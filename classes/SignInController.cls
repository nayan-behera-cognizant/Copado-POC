public with sharing class SignInController { 
    
    public String cookieCountry { get; set; }
    public String sCountry { get; set; }
    public String strLanguage { get; set; }

    public SignInController() {
        if (UserInfo.getUserType().equalsIgnoreCase('Guest')) {
            cookieCountry = Communityhelper.getUserCountryfromIPAddress();
        } else {
            cookieCountry = CommunityHelper.getUserCountryName(null);                
        }
    }
    
    public PageReference redirectToHomePage() {
        return CommunityHelper.redirectToHomePage();
    }
    
    public PageReference redirectToDocomoSignInPage() {
        Map<String, String> mapParams = ApexPages.currentpage().getParameters();
        String docomoSignInParams = (mapParams.containsKey('retUrl')) ? mapParams.get('retUrl') : '';
        docomoSignInParams += (String.isBlank(docomoSignInParams)) ? '' : ';' + mapParams.get('Country') + ';' + mapParams.get('lang');
        return CommunityHelper.docomoAuthentication(docomoSignInParams);
        //return CommunityHelper.docomoAuthentication(ApexPages.currentPage().getParameters().get('type'));
    }

    public PageReference toGetuserIPAddress() {
        return null;
    }

}