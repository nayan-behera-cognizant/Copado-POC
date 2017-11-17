/*Changes made for system.assert*/
@isTest
public class ZAccountsSynchroniserTest{
    public static String CRON_EXP = '0 10 * * * ?';
    
    /*
Description: Setup required data.
*/
    @testSetup
    public static void setData(){
        
        // Add new Setup Test data for Pass this class to Fix Week one sf_refactoring   
        CreateTestDataforUnitTest.triggerSettings();
        CreateZuoraDataforUnitTest.createZuoraDeatils();
        CreateTestDataforUnitTest.createTestcustomsetting();
    }
    
    @isTest
    public static void testExpiryNotification(){
        // Added Account and user from new setup data 
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];
        system.RunAs(oUser[0])
        {
            Test.StartTest();
            
            // Schedule the test job
            String jobId = System.schedule('schClsForBatchzAccountSync', CRON_EXP, new schClsForBatchzAccountSync());
            System.assertnotEquals(jobId , null);
            // Get the information from the CronTrigger API object
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            
            // Verify the expressions are the same
            System.assertEquals(CRON_EXP, ct.CronExpression);
            
            // Verify the job has not run
            System.assertEquals(0, ct.TimesTriggered);
            
            Test.stopTest();   
        }
        
    }
}