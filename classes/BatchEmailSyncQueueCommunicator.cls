/**
* @author Cognizant Technology Solutuions
* @date 22/03/2017
* @description Batch Class searches for the Email_Sync_Queue__c records and then send info from these records to Communicator.
*/
global class BatchEmailSyncQueueCommunicator implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {

    private static final String SCHEDULER_NAME = 'BatchEmailSyncQueueCommunicator';
    public String sQuery;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        sQuery = 'SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c, Rebill_Date__c, Email_Name__c, Gift_Code_Expiry_Date__c, ';
        sQuery += 'Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c, Sync_Error_Msg__c, Term_Setting_Type__c, ';
        sQuery += 'Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c, Pause_From__c, Pause_Until__c, ';
        sQuery += 'Account__r.Previous_Status__c, Account__r.Status_Change_Date__c ';
        sQuery += 'FROM Email_Sync_Queue__c ';
        sQuery += 'WHERE Status__c = \'Not Started\' OR Status__c = \'Retried\' ';
        sQuery += 'ORDER BY CreatedDate ASC LIMIT ' + getBatchSizeLimit(); // LIMIT 1000 by default. It is configured in 'Batch Size Email Queue' DAZNConfiguration__c
        return Database.getQueryLocator(sQuery);
    }

    global void execute(Database.BatchableContext BC, List<Email_Sync_Queue__c> scope) {
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        for (Email_Sync_Queue__c emailSyncQueue : scope) {
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        if (!Test.isRunningTest()) {
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        }
    }

    global void finish(Database.BatchableContext BC) {
        
    }

    global void execute(SchedulableContext SC) {
        BatchEmailSyncQueueCommunicator emailSyncBatch  = new BatchEmailSyncQueueCommunicator();
        Id batchProcessId = Database.executeBatch(emailSyncBatch, 200);
    }
    
    /**
    * Invoking start method for BatchEmailSyncQueueCommunicator Scheduler in Every 5 Mins
    */
    public static void startJob() {
        Set<String> intervals = new Set<String>{'00', '05', '10', '15', '20', '25', '30', '35', '40', '45', '50', '55'};
        for (String min : intervals) {
            String scheduleExpression = ('0 ' + min + ' * * * ?');
            String postfixForTestContext = (Test.isRunningTest()) ? 'Test' : '';
            System.schedule(SCHEDULER_NAME + postfixForTestContext + ' - ' + min, scheduleExpression, new BatchEmailSyncQueueCommunicator());
        }
    }
    
    /**
    * Methods gets limit size value from 'Batch Size Email Queue' DAZNConfiguration__c
    */
    public static String getBatchSizeLimit() {
        String limitString = '1000'; // by default
        DAZNConfiguration__c configBatchSize = DAZNConfiguration__c.getValues('Batch Size Email Queue');
        String limitBatchSize = configBatchSize != null ? configBatchSize.Value__c : null;
        if (limitBatchSize != null) {
            try {
                Integer numberLimit = Integer.valueOf(limitBatchSize);
                limitString = String.valueOf(numberLimit);
            } catch (Exception e) {
                System.debug('\nERROR: ' + e.getMessage() + '\nSTACK TRACE: ' + e.getStackTraceString());
            }
        }
        return limitString;
    }

}