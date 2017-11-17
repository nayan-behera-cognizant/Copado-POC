@isTest
public class ScheduledUpdateAccountStatusTest {
    
    public static String CRON_EXP = '0 0 1 * * ?';
    static testMethod void scheduledUpdateAccountStatusTest() {
        TriggerSetting__c triggerSet1 = new TriggerSetting__c(name = 'BillingAccountTrigger', Disable__c = false);
        insert triggerSet1;
        TriggerSetting__c triggerSet2 = new TriggerSetting__c(name = 'UpdateAccountTrigger', Disable__c = false);
        insert triggerSet2;
        TriggerSetting__c triggerSet3 = new TriggerSetting__c(name = 'SubscriptionTrigger', Disable__c = false);
        insert triggerSet3;
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Cancelled', System.today(), system.today() + 30);
        zSubsp.Zuora__SubscriptionStartDate__c = Date.today().addDays(-30);
        zSubsp.Zuora__SubscriptionEndDate__c = system.today() + 2;
        zSubsp.CampaignID__c = 'TestCampaignID';
        zSubsp.Free_Trial_End_Date__c = Date.today().addDays(-30);
        zSubsp.Giftcode__c = 'TestGiftcode';
        zSubsp.Gift_Code_End_Date__c = system.today() + 2;
        zSubsp.NumGiftPeriods__c = '1';
        update zSubsp;
        
        Test.startTest();
            String jobId = System.schedule('scheduleUpdateAccountStatus', CRON_EXP, new ScheduledUpdateAccountStatus());
            // Get the information from the CronTrigger API object
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            // Verify the expressions are the same
            System.assertEquals(CRON_EXP, ct.CronExpression);
            // Verify the job has not run
            System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
        List<Account> accounts = [SELECT Id FROM Account WHERE Id =: oAccount.Id AND Account_Status__c = 'Active Paid' LIMIT 1];
        System.assertEquals(true, !accounts.isEmpty());
    }
    
}