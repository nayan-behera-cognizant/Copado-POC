/**
* @author Cognizant Technology Solutuions
* @date 06/11/2015
* @description Exception Logger Utility
*/
public class ExceptionLoggerHelper{
    
    /*
Description: Method log exception in Exception log object.
*/
    public static void createExceptionLog(String sRunninguserId, String sClassName, String sMethodName, String sExMsg, String sTypeName, String sStackTrace)
    {
        //Checking the user has a access to the fields below before inserting in exceptionlog custom object(PD-7903)
        if(schema.SObjectType.Exception_Log__c.fields.Class_Name__c.isAccessible() && 
           schema.SObjectType.Exception_Log__c.fields.Exception_Type__c.isAccessible() && 
           schema.SObjectType.Exception_Log__c.fields.Method_Name__c.isAccessible() && 
           schema.SObjectType.Exception_Log__c.fields.StackTrace_Message__c.isAccessible()&& 
           schema.SObjectType.Exception_Log__c.fields.Exception_Message__c.isAccessible()){
               //checking the Exception Message length if it is greater than 255 truncating to 255 characters part of PD-9722
               	
               if(sExMsg.length() > 255){
                   sExMsg=sExMsg.substring(0, 254);
               }
               Exception_Log__c oExceptionLog = new Exception_Log__c();
               oExceptionLog.Running_User__c = sRunninguserId;
               oExceptionLog.Class_Name__c = sClassName;
               oExceptionLog.Method_Name__c = sMethodName;
               oExceptionLog.Exception_Message__c=sExMsg; 
               oExceptionLog.Exception_Type__c= sTypeName;
               oExceptionLog.StackTrace_Message__c = sStackTrace;
               insert oExceptionLog;
           }
        else
        { //user doesn't have permission to create a task then notify the same to system admin
            String strError = 'Unauthorized user trying to insert an Exception log :'+' User Id :'+UserInfo.getUserID();
            SendEmailWithErrorsToAdmins.sendEmail(strError);   
        }
    }   
}