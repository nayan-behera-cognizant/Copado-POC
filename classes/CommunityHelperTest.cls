// This test class will cover the code coverage for CommunityHelper
@IsTest 
public class CommunityHelperTest{
    @testSetup
    public static void setUpTestData() {
        List<DAZN_Help_Redirect__c> dhr = new List<DAZN_Help_Redirect__c>();
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Japan',
            Country__c = 'Japan',
            CountryISOCode__c = 'JP',
            IsDefaultCountry__c = false,
            Language__c = 'ja'
        ));
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Japan en',
            Country__c = 'Japan',
            CountryISOCode__c = 'JP',
            IsDefaultCountry__c = false,
            Language__c = 'en'
        ));
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Germany',
            Country__c = 'Germany',
            CountryISOCode__c = 'DE',
            IsDefaultCountry__c = true,
            Language__c = 'en'
        ));
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Canada',
            Country__c = 'Canada',
            CountryISOCode__c = 'CA',
            IsDefaultCountry__c = true,
            Language__c = 'fr_CA'
        ));
        insert dhr;
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','te@test.com','Free Trial');
        //CreateTestDataforUnitTest.createTestcustomsetting();
    }

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
    }

    static testMethod void testCommunityHelper(){
        SetUpTestData.triggerSettings();
        Account oAccount = [SELECT id, Notification_Country_Code__c, Notification_Language_Code__c,Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName FROM Account];
        CreateTestDataforUnitTest.createTestcustomsetting();
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername19@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        zSubsp.Zuora__TermSettingType__c = 'EVERGREEN';
        zSubsp.Zuora__MRR__c = 9.99;
        update zSubsp;
        Zuora__Subscription__c objZSub = [Select id,Zuora__SubscriptionEndDate__c,Zuora__NextChargeDate__c from Zuora__Subscription__c where id =: zSubsp.Id];        
        
        Test.StartTest();
        System.RunAs(cUser){
            List<Account> lstAccount=CommunityHelper.getUserSubscription(null);
            List<Zuora__Subscription__c> lstSubscriptions = lstAccount[0].Zuora__Subscriptions__r;

            string strMsg = CommunityHelper.getSubscriptionDescription(Label.LS_MyAccount_InfoMsg_Reactivation, lstSubscriptions[0]);
            string strLabel = Label.LS_MyAccount_InfoMsg_Reactivation;
            if(strLabel.contains('[Zuora__SubscriptionEndDate__c]')){
                Datetime Dt = Datetime.now();
                string strDate = Dt.format('dd.MM.yyyy');
                strLabel = strLabel.replace('[Zuora__SubscriptionEndDate__c]', strDate);
            }else if(strLabel.contains('[Zuora__NextChargeDate__c]')){
                Datetime Dt = Datetime.now();
                string strDate = Dt.format('dd.MM.yyyy');
                strLabel = strLabel.replace('[Zuora__NextChargeDate__c]', strDate);
            }
            //system.assertEquals(strMsg,strLabel);
            CommunityHelper.getLanguageCode();
            CommunityHelper.updateSignoutKey(null);
            CommunityHelper.getformattedAmount('$', 16,'Canada');
            //CommunityHelper.sendEmailtoUser('test@demo.com', 'test@demo.com', 'UpdatedMsg', '', '','','');
            //CommunityHelper.sendEmailtoUser('test@demo.com','test@demo.com', 'FailedMsg', '', '','','');
            CommunityHelper.getUserSubscription(cUser);
            CommunityHelper.getUserCountry(cUser);
        }
        Test.stopTest();
    }
    
    static testMethod void testCommunityHelper_Termed(){
        SetUpTestData.triggerSettings();
        Account oAccount = [SELECT id, Notification_Country_Code__c, Notification_Language_Code__c,Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName FROM Account];
        CreateTestDataforUnitTest.createTestcustomsetting();
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername19@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        zSubsp.Zuora__TermSettingType__c = 'TERMED';
        zSubsp.Zuora__TCV__c = 9.99;
        update zSubsp;
        Zuora__Subscription__c objZSub = [Select id,Zuora__SubscriptionEndDate__c,Zuora__NextChargeDate__c from Zuora__Subscription__c where id =: zSubsp.Id];        
        
        Test.StartTest();
        System.RunAs(cUser){
            List<Account> lstAccount=CommunityHelper.getUserSubscription(null);
            List<Zuora__Subscription__c> lstSubscriptions = lstAccount[0].Zuora__Subscriptions__r;

            string strMsg = CommunityHelper.getSubscriptionDescription(Label.LS_MyAccount_InfoMsg_Reactivation, lstSubscriptions[0]);
            string strLabel = Label.LS_MyAccount_InfoMsg_Reactivation;
            if(strLabel.contains('[Zuora__SubscriptionEndDate__c]')){
                Datetime Dt = Datetime.now();
                string strDate = Dt.format('dd.MM.yyyy');
                strLabel = strLabel.replace('[Zuora__SubscriptionEndDate__c]', strDate);
            }else if(strLabel.contains('[Zuora__NextChargeDate__c]')){
                Datetime Dt = Datetime.now();
                string strDate = Dt.format('dd.MM.yyyy');
                strLabel = strLabel.replace('[Zuora__NextChargeDate__c]', strDate);
            }
            //system.assertEquals(strMsg,strLabel);
            CommunityHelper.getLanguageCode();
            CommunityHelper.updateSignoutKey(null);
            CommunityHelper.getformattedAmount('$', 16,'Canada');
            //CommunityHelper.sendEmailtoUser('test@demo.com', 'test@demo.com', 'UpdatedMsg', '', '','','');
            //CommunityHelper.sendEmailtoUser('test@demo.com','test@demo.com', 'FailedMsg', '', '','','');
            CommunityHelper.getUserSubscription(cUser);
            CommunityHelper.getUserCountry(cUser);
        }
        Test.stopTest();
    }
    
    static testMethod void testCommunityHelperGuest(){
        CreateTestDataforUnitTest.CreateGuestUser();
        List <User> gUser=[select id,UserName,country from user where userType = 'Guest' AND isActive = true limit 1]; 
                Test.StartTest();
        System.RunAs(gUser[0]){
          PageReference pageRef = Page.mylogin;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('lang','de');
            CommunityHelper.getLanguageCode();
           }
        Test.stopTest();
    }
    
    static testMethod void testCommunityHelperGuestWithNoLang(){
        CreateTestDataforUnitTest.CreateGuestUser();
        List <User> gUser=[select id,UserName,country from user where userType = 'Guest' AND isActive = true limit 1]; 
                Test.StartTest();
        System.RunAs(gUser[0]){
          PageReference pageRef = Page.mylogin;
            CommunityHelper.getLanguageCode();
           }
        Test.stopTest();
    }

    static testMethod void test1CommunityHelper(){
        SetUpTestData.triggerSettings();
        //Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        Account oAccount = [SELECT id, Notification_Country_Code__c, Notification_Language_Code__c,Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName FROM Account];
        CreateTestDataforUnitTest.createTestcustomsetting();
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__PaymentMethod__c zPayMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id, 'Active', 'CreditCard', '1234567891234567', 'Visa', 'Test Credit Card', '5', '16', '456', 'Active');
        Test.StartTest();
        System.RunAs(cUser){
            Account acc = [Select id from account limit 1];
            Zuora__PaymentMethod__c objPayMethod = [Select id From Zuora__PaymentMethod__c limit 1];
            Zuora__PaymentMethod__c ozPayMethod = CommunityHelper.getPaymentInformation(acc.id);
            system.assertEquals(ozPayMethod.id,objPayMethod.id);
            //string cSymb = CommunityHelper.getCurrencySymbol(acc);
            //system.assertEquals(cSymb,'USD');
        }
        Test.stopTest();
    }
    
    static testMethod void test2CommunityHelper(){
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername2@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Test.StartTest();
        System.RunAs(cUser){
            user usr = [select id,accountid from user where id=:userinfo.getUserId()];
            Account acc = [Select id from account where id=:usr.AccountId limit 1];
            //CommunityHelper.updateAccount(cUser.id,acc.ID,'Email');
            //Account acc1 = [Select id,PersonEmail from account limit 1];
            //system.assertEquals(acc1.PersonEmail,'testCommunityuser@gmail.com');
            //CommunityHelper.updateAccount(cUser.id,acc.ID,'Name');
            //Account acc2 = [Select id,FirstName,LastName from account limit 1];
            //system.assertEquals(acc2.FirstName,'Test');
            //CommunityHelper.updateUser(usr,'Email@gmail.com');
        }
        Test.stopTest();
    }
    
    static testMethod void test3CommunityHelper(){
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername3@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Test.StartTest();
        System.RunAs(cUser){
            CommunityHelper.getAllDataCategories('GB');
            //CommunityHelper.createCaseRecord('Desc');
        }
        Test.stopTest();
    }
    
    //to get current user
    static testMethod void testGetCurrentUser(){
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername4456@email345.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Test.StartTest();
        System.RunAs(cUser){
            CommunityHelper.getCurrentUser();
            //for update account status
            CommunityHelper.updateAccountStatus(oAccount.Id, 'Free Trial');
            //for update account cancelled check box
            CommunityHelper.updateAccountCancelledCheckbox(oAccount.Id, true);
            //for  get Obfuscated Email
            CommunityHelper.getObfuscatedEmail('testemail@email.com');
            //to get Account info
            CommunityHelper.getAccountInfo(oAccount.Id);
        }
        Test.stopTest();
    }

    // to  get Obfuscated Email when sEmailToObfuscate is null
    static testMethod void testGetObfuscatedEmail(){
        SetUpTestData.triggerSettings();
        SetUpTestData.testCreateDAZNCountryCurrencyISOCode('JPY', '¥');
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername4@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Test.StartTest();
        System.RunAs(cUser){
            CommunityHelper.getObfuscatedEmail(null);
            CommunityHelper.getCurrencySymbol('JPY');
        }
        Test.stopTest();
    }

    // to get currency symbol
    static testMethod void testGetCurrencySymbol(){
        SetUpTestData.triggerSettings();
        SetUpTestData.testCreateDAZNCountryCurrencyISOCode('JPY', '¥');
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername5@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','ja','TestFName','TestLName',true); 
        Test.StartTest();
        System.RunAs(cUser){
            CommunityHelper.getCurrencySymbol('JPY');
        }
        Test.stopTest();
    }

    //for create sign off task
    static testMethod void testSignOffTask(){
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername6@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        User oCommunityUser = (User)SetUpTestData.setUpData(cUser);
        SetUpTestData.createUserDevice(oAccount.Id, 'test', Date.today(), 'Desktop', 'Active');

        Test.StartTest();
        System.RunAs(cUser) {
            // for create sign off task
            // CommunityHelper.createSignOffTask(oCommunityUser.ContactId, oAccount.Id,'TestSubject','TestDescription');
            // for create task from future
            CommunityHelper.createTaskFromFuture(oCommunityUser.ContactId, oAccount.Id, 'TestSubject', 'TestDescription');
            // for create task 
            CommunityHelper.createTask(oCommunityUser.ContactId, oAccount.Id, 'TestSubject', 'TestDescription');
            //for sign out of all devices
            CommunityHelper.signOutOfAllDevices(oAccount.Id, cUser.Id, oCommunityUser.ContactId);
        }
        Test.stopTest();
    }

    static testMethod void testSignOffallDevices(){
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername7@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        User oCommunityUser = (User)SetUpTestData.setUpData(cUser);
        SetUpTestData.createUserDevice(oAccount.Id, 'test', Date.today(), 'Desktop', 'Active');

        Test.StartTest();
        System.RunAs(cUser){
            // for create sign off task
            // CommunityHelper.createSignOffTask(oCommunityUser.ContactId, oAccount.Id,'TestSubject','TestDescription');
            // for create task from future
            CommunityHelper.createTaskFromFuture(oCommunityUser.ContactId, oAccount.Id, 'TestSubject', 'TestDescription');
            // for create task 
            CommunityHelper.createTask(oCommunityUser.ContactId, oAccount.Id, 'TestSubject', 'TestDescription');
            //for sign out of all devices
            CommunityHelper.signOutOfAllDevices(oCommunityUser);
        }
        Test.stopTest();
    }

    static testMethod void testSignOfsingleDevices(){
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername8@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        User oCommunityUser=(User)SetUpTestData.setUpData(cUser); 
        Test.StartTest();
        System.RunAs(cUser){
            // for create sign off task
            // CommunityHelper.createSignOffTask(oCommunityUser.ContactId, oAccount.Id,'TestSubject','TestDescription');
            // for create task from future
            CommunityHelper.createTaskFromFuture(oCommunityUser.ContactId, oAccount.Id, 'TestSubject', 'TestDescription');
            // for create task 
            CommunityHelper.createTask(oCommunityUser.ContactId, oAccount.Id, 'TestSubject', 'TestDescription');
            
            //for sign out of all devices
            CommunityHelper.signOutOfAllDevices(oCommunityUser);
        }
        Test.stopTest();
    }

    // for format currency
    static testMethod void testFormatCurrency(){
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername9@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        User oCommunityUser=(User)SetUpTestData.setUpData(cUser); 
        Test.StartTest();
        System.RunAs(cUser){
            CommunityHelper.getformattedAmount('?', 1.6,'Japan');
        }
        Test.stopTest();
    }

    //for format currency when country is null
    static testMethod void testCurrency(){
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername10@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        User oCommunityUser=(User)SetUpTestData.setUpData(cUser); 
        Test.StartTest();
        System.RunAs(cUser){
            CommunityHelper.getformattedAmount('?', 1000.00,null);
        }
        Test.stopTest();
    }  
    
    //for encrypt and decrypt data
    static testMethod void testEncryptData(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername11@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Test.StartTest();
        System.RunAs(cUser){
            Blob key = Crypto.generateAesKey(128);
            //to encrypt data
            CommunityHelper.encrypt('16', 'Test');
            CommunityHelper.encrypt(String.valueOf(key), 'Test');
            
            //to decrypt data
            CommunityHelper.decrypt('16','Test');
            CommunityHelper.decrypt(String.valueOf(key),'Test');
        }
        Test.stopTest();
    }

    static testMethod void testgetDataCategoriesByDataCategoryGroupName(){
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser('en_GB', 'DE', oAccount.Id, 'testemail@email.com', 'testusername12@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true); 
        Test.StartTest();
        System.RunAs(cUser){
            CommunityHelper.getDataCategoriesByDataCategoryGroupName('Region');
        }
        Test.stopTest();
    }

    //to check DfD user access *PD-9696*
    static testMethod void testCheckDfDUserAccess(){
        SetUpTestData.triggerSettings();
        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'DAZN for Docomo', 'DAZN for Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        
        Account oAccount = SetUpTestData.createDfDAccount('TestFName', 'TestLName','test@test123.com','Active Paid', '12345567890', 'DAZN for Docomo');

        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername13@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Test.StartTest();
        System.RunAs(cUser){

            PageReference partnerAccount = CommunityHelper.CheckDfDUserAccess();
            DoubleOptInController doubleOptInController = new DoubleOptInController();
            PageReference doubleOptInControllerMyAccount = doubleOptInController.setDoubleOptIn();
            ChangePasswordController changePasswordController = new ChangePasswordController();
            PageReference changePasswordControllerMyAccount = changePasswordController.navigateUser();
            PaymentHistoryController paymentHistoryController = new PaymentHistoryController();
            PageReference paymentHistoryControllerMyAccount = paymentHistoryController.navigateToErrorPage();     
            MembershipReactivationController membershipReactivationController = new MembershipReactivationController();
            membershipReactivationController.navigateError = false;
            PageReference membershipReactivationControllerMyAccount = membershipReactivationController.navigateToErrorPage();
            
            System.assertEquals(partnerAccount.getUrl(), Page.PartnerAccount.getUrl());
            System.assertEquals(doubleOptInControllerMyAccount.getUrl(), Page.PartnerAccount.getUrl());
            System.assertEquals(changePasswordControllerMyAccount.getUrl(), Page.PartnerAccount.getUrl());
            System.assertEquals(membershipReactivationControllerMyAccount.getUrl(), Page.PartnerAccount.getUrl());
            System.assertEquals(paymentHistoryControllerMyAccount.getUrl(), Page.PartnerAccount.getUrl());
            
            CommunityHelper.updateAccountStatus(oAccount.Id, 'Frozen');

            PageReference mylogin = CommunityHelper.CheckDfDUserAccess();
            PageReference doubleOptInControllerMyLogin = doubleOptInController.setDoubleOptIn();
            PageReference changePasswordControllerMyLogin = changePasswordController.navigateUser();
            PageReference paymentHistoryControllerMyLogin = paymentHistoryController.navigateToErrorPage();

            System.assertEquals(mylogin.getUrl(), Page.mylogin.getUrl());
            System.assertEquals(doubleOptInControllerMyLogin.getUrl(), Page.mylogin.getUrl());
            System.assertEquals(changePasswordControllerMyLogin.getUrl(), Page.mylogin.getUrl());
            System.assertEquals(paymentHistoryControllerMyLogin.getUrl(), Page.mylogin.getUrl());

            CommunityHelper.updateAccountStatus(oAccount.Id, 'Active');
            PageReference changePasswordControllerNotDfD = changePasswordController.navigateUser();
            System.assertEquals(changePasswordControllerNotDfD, null);
        }
        Test.stopTest();
    }   

    //to check DfD user access *PD-8875*
    static testMethod void testIsDfDUser(){
        SetUpTestData.triggerSettings();
        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'DAZN for Docomo', 'DAZN for Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        
        Account oAccount = SetUpTestData.createDfDAccount('TestFName', 'TestLName','test@test.com','Active Paid', '12345567890', 'DAZN for Docomo');

        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername14@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Test.StartTest();
        System.RunAs(cUser){           
            System.assertEquals(CommunityHelper.IsDfDUser(), true);
        }
        Test.stopTest();
    }   

    public static testMethod void testCheckSendEmailForAccount() {
        SetUpTestData.triggerSettings();
        Test.startTest();
            Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test57567567@test.com','Free Trial');
            User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail12@email.com', 'testusername12@email.com', 'tstals12','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
            System.runAs(oUser) {
                //System.assertEquals(CommunityHelper.checkSendEmailForAccount(),false);
                System.assert(CommunityHelper.checkSendEmailForAccount() != null);
            }
        Test.stopTest();
    }
    
    public static testMethod void testCheckSendEmailForAccount2() {
        SetUpTestData.triggerSettings();
        Test.startTest();
            Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test57567567@test.com','Do not contact');
            User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail12@email.com', 'testusername12@email.com', 'tstals12','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
            System.runAs(oUser) {
                //System.assertEquals(CommunityHelper.checkSendEmailForAccount(),false);
                System.assert(CommunityHelper.checkSendEmailForAccount() != null);
            }
        Test.stopTest();
    }

    public static testMethod void testUserLanguage() {
        CommunityHelper.UserLanguage ul;
        Test.startTest();
            ul = new CommunityHelper.UserLanguage('ja', 'Japan');
        Test.stopTest();
        System.assertEquals('ja', ul.language);
        System.assertEquals('Japan', ul.label);
    }

    public static testMethod void testGetMassiveURLs() {
        List<DAZNConfiguration__c> dc = new List<DAZNConfiguration__c>();
        dc.add(new DAZNConfiguration__c(
            Name = 'ForgotPasswordLink',
            Value__c = '1'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'LoginPageURL',
            Value__c = '2'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'HomePageURL',
            Value__c = '3'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'Mylogin_ForgotEmail',
            Value__c = '4'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'Mylogin_PasswordReset',
            Value__c = '5'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'ForgotPasswordLinkBeta',
            Value__c = '11'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'LoginPageURLBeta',
            Value__c = '22'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'HomePageURLBeta',
            Value__c = '33'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'Mylogin_ForgotEmailBeta',
            Value__c = '44'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'Mylogin_PasswordResetBeta',
            Value__c = '55'
        ));
        insert dc;

        String sMassiveURL;
        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'ForgotPasswordLinkType');
        System.assertEquals('1', sMassiveURL);
        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'LoginPageURLType');
        System.assertEquals('2', sMassiveURL);
        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'HomePageURLType');
        System.assertEquals('3', sMassiveURL);
        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'ForgotEmailURLType');
        System.assertEquals('4', sMassiveURL);
        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'PasswordResetURLType');
        System.assertEquals('5', sMassiveURL);

        DAZNBetaConfiguration__c dbc = new DAZNBetaConfiguration__c(
            Name = 'Japan',
            Country__c = 'JP',
            CountryCode__c = 'Japan',
            IsBeta__c = true
        );
        insert dbc;

        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'ForgotPasswordLinkType');
        System.assertEquals('11', sMassiveURL);
        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'LoginPageURLType');
        System.assertEquals('22', sMassiveURL);
        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'HomePageURLType');
        System.assertEquals('33', sMassiveURL);
        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'ForgotEmailURLType');
        System.assertEquals('44', sMassiveURL);
        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'PasswordResetURLType');
        System.assertEquals('55', sMassiveURL);
    }

    public static testMethod void testCheckIfAllSubscriptionsCancelled() {
        SetUpTestData.triggerSettings();
        CreateTestDataforUnitTest.createTestcustomsetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername15@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__PaymentMethod__c zPayMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id, 'Active', 'CreditCard', '1234567891234567', 'Visa', 'Test Credit Card', '5', '16', '456', 'Active');
        
        List<Zuora__Subscription__c> lzs = new List<Zuora__Subscription__c>();
        lzs.add(zSubsp);

        Test.StartTest();
        
        Boolean cancelled = CommunityHelper.checkIfAllSubscriptionsCancelled(lzs);
        System.assertEquals(false, cancelled);
        
        Test.stopTest();
    }

    public static testMethod void testCreateSignOffTask() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername16@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 

        User u = [Select ContactId, AccountId From User Where Id = :cUser.Id];

        Test.StartTest();
        CommunityHelper.createSignOffTask(u.ContactId, u.AccountId, 'Subject', 'Description');
        CommunityHelper.createSignOffTask(String.valueOf(u.Id), String.valueOf(u.Id), 'Subject', 'Description'); // for exception
        Test.stopTest();

        System.assertEquals(1, [Select Id From Task].size());
    }

    public static testMethod void testPageRestBaseonTerritory() {
        list<DAZN_Help_Redirect__c> defaultHelpRedirectSettings = [Select Name from DAZN_Help_Redirect__c where IsDefaultCountry__c = true];

        Test.StartTest();
        PageReference retPage = CommunityHelper.PageRestBaseonTerritory('help', 'afterHelp', 'Japann');
        System.assertEquals('/'+ 'help' + '/' + DAZN_Help_Redirect__c.getInstance(defaultHelpRedirectSettings[0].Name).CountryISOCode__c + '-' + DAZN_Help_Redirect__c.getInstance(defaultHelpRedirectSettings[0].Name).Language__c + 'afterHelp', retPage.getUrl());

        PageReference retPage1 = CommunityHelper.PageRestBaseonTerritory('help', 'afterHelp', 'Japan');
        System.assertEquals('/'+ 'help' + '/' + 'JP' + '-' + 'ja' + 'afterHelp', retPage1.getUrl());
        Test.stopTest();
    }

    public static testMethod void testGetUserCountryfromIPAddress() {
        ApexPages.currentPage().getHeaders().put('True-Client-IP', '80.249.88.240');
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        String country = CommunityHelper.getUserCountryfromIPAddress();
        System.assertEquals('Country', country);
        Test.stopTest();
    }

    public class MockHttpResponseGenerator implements HttpCalloutMock {
        private String cityName;
        private String countryName;

        public MockHttpResponseGenerator() {
            this.cityName = 'City';
            this.countryName = 'Country';
        }

        public MockHttpResponseGenerator(String cityName, String countryName) {
            this.cityName = cityName;
            this.countryName = countryName;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"city":"' + cityName + '","country":{"name":"' + countryName + '","code":"11"},"location":{"accuracy_radius":200,"latitude":1,"longitude":1,"time_zone":"1"},"ip":"1.1.1.1"}');
            res.setStatusCode(200);
            return res;
        }
    }

    public static testMethod void testValidateIPAddress() {
        ApexPages.currentPage().getHeaders().put('True-Client-IP', '80.249.88.240');
        list<DAZN_Help_Redirect__c> defaultHelpRedirectSettings = [Select Name from DAZN_Help_Redirect__c where IsDefaultCountry__c = true];

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        PageReference pr = CommunityHelper.validateIPAddress('help', 'afterHelp');
        Test.stopTest();
        System.assertEquals('/help/' + DAZN_Help_Redirect__c.getInstance(defaultHelpRedirectSettings[0].Name).CountryISOCode__c + '-' + DAZN_Help_Redirect__c.getInstance(defaultHelpRedirectSettings[0].Name).Language__c + 'afterHelp', pr.getUrl());
    }

    public static testMethod void testMyloginFetchUserLocaleJapanMyLogin() {
        User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];
        PageReference pr;

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('Tokyo', 'Japan'));
        System.RunAs(u) {
            pr = CommunityHelper.myloginFetchUserLocale('mylogin', 'en');
        }
        Test.stopTest();

        System.assertEquals('/mylogin/JP-en', pr.getUrl());
    }

    public static testMethod void testMyloginFetchUserLocaleJapanSignin() {
        User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];
        PageReference pr;

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('Tokyo', 'Japan'));
        System.RunAs(u) {
            pr = CommunityHelper.myloginFetchUserLocale('signin', 'en');
        }
        Test.stopTest();

        System.assertEquals('/signin/JP-en', pr.getUrl());
    }

    public static testMethod void testMyloginFetchUserLocaleNotJapanMyLogin() {
        User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];
        PageReference pr;

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('London', 'United Kingdom'));
        System.RunAs(u) {
            pr = CommunityHelper.myloginFetchUserLocale('mylogin', 'en');
        }
        Test.stopTest();

        System.assertEquals('/mylogin/DE-en', pr.getUrl());
    }

    public static testMethod void testMyloginFetchUserLocaleCanadaMyLogin() {
        User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];
        PageReference pr;

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('Toronto', 'Canada'));
        System.RunAs(u) {
            pr = CommunityHelper.myloginFetchUserLocale('mylogin', 'fr-CA');
        }
        Test.stopTest();

        System.assertEquals('/mylogin/CA-fr_CA', pr.getUrl());
    }

    public static testMethod void testMyloginFetchUserLocaleNotJapanSignin() {
        User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];
        PageReference pr;

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('London', 'United Kingdom'));
        System.RunAs(u) {
            pr = CommunityHelper.myloginFetchUserLocale('signin', 'en');
        }
        Test.stopTest();

        System.assertEquals('/signin/DE-en', pr.getUrl());
    }

    public static testMethod void testJapanMyloginFetchUserLocaleWithSamePageParams() {
        ApexPages.currentPage().getParameters().put('lang', 'en');
        ApexPages.currentPage().getParameters().put('Country', 'JP');
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('Tokyo', 'Japan'));
        PageReference pr = CommunityHelper.myloginFetchUserLocale('mylogin', 'en');
        System.assertEquals(null, pr);
        Test.stopTest();
    }

    public static testMethod void testJapanMyloginFetchUserLocaleContactUsWithoutParams() {
        Account oAccount = SetUpTestData.createPersonAccount('DE', 'en_US', 'TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser('en_US', 'DE', oAccount.Id, 'testemail@email.com', 'testusername17@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);

        PageReference pr;

        Test.StartTest();

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('Tokyo', 'Japan'));
        System.RunAs(cUser) {
            pr = CommunityHelper.myloginFetchUserLocale('contactus', 'en');
        }
        Test.stopTest();
        
        System.assertEquals(null, pr);
    }

    public static testMethod void testJapanMyloginFetchUserLocaleWithDifPageParams() {
        User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];
        PageReference pr;

        ApexPages.currentPage().getParameters().put('lang', 'fakeParam');
        ApexPages.currentPage().getParameters().put('Country', 'JP');
        ApexPages.currentPage().getParameters().put('loginType', 'DAZN');
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('Tokyo', 'Japan'));
        System.RunAs(u) {
            pr = CommunityHelper.myloginFetchUserLocale('mylogin', 'en');
        }
        Test.stopTest();

        System.assertEquals('/mylogin/DE-en?loginType=DAZN', pr.getUrl());
    }

    public static testMethod void testRemoveDevices() {
        SetUpTestData.triggerSettings();
        Account oAccount = [SELECT id, Notification_Country_Code__c, Notification_Language_Code__c,Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName FROM Account];
        User_Devices__c device1=new User_Devices__c();
        device1.Account__c=oAccount.Id;
        device1.Date_Of_Registration__c=System.today();
        device1.Device_Id__c='DESK001';
        device1.Device_manufacturer__c='';
        device1.Device_Name__c='Desktop1';
        device1.Device_Registration_Date__c=System.today();
        device1.Type__c='Desktop';
        device1.Device_version__c='';
        device1.Operating_System_Name__c='';
        device1.Operating_System_Version__c='';
        device1.Status__c='Active';
        device1.User_Agent__c='';
        insert device1;
        CommunityHelper.removeDevices(new List<Id>{device1.Id});
    }

    public static testMethod void testRemoveDevice() {
        SetUpTestData.triggerSettings();
        Account oAccount = [SELECT id, Notification_Country_Code__c, Notification_Language_Code__c,Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName FROM Account];
        User_Devices__c device1=new User_Devices__c();
        device1.Account__c=oAccount.Id;
        device1.Date_Of_Registration__c=System.today();
        device1.Device_Id__c='DESK001';
        device1.Device_manufacturer__c='';
        device1.Device_Name__c='Desktop1';
        device1.Device_Registration_Date__c=System.today();
        device1.Type__c='Desktop';
        device1.Device_version__c='';
        device1.Operating_System_Name__c='';
        device1.Operating_System_Version__c='';
        device1.Status__c='Active';
        device1.User_Agent__c='';
        insert device1;
        CommunityHelper.removeDevice(device1.Id);
    }

    public static testMethod void testGetZuoraAccountInfo() {
        SetUpTestData.triggerSettings();
        Account oAccount = [SELECT id, Notification_Country_Code__c, Notification_Language_Code__c,Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName FROM Account];
        CreateTestDataforUnitTest.createTestcustomsetting();
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername18@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');       
        
        Test.startTest();
            CommunityHelper.getZuoraAccountInfo(oAccount.Id);
        Test.stopTest();

    }

    public static testMethod void testRedirectToHomePage() {
        SetUpTestData.triggerSettings();
        Account oAccount = [SELECT id, Notification_Country_Code__c, Notification_Language_Code__c,Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName FROM Account];
        List<DAZNConfiguration__c> dc = new List<DAZNConfiguration__c>();
        dc.add(new DAZNConfiguration__c(
            Name = 'ForgotPasswordLink',
            Value__c = '1'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'LoginPageURL',
            Value__c = '2'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'HomePageURL',
            Value__c = '3'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'Mylogin_ForgotEmail',
            Value__c = '4'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'Mylogin_PasswordReset',
            Value__c = '5'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'ForgotPasswordLinkBeta',
            Value__c = '11'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'LoginPageURLBeta',
            Value__c = '22'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'HomePageURLBeta',
            Value__c = '33'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'Mylogin_ForgotEmailBeta',
            Value__c = '44'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'Mylogin_PasswordResetBeta',
            Value__c = '55'
        ));
        insert dc;

        String sMassiveURL;
        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'ForgotPasswordLinkType');
        System.assertEquals('1', sMassiveURL);
        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'LoginPageURLType');
        System.assertEquals('2', sMassiveURL);
        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'HomePageURLType');
        System.assertEquals('3', sMassiveURL);
        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'ForgotEmailURLType');
        System.assertEquals('4', sMassiveURL);
        sMassiveURL = CommunityHelper.getMassiveURLs('Japan', 'PasswordResetURLType');
        System.assertEquals('5', sMassiveURL);

        DAZNBetaConfiguration__c dbc = new DAZNBetaConfiguration__c(
            Name = 'Japan',
            Country__c = 'JP',
            CountryCode__c = 'Japan',
            IsBeta__c = true
        );
        insert dbc;
        Test.startTest();
            CommunityHelper.redirectToHomePage();
        Test.stopTest();
    }

    public static testmethod void testSignUsrRed() {
        PageReference pageRef = Page.ContactUs;
        String currentRequestURL= System.URL.getCurrentRequestUrl().toExternalForm();
        String afterHelp = (currentRequestURL.substringAfter('/ContactUs')!=null? currentRequestURL.substringAfter('/ContactUs'):(currentRequestURL.substringAfter('/contactUs')!=null?currentRequestURL.substringAfter('/contactUs'):''));
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test57567567@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail12@email.com', 'testusername12@email.com', 'tstals12','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        System.runAs(oUser) {
            CommunityHelper.signUsrRed('ContactUs',afterHelp);
        }
    }

    public static testMethod void testLanguageCode() { //signOutOfSingleDevices
        SetUpTestData.triggerSettings();
         Account oAccount = [SELECT id, Notification_Country_Code__c, Notification_Language_Code__c,Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName FROM Account];
        CreateTestDataforUnitTest.createTestcustomsetting();
        User usr = [SELECT Id, Country FROM User WHERE Id = :UserInfo.getUserId()];
        String sCountryName = CommunityHelper.getUserCountryName(usr);
        String sLang = CommunityHelper.getUserLanguageCode(sCountryName);
        ApexPages.currentPage().getParameters().put('lang','de');
        String sLang2 = CommunityHelper.getUserLanguageCode(sCountryName);
    }

    public static testMethod void testLangCodeGuest() {
        SetUpTestData.triggerSettings();
        DAZN_Help_Redirect__c dznHelpRed = new DAZN_Help_Redirect__c();
        dznHelpRed.CountryISOCode__c = 'JP';
        dznHelpRed.Name= 'Japan';
        dznHelpRed.Language__c = 'JA';
        dznHelpRed.IsDefaultCountry__c = true;
        dznHelpRed.Country__c = 'Japan';
        insert dznHelpRed;
        DAZNLanguageConfiguration__c oDAZNLangConfig = new DAZNLanguageConfiguration__c();
        oDAZNLangConfig.Name = '1';
        oDAZNLangConfig.Country__c = 'Japan';
        oDAZNLangConfig.Country_Code__c='JP';
        oDAZNLangConfig.Default_Language__c='ja';
        oDAZNLangConfig.Language__c='English';
        oDAZNLangConfig.Language_Code__c='en_GB';
        insert oDAZNLangConfig ; 
        CreateTestDataforUnitTest.createTestcustomsetting();
        Account oTestAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oTestUser = SetUpTestData.createGuestUser(oTestAccount.Id, 'testemail456@email.com', 'testusername123@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName12','TestLNam34e',true);        
        System.runAs(oTestUser){
            String sCountryName = CommunityHelper.getUserCountryName(oTestUser);
            String sLang = CommunityHelper.getUserLanguageCode(sCountryName);
            sCountryName = 'Japan';
            String sLang2 = CommunityHelper.getUserLanguageCode(sCountryName);
        }
    }

    public static testMethod void testDeleteUserDevice() {
        SetUpTestData.triggerSettings();
        Account oAccount = [SELECT id, Notification_Country_Code__c, Notification_Language_Code__c,Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName FROM Account];
        User_Devices__c device1=new User_Devices__c();
        device1.Account__c=oAccount.Id;
        device1.Date_Of_Registration__c=System.today();
        device1.Device_Id__c='DESK001';
        device1.Device_manufacturer__c='';
        device1.Device_Name__c='Desktop1';
        device1.Device_Registration_Date__c=System.today();
        device1.Type__c='Desktop';
        device1.Device_version__c='';
        device1.Operating_System_Name__c='';
        device1.Operating_System_Version__c='';
        device1.Status__c='Active';
        device1.User_Agent__c='';
        insert device1;
        CommunityHelper.deleteUserDevice(device1.id);
        CommunityHelper.deleteUserDevice(device1.id);
        CommunityHelper.removeDevice(device1.id);
        CommunityHelper.removeDevice(device1.id);
        CommunityHelper.removeDevices(new List<ID> {device1.id});
        CommunityHelper.RemovetheItems(new List<ID> {device1.id});
    }
    static testMethod void unitTesting(){
        SetUpTestData.triggerSettings();
        set<id> setofids =new set<id>();
        Account oAccount = [SELECT id, Notification_Country_Code__c, Notification_Language_Code__c,Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName FROM Account];
        CreateTestDataforUnitTest.createTestcustomsetting();
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername19@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        User oCommunityUser=(User)SetUpTestData.setUpData(cUser); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__Subscription__c objZSub = [Select id,Zuora__SubscriptionEndDate__c,Zuora__NextChargeDate__c from Zuora__Subscription__c where id =: zSubsp.Id];        
         setofids.add(oAccount.id);
        User_Devices__c device1=new User_Devices__c();
        device1.Account__c=oAccount.Id;
        device1.Date_Of_Registration__c=System.today();
        device1.Device_Id__c='DESK001';
        device1.Device_manufacturer__c='';
        device1.Device_Name__c='Desktop1';
        device1.Device_Registration_Date__c=System.today();
        device1.Type__c='Desktop';
        device1.Device_version__c='';
        device1.Operating_System_Name__c='';
        device1.Operating_System_Version__c='';
        device1.Status__c='Active';
        device1.User_Agent__c='';
        insert device1;
        CommunityHelper.getZBillingAccounts(setofids);
        CommunityHelper.signOutOfAllDevices(oCommunityUser);
        
    }

    static testMethod void testCommunityHelper2(){
        SetUpTestData.triggerSettings();
        CreateTestDataforUnitTest.createTestcustomsetting();
        Account oAccount = new Account(
            FirstName = 'TestF',
            LastName = 'TestL',
            PersonEmail = 'tefl@test.com',
            Account_Status__c = 'Paused',
            Pause_From__c = Date.today() - 1,
            Pause_Until__c = Date.today() + 1
        );
        insert oAccount;

        CommunityHelper.updateAccountStatus(oAccount.Id, 'Frozen');
        System.assertEquals(true, [SELECT Id, Account_Status__c, Cancelled_Account__c FROM Account WHERE Id = :oAccount.Id LIMIT 1].Cancelled_Account__c);
        CommunityHelper.redirectToMylogin();
        ApexPages.currentPage().getParameters().put('Country','JP');
        ApexPages.currentPage().getParameters().put('lang','ja');
        CommunityHelper.redirectToErrorPage('strErrMsg');
        List<AuthSession> lstActiveUserSessions = [Select ID From AuthSession Where UsersId =: UserInfo.getUserId()];
        if (!lstActiveUserSessions.isEmpty()) {
            CommunityHelper.deleteAuthSessions(new List<Id> {lstActiveUserSessions[0].Id});
        }
        Boolean isIPAdressesEquals = CommunityHelper.IpaddressCompare('0.0.0.0', '0.0.0.0');
        System.assertEquals(true, isIPAdressesEquals);
    }

    //test coverage improvement PD-13902
    static testMethod void testCommunityHelperCA() {
        SetUpTestData.triggerSettings();
        Account oAccount = [SELECT id, Notification_Country_Code__c, Notification_Language_Code__c,Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName FROM Account];
        CreateTestDataforUnitTest.createTestcustomsetting();
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername19@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        zSubsp.Zuora__TermSettingType__c = 'EVERGREEN';
        zSubsp.Zuora__MRR__c = 9.99;
        update zSubsp;
        Zuora__Subscription__c objZSub = [Select id,Zuora__SubscriptionEndDate__c,Zuora__NextChargeDate__c from Zuora__Subscription__c where id =: zSubsp.Id];        
        
        Test.StartTest();
        System.RunAs(cUser) {
            List<Account> lstAccount=CommunityHelper.getUserSubscription(null);
            List<Zuora__Subscription__c> lstSubscriptions = lstAccount[0].Zuora__Subscriptions__r;

            string strMsg = CommunityHelper.getSubscriptionDescriptionForCanada(Label.LS_MyAccount_InfoMsg_Reactivation, lstSubscriptions[0],'CA','en');
            string strMsgEnUs = CommunityHelper.getSubscriptionDescriptionForCanada(Label.LS_MyAccount_InfoMsg_Reactivation, lstSubscriptions[0],'en_US','CA');
            string strMsgFrCa = CommunityHelper.getSubscriptionDescriptionForCanada(Label.LS_MyAccount_InfoMsg_Reactivation, lstSubscriptions[0], 'fr_CA', 'CA');
            string strLabel = Label.LS_MyAccount_InfoMsg_Reactivation;
            if(strLabel.contains('[Zuora__SubscriptionEndDate__c]')){
                Datetime Dt = Datetime.now();
                string strDate = Dt.format('dd.MM.yyyy');
                strLabel = strLabel.replace('[Zuora__SubscriptionEndDate__c]', strDate);
            }else if(strLabel.contains('[Zuora__NextChargeDate__c]')){
                Datetime Dt = Datetime.now();
                string strDate = Dt.format('dd.MM.yyyy');
                strLabel = strLabel.replace('[Zuora__NextChargeDate__c]', strDate);
            }
            CommunityHelper.getLanguageCode();
            CommunityHelper.updateSignoutKey(null);
            String formattedAmountForCA = CommunityHelper.getformattedAmount('$', 16,'Canada');
            String formattedAmountForCA3 = CommunityHelper.getformattedAmount('$', Decimal.valueOf('16.5'),'Canada');
            System.assertNotEquals(null, formattedAmountForCA);
            CommunityHelper.getUserSubscription(cUser);
            CommunityHelper.getUserCountry(cUser);
        }
        Test.stopTest();
    }
    
        //test coverage improvement PD-13902
    static testMethod void testCommunityHelperCA_Termed() {
        List<PaymentMethodOptionConfig__c> paymConf = new List<PaymentMethodOptionConfig__c>(); 
        paymConf.add(new PaymentMethodOptionConfig__c(
            Name = 'Canada',
            Billing_Batch__c = 'Batch5',
            CardsPaymentGateway__c = 'DAZN Adyen UK',
            CountryCode__c = 'GB',
            Credit_Card__c = true,
            Currency_Format__c = '#,###.##',
            DefaultPaymentMethod__c = 'CreditCard',
            Direct_Debit__c = true,
            Paypal__c = true,
            PaypalMerchantPassword__c = 'S6ML4UB9N2QZCXYG',
            PaypalMerchantSignature__c = 'ALi8-v7bG.erpzNN6gL-NuQBIpX4AShyB5NtMjlYJR7SQSvWef2hVaTs',
            PaypalMerchantUsername__c = 'lukas.dechet-facilitator_api1.zuora.com',
            PaypalPaymentGateway__c = 'Paypal Japan - Staging',
            ZuoraCreditCardPageId__c = '2c91a0fa596d46ff01598cf6dd883ad2',
            ZuoraDirectDebitPageId__c = '2c91a0fb596d4d3d01598cfbdda30e4c'
        ));
        insert paymConf;
        
        SetUpTestData.triggerSettings();
        Account oAccount = [SELECT id, Notification_Country_Code__c, Notification_Language_Code__c,Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName FROM Account];
        CreateTestDataforUnitTest.createTestcustomsetting();
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername19@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        zSubsp.Zuora__TermSettingType__c = 'TERMED';
        zSubsp.Zuora__TCV__c = 9.99;
        update zSubsp;
        Zuora__Subscription__c objZSub = [Select id,Zuora__SubscriptionEndDate__c,Zuora__NextChargeDate__c from Zuora__Subscription__c where id =: zSubsp.Id];        
        
        Test.StartTest();
        System.RunAs(cUser) {
            List<Account> lstAccount=CommunityHelper.getUserSubscription(null);
            List<Zuora__Subscription__c> lstSubscriptions = lstAccount[0].Zuora__Subscriptions__r;

            string strMsg = CommunityHelper.getSubscriptionDescriptionForCanada(Label.LS_MyAccount_InfoMsg_Reactivation, lstSubscriptions[0],'CA','en');
            string strMsgEnUs = CommunityHelper.getSubscriptionDescriptionForCanada(Label.LS_MyAccount_InfoMsg_Reactivation, lstSubscriptions[0],'en_US','CA');
            string strMsgFrCa = CommunityHelper.getSubscriptionDescriptionForCanada(Label.LS_MyAccount_InfoMsg_Reactivation, lstSubscriptions[0], 'fr_CA', 'CA');
            string strLabel = Label.LS_MyAccount_InfoMsg_Reactivation;
            if(strLabel.contains('[Zuora__SubscriptionEndDate__c]')){
                Datetime Dt = Datetime.now();
                string strDate = Dt.format('dd.MM.yyyy');
                strLabel = strLabel.replace('[Zuora__SubscriptionEndDate__c]', strDate);
            }else if(strLabel.contains('[Zuora__NextChargeDate__c]')){
                Datetime Dt = Datetime.now();
                string strDate = Dt.format('dd.MM.yyyy');
                strLabel = strLabel.replace('[Zuora__NextChargeDate__c]', strDate);
            }
            CommunityHelper.getAccountInfo(cUser.Id);
            CommunityHelper.getLanguageCode();
            CommunityHelper.updateSignoutKey(null);
            String formattedAmountForCA = CommunityHelper.getformattedAmount('$', 16,'Canada');
            System.assertNotEquals(null, formattedAmountForCA);
            CommunityHelper.getUserSubscription(cUser);
            CommunityHelper.getUserCountry(cUser);
            CommunityHelper.getformattedAmount('$', 16,'Canada');
        }
        Test.stopTest();
    }

    static testMethod void testCommunityHelperCA_TermedJA() {
        List<PaymentMethodOptionConfig__c> paymConf = new List<PaymentMethodOptionConfig__c>(); 
        paymConf.add(new PaymentMethodOptionConfig__c(
            Name = 'Canada',
            Billing_Batch__c = 'Batch5',
            CardsPaymentGateway__c = 'DAZN Adyen UK',
            CountryCode__c = 'GB',
            Credit_Card__c = true,
            Currency_Format__c = '#,###.##',
            DefaultPaymentMethod__c = 'CreditCard',
            Direct_Debit__c = true,
            Paypal__c = true,
            PaypalMerchantPassword__c = 'S6ML4UB9N2QZCXYG',
            PaypalMerchantSignature__c = 'ALi8-v7bG.erpzNN6gL-NuQBIpX4AShyB5NtMjlYJR7SQSvWef2hVaTs',
            PaypalMerchantUsername__c = 'lukas.dechet-facilitator_api1.zuora.com',
            PaypalPaymentGateway__c = 'Paypal Japan - Staging',
            ZuoraCreditCardPageId__c = '2c91a0fa596d46ff01598cf6dd883ad2',
            ZuoraDirectDebitPageId__c = '2c91a0fb596d4d3d01598cfbdda30e4c'
        ));
        insert paymConf;
        
        SetUpTestData.triggerSettings();
        Account oAccount = [SELECT id, Notification_Country_Code__c, Notification_Language_Code__c,Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName FROM Account];
        CreateTestDataforUnitTest.createTestcustomsetting();
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername19@email.com', 'tstals','Europe/London','ISO-8859-1','ja','ja','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        zSubsp.Zuora__TermSettingType__c = 'TERMED';
        zSubsp.Zuora__TCV__c = 9.99;
        update zSubsp;
        Zuora__Subscription__c objZSub = [Select id,Zuora__SubscriptionEndDate__c,Zuora__NextChargeDate__c from Zuora__Subscription__c where id =: zSubsp.Id];        
        
        Test.StartTest();
        System.RunAs(cUser) {
            List<Account> lstAccount=CommunityHelper.getUserSubscription(null);
            List<Zuora__Subscription__c> lstSubscriptions = lstAccount[0].Zuora__Subscriptions__r;

            string strMsg = CommunityHelper.getSubscriptionDescriptionForCanada(Label.LS_MyAccount_InfoMsg_Reactivation, lstSubscriptions[0],'CA','en');
            string strMsgEnUs = CommunityHelper.getSubscriptionDescriptionForCanada(Label.LS_MyAccount_InfoMsg_Reactivation, lstSubscriptions[0],'en_US','CA');
            string strMsgFrCa = CommunityHelper.getSubscriptionDescriptionForCanada(Label.LS_MyAccount_InfoMsg_Reactivation, lstSubscriptions[0], 'fr_CA', 'CA');
            string strLabel = Label.LS_MyAccount_InfoMsg_Reactivation;
            if(strLabel.contains('[Zuora__SubscriptionEndDate__c]')){
                Datetime Dt = Datetime.now();
                string strDate = Dt.format('dd.MM.yyyy');
                strLabel = strLabel.replace('[Zuora__SubscriptionEndDate__c]', strDate);
            }else if(strLabel.contains('[Zuora__NextChargeDate__c]')){
                Datetime Dt = Datetime.now();
                string strDate = Dt.format('dd.MM.yyyy');
                strLabel = strLabel.replace('[Zuora__NextChargeDate__c]', strDate);
            }
            CommunityHelper.getAccountInfo(cUser.Id);
            CommunityHelper.getLanguageCode();
            CommunityHelper.updateSignoutKey(null);
            String formattedAmountForCA = CommunityHelper.getformattedAmount('$', 16,'Canada');
            System.assertNotEquals(null, formattedAmountForCA);
            CommunityHelper.getUserSubscription(cUser);
            CommunityHelper.getUserCountry(cUser);
            CommunityHelper.getformattedAmount('$', 16,'Canada');
        }
        Test.stopTest();
    }

    public static testMethod void testValidateIPAddressNot200() {
        list<DAZN_Help_Redirect__c> defaultHelpRedirectSettings = [Select Name from DAZN_Help_Redirect__c where IsDefaultCountry__c = true];

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse('{"foo":"bar"}', 201));
        PageReference pr = CommunityHelper.validateIPAddress('help', 'afterHelp');
        Test.stopTest();
        System.assertEquals('/help/' + DAZN_Help_Redirect__c.getInstance(defaultHelpRedirectSettings[0].Name).CountryISOCode__c + '-' + DAZN_Help_Redirect__c.getInstance(defaultHelpRedirectSettings[0].Name).Language__c + 'afterHelp', pr.getUrl());
    }

    public static testMethod void testCurRetunForCanadaFr() {
        String curRetunForCanadaFr = CommunityHelper.CurRetunForCanadaFr('111');
        System.assertNotEquals(null, curRetunForCanadaFr);
    }

    public static testMethod void testDocomoAuthentication() {
        PageReference pr = CommunityHelper.docomoAuthentication('test');
        System.assertNotEquals(null, pr);
    }

    public static testMethod void testIsAppleUser() {
        Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
            Name = 'Apple',
            Partner_Type__c = 'Apple',
            Page_Name__c = 'PartnerAccount.page',
            Subscription_Type_Heading_Text__c = 'Apple',
            Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
            Payment_History_URL__c = 'https://www.google.com',
            Cancel_Subscription_URL_Small__c = 'https://www.google.com',
            Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
            Cancel_Subscription_URL_Large__c = 'https://www.google.com'
        );
        insert pac;
        Boolean isAppleUser = CommunityHelper.isAppleUser();
        System.assertEquals(false, isAppleUser);
    }

    public static testMethod void testvalidateIPAddressCountry() {
        List<DAZN_Help_Redirect__c> dhr = new List<DAZN_Help_Redirect__c>();
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Japan',
            Country__c = 'Japan',
            CountryISOCode__c = 'JP',
            IsDefaultCountry__c = false,
            Language__c = 'ja'
        ));
        insert dhr;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CommunityHelperTest.MockHttpResponseGenerator('Tokyo', 'Japan'));

        PageReference pr = CommunityHelper.validateIPAddress('test', 'test');
        CommunityHelper.callFutureOrNot(null);
        System.assertNotEquals(null, pr);
        Test.stopTest();
    }

    public static testMethod void testSetCountryAndLanguageCodesGuest() {
        User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];
        
        PageReference currentPage = ApexPages.currentPage();
        Map<String, String> countryAndLanguageCodes;

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('Tokyo', 'Japan'));
        System.RunAs(u) {
            Test.setCurrentPage(currentPage);
            countryAndLanguageCodes = CommunityHelper.getCountryAndLanguageCodes('ja');
        }
        Test.stopTest();

        System.assertEquals('ja', countryAndLanguageCodes.get('lang'));
        System.assertEquals('JP', countryAndLanguageCodes.get('Country'));
    }

    public static testMethod void testSetCountryAndLanguageCodesUser() {
        Account oAccount = SetUpTestData.createPersonAccount('DE', 'en_US', 'TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser('en_US', 'DE', oAccount.Id, 'testemail@email.com', 'testusername17@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        
        PageReference currentPage = ApexPages.currentPage();
        Map<String, String> countryAndLanguageCodes;

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('Tokyo', 'Japan'));
        System.RunAs(cUser) {
            Test.setCurrentPage(currentPage);
            countryAndLanguageCodes = CommunityHelper.getCountryAndLanguageCodes(null);
        }
        Test.stopTest();

        System.assertEquals('en', countryAndLanguageCodes.get('lang'));
        System.assertEquals('DE', countryAndLanguageCodes.get('Country'));
    }

    public static testMethod void testFormatLangCode() {
        Test.StartTest();
        String lang1 = CommunityHelper.formatLangCode(null, null, 'en_GB');
        System.assertEquals('en', lang1);
        String lang2 = CommunityHelper.formatLangCode('Canada', null, 'fr');
        System.assertEquals('fr_CA', lang2);
        Test.stopTest();
    }

    public static testMethod void testConvertDateTimeToString() {
        Datetime dt = Datetime.newInstance(2017, 1, 2);
        String formattedDate = CommunityHelper.ConvertDateToString(dt);
        System.assertEquals('02/01/2017', formattedDate);
    }

    public static testMethod void testGetDateByLocale() {
        Datetime dt = Datetime.newInstance(2017, 1, 2);
        String formattedDate = CommunityHelper.getDateByLocale(dt);
        System.assertEquals(Date.newInstance(2017, 1, 2).format(), formattedDate);
    }

    public static testMethod void testConvertDateToString() {
        Date dt = Date.newInstance(2017, 1, 2);
        String formattedDate1 = CommunityHelper.ConvertDateToString(dt, 'CA', 'lang');
        System.assertEquals('02/01/2017', formattedDate1);
        String formattedDate2 = CommunityHelper.ConvertDateToString(dt, 'AT', 'lang');
        System.assertEquals('02.01.2017', formattedDate2);
        String formattedDate3 = CommunityHelper.ConvertDateToString(dt, 'ZouraFormat', 'lang');
        System.assertEquals('2017-01-02', formattedDate3);
        String formattedDate4 = CommunityHelper.ConvertDateToString(dt, 'else', 'lang');
        System.assertEquals('2017/01/02', formattedDate4);
    }

    public static testMethod void testSignOutOfAllDevicesException() {
        CommunityHelper.signOutOfAllDevices(new User());
    }

    public class MockHttpResponse implements HttpCalloutMock {
        String body;
        Integer status;

        public MockHttpResponse(String body, Integer status) {
            this.body = body;
            this.status = status;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(body);
            res.setStatusCode(status);
            return res;
        }
    }

    public static testMethod void testGetSSOProfileIdForNonSSOUser() {
        Id ssoProfileId1 = CommunityHelper.getSSOProfileIdForNonSSOUser(null);
        System.assertEquals(null, ssoProfileId1);

        Id ssoProfileId2 = CommunityHelper.getSSOProfileIdForNonSSOUser(UserInfo.getUserId());
        System.assertEquals(null, ssoProfileId2);

        DAZNConfiguration__c daznConfig = new DAZNConfiguration__c(
            Name = 'SSO Comunity User Profile Id',
            Value__c = [Select Id From Profile Where Name = 'Customer Community User SSO' LIMIT 1].Id
        );
        insert daznConfig;
        Id ssoProfileId4 = CommunityHelper.getSSOProfileIdForNonSSOUser(UserInfo.getUserId());
        System.assertNotEquals(null, ssoProfileId4);
    }

    public static testMethod void testChangeProfileToSSO() {
        List<DAZNConfiguration__c> daznConfig = new List<DAZNConfiguration__c>();
        daznConfig.add(new DAZNConfiguration__c(
            Name = 'SSO Comunity User Profile Id',
            Value__c = [Select Id From Profile Where Name = 'Customer Community User SSO' LIMIT 1].Id
        ));
        insert daznConfig;

        List<MISL_Configuration__c> mislConfig = new List<MISL_Configuration__c>();
        mislConfig.add(new MISL_Configuration__c(
            Name = 'MISL_ChangeUserPassword_DE',
            Value__c = 'test',
            Enabled_Country_Codes__c = 'DE',
            Timeout__c = 3000
        ));
        mislConfig.add(new MISL_Configuration__c(
            Name = 'MISL_ChangeUserPassword_CA',
            Value__c = 'test',
            Enabled_Country_Codes__c = 'CA',
            Timeout__c = 3000
        ));
        mislConfig.add(new MISL_Configuration__c(
            Name = 'MISL_Username',
            Value__c = 'test'
        ));
        mislConfig.add(new MISL_Configuration__c(
            Name = 'MISL_Password',
            Value__c = EncodingUtil.base64Encode(Blob.valueOf('test'))
        ));
        insert mislConfig;

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testusername@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true, 'United Kingdom');
        Id ssoProfileId;

        System.runAs(oUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockChangePasswordSuccess());
            ssoProfileId = CommunityHelper.getSSOProfileIdForNonSSOUser(UserInfo.getUserId());
            Map<String, String> res1 = CommunityHelper.changeProfileToSSO('email@email.email', 'qwerty123', UserInfo.getUserId(), oAccount.Id, ssoProfileId, 'DE');
            System.assertEquals('true', res1.get('success'));

            Map<String, String> res2 = CommunityHelper.changeProfileToSSO(null, null, null, null, null, null);
            System.assertEquals('false', res2.get('success'));
            Test.stopTest();
        }
    }

    public static testMethod void testUpdateUserProfile() {
        List<DAZNConfiguration__c> daznConfig = new List<DAZNConfiguration__c>();
        daznConfig.add(new DAZNConfiguration__c(
            Name = 'UpdateProfileEndpoint',
            Value__c = 'test'
        ));
        daznConfig.add(new DAZNConfiguration__c(
            Name = 'UpdateProfileUsername',
            Value__c = 'test'
        ));
        daznConfig.add(new DAZNConfiguration__c(
            Name = 'UpdateProfilePassword',
            Value__c = EncodingUtil.base64Encode(Blob.valueOf('test'))
        ));
        insert daznConfig;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockUpdateProfileSuccess());
        CommunityHelper.updateUserProfile(UserInfo.getUserId(), UserInfo.getProfileId());
        Test.stopTest();

        System.assertNotEquals(null, DAZNConfiguration__c.getValues('UpdateProfileEndpoint'));
    }

    public static testMethod void testIsRunSSOFlow() {
        System.assertEquals(false, CommunityHelper.isRunSSOFlow('de'));

        DAZNConfiguration__c daznConfig = new DAZNConfiguration__c(
            Name = 'SSO Enabled Country Codes',
            Value__c = 'DE, CA'
        );
        insert daznConfig;

        System.assertEquals(true, CommunityHelper.isRunSSOFlow('de'));
        System.assertEquals(false, CommunityHelper.isRunSSOFlow('JP'));
    }

    public class MockUpdateProfileSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('Profile Updated');
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockChangePasswordSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ Password Changed }');
            res.setStatusCode(200);
            return res;
        }
    }

}