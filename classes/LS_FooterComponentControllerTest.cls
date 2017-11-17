/**
* @author Cognizant Technology Solutuions
* @date 05/02/2015
* @description This class test contactus functionality.
*/
@istest
public class LS_FooterComponentControllerTest{
    
    static testMethod void testFooterComponent() {
    
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        CreateTestDataforUnitTest.CreateGuestUser();
        test.starttest();
        User oUser =[select id from user where Country=: 'Japan'AND isActive=TRUE limit 1];
        oUser.Notification_Language_Code__c='ja';
        update Ouser;
        //test.stoptest();
        
        DAZN_Help_Redirect__c helpRedirectSetting = new DAZN_Help_Redirect__c();
        helpRedirectSetting.Name = 'Japan';
        helpRedirectSetting.CountryISOCode__c = 'JP';
        helpRedirectSetting.IsDefaultCountry__c = false;
        helpRedirectSetting.Country__c = 'Japan';
        helpRedirectSetting.Language__c = 'ja';
        helpRedirectSetting.FooterAboutLinkCustomLabel__c = 'LS_Footer_imprint';
        helpRedirectSetting.FooterAboutTitleCustomLabel__c = 'LS_Footer_imprint';
        insert helpRedirectSetting;
        
        DAZNLanguageConfiguration__c oDAZNLangConfig = new DAZNLanguageConfiguration__c();
        oDAZNLangConfig.Name = '1';
        oDAZNLangConfig.Country__c = 'Japan';
        oDAZNLangConfig.Country_Code__c='JP';
        oDAZNLangConfig.Default_Language__c='ja';
        oDAZNLangConfig.Language__c='English';
        oDAZNLangConfig.Language_Code__c='ja';
        insert oDAZNLangConfig ; 
        
        System.RunAs(oUser){
            //Test.StartTest();
                PageReference testPR = new PageReference('Page.myLogin');
                testPR.getParameters().put('Country', 'JP');
                testPR.getParameters().put('lang', 'ja');
                Test.setCurrentPageReference(testPR);
                LS_FooterComponentController oFooterComponent = new LS_FooterComponentController();
                oFooterComponent.getDAZNLanguage();
                oFooterComponent.getLanguageExists();
                oFooterComponent.translatePageToSelectedLanguage();
            Test.StopTest();
        }
        
          System.assertNotEquals(null, oUser.Notification_Language_Code__c );
          System.assertEquals('Japan', oDAZNLangConfig.Country__c );
        
    }
      static testMethod void testFooterURLSforJapan() {
        
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        User oUser =[select id from user where Country=: 'Japan' AND isActive=TRUE limit 1];
        oUser.Notification_Language_Code__c='ja';
        oUser.Country='Pakistan';
        update Ouser;

        
        System.RunAs(oUser){
                Test.StartTest();
                Test.setCurrentPageReference(new PageReference('Page.help'));
                ApexPages.currentPage().getParameters().put('Country','JP');
                ApexPages.currentPage().getParameters().put('lang','ja');
                LS_FooterComponentController oFooterComponent = new LS_FooterComponentController();      
                Test.StopTest();
            }
         System.assertNotEquals(null, oUser.Notification_Language_Code__c );
         System.assertEquals('Pakistan', oUser.Country);
    }
    
      static testMethod void testFooterURLSforJapanEnglish() {
        
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        User oUser =[select id from user where Country=: 'Japan' AND isActive=TRUE limit  1];
        oUser.Notification_Language_Code__c='ja';
        oUser.Country='Pakistan';
        update Ouser;
    
    
        System.RunAs(oUser){  
            Test.StartTest();
            Test.setCurrentPageReference(new PageReference('Page.help'));
            ApexPages.currentPage().getParameters().put('Country','JP');
            ApexPages.currentPage().getParameters().put('lang','en');
            LS_FooterComponentController oFooterComponent = new LS_FooterComponentController();
            Test.StopTest();
        }
         System.assertNotEquals(null, oUser.Notification_Language_Code__c );
          System.assertEquals('Pakistan', oUser.Country);
    }
    
     static testMethod void testFooterURLSforJapanJapanese() {  
         
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        User oUser =[select id from user where Country=: 'Japan' AND isActive=TRUE limit 1];
        oUser.Notification_Language_Code__c='ja';
        oUser.Country='Pakistan';
        update Ouser;
        
        System.RunAs(oUser){
            Test.StartTest();
            Test.setCurrentPageReference(new PageReference('Page.help'));
            ApexPages.currentPage().getParameters().put('Country','JP');
            ApexPages.currentPage().getParameters().put('lang','en');
            LS_FooterComponentController oFooterComponent = new LS_FooterComponentController();         
            Test.StopTest();
        }
         System.assertNotEquals(null, oUser.Notification_Language_Code__c );
          System.assertEquals('Pakistan', oUser.Country);
    }
    
        static testMethod void testFooterURLSforATEng() { 
         
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        User oUser =[select id from user where Country=: 'Japan' AND isActive=TRUE limit 1];
        oUser.Notification_Language_Code__c='ja';
        oUser.Country='Pakistan';
        update Ouser;
        
        System.RunAs(oUser){
            Test.StartTest();
            Test.setCurrentPageReference(new PageReference('Page.help'));
            ApexPages.currentPage().getParameters().put('Country','AT');
            ApexPages.currentPage().getParameters().put('lang','en');
            ApexPages.currentPage().getParameters().put('languageSelected','en');
            LS_FooterComponentController oFooterComponent = new LS_FooterComponentController();
            oFooterComponent.translatePageToSelectedLanguage();
            Test.StopTest();
        }
         System.assertNotEquals(null, oUser.Notification_Language_Code__c );
         System.assertEquals('Pakistan', oUser.Country);
        
    }
    
    static testMethod void testFooterURLSforCHde() {    
         
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        User oUser =[select id from user where Country=: 'Japan' AND isActive=TRUE limit 1];
        oUser.Notification_Language_Code__c='ja';
        oUser.Country='Pakistan';
        update Ouser;
        
        System.RunAs(oUser){  
            Test.StartTest();
            Test.setCurrentPageReference(new PageReference('Page.help'));
            ApexPages.currentPage().getParameters().put('Country','CH');
            ApexPages.currentPage().getParameters().put('lang','de');
            LS_FooterComponentController oFooterComponent = new LS_FooterComponentController();
            Test.StopTest();
        }
         System.assertNotEquals(null, oUser.Notification_Language_Code__c );
         System.assertEquals('Pakistan', oUser.Country);
       
    }
    
  static testMethod void testFooterURLS() {
        
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        User oUser =[select id from user where Country=: 'Japan' AND isActive=TRUE limit 1];
        oUser.Notification_Language_Code__c='ja';
        oUser.Country='Pakistan';
        update Ouser;
        
        
        DAZN_Help_Redirect__c helpRedirectSetting = new DAZN_Help_Redirect__c();
        helpRedirectSetting.Name = 'Japan';
        helpRedirectSetting.CountryISOCode__c = 'JP';
        helpRedirectSetting.IsDefaultCountry__c = true;
        helpRedirectSetting.Country__c = 'Japan';
        helpRedirectSetting.Language__c = 'ja';
        helpRedirectSetting.FooterAboutLinkCustomLabel__c = 'LS_Footer_imprint';
        helpRedirectSetting.FooterAboutTitleCustomLabel__c = 'LS_Footer_imprint';
        insert helpRedirectSetting;
        
        DAZNLanguageConfiguration__c oDAZNLangConfig = new DAZNLanguageConfiguration__c();
        oDAZNLangConfig.Name = '1';
        oDAZNLangConfig.Country__c = 'Japan';
        oDAZNLangConfig.Country_Code__c='JP';
        oDAZNLangConfig.Default_Language__c='ja';
        oDAZNLangConfig.Language__c='English';
        oDAZNLangConfig.Language_Code__c='ja';
        insert oDAZNLangConfig ;
        
      
        System.RunAs(oUser){
            Test.StartTest();
            Test.setCurrentPageReference(new PageReference('Page.help/JP-ja'));
            LS_FooterComponentController oFooterComponent = new LS_FooterComponentController();
            oFooterComponent.getDAZNLanguage();
            oFooterComponent.getLanguageExists();
            oFooterComponent.translatePageToSelectedLanguage();
            Test.StopTest();
        }
        
         System.assertNotEquals(null, oUser.Notification_Language_Code__c );
          System.assertEquals('Japan', oDAZNLangConfig.Country__c );
        
    }
    
      static testMethod void testFooterURLSForGermanEng() {     
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        User oUser =[select id from user where Country=: 'Japan' AND isActive=TRUE limit 1];
        oUser.Notification_Language_Code__c='ja';
        oUser.Country='Pakistan';
        oUser.isActive=TRUE;
        update Ouser;
        
        DAZN_Help_Redirect__c helpRedirectSetting = new DAZN_Help_Redirect__c();
        helpRedirectSetting.Name = 'German';
        helpRedirectSetting.CountryISOCode__c = 'DE';
        helpRedirectSetting.IsDefaultCountry__c = true;
        helpRedirectSetting.Country__c = 'German';
        helpRedirectSetting.Language__c = 'ja';
        helpRedirectSetting.FooterAboutLinkCustomLabel__c = 'LS_Footer_imprint';
        helpRedirectSetting.FooterAboutTitleCustomLabel__c = 'LS_Footer_imprint';
        insert helpRedirectSetting;
        
        DAZNLanguageConfiguration__c oDAZNLangConfig = new DAZNLanguageConfiguration__c();
        oDAZNLangConfig.Name = '1';
        oDAZNLangConfig.Country__c = 'German';
        oDAZNLangConfig.Country_Code__c='DE';
        oDAZNLangConfig.Default_Language__c='en_GB';
        oDAZNLangConfig.Language__c='English';
        oDAZNLangConfig.Language_Code__c='en_GB';
        insert oDAZNLangConfig ;
        
    
        System.RunAs(oUser){
            Test.StartTest();
            Test.setCurrentPageReference(new PageReference('Page.help/JP-ja'));
            LS_FooterComponentController oFooterComponent = new LS_FooterComponentController();
            oFooterComponent.getDAZNLanguage();
            oFooterComponent.getLanguageExists();
            oFooterComponent.translatePageToSelectedLanguage();
            Test.StopTest();
            }
            
          System.assertNotEquals(null, oUser.Notification_Language_Code__c );
          System.assertEquals('German', oDAZNLangConfig.Country__c );
        
    }
    static testMethod void testFooterURLSForGermanDe() {
    
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        User oUser =[select id from user where Country=: 'Japan' AND isActive=TRUE limit 1];
        oUser.Notification_Language_Code__c='ja';
        oUser.Country='Pakistan';
        oUser.LocaleSidKey= 'de';
        oUser.LanguageLocaleKey= 'de';
        update Ouser;
        
        DAZN_Help_Redirect__c helpRedirectSetting = new DAZN_Help_Redirect__c();
        helpRedirectSetting.Name = 'German';
        helpRedirectSetting.CountryISOCode__c = 'DE';
        helpRedirectSetting.IsDefaultCountry__c = true;
        helpRedirectSetting.Country__c = 'German';
        helpRedirectSetting.Language__c = 'de';
        helpRedirectSetting.FooterAboutLinkCustomLabel__c = 'LS_Footer_imprint';
        helpRedirectSetting.FooterAboutTitleCustomLabel__c = 'LS_Footer_imprint';
        insert helpRedirectSetting;
        
        DAZNLanguageConfiguration__c oDAZNLangConfig = new DAZNLanguageConfiguration__c();
        oDAZNLangConfig.Name = '1';
        oDAZNLangConfig.Country__c = 'German';
        oDAZNLangConfig.Country_Code__c='DE';
        oDAZNLangConfig.Default_Language__c='de';
        oDAZNLangConfig.Language__c='de';
        oDAZNLangConfig.Language_Code__c='de';
        insert oDAZNLangConfig ;
        
        
        System.RunAs(oUser){
            Test.StartTest();
            Test.setCurrentPageReference(new PageReference('Page.help/JP-ja'));
            LS_FooterComponentController oFooterComponent = new LS_FooterComponentController();
            oFooterComponent.renderdLangSwitcher = true;
            oFooterComponent.sCountryCode = 'JP';
            oFooterComponent.sURLLang = 'ja';
            oFooterComponent.strCountryExist = true;
            oFooterComponent.getDAZNLanguage();
            oFooterComponent.getLanguageExists();
            apexpages.currentpage().getParameters().put('pauseAction', 'initiate');
            oFooterComponent.translatePageToSelectedLanguage();
            Test.StopTest();
        }
         System.assertNotEquals(null, oUser.Notification_Language_Code__c );
          System.assertEquals('German', oDAZNLangConfig.Country__c );
        
    }

    static testMethod void testFooterURLRetUrl() {
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        User oUser =[select id from user where Country=: 'Japan' AND isActive=TRUE limit 1];
        oUser.Notification_Language_Code__c='ja';
        oUser.Country='Pakistan';
        oUser.LocaleSidKey= 'de';
        oUser.LanguageLocaleKey= 'de';
        update Ouser;
        
        DAZN_Help_Redirect__c helpRedirectSetting = new DAZN_Help_Redirect__c();
        helpRedirectSetting.Name = 'German';
        helpRedirectSetting.CountryISOCode__c = 'DE';
        helpRedirectSetting.IsDefaultCountry__c = true;
        helpRedirectSetting.Country__c = 'German';
        helpRedirectSetting.Language__c = 'de';
        helpRedirectSetting.FooterAboutLinkCustomLabel__c = 'LS_Footer_imprint';
        helpRedirectSetting.FooterAboutTitleCustomLabel__c = 'LS_Footer_imprint';
        insert helpRedirectSetting;
        
        DAZNLanguageConfiguration__c oDAZNLangConfig = new DAZNLanguageConfiguration__c();
        oDAZNLangConfig.Name = '1';
        oDAZNLangConfig.Country__c = 'German';
        oDAZNLangConfig.Country_Code__c='DE';
        oDAZNLangConfig.Default_Language__c='de';
        oDAZNLangConfig.Language__c='de';
        oDAZNLangConfig.Language_Code__c='de';
        insert oDAZNLangConfig ;
        
        
        System.RunAs(oUser){
            Test.StartTest();
            Test.setCurrentPageReference(new PageReference('Page.help/JP-ja'));
            LS_FooterComponentController oFooterComponent = new LS_FooterComponentController();
            oFooterComponent.renderdLangSwitcher = true;
            oFooterComponent.sCountryCode = 'JP';
            oFooterComponent.sURLLang = 'ja';
            oFooterComponent.strCountryExist = true;
            oFooterComponent.getDAZNLanguage();
            oFooterComponent.getLanguageExists();
            apexpages.currentpage().getParameters().put('retUrl', 'q');
            oFooterComponent.translatePageToSelectedLanguage();
            Test.StopTest();
        }
        System.assertNotEquals(null, oUser.Notification_Language_Code__c );
        System.assertEquals('German', oDAZNLangConfig.Country__c );
        
    }
        
}