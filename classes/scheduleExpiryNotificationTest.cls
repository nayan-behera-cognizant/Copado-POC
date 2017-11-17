@isTest
private class scheduleExpiryNotificationTest {
    
    // CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    static testmethod void test() {
        //User creation with System Admin profile (PD-7832)
        scheduleCancelSubscriptionBatchTest.testUser();
        list <User> listUser = [select id from User where firstname = : 'Test' AND IsActive = true limit 1];
        //Verify the size of the user list
        System.assertEquals(1, 
                            listUser.size() );
        System.runAs(listUser[0]){
            Test.startTest();
            
            // Schedule the test job
            String jobId = System.schedule('scheduleExpiryNotificationTest',
                                           CRON_EXP, 
                                           new scheduleExpiryNotification());
            
            // Get the information from the CronTrigger API object
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                              NextFireTime
                              FROM CronTrigger WHERE id = :jobId];
            
            // Verify the expressions are the same
            System.assertEquals(CRON_EXP, 
                                ct.CronExpression);
            
            // Verify the job has not run
            System.assertEquals(0, ct.TimesTriggered);
            
            // Verify the next time the job will run
            System.assertEquals('2022-03-15 00:00:00', 
                                String.valueOf(ct.NextFireTime));
            
            Test.stopTest();
        }
        
    }
}