@isTest
private class MISLCalloutHelperTest {
    
    @testSetup
    public static void setUpTestData() {
        List<MISL_Configuration__c> config = new List<MISL_Configuration__c>();
        config.add(new MISL_Configuration__c(
            Name = 'MISL_GetUserDevices',
            Value__c = 'UserDevices',
            Enabled_Country_Codes__c = 'DE',
            Timeout__c = 3000
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_Username',
            Value__c = 't1'
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_Password',
            Value__c = EncodingUtil.base64Encode(Blob.valueOf('t2'))
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_ChangeUserPassword_DE',
            Value__c = 'test',
            Enabled_Country_Codes__c = 'DE',
            Timeout__c = 1000
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_DeRegisterDevices',
            Value__c = 'DeRegisterDevices',
            Enabled_Country_Codes__c = 'DE',
            Timeout__c = 3000
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_UpdateUserDetails',
            Value__c = 'UserDevices',
            Enabled_Country_Codes__c = 'DE',
            Timeout__c = 3000
        ));
        insert config;
    }

    @isTest 
    static void testGetUserDevices() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Account emptyAccount = new Account();

        PageReference userDeviceRelListPage = Page.UserDeviceRelList;
        Test.setCurrentPage(userDeviceRelListPage);
        Test.startTest();
            Map<String, String> resultMap = MISLCalloutHelper.getUserDevices(null, null);
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
            
            resultMap = MISLCalloutHelper.getUserDevices(oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
            
            Test.setMock(HttpCalloutMock.class, new MockUserDevicesResponse());
            resultMap = MISLCalloutHelper.getUserDevices(oAccount.Id, 'DE');
            System.assertEquals(true, Boolean.valueOf(resultMap.get('success')));
            
            Test.setMock(HttpCalloutMock.class, new MockGetUserDevicesUnauthorized());
            resultMap = MISLCalloutHelper.getUserDevices(oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
            
            Test.setMock(HttpCalloutMock.class, new MockGetUserDevicesNotFound());
            resultMap = MISLCalloutHelper.getUserDevices(oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
            
            Test.setMock(HttpCalloutMock.class, new MockGetUserDevicesInternalServerError());
            resultMap = MISLCalloutHelper.getUserDevices(oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
            
            Test.setMock(HttpCalloutMock.class, new MockGetUserDevicesUnknownError());
            resultMap = MISLCalloutHelper.getUserDevices(oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
            
            List<MISL_Configuration__c> getUserDevicesConfig = [SELECT Id, Timeout__c FROM MISL_Configuration__c WHERE Name = 'MISL_GetUserDevices' LIMIT 1];
            getUserDevicesConfig[0].Timeout__c = 0;
            update getUserDevicesConfig[0];
            resultMap = MISLCalloutHelper.getUserDevices(oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
            
            delete getUserDevicesConfig;
            resultMap = MISLCalloutHelper.getUserDevices(oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        Test.stopTest();
    }
    
    @isTest 
    static void testDeRegisterDevicesSuccess() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Account emptyAccount = new Account();

        Test.startTest();
            Map<String, Object> payload = new Map<String, Object>{
                'AllDevices' => true,
                'AccountId' => oAccount.Id
            };
            Test.setMock(HttpCalloutMock.class, new MockDeRegisterDevicesSuccessResponse());
            Map<String, String> resultMap = MISLCalloutHelper.deRegisterDevices(payload, oAccount.Id, 'DE');
            System.assertEquals(true, Boolean.valueOf(resultMap.get('success')));
            
            Test.setMock(HttpCalloutMock.class, new MockDeRegisterDevicesInternalServerError());
            resultMap = MISLCalloutHelper.deRegisterDevices(payload, oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        Test.stopTest();
    }
    
    @isTest 
    static void testDeRegisterDevicesDataIssue() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Account emptyAccount = new Account();

        Test.startTest();
            Map<String, Object> payload = new Map<String, Object>{
                'AllDevices' => true,
                'AccountId' => oAccount.Id
            };
            List<MISL_Configuration__c> getUserDevicesConfig = [SELECT Id, Timeout__c FROM MISL_Configuration__c WHERE Name = 'MISL_DeRegisterDevices' LIMIT 1];
            getUserDevicesConfig[0].Timeout__c = 0;
            update getUserDevicesConfig[0];
            Map<String, String> resultMap = MISLCalloutHelper.deRegisterDevices(payload, oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
            
            delete getUserDevicesConfig;
            resultMap = MISLCalloutHelper.deRegisterDevices(payload, oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        Test.stopTest();
    }
    
    @isTest 
    static void testDeRegisterDevicesFailure() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Account emptyAccount = new Account();

        Test.startTest();
            Map<String, Object> payload = new Map<String, Object>{
                'AllDevices' => true,
                'AccountId' => oAccount.Id
            };
            Test.setMock(HttpCalloutMock.class, new MockDeRegisterDevicesInternalServerError());
            Map<String, String> resultMap = MISLCalloutHelper.deRegisterDevices(payload, oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        Test.stopTest();
    }
    
    @isTest 
    static void testDeRegisterDevicesFailureNotFound() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Account emptyAccount = new Account();

        Test.startTest();
            Map<String, Object> payload = new Map<String, Object>{
                'AllDevices' => true,
                'AccountId' => oAccount.Id
            };
            Test.setMock(HttpCalloutMock.class, new MockDeRegisterDevicesFailureNotFound());
            Map<String, String> resultMap = MISLCalloutHelper.deRegisterDevices(payload, oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        Test.stopTest();
    }
    
    @isTest 
    static void testDeRegisterDevicesInternalServerError() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Account emptyAccount = new Account();

        Test.startTest();
            Map<String, Object> payload = new Map<String, Object>{
                'AllDevices' => true,
                'AccountId' => oAccount.Id
            };
            Test.setMock(HttpCalloutMock.class, new MockDeRegisterDevicesInternalServerError());
            Map<String, String> resultMap = MISLCalloutHelper.deRegisterDevices(payload, oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        Test.stopTest();
    }
    
    @isTest 
    static void testDeRegisterDevicesAnotherFailure() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Account emptyAccount = new Account();

        Test.startTest();
            Map<String, Object> payload = new Map<String, Object>{
                'AllDevices' => true,
                'AccountId' => oAccount.Id
            };
            Test.setMock(HttpCalloutMock.class, new MockDeRegisterDevicesAnnotherFailure());
            Map<String, String> resultMap = MISLCalloutHelper.deRegisterDevices(payload, oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        Test.stopTest();
    }
    
    @isTest 
    static void testDeRegisterDevicesBadResponse() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Account emptyAccount = new Account();

        Test.startTest();
            Map<String, Object> payload = new Map<String, Object>{
                'AllDevices' => true,
                'AccountId' => oAccount.Id
            };
            Test.setMock(HttpCalloutMock.class, new MockDeRegisterDevicesBadResponse());
            Map<String, String> resultMap = MISLCalloutHelper.deRegisterDevices(payload, oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        Test.stopTest();
    }
    
    @isTest 
    static void testDeRegisterDevicesUnauthorized() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Account emptyAccount = new Account();

        Test.startTest();
            Map<String, Object> payload = new Map<String, Object>{
                'AllDevices' => true,
                'AccountId' => oAccount.Id
            };
            Test.setMock(HttpCalloutMock.class, new MockDeRegisterDevicesUnauthorized());
            Map<String, String> resultMap = MISLCalloutHelper.deRegisterDevices(payload, oAccount.Id, 'DE');
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        Test.stopTest();
    }
    
    @isTest 
    static void testUpdateUserDetailsSuccess() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Account emptyAccount = new Account();

        Test.startTest();
            Map<String, Object> payload = new Map<String, Object>{
                'IsCrmRequest' => true,
                'AccountId' => oAccount.Id,
                'NewUserAccountStatus' => 'Active Paid'
            };
            Test.setMock(HttpCalloutMock.class, new MockUpdateUserDetailsSuccessResponse());
            Map<String, String> resultMap = MISLCalloutHelper.updateUserDetails(payload, oAccount.Id, 'DE', false);
            System.assertEquals(true, Boolean.valueOf(resultMap.get('success')));
            System.assertEquals(0, [SELECT Id FROM API_Log__c].size());
            
            resultMap = MISLCalloutHelper.updateUserDetails(payload, oAccount.Id, 'DE', true);
            System.assertEquals(true, Boolean.valueOf(resultMap.get('success')));
            
            Test.setMock(HttpCalloutMock.class, new MockUpdateUserDetailsFailure());
            resultMap = MISLCalloutHelper.updateUserDetails(payload, oAccount.Id, 'DE', false);
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateUserDetailsDataIssue() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Account emptyAccount = new Account();

        Test.startTest();
            Map<String, Object> payload = new Map<String, Object>{
                'IsCrmRequest' => true,
                'AccountId' => oAccount.Id,
                'NewUserAccountStatus' => 'Active Paid'
            };
            List<MISL_Configuration__c> getUserDevicesConfig = [SELECT Id, Timeout__c FROM MISL_Configuration__c WHERE Name = 'MISL_UpdateUserDetails' LIMIT 1];
            getUserDevicesConfig[0].Timeout__c = 0;
            update getUserDevicesConfig[0];
            Map<String, String> resultMap = MISLCalloutHelper.updateUserDetails(payload, oAccount.Id, 'DE', true);
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
            
            delete getUserDevicesConfig;
            resultMap = MISLCalloutHelper.updateUserDetails(payload, oAccount.Id, 'DE', true);
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateUserDetailsUnauthorized() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Account emptyAccount = new Account();

        Test.startTest();
            Map<String, Object> payload = new Map<String, Object>{
                'IsCrmRequest' => true,
                'AccountId' => oAccount.Id,
                'NewUserAccountStatus' => 'Active Paid'
            };
            Test.setMock(HttpCalloutMock.class, new MockUpdateUserDetailsUnauthorized());
            Map<String, String> resultMap = MISLCalloutHelper.updateUserDetails(payload, oAccount.Id, 'DE', true);
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
            System.assertEquals(true, [SELECT Id FROM API_Log__c].size() >  0);
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateUserDetailsAnotherFailure() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Account emptyAccount = new Account();

        Test.startTest();
            Map<String, Object> payload = new Map<String, Object>{
                'IsCrmRequest' => true,
                'AccountId' => oAccount.Id,
                'NewUserAccountStatus' => 'Active Paid'
            };
            Test.setMock(HttpCalloutMock.class, new MockUpdateUserDetailsAnotherFailure());
            Map<String, String> resultMap = MISLCalloutHelper.updateUserDetails(payload, oAccount.Id, 'DE', true);
            System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
            System.assertEquals(true, [SELECT Id FROM API_Log__c].size() >  0);
        Test.stopTest();
    }
    
    @isTest
    static void testChangePasswordSuccess() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'test@test.com', 'Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);

        Map<String, String> resultMap;

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockChangePasswordSuccess());
        resultMap = MISLCalloutHelper.changePassword(new Map<String, Object> { 'Email' => 'test', 'CheckOldPassword' => 'false', 'NewPassword' => 'test' }, 'DE', oAccount.Id);
        System.assertEquals(true, Boolean.valueOf(resultMap.get('success')));
        System.assertEquals('{ Password Changed }', resultMap.get('message'));

        Test.stopTest();
    }

    @isTest
    static void testChangePasswordFailure() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'test@test.com', 'Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);

        Map<String, String> resultMap;

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockChangePasswordFailure());
        resultMap = MISLCalloutHelper.changePassword(new Map<String, Object> { 'Email' => 'test', 'CheckOldPassword' => 'false', 'NewPassword' => 'test' }, 'DE', oAccount.Id);
        System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        System.assertEquals('400 - {"code": "10004","message": "Invalid New Password"}', resultMap.get('message'));

        Test.stopTest();
    }

    @isTest
    static void testChangePasswordException() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'test@test.com', 'Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);

        Map<String, String> resultMap;

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockChangePasswordException());
        resultMap = MISLCalloutHelper.changePassword(new Map<String, Object> { 'Email' => 'test', 'CheckOldPassword' => 'false', 'NewPassword' => 'test' }, 'DE', oAccount.Id);
        System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        System.assertEquals('test exception', resultMap.get('message'));

        delete [SELECT Id FROM MISL_Configuration__c WHERE Name = 'MISL_Username'];
        resultMap = MISLCalloutHelper.changePassword(new Map<String, Object>(), 'DE', oAccount.Id);
        System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        System.assertEquals('Custom settings are missed: DeRegisterDevices URL/Username/Password/Timeout', resultMap.get('message'));

        MISL_Configuration__c conf = [SELECT Id, Enabled_Country_Codes__c FROM MISL_Configuration__c WHERE Name = 'MISL_ChangeUserPassword_DE' LIMIT 1];
        conf.Enabled_Country_Codes__c = '';
        update conf;
        resultMap = MISLCalloutHelper.changePassword(new Map<String, Object> {''=>'dtyjy.,<>/'}, 'DE', oAccount.Id);
        System.assertEquals(false, Boolean.valueOf(resultMap.get('success')));
        System.assertEquals('ChangeUserPassword endpoint is disabled', resultMap.get('message'));

        Test.stopTest();
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

    public class MockChangePasswordFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                    '"code": "10004",' +
                    '"message": "Invalid New Password"' +
                '}'
            );
            res.setStatusCode(400);
            return res;
        }
    }

    public class MockChangePasswordException extends Exception implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            CalloutException e = new CalloutException();
            e.setMessage('test exception');
            throw e;
            return res;
        }
    }

    public class MockUserDevicesResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                    '"Devices": [' +
                        '{' +
                            '"Id": "deviceId1",' +
                            '"RegistrationDate": "2017-03-10 10:42:43.379Z",' +
                            '"Type": "Tablet"' +
                        '},' +
                        '{' +
                            '"Id": "deviceId2",' +
                            '"RegistrationDate": "2017-03-11 10:44:43.379Z",' +
                            '"Type": "TV"' +
                        '}' +
                    ']' +
                '}'
            );
            res.setStatusCode(200);
            return res;
        }
    }
    
    public class MockGetUserDevicesUnauthorized implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' + 
                     '"error": {' +
                       '"code": "10001",' +
                       '"message": {' +
                         '"lang": "en-US",' +
                         '"value": "Invalid Authorization."' +
                       '}' +
                     '}' +
                '}'
            );
            res.setStatusCode(401);
            return res;
        }
    }
    
    public class MockGetUserDevicesNotFound implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' + 
                     '"error": {' +
                       '"code": "10001",' +
                       '"message": {' +
                         '"lang": "en-US",' +
                         '"value": "Device not found."' +
                       '}' +
                     '}' +
                '}'
            );
            res.setStatusCode(404);
            return res;
        }
    }
    
    public class MockGetUserDevicesInternalServerError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' + 
                     '"error": {' +
                       '"code": "10001",' +
                       '"message": {' +
                         '"lang": "en-US",' +
                         '"value": "UnknownError."' +
                       '}' +
                     '}' +
                '}'
            );
            res.setStatusCode(500);
            return res;
        }
    }
    
    public class MockGetUserDevicesUnknownError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' + 
                     '"error": {' +
                       '"code": "10001",' +
                       '"message": {' +
                         '"lang": "en-US",' +
                         '"value": "UnknownError."' +
                       '}' +
                     '}' +
                '}'
            );
            res.setStatusCode(501);
            return res;
        }
    }
    
    public class MockDeRegisterDevicesSuccessResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(204);
            return res;
        }
    }
    
    public class MockDeRegisterDevicesBadResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                    '"error": {' +
                        '"code": 10000,' +
                        '"message": {' +
                            '"lang": "en-US",' +
                            '"value": "Request failed validation."' +
                        '},' +
                        '"validationErrors": [' +
                            '{' +
                                '"Property": "AccountId",' +
                                '"Rule": "The AccountId field is required."' +
                            '},' +
                            '{' +
                                '"Property": "DeviceId",' +
                                '"Rule": "The DeviceId field is required if AllDevices is false."' +
                            '}' +
                        ']' +
                    '}' +
                '}'
            );
            res.setStatusCode(400);
            return res;
        }
    }
    
    public class MockDeRegisterDevicesUnauthorized implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' + 
                     '"error": {' +
                       '"code": "10001",' +
                       '"message": {' +
                         '"lang": "en-US",' +
                         '"value": "Invalid Authorization."' +
                       '}' +
                     '}' +
                '}'
            );
            res.setStatusCode(401);
            return res;
        }
    }
    
    public class MockDeRegisterDevicesFailureNotFound implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' + 
                     '"error": {' +
                       '"code": "10001",' +
                       '"message": {' +
                         '"lang": "en-US",' +
                         '"value": "No devices found."' +
                       '}' +
                     '}' +
                '}'
            );
            res.setStatusCode(404);
            return res;
        }
    }
    
    public class MockDeRegisterDevicesInternalServerError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' + 
                     '"error": {' +
                       '"code": "10001",' +
                       '"message": {' +
                         '"lang": "en-US",' +
                         '"value": "Invalid Authorization."' +
                       '}' +
                     '}' +
                '}'
            );
            res.setStatusCode(500);
            return res;
        }
    }
    
    public class MockDeRegisterDevicesAnnotherFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' + 
                     '"error": {' +
                       '"code": "10001",' +
                       '"message": {' +
                         '"lang": "en-US",' +
                         '"value": "Invalid Authorization."' +
                       '}' +
                     '}' +
                '}'
            );
            res.setStatusCode(505);
            return res;
        }
    }
    
    public class MockUpdateUserDetailsSuccessResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('');
            res.setStatusCode(200);
            return res;
        }
    }
    
    public class MockUpdateUserDetailsUnauthorized implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' + 
                     '"error": {' +
                       '"code": "10001",' +
                       '"message": {' +
                         '"lang": "en-US",' +
                         '"value": "Invalid Authorization"' +
                       '}' +
                     '}' +
                '}'
            );
            res.setStatusCode(401);
            return res;
        }
    }
    
    public class MockUpdateUserDetailsAnotherFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' + 
                     '"error": {' +
                       '"code": "10001",' +
                       '"message": {' +
                         '"lang": "en-US",' +
                         '"value": "Error."' +
                       '}' +
                     '}' +
                '}'
            );
            res.setStatusCode(505);
            return res;
        }
    }
    
    public class MockUpdateUserDetailsFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' + 
                     '"error": {' +
                       '"code": "10001",' +
                       '"message": {' +
                         '"lang": "en-US",' +
                         '"value": "No devices found."' +
                       '}' +
                     '}' +
                '}'
            );
            res.setStatusCode(404);
            return res;
        }
    }
}