/**
* The scheduledBatchInactiveDevicesEmailTest class implements improve the test coverage for scheduledBatchForInactiveDevicesEmail
* 
*
* @Author  		:Cognizant Technology Solutions
* @Base version :1.0
* @Date   		:August 23rd 2016
* ***********************Update History*****************************************
* Version		Updated By				CR #					Change Description					
*
*/
@IsTest
public class ScheduledBatchInactiveDevicesEmailTest{
    static testMethod void test() { //unit test method for schedulable class
        //User creation with System Admin profile (PD-7832)
        scheduleCancelSubscriptionBatchTest.testUser();
        list <User> listUser = [select id from User where firstname = : 'Test'  AND IsActive = true limit 1];
        //Verify the size of the user list
        System.assertEquals(1, 
                            listUser.size() );	
        System.runAs(listUser[0]){
            Test.StartTest();
            ScheduledBatchForInactiveDevicesEmail sbd = new ScheduledBatchForInactiveDevicesEmail();        
            String sch = '0 0 23 * * ?'; 
            //Schedule the test job
            String jobId = system.schedule('test', sch, sbd);	
               // Get the information from the CronTrigger API object
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                              NextFireTime
                              FROM CronTrigger WHERE id = :jobId];
            
            // Verify the expressions are the same
            System.assertEquals(sch, 
                                ct.CronExpression);
            
            // Verify the job has not run
            System.assertEquals(0, ct.TimesTriggered);
           
            Test.stopTest(); 
        }
    }
}