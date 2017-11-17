/* @author Cognizant Technology Solutuions
 * @date 11/29/2016
 * Description : Batch class for create DFD accounts and DFD users from UserFeed object 
 * 1. Get all userfeed records where status is To be retried Num Retries is more than 1
 * 2. Insert the Accounts and Users  
*/
global class BatchToInsertDFDAccountsAndUsers implements Database.Batchable<sObject>,Database.stateful,Database.AllowsCallouts {
	 /**
     * start - userfeed records where status is To be retried Num Retries is more than 1
     *     
     * @Param 1 - Database.BatchableContext 
     * 
     * @return -  Database.QueryLocator -  Returns the Query to execute method
     * */
    global Database.QueryLocator start(Database.BatchableContext bc ){
        //List<DAZNUserFeed__c> allUsrFeedRecords = [Select id,Status__c,Email__c,UserId__c,AccountId__c,Num_Retries__c from DAZNUserFeed__c where Status__c = 'To be retried' AND Num_Retries__c >= 1 and Request_Type__c = 'Insert'];
        
        return Database.getQueryLocator([Select id,First_Name__c,Last_Name__c,BillingCountryCode__c,Email_Preferences__c,Secondary_Email__c,Account_Status__c,Partner_Registration_status__c,Partner_Id__c,
                                            CurrencyIsoCode,LanguageLocaleKey__c,EmailEncodingKey__c,LocaleSidKey__c,TimeZoneSidKey__c,Auth_Key__c,User_Type__c,
                                            CommunityNickname__c,Alias__c,Status__c,Email__c,UserId__c,AccountId__c,Num_Retries__c,Request_Type__c,IP_address__c,DAZN_Id__c,Account_Type__c,ViewerId__c, Subscription_Start_Date__c, Subscription_End_Date__c
                                            from DAZNUserFeed__c where DAZN_Id__c !=null AND ViewerId__c != null AND Num_Retries__c >=1 AND Status__c ='To be retried' ]);
    }
     /**
     * execute - This method is used to insert the Accounts and Users 
     * 
     * @Param 1 - Database.BatchableContext and the list of userfeed records 
     * 
     * @return -  void -  No Return type Applicable
     * */
    global void execute(Database.BatchableContext bc, List<DAZNUserFeed__c> userFeedRecordsList){  
        //system.debug('=====>11');
        DFDUserFeedHandler.prepareAccountsToInsert(userFeedRecordsList);
        //system.debug('<<<<=====>11');
    }
    
    global void finish(Database.BatchableContext bc){   
        
    }
}