/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CommunitiesLoginController {
    public string urlLoginPage {get;set;}
    global CommunitiesLoginController () {}
    
    // Code we will invoke on page load.
    /*global PageReference forwardToAuthPage() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        String displayType = System.currentPageReference().getParameters().get('display');
        return Network.forwardToAuthPage(startUrl, displayType);
    }*/
    
    global PageReference forwardToAuthPage() {
        string sCountry = CommunityHelper.getUserCountryName(null);
        urlLoginPage = CommunityHelper.getMassiveURLs(sCountry,'LoginPageURLType'); 
       
        PageReference reference=new PageReference(urlLoginPage);
        reference.setRedirect(true);
        return reference;
    }
}