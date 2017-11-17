public with sharing class KnowledgeBaseHelper {
    public KnowledgeBaseHelper() {
        
    }

    public static List<String> getArticleTypes(String suffix) {
        if (String.isBlank(suffix)) {
            return null;
        }

        List<String> articleTypes = new List<String>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Set<String> keySet = gd.keySet();
        for (String key : keySet) {
            if (key.endsWith(suffix.toLowerCase())) {
                articleTypes.add(gd.get(key).getDescribe().getName());
            }
        }
        return articleTypes;
    }

    public static Map<Id, Map<String, Set<String>>> aggreagteArticles(List<sObject> faqs) {
        Map<Id, Map<String, Set<String>>> articlesInfo = new Map<Id, Map<String, Set<String>>>();
        for (sObject article : faqs) {
            Map<String, Set<String>> articleParams = aggreagteArticleInfo(
                articlesInfo.get((String)(article.getSObject('Parent').Id)),
                (String)article.get('DataCategoryGroupName'),
                (String)article.get('DataCategoryName'),
                article.getSObject('Parent').Id,
                (String)article.getSObject('Parent').get('Language')
            );
            if (articleParams != null) {
                articlesInfo.put((String)(article.getSObject('Parent').Id), articleParams);
            }
        }
        return articlesInfo;
    }

    public static Map<String, Set<String>> aggreagteArticleInfo(Map<String, Set<String>> articleParams, String dataCategoryGroupName, String dataCategoryName, Id articleId, String language) {
        if (('Provider_Type').equalsIgnoreCase(dataCategoryGroupName) &&
            !(Label.Non_DfD_Provider_Type).equalsIgnoreCase(dataCategoryName + '__c')) {
            return null;
        }
        if (articleParams == null) {
            articleParams = new Map<String, Set<String>>();
        }
        Set<String> articleLanguages = articleParams.get('Language');
        if (articleLanguages == null) {
            articleLanguages = new Set<String>();
        }
        articleLanguages.add(language);
        Set<String> articleGroups = articleParams.get(dataCategoryGroupName);
        if (articleGroups == null) {
            articleGroups = new Set<String>();
        }
        articleGroups.add((dataCategoryGroupName.equalsIgnoreCase('Provider_Type')) ? dataCategoryName + '__c' : dataCategoryName);

        articleParams.put('Language', articleLanguages);
        articleParams.put(dataCategoryGroupName, articleGroups);

        return articleParams;
    }

    public static Integer calculateArticlesCount(Map<Id, Map<String, Set<String>>> aggregatedArticles, String articleDataCategory, String countryCode, String languageCode) {
        Integer articleCount = 0;
        for (Map<String, Set<String>> articlesInfo : aggregatedArticles.values()) {
            Boolean isArticleTypeExist = false;
            for (String contentType : articlesInfo.get('Content_type')) {
                if (contentType.equalsIgnoreCase(articleDataCategory)) {
                    isArticleTypeExist = true;
                    break;
                }
            }
            Boolean isArticleCountryExist = false;
            for (String country : articlesInfo.get('Region')) {
                if (country.equalsIgnoreCase(countryCode)) {
                    isArticleCountryExist = true;
                    break;
                }
            }
            Boolean isArticleLanguageExist = false;
            for (String language : articlesInfo.get('Language')) {
                if (language.equalsIgnoreCase(languageCode)) {
                    isArticleLanguageExist = true;
                    break;
                }
            }
            if (isArticleTypeExist && isArticleCountryExist && isArticleLanguageExist) {
                articleCount++;
            }
        }
        return articleCount;
    }

    public static Map<String, Integer> setHelpArticlesCountOrgCache(){
        List<String> articleTypes = KnowledgeBaseHelper.getArticleTypes('__datacategoryselection');
        Map<Id, Map<String, Set<String>>> aggregatedArticles = new Map<Id, Map<String, Set<String>>>();
        for (String articleType : articleTypes) {
            String queryStr = 'Select Id, DataCategoryName, DataCategoryGroupName, Parent.Id, Parent.Language '+
                'From ' + articleType + ' '+
                'Where Parent.PublishStatus = \'Online\' AND Parent.Exclude_From_Search__c = false';
            try {
                aggregatedArticles.putAll(KnowledgeBaseHelper.aggreagteArticles(Database.query(queryStr)));
            } catch(Exception e) {}
        }
        
        Map<String, Integer> articlesCount = new Map<String, Integer>();
        List<String> articleDataCategories = new List<String>{ 'Getting_Started_HP', 'Watching_DAZN_HP', 'Manage_My_Account_HP', 'Technical_issues_HP', 'FAQ' };
        List<DAZN_Help_Redirect__c> countryLangSettings = [Select CountryISOCode__c, Language__c From DAZN_Help_Redirect__c];
        for (String articleDataCategory : articleDataCategories) {
            for (DAZN_Help_Redirect__c countryLang : countryLangSettings) {
                String sCountry = countryLang.CountryISOCode__c;
                String sLanguage = countryLang.Language__c;
                sLanguage = (sLanguage.startsWithIgnoreCase('en')) ? ((sCountry.startsWithIgnoreCase('CA')) ? 'en_US' : 'en_GB') : sLanguage;
                
                String mapKey = articleDataCategory + sCountry + sLanguage;
                mapKey = mapKey.replaceAll('_', '');
                Integer articleCount = articlesCount.get(mapKey);
                if (articleCount == null || articleCount < 0) {
                    articleCount = 0;
                }
                articleCount += KnowledgeBaseHelper.calculateArticlesCount(aggregatedArticles, articleDataCategory, sCountry, sLanguage);
                articlesCount.put(mapKey, articleCount);
            }
        }
        
        Cache.OrgPartition orgPart = Cache.Org.getPartition('local.HelpArticlesCount');
        for (String articleCountKey : articlesCount.keySet()) {
            orgPart.put(articleCountKey, String.valueOf(articlesCount.get(articleCountKey)));
            System.debug(articleCountKey + ' - ' + (String)orgPart.get(articleCountKey));
        }

        return articlesCount;
    }
}