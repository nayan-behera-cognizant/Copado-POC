@RestResource(urlMapping='/signOutOfAllDevicesFromEmail/*')
global with sharing class signOutOfAllDevicesController{
    @HttpPost
    global static response signOutOfAllDevicesPost(String strEmail) {            
        response resObj = new response();         
        List<User> objUserList = [SELECT Id, AccountId, ContactId FROM User where Email =:strEmail Limit 1];        
        try{                                
            if(!objUserList.isEmpty() && objUserList!=null){           
                resObj.strResponse = System.label.LS_SignOutAll_SUCCESS;
                resObj.StatusCode = System.label.LS_SignOutAll_SUCCESS_Code;                
            }
            else{            
                resObj.strResponse = System.label.LS_SignOutAll_Fail; 
                resObj.StatusCode = System.label.LS_SignOutAll_Fail_Code;                
            }
        }catch(Exception userNullExcep){                          
        }            
        return  resObj;
        
    }    
    global class response{
        global string strResponse{get;set;}
        global String StatusCode {get;set;}
    }
}