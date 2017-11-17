/**
* @author Cognizant Technology Solutuions
* @date 11/30/2016
* @description Test class to cover insertion and updation of batch of DFD Accounts and Users details.
*/

@istest
public class BatchToInsertDFDAccountsAndUsersTest {
    @testSetup /*  calling CreateTestDataforUnitTest */  
    public static void getCommunityUsersTestData(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestcustomsetting();
        CreateTestDataforUnitTest.createTestUserDevices();
    }
    public static List<DAZNUserFeed__c> userdetailslist=new List<DAZNUserFeed__c>();
    //test method to insert the batch
    static testmethod void testInsertBatch(){
         //System.debug('Method Inside');
        List<Profile> profile=[select Id,Name from profile where Name='External User' limit 1];
        //System.debug('profile'+profile );
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=True limit 1];
        System.debug('oUser '+oUser );
        system.assertNotEquals(null, oUser);
        DocomoConfiguration__c custmstng = new DocomoConfiguration__c();
        custmstng.Name = 'Default Password';
        custmstng.Value__c = 'cGFzNzg5dzByZA==';
        insert custmstng;
        System.RunAs(oUser[0]){
        Test.startTest();
        List<DAZNUserFeed__c> userupdatelist= CreateTestDataforUnitTest.createTestDFDUserFeedRecordsBulk(50);
        //System.debug('userupdatelist'+userupdatelist);
        List<DAZNUserFeed__c> updateDFDUserlist = new List<DAZNUserFeed__c>(); 
        database.Insert (userupdatelist);
        system.assert(userupdatelist.size()>=49);
        List<DAZNUserFeed__c> lstuservalues = [Select id,Status__c,Email__c,UserId__c,AccountId__c,Num_Retries__c,Auth_Key__c,ViewerId__c, IP_address__c from DAZNUserFeed__c Where Id in:userupdatelist];
        //System.debug('lstuservalues '+lstuservalues );
           
        for(DAZNUserFeed__c userfeed:lstuservalues){
           userfeed.Num_Retries__c = 4;
           userfeed.Status__c = 'To be retried';
           updateDFDUserlist.add(userfeed);
        }
        Update updateDFDUserlist; 
        //System.debug('updateDFDUserlist'+updateDFDUserlist);
        BatchToInsertDFDAccountsAndUsers bc = new BatchToInsertDFDAccountsAndUsers();
        database.executeBatch(bc, 200);
        //System.debug('bc '+bc );
        BatchToSetPasswordToDFDAccounts batchToSetPassword = new BatchToSetPasswordToDFDAccounts();
        database.executeBatch(batchToSetPassword, 200);   
        test.stopTest();    
    	}
    }
    
    static testmethod void testInsertBatchScheduled(){
        List<Profile> profile=[select Id,Name from profile where Name='External User' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=True limit 1];
        system.assertNotEquals(null, oUser);
        String CRON_EXP = '0 0 5 12 3 ? 2022';
        DocomoConfiguration__c custmstng = new DocomoConfiguration__c();
        custmstng.Name = 'Default Password';
        custmstng.Value__c = 'cGFzNzg5dzByZA==';
        insert custmstng;
        System.RunAs(oUser[0]){
        Test.startTest();
        List<DAZNUserFeed__c> userupdatelist= CreateTestDataforUnitTest.createTestDFDUserFeedRecordsBulk(50);
        List<DAZNUserFeed__c> updateDFDUserlist = new List<DAZNUserFeed__c>(); 
        database.Insert (userupdatelist);
        system.assert(userupdatelist.size()>=49);
        List<DAZNUserFeed__c> lstuservalues = [Select id,Status__c,Email__c,UserId__c,AccountId__c,Num_Retries__c,Auth_Key__c,ViewerId__c, IP_address__c from DAZNUserFeed__c Where Id in:userupdatelist];
           
        for(DAZNUserFeed__c userfeed:lstuservalues){
           userfeed.Num_Retries__c = 4;
           userfeed.Status__c = 'To be retried';
           updateDFDUserlist.add(userfeed);
        }
        Update updateDFDUserlist;
            
       // Schedule the test job
            String jobId = System.schedule('BatchToInsertDFDAccountsAndUsersTest',
                                           CRON_EXP, 
                                           new BatchToInsertDFDAccandUsrSchedule());
            
            // Get the information from the CronTrigger API object
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                              NextFireTime
                              FROM CronTrigger WHERE id = :jobId];
            
            // Schedule the test job
            String jobId1 = System.schedule('setPassowrd',
                                           CRON_EXP, 
                                           new ScheduledBatchToSetPasswordToDFDAccounts());
            
            // Get the information from the CronTrigger API object
            CronTrigger ct1 = [SELECT Id, CronExpression, TimesTriggered, 
                              NextFireTime
                              FROM CronTrigger WHERE id = :jobId1];
    }
    }
    
}