@isTest
private class AnonymizerUserTest {

	private static final String EMAIL_PATTERN = '@testEmailPattern.com';
	private static final String STR_ENV_NAME = 'testVal';
	
	@testSetup static void generateTestData() {
		CreateTestDataforUnitTest.triggerSettings();

		DAZNConfiguration__c daznConfig = new DAZNConfiguration__c(
        	Name = 'EnviornmentName',
        	Value__c = STR_ENV_NAME
        );
        insert daznConfig;

        Profile profileForTestUser = [Select Id, Name From Profile Where Name = 'Customer Community User' LIMIT 1];

        List<Account> accountsForTestUsers = new List<Account>();
        accountsForTestUsers.add(
        	new Account(
        		FirstName = 'firstName1',
                LastName = 'lastName1',
                PersonEmail = 'email1' + EMAIL_PATTERN,
                Notification_Country_Code__c = 'DE',
                All_Email_Preferences__c = true,
                Account_Status__c = 'Active Paid',
                Is_Double_OptIn__c = true,
                IsReadyToSyncInZuora__c = true
        	)
        );
        insert accountsForTestUsers;

        String personContactId = [Select Id, PersonContactId From Account].PersonContactId;

        List<User> usersForTest = new List<User>();
        usersForTest.add(
        	new User(
        		FirstName = 'firstName1',
        		LastName = 'lastName1',
        		Email = 'email1' + EMAIL_PATTERN,
        		UserName = 'test@username1.com',
        		Alias = 'LiveSp1',
        		TimeZoneSidKey = 'Europe/London',
        		LocaleSidKey = 'de_DE',
        		EmailEncodingKey = 'ISO-8859-1',
        		ProfileId = profileForTestUser.Id,
        		LanguageLocaleKey = 'en_GB',
        		ContactId = personContactId
        	)
        );
        insert usersForTest;
	}
	
	@isTest static void testBatch() {
		String testUserEmail = 'email1' + EMAIL_PATTERN;
		User testUserBefore = [Select Id, FirstName, LastName, Username, Email, IsActive From User Where Email = :testUserEmail LIMIT 1];

		AnonymizerUser anonymizerUser = new AnonymizerUser(EMAIL_PATTERN);

		Test.startTest();
		Database.executeBatch(anonymizerUser, 1000);
		Test.stopTest();

		User testUserAfter = [Select Id, FirstName, LastName, Username, Email, IsActive From User Where Id = :testUserBefore.Id LIMIT 1];
		
		String testUserAfterFirstName = 'anonymous[' + STR_ENV_NAME + ']' + testUserAfter.Id;
		String testUserAfterLastName = 'anonymous[' + STR_ENV_NAME + ']' + testUserAfter.Id;
		String testUserAfterUsername = ('anonymous[' + STR_ENV_NAME + ']' + testUserAfter.Id + '@livesport.com').toLowerCase();
		String testUserAfterEmail = ('anonymous' + STR_ENV_NAME + testUserAfter.Id + '@livesport.com').toLowerCase();

		System.assertEquals(testUserAfterFirstName, testUserAfter.FirstName);
		System.assertEquals(testUserAfterLastName, testUserAfter.LastName);
		System.assertEquals(testUserAfterUsername, testUserAfter.Username);
		System.assertEquals(testUserAfterEmail, testUserAfter.Email);
		System.assertEquals(false, testUserAfter.IsActive);
	}
	
}