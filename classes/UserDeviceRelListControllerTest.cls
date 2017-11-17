/* This test class will cover the code coverage for UserDeviceRelListController */
@isTest
public class UserDeviceRelListControllerTest {

    @isTest 
    static void testGetUserDevicesFromMISL() {
        TriggerSetting__c triggerSet1 = new TriggerSetting__c(name ='BillingAccountTrigger', Disable__c = false);
        insert triggerSet1;
        TriggerSetting__c triggerSet2 = new TriggerSetting__c(name ='UpdateAccountTrigger', Disable__c = false);
        insert triggerSet2;
        TriggerSetting__c triggerSet3 = new TriggerSetting__c(name ='SubscriptionTrigger', Disable__c = false);
        insert triggerSet3;
        TriggerSetting__c triggerSet4 = new TriggerSetting__c(name ='UserDeviceTrigger', Disable__c = false);
        insert triggerSet4;
        
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
        insert config;
        
        Account oAccount = SetUpTestData.createPersonAccount('DE', 'EN_GB', 'TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        oAccount.Notification_Country_Code__c = 'DE';
        update oAccount;

        PageReference userDeviceRelListPage = Page.UserDeviceRelList;
        Test.setCurrentPage(userDeviceRelListPage);
        
        Test.startTest();
            UserDeviceRelListController controller = new UserDeviceRelListController(new ApexPages.StandardController(oAccount));
            System.assertEquals(true, controller.userDevices.isEmpty());
            Test.setMock(HttpCalloutMock.class, new MockUserDevicesResponse());
            UserDeviceRelListController controller2 = new UserDeviceRelListController(new ApexPages.StandardController(oAccount));
            System.assertEquals(true, !controller2.userDevices.isEmpty());
        Test.stopTest();
    }
    
    @isTest 
    static void testGetUserDevicesFromSF() {
        TriggerSetting__c triggerSet1 = new TriggerSetting__c(name ='BillingAccountTrigger', Disable__c = false);
        insert triggerSet1;
        TriggerSetting__c triggerSet2 = new TriggerSetting__c(name ='UpdateAccountTrigger', Disable__c = false);
        insert triggerSet2;
        TriggerSetting__c triggerSet3 = new TriggerSetting__c(name ='SubscriptionTrigger', Disable__c = false);
        insert triggerSet3;
        TriggerSetting__c triggerSet4 = new TriggerSetting__c(name ='UserDeviceTrigger', Disable__c = false);
        insert triggerSet4;
        
        List<MISL_Configuration__c> config = new List<MISL_Configuration__c>();
        config.add(new MISL_Configuration__c(
            Name = 'MISL_Username',
            Value__c = 't1'
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_Password',
            Value__c = EncodingUtil.base64Encode(Blob.valueOf('t2'))
        ));
        insert config;
        
        Account oAccount = SetUpTestData.createPersonAccount('DE', 'EN_GB', 'TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        oAccount.Notification_Country_Code__c = 'DE';
        update oAccount;
        User_Devices__c singleDev = SetUpTestData.createUserDevice(oAccount.Id, 'Test User Device', System.today(), 'Desktop' , 'Active');

        PageReference userDeviceRelListPage = Page.UserDeviceRelList;
        Test.setCurrentPage(userDeviceRelListPage);
        
        Test.startTest();
            UserDeviceRelListController controller = new UserDeviceRelListController(new ApexPages.StandardController(oAccount));
            System.assertEquals(true, !controller.userDevices.isEmpty());
        Test.stopTest();
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

}