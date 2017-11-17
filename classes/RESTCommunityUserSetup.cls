/**
* @author Cognizant Technology Solutuions
* @date 10/06/2016
* @description CreateCommunityUser  class to create account, user and set password for new livesport user.
*/
@RestResource(urlMapping='/CreateCommunityUser/*')
global class RESTCommunityUserSetup {
 /**
        Webservice method to setup community account in salesforce.
        @Param FirstName This param for account/user first name
        @Param LastName This param for account/user last name 
        @Param Email This param for account person email and user email
        @Param Password This param for user password
        @Param BillingCountryCode This param for account billing country code and user country code
        @Param Alias This param for user alias
        @Param EmailPreferences This param for user email preferences
        @Param CommunityName This param for user community nickname
        @Param TimeZoneSidkey This param for user time zone e.g. GMT
        @Param LocaleSidKey This param for user locale
        @Param EmailEncodingKey This param for user email encoding
        @Param LanguageLocaleKey This param for user language
        @return Response return webservice response.
    */
    /*
    @HttpPost  
    global static Response CreateCommunityUserPost(string FirstName, string LastName, string Email, string Password, string BillingCountryCode, string Alias, string EmailPreferences,
                                                    string CommunityNickName, string TimeZoneSidkey, string LocaleSidKey, string EmailEncodingKey, string LanguageLocaleKey,
                                                    string CurrencyISOCode)
    {
        
        Savepoint sp = null;
        try{
            // Step1: Log Request in API Audit Trail.
          
                    
            // Step2: Check required inputs is supplied.
            if(String.isEmpty(FirstName) || String.isEmpty(LastName) || String.isEmpty(Email) || String.isEmpty(Password) || String.isEmpty(BillingCountryCode) || String.isEmpty(EmailEncodingKey) ||
               String.isEmpty(Alias) || String.isEmpty(CommunityNickName) || String.isEmpty(TimeZoneSidkey) || String.isEmpty(LocaleSidKey) || String.isEmpty(LanguageLocaleKey)) {
                return CreateResponse('Failure', null, null, '1001', 'Missing required input');
            }
    
            // Step3: Check Country white listed, if yes then check email is white listed.
            List<Whitelisted_Country__c> lstWhiteListedCountry = [Select Id from Whitelisted_Country__c where Name=:BillingCountryCode and Whitelisting_Active__c = true];
            if(lstWhiteListedCountry != null && !lstWhiteListedCountry.isEmpty()){

                List<Whitelisted_Emails__c> lstWhiteListedEmail = [Select Id from Whitelisted_Emails__c where Whitelisted_Country__r.Name=:BillingCountryCode 
                                                            and Email__c =:Email and Whitelisted_Country__r.Whitelisting_Active__c = true];
                if(lstWhiteListedEmail == null || lstWhiteListedEmail.isEmpty()){
                    return CreateResponse('Failure', null, null, '1002', 'Email is not white listed for country');
                } 
            }
    
            // Step4: Check Email already exist in system
            List<User> lstUser = [Select Id from User where Email=: Email and IsActive = true];
            if(lstUser!=null && !lstUser.isEmpty()){
                return CreateResponse('Failure', null, null, '1003', 'Email already exist');
            }
    
            // Create a savepoint while AccountNumber is null
            sp = Database.setSavepoint();

            // Step5: Create Person Account
           // Account oAccount = CreateAccount(FirstName, LastName, Email, BillingCountryCode, EmailPreferences, CurrencyISOCode);
            Account oAccount = CreateAccount(FirstName, LastName, Email, BillingCountryCode, LanguageLocaleKey, EmailPreferences, CurrencyISOCode);
            if(oAccount==null){
                Database.rollback(sp);
                return CreateResponse('Failure', null, null, '1004', 'Failed to create person account');
            }
    
            string sUserId = null;
            string sErrorMessage = null;
            // Step6: Create Community User
            Database.SaveResult[] lstSaveResult = CreateUser(oAccount.Id, FirstName, LastName, Email, Password, BillingCountryCode, Alias, CommunityNickName, TimeZoneSidkey, 
                                    LocaleSidKey, EmailEncodingKey, LanguageLocaleKey, CurrencyISOCode);
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
        
            if(sUserId == null){
                Database.rollback(sp);
                return CreateResponse('Failure', null, null, '1005', sErrorMessage);
            }
       
            // Return Response.
            if(oAccount.id !=null && sUserId != null ){
                
                // Step8: Set password for user.
                System.setPassword(sUserId, Password);
                return CreateResponse('Success', GetAccountInfo(oAccount.id), GetUserInfo(sUserId), null, null);
            }else{
                return CreateResponse('Failure', null, null, '1006', 'Unknow exception');
            }
        }catch(Exception ex){
            Database.rollback(sp);
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CreateCommunityUser', 'CreateCommunityUserPost', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return CreateResponse('Failure', null, null, '1006', ex.getMessage());
        }
    }*/
    
    /**
        This method is used to create community user Account record.
        @Param sFirstName This param for account first name
        @Param sLastName This param for account last name 
        @Param sEmail This param for account person email
        @Param sBillingCountryCode This param for account billing country code
        @Param sEmailPreference This param for account email preferences
        @return oAccount return newly created account.
    */
    /*
    private static Account CreateAccount(string sFirstName, string sLastName, string sEmail, string sBillingCountryCode, string sLanguageCode, string sEmailPreferences, string sCurrencyISOCode){
        
        // Get Person Record Type ID.
        Id PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        // Create Account
        Account oAccount = new Account();
        oAccount.FirstName = sFirstName;
        oAccount.LastName = sLastName;
        oAccount.PersonEmail = sEmail;
        oAccount.BillingCountryCode  = sBillingCountryCode;
        oAccount.Notification_Country_Code__c = sBillingCountryCode;
        oAccount.Notification_Language_Code__c = sLanguageCode;
        oAccount.All_Email_Preferences__c = sEmailPreferences=='true'? true: false;
        oAccount.RecordTypeId = PersonRecordTypeId;
        oAccount.IsReadyToSyncInCommunicator__c = TRUE;
        //oAccount.Account_Status__c = 'Partial';
        oAccount.CurrencyISOCode = sCurrencyISOCode;
        insert oAccount;
        
        return oAccount;
    }*/
    
    /**
        This method is used to create community user record.
        @Param sAccountId This param for account id, which is used to search created contact for an account.
        @Param sFirstName This param for user first name
        @Param sLastName This param for user last name 
        @Param sEmail This param for user email
        @Param sBillingCountryCode This param for user country code
        @Param sAlias This param for user alias
        @Param sCommunityName This param for user community nickname
        @Param sTimeZoneSidkey This param for user time zone e.g. GMT
        @Param sLocaleSidKey This param for user locale
        @Param sEmailEncodingKey This param for user email encoding
        @Param sLanguageLocaleKey This param for user language
        @return oUser return newly created user.
    */
    /*
    private static Database.SaveResult[] CreateUser(Id sAccountId, string sFirstName, string sLastName, string sEmail, string sPassword, string sBillingCountryCode, string sAlias, 
                                    string sCommunityName, string sTimeZoneSidkey, string sLocaleSidKey, string sEmailEncodingKey, string sLanguageLocaleKey,
                                    string sCurrencyISOCode)
    {
        
        // Get PersonContactId from contact.
        List<Contact> lstContact = [Select Id from Contact where AccountId =:sAccountId];

        // Get Profile ID
        Profile oProfile = [SELECT Id FROM Profile where name = 'Customer Community User'];
        /*Start PD-14478*/
        /*String usernameConfiguration = (DAZNConfiguration__c.getValues('LS_UserName_Configuration') != null) ? DAZNConfiguration__c.getValues('LS_UserName_Configuration').Value__c : null;*/
        /*End PD-14478*/
        // Set DML Options
        /*Database.DMLOptions oDMLOption = new Database.DMLOptions();
        oDMLOption.EmailHeader.triggerUserEmail = false;
        oDMLOption.EmailHeader.triggerOtherEmail = false;
        
        // Create community user
        User oUser = new User();
        oUser.FirstName = sFirstName;
        oUser.LastName = sLastName;
        oUser.CountryCode = sBillingCountryCode;
        oUser.Email = sEmail;
        oUser.Username = sEmail + '.'+ /*Label.LS_UserName_Configuration*/ /* usernameConfiguration;
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
        
        List<User> lstUser = new List<User>();
        lstUser.add(oUser);
        return Database.insert(lstUser, oDMLOption);
    }*/
    
    /**
        This method is used to create reponse for webservice call.
        @Param sStatus This param for webservice operation failure/success status
        @Param oAccount This param for account information, this will be null if webservice failed to create record
        @Param oUser This param for user information, this will be null if webservice failed to create record
        @Param sErrorCode This param for errocode for failure
        @Param sReasons This param for failure reason
        @return oResponse return webservice response to client.
    */
    /*
    private static Response CreateResponse(string sStatus, Account oAccount, User oUser, string sErrorCode, string sReasons){
        Response oResponse = new Response();
        oResponse.status = sStatus;
        oResponse.account = oAccount;
        oResponse.user = oUser;
        oResponse.errorCode = sErrorCode;
        oResponse.reason = sReasons;
        return oResponse;
    }*/
    
    /**
        This method is used to get newly created account information
        @Param sAccountId This param for Account Id to query account information
        @return Account Newly created account information.
    */
    /*
    private static Account GetAccountInfo(Id sAccountId){
        
        List<Account> lstAccount = [SELECT AccountSource,Account_Status__c,All_Email_Preferences__c,AuthKey__c,BillingAddress,BillingCity,
                                            BillingCountry,BillingCountryCode,BillingGeocodeAccuracy,BillingLatitude,BillingLongitude,
                                            BillingPostalCode,BillingState,BillingStateCode,BillingStreet,Cancelled_Account__c,CleanStatus,
                                            Contact_sync_complete__c,CreatedById,CreatedDate,CurrencyIsoCode,Description,DunsNumber,Fax,
                                            FirstName,Id,Industry,IsCustomerPortal,IsDeleted,IsPersonAccount,IsReadyToSyncInCommunicator__c,
                                            IsReadyToSyncInZuora__c,Is_Double_OptIn__c,Jigsaw,JigsawCompanyId,LastActivityDate,LastModifiedById,
                                            LastModifiedDate,LastName,LastReferencedDate,LastViewedDate,MasterRecordId,
                                            NaicsCode,NaicsDesc,Name,NOTE__c,Notification_Country_Code__c,Notification_Email__c,
                                            Notification_Language_Code__c,NumberOfEmployees,Num_Active_Devices__c,Num_Devices__c,OwnerId,ParentId,
                                            Payment_Type_Last_Digits_and_Expiry_Date__c,PersonBirthdate,PersonContactId,PersonDepartment,PersonEmail,
                                            PersonEmailBouncedDate,PersonEmailBouncedReason,PersonHomePhone,PersonLastCURequestDate,PersonLastCUUpdateDate,
                                            PersonMailingAddress,PersonMailingCity,PersonMailingCountry,PersonMailingCountryCode,PersonMailingGeocodeAccuracy,
                                            PersonMailingLatitude,PersonMailingLongitude,PersonMailingPostalCode,PersonMailingState,
                                            PersonMailingStateCode,PersonMailingStreet,PersonMobilePhone,PersonTitle,Phone,PhotoUrl,Rating,RecordTypeId,
                                            Reset_Pwd_Body_1__c,Reset_Pwd_Body_2__c,Reset_Pwd_Body_3__c,Reset_Pwd_Body_4__c,
                                            Reset_Pwd_Greeting__c,Reset_pwd_Link_1__c,Reset_Pwd_Link_2__c,Reset_Pwd_Signature__c,Reset_Pwd_Subject__c,
                                            Salutation,ShippingAddress,ShippingCity,ShippingCountry,ShippingCountryCode,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,ShippingPostalCode,
                                            ShippingState,ShippingStateCode,ShippingStreet,SicDesc,SubscriptionEndDate__c,Subscription_Date__c,SystemModstamp,TestUser__c,Tradestyle,Type,
                                            Website,YearStarted,zqu__County__pc,Zuora__Active__c,Zuora__CustomerPriority__c,Zuora__NumberofLocations__c,Zuora__SLAExpirationDate__c,
                                            Zuora__SLASerialNumber__c,Zuora__SLA__c,Zuora__UpsellOpportunity__c FROM Account
                                    WHERE Id =:sAccountId];
        if(lstAccount !=null && !lstAccount.isEmpty()){
            return lstAccount[0];
        }
        return null;
    }*/
    
    /**
        This method is used to get newly created user information
        @Param sUserId This param for User Id to query user information
        @return User Newly created user information.
    */
    /*
    private static User GetUserInfo(Id sUserId){
        List<User> lstUser = [SELECT AboutMe,AccountId,Address,Alias,BadgeText,CallCenterId,City,CommunityNickname,
                                    CompanyName,ContactId,Country,CountryCode,CreatedById,CreatedDate,CurrencyIsoCode,DefaultCurrencyIsoCode,
                                    DefaultGroupNotificationFrequency,DelegatedApproverId,Department,DigestFrequency,Division,Email,
                                    EmailEncodingKey,EmailPreferencesAutoBcc,EmailPreferencesAutoBccStayInTouch,EmailPreferencesStayInTouchReminder,
                                    EmployeeNumber,Extension,ExternalID__c,Fax,FederationIdentifier,FirstName,ForecastEnabled,FullPhotoUrl,
                                    GeocodeAccuracy,Id,IsActive,IsPortalEnabled,JigsawImportLimitOverride,LanguageLocaleKey,LastLoginDate,
                                    LastModifiedById,LastModifiedDate,LastName,LastPasswordChangeDate,LastReferencedDate,LastViewedDate,Latitude,LocaleSidKey,
                                    Longitude,ManagerId,MobilePhone,Name,Notification_Language_Code__c,OfflinePdaTrialExpirationDate,OfflineTrialExpirationDate,
                                    Phone,PortalRole,PostalCode,ProfileId,ReceivesAdminInfoEmails,ReceivesInfoEmails,SenderEmail,SenderName,
                                    Send_Welcome_Email__c,Signature,SmallPhotoUrl,State,StateCode,StayInTouchNote,StayInTouchSignature,StayInTouchSubject,
                                    Street,SystemModstamp,TimeZoneSidKey,Title,Username,UserPermissionsAvantgoUser,UserPermissionsCallCenterAutoLogin,
                                    UserPermissionsChatterAnswersUser,UserPermissionsInteractionUser,UserPermissionsJigsawProspectingUser,
                                    UserPermissionsKnowledgeUser,UserPermissionsLiveAgentUser,UserPermissionsMarketingUser,UserPermissionsMobileUser,
                                    UserPermissionsOfflineUser,UserPermissionsSFContentUser,UserPermissionsSupportUser,UserPermissionsWorkDotComUserFeature,
                                    UserPreferencesActivityRemindersPopup,UserPreferencesApexPagesDeveloperMode,UserPreferencesCacheDiagnostics,
                                    UserPreferencesDisableAllFeedsEmail,UserPreferencesDisableBookmarkEmail,UserPreferencesDisableChangeCommentEmail,
                                    UserPreferencesDisableEndorsementEmail,UserPreferencesDisableFeedbackEmail,UserPreferencesDisableFileShareNotificationsForApi,
                                    UserPreferencesDisableFollowersEmail,UserPreferencesDisableLaterCommentEmail,UserPreferencesDisableLikeEmail,
                                    UserPreferencesDisableMentionsPostEmail,UserPreferencesDisableMessageEmail,UserPreferencesDisableProfilePostEmail,
                                    UserPreferencesDisableSharePostEmail,UserPreferencesDisableWorkEmail,UserPreferencesDisCommentAfterLikeEmail,
                                    UserPreferencesDisMentionsCommentEmail,UserPreferencesDisProfPostCommentEmail,UserPreferencesEnableAutoSubForFeeds,
                                    UserPreferencesEventRemindersCheckboxDefault,UserPreferencesHideChatterOnboardingSplash,UserPreferencesHideCSNDesktopTask,
                                    UserPreferencesHideCSNGetChatterMobileTask,UserPreferencesHideS1BrowserUI,UserPreferencesHideSecondChatterOnboardingSplash,
                                    UserPreferencesJigsawListUser,UserPreferencesLightningExperiencePreferred,UserPreferencesPathAssistantCollapsed,
                                    UserPreferencesReminderSoundOff,UserPreferencesShowCityToExternalUsers,UserPreferencesShowCityToGuestUsers,
                                    UserPreferencesShowCountryToExternalUsers,UserPreferencesShowCountryToGuestUsers,UserPreferencesShowEmailToExternalUsers,
                                    UserPreferencesShowEmailToGuestUsers,UserPreferencesShowFaxToExternalUsers,UserPreferencesShowFaxToGuestUsers,
                                    UserPreferencesShowManagerToExternalUsers,UserPreferencesShowManagerToGuestUsers,UserPreferencesShowMobilePhoneToExternalUsers,
                                    UserPreferencesShowMobilePhoneToGuestUsers,UserPreferencesShowPostalCodeToExternalUsers,UserPreferencesShowPostalCodeToGuestUsers,
                                    UserPreferencesShowProfilePicToGuestUsers,UserPreferencesShowStateToExternalUsers,UserPreferencesShowStateToGuestUsers,
                                    UserPreferencesShowStreetAddressToExternalUsers,UserPreferencesShowStreetAddressToGuestUsers,UserPreferencesShowTitleToExternalUsers,
                                    UserPreferencesShowTitleToGuestUsers,UserPreferencesShowWorkPhoneToExternalUsers,UserPreferencesShowWorkPhoneToGuestUsers,
                                    UserPreferencesSortFeedByComment,UserPreferencesTaskRemindersCheckboxDefault,UserRoleId,UserType,Viewer_Id__c 
                                FROM User
                                WHERE Id =:sUserId];
        if(lstUser !=null && !lstUser.isEmpty()){
            return lstUser[0];
        }
        return null;                    
    }*/
    
    
    
    /**
        Webservice Response Class
    */
    /*
    global class Response{
        public string status {get;set;} 
        public Account account {get;set;} 
        public User user {get;set;} 
        public string errorCode {get;set;}
        public string reason {get;set;} 
    }*/
}