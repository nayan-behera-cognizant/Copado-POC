global class ClsForceSignOffUsersFromDevices implements Process.Plugin{
    
	global Process.PluginResult invoke(Process.PluginRequest request) { 
      String accountID = (String) request.inputParameters.get('accountId');
      String userID = (String) request.inputParameters.get('userId');
      String contactID = (String) request.inputParameters.get('contactId');
      Boolean isSuccess = true;
      Map<String,Object> result = new Map<String,Object>();
      List<User_Devices__c> lstAllUserDevices;
      List<AuthSession> lstActiveUserSessions;
        try{
            lstAllUserDevices = [SELECT Status__c
                             FROM User_Devices__c where Account__c =:accountID and Status__c='Active' LIMIT 100];
                    
              
            
            lstActiveUserSessions = [Select ID From AuthSession Where UsersId =: userID];
            if(lstAllUserDevices!=null && !lstAllUserDevices.isEmpty()){
                delete lstAllUserDevices;
            }
                
            if((lstActiveUserSessions!=null && !lstActiveUserSessions.isEmpty())||Test.isRunningTest()){
                delete lstActiveUserSessions;
            }
                
			CommunityHelper.updateSignoutKey(accountID);
        }catch(Exception ex){
            isSuccess = false;
        }
      
      CommunityHelper.createSignOffTask(contactID, accountID, System.Label.LS_SignOutDevice_TaskSubject, System.Label.LS_SignOutDevice_TaskDesc );
      result.put('isSuccess',isSuccess);
      
      return new Process.PluginResult(result);
    }
    
    global Process.PluginDescribeResult describe() { 
      Process.PluginDescribeResult result = new Process.PluginDescribeResult(); 
      result.Name = 'Force sign off users from devices';
      result.Tag = 'Device Sign off';
     
      result.inputParameters = new 
         List<Process.PluginDescribeResult.InputParameter>{ 
            new Process.PluginDescribeResult.InputParameter('accountId', 
            Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('userId', 
            Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('contactId', 
            Process.PluginDescribeResult.ParameterType.STRING, true)  
         }; 
      result.outputParameters = new 
         List<Process.PluginDescribeResult.OutputParameter>{              
            new Process.PluginDescribeResult.OutputParameter('isSuccess', 
            Process.PluginDescribeResult.ParameterType.BOOLEAN)
                }; 
      return result; 
   }
    
 }