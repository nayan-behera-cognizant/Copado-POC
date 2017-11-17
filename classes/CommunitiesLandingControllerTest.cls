/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
/*Added Assert statements as per PD-7938*/

@IsTest public with sharing class CommunitiesLandingControllerTest {
    //@IsTest(SeeAllData=true) public static void testCommunitiesLandingController() {
    //    // Instantiate a new controller with all parameters in the page
    //   CommunitiesLandingController oCommunitiesLandingController = new CommunitiesLandingController();
    //    Test.startTest();
    //    oCommunitiesLandingController.forwardToStartPage();
    //    System.assertEquals('/myaccount', oCommunitiesLandingController.forwardToStartPage().getURL());
    //    Test.stopTest();
    //    
    //  }

    @testSetup
	public static void getCommunityUsersTestData() {
		CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();

        CreateTestDataforUnitTest.createTestUserDevices();
        CreateTestDataforUnitTest.createTestUserDevices();
        CreateTestDataforUnitTest.createTestUserDevices();
        CreateTestDataforUnitTest.createTestUserDevices();

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
        
        List<Account> getaccList = [Select Id, Type From Account Where Account_Status__c = 'Active Grace' LIMIT 1];
        for (Account a : getaccList) {
        	a.Type = 'Docomo';
            a.Partner_ID__c = '1';
        }
        update getaccList;
	}

	private static User getDfDUser() {
		Id userAccId = [Select Id From Account Where Type = 'Docomo' AND Account_Status__c = 'Active Grace' LIMIT 1].Id;
		return [Select Id, AccountId, Country From User Where AccountId = :userAccId];
	}

	private static User getNonDfDUser() {
		Id userAccId = [Select Id From Account Where Type != 'Docomo' AND Account_Status__c = 'Active Paid' LIMIT 1].Id;
		return [Select Id, AccountId, Country From User Where AccountId = :userAccId];
	}

    @IsTest public static void testCommunitiesLandingControllerDfD() {
    	User u = getDfDUser();

		Test.startTest();

		System.runAs(u) {
			CommunitiesLandingController oCommunitiesLandingController = new CommunitiesLandingController();
			oCommunitiesLandingController.forwardToStartPage();
			System.assertEquals('/PartnerAccount', oCommunitiesLandingController.forwardToStartPage().getURL());
		}
		
		Test.stopTest();
    }

    @IsTest public static void testCommunitiesLandingControllerNonDfD() {
    	User u = getNonDfDUser();

		Test.startTest();

		System.runAs(u) {
			CommunitiesLandingController oCommunitiesLandingController = new CommunitiesLandingController();
			oCommunitiesLandingController.forwardToStartPage();
			System.assertEquals('/myaccount', oCommunitiesLandingController.forwardToStartPage().getURL());
		}
		
		Test.stopTest();
    }
}