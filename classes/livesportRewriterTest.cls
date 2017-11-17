@istest
public class livesportRewriterTest {
    
    @testSetup /*  calling CreateTestDataforUnitTest */  
    public static void getCommunityUsersTestData(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();    
    }

    static testMethod void testProxyRedirect() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'devices';
        insert urlsAccepted;
        Help_Short_URLs__c helpShortURL = new Help_Short_URLs__c(
            Name = '/devices-DE-de',
            Country_code__c = 'DE',
            Language_code__c = 'de',
            Long_URL__c = '/help/DE-de/How-do-I-register',
            Short_URL_Name__c= '/devices'
        );
        insert helpShortURL;
        list<Account> acclist = [Select Id, Name, PersonEmail, PersonContactId, Notification_Language_Code__c, Notification_Country_Code__c From Account Where Account_status__c = 'Active Paid' LIMIT 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/devices'));
            Test.stopTest();
            System.assertEquals('/apex/proxyredirect?shortUrl=devices', actualResult.getUrl());
        }
    }

    static testMethod void testHelpRedirect() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'devices';
        insert urlsAccepted;
        accepted_urls__c urlsAccepted1 = new accepted_urls__c();
        urlsAccepted1.Name = 'proxyredirect';
        insert urlsAccepted1;
        accepted_urls__c urlsAccepted2 = new accepted_urls__c();
        urlsAccepted2.Name = 'help';
        insert urlsAccepted2;

        DAZN_Help_Redirect__c helpRedirect = new DAZN_Help_Redirect__c();
        helpRedirect.Country__c = 'Germany';
        helpRedirect.Name = 'Germany';
        helpRedirect.IsDefaultCountry__c = true;
        helpRedirect.CountryISOCode__c = 'DE';
        helpRedirect.Language__c = 'de';
        insert helpRedirect;

        Help_Short_URLs__c helpShortURL = new Help_Short_URLs__c(
            Name = '/devices-DE-de',
            Country_code__c = 'DE',
            Language_code__c = 'de',
            Long_URL__c = '/help/DE-de/How-do-I-register',
            Short_URL_Name__c= '/devices'
        );
        insert helpShortURL;

        list<Account> acclist = [Select Id, Name, PersonEmail, PersonContactId, Notification_Language_Code__c, Notification_Country_Code__c From Account Where Account_status__c = 'Active Paid' LIMIT 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/devices/DE-de'));
            Test.stopTest();
            System.assertEquals('/apex/help?Country=DE&lang=de&title=How-do-I-register', actualResult.getUrl());
        }
    }
    
    static testMethod void testlivesportRewriter() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'contactus';
        insert urlsAccepted;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/contactus/?metakeyword=testmetakeyword'));
            Test.stopTest();
        }
    }
    
    /*Test livesport rewriter with Accepted Url as Null*/
    static testMethod void testlivesportRewriterWithAcceptedUrlAsNull() {
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest(); 
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/help/DE-de'));
            system.assertEquals('/apex/mylogin',actualResult.getUrl());
            Test.stopTest();
        }
    }
    /*Test livesport rewriter with country and language in help url*/
    static testMethod void testlivesportRewriterWithCountryNLanguageHelp() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'help';
        insert urlsAccepted;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/help/DE-de'));
            system.assertEquals('/apex/help?Country=DE&lang=de',actualResult.getUrl());
            Test.stopTest();
        }
    }
    
    /*Test livesport rewriter without correct format of country and language in help url*/
    static testMethod void testlivesportRewriterWithCountryNLanguageHelpWithInternalServer() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'help';
        insert urlsAccepted;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/help/JP_en'));
            system.assertEquals('/apex/internalservererror',actualResult.getUrl());
            Test.stopTest();    
        }
    }
    
    
    /*Test livesport rewriter with country, language and type in help url*/
    static testMethod void testlivesportRewriterWithCountryLanguageNTypeHelp() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'help';
        insert urlsAccepted;
        DAZN_Help_Redirect__c helpRedirect = new DAZN_Help_Redirect__c();
        helpRedirect.Country__c = 'Germany';
        helpRedirect.Name = 'Germany';
        helpRedirect.IsDefaultCountry__c = true;
        helpRedirect.CountryISOCode__c = 'DE';
        helpRedirect.Language__c = 'en';
        insert helpRedirect;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/help/DE-en/I need help?metakeyword=testmetakeyword'));
            Test.stopTest();
        }
    }
    
    /*Test livesport rewriter with country, language and type in help url*/
    static testMethod void testlivesportRewriterWithCountryLanguageNTypeHelp1() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'help';
        insert urlsAccepted;
        DAZN_Help_Redirect__c helpRedirect = new DAZN_Help_Redirect__c();
        helpRedirect.Country__c = 'Germany';
        helpRedirect.Name = 'Germany';
        helpRedirect.IsDefaultCountry__c = true;
        helpRedirect.CountryISOCode__c = 'DE';
        helpRedirect.Language__c = 'en';
        insert helpRedirect;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/help/DE-de/I need help?metakeyword=testmetakeyword'));
            Test.stopTest();
        }
    }
    
    /*Test livesport rewriter with country, language and type in help url*/
    static testMethod void testlivesportRewriterWithCountryLanguageNTypeHelp2() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'help';
        insert urlsAccepted;
        DAZN_Help_Redirect__c helpRedirect = new DAZN_Help_Redirect__c();
        helpRedirect.Country__c = 'Germany';
        helpRedirect.Name = 'Germany';
        helpRedirect.IsDefaultCountry__c = true;
        helpRedirect.CountryISOCode__c = 'DE';
        helpRedirect.Language__c = 'en';
        insert helpRedirect;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/help/-/I need help?metakeyword=testmetakeyword'));
            Test.stopTest();
        }
    }
    
    /*Test livesport rewriter with country, language and serachtext in help url*/
    static testMethod void testlivesportRewriterWithSearchTextHelp() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'help';
        insert urlsAccepted;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/help/DE-de/search/test'));
            system.assertEquals('/apex/help?Country=DE&lang=de&searchText=test',actualResult.getUrl());
            Test.stopTest();
        }
    }
    
    /*Test livesport rewriter with country and language in contactus url*/
    static testMethod void testlivesportRewriterWithCountryNLanguageContactUs() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'contactus';
        insert urlsAccepted;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/contactus/'));
            system.assertEquals('/apex/contactus', actualResult.getURL());
            Test.stopTest();
        }
    }
    
    /*Test livesport rewriter with country, language and type in contactus url*/
    static testMethod void testlivesportRewriterWithCountryLanguageNTypeContactUs() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'contactus';
        insert urlsAccepted;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/contactus/I need help'));
            system.assertEquals('/apex/contactus?type=I+need+help', actualResult.getURL());
            Test.stopTest();
        }
    }
    
    /*Test livesport rewriter with country, language and tracking parameters in contactus url*/
    static testMethod void testlivesportRewriterWithTrackingParamContactUs() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'contactus';
        insert urlsAccepted;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/contactus/DE-de/I need help?metakeyword=testmetakeyword'));
            Test.stopTest();
        }
    }

    /*Test livesport rewriter with country and language in mylogin url*/
    static testMethod void testMyLoginWithCountryNLanguageNRetUrlNFlow() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'mylogin';
        insert urlsAccepted;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/mylogin/help'));
            System.assertEquals('help', actualResult.getParameters().get('retUrl'));
            PageReference actualResultFlow = rewriter.mapRequestUrl(new PageReference('/mylogin/help/livechat'));
            System.assertEquals('help', actualResultFlow.getParameters().get('retUrl'));
            System.assertEquals('livechat', actualResultFlow.getParameters().get('flow'));
            Test.stopTest();
        }
    }
    
    /*Test livesport rewriter with country and language in change password url*/
    static testMethod void testlivesportRewriterWithCountryNLanguageChangePassword() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'changepassword';
        insert urlsAccepted;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/changepassword/DE-de/'));
            system.assertEquals('/apex/changepassword?Country=DE&lang=de',actualResult.getURL());
            Test.stopTest();
        }
    }

    /*Test livesport rewriter with country and language in PauseUpsell url*/
    static testMethod void testlivesportRewriterPauseUpsellInit() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'pause-or-cancel';
        insert urlsAccepted;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/pause-or-cancel/initiate'));
            system.assertEquals('/apex/pauseupsell?pauseAction=initiate', actualResult.getURL());
            Test.stopTest();
        }
    }

    /*Test livesport rewriter with country and language in SetPause url*/
    static testMethod void testlivesportRewriterSetPauseInit() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'setpause';
        insert urlsAccepted;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/setpause/initiate'));
            system.assertEquals('/apex/setpause?pauseAction=initiate', actualResult.getURL());
            Test.stopTest();
        }
    }

    /*Test livesport rewriter with pauseAction in KeepInTouch url*/
    static testMethod void testlivesportRewriterWithpauseActionKeepInTouch() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'keepintouch';
        insert urlsAccepted;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/keepintouch/amend/'));
            system.assertEquals('/apex/keepintouch?pauseAction=amend', actualResult.getURL());
            Test.stopTest();
        }
    }
    
    /*Test livesport rewriter with country and language in email preferences url*/
    static testMethod void testlivesportRewriteEmailPreferences() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'emailpreferences';
        insert urlsAccepted;
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Active Paid' limit 1];
        List<User> oUser = [Select Id,UserName,Alias,Country,LocaleSidKey,LanguageLocaleKey from User where ContactId =: acclist[0].PersonContactId limit 1];         
        System.RunAs(oUser[0]){
            Test.StartTest();
            livesportRewriter rewriter = new livesportRewriter();
            String url = '/emailpreferences/' + 'UID' + acclist[0].id;
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference(url));
            System.assertEquals('UID' + acclist[0].id, actualResult.getParameters().get('UserId'));
            Test.stopTest();
        }
    }
    
    /*Test Method for generateUrlFor Method*/
    static testMethod void testgenerateUrlFor(){
        livesportRewriter rewriter = new livesportRewriter();
        System.assert(rewriter.generateUrlFor(null) == null);
    }
    
    /*PD-9104*/
    static testMethod void testDocomoSignIn() {
        List<DocomoConfiguration__c> config = new List<DocomoConfiguration__c>();
        config.add(new DocomoConfiguration__c(Name = 'Authentication Request', Value__c = 'https://ve.m.id.smt.docomo.ne.jp/cgi8/oidc/authorize?scope=openid offline_access accountid_n dma_service10&response_type=code&prompt=login&client_id=g00_0010_0001_03&redirect_uri={0}&state={1}&nonce={2}&authiden=1'));
        config.add(new DocomoConfiguration__c(Name = 'Client ID', Value__c = 'g00_0010_0001_03'));
        config.add(new DocomoConfiguration__c(Name = 'Client Password', Value__c = 'UB7uPuX9kvxgKaBx2LU9E6cdqT3vnAEU'));
        config.add(new DocomoConfiguration__c(Name = 'Default Password', Value__c = 'cGFzNzg5dzByZA=='));
        config.add(new DocomoConfiguration__c(Name = 'Host', Value__c = 'docomoproxy.performgroup.com'));
        config.add(new DocomoConfiguration__c(Name = 'ReturnUrl', Value__c = '/livesport/myaccount'));
        config.add(new DocomoConfiguration__c(Name = 'Token Request', Value__c = 'https://docomoproxy.performgroup.com/ve.m.conf.uw.docomo.ne.jp/token'));
        config.add(new DocomoConfiguration__c(Name = 'UserInfo Request', Value__c = 'https://docomoproxy.performgroup.com/ve.m.conf.uw.docomo.ne.jp/userinfo'));
        insert config;

        livesportRewriter rewriter = new livesportRewriter();
        PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/livesport/myaccount?state=state1&code=code1'));

        //System.assertEquals('/apex/docomosignin?code=code1&state=state1', actualResult.getURL());
        //System.assert(actualResult.getURL().contains('/apex/docomosignin'));
        System.assertEquals('/apex/docomosignin?auth=true&code=code1&state=state1', actualResult.getURL());
    }
    /*PD-10979*/
    static testMethod void testlivesportRewriterSignInJPnoLang() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'signin';
        insert urlsAccepted;
        
        User u = [Select Id From User Where UserType = 'Guest' AND isActive = true LIMIT 1];
        
        System.RunAs(u) {
            Test.StartTest();
            
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult1 = rewriter.mapRequestUrl(new PageReference('/signin/testRetUrl'));
            System.assert(actualResult1.getURL() == '/apex/signin?retUrl=testRetUrl');

            PageReference actualResult2 = rewriter.mapRequestUrl(new PageReference('/signin/testRetUrl/testFlow'));
            System.assert(actualResult2.getURL() == '/apex/signin?flow=testFlow&retUrl=testRetUrl');
            
            Test.stopTest();
        }
    }

    static testMethod void testlivesportRewriterContactUsnoLang() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'ContactUs';
        insert urlsAccepted;
        
        User u = [Select Id From User Where UserType = 'Guest' AND isActive = true LIMIT 1];
        
        System.RunAs(u) {
            Test.StartTest();
            
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/ContactUs/JP'));
            System.assert(actualResult.getURL() != '/apex/ContactUs?Country=JP');
            
            Test.stopTest();
        }
    }

    static testMethod void testlivesportRewriterEmailPreferencesnoLang() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'EmailPreferences';
        insert urlsAccepted;
        
        User u = [Select Id From User Where UserType = 'Guest' AND isActive = true LIMIT 1];
        
        System.RunAs(u) {
            Test.StartTest();
            
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/EmailPreferences/JP'));
            System.assert(actualResult.getURL() != '/apex/EmailPreferences?Country=JP');
            
            Test.stopTest();
        }
    }

    static testMethod void testlivesportRewriterChangePasswordnoLang() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'ChangePassword';
        insert urlsAccepted;
        
        User u = [Select Id From User Where UserType = 'Guest' AND isActive = true LIMIT 1];
        
        System.RunAs(u) {
            Test.StartTest();
            
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/ChangePassword/JP'));
            System.assert(actualResult.getURL() != '/apex/ChangePassword?Country=JP');
            
            Test.stopTest();
        }
    }

    static testMethod void testlivesportRewriterPaymenthistory() {
        accepted_urls__c urlsAccepted = new accepted_urls__c();
        urlsAccepted.Name = 'paymenthistory';
        insert urlsAccepted;
        
        User u = [Select Id From User Where UserType = 'Guest' AND isActive = true LIMIT 1];
        
        System.RunAs(u) {
            Test.StartTest();
            
            livesportRewriter rewriter = new livesportRewriter();
            PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/paymenthistory/testError'));
            System.assert(actualResult.getURL() == '/apex/paymenthistory?dowloaderror=testError');
            
            Test.stopTest();
        }
    }
}