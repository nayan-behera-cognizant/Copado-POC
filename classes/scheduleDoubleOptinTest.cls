@isTest
private class scheduleDoubleOptinTest {
    
 /*   // CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
     @testSetup
    public static void testUser(){
        CreateTestDataforUnitTest.triggerSettings();
        //creating a user with a Profile System Admin  
        list<Profile> pList = [SELECT id, Name FROM Profile where name = 'System Administrator'  limit 1 ];
        
        //verify the size of the profile list
        System.assertEquals(1, 
                            pList.size() );
        
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId;
        uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
        list<User> alistUser =new list<User>();
        User aUser =new User(  firstname = 'Test',
                             lastName = 'Admin'+uniqueName,
                             email = 'TestAdmin'+uniqueName + '@test' +'.com',
                             Username = 'TestAdmin' + uniqueName+'@test'+ '.org',
                             EmailEncodingKey = 'ISO-8859-1',
                             Alias = 'Admin',
                             TimeZoneSidKey = 'America/Los_Angeles', 
                             LocaleSidKey = 'en_US',
                             LanguageLocaleKey = 'en_US',
                             IsActive = true,
                             ProfileId = pList[0].id  );
        alistUser.add(aUser);
        insert alistUser;
        //Verify the size of the user list
        System.assertEquals(1, 
                            alistUser.size() );     
    }
    static testmethod void test() {
        
        list <User> listUser = [select id from User where firstname = : 'Test' AND IsActive = true limit 1];
        //Verify the size of the user list
        System.assertEquals(1, 
                            listUser.size() );
        System.runAs(listUser[0]){
            Test.startTest();
            
            // Schedule the test job
            String jobId = System.schedule('scheduleDoubleOptinTest',
                                           CRON_EXP, 
                                           new scheduleDoubleOptin());
            
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
        
    }*/
}