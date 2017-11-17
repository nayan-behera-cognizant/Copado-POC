//This class is used for update the rating in case given by user
public class CaseFeedbakRatingController{
    public case updateCase{get;set;}    
    public string rate{get;set;} 
    public CaseFeedbakRatingController(ApexPages.StandardController controller) {    
    }
    //Used to get those parameters from email termplate and update the case 
    public PageReference served(){    
        rate=ApexPages.currentPage().getParameters().get('x');                       
        updateCase=[select id,casenumber,Rating__c from case where Id=:ApexPages.currentPage().getParameters().get('y') limit 1];            
        updateCase.Rating__c=rate;                
        update updateCase;
        return null;
    }
}