@isTest
private class ResetD4DAccountTest {

	@testSetup
	public static void setup() {
		CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccountsDocomo();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        List<Partner_Account_Configuration__c> partnerConfiguration = new List<Partner_Account_Configuration__c>();
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
        partnerConfiguration.add(pac);
        insert partnerConfiguration;
	}
	
	@isTest 
	static void test_method_one() {
		User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
		System.runAs(oCSUser) {
			Test.startTest();
				List<Account> accs = [SELECT Id FROM Account WHERE Type = 'Docomo' LIMIT 10];
				ResetD4DAccount.resetAccount(accs[0].Id);
				Account acc = [SELECT Id,Secondary_Email__c, FirstName FROM Account WHERE Id = :accs[0].Id];
				System.assertEquals(acc.FirstName, 'resetAccount');
			Test.stopTest();
		}
		

	}
	
}