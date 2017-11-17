/**
* @author Cognizant Technology Solutuions
* @date 16/06/2016
* @description This class test restCommunity API .
*/
@istest
public class RESTCommunityUserCaptureIPAddressTest{

    // PD-9843 - Partner_Account_Configuration__c is used in Account trigger
    @testSetup
    public static void setupTest() {
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
        insert pac;
    }
    
    /*
Test required parameter validation
*/
    static testMethod void  testRequiredParameterValidation() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        test.startTest();
        RESTCommunityUserSetupCaptureIPAddress restCommunity = new RESTCommunityUserSetupCaptureIPAddress();
        RESTCommunityUserSetupCaptureIPAddress.Response oResponse = RESTCommunityUserSetupCaptureIPAddress.CreateCommunityUserPost('', 'Test', 'test@test.com', 'Test@123', 'JP', 'test123', 'true', 'Test@123', 'GMT', 'en_GB', 'ISO-8859-1', 'en_GB', 'GBP', '15.166.77.245', 'Test1', System.Now(), '');
        System.assertEquals('1001', oResponse.errorCode);
        System.assertEquals('Missing required input', oResponse.reason);
        test.stopTest();
    }
    
    
    /*
Test email already exist validation
*/
    static testMethod void  testEmailAlreadyExistValidation() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        System.runAs(oCSUser) {
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
            System.assertEquals(null, RESTCommunityUserSetupCaptureIPAddress.getUserInfo(oAccount.Id));
            User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'test@test.com', 'test678@test.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true);  
            
            RESTCommunityUserSetupCaptureIPAddress.Response oResponse = RESTCommunityUserSetupCaptureIPAddress.CreateCommunityUserPost('Test', 'Test', 'test@test.com', 'Test@123', 'JP', 'test123', 'true', 'Test@123', 'GMT', 'en_GB', 'ISO-8859-1', 'en_GB', 'GBP', '12.522.34.897','Test1', System.Now(),'');
            System.assertEquals('1003', oResponse.errorCode);
            System.assertEquals('Email already exist', oResponse.reason);
            test.stopTest();   
        }    
    }         
    /*static testMethod void  testIPaddressValidation() {
SetUpTestData.triggerSettings();
SetUpTestData.emailCustsett();
test.startTest();

RESTCommunityUserSetupCaptureIPAddress.Response oResponse = RESTCommunityUserSetupCaptureIPAddress.CreateCommunityUserPost('Test', 'Test', 'test@test.com', 'Test@123', 'JP', 'test123', 'true', 'Test@123', 'GMT', 'en_GB', 'ISO-8859-1', 'en_GB', 'GBP','3.345.34.259', 'Test1', System.Now());
System.assertEquals('1004', oResponse.errorCode);
System.assertEquals('Invalid IP Address', oResponse.reason);
test.stopTest();
}*/
    
    /*
Test IP Address Validation
*/
    static testMethod void  testIPaddressValidation() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();

        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        System.runAs(oCSUser) {
            test.startTest();
            
            Whitelisted_Country__c oWhiteListedCountry = new Whitelisted_Country__c();
            oWhiteListedCountry.Name = 'JP';
            oWhiteListedCountry.Whitelisting_Active__c = true;
            insert oWhiteListedCountry;
            
            Whitelisted_Emails__c oWhiteListedEmail = new Whitelisted_Emails__c();
            oWhiteListedEmail.Email__c = 'ucfrtest@test.com';
            oWhiteListedEmail.Whitelisted_Country__c = oWhiteListedCountry.Id;
            insert oWhiteListedEmail;
            
            Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trail');
            User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'test@test.com', 'test890@test.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true);          
            
            RESTCommunityUserSetupCaptureIPAddress.Response oResponse1 = RESTCommunityUserSetupCaptureIPAddress.CreateCommunityUserPost('Test', 'Test', 'ucfrtest@test.com', 'Test@123', 'JP', 'test12', 'true', 'test12345', 'GMT', 'en_GB', 'ISO-8859-1', 'en_GB', 'GBP', 'lasdfjhasdkljf', 'Test1', System.Now(), '');                
            System.assertEquals('Failure', oResponse1.status);                
            
            test.stopTest();
        }
    }
    
    /*
Test community user setup
*/
    static testMethod void  testCommunityUserSetup() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();

        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        System.runAs(oCSUser) {
            test.startTest();
            
            Whitelisted_Country__c oWhiteListedCountry = new Whitelisted_Country__c();
            oWhiteListedCountry.Name = 'JP';
            oWhiteListedCountry.Whitelisting_Active__c = true;
            insert oWhiteListedCountry;
            
            Whitelisted_Emails__c oWhiteListedEmail = new Whitelisted_Emails__c();
            oWhiteListedEmail.Email__c = 'ucfrtest@test.com';
            oWhiteListedEmail.Whitelisted_Country__c = oWhiteListedCountry.Id;
            insert oWhiteListedEmail; 
            
            
            RESTCommunityUserSetupCaptureIPAddress.Response oResponse = RESTCommunityUserSetupCaptureIPAddress.CreateCommunityUserPost('Test', 'Test', 'ucfrtest@test.com', 'Test@123', 'JP', 'ucfrtest', 'true', 'ucfrtest', 'GMT', 'en_GB', 'ISO-8859-1', 'en_GB', 'GBP', '203.99.208.1', 'Test111', System.Now(), '');
            System.assertEquals(null, oResponse.reason);
            System.assertEquals(null, oResponse.errorCode);
            System.assertEquals('Success', oResponse.status);
            List<Email_Sync_Queue__c> emailSyncQueueList = [SELECT Id, Type_of_Email__c, Dispatch_ID__c FROM Email_Sync_Queue__c WHERE Account__r.Name = 'Test Test'];
            System.assertEquals(true, !emailSyncQueueList.isEmpty());
            System.assertEquals('Data Import', emailSyncQueueList[0].Type_of_Email__c);

            test.stopTest();

            
        }
    }
    
    static testMethod void  testCommunityUserSetupDE() {
        List<DAZNCommunicatorConfig__c> lstCustomSetting = new List<DAZNCommunicatorConfig__c>();
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(Name = 'DispatchID Double optin', Value__c = 12345));
        insert lstCustomSetting;

        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();

        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        System.runAs(oCSUser) {
            test.startTest();
            
            Whitelisted_Country__c oWhiteListedCountry = new Whitelisted_Country__c();
            oWhiteListedCountry.Name = 'JP';
            oWhiteListedCountry.Whitelisting_Active__c = true;
            insert oWhiteListedCountry;
            
            Whitelisted_Emails__c oWhiteListedEmail = new Whitelisted_Emails__c();
            oWhiteListedEmail.Email__c = 'ucfrtest@test.com';
            oWhiteListedEmail.Whitelisted_Country__c = oWhiteListedCountry.Id;
            insert oWhiteListedEmail; 
            
            RESTCommunityUserSetupCaptureIPAddress.Response oResponse = RESTCommunityUserSetupCaptureIPAddress.CreateCommunityUserPost('Test', 'Test', 'ucfrtest@test.com', 'Test@123', 'DE', 'ucfrtest', 'true', 'ucfrtest', 'GMT', 'en_GB', 'ISO-8859-1', 'en_GB', 'GBP', '203.99.208.1', 'Test2DE', System.Now(), '');
            System.assertEquals(null, oResponse.reason);
            System.assertEquals(null, oResponse.errorCode);
            System.assertEquals('Success', oResponse.status);
            List<Email_Sync_Queue__c> emailQueuesTriggeredDispatch = [SELECT Id, Type_of_Email__c, Dispatch_ID__c FROM Email_Sync_Queue__c WHERE Account__r.Name = 'Test Test' AND Type_of_Email__c = 'Triggered Dispatch'];
            System.assertEquals(true, !emailQueuesTriggeredDispatch.isEmpty());
            System.assertEquals('Triggered Dispatch', emailQueuesTriggeredDispatch[0].Type_of_Email__c);
            System.assertEquals(12345, emailQueuesTriggeredDispatch[0].Dispatch_ID__c);

            List<Email_Sync_Queue__c> emailQueuesDataImport = [SELECT Id, Type_of_Email__c, Dispatch_ID__c FROM Email_Sync_Queue__c WHERE Account__r.Name = 'Test Test' AND Type_of_Email__c = 'Data Import'];
            System.assertEquals(true, !emailQueuesDataImport.isEmpty());
            System.assertEquals('Data Import', emailQueuesDataImport[0].Type_of_Email__c);

            test.stopTest();

            
        }
    }
    
    /*Test User Creation Exception */
    static testMethod void  testException() {
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        System.assertEquals(null, RESTCommunityUserSetupCaptureIPAddress.getAccountInfo(oCSUser.Id));
        System.runAs(oCSUser) {
            test.startTest();
            RESTCommunityUserSetupCaptureIPAddress.Response oResponse = RESTCommunityUserSetupCaptureIPAddress.CreateCommunityUserPost('Test', 'Test', 'ucfrtest@test.com', 'Test@123', 'JP', 'test12', 'true', 'test12345', 'HMT', 'en_GB', 'ISO-8859-1', 'GB', 'P1', '', 'Test1', System.Now(), '');
            System.assertEquals('Failure', oResponse.status); 
            test.stopTest();
        }
    }

     static testMethod void  testRequiredParameterValidationFail() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        test.startTest();
        RESTCommunityUserSetupCaptureIPAddress.Response oResponse = RESTCommunityUserSetupCaptureIPAddress.CreateCommunityUserPost('yyyyyyyyyyyyyyyyyyyuerfgdkfhgkhdkfghdkjfhgkljdhfklgyyyyyyyyyyyyyyyyyyyuerfgdkfhgkhdkfghdkjfhgkljdhfklgyyyyyyyyyyyyyyyyyyyuerfgdkfhgkhdkfghdkjfhgkljdhfklgyyyyyyyyyyyyyyyyyyyuerfgdkfhgkhdkfghdkjfhgkljdhfklgyyyyyyyyyyyyyyyyyyyuerfgdkfhgkhdkfghdkjfhgkljdhfklgyyyyyyyyyyyyyyyyyyyuerfgdkfhgkhdkfghdkjfhgkljdhfklgyyyyyyyyyyyyyyyyyyyuerfgdkfhgkhdkfghdkjfhgkljdhfklgyyyyyyyyyyyyyyyyyyyuerfgdkfhgkhdkfghdkjfhgkljdhfklgyyyyyyyyyyyyyyyyyyyuerfgdkfhgkhdkfghdkjfhgkljdhfklgyyyyyyyyyyyyyyyyyyyuerfgdkfhgkhdkfghdkjfhgkljdhfklgyyyyyyyyyyyyyyyyyyyuerfgdkfhgkhdkfghdkjfhgkljdhfklgyyyyyyyyyyyyyyyyyyyuerfgdkfhgkhdkfghdkjfhgkljdhfklg', 'Test', 'testtestcom', 'Test@123', 'JPT', 'test123', 'true', 'Test@123', 'GMT', 'en_GB', 'ISO-8859-1', 'en_GB', 'GBP', '15.166.77.245', 'Test1', System.Now(), '');

        test.stopTest();
    }

    
}