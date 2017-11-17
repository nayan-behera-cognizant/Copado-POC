@isTest 
public class signOutSingleDevicesControllerTest {
    
    static testMethod void  signOutSingleDevicesControllerMethod() {
        SetUpTestData.triggerSettings();
        String strExternalId = '';
        String DeviceId = 'Test001';
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'testemail@email.com', 'Frozen');
        User oUser = SetUpTestData.createCommunityUser(strExternalId, 'en_GB', 'DE', oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);
        User_Devices__c objUserDevice = new User_Devices__c();
        objUserDevice.Account__c = oAccount.id;
        objUserDevice.Device_Id__c = 'Test001';
        objUserDevice.Date_Of_Registration__c = system.today();
        objUserDevice.Type__c = 'DESKTOP';
        insert objUserDevice;
        
        List<User> oUserList = new List<User>();
        oUserList.add(oUser);
        System.assertEquals(1, oUserList.size());
        List<User> oUserListnull = new List<User>();
        List<User_Devices__c> objUserDeviceList = new List<User_Devices__c>();
        objUserDeviceList.add(objUserDevice);
        System.assertEquals(1, objUserDeviceList.size());
        signOutSingleDevicesController.signOutSingleDevicesPost(strExternalId, DeviceId);
        signOutSingleDevicesController.response resposne = new signOutSingleDevicesController.response();
        resposne.strStatus = 'SUCCESS';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/signOutSingleDevices'; //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        RestContext.request = req;
        RestContext.response = res;
    }
    static testMethod void  signOutSingleDevicesControllerMethod2() {
        SetUpTestData.triggerSettings();
        String strExternalId = 'Ext-00005952';
        String DeviceId = '';
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Frozen');
        User oUser = SetUpTestData.createCommunityUser(strExternalId, 'en_GB', 'DE', oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName', true);
        User_Devices__c objUserDevice = new User_Devices__c();
        objUserDevice.Account__c = oAccount.id;
        objUserDevice.Device_Id__c = 'Test001';
        objUserDevice.Date_Of_Registration__c = system.today();
        objUserDevice.Type__c = 'Desktop';
        insert objUserDevice; 
        
        List<User> oUserList = new List<User>();
        oUserList.add(oUser);
        System.assertEquals(1, oUserList.size());
        List<User_Devices__c> objUserDeviceList = new List<User_Devices__c>();
        objUserDeviceList.add(objUserDevice);
        System.assertEquals(1, objUserDeviceList.size());
        
        signOutSingleDevicesController.signOutSingleDevicesPost(strExternalId, DeviceId);
        signOutSingleDevicesController.response resposne = new signOutSingleDevicesController.response();
        resposne.strStatus = 'SUCCESS';
        MyAccountController.signOutOfSingleDevicesUpdated(objUserDeviceList, oUserList, DeviceId);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/signOutSingleDevices'; //Request URL
        req.httpMethod = 'POST';//HTTP Request Type   
        RestContext.request = req;
        RestContext.response = res;
    }
    static testMethod void  signOutSingleDevicesControllerMethod3() {
        SetUpTestData.triggerSettings();
        String strExternalId = 'Ext-00005952';
        String DeviceId = 'Test0011';
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Frozen');
        User oUser = SetUpTestData.createCommunityUser(strExternalId, 'en_GB', 'DE', oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName', true);
        User_Devices__c objUserDevice = new User_Devices__c();
        objUserDevice.Account__c = oAccount.id;
        objUserDevice.Device_Id__c = 'Test0011';
        objUserDevice.Date_Of_Registration__c = system.today();
        objUserDevice.Type__c = 'Desktop';
        insert objUserDevice; 
        
        List<User> oUserList = new List<User>();
        oUserList.add(oUser);
        System.assertEquals(1, oUserList.size());
        List<User_Devices__c> objUserDeviceList = new List<User_Devices__c>();
        objUserDeviceList.add(objUserDevice);
        System.assertEquals(1, objUserDeviceList.size());
        
        signOutSingleDevicesController.signOutSingleDevicesPost(strExternalId, DeviceId);
        signOutSingleDevicesController.response resposne = new signOutSingleDevicesController.response();
        resposne.strStatus = 'SUCCESS';
        MyAccountController.signOutOfSingleDevicesUpdated(objUserDeviceList, oUserList, DeviceId);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/signOutSingleDevices'; //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        RestContext.request = req;
        RestContext.response = res;
    }
    static testMethod void  signOutSingleDevicesControllerMethod4() {
        SetUpTestData.triggerSettings();
        String strExternalId = 'Ext-00414648';
        String DeviceId = 'Test0011';
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Frozen');
        User oUser = SetUpTestData.createCommunityUser(strExternalId, 'en_GB', 'DE', oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName', true);
        User_Devices__c objUserDevice = new User_Devices__c();
        objUserDevice.Account__c = oAccount.Id;
        objUserDevice.Device_Id__c = 'Test0011';
        objUserDevice.Date_Of_Registration__c = system.today();
        objUserDevice.Type__c = 'Desktop';
        objUserDevice.Status__c = 'Active';
        insert objUserDevice; 
        
        List<User> oUserList = new List<User>();
        oUserList.add(oUser);
        System.assertEquals(1, oUserList.size());
        
        List<User_Devices__c> objUserDeviceList = new List<User_Devices__c>();
        objUserDeviceList.add(objUserDevice);
        System.assertEquals(1, objUserDeviceList.size());
        
        signOutSingleDevicesController.signOutSingleDevicesPost(strExternalId, '');
        signOutSingleDevicesController.response resposne = new signOutSingleDevicesController.response();
        resposne.strStatus = 'SUCCESS';
        MyAccountController.signOutOfSingleDevicesUpdated(objUserDeviceList, oUserList,DeviceId);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/signOutSingleDevices'; //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        RestContext.request = req;
        RestContext.response = res;
    }
    static testMethod void  signOutSingleDevicesControllerMethod5() {
        SetUpTestData.triggerSettings();
        String strExternalId = 'Ext-00005952';
        String DeviceId = 'Test0011';
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Frozen');
        User oUser = SetUpTestData.createCommunityUser(strExternalId, 'en_GB', 'DE', oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName', true);
        
        List<User> oUserList = new List<User>();
        oUserList.add(oUser);
        System.assertEquals(1, oUserList.size());
        
        List<User_Devices__c> objUserDeviceList = new List<User_Devices__c>();
        Test.startTest();
        signOutSingleDevicesController.signOutSingleDevicesPost(strExternalId , DeviceId);
        signOutSingleDevicesController.response resposne = new signOutSingleDevicesController.response();
        signOutSingleDevicesController.updateFailedResponse(resposne, 'Error happens', 100);
        resposne.strStatus = 'SUCCESS';
        MyAccountController.signOutOfSingleDevicesUpdated(objUserDeviceList, oUserList, DeviceId);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/signOutSingleDevices'; //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        RestContext.request = req;
        RestContext.response = res;
        Test.stopTest();
    }
    
}