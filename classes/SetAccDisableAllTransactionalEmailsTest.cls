@isTest
private class SetAccDisableAllTransactionalEmailsTest {
	
	@isTest static void testSetAccountDisableAllTransactionalEmails() {
		SetUpTestData.triggerSettings();
		
		List<Account> acc = new List<Account>();
		acc.add(new Account(
			FirstName = 'testfq',
			LastName = 'testlq',
			PersonEmail = 'testfq@testlq.com',
			Type = 'Docomo',
			Disable_all_transactional_emails__c = false
		));
		acc.add(new Account(
			FirstName = 'testfw',
			LastName = 'testlw',
			PersonEmail = 'testfw@testlw.com',
			Type = 'Do not contact',
			Disable_all_transactional_emails__c = false
		));
		acc.add(new Account(
			FirstName = 'testfe',
			LastName = 'testle',
			PersonEmail = 'testfe@testle.com',
			Type = 'Apple',
			Disable_all_transactional_emails__c = false
		));
		insert acc;

		System.assertEquals(0, [Select Id From Account Where Disable_all_transactional_emails__c = true].size());

		Test.startTest();
		Database.executeBatch(new SetAccountDisableAllTransactionalEmails(), 2000);
		Test.stopTest();

		System.assertEquals(1, [Select Id From Account Where Disable_all_transactional_emails__c = true].size());
	}
	
}