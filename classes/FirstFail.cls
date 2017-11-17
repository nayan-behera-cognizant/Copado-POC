@RestResource(urlMapping='/FirstFail/*')
global class FirstFail {
    
    @HttpPost  
    global static String newSubscriptionPost() {
        String accountID;
        String requestString;
        UpdateAccount updateAccount;
         
        updateAccount = new UpdateAccount();
        RestRequest req = RestContext.request;
        requestString = req.requestBody.toString();
        accountID = updateAccount.getAccountId(requestString);
        
       
            updateAccount.processFirstTrial(accountID);
            createPaymentFailedEmailQueueRecords(accountID);
        
        return accountID;
    }
    
    /*
        PD-12533: Description: Method creates Email Sync Queue records for further send email notification to user from communicator when Payment Failed
    */
    public static void createPaymentFailedEmailQueueRecords(String accountId) {
        List<Zuora__CustomerAccount__c> anAccount = [
            SELECT Id, Name, Zuora__Account__c, Zuora__Account__r.Type, Zuora__Account__r.Notification_Country_Code__c, 
                Zuora__Account__r.Notification_Language_Code__c, Zuora__Account__r.PersonEmail, Zuora__Account__r.Disable_transactional_emails__c
            FROM Zuora__CustomerAccount__c
            WHERE Zuora__Zuora_Id__c = :accountId.trim() LIMIT 1
        ];
        if (!anAccount.isEmpty() && !anAccount[0].Zuora__Account__r.Disable_transactional_emails__c) {
            Email_Sync_Queue__c triggeredDispatchEmailQueue = new Email_Sync_Queue__c(
                Account__c = anAccount[0].Zuora__Account__c,
                Account_Status__c = 'Active Grace',
                Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Payment_Failure').Value__c),
                Notification_Country_Code__c = anAccount[0].Zuora__Account__r.Notification_Country_Code__c,
                Notification_Language_Code__c = anAccount[0].Zuora__Account__r.Notification_Language_Code__c,
                Person_Email__c = anAccount[0].Zuora__Account__r.PersonEmail,
                Status__c = 'Not Started',
                Type_of_Email__c = 'Triggered Dispatch',
                Unsubscribe_Language__c = anAccount[0].Zuora__Account__r.Notification_Language_Code__c,
                Email_Name__c = 'Payment Failed'
            );
            insert triggeredDispatchEmailQueue;
        }
    }

}