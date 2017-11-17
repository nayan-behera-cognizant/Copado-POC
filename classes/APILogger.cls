/**
 * @Author : Cognizant Technology Solution
 * @Date : 01-Sept-2017
 * @Description: This class will be used to create API logs which will be used to track API call outs
 * @Parameter1 : accountId : It captures Id of person account for API call out
 * @Parameter2 : callOutEndPointURLStr : It captures end point of API call out
 * @Parameter3 : callOutTypeStr : Its a restricted picklist and its values will be Inbound/Outbound depending on call out. 
 * @Parameter4 : processIDStr : It captures Workflow ID/Process Id of API call out
 * @Parameter5 : requestStr : It captures request of API call out
 * @Parameter6 : responseCodeStr : It captures response of API call out
 * @Parameter7 : statusStr : It captures status of API call out
**/
global class APILogger{
    public static void CreateAPILogs(Id accountId,String callOutEndPointURLStr,String callOutTypeStr,String processIDStr,
									String requestStr,String responseStr,String responseCodeStr,String statusStr){
    	API_Log__c apiLogRec = new API_Log__c();
        if(accountId <> null)
        	apiLogRec.Account__c = accountId; 
        if(callOutEndPointURLStr <> null)
            apiLogRec.Call_out_end_point__c = callOutEndPointURLStr; 
        apiLogRec.Call_out_type__c = callOutTypeStr;
        apiLogRec.Process_ID__c = processIDStr;
        //Update API Request                                 
        if(requestStr <> '' && requestStr <> null){            
            System.debug(requestStr.length());
            if(requestStr.length() > 131071){                
            	apiLogRec.Request__c = requestStr.substring(0,131071);
            }
            else
                apiLogRec.Request__c = requestStr;
        }
        //Update API Response 
        if(responseStr <> '' && responseStr <> null){
            if(responseStr.length() > 131071){
                apiLogRec.Response__c = responseStr.substring(0,131071);
            }
            else
                apiLogRec.Response__c = responseStr;
        }
		apiLogRec.Response_Code__c = responseCodeStr;                                    
		apiLogRec.Status__c = statusStr;
        try{
        	insert apiLogRec;//Create API Log record   
        }catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'APILogger', 'CreateAPILogs', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        }                     
    }
}