/**
* The SendEmailWithErrorsToAdmins class implements system admin to notify the exact error message
* 
*
* @Author  		:Cognizant Technology Solutions
* @Base version :1.0
* @Date   		:August 23rd 2016
* ***********************Update History*****************************************
* Version		Updated By				CR #					Change Description					
*
*/
    public class SendEmailWithErrorsToAdmins {
     /*
        Description : This method implements send notification emails to system admin
    */
    Public Static PageReference sendEmail(String errorMessage){          
        List<EmailNotification__c> listEmailNotification = EmailNotification__c.getall().values();
        List <Id> targetObjectIds = new List <Id> ();
        List <user> targetObjects = new List <user> ();
        
        List<String> listEmails = new List<String>();
        if(listEmailNotification != null){
            for(EmailNotification__c stng : listEmailNotification){ 
                if(stng.Email__c != null){
                    listEmails.add(stng.Email__c);
                }//end of if - null check
            }//end of For loop - over custom setting values 
        }//end of if - null check
        
        targetObjects = [SELECT Id FROM User WHERE email in :listEmails and IsActive = True and Profile.Name = 'System Administrator'];
        for(User usr : targetObjects){
            targetObjectIds.add(usr.Id);
        }
        Messaging.SingleEmailMessage[] mail = new Messaging.SingleEmailMessage[]{} ;  
            //Iterating over User ids if more than one user is needed to be notified through mail
            for( Id targetId :targetObjectIds){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setSaveAsActivity(false);
                email.setTargetObjectId(targetId);
                email.setSubject('Email Exception Notifications');
                email.setHtmlBody(errorMessage);
                mail.add(email);  
            }
        if(mail!=null && mail.size()>0){
        Messaging.sendEmail(mail);
        }
        return null;
    }
    
}