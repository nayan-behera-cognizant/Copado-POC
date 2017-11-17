public with sharing class LS_Help_FooterComponentController {

    public Boolean showEmailLink { get; set; }

    public String liveChatButtonId {
        get {
            String sCountry = ApexPages.currentPage().getParameters().get('Country');
            String sLang = ApexPages.currentPage().getParameters().get('lang');
            LiveChatLanguageSettings__c lChLangSettings = (String.isBlank(sCountry) || String.isBlank(sLang)) ? null : LiveChatLanguageSettings__c.getValues(sCountry.toUpperCase() + '-' + sLang.toLowerCase());
            return (lChLangSettings == null) ? null : lChLangSettings.Button_Id__c;
        }
        set;
    }

    public Boolean showLiveChat {
        get {
            String sCountry = ApexPages.currentPage().getParameters().get('Country');
            LiveChatCountrySettings__c lChCountrySettings = (String.isBlank(sCountry)) ? null : LiveChatCountrySettings__c.getValues(sCountry.toUpperCase());
            return (!UserInfo.getUserType().Equals('Guest') && String.isNotBlank(liveChatButtonId) && !CommunityHelper.IsDfDUser()) || (UserInfo.getUserType().Equals('Guest') && (String.isNotBlank(liveChatButtonId)) && (lChCountrySettings != null) && lChCountrySettings.Is_Enabled__c);
        }
        set;
    }

    public String sTrakingParams {
        get {
            return ApexPages.currentPage().getParameters().get('TrakingParams');
        }
        set;
    }

    public String faqLinkLabel {
        get {
            String sCountry = ApexPages.currentPage().getParameters().get('Country');
            String sLang = ApexPages.currentPage().getParameters().get('lang');
            return getFAQArticleCount((sLang == 'en') ? 'en_GB' : sLang, sCountry + '__c');
        }
        set;
    }

    public LS_Help_FooterComponentController() {
        showEmailLink = ApexPages.currentPage().getURL().indexOf('contactus') <= -1;
        showLiveChat = false;
    }

    public static String getFAQArticleCount(String sLanguage, String sCountry) {
        String sDataCategoryName = 'FAQ';
        Integer iArticleCount = 0;

        try {
            List<String> lstArticleType = new List<String>();
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            for (String key : gd.keySet()) {
                Schema.SObjectType objectType = gd.get(key);
                if (key.endsWith('ka') || key.endsWith('kb')) {
                    lstArticleType.add(objectType.getDescribe().getName());
                }
            }
            for (String sArticleType : lstArticleType) {                
                String sQuery;                    
                sQuery = 'Select COUNT() FROM ' + sArticleType.replace('__ka', '__kav') + ' WHERE (PublishStatus = \'online\' and language=\'' + sLanguage + '\' and Exclude_From_Search__c=false) WITH DATA CATEGORY Region__c AT ' + sCountry + ' AND Provider_Type__c AT ' + ' (' + Label.Non_DfD_Provider_Type + ') AND Content_type__c AT ' + sDataCategoryName + '__c' ;
                System.debug(sQuery);
                if (sArticleType != 'System_update__ka') {
                    iArticleCount += Database.countQuery(sQuery);
                }
            }
        } catch(Exception e) {
            return Label.LS_Help_Label_See_All_FAQs.replace('[count]', '0');
        }

        return Label.LS_Help_Label_See_All_FAQs.replace('[count]', String.valueOf(iArticleCount));
    }

}