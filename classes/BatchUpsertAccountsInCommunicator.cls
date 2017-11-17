/**
* @author Cognizant Technology Solutuions
* @date 18/04/2016
* @description Batch Class to update communicator with the updated accounts in salesforce.
*/
global class BatchUpsertAccountsInCommunicator implements Database.Batchable<sObject>, Database.AllowsCallouts{
    String sQuery;
    global Database.QueryLocator start(Database.BatchableContext bc){
        /*sQuery = 'SELECT Id, PersonEmail,FirstName,LastName,Type,Account_Status__c,Is_Double_OptIn__c,Notification_Language_Code__c,Notification_Country_Code__c,Hard_Offer_date__c,';
        sQuery += 'All_Email_Preferences__c FROM Account ';  
        sQuery += 'WHERE IsReadyToSyncInCommunicator__c = true AND Type != \'Docomo\''; 
        */
        //query to get the accounts information which needs to be updated in communicator.
        return Database.getQueryLocator(sQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('scope===>'+scope);
        if(!Test.isRunningTest()){
            //CommunicatorIntegrationHelper.upsertAccountInformationInCommunicator(scope);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}