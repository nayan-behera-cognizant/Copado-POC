@isTest
private class ProfileUpdateTest {

	@testSetup
    public static void setUpTestData() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testusername@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true, 'United Kingdom');
    }
	
	@isTest static void testUpdateProfile() {
		Id profileIdBefore = [Select Id From Profile Where Name = 'Customer Community User' LIMIT 1].Id;
        User oUser = [Select Id From User Where isActive = true AND ProfileId = :profileIdBefore LIMIT 1];
        Id ssoProfileId = [Select Id From Profile Where Name = 'Customer Community User SSO' LIMIT 1].Id;
        
        Test.startTest();
        ProfileUpdate.updateProfile(oUser.Id, ssoProfileId);
        Test.stopTest();

        Id profileIdAfter = [Select ProfileId From User Where Id = :oUser.Id].ProfileId;
        System.assertEquals(profileIdAfter, ssoProfileId);
	}
	
}