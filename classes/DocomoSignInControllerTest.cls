//*PD-9104*/
@isTest
private class DocomoSignInControllerTest {
    
    static testMethod void testRedirectHomePage() {
        Test.StartTest();
        
        DAZNConfiguration__c setting = new DAZNConfiguration__c();
        setting.Name = 'HomePageURL';
        setting.Value__c = 'Whatever.com';
        insert setting;

        DocomoSignInController docomoSignInController = new DocomoSignInController();
        PageReference homePageReference = docomoSignInController.redirectToHomePage();

        System.assertEquals(homePageReference.getUrl(),'Whatever.com');

        Test.StopTest();
    }
    
    static testMethod void testCommunityUserAuthentication() {
        SetUpTestData.triggerSettings();

        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'DAZN for Docomo', 'DAZN for Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        Account oAccount = SetUpTestData.createDfDAccount('TestFName', 'TestLName', 'test@test.com','Active Paid', 'accountid1', 'Docomo');
        oAccount.Partner_Registration_Status__c = 'Complete';
        update oAccount;

        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zuoraSubscription = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);    

        Test.StartTest();
        System.RunAs(oUser){
            DocomoSignInController docomoSignInController = new DocomoSignInController();
            PageReference authenticationReference = docomoSignInController.Authentication();
            system.assertEquals(System.Page.PartnerAccount.getUrl(), authenticationReference.getUrl());
        }
        Test.StopTest();
    }

    static testMethod void testGuestUserAuthentication() {
        SetUpTestData.triggerSettings();
        User guestUser = [select id, name from User where userType = 'Guest' AND isActive = true LIMIT 1];
        DocomoConfiguration__c docomoConfiguration = new DocomoConfiguration__c();
        docomoConfiguration.Name = 'Authentication Request';
        docomoConfiguration.Value__c = 'https://id.smt.docomo.ne.jp/cgi8/oidc/authorize?scope=openid offline_access accountid_n dma_service10&response_type=code&client_id=g00_0010_0001_01&redirect_uri={0}&state={1}&nonce={2}&authiden=1';
        insert docomoConfiguration;

        Test.StartTest();
        System.runAs(guestUser) {
            ApexPages.currentPage().getParameters().put('auth', 'true');
            DocomoSignInController docomoSignInController = new DocomoSignInController();
            PageReference authenticationReference = docomoSignInController.Authentication();
            system.assertEquals(true, authenticationReference.getUrl().contains('https://id.smt.docomo.ne.jp/cgi8/oidc/authorize'));                
        }
        Test.stopTest();
    }

    static testMethod void testRetriveApproval() {
        SetUpTestData.triggerSettings();
        User guestUser = [select id, name from User where userType = 'Guest' AND isActive = true LIMIT 1];
        
        Test.StartTest();
            System.runAs(guestUser) {
                ApexPages.currentPage().getParameters().put('state','state1');
                ApexPages.currentPage().getParameters().put('code','code1');
                DocomoSignInController docomoSignInController = new DocomoSignInController();
                String approvalCode = docomoSignInController.RetriveApprovalCode();
                system.assertEquals(approvalCode, 'code1');                
            }
        Test.stopTest();
    }

    static testMethod void testTokenRequest() {
        SetUpTestData.triggerSettings();
        User guestUser = [select id, name from User where userType = 'Guest' AND isActive = true LIMIT 1];

        Map<String,String> docomoConfigurationMap = new Map<String,String>();
        docomoConfigurationMap.put('Token Request', 'https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/token');
        docomoConfigurationMap.put('Host', 'docomoproxy.performgroup.com');
        docomoConfigurationMap.put('Client ID', 'Client ID');
        docomoConfigurationMap.put('Client Password', 'Client Password');                        

        Test.StartTest();
            System.runAs(guestUser) {
                Test.setMock(HttpCalloutMock.class, new MockDocomoHttpResponse());

                DocomoSignInController docomoSignInController = new DocomoSignInController();
                String token = docomoSignInController.TokenRequest('', docomoConfigurationMap);
                system.assertEquals(token, 'access_token1');                
            }
        Test.stopTest();
    }

    static testMethod void testUserInfoRequest() {
        SetUpTestData.triggerSettings();
        User guestUser = [select id, name from User where userType = 'Guest' AND isActive = true LIMIT 1];
        Map<String,String> docomoConfigurationMap = new Map<String,String>();
        docomoConfigurationMap.put('UserInfo Request', 'https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/userinfo');

        Test.StartTest();
            System.runAs(guestUser) {
                Test.setMock(HttpCalloutMock.class, new MockDocomoHttpResponse());

                DocomoSignInController docomoSignInController = new DocomoSignInController();
                HTTPResponse userInfoResponse = docomoSignInController.UserInfoRequest('', docomoConfigurationMap);
                String accountId = docomoSignInController.ParseToken(userInfoResponse.getBody(), 'accountid');
                system.assertEquals(accountId, 'accountid1');                
            }
        Test.stopTest();
    }

    static testMethod void testGuestUserAuthenticationTechErrorBetweenDAccountAuthAndCognizant() {
        SetUpTestData.triggerSettings();
        User guestUser = [select id, name from User where userType = 'Guest' AND isActive = true LIMIT 1];
        
        Test.StartTest();
            System.runAs(guestUser) {
                ApexPages.currentPage().getParameters().put('state','state1');
                ApexPages.currentPage().getParameters().put('code','code1');
                ApexPages.currentPage().getParameters().put('auth', 'true');

                DocomoSignInController docomoSignInController = new DocomoSignInController();
                docomoSignInController.Authentication();
                system.assertEquals(docomoSignInController.TechErrorBetweenDAccountAuthAndCognizant, true);                
            }
        Test.stopTest();
    }

    static testMethod void testGuestUserAuthenticationNotFoundAccount() {
        SetUpTestData.triggerSettings();
        User guestUser = [select id, name from User where userType = 'Guest' AND isActive = true LIMIT 1];
        
        Test.StartTest();
            System.runAs(guestUser) {
                Test.setMock(HttpCalloutMock.class, new MockDocomoHttpResponse());
                ApexPages.currentPage().getParameters().put('state','state1');
                ApexPages.currentPage().getParameters().put('code','code1');
                ApexPages.currentPage().getParameters().put('auth', 'true');

                DocomoSignInController docomoSignInController = new DocomoSignInController();
                docomoSignInController.Authentication();
                system.assertEquals(docomoSignInController.TechErrorBetweenDAccountAuthAndCognizant, true);                
            }
        Test.stopTest();
    }

    static testMethod void testAuthenticationRequest() {
        SetUpTestData.triggerSettings();
        
        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'DAZN for Docomo', 'DAZN for Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        Account oAccount = SetUpTestData.createDfDAccount('TestFName', 'TestLName', 'test@test.com','Active Paid', 'accountid1', 'Docomo');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);    

        List<DocomoConfiguration__c> docomoConfiguration = new List<DocomoConfiguration__c>();
        DocomoConfiguration__c docomoConfiguration1 = new DocomoConfiguration__c();
        docomoConfiguration1.Name = 'Default Password';
        docomoConfiguration1.Value__c = EncodingUtil.base64Encode(Blob.valueOf('test!2345'));
        docomoConfiguration.add(docomoConfiguration1);

        DocomoConfiguration__c docomoConfiguration2 = new DocomoConfiguration__c();
        docomoConfiguration2.Name = 'Token Request';
        docomoConfiguration2.Value__c = 'https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/token';
        docomoConfiguration.add(docomoConfiguration2);

        DocomoConfiguration__c docomoConfiguration3 = new DocomoConfiguration__c();
        docomoConfiguration3.Name = 'Host';
        docomoConfiguration3.Value__c = 'docomoproxy.performgroup.com';
        docomoConfiguration.add(docomoConfiguration3);

        DocomoConfiguration__c docomoConfiguration4 = new DocomoConfiguration__c();
        docomoConfiguration4.Name = 'Client ID';
        docomoConfiguration4.Value__c = 'Client ID';
        docomoConfiguration.add(docomoConfiguration4);

        DocomoConfiguration__c docomoConfiguration5 = new DocomoConfiguration__c();
        docomoConfiguration5.Name = 'Client Password';
        docomoConfiguration5.Value__c = 'Client Password';
        docomoConfiguration.add(docomoConfiguration5);

        DocomoConfiguration__c docomoConfiguration6 = new DocomoConfiguration__c();
        docomoConfiguration6.Name = 'UserInfo Request';
        docomoConfiguration6.Value__c = 'https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/userinfo';
        docomoConfiguration.add(docomoConfiguration6);               
        insert docomoConfiguration;

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockDocomoHttpResponse());
        ApexPages.currentPage().getParameters().put('state','state1');
        ApexPages.currentPage().getParameters().put('code','code1');
        DocomoSignInController docomoSignInController = new DocomoSignInController();
        PageReference authenticationRedirect = docomoSignInController.AuthenticationRequest();
        system.assertNotEquals(authenticationRedirect, null);           
        Test.stopTest();
    }

    static testMethod void testRedirectToDualSignInPage() {
        DocomoSignInController docomoSignInController = new DocomoSignInController();
        PageReference signIn = docomoSignInController.redirectToDualSignInPage();
        system.assertEquals(signIn.getUrl(), System.Page.signIn.getUrl());
    }

    /*PD-10365*/
    static testMethod void testCommunityUserAuthenticationNoActiveDAZNSubscriptionOnDocomoAccount() {

        SetUpTestData.triggerSettings();
        User guestUser = [select id, name from User where userType = 'Guest' AND isActive = true LIMIT 1];

        Account oAccount = SetUpTestData.createDfDAccount('TestFName', 'TestLName', 'test@test.com','Active Paid', 'accountid1', 'Docomo');

        List<DocomoConfiguration__c> docomoConfiguration = new List<DocomoConfiguration__c>();
        DocomoConfiguration__c docomoConfiguration1 = new DocomoConfiguration__c();
        docomoConfiguration1.Name = 'Default Password';
        docomoConfiguration1.Value__c = 'dGVzdA==';
        docomoConfiguration.add(docomoConfiguration1);

        DocomoConfiguration__c docomoConfiguration2 = new DocomoConfiguration__c();
        docomoConfiguration2.Name = 'Token Request';
        docomoConfiguration2.Value__c = 'https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/token';
        docomoConfiguration.add(docomoConfiguration2);

        DocomoConfiguration__c docomoConfiguration3 = new DocomoConfiguration__c();
        docomoConfiguration3.Name = 'Host';
        docomoConfiguration3.Value__c = 'docomoproxy.performgroup.com';
        docomoConfiguration.add(docomoConfiguration3);

        DocomoConfiguration__c docomoConfiguration4 = new DocomoConfiguration__c();
        docomoConfiguration4.Name = 'Client ID';
        docomoConfiguration4.Value__c = 'Client ID';
        docomoConfiguration.add(docomoConfiguration4);

        DocomoConfiguration__c docomoConfiguration5 = new DocomoConfiguration__c();
        docomoConfiguration5.Name = 'Client Password';
        docomoConfiguration5.Value__c = 'Client Password';
        docomoConfiguration.add(docomoConfiguration5);

        DocomoConfiguration__c docomoConfiguration6 = new DocomoConfiguration__c();
        docomoConfiguration6.Name = 'UserInfo Request';
        docomoConfiguration6.Value__c = 'https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/userinfo/noactivesubscription';
        docomoConfiguration.add(docomoConfiguration6);               
        insert docomoConfiguration;

        Test.StartTest();
            System.runAs(guestUser) {
                ApexPages.currentPage().getParameters().put('auth', 'true');
                ApexPages.currentPage().getParameters().put('state','state1');
                ApexPages.currentPage().getParameters().put('code','code1');
                Test.setMock(HttpCalloutMock.class, new MockDocomoHttpResponse());

                DocomoSignInController docomoSignInController = new DocomoSignInController();

                PageReference authenticationReference = docomoSignInController.Authentication();
                system.assertEquals(docomoSignInController.NoActiveDAZNSubscriptionOnDocomoAccount, true);       
            }
        Test.stopTest();
    }
    /*PD-9838*/
    static testMethod void testRedirectToSingUpPage() {
        DAZNConfiguration__c daznConfig = new DAZNConfiguration__c(
            Name = 'SignUpUrl',
            Value__c = 'https://test.dazn.com/docomo'
        );
        insert daznConfig;

        DocomoSignInController docomoSignInController = new DocomoSignInController();
        PageReference signUp = docomoSignInController.redirectToSingUpPage();
        system.assertEquals(signUp.getUrl(), 'https://test.dazn.com/docomo');
    }

    /*PD-9838*/
    static testMethod void testRedirectSignInDAccount() {
        DAZNConfiguration__c daznConfig = new DAZNConfiguration__c(
            Name = 'SignInDAccountUrl',
            Value__c = 'https://stag.dazn.com/account/signin-selector'
        );
        insert daznConfig;

        DocomoSignInController docomoSignInController = new DocomoSignInController();
        PageReference signUp = docomoSignInController.redirectSignInDAccount();
        system.assertEquals(signUp.getUrl(), 'https://stag.dazn.com/account/signin-selector');
    }

    /*PD-9838*/
    static testMethod void testRedirectHelpLink() {
        DAZNConfiguration__c daznConfig = new DAZNConfiguration__c(
            Name = 'DocomoHelpLinkUrl',
            Value__c = 'https://my.dazn.com/help'
        );
        insert daznConfig;

        DocomoSignInController docomoSignInController = new DocomoSignInController();
        PageReference signUp = docomoSignInController.redirectHelpLink();
        system.assertEquals(signUp.getUrl(), 'https://my.dazn.com/help');
    }
        /*PD-10749*/
    static testMethod void testDocomoLoginFromContactUs() {
        SetUpTestData.triggerSettings();
        
        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'DAZN for Docomo', 'DAZN for Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        Account oAccount = SetUpTestData.createDfDAccount('TestFName', 'TestLName', 'test@test.com','Active Paid', 'accountid1', 'Docomo');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);

        List<DocomoConfiguration__c> docomoConfiguration = new List<DocomoConfiguration__c>();
        DocomoConfiguration__c docomoConfiguration1 = new DocomoConfiguration__c();
        docomoConfiguration1.Name = 'Default Password';
        docomoConfiguration1.Value__c = 'dGVzdA==';
        docomoConfiguration.add(docomoConfiguration1);

        DocomoConfiguration__c docomoConfiguration2 = new DocomoConfiguration__c();
        docomoConfiguration2.Name = 'Token Request';
        docomoConfiguration2.Value__c = 'https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/token';
        docomoConfiguration.add(docomoConfiguration2);

        DocomoConfiguration__c docomoConfiguration3 = new DocomoConfiguration__c();
        docomoConfiguration3.Name = 'Host';
        docomoConfiguration3.Value__c = 'docomoproxy.performgroup.com';
        docomoConfiguration.add(docomoConfiguration3);

        DocomoConfiguration__c docomoConfiguration4 = new DocomoConfiguration__c();
        docomoConfiguration4.Name = 'Client ID';
        docomoConfiguration4.Value__c = 'Client ID';
        docomoConfiguration.add(docomoConfiguration4);

        DocomoConfiguration__c docomoConfiguration5 = new DocomoConfiguration__c();
        docomoConfiguration5.Name = 'Client Password';
        docomoConfiguration5.Value__c = 'Client Password';
        docomoConfiguration.add(docomoConfiguration5);

        DocomoConfiguration__c docomoConfiguration6 = new DocomoConfiguration__c();
        docomoConfiguration6.Name = 'UserInfo Request';
        docomoConfiguration6.Value__c = 'https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/userinfo/noactivesubscription';
        docomoConfiguration.add(docomoConfiguration6);

        DocomoConfiguration__c docomoConfiguration7 = new DocomoConfiguration__c();
        docomoConfiguration7.Name = 'Authentication Request';
        docomoConfiguration7.Value__c = 'https://id.smt.docomo.ne.jp/cgi8/oidc/authorize?scope=openid offline_access accountid_n dma_service10&response_type=code&client_id=g00_0010_0001_01&redirect_uri={0}&state={1}&nonce={2}&authiden=1';
        docomoConfiguration.add(docomoConfiguration7);
        insert docomoConfiguration;

        SetUpTestData.createCustomProvider('DAZN JP', 'DAZN', 'JP', 'de');
        SetUpTestData.createEmailHelpOption('testEHO', 'testSubj', 'DAZN', 'DAZN', 'JP', 'de');

        User guestUser = [select id, name from User where userType = 'Guest' AND isActive = true LIMIT 1];

        Test.StartTest();
        System.runAs(guestUser) {
            ApexPages.currentpage().getParameters().put('lang', 'de');
            ApexPages.currentpage().getParameters().put('Country', 'JP');
            ApexPages.currentpage().getParameters().put('type', 'testEHO');

            ContactUsController contactUsController = new ContactUsController();
            contactUsController.selectedProvider = 'DAZN';
            PageReference dSignIn = contactUsController.redirectToDocomoSignInPage();

            System.assertEquals(true, dSignIn.getUrl().contains('docomosignin'));
            System.assertEquals(true, dSignIn.getParameters().get('type').contains('testSubj'));
            System.assertEquals('true', dSignIn.getParameters().get('auth'));

            Test.setCurrentPage(dSignIn);

            ApexPages.currentPage().getParameters().put('auth', 'true');

            DocomoSignInController docomoSignInController = new DocomoSignInController();
            PageReference authenticationReference = docomoSignInController.Authentication();
            System.assertEquals(true, authenticationReference.getUrl().contains('https://id.smt.docomo.ne.jp/cgi8/oidc/authorize'));
            System.assertEquals(true, docomoSignInController.State.contains('testSubj'));
        }

        System.runAs(oUser) {
            ApexPages.currentPage().getParameters().put('state', 'contactus;testSubj');
            ApexPages.currentPage().getParameters().put('code', 'accountid1');
            ApexPages.currentPage().getParameters().put('auth', 'not true');
            DocomoSignInController docomoSignInControllerU = new DocomoSignInController();
            PageReference authenticationRef = docomoSignInControllerU.Authentication();
            System.assertEquals(true, authenticationRef.getUrl().contains('contactus'));
            System.assertEquals('testSubj', authenticationRef.getParameters().get('type'));

            ApexPages.currentPage().getParameters().put('state', 'help;DE;en');
            ApexPages.currentPage().getParameters().put('code', 'accountid1');
            ApexPages.currentPage().getParameters().put('auth', 'not true');
            DocomoSignInController docomoSignInControllerU1 = new DocomoSignInController();
            PageReference authenticationRef1 = docomoSignInControllerU1.Authentication();
            System.assertEquals(true, authenticationRef1.getUrl().contains('help'));
            System.assertEquals(true, authenticationRef1.getUrl().contains('DE'));
            System.assertEquals(true, authenticationRef1.getUrl().contains('en'));
        }
        Test.StopTest();
    }

    static testMethod void testAuthenticationRequestDFDBlocked() {
        SetUpTestData.triggerSettings();
        
        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'Docomo', 'Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        Account oAccount = SetUpTestData.createDfDAccount('TestFName', 'TestLName', 'test@test.com','Blocked', 'accountid1', 'Docomo');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);    

        List<DocomoConfiguration__c> docomoConfiguration = new List<DocomoConfiguration__c>();
        DocomoConfiguration__c docomoConfiguration1 = new DocomoConfiguration__c();
        docomoConfiguration1.Name = 'Default Password';
        docomoConfiguration1.Value__c = 'dGVzdA==';
        docomoConfiguration.add(docomoConfiguration1);

        DocomoConfiguration__c docomoConfiguration2 = new DocomoConfiguration__c();
        docomoConfiguration2.Name = 'Token Request';
        docomoConfiguration2.Value__c = 'https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/token';
        docomoConfiguration.add(docomoConfiguration2);

        DocomoConfiguration__c docomoConfiguration3 = new DocomoConfiguration__c();
        docomoConfiguration3.Name = 'Host';
        docomoConfiguration3.Value__c = 'docomoproxy.performgroup.com';
        docomoConfiguration.add(docomoConfiguration3);

        DocomoConfiguration__c docomoConfiguration4 = new DocomoConfiguration__c();
        docomoConfiguration4.Name = 'Client ID';
        docomoConfiguration4.Value__c = 'Client ID';
        docomoConfiguration.add(docomoConfiguration4);

        DocomoConfiguration__c docomoConfiguration5 = new DocomoConfiguration__c();
        docomoConfiguration5.Name = 'Client Password';
        docomoConfiguration5.Value__c = 'Client Password';
        docomoConfiguration.add(docomoConfiguration5);

        DocomoConfiguration__c docomoConfiguration6 = new DocomoConfiguration__c();
        docomoConfiguration6.Name = 'UserInfo Request';
        docomoConfiguration6.Value__c = 'https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/userinfo';
        docomoConfiguration.add(docomoConfiguration6);               
        insert docomoConfiguration;

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockDocomoHttpResponse());
        ApexPages.currentPage().getParameters().put('state','state1');
        ApexPages.currentPage().getParameters().put('code','code1');
        DocomoSignInController docomoSignInController = new DocomoSignInController();
        PageReference authenticationRedirect = docomoSignInController.AuthenticationRequest();
        system.assertEquals(authenticationRedirect, null);           
        Test.stopTest();
    }
}