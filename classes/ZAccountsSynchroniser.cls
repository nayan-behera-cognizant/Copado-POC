/**
* @author Cognizant Technology Solutuions
* @date 04/25/2016
* @description Schedule class to update account information in zuora.
*/
global class ZAccountsSynchroniser implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    global String query ;
    global Map<Id, Account> mapAccounts ;
    global Map<String,Account> mapAccountsforZuora ;
    global List<Zuora__CustomerAccount__c> zBillingAccounts;
    global Database.QueryLocator start(Database.BatchableContext BC){
        query = 'SELECT id,Name,FirstName,LastName,PersonEmail from Account WHERE IsReadyToSyncInZuora__c = True LIMIT 50'; 
        return Database.getQueryLocator(query);
        
    }
    
    /*
        Description: - execute method for the Batch job, extracts Accounts, finds billing accounts and updates them in Zuora
                       mark the flag of sync to true in salesforce 
    */ 
    global void execute(Database.BatchableContext BC, List<Account> scope){
        
        mapAccounts = new Map<Id, Account>();
         mapAccountsforZuora = new Map<String,Account>();
        for ( Account acc : scope ){
            mapAccounts.put( acc.id, acc );
        }
        if(mapAccounts!=null && !mapAccounts.isEmpty()){
            zBillingAccounts =  [SELECT Zuora__Account__c,Zuora__External_Id__c,Zuora__Zuora_Id__c FROM Zuora__CustomerAccount__c where Zuora__Account__c IN :mapAccounts.keySet()];
            if(zBillingAccounts!=null && !zBillingAccounts.isEmpty()){  
                for (Zuora__CustomerAccount__c zuoCustAcct : zBillingAccounts){
                    mapAccountsforZuora.put(string.valueof(zuoCustAcct.Zuora__Zuora_Id__c),mapAccounts.get(string.valueof(zuoCustAcct.Zuora__Account__c)));
                }
               ZuoraTransactionHelper.updateUserDetailsinZuora(zBillingAccounts,mapAccountsforZuora);
            }
        }
    }
    global void finish(Database.BatchableContext BC){
    }
}