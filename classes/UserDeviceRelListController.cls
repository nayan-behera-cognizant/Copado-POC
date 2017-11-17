public class UserDeviceRelListController {
 
    public String currentAccountId { get; set; }
    public String errorMessage { get; set; }
    public List<UserDeviceWrapper> userDevices { get; set; }
    
    public UserDeviceRelListController(ApexPages.StandardController controller) {
        currentAccountId = controller.getRecord().id;
        List<Account> accounts = [SELECT Id, DAZN_Id__c, Notification_Country_Code__c FROM Account WHERE Id = :currentAccountId];
        if (!accounts.isEmpty()) {
            currentAccountId = String.isNotBlank(accounts[0].DAZN_Id__c) ? accounts[0].DAZN_Id__c : currentAccountId;
            userDevices = new List<UserDeviceWrapper>();
            Map<String, String> calloutResult = MISLCalloutHelper.getUserDevices(currentAccountId, accounts[0].Notification_Country_Code__c);
            if (!calloutResult.isEmpty()) {
                Boolean isResultSuccess = Boolean.valueOf(calloutResult.get('success'));
                if (isResultSuccess) {
                    MISLCalloutHelper.GetUserDevicesSuccessResponse getUserDevicesSuccessResponse = (MISLCalloutHelper.GetUserDevicesSuccessResponse)JSON.deserialize(calloutResult.get('message'), MISLCalloutHelper.GetUserDevicesSuccessResponse.class);
                    for (MISLCalloutHelper.MISLDevices device : getUserDevicesSuccessResponse.Devices) {
                        userDevices.add(new UserDeviceWrapper(device.Id, device.Type, device.RegistrationDate, true));
                    }
                } else {
                    if (calloutResult.get('message') == 'GetUserDevices is disabled') {
                        List<User_Devices__c> lstAllUserDevices = [
                            SELECT Id, Device_Id__c, Name, Account__c, Date_Of_Registration__c, Type__c, Status__c
                            FROM User_Devices__c
                            WHERE Account__c =: currentAccountId
                                AND Status__c = 'Active' ORDER BY CreatedDate LIMIT 100
                        ];
                        for (User_Devices__c device : lstAllUserDevices) {
                            userDevices.add(new UserDeviceWrapper(device.Device_Id__c, device.Type__c, CommunityHelper.ConvertDateToString(device.Date_Of_Registration__c), false));
                        }
                    } else if (userDevices.isEmpty()) {
                        errorMessage = calloutResult.get('message');
                        errorMessage = (errorMessage != '404 - No devices were found for account.') ? errorMessage : null;
                    }
                }
            }
        }
    }
    
    public class UserDeviceWrapper {
        public String deviceId { get;set; }
        public String deviceType { get;set; }
        public String registrationDate { get;set; }
        
        public UserDeviceWrapper (String deviceId, String deviceType, String registrationDate, Boolean isFromMISL) {
          this.deviceId = deviceId;
          this.deviceType = deviceType;
          if (isFromMISL) {
              this.registrationDate = (String.isNotBlank(registrationDate)) ? DateTime.valueOf(registrationDate.replace('T',' ')).format('yyyy-MM-dd') : registrationDate;
          } else {
              this.registrationDate = registrationDate;
          }
        }
    }

}