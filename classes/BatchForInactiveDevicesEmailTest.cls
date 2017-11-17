/**
* The BatchForInactiveDevicesEmailTest class implements improve the test coverage for BatchForInactiveDevicesEmail
* 
*
* @Author  		:Cognizant Technology Solutions
* @Base version :1.0
* @Date   		:August 23rd 2016
* ***********************Update History*****************************************
* Version		Updated By				CR #					Change Description					
*
*/
@IsTest
public class BatchForInactiveDevicesEmailTest {
    
    static testMethod void test() { 
        CreateTestDataforUnitTest.triggerSettings();
		CreateTestDataforUnitTest.createTestAccounts();
        //Insert EmailNotification__c custom settings
        EmailNotification__c emailCustomSettings = new EmailNotification__c();
        //Insert account
        Account oAccount =  [select id,Notification_Language_Code__c,PersonEmail,FirstName from Account where Account_Status__c = 'Active Paid' Limit 1];       
        oAccount.Notification_Language_Code__c = 'de'; 
        emailCustomSettings.Name = oAccount.FirstName;
        emailCustomSettings.Email__c = oAccount.PersonEmail;
        insert emailCustomSettings;
        System.assertNotEquals(emailCustomSettings.id, Null);
        if(oAccount!=null){
            update oAccount;
            System.assertNotEquals(oAccount.Id, Null);
        }                        
        //inserting devices related to account
        List<Inactive_User_Devices__c> listInactive = new List<Inactive_User_Devices__c>();
        Inactive_User_Devices__c device1=new Inactive_User_Devices__c();
        device1.Account__c=oAccount.Id;
        device1.Date_Of_Registration__c=System.today();
        device1.Device_Id__c='DESK001';
        device1.Device_manufacturer__c='';
        device1.Device_Name__c='Desktop1';
        device1.Device_Registration_Date__c=System.today();
        device1.Type__c='Desktop';
        device1.Device_version__c='';
        device1.Operating_System_Name__c='';
        device1.Operating_System_Version__c='';
        device1.Status__c='Active';
        device1.User_Agent__c='';
        listInactive.add(device1);
        
        Inactive_User_Devices__c device2=new Inactive_User_Devices__c();
        device2.Account__c=oAccount.Id;
        device2.Date_Of_Registration__c=System.today();
        device2.Device_Id__c='DESK001';
        device2.Device_manufacturer__c='';
        device2.Device_Name__c='Desktop1';
        device2.Device_Registration_Date__c=System.today();
        device2.Type__c='Desktop';
        device2.Device_version__c='';
        device2.Operating_System_Name__c='';
        device2.Operating_System_Version__c='';
        device2.Status__c='Active';
        device2.User_Agent__c='';
        listInactive.add(device2);
        if(listInactive!=null && listInactive.size()>0){
            insert listInactive;
            System.assertNotEquals(listInactive[0].Id, Null);
        }                        
        CommunicatorIntegrationHelperTest.setData();
        BatchForInactiveDevicesEmail bd = new BatchForInactiveDevicesEmail();
        Database.executeBatch(bd);
    }
    
}