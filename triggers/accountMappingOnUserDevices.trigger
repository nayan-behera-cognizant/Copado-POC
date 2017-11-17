/**
* The DAZN_UserDevice_Feed Trigger 
* > There is a call to DAZNUserDeviceFeedTriggerHandler- to handle the Creation of Additional User Device on Account based on DAZN_User_Device_Feed__c 
*
* @Author       :Cognizant Technology Solutions
* @Base version :1.0
* @Date         :DEC 09 2016
* ***********************Update History*****************************************
*/
trigger accountMappingOnUserDevices on DAZN_User_Device_Feed__c (after insert) {
    set<ID> setOFUSerfeedIDs = new set<ID>();
    for(DAZN_User_Device_Feed__c DaznUserFeedDevObj : trigger.new){
            if(DaznUserFeedDevObj.DAZN_User_feed__c != null  ){    
                setOFUSerfeedIDs.add(DaznUserFeedDevObj.DAZN_User_feed__c);  
                }
        }
    if(setOFUSerfeedIDs.size()>0){    
        DAZNUserDeviceFeedTriggerHandler.daznUserFeedDeviceCreationOnAccount(setOFUSerfeedIDs);
        }
}