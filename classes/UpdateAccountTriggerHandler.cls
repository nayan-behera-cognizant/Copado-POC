/****************************************************************************************************
* @author Cognizant Technology Solutuions
* @date 1/02/2015
* @description UpdateAccountTriggerHandler class for populating the  information on User from Account.
History
================
Version     Date            Author                  Reason
-------     ----------      ------------------      ------------------
1.0         1/02/2015       CTS                     Initial version
1.1         2/09/2016       Manjula                 Code Optimization for Ticket PD-7935
1.2         07/09/2016      Manjula                 Code Refactoring for Ticket PD-7935

******************************************************************************************************/
public class UpdateAccountTriggerHandler{
    
    public static Time startingDateTimeValue; // Added code part of the PD-10362 
    
    /******************************************************************************
@Method Name: checkIfEmailAlreadyExists
@Method Description: Method to check if the email address already exists or not
@Param: lstAccount  
******************************************************************************/
    //commented as part of PD-13612
    /*public static void checkIfEmailAlreadyExists(list<Account> lstAccount){
        String errMsg = Label.LS_MyAccount_ErrMsg_EmailIDExists;
        Set<String> emailSet = new Set<String>();
        Set<Id> accountIdSet = new Set<Id>();
        for( Account oAccount : lstAccount) {
            if(!string.isBlank(oAccount.PersonEmail)){
                emailSet.add( oAccount.PersonEmail );
                accountIdSet.add(oAccount.Id);
            }
        }
       Map<String,Id> duplicateAccountMap = new Map<String,Id>();
        // updated SOQL as part of PD-7933
        for( Account objAcc : [select Id, PersonEmail from Account where PersonEmail = :emailSet AND Id !=: accountIdSet LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())] )
            duplicateAccountMap.put(objAcc.PersonEmail ,objAcc.Id );
        for( Account oAcc : lstAccount ){
            Id duplicateAccountId = duplicateAccountMap.get(oAcc.PersonEmail);
            if( duplicateAccountId != null && duplicateAccountId != oAcc.Id)
                oAcc.addError(errMsg);
        }
    }*/
    
    /******************************************************************************
@Method Name: updateUser
@Method Description: future call to Update user personal information for the related Account
@Param: lstAccountId    
******************************************************************************/
    @future
    public static void updateUser(list<String> lstAccountId){
        /*Start PD-14478*/
        String usernameConfiguration = (DAZNConfiguration__c.getValues('LS_UserName_Configuration') != null) ? DAZNConfiguration__c.getValues('LS_UserName_Configuration').Value__c : null;
        /*End PD-14478*/
        try{            
            // updated SOQL as part of PD-7933
            Map<Id, Account> mapAccountById = new Map<Id, Account>([select id,FirstName,LastName,PersonEmail FROM Account where Id IN : lstAccountId LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())]);
            List<User> lstuser= new List<user>();
            //checking whether this object have DML permissions and checking field level security for this profile
            if(schema.SObjectType.User.isAccessible() && schema.SObjectType.User.isUpdateable() &&
               schema.SObjectType.User.fields.FirstName.isAccessible() && schema.SObjectType.User.fields.LastName.isAccessible() &&
               schema.SObjectType.User.fields.Email.isAccessible() && schema.SObjectType.User.fields.Username.isAccessible()){
                   // updated SOQL as part of PD-7933
                   for(User oUser : [SELECT id,AccountId ,Email,FirstName,LastName FROM User WHERE AccountId IN :mapAccountById.keySet() LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())])
                   {
                       if(mapAccountById.containsKey(oUser.AccountId))
                       {
                           Account oAcc = mapAccountById.get(oUser.AccountId);
                           oUser.FirstName = oAcc.FirstName;
                           oUser.LastName = oAcc.LastName;
                           oUser.Email = oAcc.PersonEmail;
                           oUser.Username= oAcc.PersonEmail+ '.' + /*Label.LS_UserName_Configuration*/usernameConfiguration;
                       }
                       lstuser.add(oUser);
                       
                   }
                   shouldIRun.stopTrigger();               
                   update lstuser;
               }else{ //if this user doest have permition to update then notify the same to system admin    
                   String strError = 'Error faced while update :'+' User Id :'+UserInfo.getUserID();
                   SendEmailWithErrorsToAdmins.sendEmail(strError);
               }
        }catch(Exception ex){ // updated SOQL as part of PD-7858
            //PD-11128-Replaced to userinfo.getUserId() from string.valueof(user.Id)
            ExceptionLoggerHelper.createExceptionLog(userinfo.getUserId(), 'UpdateAccountTrigger', 'updateUser', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            SendEmailWithErrorsToAdmins.sendEmail(ex.getMessage());
        }
        
    }
    
    /******************************************************************************
@Method Name: sendNameChangeNotification
@Method Description: Method to send email notification to user from communiticator on name update
@Param: lstAccountId    
******************************************************************************/
    //@future (callout=true)
    /* Commented out according to PD-13009:
    public static void sendNameChangeNotification(list<String> lstAccountId){
        if(lstAccountId != null && !lstAccountId.isEmpty()){            
            set<string> setCountryLangCode = new set<string>();
            List<Account> lstAccount = new List<account>();
            // updated SOQL as part of PD-7933
            for (Account oAccount : [SELECT Id, PersonContactId, PersonEmail, FirstName, LastName, Notification_Language_Code__c,
                                        Notification_Country_Code__c, Type, Partner_ID__c, Disable_transactional_emails__c
                                     FROM Account
                                     WHERE Id IN :lstAccountId LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())]) {

                if (!oAccount.Disable_transactional_emails__c) { // For PD-11577
                    lstAccount.add(oAccount);
                    setCountryLangCode.add(oAccount.Notification_Country_Code__c + '_' + oAccount.Notification_Language_Code__c);
                }
            }
            
                Map<string, List<Account>> oMapAccountNameUpdateList = new Map<string, List<Account>>();
            
                List<Account> lstAccountByCountryLang = null;
                for(String sCountryLangCode : setCountryLangCode){
                    
                    lstAccountByCountryLang = new List<Account>();                
                    for(Account oAccount:lstAccount){
                        if(sCountryLangCode == (oAccount.Notification_Country_Code__c + '_' + oAccount.Notification_Language_Code__c)){                        
                            lstAccountByCountryLang.add(oAccount);                        
                        }
                    }
                    
                    if(lstAccountByCountryLang!=null && !lstAccountByCountryLang.isEmpty()){
                        oMapAccountNameUpdateList.put(sCountryLangCode, lstAccountByCountryLang);                   
                    }
                }

            
            //if(!Test.isRunningTest()){
                //Added inspection for Turn off email PD-9179
                Boolean isSend = true;
                if (CommunityHelper.IsDfDUser()) {
                    Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
                    if (!CommunityHelper.checkSendEmailForAccount()) {
                        isSend = false;
                    }
                } 
                            
                if (isSend) {
                    if(!Test.isRunningTest()){                   
                        CommunicatorIntegrationHelper.sendUserDetailsUpdateNotification(oMapAccountNameUpdateList, 'Updated_Name');
                    }
                }
                //End PD-9179
            //}
        }
    }*/
    
    /****************************************************************************************************
    @Method Name: sendPaymentFailureNotification
    @Method Description: Method to send email notification to user from communiticator on payment failure
    @Param: lstAccountId
    ****************************************************************************************************/
    /* Commented out according to PD-12533:
    //@future (callout=true)
    public static void sendPaymentFailureNotification(list<String> lstAccountId){
        if(lstAccountId != null && !lstAccountId.isEmpty()){
            List<User> lstuser= new List<user>();
            set<string> setCountryLangCode = new set<string>();
            // updated SOQL as part of PD-7933
            for (User oUser : [SELECT id, AccountId, ContactId, Email, FirstName, LanguageLocaleKey, CountryCode,
                                   Account.Disable_Payment_failed_email__c, Account.Disable_transactional_emails__c
                               FROM User
                               WHERE AccountId IN :lstAccountId LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())]) {

                Boolean isDisableSend = oUser.Account.Disable_Payment_failed_email__c || oUser.Account.Disable_transactional_emails__c; // For PD-8928 and PD-11577
                 if (!isDisableSend) {
                    lstuser.add(oUser);
                    setCountryLangCode.add(oUser.CountryCode+'_'+oUser.LanguageLocaleKey);
                }
                
            }
            
            Map<string, List<WrapCommunicatorEmail>> oMapPaymentFailureList = new Map<string, List<WrapCommunicatorEmail>>();
            List<WrapCommunicatorEmail> lstWrapPaymentFail = null;
            WrapCommunicatorEmail oWrapPF = null;
            for(String sCountryLangCode : setCountryLangCode){
                lstWrapPaymentFail = new List<WrapCommunicatorEmail>();
                for(User oUser : lstUser){
                    if(sCountryLangCode == (oUser.CountryCode+'_'+oUser.LanguageLocaleKey)){
                        oWrapPF = new WrapCommunicatorEmail();
                        oWrapPF.Id = oUser.AccountId;
                        oWrapPF.ContactId = oUser.ContactId;
                        oWrapPF.Email = oUser.Email;
                        oWrapPF.NotificationCountryCode = oUser.CountryCode;
                        oWrapPF.NotificaitonLanguageCode = oUser.LanguageLocaleKey;
                        lstWrapPaymentFail.add(oWrapPF);
                    }
                }
                if(lstWrapPaymentFail != null && !lstWrapPaymentFail.isEmpty()){
                    oMapPaymentFailureList.put(sCountryLangCode, lstWrapPaymentFail);
                }
            }
            //if(!Test.isRunningTest()){
                //Added inspection for Turn off email PD-9179
                Boolean isSend = true;
                if (CommunityHelper.IsDfDUser()) {
                    Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
                    if (!CommunityHelper.checkSendEmailForAccount() && String.isBlank(pac.Change_password_email__c)) {
                        isSend = false;
                    }
                } 
                            
                if (isSend) {
                    if(!Test.isRunningTest()){
                        CommunicatorIntegrationHelper.sendPaymentFailureNotification(oMapPaymentFailureList);
                    }
                }
                //End PD-9179
            //}
        }
    }*/
    
    /***********************************************************************************************
@Method Name: createHardOfferWelcomeEmailQueueRecords
@Method Description: Method creates Email Sync Queue recors for further send email notification to user from communiticator on hard offer
@Param: lstAccountId
************************************************************************************************/
    public static void createHardOfferWelcomeEmailQueueRecords(List<String> lstAccountId) {
        if (lstAccountId != null && !lstAccountId.isEmpty()) {
            List<Zuora__CustomerAccount__c> lstBA =  [
                SELECT Id, Zuora__PaymentMethod_Type__c, Zuora__Currency__c, Zuora__Account__c,
                    Zuora__Account__r.PersonEmail, Zuora__Account__r.PersonContactId, Zuora__Account__r.Is_Double_OptIn__c,
                    Zuora__Account__r.All_Email_Preferences__c, Zuora__Account__r.LastName, Zuora__Account__r.Hard_Offer_date__c,
                    Zuora__Account__r.FirstName, Zuora__Account__r.Notification_Language_Code__c,
                    Zuora__Account__r.Account_Status__c, Zuora__Account__r.Notification_Country_Code__c
                FROM Zuora__CustomerAccount__c
                WHERE Zuora__Account__c IN :lstAccountId
                ORDER BY CreatedDate DESC NULLS LAST
            ];

            List<Email_Sync_Queue__c> emailSyncQueueList = new List<Email_Sync_Queue__c>();
            Map<Id, String> accountIdSubscriptionIdMap = new Map<Id, String>();
            Set<Id> utilizedAccountIds = new Set<Id>();
            for (Zuora__CustomerAccount__c bAccount : lstBA) {
                if (!utilizedAccountIds.contains(bAccount.Zuora__Account__c)) {
                    Date hardOfferDate;
                    if (bAccount.Zuora__Account__r.Hard_Offer_Date__c != null) {
                        DateTime hardOfferDateTmp = bAccount.Zuora__Account__r.Hard_Offer_Date__c;
                        hardOfferDate = Date.newInstance(hardOfferDateTmp.year(), hardOfferDateTmp.month(), hardOfferDateTmp.day());
                    }
                    //set hard offer date to current date
                    Email_Sync_Queue__c triggeredDispatchEmailQueue = new Email_Sync_Queue__c(
                        Account__c = bAccount.Zuora__Account__c,
                        Account_Currency__c = bAccount.Zuora__Currency__c,
                        Account_Status__c = 'Active Paid',
                        All_Email_Preferences__c = bAccount.Zuora__Account__r.All_Email_Preferences__c,
                        First_Name__c = bAccount.Zuora__Account__r.FirstName,
                        Last_Name__c = bAccount.Zuora__Account__r.LastName,
                        Free_Trial_End_Date__c = null,
                        Hard_Offer_Date__c = hardOfferDate,
                        Is_Double_Opt_in__c = bAccount.Zuora__Account__r.Is_Double_OptIn__c,
                        Notification_Country_Code__c = bAccount.Zuora__Account__r.Notification_Country_Code__c,
                        Notification_Language_Code__c = bAccount.Zuora__Account__r.Notification_Language_Code__c,
                        Payment_Method_Type__c = bAccount.Zuora__PaymentMethod_Type__c,
                        Person_Email__c = bAccount.Zuora__Account__r.PersonEmail,
                        Plan_Details__c = 'Active Paid',
                        Status__c = 'Not Started',
                        Subscription_Amount__c = null,
                        Subscription_End_Date__c = null,
                        Sync_Error_Msg__c = null,
                        Type_of_Email__c = 'Triggered Dispatch',
                        Unsubscribe_Language__c = bAccount.Zuora__Account__r.Notification_Language_Code__c,
                        Email_Name__c = 'Hard Offer Welcome'
                    );
                    emailSyncQueueList.add(triggeredDispatchEmailQueue);
                    utilizedAccountIds.add(bAccount.Zuora__Account__c);
                }
            }
            insert emailSyncQueueList;
        }
    }
    
    /***********************************************************************************************
     @Method Name: createUpdateNameEmailQueueRecords
     @Method Description: Method creates Email Sync Queue recors for further send email notification to user from communiticator on Name Update
     @Param: lstAccountId
    ************************************************************************************************/
    public static void createUpdateNameEmailQueueRecords(List<Account> accounts) {
        Boolean isInsertEmailSyncQueue = true;
        List<Email_Sync_Queue__c> emailSyncQueueList = new List<Email_Sync_Queue__c>();
        if (accounts != null && !accounts.isEmpty()) {
            for (Account account : accounts) {
                if (!account.Disable_transactional_emails__c) {
                    Email_Sync_Queue__c triggeredDispatchEmailQueue = new Email_Sync_Queue__c(
                        Account__c = account.Id,
                        Account_Status__c = account.Account_Status__c,
                        All_Email_Preferences__c = account.All_Email_Preferences__c,
                        First_Name__c = account.FirstName,
                        Last_Name__c = account.LastName,
                        Is_Double_Opt_in__c = account.Is_Double_OptIn__c,
                        Notification_Country_Code__c = account.Notification_Country_Code__c,
                        Notification_Language_Code__c = account.Notification_Language_Code__c,
                        Person_Email__c = account.PersonEmail,
                        Plan_Details__c = account.Account_Status__c,
                        Status__c = 'Not Started',
                        Type_of_Email__c = 'Triggered Dispatch',
                        Unsubscribe_Language__c = account.Notification_Language_Code__c,
                        Email_Name__c = 'Update Name',
                        Dispatch_ID__c = (!Test.isRunningTest()) ? Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Updated_Name').Value__c) : 12340,
                        Subscription_Amount__c = null,
                        Subscription_End_Date__c = null,
                        Sync_Error_Msg__c = null
                    );
                    emailSyncQueueList.add(triggeredDispatchEmailQueue);
                }
            }
            /* Commented out because Disable_transactional_emails__c has the next formula OR(ISPICKVAL(Type, 'Docomo'),ISPICKVAL(Type, 'Do not contact'))
             So if Account is Docomo it will always have Disable_transactional_emails__c as "true".
             So the below check is not needed until Disable_transactional_emails__c has Docomo check mentioned above
            if (CommunityHelper.IsDfDUser()) {
                if (!CommunityHelper.checkSendEmailForAccount()) {
                    isInsertEmailSyncQueue = false;
                }
            }*/
            if (isInsertEmailSyncQueue) {
                insert emailSyncQueueList;
            }
            
        }
    }
    
    /************************************************************************************************
    @Method Name: sendDoubleOptInNotification
    @Method Description: Method to send email notification to user from communiticator on name update
    @Param: lstAccountId    
    *************************************************************************************************/
    //@future (callout=true)
    /* Commented out according to PD-11495:
    public static void sendDoubleOptInNotification(list<String> lstAccountId){
        if(lstAccountId != null && !lstAccountId.isEmpty()){            
            // Get double optin countries information from custom setting and prepare a list.
            DAZNConfiguration__c oDoubleOptinConfig = DAZNConfiguration__c.getValues('DoubleOptInCountries');            
            if(oDoubleOptinConfig != null){                
                string sCountries = oDoubleOptinConfig.value__c;                           
                List<String> lstCountry = sCountries.split(',');                
                // Prepare set of user and language set.
                List<User> lstuser= new List<user>();
                set<string> setCountryLangCode = new set<string>();                 
                // updated SOQL as part of PD-7933
                for (User oUser : [SELECT id, AccountId, ContactId, Email, LanguageLocaleKey, CountryCode, Account.Disable_transactional_emails__c
                                   FROM User
                                   WHERE AccountId IN :lstAccountId
                                       AND Country IN :lstCountry LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())]) {

                    if (!oUser.Account.Disable_transactional_emails__c) { // For PD-11577
                        lstuser.add(oUser);
                        setCountryLangCode.add(oUser.CountryCode + '_' + oUser.LanguageLocaleKey);
                    }
                }               
                Map<string, List<User>> oMapDoubleOptInUser = new Map<string, List<User>>();
                List<User> lstUserByLang = null;
                for(String sCountryLangCode : setCountryLangCode){
                    lstUserByLang = new List<User>();
                    for(User oUser : lstUser){
                        if(sCountryLangCode == (oUser.CountryCode+'_'+oUser.LanguageLocaleKey)){
                            lstUserByLang.add(oUser);
                        }
                    }                    
                    if(lstUserByLang != null && !lstUserByLang.isEmpty()){
                        oMapDoubleOptInUser.put(sCountryLangCode, lstUserByLang);
                    }                    
                }
                //if(!Test.isRunningTest()){
                    //Added inspection for Turn off email PD-9179
                    Boolean isSend = true;
                    if (CommunityHelper.IsDfDUser()) {
                        Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
                        if (!CommunityHelper.checkSendEmailForAccount() && String.isBlank(pac.Change_password_email__c)) {
                            isSend = false;
                        }
                    } 
                            
                    if (isSend) {
                        if(!Test.isRunningTest()){
                            CommunicatorIntegrationHelper.sendDoubleOptInEmail(oMapDoubleOptInUser);
                        }
                    }
                    //End PD-9179
                //}
            }
        }
    }*/
    
    /*******************************************************
    @Method Name: setAccountForSyncWithZuora
    @Method Description: Method to set a true for zuora sync
    @Param: oldAccounts 
    @Param: newAccounts 
    ********************************************************/
    public static void setAccountForSyncWithZuora(Map<id,Account> oldAccounts, Map<Id,Account> newAccounts){
        
        for (Account account: newAccounts.values()){
            Account previousVAccount = oldAccounts.get(account.Id);
            
            if( (previousVAccount.TestUser__c == True && account.TestUser__c == False)){
                account.Account_Status__c= Label.LS_ACC_STATUS;
                
            }
            
            if( (previousVAccount.TestUser__c == False && account.TestUser__c == True && account.Account_Status__c == Label.LS_ACC_STATUS)){
                account.addError('You cant Activate it . The status is in Frozen');
            }
            
            if(previousVAccount.PersonEmail != account.PersonEmail || previousVAccount.FirstName != account.FirstName 
               || previousVAccount.LastName != account.LastName || previousVAccount.Account_Status__c != account.Account_Status__c ){
                   account.IsReadyToSyncInZuora__c = True;
                   // added as part of PD-7935
                   account.IsReadyToSyncInCommunicator__c = true;
               }
        }
    }    
    
    /**********************************************************
    @Method Name: callAsyncForAccount
    @Method Description: Future Method to prepare Account records and
    to call callAsyncForAccount method
    @Param: lstAccountId
    @Param: lstAccountIdForNameChange
    //@Param: lstAccountIdForSuccessPayment
    //@Param: lstAccountIdForPaymentFailure
    //@Param: lstAccountIdForDoubleOptInEmail 
    ***********************************************************/
    /* Commented out according to PD-13009:
    @future (callout=true)
    public static void callAsyncForAccount(List<String> lstAccountId, List<String> lstAccountIdForNameChange
                                           //,List<String> lstAccountIdForSuccessPayment - Commented out according to PD-12615
                                           //,List<String> lstAccountIdForPaymentFailure - Commented out according to PD-12533
                                           //,List<String> lstAccountIdForDoubleOptInEmail - Commented out according to PD-11495
                                           ){
                                               
                                               
                                               // Commented out according to PD-13009:
                                               if(lstAccountIdForNameChange!= null && !lstAccountIdForNameChange.isEmpty())
                                                   UpdateAccountTriggerHandler.sendNameChangeNotification(lstAccountIdForNameChange);  
                                               // Commented out according to PD-12615:
                                               if(lstAccountIdForSuccessPayment!= null && !lstAccountIdForSuccessPayment.isEmpty()) 
                                                   UpdateAccountTriggerHandler.sendPaymentSuccessAfterFailureNotification(lstAccountIdForSuccessPayment);
                                               // Commented out according to PD-12533:
                                               if(lstAccountIdForPaymentFailure!=null && !lstAccountIdForPaymentFailure.isEmpty())
                                                   UpdateAccountTriggerHandler.sendPaymentFailureNotification(lstAccountIdForPaymentFailure);
                                               // Commented out according to PD-11495:
                                               if(lstAccountIdForDoubleOptInEmail!=null && !lstAccountIdForDoubleOptInEmail.isEmpty())
                                                   UpdateAccountTriggerHandler.sendDoubleOptInNotification(lstAccountIdForDoubleOptInEmail);
    }*/
    
    /**********************************************************
    @Method Name: setAccountAfterUpdate
    @Method Description: Method to prepare Account records after Update 
    Added as part of PD-7935
    @Param: oldAccounts
    @Param: newAccounts
    ***********************************************************/
    public static void setAccountAfterUpdate(Map<Id,Account> oldAccounts, Map<Id,Account> newAccounts) {
        list<String> lstAccountId = new list<String>();
        List<Account> accountsWithUpdatedName = new List<Account>();
        //list<String> lstAccountIdForNameChange = new list<String>(); Commented out according to PD-13009
        //list<String> lstAccountIdForSuccessPayment = new list<String>(); Commented out according to PD-12615
        //list<String> lstAccountIdForPaymentFailure = new list<String>(); Commented out according to PD-12533
        //list<String> lstAccountIdForDoubleOptInEmail = new list<String>(); Commented out according to PD-11495
        List<id> ids = new List<id>();
        Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
        if (newAccounts.values() != null && newAccounts.values().size()>0){
            for (account oAcc : newAccounts.values()) {
                
                Account oldAccValues = oldAccounts.get(oAcc.Id);
                if(oldAccValues.FirstName != oAcc.FirstName || oldAccValues.LastName != oAcc.LastName  || 
                   oldAccValues.PersonEmail != oAcc.PersonEmail) {
                    lstAccountId.add(oAcc.Id);
                }
                    
                if((oldAccValues.FirstName != oAcc.FirstName || oldAccValues.LastName != oAcc.LastName) && (!oAcc.FirstName.contains('anonymous'))) {
                    accountsWithUpdatedName.add(oAcc);
                    /* Commented out according to PD-13009:
                    //PD-9179
                    if (!String.isBlank(oAcc.Type) && !String.isBlank(pac.Partner_Type__c) && oAcc.Type.equals(pac.Partner_Type__c)) {
                        if (!oAcc.Disable_all_transactional_emails__c && !String.isBlank(pac.Name_change_email__c)) {
                            lstAccountIdForNameChange.add(oAcc.Id);
                            
                        }
                    } else {
                        lstAccountIdForNameChange.add(oAcc.Id);
                    }*/
                }
                
                /* Commented out according to PD-12615:
                if((oldAccValues.Account_Status__c == 'Active Grace' || oldAccValues.Account_Status__c == 'Free Trial')  && oAcc.Account_Status__c == 'Active Paid') {
                    //PD-9179
                    if (!String.isBlank(oAcc.Type) && !String.isBlank(pac.Partner_Type__c) && oAcc.Type.equals(pac.Partner_Type__c) && (!oAcc.Disable_all_transactional_emails__c && !String.isBlank(pac.Payment_success_email__c))) {
                        lstAccountIdForSuccessPayment.add(oAcc.Id);
                    } else {
                        lstAccountIdForSuccessPayment.add(oAcc.Id);
                    }
                    
                }*/
                
                /* Commented out according to PD-12533:
                if((oldAccValues.Account_Status__c == 'Free Trial' || oldAccValues.Account_Status__c == 'Active Paid') && oAcc.Account_Status__c == 'Active Grace') {
                    //PD-9179
                    if (!String.isBlank(oAcc.Type) && !String.isBlank(pac.Partner_Type__c) && oAcc.Type.equals(pac.Partner_Type__c) && (!oAcc.Disable_all_transactional_emails__c && !String.isBlank(pac.Payment_failure_email__c))) {
                        lstAccountIdForPaymentFailure.add(oAcc.Id);
                    } else {
                        lstAccountIdForPaymentFailure.add(oAcc.Id);
                    }
                    
                }*/
                
                /* Commented out according to PD-11495:
                if(oldAccValues.All_Email_Preferences__c == false && oAcc.All_Email_Preferences__c == true) {
                    
                    if (!String.isBlank(oAcc.Type) && !String.isBlank(pac.Partner_Type__c) && oAcc.Type.equals(pac.Partner_Type__c) && (!oAcc.Disable_all_transactional_emails__c && !String.isBlank(pac.Double_opt_in_email__c))) {
                        lstAccountIdForDoubleOptInEmail.add(oAcc.Id);
                    } else {
                        lstAccountIdForDoubleOptInEmail.add(oAcc.Id);
                    }
                    
                }*/
                
                if(oAcc.TestUser__c ==True)
                    ids.add(oAcc.id);  
            }
            
        }
      
        
        if(!System.isBatch() && !System.isFuture() && !(lstAccountId.isEmpty() /*&& lstAccountIdForNameChange.isEmpty() && lstAccountIdForSuccessPayment.isEmpty() && lstAccountIdForPaymentFailure.isEmpty() && lstAccountIdForDoubleOptInEmail.isEmpty() - for PD-11495, PD-12533. PD-12615, PD-13009 */))
        {
            
            if(!lstAccountId.isEmpty())
                
                updateUser(lstAccountId);
                /* Commented out according to PD-13009:*/
                //callAsyncForAccount(new List<String>(),lstAccountIdForNameChange/*,lstAccountIdForSuccessPayment,lstAccountIdForPaymentFailure,lstAccountIdForDoubleOptInEmail - for PD-11495, PD-12533, PD-12615*/);
        }
        
        if (!ids.isEmpty()) {
            CommunityHelper.callFutureOrNot(ids); 
        }
        createUpdateNameEmailQueueRecords(accountsWithUpdatedName); // /PD-13009: create email sync queue record for Name Update 
    }
    
    
     /*Added as a part of PD-11487*/
    // Update AuthKey__c
    public static void authKeyUpdate(List<Account> listFrozenAccounts){
        if(listFrozenAccounts!=null && !listFrozenAccounts.isEmpty()){
            for (Account acc : listFrozenAccounts){
                acc.AuthKey__c = System.now();
            } 
        }
    } //End of AuthKey__c Update
        
    
    /*PD-8834-Sign out of all devices on Docomo Cancellation
    Updated Task,Update AuthKey__c,delete AuthSession for the PD-11487. */
      public static void deleteUseDevicesWhenStatusFrozen(List<Id> listAccountFrozen){    
        list<User> lstUser = [Select id,Accountid,ContactID from user where Accountid IN : listAccountFrozen LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())];
        List<User_Devices__c> lstUserDevices = [SELECT Id, Account__c FROM User_Devices__c WHERE Account__c IN : listAccountFrozen];
        List<Task> signOutTask = new List<Task>();
        List<Account> UpdateAuthKey = new List<Account>();
        // Existing Code for delete UserDevices
        if(lstUserDevices != null && lstUserDevices.size() > 0){
                Database.DeleteResult[] srDeleteList = Database.delete(lstUserDevices,False); 
                for(Database.DeleteResult sr : srDeleteList){
                    if(!sr.isSuccess()){
                        for(Database.Error err : sr.getErrors()) {
                           SendEmailWithErrorsToAdmins.sendEmail(err.getMessage());  
                        }
                    } else {
                      // Operation Is successful  
                    }
                }
            }
          // Task create
         if(lstUser!=null && !lstUser.isEmpty()){
             for (User ousr : lstUser){
                Task TaskLists = new Task();
                TaskLists.WhoId = ousr.contactId;
                TaskLists.WhatId = ousr.accountId;
                TaskLists.priority = 'High';
                TaskLists.status = 'Completed';
                TaskLists.Subject = System.Label.LS_SignOutDevice_TaskSubject;
                TaskLists.description = System.Label.LS_SignOutDevice_TaskDesc;
                TaskLists.ActivityDate = Date.today();
                signOutTask.add(TaskLists);
            }
         }
        // Update AuthKey__c
         /* if(listAccountFrozen!=null && !listAccountFrozen.isEmpty()){
              for (id Accid : listAccountFrozen){
              Account updatesignoutkey = new Account();
              updatesignoutkey.Id = Accid;
              updatesignoutkey.AuthKey__c = System.now();
              UpdateAuthKey.add(updatesignoutkey);
              } 
                        
            }*/
              CommunityHelper.firstRun = false;
            //if(UpdateAuthKey!=null && !UpdateAuthKey.isEmpty()){update UpdateAuthKey;}
           
            if(signOutTask!=null && !signOutTask.isEmpty()){insert signOutTask;}
       //end Update AuthKey__c
       //delete AuthSession
            authSessionDeletion(JSON.serialize(lstUser));
     }
	 
	 @future
	 public static void authSessionDeletion(String lstUsers){
         try{
         List<AuthSession> lstActiveUserSessions = new List<AuthSession>();
         list<User> lstUser = (List<User>)JSON.deserialize(lstUsers,List<User>.class);
	   if(lstUser!=null && !lstUser.isEmpty()){
            for (AuthSession oAut : [Select ID From AuthSession Where UsersId in: lstUser]){
                    lstActiveUserSessions.add(oAut);
            }
            if(lstActiveUserSessions!=null && !lstActiveUserSessions.isEmpty()){
                 //delete(lstActiveUserSessions);
                Database.delete(lstActiveUserSessions);
            }
        }
         } catch(Exception ex) {
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'UpdateAccountTriggerHandler', 'AuthSessionDeletion', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
             } //Added try catch block as part of PD-16032
	 }
    //End of PD-8834       
       
    //PD-8706 Send Welcome Back email via Communicator   
    public static void accountStatusFrozentoActivepaidUpdate(List<Account> accList){  
        if(accList!=null && accList.size()>0){
            for(Account acc :accList){
                acc.Hard_Offer_date__c = System.now();
                //acc.IsReadyToSyncInCommunicator__c = true;
            }
        }
    }
    //End PD-8706 Send Welcome Back email via Communicator
    
    //PD-10145
    /*public static void validateAccountName(Map<Id, Account> accounts, Map<Id, Account> oldAccounts)
    {
        String errMsg = System.Label.LS_AccountValidation_ErrMsg;

        if(oldAccounts != null) {
            for(Id accountId : accounts.keySet() ) 
            {
                Account account = accounts.get(accountId);
                String accountName = '';
                if(account.FirstName != null){
                    accountName += account.FirstName;
                }
                 if(account.LastName != null){
                    accountName += account.LastName;
                }    

                String oldAccountName = '';
                Account oldAccount = oldAccounts.get(accountId);
                if(oldAccount.FirstName != null){
                    oldAccountName += oldAccount.FirstName;
                }
                 if(oldAccount.LastName != null){
                    oldAccountName += oldAccount.LastName;
                }  

                if(oldAccountName != accountName){
                    if(!validateName(accountName)){
                        account.addError(errMsg);
                    }
                }
            }
        }
        else{
            validateAccountName(oldAccounts.values());
        }
    }*/

    /*public static void validateAccountName(List<Account> accounts)
    {
        String errMsg = System.Label.LS_AccountValidation_ErrMsg;
        for(Account account : accounts){
            if(account.FirstName != null){
                if(!validateName(account.FirstName)){
                    account.addError(errMsg);
                }
            }

            if(account.LastName != null){
                if(!validateName(account.LastName)){
                    account.addError(errMsg);
                }
            }
        }
    }
    
    private static Boolean validateName(String name){
        //Pattern myPattern = Pattern.compile('[^0-9._|\\\\%#~`=?&/$^*!\\/}{+-]+');
        Pattern myPattern = Pattern.compile('(?i)^[a-z\'.\\-\u3000-\u303F\u3040-\u309F\u30A0-\u30FF\uFF00-\uFFEF\u4E00-\u9FAF\u2605-\u2606\u2190-\u2195\u203B]+(\\s+[a-z\u3000-\u303F\u3040-\u309F\u30A0-\u30FF\uFF00-\uFFEF\u4E00-\u9FAF\u2605-\u2606\u2190-\u2195\u203B\'.\\-]+)*$');
        Matcher myMatcher = myPattern.matcher(name);
        return Test.isRunningTest() ? true : myMatcher.matches();
    }*/
    
    // Added code part of the PD-10362
    public static void toSetTheStartDateTime()
    {
       startingDateTimeValue = system.now().time(); 
    }
   

    /*Add code as part of the PD-9770*/
    public static boolean run = true;
    
    public static boolean runOnce() {
        if(run) {
            run=false;
            return true;
        } else{
            return run;
        }
    }
    
    
    /*Start part of PD-14478*/
    public static String getRecordTypeId(String recordTypeName, String obj) {
        String recordTypeId = '';
        String qr = 'SELECT Id FROM RecordType WHERE SobjectType = ' + '\'' + obj + '\'' + ' AND ' + ' DeveloperName = ' + '\'' + recordTypeName + '\'' + ' LIMIT 1';
        List<RecordType> types = Database.query(qr);
        if (!types.isEmpty()) {
            recordTypeId = types[0].Id;
        }
        return recordTypeId;
    }
    /*End part of PD-14478*/
    
    /*Added code as part of the PD-11936*/
    public static void accountFreeTrialStartDateUpdate(List<Account> accList) {
        if (accList != null && accList.size() > 0) {
            for (Account acc : accList) {
                acc.Free_Trial_Start_Date__c = System.now().date();
            }
        }
    }
     /*Ended code as part of the PD-11936*/
    
    /*Added code as part of the PD-11495*/
    public static void createEmailSyncQueueRecords(Map<Id, Account> mapOfOldAccValues, Map<Id, Account> mapOfNewAccValues){
        List<Account> listOfAccountsUpdate = new List<Account>();
        Account accOld = new Account();
        Account accNew = new Account();
        if (mapOfOldAccValues != null && mapOfNewAccValues!= null) {
            List<Email_Sync_Queue__c> emailSyncQueueList = new List<Email_Sync_Queue__c>();
            for (Id newAccId : mapOfNewAccValues.keySet()) {
                accOld = mapOfOldAccValues.get(newAccId);
                accNew = mapOfNewAccValues.get(newAccId);
                if (accOld != null && accNew != null &&
                    (( accOld.Notification_Language_Code__c != null && accNew.Notification_Language_Code__c != null && accOld.Notification_Language_Code__c != accNew.Notification_Language_Code__c)
                     ||( accOld.Account_Status__c != null && accNew.Account_Status__c != null && accOld.Account_Status__c != accNew.Account_Status__c)
                     ||(accOld.Notification_Country_Code__c != null && accNew.Notification_Country_Code__c != null && accOld.Notification_Country_Code__c != accNew.Notification_Country_Code__c)
                     ||( accOld.personemail != null && accNew.personemail != null && accOld.personemail != accNew.personemail)
                     ||( accOld.All_Email_Preferences__c != null && accNew.All_Email_Preferences__c != null && accOld.All_Email_Preferences__c != accNew.All_Email_Preferences__c)
                     ||(accOld.Is_Double_OptIn__c != null && accNew.Is_Double_OptIn__c != null && accOld.Is_Double_OptIn__c != accNew.Is_Double_OptIn__c)
                     ||(accOld.FirstName != null && accNew.FirstName != null && accOld.FirstName != accNew.FirstName)
                     ||(accOld.LastName != null && accNew.LastName!= null && accOld.LastName != accNew.LastName)
                   )) {
                       Email_Sync_Queue__c emailSyncQueue = new Email_Sync_Queue__c(
                           Account__c = accNew.Id,
                           Account_Status__c = accNew.Account_Status__c,
                           Notification_Language_Code__c = accNew.Notification_Language_Code__c,
                           Person_Email__c = accNew.PersonEmail,
                           First_Name__c = accNew.FirstName,
                           Last_Name__c = accNew.LastName,
                           Notification_Country_Code__c = accNew.Notification_Country_Code__c,
                           Unsubscribe_Language__c = accNew.Notification_Language_Code__c,
                           Plan_Details__c = accNew.Account_Status__c,
                           Type_of_Email__c = 'Data Import',
                           Status__c = 'Not Started',
                           All_Email_Preferences__c = accNew.All_Email_Preferences__c,
                           Is_Double_Opt_in__c = accNew.Is_Double_OptIn__c
                       );
                       emailSyncQueueList.add(emailSyncQueue);
                }
                if ((accOld.All_Email_Preferences__c != null && accNew.All_Email_Preferences__c != null && accOld.All_Email_Preferences__c == false && accNew.All_Email_Preferences__c == true) &&
                   (accNew.Notification_Country_Code__c != null && accNew.Notification_Country_Code__c == 'DE') && !accNew.Disable_transactional_emails__c
                ) {
                    Email_Sync_Queue__c triggeredDispatchEmailQueue = new Email_Sync_Queue__c(
                        Account__c = accNew.Id,
                        Account_Status__c = accNew.Account_Status__c,
                        Notification_Language_Code__c = accNew.Notification_Language_Code__c,
                        Person_Email__c = accNew.PersonEmail,
                        First_Name__c = accNew.FirstName,
                        Last_Name__c = accNew.LastName,
                        Notification_Country_Code__c = accNew.Notification_Country_Code__c,
                        Status__c = 'Not Started',
                        All_Email_Preferences__c = true,
                        Is_Double_Opt_in__c = false,
                        Type_of_Email__c = 'Triggered Dispatch',
                        Dispatch_ID__c = (!Test.isRunningTest()) ? Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID Double optin').Value__c) : 12345,
                        Email_Name__c = 'Double opt in'
                    );
                    emailSyncQueueList.add(triggeredDispatchEmailQueue);
                }
            }
            insert emailSyncQueueList;
        }
    }
    /*Ended code as part of the PD-11495*/

    //added as part of PD-13612
    public static void populateUniqueEmail(List<Account> lstAccount) {
        for (Account acc : lstAccount) {
            if (String.isBlank(acc.Type) || !acc.Type.equalsIgnoreCase('Docomo')) {
                acc.UniqueEmail__c = acc.PersonEmail;
            }
        }
    }
}