public class EmailHelper {
    
    //Get the PASSWORD_CHANGE values form Custom label*PD-7937* public static final String PASSWORD_CHANGE = 'PasswordChange'
    public static final String PASSWORD_CHANGE = System.Label.Ls_EmailHelper_PWDC;
    public static final String PASSWORD_CHANGE_TEMPLATE_LABEL = 'Send_Password_Update_Notification_Email';
    public static final String REACTIVATION_SUBSCRIPTION = 'ReactivateSubscription';
    public static final String REACTIVATION_SUBSCRIPTION_TEMPLATE_LABEL = 'Send_Confirmation_Notification_on_Subscription_Reactivated';
    public static final String CANCEL_SUBSCRIPTION = 'CancelSubscription';
    public static final String CANCEL_SUBSCRIPTION_TEMPLATE_LABEL = 'Send_Email_Notification_on_Subscription_Cancelled';
    
    public static void sendMail(List<string> lstToEmailAddress,string sSubject,string sMessage){        
        Messaging.SingleEmailMessage mail = null;
        mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = lstToEmailAddress;
        mail.setToAddresses(toAddresses);
        mail.setSubject(sSubject);
        mail.setPlainTextBody(sMessage);
        mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public static void sendMail(List<string> lstToEmailAddress, Id sTemplateId){        
        if(sTemplateId != null){
            Messaging.SingleEmailMessage mail = null;
            mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = lstToEmailAddress;
            mail.setToAddresses(toAddresses);
            mail.setSaveAsActivity(false);
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setTemplateId(sTemplateId);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    /*
        Description: Method to send email on password change.
    */    
    public static void sendPasswordChangeEmailtoUser(string strNewEmail, string strEmailTemplateType, string strPassword , 
                                                     string strNewPassword){
                                       
        Messaging.SingleEmailMessage mail = null;
        List<string> lstEmailIds = new List<String>();
        
        if(String.isBlank(strNewPassword)  && String.isBlank(strPassword) && !String.isBlank(strNewEmail) 
                 && strEmailTemplateType == 'PasswordChange'){
               lstEmailIds.add(strNewEmail);
               
               Id sTemplateId = getEmailTemplate(strEmailTemplateType);
               sendMail(lstEmailIds,sTemplateId);
       }
    }
    
    /*
        Description: Method to send email on subscription cancellation.
    */    
    public static void sendCancelSubscriptionEmailtoUser(string strNewEmail, string strEmailTemplateType){
                                       
        Messaging.SingleEmailMessage mail = null;
        List<string> lstEmailIds = new List<String>();
        
        /* Send email on subscription cancelled*/
        if(!string.isBlank(strNewEmail) && !string.isBlank(strEmailTemplateType) && strEmailTemplateType =='CancelSubscription'){
            lstEmailIds.add(strNewEmail);
            Id sTemplateId = getEmailTemplate(strEmailTemplateType);
            sendMail(lstEmailIds, sTemplateId);
        }
    }
  
    /*
        Description: Method to send email on subscription reactivation.
    */
    public static void sendReactivationSubscriptionEmailtoUser(string strNewEmail, string strEmailTemplateType){
                                       
        Messaging.SingleEmailMessage mail = null;
        List<string> lstEmailIds = new List<String>();
        /* Send email on subscription reactivation*/
        if(!string.isBlank(strNewEmail) && !string.isBlank(strEmailTemplateType) && strEmailTemplateType =='ReactivateSubscription'){
            lstEmailIds.add(strNewEmail);
            Id sTemplateId = getEmailTemplate(strEmailTemplateType);
            sendMail(lstEmailIds, sTemplateId);
        }
    }
    
    /*
        Description: Method to get email template information .
    */
    public static Id getEmailTemplate(String strEmailTemplateType){
        string sCountryCode = CommunityHelper.getCurrentUser().CountryCode;
        string strLangCode = CommunityHelper.getLanguageCode();
        
        if(strEmailTemplateType == PASSWORD_CHANGE){
            return getTemplateId(PASSWORD_CHANGE_TEMPLATE_LABEL + '_' + sCountryCode+ '_' + strLangCode);
        }else if(strEmailTemplateType == CANCEL_SUBSCRIPTION){
            return getTemplateId(CANCEL_SUBSCRIPTION_TEMPLATE_LABEL + '_' + sCountryCode + '_' +strLangCode);
        }else if(strEmailTemplateType == REACTIVATION_SUBSCRIPTION){
            return getTemplateId(REACTIVATION_SUBSCRIPTION_TEMPLATE_LABEL + '_' + sCountryCode + '_' +strLangCode);
        }
        
        return null;
    }
    
    /*
        Description: Method to get email template id.
    */
    private static Id getTemplateId(String emailTemplateName){
        List<EmailTemplate> lstEmailTemplate =  [Select Id, Name from EmailTemplate where DeveloperName=:emailTemplateName];
        if(lstEmailTemplate != null && !lstEmailTemplate.isEmpty()){
            return lstEmailTemplate[0].Id;
        }
        return null;
    }
    
    /*
        Description: Method to send payment expriy emails notifications.
        Note: This method invoke by job: BatchSendPaymentExpiryNotification
    */
    public static void SendPaymentExpiryNotification(List<Zuora__PaymentMethod__c> lstPaymentMethods){
        Set<Id> setAccountIds = new Set<Id>();
        Map<String, List<WrapCommunicatorEmail>> mapWrapSubscriptionEmail = new Map<String, List<WrapCommunicatorEmail>>();
        
        for(Zuora__PaymentMethod__c objPayment : lstPaymentMethods){
            setAccountIds.add(objPayment.Zuora__BillingAccount__r.Zuora__Account__r.Id);    
        }
        
        List<User> lstuser= new List<user>();
        set<string> setCountryLangCode = new set<string>();
            
        //get the list of users
        for(User oUser : [SELECT id, AccountId, ContactId, email, FirstName, Languagelocalekey, CountryCode FROM user WHERE AccountId In: setAccountIds AND isActive =True ]){
            lstuser.add(oUser);
            setCountryLangCode.add(oUser.CountryCode +'_'+ oUser.Languagelocalekey);
        }
        
        Map<string, List<User>> oMapPaymentExpiryUsers = new Map<string, List<User>>();
        List<User> lstUserByLang = null;
        for(string sCountryLangCode : setCountryLangCode){
            lstUserByLang = new List<User>();
            for(User oUser : lstUser){
               if(sCountryLangCode == (oUser.CountryCode+'_'+oUser.LanguageLocaleKey)){
                   lstUserByLang.add(oUser);
               }
            }
            if(lstUserByLang != null && !lstUserByLang.isEmpty()){
                oMapPaymentExpiryUsers.put(sCountryLangCode, lstUserByLang);
            }
        }
        
        if(oMapPaymentExpiryUsers != null && !oMapPaymentExpiryUsers.isEmpty() && !Test.isRunningTest()){
            CommunicatorIntegrationHelper.sendPaymentExpiryNotification(oMapPaymentExpiryUsers);
        }
        
        /*for(User objUser : lstPartnerUsers){
            WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
            
            //prepare wrapper object
            objWrap.Id        = objUser.AccountId;
            objWrap.ContactId = objUser.ContactId;
            objWrap.Email     = objUser.Email;
            objWrap.FirstName = objUser.FirstName;   
            objWrap.NotificationCountryCode = objUser.CountryCode; 
            objWrap.NotificaitonLanguageCode = objUser.Languagelocalekey; 

            List<WrapCommunicatorEmail> lstSubsEmails;
            if(mapWrapSubscriptionEmail.containsKey(objUser.Languagelocalekey)){
                lstSubsEmails = mapWrapSubscriptionEmail.get(objUser.Languagelocalekey);
            }else{
                lstSubsEmails = new List<WrapCommunicatorEmail>();
            }
            //add in the list of wrapper
            lstSubsEmails.add(objWrap);
            
            //populate the map
            mapWrapSubscriptionEmail.put(objUser.Languagelocalekey, lstSubsEmails);
        }*/
        
        //call the notification method
        //if(mapWrapSubscriptionEmail != null && !mapWrapSubscriptionEmail.isEmpty() && !Test.isRunningTest()){
          //  CommunicatorIntegrationHelper.sendPaymentExpiryNotification(mapWrapSubscriptionEmail);
        //}
    }    
      public static void sendInactiveDevicesNotification(list<Id> lstAccountId){   
       
        if(lstAccountId != null && !lstAccountId.isEmpty()){
            List<Account> lstAccount = new List<Account>();  
            set<string> setCountryLangCode = new set<string>();
            for(Account oAccount : [select id, PersonContactId, FirstName, PersonEmail, Notification_Language_Code__c, 
                                                                    Notification_Country_Code__c
                                                                    from Account
                                                                    where id in: lstAccountId]){
                lstAccount.add(oAccount);
                setCountryLangCode.add(oAccount.Notification_Country_Code__c+'_'+oAccount.Notification_Language_Code__c);
            }
            Map<string, List<WrapCommunicatorEmail>> oMapUserDevices = new Map<string, List<WrapCommunicatorEmail>>();
            List<WrapCommunicatorEmail> lstInactiveUserDevicesForEmail = null;
            WrapCommunicatorEmail oWrapUD = null;                
            for(String sCountryLangCode : setCountryLangCode){
                lstInactiveUserDevicesForEmail = new List<WrapCommunicatorEmail>();                   
                    for(Account oAcc : lstAccount){
                        if(sCountryLangCode == oAcc.Notification_Country_Code__c+'_'+oAcc.Notification_Language_Code__c){
                            oWrapUD = new WrapCommunicatorEmail();
                            oWrapUD.ID = oAcc.Id;
                            oWrapUD.ContactId = oAcc.PersonContactId;
                            oWrapUD.Email = oAcc.PersonEmail;
                            oWrapUD.FirstName = oAcc.FirstName;
                            //oWrapUD.DeviceName = oUserDevice.Device_Name__c;
                            oWrapUD.NotificationCountryCode = oAcc.Notification_Country_Code__c;
                            oWrapUD.NotificaitonLanguageCode = oAcc.Notification_Language_Code__c;
                            lstInactiveUserDevicesForEmail.add(oWrapUD);
                        }                    
                    }
                    if(lstInactiveUserDevicesForEmail != null && !lstInactiveUserDevicesForEmail.isEmpty()){
                        oMapUserDevices.put(sCountryLangCode, lstInactiveUserDevicesForEmail);
                    }
            }
            if(!Test.isRunningTest()){
                // Send email notification to user on new device sign-in.
                CommunicatorIntegrationHelper.sendInactiveDeviceNotification(oMapUserDevices);
            }
        }        
    }
}