public with sharing class LS_HeaderComponentController {
    public String homePageURL { get; set; }
    public String helpPageURL { get; set; }

    /*
        Description: Header constructor.
    */
    public LS_HeaderComponentController() {
        String sCountry = CommunityHelper.getUserCountryName(null);
        homePageURL = CommunityHelper.getMassiveURLs(sCountry, 'HomePageURLType');
        helpPageURL = '';
    }
    
    /*
        Description: Method to redirect user on home page.
    */
    public PageReference redirectToHomePage() {
        return CommunityHelper.redirectToHomePage();
    }
}