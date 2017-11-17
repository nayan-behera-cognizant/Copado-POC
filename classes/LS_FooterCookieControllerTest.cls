@isTest
private class LS_FooterCookieControllerTest {
    
    @isTest static void testConstructor() {
        DAZNLanguageConfiguration__c oDAZNLangConfig = new DAZNLanguageConfiguration__c();
        oDAZNLangConfig.Name = '1';
        oDAZNLangConfig.Country__c = 'Canada';
        oDAZNLangConfig.Country_Code__c = 'CA';
        oDAZNLangConfig.Default_Language__c = 'en_US';
        oDAZNLangConfig.Language__c = 'English';
        oDAZNLangConfig.Language_Code__c = 'en_US';
        insert oDAZNLangConfig;

        ApexPages.currentPage().getParameters().put('Country', 'CA');
        ApexPages.currentPage().getParameters().put('lang', 'en');
        ApexPages.currentPage().getParameters().put('TrakingParams', 'TrakingParams');
        LS_FooterCookieController ctrl = new LS_FooterCookieController();
        ctrl.nameOfPage = 'mylogin';
        ctrl.renderdLangSwitcher = true;
        ctrl.selectedLanguage = 'en';
        ctrl.langToChange = 'fr_CA';
        ctrl.countryToChange = 'CA';

        System.assertEquals('CA', ctrl.sCountry);
        System.assertEquals('en', ctrl.sLang);
        System.assertEquals('TrakingParams', ctrl.sTrakingParams);
        System.assertEquals('/help/' + ctrl.sCountry + '-' + ctrl.sLang + (ctrl.sTrakingParams == null ? '' : ctrl.sTrakingParams), ctrl.helpURL);
        System.assertEquals('/help/' + ctrl.sCountry + '-' + ctrl.sLang + '/' + 'FAQ' + (ctrl.sTrakingParams == null ? '' : ctrl.sTrakingParams), ctrl.faqURL);
        System.assertEquals('/help/' + ctrl.sCountry + '-' + ctrl.sLang + '/' + 'terms' + (ctrl.sTrakingParams == null ? '' : ctrl.sTrakingParams), ctrl.termsURL);
        System.assertEquals('/help/' + ctrl.sCountry + '-' + ctrl.sLang + '/' + 'privacy' + (ctrl.sTrakingParams == null ? '' : ctrl.sTrakingParams), ctrl.privacyURL);
        System.assertEquals('/help/' + ctrl.sCountry + '-' + ctrl.sLang + '/' + 'about' + (ctrl.sTrakingParams == null ? '' : ctrl.sTrakingParams), ctrl.aboutURL);

        System.assertEquals(true, ctrl.getLanguageExists());
        System.assertEquals(true, ctrl.getCountryExists());

        System.assertNotEquals(null, ctrl);
    }
    
    @isTest static void testTranslatePageToSelectedLanguage() {
        ApexPages.currentPage().getParameters().put('Country', 'CA');
        ApexPages.currentPage().getParameters().put('lang', 'en');
        ApexPages.currentPage().getParameters().put('TrakingParams', 'TrakingParams');
        LS_FooterCookieController ctrl = new LS_FooterCookieController();
        ctrl.nameOfPage = 'mylogin';
        ctrl.renderdLangSwitcher = true;
        ctrl.selectedLanguage = 'en';
        ctrl.langToChange = 'fr_CA';
        ctrl.countryToChange = 'CA';
        ctrl.translatePageToSelectedLanguage();
        System.assertEquals(ctrl.countryToChange, ApexPages.currentPage().getParameters().get('Country'));
        System.assertEquals(ctrl.langToChange, ApexPages.currentPage().getParameters().get('lang'));
    }
    
}