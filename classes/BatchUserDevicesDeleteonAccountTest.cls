@IsTest
public class BatchUserDevicesDeleteonAccountTest {
    static testMethod void test() {
        SetUpTestData.triggerSettings();
        //Database.BatchableContext BC=new Database.BatchableContext();
        DeviceSettings__c setting = new DeviceSettings__c();
        setting.Name = 'Japan';
        setting.Country__c = 'JP';
        setting.MaxDevices__c = 4;
        insert setting;
        System.assertEquals('Japan', setting.Name);
        list<User_Devices__c> listuserdevices = new list<User_Devices__c>();
        //Insert account
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm1testemail@email.com','Free Trial');        
        //SetUpTestData.createCommunityUser(oAccount.Id, 'pm1testemail@email.com', 'pm1testemail@email.com', 'tstals1','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        /*Account oAccount=new Account();
oAccount.Name='NameDemo';
oAccount.Notification_Country_Code__c='JP';
insert oAccount;*/
        oAccount.Notification_Country_Code__c = 'JP';
        update oAccount;
        
        //inserting devices related to account
        User_Devices__c device1=new User_Devices__c();
        device1.Account__c=oAccount.Id;
        device1.Date_Of_Registration__c=System.today();
        device1.Device_Id__c='DESK001';
        device1.Device_manufacturer__c='';
        device1.Device_Name__c='Desktop1';
        device1.Device_Registration_Date__c=System.today();
        device1.Type__c='Desktop';
        device1.Device_version__c='';
        device1.IP_address__c ='1638399';
        device1.Operating_System_Name__c='';
        device1.Operating_System_Version__c='';
        device1.Status__c='Active';
        device1.User_Agent__c='';
        listuserdevices.add(device1);
        
        User_Devices__c device2=new User_Devices__c();
        device2.Account__c=oAccount.Id;
        device2.Date_Of_Registration__c=System.today();
        device2.Device_Id__c='DESK001';
        device2.Device_manufacturer__c='';
        device2.Device_Name__c='Desktop1';
        device2.Device_Registration_Date__c=System.today();
        device2.Type__c='Desktop';
        device2.Device_version__c='';
        device2.IP_address__c ='1638399';
        device2.Operating_System_Name__c='';
        device2.Operating_System_Version__c='';
        device2.Status__c='Active';
        device2.User_Agent__c='';
        listuserdevices.add(device2);
        
        User_Devices__c device3=new User_Devices__c();
        device3.Account__c=oAccount.Id;
        device3.Date_Of_Registration__c=System.today();
        device3.Device_Id__c='DESK001';
        device3.Device_manufacturer__c='';
        device3.Device_Name__c='Desktop1';
        device3.Device_Registration_Date__c=System.today();
        device3.Type__c='Desktop';
        device3.Device_version__c='';
        device3.IP_address__c ='1638399';
        device3.Operating_System_Name__c='';
        device3.Operating_System_Version__c='';
        device3.Status__c='Active';
        device3.User_Agent__c='';
        listuserdevices.add(device3);
        
        User_Devices__c device4=new User_Devices__c();
        device4.Account__c=oAccount.Id;
        device4.Date_Of_Registration__c=System.today();
        device4.Device_Id__c='DESK001';
        device4.Device_manufacturer__c='';
        device4.Device_Name__c='Desktop1';
        device4.Device_Registration_Date__c=System.today();
        device4.Type__c='Desktop';
        device4.Device_version__c='';
        device4.IP_address__c ='1638399';
        device4.Operating_System_Name__c='';
        device4.Operating_System_Version__c='';
        device4.Status__c='Active';
        device4.User_Agent__c='';
        listuserdevices.add(device4);
        
        User_Devices__c device5=new User_Devices__c();
        device5.Account__c=oAccount.Id;
        device5.Date_Of_Registration__c=System.today();
        device5.Device_Id__c='DESK001';
        device5.Device_manufacturer__c='';
        device5.Device_Name__c='Desktop1';
        device5.Device_Registration_Date__c=System.today();
        device5.Type__c='Desktop';
        device5.Device_version__c='';
        device5.IP_address__c ='1638399';
        device5.Operating_System_Name__c='';
        device5.Operating_System_Version__c='';
        device5.Status__c='Active';
        device5.User_Agent__c='';
        listuserdevices.add(device5);
        
        list<Account> listOfAccounts=new list<Account>();
        listOfAccounts.add(oAccount);
        if(listuserdevices!= null && listuserdevices.size()>0){
            insert listuserdevices;
        }
        
        
        BatchUserDevicesDeleteonAccount c = new BatchUserDevicesDeleteonAccount();
        Database.executeBatch(c);
        //c.execute(BC, listOfAccounts); 
        
    }
}