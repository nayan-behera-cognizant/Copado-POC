/*
    This Class is used to Delete the Devices of the Particular Account based on the ExternalId and DeviceId.If Device Type is Desktop,
    it also deletes the AuthSession Ids(User need to be logout from Desktop and other Devices we just delete them) 
*/
@RestResource(urlMapping='/signOutSingleDevices/*')
global with sharing class signOutSingleDevicesController {

/*
  This method is used to delete the Devices and giving the Responses based on the External Id and Device Id.
*/
    @HttpPost
    global static Response signOutSingleDevicesPost(String strExternalID, String DeviceId) {
        Response oResponse = null;
        try {
            oResponse = new Response();
            List<User_Devices__c> lstUserDevices = new List<User_Devices__c>();
            List<User> lstUser = new List<User>();
            if (!String.isBlank(strExternalID)) {
                lstUser= [SELECT Id, AccountId, Email, ExternalID__c, ViewerId__c FROM User WHERE (ExternalID__c =: strExternalID) OR (ViewerId__c =: strExternalID)];
            }
            // Get user information using external id.
            if (lstUser == null || lstUser.isEmpty()) {
                 oResponse.ExtId = System.Label.LS_Logout_Not_Valid_ExternalId;
                 oResponse.strStatus =System.label.LS_SignOutAll_Fail_Msg;
                 oResponse.StatusCode = System.label.LS_SignOutAll_Fail_Code;
            } else {
                // Get User Devices using device ID and Nulll
                if (DeviceId == null || DeviceId =='') {
                    lstUserDevices = [SELECT id, Account__c, Status__c, Type__c, Device_Id__c FROM User_Devices__c WHERE Status__c = 'Active' AND Account__c =: lstUser[0].AccountId];
                } else {
                    lstUserDevices = [SELECT id, Account__c, Status__c, Type__c, Device_Id__c FROM User_Devices__c WHERE Status__c = 'Active' AND Account__c =: lstUser[0].AccountId AND Device_Id__c =: DeviceId];
                }
                if (lstUserDevices == null || lstUserDevices.isEmpty()) {
                     oResponse.DeviceId = System.Label.LS_Logout_Not_Valid_DeviceId;
                     oResponse.strStatus = System.label.LS_SignOutAll_Fail_Msg;
                     oResponse.StatusCode = System.label.LS_SignOutAll_Fail_Code;
                } else {
                    MyAccountController.signOutOfSingleDevicesUpdated(lstUserDevices, lstUser, DeviceId);
                    oResponse.strStatus = System.label.LS_SignOutAll_SUCCESS;
                    oResponse.StatusCode = System.label.LS_SignOutAll_SUCCESS_Code;
                }
            }
        } catch (Exception ex) {
            updateFailedResponse(oResponse, ex.getMessage(), ex.getLineNumber());
        }
        return oResponse;
    }
    
    @TestVisible
    private static void updateFailedResponse(Response oResponse, String errorMessage, Integer errorLineNumber) {
        oResponse.strStatus = 'Failure==>' + errorMessage + '=LineNumber=>' + errorLineNumber;
        oResponse.StatusCode = System.label.LS_SignOutAll_Fail_Code;
    }
    
    /*
        This child class is used to give the Success and Failure Responses.If StatusCode equals to 200 ,then it is Success,If 
        StatusCode equals to 500,then it is Failure.
    */
    global class Response {
        global String strStatus;
        global String ExtId;
        global String DeviceId;
        global String StatusCode;
    }
    
}