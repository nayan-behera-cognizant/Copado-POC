/**
* @author Cognizant Technology Solutuions
* @date 14/04/2016
* @description Test class to cover subscription trigger and handler functionality
*/
@isTest
public class SubscriptionTriggerHandlerTest {
    
    @testSetup
    public static void createTestData() {
        CreateTestDataforUnitTest.triggerSettings();
        //CreateZuoraDataforUnitTest.createZuoraDeatils();
        SetUpTestData.emailCustsett();
        
        /*To Create External User*/
        /*list<Profile> lstProf = [SELECT Id, Name from Profile where Name = 'External User' limit 1];
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId;
        uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
        list<User> lstUser =new list<User>();
        User oExtUser =new User(firstname = 'Test',
                                lastName = 'External'+uniqueName,
                                email = 'TestExt'+uniqueName + '@test' +'.com',
                                Username = 'TestExt' + uniqueName+'@test'+ '.org',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = 'TestExt',
                                IsActive = true,
                                Notification_Language_Code__c='ja',
                                TimeZoneSidKey = 'America/Los_Angeles', 
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = lstProf[0].id  );
        lstUser.add(oExtUser);
        insert lstUser;*/
        /*To create DAZN_Country_Currency_ISO_Code__c Custom Settings*/
        list<DAZN_Country_Currency_ISO_Code__c> oCurrencyISOCode = new list<DAZN_Country_Currency_ISO_Code__c>();
        DAZN_Country_Currency_ISO_Code__c isoUSD = new DAZN_Country_Currency_ISO_Code__c();
        isoUSD.name = 'USD';
        isoUSD.CurrencySymbol__c = '$';
        oCurrencyISOCode.add(isoUSD);
        
        DAZN_Country_Currency_ISO_Code__c isoJPY = new DAZN_Country_Currency_ISO_Code__c();
        isoJPY.name = 'JPY';
        isoJPY.CurrencySymbol__c = '¥';
        oCurrencyISOCode.add(isoJPY);
        
        DAZN_Country_Currency_ISO_Code__c isoGBP = new DAZN_Country_Currency_ISO_Code__c();
        isoGBP.name = 'GBP';
        isoGBP.CurrencySymbol__c = '£';
        oCurrencyISOCode.add(isoGBP);
        
        insert oCurrencyISOCode;
        System.assert(oCurrencyISOCode.size()>0);
        
        /*To create Payment_Method__c Custom setting*/
        
        Payment_Method__c oPayment = new Payment_Method__c();
        oPayment.name = 'Credit Card';
        oPayment.Japan__c= 'クレジットカード';
        oPayment.German__c= 'KreditKarte';
        insert oPayment;
        System.assertNotEquals(null, oPayment.id);
        
        /*To create Plan_Details__c Custom setting*/
        
        Plan_Details__c oPlanDetails = new Plan_Details__c();
        oPlanDetails.Name = 'Free Trial';
        oPlanDetails.Japan__c = '無料体験';
        oPlanDetails.German__c = 'Gratismonat';
        insert oPlanDetails;
        System.assertNotEquals(null, oPlanDetails.id);
    }

    /*Description: Test method to verify the functionality of trigger when trigger settings are disabled*/
    public static testMethod void testTriggerSettings(){
        CreateZuoraDataforUnitTest.createZuoraDeatils();
        TriggerSetting__c oTrigSetting = TriggerSetting__c.getInstance('SubscriptionTrigger');
        oTrigSetting.Disable__c = true;
        update oTrigSetting;
        
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Free Trial' limit 1];
        system.assert(acclist.size()>0);
        list<Zuora__Subscription__c> lstSubscription = [select id, Name from Zuora__Subscription__c where Zuora__Account__c =: accList[0].id limit 1];
        system.assertNotEquals(null, lstSubscription);
        /*Updating the Subscription details to fire the Subscription Trigger*/
        lstSubscription[0].Name = 'billing account';
        update lstSubscription;
    }
    
    /*
Description: Test method to verify the functionality to Update Account with Subscription next charge date and subscription date*/
    
    public static testMethod void testUpdateSubscriptionInfoOnAccount(){
        CreateZuoraDataforUnitTest.createZuoraDeatils();
        list<Account> acclist = [select id,Name,PersonEmail,PersonContactId from Account where Account_status__c = 'Free Trial' limit 1];
        list<Zuora__CustomerAccount__c> lstBillingAcc = [select id, Name from Zuora__CustomerAccount__c where Zuora__Account__c =:acclist[0].id limit 1];
        list<Zuora__Subscription__c> lstSubscription = [select id, Name,Zuora__Status__c,Zuora__SubscriptionStartDate__c,Zuora__NextChargeDate__c,Zuora__Account__c,Zuora__CustomerAccount__c from Zuora__Subscription__c where Zuora__Account__c =: accList[0].id limit 1];
        System.assert(lstSubscription.size()>0);
        list<Profile> lstExtProfile = [SELECT Id, Name from Profile where Name = 'External User' limit 1];
        List<User> eUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstExtProfile[0].id  AND IsActive = true LIMIT 1];
        
        /*Added for PD-7830*/
        System.runAs(eUser[0]){
            test.startTest();
            SubscriptionTriggerHandler oSubscriptionTriggerHandler = new SubscriptionTriggerHandler();
            oSubscriptionTriggerHandler.UpdateSubscriptionInfoOnAccount(lstSubscription);
            
            /*To test if the Account status is cancelled*/
            lstSubscription[0].Zuora__Status__c ='Cancelled';
            update lstSubscription;
            oSubscriptionTriggerHandler.UpdateSubscriptionInfoOnAccount(lstSubscription);
            test.stopTest();
        }
    }
    //PD-9770
    public static User createProfile(String profileName){
        
        list<Profile> pList = [SELECT id, Name FROM Profile where name =: profileName limit 1 ];
        
        //verify the size of the profile list 
        System.assertEquals(1, pList.size() );
        
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId;
        uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
        //list<User> alistUser =new list<User>();
        User aUser =new User(  firstname = 'Test',
                             lastName = 'Member'+uniqueName,
                             email = 'TestMember'+uniqueName + '@test' +'.com',
                             Username = 'TestMember' + uniqueName+'@test'+ '.org',
                             EmailEncodingKey = 'ISO-8859-1',
                             Alias = 'Memeber',
                             Notification_Language_Code__c='DE',
                             TimeZoneSidKey = 'America/Los_Angeles', 
                             LocaleSidKey = 'en_US',
                             LanguageLocaleKey = 'en_US',
                             isActive =true,
                             ProfileId = pList[0].id );
        
        insert aUser;
        System.assertEquals('Test', aUser.FirstName);
        return aUser;
    }

    /* Commented out according to PD-11495:
    //PD-9770
    public static testMethod void testDoubleOptInNotification(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        SetUpTestData.testCreateDAZNConfiguration('DoubleOptInCountries', 'Germany');
        List<Account> lstUpdatedAccount = new List<Account>();
        Account oAccount1 = SetUpTestData.createPersonAccount('TestFirstName1', 'TestLastName1','test@test1.com','Free Trial');
        
        Account oAccount2 = SetUpTestData.createPersonAccount('TestFirstName2', 'TestLastName2','test@test2.com','Free Trial');
        Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
            Name = 'Docomo',
            Partner_Type__c = 'DAZN for Docomo',
            Page_Name__c = 'PartnerAccount.page',
            Subscription_Type_Heading_Text__c = 'DAZN for Docomo',
            Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
            Payment_History_URL__c = 'https://www.google.com',
            Cancel_Subscription_URL_Small__c = 'https://www.google.com',
            Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
            Cancel_Subscription_URL_Large__c = 'https://www.google.com'
        );
        insert pac;
        User oUser1 = SetUpTestData.createCommunityUser(oAccount1.Id, 'test@test1.com', 'testlsut1uniq@email.com.ls', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFirstName1','TestLastName1',true);
        User oUser2 = SetUpTestData.createCommunityUser(oAccount2.Id, 'test@test2.com', 'testlsut2uniq@email.com.ls', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFirstName2','TestLastName2',true);
        
        list<User> listUpdatedUser = new list<User>();
        
        oUser1.Country='Germany';
        listUpdatedUser.add(oUser1);
        
        oUser2.Country='Germany';
        listUpdatedUser.add(oUser2);
        System.assert(listUpdatedUser.size()>0);
        
        oAccount1.All_Email_Preferences__c = true;
        lstUpdatedAccount.add(oAccount1);
        
        oAccount2.All_Email_Preferences__c = true;
        lstUpdatedAccount.add(oAccount2);
        System.assert(lstUpdatedAccount.size()>0);
        
        List<Account> lstAccount = [Select id from Account where personemail in ('test@test1.com', 'test@test2.com')];
        list<String> lstAccountId = new list<String>();
        for(Account oAccount : lstAccount){
            lstAccountId.add(oAccount.Id);
        }
        System.assert(lstAccountId.size()>0);
        
        User oProfileUser = createProfile('System Administrator');
        System.assertNotEquals(null, oProfileUser.Id);
        
        System.runAs (oProfileUser) {
            test.startTest();
            update lstUpdatedAccount;
            update listUpdatedUser;
            SubscriptionTriggerHandler.sendDoubleOptinmailNotification(lstAccountId);            
            test.stoptest(); 
        }
    }*/

    static testMethod void evergreenWelcomeEmailsSyncCreationTest() {
        SetUpTestData.triggerSettings();
        Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
            Name = 'Docomo',
            Partner_Type__c = 'Docomo',
            Page_Name__c = 'PartnerAccount.page',
            Subscription_Type_Heading_Text__c = 'Docomo',
            Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
            Payment_History_URL__c = 'https://www.google.com',
            Cancel_Subscription_URL_Small__c = 'https://www.google.com',
            Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
            Cancel_Subscription_URL_Large__c = 'https://www.google.com'
        );
        insert pac;
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName6', 'TestLastName6','test6@test.com','Free Trial');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        oAccount.Free_Trial_Start_Date__c = System.today().addDays(-1);
        update oAccount;

        Zuora__PaymentMethod__c oPaymethMethod = new Zuora__PaymentMethod__c(
            Zuora__PaymentMethodStatus__c = 'Active',
            Zuora__Type__c = 'CreditCard',
            Zuora__CreditCardMaskNumber__c = '************1111',
            Zuora__CreditCardType__c = 'Visa',
            Zuora__DefaultPaymentMethod__c = true,
            Zuora__CreditCardExpirationMonth__c = '8',
            Zuora__CreditCardExpirationYear__c = '2018',
            Zuora__BankIdentificationNumber__c = '411111',
            Zuora__LastTransactionStatus__c = 'Approved',
            Zuora__BankTransferAccountNumber__c = '4111111111111111',
            Zuora__BillingAccount__c = bAccount.id
        );
        insert oPaymethMethod;

        Test.StartTest();
        /*Add Zuora Subscription*/
        Zuora__Subscription__c oSubscription = new Zuora__Subscription__c(
            Name = 'test billing account',
            Zuora__Status__c = 'Active',
            Zuora__SubscriptionStartDate__c = Date.Today(),
            Zuora__NextChargeDate__c = Date.today().addMonths(2),
            Zuora__Account__c = bAccount.Zuora__Account__c,
            Zuora__CustomerAccount__c = bAccount.Id,
            Zuora__TermStartDate__c = Date.Today(),
            Zuora__TermSettingType__c = 'EVERGREEN',
            NumFreeTrialPeriods__c = '1',
            NumGiftPeriods__c = '1'
        );
        insert oSubscription;
        Test.StopTest();
        List<Email_Sync_Queue__c> welcomeEmailSyncQueue = [SELECT Id FROM Email_Sync_Queue__c WHERE Dispatch_ID__c = 12334];
        System.assertEquals(true, welcomeEmailSyncQueue.size() > 0);
    }
    static testMethod void termedWelcomeEmailsSyncCreationTest() {
        SetUpTestData.triggerSettings();
        Date date1 = Date.today();
        Date date2 = Date.today().addDays(2);
        SubscriptionTriggerHandler.calculateRebillDate(date1, date2);
        SubscriptionTriggerHandler.calculateRebillDate(date2, date1);
        SubscriptionTriggerHandler.calculateRebillDate(date2, null);
        SubscriptionTriggerHandler.calculateRebillDate(null, date2);
        Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
            Name = 'Docomo',
            Partner_Type__c = 'Docomo',
            Page_Name__c = 'PartnerAccount.page',
            Subscription_Type_Heading_Text__c = 'Docomo',
            Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
            Payment_History_URL__c = 'https://www.google.com',
            Cancel_Subscription_URL_Small__c = 'https://www.google.com',
            Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
            Cancel_Subscription_URL_Large__c = 'https://www.google.com'
        );
        insert pac;
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName6', 'TestLastName6','test6@test.com','Free Trial');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        oAccount.Free_Trial_Start_Date__c = System.today().addDays(-1);
        update oAccount;

        Zuora__PaymentMethod__c oPaymethMethod = new Zuora__PaymentMethod__c(
            Zuora__PaymentMethodStatus__c = 'Active',
            Zuora__Type__c = 'CreditCard',
            Zuora__CreditCardMaskNumber__c = '************1111',
            Zuora__CreditCardType__c = 'Visa',
            Zuora__DefaultPaymentMethod__c = true,
            Zuora__CreditCardExpirationMonth__c = '8',
            Zuora__CreditCardExpirationYear__c = '2018',
            Zuora__BankIdentificationNumber__c = '411111',
            Zuora__LastTransactionStatus__c = 'Approved',
            Zuora__BankTransferAccountNumber__c = '4111111111111111',
            Zuora__BillingAccount__c = bAccount.id
        );
        insert oPaymethMethod;

        Test.StartTest();
        /*Add Zuora Subscription*/
        List<Zuora__Subscription__c> subscriptions = new List<Zuora__Subscription__c>();
        subscriptions.add(new Zuora__Subscription__c(
            Name = 'test billing account',
            Zuora__Status__c = 'Active',
            Zuora__SubscriptionStartDate__c = Date.Today(),
            Zuora__NextChargeDate__c = Date.today().addMonths(2),
            Zuora__Account__c = bAccount.Zuora__Account__c,
            Zuora__CustomerAccount__c = bAccount.Id,
            Zuora__TermStartDate__c = Date.Today(),
            Zuora__TermSettingType__c = 'TERMED',
            NumFreeTrialPeriods__c = '1',
            NumGiftPeriods__c = '1'
        ));
        subscriptions.add(new Zuora__Subscription__c(
            Name = 'test billing account',
            Zuora__Status__c = 'Active',
            Zuora__SubscriptionStartDate__c = Date.Today(),
            Zuora__NextChargeDate__c = Date.today().addMonths(2),
            Zuora__Account__c = bAccount.Zuora__Account__c,
            Zuora__CustomerAccount__c = bAccount.Id,
            Zuora__TermStartDate__c = Date.Today(),
            Zuora__TermSettingType__c = 'TERMED',
            SourceSystem__c = 'Apple',
            NumFreeTrialPeriods__c = '1',
            NumGiftPeriods__c = '1'
        ));
        subscriptions.add(new Zuora__Subscription__c(
            Name = 'test billing account',
            Zuora__Status__c = 'Active',
            Zuora__SubscriptionStartDate__c = Date.Today(),
            Zuora__NextChargeDate__c = Date.today().addMonths(2),
            Zuora__Account__c = bAccount.Zuora__Account__c,
            Zuora__CustomerAccount__c = bAccount.Id,
            Zuora__TermStartDate__c = Date.Today(),
            Zuora__TermSettingType__c = 'TERMED',
            SourceSystem__c = 'Roku',
            NumFreeTrialPeriods__c = '1',
            NumGiftPeriods__c = '1'
        ));
        insert subscriptions;
        Test.StopTest();
        List<Email_Sync_Queue__c> welcomeEmailSyncQueue = [SELECT Id FROM Email_Sync_Queue__c WHERE Dispatch_ID__c = 12333];
        System.assertEquals(true, welcomeEmailSyncQueue.size() > 0);
    }

    public static testMethod void testSetFreeTrialEndDateUpdate() {
        CreateZuoraDataforUnitTest.createZuoraDeatils();
        List<Account> acclist = [Select Id, Name, PersonEmail, PersonContactId
            From Account
            Where Account_status__c = 'Free Trial'
            LIMIT 1];
        List<Zuora__CustomerAccount__c> lstBillingAcc = [Select Id, Name
            From Zuora__CustomerAccount__c
            Where Zuora__Account__c = :acclist[0].Id
            LIMIT 1];
        List<Zuora__Subscription__c> lstSubscription = [Select Id, NumFreeTrialPeriods__c, Free_Trial_End_Date__c, Zuora__SubscriptionStartDate__c
            From Zuora__Subscription__c
            Where Zuora__Account__c = :accList[0].Id
            LIMIT 1];

        System.assert(lstSubscription.size() > 0);
        
        lstSubscription[0].NumFreeTrialPeriods__c = '1';
        update lstSubscription;

        lstSubscription = [Select Id, NumFreeTrialPeriods__c, Free_Trial_End_Date__c, Zuora__SubscriptionStartDate__c
            From Zuora__Subscription__c
            Where Zuora__Account__c = :accList[0].Id
            LIMIT 1];

        System.assertEquals(lstSubscription[0].Zuora__SubscriptionStartDate__c.addMonths(Integer.valueOf(lstSubscription[0].NumFreeTrialPeriods__c)), lstSubscription[0].Free_Trial_End_Date__c);

        lstSubscription[0].NumFreeTrialPeriods__c = '0';
        update lstSubscription;

        lstSubscription = [Select Id, NumFreeTrialPeriods__c, Free_Trial_End_Date__c, Zuora__SubscriptionStartDate__c
            From Zuora__Subscription__c
            Where Zuora__Account__c = :accList[0].Id
            LIMIT 1];

        System.assertEquals(lstSubscription[0].Zuora__SubscriptionStartDate__c, lstSubscription[0].Free_Trial_End_Date__c);

    }

    public static testMethod void testSetFreeTrialEndDateInsert() {
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.CreateTestCommunityUsers();        
        List<Account> accList = [Select Id, Name, PersonContactId From Account LIMIT 1];
        List<Zuora__CustomerAccount__c> bAccount = new List<Zuora__CustomerAccount__c>();
        List<Zuora__Subscription__c> lstSubscription = new list<Zuora__Subscription__c>();
        List<Zuora__PaymentMethod__c> oZuoraPayMethList = new List<Zuora__PaymentMethod__c>();
        Integer bcount = 1;
        for (Account accOb: accList) {
            Zuora__CustomerAccount__c zCustomerAcct = new Zuora__CustomerAccount__c();
            zCustomerAcct.Zuora__Account__c = accOb.id;
            zCustomerAcct.Name = accOb.Name;
            zCustomerAcct.Zuora__Status__c = 'Active';
            zCustomerAcct.Zuora__AccountNumber__c = 'A'+bcount;
            zCustomerAcct.Zuora__BillToName__c = 'billing account'+accOb.Name;
            zCustomerAcct.Zuora__BillToCountry__c = 'Japan';
            zCustomerAcct.Zuora__SoldToName__c = 'billing account'+accOb.Name;
            zCustomerAcct.Zuora__DefaultPaymentMethod__c= 'CreditCard';
            zCustomerAcct.Zuora__Batch__c= 'Batch1';
            zCustomerAcct.Zuora__Currency__c= 'JPY';
            zCustomerAcct.Zuora__BillCycleDay__c= '5th of the month';
            bAccount.add(zCustomerAcct);
            bcount++;
        }
        insert bAccount;
        //add Zuora PaymentMethod
        for (Zuora__CustomerAccount__c obill: bAccount) {
            Zuora__PaymentMethod__c oPaymethMethod = new Zuora__PaymentMethod__c();
            oPaymethMethod.Zuora__PaymentMethodStatus__c = 'Active';
            oPaymethMethod.Zuora__Type__c = 'CreditCard';
            oPaymethMethod.Zuora__CreditCardMaskNumber__c = '************1111';
            oPaymethMethod.Zuora__CreditCardType__c = 'Visa';
            oPaymethMethod.Zuora__DefaultPaymentMethod__c = true;
            oPaymethMethod.Zuora__CreditCardExpirationMonth__c = '8';
            oPaymethMethod.Zuora__CreditCardExpirationYear__c = '2018';
            oPaymethMethod.Zuora__BankIdentificationNumber__c = '411111';
            oPaymethMethod.Zuora__LastTransactionStatus__c = 'Approved';
            oPaymethMethod.Zuora__BankTransferAccountNumber__c = '4111111111111111';
            oPaymethMethod.Zuora__BillingAccount__c = obill.id;
            oZuoraPayMethList.add(oPaymethMethod);
        }
        insert oZuoraPayMethList;
        /*Add Zuora Subscription*/
        for (Zuora__CustomerAccount__c obillAcc: bAccount) {
            Zuora__Subscription__c oSubscription = new Zuora__Subscription__c();
            oSubscription.Name = 'test billing account';
            oSubscription.Zuora__Status__c = 'Active';
            oSubscription.Zuora__SubscriptionStartDate__c = Date.Today();
            oSubscription.Zuora__NextChargeDate__c = Date.today().addMonths(2);
            oSubscription.Zuora__Account__c = obillAcc.Zuora__Account__c;
            oSubscription.Zuora__CustomerAccount__c = obillAcc.Id;
            oSubscription.Zuora__TermStartDate__c = Date.Today();
            oSubscription.NumFreeTrialPeriods__c = '1';
            lstSubscription.add(oSubscription);
        }
        insert lstSubscription;

        lstSubscription = [Select Id, NumFreeTrialPeriods__c, Free_Trial_End_Date__c, Zuora__SubscriptionStartDate__c
            From Zuora__Subscription__c
            Where Zuora__Account__c = :accList[0].Id
            LIMIT 1];

        System.assert(lstSubscription.size() > 0);
        System.assertEquals(lstSubscription[0].Zuora__SubscriptionStartDate__c.addMonths(Integer.valueOf(lstSubscription[0].NumFreeTrialPeriods__c)), lstSubscription[0].Free_Trial_End_Date__c);
    }

    public static testMethod void testGiftCodeEndDateInsert() {
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.CreateTestCommunityUsers();        
        List<Account> accList = [Select Id, Name, PersonContactId From Account LIMIT 1];
        List<Zuora__CustomerAccount__c> bAccount = new List<Zuora__CustomerAccount__c>();
        List<Zuora__Subscription__c> lstSubscription = new list<Zuora__Subscription__c>();
        List<Zuora__PaymentMethod__c> oZuoraPayMethList = new List<Zuora__PaymentMethod__c>();
        Integer bcount = 1;
        for (Account accOb: accList) {
            Zuora__CustomerAccount__c zCustomerAcct = new Zuora__CustomerAccount__c();
            zCustomerAcct.Zuora__Account__c = accOb.id;
            zCustomerAcct.Name = accOb.Name;
            zCustomerAcct.Zuora__Status__c = 'Active';
            zCustomerAcct.Zuora__AccountNumber__c = 'A'+bcount;
            zCustomerAcct.Zuora__BillToName__c = 'billing account'+accOb.Name;
            zCustomerAcct.Zuora__BillToCountry__c = 'Japan';
            zCustomerAcct.Zuora__SoldToName__c = 'billing account'+accOb.Name;
            zCustomerAcct.Zuora__DefaultPaymentMethod__c= 'CreditCard';
            zCustomerAcct.Zuora__Batch__c= 'Batch1';
            zCustomerAcct.Zuora__Currency__c= 'JPY';
            zCustomerAcct.Zuora__BillCycleDay__c= '5th of the month';
            bAccount.add(zCustomerAcct);
            bcount++;
        }
        insert bAccount;
        //add Zuora PaymentMethod
        for (Zuora__CustomerAccount__c obill: bAccount) {
            Zuora__PaymentMethod__c oPaymethMethod = new Zuora__PaymentMethod__c();
            oPaymethMethod.Zuora__PaymentMethodStatus__c = 'Active';
            oPaymethMethod.Zuora__Type__c = 'CreditCard';
            oPaymethMethod.Zuora__CreditCardMaskNumber__c = '************1111';
            oPaymethMethod.Zuora__CreditCardType__c = 'Visa';
            oPaymethMethod.Zuora__DefaultPaymentMethod__c = true;
            oPaymethMethod.Zuora__CreditCardExpirationMonth__c = '8';
            oPaymethMethod.Zuora__CreditCardExpirationYear__c = '2018';
            oPaymethMethod.Zuora__BankIdentificationNumber__c = '411111';
            oPaymethMethod.Zuora__LastTransactionStatus__c = 'Approved';
            oPaymethMethod.Zuora__BankTransferAccountNumber__c = '4111111111111111';
            oPaymethMethod.Zuora__BillingAccount__c = obill.id;
            oZuoraPayMethList.add(oPaymethMethod);
        }
        insert oZuoraPayMethList;
        /*Add Zuora Subscription*/
        for (Zuora__CustomerAccount__c obillAcc: bAccount) {
            Zuora__Subscription__c oSubscription = new Zuora__Subscription__c();
            oSubscription.Name = 'test billing account';
            oSubscription.Zuora__Status__c = 'Active';
            oSubscription.Zuora__SubscriptionStartDate__c = Date.Today();
            oSubscription.Zuora__NextChargeDate__c = Date.today().addMonths(2);
            oSubscription.Zuora__Account__c = obillAcc.Zuora__Account__c;
            oSubscription.Zuora__CustomerAccount__c = obillAcc.Id;
            oSubscription.Zuora__TermStartDate__c = Date.Today();
            oSubscription.NumGiftPeriods__c = '1';
            lstSubscription.add(oSubscription);
        }
        insert lstSubscription;

        lstSubscription = [Select Id, NumGiftPeriods__c, Gift_Code_End_Date__c, Zuora__SubscriptionStartDate__c
            From Zuora__Subscription__c
            Where Zuora__Account__c = :accList[0].Id
            LIMIT 1];

        System.assert(lstSubscription.size() > 0);
        System.assertEquals(lstSubscription[0].Zuora__SubscriptionStartDate__c.addMonths(Integer.valueOf(lstSubscription[0].NumGiftPeriods__c)), lstSubscription[0].Gift_Code_End_Date__c);
    }
}