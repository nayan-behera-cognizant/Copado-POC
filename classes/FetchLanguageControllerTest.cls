@isTest
private class FetchLanguageControllerTest {
	
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
        insert dhr;
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
	@isTest static void testFetchLanguage() {
        User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];

		PageReference pr;

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new CommunityHelperTest.MockHttpResponseGenerator('London', 'United Kingdom'));

        System.runAs(u) {
    	    FetchLanguageController fetchLanguageController = new FetchLanguageController();
            fetchLanguageController.strLang = 'en';
            fetchLanguageController.strPageName = 'mylogin';
            pr = fetchLanguageController.fetchBrowserLanguage();
        }

		Test.stopTest();

		System.assertEquals('/mylogin/DE-en', pr.getUrl());
	}
	
}