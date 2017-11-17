/**
* @author Cognizant Technology Solutuions
* @date 16/06/2016
* @description This class test RESTCommunityUserSetup API .
*/
@istest
public class RESTCommunityUserSetupTest{
    
    /*
        Test required parameter validation
    */
    /*
    static testMethod void  testRequiredParameterValidation() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        test.startTest();
        RESTCommunityUserSetup.Response oResponse = RESTCommunityUserSetup.CreateCommunityUserPost('', 'Test', 'test@test.com', 'Test@123', 'JP', 'test123', 'true', 'Test@123', 'GMT', 'en_GB', 'ISO-8859-1', 'en_GB', 'GBP'); 
        System.assertEquals('1001', oResponse.errorCode);
        System.assertEquals('Missing required input', oResponse.reason);
        test.stopTest();
    }*/
    
    /*
        Test email white listed validation
    */
    /*
    static testMethod void  testWhiteListedEmailValidation() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        test.startTest();
        
        Whitelisted_Country__c oWhiteListedCountry = new Whitelisted_Country__c();
        oWhiteListedCountry.Name = 'JP';
        oWhiteListedCountry.Whitelisting_Active__c = true;
        insert oWhiteListedCountry;
        
        RESTCommunityUserSetup.Response oResponse = RESTCommunityUserSetup.CreateCommunityUserPost('Test', 'Test', 'test@test.com', 'Test@123', 'JP', 'test123', 'true', 'Test@123', 'GMT', 'en_GB', 'ISO-8859-1', 'en_GB', 'GBP'); 
        System.assertEquals('1002', oResponse.errorCode);
        System.assertEquals('Email is not white listed for country', oResponse.reason);
        test.stopTest();
    }*/
    
    /*
        Test email already exist validation
    */
    /*
    static testMethod void  testEmailAlreadyExistValidation() { 
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        test.startTest();
        Whitelisted_Country__c oWhiteListedCountry = new Whitelisted_Country__c();
        oWhiteListedCountry.Name = 'JP';
        oWhiteListedCountry.Whitelisting_Active__c = true;
        insert oWhiteListedCountry;
        
        Whitelisted_Emails__c oWhiteListedEmail = new Whitelisted_Emails__c();
        oWhiteListedEmail.Email__c = 'test@test.com';
        oWhiteListedEmail.Whitelisted_Country__c = oWhiteListedCountry.Id;
        insert oWhiteListedEmail;
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trail');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'test@test.com', 'test456@test.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true);   
        
        RESTCommunityUserSetup.Response oResponse = RESTCommunityUserSetup.CreateCommunityUserPost('Test', 'Test', 'test@test.com', 'Test@123', 'JP', 'test123', 'true', 'Test@123', 'GMT', 'en_GB', 'ISO-8859-1', 'en_GB', 'GBP'); 
        System.assertEquals('1003', oResponse.errorCode);
        System.assertEquals('Email already exist', oResponse.reason);
        test.stopTest();
    }*/
    
    /*
        Test user creation failure validation
    */
    /*
    static testMethod void  testUserCreationFailedError() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        test.startTest();
        
        Whitelisted_Country__c oWhiteListedCountry = new Whitelisted_Country__c();
        oWhiteListedCountry.Name = 'JP';
        oWhiteListedCountry.Whitelisting_Active__c = true;
        insert oWhiteListedCountry;
        
        Whitelisted_Emails__c oWhiteListedEmail = new Whitelisted_Emails__c();
        oWhiteListedEmail.Email__c = 'ucfrtest@test.com';
        oWhiteListedEmail.Whitelisted_Country__c = oWhiteListedCountry.Id;
        insert oWhiteListedEmail;
        
        RESTCommunityUserSetup.Response oResponse = RESTCommunityUserSetup.CreateCommunityUserPost('Test', 'Test', 'ucfrtest@test.com', 'Test@123', 'JP', 'test12', 'true', 'test123', 'GMT', 'en_GB', 'ISO-8859-1', 'en_GB', 'GBP'); 
        test.stopTest();
    }*/
    
    /*
        Test community user setup
    */
    /*
    static testMethod void  testCommunityUserSetup() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        test.startTest();
        
        Whitelisted_Country__c oWhiteListedCountry = new Whitelisted_Country__c();
        oWhiteListedCountry.Name = 'JP';
        oWhiteListedCountry.Whitelisting_Active__c = true;
        insert oWhiteListedCountry;
        
        Whitelisted_Emails__c oWhiteListedEmail = new Whitelisted_Emails__c();
        oWhiteListedEmail.Email__c = 'ucfrtest@test.com';
        oWhiteListedEmail.Whitelisted_Country__c = oWhiteListedCountry.Id;
        insert oWhiteListedEmail;
        
        RESTCommunityUserSetup.Response oResponse = RESTCommunityUserSetup.CreateCommunityUserPost('Test', 'Test', 'ucfrtest@test.com', 'Test@123', 'JP', 'ucfrtest', 'true', 'ucfrtest', 'GMT', 'en_GB', 'ISO-8859-1', 'en_GB', 'GBP'); 
        System.assertEquals(null, oResponse.reason);
        System.assertEquals(null, oResponse.errorCode);
        System.assertEquals('Success', oResponse.status);
        
        test.stopTest();
    }*/
    
    /*Test User Creation Exception */
    /*
    static testMethod void  testException() {
        test.startTest();
        RESTCommunityUserSetup.Response oResponse = RESTCommunityUserSetup.CreateCommunityUserPost('Test', 'Test', 'ucfrtest@test.com', 'Test@123', 'JP', 'test12', 'true', 'test12345', 'HMT', 'en_GB', 'ISO-8859-1', 'GB', 'P1');
        RESTCommunityUserSetup.GetAccountInfo('000000');
        RESTCommunityUserSetup.GetUserInfo('0000');
        System.assertEquals('Failure', oResponse.status); 
        test.stopTest();
    }*/
    
    
}