/**
* @author Cognizant Technology Solutuions
* @date 14/03/2017
* @description Test class for UpsertAccountsInCommunicator batch job.
*/
@isTest
public class BatchTriggerDoubleOptinTest{
  /*   @testSetup
    public static void testUser(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        CreateTestDataforUnitTest.CreateGuestUser();//As per PD-7938
        SetUpTestData.emailCustsett();
    }
    
    @isTest
    public static void testUpsertAccountInCommunicatorBatch(){
        SetUpTestData.triggerSettings();
        
        List<account>lstAcc = new List<account>(); 
        Account oAccount1 = SetUpTestData.createPersonAccountForBatch('TestFirstName1', 'TestLastName1','testdoubleoptin1@test.com','Partial', 'DE', 'User', True , True );
        oAccount1.Notification_Language_Code__c = 'de';
        oAccount1.IsReadyToSyncInCommunicator__c = TRUE;
        
        Account oAccount2 = SetUpTestData.createPersonAccountForBatch('TestFirstName1', 'TestLastName1','testdoubleoptin1@test.com','Partial', 'DE', 'User', True , True );
        oAccount2.Notification_Language_Code__c = 'en_GB';
        oAccount2.IsReadyToSyncInCommunicator__c = TRUE;
         
        lstAcc.add(oAccount1);
        lstAcc.add(oAccount2);
        update lstAcc;
        
        Test.startTest();
        BatchTriggerDoubleOptin obj = new BatchTriggerDoubleOptin();
        DataBase.executeBatch(obj); 
        Test.stopTest();    
        
 }*/
 }