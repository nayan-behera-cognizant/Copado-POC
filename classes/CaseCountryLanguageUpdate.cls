/**
* @author Cognizant Technology Solutuions
* @date 16/03/2015
* @description CaseCountryLanguageUpdate class is to Update Language code and country code on case using a custom button  
*/

public class CaseCountryLanguageUpdate {
    
    public ApexPages.StandardController Controller;
    public string SelectedCountryCode {get; set;}
    public string SelectedLanguageCode {get; set;}
    public list<selectOption> lang{get;set;}
    List<Case> caseList = new List<Case>();
    public string sCaseID;
    private map<string, string> countryLangMap;
    
    
    public CaseCountryLanguageUpdate(ApexPages.StandardController stdController){
        this.Controller = stdController;
        sCaseID = stdController.getId(); //Retrieving Case ID from Controller
        countryLangMap = new Map<string, string>();
        lang = new list<selectOption>();
    }
    
    
    /*Method to get the country values from Custom setting and displaying country picklist values on page*/
    
    public list<selectOption> getCountry(){       
        List<CaseCountryLanguages__c> lstcountryLanguage = CaseCountryLanguages__c.getall().values();
        list<selectOption> Options = new list<selectOption>();    
        Options.add(new selectOption('','--None--'));
        if(!lstcountryLanguage.isEmpty()){
            for(CaseCountryLanguages__c ccLang: lstcountryLanguage ){
                Options.add(new selectOption(ccLang.name,ccLang.name)); //adding Country picklist values on page
                countryLangMap.put(ccLang.name,ccLang.Language__c);
             }          
        }
         return Options;
    }
    
    
    /*Method to display the language values on page based on selected country*/
    
    public void changeLang(){
        lang.clear();
        if(SelectedCountryCode!= null && countryLangMap.containskey(SelectedCountryCode)){
            string langvalues =  countryLangMap.get(SelectedCountryCode);
            if(langvalues != null){
                for(string st :langvalues.split(',') ){
                    lang.add(new selectOption(st,st));//adding language picklist vaues on page
                }
             }
        }
     }       
    
    
    /*Method to save the Country and language and return back to case layout*/ 
    
    public PageReference saveAndReturn(){
        try{
            if(sCaseID != null){
                //List to retrieve Case details
                caseList = [SELECT Id, Notification_Country_Code__c, Notification_Language_Code__c FROM Case WHERE Id = :sCaseID limit 1];
            }
          
            if( !caseList.isEmpty() && SelectedCountryCode!= null && SelectedLanguageCode!=null){
                caseList[0].Notification_Country_Code__c = SelectedCountryCode;
                caseList[0].Notification_Language_Code__c = SelectedLanguageCode;
                update caseList; //updating the case according to values selected using Custom button            
                PageReference parentPage = new PageReference('/' + sCaseID);
                parentPage.setRedirect(true);
                return parentPage; //redirecting to case layout page after saving the values
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Country '));
                return null;
                
            }
            
        }catch(exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select a value '));
            return null;
        }
    }
    
    
    /*Method to redirect to parent page when we click on cancel button*/
    
    public PageReference cancelAction(){
        
        return new pageReference('/'+sCaseID);
    }
    
}