/* @author Cognizant Technology Solutuions
 * @date 07/04/2016
 * Description : Batch class for Sending email to all Users - when the User Devices moves into Inactive List
 * 1. Get all InactiveDevices records created today and get their Account Id's (unique)
 * 2. Prepare Wrapper Data after iterating over respective accounts 
 * 3. Pass the Wrapper to CommunicatorIntegrationHelper 
*/

global class BatchForInactiveDevicesEmail implements Database.Batchable<sObject>,Database.stateful,Database.AllowsCallouts {
     /**
     * start - Method to retrive id and corresponding account id of Inactive_User_Devices__c based on the created date 
     *     > where created date is compared with the value that is updated in the custom setting(BatchForInactiveDevicesSuccess__c)
     *       field named  BatchJobSuccessTime__c 
     * 
     * @Param 1 - Database.BatchableContext 
     * 
     * @return -  Database.QueryLocator -  Returns the Query to execute method
     * */
    global Database.QueryLocator start(Database.BatchableContext bc ){
        BatchForInactiveDevicesSuccess__c lastBatchSuccessTime = BatchForInactiveDevicesSuccess__c.getValues('BatchForInactiveDevices');
        //Query all Inactive Devices created Today
        if(lastBatchSuccessTime!=null && lastBatchSuccessTime.BatchJobSuccessTime__c != null){            
            return Database.getQueryLocator([select id, Account__c from Inactive_User_Devices__c 
                                             where CreatedDate > :lastBatchSuccessTime.BatchJobSuccessTime__c ]);            
        }else{
            return Database.getQueryLocator([select id, Account__c from Inactive_User_Devices__c where CreatedDate = TODAY]);            
        }
    }
     /**
     * execute - In this method we will  
     *              > retriving the corresponding Accounts Ids based on the Inactive_User_Devices__c
     * 				> Preparing the oMapUserDevices from the corresponding account details and passing to 
     * 					CommunicatorIntegrationHelper.sendInactiveDeviceNotification 
     * 
     * 
     * @Param 1 - Database.BatchableContext and the list of inactive user devices 
     * 
     * @return -  void -  No Return type Applicable
     * */
    global void execute(Database.BatchableContext bc, List<Inactive_User_Devices__c> inactiveUDList){       
        final Set<Id> setOfAccountIds = new Set<Id>();
        String countryLangCode;
        final WrapCommunicatorEmail oWrapUD = new WrapCommunicatorEmail();
        final Map<string, List<WrapCommunicatorEmail>> oMapUserDevices = new Map<string, List<WrapCommunicatorEmail>>();
        for (Inactive_User_Devices__c oInactiveud :inactiveUDList){
            setOfAccountIds.add(oInactiveud.Account__c);
        } //end of For loop - adding the all account id
        for(Account acc : [Select Id, PersonContactId, PersonEmail, FirstName, Notification_Country_Code__c, Notification_Language_Code__c
                           From Account Where ID IN: setOfAccountIds AND Notification_Country_Code__c != null AND Notification_Language_Code__c != null]){
                               countryLangCode = acc.Notification_Country_Code__c+'_'+acc.Notification_Language_Code__c;                               
                               oWrapUD.ID = acc.Id;
                               oWrapUD.ContactId = acc.PersonContactId;
                               oWrapUD.Email = acc.PersonEmail;
                               oWrapUD.FirstName = acc.FirstName;
                               oWrapUD.NotificationCountryCode = acc.Notification_Country_Code__c;
                               oWrapUD.NotificaitonLanguageCode = acc.Notification_Language_Code__c;
                               
                               if(oMapUserDevices.containsKey(countryLangCode)){
                                   oMapUserDevices.get(countryLangCode).add(oWrapUD); 
                               } else {
                                   oMapUserDevices.put(countryLangCode,new List<WrapCommunicatorEmail>{oWrapUD}); 
                               }                    
                           }//end of For loop -over Accounts        
        if(oMapUserDevices.size() > 0){            
            CommunicatorIntegrationHelper.sendInactiveDeviceNotification(oMapUserDevices); 
        } //end of if - size check
    }
     /**
     * execute - This method is to update the custom settings(BatchForInactiveDevicesSuccess__c) with current date and time
     * 			 once the batch Status = 'Completed' by getting the query from  AsyncApexJob.
     *    
     * 
     * @Param 1 - Database.BatchableContext 
     * 
     * @return -  void -  No Return type Applicable
     * */
    global void finish(Database.BatchableContext bc){        
        try{
            AsyncApexJob asyncJob = [Select Id, Status,CompletedDate from AsyncApexJob where Id = :bc.getJobId() AND Status = 'Completed']; 
            List<BatchForInactiveDevicesSuccess__c> objBatchInactive = [SELECT Id, Name, BatchJobSuccessTime__c FROM BatchForInactiveDevicesSuccess__c WHERE Name ='BatchForInactiveDevices'];
            if(objBatchInactive != null && objBatchInactive.size()>0){
                objBatchInactive[0].BatchJobSuccessTime__c = asyncJob.CompletedDate;
                update objBatchInactive;
            }                
        }Catch(Exception ex){
            SendEmailWithErrorsToAdmins.sendEmail(ex.getMessage());            
        }                            
    }
}