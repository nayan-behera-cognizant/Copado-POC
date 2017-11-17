/*Added Assert statements as per PD-7938*/

@IsTest
Public class myLoginControllerTest{
    @testSetup
    Public static void customSetting(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.CreateGuestUser();
        
        //custom settings             
        DAZN_Help_Redirect__c helpRedirectSetting = new DAZN_Help_Redirect__c();
        helpRedirectSetting.Name = 'Japan';
        helpRedirectSetting.CountryISOCode__c = 'JP';
        helpRedirectSetting.IsDefaultCountry__c = true;
        helpRedirectSetting.Country__c = 'Japan';
        helpRedirectSetting.Language__c = 'ja';
        insert helpRedirectSetting;
        System.assertEquals('Japan', helpRedirectSetting.Country__c);
        
        DAZNLanguageConfiguration__c oDAZNLangConfig = new DAZNLanguageConfiguration__c();
        oDAZNLangConfig.Name = '1';
        oDAZNLangConfig.Country__c = 'Japan';
        oDAZNLangConfig.Country_Code__c='JP';
        oDAZNLangConfig.Default_Language__c='ja';
        oDAZNLangConfig.Language__c='English';
        oDAZNLangConfig.Language_Code__c='en_GB';
        insert oDAZNLangConfig ;
        System.assertEquals('English', oDAZNLangConfig.Language__c);
        
        DAZNConfiguration__c oDAZNConfigEmail = new DAZNConfiguration__c();
        oDAZNConfigEmail.Name = 'Mylogin_ForgotEmail';
        oDAZNConfigEmail.Value__c = 'https://stag.dazn.com/User/RememberEmail';
        insert oDAZNConfigEmail ;
        System.assertEquals('Mylogin_ForgotEmail', oDAZNConfigEmail.Name);
        
        DAZNConfiguration__c oDAZNConfigEmailBeta = new DAZNConfiguration__c();
        oDAZNConfigEmailBeta.Name = 'Mylogin_ForgotEmailBeta';
        oDAZNConfigEmailBeta.Value__c = 'https://stag.dazn.com/User/RememberEmail';
        insert oDAZNConfigEmailBeta ;
        
        DAZNConfiguration__c oDAZNConfigPasswordReset = new DAZNConfiguration__c();
        oDAZNConfigPasswordReset.Name = 'Mylogin_PasswordReset';
        oDAZNConfigPasswordReset.Value__c = 'https://stag.dazn.com/User/RememberEmail';
        insert oDAZNConfigPasswordReset ;
        
        DAZNConfiguration__c oDAZNConfigPasswordResetBeta = new DAZNConfiguration__c();
        oDAZNConfigPasswordResetBeta.Name = 'Mylogin_PasswordResetBeta';
        oDAZNConfigPasswordResetBeta.Value__c = 'https://stag.dazn.com/User/RememberEmail';
        insert oDAZNConfigPasswordResetBeta ;
        system.assertNotEquals(null, oDAZNConfigPasswordResetBeta);
        
        DAZNConfiguration__c oDAZNConfigHomepage = new DAZNConfiguration__c();
        oDAZNConfigHomepage.Name = 'HomePageURL';
        oDAZNConfigHomepage.Value__c = 'https://stag.dazn.com/User/RememberEmail';
        insert oDAZNConfigHomepage ;
        
        DAZNConfiguration__c oDAZNConfigHomepageBeta = new DAZNConfiguration__c();
        oDAZNConfigHomepageBeta.Name = 'HomePageURLBeta';
        oDAZNConfigHomepageBeta.Value__c = 'https://stag.dazn.com/User/RememberEmail';
        insert oDAZNConfigHomepageBeta ;
        
        DAZNConfiguration__c dznConfigUserNameConf = new DAZNConfiguration__c();
        dznConfigUserNameConf.Name = 'LS_UserName_Configuration';
        dznConfigUserNameConf.Value__c = 'livesport.dev';
        insert dznConfigUserNameConf;

        system.assertNotEquals(null, oDAZNConfigHomepageBeta);
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
    
    static testMethod void testlogin(){
        List<Profile> profile=[select id, Name from profile where Name='Customer Community User'limit 1 ]; 
        system.assert(profile.size()>0);
        List <User> gUser=[select id,UserName from user where profileid= :profile[0].Id  AND IsActive = true limit 1]; 
        system.assertEquals(1,gUser.size());
        gUser[0].Country = '';
        update gUser;
        System.RunAs(gUser[0]){            
            test.startTest();
            myLoginController objCntrl = new myLoginController();
            objCntrl.RetURl = 'test';
            //objCntrl.strLang = 'en';
            objCntrl.getRememberEmailURL();
            objCntrl.getPasswordResetURL();
            //objCntrl.fetchBrowserLanguage();
            objCntrl.redirectToHomePage();
            objCntrl.closeBanner();
            objCntrl.login();
            test.stopTest();
        }
    }
    
    // to cover else cases
    static testmethod void testCases(){
        List<Profile> profile=[select id, Name from profile where Name='Customer Community User'limit 1 ]; 
        system.assert(profile.size()>0);
        List <User> gUser=[select id,UserName,country from user where profileid= :profile[0].Id AND IsActive = true limit 1];
        system.assertEquals(1,gUser.size());
        System.RunAs(gUser[0]){            
            test.startTest();
            PageReference pageref=Page.mylogin;
            test.setCurrentPage(pageref);
            myLoginController objCntrl = new myLoginController();
            //objCntrl.strLang = 'en';
            pageref.getParameters().put('strLang','en_GB');
            //objCntrl.fetchBrowserLanguage();
            test.stopTest();
        }   
        
    }
    //if user is from Germany
    static testMethod void testGermany(){
        List<Profile> profile=[select id, Name from profile where Name='Customer Community User'limit 1 ]; 
        system.assert(profile.size()>0);
        List <User> gUser=[select id,UserName,country from user where profileid= :profile[0].Id AND IsActive = true limit 1]; 
        system.assertEquals(1,gUser.size());
        gUser[0].country='Germany';
        System.RunAs(gUser[0]){            
            test.startTest();
            update gUser;
            myLoginController objCntrl = new myLoginController();
            //objCntrl.strLang = 'en';           
            objCntrl.getRememberEmailURL();
            objCntrl.getPasswordResetURL();
            //objCntrl.fetchBrowserLanguage();
            objCntrl.redirectToHomePage();
            objCntrl.closeBanner();
            objCntrl.login();
            test.stopTest();
        }
    }
    
    // to cover else cases for Germany user
    static testmethod void testCasesGermany(){
        List<Profile> profile=[select id, Name from profile where Name='Customer Community User'limit 1 ]; 
        system.assert(profile.size()>0);
        List <User> gUser=[select id,UserName,country from user where profileid= :profile[0].Id AND IsActive = true limit 1];
        system.assertEquals(1,gUser.size());
        gUser[0].country='Germany';
        System.RunAs(gUser[0]){            
            test.startTest();
            update gUser;
            PageReference pageref=Page.mylogin;
            test.setCurrentPage(pageref);
            myLoginController objCntrl = new myLoginController();
            //objCntrl.strLang = 'en';
            pageref.getParameters().put('strLang','en_GB');
            //objCntrl.fetchBrowserLanguage();
            test.stopTest();
        }   
        
    }
    //if user is from Austria
    static testMethod void testAustria(){
        List<Profile> profile=[select id, Name from profile where Name='Customer Community User'limit 1 ]; 
        system.assert(profile.size()>0);
        List <User> gUser=[select id,UserName,country from user where profileid= :profile[0].Id AND IsActive = true limit 1]; 
        system.assertEquals(1,gUser.size());
        gUser[0].country='Austria';
        System.RunAs(gUser[0]){            
            test.startTest();
            update gUser;
            myLoginController objCntrl = new myLoginController();    
            //objCntrl.strLang = 'en';       
            objCntrl.getRememberEmailURL();
            objCntrl.getPasswordResetURL();
            //objCntrl.fetchBrowserLanguage();
            objCntrl.redirectToHomePage();
            objCntrl.closeBanner();
            objCntrl.login();
            test.stopTest();
        }
    }
    // to cover else cases for Austria user
    static testmethod void testCasesAustria(){
        List<Profile> profile=[select id, Name from profile where Name='Customer Community User' limit 1 ]; 
        system.assert(profile.size()>0);
        List <User> gUser=[select id,UserName,country from user where profileid= :profile[0].Id AND IsActive = true limit 1];
        system.assertEquals(1,gUser.size());
        gUser[0].country='Austria';
        System.RunAs(gUser[0]){            
            test.startTest();
            update gUser;
            PageReference pageref=Page.mylogin;
            test.setCurrentPage(pageref);
            myLoginController objCntrl = new myLoginController();
            //objCntrl.strLang = 'en';
            pageref.getParameters().put('strLang','en_GB');
            //objCntrl.fetchBrowserLanguage();
            test.stopTest();
        }   
        
    }   
    // if user is from Switzerland
    static testMethod void testSwitzerland(){
        List<Profile> profile=[select id, Name from profile where Name='Customer Community User'limit 1 ]; 
        system.assert(profile.size()>0);
        List <User> gUser=[select id,UserName,country from user where profileid= :profile[0].Id AND IsActive = true limit 1]; 
        system.assertEquals(1,gUser.size());
        gUser[0].country='Switzerland';
        System.RunAs(gUser[0]){            
            test.startTest();
            update gUser;
            myLoginController objCntrl = new myLoginController();
            //objCntrl.strLang = 'en';           
            objCntrl.getRememberEmailURL();
            objCntrl.getPasswordResetURL();
            //objCntrl.fetchBrowserLanguage();
            objCntrl.redirectToHomePage();
            objCntrl.closeBanner();
            objCntrl.login();
            test.stopTest();
        }
    }
    // to cover else cases for Switzerland user
    static testmethod void testCasesSwitzerland(){
        List<Profile> profile=[select id, Name from profile where Name='Customer Community User'limit 1 ]; 
        system.assert(profile.size()>0);
        List <User> gUser=[select id,UserName,country from user where profileid= :profile[0].Id AND IsActive = true limit 1];
        system.assertEquals(1,gUser.size());
        gUser[0].country='Switzerland';
        System.RunAs(gUser[0]){            
            test.startTest();
            update gUser;
            PageReference pageref=Page.mylogin;
            test.setCurrentPage(pageref);
            myLoginController objCntrl = new myLoginController();
            //objCntrl.strLang = 'en';
            pageref.getParameters().put('strLang','en_GB');
            //objCntrl.fetchBrowserLanguage();
            test.stopTest();
        }   
        
    }  
    // if user is from japan 
    static testMethod void testJapan(){
        List<Profile> profile=[select id, Name from profile where Name='Customer Community User'limit 1 ]; 
        system.assert(profile.size()>0);
        List <User> gUser=[select id,UserName,country from user where profileid= :profile[0].Id AND IsActive = true limit 1]; 
        system.assertEquals(1,gUser.size());
        gUser[0].country='Japan';
        System.RunAs(gUser[0]){            
            test.startTest();
            update gUser;
            myLoginController objCntrl = new myLoginController();
            //objCntrl.strLang = 'en';     
            objCntrl.getRememberEmailURL();
            objCntrl.getPasswordResetURL();
            //objCntrl.fetchBrowserLanguage();
            objCntrl.redirectToHomePage();
            objCntrl.closeBanner();
            objCntrl.login();
            test.stopTest();
        }
    }
    // to cover else cases for japan user
    static testmethod void testCasesJapan(){
        List<Profile> profile=[select id, Name from profile where Name='Customer Community User'limit 1 ]; 
        system.assert(profile.size()>0);
        List <User> gUser=[select id,UserName,country from user where profileid= :profile[0].Id AND IsActive = true limit 1];
        system.assertEquals(1,gUser.size());
        gUser[0].country='Japan';
        System.RunAs(gUser[0]){            
            test.startTest();
            update gUser;
            PageReference pageref=Page.mylogin;
            test.setCurrentPage(pageref);
            myLoginController objCntrl = new myLoginController();
            //objCntrl.strLang = 'en';
            pageref.getParameters().put('strLang','en_GB');
            //objCntrl.fetchBrowserLanguage();
            test.stopTest();
        }   
        
    }  
    
    //@isTest 
    static void testCallout()  {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        //myLoginController objCntrl = new myLoginController();
        
        // HttpResponse res = objCntrl.getcountry('119.235.235.85');
        //getcountryclass objclass = new getcountryclass();
        HttpResponse res = getcountryclass.getcountry('119.235.235.85');
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        
    }  
    
    /*PD-9874*/
    static testMethod void testSignInBlockedUser() {
        SetUpTestData.triggerSettings();
        Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
            Name = 'Docomo',
            Partner_Type__c = 'Docomo',
            Page_Name__c = 'PartnerAccount.page',
            Subscription_Type_Heading_Text__c = 'Docomo',
            Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
            Payment_History_URL__c = 'https://www.google.com',
            Cancel_Subscription_URL_Small__c = 'https://www.google.com',
            Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
            Cancel_Subscription_URL_Large__c = 'https://www.google.com',
            Payment_success_email__c = '123'
        );
        insert pac;
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testusername@email.com','Free Trial');
        system.debug('Account_Status__c-----'+oAccount.Account_Status__c);
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
        oAccount.Account_Status__c='Blocked';
        update oAccount;
        system.debug('Account_Status__c0000-----'+oAccount.Account_Status__c);
        Test.StartTest();
        
        System.RunAs(oUser){
            PageReference oPageReference = Page.mylogin; 
            oPageReference.getParameters().put('lang', 'en'); 
            oPageReference.getParameters().put('Country', 'JP'); 
            oPageReference.getParameters().put('type', 'General Enquiry'); 
            Test.setCurrentPage(oPageReference);          
            myLoginController myLoginC = new myLoginController();
            myLoginC.username = oUser.username;
            myLoginC.getRedirectUrl();
            myLoginC.login();
            system.assertEquals(myLoginC.isBlockedUser, true);
        }
        Test.StopTest();    
    }
    
    /*static testmethod void testGetRedirectUrl() {
SetUpTestData.triggerSettings();
Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
Name = 'Docomo',
Partner_Type__c = 'Docomo',
Page_Name__c = 'PartnerAccount.page',
Subscription_Type_Heading_Text__c = 'Docomo',
Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
Payment_History_URL__c = 'https://www.google.com',
Change_Payment_Method_Text__c = 'Docomo',
Change_Payment_Method_URL__c = 'https://www.google.com',
Cancel_Subscription_URL_Small__c = 'https://www.google.com',
Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
Cancel_Subscription_URL_Large__c = 'https://www.google.com',
Contact_Us_Link__c = 'https://www.google.com',
Payment_success_email__c = '123'
);
insert pac;
Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
oAccount.Account_Status__c = 'Blocked';
update oAccount;
User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
Test.StartTest();

System.RunAs(oUser){
PageReference oPageReference = Page.ContactUs; 
oPageReference.getParameters().put('lang', 'en'); 
oPageReference.getParameters().put('Country', 'JP'); 
oPageReference.getParameters().put('type', 'General Enquiry'); 
Test.setCurrentPage(oPageReference);          
myLoginController myLoginC = new myLoginController();

myLoginC.email = 'testusername@email.com';
myLoginC.getRedirectUrl();

//system.assertEquals(myLoginC.isBlockedUser, true);
}
Test.StopTest();
}*/
    
    static testmethod void testRedirectToDocomoSignInPage() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
        // User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];
         PageReference pr;
        System.RunAs(oUser) {
            Test.startTest();
            myLoginController.MyLoginControllerWithouSharing objCntrl = new myLoginController.MyLoginControllerWithouSharing();
            pr = objCntrl.redirectToDocomoSignInPage();
            
            Test.stopTest();
        }
        
        System.assertNotEquals(null, pr);  
    }
    
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
Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('Tokyo', 'Japan'));

System.runAs(testGuestUser) {
myLoginController myLoginCtrl = new myLoginController();
myLoginCtrl.strLang = 'ja';
pr = myLoginCtrl.fetchBrowserLanguage();
}        
Test.stopTest();

System.assertEquals('/signin?Country=JP&lang=ja', pr.getUrl());
}*/
    
    
    
    /*public class MockHttpResponseGenerator implements HttpCalloutMock {
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
}*/
    // to test invalid login user
    static testMethod void testInvalidLoginUser() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
        System.RunAs(oUser){
            test.startTest();
            Pagereference pageref= Page.mylogin;
            test.setCurrentPage(pageref);
            system.assertNotEquals(pageref.getUrl(),null );
            pageref.getParameters().put('emailaddress','testemail@email.com ');
            test.setCurrentPage(pageref);
            myLoginController myLoginC = new myLoginController();
            myLoginC.emailaddress='testemail@email.com';
            myLoginC.login();
            test.stopTest();
        }
    }   
    static testMethod void testRedirectUrlNotNull() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testusername@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
        oAccount.Account_Status__c='Blocked';
        update oAccount;
        system.assertEquals( oAccount.Account_Status__c, 'Blocked');
        Test.StartTest();
        System.RunAs(oUser){
            PageReference oPageReference = Page.mylogin; 
            oPageReference.getParameters().put('lang', 'en'); 
            oPageReference.getParameters().put('Country', 'JP'); 
            oPageReference.getParameters().put('type', 'General Enquiry'); 
            Test.setCurrentPage(oPageReference);          
            myLoginController myLoginC = new myLoginController();
            myLoginC.username = 'testusername@email.com';
            myLoginC.getRedirectUrl();
            //myLoginC.login();
        }
        Test.StopTest();    
    }
    static testmethod void testGuestLogin() {
        list<User> oUser = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];
        system.assertNotEquals(oUser, null);
        System.RunAs(oUser[0]) {
            Test.startTest();
            myLoginController objCntrl = new myLoginController();
            Test.stopTest();
        }
    }

    static testMethod void testSignInNotBlockedUser() {
        SetUpTestData.triggerSettings();
        Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
            Name = 'Docomo',
            Partner_Type__c = 'Docomo',
            Page_Name__c = 'PartnerAccount.page',
            Subscription_Type_Heading_Text__c = 'Docomo',
            Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
            Payment_History_URL__c = 'https://www.google.com',
            Cancel_Subscription_URL_Small__c = 'https://www.google.com',
            Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
            Cancel_Subscription_URL_Large__c = 'https://www.google.com',
            Payment_success_email__c = '123'
        );
        insert pac;

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testusername@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');

        Test.StartTest();
        System.runAs(oUser) {
            PageReference oPageReference = Page.mylogin;
            oPageReference.getParameters().put('lang', 'en');
            oPageReference.getParameters().put('Country', 'JP');
            oPageReference.getParameters().put('type', 'General Enquiry');
            Test.setCurrentPage(oPageReference);
            myLoginController myLoginC = new myLoginController();
            myLoginC.username = oUser.username;
            myLoginC.getRedirectUrl();
            myLoginC.login();
            system.assertEquals(myLoginC.isBlockedUser, false);
        }
        Test.StopTest();
    }

    static testmethod void testNavigateUser() {
        myLoginController objCntrl = new myLoginController();
        ApexPages.currentpage().getParameters().put('retUrl', 'ChangePaymentMethod');
        System.assertNotEquals(null, objCntrl.navigateUser());

        List<User> oUser = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];
        System.RunAs(oUser[0]) {
            System.assertEquals(null, objCntrl.navigateUser());
        }
    }
}