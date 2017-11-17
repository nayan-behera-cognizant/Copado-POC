@RestResource(urlMapping='/CreateCommunityUserAccount/*')
global class RESTCommunityUserAccountCreation {
    @HttpPost
    global static responseObj createCommunityUserAccountPost(string FirstName, string LastName, string Email, string Password, string BillingCountryCode, string Alias, string EmailPreferences,
                                                        string CommunityNickName, string TimeZoneSidkey, string LocaleSidKey, string EmailEncodingKey, string LanguageLocaleKey,
                                                        string CurrencyISOCode,string IPaddress, string ViewerId, DateTime AuthKey, String TypeUser,boolean NFLMarketing)
    {
         Savepoint sp = null;
        try {
         // Step1: Log Request in API Audit Trail. - removed

            // Step2: Check required inputs is supplied.
            if(String.isEmpty(FirstName) || String.isEmpty(LastName) || String.isEmpty(Email) || String.isEmpty(Password) || String.isEmpty(BillingCountryCode) || String.isEmpty(EmailEncodingKey) ||
               String.isEmpty(Alias) || String.isEmpty(CommunityNickName) || String.isEmpty(TimeZoneSidkey) || String.isEmpty(LocaleSidKey) || String.isEmpty(LanguageLocaleKey)) {
                return Response('Failure', null, null, '1001', 'Missing required input');
            }

            // Step3: Check Email already exist in system
            //commented as part of PD-13612
            //List<User> lstUser = [Select Id from User where Email=: Email and IsActive = true];
            //if(lstUser!=null && !lstUser.isEmpty()){
            //    return CreateResponse('Failure', null, null, '1003', 'Email already exist');
            //}
           //step4 : Check IP address format
            String regex='^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$';
            Pattern p = Pattern.compile(regex);
            String InputString = IPaddress;
            Matcher MyMatcher = p.matcher(InputString);
            if (String.isNotBlank(InputString)) {
                if (!MyMatcher.matches()) {
                    return Response('Failure', null, null, '1004', 'Invalid IP Address');
                }
            }
        // Create a savepoint while AccountNumber is null
            sp = Database.setSavepoint();
            // Step5: Create Person Account
            // Account oAccount = CreateAccount(FirstName, LastName, Email, BillingCountryCode, EmailPreferences, CurrencyISOCode);
            //
            //addes parameters for PD-9679 - Docomo sign- Modification of existing webservice
          
         Account oAccount;
            try { //try...catch was added as part of PD-13612
                oAccount = createAccount(FirstName, LastName, Email, BillingCountryCode, LanguageLocaleKey, EmailPreferences, CurrencyISOCode, IPaddress, AuthKey, TypeUser, NFLMarketing);
            } catch(DmlException e) {
                if (String.valueOf(StatusCode.DUPLICATE_VALUE) == e.getDmlStatusCode(0)) {
                    return Response('Failure', null, null, '1003', 'Email already exist');
                }
            }

            if (oAccount == null) {
                Database.rollback(sp);
                return Response('Failure', null, null, '1005', 'Failed to create person account');
            }
            string sUserId = null;
            string sErrorMessage = null;
        
            //addes parameters for PD-9679 - Docomo sign- Modification of existing webservice
            // Step6: Create Community User
            Database.SaveResult[] lstSaveResult = CreateUser(oAccount.Id, FirstName, LastName, Email, Password, BillingCountryCode, Alias, CommunityNickName, TimeZoneSidkey,
                                    LocaleSidKey, EmailEncodingKey, LanguageLocaleKey, CurrencyISOCode, ViewerId);
            for (Database.SaveResult sr : lstSaveResult) {
                if (sr.isSuccess()) {
                     sUserId = sr.getId();
                }
                else {
                    // Operation failed, so get all errors
                    for(Database.Error err : sr.getErrors()) {
                        sErrorMessage = err.getStatusCode() + ': ' + err.getMessage();
                    }
                }
            }
            if (sUserId == null) {
                Database.rollback(sp);
                return Response('Failure', null, null, '1006', sErrorMessage);
            }
              // Return Response.
            if (oAccount.id !=null && sUserId != null ) {

                // Step8: Set password for user.
                System.setPassword(sUserId, Password);
                /* Added code part of the PD-11719 start */
                Account createdAccount = getAccount(oAccount.id);
                List<Email_Sync_Queue__c> emailSyncQueueList = new List<Email_Sync_Queue__c>();
                Email_Sync_Queue__c dataImportEmailQueue = new Email_Sync_Queue__c(
                    Account__c = createdAccount.Id,
                    Account_Status__c = createdAccount.Account_Status__c,
                    Notification_Language_Code__c = LanguageLocaleKey,
                    Person_Email__c = Email,
                    First_Name__c = FirstName,
                    Last_Name__c = LastName,
                    Notification_Country_Code__c = BillingCountryCode.toUpperCase(),
                    Status__c = 'Not Started',
                    All_Email_Preferences__c = true,
                    Is_Double_Opt_in__c = false,
                    Type_of_Email__c = 'Data Import'
                );
                emailSyncQueueList.add(dataImportEmailQueue);
                if (BillingCountryCode.toUpperCase() == 'DE' && EmailPreferences == 'true' && !createdAccount.Disable_transactional_emails__c) {
                    Email_Sync_Queue__c triggeredDispatchEmailQueue = new Email_Sync_Queue__c(
                        Account__c = createdAccount.Id,
                        Account_Status__c = createdAccount.Account_Status__c,
                        Notification_Language_Code__c = LanguageLocaleKey,
                        Person_Email__c = Email,
                        First_Name__c = FirstName,
                        Last_Name__c = LastName,
                        Notification_Country_Code__c = BillingCountryCode.toUpperCase(),
                        Status__c = 'Not Started',
                        All_Email_Preferences__c = true,
                        Is_Double_Opt_in__c = false,
                        Type_of_Email__c = 'Triggered Dispatch',
                        Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID Double optin').Value__c),
                        Email_Name__c = 'Double opt in'
                    );
                    emailSyncQueueList.add(triggeredDispatchEmailQueue);
                }
                insert emailSyncQueueList;
                /* Added code part of the PD-11719 end */
                return Response('Success', createdAccount, getUser(sUserId), null, null);
            }else{
                return Response('Failure', null, null, '1007', 'Unknow exception');
            }
        } catch(Exception ex) {
            Database.rollback(sp);
            String sRunninguserId = UserInfo.getUserId();
            String sClassName = 'CreateCommunityUserCaptureIPAddress';
            String sMethodName = 'CreateCommunityUserPost';
            // faced with an issue that error message could be longer than 255 symbols while working on PD-9843
            String sExMsg = (ex.getMessage().length() > 255) ? ex.getMessage().substring(0, 244) : ex.getMessage();
            String sTypeName = ex.getTypeName();
            String sStackTrace = ex.getStackTraceString();
            ExceptionLoggerHelper.createExceptionLog(sRunninguserId, sClassName, sMethodName, sExMsg, sTypeName, sStackTrace);
            return Response('Failure', null, null, '1008', ex.getMessage());
        } finally {
        }
        
       
    }
    
    public static responseObj Response(string sStatus, Account oAccount, User oUser, string sErrorCode, string sReasons){
        responseObj resObj = new responseObj();
        resObj.status = sStatus;
        resObj.ErrorCode = sErrorCode;
        resObj.reason = sReasons;
        //Account attributes Mapping
        if(oAccount!= null){
            account ac = getAccount(oAccount.Id);
            resObj.aAcId= ac.id; 
            resObj.aFirstName= ac.FirstName; 
            resObj.aLastName= ac.LastName;
            resObj.aPersonEmail= ac.PersonEmail;
            resObj.aRecordTypeId= ac.RecordTypeId;
            resObj.aPersonContactId= ac.PersonContactId;
            resObj.aAccountStatus= ac.Account_Status__c;
            resObj.aAuthKey= string.valueOf(ac.AuthKey__c);
            resObj.aBillingCountryCode= ac.BillingCountryCode;
            resObj.aAllEmailPreferences= ac.All_Email_Preferences__c;
        }else{
            resObj.aAcId= null; 
            resObj.aFirstName= null; 
            resObj.aLastName= null;
            resObj.aPersonEmail= null;
            resObj.aRecordTypeId= null;
            resObj.aPersonContactId= null;
            resObj.aAccountStatus= null;
            resObj.aAuthKey= null;
            resObj.aBillingCountryCode= null;
            resObj.aAllEmailPreferences= null;
        }
        // User object attributes Mapping 
        if(oUser!= null){
            user u = getUser(oUser.id);
            resObj.uUserId = u.id;
            resObj.uViewerID = u.ExternalID__c; 
            resObj.uUsername = u.Username;
            resObj.uEmail = u.Email;
            resObj.uFirstName = u.FirstName;
            resObj.uLastName = u.LastName;
            resObj.uContactId = u.ContactId;
            resObj.uProfileId = u.ProfileId;
            resObj.uAlias = u.Alias;
            resObj.uIsActive = u.IsActive;
            resObj.uCommunityNickname = u.CommunityNickname;
            resObj.uTimeZoneSidKey = u.TimeZoneSidKey;
            resObj.uLocaleSidKey = u.LocaleSidKey;
            resObj.uEmailEncodingKey = u.EmailEncodingKey;
            resObj.uLanguageLocaleKey = u.LanguageLocaleKey;
            resObj.uSendWelcomeEmail = u.Send_Welcome_Email__c;
            resObj.uCurrencyIsoCode = u.CurrencyIsoCode;
            resObj.uCountryCode = u.CountryCode;
        }else{
            resObj.uUserId = null; 
            resObj.uViewerID = null; 
            resObj.uUsername = null; 
            resObj.uEmail = null;
            resObj.uFirstName = null;
            resObj.uLastName = null;
            resObj.uContactId = null;
            resObj.uProfileId = null;
            resObj.uAlias = null;
            resObj.uIsActive = null;
            resObj.uCommunityNickname = null;
            resObj.uTimeZoneSidKey = null;
            resObj.uLocaleSidKey = null;
            resObj.uEmailEncodingKey = null;
            resObj.uLanguageLocaleKey = null;
            resObj.uSendWelcomeEmail = null;
            resObj.uCurrencyIsoCode = null;
            resObj.uCountryCode = null;
            
        }
        
        return resObj;//json.serialize(resObj);
    } 
    
    private static account getAccount(Id acID){
        account ac =[select id, Account_Status__c,All_Email_Preferences__c,AuthKey__c,LastName,FirstName, Disable_transactional_emails__c,
                     PersonContactId,BillingCountryCode,RecordTypeId,PersonEmail from account where id =:acID];
        return ac;
    }
    private static user getUser(Id uID){
        User u =[select id, ExternalID__c,userName,email,LastName,FirstName,
                 ContactId,ProfileId,Alias,IsActive,CommunityNickname,TimeZoneSidKey,LocaleSidKey,
                 EmailEncodingKey,LanguageLocaleKey,Send_Welcome_Email__c,CurrencyIsoCode,CountryCode from User where id =:uID];
        return u;
    }
    
      //addes parameters for PD-9679 - Docomo sign- Modification of existing webservice
    private static Account createAccount(string sFirstName, string sLastName, string sEmail, string sBillingCountryCode, string sLanguageCode, string sEmailPreferences, string sCurrencyISOCode, string sAddress, DateTime sAuthKey, String typeUser,boolean NFLMarketing){

        // Get Person Record Type ID.
        Id PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        // Create Account
        Account oAccount = new Account();
        oAccount.UniqueEmail__c = sEmail; //added as part of PD-13612
        oAccount.FirstName = sFirstName;
        oAccount.LastName = sLastName;
        oAccount.PersonEmail = sEmail;
        oAccount.BillingCountryCode  = sBillingCountryCode.toUpperCase();
        oAccount.Notification_Country_Code__c = sBillingCountryCode.toUpperCase();
        oAccount.Notification_Language_Code__c = sLanguageCode;
        oAccount.All_Email_Preferences__c = sEmailPreferences=='true'? true: false;
        oAccount.RecordTypeId = PersonRecordTypeId;
        oAccount.Type = typeUser;
        //oAccount.Account_Status__c = 'Partial';
        oAccount.CurrencyISOCode = sCurrencyISOCode;
        oAccount.IP_address__c = sAddress;
        oAccount.IsReadyToSyncInCommunicator__c = TRUE;
        //PD-12780 : start
        if(sBillingCountryCode.toUpperCase() == 'CA'){
            if(NFLMarketing !=null){
            oAccount.NFL_marketing__c = NFLMarketing;
            }
        }
        //PD-12780 : End
        //PD-9679 - Docomo sign- Modification of existing webservice
        if(!string.isEmpty(String.ValueOf(sAuthKey))){
            oAccount.AuthKey__c  = sAuthKey;
        }
        //end PD-9679
        insert oAccount;
        return oAccount;
    }
    //addes parameters for PD-9679 - Docomo sign- Modification of existing webservice
    private static Database.SaveResult[] createUser(Id sAccountId, string sFirstName, string sLastName, string sEmail, string sPassword, string sBillingCountryCode, string sAlias,
                                    string sCommunityName, string sTimeZoneSidkey, string sLocaleSidKey, string sEmailEncodingKey, string sLanguageLocaleKey,
                                    string sCurrencyISOCode, String sViewerId)
    {

        // Get PersonContactId from contact.
        List<Contact> lstContact = [Select Id from Contact where AccountId =:sAccountId];

        // Get Profile ID
        Profile oProfile = [SELECT Id FROM Profile where name = 'Customer Community User'];

        // Set DML Options
        Database.DMLOptions oDMLOption = new Database.DMLOptions();
        oDMLOption.EmailHeader.triggerUserEmail = false;
        oDMLOption.EmailHeader.triggerOtherEmail = false;

        // Create community user
        User oUser = new User();
        oUser.FirstName = sFirstName;
        oUser.LastName = sLastName;
        oUser.CountryCode = sBillingCountryCode;
        oUser.Email = sEmail;
        oUser.Username = sEmail + '.'+ Label.LS_UserName_Configuration;
        oUser.Alias = sAlias;
        oUser.ContactId = lstContact[0].Id;
        oUser.CommunityNickName = sCommunityName;
        oUser.TimeZoneSidkey = sTimeZoneSidkey;
        oUser.LocaleSidKey = sLocaleSidKey ;
        oUser.EmailEncodingKey = sEmailEncodingKey;
        oUser.LanguageLocaleKey = sLanguageLocaleKey;
        oUser.IsActive = true;
        oUser.ProfileId = oProfile.Id;
        oUser.CurrencyISOCode = sCurrencyISOCode;
        //PD-9679 - Docomo sign- Modification of existing webservice
        if(!string.isEmpty(sViewerId)){
            oUser.ViewerId__c = sViewerId;
        }
        //end PD-9679
        List<User> lstUser = new List<User>();
        lstUser.add(oUser);
        return Database.insert(lstUser, oDMLOption);
    }

    
    global class responseObj{
        
        //Account Attributes
        public string aAcId{get;set;} 
        public string aFirstName{get;set;} 
        public string aLastName{get;set;}
        public string aPersonEmail{get;set;}
        public string aRecordTypeId{get;set;}
        public string aPersonContactId{get;set;}
        public string aAccountStatus{get;set;}
        public string aAuthKey{get;set;}
        public string aBillingCountryCode{get;set;}
        public boolean aAllEmailPreferences{get;set;}
        //User attributes
        public string uUserId{get;set;} 
        public string uViewerID{get;set;} 
        public string uUsername{get;set;} 
        public string uEmail{get;set;}
        public string uFirstName{get;set;}
        public string uLastName{get;set;}
        public string uContactId{get;set;}
        public string uProfileId{get;set;}
        public string uAlias{get;set;}
        public boolean uIsActive{get;set;}
        public string uCommunityNickname{get;set;}
        public string uTimeZoneSidKey{get;set;}
        public string uLocaleSidKey{get;set;}
        public string uEmailEncodingKey{get;set;}
        public string uLanguageLocaleKey{get;set;}
        public boolean uSendWelcomeEmail{get;set;}
        public string uCurrencyIsoCode{get;set;}
        public string uCountryCode{get;set;}
        //Failure and Success Attributes
        public string status {get;set;}
        public string errorCode {get;set;}
        public string reason {get;set;}    
    }
    
}