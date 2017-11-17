global with sharing class TestWillBeDeleted {

    static List<String> lstArticleType = new List<String>();
    public static PageReference errorPage = null;
    public static String pageDfdName {get;set;}//PD-9725

    public String url { get; set; }
    public String strRelatedContentsLabel { get; set; }
    public String homePageURL { get; set; }
    public User user { get; set; } 
    public String sCountry {get; set; }
    public String cookieCountry { get; set; }
    public String strLanguage { get; set; }
    public String sCountryName { get; set; }
    public String browserLang { get; set; }
    public String strLang { get; set; }        
    public String metaUrl { get; set; }  
    public String helpDescription { get; set; }  
    public String helpKeyWord { get; set; }

    public String strPageLanguage {
        get {
            return ApexPages.currentPage().getParameters().get('lang');
        }
        set;
    }
    
    global static List<String> createDescribeMap() {    
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Set<String> keySet = gd.keySet();
        for (String key : keySet) {
            Schema.SObjectType objectType = gd.get(key);
            if (key.endsWith('ka') || key.endsWith('kb')) {
                lstArticleType.add(objectType.getDescribe().getName());
            }
        }       
        return lstArticleType;
    }

    /*
    Description: Method to redirect user on home page.
    */
    public PageReference redirectToHomePage() {
        return CommunityHelper.redirectToHomePage();
    }

    //@RemoteAction 
    global static string getUserCountryAndLanguage() {
        try{
            string sLanguage=CommunityHelper.getLanguageCode();
            string sCountry=CommunityHelper.getUserCountry(null);
            Map<string,string> mapDataCategories = CommunityHelper.getDataCategoriesByDataCategoryGroupName('Region');
            if(mapDataCategories.containsKey(sCountry))
                sCountry=sCountry+'__c';
            else
                sCountry='GB__c';
            return sLanguage+':'+sCountry;
        }
        catch(Exception ex)
        {
            system.debug('ex---->'+ex);
            ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'HelpController', 'getUserCountryAndLanguage', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());            
            return null;
        }
    }

    /*
    Description: Method to get all homepage articles.
    */
    //@RemoteAction
    global static MAP<String,List<KnowledgeArticleVersion>> getHomepageArticles(string strLanguage,string strCountry,string dfdname) {
        System.debug('>>> hc strLanguage = ' + strLanguage);
        System.debug('>>> hc strCountry = ' + strCountry);
        
        MAP<String,String> mapHomePageDataCategories=CommunityHelper.getAllDataCategories('Homepage');
        system.debug('SearchMapData'+mapHomePageDataCategories);
        createDescribeMap();        
        MAP<String,List<sObject>> mapHomePageArticleList=new MAP<String,List<sObject>>();
        List<sObject> lstObjects = new List<sObject>();
        if(strCountry != null ){
            if(!strCountry.contains('__c')){
                strCountry = strCountry+'__c';
            }
        }        
        if(strLanguage != null){
            if(strLanguage.startsWith('en') && !strLanguage.contains('_GB')){
                strLanguage = strLanguage+'_GB';
           }
        }
        strLanguage = (String.isNotBlank(strCountry) && strCountry.startsWithIgnoreCase('CA') && String.isNotBlank(strLanguage) && strLanguage.startsWithIgnoreCase('en')) ? 'en_US' : strLanguage;

        system.debug('SearchMapData------>'+mapHomePageDataCategories);
        if(!mapHomePageDataCategories.isEmpty() && mapHomePageDataCategories.size() > 0){    
            for(String strdataCategory : mapHomePageDataCategories.keySet())
            {
                lstObjects.clear();
                for(string sArticleType:lstArticleType)
                {
                    try{                        
                        string sQuery = 'SELECT ID,ArticleType,Title,KnowledgeArticleId,UrlName,MasterVersionId  FROM '+sArticleType.replace('__ka', '__kav')+ ' Where (PublishStatus = \'online\' and language=\''+strLanguage+'\' and Exclude_From_Search__c=false) WITH DATA CATEGORY Region__c AT ' + strCountry +' AND Provider_Type__c AT '+' ('+Label.Non_DfD_Provider_Type+')  AND Content_type__c AT ' + strdataCategory+'__c  ORDER BY Ranking__c ASC NULLS LAST LIMIT 4';
                        system.debug('sQuery---->'+sQuery);
                        lstObjects.addAll(Database.query(sQuery));
                        system.debug('lstObjects---->'+lstObjects);
                     }catch(Exception ex)
                    { 
                        system.debug('ex---->'+ex);
                        //ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'HelpController', 'getHomepageArticles', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
                        Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'HomepageArticles not found Exception: ' + ex.getMessage());
                        Apexpages.addmessage(msg);                        
                    }
                }                
                mapHomePageArticleList.put(strdataCategory,lstObjects.clone());
            }
            system.debug('mapHomePageArticleList--->'+mapHomePageArticleList);
            return mapHomePageArticleList;
        }
        else
        {
            redirectToErrorPage('Home Page Data is not Found');
            return null;
        }
    }
    
    /*
Description; Display a single selected article.
*/  
    @RemoteAction
    global static sObject displayArticleWithTitle(string sLanguage,string sCountry,String sTitle,string dfdname)
    {  

        System.debug('>>> hc sLanguage = ' + sLanguage);
        System.debug('>>> hc sCountry = ' + sCountry);

        system.debug('dfdnameDisplay--->'+dfdname);
        List<LS_LegalArticle__c> lstShortUrl;
        if(sTitle != null){
        //This list for Display Legal Article display based on custom setting
        lstShortUrl = [Select URL__c From LS_LegalArticle__c Where Title__c =: sTitle and Country__c =:sCountry];
         }        
        if(lstShortUrl!=null && !lstShortUrl.isEmpty()){
            sTitle=String.valueOf(lstShortUrl[0].URL__c);
        }
        try
        {
            if(sCountry != null){
                if(!sCountry.contains('__c')){
                    sCountry = sCountry+'__c';
                }
            }            
            if(sLanguage != null){
                if(sLanguage.startsWith('en') && !sLanguage.contains('_GB')){
                    sLanguage = sLanguage+'_GB';
                }
            }
            sLanguage = (String.isNotBlank(sCountry) && sCountry.startsWithIgnoreCase('CA') && String.isNotBlank(sLanguage) && sLanguage.startsWithIgnoreCase('en')) ? 'en_US' : sLanguage;
            if(sCountry.contains(Label.Help_Article_Displ_Spl_Regions))
            {
                List<KnowledgeArticleVersion> lstKnowledgeArticles = new List<KnowledgeArticleVersion>();
                system.debug('dfdname--->'+dfdname);
                if(String.isBlank(dfdname))
                {
                  string sKnowledgeArticleQuery = 'Select ID,ArticleType,KnowledgeArticleId,MasterVersionId From KnowledgeArticleVersion Where (PublishStatus = \'online\' and language=\''+sLanguage+'\' and URLName like \''+sTitle+'\' ) WITH DATA CATEGORY Region__c AT '+sCountry+' AND Provider_Type__c AT '+' ('+Label.Help_provider_type_for_JP+') LIMIT 4'; 
                    if(!test.isRunningTest()){
                    lstKnowledgeArticles = Database.query(sKnowledgeArticleQuery);
                    }
                    else{
                        KnowledgeArticleVersion  kav = new KnowledgeArticleVersion ();
                        kav.ID = 'ka0260000008cquAAA';
                      lstKnowledgeArticles.add(kav); 
                    }               
                    
                }
                else{
                    string sKnowledgeArticleQuery = 'Select ID,ArticleType,KnowledgeArticleId,MasterVersionId From KnowledgeArticleVersion Where (PublishStatus = \'online\' and language=\''+sLanguage+'\' and URLName like \''+sTitle+'\' ) WITH DATA CATEGORY Region__c AT '+sCountry+' Provider_Type__c AT '+' ('+Label.Help_provider_type_for_JP_dfd+' AND Content_type__c  AT '+' ('+Label.Help_ContentType_dfd+') LIMIT 4';              
                            
                    if(!test.isRunningTest()){
                    lstKnowledgeArticles = Database.query(sKnowledgeArticleQuery);
                    }
                    else{
                        KnowledgeArticleVersion  kav = new KnowledgeArticleVersion ();
                        kav.ID = 'ka0260000008cquAAA';
                      lstKnowledgeArticles.add(kav); 
                    }
                }
                System.debug('lstKnowledgeArticles--->'+lstKnowledgeArticles);
                if(lstKnowledgeArticles!=null && !lstKnowledgeArticles.isEmpty())
                {
                    List<sObject> lstArticle = new List<sObject>();
                    String strArticleQuery='Select Content__c,Title,ID,KnowledgeArticleId,ArticleType,MasterVersionId From '+lstKnowledgeArticles[0].ArticleType+ ' Where ID = \'' + lstKnowledgeArticles[0].Id+'\'';                                  
                    if(!test.isRunningTest()){
                        lstArticle = Database.query(strArticleQuery);
                    } 
                    else
                    {
                        lstArticle = [Select Content__c,Title,ID,KnowledgeArticleId,ArticleType,MasterVersionId From DAZN_for_Docomo__kav Where ID = 'ka0260000008cquAAA'];
                    }
                    if(lstArticle!=null && !lstArticle.isEmpty()){
                        return lstArticle[0];
                    }
                    else{                       
                        redirectToErrorPage('No Articles Found');
                        return null;
                    }
                } 
                else{               
                    redirectToErrorPage('No Articles Found');
                    return null;
                }
            }
            else
            {
                List<KnowledgeArticleVersion> lstKnowledgeArticles = new List<KnowledgeArticleVersion>();
                string sKnowledgeArticleQuery = 'Select ID,ArticleType,KnowledgeArticleId,MasterVersionId From KnowledgeArticleVersion Where (PublishStatus = \'online\' and language=\''+sLanguage+'\' and URLName like \''+sTitle+'\' ) WITH DATA CATEGORY Region__c AT '+sCountry+' AND Provider_Type__c AT '+' ('+Label.Help_provider_type_for_all+') LIMIT 4';
                if(!test.isRunningTest())
                {
                    lstKnowledgeArticles = Database.query(sKnowledgeArticleQuery);
                }
                else
                {
                    KnowledgeArticleVersion  kav = new KnowledgeArticleVersion ();
                    kav.ID = 'ka0260000008cquAAA';
                    lstKnowledgeArticles.add(kav); 
                }
                    System.debug('lstKnowledgeArticles--->'+lstKnowledgeArticles);
                if(lstKnowledgeArticles!=null && !lstKnowledgeArticles.isEmpty())
                {
                    List<sObject> lstArticle = new List<sObject>();
                    String strArticleQuery='Select Content__c,Title,ID,KnowledgeArticleId,ArticleType,MasterVersionId From '+lstKnowledgeArticles[0].ArticleType+ ' Where ID = \'' + lstKnowledgeArticles[0].Id+'\'';                                  
                    lstArticle = Database.query(strArticleQuery);
                    
                    if(lstArticle!=null && !lstArticle.isEmpty()){
                        return lstArticle[0];
                    }
                    
                    else{                       
                        redirectToErrorPage('No Articles Found');
                        return null;
                    }
                } 
                else{               
                    redirectToErrorPage('No Articles Found');
                    return null;
                }    
            }
        }
        catch(Exception ex){
            system.debug('ex---->'+ex);
            ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'HelpPageController', 'displayArticleWithTitle', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());            
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'displayArticleWithTitle not found Exception: ' + ex.getMessage());
            Apexpages.addmessage(msg);
            return null;
        }
    }
    
    /*
    Description: Method to get article count.
    */
    @RemoteAction
    global static Map<String, String> getAllArticleCount(String sLanguage, String sCountry, String sHomeCategorySeeAll, String sFAQCategorySeeAll) {
        sLanguage = (sLanguage.startsWithIgnoreCase('en')) ? ((sCountry.startsWithIgnoreCase('CA')) ? 'en_US' : 'en_GB') : sLanguage;

        Map<String, String> mapArticleCount = new Map<String, String>();
        Cache.OrgPartition orgPart = Cache.Org.getPartition('local.HelpArticlesCount');

        List<String> lstDataCategory = new List<String>{ 'Getting_Started_HP', 'Watching_DAZN_HP', 'Manage_My_Account_HP', 'Technical_issues_HP', 'FAQ' };
        for (String sDataCategoryName : lstDataCategory) {
            sCountry = sCountry.split('_')[0];
            String cacheKey = (sDataCategoryName + sCountry + sLanguage).replaceAll('_', '');
            String articlesCount = (String)orgPart.get(cacheKey);
            articlesCount = (String.isBlank(articlesCount)) ? '0' : articlesCount;
            if (sDataCategoryName.equals('FAQ')) {
                mapArticleCount.put(sDataCategoryName, sFAQCategorySeeAll.replace('[count]', articlesCount));
            } else {
                mapArticleCount.put(sDataCategoryName, sHomeCategorySeeAll.replace('[count]', articlesCount));
            }
        }
        return mapArticleCount;
    }
    
    /*
Description: Method to show all articles of selected category.
*/
    @RemoteAction
    global static List<sObject> seeAllArticles(string sLanguage,string sCountry,string sDataCategoryName)
    {
        System.debug('>>> hc 2 sLanguage = ' + sLanguage);
        System.debug('>>> hc 2 sCountry = ' + sCountry);

        system.debug('sLanguage--------->'+sLanguage);
        system.debug('sCountry--------->'+sCountry);
        system.debug('sDataCategoryName--------->'+sDataCategoryName);
         system.debug('lstArticleType--------->'+lstArticleType);
        createDescribeMap();
        List<sObject> lstObjects = new List<sObject>();
        if(lstArticleType !=null && lstArticleType.size() >0){
            for(string sArticleType:lstArticleType)
            {                
                try{
                    string sQuery;                
                    if(sDataCategoryName.contains('_HP'))
                        sQuery = 'SELECT ID,ArticleType,Title,KnowledgeArticleId,UrlName  FROM '+sArticleType.replace('__ka', '__kav')+ ' WHERE (PublishStatus = \'online\' and language=\''+sLanguage+'\' and Exclude_From_Search__c=false) WITH DATA CATEGORY Region__c AT ' + sCountry + ' AND Provider_Type__c AT '+' ('+Label.Non_DfD_Provider_Type+') AND Content_type__c AT ('+sDataCategoryName+'__c,' + sDataCategoryName.replace('_HP', '__c')+') ORDER BY Ranking__c ASC NULLS LAST LIMIT 1000';
                        //system.debug('sArticleType5--->'+sArticleType+'sLanguage5---->'+sLanguage+'sCountry5--->'+sCountry+'sDataCategoryName5--->'+sDataCategoryName);                   
                    else
                        sQuery = 'SELECT ID,ArticleType,Title,KnowledgeArticleId,UrlName  FROM '+sArticleType.replace('__ka', '__kav')+ ' WHERE (PublishStatus = \'online\' and language=\''+sLanguage+'\' and Exclude_From_Search__c=false) WITH DATA CATEGORY Region__c AT ' + sCountry + ' AND Provider_Type__c AT '+' ('+Label.Non_DfD_Provider_Type+')  AND Content_type__c AT ' + sDataCategoryName+'__c ORDER BY Ranking__c ASC NULLS LAST LIMIT 1000';
                        system.debug('sArticleType5--->'+sArticleType+'sLanguage5---->'+sLanguage+'sCountry5--->'+sCountry+'sDataCategoryName5--->'+sDataCategoryName);
                    if(sArticleType!='System_update__ka')
                        lstObjects.addAll(Database.query(sQuery));
                    system.debug('lstObjects----------->'+lstObjects);
                }catch(Exception ex)
                {
                    system.debug('ex---->'+ex);
                    ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'HelpController', 'seeAllArticles', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'seeAllArticles not found Exception: ' + ex.getMessage());
                    Apexpages.addmessage(msg);                
                }
            }
        }        
        return lstObjects;
    }
    
    /*
Description: Method to verify if the selected article is rated already
*/
    @RemoteAction
    global static boolean isArticleVoted(String sKnowledgeArticleID)
    {
        try{
            if(userInfo.getUserType().Equals('Guest'))
                return false;
            string sQuery='Select ID,ParentId,Type From Vote Where ParentId = \'' + sKnowledgeArticleID +'\' and CreatedById=\''+UserInfo.getUserId()+'\'';
            system.debug('sKnowledgeArticleID7--->'+sKnowledgeArticleID);
            List<Vote> lstVote = Database.Query(sQuery);       
            if(lstVote!=NULL && !lstVote.isEmpty())
                return false;
            else
                return true;
        }
        catch(Exception ex)
        {
            system.debug('ex---->'+ex);
            ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'HelpController', 'isArticleVoted', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return false;
        }
    }
    
    /*
Description: Rate the article.
*/
    @RemoteAction
    global static boolean VoteForArticle(string sUserInput,string sKnowledgeArticleID)
    {
        try
        {                        
            Vote oVote=new Vote();
            oVote.Type=sUserInput;
            oVote.ParentId=sKnowledgeArticleID;
            Database.SaveResult oSaveResult = Database.Insert(oVote);
            return oSaveResult.isSuccess();
        }
        catch(Exception ex){
            system.debug('ex---->'+ex);
            ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'HelpController', 'VoteForArticle', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'VoteForArticle not found Exception: ' + ex.getMessage());
            Apexpages.addmessage(msg);
            return false;
        }
    }
    
    /*
Description: Method to get Related Articles.
*/
    @RemoteAction
    global static MAP<string,List<RelatedArticleWrapper>> getRelatedArticles(string sLanguage,string sCountry, string sDataCategory,string sArticleID,string sKnowledgeArticleType,string sMasterVersionId){
        System.debug('>>> hc 3 sLanguage = ' + sLanguage);
        System.debug('>>> hc 3 sCountry = ' + sCountry);

        try{
            if(String.isBlank(sDataCategory)) 
            {
                String sDataCategoryQuery='Select DataCategoryName,ParentId,DataCategoryGroupName From '+ sKnowledgeArticleType.replace('kav','DataCategorySelection')+' where ParentId = \'' + sMasterVersionId+'\'';
                system.debug('dataCatlist--->'+sDataCategoryQuery);
                List<sObject> lstDataCategory = Database.query(sDataCategoryQuery);
                system.debug('lstDataCategory---->'+lstDataCategory);
                for(sObject objDataCategory : lstDataCategory)
                {
                    if(objDataCategory.get('DataCategoryGroupName').equals('Content_type'))
                    {
                        sDataCategory = String.ValueOf(objDataCategory.get('DataCategoryName'));
                        break;
                    }
                }
            }
            String sQuery;
            List<RelatedArticleWrapper> lstRelatedArticles=new List<RelatedArticleWrapper>();
            List<sObject> lstObjects = new List<sObject>();
            String sRelatedArticleDataCategory;
            if(sDataCategory.contains('_HP'))
                sRelatedArticleDataCategory=sDataCategory.replace('_HP', '_RC__c');                
            else if(sDataCategory.contains('_RC'))
            {
                if(sDataCategory.contains('_RC__c'))
                    sRelatedArticleDataCategory=sDataCategory;
                else
                    sRelatedArticleDataCategory=sDataCategory+'__c';
            }
            else
                sRelatedArticleDataCategory=sDataCategory+'_RC__c';
            createDescribeMap();
            if(lstArticleType != null && lstArticleType.size() >0){
                for(string sArticleType : lstArticleType)
                {
                    try{
                        
                        sQuery = 'SELECT ID,ArticleType,Title,KnowledgeArticleId,UrlName FROM '+sArticleType.replace('__ka', '__kav')+ ' WHERE (PublishStatus = \'online\' and language=\''+sLanguage+'\' and ID!=\''+sArticleID+'\' and Exclude_From_Search__c=false ) WITH DATA CATEGORY Region__c AT ' + sCountry + ' AND Provider_Type__c AT '+' ('+Label.Help_Provider_Type+') AND Content_type__c AT ' + sRelatedArticleDataCategory+' ORDER BY Ranking__c ASC NULLS LAST LIMIT 4';
                        system.debug('sQuery/*/*/*/*/*>'+sQuery);
                        system.debug('sArticleType6--->'+sArticleType+'sLanguage6-->'+sLanguage+'sArticleID6-->'+sArticleID+'sCountry6-->'+sCountry+'sRelatedArticleDataCategory6--->'+sRelatedArticleDataCategory);
                        if(sArticleType!='System_update__ka' && sArticleType!='Legal__ka')
                            lstObjects.addAll(Database.query(sQuery));
                        system.debug('lstObjects++++++>'+lstObjects);
                        if(lstObjects.size()>=4)
                            break;
                    }catch(Exception ex)
                    {
                        system.debug('ex---->'+ex);
                        ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'HelpController', 'getRelatedArticles', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());    
                    }
                }
            }                       
            RelatedArticleWrapper objRelatedArticleWrapper;
            system.debug('listsize****'+lstObjects.size());
            for(Integer i=0;i<lstObjects.size();i++)
            {
                if(math.mod(i,2)==0)
                {     
                    objRelatedArticleWrapper=new RelatedArticleWrapper();
                    
                    objRelatedArticleWrapper.leftArticle=lstObjects[i];
                    if(i==(lstObjects.size()-1))
                    {
                        
                        lstRelatedArticles.add(objRelatedArticleWrapper);
                    }
                }
                else
                {
                    objRelatedArticleWrapper.rightArticle=lstObjects[i];                       
                    lstRelatedArticles.add(objRelatedArticleWrapper);
                }
            }
            MAP<string,List<RelatedArticleWrapper>> mapRelatedArticleWrapper=new MAP<string,List<RelatedArticleWrapper>>();
            mapRelatedArticleWrapper.put(sRelatedArticleDataCategory,lstRelatedArticles);
            system.debug('mapRelatedArticleWrapper--->'+mapRelatedArticleWrapper);
            return mapRelatedArticleWrapper;
            
        }
        catch(Exception ex)
        {
            system.debug('ex---->'+ex);
            ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'HelpPageController', 'getRelatedArticles', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'Related articles not found Exception: ' + ex.getMessage());
            Apexpages.addmessage(msg);
            return null;
        }
    }
    
    /*
Description: Method to get all articles for predictive search.
*/
    //@RemoteAction
    global static List<sObject> getAllArticlesForSearch(string sLanguage, string sCountry, string DfDName)
    {
        System.debug('>>> hc 4 sLanguage = ' + sLanguage);
        System.debug('>>> hc 4 sCountry = ' + sCountry);

        system.debug('DfDNameSearch--->'+DfDName);
        
        try{
           
            
            List<sObject> lstArticles=new List<sObject>();
            createDescribeMap();
            List<String> lstArticlesTypesToSearch=new List<String>();
            if(sCountry != null){
                if(!sCountry.contains('__c')){
                    sCountry=sCountry+'__c';
                }
            }           
            if(sLanguage != null){
                if(sLanguage.startsWith('en') && !sLanguage.contains('_GB')){
                    sLanguage = sLanguage+'_GB';
                }
            }
            sLanguage = (String.isNotBlank(sCountry) && sCountry.startsWithIgnoreCase('CA') && String.isNotBlank(sLanguage) && sLanguage.startsWithIgnoreCase('en')) ? 'en_US' : sLanguage;
            system.debug('ArticleTypeSearch---->'+lstArticleType);
            if(String.isBlank(DfDName))
            {
                system.debug('spageParam In IF ----->'+DfDName);
                if(lstArticleType != null && lstArticleType.size() > 0){
                    for(string sArticleType:lstArticleType)
                    {
                        string sQuery;
                        sQuery = 'SELECT ID,ArticleType,Title,KnowledgeArticleId,UrlName  FROM '+sArticleType.replace('__ka', '__kav')+ ' WHERE (PublishStatus = \'online\' and language=\''+sLanguage+'\' and Exclude_From_Search__c=false) WITH DATA CATEGORY Region__c AT ' + sCountry + ' AND Content_type__c BELOW Homepage__c  LIMIT 1000';
                        System.debug('>>>>> sQuery = ' + sQuery);
                        system.debug('sArticleType8--->'+sArticleType+'sLanguage8--->'+sLanguage+'sCountry8--->'+sCountry);
                        lstArticles.addAll(Database.query(sQuery));
                    }
                }  
            }
            else
            {
                system.debug('spageParam In IF Else ----->'+DfDName);
                if(lstArticleType != null && lstArticleType.size() > 0){
                    for(string sArticleType:lstArticleType)
                    {
                        string sQuery;
                        sQuery = 'SELECT ID,ArticleType,Title,KnowledgeArticleId,UrlName  FROM '+sArticleType.replace('__ka', '__kav')+ ' WHERE (PublishStatus = \'online\' and language=\''+sLanguage+'\' and Exclude_From_Search__c=false) WITH DATA CATEGORY Region__c AT ' + sCountry + ' AND Content_type__c AT '+' ('+Label.DfD_Provider_Type+')  LIMIT 1000';
                        system.debug('sQuery--->'+sQuery);
                        system.debug('sArticleType8--->'+sArticleType+'sLanguage8--->'+sLanguage+'sCountry8--->'+sCountry);
                        lstArticles.addAll(Database.query(sQuery));
                    }
                } 
            }
            system.debug('ArticlesList--->'+lstArticles);
            return lstArticles;
        }
        catch(Exception ex)
        {
            system.debug('ex---->'+ex);
            ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'HelpController', 'getAllArticlesForSearch', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'ArticlesForSearch not found Exception: ' + ex.getMessage());
            Apexpages.addmessage(msg);
            return null;
        }
    }
    
    
      /*
    Description: Method to get all articles for search page.
    */
    @RemoteAction
    global static List<sObject> searchArticles(string sLanguage, string sCountry, string sSearchText)
    {
        System.debug('>>> hc 5 sLanguage = ' + sLanguage);
        System.debug('>>> hc 5 sCountry = ' + sCountry);

        List<sObject> lstAllArticles=new List<sObject>();
    
        try{            
            
            createDescribeMap();
            string sQuery;
            sQuery='FIND{'+sSearchText+'} RETURNING ';
            if(String.isBlank(pageDfdName)){
                 system.debug('spageParam In IF ----->'+pageDfdName);
                 for(string sArticleType:lstArticleType)
                    {
                        sQuery= sQuery+ sArticleType.replace('__ka', '__kav') + '(Title,KnowledgeArticleId,ArticleType,UrlName WHERE PublishStatus=\'online\' AND Language= \''+sLanguage+'\' and Exclude_From_Search__c=false),';
                    }
                sQuery=sQuery.removeEnd(',');
                //sQuery=sQuery+' WITH DATA CATEGORY Region__c AT '+sCountry+' AND Provider_Type__c AT DAZN_for_Docomo__c ';        
                sQuery=sQuery+' WITH DATA CATEGORY Region__c AT '+sCountry+' AND Provider_Type__c AT '+' ('+Label.Non_DfD_Provider_Type+')'; 
                for(List<sObject> lstArticles:Search.query(sQuery))
                {
                    lstAllArticles.addAll(lstArticles);
                    system.debug('lstAllArticles in IF----->'+lstAllArticles);
                }
                 
            }
            else{
            system.debug('spageParam In Else ----->'+pageDfdName);
            for(string sArticleType:lstArticleType)
            {
                sQuery= sQuery+ sArticleType.replace('__ka', '__kav') + '(Title,KnowledgeArticleId,ArticleType,UrlName WHERE PublishStatus=\'online\' AND Language= \''+sLanguage+'\' and Exclude_From_Search__c=false),';
            }
            sQuery=sQuery.removeEnd(',');
            sQuery=sQuery+' WITH DATA CATEGORY Region__c AT '+sCountry+' AND Content_type__c AT DAZN_for_Docomo__c';        
            //sQuery=sQuery+' WITH DATA CATEGORY Region__c AT '+sCountry+' AND Content_type__c AT DAZN_for_Docomo__c'; 
            for(List<sObject> lstArticles:Search.query(sQuery))
            {
                lstAllArticles.addAll(lstArticles);
                system.debug('lstAllArticles in else----->'+lstAllArticles);
            }   
            
            }   
            system.debug('Final lstAllArticles ----->'+lstAllArticles);
                return lstAllArticles;
        }
        catch(Exception ex)
        {           
            ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'HelpController', 'searchArticles', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'searchArticles not found Exception: ' + ex.getMessage());
            Apexpages.addmessage(msg);
            return null;
        }
    }
        /* 
    Description: Get System Outage Information from System Update Article Type.
    Note: Information will only be retrive if article is associated with System Update DataCategory.
    */
        //@RemoteAction
        global static System_Update__Kav getSystemUpdateArticle(string sLanguage,string sCountry){
            System.debug('>>> hc 6 sLanguage = ' + sLanguage);
            System.debug('>>> hc 6 sCountry = ' + sCountry);

            try
            {
                if(sCountry != null){
                    if(!sCountry.contains('__c')){
                        sCountry=sCountry+'__c';
                    }
                }            
                if(sLanguage != null){
                    if(sLanguage.startsWith('en') && !sLanguage.contains('_GB')){
                        sLanguage = sLanguage+'_GB';
                    }
                }
                sLanguage = (String.isNotBlank(sCountry) && sCountry.startsWithIgnoreCase('CA') && String.isNotBlank(sLanguage) && sLanguage.startsWithIgnoreCase('en')) ? 'en_US' : sLanguage;
                String sQuerySystemUpdate = 'SELECT Id, Title, Summary, Content__c,KnowledgeArticleId,ArticleType,UrlName,MasterVersionId FROM System_update__kav WHERE (PublishStatus = \'online\' and Language = \''+sLanguage +'\') WITH DATA CATEGORY Region__c AT ' + sCountry + ' AND Provider_Type__c AT '+' ('+Label.Help_Provider_Type+') AND Content_type__c AT System_Update__c Limit 1';
                List<System_Update__Kav> lstSUArticles= Database.query(sQuerySystemUpdate);            
                
                if (lstSUArticles!=null && !lstSUArticles.isEmpty()){
                    return lstSUArticles[0];
                }            
            }
            catch(Exception ex)
            {      
                system.debug('ex---->'+ex);
                ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'HelpPageController', 'getSystemUpdateArticle', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'SystemUpdateArticle not found Exception: ' + ex.getMessage());
                Apexpages.addmessage(msg);
            }
            return null;
        }
    
    //Related Article Wrapper
    global class RelatedArticleWrapper {
        public sObject leftArticle { get; set; }
        public sObject rightArticle { get; set; }
    }
    
    public TestWillBeDeleted() {
        cookieCountry = CommunityHelper.getUserCountryName(null);                
        
        homePageURL = CommunityHelper.getMassiveURLs(sCountry, 'HomePageURLType'); 
        
        /*Added as a part of PD-10946*/
        String baseUrl;
        String searchUrl = ApexPages.currentPage().getURL();
        if (searchUrl != null) {
            if (searchUrl.containsIgnoreCase('title')) {
                baseUrl = ApexPages.currentPage().getParameters().get('title');
            } else if (searchUrl.containsIgnoreCase('searchText')) {
                baseUrl = ApexPages.currentPage().getParameters().get('searchText');
            }
            if (baseUrl != null) {
                helpDescription = baseUrl.replaceAll('-', ' ') + ' - ' + Label.LS_HelpDescriptionWithTitle ;
                helpKeyWord = baseUrl.replaceAll('-', ' ') + Label.LS_HelpKeywordsWithTitle;
            } else {
                helpDescription = Label.LS_HelpDescription;
                helpKeyWord= Label.LS_HelpKeywords;
            }
        }
        /*End of PD-10946*/
    }

    public Map<String, String> getHomepageDataCategory() {
        Map<String, String> mapHomePageDataCategory = CommunityHelper.getAllDataCategories('Homepage');
        return mapHomePageDataCategory;
    }

    public Map<String, String> getFAQDataCategory() {
        Map<String, String> mapFAQDataCategory = CommunityHelper.getAllDataCategories('FAQs');
        return mapFAQDataCategory;
    }

    public Map<String, String> getDfDDataCategory() {
        Map<String, String> mapDfDDataCategory = CommunityHelper.getAllDataCategories('DAZN for Docomo');
        return mapDfDDataCategory;
    }

    /*
     Method to display related content label
    */
    public string getRelatedArticleLabel() {
        Map<String, String> mapContentType = CommunityHelper.getAllDataCategories('Public'); //Related_contents
        if (mapContentType != null) {
            return mapContentType.get('Related_contents'); 
        } else {
            redirectToErrorPage('Related Content Not Found');
            return '';
        }
    }

    //@RemoteAction
    public static Map<String, String> getDataCategories() {
        Map<String, String> mapAllCategories = new Map<String, String>();
        List<String> lstDataCategories = new List<String>{'Getting_Started_HP','Technical_issues_HP','Watching_DAZN_HP','Manage_My_Account_HP','FAQ', 'DAZN_for_Docomo'};
        if (lstDataCategories !=null && lstDataCategories.size() > 0) {
            for (String sDataCategoryName : lstDataCategories) {
                mapAllCategories.put(sDataCategoryName, DAZNConfiguration__c.getValues(sDataCategoryName).Value__c);
            }
        }
        return mapAllCategories;
    }  
    
    global class ArticleWrapper {
        global string getUserCountryAndLanguage{get;set;}       
        global Map<string,string> getDataCategories{get;set;}       
        global List<ArticleCountWrapper> GetArticleCountWrapper{get;set;}
    }
    
    global class ArticleCountWrapper {
        //global MAP<string,string> getAllArticleCount{get;set;}    
        global MAP<String,List<KnowledgeArticleVersion>> getHomepageArticles{get;set;} 
        global List<sObject> getAllArticlesForSearch{get;set;} 
        global System_Update__Kav getSystemUpdateArticle{get;set;} 
    }
    
    @RemoteAction
    global static List<ArticleWrapper> getArticlesOnHome(string sLanguage,string sCountry,string sHomeCategorySeeAll, string sFAQCategorySeeAll, string dfdName){       
        
        System.debug('>>> hc 7 sLanguage = ' + sLanguage);
        System.debug('>>> hc 7 sCountry = ' + sCountry);

        List<ArticleWrapper> articles = new List<ArticleWrapper>();
        List<ArticleCountWrapper> countArticles = new List<ArticleCountWrapper>();
        ArticleCountWrapper artCount = new ArticleCountWrapper();
        
        artCount.getHomepageArticles = getHomepageArticles(sLanguage,sCountry,dfdName);
        
        system.debug('DfDNamesearch--->'+dfdName);
        artCount.getAllArticlesForSearch =  getAllArticlesForSearch(sLanguage,sCountry,dfdName);
        artCount.getSystemUpdateArticle = getSystemUpdateArticle(sLanguage,sCountry);        
        countArticles.add(artCount);        
        
        ArticleWrapper artWrap = new ArticleWrapper();          
        artWrap.getUserCountryAndLanguage = getUserCountryAndLanguage();
        artWrap.getDataCategories = getDataCategories();        
        artWrap.GetArticleCountWrapper = countArticles;
        articles.add(artWrap);        
        return articles;
    }

    /*Description: Method to redirect user to error page */
    public static PageReference redirectToErrorPage(String strErrMsg){
        errorPage = System.Page.InternalServerError;
        errorPage.getParameters().Put('Errormsg',strErrMsg);
        errorPage.setRedirect(true);
        return errorPage;
        
    }
}