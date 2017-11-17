@isTest
private class AnonymizerAccountTest {
	
	private static final String EMAIL_PATTERN = '@testEmailPattern.com';
	private static final String STR_ENV_NAME = 'testVal';
	
	@testSetup static void generateTestData() {
		CreateTestDataforUnitTest.triggerSettings();

		Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
        	Name = 'Docomo',
        	Partner_Type__c = 'Docomo',
        	Page_Name__c = 'PartnerAccount.page',
        	Subscription_Type_Heading_Text__c = 'Docomo',
        	Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
        	Payment_History_URL__c = 'https://www.google.com',
        	Cancel_Subscription_URL_Small__c = 'https://www.google.com',
        	Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
        	Cancel_Subscription_URL_Large__c = 'https://www.google.com'
        );
        insert pac;

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
        		FirstName = 'anonymous[' + STR_ENV_NAME + ']' + '1',
        		LastName = 'anonymous[' + STR_ENV_NAME + ']' + '1',
        		Email = 'anonymous' + STR_ENV_NAME + '1' + '@livesport.com',
        		UserName = 'anonymous[' + STR_ENV_NAME + ']' + '1' + '@livesport.com',
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
		Account testAccountBefore = [Select Id, All_Email_Preferences__c, PersonEmail, Account_Status__c, FirstName, LastName From Account Where PersonEmail = :testUserEmail LIMIT 1];

		AnonymizerAccount anonymizerAccount = new AnonymizerAccount(EMAIL_PATTERN);

		Test.startTest();
		Database.executeBatch(anonymizerAccount, 1000);
		Test.stopTest();

		Account testAccountAfter = [Select Id, All_Email_Preferences__c, PersonEmail, Account_Status__c, FirstName, LastName From Account Where Id = :testAccountBefore.Id LIMIT 1];
		User testUser = [Select Id, FirstName, LastName, Email From User Where AccountId = :testAccountBefore.Id];

		System.assertEquals(false, testAccountAfter.All_Email_Preferences__c);
        System.assertEquals(testUser.Email, testAccountAfter.PersonEmail);
        System.assertEquals('Expired', testAccountAfter.Account_Status__c);
        System.assertEquals(testUser.FirstName, testAccountAfter.FirstName);
        System.assertEquals(testUser.LastName, testAccountAfter.LastName);
	}
	
}