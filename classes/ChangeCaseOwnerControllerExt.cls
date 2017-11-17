/**
*  @author Dasetti Venkata Ramaiah(Cognizant)
*  @date Aug 22, 2017
*  @description ChangeCaseOwnerControllerExt 
*  @Modification Log:        
------------------------------------------------------------------------------------        
Developer                Vesrsion No       Date                Description        
------------------------------------------------------------------------------------        
Dasetti Venkat Ramaiah       -           22/08/2017           Initial version created.
*/

public with sharing class ChangeCaseOwnerControllerExt {
    //varibles
    public String caseId;
    private ApexPages.StandardController ctrl;
    public boolean Iserror{get;set;}
    public case newCase{get;set;}      
    
    //constructor
    public ChangeCaseOwnerControllerExt(ApexPages.StandardController sc) {
        this.caseId = ApexPages.currentPage().getParameters().get('id');
        this.ctrl = sc;
        Iserror = false;
        newCase = new case();
    }
    /**
*  @Method: changeCaseOwner
*  @description : This method is used to change ownere and set the status to Waiting for Support
*  @Parameter : No
*  @Return Type: PageReference 
*/
    public PageReference  changeCaseOwner() {
        
        Case caseForChange;
        try{
            List<Case> cases = [SELECT Id, OwnerId FROM Case WHERE Id = :caseId];
            if (!cases.isEmpty() && string.isNotBlank(newCase.User_internal__c)) {
                caseForChange = cases[0];
                caseForChange.OwnerId = newCase.User_internal__c;
                caseForChange.Status = Label.LS_Case_Status;
                
                
                update caseForChange;
                
                
                
            }else{
                Iserror = true;
                apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, 'Please enter a value'));
                return null;
            }
        }catch(exception ex){
            Iserror = true;
            ExceptionLoggerHelper.createExceptionLog(userinfo.getuserid(), 'ChangeCaseOwnerControllerExt', 'changeCaseOwner', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, System.Label.Please_Contact_Your_Admi));
            
        }
        return null;
    }
    
    /**
*  @Method: cancelAction
*  @description : This method is used to change the value from true to false
*  @Parameter : No
*  @Return Type: PageReference 
*/
    public pageReference cancelAction(){
        Iserror = false;       
        return null;
    }
    
    
}