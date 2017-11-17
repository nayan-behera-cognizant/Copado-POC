/**
* @author Cognizant Technology Solutuions
* @date 03/10/2017
* @description EmailQueOptinController class
*/
public class EmailQueOptinController{

    /* Takes the Set of account Ids and make Double Optin True */
    
    public static void accDouOPtinCheck(set<ID> setOFAccIds) {
    
        List<Account> lstAccount = new List<Account>();
        List<Account> UpdateAccount = new List<Account>(); 
      try{
        if(setOFAccIds.size()>0){
            lstAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c from Account where Id IN:setOFAccIds];
        }
        if(lstAccount.size()>0){
            For(Account accObj : lstAccount){
                if(accObj.Is_Double_OptIn__c == false){
                     accObj.Is_Double_OptIn__c = true;
                     UpdateAccount.add(accObj); 
                }
                              
                }
            }
            
                
                    if(UpdateAccount.size()>0){
                          
                    		update UpdateAccount;
                          }
    }Catch(Exception ex){ 
        ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'EmailQueOptinController', 'accDouOPtinCheck', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
    }    
                               
     }  
}