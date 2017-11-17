public with sharing class FetchLanguageController {

	public String strPageName { get; set; }
	public String strLang { get; set; }

	public FetchLanguageController() {
		
	}

	public PageReference fetchBrowserLanguage() {
        return CommunityHelper.myloginFetchUserLocale(strPageName, strLang);
    }
}