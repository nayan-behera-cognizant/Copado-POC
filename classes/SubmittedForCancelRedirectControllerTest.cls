@isTest
private class SubmittedForCancelRedirectControllerTest {
	
	@isTest static void testConstructor() {
		CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestcustomsetting();

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Paused');
        User cUser = SetUpTestData.createCommunityUser('en_US', 'DE', oAccount.Id, 'pauseuser@email.com', 'pauseuseree@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','PauseUserFName','PauseUserLName',true);
        
        Test.StartTest();
        System.RunAs(cUser) {
        	SubmittedForCancelRedirectController ctrl = new SubmittedForCancelRedirectController();
        	System.assertNotEquals(null, ctrl);
        }
        Test.stopTest();
	}
	
}