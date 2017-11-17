@isTest
private class CheckingAccountTypeControllerTest {
	
	@testSetup
	public static void getCommunityUsersTestData() {
		CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccountsDocomo();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        CreateTestDataforUnitTest.createTestcustomsetting();

        CreateTestDataforUnitTest.createTestUserDevices();
        CreateTestDataforUnitTest.createTestUserDevices();
        CreateTestDataforUnitTest.createTestUserDevices();
        CreateTestDataforUnitTest.createTestUserDevices();

        List<DAZNLanguageSetting__c> ls = new List<DAZNLanguageSetting__c>();
		ls.add(new DAZNLanguageSetting__c(
			Name = 'Austria',
			LanguageToDisplay__c = 'en_GB,DE'
		));
		ls.add(new DAZNLanguageSetting__c(
			Name = 'Germany',
			LanguageToDisplay__c = 'en_GB,DE'
		));
		ls.add(new DAZNLanguageSetting__c(
			Name = 'Japan',
			LanguageToDisplay__c = 'en_GB,ja'
		));
		ls.add(new DAZNLanguageSetting__c(
			Name = 'Switzerland',
			LanguageToDisplay__c = 'en_GB,DE'
		));
		ls.add(new DAZNLanguageSetting__c(
			Name = 'United Kingdom',
			LanguageToDisplay__c = 'en_GB'
		));
		ls.add(new DAZNLanguageSetting__c(
			Name = 'United States',
			LanguageToDisplay__c = 'en_GB'
		));
		insert ls;

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
        Partner_Account_Configuration__c pacApple = new Partner_Account_Configuration__c(
        	Name = 'Apple',
        	Partner_Type__c = 'Apple',
        	Page_Name__c = 'ApplepayAccount.page',
        	Subscription_Type_Heading_Text__c = 'LS_MyAccount_Subscription_Sub_Type_Heading_Text_Apple',
        	Subscription_Type_Sub_Heading_Text__c = 'LS_MyAccount_Subscription_Type_Heading_Text_Apple',
        	Payment_History_URL__c = 'https://www.google.com',
        	Cancel_Subscription_URL_Small__c = 'https://www.google.com',
        	Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
        	Cancel_Subscription_URL_Large__c = 'https://www.google.com'
        );
        partnerConfiguration.add(pacApple);
        insert partnerConfiguration;

        DAZN_Help_Redirect__c dhr = new DAZN_Help_Redirect__c(
        	Name = 'Japan',
        	Country__c = 'Japan',
        	CountryISOCode__c = 'JP',
        	IsDefaultCountry__c = true,
        	Language__c = 'ja'
        );
        insert dhr;
	}

	@isTest 
	static void testApple() {
		Account oAccount = SetUpTestData.createDfDAccount('TestFName', 'TestLName','test@test.com','Active Paid', '12345567890', 'Apple');
  		User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailAppleUser@email.com', 'testusernameAppleUser@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
  		System.runAs(cUser) {
  			Test.startTest();
  				CheckingAccountTypeController ctrl = new CheckingAccountTypeController();
  			Test.stopTest();
  			System.assertEquals(ctrl.docomoPartnerPage,'PartnerAccount');
  			System.assertEquals(ctrl.isAppleUser,true);
  		}

	}
	
	@isTest 
	static void testDocomo() {
		Account oAccount = SetUpTestData.createDfDAccount('TestFName', 'TestLName','test@test.com','Active Paid', '12345567890', 'Docomo');
  		User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailAppleUser@email.com', 'testusernameAppleUser@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
  		System.runAs(cUser) {
  			Test.startTest();
  				CheckingAccountTypeController ctrl = new CheckingAccountTypeController();
  			Test.stopTest();
  			System.assertEquals(ctrl.docomoPartnerPage,'PartnerAccount');
  			System.assertEquals(ctrl.isDocomoUser,true);
  		}

	}
}