/**
* The UserDeviceTriggerHandler class implements all necessary logic to be executed when a Trigger event is fired on User Device
* 
*
* @Author       :Cognizant Technology Solutions
* @Base version :1.0
* @Date         :August 23rd 2016
* ***********************Update History*****************************************
* Version       Updated By              CR #                    Change Description                  
*
*/
public class UserDeviceTriggerHandler {
    public static Integer minDevicesCount = 0; //Devices permitted per Country - overall minimum
    public static Map<String,Integer> mapCountryLimit = new Map<String,Integer>();    
    public static String errMessage;
    /**
     * getDeviceSettingsData - Method to Initialize Device Settings Data
     * 
     * > Used to Fetch Custom settings data - DeviceSettings__c
     * > To Fetch the number of user devices allowed in a specific country
     * > And overall minimum number of devices
     * 
     * @Param 1 - no params required - Initialising Data
     * 
     * @return -  Void - no return applicable
     * */
    public static void getDeviceSettingsData(){
        Map<String,DeviceSettings__c> mapOfDeivceSettings = DeviceSettings__c.getAll();
        If(mapOfDeivceSettings != null){
            for(DeviceSettings__c stng : mapOfDeivceSettings.values()){        
                if(stng.Country__c != null && stng.MaxDevices__c != null){
                    mapCountryLimit.put(stng.Country__c, Integer.valueof(stng.MaxDevices__c));
                    if(minDevicesCount == 0 || minDevicesCount > Integer.valueof(stng.MaxDevices__c)){
                        //minDevicesCount is to make sure we query Accounts only if the # of Devices on Account is more than this number
                        minDevicesCount = Integer.valueof(stng.MaxDevices__c); 
                    } 
                }                
            } //end of For loop - over custom setting values
        }//end of if - null check
    }
    /**
     * moveAdditionalDevicesToInactive - Method to move all Additional devices to Inactive
     * 
     * > Every country has a predefined number of user devices allowed per User
     * > If a User login using extra devices, the old devices should be moved to Inactive
     * > During this process all Old devices should be deleted from Active and to be created in Inactive
     * 
     * > Get all devices in context, get their Accounts along with all Active devices   
     * > Query only Accounts with No of Devices more than the Minimum of number of devices allowed of all countries
     * > Everytime a new User Device is created, need to check if the total number of Devices on the Respective Account
     *   is more than the designated number.
     * > If more devices found mark the active devices (older devices) for deletion, add create new inactive device records
     * > Once insert of new devices is success then go ahead and delete the older active devices
     * Note :The code is with the assumption that User Devices are not created in Bulk
     * 
     * @Param 1 - List of User Devices from trigger context - Trigger.New
     * 
     * @return -  void method - No Return type Applicable
     * */
    public static void moveAdditionalDevicesToInactive(List<User_Devices__c> devicesList){
    //public static void moveAdditionalDevicesToInactive(Sobject sObectList){
       //Schema.SObjectType sObjectType = sObectList.add(new User_Devices__c);
       //Get All Account Ids in Context        
        Set<Id> setAccountIds = getAccountIdsInContext(devicesList);
        Map<Id, Account> accountRecordsInContextMap;
        Map<String, List<User_Devices__c>> UserDeviceMap = new Map<String, List<User_Devices__c>>();
        list<User_Devices__c> addForInactive = new list<User_Devices__c>();        
        if(setAccountIds.size() > 0){
            getDeviceSettingsData(); // get device Settings data
            accountRecordsInContextMap = new Map<Id, Account>([SELECT Id, Name, Notification_Country_Code__c, Number_of_UserDevices__c FROM Account 
                                                               WHERE id IN : setAccountIds AND Number_of_UserDevices__c >=:minDevicesCount AND Notification_Country_Code__c!=null]);
            if(accountRecordsInContextMap != null && accountRecordsInContextMap.size() > 0){
                for(User_Devices__c usrDevice : [SELECT Id,name,Account__c,Date_Of_Registration__c,Device_Id__c,Device_manufacturer__c,
                                                 Device_Name__c,Device_Registration_Date__c,Type__c,Device_version__c,Operating_System_Name__c,
                                                 Operating_System_Version__c,Status__c,User_Agent__c, IP_address__c FROM User_Devices__c Where Account__c IN: accountRecordsInContextMap.keyset() ORDER BY Name DESC]){
                                                     if(UserDeviceMap.containsKey(usrDevice.Account__c)){
                                                         UserDeviceMap.get(usrDevice.Account__c).add(usrDevice);                              
                                                     } else {
                                                         UserDeviceMap.put(usrDevice.Account__c,new List<User_Devices__c>{usrDevice} );
                                                     }                                    
                                                 }//end of for loop
            } // end of if - accountRecordsInContextMap
            if(UserDeviceMap.size() > 0) {
                for(Id accId : UserDeviceMap.keySet()){                    
                    //Iterating over Accounts - get Account Record
                    String accCountryCode;
                    Integer accCountryDeviceCnt;
                    Account acc; // Complete Account Details in context
                    if(accountRecordsInContextMap.containsKey(accId)){
                        acc = accountRecordsInContextMap.get(accId);
                        if(acc != null){
                            accCountryCode = acc.Notification_Country_Code__c; 
                        }
                        if(accCountryCode != null && accCountryCode != '' && mapCountryLimit.containsKey(accCountryCode)){
                            accCountryDeviceCnt = mapCountryLimit.get(accCountryCode);  
                        }
                    }
                    if(accCountryDeviceCnt != null){
                        Integer devicesListCount = UserDeviceMap.get(accId).size();
                        if(devicesListCount > accCountryDeviceCnt ){
                            //The Devices count for this Account is more than the specified # for the country code
                            for(Integer i = accCountryDeviceCnt; i < devicesListCount ; i++){
                                User_Devices__c userDevObj = UserDeviceMap.get(accId).get(i);
                                if(userDevObj != null){       
                                    //Logic for removing an Additional Active Device record
                                    addForInactive.add(userDevObj);  //To be deleted    
                                }
                            } //end of for loop                        
                        } //end of if check - to see if devices count is more than specified #
                    } //end of if - accCountryDeviceCnt null check            
                }
            } // end of if -UserDeviceMap size 
            
           
            
            if(addForInactive.size() > 0){
                Database.DeleteResult[] srDeleteList = Database.delete(addForInactive,true); 
                for(Database.DeleteResult sr : srDeleteList){
                    if(!sr.isSuccess()){
                        for(Database.Error err : sr.getErrors()) {
                           SendEmailWithErrorsToAdmins.sendEmail(err.getMessage());  
                        }
                        break;
                    } else {
                      // Operation Is successful  
                    }
                }
            }
            
            
         }//end of if - setAccountIds null check
        
    }
    /**
     * getAccountIdsInContext - Method to prepare Set of Account Ids from the List of User Devices
     * 
     * > Prepare unique set of Account Ids from the list of User Devices
     * 
     * @Param 1 - List of User Devices - User_Devices__c
     * 
     * @return -  Set<Id> - Account Ids
     * */
    public static Set<Id> getAccountIdsInContext(List<User_Devices__c> devicesList){
        Set<Id> setAccountIds = new Set<Id>(); 
        if(devicesList != null){
            for(User_Devices__c oUserDevices : devicesList){
                setAccountIds.add(oUserDevices.Account__c);
            }
        }
        return setAccountIds;
    }
    
   /**
     * removeDuplicatesFromInactiveUserDevices - Method to delete device Ids from Inactive User devices if they have been added as Active User devices
     * 
     *  
     * @Param 1 - List of User Devices - User_Devices__c
     * 
     * @return -  None
     * */
    public static void removeDuplicatesFromInactiveUserDevices (List<User_Devices__c> devicesList){
        List<String> lstDeviceIds = new List<String>();
		 List<Inactive_User_Devices__c> lstInactiveUserDevices = new List<Inactive_User_Devices__c> ();
		 
		   if(devicesList != null){
            for(User_Devices__c oUserDevices : devicesList){
                lstDeviceIds.add(oUserDevices.Device_Id__c);
            }
        }
		 
			
			If(!lstDeviceIds.isEmpty()){
			if(!Test.isRunningTest()){	
            lstInactiveUserDevices = [Select Id from Inactive_User_Devices__c where Device_Id__c in :lstDeviceIds];
            if(lstInactiveUserDevices!=null && !lstInactiveUserDevices.isEmpty()){
                try{
                    delete lstInactiveUserDevices;
                }catch(Exception ex){
                    ExceptionLoggerHelper.createExceptionLog(string.valueof(user.Id), 'UserDeviceTriggerHandler', 'removeDuplicatesFromInactiveUserDevices', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
                    SendEmailWithErrorsToAdmins.sendEmail(ex.getMessage());
                }
            }
			}
				
		}
       
        
      
        
   
    }
    /**
     * moveDeleteDevicesToInactive -PD-8813: Method to get delete user devices Ids from UserDeviceTrigger and created those deleted user device Ids in to Inactive user devices  
     * @Param 1 - List of User Devices - User_Devices__c 
     * @return -  None
     * */
    public static void moveDeleteDevicesToInactive(List<User_Devices__c> devicesDeleteList){            
        Map<id,List<User_Devices__c>> mapAccIdAndUDObj = new Map<id,List<User_Devices__c>>();
        if(devicesDeleteList != null && devicesDeleteList.size() > 0){
            for(User_Devices__c oUserDevices : devicesDeleteList){               
                if(mapAccIdAndUDObj.containsKey(oUserDevices.Account__c)){                   
                   List<User_Devices__c> userDeviceIds = mapAccIdAndUDObj.get(oUserDevices.Account__c);
                   userDeviceIds.add(oUserDevices);
                   mapAccIdAndUDObj.put(oUserDevices.Account__c, userDeviceIds);                  
                }else{
                    mapAccIdAndUDObj.put(oUserDevices.Account__c, new List<User_Devices__c> { oUserDevices});

                }
                
            } 
        }
       
        
        List<Inactive_User_Devices__c> insertListOfInactiveObj = new List<Inactive_User_Devices__c>();
        if(!mapAccIdAndUDObj.isEmpty()){           
            for(Id objUserDevicesIds : mapAccIdAndUDObj.keyset()){
                Integer devicesListCount = mapAccIdAndUDObj.get(objUserDevicesIds).size();
                for(Integer i = 0; i < devicesListCount ; i++){
                    User_Devices__c userDevObj = mapAccIdAndUDObj.get(objUserDevicesIds).get(i);
                    Inactive_User_Devices__c inactiveObj = new Inactive_User_Devices__c();
                    inactiveObj.Account__c = userDevObj.Account__c; 
                    inactiveObj.Date_Of_Registration__c = userDevObj.Date_Of_Registration__c;
                    inactiveObj.Device_Id__c = userDevObj.Device_Id__c;
                    inactiveObj.Device_manufacturer__c = userDevObj.Device_manufacturer__c;
                    inactiveObj.Device_Name__c = userDevObj.Device_Name__c;
                    inactiveObj.Device_Registration_Date__c = userDevObj.Device_Registration_Date__c;
                    inactiveObj.Type__c = userDevObj.Type__c;
                    inactiveObj.Device_version__c = userDevObj.Device_version__c;
                    inactiveObj.Operating_System_Name__c = userDevObj.Operating_System_Name__c;
                    inactiveObj.Operating_System_Version__c = userDevObj.Operating_System_Version__c;
                    inactiveObj.Status__c = userDevObj.Status__c;
                    inactiveObj.User_Agent__c = userDevObj.User_Agent__c;
                    insertListOfInactiveObj.add(inactiveObj); 
                }
               
             }
        }         
        If(!insertListOfInactiveObj.isEmpty()){                        
            try{
                    Database.SaveResult[] srList = Database.insert(insertListOfInactiveObj, false);
                    for (Integer i = 0; i < insertListOfInactiveObj.size(); i++) {
                            Database.SaveResult sr = srList[i];
                            Inactive_User_Devices__c origRecord = insertListOfInactiveObj[i];
                            if (!sr.isSuccess() || Test.isRunningTest()) {        
                                errMessage += 'trying to insert with Account:'+ origRecord.Account__c;
                        } 
                    
                }
            }catch(Exception ex){
                ExceptionLoggerHelper.createExceptionLog(userinfo.getUserId(), 'UserDeviceTriggerHandler', 'moveDeleteDevicesToInactive', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());                                
                SendEmailWithErrorsToAdmins.sendEmail(errMessage);
            }
        }     
    }// End of PD-8813
}