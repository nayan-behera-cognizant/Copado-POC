/**
    *  @author Megha Jain
    *  @date August 22, 2017
    *  @description Test class for DataStorageCleanUpScheduler and Batch class
       @Modification Log:        
    ------------------------------------------------------------------------------------        
    Developer                Mod Number       Date                Description        
    ------------------------------------------------------------------------------------        
    Megha Jain               -           August 22, 2017          Initial version created.
    */




@isTest
private class DataStorageCleanUpTest {
    
    
     public static void dataStorageCustomSetting() {
        List<DataStorageCleanUpObjectandLimits__c> config = new List<DataStorageCleanUpObjectandLimits__c>();
        config.add(new DataStorageCleanUpObjectandLimits__c(
            Name= 'Task',
            Number_Of_Months__c= 1
        ));
        config.add(new DataStorageCleanUpObjectandLimits__c(
           
            Name= 'Exception_Log__c',
            Number_Of_Months__c= 1
        ));
        config.add(new DataStorageCleanUpObjectandLimits__c(
            
            Name= 'DAZNUserFeed__c',
            Number_Of_Months__c= 1
        ));
        config.add(new DataStorageCleanUpObjectandLimits__c(
          
            Name= 'Pause_History__c',
            Number_Of_Months__c= 1
        ));
       
        insert config; 
    } 
    
    @testSetup
    public static void setup() {
      
        List<Task> tasks = new List<Task>();
        List<Pause_History__c> auditTrials = new List<Pause_History__c>();
        List<Exception_Log__c> logs = new List<Exception_Log__c>();
        List<DAZNUserFeed__c> feeds = new List<DAZNUserFeed__c>();

        for (Integer i=0; i < 10; i++) {
            Pause_History__c trial = new Pause_History__c ();
            trial.Name = 'testClass';
            
            auditTrials.add(trial);
        }
        insert auditTrials;
        
        Test.setCreatedDate(auditTrials[0].Id, Date.today().addMonths(-4));
        Test.setCreatedDate(auditTrials[1].Id, Date.today().addMonths(-4));
        
        for (Integer i=0; i < 10; i++) {
            Exception_Log__c exceptionLog = new Exception_Log__c();
            exceptionLog.Class_Name__c = 'testClass';
            exceptionLog.Exception_Message__c = 'Error ';
            logs.add(exceptionLog);
        }
        insert logs;
        
        Test.setCreatedDate(logs[0].Id, Date.today().addMonths(-4));
        Test.setCreatedDate(logs[1].Id, Date.today().addMonths(-4));
    }

    @isTest 
    static void testCleanUpDataStorage() {
        dataStorageCustomSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        List<Exception_Log__c > trials = [SELECT Id, CreatedDate FROM Exception_Log__c ];
        System.assertEquals(10, trials.size());
        Test.StartTest();
            System.RunAs(oUser){
                String CRON_EXP = '0 0 5 12 3 ? 2022';
                String jobId = System.schedule('DataStorageCleanUpSchedulerTest', CRON_EXP, new DataStorageCleanUpScheduler());
            }
        Test.StopTest(); 
        List<Exception_Log__c > trialsAfter = [SELECT Id FROM Exception_Log__c ];
        System.assert(trials.size() > 0);
    }
    
     @isTest 
    static void testException() {
        
         List<DataStorageCleanUpObjectandLimits__c> config = new List<DataStorageCleanUpObjectandLimits__c>();
        config.add(new DataStorageCleanUpObjectandLimits__c(
            Name= 'Task'
           
        ));
         insert config; 
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
       
      
        Test.StartTest();
            System.RunAs(oUser){
                String CRON_EXP = '0 0 5 12 3 ? 2022';
                String jobId = System.schedule('DataStorageCleanUpSchedulerTest', CRON_EXP, new DataStorageCleanUpScheduler());
            }
        Test.StopTest(); 
       
    }
   
}