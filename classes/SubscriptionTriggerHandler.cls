/**
* @author Cognizant Technology Solutuions
* @date 06/04/2016
* @description SubscriptionTriggerHandler class.
* 1. Send email to user on subscription.
* 2. Update Account with subscription information (Next Charget Date, Subscription Date)
* 3. Update Account Cancelled checkbox on subscription cancellation.
*/
public class SubscriptionTriggerHandler{
    
    /*
     * Description: Update Account with Subscription next charge date and subscription date.
     */
    
    public void UpdateSubscriptionInfoOnAccount(List<Zuora__Subscription__c> lstSubscription) {
        
        //********Introducing Try and Catch as per PD7859****************
        
        try {
        Map<String,Account> mapAccountForQuery = new Map<String, Account>();
        Map<String,Account> mapAccount = new Map<String, Account>();
        Map<String,Zuora__Subscription__c> mapActiveSubscriptions = new Map<String, Zuora__Subscription__c>();
        Account oAccount = null;
        List<Database.SaveResult> accountUpdateResults ;
        //get list of account Ids 
        for (Zuora__Subscription__c oSubscription : lstSubscription){
            mapAccountForQuery.put(oSubscription.Zuora__Account__c, null);
        }
        
        //figure out if any account already has an active subscription 
        List<Zuora__Subscription__c> subscriptiondetails = [Select Zuora__Account__c, Zuora__Status__c, ID, Zuora__SubscriptionStartDate__c, Zuora__NextChargeDate__c from Zuora__Subscription__c where 
                                                            Zuora__Account__c in :mapAccountForQuery.keySet() and Zuora__Status__c = 'Active'];
        
        
        if(subscriptiondetails!= null && !subscriptiondetails.isEmpty()){
            for(Zuora__Subscription__c zSubscription : subscriptiondetails){
                mapActiveSubscriptions.put(zSubscription.Zuora__Account__c,zSubscription);
            }
        }
        
        
        //if account has an Active subscription then the cancelled subscription in the current batch should be ignored
        for(Zuora__Subscription__c oSubscription: lstSubscription){
            if(!mapActiveSubscriptions.isEmpty() && mapActiveSubscriptions.containsKey(oSubscription.Zuora__Account__c) 
               && ((mapActiveSubscriptions.get(oSubscription.Zuora__Account__c)).ID) == oSubscription.ID){
                   oAccount = new Account();
                   oSubscription = mapActiveSubscriptions.get(oSubscription.Zuora__Account__c);
                   oAccount.Id = oSubscription.Zuora__Account__c;
                   //oAccount.Next_Charge_Date__c = oSubscription.Zuora__NextChargeDate__c; // commented out according to PD-15332
                   oAccount.Subscription_Date__c = oSubscription.Zuora__SubscriptionStartDate__c;
                   oAccount.Cancelled_Account__c = false;
                   mapAccount.put(oAccount.Id, oAccount);
               } else if(mapActiveSubscriptions.isEmpty() || (!mapActiveSubscriptions.isEmpty() && !mapActiveSubscriptions.containsKey(oSubscription.Zuora__Account__c))){
                   oAccount = new Account();
                   oAccount.Id = oSubscription.Zuora__Account__c;
                   //oAccount.Next_Charge_Date__c = (oSubscription.Zuora__Status__c == 'Active'? oSubscription.Zuora__NextChargeDate__c:oSubscription.Zuora__TermEndDate__c); // commented out according to PD-15332
                   oAccount.Subscription_Date__c = oSubscription.Zuora__SubscriptionStartDate__c;
                   oAccount.Cancelled_Account__c = (oSubscription.Zuora__Status__c == 'Active'? false:true);
                   mapAccount.put(oAccount.Id, oAccount);
               }
            
        }   
        
        if(!mapAccount.isEmpty()){
            
            update mapAccount.values();
        }
        }catch(Exception ex){
            // TO-DO: this an old code will need to be deleted - temporarily commented out PD-11052 changes
            //PD-11052-Replaced to userinfo.getUserId() from string.valueof(user.Id)
            /*ExceptionLoggerHelper.createExceptionLog(userinfo.getUserId(), 'UpdateSubscriptionInfoOnAccount', 'updateAccount', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());*/
            SendEmailWithErrorsToAdmins.sendEmail(ex.getMessage());
        }
        
    }
    
    /* Commented out according to PD-11495:
    //added method for PD-9770 Live- Improvement in Sign-up Service
    @future (callout=true)
    public static void sendDoubleOptinmailNotification(list<String> lstAccountId){                     
        List<String> lstCountry = new List<String>();        
        DAZNConfiguration__c oDoubleOptinConfig = DAZNConfiguration__c.getValues('DoubleOptInCountries');
        if(oDoubleOptinConfig != null){
            string sCountries = oDoubleOptinConfig.value__c; 
            lstCountry = sCountries.split(',');
        }
        List<User> lstuser= new List<user>();
        set<string> setCountryLangCode = new set<string>(); 
        for(User oUser : [SELECT id, AccountId, ContactId, Email, LanguageLocaleKey, CountryCode FROM User WHERE AccountId IN :lstAccountId
                                  and Country IN : lstCountry LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())]){                
            lstuser.add(oUser);
            setCountryLangCode.add(oUser.CountryCode+'_'+oUser.LanguageLocaleKey);
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
        if(!Test.isRunningTest()){            
            CommunicatorIntegrationHelper.sendDoubleOptInEmail(oMapDoubleOptInUser);
        }
    }
    //End PD-9770 Live- Improvement in Sign-up Service
    */

    /***************************************************************************
     Method:  createWelcomeEmailSyncQueueRecords 
     Details: changes for zuora subscription as per PD-11936
    *****************************************************************************/
     public static void createWelcomeEmailSyncQueueRecords(Map<Id, Zuora__Subscription__c> mapSub) {
        
        if (mapSub.values() != null && mapSub.values().size() > 0) {
            Map<Id, Zuora__Subscription__c> subscriptionMap = new Map<Id, Zuora__Subscription__c>([
                SELECT Id,
                    SourceSystem__c,
                    NumFreeTrialPeriods__c,
                    NumGiftPeriods__c,
                    SubscriptionAmount__c,
                    Zuora__TermSettingType__c,
                    Zuora__SubscriptionStartDate__c,
                    Zuora__SubscriptionEndDate__c,
                    Zuora__Account__c,
                    Gift_Code_End_Date__c,
                    Free_Trial_End_Date__c,
                    Zuora__NextChargeDate__c,
                    CreatedDate,
                    Zuora__CustomerAccount__c,
                    Zuora__CustomerAccount__r.Zuora__Currency__c,
                    Zuora__CustomerAccount__r.Zuora__PaymentMethod_Type__c,
                    Zuora__Account__r.Account_Status__c,
                    Zuora__Account__r.All_Email_Preferences__c,
                    Zuora__Account__r.FirstName,
                    Zuora__Account__r.LastName,
                    Zuora__Account__r.Is_Double_OptIn__c,
                    Zuora__Account__r.Notification_Country_Code__c,
                    Zuora__Account__r.Notification_Language_Code__c,
                    Zuora__Account__r.PersonEmail,
                    Zuora__Account__r.Free_Trial_Start_Date__c,
                    Zuora__Account__r.Disable_transactional_emails__c,
                    Zuora__Account__r.Disable_all_transactional_emails__c,
                    Zuora__Account__r.Disable_Welcome_emails__c
                FROM Zuora__Subscription__c
                WHERE Id IN :mapSub.keySet()
                    AND Zuora__Status__c = 'Active'
            ]);
            List<Email_Sync_Queue__c> welcomeEmailSyncQueues = new List<Email_Sync_Queue__c>();
            for (Zuora__Subscription__c oSubscription : subscriptionMap.values()) {
                if (oSubscription.Zuora__Account__c != null && oSubscription.Zuora__CustomerAccount__c != null) {
                    Boolean isStartDatesAndStatusSuitable = (
                        (oSubscription.Zuora__SubscriptionStartDate__c != null && oSubscription.Zuora__Account__r.Free_Trial_Start_Date__c != null) &&
                        (oSubscription.Zuora__SubscriptionStartDate__c == oSubscription.Zuora__Account__r.Free_Trial_Start_Date__c ||
                            oSubscription.Zuora__SubscriptionStartDate__c == oSubscription.Zuora__Account__r.Free_Trial_Start_Date__c.addDays(1)
                        ) &&
                        (oSubscription.Zuora__Account__r.Account_Status__c == 'Partial' || oSubscription.Zuora__Account__r.Account_Status__c == 'Free Trial')
                        &&
                        (oSubscription.Zuora__SubscriptionStartDate__c.addDays(2) >= oSubscription.CreatedDate)
                    );
                    Boolean isEmailDisabled = (
                        oSubscription.Zuora__Account__r.Disable_transactional_emails__c ||
                        oSubscription.Zuora__Account__r.Disable_Welcome_emails__c
                    ); 
                    if (isStartDatesAndStatusSuitable && !isEmailDisabled) {
                        Email_Sync_Queue__c dataImportEmailQueue = new Email_Sync_Queue__c(
                            Account__c = oSubscription.Zuora__Account__c,
                            Account_Currency__c = oSubscription.Zuora__CustomerAccount__r.Zuora__Currency__c,
                            Account_Status__c = 'Free Trial',
                            All_Email_Preferences__c = oSubscription.Zuora__Account__r.All_Email_Preferences__c,
                            Dispatch_ID__c = setAnnualOrMonthlyDispatchId(oSubscription.Zuora__TermSettingType__c, oSubscription.SourceSystem__c),
                            First_Name__c = oSubscription.Zuora__Account__r.FirstName,
                            Last_Name__c = oSubscription.Zuora__Account__r.LastName,
                            Free_Trial_End_Date__c = oSubscription.Zuora__NextChargeDate__c,//calculateFreeTrialEndDate(oSubscription.Zuora__SubscriptionStartDate__c, oSubscription.NumFreeTrialPeriods__c),
                            Subscription_Amount__c = oSubscription.SubscriptionAmount__c,
                            Subscription_End_Date__c = calculateSubscriptionEndDate(oSubscription),
                            Is_Double_Opt_in__c = oSubscription.Zuora__Account__r.Is_Double_OptIn__c,
                            Notification_Country_Code__c = oSubscription.Zuora__Account__r.Notification_Country_Code__c,
                            Notification_Language_Code__c = oSubscription.Zuora__Account__r.Notification_Language_Code__c,
                            Payment_Method_Type__c = oSubscription.Zuora__CustomerAccount__r.Zuora__PaymentMethod_Type__c,
                            Person_Email__c = oSubscription.Zuora__Account__r.PersonEmail,
                            Rebill_Date__c = calculateRebillDate(oSubscription.Free_Trial_End_Date__c, oSubscription.Gift_Code_End_Date__c),
                            Plan_Details__c = 'Free Trial',
                            Status__c = 'Not Started',
                            Type_of_Email__c = 'Triggered Dispatch',
                            Unsubscribe_Language__c = oSubscription.Zuora__Account__r.Notification_Language_Code__c,
                            Email_Name__c = setEmailNameAnnualOrMonthly(oSubscription.Zuora__TermSettingType__c, oSubscription.SourceSystem__c)
                        );
                        welcomeEmailSyncQueues.add(dataImportEmailQueue);
                    }
                }
            }
            insert welcomeEmailSyncQueues;
        }
    }
    
    public static Integer setAnnualOrMonthlyDispatchId(String termSettingType, String sourceSystem) {
        Integer dispatchId;
        if (String.isNotBlank(sourceSystem) && sourceSystem == 'Apple') {
            dispatchId = (!Test.isRunningTest()) ? Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Apple_Free_Trial_Welcome').Value__c) : 12334;
        } else if (String.isNotBlank(sourceSystem) && sourceSystem == 'Roku') {
            dispatchId = (!Test.isRunningTest()) ? Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Roku_Free_Trial_Welcome').Value__c) : 12334;
        } else if (termSettingType == 'EVERGREEN') {
            dispatchId = (!Test.isRunningTest()) ? Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Free_Trial_Welcome').Value__c) : 12334;
        } else if (termSettingType == 'TERMED') {
            dispatchId = (!Test.isRunningTest()) ? Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Free_Trial_Welcome_Termed').Value__c) : 12333;
        }
        return dispatchId;
    }
    
    public static String setEmailNameAnnualOrMonthly(String termSettingType, String sourceSystem) {
        String emailName;
        if (String.isNotBlank(sourceSystem) && sourceSystem == 'Apple') {
            emailName = 'Apple Free Trial Welcome';
        } else if (String.isNotBlank(sourceSystem) && sourceSystem == 'Roku') {
            emailName = 'Roku Free Trial Welcome';
        } else if (termSettingType == 'EVERGREEN') {
            emailName = 'Free Trial Welcome Monthly';
        } else if (termSettingType == 'TERMED') {
            emailName = 'Free Trial Welcome Annual';
        }
        return emailName;
    }
    
    public static Date calculateRebillDate(Date freeTrialEndDate, Date giftCodeEndDate) {
        Date rebillDate = freeTrialEndDate;
        if (rebillDate != null) {
            if (giftCodeEndDate != null && giftCodeEndDate > rebillDate) {
                rebillDate = giftCodeEndDate;
            }
        }
        else {
            rebillDate = giftCodeEndDate;
        }
        return rebillDate;
    }

    private static Date calculateSubscriptionEndDate(Zuora__Subscription__c sub) {
        Date subscriptionEndDate;
        if (sub.Zuora__TermSettingType__c == 'TERMED') {
            subscriptionEndDate = sub.Zuora__SubscriptionStartDate__c;
            if (String.isNotBlank(sub.NumGiftPeriods__c) && Integer.valueOf(sub.NumGiftPeriods__c) > 0) {
               subscriptionEndDate = subscriptionEndDate.addMonths(Integer.valueOf(sub.NumGiftPeriods__c));
            }
            if (String.isNotBlank(sub.NumFreeTrialPeriods__c) && Integer.valueOf(sub.NumFreeTrialPeriods__c) > 0) {
                subscriptionEndDate = subscriptionEndDate.addMonths(Integer.valueOf(sub.NumFreeTrialPeriods__c));
            }
            subscriptionEndDate = subscriptionEndDate.addMonths(12);
        } else {
            subscriptionEndDate = sub.Zuora__SubscriptionEndDate__c;
        }
        return subscriptionEndDate;
    }
    
    /*
    * Description: Method calculates Free_Trial_End_Date__c: subscription start date + number of months as denoted by the field NumFreeTrialPeriods__c
    */
    /* Temporarily commented out
    public static Date calculateFreeTrialEndDate(Date subscriptionStartDate, String numFreeTrialPeriods) {
        Date freeTrialEndDate;
        if (subscriptionStartDate != null) {
            freeTrialEndDate = subscriptionStartDate;
            if (numFreeTrialPeriods != null) {
                freeTrialEndDate = freeTrialEndDate.addMonths(Integer.valueOf(numFreeTrialPeriods));
            }
        }
        return freeTrialEndDate;
    }*/
    
    
     /***************************************************************************
     Method:  updateAccountCounts
     Details: update counts of different Subscriptions in Accounts   
    *****************************************************************************/
    /* commented out according to PD-15332
    public void updateAccountCounts(map<id,Zuora__Subscription__c> mapsub){
        List<Account> lstAccount = new List<Account>();
        Map<String, List<Zuora__Subscription__c>> mapAccountsForActiveSubscriptions = new Map<String, List<Zuora__Subscription__c>>();
        Map<String, List<Zuora__Subscription__c>> mapAccountsForCancelledSubscriptions = new Map<String, List<Zuora__Subscription__c>>();
        Map<String, List<Zuora__Subscription__c>> mapAccountsForFutureCancelledSubscriptions = new Map<String, List<Zuora__Subscription__c>>();
    try{
        //get the Account Ids corresponding to the Sub Ids
        List<Zuora__Subscription__c> subscriptiondetails = [Select Zuora__Account__c, Zuora__Status__c, ID, Zuora__TermEndDate__c from Zuora__Subscription__c where 
                                                            ID in :mapsub.keySet()];
                                                            
        
        
        //create a Map of Accounts and related List of Subscriptions Status = Active
        for(Zuora__Subscription__c zSubscription : subscriptiondetails){
            mapAccountsForActiveSubscriptions.put(zSubscription.Zuora__Account__c,new List<Zuora__Subscription__c>());
            mapAccountsForCancelledSubscriptions.put(zSubscription.Zuora__Account__c,new List<Zuora__Subscription__c>());
            mapAccountsForFutureCancelledSubscriptions.put(zSubscription.Zuora__Account__c,new List<Zuora__Subscription__c>());
        }
        
        List<Zuora__Subscription__c> subscriptionPerAccount = [Select Zuora__Account__c, Zuora__Status__c, ID, Zuora__TermEndDate__c from Zuora__Subscription__c where 
                                                            Zuora__Account__c in :mapAccountsForActiveSubscriptions.keySet()];
        
        //get the counts per account being processed in the trigger
        for(Zuora__Subscription__c zSubscription : subscriptionPerAccount){
            if(zSubscription.Zuora__Status__c == 'Active'){
                List<Zuora__Subscription__c> accSubscriptions = mapAccountsForActiveSubscriptions.get(zSubscription.Zuora__Account__c);
                accSubscriptions.add(zSubscription);
                mapAccountsForActiveSubscriptions.put(zSubscription.Zuora__Account__c, accSubscriptions);
            }
            if(zSubscription.Zuora__Status__c == 'Cancelled' && zSubscription.Zuora__TermEndDate__c!=null && zSubscription.Zuora__TermEndDate__c > Date.today()){
                List<Zuora__Subscription__c> accSubscriptions = mapAccountsForFutureCancelledSubscriptions.get(zSubscription.Zuora__Account__c);
                accSubscriptions.add(zSubscription);
                mapAccountsForFutureCancelledSubscriptions.put(zSubscription.Zuora__Account__c, accSubscriptions);
            }
            
            if(zSubscription.Zuora__Status__c == 'Cancelled'){
                List<Zuora__Subscription__c> accSubscriptions = mapAccountsForCancelledSubscriptions.get(zSubscription.Zuora__Account__c);
                accSubscriptions.add(zSubscription);
                mapAccountsForCancelledSubscriptions.put(zSubscription.Zuora__Account__c, accSubscriptions);
            }
        }
        if(mapAccountsForActiveSubscriptions!=null && !mapAccountsForActiveSubscriptions.isEmpty()){
            for (String accId : mapAccountsForActiveSubscriptions.keySet()){
                Account objAcc = new Account(Id = accId);
                objAcc.Number_of_Active_Subs__c = (mapAccountsForActiveSubscriptions.get(accId)).size()+'';
                objAcc.Number_of_Cancelled_Subs__c = (mapAccountsForCancelledSubscriptions.get(accId)).size()+'';
                objAcc.Number_of_Future_Cancels__c = (mapAccountsForFutureCancelledSubscriptions.get(accId)).size()+'';
                lstAccount.add(objAcc);
            }
        }
        
        if(!lstAccount.isEmpty()){
            update lstAccount;
        }
        
    }catch(Exception ex){
        // TO-DO: this an old code will need to be deleted - temporarily commented out PD-11052 changes
        //PD-11052-Replaced to userinfo.getUserId() from string.valueof(user.Id)
        //    ExceptionLoggerHelper.createExceptionLog(userinfo.getUserId(), 'updateAccountCounts', 'updateAccountCounts', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            SendEmailWithErrorsToAdmins.sendEmail(ex.getMessage());
        }
        
    }*/

    public void setFreeTrialEndDate(List<Zuora__Subscription__c> lstSubscription) {
        for (Zuora__Subscription__c sub : lstSubscription) {
            if (String.isNotBlank(sub.NumFreeTrialPeriods__c) && Integer.valueOf(sub.NumFreeTrialPeriods__c) > 0) {
                Date tmpSubscriptionStartDate = sub.Zuora__SubscriptionStartDate__c;
                sub.Free_Trial_End_Date__c = tmpSubscriptionStartDate.addMonths(Integer.valueOf(sub.NumFreeTrialPeriods__c));
            } else {
                //commented as part of PD-13731
                //sub.Free_Trial_End_Date__c = null;
                //added as part of PD-13731
                sub.Free_Trial_End_Date__c = sub.Zuora__SubscriptionStartDate__c;
            }
            if (String.isNotBlank(sub.NumGiftPeriods__c) && Integer.valueOf(sub.NumGiftPeriods__c) > 0) {
                Date tmpGiftCodeEndDate = (sub.Free_Trial_End_Date__c != null) ? sub.Free_Trial_End_Date__c : sub.Zuora__SubscriptionStartDate__c;
                sub.Gift_Code_End_Date__c = tmpGiftCodeEndDate.addMonths(Integer.valueOf(sub.NumGiftPeriods__c));
            } else {
                sub.Gift_Code_End_Date__c = null;
            }
        }
    }
    
}