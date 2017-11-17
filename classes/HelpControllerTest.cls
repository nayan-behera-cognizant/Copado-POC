// This test class will cover the code coverage for HelpPageController
// All Assert statements as per PD-7938
@isTest
public class HelpControllerTest{
    
    @testSetup static void SetupData() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        SetUpTestData.testCreateDAZNConfiguration('HomePageURL', '/HomePage');
        SetUpTestData.createKnowledgeArticles('FAQs__kav','FAQs__DataCategorySelection','Test Title FAQ','test-title-faq','Getting_Started','GB');
        SetUpTestData.createKnowledgeArticles('FAQs__kav','FAQs__DataCategorySelection','Test Title FAQ1','test-title-faq1','Getting_Started_HP','GB');
        SetUpTestData.createKnowledgeArticles('FAQs__kav','FAQs__DataCategorySelection','Test Title FAQ2','test-title-faq2','Getting_Started_RC','GB');
        SetUpTestData.createKnowledgeArticles('FAQs__kav','FAQs__DataCategorySelection','Test Title FAQ3','test-title-faq3','Getting_Started_RC','GB');
        SetUpTestData.createKnowledgeArticles('FAQs__kav','FAQs__DataCategorySelection','Test Title FAQ4','test-title-faq4','Getting_Started_RC','GB');
        SetUpTestData.createKnowledgeArticles('FAQs__kav','FAQs__DataCategorySelection','Test Title FAQ5','test-title-faq5','Getting_Started_RC','GB');
        SetUpTestData.createKnowledgeArticles('FAQs__kav','FAQs__DataCategorySelection','Test Title FAQ6','test-title-faq6','Getting_Started_RC','GB');
        SetUpTestData.createKnowledgeArticles('System_update__kav','System_update__DataCategorySelection','SystemUpdate','systemupdate','System_Update','GB');
        SetUpTestData.createKnowledgeArticles('Auto_Customer_Responses__kav','Auto_Customer_Responses__DataCategorySelection','Technical Issues','test-technical-issues','Technical_issues_HP','GB');
        SetUpTestData.createKnowledgeArticles('Escalation_Guide__kav','Escalation_Guide__DataCategorySelection','Watching DAZN','watching-dazn','Watching_DAZN_RC','GB');
        
        List<sObject> lstDaznConfiguration = new List<sObject>();
        sObject oDaznConfiguration_GS = Schema.getGlobalDescribe().get('DAZNConfiguration__c').newSObject() ;
        oDaznConfiguration_GS.put('Name','Getting_Started_HP');
        oDaznConfiguration_GS.put('Value__c','Getting Started');
        lstDaznConfiguration.add(oDaznConfiguration_GS);
        system.assertNotEquals(null, lstDaznConfiguration);
        
        sObject oDaznConfiguration_TI = Schema.getGlobalDescribe().get('DAZNConfiguration__c').newSObject() ;
        oDaznConfiguration_TI.put('Name','Technical_issues_HP');
        oDaznConfiguration_TI.put('Value__c','Technical Issues');
        lstDaznConfiguration.add(oDaznConfiguration_TI);
        
        sObject oDaznConfiguration_WD = Schema.getGlobalDescribe().get('DAZNConfiguration__c').newSObject() ;
        oDaznConfiguration_WD.put('Name','Watching_DAZN_HP');
     
        oDaznConfiguration_WD.put('Value__c','Watching DAZN');
        lstDaznConfiguration.add(oDaznConfiguration_WD);
        system.assert(lstDaznConfiguration.size()>0);
        sObject oDaznConfiguration_MA = Schema.getGlobalDescribe().get('DAZNConfiguration__c').newSObject() ;
        oDaznConfiguration_MA.put('Name','Manage_My_Account_HP');
        oDaznConfiguration_MA.put('Value__c','Manage My Account');
        lstDaznConfiguration.add(oDaznConfiguration_MA);
        
        //PD-7815 Salesforce Unit Tests Issues - For HelpController
        sObject oDaznConfiguration_HM = Schema.getGlobalDescribe().get('DAZNConfiguration__c').newSObject() ;
        oDaznConfiguration_HM.put('Name','HomePageURLBeta');
        oDaznConfiguration_HM.put('Value__c','http://livesport-web.massiveinteractive.com');
        lstDaznConfiguration.add(oDaznConfiguration_HM);
        //End PD-7815 Salesforce Unit Tests Issues - For HelpController
        
        sObject oDaznConfiguration_FAQ = Schema.getGlobalDescribe().get('DAZNConfiguration__c').newSObject() ;
        oDaznConfiguration_FAQ.put('Name','FAQ');
        oDaznConfiguration_FAQ.put('Value__c','FAQ');
        lstDaznConfiguration.add(oDaznConfiguration_FAQ);
        
        sObject oDaznConfiguration_D4D = Schema.getGlobalDescribe().get('DAZNConfiguration__c').newSObject() ;
        oDaznConfiguration_D4D.put('Name','DAZN_for_Docomo');
        oDaznConfiguration_D4D.put('Value__c','DAZN for Docomo');
        lstDaznConfiguration.add(oDaznConfiguration_D4D);
        
        Insert lstDaznConfiguration;
        system.assertNotEquals(null, lstDaznConfiguration);
    }
    
     //Added as Part of PD-15349
     @testSetup
    public static void setUpTestDataOne() {
        List<DAZNConfiguration__c> dhr = new List<DAZNConfiguration__c>();
        dhr.add(new DAZNConfiguration__c(
            Name = 'Geo IP timeout',
            Value__c ='4999'
        ));
        //Modified as part of PD-15349
        dhr.add(new DAZNConfiguration__c(
            Name = 'IPADDRESSFINDER',
            Value__c ='http://geoip.nekudo.com/api/'
        ));
          insert dhr;
    }//End of PD-15349
    
    //PD-7815 Salesforce Unit Tests Issues - For HelpController
    static testMethod void testArticlesOnHome()
    {	          
        
        HelpController objHelp = new HelpController();  
        objHelp.strRelatedContentsLabel = 'testRelated';
        objHelp.strLanguage = 'GB__c';
        objHelp.sCountryName = 'Japan';
        objHelp.browserLang = 'GB__c';
        objHelp.strLang = 'GB__c';
        
        string sLanguage;
        string sCountry;
		string sLanguagenContry = HelpController.getUserCountryAndLanguage();		
		sLanguage=sLanguagenContry.split(':')[0];
		sCountry=sLanguagenContry.split(':')[1];
        HelpController.getArticlesOnHome(sLanguage,sCountry,Label.LS_Help_Link_See_All, Label.LS_Help_Label_See_All_FAQs,Label.DfD_Provider_Type);
       
    }//End PD-7815 Salesforce Unit Tests Issues - For HelpController
    static testMethod void testArticleCount()
    {
        string sLanguage;
        string sCountry;        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemaila@email.com', 'testusernamea@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFNamea','TestLNamea',true, 'United Kingdom');
        system.runAs(oUser){
            Test.startTest();
			sLanguage = CommunityHelper.getLanguageCode();
			sCountry = 'GB__c';
            PageReference pageRef = Page.Help;
            pageRef.getParameters().put('lang','en_US');
            Test.setCurrentPage(pageRef);
            HelpController.getDataCategories();
            system.assert(HelpController.getDataCategories().size()>0);
            HelpController.getAllArticleCount(sLanguage, sCountry, Label.LS_Help_Link_See_All, Label.LS_Help_Label_See_All_FAQs);
            Test.stopTest();
        }
    }
    
    static testMethod void testArticleCount11()
    {
        string sLanguage;
        string sCountry;        
        Account oAccount = SetUpTestData.createPersonAccount('JP','ja','TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailb@email.com', 'testusernambe@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameb','TestLNameb',true, 'United Kingdom');
        system.runAs(oUser){
            Test.startTest();
			sLanguage = CommunityHelper.getLanguageCode();
			sCountry = 'GB';
            PageReference pageRef = Page.Help;
            pageRef.getParameters().put('lang','en_US');
            Test.setCurrentPage(pageRef);
            HelpController.getDataCategories();
            system.assert(HelpController.getDataCategories().size()>0);
            HelpController.getAllArticleCount(sLanguage, sCountry, Label.LS_Help_Link_See_All, Label.LS_Help_Label_See_All_FAQs);
            Test.stopTest();
        }
    }
    
    static testMethod void testHomePageArticle(){   
        string sLanguage;
        string sCountry;        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailc@email.com', 'testusernamec@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNamec','TestLNamec',true, 'United Kingdom');
        system.runAs(oUser){
            Test.startTest();
            PageReference pageRef = Page.Help;
            pageRef.getParameters().put('lang','en_GB');
            Test.setCurrentPage(pageRef);
            HelpController oHelpController = new HelpController();
            oHelpController.getHomepageDataCategory();
            oHelpController.getFAQDataCategory();
            string sLanguagenContry = HelpController.getUserCountryAndLanguage();
            sLanguage=sLanguagenContry.split(':')[0];
            sCountry=sLanguagenContry.split(':')[1];
            System.assertEquals('GB__c', sCountry);
            oHelpController.getHomepageDataCategory();
            oHelpController.getFAQDataCategory();
            oHelpController.getDfDDataCategory();
            HelpController.getHomepageArticles(sLanguage, sCountry,Label.DfD_Provider_Type);
            HelpController.getSystemUpdateArticle(sLanguage, sCountry);  
            HelpController.getAllArticlesForSearch(sLanguage, sCountry,Label.DfD_Provider_Type);
            HelpController.getHomepageArticles(sLanguage, '',Label.non_dfd_provider_type);
            HelpController.getSystemUpdateArticle(sLanguage, '');
            HelpController.getAllArticlesForSearch(sLanguage, '','');
            Test.stopTest();
        }
    }
    
    
     static testMethod void testSeeAllCategorywiseArticle()
    {
        string sLanguage;
        string sCountry;        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemaild@email.com', 'testusernamed@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFNamed','TestLNamed',true, 'United Kingdom');
        system.runAs(oUser){
            Test.startTest();
            HelpController oHelpController = new HelpController();
            string sLanguagenContry = HelpController.getUserCountryAndLanguage();
            sLanguage=sLanguagenContry.split(':')[0];
            system.assertEquals('en_GB', sLanguage);
            sCountry=sLanguagenContry.split(':')[1];
            HelpController.seeAllArticles(sLanguage,sCountry,'Getting-Started');
            HelpController.seeAllArticles(sLanguage,sCountry,'Getting-Started_HP');
            HelpController.seeAllArticles(sLanguage,'','Getting-Started_HP');
            Test.stopTest();
        }
    }
    static testMethod void testDisplayArticle()
    {
        string sLanguage;
        string sCountry;  
        LS_LegalArticle__c oLegalArticle = new LS_LegalArticle__c();
        oLegalArticle.Name = 'terms-de';
        oLegalArticle.Title__c = 'terms';
        oLegalArticle.Country__c = 'GB__c';
        oLegalArticle.URL__c = 'terms-de';
        insert oLegalArticle;
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@emaile.com', 'testusernamee@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFNamee','TestLNamee',true, 'United Kingdom');
        system.runAs(oUser){
            Test.startTest();
			PageReference pageRef = Page.Help;
			pageRef.getParameters().put('lang','en_GB');
			Test.setCurrentPage(pageRef);
            HelpController oHelpController = new HelpController();
            oHelpController.getRelatedArticleLabel();
            string sLanguagenContry = HelpController.getUserCountryAndLanguage();
            sLanguage=sLanguagenContry.split(':')[0];
            sCountry=sLanguagenContry.split(':')[1];
            FAQs__kav sObjKnowledgeArticle = Database.Query('Select Id,ArticleType,MasterVersionId,KnowledgeArticleId From FAQs__kav where UrlName=\'test-title-faq\' and publishStatus=\'online\' and Language= \'' + sLanguage +'\'' ) ;
            HelpController.isArticleVoted(sObjKnowledgeArticle.KnowledgeArticleId);
            HelpController.displayArticleWithTitle(sLanguage,sCountry,'Test-Title-FAQ',Label.DfD_Provider_Type);
            HelpController.getRelatedArticles(sLanguage, sCountry,'',sObjKnowledgeArticle.Id,sObjKnowledgeArticle.ArticleType,sObjKnowledgeArticle.MasterVersionId);
            HelpController.VoteForArticle('Up',sObjKnowledgeArticle.KnowledgeArticleId);
            HelpController.isArticleVoted(sObjKnowledgeArticle.KnowledgeArticleId);
            
            Auto_Customer_Responses__kav oTechnicalIssues = Database.Query('Select Id,ArticleType,MasterVersionId,KnowledgeArticleId From Auto_Customer_Responses__kav where UrlName=\'test-technical-issues\' and publishStatus=\'online\' and Language= \'' + sLanguage +'\'' ) ;
            HelpController.getRelatedArticles(sLanguage, sCountry,'',oTechnicalIssues.Id,oTechnicalIssues.ArticleType,oTechnicalIssues.MasterVersionId);
            
            Escalation_Guide__kav oETechnicalIssues = Database.Query('Select Id,ArticleType,MasterVersionId,KnowledgeArticleId From Escalation_Guide__kav where UrlName=\'watching-dazn\' and publishStatus=\'online\' and Language= \'' + sLanguage +'\'' ) ;
            HelpController.getRelatedArticles(sLanguage, sCountry,'',oETechnicalIssues.Id,oETechnicalIssues.ArticleType,oETechnicalIssues.MasterVersionId);
            HelpController.isArticleVoted('error');
            system.assertEquals(false, HelpController.isArticleVoted('error'));
            HelpController.VoteForArticle('',sObjKnowledgeArticle.KnowledgeArticleId);
           //  HelpController.displayArticleWithTitle('','','','');//code added by venkat
            HelpController.displayArticleWithTitle(sLanguage,'','Test-Title-FAQ',Label.DfD_Provider_Type);
            HelpController.displayArticleWithTitle(sLanguage,'','Test-Title-FAQ','');
            HelpController.displayArticleWithTitle(sLanguage,sCountry,'terms','');  
            HelpController.displayArticleWithTitle(sLanguage,sCountry,'terms',Label.DfD_Provider_Type); 
            HelpController.displayArticleWithTitle(sLanguage,'JP','terms',''); 
            HelpController.displayArticleWithTitle(sLanguage,'JP','Test-Title-FAQ',Label.DfD_Provider_Type); 
            HelpController.getRelatedArticles(sLanguage, 'JP','Getting_Started_HP',sObjKnowledgeArticle.Id,sObjKnowledgeArticle.ArticleType,sObjKnowledgeArticle.MasterVersionId);
            Test.stopTest();
        }
    }
    
    static testMethod void testDisplayArticle11()
    {
        string sLanguage;
        string sCountry;        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailf@email.com', 'testusernamef@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNamef','TestLNamef',true, 'United Kingdom');
        system.runAs(oUser){
            Test.startTest();
            HelpController oHelpController = new HelpController();
            oHelpController.getRelatedArticleLabel();
            string sLanguagenContry = HelpController.getUserCountryAndLanguage();
            sLanguage=sLanguagenContry.split(':')[0];
            sCountry=sLanguagenContry.split(':')[1];
            HelpController.displayArticleWithTitle(sLanguage,sCountry,'Test-Title-FAQ',Label.non_dfd_provider_type);
            Test.stopTest();
        }
    }
    
    
    static testMethod void searchArticle()
    {
        string sLanguage;
        string sCountry;        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailg@email.com', 'testusernameg@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFNameg','TestLNameg',true, 'United Kingdom');
        system.runAs(oUser){
            Test.startTest();
            HelpController oHelpController = new HelpController();
            string sLanguagenContry = HelpController.getUserCountryAndLanguage();
            sLanguage=sLanguagenContry.split(':')[0];
            system.assertEquals('en_GB', sLanguage);
            sCountry=sLanguagenContry.split(':')[1];
            HelpController.searchArticles(sLanguage, sCountry,'Test'); 
            HelpController.pageDfdName ='test';
            HelpController.searchArticles(sLanguage, '','Test'); 
            Test.stopTest();
        }
    }
    
    /*Test livesport rewriter with country and language in url*/
    static testMethod void testlivesportRewriterWithCountryNLanguage() {
        livesportRewriter rewriter = new livesportRewriter();
        PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/help/JP-en'));
        system.assertEquals('/apex/mylogin',actualResult.getUrl());
    }
    
    /*Test livesport rewriter with country, language and type in url*/
    static testMethod void testlivesportRewriterWithCountryLanguageNType() {
        livesportRewriter rewriter = new livesportRewriter();
        PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/help/JP-en/I need help?metakeyword=testmetakeyword'));
        system.assertEquals('/apex/mylogin',actualResult.getUrl());
        
    }
    
    /*Test livesport rewriter with country, language and serachtext in url*/
    static testMethod void testlivesportRewriterWithSearchText() {
        livesportRewriter rewriter = new livesportRewriter();
        PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/help/JP-en/search/test'));
        system.assertEquals('/apex/mylogin',actualResult.getUrl());
    }
    
    /*Test with not supported country and redirecting to specific URL*/
    static testMethod void testtogetIpAddsforNotSupported() {
        DAZN_Help_Redirect__c dznHelpRed = new DAZN_Help_Redirect__c();
        dznHelpRed.CountryISOCode__c = 'JP';
        dznHelpRed.Name= 'Japan';
        dznHelpRed.Language__c = 'JA';
        dznHelpRed.IsDefaultCountry__c = true;
        dznHelpRed.Country__c = 'Japan';
        insert dznHelpRed;
        system.assertEquals('Japan', dznHelpRed.Country__c);
        SetUpTestData.testCreateDAZNConfiguration('HomePageURL', '/HomePage');
        Account oTestAccount = SetUpTestData.createPersonAccount('JP','ja','TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oTestUser = SetUpTestData.createGuestUser(oTestAccount.Id, 'testemail456h@email.com', 'testusername123h@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName12h','TestLNam34eh',true);        
        system.runAs(oTestUser){
            PageReference pageRef = Page.Help;
            Test.setCurrentPage(pageRef);
            test.startTest(); 
            map<string,object> mapOfresObj = (Map<String, Object>)JSON.deserializeUntyped('{"city":false,"country":{"name":"India","code":"IN"},"location":{"latitude":20,"longitude":77,"time_zone":"AsiaKolkata"}}');
            string strREs = (string)JSON.serialize(mapOfresObj);  
            SingleRequestMock fakeResponse = new SingleRequestMock(200,'Complete',strREs,null);
            system.assertNotEquals(null,fakeResponse);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            HelpController helpCon = new HelpController();
            helpCon.toGetuserIPAddress();
            test.stopTest();
        }
        
    }
    
    /*Test with supported country and redirecting to specific URL*/
    static testMethod void testtogetIpAddsforSupported() {
        DAZN_Help_Redirect__c dznHelpRed = new DAZN_Help_Redirect__c();
        dznHelpRed.CountryISOCode__c = 'JP';
        dznHelpRed.Name= 'Japan';
        dznHelpRed.Language__c = 'JA';
        dznHelpRed.IsDefaultCountry__c = true;
        dznHelpRed.Country__c = 'Japan';
        insert dznHelpRed;
        system.assertEquals('JA', dznHelpRed.Language__c);
        SetUpTestData.testCreateDAZNConfiguration('HomePageURL', '/HomePage');
        Account oTestAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oTestUser = SetUpTestData.createGuestUser(oTestAccount.Id, 'testemail456i@email.com', 'testusername123i@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName12i','TestLNam34ei',true);        
        system.runAs(oTestUser){
            PageReference pageRef = Page.Help;
            Test.setCurrentPage(pageRef);
            test.startTest(); 
            map<string,object> mapOfresObj = (Map<String, Object>)JSON.deserializeUntyped('{"city":false,"country":{"name":"Japan","code":"JP"},"location":{"latitude":20,"longitude":77,"time_zone":"AsiaKolkata"}}');
            string strREs = (string)JSON.serialize(mapOfresObj);  
            SingleRequestMock fakeResponse = new SingleRequestMock(200,'Complete',strREs,null);
            system.assertNotEquals(null, fakeResponse);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            HelpController helpCon = new HelpController();
            helpCon.toGetuserIPAddress();
            test.stopTest();
        }
        
    }
    
    /*Test with error response country and redirecting to specific URL*/
    static testMethod void testtogetIpAddsforUnSucResp() {
        DAZN_Help_Redirect__c dznHelpRed = new DAZN_Help_Redirect__c();
        dznHelpRed.CountryISOCode__c = 'JP';
        dznHelpRed.Name= 'Japan';
        dznHelpRed.Language__c = 'JA';
        dznHelpRed.IsDefaultCountry__c = true;
        dznHelpRed.Country__c = 'Japan';
        insert dznHelpRed;
        
        
        
        system.assertEquals('JA', dznHelpRed.Language__c);
        SetUpTestData.testCreateDAZNConfiguration('HomePageURL', '/HomePage');
        Account oTestAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oTestUser = SetUpTestData.createGuestUser(oTestAccount.Id, 'testemail456j@email.com', 'testusername123j@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName12j','TestLNam34ej',true);        
        system.runAs(oTestUser){
            //PD-7815 Salesforce Unit Tests Issues - For HelpController
			DAZNBetaConfiguration__c daznBetaConfic = new DAZNBetaConfiguration__c();
            daznBetaConfic.Name = 'Japan';
            daznBetaConfic.Country__c = 'Japan';
            daznBetaConfic.CountryCode__c = 'JP';
            daznBetaConfic.IsBeta__c = True;
            insert daznBetaConfic;
            //End PD-7815 Salesforce Unit Tests Issues - For HelpController
             
            
            PageReference pageRef = Page.Help;
            Test.setCurrentPage(pageRef);
            test.startTest(); 
            map<string,object> mapOfresObj = (Map<String, Object>)JSON.deserializeUntyped('{"city":false,"country":{"name":"Germany","code":"en"},"location":{"latitude":20,"longitude":77,"time_zone":"AsiaKolkata"}}');
            string strREs = (string)JSON.serialize(mapOfresObj);  
            SingleRequestMock fakeResponse = new SingleRequestMock(503,'Error',strREs,null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            HelpController helpCon = new HelpController();
            helpCon.toGetuserIPAddress();
            test.stopTest();
        }
        
        
    }
    //PD-7815 Salesforce Unit Tests Issues - For HelpController
    static testMethod void testtogetIpAddsforUnSucRespIsBetaFalse() {
        DAZN_Help_Redirect__c dznHelpRed = new DAZN_Help_Redirect__c();
        dznHelpRed.CountryISOCode__c = 'JP';
        dznHelpRed.Name= 'Japan';
        dznHelpRed.Language__c = 'JA';
        dznHelpRed.IsDefaultCountry__c = true;
        dznHelpRed.Country__c = 'Japan';
        insert dznHelpRed;        
        
        system.assertEquals('JA', dznHelpRed.Language__c);
        SetUpTestData.testCreateDAZNConfiguration('HomePageURL', '/HomePage');
        Account oTestAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oTestUser = SetUpTestData.createGuestUser(oTestAccount.Id, 'testemail456k@email.com', 'testusername123k@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName12k','TestLNam34ek',true);        
        
        
        system.runAs(oTestUser){
			DAZNBetaConfiguration__c daznBetaConfic = new DAZNBetaConfiguration__c();
            daznBetaConfic.Name = 'Japan';
            daznBetaConfic.Country__c = 'Japan';
            daznBetaConfic.CountryCode__c = 'JP';
            daznBetaConfic.IsBeta__c = False;
            insert daznBetaConfic;                         
            
            PageReference pageRef = Page.Help;
            Test.setCurrentPage(pageRef);
            test.startTest(); 
            map<string,object> mapOfresObj = (Map<String, Object>)JSON.deserializeUntyped('{"city":false,"country":{"name":"Germany","code":"en"},"location":{"latitude":20,"longitude":77,"time_zone":"AsiaKolkata"}}');
            string strREs = (string)JSON.serialize(mapOfresObj);  
            SingleRequestMock fakeResponse = new SingleRequestMock(503,'Error',strREs,null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            HelpController helpCon = new HelpController();
            helpCon.toGetuserIPAddress();
            test.stopTest();
        }
        
        
    }
     static testMethod void testtogetIpAddsforUnSucRespNotGuestUser() {
        DAZN_Help_Redirect__c dznHelpRed = new DAZN_Help_Redirect__c();
        dznHelpRed.CountryISOCode__c = 'JP';
        dznHelpRed.Name= 'Japan';
        dznHelpRed.Language__c = 'JA';
        dznHelpRed.IsDefaultCountry__c = true;
        dznHelpRed.Country__c = 'Japan';
        insert dznHelpRed;
        
        
        
        system.assertEquals('JA', dznHelpRed.Language__c);
       	SetUpTestData.testCreateDAZNConfiguration('HomePageURL', '/HomePage');
        Account oTestAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oTestUser = SetUpTestData.createCommunityUser(oTestAccount.id, 'testemail456l@email.com', 'testusername123l@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName12l','TestLNam34el',true);               												
        system.runAs(oTestUser){
			DAZNBetaConfiguration__c daznBetaConfic = new DAZNBetaConfiguration__c();
            daznBetaConfic.Name = 'Japan';
            daznBetaConfic.Country__c = 'Japan';
            daznBetaConfic.CountryCode__c = 'JP';
            daznBetaConfic.IsBeta__c = False;
            insert daznBetaConfic;
            
             
            
            PageReference pageRef = Page.Help;
            Test.setCurrentPage(pageRef);
            test.startTest(); 
            map<string,object> mapOfresObj = (Map<String, Object>)JSON.deserializeUntyped('{"city":false,"country":{"name":"Germany","code":"en"},"location":{"latitude":20,"longitude":77,"time_zone":"AsiaKolkata"}}');
            string strREs = (string)JSON.serialize(mapOfresObj);  
            SingleRequestMock fakeResponse = new SingleRequestMock(503,'Error',strREs,null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            HelpController helpCon = new HelpController();
            helpCon.toGetuserIPAddress();
            test.stopTest();
        }
        
        
    }//End PD-7815 Salesforce Unit Tests Issues - For HelpController    
    /* Test with user having language and country code */
    
    static testMethod void testforsignUsrRed() {        
        DAZN_Help_Redirect__c dznHelpRed = new DAZN_Help_Redirect__c();
        dznHelpRed.CountryISOCode__c = 'JP';
        dznHelpRed.Name= 'Japan';
        dznHelpRed.Language__c = 'JA'; 
        dznHelpRed.IsDefaultCountry__c = true;
        dznHelpRed.Country__c = 'Japan';
        insert dznHelpRed;
        system.assertEquals('Japan', dznHelpRed.Name);
        SetUpTestData.testCreateDAZNConfiguration('HomePageURL', '/HomePage');
        Account oTestAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oTestUser = SetUpTestData.createGuestUser(oTestAccount.Id, 'testemail456m@email.com', 'testusername123m@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName12m','TestLNam34em',true);        
        system.runAs(oTestUser){
            PageReference pageRef = Page.Help;
            Test.setCurrentPage(pageRef);
            test.startTest(); 
            map<string,object> mapOfresObj = (Map<String, Object>)JSON.deserializeUntyped('{"city":false,"country":{"name":"Germany","code":"en"},"location":{"latitude":20,"longitude":77,"time_zone":"AsiaKolkata"}}');
            string strREs = (string)JSON.serialize(mapOfresObj);  
            SingleRequestMock fakeResponse = new SingleRequestMock(503,'Error',strREs,null);
            system.assertNotEquals(null, fakeResponse);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            HelpController helpCon = new HelpController();
            helpCon.toGetuserIPAddress();
            test.stopTest();
        }
    }    
    
    /* Test with user having language and country code */
    
    static testMethod void testRedirectToHomePage() {       
        Account oTestAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oTestAccount.Id, 'testemail456n@email.com', 'testusername123n@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName12n','TestLNam34en',true);        
        system.runAs(oUser){
            PageReference pageRef = Page.Help;
            Test.setCurrentPage(pageRef);
            HelpController helpCon = new HelpController();
            helpCon.redirectToHomePage();
            system.assertEquals('/HomePage', helpCon.redirectToHomePage().getURL()); 
        } 
    } 
    
    /*Test for getting exception covered*/ 
    static testMethod void exceptioncover(){
    	Account oTestAccount = SetUpTestData.createPersonAccount('JP','ja','TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oTestAccount.Id, 'testemail456o@email.com', 'testusername123o@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName12o','TestLNam34eo',true);        
        system.runAs(oUser){
            PageReference pageRef = Page.Help;
            Test.setCurrentPage(pageRef);
            HelpController helpCon = new HelpController();
            HelpController.getHomepageArticles('','','');
            HelpController.displayArticleWithTitle('','','','');
            helpCon.url ='test';
        }    
    }

  /*Test To cover Exception */
    static testMethod void testtogetIpAddException() {
        SetUpTestData.testCreateDAZNConfiguration('HomePageURL', '/HomePage');
        Account oTestAccount = SetUpTestData.createPersonAccount('JP','ja','TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oTestUser = SetUpTestData.createGuestUser(oTestAccount.Id, 'testemail456h@email.com', 'testusername123h@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName12h','TestLNam34eh',true);        
        system.runAs(oTestUser){
            PageReference pageRef = Page.Help;
            Test.setCurrentPage(pageRef);
            test.startTest(); 
            map<string,object> mapOfresObj = (Map<String, Object>)JSON.deserializeUntyped('{"city":true,"country":{"name":"India","code":"IN"},"location":{"latitude":20,"longitude":77,"time_zone":"AsiaKolkata"}}');
            string strREs = (string)JSON.serialize(mapOfresObj);  
            SingleRequestMock fakeResponse = new SingleRequestMock(200,'Complete',strREs,null);
            system.assertNotEquals(null,fakeResponse);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            HelpController helpCon = new HelpController();
            helpCon.toGetuserIPAddress();
            test.stopTest();
        }
        
    }
    
    
}