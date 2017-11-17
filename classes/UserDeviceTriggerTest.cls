@IsTest
public class UserDeviceTriggerTest {
    @testSetup
    public static void createDeviceSettingsData(){              
        DeviceSettings__c setting = new DeviceSettings__c();
        setting.Name = 'Germany';
        setting.Country__c = 'DE';
        setting.MaxDevices__c = 4;        
        insert setting;
        System.assertNotEquals(setting.Id, Null);
        System.assertEquals(setting.Name, 'Germany');
        System.assertEquals(setting.MaxDevices__c, 4);
    }
    
    public static testMethod void UserDeviceTriggerTestMethod1() { 
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts(); //Create Accounts and User for Unit Test  
        //Retreieve  account Data
        List<Account> oAccountList = new List<Account>();      
        oAccountList = [Select Id, Name from Account where Account_Status__c = 'Active Paid' Limit 1];
        if(oAccountList.size() > 0 && oAccountList[0].id != null ){
            
            List<User_Devices__c> listOfDevices = new List<User_Devices__c>();
            for(Integer i = 0;i < 4;i++){
                //Adding devices related to account
                User_Devices__c device1 = new User_Devices__c(); 
                device1.Account__c = oAccountList[0].Id;
                device1.Date_Of_Registration__c=System.today();
                device1.Device_Id__c='DESK001'+i;
                device1.Device_manufacturer__c='';
                device1.Device_Name__c='Desktop1'+i;
                device1.Device_Registration_Date__c=System.today();
                device1.Type__c='Desktop';
                device1.Device_version__c='';
                device1.Operating_System_Name__c='';
                device1.Operating_System_Version__c='';
                device1.Status__c='Active';
                device1.User_Agent__c='';
                listOfDevices.add(device1);
            }
            Test.startTest();
            if(listOfDevices.size() > 0){
                Insert listOfDevices;
                System.assertNotEquals(listOfDevices[0].Id, Null);
            }
            Test.stopTest();
            //Now Add Additional device
            User_Devices__c device5 = new User_Devices__c();
            device5.Account__c=oAccountList[0].Id;
            device5.Date_Of_Registration__c=System.today();
            device5.Device_Id__c='DESK001';
            device5.Device_manufacturer__c='';
            device5.Device_Name__c='Desktop1';
            device5.Device_Registration_Date__c=System.today();
            device5.Type__c='Desktop';
            device5.Device_version__c='';
            device5.Operating_System_Name__c='';
            device5.Operating_System_Version__c='';
            device5.Status__c='Active';
            device5.User_Agent__c='';
            insert device5;   
            System.assertNotEquals(device5.ID, Null);
        }    
    }
    
    public static testMethod void testDuplicateDeviceIdForUserDevice() { 
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts(); //Create Accounts and User for Unit Test  
        //Retreieve  account Data
        List<Account> oAccountList = new List<Account>();      
        oAccountList = [Select Id, Name from Account where Account_Status__c = 'Active Paid' Limit 1];
        if(oAccountList.size() > 0 && oAccountList[0].id != null ){
            
            List<User_Devices__c> listOfDevices = new List<User_Devices__c>();
            for(Integer i = 0;i < 4;i++){
                //Adding devices related to account
                User_Devices__c device1 = new User_Devices__c(); 
                device1.Account__c = oAccountList[0].Id;
                device1.Date_Of_Registration__c=System.today();
                device1.Device_Id__c='DESK001'+i;
                device1.Device_manufacturer__c='';
                device1.Device_Name__c='Desktop1'+i;
                device1.Device_Registration_Date__c=System.today();
                device1.Type__c='Desktop';
                device1.Device_version__c='';
                device1.Operating_System_Name__c='';
                device1.Operating_System_Version__c='';
                device1.Status__c='Active';
                device1.User_Agent__c='';
                listOfDevices.add(device1);
            }
             Insert listOfDevices;
            Inactive_User_Devices__c objInactiveUD = new Inactive_User_Devices__c(Account__c = oAccountList[0].Id, Date_Of_Registration__c=System.today(), 
                    Device_Id__c='DESK0011', Device_manufacturer__c='', Device_Name__c='Desktop1', Device_Registration_Date__c=System.today(), 
                    Type__c='Desktop', Device_version__c='', Operating_System_Name__c='', Operating_System_Version__c='', Status__c='Active', User_Agent__c='');
                    Insert objInactiveUD;                                    
            Test.startTest();
            if(listOfDevices.size() > 0){                
               
                System.assertNotEquals(listOfDevices[0].Id, Null);
                objInactiveUD = [Select Id from Inactive_User_Devices__c where Id = :objInactiveUD.Id];
                System.assertNotEquals(objInactiveUD.Id, Null);
            }
            Test.stopTest();
            //Now Add Additional device
            User_Devices__c device5 = new User_Devices__c();
            device5.Account__c=oAccountList[0].Id;
            device5.Date_Of_Registration__c=System.today();
            device5.Device_Id__c='DESK001';
            device5.Device_manufacturer__c='';
            device5.Device_Name__c='Desktop1';
            device5.Device_Registration_Date__c=System.today();
            device5.Type__c='Desktop';
            device5.Device_version__c='';
            device5.Operating_System_Name__c='';
            device5.Operating_System_Version__c='';
            device5.Status__c='Active';
            device5.User_Agent__c='';
            insert device5;   
            
            System.assertNotEquals(device5.ID, Null);
        }    
    }
}