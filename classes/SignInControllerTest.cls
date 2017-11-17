@isTest
private class SignInControllerTest {
	
	@isTest static void testController() {
		Test.startTest();
        SignInController signInController = new SignInController();
		Test.stopTest();
		System.assertNotEquals(null, signInController);
	}

	@isTest static void testRedirectToHomePage() {
		DAZNConfiguration__c config = new DAZNConfiguration__c(
			Name = 'HomePageURL',	
			Value__c = '/testHome'
		);
		insert config;

		Test.startTest();
        SignInController signInController = new SignInController();
        signInController.toGetuserIPAddress();
        signInController.sCountry = 'DE';
        signInController.strLanguage  = 'en_GB';
        PageReference pr = signInController.redirectToHomePage();
		Test.stopTest();
		System.assertEquals('/testHome', pr.getUrl());
	}
	
	@isTest static void testRedirectToDocomoSignInPage() {
		User testGuestUser = [Select Id, Name From User Where userType = 'Guest' AND isActive = true LIMIT 1];
		ApexPages.currentPage().getParameters().put('lang', 'en-US');
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('London', 'United Kingdom'));
		PageReference pr;
		System.runAs(testGuestUser) {
            SignInController signInController = new SignInController();
            pr = signInController.redirectToDocomoSignInPage();
        }
		Test.stopTest();
        // Commented for deployment
        PageReference prTest = System.Page.DocomoSignIn;
        prTest.getParameters().put('auth', 'true');
		System.assertEquals(prTest.getUrl(), pr.getUrl());
		//System.assertEquals(null, pr);
	}
	  //Added as Part of PD-15349
     @testSetup
    public static void setUpTestDataOne() {
        List<DAZNConfiguration__c> dhr = new List<DAZNConfiguration__c>();
        dhr.add(new DAZNConfiguration__c(
            Name = 'Geo IP timeout',
            Value__c ='4999'
        ));
        //Modified as part of PD-15349
        dhr.add(new DAZNConfiguration__c(
            Name = 'IPADDRESSFINDER',
            Value__c ='http://geoip.nekudo.com/api/'
        ));
          insert dhr;
    }//End of PD-15349
	/*@isTest static void testFetchBrowserLanguageJA() {
		List<DAZN_Help_Redirect__c> dhr = new List<DAZN_Help_Redirect__c>();
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Japan',
            Country__c = 'Japan',
            CountryISOCode__c = 'JP',
            IsDefaultCountry__c = false,
            Language__c = 'ja'
        ));
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Germany',
            Country__c = 'Germany',
            CountryISOCode__c = 'DE',
            IsDefaultCountry__c = true,
            Language__c = 'en'
        ));
        insert dhr;

		User testGuestUser = [Select Id, Name From User Where userType = 'Guest' AND isActive = true LIMIT 1];

		PageReference pr;

		Test.startTest();
		PageReference pageRef = Page.signIn;
		Test.setCurrentPage(pageRef);
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('London', 'United Kingdom'));

		System.runAs(testGuestUser) {
			SignInController signInController = new SignInController();
            signInController.strLang = 'ja';
            pr = signInController.fetchBrowserLanguage();
		}        
		Test.stopTest();

		System.assertEquals('/signin?Country=DE&lang=en', pr.getUrl());
	}

	@isTest static void testFetchBrowserLanguageEN() {
		List<DAZN_Help_Redirect__c> dhr = new List<DAZN_Help_Redirect__c>();
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Japan',
            Country__c = 'Japan',
            CountryISOCode__c = 'JP',
            IsDefaultCountry__c = false,
            Language__c = 'ja'
        ));
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Germany',
            Country__c = 'Germany',
            CountryISOCode__c = 'DE',
            IsDefaultCountry__c = true,
            Language__c = 'en'
        ));
        insert dhr;

		PageReference pr;

		Test.startTest();
		PageReference pageRef = Page.signIn;
		pageRef.getParameters().put('lang', 'en');
		Test.setCurrentPage(pageRef);
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('London', 'United Kingdom'));

    	SignInController signInController = new SignInController();
        signInController.strLang = 'en';
        pr = signInController.fetchBrowserLanguage();

		Test.stopTest();

		System.assertEquals('/signin?Country=DE&lang=en', pr.getUrl());
	}*/



	public class MockHttpResponseGenerator implements HttpCalloutMock {
        private String cityName;
        private String countryName;

        public MockHttpResponseGenerator() {
            this.cityName = 'City';
            this.countryName = 'Country';
        }

        public MockHttpResponseGenerator(String cityName, String countryName) {
            this.cityName = cityName;
            this.countryName = countryName;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"city":"' + cityName + '","country":{"name":"' + countryName + '","code":"11"},"location":{"accuracy_radius":200,"latitude":1,"longitude":1,"time_zone":"1"},"ip":"1.1.1.1"}');
            res.setStatusCode(200);
            return res;
        }
    }
	
}