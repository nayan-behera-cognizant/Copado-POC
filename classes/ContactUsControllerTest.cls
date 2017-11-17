/**
* @author Cognizant Technology Solutuions
* @date 05/02/2015
* @description This class test contactus functionality.
*/
@istest
public class ContactUsControllerTest {
    
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
        
    /*Testing email edit flag*/
    static testMethod void testEmailEditFlag() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        
        Test.StartTest();
        
        System.RunAs(oUser){
            ApexPages.currentPage().getParameters().put('field','Email');
            ContactUsController objContactUs = new ContactUsController();
            objContactUs.sUniqueCaseType = 'test';
            objContactUs.edit();
            system.assertEquals(true, objContactUs.isEmailEdit);
        }
        Test.StopTest();
    }
    
    /*Testing country and language code */
    static testMethod void testUserCountryNLanguageCode() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('GB', 'en_US', 'TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
        
        Test.StartTest();
        
        System.RunAs(oUser){
            ContactUsController objContactUs = new ContactUsController();
            system.assertNotEquals(null, objContactUs);
        }
        Test.StopTest();
    }

    /*Testing case creation*/
    static testMethod void testCaseCreation() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
        
        List<Email_Help_Option__c> lstEmailHelpOption = new List<Email_Help_Option__c>();
        Email_Help_Option__c oEmailOption1 = new Email_Help_Option__c();
        oEmailOption1.Name = 'Catch Up Issue';
        oEmailOption1.Language__c = 'en';
        oEmailOption1.Type__c = 'I have an issue with catch up';
        oEmailOption1.Provider_Type__c = 'DAZN';
        oEmailOption1.Case_Resolution_Owner__c = 'DAZN';
        lstEmailHelpOption.add(oEmailOption1);
        
        Email_Help_Option__c oEmailOption2 = new Email_Help_Option__c();
        oEmailOption2.Name = 'General Enquiry';
        oEmailOption2.Language__c = 'en';
        oEmailOption2.Type__c = 'I have a general enquiry';
        oEmailOption2.Provider_Type__c = 'DAZN';
        oEmailOption2.Case_Resolution_Owner__c = 'DAZN';
        lstEmailHelpOption.add(oEmailOption2);
        
        insert lstEmailHelpOption;
        
        Test.StartTest(); 
        
        System.RunAs(oUser){
            ContactUsController objContactUs = new ContactUsController();
            system.assertEquals(objContactUs.oUser.Id, userinfo.getUserId());
            objContactUs.caseDescription = 'Test Description';
            objContactUs.sCaseSubject = 'Test Description';
            objContactUs.sCaseType = 'General Enquiry';
            objContactUs.strNewEmail = oUser.email;
            objContactUs.createCase();
        }
        
        Test.StopTest();
    }
    
    /*Test livesport rewriter with country and language in url*/
    static testMethod void testlivesportRewriterWithCountryNLanguage() {
        
        livesportRewriter rewriter = new livesportRewriter();
        PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/contactus/JP-en'));
        //***********changes as per PD-7816 & PD-7938*********
        system.assertEquals('/apex/mylogin',actualResult.getURL());
    }
    
    /*Test livesport rewriter with country, language and type in url*/
    static testMethod void testlivesportRewriterWithCountryLanguageNType() {
        livesportRewriter rewriter = new livesportRewriter();
        PageReference actualResult = rewriter.mapRequestUrl(new PageReference('/contactus/JP-en/I need help'));
        //***********changes as per PD-7816 & PD-7938*********
        system.assertEquals('/apex/mylogin',actualResult.getURL());
    }
    
    static testMethod void testCreateCaseForCommunityUserIsNotGuestUserCA() {
        List<DAZNConfiguration__c> lstConfig = new List<DAZNConfiguration__c>();
        lstConfig.add(new DAZNConfiguration__c(Name = 'DefaultCaseType', Value__c = 'General Enquiry'));
        lstConfig.add(new DAZNConfiguration__c(Name = 'DefaultCaseSubject', Value__c = 'I have a general enquiry'));
        insert lstConfig;
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');       
        
        Test.StartTest();
        
        System.RunAs(oUser){
            ApexPages.currentPage().getParameters().put('Country', 'CA');
            ApexPages.currentPage().getParameters().put('lang', 'en');
            
            ContactUsController objContactUs = new ContactUsController();
            objContactUs.bIsGuestUser = false;
            objContactUs.selectedProvider  = 'DAZN';
            objContactUs.strNewEmail = 'testemail@email.com';
            objContactUs.caseDescription = 'Test Description';
            objContactUs.sCaseType = 'General Enquiry';
            PageReference result = objContactUs.createCase();
        }
        Test.StopTest();

        Case createdCase = [SELECT AccountId, ContactId FROM Case LIMIT 1];
        system.assertEquals(createdCase.AccountId, oAccount.Id);
    }

    /*PD-8875*/
    static testMethod void testDaznSignIn() {
        Custom_Provider__c provider = new Custom_Provider__c();
        provider.Country_Code__c = 'JP';
        provider.Name = 'DAZN JP';
        provider.Language__c = 'de';
        provider.Provider_Type__c = 'DAZN';
        insert provider;

        List<Email_Help_Option__c> lstEmailHelpOption = new List<Email_Help_Option__c>();
        lstEmailHelpOption.add(new Email_Help_Option__c(
            Name = 'testEHO',
            Language__c = 'de',
            Country__c = 'JP',
            Type__c = 'testSubject',
            Provider_Type__c = 'DAZN',
            Case_Resolution_Owner__c = 'DAZN'
        ));
        insert lstEmailHelpOption;

        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');       
        
        Test.StartTest();
        System.RunAs(oUser) {
            ApexPages.currentpage().getParameters().put('lang', 'de');
            ApexPages.currentpage().getParameters().put('Country', 'JP');
            ApexPages.currentpage().getParameters().put('type', 'testEHO');
            
            ContactUsController objContactUs = new ContactUsController();
            PageReference myLogin = objContactUs.daznSignIn();
            System.assertEquals(true, myLogin.getUrl().contains('mylogin'));
            System.assertEquals('testSubject', myLogin.getParameters().get('type'));
            System.assertEquals('DAZN', myLogin.getParameters().get('loginType'));

            ApexPages.currentpage().getParameters().put('type', '');
            objContactUs = new ContactUsController(); 
            objContactUs.selectedSubject = '';
            myLogin = objContactUs.daznSignIn();
            System.assertEquals('/mylogin?loginType=DAZN', myLogin.getUrl());

        }
        Test.StopTest();        
    }

    /*PD-8875*/
    static testMethod void testLoadUserTypesAndSubjects() {
        Custom_Provider__c provider = new Custom_Provider__c();
        provider.Country_Code__c = 'JP';
        provider.Name = 'DAZN JP';
        provider.Language__c = 'de';
        provider.Provider_Type__c = 'DAZN';
        insert provider;

        Email_Help_Option__c oEmailOption = new Email_Help_Option__c();
        oEmailOption.Name = 'General Enquiry';
        oEmailOption.Language__c = 'de';
        oEmailOption.Country__c = 'JP';
        oEmailOption.Provider_Type__c = 'DAZN';
        oEmailOption.Case_Resolution_Owner__c = 'DAZN';
        oEmailOption.Type__c = 'I have a general enquiry';
        insert oEmailOption;

        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'testemail@email.com', 'Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US',  'TestFName', 'TestLName', true, 'United Kingdom');       
        
        Test.StartTest();
        System.RunAs(oUser) {
            PageReference oPageReference = Page.ContactUs; 
            oPageReference.getParameters().put('lang', 'de'); 
            oPageReference.getParameters().put('Country', 'JP'); 
            Test.setCurrentPage(oPageReference);             
            ContactUsController objContactUs = new ContactUsController();
            List<Custom_Provider__c> ut = objContactUs.userTypes;
            System.assertEquals(1, ut.size());
        }
        Test.StopTest();        
    }  

    /*PD-8875*/
    static testMethod void testDefaultSubject() {
        Custom_Provider__c provider = new Custom_Provider__c();
        provider.Country_Code__c = 'JP';
        provider.Name = 'DAZN JP';
        provider.Language__c = 'de';
        provider.Provider_Type__c = 'DAZN';
        insert provider;

        Email_Help_Option__c oEmailOption = new Email_Help_Option__c();
        oEmailOption.Name = 'General Enquiry';
        oEmailOption.Language__c = 'de';
        oEmailOption.Country__c = 'JP';
        oEmailOption.Provider_Type__c = 'DAZN';
        oEmailOption.Case_Resolution_Owner__c = 'DAZN';
        oEmailOption.Type__c = 'I have a general enquiry';
        
        insert oEmailOption;

        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');       
        
        Test.StartTest();
        
        System.RunAs(oUser){
            PageReference oPageReference = Page.ContactUs; 
            oPageReference.getParameters().put('lang', 'de'); 
            oPageReference.getParameters().put('Country', 'JP'); 
            oPageReference.getParameters().put('type', 'General Enquiry'); 
            Test.setCurrentPage(oPageReference);             
            ContactUsController objContactUs = new ContactUsController();

            system.assertEquals(objContactUs.selectedSubject, 'I have a general enquiry');
        }
        Test.StopTest();  
    }  

    /*PD-9519*/
    static testMethod void testCreateCaseForCommunityUser() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');       
        
        Test.StartTest();
        
        System.RunAs(oUser){
            ApexPages.currentPage().getParameters().put('Country', 'DE');
            ApexPages.currentPage().getParameters().put('lang', 'en');
            
            ContactUsController objContactUs = new ContactUsController();
            objContactUs.bIsGuestUser = true;
            objContactUs.selectedProvider  = 'DAZN';
            objContactUs.strNewEmail = 'testemail@email.com';
            objContactUs.caseDescription = 'Test Description';
            objContactUs.sCaseSubject = 'Test Description';
            objContactUs.sCaseType = 'General Enquiry';
            PageReference result = objContactUs.createCase();
        }
        Test.StopTest();

        Case createdCase = [SELECT AccountId, ContactId FROM Case LIMIT 1];
        system.assertEquals(createdCase.AccountId, oAccount.Id);
    }

    static testMethod void testCreateCaseForCommunityUserIsNotGuestUser() {
        List<DAZNConfiguration__c> lstConfig = new List<DAZNConfiguration__c>();
        lstConfig.add(new DAZNConfiguration__c(Name = 'DefaultCaseType', Value__c = 'General Enquiry'));
        lstConfig.add(new DAZNConfiguration__c(Name = 'DefaultCaseSubject', Value__c = 'I have a general enquiry'));
        insert lstConfig;
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');       
        
        Test.StartTest();
        
        System.RunAs(oUser){
            ApexPages.currentPage().getParameters().put('Country', 'DE');
            ApexPages.currentPage().getParameters().put('lang', 'en');
            
            ContactUsController objContactUs = new ContactUsController();
            objContactUs.bIsGuestUser = false;
            objContactUs.selectedProvider  = 'DAZN';
            objContactUs.strNewEmail = 'testemail@email.com';
            objContactUs.caseDescription = 'Test Description';
            objContactUs.sCaseType = 'General Enquiry';
            PageReference result = objContactUs.createCase();
        }
        Test.StopTest();

        Case createdCase = [SELECT AccountId, ContactId FROM Case LIMIT 1];
        system.assertEquals(createdCase.AccountId, oAccount.Id);
    }

    /*PD-9519*/
    static testMethod void testCreateCaseForGuestUser() {
        SetUpTestData.triggerSettings();
        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'DAZN for Docomo', 'DAZN for Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail5@email.com','Free Trial');
        User oUser = SetUpTestData.createGuestUser(oAccount.Id, 'testemail456@email.com', 'testusername123@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName12','TestLNam34e',true);        
        
        Test.StartTest();
        
        System.RunAs(oUser){
            ApexPages.currentPage().getParameters().put('Country', 'DE');
            ApexPages.currentPage().getParameters().put('lang', 'en');

            ContactUsController objContactUs = new ContactUsController();
            objContactUs.bIsGuestUser = true;
            objContactUs.selectedProvider  = 'DAZN';
            objContactUs.strNewEmail = 'testemail5@email.com';
            objContactUs.caseDescription = 'Test Description';
            objContactUs.sCaseSubject = 'Test Description';
            objContactUs.sCaseType = 'General Enquiry';
            PageReference result = objContactUs.createCase();
        }
        Test.StopTest();

        Case createdCase = [SELECT AccountId, ContactId FROM Case LIMIT 1];
        system.assertEquals(createdCase.AccountId, oAccount.Id);
    }
    
    /*PD-9519*/
    static testMethod void testCreateCaseDAZNDuplicates() {
        //SetUpTestData.triggerSettings();

        TriggerSetting__c updateAccountTrigger = new TriggerSetting__c(name = 'UpdateAccountTrigger', Disable__c = true);
        insert updateAccountTrigger;
        List<TriggerSetting__c> triggerSet = new List<TriggerSetting__c>();
        List<string> objSettings = new List<string> {'BillingAccountTrigger','UserTrigger','SubscriptionTrigger','UserDeviceTrigger','ZuoraRefundTrigger'};
            for(string objSet : objSettings){
                TriggerSetting__c trigSet = new TriggerSetting__c(name = objSet, Disable__c = false);
                triggerSet.add(trigSet);
            }       
        insert triggerSet;

        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'DAZN for Docomo', 'DAZN for Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        Account oAccount2 = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createGuestUser(oAccount.Id, 'testemail456@email.com', 'testusername123@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName12','TestLNam34e',true);        
        
        Test.StartTest();
        
        System.RunAs(oUser){
            ApexPages.currentPage().getParameters().put('Country', 'DE');
            ApexPages.currentPage().getParameters().put('lang', 'en');

            ContactUsController objContactUs = new ContactUsController();
            objContactUs.bIsGuestUser = true;
            objContactUs.selectedProvider  = 'DAZN';
            objContactUs.strNewEmail = 'testemail@email.com';
            objContactUs.caseDescription = 'Test Description';
            objContactUs.sCaseSubject = 'Test Description';
            objContactUs.sCaseType = 'General Enquiry';
            PageReference result = objContactUs.createCase();
        }
        Test.StopTest();

        Case createdCase = [SELECT AccountId, ContactId FROM Case LIMIT 1];
        System.assertEquals(createdCase.AccountId, null);
    }

    /*PD-9104*/
    static testMethod void testRedirectToDocomoSignInPage() {
        SetUpTestData.createCustomProvider('DAZN JP', 'DAZN', 'JP', 'de');
        SetUpTestData.createEmailHelpOption('testEHO', 'testSubj', 'DAZN', 'DAZN', 'JP', 'de');

        ApexPages.currentpage().getParameters().put('lang', 'de');
        ApexPages.currentpage().getParameters().put('Country', 'JP');
        ApexPages.currentpage().getParameters().put('type', 'testEHO');

        ContactUsController objContactUs = new ContactUsController();
        PageReference docomoSignIn = objContactUs.redirectToDocomoSignInPage();
        System.assertEquals('/apex/docomosignin?auth=true&type=contactus%3BtestSubj', docomoSignIn.getUrl());
    }
}