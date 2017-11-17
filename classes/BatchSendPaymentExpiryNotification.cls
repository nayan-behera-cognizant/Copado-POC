/*
    Description : Batch Class to send emails to users before the Payment expiry date
    Author      : Cognizant 
*/
global class BatchSendPaymentExpiryNotification implements Database.Batchable<sObject>, Database.AllowsCallouts{
    String query;
    global Database.QueryLocator start(Database.BatchableContext bc){
         DateTime emailTriggerDate = System.now().addDays(-1);
         String expMonth = String.ValueOf(emailTriggerDate.Month());   //'8';   
         String expYear  = String.valueOf(emailTriggerDate.Year());    //'2018'; 
         query = 'SELECT id, Zuora__BillingAccount__r.Zuora__Account__r.Id, Zuora__CreditCardExpirationMonth__c, Zuora__CreditCardExpirationYear__c, Zuora__Type__c FROM Zuora__PaymentMethod__c ';  
         query += 'WHERE Zuora__DefaultPaymentMethod__c = true AND '; 
         query +=  'Zuora__Type__c =\'CreditCard\' AND ';
         query += 'Zuora__CreditCardExpirationMonth__c =\'' + expMonth +'\' AND ';
         query += 'Zuora__CreditCardExpirationYear__c  =\'' + expYear+ '\'';     
         
         //query to get the accounts for which the payment expiry notifications has to be sent
         return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        //call the method from the communicator helper to send the email 
        EmailHelper.SendPaymentExpiryNotification(scope);
    }
    
    global void finish(Database.BatchableContext BC){
        //send email in case of failure
    }

}