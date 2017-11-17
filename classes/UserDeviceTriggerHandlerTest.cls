/**
* @author Cognizant Technology Solutuions
* @date 14/04/2016
* @description Test class to cover user device trigger and handler functionality
*/
/*Added Assert statements as per PD-7938*/
@isTest
public class UserDeviceTriggerHandlerTest{
    public static testMethod void testInactivedevices(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts(); //Create Accounts and User for Unit Test                
        DeviceSettings__c setting = new DeviceSettings__c();
        setting.Name = 'Germany';
        setting.Country__c = 'DE';
        setting.MaxDevices__c = 4;        
        insert setting;
        System.assertNotEquals(null, setting.id);
        List<Account> oAccountList = new List<Account>();      
        oAccountList = [Select Id, Name from Account where Account_Status__c = 'Active Paid' Limit 1];
        if(oAccountList.size() > 0 && oAccountList[0].id != null ){
            
            List<User_Devices__c> listOfDevices = new List<User_Devices__c>();
            for(Integer i = 0;i < 5;i++){
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
            UserDeviceTriggerHandler.moveAdditionalDevicesToInactive(listOfDevices);
            Test.stopTest();
        }
    }
  // method when trigger is disabled
    
    public static testMethod void testDevices(){
        CreateTestDataforUnitTest.triggerSettings();
        TriggerSetting__c triggset= TriggerSetting__c.getInstance('UserDeviceTrigger');
        triggset.Disable__c=true;
        Update triggset;
        CreateTestDataforUnitTest.createTestAccounts();
        DeviceSettings__c setting = new DeviceSettings__c();
        setting.Name = 'Germany';
        setting.Country__c = 'DE';
        setting.MaxDevices__c = 4;           
        insert setting;
        System.assertNotEquals(null, setting.id);
        List<Account> oAccountList = new List<Account>();      
        oAccountList = [Select Id, Name from Account where Account_Status__c = 'Active Paid' Limit 1];
        if(oAccountList.size() > 0 && oAccountList[0].id != null ){
            
            List<User_Devices__c> listOfDevices = new List<User_Devices__c>();
            for(Integer i = 0;i < 5;i++){
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
        }
    }
    
    public static testMethod void testDeleteDevices(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts(); //Create Accounts and User for Unit Test                
        DeviceSettings__c setting = new DeviceSettings__c();
        setting.Name = 'Germany';
        setting.Country__c = 'DE';
        setting.MaxDevices__c = 4;        
        insert setting;
        System.assertNotEquals(null, setting.id);
        List<Account> oAccountList = new List<Account>();      
        oAccountList = [Select Id, Name from Account where Account_Status__c = 'Active Paid' Limit 1];
        if(oAccountList.size() > 0 && oAccountList[0].id != null ){
            
            List<User_Devices__c> listOfDevices = new List<User_Devices__c>();
            List<User_Devices__c> testListOfDevices = new List<User_Devices__c>();
            List<User_Devices__c> testListOfDevices1;
            for(Integer i = 0;i < 5;i++){
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
            
            for(User_Devices__c usrDevices: listOfDevices){
               usrDevices.Date_Of_Registration__c= system.today();
                usrDevices.Device_Id__c='';
                usrDevices.Device_manufacturer__c='';
                usrDevices.Device_Name__c='';
                usrDevices.Device_Registration_Date__c= null;
                usrDevices.Type__c='';
                usrDevices.Device_version__c='';
                usrDevices.Operating_System_Name__c='';
                usrDevices.Operating_System_Version__c='';
                usrDevices.Status__c='';
                usrDevices.User_Agent__c='';
               testListOfDevices.add(usrDevices);
            }
            UserDeviceTriggerHandler.moveDeleteDevicesToInactive(testListOfDevices);
            UserDeviceTriggerHandler.removeDuplicatesFromInactiveUserDevices(testListOfDevices);
            Test.stopTest();
        }
    }
    
}