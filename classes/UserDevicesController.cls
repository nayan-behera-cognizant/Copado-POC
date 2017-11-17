public with sharing class UserDevicesController {
    
    public List<User_Devices__c> lstUserDevices {get;set;}
    
    public UserDevicesController() {
        lstUserDevices= new List<User_Devices__c>();
        
        lstUserDevices= [SELECT name,
                          Account__c,
                          Date_Of_Registration__c,
                          Type__c,
                          Status__c
                       FROM User_Devices__c LIMIT 5];
    }

}