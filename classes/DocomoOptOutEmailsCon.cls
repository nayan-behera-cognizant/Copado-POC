/**
* @author Cognizant Technology Solutuions
* @date 30/03/2017
* @description DocomoOptOutEmailsCon class
* Purpose:It will unsubscribe user email from the docomo 
email list.
*@ The url to load this page is
"https://<CommunityURL>/DocomoOptOutEmails?ACID=<Docomo PartnerID>&lang=en&country=JP"
lang and country parameters in URL to load the "Change language" section in help footer      
Without Sharing key word is used to bypass the security sharing rules since account records are queried to 
by the guest user.   
*/
public without sharing class DocomoOptOutEmailsCon{
    
    //Global Variables
    public string strDfdPartnerId;
    public static string dfdDocomoResp{get;set;} 
    public account accounts{get;set;}   
    public boolean errorMessage{get;set;} // To display error message on screen
    public boolean sucessflag{get;set;}  // To display success message on screen
    
    /*@ Method : Constructor
*@ Arugments: No
*@ ReturnType: no
*/    
    public DocomoOptOutEmailsCon(){
        strDfdPartnerId = Apexpages.currentPage().getParameters().get('ACID');
      /*Added as part of PD-10413*/
        blob ACID = EncodingUtil.base64Decode(strDfdPartnerId);
        string decodedACID = ACID.toString();
        sucessflag = false;
        errorMessage = false;
        if(decodedACID!= null && decodedACID  != ''){
            try{
                accounts = [select id, Type,PersonEmail,Secondary_Email__c,Partner_ID__c  from account where Partner_ID__c =:decodedACID limit 1]; 
            }catch(exception ex){
                errorMessage = true;
                
            }  
            System.debug('accounts**'+accounts);
            // ToDo:Email Validation - If a account without secondary email, error banner need to show
            if(accounts!= null && accounts.Secondary_Email__c == null ){
                errorMessage = true;
                
            }  
            
        }else{
            errorMessage = true;
        } 
        
    }
    
    
    /*@ Method : oPtOutDocomoEmails
*@ Arugments: No
*@ ReturnType: Null
*/
    public pageReference oPtOutDocomoEmails(){   
        // Need to check for only docomo type users without email secondary mail       
        if(accounts!= null && accounts.type =='Docomo' && accounts.Secondary_Email__c!= null ){
            // Removing the email from docomo market list by passing the two parameters(one flag  and docomo ACID)
            dfdDocomoResp = PartnerAccountController.respToSetTheDocomo(false,accounts.Partner_ID__c ); 
        }
        //if status is equal to 0 than sucessfully updated in docomo server else need to show error message           
        if(dfdDocomoResp == '0' && dfdDocomoResp!= null){
            sucessflag = true;
        }else{
            errorMessage = true; 
            sucessflag = false;        
        }                
        return null;
    }  
    
    /*@ Method: Closebanner
*@ Purpose: To close the banner displayed in the page
*/
    public void Closebanner(){
        errorMessage  = false;
        
        
    }
    
}