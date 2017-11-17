@isTest
public class CSSignoutfromalldevicesTest {

    @testSetup
    public static void getCommUsersTestData() {
        CreateTestDataforUnitTest.triggerSettings();
        CreateZuoraDataforUnitTest.createZuoraDeatils();
        CreateTestDataforUnitTest.createTestcustomsetting();
        
        List<MISL_Configuration__c> config = new List<MISL_Configuration__c>();
        config.add(new MISL_Configuration__c(
            Name = 'MISL_DeRegisterDevices',
            Value__c = 'DeRegisterDevices',
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
    }  
    static testMethod void testCSShowallleDeviceSuccess() {
        List<Account> accList = [SELECT Id, Name, PersonEmail, PersonContactId FROM Account WHERE Account_Status__c = 'Active Paid'];
	    List<Profile> profile = [SELECT Id, Name FROM profile WHERE Name = 'Customer Service Team Member' LIMIT 1];
        System.assert(profile.size() > 0);
        List<User> oUser = [
            SELECT Id, Name, UserName, Alias, Country, profileId, LanguageLocaleKey
            FROM User
            WHERE profileId=:profile[0].Id
            AND IsActive = true LIMIT 1
        ];
        System.assertNotEquals(null, oUser);
        List<User_Devices__c> userDiv = [
            SELECT Id, Device_Name__c, Account__c, Date_Of_Registration__c, Type__c, Status__c
            FROM User_Devices__c
            WHERE Account__c =: accList[0].id
        ];
        Integer countOfDiv = userDiv.size();
        System.RunAs(oUser[0]) {
            Test.startTest();
            
            Test.setMock(HttpCalloutMock.class, new MockDeRegisterDevicesResponse());
            String isSuccess = CSSignoutfromalldevices.CSForceSignout(accList[0].Id);
            System.assertEquals('Success', isSuccess);
            
            Test.stopTest();
        }
    }
    
    static testMethod void testCSShowallleDeviceMISLDisabled() {
        List<Account> accList = [SELECT Id, Name, PersonEmail, PersonContactId FROM Account WHERE Account_Status__c = 'Active Paid'];
        List<Profile> profile = [SELECT Id, Name FROM profile WHERE Name = 'Customer Service Team Member' LIMIT 1];
        System.assert(profile.size() > 0);
        List<User> oUser = [
            SELECT Id, Name, UserName, Alias, Country, profileId, LanguageLocaleKey
            FROM User
            WHERE profileId=:profile[0].Id
            AND IsActive = true LIMIT 1
        ];
        System.assertNotEquals(null, oUser);
        List<User_Devices__c> userDiv = [
            SELECT Id, Device_Name__c, Account__c, Date_Of_Registration__c, Type__c, Status__c
            FROM User_Devices__c
            WHERE Account__c =: accList[0].Id
        ];
        User_Devices__c singleDev = SetUpTestData.createUserDevice(accList[0].Id, 'Test User Device', System.today(), 'Desktop' , 'Active');
        delete MISL_Configuration__c.getValues('MISL_DeRegisterDevices');
        System.RunAs(oUser[0]) {
            Test.startTest();
            String isSuccess = CSSignoutfromalldevices.CSForceSignout(accList[0].Id);
            System.assertEquals('Success', isSuccess);
            Test.stopTest();
        }
        System.assertEquals(0, [SELECT Id FROM User_Devices__c WHERE Account__c =: accList[0].Id].size());
    }
    
    static testMethod void testCSShowallleDeviceFailure() {
        List<Account> accList = [SELECT Id, Name, PersonEmail, PersonContactId FROM Account WHERE Account_Status__c = 'Active Paid'];
	    List<Profile> profile = [SELECT Id, Name FROM profile WHERE Name = 'Customer Service Team Member' LIMIT 1];
        System.assert(profile.size() > 0);
        List<User> oUser = [
            SELECT Id, Name, UserName, Alias, Country, profileId, LanguageLocaleKey
            FROM User
            WHERE profileId=:profile[0].Id
            AND IsActive = true LIMIT 1
        ];
        System.assertNotEquals(null, oUser);
        List<User_Devices__c> userDiv = [
            SELECT Id, Device_Name__c, Account__c, Date_Of_Registration__c, Type__c, Status__c
            FROM User_Devices__c
            WHERE Account__c =: accList[0].id
        ];
        Integer countOfDiv = userDiv.size();
        System.RunAs(oUser[0]) {
            Test.startTest();
            
            String isSuccess = CSSignoutfromalldevices.CSForceSignout(accList[0].Id);
            System.assertNotEquals('Success', isSuccess);
            
            Test.stopTest();
        }
    }
    
    public class MockDeRegisterDevicesResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(204);
            return res;
        }
    }

}