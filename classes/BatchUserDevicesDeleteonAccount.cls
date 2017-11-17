global class BatchUserDevicesDeleteonAccount implements Database.Batchable<sObject>,Database.stateful,Database.AllowsCallouts {
    public map<string,integer> mapCountryLimit;        
    public list<id> listInactiveDeviceIds ;
    public list<Id> listAccountIds;                
    global BatchUserDevicesDeleteonAccount(){
        listInactiveDeviceIds = new list<id>();
        listAccountIds = new list<Id>();   
        mapCountryLimit = new map<string,integer>();
        list<DeviceSettings__c> lstDS = [select Id,Name,Country__c,MaxDevices__c from DeviceSettings__c];
        for(DeviceSettings__c objDS:lstDS){
            mapCountryLimit.put(objDS.Country__c,Integer.valueof(objDS.MaxDevices__c));
        }
        
    }   
   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('select Id,Name,Notification_Country_Code__c,(Select Id,name,Account__c,Date_Of_Registration__c,Device_Id__c,Device_manufacturer__c,Device_Name__c,Device_Registration_Date__c,Type__c,Device_version__c,Operating_System_Name__c,Operating_System_Version__c,Status__c,User_Agent__c from User_Devices__r ORDER BY Name DESC) from Account');
   }

   global void execute(Database.BatchableContext BC, List<Account> accounts){
       List<User_Devices__c> lstUserDevices = new list<User_Devices__c>();       
       list<Inactive_User_Devices__c> lstIUD = new list<Inactive_User_Devices__c>(); // variable declaration to insert list of inactive user devices
       
            for(Account acc:accounts){
          
           
           
           if(acc.Notification_Country_Code__c != null && mapCountryLimit != null && mapCountryLimit.get(acc.Notification_Country_Code__c) != null && mapCountryLimit.get(acc.Notification_Country_Code__c) > 0  ){
               if(mapCountryLimit.get(acc.Notification_Country_Code__c) < acc.User_Devices__r.size()){                     
                   integer size = mapCountryLimit.get(acc.Notification_Country_Code__c) ;
                   
                   for(integer i= size; i< acc.User_Devices__r.size();i++ ){
                       lstUserDevices.add(acc.User_Devices__r[i]);                      
                   }                   
                   listAccountIds.add(acc.id);
               }
           }   
       }
      
       
       // looping extra devices here and preparing inactive users data to insert into inactive user devices       
       if(!lstUserDevices.isEmpty()){
           for(User_Devices__c objUD:lstUserDevices){
               Inactive_User_Devices__c objIUD = new Inactive_User_Devices__c();
               //objIUD.name = objUD.Name;
               objIUD.Account__c = objUD.Account__c;
               
               objIUD.Date_Of_Registration__c = objUD.Date_Of_Registration__c;
               objIUD.Device_Id__c = objUD.Device_Id__c;
               objIUD.Device_manufacturer__c = objUD.Device_manufacturer__c;
               objIUD.Device_Name__c = objUD.Device_Name__c;
               objIUD.Device_Registration_Date__c = objUD.Device_Registration_Date__c;
               objIUD.Type__c = objUD.Type__c;
               objIUD.Device_version__c = objUD.Device_version__c;
               objIUD.Operating_System_Name__c = objUD.Operating_System_Name__c;
               objIUD.Operating_System_Version__c = objUD.Operating_System_Version__c;
               objIUD.Status__c = objUD.Status__c;
               objIUD.User_Agent__c = objUD.User_Agent__c;
               lstIUD.add(objIUD);               
           }
       }
       
       
       // Inserting inactive user devices 
       if(!lstIUD.isEmpty()){
           
           insert lstIUD;
       }
       /*for(Inactive_User_Devices__c ind : lstIUD){
           listInactiveDeviceIds.add(ind.id);
       }  */ 
      
       // After inserting active devices into inactive user devices deleting extra devices for each country
       if(!lstUserDevices.isEmpty()){
            
           delete lstUserDevices;
       }   
         
       EmailHelper.sendInactiveDevicesNotification(listAccountIds);
       
   }

   global void finish(Database.BatchableContext BC){                 
   }

}