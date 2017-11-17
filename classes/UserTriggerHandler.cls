/****************************************************************************************************
* @author Cognizant Technology Solutuions
* @date 11/02/2016
* @description User TriggerHandler class - helper class for the User Trigger
History
================
Version     Date            Author                  Reason
-------     ----------      ------------------      ------------------
1.0         11/02/2016       CTS                     Initial version
1.1         15/10/2016       Manjula                 Code Optimization for Ticket PD-7858   
******************************************************************************************************/
public class UserTriggerHandler {
  public static Time startingDateTimeValue; // Added code part of the PD-10362
  public static Boolean isTest = false;
    /******************************************************************************
@Method Name: userNotificationLanguage
@Method Description: This method assigns the user language
******************************************************************************/
    public static void userNotificationLanguage(List<User> newUser){
        for(User u : newUser) {           
            if(u.LanguageLocaleKey != null){
                u.Notification_Language_Code__c = u.LanguageLocaleKey;
            }            
        }                       
    }
    
    /*********************************************************************************************
@Method Name: sendUpdateToOldEmail
@Method Description: This method sends mail to Old email Id of an User once the Email Changes
*********************************************************************************************/
    public static void sendUpdateToOldEmail(Map<Id,User> oldUsers, Map<Id,User> newUsers){
        Map<Id, User> listChangedEmails = new Map<Id, User> ();
        Map<Id, String> newEmails = new Map<Id, String> ();
        Map<Id, User> listChangedEmailsOldEmail = new Map<Id, User> ();
        Map<String,EmailTemplate> listTemplates = new Map<String,EmailTemplate>();
        Set<Id> usersId = new Set<Id>();
        for(User oUser : newUsers.values()){
            if(oUser.IsPortalEnabled){
                //find how many user's emails have changed
                if(!oUser.Email.contains('anonymous') && (oldUsers.get(oUser.Id).Email <> newUsers.get(oUser.Id).Email) ){
                     // modified if condition as per PD-11920
                    if(!(oUser.Account.Disable_Email_change_emails__c ||oUser.Account.Disable_transactional_emails__c)){
                    listChangedEmails.put(oUser.Id, oUser);
                    newEmails.put(oUser.Id, oUser.Email);
                    }
                    }
                
                if (oldUsers.get(oUser.Id).CountryCode != newUsers.get(oUser.Id).CountryCode) {
                    usersId.add(oUser.Id);
                }
            }
        } 
        if (!usersId.isEmpty()) {
            updateAccount(usersId);
        }
        for(User oUser : oldUsers.values()){
            if(oUser.IsPortalEnabled){
                //find how many user's emails have changed
                
                if(!newUsers.get(oUser.Id).Email.contains('anonymous') && (oldUsers.get(oUser.Id).Email <> newUsers.get(oUser.Id).Email) ){
                     // modified if condition as per PD-11920
                    if(!(oUser.Account.Disable_Email_change_emails__c ||oUser.Account.Disable_transactional_emails__c)){
                    listChangedEmailsOldEmail.put(oUser.Id, oUser);
                    }
                    }
            }
        } 
        /*Start 9179*/
        Boolean isSend = true;
        if (CommunityHelper.IsDfDUser()) {
            Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
            if (!CommunityHelper.checkSendEmailForAccount()) {
                isSend = false;
            }
        } 		
        /*End 9179*/
        //check size of Map
        if(listChangedEmails.size()>0){
            
            listTemplates = getLanguageLocaleCodesAndEmailTemplates(listChangedEmails);
            if (isSend) {
                sendEmail(listChangedEmails,listTemplates);
            }
        }
        
        //check size of Map
        if(listChangedEmailsOldEmail.size()>0){
            
            listTemplates = getLanguageLocaleCodesAndEmailTemplatesOLdEmail(listChangedEmailsOldEmail);
            if (isSend) {
                sendEmailOldEmail(listChangedEmailsOldEmail,listTemplates,newEmails);
            }
        }
        
    }

    @future
    public static void updateAccount(Set<Id> userId) {
        
        List<Account> lstAcc = new List<Account>();
        List<User> userLst = [SELECT Id, AccountId , CountryCode, Country FROM User WHERE Id IN :userId ];
               
        Map<Id, User> mapUserByAccountId = new Map<Id, User>();
        for(User objUser : userLst){
            mapUserByAccountId.put(objUser.AccountId, objUser);
        }               
        
        lstAcc = [SELECT Id, Notification_Country_Code__c, BillingCountry FROM Account WHERE Id IN :mapUserByAccountId.keySet()];
        if (!lstAcc.isEmpty()) {
            for(Account account : lstAcc) {
                account.Notification_Country_Code__c = mapUserByAccountId.get(account.Id).CountryCode;
                account.BillingCountry = mapUserByAccountId.get(account.Id).Country;
            }

            update lstAcc;
        }
                    
    }
    
    /*************************************************************************************************
@Method Name: getLanguageLocaleCodesAndEmailTemplates
@Method Description: This method returns the template which is to be sent to updated Email Address.
@Param: Map<String,EmailTemplate>    
**************************************************************************************************/
    private static Map<String,EmailTemplate> getLanguageLocaleCodesAndEmailTemplates(Map<Id, User> listChangedEmails){
        
        Map<String,EmailTemplate> listTemplates = new Map<String,EmailTemplate>();
        
        for(Id userId: listChangedEmails.keySet()){
            User user = listChangedEmails.get(userId);
            listTemplates.put('Updated_Email_Address_'+user.CountryCode+'_'+user.LanguageLocaleKey.subString(0,2),null);
        }
        List<EmailTemplate>  emailTemplates = [Select Id,DeveloperName, Body, HtmlValue, Subject 
                                                from EmailTemplate 
                                                where DeveloperName 
                                                    in :listTemplates.keySet()];
        for(EmailTemplate temp: emailTemplates){
            listTemplates.put(temp.DeveloperName, temp);
        }		
        if(!listTemplates.isEmpty()){
            return listTemplates;
        }else{
            return null;
        }
        
    }
    
    /*************************************************************************************************
@Method Name: getLanguageLocaleCodesAndEmailTemplatesOLdEmail
@Method Description: This method returns the template which is to be sent to old Email Address.
@Param: Map<String,EmailTemplate>    
**************************************************************************************************/
    private static Map<String,EmailTemplate> getLanguageLocaleCodesAndEmailTemplatesOLdEmail(Map<Id, User> listChangedEmailsOldEmail){                   
        Map<String,EmailTemplate> listTemplates = new Map<String,EmailTemplate>();
        List<EmailTemplate>  emailTemplates = new List<EmailTemplate>();
        
        for(Id userId: listChangedEmailsOldEmail.keySet()){
            User user = listChangedEmailsOldEmail.get(userId);
            listTemplates.put('Updated_Email_Address_'+user.CountryCode+'_'+user.LanguageLocaleKey.subString(0,2)+'_Old_Email_Address',null);
        }		
        if(!listTemplates.isEmpty()){
            emailTemplates = [Select Id,DeveloperName, Body, HtmlValue, Subject 
                                from EmailTemplate 
                                where DeveloperName 
                                    in :listTemplates.keySet()];
        }		
        for(EmailTemplate temp: emailTemplates){
            listTemplates.put(temp.DeveloperName, temp);
        }		
        if(!listTemplates.isEmpty()){
            return listTemplates;
        }else{
            return null;
        }
    }
    
    /***********************************************************************************
@Method Name: sendEmail
@Method Description: This method is used to send the email to updated Email address.
***********************************************************************************/
    private static void sendEmail(Map<Id, User> listChangedEmails,Map<String,EmailTemplate> listTemplates){            
        Messaging.SingleEmailMessage[] mail = new Messaging.SingleEmailMessage[]{} ;
            EmailTemplate template ;
        String environment = (DAZNConfiguration__c.getValues('LinkToDAZN') != null) ? DAZNConfiguration__c.getValues('LinkToDAZN').Value__c : null;

        for(User user:listChangedEmails.values()){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            template = listTemplates.get('Updated_Email_Address_'+user.CountryCode+'_'+user.LanguageLocaleKey.subString(0,2));
            if(template!=null){
                email.setToAddresses(new String[]{user.Email});
                email.setSaveAsActivity(false);
                email.setTargetObjectId(user.Id);//Added this line as a part of PD-12028
                for(OrgWideEmailAddress owa : [select id, Address, DisplayName 
                                                from OrgWideEmailAddress 
                                                limit 1]) 
                {
                    email.setOrgWideEmailAddressId(owa.id); 					
                }
                email.setSubject(template.Subject);
                String htmlBody = template.HtmlValue;
                htmlBody = htmlBody.replace('{!Target_User.FirstName}',user.FirstName);
                htmlBody = htmlBody.replace('{!Target_User.CountryCode}',user.CountryCode);
                htmlBody = htmlBody.replace('{!Target_User.Email}',user.Email);
                htmlBody = htmlBody.replace('{!Target_Environment}', environment);
                email.setHtmlBody(htmlBody);				
                mail.add(email); 
            }			
            if(Test.isRunningTest()){
                email.setToAddresses(new String[]{user.Email});
                email.setSaveAsActivity(false);
                email.setSubject('test subject');
                email.setHtmlBody('test body');
                mail.add(email); 
            }			
        }
        List<Messaging.SendEmailResult> results;	   
        if(mail!=null && mail.size()>0){
            results = Messaging.sendEmail(mail);
        }
        
    }
    
    /******************************************************************************
@Method Name: sendEmailOldEmail
@Method Description: This method is used to send the email to old Email address.
*******************************************************************************/
    private static void sendEmailOldEmail(Map<Id, User> listChangedEmailsOldEmail,Map<String,EmailTemplate> listTemplates, Map<Id, String> newEmail){            
        Messaging.SingleEmailMessage[] mail = new Messaging.SingleEmailMessage[]{} ;
            EmailTemplate templateOldEmail ;
        String environment = (DAZNConfiguration__c.getValues('LinkToDAZN') != null) ? DAZNConfiguration__c.getValues('LinkToDAZN').Value__c : null;
        Integer email_Left = Limits.getLimitEmailInvocations() - Limits.getEmailInvocations();
        for(User user:listChangedEmailsOldEmail.values()){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            templateOldEmail = listTemplates.get('Updated_Email_Address_'
                                + user.CountryCode 
                                + '_'
                                + user.LanguageLocaleKey.subString(0,2) 
                                + '_Old_Email_Address');
            if(templateOldEmail!=null){
                email.setToAddresses(new String[]{user.Email});
                email.setSaveAsActivity(false);
                for(OrgWideEmailAddress owa : [select id, Address, DisplayName 
                                                from OrgWideEmailAddress 
                                                limit 1]) 
                {				   
                    email.setOrgWideEmailAddressId(owa.id); 					
                }
                email.setSubject(templateOldEmail.Subject);
                String htmlBody = templateOldEmail.HtmlValue;
                htmlBody = htmlBody.replace('{!Target_User.FirstName}',user.FirstName);
                htmlBody = htmlBody.replace('{!Target_User.CountryCode}',user.CountryCode);
                htmlBody = htmlBody.replace('{!Target_User.Email}',newEmail.get(user.Id));
                htmlBody = htmlBody.replace('{!Target_Environment}', environment);
                email.setHtmlBody(htmlBody);				
                mail.add(email); 
            }			
            if(Test.isRunningTest()){
                email.setToAddresses(new String[]{user.Email});
                email.setSaveAsActivity(false);
                email.setSubject('test subject');				
                email.setHtmlBody('test body');				
                mail.add(email); 
            }			
        }
        List<Messaging.SendEmailResult> results;
        
        if(email_Left > 0 && !isTest){
            if(mail!=null && mail.size()>0){
                results = Messaging.sendEmail(mail); 
            } 
        }
        else{
            string errorMessage = 'Email Limit Exceeded';				
            SendEmailWithErrorsToAdmins.sendEmail(errorMessage);
        }
    }
    
    /********************************************************************************************
@Method Name: updateAccount
@Method Description: Future Method to update User with Country code and Language Code update.
*********************************************************************************************/
  //Commented as part of PD-11813
    /* @future
    public static void updateAccount(Set<Id> userId){
        //checking whether this object have DML permissions and checking field level security for this profile
        if(schema.SObjectType.Account.isAccessible() && schema.SObjectType.Account.isUpdateable() &&
           schema.SObjectType.Account.fields.Notification_Country_Code__c.isUpdateable() && schema.SObjectType.Account.fields.Notification_Language_Code__c.isUpdateable()){
               List<Account> lstAcc= new List<Account>();
               List<Account> lstUpdatedAcc= new List<Account>();
               List<User> userLst = [Select id,AccountId ,CountryCode,
                                     LanguageLocaleKey 
                                     from User 
                                     where Id IN:userId ];
               Map<Id , User> mapUserByAccountId = new Map<Id, User>();
               for(User objUser : userLst){
                   mapUserByAccountId.put(objUser.AccountId, objUser);
               }			   
               lstAcc = [Select Id, Notification_Country_Code__c, Notification_Language_Code__c  
                            from Account 
                            where Id in :mapUserByAccountId.keySet()];
               for(Account account : lstAcc)
               {
                   account.Notification_Country_Code__c = mapUserByAccountId.get(account.Id).CountryCode;
                   account.Notification_Language_Code__c = mapUserByAccountId.get(account.Id).LanguageLocaleKey;
                   lstUpdatedAcc.add(account);
               }
               try{
                   if(!lstUpdatedAcc.isEmpty()){
                       update lstUpdatedAcc;
                   }
               }catch(Exception ex){
                   ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'UserTriggerHandler', 'updateAccount', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
                   string errorMessage = 'Double Optin is Unsuccessful';				
                   SendEmailWithErrorsToAdmins.sendEmail(errorMessage);
                   CommunityHelper.redirectToErrorPage(errorMessage);
               }
           }else{
               //if this user doest have permition to update then notify the same to system admin  
               String strError = 'Error faced while update :'
                +' User Id :'+UserInfo.getUserID();
               SendEmailWithErrorsToAdmins.sendEmail(strError);
           }
        
    }*/
    
  // Ended code part of the PD-10362

    /*Add code as part of the PD-9770*/
    public static boolean run = true;
    
    public static boolean runOnce() {
        if(run) {
            if (!Test.isRunningTest()) {
                run=false;
            }
            return true;
        } else{
            return run;
        }
    }
    /*Ended code as part of the PD-9770*/
    
}