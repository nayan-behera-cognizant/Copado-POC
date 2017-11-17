public class RefererCon {
    public String pageNameReferer   { get; set; }
    public RefererCon(){
        //if(pageNameReferer  != null){
            getRefererDetails();
      //  }
        
    }
    
    public pageReference getRefererDetails(){
        PageReference pr = null;
        Map<String, String> headers=ApexPages.currentPage().getHeaders();
        String referrer=headers.get('Referer');
        // custom setting 
        DAZNConfiguration__c daznConRefUrl = DAZNConfiguration__c.getValues('RefererAcceptURL');
        system.debug('daznConRefUrl--------->'+daznConRefUrl.Value__c);
        string refererAceptUrl = daznConRefUrl.Value__c;
        if(string.isNotBlank(referrer) &&  string.isNotBlank(refererAceptUrl) && refererAceptUrl.containsIgnoreCase(referrer) ){
        
        }else{
            system.debug('Conditions is failed logic is moved to else condition');
            pr = new pagereference('PAGENOTFOUND');
                      
            pr.setRedirect(true);
            return pr;
            
        }
       
        return pr;
    }
}