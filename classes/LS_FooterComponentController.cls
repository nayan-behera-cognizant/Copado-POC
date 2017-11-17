/**
* @author Cognizant Technology Solutuions
* @date 01/05/2016
* @description LS_FooterComponentController is being used by LS_Footer component .
*/
public with sharing class LS_FooterComponentController {
    public PageReference pRCurrentPage { get; set; }
    public String termsURL { get; set; }
    public String privacyURL { get; set; }
    public String faqURL { get; set; }
    public String helpURL { get; set; }
    public String selectedLanguage { get; set; }
    public boolean renderdLangSwitcher { get; set; }
    public String sCountry { get; set; }
    public String sCountryName { get; set; }
    public String sCountryCode { get; set; }
    public String sLanguage { get; set; }
    public String sURLLang { get; set; }
    public String sLang { get; set; }
    public boolean showSwitcher { get; set; }
    public boolean sCountryExists { get; set; }
    public boolean strCountryExist { get; set; }
    public String sTrakingParams { get; set; }
    public String aboutURL { get; set; }
    public String straboutURL { get; set; }
    public String cookieCountry { get; set; }
    public User user { get; set; }
    public String oCountry { get; set; }
    public String nameOfPage { get; set; }
    public Boolean showAddGiftCodeFlagInFooter { get; set;}

          
    public LS_FooterComponentController() {
        showSwitcher = true;
        straboutURL = Label.LS_Footer_about;
        pRCurrentPage = ApexPages.currentPage();
        sCountry = pRCurrentPage.getParameters().get('Country');
        sLanguage = pRCurrentPage.getParameters().get('lang');
        sTrakingParams = pRCurrentPage.getParameters().get('TrakingParams');

        sCountryExists = String.isNotBlank(sCountry);
        
        cookieCountry = CommunityHelper.getUserCountryName(null);
        
         

        user = CommunityHelper.getCurrentUser();
        if (String.isBlank(sLanguage) || sLanguage == 'null') { sLanguage = CommunityHelper.getLanguageCode(); }
        if (sLanguage.equals('en_GB') || sLanguage.equals('en_US')) { sLanguage = 'en'; }
        if (String.isBlank(sCountry)) { sCountry = CommunityHelper.getUserCountry(user); }

        getFooterURLs();
        
        If (user!= null){
        showAddGiftCodeFlagInFooter = GiftCodeHelper.checkRedeemLinkCriteria(user); 
        }
    }
    
    public boolean getLanguageExists() {
        return getDAZNLanguage().values().size() > 0;
    }
    
    /*
        Description: This method implements redirection for footer links.
    */
    private void getFooterURLs() {
        termsURL = '/help/' + sCountry + '-' + sLanguage + '/terms' + (sTrakingParams == null ? '' : sTrakingParams);
        privacyURL = '/help/' + sCountry + '-' + sLanguage + '/privacy' + (sTrakingParams == null ? '' : sTrakingParams);
        faqURL = '/help/' + sCountry + '-' + sLanguage + '/FAQ' + (sTrakingParams == null ? '' : sTrakingParams);
        helpURL = '/help/' + sCountry + '-' + sLanguage + (sTrakingParams == null ? '' : sTrakingParams);
        
        List<DAZN_Help_Redirect__c> daznHelpRedirect = [Select Id, FooterAboutLinkCustomLabel__c, FooterAboutTitleCustomLabel__c
            From DAZN_Help_Redirect__c
            Where CountryISOCode__c = :sCountry AND Language__c = :sLanguage
            LIMIT 1];

        if (!daznHelpRedirect.isEmpty() && String.isNotBlank(daznHelpRedirect[0].FooterAboutTitleCustomLabel__c) && String.isNotBlank(daznHelpRedirect[0].FooterAboutLinkCustomLabel__c)) {
            Component.Apex.OutputText output = new Component.Apex.OutputText();
            output.expressions.value = '{! $Label.' + daznHelpRedirect[0].FooterAboutTitleCustomLabel__c + ' }';
            straboutURL = String.valueOf(output.value);
            output.expressions.value = '{! $Label.' + daznHelpRedirect[0].FooterAboutLinkCustomLabel__c + ' }';
            aboutURL = '/help/' + sCountry + '-' + sLanguage + '/' + String.valueOf(output.value) + (sTrakingParams == null ? '' : sTrakingParams);
        }
        
        /*if (sCountry == 'JP' && sLanguage.equalsIgnoreCase('en')) {
            straboutURL = Label.LS_Footer_about;
            aboutURL = '/help/' + sCountry + '-' + sLanguage + '/' + Label.LS_Footer_about + (sTrakingParams == null ? '' : sTrakingParams);
        }
        system.debug('*****AboutURL'+aboutURL );
        
        if (sCountry == 'JP' && sLanguage.equalsIgnoreCase('ja')) {
            straboutURL = Label.LS_Footer_about_JP;
            aboutURL = '/help/' + sCountry + '-' + sLanguage + '/' + Label.LS_Footer_about + (sTrakingParams == null ? '' : sTrakingParams);
        }
        if ((sCountry == 'DE' || sCountry == 'AT' || sCountry == 'CH') && sLanguage.equalsIgnoreCase('de')) {
            straboutURL = Label.LS_Footer_IMPRESSUM;
            aboutURL = '/help/' + sCountry + '-' + sLanguage + '/' + Label.LS_Footer_imprint + (sTrakingParams == null ? '' : sTrakingParams);     
        }
        if ((sCountry == 'DE' || sCountry == 'AT' || sCountry == 'CH') && (sLanguage.equalsIgnoreCase('en'))) {
            straboutURL = Label.LS_Footer_imprint;
            aboutURL = '/help/' + sCountry + '-' + sLanguage + '/' + Label.LS_Footer_imprint + (sTrakingParams == null ? '' : sTrakingParams);             
        }
        if (sCountry == 'CA' && (sLanguage.equalsIgnoreCase('fr_CA') || sLanguage.equalsIgnoreCase('en'))) {
            straboutURL = Label.LS_Footer_about_CA;
            aboutURL = '/help/' + sCountry + '-' + sLanguage + '/'+ Label.LS_Footer_about_CA + (sTrakingParams == null ? '' : sTrakingParams);     
        }*/
    }  
    
    /*
        Description: This method returns the languages available for the specific country of the user.
    */
    public Map<string,string> getDAZNLanguage() {
        List<DAZNLanguageConfiguration__c> oDAZNLang = DAZNLanguageConfiguration__c.getall().values();
        
        /*Added as part of PD-11615*/
        if(sCountry == 'CA'){
            sLang = (sLanguage == 'en') ? 'en_US' : sLanguage;
        } //End of PD-11615
        else{
            sLang = (sLanguage == 'en') ? 'en_GB' : sLanguage;
        }

        Map<String, String> mapLang = new Map<String, String>();
        for (DAZNLanguageConfiguration__c oLang : oDAZNLang) {
            if (oLang.Country__c == sCountryName || oLang.Country_Code__c == sCountry) {
                mapLang.put(oLang.Language_Code__c, oLang.Language__c);
                if (oLang.Language_Code__c == sLang) {
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
        if (String.isBlank(oCountry)) { oCountry = sCountry; }
        PageReference retPage = null;
        string pageURL = (String.isNotBlank(nameOfPage)) ? '/' + nameOfPage : System.URL.getCurrentRequestUrl().toExternalForm().replaceFirst('/apex', '');
        MAP<String, String> mapParams = apexpages.currentpage().getParameters();
        system.debug('---->mapParams'+mapParams);
        String languageSelected = mapParams.get('languageSelected');
        
        if (String.isNotBlank(languageSelected) || String.isNotEmpty(languageSelected)) {
            if (languageSelected <> 'fr_CA' && languageSelected.length() > 2 && languageSelected.indexOf('_') > -1 ) {
                languageSelected = languageSelected.split('_')[0];
            }
        }
        
        String sPageReferenceURL;
        if (mapParams.containsKey('title'))
            sPageReferenceURL = pageURL + '/' + oCountry + '-' + languageSelected + '/' + mapParams.get('title');
        else if (mapParams.containsKey('searchText'))
            sPageReferenceURL = pageURL + '/' + oCountry + '-' + languageSelected + '/search/' + mapParams.get('searchText');
        else if (mapParams.containsKey('type'))
            sPageReferenceURL = pageURL  + '/' + oCountry + '-' + languageSelected + '/' + mapParams.get('type');
        else if (mapParams.containsKey('UserId'))
            sPageReferenceURL = pageURL  + '/' + oCountry + '-' + languageSelected + '/' + mapParams.get('UserId');
        else if (mapParams.containsKey('Id'))
            sPageReferenceURL = pageURL + '/' + oCountry + '-' + languageSelected + '/' + mapParams.get('Id');
        else if (mapParams.containsKey('pauseAction'))
            sPageReferenceURL = pageURL + '/' + oCountry + '-' + languageSelected + '/' + mapParams.get('pauseAction');
        else if (mapParams.containsKey('retUrl'))
            sPageReferenceURL = pageURL + '/' + oCountry + '-' + languageSelected + '/' + mapParams.get('retUrl');
        else
            sPageReferenceURL = pageURL  + '/' + oCountry + '-' + languageSelected;

        retPage = new pagereference(sPageReferenceURL);

        /*PD-10536*/
        if (ApexPages.CurrentPage().getUrl().Contains(System.Page.MyLogin.getUrl())) {
            retPage.getParameters().put('loginType', 'DAZN');
        }

        retPage.setRedirect(true);
        return retPage;
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