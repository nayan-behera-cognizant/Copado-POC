@isTest
private class DeleteAuthSessionsTest {
	
	@testSetup
    public static void setData() {
		SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
    }

	@isTest
	static void deleteAuthSessionSuccess() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        User oUser = SetUpTestData.createCommunityUser('test', 'en_US','DE', oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London', 'ISO-8859-1','en_US','en_US', 'Test First Name','Test Last Name',true); 

        User us = [SELECT Viewer_Id__c FROM User WHERE Id = :oUser.Id];
        
        Test.startTest();
			String resp = DeleteAuthSessions.deleteAllAuthSessions(us.Viewer_Id__c);
			System.assert(resp == 'Success');
		Test.stopTest();
		
	}

	@isTest
	static void deleteAuthSessionFail() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        User oUser = SetUpTestData.createCommunityUser('test', 'en_US','DE', oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London', 'ISO-8859-1','en_US','en_US', 'Test First Name','Test Last Name',true); 
        
        Test.startTest();
			String resp = DeleteAuthSessions.deleteAllAuthSessions('test');
			System.assert(resp == 'Failure');
		Test.stopTest();
	}

}