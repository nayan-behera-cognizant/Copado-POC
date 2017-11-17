/**
* The emailDobOptinTrigger Trigger 
* > There is a call to EmailQueOptinController- to handle the  account Ids and make Double Optin True
* @Author       :Cognizant Technology Solutions
* @Base version :1.0
* @Date         :MAR 10 2017
* ***********************Update History*****************************************
*/

trigger emailDobOptinTrigger on Email_Queue__c (after insert) {
	set<ID> setofEmail = new set <ID>();
    For (Email_Queue__c EmQObj : Trigger.new){
           setofEmail.add(EmQObj.AccountName__c);    
    }
    if(setofEmail.size()>0)  {
        EmailQueOptinController.accDouOPtinCheck(setofEmail);
    }

}