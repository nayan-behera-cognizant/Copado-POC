/*
    @Name - CLsResetPassword
    @UsedBy - /flow/forgot_password
    @Last Modified Date - 03 February 2016
    
    @RevisionHistory 
    03 Feb 2016 - Added comments and indentation
*/
global class ClsResetPassword implements Process.Plugin{ 
    
    /*
    @Input - Process.PluginRequest
    @Output - Process.PluginResult
    @Description - Invoke method to reset password for the user
    @Author - Cognizant 
    */
    global Process.PluginResult invoke(Process.PluginRequest request) { 
      String name = (String) request.inputParameters.get('name');
      Map<String,Object> result = new Map<String,Object>();
        try{
            //result.put('isSuccess', Site.forgotPassword(name));
            System.resetPassword(name,true);
            result.put('isSuccess',TRUE);
        }catch(Exception ex){
            result.put('isSuccess',FALSE);
        }
      
      return new Process.PluginResult(result);
    }
    
    /*
    @Input - Process.PluginRequest
    @Output - Process.PluginResult
    @Description - Describes the format of the request and response to be used in invoke() method
    @Author - Cognizant 
    */
    global Process.PluginDescribeResult describe() { 
      Process.PluginDescribeResult result = new Process.PluginDescribeResult(); 
      result.Name = 'Forgot password for username';
      result.Tag = 'Account Classes';
      result.inputParameters = new 
         List<Process.PluginDescribeResult.InputParameter>{ 
            new Process.PluginDescribeResult.InputParameter('name', 
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