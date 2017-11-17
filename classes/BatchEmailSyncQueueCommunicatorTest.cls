@isTest
public class BatchEmailSyncQueueCommunicatorTest {

    public static String CRON_EXP = '0 0 1 * * ?';

    /*
        Description: Setup required data.
    */
    @testSetup
    public static void setData() {
        SetUpTestData.triggerSettings();

        List<DAZNCommunicatorConfig__c> lstCustomSetting = new List<DAZNCommunicatorConfig__c>();
        List<DAZNConfiguration__c> lstConfig = new List<DAZNConfiguration__c>();

        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'test.salesforce.com');
        SetUpTestData.testCreateDAZNConfiguration('EncryptionKey', '160ab450f9c22gb1');
        SetUpTestData.testCreateDAZNConfiguration('CommunicatorAPIUserName', 'test');
        SetUpTestData.testCreateDAZNConfiguration('CommunicatorAPIUserPwd', 'oL9IBIKPqWGSvVXHuhKawxjDx/PhfrWZGHjsKrMA/J8=');

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
        oAccount.Account_Status__c = 'Partial';
        update oAccount;
        system.assertnotequals(oAccount, null);

        Account oAccount2 = SetUpTestData.createPersonAccount('TestFirstName2', 'TestLastName2','test2@test2.com','Active Paid');
        oAccount2.LastName = 'TestLastName3';
        update oAccount2;

        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.PersonEmail = 'test@test.com' LIMIT 1
        ];
        System.assertEquals(true, !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        List<Email_Sync_Queue__c> emailSyncQueues2 = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName3' LIMIT 1
        ];
        System.assertEquals(true, !emailSyncQueues2.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method

        DAZNCommunicatorConfig__c commConf = new DAZNCommunicatorConfig__c(Name = 'DispatchID Double optin', Value__c = 12345);
        insert commConf;
        if (!emailSyncQueues2.isEmpty()) {
            emailSyncQueues2[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID Double optin').Value__c);
            emailSyncQueues2[0].Type_of_Email__c = 'Triggered Dispatch';
            update emailSyncQueues2[0];
        }

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true);
        system.assertnotequals(oUser , null);
    }

    @isTest
    public static void testBatchEmailSyncQueueCommunicatorScheduler() {
        Test.startTest();
            BatchEmailSyncQueueCommunicator.startJob();
        Test.stopTest();
    }

    @isTest
    public static void testGetBatchSizeLimit() {
        DAZNConfiguration__c configBatchSize = new DAZNConfiguration__c(Name = 'Batch Size Email Queue', Value__c = '2000');
        insert configBatchSize;
        Test.startTest();
            String limitString = BatchEmailSyncQueueCommunicator.getBatchSizeLimit();
        Test.stopTest();
        System.assertEquals('2000' , limitString);
    }

    @isTest
    public static void testGetBatchSizeLimitException() {
        DAZNConfiguration__c configBatchSize = new DAZNConfiguration__c(Name = 'Batch Size Email Queue', Value__c = 'IncorrectValue');
        insert configBatchSize;
        Test.startTest();
            String limitString = BatchEmailSyncQueueCommunicator.getBatchSizeLimit();
        Test.stopTest();
        System.assertEquals('1000' , limitString);
    }

    @isTest
    public static void testBatchEmailSyncQueueCommunicatorSchedulerWithCronExp() {
        User currentUser = [SELECT Id FROM User WHERE id =: UserInfo.getUserId()];
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('scheduleBatchEmailSyncQueueCommunicator', CRON_EXP, new BatchEmailSyncQueueCommunicator());
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        //Test.stopTest();
    }

}