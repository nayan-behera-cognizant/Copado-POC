/**
 * An apex page controller that exposes the change password functionality
 */
@IsTest 
public class ChangePasswordControllerTest {
    
    /*Testing the Password Change Functionality*/
    static testMethod void testPasswordChanges() {
        SetUpTestData.triggerSettings();
        Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
            Name = 'Docomo',
            Partner_Type__c = 'Docomo',
            Page_Name__c = 'PartnerAccount.page',
            Subscription_Type_Heading_Text__c = 'DAZN for Docomo',
            Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
            Payment_History_URL__c = 'https://www.google.com',
            Cancel_Subscription_URL_Small__c = 'https://www.google.com',
            Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
            Cancel_Subscription_URL_Large__c = 'https://www.google.com',
            Change_password_email__c = '123'
        );
        insert pac;
        Account oAccount = SetUpTestData.createPersonAccount('Test Bharath', 'Test Jitta','testbharath@test.com','Free Trial');
        oAccount.Disable_all_transactional_emails__c = false;
        oAccount.Type = 'Docomo';
        oAccount.Partner_ID__c = '123';
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testbharath@email.com', 'testjitta@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Bharath','Jitta',true); 
        system.setPassword(oUser.ID, 'TestPassword');
        
        List<DAZNCommunicatorConfig__c> lstCustomSetting = new List<DAZNCommunicatorConfig__c>();
        List<DAZNConfiguration__c> lstConfig = new List<DAZNConfiguration__c>();
        
        lstConfig.add(new DAZNConfiguration__c(name='LoginPageURL', Value__c='test.salesforce.com'));
        lstConfig.add(new DAZNConfiguration__c(name='CommunicatorAPIUserName', Value__c='test'));
        lstConfig.add(new DAZNConfiguration__c(name='CommunicatorAPIUserPwd', Value__c='test'));
        insert lstConfig;
                
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Expiry_en_GB',Value__c=12345));
        insert lstCustomSetting;
        System.RunAs(oUser){
        Test.StartTest();
            PageReference pageRef2 = Page.changePassword;
            Test.setCurrentPage(pageRef2);
            ApexPages.currentPage().getParameters().put('field','Password');
            ChangePasswordController objCntrl = new ChangePasswordController();

            /*SavePasswordChanges always returns null when the page isn't accessed as a guest user*/
            System.assert(objCntrl.changePassword() == null);
            objCntrl.oldPassword = 'TestPassword';
            objCntrl.newPassword = 'test1234';
            objCntrl.verifyNewPassword = 'test1234';
            objCntrl.strMessage = '';
            System.assert(objCntrl.changePassword() != null);

            objCntrl.oldPassword = '';
            objCntrl.strMessage = '';
            System.assert(objCntrl.changePassword() != null);

        Test.stopTest();
        }
    }
    
    /*Testing the Password Change Functionality Validations*/
    static testMethod void testPasswordChangesValidation() { 
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName','test@test.com','Active');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        System.RunAs(oUser){
        Test.StartTest();
            
            ChangePasswordController objCntrl = new ChangePasswordController();
            objCntrl.sCountry = '';
            objCntrl.newPassword = '';
            objCntrl.changePassword();
            system.assertEquals(Label.LS_MyAccount_ErrMsg_BlankPassword, objCntrl.sProvideValidNewPasswordErrMsg);
            
            objCntrl.newPassword = 'Test123456789123456789987654321121';
            objCntrl.changePassword();
            system.assertEquals(Label.LS_MyAccount_ErrMsg_PasswordLength, objCntrl.sProvideValidNewPasswordErrMsg);
            
            objCntrl.newPassword = 'Test12@15';
            objCntrl.verifyNewPassword = 'Test123@12345';
            objCntrl.changePassword();
            system.assertEquals(objCntrl.sProvideValidNewPasswordErrMsg, Label.LS_MyAccount_ErrMsg_NewPwdAndRepeatPwdDoNotMatch);
            
            Test.stopTest();
        }
    }

    static testMethod void testNavigateUser() {
        ChangePasswordController objCntrl = new ChangePasswordController();
        objCntrl.navigateUser();
        System.assert(objCntrl.navigateUser() == null);
    }
    
    static testMethod void testPasswordChangesUser() {
        SetUpTestData.triggerSettings();
        User guestUser = [select id, name from User where userType = 'Guest' AND isActive = true LIMIT 1];
        
        Test.StartTest();
            System.runAs(guestUser) {
                try {
                    ChangePasswordController objCntrl = new ChangePasswordController();
                    objCntrl.user = null;
                    objCntrl.changePassword();
                } catch (Exception ex) {}
                
            }
        Test.stopTest();
    }

    static testMethod void testSSOChangePassFail() {
        SetUpTestData.triggerSettings();
        List<DAZNConfiguration__c> daznConfig = new List<DAZNConfiguration__c>();
        daznConfig.add(new DAZNConfiguration__c(
            Name = 'SSO Comunity User Profile Id',
            Value__c = [Select Id From Profile Where Name = 'Customer Community User SSO' LIMIT 1].Id
        ));
        daznConfig.add(new DAZNConfiguration__c(
            Name = 'SSO Enabled Country Codes',
            Value__c = 'DE, CA'
        ));
        insert daznConfig;

        Account oAccount = SetUpTestData.createPersonAccount('DE', 'de', 'TestFirstName', 'TestLastName','testusername@email.com','Free Trial');
        oAccount.Notification_Country_Code__c = 'DE';
        oAccount.Notification_Language_Code__c = 'de';
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true, 'United Kingdom');
        Id ssoProfileId;
        
        System.runAs(oUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockChangePasswordFail());
            ChangePasswordController objCntrl = new ChangePasswordController();
            objCntrl.newPassword = 'Test123@12345';
            objCntrl.verifyNewPassword = 'Test123@12345';
            PageReference pr = objCntrl.changePassword();
            System.assertEquals(null, pr);
            Test.stopTest();
        }
    }

    static testMethod void testSSOChangePassSuccess() {
        SetUpTestData.triggerSettings();
        List<DAZNConfiguration__c> daznConfig = new List<DAZNConfiguration__c>();
        daznConfig.add(new DAZNConfiguration__c(
            Name = 'SSO Comunity User Profile Id',
            Value__c = [Select Id From Profile Where Name = 'Customer Community User SSO' LIMIT 1].Id
        ));
        daznConfig.add(new DAZNConfiguration__c(
            Name = 'SSO Enabled Country Codes',
            Value__c = 'DE, CA'
        ));
        insert daznConfig;

        List<MISL_Configuration__c> mislConfig = new List<MISL_Configuration__c>();
        mislConfig.add(new MISL_Configuration__c(
            Name = 'MISL_ChangeUserPassword_DE',
            Value__c = 'test',
            Enabled_Country_Codes__c = 'DE',
            Timeout__c = 3000
        ));
        mislConfig.add(new MISL_Configuration__c(
            Name = 'MISL_ChangeUserPassword_CA',
            Value__c = 'test',
            Enabled_Country_Codes__c = 'CA',
            Timeout__c = 3000
        ));
        mislConfig.add(new MISL_Configuration__c(
            Name = 'MISL_Username',
            Value__c = 'test'
        ));
        mislConfig.add(new MISL_Configuration__c(
            Name = 'MISL_Password',
            Value__c = EncodingUtil.base64Encode(Blob.valueOf('test'))
        ));
        insert mislConfig;

        Account oAccount = SetUpTestData.createPersonAccount('DE', 'de', 'TestFirstName', 'TestLastName','testusername@email.com','Free Trial');
        oAccount.Notification_Country_Code__c = 'DE';
        oAccount.Notification_Language_Code__c = 'de';
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true, 'United Kingdom');
        Id ssoProfileId;
        
        System.runAs(oUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockChangePasswordSuccess());
            ChangePasswordController objCntrl = new ChangePasswordController();
            objCntrl.user = null;
            objCntrl.newPassword = 'Test123@12345';
            objCntrl.verifyNewPassword = 'Test123@12345';
            PageReference pr = objCntrl.changePassword();
            System.assertNotEquals(null, pr);
            Test.stopTest();
        }
    }

    public class MockUpdateProfileSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('Profile Updated');
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockChangePasswordSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ Password Changed }');
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockChangePasswordFail implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('Fail');
            res.setStatusCode(400);
            return res;
        }
    }
    
}