@isTest
private class DailyBatchToUpdPartnerRdytoSyncTest{
 @testSetup /*  calling CreateTestDataforUnitTest */  
    public static void getCommunityUsersTestData(){
        CreateTestDataforUnitTest.triggerSettings();
        //CreateZuoraDataforUnitTest.createZuoraDeatils();
        CreateTestDataforUnitTest.createTestcustomsetting();
        CreateTestDataforUnitTest.createTestUserDevices();
        SetUpTestData.createDAZNConfigurations();
    }
    
    static testMethod void testMethod1() {   

        List<Account> acLst = new List<Account>();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true, 'United Kingdom');
        oAccount.Partner_Ready_to_Sync__c = TRUE;
        oAccount.Partner_ID__c = '45QQGGJT55QOOTTTP4Q5TTPT';
        update oAccount;

        acLst.add(oAccount);
        string strREs=	'{\"result\":\"000\"}';
        SingleRequestMock fakeResponse1 = new SingleRequestMock(200,'Complete',strREs,null);    
       	Test.setMock(HttpCalloutMock.class, fakeResponse1); 
        
        Test.startTest(); 
            docomoDailyBatchToUpdPartnerRdytoSync obj = new docomoDailyBatchToUpdPartnerRdytoSync();
        	Database.QueryLocator ql = obj.start(null);
            obj.execute(null,acLst);
            obj.Finish(null);
        Test.stopTest();
    }

	static testMethod void testMethod2() {
        List<Account> acLst = new List<Account>();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true, 'United Kingdom');
        oAccount.Partner_Ready_to_Sync__c = TRUE;
        oAccount.Partner_ID__c = '45QQGGJT55QOOTTTP4Q5TTPT';
        update oAccount;

        acLst.add(oAccount);
        string strREs=	'{\"result\":\"999\"}';
        SingleRequestMock fakeResponse1 = new SingleRequestMock(200,'Complete',strREs,null);    
       	Test.setMock(HttpCalloutMock.class, fakeResponse1); 
        
        Test.startTest();
            docomoDailyBatchToUpdPartnerRdytoSync obj = new docomoDailyBatchToUpdPartnerRdytoSync();
        	Database.QueryLocator ql = obj.start(null);
            obj.execute(null,acLst);
            obj.Finish(null);
        Test.stopTest();
    }

    static testMethod void testMethod3() {
        List<Account> acLst = new List<Account>();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true, 'United Kingdom');
        oAccount.Partner_Ready_to_Sync__c = TRUE;
        oAccount.Partner_ID__c = '45QQGGJT55QOOTTTP4Q5TTPT';
        oAccount.Partner_Ready_to_Sync__c = FALSE;
        update oAccount;

        acLst.add(oAccount);
        string strREs=	'{\"result\":\"999\"}';
        SingleRequestMock fakeResponse1 = new SingleRequestMock(200,'Complete',strREs,null);    
       	Test.setMock(HttpCalloutMock.class, fakeResponse1); 
        
        Test.startTest();
            docomoDailyBatchToUpdPartnerRdytoSync obj = new docomoDailyBatchToUpdPartnerRdytoSync();
        	Database.QueryLocator ql = obj.start(null);
            obj.execute(null,acLst);
            obj.Finish(null);
        Test.stopTest();
    }

}