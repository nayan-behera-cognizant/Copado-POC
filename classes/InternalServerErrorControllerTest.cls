/**
* @author Cognizant Technology Solutuions
* @date 02/05/2016
* @description This class test internal server error controller functionality.
*/
@istest
public class InternalServerErrorControllerTest {

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
    /*Test Internal Server Error*/
    static testMethod void testInternalServerErrorPageLanguage() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true);
        
        Test.StartTest();
        
        System.RunAs(oUser) {
            InternalServerErrorController objISE = new InternalServerErrorController();
            system.assertNotEquals(null, objISE);
        }
        Test.StopTest();
    }

    static testMethod void testFetchBrowserLanguage() {
        User testGuestUser = [Select Id, Name From User Where userType = 'Guest' AND isActive = true LIMIT 1];

        PageReference pr;
        InternalServerErrorController internalServerErrorController;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CommunityHelperTest.MockHttpResponseGenerator('Tokyo', 'Japan'));

        System.runAs(testGuestUser) {
            internalServerErrorController = new InternalServerErrorController();
            internalServerErrorController.strLang = 'en_GB';
        }        
        Test.stopTest();

        System.assertEquals('Japan', internalServerErrorController.cookieCountry);
    }
}