public with sharing class FetchLanguageCookieController {
    public String strPageName { get; set; }
    public String strBrowserLang { get; set; }
    public String strParamLang { get; set; }
    public String strParamCountry { get; set; }
    private String countryCode;
    private String languageCode;
    
    public PageReference fetchBrowserLanguage() {
        PageReference currentPage = ApexPages.currentPage();

        Map<String, String> countryAndLanguageCodes = CommunityHelper.setCountryAndLanguageCodes(strBrowserLang);

        languageCode = countryAndLanguageCodes.get('lang');
        countryCode = countryAndLanguageCodes.get('Country');

        String loginType = currentPage.getParameters().get('loginType');
        Boolean redirectToDocomoSignIn = (String.isNotBlank(strPageName) && strPageName.equalsIgnoreCase('mylogin')) &&
            (String.isBlank(loginType) || !loginType.equalsIgnoreCase('DAZN')) &&
            (String.isNotBlank(countryCode) && countryCode.equalsIgnoreCase('JP'));

        PageReference pageToRedirect = null;
        if (redirectToDocomoSignIn) {
            pageToRedirect = Page.signIn;
            pageToRedirect.getParameters().put('lang', languageCode);
            pageToRedirect.getParameters().put('Country', countryCode);
        }
        
        return pageToRedirect;
    }
}