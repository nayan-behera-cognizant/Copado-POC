/**
* @author Cognizant Technology Solutuions
* @date 30/03/2016
* @description Test class for UpsertAccountsInCommunicator batch job.
*/
@isTest
public class BatchUpsertAccountsInCommunicatorTest{
   /* public static String CRON_EXP = '0 0 1 * * ?';
    
    /*
        Description: Setup required data.
    
    @testSetup
    public static void setData(){
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
        system.assertnotequals(oAccount, null);
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true);
        system.assertnotequals(oUser , null);
    }

    @isTest
    public static void testUpsertAccountInCommunicatorBatch(){
        Test.startTest();

        // Schedule the test job
        String jobId = System.schedule('scheduleAccountUpsertInCommunicator', CRON_EXP, new scheduleAccountUpsertInCommunicator ());
         
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    } */
}