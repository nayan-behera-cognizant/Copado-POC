/*
Description:This is WhyController test class is using by Subscription cancellation.
PD-7807- Test class is changed as per PD notes.
*/
@IsTest
public class WhyControllerTest {
    @testSetup 
    public static void getCommunityUsersTestData(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateZuoraDataforUnitTest.createZuoraDeatils();
        CreateZuoraDataforUnitTest.createInvoice();
        CreateTestDataforUnitTest.createTestcustomsetting();
        CreateTestDataforUnitTest.CreateGuestUser();
        
        List<DAZNConfiguration__c> config = new List<DAZNConfiguration__c>();
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelSubscSchInFuture',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/42/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelUserName',
            Value__c = 'david.francesconi@dazn.com'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelSubPass',
            Value__c = '58c89e0f46f549eded0a140e8d9a842f'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'AmendPauseURL',
            Value__c = 'https://dev.dazn.com/'
        ));
        insert config;
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
    // To cover with Account Status Active Paid.
    static testMethod void testWhyController() {
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Paid'];
        system.assertNotEquals(null, accList[0]); 
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        system.assertNotEquals(null, oUser[0]); 
        System.RunAs(oUser[0]){
            Test.StartTest();
            WhyController objwhyCntrl = new WhyController();
            objwhyCntrl.sTechnicalRecommedation = 'test';
            objwhyCntrl.sPaymentSwitchRecommendation = 'test';
            objwhyCntrl.sLatestContentOnDAZN = 'test';
            objwhyCntrl.sCancelSubscriptionMsg = 'test';
            PageReference navigatPage = objwhyCntrl.navigateUser();
            String navigatreslut = objwhyCntrl.naviageToMyAccountPage().getUrl();
            System.assertEquals('/MyAccount',navigatreslut);
            
            Test.stopTest();
        }
    }
    // To cover with Account Status Frozen.
    static testMethod void testWhyControllernavigateUser() {
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Frozen'];
        system.assertNotEquals(null, accList[0]); 
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        system.assertNotEquals(null, oUser[0]); 
        System.RunAs(oUser[0]){
            Test.StartTest();
            WhyController objwhyCntrl = new WhyController();
            objwhyCntrl.navigateError = false;
            PageReference navigatPage = objwhyCntrl.navigateUser();
            //System.assertEquals('/LoginPageURL',navigatPage.getURL());
            Test.stopTest();
        }
        //Below lines to cover, Without user accessing cancellation page.
        WhyController objwhyCntrlWithoutUser = new WhyController();
        objwhyCntrlWithoutUser.navigateUser();
    }
    
    
    // To cover with Account Status Active Grace.
    static testMethod void testWhyControllercancelSubscription() {
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Grace'];
        system.assertNotEquals(null, accList[0]);   
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        system.assertNotEquals(null, oUser[0]);   
        System.RunAs(oUser[0]){
            Test.StartTest();
            WhyController objwhyCntrl = new WhyController();
            String navigattomyaccount = objwhyCntrl.naviageToMyAccountPage().getUrl();
            objwhyCntrl.reasonForCncl = 'I want to switch my payment method';
            String navigatreslut = objwhyCntrl.cancelSubscription().getUrl();
            System.assertEquals('/MyAccount',navigattomyaccount);   
            Test.stopTest();
        }
    }
    
    
    /* To cover error handling, Below is for cover error handling in configure recommendation messages. */
    static testMethod void testerrorhandling() {
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Free Trial'];
        system.assertNotEquals(null, accList[0]);
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        system.assertNotEquals(null, oUser[0]);
        System.RunAs(oUser[0]){
            Test.StartTest();
            list<DAZNConfiguration__c> listofDAZNConfig = new list<DAZNConfiguration__c>();
            listofDAZNConfig.add(DAZNConfiguration__c.getValues('FAQURL'));
            listofDAZNConfig[0].Name='FAQURL';
            listofDAZNConfig[0].Value__c='null';
            update listofDAZNConfig;
            WhyController objwhyCntrl = new WhyController();
            String navigatreslut = objwhyCntrl.cancelSubscription().getUrl();
            Test.stopTest();
        }
    }
    
    
    static testMethod void testguestuser(){
        
        List <User> gUser=[select id,UserName,country from user where userType = 'Guest' AND isActive = true limit 1]; 
        system.assertEquals(1,gUser.size());
        DAZN_Help_Redirect__c helpRedirectSetting = new DAZN_Help_Redirect__c();
        helpRedirectSetting.Name = 'Japan';
        helpRedirectSetting.CountryISOCode__c = 'JP';
        helpRedirectSetting.IsDefaultCountry__c = true;
        helpRedirectSetting.Country__c = 'Japan';
        helpRedirectSetting.Language__c = 'ja';
        insert helpRedirectSetting;
        System.assertEquals('Japan', helpRedirectSetting.Country__c); 
        System.RunAs(gUser[0]){
            Test.StartTest();
            WhyController objwhyCntrl = new WhyController();
            test.stopTest();
            
        }
        
    }  
    // test method to cover else part
    static testMethod void testController() {
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Paid'];
        system.assertNotEquals(null, accList[0]);
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        system.assertNotEquals(null, oUser[0]);
        System.RunAs(oUser[0]){
            Test.StartTest();
            WhyController objwhyCntrl = new WhyController();
            objwhyCntrl.oSubscription = null;
             objwhyCntrl.reasonForCncl = 'Others';
            objwhyCntrl.otherReasonValue = 'Others Value';
            objwhyCntrl.cancelSubscription();
        }
    }
    
    
    //test cover for cancel subscription method
    static testmethod void testCancel(){
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Paid'];
        system.assertNotEquals(null, accList[0]);
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey,AccountID from User where ContactId In : contactIdList];
        system.assertNotEquals(null, oUser[0]);
        System.RunAs(oUser[0]){
            Test.StartTest();   
            WhyController objCntrl = new WhyController();
            objCntrl.reasonForCncl = 'Others';
            objCntrl.otherReasonValue = 'Others Value';
            objCntrl.cancelSubscription();
            Test.stopTest();
            
        } 
    }  
    
    /*Start part of PD-11865*/
    static testmethod void testCancelPauseFail(){
        List<Account> accList = [Select Id, PersonEmail,PersonContactId, Pause_From__c, PauseScheduled__c, Pause_Until__c, Previous_BCD__c, Submitted_for_cancellation__c from Account where Account_Status__c = 'Active Paid'];
        //Account acc = accList[0];
        accList[0].Pause_From__c = Date.today().addDays(1);
        accList[0].Pause_Until__c = Date.today().addDays(3);
        update accList[0];
        system.assertNotEquals(null, accList[0]);
        List<Id> contactIdList = new List<Id>();
        for(Account item : accList){
            contactIdList.add(item.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey,AccountID from User where ContactId In : contactIdList];
        system.assertNotEquals(null, oUser[0]);
        System.RunAs(oUser[0]){
            Test.StartTest();   
            Test.setMock(HttpCalloutMock.class, new MockSetPauseFailureResponse());
            WhyController objCntrl = new WhyController();
            objCntrl.cancelSubscription();
            Test.stopTest();
        } 
    } 
    static testmethod void testCancelPauseSuccess(){
        List<Account> accList = [Select Id, PersonEmail,PersonContactId, Pause_From__c, PauseScheduled__c, Pause_Until__c, Previous_BCD__c, Submitted_for_cancellation__c from Account where Account_Status__c = 'Active Paid'];
        //Account acc = accList[0];
        accList[0].Pause_From__c = Date.today().addDays(1);
        accList[0].Pause_Until__c = Date.today().addDays(3);
        update accList[0];
        system.assertNotEquals(null, accList[0]);
        List<Id> contactIdList = new List<Id>();
        for(Account item : accList){
            contactIdList.add(item.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey,AccountID from User where ContactId In : contactIdList];
        system.assertNotEquals(null, oUser[0]);
        System.RunAs(oUser[0]){
            Test.StartTest();   
            Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
            WhyController objCntrl = new WhyController();
            objCntrl.cancelSubscription();
            Test.stopTest();
        } 
    }
    static testmethod void testCancelPauseNow(){
        List<Account> accList = [Select Id, PersonEmail,PersonContactId, Pause_From__c, PauseScheduled__c, Pause_Until__c, Previous_BCD__c, Submitted_for_cancellation__c from Account where Account_Status__c = 'Active Paid'];
        //Account acc = accList[0];
        accList[0].Pause_From__c = Date.today().addDays(-1);
        accList[0].Pause_Until__c = Date.today().addDays(3);
        accList[0].Account_Status__c = 'Paused';
        update accList[0];
        system.assertNotEquals(null, accList[0]);
        List<Id> contactIdList = new List<Id>();
        for(Account item : accList){
            contactIdList.add(item.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey,AccountID from User where ContactId In : contactIdList];
        system.assertNotEquals(null, oUser[0]);
        System.RunAs(oUser[0]){
            Test.StartTest();   
            Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
            WhyController objCntrl = new WhyController();
            objCntrl.cancelSubscription();
            Test.stopTest();
        } 
    }
    static testmethod void testBCD(){
        List<Account> accList = [Select Id, PersonEmail,PersonContactId, Pause_From__c, PauseScheduled__c, Pause_Until__c, Previous_BCD__c, Submitted_for_cancellation__c from Account where Account_Status__c = 'Active Paid'];
        //Account acc = accList[0];
        accList[0].Pause_From__c = Date.today().addDays(1);
        accList[0].Pause_Until__c = Date.today().addDays(3);
        update accList[0];
        system.assertNotEquals(null, accList[0]);
        List<Id> contactIdList = new List<Id>();
        for(Account item : accList){
            contactIdList.add(item.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey,AccountID from User where ContactId In : contactIdList];
        system.assertNotEquals(null, oUser[0]);
        System.RunAs(oUser[0]){
            Test.StartTest();   
            //WhyController objCntrl = new WhyController();
            WhyController.createPreviousBCD('30th of the month');
            WhyController.createPreviousBCD('2th of the month');
            Test.stopTest();
        } 
    }
    
    public class MockSetPauseSuccessResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{ '+
                '    "id": 57, '+
                '    "name": "WF-9-00000011", '+
                '    "originalWorkflowId": 9, '+
                '    "type": "Workflow::Instance", '+
                '    "tasks": { '+
                '        "total": 1, '+
                '        "queued": 1, '+
                '        "processing": 0, '+
                '        "pending": 0, '+
                '        "stopped": 0, '+
                '        "success": 0, '+
                '        "error": 0 '+
                '    }, '+
                '    "runTime": null, '+
                '    "cpuTime": "00:00:00", '+
                '    "createdAt": "2017-03-24 09:56:17 UTC", '+
                '    "updatedAt": "2017-03-24 09:56:17 UTC" '+
                '}'
            );
            res.setStatusCode(200);
            return res;
        }
    }
    
    public class MockSetPauseFailureResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{ '+
                '    "errors": [ '+
                '         { '+
                '             "status": 406, '+
                '             "code": "invalid", '+
                '             "title": "Required field for Workflow-ResumeDate does not have a set value. Ensure parameter \'ResumeDate\' is present." '+
                '         } '+
                '    ], '+
                '    "parameters": { '+
                '        "SubscriptionName": "A-S00000251", '+
                '        "SuspendDate": "2017-03-10", '+
                '        "BCD": 20, '+
                '        "workflow": {} '+
                '    } '+
                '}'
            );
            res.setStatusCode(406);
            return res;
        }
    }
    
    
    /*End Part of PD-11865*/
    static testmethod void testDescriptionFreeTrial(){
        Account oAccount  = [Select Id, PersonEmail,PersonContactId,Account_Status__c,SubscriptionEndDate__c from Account where Account_Status__c = 'Active Paid' LIMIT 1];
        
        oAccount.SubscriptionEndDate__c = Date.Today().addMonths(10);
        update oAccount;
        
        List<Zuora__Subscription__c>lstSubscription = new list<Zuora__Subscription__c>();
        List<Id> contactIdList = new List<Id>();
        
        Zuora__Subscription__c oSubscription = new Zuora__Subscription__c();
        oSubscription.Name = 'test billing account';
        oSubscription.Zuora__Status__c = 'Active' ;
        oSubscription.Zuora__SubscriptionEndDate__c = Date.Today().addMonths(10);
        oSubscription.Zuora__NextChargeDate__c = Date.today().addMonths(2);
        oSubscription.Zuora__Account__c =  oAccount .Id;
        oSubscription.Free_Trial_End_Date__c =  Date.today().addMonths(1);
        oSubscription.Zuora__TermSettingType__c='EVERGREEN';
        oSubscription.Zuora__TermStartDate__c = Date.Today();
        oSubscription.Gift_Code_End_Date__c = Date.today();
        lstSubscription.add(oSubscription);
        insert lstSubscription;
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId =:oAccount.PersonContactId];
      
        oAccount.Notification_Country_Code__c='CA';
        update oAccount;
        
        System.RunAs(oUser[0]){
            Test.StartTest(); 
            WhyController objCntrl = new WhyController();
            
            objCntrl.descriptionActivePaid();
            objCntrl.descriptionFreeTrial();
            
            Test.stopTest();
            
        } 
    }
    
    
    static testmethod void testDescriptionFreeTrial3(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Free Trial');
        oAccount.SubscriptionEndDate__c = Date.Today().addMonths(10);
        update oAccount;
        System.assertNotEquals(null, oAccount);
        List<Zuora__Subscription__c>lstSubscription = new list<Zuora__Subscription__c>();
        List<Id> contactIdList = new List<Id>();
        
        Zuora__Subscription__c oSubscription = new Zuora__Subscription__c();
        oSubscription.Name = 'test billing account';
        oSubscription.Zuora__Status__c = 'Active' ;
        oSubscription.Zuora__SubscriptionEndDate__c = Date.Today().addMonths(10);
        oSubscription.Zuora__NextChargeDate__c = Date.today().addMonths(2);
        oSubscription.Zuora__Account__c =  oAccount .Id;
        oSubscription.Free_Trial_End_Date__c =  Date.today().addMonths(1);
        oSubscription.Zuora__TermSettingType__c='EVERGREEN';
        oSubscription.Zuora__TermStartDate__c = Date.Today();
        oSubscription.Giftcode__c = null;
        lstSubscription.add(oSubscription);
        insert lstSubscription;
        System.assertNotEquals(null, lstSubscription[0]); 
        User cUser = SetUpTestData.createCommunityUser('de', 'DE', oAccount.Id, 'pauseuser@email.com', 'pauseuseree@email.com', 'tstals','Europe/London','ISO-8859-1','de','de','PauseUserFName','PauseUserLName',true);
        
        System.RunAs(cUser){
            Test.StartTest(); 
            
            WhyController objCntrl = new WhyController();
            
            objCntrl.descriptionActivePaid();
            objCntrl.descriptionFreeTrial();
            
            Test.stopTest();
            
        } 
    }
    
    static testmethod void testDescriptionFreeTrial4(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Free Trial');
        oAccount.SubscriptionEndDate__c = Date.Today().addMonths(10);
        update oAccount;
        System.assertNotEquals(null, oAccount);
        
        List<Zuora__Subscription__c>lstSubscription = new list<Zuora__Subscription__c>();
        List<Id> contactIdList = new List<Id>();
        
        Zuora__Subscription__c oSubscription = new Zuora__Subscription__c();
        oSubscription.Name = 'test billing account';
        oSubscription.Zuora__Status__c = 'Active' ;
        oSubscription.Zuora__SubscriptionEndDate__c = Date.Today().addMonths(10);
        oSubscription.Zuora__NextChargeDate__c = Date.today().addMonths(2);
        oSubscription.Zuora__Account__c =  oAccount .Id;
        oSubscription.Free_Trial_End_Date__c =  Date.today().addMonths(1);
        oSubscription.Zuora__TermSettingType__c='EVERGREEN';
        oSubscription.Zuora__TermStartDate__c = Date.Today();
        oSubscription.Giftcode__c ='ttrttvbn';
        oSubscription.Gift_Code_End_Date__c = Date.today();
        lstSubscription.add(oSubscription);
         insert lstSubscription;
        System.assertNotEquals(null, lstSubscription[0]);      
        User cUser = SetUpTestData.createCommunityUser('de', 'DE', oAccount.Id, 'pauseuser@email.com', 'pauseuseree@email.com', 'tstals','Europe/London','ISO-8859-1','de','de','PauseUserFName','PauseUserLName',true);
        
        System.RunAs(cUser){
            Test.StartTest(); 
            WhyController objCntrl = new WhyController();
            
            objCntrl.descriptionActivePaid();
            objCntrl.descriptionFreeTrial();
            
            Test.stopTest();
        } 
    }
    static testmethod void testDescriptionFreeTrial2(){
        Account oAccount  = [Select Id, PersonEmail,PersonContactId,Account_Status__c,SubscriptionEndDate__c from Account where Account_Status__c = 'Active Paid' LIMIT 1];
        
        oAccount.SubscriptionEndDate__c = Date.Today().addMonths(10);
        update oAccount;
        
        List<Zuora__Subscription__c>lstSubscription = new list<Zuora__Subscription__c>();
        List<Id> contactIdList = new List<Id>();
        
        Zuora__Subscription__c oSubscription = new Zuora__Subscription__c();
        oSubscription.Name = 'test billing account';
        oSubscription.Zuora__Status__c = 'Active' ;
        oSubscription.Zuora__SubscriptionEndDate__c = Date.Today().addMonths(10);
        oSubscription.Zuora__NextChargeDate__c = Date.today().addMonths(2);
        oSubscription.Zuora__Account__c =  oAccount .Id;
        oSubscription.Free_Trial_End_Date__c =  Date.today().addMonths(1);
        oSubscription.Zuora__TermSettingType__c='EVERGREEN';
        oSubscription.Zuora__TermStartDate__c = Date.Today();
        oSubscription.Gift_Code_End_Date__c = Date.today();
        lstSubscription.add(oSubscription);
        insert lstSubscription;
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId =:oAccount.PersonContactId];
        
        oAccount.Notification_Country_Code__c='EN';
        update oAccount;
        System.RunAs(oUser[0]){
            Test.StartTest(); 
            
            WhyController objCntrl = new WhyController();
            objCntrl.descriptionActivePaid();
            objCntrl.descriptionFreeTrial();
            
            Test.stopTest();
            
        } 
    }
    static testMethod void testWhyControllernavigateUserActive() {
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Paid'];
        system.assertNotEquals(null, accList[0]); 
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        system.assertNotEquals(null, oUser[0]); 
        System.RunAs(oUser[0]){
            Test.StartTest();
            WhyController objwhyCntrl = new WhyController();
            objwhyCntrl.navigateError = false;
            PageReference navigatPage = objwhyCntrl.navigateUser();
            //System.assertEquals('/LoginPageURL',navigatPage.getURL());
            Test.stopTest();
        }
        //Below lines to cover, Without user accessing cancellation page.
        WhyController objwhyCntrlWithoutUser = new WhyController();
        objwhyCntrlWithoutUser.navigateUser();
    }
    
    
    
    static testMethod void TestActiveSubscription() {
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
       
        User cUser = SetUpTestData.createCommunityUser('de', 'DE', oAccount.Id, 'pauseuser@email.com', 'pauseuseree@email.com', 'tstals','Europe/London','ISO-8859-1','de','de','PauseUserFName','PauseUserLName',true);
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        
        Test.StartTest();
        
        System.RunAs(cUser){
            
            WhyController objCntrl = new  WhyController();
            
            objCntrl.descriptionActivePaid();
            Test.StopTest();
        }
        
    }
    
    static testMethod void TestActiveSubscription2() {
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
        oAccount.Notification_Country_Code__c = 'CA';
        update oAccount ;
        User cUser = SetUpTestData.createCommunityUser('de', 'DE', oAccount.Id, 'pauseuser@email.com', 'pauseuseree@email.com', 'tstals','Europe/London','ISO-8859-1','de','de','PauseUserFName','PauseUserLName',true);
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        zSubsp.Zuora__TermSettingType__c='EVERGREEN';
        
        update zSubsp ;
        
        Test.StartTest();
        
        System.RunAs(cUser){
            
            WhyController objCntrl = new  WhyController();
            
            objCntrl.descriptionActivePaid();
            Test.StopTest();
        }
        
    }
    
    static testMethod void testStartStandardCancelZuoraWorkflow() {
        //Create personal account
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testCustomer123@email.com','Active Paid');
        oAccount.Submitted_for_cancellation__c = true;
        update oAccount;
        //Create Billing Account
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        Zuora__Subscription__c subscription = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Zuora__Subscription__c', '', date.today(), date.today().addDays(7));
        List<Zuora__Subscription__c> subscriptions = [SELECT Id, Name FROM Zuora__Subscription__c WHERE Id =: subscription.Id];
        
        List<DAZNConfiguration__c> config = new List<DAZNConfiguration__c>();
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraStandardCancelUrl',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/552/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseUsername',
            Value__c = 't1'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPausePassword',
            Value__c = 't2'
        ));
        insert config;
        
        Test.StartTest();
        WhyController objwhyCntrl = new WhyController();
        objwhyCntrl.startStandardCancelZuoraWorkflow(subscriptions[0].Name, DateTime.now().format('yyyy-MM-dd'), oAccount.Id);
        Test.setMock(HttpCalloutMock.class, new MockStandardCancelSuccessResponse());
        WhyController objwhyCntrl2 = new WhyController();
        objwhyCntrl2.startStandardCancelZuoraWorkflow(subscriptions[0].Name, DateTime.now().format('yyyy-MM-dd'), oAccount.Id);
        User tmpUser = objwhyCntrl.oUser;
        objwhyCntrl.oUser = null;
        objwhyCntrl.descriptionActivePaid();
        WhyController.createPreviousBCD('EOM');
        PageReference navigatPage = objwhyCntrl.navigateUser();
        objwhyCntrl.oUser = tmpUser;
        objwhyCntrl.getLastDayOfAccess();
        Test.stopTest();
    }
    
    public class MockStandardCancelSuccessResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{ '+
                '    "id": 57, '+
                '    "name": "WF-9-00000011", '+
                '    "originalWorkflowId": 9, '+
                '    "type": "Workflow::Instance", '+
                '    "tasks": { '+
                '        "total": 1, '+
                '        "queued": 1, '+
                '        "processing": 0, '+
                '        "pending": 0, '+
                '        "stopped": 0, '+
                '        "success": 0, '+
                '        "error": 0 '+
                '    }, '+
                '    "runTime": null, '+
                '    "cpuTime": "00:00:00", '+
                '    "createdAt": "2017-03-24 09:56:17 UTC", '+
                '    "updatedAt": "2017-03-24 09:56:17 UTC" '+
                '}'
            );
            res.setStatusCode(200);
            return res;
        }
    }
   static testMethod void testWhyControllernavigateUsernextchargedatenull() {
        Account oAccount  = [Select Id, PersonEmail,PersonContactId,Account_Status__c,SubscriptionEndDate__c from Account where Account_Status__c = 'Active Paid' LIMIT 1];
        
        oAccount.SubscriptionEndDate__c = Date.Today().addMonths(10);
        update oAccount;
        
        List<Zuora__Subscription__c>lstSubscription = new list<Zuora__Subscription__c>();
        List<Id> contactIdList = new List<Id>();
        
        Zuora__Subscription__c oSubscription = new Zuora__Subscription__c();
        oSubscription.Name = 'test billing account';
        oSubscription.Zuora__Status__c = 'Active' ;
        oSubscription.Zuora__SubscriptionEndDate__c = Date.Today().addMonths(10);
        oSubscription.Zuora__NextChargeDate__c = Date.today().addMonths(-2);
        oSubscription.Zuora__Account__c =  oAccount .Id;
        oSubscription.Free_Trial_End_Date__c =  Date.today().addMonths(-1);
        oSubscription.Zuora__TermSettingType__c='EVERGREEN';
        oSubscription.Zuora__TermStartDate__c = Date.Today();
        lstSubscription.add(oSubscription);
        insert lstSubscription;
        
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId =:oAccount.PersonContactId];
      
        system.assertNotEquals(null, oUser ); 
        System.RunAs(oUser[0]){
            Test.StartTest();
            WhyController objwhyCntrl = new WhyController();
            objwhyCntrl.navigateError = false;
            PageReference navigatPage = objwhyCntrl.navigateUser();
           
            Test.stopTest();
        }
        
    }
}