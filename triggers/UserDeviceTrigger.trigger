/**
* The UserDeviceTrigger Trigger 
* > There is a call to UserDeviceTriggerHandler - to handle the Creation of Additional User Device
*
* @Author       :Cognizant Technology Solutions
* @Base version :1.0
* @Date         :August 23rd 2016
* ***********************Update History*****************************************
* Version       Updated By              CR #                    Change Description                  
*
*/
trigger UserDeviceTrigger on User_Devices__c (after insert, after delete) { 
     
     //***********Changes as per PD-7866************
     if(TriggerSetting__c.getInstance('UserDeviceTrigger').Disable__c){
        return;
     } 
    //***********Changes End***********************

    If(Trigger.isAfter){
        //All After events to go in here
        If(Trigger.isInsert){
           //All After and Insert events to go in here
           UserDeviceTriggerHandler.moveAdditionalDevicesToInactive(Trigger.New);  
           UserDeviceTriggerHandler.removeDuplicatesFromInactiveUserDevices (Trigger.New);
        } 
        //PD-8813 deleted user devices to inactive user devices
        If(Trigger.isDelete){            
            UserDeviceTriggerHandler.moveDeleteDevicesToInactive(Trigger.old);  
        } 
    }       
}