@isTest
private class PartnerAccountControllerTest {

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
	
	@isTest static void testController() {
		User u = getDfDUser();

		Test.startTest();

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();
			pac.strCurrentCountry = 'JP';
			System.assertNotEquals(null, pac);
		}

		PartnerAccountController pac = new PartnerAccountController();
        pac.DAZNHomePageNavigationHandler();
		System.assertNotEquals(null, pac);
		
		Test.stopTest();
	}
	
	@isTest static void testEmailPreferences() {
		User u = getDfDUser();

		Test.startTest();

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();

			System.assertNotEquals(true, pac.bEmailPreference);
		}
		
		Test.stopTest();
	}

	@isTest static void testEmailPreferencesNegative() {
		Test.startTest();

		PartnerAccountController pac = new PartnerAccountController();

		System.assertNotEquals(false, pac.bEmailPreference);
		
		Test.stopTest();
	}

	@isTest static void testEditEmail() {
		String newEmail = 'test1@test1.com';

		User u = getDfDUser();

		Test.startTest();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Email');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();
			pac.oAccount.Secondary_Email__c = newEmail;
			pac.edit();

			System.assertEquals(newEmail, pac.strNewEmail);
			System.assertEquals(true, pac.isEmailEdit);
		}
		
		Test.stopTest();
	}

	@isTest static void testEditName() {
		String newFirstName = 'testNewFirstName';
		String newLastName = 'testNewLastName';

		User u = getDfDUser();
		
		Test.startTest();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Name');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();

			pac.oAccount.DFD_First_Name__c = newFirstName;
			pac.oAccount.DFD_Last_Name__c = newLastName;
						
			pac.edit();

			System.assertEquals(newFirstName, pac.strFirstName);
			System.assertEquals(newLastName, pac.strLastName);
			System.assertEquals(true, pac.isNameEdit);
		}
		
		Test.stopTest();
	}

	@isTest static void testEditError() {
		User u = getDfDUser();

		Test.startTest();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Error');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();
			pac.edit();

			System.assertNotEquals(null, PartnerAccountController.errorPage);
		}
		
		Test.stopTest();
	}

	@isTest static void testCancelEditEmail() {
		User u = getDfDUser();

		Test.startTest();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Email');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();
			pac.cancelEdit();

			System.assertEquals(u.Id, pac.user.Id);
			System.assertEquals(false, pac.isEmailEdit);
		}
		
		Test.stopTest();
	}

	@isTest static void testCancelEditName() {
		User u = getDfDUser();

		Test.startTest();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Name');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();
			pac.cancelEdit();

			System.assertEquals(pac.strFirstName, pac.user.FirstName);
			System.assertEquals(pac.strLastName, pac.user.LastName);
			System.assertEquals(false, pac.isNameEdit);
		}
		
		Test.stopTest();
	}

	@isTest static void testCancelEditError() {
		User u = getDfDUser();

		Test.startTest();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Error');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();
			pac.cancelEdit();

			System.assertNotEquals(null, PartnerAccountController.errorPage);
		}
		
		Test.stopTest();
	}

	@isTest static void testSaveNameChanges() {
		String newFirstName = 'testNewFirstName';
		String newLastName = 'testNewLastName';

		User u = getDfDUser();
		PartnerAccountController pac;

		Test.startTest();

		System.runAs(u) {
			pac = new PartnerAccountController();
			pac.strFirstName = newFirstName;
            pac.strLastName = newLastName;
			pac.saveNameChanges();
		}
		
		Test.stopTest();

		User userAfterUpdate = [Select Id, FirstName, LastName, AccountId From User Where Id = :u.Id LIMIT 1];
		Account accountAfterUpdate = [Select Id, FirstName, LastName, DFD_First_Name__c, DFD_Last_Name__c From Account Where Id = :userAfterUpdate.AccountId LIMIT 1];

		System.assertEquals(newFirstName, pac.strFirstName);
		System.assertEquals(newLastName, pac.strLastName);
		/*System.assertEquals(newFirstName, userAfterUpdate.FirstName);
		System.assertEquals(newLastName, userAfterUpdate.LastName);*/
		System.assertEquals(newFirstName, accountAfterUpdate.DFD_First_Name__c);
		System.assertEquals(newLastName, accountAfterUpdate.DFD_Last_Name__c);
	}

	@isTest static void testSaveNameChangesError() {
		String newFirstName = 'testNewFirstNameqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq';
		String newLastName = 'testNewLastName';

		User u = getDfDUser();

		Test.startTest();

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();
			pac.strFirstName = newFirstName;
            pac.strLastName = newLastName;
			pac.saveNameChanges();

			System.assertNotEquals(null, PartnerAccountController.errorPage);
		}
		
		Test.stopTest();
	}
	
	//test first name and last name fields order for JP users (PD-5776)
    @isTest	static void testNameFieldsOrderForJP(){

		String newFirstName = 'FirstName1';
		String newLastName = 'LastName1';

		User oUser = getDfDUser();
        system.assertNotEquals(null, oUser);

        test.startTest();

        System.RunAs(oUser) {
			PartnerAccountController pac = new PartnerAccountController();
			pac.strCurrentCountry = 'JP';
            pac.strFirstName = newFirstName;
            pac.strLastName = newLastName;
            pac.saveNameChanges();
            string testName = pac.strLastName + ' ' + pac.strFirstName;

            System.assertEquals(pac.sAccountName, testName);

        }
        Test.stopTest();

    }    

    @isTest	static void testNameFieldsOrderForJPError(){

		String newFirstName = 'FirstName1';
		String newLastName = 'LastName1';

		User oUser = getDfDUser();
        system.assertNotEquals(null, oUser);

        test.startTest();

        System.RunAs(oUser) {
			PartnerAccountController pac = new PartnerAccountController();
			pac.strCurrentCountry = 'DE';
            pac.strFirstName = newFirstName;
            pac.strLastName = newLastName;
            pac.saveNameChanges();
            string testName = pac.strLastName + ' ' + pac.strFirstName;

            System.assertNotEquals(pac.sAccountName, testName);

        }
        Test.stopTest();

    }    

    /*PD-10364*/
	@isTest static void testSaveEmailChanges() {
		String newEmail = 'newemail@new.com';

		User u = getDfDUser();
		PartnerAccountController pac;

		System.runAs(u) {
			Test.startTest();

			pac = new PartnerAccountController();
			pac.strNewEmail = newEmail;
			pac.saveEmailChanges();

			Test.stopTest();
		}

		User userAfterUpdate = [Select Id, Email, AccountId From User Where Id = :u.Id LIMIT 1];
		Account accountAfterUpdate = [Select Id, Secondary_Email__c From Account Where Id = :userAfterUpdate.AccountId LIMIT 1];

		System.assertEquals(newEmail, pac.oAccount.Secondary_Email__c);
		System.assertEquals(newEmail, userAfterUpdate.Email);
		System.assertEquals(newEmail, accountAfterUpdate.Secondary_Email__c);
	}

	@isTest static void testSaveEmailChangesError() {
		String newEmail = 'newemail@new.commmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm';

		User u = getDfDUser();

		Test.startTest();

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();
			pac.strNewEmail = newEmail;
			pac.saveEmailChanges();

			System.assertNotEquals(null, PartnerAccountController.errorPage);
		}
		
		Test.stopTest();
	}

	@isTest static void testSaveEmailChangesErrorOldEmail() {
		User u = getDfDUser();

		Test.startTest();

		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();
    	    pac.strNewEmail = pac.user.Email;
		    pac.saveEmailChanges();

		    System.assertEquals(Label.LS_Myaccount_ErrMsg_ProvideNewEmail, pac.sEmailProvideNewEmailErrorMsg);
		}
		
		Test.stopTest();
	}

    /*PD-10364*/
	@isTest static void testSaveDocomoEmailChangesErrorExistingEmail() {
		String newEmail = 'testdocomo@test.com';
        
        Account oAccount = new Account();
        oAccount.FirstName = 'TestFName';
        oAccount.LastName = 'TestLName';
        oAccount.PersonEmail = newEmail;
        oAccount.Secondary_Email__c = newEmail;        
        oAccount.Account_Status__c = 'Active Paid';
        oAccount.Partner_ID__c = '1234567890';
        oAccount.Type = 'Docomo';
        insert oAccount;
        
        User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
            
    	    PartnerAccountController pac = new PartnerAccountController();
    	    pac.strNewEmail = newEmail;
		    pac.saveEmailChanges();

		    System.assertEquals(Label.LS_MyAccount_ErrMsg_DocomoEmailIDExists, pac.sEmailProvideNewEmailErrorMsg);
		}
		
		Test.stopTest();
	}

	@isTest static void testRedirectToErrorPageMyLogin() {
		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();
		    PartnerAccountController.redirectToErrorPage('mylogin');

		    System.assertEquals(System.Page.mylogin.getUrl(), PartnerAccountController.errorPage.getUrl());
		}
		
		Test.stopTest();
	}

	@isTest static void testRedirectToErrorPageNotMyLogin() {
		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();
		    PartnerAccountController.redirectToErrorPage('AnotherError');

		    System.assertEquals(System.Page.InternalServerError.getUrl() + '?Errormsg=AnotherError', PartnerAccountController.errorPage.getUrl());
		}
		
		Test.stopTest();
	}

	@isTest static void testShowAllUserDevices() {
		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();
		    pac.showAllUserDevices();

		    System.assertEquals(false, pac.bshowAllUserDevicesButton);
		    System.assertEquals(4, pac.wrapUDList.size());
		}
		
		Test.stopTest();
	}

	@isTest static void testGetUserDevices() {
		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();

		    System.assertEquals(true, pac.bshowAllUserDevicesButton);
		    System.assertEquals(3, pac.wrapUDList.size());
		}
		
		Test.stopTest();
	}

	@isTest static void testSignoutAllDevices() {
		DAZNConfiguration__c config = new DAZNConfiguration__c(
			Name = 'LoginPageURL',
			Value__c = '12345'
		);
		insert config;

		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
			PageReference tpageRef = Page.PartnerAccount;
            Test.setCurrentPage(tpageRef);
            ApexPages.currentPage().getParameters().put('cancelButtonclick', 'false');

    	    PartnerAccountController pac = new PartnerAccountController();
    	    PageReference pr = pac.signoutAllDevices();

		    System.assertEquals(config.Value__c, pr.getUrl());
		}
		
		Test.stopTest();
	}

	@isTest static void testSignoutAllDevicesTask() {
		DAZNConfiguration__c config = new DAZNConfiguration__c(
			Name = 'LoginPageURL',
			Value__c = '12345'
		);
		insert config;

		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
			PageReference tpageRef = Page.PartnerAccount;
            Test.setCurrentPage(tpageRef);
            ApexPages.currentPage().getParameters().put('cancelButtonclick', 'true');

    	    PartnerAccountController pac = new PartnerAccountController();
    	    PageReference pr = pac.signoutAllDevices();

		    System.assertEquals(config.Value__c, pr.getUrl());
		}
		
		Test.stopTest();
	}

	@isTest static void testSignoutAllDevicesBlankLoginUrl() {
		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
			PageReference tpageRef = Page.PartnerAccount;
            Test.setCurrentPage(tpageRef);
            ApexPages.currentPage().getParameters().put('cancelButtonclick', 'false');

    	    PartnerAccountController pac = new PartnerAccountController();
    	    PageReference pr = pac.signoutAllDevices();

		    //System.assertNotEquals(null, PartnerAccountController.errorPage);
		}
		
		Test.stopTest();
	}

	@isTest static void testSignoutAllDevicesLangLoginUrl() {
		DAZNConfiguration__c config = new DAZNConfiguration__c(
			Name = 'LoginPageURL',
			Value__c = '12345language'
		);
		insert config;

		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
			PageReference tpageRef = Page.PartnerAccount;
            Test.setCurrentPage(tpageRef);
            ApexPages.currentPage().getParameters().put('cancelButtonclick', 'false');

    	    PartnerAccountController pac = new PartnerAccountController();
    	    PageReference pr = pac.signoutAllDevices();

    	    String sLanguage = CommunityHelper.getLanguageCode();
            if (sLanguage.equals('en_GB') || sLanguage.equals('en_US')) {
                sLanguage = 'en';
            }

		    System.assertEquals('12345' + sLanguage, pr.getUrl());
		}
		
		Test.stopTest();
	}

	@isTest static void testSignoutAllDevicesTerritoryLoginUrl() {
		DAZNConfiguration__c config = new DAZNConfiguration__c(
			Name = 'LoginPageURL',
			Value__c = '12345territory'
		);
		insert config;

		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
			PageReference tpageRef = Page.PartnerAccount;
            Test.setCurrentPage(tpageRef);
            ApexPages.currentPage().getParameters().put('cancelButtonclick', 'false');

    	    PartnerAccountController pac = new PartnerAccountController();
    	    PageReference pr = pac.signoutAllDevices();

		    System.assertEquals('12345' + CommunityHelper.getUserCountry(pac.user), pr.getUrl());
		}
		
		Test.stopTest();
	}

	@isTest static void testShowSignOutBannerSinleDevice() {
		User u = getDfDUser();

		Id deviceId = [Select Id From User_Devices__c Where Account__c = :u.AccountId LIMIT 1].Id;

		Test.startTest();
		
		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();
    	    pac.selectedDeviceID = deviceId;
    	    pac.showSignOutBannerSinleDevice();

		    System.assertEquals(true, pac.bShowSignOutButton);
		    System.assertEquals(true, pac.showbannerforSingledevice);
		    System.assertEquals(false, pac.showStartWatchingDAZN);
		}
		
		Test.stopTest();
	}

	@isTest static void testShowSignOutBanner() {
		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();
    	    pac.showSignOutBanner();

		    System.assertEquals(true, pac.bShowSignOutButton);
		    System.assertEquals(true, pac.showBanner);
		    System.assertEquals(false, pac.showStartWatchingDAZN);
		}
		
		Test.stopTest();
	}

	@isTest static void testDeregisterSingelUserDevice() {
		User u = getDfDUser();

		Id deviceId = [Select Id From User_Devices__c Where Account__c = :u.AccountId LIMIT 1].Id;

		Test.startTest();
		
		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();
    	    pac.selectedDeviceID = deviceId;
    	    PageReference pr = pac.deregisterSingelUserDevice();

		    System.assertEquals(3, pac.wrapUDList.size());
		    //System.assertEquals(null, pr);
		}
		
		Test.stopTest();

		List<User_Devices__c> userDevices = [Select Id From User_Devices__c Where Account__c = :u.AccountId];
		//System.assertEquals(3, userDevices.size());
	}

	@isTest static void testGetLanguages() {
		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();
    	    List<CommunityHelper.UserLanguage> languages = pac.getLanguages();

		    System.assertNotEquals(null, languages);
		    System.assertEquals(2, languages.size());
		}
		
		Test.stopTest();
	}

	@isTest static void testUpdateUserLanguage() {
		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();
    	    pac.strSelectedLanguage = 'ja';
    	    PageReference pr = pac.updateUserLanguage();

		    System.assertEquals(null, pr);
		    System.assertEquals('ja', pac.user.LanguageLocaleKey);
		}
		
		Test.stopTest();

		User userAfterUpdate = [Select Id, LanguageLocaleKey From User Where Id = :u.Id LIMIT 1];

		System.assertEquals('ja', userAfterUpdate.LanguageLocaleKey);
	}

	@isTest static void testUpdateUserLanguageError() {
		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();
    	    pac.strSelectedLanguage = 'error';
    	    PageReference pr = pac.updateUserLanguage();

		    System.assertNotEquals(null, pr);
		}
		
		Test.stopTest();
	}

	@isTest static void testSetEmailPreferences() {
		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();
    	    pac.bEmailPreference = false;
    	    PageReference pr = pac.setEmailPreferences();

    	    List<Account> lstAccount = [SELECT All_Email_Preferences__c FROM Account WHERE Id = :u.AccountId LIMIT 1];
		    System.assertEquals(false, lstAccount[0].All_Email_Preferences__c);

		    pac.bEmailPreference = true;
    	    pr = pac.setEmailPreferences();

    	    lstAccount = [SELECT All_Email_Preferences__c FROM Account WHERE Id = :u.AccountId LIMIT 1];
		    System.assertEquals(true, lstAccount[0].All_Email_Preferences__c);
		}
		
		Test.stopTest();
	}

	@isTest static void testCloseBanner() {
		User u = getDfDUser();

		Test.startTest();
		
		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();
    	    pac.closeBanner();

		    System.assertEquals(false, pac.showBanner);
		    System.assertEquals(false, pac.showbannerforSingledevice);
		}
		
		Test.stopTest();
	}

	@isTest static void testURLWithCountryAndLang() {
		User u = getDfDUser();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('Country', 'Country');
        ApexPages.currentPage().getParameters().put('lang', 'lang');

		Test.startTest();
		
		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();

		    System.assertEquals('/help/' + 'Country' + '-' + 'lang' + '/terms', pac.termsURL);
		    System.assertEquals('/help/' + 'Country' + '-' + 'lang' + '/privacy', pac.privacyURL);
		}
		
		Test.stopTest();
	}

	@isTest static void testURLWithoutCountryAndLang() {
		User u = getDfDUser();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);

		Test.startTest();
		
		System.runAs(u) {
    	    PartnerAccountController pac = new PartnerAccountController();

    	    String countryISOCode = 'JP'; //there is only 1 record in DAZN_Help_Redirect__c
    	    String sURLLang = userInfo.getLanguage();
    	    if (sURLLang.length() > 2 && sURLLang.indexOf('_') > -1) {
                sURLLang = sURLLang.split('_')[0];
            }

		    System.assertEquals('/help/' + countryISOCode + '-' + sURLLang + '/terms', pac.termsURL);
		    System.assertEquals('/help/' + countryISOCode + '-' + sURLLang + '/privacy', pac.privacyURL);
		}
		
		Test.stopTest();
	}
    
 @isTest static void testGetDocomoResp() {
		User u = getDfDUser();
		string strREs=	'<methodCall><methodName>MelMaga.ref</methodName><params><param><value><struct><member><name>siteId</name><value>DAZN4docomo</value></member><member><name>Idtype</name><value>AI</value></member><member><name>Id</name><value>NTG5OT5J5Q45540TP45TTTPQ</value></member></struct></value></param></params></methodCall>';
        SingleRequestMock fakeResponse1 = new SingleRequestMock(200,'Complete',strREs,null);    
        Test.setMock(HttpCalloutMock.class, fakeResponse1);  		
		System.runAs(u) {        
            
        Test.startTest();		    
            String strDocomoPartnerId = 'NTG5OT5J5Q45540TP45TTTPQ';
            boolean bolDocomo = TRUE;
            PartnerAccountController.respToSetTheDocomo( bolDocomo, strDocomoPartnerId);
            System.assertNotEquals(fakeResponse1,null);
   		Test.stopTest();
        }
 }

  @isTest static void testSetDocomoResp() {
		User u = getDfDUser();
		string strREs=	'<methodCall><methodName>MelMaga.ref</methodName><params><param><value><struct><member><name>siteId</name><value>DAZN4docomo</value></member><member><name>Idtype</name><value>AI</value></member><member><name>Id</name><value>NTG5OT5J5Q45540TP45TTTPQ</value></member></struct></value></param></params></methodCall>';
        SingleRequestMock fakeResponse1 = new SingleRequestMock(404,'Complete',strREs,null);    
        Test.setMock(HttpCalloutMock.class, fakeResponse1);  		
		System.runAs(u) {      
            
        Test.startTest();
           //ApexPages.currentPage().getParameters().put('strDocomoSts','400');
            String strDocomoPartnerId = 'NTG5OT5J5Q45540TP45TTTPQ';            
            PartnerAccountController.respFromDocomo(strDocomoPartnerId);
            System.assertNotEquals(fakeResponse1,null);
   		Test.stopTest();
        }
 }

    /*PD-10385*/
  	@isTest static void testNavigateUser() {
  		Account oAccount = SetUpTestData.createDfDAccount('TestFName', 'TestLName','test@test.com','Active Paid', '12345567890', 'DAZN for Docomo');

        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailtestNavigateUser@email.com', 'testusernametestNavigateUser@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 

		System.runAs(cUser) {               
	        PartnerAccountController partnerAccountController = new PartnerAccountController();
	        PageReference myAccount = partnerAccountController.navigateUser();
	        System.assertEquals(myAccount.getUrl(), Page.MyAccount.getUrl());
        }
  	}

  	/*Start part of PD-10449*/
  	@isTest
  	static void testAppleUser() {
  		
  		Account oAccount = SetUpTestData.createDfDAccountWithoutCode('TestFName', 'TestLName','test@test.com','Active Paid', '12345567890', 'Apple');
  		User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailAppleUser@email.com', 'testusernameAppleUser@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 

  		List<Account> accList = [Select Id,Name,PersonContactId from Account where id = :oAccount.Id];
        List<Zuora__CustomerAccount__c> bAccount = new List<Zuora__CustomerAccount__c>();
        List<Zuora__Subscription__c> lstSubscription =new list<Zuora__Subscription__c>();
        List<Zuora__PaymentMethod__c> oZuoraPayMethList = new List<Zuora__PaymentMethod__c>();
        Integer  bcount=100;
        Test.startTest();
        for(Account accOb: accList){
            // add Zuora bAccount
            Zuora__CustomerAccount__c zCustomerAcct = new Zuora__CustomerAccount__c();
            zCustomerAcct.Zuora__Account__c = accOb.id;
            zCustomerAcct.Name = accOb.Name;
            zCustomerAcct.Zuora__Status__c = 'Active';
            zCustomerAcct.Zuora__AccountNumber__c = 'A'+bcount;
            //zCustomerAcct.Zuora__Zuora_Id__c = 'A'+bcount+'z';
            zCustomerAcct.Zuora__BillToName__c = 'billing account'+accOb.Name;
            zCustomerAcct.Zuora__BillToCountry__c = 'Japan';
            zCustomerAcct.Zuora__SoldToName__c = 'billing account'+accOb.Name;
            zCustomerAcct.Zuora__DefaultPaymentMethod__c= 'CreditCard';
            zCustomerAcct.Zuora__Batch__c= 'Batch1';
            zCustomerAcct.Zuora__Currency__c= 'JPY';
            zCustomerAcct.Zuora__BillCycleDay__c= '5th of the month';
            bAccount.add(zCustomerAcct);
            bcount++;
        }
        Database.insert(bAccount,true);
        //add Zuora PaymentMethod
        for(Zuora__CustomerAccount__c obill: bAccount){
            Zuora__PaymentMethod__c oPaymethMethod = new Zuora__PaymentMethod__c();
            oPaymethMethod.Zuora__PaymentMethodStatus__c = 'Active';
            oPaymethMethod.Zuora__Type__c = 'CreditCard';
            oPaymethMethod.Zuora__CreditCardMaskNumber__c = '************1111';
            oPaymethMethod.Zuora__CreditCardType__c = 'Visa';
            oPaymethMethod.Zuora__DefaultPaymentMethod__c = true;
            oPaymethMethod.Zuora__CreditCardExpirationMonth__c = '8';
            oPaymethMethod.Zuora__CreditCardExpirationYear__c = '2018';
            oPaymethMethod.Zuora__BankIdentificationNumber__c = '411111';
            oPaymethMethod.Zuora__LastTransactionStatus__c = 'Approved';
            oPaymethMethod.Zuora__BankTransferAccountNumber__c = '4111111111111111';
            oPaymethMethod.Zuora__BillingAccount__c = obill.id;
            oPaymethMethod.Zuora__PaypalEmail__c = 'test@tes.te';
            oZuoraPayMethList.add(oPaymethMethod);
        }
        Database.insert(oZuoraPayMethList,true);
        System.debug('oZuoraPayMethList'+oZuoraPayMethList);
        /*Add Zuora Subscription*/
        for(Zuora__CustomerAccount__c obillAcc: bAccount){
            Zuora__Subscription__c oSubscription = new Zuora__Subscription__c();
            oSubscription.Name = 'test billing account';
            oSubscription.Zuora__Status__c = 'Active';
            oSubscription.Zuora__SubscriptionStartDate__c = Date.Today();
            oSubscription.Zuora__NextChargeDate__c = Date.today().addMonths(2);
            oSubscription.Zuora__Account__c = obillAcc.Zuora__Account__c;
            oSubscription.Zuora__CustomerAccount__c = obillAcc.Id;
            oSubscription.Zuora__TermStartDate__c = Date.Today();
            lstSubscription.add(oSubscription);
          
        }
        Database.insert(lstSubscription,true);

  		System.runAs(cUser) {
  			PageReference pageRef2 = Page.PartnerAccount;
            Test.setCurrentPage(pageRef2);
            ApexPages.currentPage().getParameters().put('field','Email');
  			PartnerAccountController partnerAccountController = new PartnerAccountController();
  			partnerAccountController.freeTrial();
  			partnerAccountController.edit();
  			ApexPages.currentPage().getParameters().put('field','Name');
  			partnerAccountController.edit();

  		}
  		Test.stopTest();
  	}

  	static testMethod void testPasswordChanges() {
        createDaznCommunicatorConfig();
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c ='Active Paid'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<Profile> profile=[select Id,Name from profile where Name='Customer Service Team Member' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=True limit 1];
        system.assertNotEquals(null, oUser);
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        System.RunAs(oUser[0]){
            Test.StartTest();
            PageReference pageRef2 = Page.MyAccount;
            Test.setCurrentPage(pageRef2);
            ApexPages.currentPage().getParameters().put('field','Password');
            //MyAccountController objCntrl = new MyAccountController();
            PartnerAccountController objCntrl = new PartnerAccountController();
            objCntrl.strPassword = 'TestPassword';
            objCntrl.strNewPassword = 'test1234';
            objCntrl.strRepeatPassword = 'test1234';            
            objCntrl.cancelEdit();
            system.assertEquals(objCntrl.isPasswordEdit, false);
            objCntrl.edit();
            system.assertEquals(objCntrl.isPasswordEdit, true);
            objCntrl.savePasswordChanges();
            ApexPages.currentPage().getParameters().put('field','test');
            objCntrl.cancelEdit();
            objCntrl.edit();
            Test.stopTest();
        }
    }

    static testMethod void testNameChanges() {
    	createDaznCommunicatorConfig();
    	User us = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagenttestNameChanges@email.com', 'testcsagenttestNameChanges@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
  		System.runAs(us) {
	  		Account oAccount = SetUpTestData.createDfDAccount('TestFNametestNameChanges2', 'TestLName','test@test.com','Active Paid', '12345567890', 'Apple');
	  		User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailtestNameChanges2@email.com', 'testusernametestNameChanges2@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
	  	}

        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c ='Active Paid' AND Type = 'Apple'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<Profile> profile=[select Id,Name from profile where Name='Customer Service Team Member' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where Account.Type = 'Apple' limit 1];
        System.debug('##### oUser = ' + oUser);
        system.assertNotEquals(null, oUser);
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        System.RunAs(oUser[0]){
            Test.StartTest();
            PageReference pageRef2 = Page.PartnerAccount;
            Test.setCurrentPage(pageRef2);
            ApexPages.currentPage().getParameters().put('field','Password');
            
            PartnerAccountController objCntrl = new PartnerAccountController();
            objCntrl.strFirstName = 'TestFirstName';
            objCntrl.strLastName = 'TestLastNAme';
            objCntrl.saveNameChanges();
            Test.stopTest();
        }
    }

    static testMethod void testDeregisterSingleDevice() {
    	createDaznCommunicatorConfig();
    	User us = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagentSingle@email.com', 'testcsagentSingle@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
  		System.runAs(us) {
	  		Account oAccount = SetUpTestData.createDfDAccount('TestFNameSingle', 'TestLName','test@test.com','Active Paid', '12345567890', 'Apple');
	  		User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailSingle2@email.com', 'testusernameSingle2@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
	  		CreateTestDataforUnitTest.createTestUserDevices();
	  	}
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Paid' AND Type = 'Apple'];
        List<Profile> profile=[select Id,Name from profile where Name='Customer Service Team Member' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User WHERE Account.Type = 'Apple' limit 1];
        system.assertNotEquals(null, oUser);
        List<User_Devices__c> userDiv = [Select Id, Device_Name__c,Account__c,Date_Of_Registration__c,Type__c,Status__c from User_Devices__c where Account__c =: accList[0].id];
        Integer countOfDiv= userDiv.size();
        System.debug('##### userDiv = ' + userDiv);
        System.RunAs(oUser[0]){   
            PageReference oPageReference = Page.PartnerAccount; 
            Test.setCurrentPage(oPageReference); 
            PartnerAccountController objCntrl = new PartnerAccountController();
            objCntrl.selectedDeviceID = userDiv[0].id;
            objCntrl.deregisterSingelUserDevice();
            //List<User_Devices__c> userDivCou = [Select Id from User_Devices__c where Account__c =: accList[0].id];
            //objCntrl.deleteUserDevice(new List<String>{userDiv[0].id});
        }        
    }

    public static void createDaznCommunicatorConfig() {
    	DAZNCommunicatorConfig__c config = new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Successful_en_GB',Value__c=12346);
        insert config;
        DAZNCommunicatorConfig__c config1 = new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Successful_DE_de',Value__c=4603740);
        insert config1;
        DAZNCommunicatorConfig__c config2 = new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Successful_DE_en_GB',Value__c=4603609);
        insert config2;
    }

  	/*End part of PD-10449*/

  	static testMethod void testPasswordChangesApple() {
       	createDaznCommunicatorConfig();
        Account oAccount = SetUpTestData.createDfDAccount('TestFName', 'TestLName','test@test.com','Active Paid', '12345567890', 'Apple');
  		User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailAppleUser@email.com', 'testusernameAppleUser@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 

        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        

        System.RunAs(cUser){
            Test.StartTest();
            PageReference pageRef2 = Page.MyAccount;
            Test.setCurrentPage(pageRef2);
            ApexPages.currentPage().getParameters().put('field','Password');

            PartnerAccountController objCntrl = new PartnerAccountController();
            objCntrl.strPassword = 'TestPassword';
            objCntrl.strNewPassword = 'test1234';
            objCntrl.strRepeatPassword = 'test1234';            
            objCntrl.savePasswordChanges();
            Test.stopTest();
        }
    }

    @isTest static void testSaveEmailChangesApplePass() {
		String newEmail = 'newemail@new.com';

		createDaznCommunicatorConfig();
        Account oAccount = SetUpTestData.createDfDAccount('TestFName', 'TestLName','test@test.com','Active Paid', '12345567890', 'Apple');
  		User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailAppleUser@email.com', 'testusernameAppleUser@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 

		PartnerAccountController pac;

		System.runAs(cUser) {
			Test.startTest();

			pac = new PartnerAccountController();
			pac.strNewEmail = newEmail;
			pac.saveEmailChanges();

			Test.stopTest();
		}

		User userAfterUpdate = [Select Id, Email, AccountId From User Where Id = :cUser.Id LIMIT 1];
		Account accountAfterUpdate = [Select Id, Secondary_Email__c From Account Where Id = :userAfterUpdate.AccountId LIMIT 1];
	}
	@isTest static void testSaveEmailChangesApple() {
		String newEmail = 'newemail@new.com';

		createDaznCommunicatorConfig();
        Account oAccount = SetUpTestData.createDfDAccount('TestFName', 'TestLName','test@test.com','Active Paid', '12345567890', 'Apple');
  		User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailAppleUser@email.com', 'testusernameAppleUser@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 

		PartnerAccountController pac;

		System.runAs(cUser) {
			Test.startTest();

			pac = new PartnerAccountController();

			pac.sSubscriptionTypeDescription = 'test';
			pac.sCurrentPaypalEmail = 'test';
			pac.lastPaymentInfo = 'test';
			pac.sCurrency = 'test';
			pac.freeTrialEndDate = 'test';
			pac.freeTrialCMR = 'test';
			pac.description = 'test';
			pac.showResubscribe = false;
			pac.strReactivationMsg = 'test';

			pac.strPassword = 'TestPassword';
			pac.strNewEmail = newEmail;
			pac.saveEmailChanges();

			Test.stopTest();
		}

		User userAfterUpdate = [Select Id, Email, AccountId From User Where Id = :cUser.Id LIMIT 1];
		Account accountAfterUpdate = [Select Id, Secondary_Email__c From Account Where Id = :userAfterUpdate.AccountId LIMIT 1];
	}

	@isTest static void testNavigated() {
		PartnerAccountController pac = new PartnerAccountController();
		pac.navigatedfd('test');
	}

	@isTest static void testXML() {
		try {
			PartnerAccountController.loadChildsForSetResponse(null);
           	
		} catch(Exception ex){}
		try {
			PartnerAccountController.loadChilds(null);
		} catch(Exception ex){}  
	}

	@isTest static void voidtestGuest() {
		User guestUser = [select id, name from User where userType = 'Guest' AND isActive = true LIMIT 1];
        
        Test.StartTest();
            System.runAs(guestUser) {
	            try {
	               PartnerAccountController partnerAccountController = new PartnerAccountController();
	           	}
               	catch (Exception ex) {}
            }
        Test.stopTest();
	}

	@isTest static void testChangePassAppleForDocomo() {
		User u = getDfDUser();

		Test.startTest();

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();
			pac.savePasswordChangesApple();
		}
		
		Test.stopTest();
	}
	private static User getAppleUser() {
		Id userAccId = [Select Id From Account Where Type = 'Apple' LIMIT 1].Id;
		return [Select Id, AccountId, Country, LanguageLocaleKey  From User Where AccountId = :userAccId];
	}

	@isTest static void testEditNameApple() {
		String newFirstName = 'testNewFirstName';
		String newLastName = 'testNewLastName';

		Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail@email.com','Blocked','testpartner123', 'Apple');
        System.assertNotEquals(null, oTestAccount.Id);
        
        User oCommunityUser = SetUpTestData.createCommunityUser(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        User u = [select Id FROM User Where email = 'testemail1Apl@email.com' LIMIT 1];
		
		Test.startTest();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Name');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();						
			pac.edit();
		}
		
		Test.stopTest();
	}
	@isTest static void testEditEmailApple() {
		String newFirstName = 'testNewFirstName';
		String newLastName = 'testNewLastName';

		Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail@email.com','Blocked','testpartner123', 'Apple');
        System.assertNotEquals(null, oTestAccount.Id);
        
        User oCommunityUser = SetUpTestData.createCommunityUser(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        User u = [select Id FROM User Where email = 'testemail1Apl@email.com' LIMIT 1];
		
		Test.startTest();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Email');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();	
			pac.strCurrentCountry = 'JP';					
			pac.edit();
		}
		
		Test.stopTest();
	}
	@isTest static void testSettingEmailPref() {
		String newFirstName = 'testNewFirstName';
		String newLastName = 'testNewLastName';

		Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail@email.com','Blocked','testpartner123', 'Apple');
        System.assertNotEquals(null, oTestAccount.Id);
        
        User oCommunityUser = SetUpTestData.createCommunityUser(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        User u = [select Id FROM User Where email = 'testemail1Apl@email.com' LIMIT 1];
		
		Test.startTest();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();
			pac.strCurrentCountry = 'DE';						
			pac.settingEmailPreference(oTestAccount);
		}
		
		Test.stopTest();
	}

	@isTest static void testEmailPreflApple() {
		String newFirstName = 'testNewFirstName';
		String newLastName = 'testNewLastName';

		Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail@email.com','Blocked','testpartner123', 'Apple');
		oTestAccount.All_Email_Preferences__c = true;
		oTestAccount.Is_Double_OptIn__c = true;
		update oTestAccount;
        System.assertNotEquals(null, oTestAccount.Id);
        
        User oCommunityUser = SetUpTestData.createCommunityUserDE(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true);
        User u = [select Id FROM User Where email = 'testemail1Apl@email.com' LIMIT 1];
		Test.startTest();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Email');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();	
			pac.bEmailPreference = false;		
			pac.firstTimeLoadEmailPref = true;	
			pac.strCurrentCountry = 'DE';

			pac.setEmailPreferences();
		}
		
		Test.stopTest();
	}
	@isTest static void testEmailPreflAppleCA() {
		String newFirstName = 'testNewFirstName';
		String newLastName = 'testNewLastName';

		Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail@email.com','Blocked','testpartner123', 'Apple');
		oTestAccount.All_Email_Preferences__c = true;
		oTestAccount.Is_Double_OptIn__c = true;
		update oTestAccount;
        System.assertNotEquals(null, oTestAccount.Id);
        
        User oCommunityUser = SetUpTestData.createCommunityUserDE(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true);
        User u = [select Id FROM User Where email = 'testemail1Apl@email.com' LIMIT 1];
		Test.startTest();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Email');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();	
			pac.bEmailPreference = false;		
			pac.firstTimeLoadEmailPref = true;	
			pac.strCurrentCountry = 'CA';

			pac.setEmailPreferences();
		}
		
		Test.stopTest();
	}
	@isTest static void testEmailPreflAppleCAException() {
		String newFirstName = 'testNewFirstName';
		String newLastName = 'testNewLastName';

		Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail@email.com','Blocked','testpartner123', 'Apple');
		oTestAccount.All_Email_Preferences__c = true;
		oTestAccount.Is_Double_OptIn__c = true;
		update oTestAccount;
        System.assertNotEquals(null, oTestAccount.Id);
        
        User oCommunityUser = SetUpTestData.createCommunityUserDE(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true);
        User u = [select Id FROM User Where email = 'testemail1Apl@email.com' LIMIT 1];
		Test.startTest();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Email');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();	
			pac.bEmailPreference = null;		
			pac.firstTimeLoadEmailPref = true;	
			pac.strCurrentCountry = 'CA';
			
			pac.setEmailPreferences();
			
		}
		
		Test.stopTest();
	}
	static testMethod void testDeregisterSingleDeviceException() {
    	createDaznCommunicatorConfig();
    	User us = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagentSingle@email.com', 'testcsagentSingle@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
  		System.runAs(us) {
	  		Account oAccount = SetUpTestData.createDfDAccount('TestFNameSingle', 'TestLName','test@test.com','Active Paid', '12345567890', 'Apple');
	  		User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailSingle2@email.com', 'testusernameSingle2@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
	  		CreateTestDataforUnitTest.createTestUserDevices();
	  	}
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Paid' AND Type = 'Apple'];
        List<Profile> profile=[select Id,Name from profile where Name='Customer Service Team Member' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User WHERE Account.Type = 'Apple' limit 1];
        system.assertNotEquals(null, oUser);
        List<User_Devices__c> userDiv = [Select Id, Device_Name__c,Account__c,Date_Of_Registration__c,Type__c,Status__c from User_Devices__c where Account__c =: accList[0].id];
        Integer countOfDiv= userDiv.size();
        System.RunAs(oUser[0]){   
            PageReference oPageReference = Page.PartnerAccount; 
            Test.setCurrentPage(oPageReference); 
            PartnerAccountController.deleteUserDevice(new List<Id>{oUser[0].Id});
        }        
    }

    @isTest static void testEmailPreflAppleEmailPrefCheck() {
		String newFirstName = 'testNewFirstName';
		String newLastName = 'testNewLastName';

		Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail@email.com','Blocked','testpartner123', 'Apple');
		oTestAccount.All_Email_Preferences__c = true;
		oTestAccount.Is_Double_OptIn__c = true;
		update oTestAccount;
        System.assertNotEquals(null, oTestAccount.Id);
        
        User oCommunityUser = SetUpTestData.createCommunityUserDE(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true);
        User u = [select Id FROM User Where email = 'testemail1Apl@email.com' LIMIT 1];
		Test.startTest();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Email');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();	
			pac.bEmailPreference = true;		
			pac.firstTimeLoadEmailPref = false;	
			pac.strCurrentCountry = 'DE';

			pac.setEmailPreferences();
		}
		
		Test.stopTest();
	}
	@isTest static void testUpdateLang() {
		
		Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail@email.com','Blocked','testpartner123', 'Apple');
		
        User oCommunityUser = SetUpTestData.createCommunityUserDE(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true);
        User u = [select Id FROM User Where email = 'testemail1Apl@email.com' LIMIT 1];
		Test.startTest();

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();	
			pac.oZPayment = null;
			pac.strSelectedLanguage = 'en_GB';
			pac.updateUserLanguage();
		}
		
		Test.stopTest();
	}
	@isTest static void testEditEmailJP() {
		String newEmail = 'test1@test1.com';

		User u = getDfDUser();

		Test.startTest();

		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Name');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();
			pac.oAccount.Secondary_Email__c = newEmail;
			pac.strCurrentCountry = 'JP';
			pac.edit();
		}
		
		Test.stopTest();
	}
	static testMethod void testNameChangesAppleJp() {
    	createDaznCommunicatorConfig();
    	User us = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagenttestNameChanges@email.com', 'testcsagenttestNameChanges@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
  		System.runAs(us) {
	  		Account oAccount = SetUpTestData.createDfDAccount('TestFNametestNameChanges2', 'TestLName','test@test.com','Active Paid', '12345567890', 'Apple');
	  		User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailtestNameChanges2@email.com', 'testusernametestNameChanges2@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
	  	}

        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c ='Active Paid' AND Type = 'Apple'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<Profile> profile=[select Id,Name from profile where Name='Customer Service Team Member' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where Account.Type = 'Apple' limit 1];
        system.assertNotEquals(null, oUser);
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        System.RunAs(oUser[0]){
            Test.StartTest();
            PageReference pageRef2 = Page.PartnerAccount;
            Test.setCurrentPage(pageRef2);
            ApexPages.currentPage().getParameters().put('field','Password');
            
            PartnerAccountController objCntrl = new PartnerAccountController();
            objCntrl.strFirstName = 'TestFirstName';
            objCntrl.strLastName = 'TestLastNAme';
            objCntrl.strCurrentCountry = 'JP';
            objCntrl.saveNameChanges();
            Test.stopTest();
        }
    }
    @isTest static void testSaveDocomoEmailChangesErrorExistingEmailApple() {
		
		String newFirstName = 'testNewFirstName';
		String newLastName = 'testNewLastName';
		Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail1Apl@email.com','Blocked','testpartner123', 'Apple');
		oTestAccount.All_Email_Preferences__c = true;
		oTestAccount.Is_Double_OptIn__c = true;
		update oTestAccount;
        System.assertNotEquals(null, oTestAccount.Id);
        
        User oCommunityUser = SetUpTestData.createCommunityUserDE(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true);
        User u = [select Id FROM User Where email = 'testemail1Apl@email.com' LIMIT 1];
		Test.startTest();
		String newEmail = 'testemail1Apl@email.com';
		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Email');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();
    	    pac.strNewEmail = newEmail;
		    pac.saveEmailChangesApple();
		}
		
		Test.stopTest();
	}
	@isTest static void testSaveDocomoEmailChangesErrorExistingEmailAppleDuplicate() {
		
		String newFirstName = 'testNewFirstName';
		String newLastName = 'testNewLastName';
		Account oTestAccount1 = SetUpTestData.createDfDAccount('TestFirstName2', 'TestLastName2','testemail1Apl2222@email.com','Blocked','testpartner1232', 'Apple');
		Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail1Apl@email.com','Blocked','testpartner123', 'Apple');
		oTestAccount.All_Email_Preferences__c = true;
		oTestAccount.Is_Double_OptIn__c = true;
		update oTestAccount;
        System.assertNotEquals(null, oTestAccount.Id);
        
        User oCommunityUser = SetUpTestData.createCommunityUserDE(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true);
        User u = [select Id FROM User Where email = 'testemail1Apl@email.com' LIMIT 1];
		Test.startTest();
		String newEmail = 'testemail1Apl2222@email.com';
		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Email');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();
    	    pac.strNewEmail = newEmail;
		    pac.saveEmailChangesApple();
		}
		
		Test.stopTest();
	}
	@isTest static void testSaveEmailAppleExisting() {
		
		String newFirstName = 'testNewFirstName';
		String newLastName = 'testNewLastName';
		Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail1Apl@email.com','Blocked','testpartner123', 'Apple');
		oTestAccount.All_Email_Preferences__c = true;
		oTestAccount.Is_Double_OptIn__c = true;
		update oTestAccount;
        System.assertNotEquals(null, oTestAccount.Id);
        
        User oCommunityUser = SetUpTestData.createCommunityUserDE(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true);
        User u = [select Id FROM User Where email = 'testemail1Apl@email.com' LIMIT 1];
		Test.startTest();
		String newEmail = 'testemail1Apl@email.com';
		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Email');

		System.runAs(u) {
			PartnerAccountController pac = new PartnerAccountController();
    	    pac.strNewEmail = newEmail;
		    pac.saveEmailChanges();
		}
		
		Test.stopTest();
	}

	/*Start part of PD-12480*/
    @IsTest
    static void testGetDevicesIncorrectJSON() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1146543@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                
                Test.setMock(HttpCalloutMock.class, new MockUserDevicesResponse());
                PartnerAccountController myAccountController = new PartnerAccountController();
                myAccountController.getUserDevices();
                System.assert(myAccountController.isDevicesFromMISL == true);

            Test.stopTest();
        }
    }

    @IsTest
    static void testGetDevicesCorrectJSON() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1145322@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                
                Test.setMock(HttpCalloutMock.class, new MockUserDevicesResponseCorrectJSON());
                PartnerAccountController myAccountController = new PartnerAccountController();
                myAccountController.getUserDevices();
                System.assert(myAccountController.isDevicesFromMISL == true);
                System.assert(myAccountController.wrapUDList.isEmpty() == false);

            Test.stopTest();
        }
    }

    @IsTest
    static void testGetDevicesFourDevices() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1149876@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                
                Test.setMock(HttpCalloutMock.class, new MockUserDevicesResponseFourDevices());
                PartnerAccountController myAccountController = new PartnerAccountController();
                myAccountController.getUserDevices();
                System.assert(myAccountController.isDevicesFromMISL == true);
                System.assert(myAccountController.wrapUDListFull.size() > 3);

            Test.stopTest();
        }
    }

    @IsTest
    static void testGetDevicesFourDevicesShowAllUserDevices() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername114534@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                
                Test.setMock(HttpCalloutMock.class, new MockUserDevicesResponseFourDevices());
                PartnerAccountController myAccountController = new PartnerAccountController();
                myAccountController.showAllUserDevices();
                myAccountController.getUserDevices();
                System.assert(myAccountController.isDevicesFromMISL == true);
                System.assert(myAccountController.wrapUDListFull.size() > 3);

            Test.stopTest();
        }
    }

    @IsTest
    static void testShowSignOutBannersinledevicePartner() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1141111@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                
                Test.setMock(HttpCalloutMock.class, new MockUserDevicesResponseFourDevices());
                PartnerAccountController myAccountController = new PartnerAccountController();
                myAccountController.getUserDevices();
                System.assert(myAccountController.isDevicesFromMISL == true);
                myAccountController.showSignOutBannersinledevice();
                System.assert(myAccountController.showStartWatchingDAZN == false);

            Test.stopTest();
        }
    }

    @IsTest
    static void testDeregisterSingelUserDevicePartner() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername11214@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();

                PartnerAccountController myAccountController = new PartnerAccountController();
                myAccountController.selectedDeviceID = 'deviceId1';
                //myAccountController.strCurrentCountry = 'DE';
                Test.setMock(HttpCalloutMock.class, new MockDeregisterSingleDevice());
                myAccountController.deregisterSingelUserDevice();
                List<AuthSession> auth = [SELECT Id FROM AuthSession WHERE UsersId = :oUser.Id];
                System.assert(auth.isEmpty());
            Test.stopTest();
        }
    }

    @IsTest
    static void testDeregisterSingelUserDeviceSuccess() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        /*oAccount.Notification_Country_Code__c = 'de';
        update oAccount;*/
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusernam123e114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();

                PartnerAccountController myAccountController = new PartnerAccountController();
                myAccountController.selectedDeviceID = 'deviceId1';
                //myAccountController.strCurrentCountry = 'DE';
                Test.setMock(HttpCalloutMock.class, new MockDeregisterSingleDevice());
                myAccountController.deregisterSingelUserDevice();
                List<AuthSession> auth = [SELECT Id FROM AuthSession WHERE UsersId = :oUser.Id];
                System.assert(auth.isEmpty());
            Test.stopTest();
        }
    }

    @IsTest
    static void testDeregisterSingelUserDeviceError() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        oAccount.Notification_Country_Code__c = 'de';
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusernamwe114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                ApexPages.currentPage().getParameters().put('banner', 'deregisterDeviceFail');
                PartnerAccountController myAccountController = new PartnerAccountController();
                myAccountController.signoutAllDevices();
                System.assert(myAccountController.showbanner == true);
            Test.stopTest();
        }
    }

    @IsTest
    static void testSignOutFromAllDevice() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        oAccount.Notification_Country_Code__c = 'de';
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusernfghame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();

                PartnerAccountController myAccountController = new PartnerAccountController();
                myAccountController.selectedDeviceID = 'deviceId1';
               // myAccountController.strCurrentCountry = 'DE';
                Test.setMock(HttpCalloutMock.class, new MockDeregisterSingleDevice());
                myAccountController.signoutAllDevices();
                List<AuthSession> auth = [SELECT Id FROM AuthSession WHERE UsersId = :oUser.Id];
                System.assert(auth.isEmpty());
            Test.stopTest();
        }
    }

    @IsTest
    static void testSignOutFromAllDeviceCancell() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        oAccount.Notification_Country_Code__c = 'de';
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testuserfghname114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();

                PartnerAccountController myAccountController = new PartnerAccountController();
                myAccountController.selectedDeviceID = 'deviceId1';
               // myAccountController.strCurrentCountry = 'DE';
                ApexPages.currentPage().getParameters().put('cancelButtonclick', 'true');
                Test.setMock(HttpCalloutMock.class, new MockDeregisterSingleDevice());
                myAccountController.signoutAllDevices();
                List<AuthSession> auth = [SELECT Id FROM AuthSession WHERE UsersId = :oUser.Id];
                System.assert(auth.isEmpty());
            Test.stopTest();
        }
    }

    @IsTest
    static void testCloseBannerMISL() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testuserndasame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();

                PartnerAccountController myAccountController = new PartnerAccountController();
                myAccountController.closeBanner();
                System.assert(myAccountController.showbanner == false);
            Test.stopTest();
        }
    }

    @IsTest
    static void testShowSignOutBannerMISL() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusersdfname114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();

                PartnerAccountController myAccountController = new PartnerAccountController();
                //myAccountController.nextPayValForPause = 'test';
                myAccountController.showSignOutBanner();
                System.assert(myAccountController.showbanner == true);
            Test.stopTest();
        }
    }
    public class MockUserDevicesResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                    '"Devices": [' +
                        '{' +
                            '"Id": "deviceId1",' +
                            '"RegistrationDate": "2017-03-10 10:42:43.379Z",' +
                            '"Type": "Tablet"' +
                        '},' +
                        '{' +
                            '"Id": "deviceId2",' +
                            '"RegistrationDate": "2017-03-11 10:44:43.379Z",' +
                            '"Type": "TV"' +
                        '}' +
                    ']' +
                '}'
            );
            res.setStatusCode(200);
            return res;
        }
    }
    public class MockUserDevicesResponseCorrectJSON implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                    '"Devices": [' +
                        '{' +
                            '"Id": "deviceId1",' +
                            '"RegistrationDate": "2017-03-10T10:42:43.379Z",' +
                            '"Type": "Tablet"' +
                        '},' +
                        '{' +
                            '"Id": "deviceId2",' +
                            '"RegistrationDate": "2017-03-11T10:44:43.379Z",' +
                            '"Type": "TV"' +
                        '}' +
                    ']' +
                '}'
            );
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockUserDevicesResponseFourDevices implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                    '"Devices": [' +
                        '{' +
                            '"Id": "deviceId1",' +
                            '"RegistrationDate": "2017-03-10T10:42:43.379Z",' +
                            '"Type": "Tablet"' +
                        '},' +
                        '{' +
                            '"Id": "deviceId2",' +
                            '"RegistrationDate": "2017-03-11T10:44:43.379Z",' +
                            '"Type": "TV"' +
                        '},' +
                        '{' +
                            '"Id": "deviceId3",' +
                            '"RegistrationDate": "2017-03-10T10:42:43.379Z",' +
                            '"Type": "Tablet"' +
                        '},' +
                        '{' +
                            '"Id": "deviceId4",' +
                            '"RegistrationDate": "2017-03-10T10:42:43.379Z",' +
                            '"Type": "Tablet"' +
                        '}'+
                    ']' +
                '}'
            );
            res.setStatusCode(200);
            return res;
        }
    }
    public class MockDeregisterSingleDevice implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                '"Device(s) de-registered"' +
                '}'
            );
            res.setStatusCode(204);
            return res;
        }
    }
    /*End part of PD12480*/

    /*Start part of PD-15209*/
    @isTest 
    static void testSaveMISLDocomoEmailChangesApple() {
		SetUpTestData.createMISLSetting();
		String newFirstName = 'testNewFirstName';
		String newLastName = 'testNewLastName';
		Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail1Apl@email.com','Blocked','testpartner123', 'Apple');
		oTestAccount.All_Email_Preferences__c = true;
		oTestAccount.Is_Double_OptIn__c = true;
		update oTestAccount;
        System.assertNotEquals(null, oTestAccount.Id);
        
        User oCommunityUser = SetUpTestData.createCommunityUserDE(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true);
        User u = [select Id, AccountId,Account.DAZN_Id__c FROM User Where email = 'testemail1Apl@email.com' LIMIT 1];
		Test.startTest();
		String newEmail = 'testemail1Aple@email.com';
		PageReference tpageRef = Page.PartnerAccount;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('field', 'Email');

		System.runAs(u) {
		    PartnerAccountController.sendEmailtoMISL(u, 'testemail1Aple@email.com' , 'DE');
		}
		
		Test.stopTest();
	}
    /*End part of PD-15209*/

    /*Start part of PD-15208*/
    @IsTest
    static void testChangeLanguageCorrect() {
        SetUpTestData.createMISLSetting();
        Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail1Apl@email.com','Blocked','testpartner123', 'Docomo');
        User oCommunityUser = SetUpTestData.createCommunityUserDE(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true);        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oTestAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User us = [SELECT Id, LanguageLocaleKey, Account.Notification_Country_Code__c FROM User WHERE Id = :oCommunityUser.Id LIMIT 1];
        System.assert(us != null);
        System.runAs(us) {
            Test.startTest();
                PartnerAccountController objCntrl = new PartnerAccountController();
                Test.setMock(HttpCalloutMock.class, new MockUpdateUserDetailsSuccessResponse());
                objCntrl.strCurrentCountry= 'DE';
                objCntrl.strSelectedLanguage = 'DE';            
                objCntrl.updateUserLanguage();
            Test.stopTest();
            User usr = [SELECT Id, LanguageLocaleKey, Account.Notification_Country_Code__c FROM User WHERE Id = :us.Id LIMIT 1];
            System.assert(usr.Account.Notification_Country_Code__c.toLowerCase() != null);
        }
    }

    @IsTest
    static void testChangeLanguageCorrectfr() {
        SetUpTestData.createMISLSetting();
        Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail1Apl@email.com','Blocked','testpartner123', 'Docomo');
        User oCommunityUser = SetUpTestData.createCommunityUserDE(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true);        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oTestAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        
        System.runAs(oCommunityUser) {
            Test.startTest();
                
                PartnerAccountController objCntrl = new PartnerAccountController();
                Test.setMock(HttpCalloutMock.class, new MockUpdateUserDetailsSuccessResponse());
                objCntrl.strCurrentCountry= 'CA';
                objCntrl.strSelectedLanguage = 'fr';            
                objCntrl.updateUserLanguage();
            Test.stopTest();
            User us = [SELECT Id, LanguageLocaleKey, Account.Notification_Country_Code__c FROM User WHERE Id = :oCommunityUser.Id LIMIT 1];
            System.assert(us.Account.Notification_Country_Code__c.toLowerCase() != null);
        }        
    }
    @IsTest
    static void testChangeLanguageCorrectfr_CA() {
        SetUpTestData.createMISLSetting();
        Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail1Apl@email.com','Blocked','testpartner123', 'Docomo');
        User oCommunityUser = SetUpTestData.createCommunityUserDE(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true);        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oTestAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        
        System.runAs(oCommunityUser) {
            Test.startTest();
                
                PartnerAccountController objCntrl = new PartnerAccountController();
                Test.setMock(HttpCalloutMock.class, new MockUpdateUserDetailsSuccessResponse());
                objCntrl.strCurrentCountry= 'CA';
                objCntrl.strSelectedLanguage = 'fr_CA';            
                objCntrl.updateUserLanguage();
            Test.stopTest();
            User us = [SELECT Id, LanguageLocaleKey, Account.Notification_Country_Code__c FROM User WHERE Id = :oCommunityUser.Id LIMIT 1];
            System.assert(us.Account.Notification_Country_Code__c.toLowerCase() != null);
        }        
    }
    @IsTest
    static void testChangeLanguageCorrecten_US() {
        SetUpTestData.createMISLSetting();
        Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail1Apl@email.com','Blocked','testpartner123', 'Docomo');
        User oCommunityUser = SetUpTestData.createCommunityUserDE(oTestAccount.Id, 'testemail1Apl@email.com', 'testusername1Apl@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true);        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oTestAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        

        System.runAs(oCommunityUser) {
            Test.startTest();
                PartnerAccountController objCntrl = new PartnerAccountController();
                Test.setMock(HttpCalloutMock.class, new MockUpdateUserDetailsSuccessResponse());
                objCntrl.strCurrentCountry= 'CA';
                objCntrl.strSelectedLanguage = 'en_US';            
                objCntrl.updateUserLanguage();
            Test.stopTest();
            User us = [SELECT Id, LanguageLocaleKey, Account.Notification_Country_Code__c FROM User WHERE Id = :oCommunityUser.Id LIMIT 1];
            System.assert(us.Account.Notification_Country_Code__c.toLowerCase() != null);
        }        
    }
    public class MockUpdateUserDetailsSuccessResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                  '"UserDetails": {' +
                    '"AccountId": "0019E00000PEe1mQAD",' +
                    '"Email": "test@test.test",' +
                    '"FirstName": "TestDEUseTest",' +
                    '"LastName": "SkorTest",' +
                    '"LanguageCode": "DE",' +
                    '"DaznEmailsOptIn": false,' +
                    '"NflEmailsOptIn": false,' +
                    '"UserAccountStatus": "Active Paid"' +
                  '}' +
               '}'
            );
            res.setStatusCode(200);
            return res;
        }
    }
    /*End part of PD-15208*/

}