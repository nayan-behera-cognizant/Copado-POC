public with sharing class LS_FooterCookieController {
    public String nameOfPage { get; set; }
    public Boolean renderdLangSwitcher { get; set; }
    public String selectedLanguage { get; set; }
    public String langToChange { get; set; }
    public String countryToChange { get; set; }
    public Boolean showAddGiftCodeFlagInFooter { get; set;}
    public User user { get; set; }

      public LS_FooterCookieController() {
      
      user = CommunityHelper.getCurrentUser();
        
        If (user!= null){
        showAddGiftCodeFlagInFooter = GiftCodeHelper.checkRedeemLinkCriteria(user); 
        }
    }

    public String sCountry {
        get {
            return ApexPages.currentPage().getParameters().get('Country');
        }
        set;
    }
    public String sLang {
        get {
            return ApexPages.currentPage().getParameters().get('lang');
        }
        set;
    }
    public String sTrakingParams {
        get {
            return ApexPages.currentPage().getParameters().get('TrakingParams');
        }
        set;
    }
    public String helpURL {
        get {
            return '/help/' + sCountry + '-' + sLang + (sTrakingParams == null ? '' : sTrakingParams);
        }
        set;
    }
    public String faqURL {
        get {
            return '/help/' + sCountry + '-' + sLang + '/' + 'FAQ' + (sTrakingParams == null ? '' : sTrakingParams);
        }
        set;
    }
    public String termsURL {
        get {
            return '/help/' + sCountry + '-' + sLang + '/' + 'terms' + (sTrakingParams == null ? '' : sTrakingParams);
        }
        set;
    }
    public String privacyURL {
        get {
            return '/help/' + sCountry + '-' + sLang + '/' + 'privacy' + (sTrakingParams == null ? '' : sTrakingParams);
        }
        set;
    }
    public String aboutURL {
        get {
            return '/help/' + sCountry + '-' + sLang + '/' + 'about' + (sTrakingParams == null ? '' : sTrakingParams);
        }
        set;
    }

    public Boolean getLanguageExists() {
        return getDAZNLanguage().values().size() > 0;
    }

    public Boolean getCountryExists() {
        return String.isNotBlank(sCountry);
    }
    
    /*
        Description: This method returns the languages available for the specific country of the user.
    */
    public Map<string,string> getDAZNLanguage() {
        List<DAZNLanguageConfiguration__c> oDAZNLang = DAZNLanguageConfiguration__c.getall().values();

        String countryCode = sCountry;
        String languageCode = sLang;

        Boolean isCanadaCountryCode = String.isNotBlank(countryCode) && countryCode.equalsIgnoreCase('CA');
        Boolean isChangeEnLangCode = String.isNotBlank(languageCode) && languageCode.startsWithIgnoreCase('en');
        
        if (isChangeEnLangCode) {
            languageCode = (isCanadaCountryCode) ? 'en_US' : 'en_GB';
        }

        Map<String, String> mapLang = new Map<String, String>();
        for (DAZNLanguageConfiguration__c oLang : oDAZNLang) {
            if (oLang.Country__c == countryCode || oLang.Country_Code__c == countryCode) {
                mapLang.put(oLang.Language_Code__c, oLang.Language__c);
                if (oLang.Language_Code__c == languageCode) {
                    selectedLanguage = oLang.Language__c;
                }
            }
        }

        return mapLang; 
    }
    
    /*
        Description: This method changes the language of the page.
    */
    public PageReference translatePageToSelectedLanguage() {
        PageReference currentPage = ApexPages.currentPage();

        if (String.isNotBlank(currentPage.getUrl()) && currentPage.getUrl().contains(System.Page.MyLogin.getUrl())) {
            currentPage.getParameters().put('loginType', 'DAZN');
        }
        String newLang = CommunityHelper.formatLangCode('', countryToChange, langToChange);
        currentPage.getParameters().put('lang', newLang);
        currentPage.getParameters().put('Country', countryToChange);

        Cookie lang = new Cookie('lang', newLang, null, -1, false);
        Cookie country = new Cookie('Country', countryToChange, null, -1, false);
        currentPage.setCookies(new Cookie[] {lang, Country});

        return null;
    }
    
   /**
 * @Author Cognizant Technology Solutuions
 * @Date 10-Oct-2017
 * @Description : This method is used to Navigate to Redeem URL page
 * @Parameter1 :
*/

 public PageReference redeemGiftCode() {
    PageReference ref = GiftCodeHelper.redeemGiftCode();
    return ref;
} 

}