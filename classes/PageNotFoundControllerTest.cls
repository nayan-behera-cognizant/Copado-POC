/**
* @author Cognizant Technology Solutuions
* @date 02/05/2016
* @description This class test page not found contrller functionality.
*/
@istest
public class PageNotFoundControllerTest {

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
    /*Test Page Not Found*/
    static testMethod void testPageNotFoundPageLanguage() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true);
        
        User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new CommunityHelperTest.MockHttpResponseGenerator('Tokyo', 'Japan'));

        System.RunAs(u){
            PageNotFoundController objPNFC = new PageNotFoundController();
            objPNFC.strLang = 'en_US';
            System.assertNotEquals(null, objPNFC);
            System.assertEquals('Japan', objPNFC.cookieCountry);
        }

        Test.StopTest();
    }

}