@isTest
private class FetchLanguageCookieControllerTest {

	@testSetup
    public static void setUpTestData() {
        List<DAZN_Help_Redirect__c> dhr = new List<DAZN_Help_Redirect__c>();
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Japan',
            Country__c = 'Japan',
            CountryISOCode__c = 'JP',
            IsDefaultCountry__c = false,
            Language__c = 'ja'
        ));
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Japan en',
            Country__c = 'Japan',
            CountryISOCode__c = 'JP',
            IsDefaultCountry__c = false,
            Language__c = 'en'
        ));
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Germany',
            Country__c = 'Germany',
            CountryISOCode__c = 'DE',
            IsDefaultCountry__c = true,
            Language__c = 'en'
        ));
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Canada',
            Country__c = 'Canada',
            CountryISOCode__c = 'CA',
            IsDefaultCountry__c = true,
            Language__c = 'fr_CA'
        ));
        insert dhr;

        List<DAZNConfiguration__c> dc = new List<DAZNConfiguration__c>();
        dc.add(new DAZNConfiguration__c(
            Name = 'Geo IP timeout',
            Value__c ='4999'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'IPADDRESSFINDER',
            Value__c ='http://geoip.nekudo.com/api/'
        ));
        insert dc;
    }
	
    public static testMethod void testfetchBrowserLanguageCookie() {
        PageReference currentPage = ApexPages.currentPage();
        Cookie lang = new Cookie('lang', 'ja', null, -1, false);
        Cookie country = new Cookie('Country', 'JP', null, -1, false);
        currentPage.setCookies(new Cookie[] {lang, Country});

        FetchLanguageCookieController flcc = new FetchLanguageCookieController();
        flcc.strParamLang = 'ja';
        flcc.strBrowserLang = 'ja';
        flcc.strPageName = 'mylogin';
        flcc.fetchBrowserLanguage();
        System.assertEquals(true, currentPage.getParameters().get('lang') != null);
        System.assertEquals(true, currentPage.getParameters().get('Country') != null);
    }

    public static testMethod void testfetchBrowserLanguageGuest() {
        User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];
        PageReference currentPage = ApexPages.currentPage();

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('Tokyo', 'Japan'));
        System.RunAs(u) {
        	FetchLanguageCookieController flcc = new FetchLanguageCookieController();
            flcc.strBrowserLang = 'ja';
            flcc.fetchBrowserLanguage();
        }
        Test.stopTest();

        System.assertEquals('ja', currentPage.getParameters().get('lang'));
        System.assertEquals('JP', currentPage.getParameters().get('Country'));
    }

    public static testMethod void testfetchBrowserLanguageGuestSignIn() {
        User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];
        PageReference currentPage = ApexPages.currentPage();

        PageReference pr;

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('Tokyo', 'Japan'));
        System.RunAs(u) {
            FetchLanguageCookieController flcc = new FetchLanguageCookieController();
            flcc.strBrowserLang = 'ja';
            flcc.strPageName = 'mylogin';
            pr = flcc.fetchBrowserLanguage();
        }
        Test.stopTest();

        System.assertEquals('ja', currentPage.getParameters().get('lang'));
        System.assertEquals('JP', currentPage.getParameters().get('Country'));
        System.assertNotEquals(null, pr);
        System.assertEquals('/apex/signin?Country=JP&lang=ja', pr.getURL());
    }

    public static testMethod void testfetchBrowserLanguageUser() {
        Account oAccount = SetUpTestData.createPersonAccount('DE', 'en_US', 'TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser('en_US', 'DE', oAccount.Id, 'testemail@email.com', 'testusername17@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        PageReference currentPage = ApexPages.currentPage();

        Test.StartTest();

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('Tokyo', 'Japan'));
        System.RunAs(cUser) {
        	FetchLanguageCookieController flcc = new FetchLanguageCookieController();
            flcc.strBrowserLang = 'ja';
            flcc.fetchBrowserLanguage();
        }
        Test.stopTest();
        
        System.assertEquals('en', currentPage.getParameters().get('lang'));
        System.assertEquals('DE', currentPage.getParameters().get('Country'));
    }

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