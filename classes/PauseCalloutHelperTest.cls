@isTest
private class PauseCalloutHelperTest {
	
    @testSetup
    public static void setUpTestData() {
        List<DAZN_Country_Currency_ISO_Code__c> currencyCodes = new List<DAZN_Country_Currency_ISO_Code__c>();
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'CAD',
            CurrencySymbol__c = '$'
        ));
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'CHF',
            CurrencySymbol__c = 'CHF'
        ));
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'CNY',
            CurrencySymbol__c = '元'
        ));
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'EUR',
            CurrencySymbol__c = '€'
        ));
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'GBP',
            CurrencySymbol__c = '£'
        ));
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'JPY',
            CurrencySymbol__c = '¥'
        ));
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'KRW',
            CurrencySymbol__c = '₩'
        ));
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'USD',
            CurrencySymbol__c = '$'
        ));
        insert currencyCodes;

        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'te@test.com', 'Active Paid');
    }

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
            Value__c = 't1'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPausePassword',
            Value__c = 't2'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelSubscSchInFuture',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/87/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelSubscSchInFuture43',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/86/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelUserName',
            Value__c = 't3'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelSubPass',
            Value__c = 't4'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraStandardCancelUrl',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/552/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraReactivationUrl',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/554/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraImmediateCancelUrl',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/554/run'
        ));
        insert config;
    }

    @isTest
    static void testConstructor() {
        Test.startTest();
        PauseCalloutHelper pauseCalloutHelper = new PauseCalloutHelper();
        System.assertNotEquals(null, pauseCalloutHelper);
        Test.stopTest();
    }

    @isTest static void testPerformZuoraCallout() {
        insertZuoraIntegrationParameters();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        HttpResponse response = PauseCalloutHelper.performZuoraCallout('endpointUrl', 'POST', 'application/json', 'auth', 'body');
        System.assertNotEquals(null, response);
        Test.stopTest();
    }

    @isTest static void testSetPauseBody() {
    	Test.startTest();
        PauseCalloutHelper.SetPauseBody cls = new PauseCalloutHelper.SetPauseBody('q', 'w', 'e', 'r');
        System.assertNotEquals(null, cls);
        Test.stopTest();
    }

    @isTest static void testEditPauseScheduledBody() {
        Test.startTest();
        PauseCalloutHelper.EditPauseScheduledBody cls = new PauseCalloutHelper.EditPauseScheduledBody('q', 'w', 'e', 'r');
        System.assertNotEquals(null, cls);
        Test.stopTest();
    }

    @isTest static void testEditPausePausedBody() {
        Test.startTest();
        PauseCalloutHelper.EditPausePausedBody cls = new PauseCalloutHelper.EditPausePausedBody('q', 'w', 'e');
        System.assertNotEquals(null, cls);
        Test.stopTest();
    }

    @isTest static void testSetPauseBodyCancelSubscription() {
    	Test.startTest();
        PauseCalloutHelper.SetPauseBodyCancelSubscription cls = new PauseCalloutHelper.SetPauseBodyCancelSubscription('q', 1, DateTime.now().format('yyyy-MM-dd'), 'test');
        System.assertNotEquals(null, cls);
        Test.stopTest();
    }
    
    @isTest static void testSetPauseSuccessResponse() {
    	Test.startTest();
        PauseCalloutHelper.SetPauseSuccessResponse cls = new PauseCalloutHelper.SetPauseSuccessResponse();
        System.assertNotEquals(null, cls);
        Test.stopTest();
    }
    
    @isTest static void testSetPauseSuccessResponseTasks() {
    	Test.startTest();
        PauseCalloutHelper.SetPauseSuccessResponseTasks cls = new PauseCalloutHelper.SetPauseSuccessResponseTasks();
        System.assertNotEquals(null, cls);
        Test.stopTest();
    }
    
    @isTest static void testSetPauseFailureResponse() {
    	Test.startTest();
        PauseCalloutHelper.SetPauseFailureResponse cls = new PauseCalloutHelper.SetPauseFailureResponse();
        System.assertNotEquals(null, cls);
        Test.stopTest();
    }
    
    @isTest static void testSetPauseFailureResponseError() {
    	Test.startTest();
        PauseCalloutHelper.SetPauseFailureResponseError cls = new PauseCalloutHelper.SetPauseFailureResponseError();
        System.assertNotEquals(null, cls);
        Test.stopTest();
    }

    @isTest static void testInitPauseCalloutScheduledFutureSuccess() {
        insertZuoraIntegrationParameters();
        Account oAccount = [Select Id, Previous_BCD__c From Account];
        oAccount.Previous_BCD__c = 10.0;
        update oAccount;

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        Zuora__ZInvoice__c oInv = SetUpTestData.createZuoraInvoice(oAccount.Id, oCustAccount.Id, 0.00);
        Zuora__Payment__c oPay = SetUpTestData.createZuoraPayment(oAccount.Id, oCustAccount.Id, oInv.Id, 0.00);

        oAccount = [Select Id, Previous_BCD__c, (Select Id, Zuora__External_Id__c From Zuora__Subscriptions__r) From Account];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        Map<String, String> res = PauseCalloutHelper.initPauseCalloutScheduledFuture(oAccount, false);
        System.assertNotEquals(null, res);
        System.assertEquals('true', res.get('success'));
        Test.stopTest();
    }
    
    @isTest static void testInitPauseCalloutScheduledFutureSuccessImmediate() {
        insertZuoraIntegrationParameters();
        Account oAccount = [Select Id, Previous_BCD__c From Account];
        oAccount.Previous_BCD__c = 10.0;
        update oAccount;

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        Zuora__ZInvoice__c oInv = SetUpTestData.createZuoraInvoice(oAccount.Id, oCustAccount.Id, 0.00);
        Zuora__Payment__c oPay = SetUpTestData.createZuoraPayment(oAccount.Id, oCustAccount.Id, oInv.Id, 0.00);

        oAccount = [Select Id, Previous_BCD__c, (Select Id, Zuora__External_Id__c From Zuora__Subscriptions__r) From Account];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        Map<String, String> res = PauseCalloutHelper.initPauseCalloutScheduledFuture(oAccount, true);
        System.assertNotEquals(null, res);
        System.assertEquals('true', res.get('success'));
        Test.stopTest();
    }
    
    @isTest static void testInitPauseCalloutScheduledFutureFailure() {
        insertZuoraIntegrationParameters();
        Account oAccount = [Select Id, Previous_BCD__c From Account];
        oAccount.Previous_BCD__c = 10.0;
        update oAccount;

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        Zuora__ZInvoice__c oInv = SetUpTestData.createZuoraInvoice(oAccount.Id, oCustAccount.Id, 0.00);
        Zuora__Payment__c oPay = SetUpTestData.createZuoraPayment(oAccount.Id, oCustAccount.Id, oInv.Id, 0.00);

        oAccount = [Select Id, Previous_BCD__c, (Select Id, Zuora__External_Id__c From Zuora__Subscriptions__r) From Account];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseFailureResponse());
        Map<String, String> res = PauseCalloutHelper.initPauseCalloutScheduledFuture(oAccount, false);
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testInitPauseCalloutScheduledFutureException() {
        insertZuoraIntegrationParameters();
        Account oAccount = [Select Id, Previous_BCD__c From Account];
        oAccount.Previous_BCD__c = 10.0;
        update oAccount;

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        Zuora__ZInvoice__c oInv = SetUpTestData.createZuoraInvoice(oAccount.Id, oCustAccount.Id, 0.00);
        Zuora__Payment__c oPay = SetUpTestData.createZuoraPayment(oAccount.Id, oCustAccount.Id, oInv.Id, 0.00);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseFailureResponse());
        Map<String, String> res = PauseCalloutHelper.initPauseCalloutScheduledFuture(oAccount, false);
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testInitPauseCalloutScheduledFutureFailureOther() {
        insertZuoraIntegrationParameters();
        Account oAccount = [Select Id, Previous_BCD__c From Account];
        oAccount.Previous_BCD__c = 10.0;
        update oAccount;

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        Zuora__ZInvoice__c oInv = SetUpTestData.createZuoraInvoice(oAccount.Id, oCustAccount.Id, 0.00);
        Zuora__Payment__c oPay = SetUpTestData.createZuoraPayment(oAccount.Id, oCustAccount.Id, oInv.Id, 0.00);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseOtherFailureResponse());
        Map<String, String> res = PauseCalloutHelper.initPauseCalloutScheduledFuture(oAccount, false);
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testInitPauseCalloutScheduledFutureWithoutParams() {
        Account oAccount = [Select Id, Previous_BCD__c From Account];

        Test.startTest();
        Map<String, String> res = PauseCalloutHelper.initPauseCalloutScheduledFuture(oAccount, false);
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testInitPauseCalloutFailure() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseFailureResponse());
        Map<String, String> res = PauseCalloutHelper.initPauseCallout(oSubscription.Name, '2017-03-25', '2017-03-24', '25');
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testInitPauseCalloutFailureOther() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseOtherFailureResponse());
        Map<String, String> res = PauseCalloutHelper.initPauseCallout(oSubscription.Name, '2017-03-25', '2017-03-24', '25');
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testInitPauseCalloutSuccess() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        Map<String, String> res = PauseCalloutHelper.initPauseCallout(oSubscription.Name, '2017-03-25', '2017-03-24', '25');
        System.assertNotEquals(null, res);
        System.assertEquals('true', res.get('success'));
        Test.stopTest();
    }
    
    @isTest static void testInitPauseCalloutException() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Map<String, String> res = PauseCalloutHelper.initPauseCallout(oSubscription.Name, '2017-03-25', '2017-03-24', '25');
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testInitPauseCalloutWithoutSettings() {
        Test.startTest();
        Map<String, String> result = PauseCalloutHelper.initPauseCallout('subscriptionName', 'resumeDate', 'suspendDate', 'bcd');
        Test.stopTest();
        System.assertEquals('false', result.get('success'));
    }

    @isTest static void testAmendPauseCalloutFailure() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseFailureResponse());
        Map<String, String> res = PauseCalloutHelper.amendPauseCallout(oSubscription.Name, '2017-03-25', '25');
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testAmendPauseCalloutFailureOther() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseOtherFailureResponse());
        Map<String, String> res = PauseCalloutHelper.amendPauseCallout(oSubscription.Name, '2017-03-25', '25');
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testAmendPauseCalloutSuccess() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        Map<String, String> res = PauseCalloutHelper.amendPauseCallout(oSubscription.Name, '3017-03-25', '25');
        System.assertNotEquals(null, res);
        System.assertEquals('true', res.get('success'));
        Test.stopTest();
    }
    
    @isTest static void testAmendPauseCalloutException() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Map<String, String> res = PauseCalloutHelper.amendPauseCallout(oSubscription.Name, '3017-03-25', '25');
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testAmendPauseCalloutWithoutSettings() {
        Test.startTest();
        Map<String, String> result = PauseCalloutHelper.amendPauseCallout('subscriptionName', 'resumeDate', 'bcd');
        Test.stopTest();
        System.assertEquals('false', result.get('success'));
    }

    @isTest static void testAmendFuturePauseCalloutSettings() {
        Test.startTest();
        Map<String, String> result = PauseCalloutHelper.amendFuturePauseCallout('subscriptionName', 'resumeDate', 'bcd');
        Test.stopTest();
        System.assertEquals('false', result.get('success'));
    }

    @isTest static void testAmendFuturePauseCalloutFailure() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseFailureResponse());
        Map<String, String> res = PauseCalloutHelper.amendFuturePauseCallout(oSubscription.Name, '2017-03-25', '25');
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testAmendFuturePauseCalloutFailureOther() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseOtherFailureResponse());
        Map<String, String> res = PauseCalloutHelper.amendFuturePauseCallout(oSubscription.Name, '2017-03-25', '25');
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testAmendFuturePauseCalloutSuccess() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        Map<String, String> res = PauseCalloutHelper.amendFuturePauseCallout(oSubscription.Name, '3017-03-25', '25');
        System.assertNotEquals(null, res);
        System.assertEquals('true', res.get('success'));
        Test.stopTest();
    }
    
    @isTest static void testAmendFuturePauseCalloutException() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Map<String, String> res = PauseCalloutHelper.amendFuturePauseCallout(oSubscription.Name, '3017-03-25', '25');
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testCancelPauseCalloutFailure() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseFailureResponse());
        Map<String, String> res = PauseCalloutHelper.cancelPauseCallout(oSubscription.Name, '25');
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testCancelPauseCalloutFailureOther() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseOtherFailureResponse());
        Map<String, String> res = PauseCalloutHelper.cancelPauseCallout(oSubscription.Name, '25');
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testCancelPauseCalloutSuccess() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        Map<String, String> res = PauseCalloutHelper.cancelPauseCallout(oSubscription.Name, '25');
        System.assertNotEquals(null, res);
        System.assertEquals('true', res.get('success'));
        Test.stopTest();
    }

    @isTest static void testCancelPauseCalloutWithoutSettings() {
        Test.startTest();
        Map<String, String> result = PauseCalloutHelper.cancelPauseCallout('subscriptionName', 'previousBCD');
        Test.stopTest();
        System.assertEquals('false', result.get('success'));
    }

    @isTest
    static void testProcessSuccessFutureInitPause() {
        Account oAccount = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Test Zuora', 'Active', Date.today(), Date.today() + 30);
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername2@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);
        User oUser = [Select Id, ContactId, AccountId, Country From User Where Id = :cUser.Id];

        Test.startTest();
        Date dSuspendDate = Date.today() + 1;
        Date dResumeDate = Date.today() + 11;
        DateTime dtResumeDate = dResumeDate;
        DateTime dtSuspendDate = dSuspendDate;
        String formattedResumeDate = dtResumeDate.format('yyyy-mm-dd');
        String formattedSuspendDate = dtSuspendDate.format('yyyy-mm-dd');
        
        PageReference pr;
        pr = PauseCalloutHelper.pauseFlowProcessSuccess('initiate', oUser, oAccount, dResumeDate, dSuspendDate, '111', 10.0, false);

        PageReference pr1;
        pr1 = PauseCalloutHelper.pauseFlowProcessSuccess('initiate', oUser, oAccount, dResumeDate, dSuspendDate, '111', 10.0, false, 'DE', 'en');
        Test.stopTest();

        //List<Zuora__Subscription__c> sub = [Select Id, Zuora__NextChargeDate__c From Zuora__Subscription__c Where Zuora__Account__c = :oAccount.Id AND Zuora__Status__c = 'Active' LIMIT 1];
        //System.assertEquals(dResumeDate, sub[0].Zuora__NextChargeDate__c);

        System.assertNotEquals(null, pr);
        System.assertNotEquals(null, pr1);

        List<Account> acc = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, Notification_Country_Code__c, All_Email_Preferences__c, Is_Double_OptIn__c From Account Where Id = :oAccount.Id LIMIT 1];
        System.assertEquals(dSuspendDate, acc[0].Pause_From__c);
        System.assertEquals(dResumeDate, acc[0].Pause_Until__c);
        System.assertNotEquals('Paused', acc[0].Account_Status__c);
        System.assertEquals(10, acc[0].Previous_BCD__c);
        //changed for PD-13022
        System.assertEquals(true, acc[0].Submitted_for_cancellation__c);

        List<Pause_History__c> ph = [Select Id, Workflow_Id__c From Pause_History__c];
        System.assertEquals(2, ph.size());
        System.assertEquals('111', ph[0].Workflow_Id__c);
    }

    @isTest
    static void testProcessSuccessCurrentInitPause() {
        Account oAccount = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername3@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true, 'Japan');
        oAccount.All_Email_Preferences__c = false;
        update oAccount;
        oAccount = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        PageReference pr, pr1;
        Date dSuspendDate;
        Date dResumeDate;
        Test.startTest();
        System.runAs(cUser) {
            dSuspendDate = Date.today();
            dResumeDate = Date.today() + 10;
            DateTime dtResumeDate = dResumeDate;
            DateTime dtSuspendDate = dSuspendDate;
            String formattedResumeDate = dtResumeDate.format('yyyy-mm-dd');
            String formattedSuspendDate = dtSuspendDate.format('yyyy-mm-dd');

            pr = PauseCalloutHelper.pauseFlowProcessSuccess('initiate', cUser, oAccount, dResumeDate, dSuspendDate, '111', 10.0, false);

            pr1 = PauseCalloutHelper.pauseFlowProcessSuccess('initiate', cUser, oAccount, dResumeDate, dSuspendDate, '111', 10.0, false, 'DE', 'en');
        }
        Test.stopTest();

        System.assertNotEquals(null, pr);
        System.assertNotEquals(null, pr1);

        List<Account> acc = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, Notification_Country_Code__c, All_Email_Preferences__c, Is_Double_OptIn__c From Account Where Id = :oAccount.Id LIMIT 1];
        System.assertEquals(dSuspendDate, acc[0].Pause_From__c);
        System.assertEquals(dResumeDate, acc[0].Pause_Until__c);
        System.assertEquals('Paused', acc[0].Account_Status__c);
        System.assertEquals(10, acc[0].Previous_BCD__c);
        //changed for PD-13022
        System.assertEquals(true, acc[0].Submitted_for_cancellation__c);

        List<Pause_History__c> ph = [Select Id, Workflow_Id__c From Pause_History__c];
        System.assertEquals(2, ph.size());
        System.assertEquals('111', ph[0].Workflow_Id__c);
    }

    @isTest
    static void testProcessSuccessAmendPauseScheduled() {
        Account oAccount = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername4@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);
        User oUser = [Select Id, ContactId, AccountId, Country From User Where Id = :cUser.Id];

        Date dResumeDate = Date.today() + 11;
        Date dSuspendDate = Date.today() + 1;
        DateTime dtResumeDate = dResumeDate;
        DateTime dtSuspendDate = dSuspendDate;
        String formattedResumeDate = dtResumeDate.format('yyyy-mm-dd');
        String formattedSuspendDate = dtSuspendDate.format('yyyy-mm-dd');

        oAccount.Pause_From__c = dSuspendDate;
        oAccount.Pause_Until__c = dResumeDate + 5;
        oAccount.Account_Status__c = 'Active Paid';
        update oAccount;
        oAccount = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Test.startTest();
        PageReference pr, pr1;
        pr = PauseCalloutHelper.pauseFlowProcessSuccess('amend', oUser, oAccount, dResumeDate, dSuspendDate, '111', 10.0, false);
        pr1 = PauseCalloutHelper.pauseFlowProcessSuccess('amend', oUser, oAccount, dResumeDate, dSuspendDate, '111', 10.0, false, 'DE', 'en');
        Test.stopTest();

        System.assertNotEquals(null, pr);
        System.assertNotEquals(null, pr1);

        List<Account> acc = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, Notification_Country_Code__c, All_Email_Preferences__c, Is_Double_OptIn__c From Account Where Id = :oAccount.Id LIMIT 1];
        System.assertEquals(dSuspendDate, acc[0].Pause_From__c);
        System.assertEquals(dResumeDate, acc[0].Pause_Until__c);
        System.assertEquals('Active Paid', acc[0].Account_Status__c);
        System.assertEquals(10, acc[0].Previous_BCD__c);
        //changed for PD-13022
        System.assertEquals(true, acc[0].Submitted_for_cancellation__c);

        List<Pause_History__c> ph = [Select Id, Workflow_Id__c From Pause_History__c];
        System.assertEquals(2, ph.size());
        System.assertEquals('111', ph[0].Workflow_Id__c);
    }

    @isTest static void testProcessSuccessAmendPausePaused() {
        Account oAccount = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername5@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);
        
        Date dResumeDate = Date.today() + 11;
        Date dSuspendDate = Date.today();
        DateTime dtResumeDate = dResumeDate;
        DateTime dtSuspendDate = dSuspendDate;
        String formattedResumeDate = dtResumeDate.format('yyyy-mm-dd');
        String formattedSuspendDate = dtSuspendDate.format('yyyy-mm-dd');

        oAccount.Pause_From__c = dSuspendDate;
        oAccount.Pause_Until__c = dResumeDate + 5;
        oAccount.Account_Status__c = 'Paused';
        update oAccount;
        oAccount = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Test.startTest();
        PageReference pr, pr1;
        pr = PauseCalloutHelper.pauseFlowProcessSuccess('amend', cUser, oAccount, dResumeDate, dSuspendDate, '111', 10.0, false);
        pr1 = PauseCalloutHelper.pauseFlowProcessSuccess('amend', cUser, oAccount, dResumeDate, dSuspendDate, '111', 10.0, false, 'DE', 'en');
        Test.stopTest();

        System.assertNotEquals(null, pr);
        System.assertNotEquals(null, pr1);

        List<Account> acc = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, Notification_Country_Code__c, All_Email_Preferences__c, Is_Double_OptIn__c From Account Where Id = :oAccount.Id LIMIT 1];
        System.assertEquals(dSuspendDate, acc[0].Pause_From__c);
        System.assertEquals(dResumeDate, acc[0].Pause_Until__c);
        System.assertEquals('Paused', acc[0].Account_Status__c);
        System.assertEquals(10, acc[0].Previous_BCD__c);
        //changed for PD-13022
        System.assertEquals(true, acc[0].Submitted_for_cancellation__c);

        List<Pause_History__c> ph = [Select Id, Workflow_Id__c From Pause_History__c];
        System.assertEquals(2, ph.size());
        System.assertEquals('111', ph[0].Workflow_Id__c);
    }

    @isTest static void testProcessSuccessCancelPauseScheduled() {
        Account oAccount = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername6@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);
        
        Date dResumeDate = Date.today() + 11;
        Date dSuspendDate = Date.today() + 1;
        DateTime dtResumeDate = dResumeDate;
        DateTime dtSuspendDate = dSuspendDate;
        String formattedResumeDate = dtResumeDate.format('yyyy-mm-dd');
        String formattedSuspendDate = dtSuspendDate.format('yyyy-mm-dd');

        oAccount.Pause_From__c = dSuspendDate;
        oAccount.Pause_Until__c = dResumeDate;
        oAccount.Account_Status__c = 'Active Paid';
        update oAccount;
        oAccount = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Test.startTest();
        PageReference pr, pr1;
        pr = PauseCalloutHelper.pauseFlowProcessSuccess('cancel', cUser, oAccount, dResumeDate, dSuspendDate, '111', 10.0, false);
        pr1 = PauseCalloutHelper.pauseFlowProcessSuccess('cancel', cUser, oAccount, dResumeDate, dSuspendDate, '111', 10.0, false, 'DE', 'en');
        Test.stopTest();

        System.assertNotEquals(null, pr);
        System.assertNotEquals(null, pr1);

        List<Account> acc = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, Notification_Country_Code__c, All_Email_Preferences__c, Is_Double_OptIn__c From Account Where Id = :oAccount.Id LIMIT 1];
        System.assertEquals(null, acc[0].Pause_From__c);
        System.assertEquals(null, acc[0].Pause_Until__c);
        System.assertEquals('Active Paid', acc[0].Account_Status__c);
        System.assertEquals(10, acc[0].Previous_BCD__c);
        System.assertEquals(true, acc[0].Submitted_for_cancellation__c);

        List<Pause_History__c> ph = [Select Id, Workflow_Id__c From Pause_History__c];
        System.assertEquals(2, ph.size());
        System.assertEquals('111', ph[0].Workflow_Id__c);
    }

    @isTest static void testProcessSuccessCancelPausePaused() {
        Account oAccount = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername7@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);
        
        Date dResumeDate = Date.today() + 11;
        Date dSuspendDate = Date.today();
        DateTime dtResumeDate = dResumeDate;
        DateTime dtSuspendDate = dSuspendDate;
        String formattedResumeDate = dtResumeDate.format('yyyy-mm-dd');
        String formattedSuspendDate = dtSuspendDate.format('yyyy-mm-dd');

        oAccount.Pause_From__c = dSuspendDate;
        oAccount.Pause_Until__c = dResumeDate;
        oAccount.Account_Status__c = 'Paused';
        update oAccount;
        oAccount = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Test.startTest();
        PageReference pr, pr1;
        pr = PauseCalloutHelper.pauseFlowProcessSuccess('cancel', cUser, oAccount, dResumeDate, dSuspendDate, '111', 10.0, false);
        pr1 = PauseCalloutHelper.pauseFlowProcessSuccess('cancel', cUser, oAccount, dResumeDate, dSuspendDate, '111', 10.0, false, 'DE', 'en');
        Test.stopTest();

        System.assertNotEquals(null, pr);
        System.assertNotEquals(null, pr1);

        List<Account> acc = [Select Id, Submitted_for_cancellation__c, Previous_BCD__c, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, Notification_Country_Code__c, All_Email_Preferences__c, Is_Double_OptIn__c From Account Where Id = :oAccount.Id LIMIT 1];
        System.assertEquals(dSuspendDate, acc[0].Pause_From__c);
        System.assertEquals(dResumeDate, acc[0].Pause_Until__c);
        System.assertEquals('Paused', acc[0].Account_Status__c);
        System.assertEquals(null, acc[0].Previous_BCD__c);
        //changed for PD-13022
        System.assertEquals(true, acc[0].Submitted_for_cancellation__c);

        List<Pause_History__c> ph = [Select Id, Workflow_Id__c From Pause_History__c];
        System.assertEquals(2, ph.size());
    }

    @isTest
    static void testProcessFailure() {
        Account oAccount = [Select Id, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);
        User oUser = [Select Id, ContactId, AccountId From User Where Id = :cUser.Id];

        Test.startTest();
        Date pauseFrom = Date.today();
        Date pauseUntil = Date.today() + 1;
        DateTime pauseScheduledTime = DateTime.now();
        String accountStatus = 'Paused';

        PageReference pr = PauseCalloutHelper.pauseFlowProcessFailure('initiate', oUser, oAccount, 'test msg');
        Test.stopTest();

        System.assertNotEquals(null, pr);
        PageReference prToCheck = new PageReference('/myaccount');
        System.assertEquals(prToCheck.getUrl(), pr.getUrl());
    }

    @isTest
    static void testProcessFailureInit() {
        Account oAccount = [Select Id, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);
        User oUser = [Select Id, ContactId, AccountId From User Where Id = :cUser.Id];

        Test.startTest();
        Date pauseFrom = Date.today();
        Date pauseUntil = Date.today() + 1;
        DateTime pauseScheduledTime = DateTime.now();
        String accountStatus = 'Paused';

        PageReference pr = PauseCalloutHelper.pauseFlowProcessFailure('initiate', oUser, oAccount, 'test msg');
        Test.stopTest();

        System.assertNotEquals(null, pr);
        PageReference prToCheck = new PageReference('/myaccount');
        System.assertEquals(prToCheck.getUrl(), pr.getUrl());
    }

    @isTest
    static void testProcessFailureAmendFuture() {
        Account oAccount = [Select Id, PauseScheduled__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
        oAccount.Pause_From__c = Date.today() + 1;
        update oAccount;
        oAccount = [Select Id, PauseScheduled__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);
        User oUser = [Select Id, ContactId, AccountId From User Where Id = :cUser.Id];

        Test.startTest();
        Date pauseFrom = Date.today();
        Date pauseUntil = Date.today() + 1;
        DateTime pauseScheduledTime = DateTime.now();
        String accountStatus = 'Paused';

        PageReference pr = PauseCalloutHelper.pauseFlowProcessFailure('amend', oUser, oAccount, 'test msg');
        Test.stopTest();

        System.assertNotEquals(null, pr);
        PageReference prToCheck = new PageReference('/myaccount');
        System.assertEquals(prToCheck.getUrl(), pr.getUrl());
    }

    @isTest
    static void testProcessFailureAmendPaused() {
        Account oAccount = [Select Id, PauseScheduled__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);
        User oUser = [Select Id, ContactId, AccountId From User Where Id = :cUser.Id];

        Test.startTest();
        Date pauseFrom = Date.today();
        Date pauseUntil = Date.today() + 1;
        DateTime pauseScheduledTime = DateTime.now();
        String accountStatus = 'Paused';

        PageReference pr = PauseCalloutHelper.pauseFlowProcessFailure('amend', oUser, oAccount, 'test msg');
        Test.stopTest();

        System.assertNotEquals(null, pr);
        PageReference prToCheck = new PageReference('/myaccount?banner=amendReqFail');
        System.assertEquals(prToCheck.getUrl(), pr.getUrl());
    }

    @isTest
    static void testProcessFailureCancelFuture() {
        Account oAccount = [Select Id, PauseScheduled__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
        oAccount.Pause_From__c = Date.today() + 1;
        update oAccount;
        oAccount = [Select Id, PauseScheduled__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);
        User oUser = [Select Id, ContactId, AccountId From User Where Id = :cUser.Id];

        Test.startTest();
        Date pauseFrom = Date.today();
        Date pauseUntil = Date.today() + 1;
        DateTime pauseScheduledTime = DateTime.now();
        String accountStatus = 'Paused';

        PageReference pr = PauseCalloutHelper.pauseFlowProcessFailure('cancel', oUser, oAccount, 'test msg');
        Test.stopTest();

        System.assertNotEquals(null, pr);
        PageReference prToCheck = new PageReference('/myaccount');
        System.assertEquals(prToCheck.getUrl(), pr.getUrl());
    }
    // tests for PauseCalloutHelper.runStandardCancelZuoraWorkflow() method
    @isTest
    static void testStandardCancelCalloutFailure() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseFailureResponse());
        Map<String, String> res = PauseCalloutHelper.runStandardCancelZuoraWorkflow(oSubscription.Name, DateTime.now().format('yyyy-MM-dd'));
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest
    static void testStandardCancelCalloutFailureOther() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseOtherFailureResponse());
        Map<String, String> res = PauseCalloutHelper.runStandardCancelZuoraWorkflow(oSubscription.Name, DateTime.now().format('yyyy-MM-dd'));
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest
    static void testStandardCancelCalloutSuccess() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        Map<String, String> res = PauseCalloutHelper.runStandardCancelZuoraWorkflow(oSubscription.Name, DateTime.now().format('yyyy-MM-dd'));
        System.assertNotEquals(null, res);
        System.assertEquals('true', res.get('success'));
        Test.stopTest();
    }
    
    @isTest
    static void testStandardCancelCalloutSuccessWithoutCSettings() {
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        Map<String, String> res = PauseCalloutHelper.runStandardCancelZuoraWorkflow(oSubscription.Name, DateTime.now().format('yyyy-MM-dd'));
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }
    // tests for PauseCalloutHelper.runUndoCancellationZuoraWorkflow() method
    @isTest
    static void testReactivationCancelCalloutFailure() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseFailureResponse());
        Map<String, String> res = PauseCalloutHelper.runUndoCancellationZuoraWorkflow(oSubscription.Name);
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest
    static void testReactivationCancelCalloutFailureOther() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseOtherFailureResponse());
        Map<String, String> res = PauseCalloutHelper.runUndoCancellationZuoraWorkflow(oSubscription.Name);
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest
    static void testReactivationCancelCalloutSuccess() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        Map<String, String> res = PauseCalloutHelper.runUndoCancellationZuoraWorkflow(oSubscription.Name);
        System.assertNotEquals(null, res);
        System.assertEquals('true', res.get('success'));
        Test.stopTest();
    }
    
    @isTest
    static void testReactivationCancelCalloutSuccessWithoutCSettings() {
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        Map<String, String> res = PauseCalloutHelper.runUndoCancellationZuoraWorkflow(oSubscription.Name);
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }
    // tests for PauseCalloutHelper.runImmediateCancelZuoraWorkflow() method
    @isTest
    static void testImmediateCancelCalloutFailure() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseFailureResponse());
        Map<String, String> res = PauseCalloutHelper.runImmediateCancelZuoraWorkflow(oSubscription.Name, DateTime.now().format('yyyy-MM-dd'), '2c92c0f85d5964dc015d5f05fa0212e7');
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest
    static void testImmediateCancelCalloutFailureOther() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseOtherFailureResponse());
        Map<String, String> res = PauseCalloutHelper.runImmediateCancelZuoraWorkflow(oSubscription.Name, DateTime.now().format('yyyy-MM-dd'), '2c92c0f85d5964dc015d5f05fa0212e7');
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
        Test.stopTest();
    }

    @isTest
    static void testImmediateCancelCalloutSuccess() {
        insertZuoraIntegrationParameters();
        
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        Map<String, String> res = PauseCalloutHelper.runImmediateCancelZuoraWorkflow(oSubscription.Name, DateTime.now().format('yyyy-MM-dd'), '2c92c0f85d5964dc015d5f05fa0212e7');
        System.assertNotEquals(null, res);
        System.assertEquals('true', res.get('success'));
        Test.stopTest();
    }
    
    @isTest
    static void testImmediateCancelCalloutSuccessWithoutCSettings() {
        Account oAccount = [Select Id, All_Email_Preferences__c, Is_Double_OptIn__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];

        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
        Map<String, String> res = PauseCalloutHelper.runImmediateCancelZuoraWorkflow(oSubscription.Name, DateTime.now().format('yyyy-MM-dd'), '2c92c0f85d5964dc015d5f05fa0212e7');
        System.assertNotEquals(null, res);
        System.assertEquals('false', res.get('success'));
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

    public class MockSetPauseOtherFailureResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{ '+
                '    "errors": [ '+
                '         { '+
                '             "status": 400, '+
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
            res.setStatusCode(400);
            return res;
        }
    }


	
}