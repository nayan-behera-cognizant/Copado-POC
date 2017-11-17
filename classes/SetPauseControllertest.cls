/**
*  @author: Megha Jain
*  @date March 24, 2017
*  @description : Test the functionality of SetPauseController
*/
@isTest
private class SetPauseControllertest{
    
    public static void insertZuoraIntegrationParameters() {
        List<DAZNConfiguration__c> config = new List<DAZNConfiguration__c>();
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraStandardPauseResumeScheduleUrl',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/9/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraCancelPauseBeforeStartURL',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/151/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraChangeResumeDatesWhileInPauseURL',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/150/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraChangeResumeDatesBeforePauseURL',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/285/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseUsername',
            Value__c = 'david.francesconi@dazn.com'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPausePassword',
            Value__c = '58c89e0f46f549eded0a140e8d9a842f'
        ));
        insert config; 
    } 
    
    @testSetup 
    public static void getCommunityUsersTestData(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateZuoraDataforUnitTest.createZuoraDeatils();
        CreateTestDataforUnitTest.createTestcustomsetting();
        
        
    }   
    
    /**
*  @author: Megha Jain
*  @Last Modified by: Nayan Behera 
*  @date March 24, 2017
*  @description : This method is used to create test DAZN Event
*/
    
    Public static DAZN_Events_Calendar__c createDaznEvent (String strDescription,Boolean majEvent, Date evntDate, String strLocalisedDt, String countryCode, String countryLang){
        DAZN_Events_Calendar__c dE = new DAZN_Events_Calendar__c();
        dE.Localised_Event_description__c = strDescription;
        dE.Is_Major_Event__c = majEvent;
        dE.Event_Date__c = evntDate;
        dE.Localised_Date__c = strLocalisedDt;
        dE.Event_Country__c = countryCode;
        dE.Country_language__c = countryLang;       
        insert dE;
        return dE;
    }
    
    public static User createTestUser(Id profileId, String countryCode, String stremail, String strUserName, String strAlias, String strTimeZoneSidKey, String strEmailEncodingKey, String strLocaleSidKey, String strLanguageLocaleKey, String strFirstName, String strLastName, Boolean bisActive){
        
        /* Create Community User*/
        User oUser = new User();
        oUser.email= stremail;
        oUser.UserName= strUserName;
        oUser.Alias = strAlias;
        oUser.TimeZoneSidKey= strTimeZoneSidKey;
        oUser.EmailEncodingKey= strEmailEncodingKey;
        oUser.LocaleSidKey= strLocaleSidKey;
        oUser.LanguageLocaleKey= strLanguageLocaleKey;
        oUser.FirstName = strFirstName;
        oUser.LastName = strLastName;
        oUser.isActive= bisActive;
        oUser.CountryCode = countryCode;
        oUser.profileid = profileId;
        insert oUser;
        return oUser;
    }
    
    static testMethod void TestCalNextBillingDatePaused() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Paused');
        
        Date myDateTime = Date.today();
        Date newDateTime = myDateTime.addDays(10);
        
        oAccount.Pause_From__c = Date.today() - 10;
        oAccount.Pause_Until__c = newDateTime;
        update oAccount;
        
        User cUser = SetUpTestData.createCommunityUser('en_US', 'DE', oAccount.Id, 'pauseuser@email.com', 'pauseuseree@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','PauseUserFName','PauseUserLName',true);
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        zSubsp.Zuora__NextChargeDate__c = Date.today() + 10;
        
        update zSubsp ; 
        
        Test.StartTest();
        
        System.RunAs(cUser) {
            SetPauseController objCntrl = new SetPauseController();
            objCntrl.calcNextBillingdate();
            objCntrl.searchMajorEvent();
            objCntrl.majEventDescriptionflag = true; 
            objCntrl.majEventLocalDate = CommunityHelper.ConvertDateToString(oAccount.Pause_Until__c , 'jp');
        }
        Test.StopTest();
    }
    
    static testMethod void TestCalNextBillingDatePauseschedule() {
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
        oAccount.Pause_From__c =date.newinstance(2020,4,15);
        oAccount.Pause_Until__c = date.newinstance(2020,5,15);
        update oAccount;
        User cUser = SetUpTestData.createCommunityUser('de', 'DE', oAccount.Id, 'pauseuser@email.com', 'pauseuseree@email.com', 'tstals','Europe/London','ISO-8859-1','de','de','PauseUserFName','PauseUserLName',true);
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        zSubsp.Zuora__NextChargeDate__c = Date.today() + 10;
        update zSubsp ; 
        Test.StartTest();
        System.RunAs(cUser){
            SetPauseController objCntrl = new SetPauseController();
            objCntrl.calcNextBillingdate();
            objCntrl.majEventDescriptionflag = true; 
            objCntrl.majEventLocalDate = CommunityHelper.ConvertDateToString(oAccount.Pause_Until__c, 'de');
            
            Test.StopTest();
        }
    }
    static testMethod void TestCalNextBillingActivePaid() {
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
        oAccount.Pause_Until__c = date.newinstance(2020,5,15);
        
        update oAccount;
        User cUser = SetUpTestData.createCommunityUser('ja', 'DE', oAccount.Id, 'pauseuser@email.com', 'pauseuseree@email.com', 'tstals','Europe/London','ISO-8859-1','ja','ja','PauseUserFName','PauseUserLName',true);
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        
        Zuora__Subscription__c oSubscription = new Zuora__Subscription__c();
        oSubscription.Name = 'testSub';
        oSubscription.Zuora__Status__c = 'Active';
        oSubscription.Zuora__SubscriptionStartDate__c =Date.Today()-10;
        oSubscription.Zuora__NextChargeDate__c = Date.Today()+30 ;
        oSubscription.Zuora__Account__c = oAccount.Id;
        oSubscription.Zuora__CustomerAccount__c = bAccount.Id;
        insert oSubscription;
        
        Test.StartTest();
        
        System.RunAs(cUser){
            
            SetPauseController objCntrl = new SetPauseController();
            objCntrl.calcNextBillingdate();
            objCntrl.searchEventDynamically();
            objCntrl.majEventDescriptionflag = true; 
            Test.StopTest();
        }
        
    }
    
    static testMethod void TestCalNextBillingNextChargeDateNull() {
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
        oAccount.Pause_Until__c = date.newinstance(2020,5,15);
        
        update oAccount;
        
        System.assertNotEquals(null, oAccount);
        
        User cUser = SetUpTestData.createCommunityUser('ja', 'DE', oAccount.Id, 'pauseuser@email.com', 'pauseuseree@email.com', 'tstals','Europe/London','ISO-8859-1','ja','ja','PauseUserFName','PauseUserLName',true);
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        
        System.assertNotEquals(null, zSubsp );
        
        Test.StartTest();
        System.RunAs(cUser){
            SetPauseController objCntrl = new SetPauseController();
            
            objCntrl.calcNextBillingdate();
            objCntrl.searchEventDynamically();
            objCntrl.majEventDescriptionflag = true; 
            
            Test.StopTest();
        }
        
    }
    
    static testMethod void TestsearchMajorEventActivePaid() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
        User cUser = SetUpTestData.createCommunityUser('EN_GB', 'JP', oAccount.Id, 'PauseUseremail@email.com', 'PauseUser@email.com', 'tstals','Europe/London','ISO-8859-1','EN_GB','EN_GB','PauseUserFName','PauseUserLName',true);
        
        Date myDateTime = Date.today();
        Date newDateTime = myDateTime.addDays(10);
        
        DAZN_Events_Calendar__c dE = new DAZN_Events_Calendar__c();
        dE.Localised_Event_description__c = 'strDescription';
        dE.Is_Major_Event__c = True;
        dE.Event_Date__c = Date.Today()+30 ;
        dE.Localised_Date__c = 'strLocalisedDt';
        dE.Event_Country__c = 'JP';
        dE.Country_language__c = 'en_GB';       
        insert dE;
        
        Test.StartTest();
        System.RunAs(cUser) {
            SetPauseController objCntrl = new SetPauseController();
            objCntrl.sCountryCode = 'JP';
            objCntrl.strLangCode = 'EN_GB';
            objCntrl.searchMajorEvent ();
            objCntrl.searchEventDynamically();
            
            objCntrl.majEventDescriptionflag = true; 
        }
        Test.StopTest();
    }
    
    static testMethod void SearchMajorEventTest_NoPause() {
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
        
        List<Profile> profile=[select Id,Name from profile where Name='LiveSport Team Member' limit 1];
        system.assertEquals(false, profile.isEmpty());
        //List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=true limit 1];
        User testUser = createTestUser(profile[0].Id,'JP','abct@test.com','testUsert123445454@test.com','tusert','Europe/London','ISO-8859-1', 'en_GB', 'en_GB','PAFirstNamte', 'PALastNamte',true);
        testUser.LanguageLocaleKey = 'EN_GB';
        testUser.CountryCode = 'JP';
        update testUser;
        Date myDateTime = date.Today();
        Date newDateTime = myDateTime.addDays(10);
        
        DAZN_Events_Calendar__c dazn = createDaznEvent('IPL 20126',true, newDateTime ,'12/04/2017', 'JP', 'EN_GB');
        
       Test.StartTest();
        
        System.runAS(testUser)
        {
            SetPauseController objCntrl = new SetPauseController(); 
            objCntrl.sCountryCode = 'JP';
            objCntrl.strLangCode = 'EN_GB';
            objCntrl.user = testUser;
            objCntrl.searchMajorEvent();
            objCntrl.searchOtherEvent();
            objCntrl.pauseIsDone();
            objCntrl.searchEventDynamically();
            objCntrl.getNextDateForSetPause();
            Test.StopTest();
        }
    }
    
    
    static testMethod void testSearchpastEvent() { 
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName','test@test.com','Active');
        List<Profile> profile=[select Id,Name from profile where Name='LiveSport Team Member' limit 1];
        system.assert(profile.size()>0);
        User testUser = createTestUser(profile[0].Id,'JP','abct@test.com','testUsert123445454@test.com','tusert','Europe/London','ISO-8859-1', 'en_GB', 'en_GB','PAFirstNamte', 'PALastNamte',true);
        //List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=true limit 1];
        DAZN_Events_Calendar__c dazn = createDaznEvent('IPL 2016',True,date.newInstance(2017, 2, 15),'12/04/2016', 'AT', 'EN_GB');
        dazn.Event_Date__c = (Date.Today()- 15);
        update dazn;
        System.RunAs(testUser){
            Test.StartTest();
            SetPauseController objCntrl = new SetPauseController(); 
            objCntrl.searchMajorEvent();
            objCntrl.searchOtherEvent();
            objCntrl.searchEventDynamically();
            Test.StopTest();        
        } 
    }
    
    static testMethod void test_searchOtherEvent() { 
        String strDate = '2017-05-10';
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName','test@test.com','Active');
        List<Profile> profile=[select Id,Name from profile where Name='LiveSport Team Member' limit 1];
        system.assert(profile.size()>0);
        User testUser = createTestUser(profile[0].Id,'JP','abct@test.com','testUsert123445454@test.com','tusert','Europe/London','ISO-8859-1', 'en_GB', 'en_GB','PAFirstNamte', 'PALastNamte',true);
        //List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=true limit 1];
        DAZN_Events_Calendar__c dazn = createDaznEvent('IPL 20126',False, date.newInstance(2517, 4, 15),'12/04/2017', 'AT', 'EN_GB');
        System.RunAs(testUser){
            Test.StartTest();
            SetPauseController objCntrl = new SetPauseController();
            objCntrl.searchMajorEvent();
            objCntrl.searchOtherEvent();
            objCntrl.pauseIsDone();
            objCntrl.getNextDateForSetPause();
            objCntrl.searchEventDynamically(); 
            objCntrl.sCountryCode = 'AT';
            objCntrl.strLangCode = 'EN_GB';  
            SetPauseController.setStringToDateFormat(strDate);       
            Test.StopTest();     
        } 
    } 
    
    static testMethod void SearchMajorEventTest_NPause() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName','test@test.com','Active');
        List<Profile> profile = [select Id,Name from profile where Name='LiveSport Team Member' limit 1];
        Profile communityUserprofile = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
        User testuser= SetUpTestData.createCommunityUser('en_GB', 'JP', oAccount.Id, 'PauseUseremail@email.com', 'PauseUser@email.com', 'tstals','Europe/London','ISO-8859-1','EN_GB','EN_GB','PauseUserFName','PauseUserLName',true);
        User loginUser = [Select Id,AccountId From User Where ContactId = : oAccount.PersonContactId limit 1];
        System.runAs(testUser){ 
            Test.StartTest();
            DAZN_Events_Calendar__c dazn = createDaznEvent('IPL 20126',true,date.newInstance(2517, 4, 15) ,'12/04/2017', 'JP', 'en_GB');
            SetPauseController objCntrl = new SetPauseController(); 
            objCntrl.user = loginUser;
            objCntrl.searchMajorEvent();
            objCntrl.searchOtherEvent();
            objCntrl.pauseIsDone();
            objCntrl.getNextDateForSetPause();
            objCntrl.searchEventDynamically();
            objCntrl.sCountryCode = 'JP';
            objCntrl.strLangCode = 'EN_GB';  
            Test.StopTest();
        }
    }  
    
    static testMethod void SearchMajorEventTest_NoPause_new() {
        Account testPersonAccount = [Select Id, PersonEmail,PersonContactId from Account where PersonContactId <> null limit 1];
        List<Profile> profile = [select Id,Name from profile where Name='LiveSport Team Member' limit 1];
        Profile communityUserprofile = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
        User testUser = createTestUser(profile[0].Id,'JP','abct@test.com','testUsert123445454@test.com','tusert','Europe/London','ISO-8859-1', 'en_GB', 'en_GB','PAFirstNamte', 'PALastNamte',true);             
        User loginUser = [Select Id,AccountId From User Where ContactId = : testPersonAccount.PersonContactId];
        System.runAs(testUser){ 
            Test.StartTest();
            DAZN_Events_Calendar__c dazn = createDaznEvent('IPL 20126',true,date.newInstance(2517, 4, 15) ,'12/04/2017', 'JP', 'en_GB');
            SetPauseController objCntrl = new SetPauseController(); 
            objCntrl.user = loginUser;
            objCntrl.searchMajorEvent();
            objCntrl.searchOtherEvent();
            objCntrl.pauseIsDone();
            objCntrl.getNextDateForSetPause();
            objCntrl.searchEventDynamically();
            objCntrl.sCountryCode = 'JP';
            objCntrl.strLangCode = 'EN_GB';
            Test.StopTest();
        }
    }
    
    static testMethod void SearchMajorEventTest_Paused() {
        list<Account> testPersonAccountList = [Select Id, PersonEmail,PersonContactId from Account where PersonContactId <> null];
        List<Profile> profile = [select Id,Name from profile where Name='LiveSport Team Member' limit 1];
        Profile communityUserprofile = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
        User testUser = createTestUser(profile[0].Id,'JP','abcx@test.com','testUserx1235@test.com','tuserx','Europe/London','ISO-8859-1', 'en_GB', 'en_GB','PAFirstNamxe', 'PALastNamxe',true);                     
        list<Id> conIdList = new list<Id>();
        for(Account acc : testPersonAccountList)
            conIdList.add(acc.PersonContactId);
        list<User> loginUserList = [Select Id,AccountId From User Where ContactId IN: conIdList];
        loginUserList[0].CountryCode = 'JP';
        loginUserList[0].LanguageLocaleKey='en_GB';
        update loginUserList[0];        
        System.runAs(testUser){ 
            Test.StartTest();
            Delete [Select Id From DAZN_Events_Calendar__c];
            DAZN_Events_Calendar__c dazn = createDaznEvent('IPL 20126',true,date.newInstance(2517, 4, 15) ,'12/04/2017', 'JP', 'en_GB');           
            list<Account> accList = new list<Account>(); 
            for(Account acc : [Select Id,Pause_From__c,Notification_Country_Code__c,Notification_Language_Code__c From Account]){
                acc.Pause_From__c = date.today() + 1;
                acc.Pause_Until__c = date.newinstance(2517, 4, 15);
                acc.Notification_Country_Code__c = 'JP';
                acc.Notification_Language_Code__c = 'en_GB';
                accList.add(acc);
            }
            update accList;
            SetPauseController objCntrl = new SetPauseController(); 
            objCntrl.nextDateVar = System.today() - 1;
            objCntrl.sCountryCode = 'JP';
            objCntrl.strLangCode = 'en_GB';
            objCntrl.user = loginUserList[0];
            objCntrl.searchMajorEvent();
            objCntrl.searchOtherEvent();
            objCntrl.pauseIsDone();
            objCntrl.getNextDateForSetPause();
            objCntrl.searchEventDynamically();
            Test.StopTest();
        }
    } 
    
    static testMethod void SearchMajorEventTest_Paused_new() {
        Date myDateTime = Date.today();
        Date newDateTime = myDateTime.addDays(10);
        list<Account> testPersonAccountList = [Select Id, PersonEmail,PersonContactId from Account where PersonContactId <> null];
        List<Profile> profile = [select Id,Name from profile where Name='LiveSport Team Member' limit 1];
        Profile communityUserprofile = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
        User testUser = createTestUser(profile[0].Id,'JP','abcd@test.com','testUserr1236@test.com','tuserr','Europe/London','ISO-8859-1', 'en_GB', 'en_GB','PAFirstNamee', 'PALastNamee',true);                     
        list<Id> conIdList = new list<Id>();
        for(Account acc : testPersonAccountList)
            conIdList.add(acc.PersonContactId);
        list<User> loginUserList = [Select Id,AccountId From User Where ContactId IN: conIdList];
        loginUserList[0].CountryCode = 'JP';
        loginUserList[0].LanguageLocaleKey='en_GB';
        update loginUserList[0];        
        System.runAs(testUser){ 
            Test.StartTest();
         
            list<Account> accList = new list<Account>(); 
            for(Account acc : [Select Id,Pause_From__c,Pause_Until__c  From Account]){
                
                acc.Pause_From__c = myDateTime.addDays(5); 
                acc.Pause_Until__c =newDateTime;
                
                accList.add(acc);    
            }
            update accList;
           
            List <DAZN_Events_Calendar__c>lstDazn = new List <DAZN_Events_Calendar__c >();
            DAZN_Events_Calendar__c dE = new DAZN_Events_Calendar__c();
            
            dE.Localised_Event_description__c = 'test';
            dE.Is_Major_Event__c = true;
            dE.Event_Date__c = newDateTime;
            dE.Localised_Date__c = '67/78/78';
            dE.Event_Country__c = 'JP';
            dE.Country_language__c = 'en_GB';       
            
            lstDazn.add(dE);
            
            DAZN_Events_Calendar__c dEz = new DAZN_Events_Calendar__c();
            
            dEz.Localised_Event_description__c = 'test';
            dEz.Is_Major_Event__c = true;
            dEz.Event_Date__c = myDateTime.addDays(20);
            dEz.Localised_Date__c = '67/78/78';
            dEz.Event_Country__c = 'JP';
            dEz.Country_language__c = 'en_GB';   
            
            lstDazn.add(dEz);
            
            insert lstDazn ;
            SetPauseController objCntrl = new SetPauseController(); 
            objCntrl.user = loginUserList[0];
            objCntrl.searchMajorEvent();
            objCntrl.searchOtherEvent();
            objCntrl.pauseIsDone();
            objCntrl.getNextDateForSetPause();
            objCntrl.searchEventDynamically();
            objCntrl.sCountryCode = 'JP';
            objCntrl.strLangCode = 'EN_GB';
            Test.StopTest();
        }
    } 
    
    static testMethod void SearchMinorEventTest() {
        list<Account> testPersonAccountList = [Select Id, PersonEmail,PersonContactId from Account where PersonContactId <> null ];
        List<Profile> profile = [select Id,Name from profile where Name='LiveSport Team Member' limit 1];
        Profile communityUserprofile = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
        list<Id> conIdList = new list<Id>();
        for(Account acc : testPersonAccountList)
            conIdList.add(acc.PersonContactId);
        list<User> loginUserList = [Select Id,AccountId From User Where ContactId IN: conIdList];
        loginUserList[0].CountryCode = 'JP';
        loginUserList[0].LanguageLocaleKey='en_GB';
        update loginUserList[0];
        User testUser = createTestUser(profile[0].Id,'JP','abce@test.com','testUsere1238@test.com','tusere','Europe/London','ISO-8859-1', 'en_GB', 'en_GB','PAFirstNamev', 'PALastNamev',true);             
        System.runAs(testUser){
            Test.StartTest();
            DAZN_Events_Calendar__c dazn = createDaznEvent('IPL 20126',false,date.newInstance(2517, 4, 15),'12/04/2017', 'JP', 'en_GB');
            for(Account acc: testPersonAccountList)
                acc.Pause_From__c = date.newinstance(2517, 4, 15); 
            update testPersonAccountList;  
            SetPauseController objCntrl = new SetPauseController(); 
            objCntrl.user = null;
            objCntrl.fetchPauseAccount();
            objCntrl.user = loginUserList[0];
            objCntrl.searchMajorEvent();
            objCntrl.searchOtherEvent();
            objCntrl.pauseIsDone(); 
            objCntrl.getNextDateForSetPause();
            objCntrl.searchEventDynamically();
            SetPauseController.redirectToErrorPage('mylogin');
            objCntrl.sCountryCode = 'JP';
            objCntrl.strLangCode = 'EN_GB';
            Test.StopTest();    
        }       
    }
    
    static testMethod void testCommunityHelperConvertDateToString() {
        Integer i = 1;
        Account testPersonAccount = [Select Id, PersonEmail,PersonContactId from Account where PersonContactId <> null limit 1];
        List<Profile> profile = [select Id,Name from profile where Name='LiveSport Team Member' limit 1];
        Profile communityUserprofile = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
        User loginUser = [Select Id,AccountId From User Where ContactId = : testPersonAccount.PersonContactId];
        Test.StartTest();
        
        List<DAZN_Country_Localized_Month__c> lstCustomSetting = new List<DAZN_Country_Localized_Month__c>();
        
        lstCustomSetting.add(new DAZN_Country_Localized_Month__c(name='en_GB_January',Language_Code__c= 'en_GB', Month_In_Local_Lang__c='Jan', Month_In_Number__c='1'));  
        
        insert lstCustomSetting ; 
        Map<String,String>monthAndCountryMap = new Map<String,String>();
        monthAndCountryMap.put('de_GB:1','Jan');
        LS_PauseHelper objCntrl = new LS_PauseHelper(); 
        CommunityHelper.ConvertDateToString(date.newinstance(2507, 1, 15), 'en_GB');
        CommunityHelper.localMonthNameForLanguageSwitch(i,'de');
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetDateFromStringSuccess() {
        Test.startTest();
        Date convertedDate = SetPauseController.getDateFromString('2017-03-14');
        System.assertNotEquals(null, convertedDate);
        Test.stopTest();
    }
    
    @isTest
    static void testGetDateFromStringFail() {
        Test.startTest();
        Date convertedDate = SetPauseController.getDateFromString('FakeDate');
        System.assertEquals(null, convertedDate);
        Test.stopTest();
    }
    
    @isTest static void testSetPauseInit() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, PersonContactId, Account_Status__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account LIMIT 1];
        User oUser = [Select Id, ContactId, Country From User Where ContactId = :oAccount.PersonContactId];
        
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        SetPauseController ctrl = new SetPauseController();
        
        DateTime dtResumeDate = Date.today() + 11;
        DateTime dtSuspendDate = Date.today() + 1;
        String resumeDate = dtResumeDate.format('yyyy-MM-dd');
        String suspendDate = dtSuspendDate.format('yyyy-MM-dd');
        
        PageReference pr;
        System.runAs(oUser) {
            ctrl.strAction = 'initiate';
            ctrl.strSuspendDate = suspendDate;
            ctrl.strResumeDate = resumeDate;
            ctrl.sCountryCode = 'JP';
            ctrl.strLangCode = 'EN_GB';
            //pr = ctrl.processPause();
            pr = SetPauseController.processPause('initiate', suspendDate, resumeDate, 'DE', 'en');
        }
        
        System.assertNotEquals(null, pr);
        Test.stopTest();
    }
    
    @isTest static void testSetPauseAmend() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, PersonContactId, Pause_From__c, Account_Status__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account LIMIT 1];
        oAccount.Pause_From__c = Date.today() + 1;
        update oAccount;
        User oUser = [Select Id, ContactId, Country From User Where ContactId = :oAccount.PersonContactId];
        
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        SetPauseController ctrl = new SetPauseController();
        
        DateTime dtResumeDate = Date.today() + 11;
        DateTime dtSuspendDate = Date.today() + 1;
        String resumeDate = dtResumeDate.format('yyyy-MM-dd');
        String suspendDate = dtSuspendDate.format('yyyy-MM-dd');
        
        PageReference pr;
        System.runAs(oUser) {
            ctrl.strAction = 'amend';
            ctrl.strSuspendDate = suspendDate;
            ctrl.strResumeDate = resumeDate;
            ctrl.sCountryCode = 'JP';
            ctrl.strLangCode = 'EN_GB';
            //pr = ctrl.processPause();
            pr = SetPauseController.processPause('amend', suspendDate, resumeDate, 'DE', 'en');
        }
        
        System.assertNotEquals(null, pr);
        Test.stopTest();
    }
    
    @isTest static void testSetPauseAmendPaused() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, PersonContactId, Pause_From__c, Account_Status__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account LIMIT 1];
        oAccount.Pause_From__c = Date.today() - 1;
        update oAccount;
        User oUser = [Select Id, ContactId, Country From User Where ContactId = :oAccount.PersonContactId];
        
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        SetPauseController ctrl = new SetPauseController();
        
        DateTime dtResumeDate = Date.today() + 11;
        DateTime dtSuspendDate = Date.today() - 1;
        String resumeDate = dtResumeDate.format('yyyy-MM-dd');
        String suspendDate = dtSuspendDate.format('yyyy-MM-dd');
        
        PageReference pr;
        System.runAs(oUser) {
            ctrl.strAction = 'amend';
            ctrl.strSuspendDate = suspendDate;
            ctrl.strResumeDate = resumeDate;
            ctrl.sCountryCode = 'JP';
            ctrl.strLangCode = 'EN_GB';
            //pr = ctrl.processPause();
            pr = SetPauseController.processPause('amend', suspendDate, resumeDate, 'DE', 'en');
        }
        
        System.assertNotEquals(null, pr);
        Test.stopTest();
    }
    
    @isTest static void testSetPauseCancel() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, PersonContactId, Account_Status__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account LIMIT 1];
        User oUser = [Select Id, ContactId, Country From User Where ContactId = :oAccount.PersonContactId];
        
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        SetPauseController ctrl = new SetPauseController();
        
        DateTime dtResumeDate = Date.today() + 11;
        DateTime dtSuspendDate = Date.today() + 1;
        String resumeDate = dtResumeDate.format('yyyy-MM-dd');
        String suspendDate = dtSuspendDate.format('yyyy-MM-dd');
        
        ctrl.sCountryCode = 'JP';
        ctrl.strLangCode = 'EN_GB';
        
        PageReference pr;
        System.runAs(oUser) {
            ctrl.strAction = 'cancel';
            //pr = ctrl.processPause();
            pr = SetPauseController.processPause('cancel', '', '', 'DE', 'en');
        }
        
        System.assertNotEquals(null, pr);
        Test.stopTest();
    }
    
    @isTest static void testSetPauseCancelPaused() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, PersonContactId, Account_Status__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account LIMIT 1];
        User oUser = [Select Id, ContactId, Country From User Where ContactId = :oAccount.PersonContactId];
        
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        SetPauseController ctrl = new SetPauseController();
        ctrl.sCountryCode = 'JP';
        ctrl.strLangCode = 'EN_GB';
        DateTime dtResumeDate = Date.today() + 11;
        DateTime dtSuspendDate = Date.today() + 1;
        String resumeDate = dtResumeDate.format('yyyy-MM-dd');
        String suspendDate = dtSuspendDate.format('yyyy-MM-dd');
        
        PageReference pr;
        System.runAs(oUser) {
            ctrl.strAction = 'cancel';
            //pr = ctrl.processPause();
            pr = SetPauseController.processPause('cancel', '', '', 'DE', 'en');
        }
        
        System.assertNotEquals(null, pr);
        Test.stopTest();
    }
    
    @isTest static void testSetPauseAmendFailure() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, PersonContactId, Pause_From__c, Account_Status__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account LIMIT 1];
        oAccount.Pause_From__c = Date.today() + 1;
        update oAccount;
        User oUser = [Select Id, ContactId, Country From User Where ContactId = :oAccount.PersonContactId];
        
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseFailureResponse());
        SetPauseController ctrl = new SetPauseController();
        
        DateTime dtResumeDate = Date.today() + 11;
        DateTime dtSuspendDate = Date.today() + 1;
        String resumeDate = dtResumeDate.format('yyyy-MM-dd');
        String suspendDate = dtSuspendDate.format('yyyy-MM-dd');
        ctrl.sCountryCode = 'JP';
        ctrl.strLangCode = 'EN_GB';
        
        PageReference pr;
        System.runAs(oUser) {
            ctrl.strAction = 'amend';
            ctrl.strSuspendDate = suspendDate;
            ctrl.strResumeDate = resumeDate;
            //pr = ctrl.processPause();
            pr = SetPauseController.processPause('amend', suspendDate, resumeDate, 'DE', 'en');
        }
        
        System.assertNotEquals(null, pr);
        Test.stopTest();
    }
    
    @isTest static void testSearchEventDynamicallyPaused() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, PersonContactId, Pause_From__c, Account_Status__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account LIMIT 1];
        oAccount.Account_Status__c = 'Paused';
        oAccount.Pause_From__c = Date.today() - 1;
        update oAccount;
        User oUser = [Select Id, ContactId, Country From User Where ContactId = :oAccount.PersonContactId];
        
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        
        DAZN_Events_Calendar__c dazn = createDaznEvent('IPL 20126', true, Date.today(), DateTime.now().format('dd/MM/yyyy'), 'JP', 'EN_GB');
        
        Test.startTest();
        
        PageReference pr;
        System.runAs(oUser) {
            
            SetPauseController ctrl = new SetPauseController();
            ctrl.sCountryCode = 'JP';
            ctrl.strLangCode = 'EN_GB';
            ctrl.strEventDate = DateTime.now().format('yyyy-MM-dd');
            pr = ctrl.searchEventDynamically();
        }
        
        System.assertNotEquals(null, pr);
        Test.stopTest();
    }
    
    @isTest static void testSearchEventDynamicallyNotPaused() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = SetUpTestData.createPersonAccount('JP', 'EN_GB', 'TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
        oAccount.Account_Status__c = 'Active Paid';
        oAccount.Pause_From__c = Date.today() - 1;
        update oAccount;
        User testuser = SetUpTestData.createCommunityUser('EN_GB', 'JP', oAccount.Id, 'PauseUseremail@email.com', 'PauseUser@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'EN_GB', 'EN_GB', 'PauseUserFName', 'PauseUserLName', true);
        
        DAZN_Events_Calendar__c dazn = createDaznEvent('IPL 20126', true, Date.today(), DateTime.now().format('dd/MM/yyyy'), 'JP', 'EN_GB');
        
        Test.startTest();
        
        PageReference pr;
        System.runAs(testuser) {
            SetPauseController ctrl = new SetPauseController();
            ctrl.strEventDate = DateTime.now().format('yyyy-MM-dd');
            ctrl.sCountryCode = 'JP';
            ctrl.strLangCode = 'EN_GB';
            pr = ctrl.searchEventDynamically();
        }
        
        System.assertNotEquals(null, pr);
        Test.stopTest();
    }
    
    @isTest static void testSearchEventDynamicallyPausedOtherEventLst() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, PersonContactId, Pause_From__c, Account_Status__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account LIMIT 1];
        oAccount.Account_Status__c = 'Paused';
        oAccount.Pause_From__c = Date.today() - 1;
        update oAccount;
        User oUser = [Select Id, ContactId, Country From User Where ContactId = :oAccount.PersonContactId];
        
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        
        DAZN_Events_Calendar__c dazn = createDaznEvent('IPL 20126', false, Date.today(), DateTime.now().format('dd/MM/yyyy'), 'JP', 'EN_GB');
        
        Test.startTest();
        
        PageReference pr;
        System.runAs(oUser) {
            
            SetPauseController ctrl = new SetPauseController();
            ctrl.sCountryCode = 'JP';
            ctrl.strLangCode = 'EN_GB';
            ctrl.strEventDate = (DateTime.now() + 1).format('yyyy-MM-dd');
            pr = ctrl.searchEventDynamically();
        }
        
        System.assertNotEquals(null, pr);
        Test.stopTest();
    }
    
    @isTest static void testProcessPauseWithoutAccount() {
        Test.startTest();
        
        SetPauseController ctrl = new SetPauseController();
        PageReference pr;
        //pr = ctrl.processPause();
        pr = SetPauseController.processPause('', '', '', 'DE', 'en');
        System.assertEquals('/myaccount', pr.getUrl());
        
        Test.stopTest();
    }
    
    @isTest static void testProcessPauseWithoutSubscription() {
        Account oAccount = [Select Id, PersonContactId, Account_Status__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account LIMIT 1];
        User oUser = [Select Id, ContactId, Country From User Where ContactId = :oAccount.PersonContactId];
        
        List<Zuora__Subscription__c> subscriptions = [Select Id, Name, Zuora__CustomerAccount__r.Zuora__BillCycleDay__c
                                                      From Zuora__Subscription__c];
        delete subscriptions;
        
        Test.startTest();
        
        PageReference pr;
        System.runAs(oUser) {
            SetPauseController ctrl = new SetPauseController();
            //pr = ctrl.processPause();
            pr = SetPauseController.processPause('', '', '', 'DE', 'en');
        }
        System.assertEquals('/myaccount', pr.getUrl());
        
        Test.stopTest();
    }
    
    @isTest static void testProcessPauseWithoutParams() {
        Account oAccount = [Select Id, PersonContactId, Pause_From__c, Account_Status__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account LIMIT 1];
        User oUser = [Select Id, ContactId, Country From User Where ContactId = :oAccount.PersonContactId];
        
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        
        Test.startTest();
        
        PageReference pr;
        System.runAs(oUser) {
            SetPauseController ctrl = new SetPauseController();
            //pr = ctrl.processPause();
            pr = SetPauseController.processPause('', '', '', 'DE', 'en');
        }
        System.assertEquals(null, pr);
        
        Test.stopTest();
    }
    
    @isTest static void testSetPauseAmendSameDate() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, PersonContactId, Pause_From__c, Account_Status__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account LIMIT 1];
        oAccount.Pause_From__c = Date.today() + 1;
        update oAccount;
        User oUser = [Select Id, ContactId, Country From User Where ContactId = :oAccount.PersonContactId];
        
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        
        Test.startTest();
        SetPauseController ctrl = new SetPauseController();
        
        DateTime dtResumeDate = Date.today() + 1;
        DateTime dtSuspendDate = Date.today() + 1;
        String resumeDate = dtResumeDate.format('yyyy-MM-dd');
        String suspendDate = dtSuspendDate.format('yyyy-MM-dd');
        
        PageReference pr;
        System.runAs(oUser) {
            ctrl.strAction = 'amend';
            ctrl.strSuspendDate = suspendDate;
            ctrl.strResumeDate = resumeDate;
            //pr = ctrl.processPause();
            pr = SetPauseController.processPause('amend', suspendDate, resumeDate, 'DE', 'en');
        }
        
        System.assertNotEquals(null, pr);
        Test.stopTest();
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
    
    
    static testMethod void testLS_PauseHelperlocalFormattedDate() {
        Integer i = 1;
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
        
        Profile communityUserprofile = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
        User cUser = SetUpTestData.createCommunityUser('ja', 'JP', oAccount.Id, 'PauseUseremail@email.com', 'PauseUser@email.com', 'tstals','Europe/London','ISO-8859-1','ja','ja','PauseUserFName','PauseUserLName',true);
        Test.StartTest();
        
        List<DAZN_Country_Localized_Month__c> lstCustomSetting = new List<DAZN_Country_Localized_Month__c>();
        
        insert lstCustomSetting ; 
        
        ApexPages.currentPage().getParameters().put('Country', 'JP');
        ApexPages.currentPage().getParameters().put('lang', 'ja');
        
        LS_PauseHelper objCntrl = new LS_PauseHelper(); 
        LS_PauseHelper.localFormattedDate(date.newinstance(2507, 1, 15), 'ja');
        LS_PauseHelper.localMonthName(i);
        
        Test.stopTest();
    }
     @isTest static void testSearchEventDynPaused() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = SetUpTestData.createPersonAccount('JP', 'EN_GB', 'TestFirstName', 'TestLastName','pm3testemail@email.com','Paused');
       
        update oAccount;
        User testuser = SetUpTestData.createCommunityUser('EN_GB', 'JP', oAccount.Id, 'PauseUseremail@email.com', 'PauseUser@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'EN_GB', 'EN_GB', 'PauseUserFName', 'PauseUserLName', true);
        
        DAZN_Events_Calendar__c dazn = createDaznEvent('IPL 20126', true, Date.today(), DateTime.now().format('dd/MM/yyyy'), 'JP', 'EN_GB');
        
        Test.startTest();
        
         ApexPages.currentPage().getParameters().put('Country', 'DE');
         ApexPages.currentPage().getParameters().put('lang', 'en');
        
        
        System.runAs(testuser) {
            SetPauseController ctrl = new SetPauseController();
            ctrl.strEventDate = DateTime.now().format('yyyy-MM-dd');
            ctrl.searchEventDynamically();
            System.assertNotEquals(null,ctrl.strEventDate);
        }
        
      
        Test.stopTest();
    }
}