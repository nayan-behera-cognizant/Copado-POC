@isTest
private class PartnerAccountHelperTest {

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

        SetupTestData.createDAZNConfigurations();
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

    private static User getDfDUser() {
        Id userAccId = [Select Id From Account Where Type = 'Docomo' AND Account_Status__c = 'Active Grace' LIMIT 1].Id;
        return [Select Id, AccountId, Country, LanguageLocaleKey  From User Where AccountId = :userAccId];
    }
	
	@isTest static void testOptedInStatus() {
		User u = getDfDUser();
		String strRes =	'<struct><member><name>magaId</name><value>MAGAID1</value></member>'+
            '<member><name>status</name><value><i4>1</i4></value></member></struct>';
        SingleRequestMock fakeResponse1 = new SingleRequestMock(200, 'Complete', strRes, null);    
        Test.setMock(HttpCalloutMock.class, fakeResponse1);
		System.runAs(u) {
            Test.startTest();
            String strDocomoPartnerId = 'NTG5OT5J5Q45540TP45TTTPQ';
            String res = PartnerAccountHelper.checkMarketingOptInStatusForD4dUser(strDocomoPartnerId);
            System.assertEquals('Opted in', res);
   		    Test.stopTest();
        }
    }

    @isTest static void testOptedOutStatus() {
        User u = getDfDUser();
        String strRes = '<struct><member><name>magaId</name><value>MAGAID1</value></member>'+
            '<member><name>status</name><value><i4>0</i4></value></member></struct>';
        SingleRequestMock fakeResponse1 = new SingleRequestMock(200, 'Complete', strRes, null);    
        Test.setMock(HttpCalloutMock.class, fakeResponse1);
        System.runAs(u) {
            Test.startTest();
            String strDocomoPartnerId = 'NTG5OT5J5Q45540TP45TTTPQ';
            String res = PartnerAccountHelper.checkMarketingOptInStatusForD4dUser(strDocomoPartnerId);
            System.assertEquals('Opted out', res);
            Test.stopTest();
        }
    }

    @isTest static void testErrorCodeStatus() {
        User u = getDfDUser();
        String strRes = '<struct><member><name>magaId</name><value>MAGAID1</value></member>'+
            '<member><name>errorCode</name><value><i4>0</i4></value></member></struct>';
        SingleRequestMock fakeResponse1 = new SingleRequestMock(200, 'Complete', strRes, null);    
        Test.setMock(HttpCalloutMock.class, fakeResponse1);
        System.runAs(u) {
            Test.startTest();
            String strDocomoPartnerId = 'NTG5OT5J5Q45540TP45TTTPQ';
            String res = PartnerAccountHelper.checkMarketingOptInStatusForD4dUser(strDocomoPartnerId);
            System.assertEquals('Error', res);
            Test.stopTest();
        }
    }

    @isTest static void testNeverOptedInCodeStatus() {
        User u = getDfDUser();
        String strRes = '<struct><member><name>magaId</name><value>MAGAID1</value></member>'+
            '<member><name>errorCode</name><value><i4>0</i4></value></member></struct>';
        SingleRequestMock fakeResponse1 = new SingleRequestMock(300, 'Complete', strRes, null);    
        Test.setMock(HttpCalloutMock.class, fakeResponse1);
        System.runAs(u) {
            Test.startTest();
            String strDocomoPartnerId = 'NTG5OT5J5Q45540TP45TTTPQ';
            String res = PartnerAccountHelper.checkMarketingOptInStatusForD4dUser(strDocomoPartnerId);
            System.assertEquals('Never opted in', res);
            Test.stopTest();
        }
    }
	
}