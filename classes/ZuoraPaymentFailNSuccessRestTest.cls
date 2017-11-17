/**
* @author Cognizant Technology Solutuions
* @date 05/02/2015
* @description This class test first payment fail.
*/ 
@isTest
public class ZuoraPaymentFailNSuccessRestTest{

    @testSetup
    public static void setData(){
        List<DAZNCommunicatorConfig__c> lstCustomSetting = new List<DAZNCommunicatorConfig__c>();
        List<DAZNConfiguration__c> lstConfig = new List<DAZNConfiguration__c>();
        
        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'test.salesforce.com');
        SetUpTestData.testCreateDAZNConfiguration('EncryptionKey', '160ab450f9c22gb1');
        SetUpTestData.testCreateDAZNConfiguration('CommunicatorAPIUserName', 'test');
        SetUpTestData.testCreateDAZNConfiguration('CommunicatorAPIUserPwd', 'oL9IBIKPqWGSvVXHuhKawxjDx/PhfrWZGHjsKrMA/J8=');
        
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_User_Cancel_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Updated_Name_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Updated_Password_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Forgotten_Password_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Partial_Welcome_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Free_Trial_Welcome_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Hard_Offer_Welcome_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Successful_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Failure_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Subscription_End_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_New_Device_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Updatation_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Expiry_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Failure',Value__c=22345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Contacts_Table_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='MailingList_Transactional_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SalesForceID_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Email_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='FirstName_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='LastName_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SubscriptionEndDate_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Currency_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SubscriptionAmount_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='PlanDetails_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='PaymentMethodType_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='FreeTrialEndDate_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='AccountStatus_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='NotificationLanguageCode_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='NotificationCountryCode_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='CountryLanguage_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SignInLink_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Germany_Marketing_Mailing_List_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Marketing_Germany_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='UnsubscribeLanguage_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='CommunicatorAPITimeOutLimit',Value__c=60000));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Marketing_Mailing_List_ID',Value__c=63500)); 
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Inactive_Device_DE_en_GB',Value__c=60000)); 
        lstConfig.add(new DAZNConfiguration__c(name='DoubleOptInCountries',Value__c='DE,AT'));
        // added new 
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Docomo_MarketingMailingListID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Docomo_Contact_Table_ID',Value__c=21345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DFD_SalesforceColumnID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DfdColumnID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='HardOfferDateTime_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='ResetPasswordURL_Column_ID',Value__c=12345));

        insert lstCustomSetting;   
        insert lstConfig;
    }

    static testMethod void testFirstFail() {
        SetUpTestData.triggerSettings();
        List<DAZNConfiguration__c> lstConfig = new List<DAZNConfiguration__c>();    
        lstConfig.add(new DAZNConfiguration__c(Name = 'AccountsToBeExcludedFromZuoraCallouts', Value__c= 'Apple  , User '));
        insert lstConfig;
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail321@email.com', 'testusername321@email.com', 'tst321','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        bAccount.Zuora__Zuora_Id__c = 'TestFF123';
        update bAccount;
        
        Test.StartTest();
        
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/FirstFail';
        req.requestBody = Blob.valueof('<?xml version="1.0" encoding="UTF-8"?><callout><parameter name="AccountID">'+ bAccount.Zuora__Zuora_Id__c +'</parameter></callout>');
        req.httpMethod = 'POST';
        RestContext.request = req;
        
        FirstFail.newSubscriptionPost();

        List<Zuora__CustomerAccount__c> lstBillingAccount = [Select First_Payment_Trial__c, Payment_Success__c from Zuora__CustomerAccount__c where Zuora__Zuora_Id__c =: bAccount.Zuora__Zuora_Id__c limit 1];
        System.assertEquals(true, lstBillingAccount[0].First_Payment_Trial__c);
        System.assertEquals(false, lstBillingAccount[0].Payment_Success__c);
        
        // for PD-12533: check id Email_Sync_Queue__c were created
        System.assertEquals(true, [SELECT Id FROM Email_Sync_Queue__c WHERE Dispatch_ID__c = 22345].size() > 0);

        // For PD-10451
        oAccount.Type = 'Apple';
        update oAccount;
        oAccount.Type = 'User';
        update oAccount;

        Test.StopTest();
    }

    
    
    static testMethod void testPaymentSuccess(){
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail321@email.com', 'testusername321@email.com', 'tst321','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        
        bAccount.Zuora__Zuora_Id__c = 'TestPS123';
        bAccount.First_Payment_Trial__c = true;
        update bAccount;
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
        Test.StartTest();
        
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/PaymentSuccess';
        req.requestBody = Blob.valueof('<?xml version="1.0" encoding="UTF-8"?><callout><parameter name="AccountID">'+ bAccount.Zuora__Zuora_Id__c +'</parameter></callout>');
        req.httpMethod = 'POST';
        RestContext.request = req;
        
        PaymentSuccess.newSubscriptionPost();
        
        List<Zuora__CustomerAccount__c> lstBillingAccount = [Select First_Payment_Trial__c, Payment_Success__c from Zuora__CustomerAccount__c where Zuora__Zuora_Id__c =: bAccount.Zuora__Zuora_Id__c limit 1];
        System.assertEquals(false, lstBillingAccount[0].First_Payment_Trial__c);
        System.assertEquals(true, lstBillingAccount[0].Payment_Success__c); 
        
        Test.StopTest();
    }

    static testMethod void testCancelEmail() {
        /*
        List<DAZNCommunicatorConfig__c> lstCustomSetting = new List<DAZNCommunicatorConfig__c>();
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='CommunicatorAPITimeOutLimit',Value__c=60000));
        insert lstCustomSetting;*/
        list<DAZNCommunicatorConfig__c> communicatorConfigs = new List<DAZNCommunicatorConfig__c>();
        communicatorConfigs.add(new DAZNCommunicatorConfig__c(Name='DispatchID_User_Cancel',Value__c=1233));
        communicatorConfigs.add(new DAZNCommunicatorConfig__c(Name='DispatchID_Payment_Failed_User_Frozen',Value__c=1234));
        communicatorConfigs.add(new DAZNCommunicatorConfig__c(Name='DispatchID_Immediate_Cancellation',Value__c=1235));
        communicatorConfigs.add(new DAZNCommunicatorConfig__c(Name='DispatchID_Paused_Cancellation',Value__c=1236));
        insert communicatorConfigs;

        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail321@email.com', 'testusername321@email.com', 'tst321','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');    
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 10.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 10.00);

        Zuora__Subscription__c subscription = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Zuora__Subscription__c', '', date.today(), date.today().addDays(7));

        bAccount.Zuora__Zuora_Id__c = 'TestFF123';
        bAccount.Zuora__External_Id__c='ZuaraExtId';
        update bAccount;
        oAccount.Hard_Offer_Date__c = DateTime.now();
        update oAccount;
        
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

        Test.setMock(HttpCalloutMock.class, new CancelHttpMock());
        Test.StartTest();

        /* Invocation of Standard cancellation with accountBillCycleDay and subscriptionTermEndDate = today */
        String accountBillCycleDayTmp = String.valueOf(System.Date.today().day());
        String subscriptionTermEndDateTmpToday = String.valueOf(System.Date.today());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CancelEmail';
        String jsonStringToday = '{' +
            '"AccountCrmId" : "' + bAccount.Id + '",' +
            '"AccountId" : "' + bAccount.Zuora__External_Id__c + '",' +
            '"AccountBillCycleDay" : "' + accountBillCycleDayTmp + '",' +
            '"SubscriptionTermEndDate" : "' + subscriptionTermEndDateTmpToday + '",' +
            '"DefaultPaymentMethodType" : "CreditCard",' +
            '"SubscriptionName" : "Zuora__Subscription__c"' +
        '}';
        req.requestBody = Blob.valueof(jsonStringToday);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        System.assertEquals('Success', CancelEmail.cancelSubscriptionPost());

        /* Invocation of Standard cancellation with subscriptionTermEndDate in the Future */
        String subscriptionTermEndDateFuture = String.valueOf(System.Date.today().addDays(5));
        String jsonStringFuture = '{' +
            '"AccountCrmId" : "' + bAccount.Id + '",' +
            '"AccountId" : "' + bAccount.Zuora__External_Id__c + '",' +
            '"AccountBillCycleDay" : "' + accountBillCycleDayTmp + '",' +
            '"SubscriptionTermEndDate" : "' + subscriptionTermEndDateFuture + '",' +
            '"DefaultPaymentMethodType" : "CreditCard",' +
            '"SubscriptionName" : "Zuora__Subscription__c"' +
        '}';
        req.requestBody = Blob.valueof(jsonStringFuture);
        System.assertEquals('Success', CancelEmail.cancelSubscriptionPost());

        subscription.Zuora__TermSettingType__c = 'TERMED';
        update subscription;

        /* Invocation of Standard cancellation with subscriptionTermEndDate in the Future */
        subscriptionTermEndDateFuture = String.valueOf(System.Date.today().addDays(5));
        jsonStringFuture = '{' +
            '"AccountCrmId" : "' + bAccount.Id + '",' +
            '"AccountId" : "' + bAccount.Zuora__External_Id__c + '",' +
            '"AccountBillCycleDay" : "' + accountBillCycleDayTmp + '",' +
            '"SubscriptionTermEndDate" : "' + subscriptionTermEndDateFuture + '",' +
            '"DefaultPaymentMethodType" : "CreditCard",' +
            '"SubscriptionName" : "Zuora__Subscription__c"' +
        '}';
        req.requestBody = Blob.valueof(jsonStringFuture);
        System.assertEquals('Success', CancelEmail.cancelSubscriptionPost());

        oAccount.Account_Status__c = 'Active Paid';
        update oAccount;

        /* Invocation of Immediate cancellation with subscriptionTermEndDate in the past */
        String subscriptionTermEndDateTmpPast = String.valueOf(System.Date.today().addDays(-1));
        String jsonStringPast = '{' +
            '"AccountCrmId" : "' + bAccount.Id + '",' +
            '"AccountId" : "' + bAccount.Zuora__External_Id__c + '",' +
            '"AccountBillCycleDay" : "' + accountBillCycleDayTmp + '",' +
            '"SubscriptionTermEndDate" : "' + subscriptionTermEndDateTmpPast + '",' +
            '"DefaultPaymentMethodType" : "CreditCard",' +
            '"SubscriptionName" : "Zuora__Subscription__c"' +
        '}';
        req.requestBody = Blob.valueof(jsonStringPast);
        System.assertEquals('Success', CancelEmail.cancelSubscriptionPost());


        oAccount.Account_Status__c = 'Active Grace';
        update oAccount;

        /* Invocation of Immediate cancellation with subscriptionTermEndDate in the past */
        subscriptionTermEndDateTmpPast = String.valueOf(System.Date.today().addDays(-1));
        jsonStringPast = '{' +
            '"AccountCrmId" : "' + bAccount.Id + '",' +
            '"AccountId" : "' + bAccount.Zuora__External_Id__c + '",' +
            '"AccountBillCycleDay" : "' + accountBillCycleDayTmp + '",' +
            '"SubscriptionTermEndDate" : "' + subscriptionTermEndDateTmpPast + '",' +
            '"DefaultPaymentMethodType" : "CreditCard",' +
            '"SubscriptionName" : "Zuora__Subscription__c"' +
        '}';
        req.requestBody = Blob.valueof(jsonStringPast);
        System.assertEquals('Success', CancelEmail.cancelSubscriptionPost());

        oAccount.Account_Status__c = 'Partial';
        update oAccount;
        
        /* Invocation of Immediate cancellation with subscriptionTermEndDate in the past */
        subscriptionTermEndDateTmpPast = String.valueOf(System.Date.today().addDays(-1));
        jsonStringPast = '{' +
            '"AccountCrmId" : "' + bAccount.Id + '",' +
            '"AccountId" : "' + bAccount.Zuora__External_Id__c + '",' +
            '"AccountBillCycleDay" : "' + accountBillCycleDayTmp + '",' +
            '"SubscriptionTermEndDate" : "' + subscriptionTermEndDateTmpPast + '",' +
            '"DefaultPaymentMethodType" : "CreditCard",' +
            '"SubscriptionName" : "Zuora__Subscription__c"' +
        '}';
        req.requestBody = Blob.valueof(jsonStringPast);
        System.assertEquals('Success', CancelEmail.cancelSubscriptionPost());

        oAccount.Account_Status__c = 'Paused';
        update oAccount;




        //Added as part of PD-14237
        /* Invocation of Immediate cancellation with subscriptionTermEndDate in the past */
        subscriptionTermEndDateTmpPast = String.valueOf(System.Date.today().addDays(-1));
        jsonStringPast = '{' +
            '"AccountCrmId" : "' + bAccount.Id + '",' +
            '"AccountId" : "' + bAccount.Zuora__External_Id__c + '",' +
            '"AccountBillCycleDay" : "' + accountBillCycleDayTmp + '",' +
            '"SubscriptionTermEndDate" : "' + subscriptionTermEndDateTmpPast + '",' +
            '"DefaultPaymentMethodType" : "CreditCard",' +
            '"SubscriptionName" : ""' +
        '}';
        req.requestBody = Blob.valueof(jsonStringPast);
        System.assertEquals('Success', CancelEmail.cancelSubscriptionPost());

        /* Invocation of Immediate cancellation with subscriptionTermEndDate in the past */
        subscriptionTermEndDateTmpPast = String.valueOf(System.Date.today().addDays(-1));
        jsonStringPast = '{' +
            '"AccountCrmId" : "' + bAccount.Id + '",' +
            '"AccountId" : "' + bAccount.Zuora__External_Id__c + '",' +
            '"AccountBillCycleDay" : "' + accountBillCycleDayTmp + '",' +
            '"SubscriptionTermEndDate" : "' + subscriptionTermEndDateTmpPast + '",' +
            '"DefaultPaymentMethodType" : "CreditCard",' +
            '"SubscriptionName" : "Test"' +
        '}';
        req.requestBody = Blob.valueof(jsonStringPast);
        System.assertEquals('Success', CancelEmail.cancelSubscriptionPost());





        /* Invocation of Immediate cancellation with subscriptionTermEndDate in the past */
        subscriptionTermEndDateTmpPast = String.valueOf(System.Date.today().addDays(-1));
        jsonStringPast = '{' +
            '"AccountCrmId" : "' + bAccount.Id + '",' +
            '"AccountId" : "' + bAccount.Zuora__External_Id__c + '",' +
            '"AccountBillCycleDay" : "' + accountBillCycleDayTmp + '",' +
            '"SubscriptionTermEndDate" : "' + subscriptionTermEndDateTmpPast + '",' +
            '"DefaultPaymentMethodType" : "CreditCard",' +
            '"SubscriptionName" : "Zuora__Subscription__c"' +
        '}';
        req.requestBody = Blob.valueof(jsonStringPast);

        System.assertEquals('Success', CancelEmail.cancelSubscriptionPost());

        /* Invocation of cancellation with empty accountBillCycleDay */
        String jsonWithEmptyValue = '{' +
            '"AccountCrmId" : "' + bAccount.Id + '",' +
            '"AccountId" : "' + bAccount.Zuora__External_Id__c + '",' +
            '"AccountBillCycleDay" : "",' +
            '"SubscriptionTermEndDate" : "' + subscriptionTermEndDateTmpPast + '",' +
            '"DefaultPaymentMethodType" : "CreditCard",' +
            '"SubscriptionName" : "Zuora__Subscription__c"' +
        '}';
        req.requestBody = Blob.valueof(jsonWithEmptyValue);
        System.assertEquals('Failure', CancelEmail.cancelSubscriptionPost());

        /* Invocation of cancellation when org has no account with received accountId */
        bAccount.Zuora__External_Id__c = NULL;
        update bAccount;
        jsonWithEmptyValue = '{' +
            '"AccountCrmId" : "' + bAccount.Id + '",' +
            '"AccountId" : "' + bAccount.Zuora__External_Id__c + '",' +
            '"AccountBillCycleDay" : "' + accountBillCycleDayTmp + '",' +
            '"SubscriptionTermEndDate" : "' + subscriptionTermEndDateTmpPast + '",' +
            '"DefaultPaymentMethodType" : "CreditCard",' +
            '"SubscriptionName" : "Zuora__Subscription__c"' +
        '}';
        req.requestBody = Blob.valueof(jsonWithEmptyValue);
        System.assertEquals('Failure', CancelEmail.cancelSubscriptionPost());

        /* Invocation with bad JSON */
        String brokenJsonString = '{"AccountCrmId BROKEN JSON - test Failure}';
        req.requestBody = Blob.valueof(brokenJsonString);
        System.assertEquals('Failure', CancelEmail.cancelSubscriptionPost());

        Test.StopTest();
    }

    class CancelHttpMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            String endpoint = req.getEndpoint();
            System.debug('endpoint: ' + endpoint);
            HttpResponse res = new HttpResponse();
            RestResponse resp = RestContext.response;
            String respBody = '{}';
            res.setBody(respBody);
            res.setStatusCode(200);
            return res;
        }
    }

    static testMethod void testAddDiscount() {
        List<DAZNConfiguration__c> lstConfig = new List<DAZNConfiguration__c>();    
        lstConfig.add(new DAZNConfiguration__c(Name = 'ZuoraAddDiscountUrl', Value__c= 'https://workflow.apps.zuora.com/workflows/9/callout.json'));
        lstConfig.add(new DAZNConfiguration__c(Name = 'Livesport Rateplan 1m Discount', Value__c= '2c92c0f85879e9dd01588c4ee178750b'));
        lstConfig.add(new DAZNConfiguration__c(Name = 'Livesport Rateplan 2m Discount', Value__c= '2c92c0f85a6b1352015a94e2f1985611'));
        lstConfig.add(new DAZNConfiguration__c(Name = 'Livesport Rateplan 3m Discount', Value__c= '2c92c0f9587b0ad001588c4d8f7c55be'));
        lstConfig.add(new DAZNConfiguration__c(Name = 'ZuoraAddDiscountUsername', Value__c= 'lucinda.marshall@zuora.com'));
        lstConfig.add(new DAZNConfiguration__c(Name = 'ZuoraAddDiscountPassword', Value__c= 'e5a8475597c4cfe3e6be46ef3d674b8b'));
        insert lstConfig;

        DAZN_Country_Currency_ISO_Code__c isoUSD = new DAZN_Country_Currency_ISO_Code__c();
        isoUSD.name = 'USD';
        isoUSD.CurrencySymbol__c = '$';
        insert isoUSD;

        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail321@email.com', 'testusername321@email.com', 'tst321','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');    
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 10.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 10.00);

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

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new AddDiscountHttpMock());

        AddDiscountController controller = new AddDiscountController(new ApexPages.StandardController(oAccount));
        controller.selectedMonth = '2';
        controller.submit();
        System.assertEquals(false, controller.isErrorMode);

        Test.setMock(HttpCalloutMock.class, new AddDiscountHttpMock('false'));
        controller.submit();
        System.assertEquals(true, controller.isErrorMode);

        Test.setMock(HttpCalloutMock.class, new AddDiscountHttpMock('bad json'));
        controller.submit();
        System.assertEquals(true, controller.isErrorMode);

        controller.selectedMonth = null;
        controller.submit();
        System.assertEquals(true, controller.isErrorMode);

        delete zSubsr;
        AddDiscountController controller2 = new AddDiscountController(new ApexPages.StandardController(oAccount));
        System.assertEquals(true, controller2.isErrorMode);

        Test.StopTest();
    }

    public class AddDiscountHttpMock implements HttpCalloutMock {
        private String isSuccess;
        public AddDiscountHttpMock() {
            this.isSuccess = 'true';
        }
        public AddDiscountHttpMock(String isSuccess) {
            this.isSuccess = isSuccess;
        }
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('{"success":' + isSuccess + ',"Msg":"Workflow enqueued. Run name WF-9-00000001"}'); old JSON format
            if (isSuccess == 'true') {
                String successJSON = '{' +
                    '"id":163,' +
                    '"name":"WF-9-00000018",' +
                    '"originalWorkflowId":9,' +
                    '"type":' +
                    '"Workflow::Instance","tasks":{"total":1,"queued":1,"processing":0,"pending":0,"stopped":0,"success":0,"error":0},' +
                    '"runTime":null,' +
                    '"cpuTime":"00:00:00",' +
                    '"createdAt":"2017-03-29 06:22:45 UTC",' +
                    '"updatedAt":"2017-03-29 06:22:45 UTC"' +
                '}';
                res.setBody(successJSON);
            } else {
                String errorJSON = '{' +
                  '"errors": [' +
                    '{' +
                      '"status": 406,' +
                      '"code": "invalid",' +
                      '"title": "Required field for Workflow-SubscriptionName does not have a set value. Ensure parameter \'SubscriptionName\' is present."' +
                    '}' +
                  '],' +
                  '"parameters": {' +
                    '"PreviousBCD": 22,' +
                    '"workflow": {}' +
                  '}' +
                '}';
                res.setBody(errorJSON);
            }
            res.setStatusCode(200);
            return res;
        }
    }

}