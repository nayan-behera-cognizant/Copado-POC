@isTest
private class InvoicePDFPageControllerTest {
    
   @testSetup
    public static void setup() {
        List<DAZNConfiguration__c> config = new List<DAZNConfiguration__c>();
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraEndPointInvoiceURL',
            Value__c = 'https://apisandbox-api.zuora.com/rest/v1/transactions/invoices/accounts/'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraAPIUserId',
            Value__c = 'Librada.CespedosaSantiago@cognizant.com'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraAPIUserPassword',
            Value__c = 'Amarillo12%'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'PaymentHistoryDownloadError',
            Value__c = 'paymenthistory?dowloaderror='
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'InvoicePDFLink',
            Value__c = '/InvoicePDFPage?endpointForDownload='
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'InvoicePDFGettingTimeout',
            Value__c = '3000'
        ));
        insert config;
        
        List<PaymentHistoryDownloadConfiguration__c> configDowload = new List<PaymentHistoryDownloadConfiguration__c>();
        configDowload.add(new PaymentHistoryDownloadConfiguration__c(
            Name = 'DE',
            Country_code__c = 'DE',
            Download_Invoice__c = true
        ));
        configDowload.add(new PaymentHistoryDownloadConfiguration__c(
            Name = 'US',
            Country_code__c = 'US',
            Download_Invoice__c = true
        ));
        configDowload.add(new PaymentHistoryDownloadConfiguration__c(
            Name = 'JP',
            Country_code__c = 'JP',
            Download_Invoice__c = true
        ));
        insert configDowload;
        DAZN_Country_Currency_ISO_Code__c isoUSD = new DAZN_Country_Currency_ISO_Code__c();
        isoUSD.name = 'USD';
        isoUSD.CurrencySymbol__c = '$';
        insert isoUSD;
        SetupTestData.createDAZNConfigurations();

        List<Payment_history_configuration__c> ls = new List<Payment_history_configuration__c>();
        ls.add(new Payment_history_configuration__c(
            Name = 'DE',
            Country_code__c = 'DE',
            Show_free_trial__c = true,
            Subscription_type__c = 'EVERGREEN'
        ));
        ls.add(new Payment_history_configuration__c(
            Name = 'JP',
            Country_code__c = 'JP',
            Show_free_trial__c = true,
            Subscription_type__c = 'EVERGREEN'
        ));
        ls.add(new Payment_history_configuration__c(
            Name = 'CA',
            Country_code__c = 'CA',
            Show_free_trial__c = false,
            Subscription_type__c = 'EVERGREEN'
        ));
        ls.add(new Payment_history_configuration__c(
            Name = 'CH',
            Country_code__c = 'CH',
            Show_free_trial__c = true,
            Subscription_type__c = 'EVERGREEN'
        ));
        ls.add(new Payment_history_configuration__c(
            Name = 'US',
            Country_code__c = 'US',
            Show_free_trial__c = true,
            Subscription_type__c = 'EVERGREEN'
        ));

        insert ls;
    }

    @isTest 
    static void test_method_one() {
        CreateTestDataforUnitTest.triggerSettings();
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        
        System.runAs(oCSUser) {
            
            Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'te@test.com', 'Active Paid');
            User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
            Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');

            Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
            Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
            zInv.Zuora__TaxExemptAmount__c = 100.00 ;
            zInv.Zuora__TaxAmount__c = 200.00 ;
            zInv.Zuora__TotalAmount__c = 5100.00;
            zInv.Name = 'INV00000832';
            update zInv;
            
            Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
            zPay.Zuora__Status__c = 'Processed';
            zPay.Zuora__Effective_Date__c = Date.today();
            zPay.Zuora__PaymentMethod__c = 'Credit Card Visa ************1111';
            update zPay;

            zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
            zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
            update zSubsr;
            
            Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'CreditCard', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
            
            Zuora__PaymentInvoice__c zPaymentInvoice = SetupTestData.createZuoraPaymentInvoice(zPay.Id, zInv.Id);
            zPaymentInvoice.Zuora__RefundAmount__c = 1000;
            update zPaymentInvoice; 
            Zuora__Refund__c oZuoraRefund = new Zuora__Refund__c();
            oZuoraRefund.Zuora__Account__c = oAccount.Id;
            oZuoraRefund.Zuora__BillingAccount__c = bAccount.Id;
            oZuoraRefund.Zuora__Payment__c = zPay.Id;
            oZuoraRefund.Zuora__Amount__c = 1000.00;    
            oZuoraRefund.Zuora__RefundDate__c = Date.today().addDays(-5);
            insert oZuoraRefund;
            system.assertNotEquals(null, oZuoraRefund);
            Zuora__RefundInvoicePayment__c oZuoraRefundInvoicePayment = new Zuora__RefundInvoicePayment__c();
            oZuoraRefundInvoicePayment.Zuora__Refund__c = oZuoraRefund.Id;
            oZuoraRefundInvoicePayment.Zuora__InvoicePayment__c =  zPaymentInvoice.Id;
            oZuoraRefundInvoicePayment.Zuora__RefundAmount__c = 1000.00;    
            insert oZuoraRefundInvoicePayment;    
            system.assertNotEquals(null, oZuoraRefundInvoicePayment);

            Test.startTest();
                User us = [SELECT Id, AccountId FROM User WHERE AccountId = :oAccount.Id];
                Test.setMock(HttpCalloutMock.class, new MockInvoiceSuccessResponse());
                System.runAs(us) {
                    PaymentHistoryController ctrl = new PaymentHistoryController();
                    ctrl.oUser = us;
                    ctrl.loadPdfPage();
                    System.assert(ctrl.showDownloadLink != null);

                }
                
            Test.stopTest();
        }
    }

    @isTest 
    static void testInvoicePDFController() {
        CreateTestDataforUnitTest.triggerSettings();
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        
        System.runAs(oCSUser) {
            
            Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'te@test.com', 'Active Paid');
            User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
            Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');

            Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
            Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
            zInv.Zuora__TaxExemptAmount__c = 100.00 ;
            zInv.Zuora__TaxAmount__c = 200.00 ;
            zInv.Zuora__TotalAmount__c = 5100.00;
            zInv.Name = 'INV00000832';
            update zInv;
            
            Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
            zPay.Zuora__Status__c = 'Processed';
            zPay.Zuora__Effective_Date__c = Date.today();
            zPay.Zuora__PaymentMethod__c = 'Credit Card Visa ************1111';
            update zPay;

            zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
            zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
            update zSubsr;
            
            Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'CreditCard', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
            
            Zuora__PaymentInvoice__c zPaymentInvoice = SetupTestData.createZuoraPaymentInvoice(zPay.Id, zInv.Id);
            zPaymentInvoice.Zuora__RefundAmount__c = 1000;
            update zPaymentInvoice; 
            Zuora__Refund__c oZuoraRefund = SetUpTestData.createZuoraRefund(oAccount.Id,bAccount.Id,'External','Payment Reversal',1000.00);
            oZuoraRefund.Zuora__Payment__c = zPay.Id;  
            oZuoraRefund.Zuora__RefundDate__c = Date.today().addDays(-5);
            update oZuoraRefund;
            system.assertNotEquals(null, oZuoraRefund);

            Zuora__RefundInvoicePayment__c oZuoraRefundInvoicePayment = SetUpTestData.createZuoraRefundInvoicePayment(oZuoraRefund.Id,zPaymentInvoice.Id,1000.00); 
            system.assertNotEquals(null, oZuoraRefundInvoicePayment);

            String endpoint = 'https://apisandbox-api.zuora.com/rest/v1/files/2c92c08c5ca05646015ca09d80d403aa';
            Test.setMock(HttpCalloutMock.class, new MockInvoiceSuccessResponsePDF());
            Test.startTest();
                PageReference pageRef2 = Page.InvoicePDFPage;
                Test.setCurrentPage(pageRef2);
                ApexPages.currentPage().getParameters().put('endpointForDownload',endpoint);

                InvoicePDFPageController invoicePDF = new InvoicePDFPageController();
                invoicePDF.getDoc();
                System.assert(invoicePDF.doc != null);
            Test.stopTest();
        }
    }

    @isTest 
    static void testBadResponse() {
        CreateTestDataforUnitTest.triggerSettings();
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        
        System.runAs(oCSUser) {
            
            Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'te@test.com', 'Active Paid');
            User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
            Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');

            Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
            Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
            zInv.Zuora__TaxExemptAmount__c = 100.00 ;
            zInv.Zuora__TaxAmount__c = 200.00 ;
            zInv.Zuora__TotalAmount__c = 5100.00;
            zInv.Name = 'INV00000832';
            update zInv;
            
            Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
            zPay.Zuora__Status__c = 'Processed';
            zPay.Zuora__Effective_Date__c = Date.today();
            zPay.Zuora__PaymentMethod__c = 'Credit Card Visa ************1111';
            update zPay;

            zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
            zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
            update zSubsr;
            
            Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'CreditCard', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
            
            Zuora__PaymentInvoice__c zPaymentInvoice = SetupTestData.createZuoraPaymentInvoice(zPay.Id, zInv.Id);
            zPaymentInvoice.Zuora__RefundAmount__c = 1000;
            update zPaymentInvoice; 
            Zuora__Refund__c oZuoraRefund = new Zuora__Refund__c();
            oZuoraRefund.Zuora__Account__c = oAccount.Id;
            oZuoraRefund.Zuora__BillingAccount__c = bAccount.Id;
            oZuoraRefund.Zuora__Payment__c = zPay.Id;
            oZuoraRefund.Zuora__Amount__c = 1000.00;    
            oZuoraRefund.Zuora__RefundDate__c = Date.today().addDays(-5);
            insert oZuoraRefund;
            system.assertNotEquals(null, oZuoraRefund);
            Zuora__RefundInvoicePayment__c oZuoraRefundInvoicePayment = new Zuora__RefundInvoicePayment__c();
            oZuoraRefundInvoicePayment.Zuora__Refund__c = oZuoraRefund.Id;
            oZuoraRefundInvoicePayment.Zuora__InvoicePayment__c =  zPaymentInvoice.Id;
            oZuoraRefundInvoicePayment.Zuora__RefundAmount__c = 1000.00;    
            insert oZuoraRefundInvoicePayment;    
            system.assertNotEquals(null, oZuoraRefundInvoicePayment);

            Test.startTest();
                User us = [SELECT Id, AccountId FROM User WHERE AccountId = :oAccount.Id];
                Test.setMock(HttpCalloutMock.class, new MockInvoiceUnSuccessResponse());
                System.runAs(us) {
                    PaymentHistoryController ctrl = new PaymentHistoryController();
                    ctrl.oUser = us;
                    ctrl.loadPdfPage();
                    System.assert(ctrl.showDownloadLink == false);

                }
                
            Test.stopTest();
        }
    }

    @isTest 
    static void testInvoicePDFControllernUnSuccessBody() {
        CreateTestDataforUnitTest.triggerSettings();
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        
        System.runAs(oCSUser) {
            
            Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'te@test.com', 'Active Paid');
            User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
            Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');

            Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
            Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
            zInv.Zuora__TaxExemptAmount__c = 100.00 ;
            zInv.Zuora__TaxAmount__c = 200.00 ;
            zInv.Zuora__TotalAmount__c = 5100.00;
            zInv.Name = 'INV00000832';
            update zInv;
            
            Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
            zPay.Zuora__Status__c = 'Processed';
            zPay.Zuora__Effective_Date__c = Date.today();
            zPay.Zuora__PaymentMethod__c = 'Credit Card Visa ************1111';
            update zPay;

            zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
            zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
            update zSubsr;
            
            Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'CreditCard', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
            
            Zuora__PaymentInvoice__c zPaymentInvoice = SetupTestData.createZuoraPaymentInvoice(zPay.Id, zInv.Id);
            zPaymentInvoice.Zuora__RefundAmount__c = 1000;
            update zPaymentInvoice; 
            Zuora__Refund__c oZuoraRefund = SetUpTestData.createZuoraRefund(oAccount.Id,bAccount.Id,'External','Payment Reversal',1000.00);
            oZuoraRefund.Zuora__Payment__c = zPay.Id;  
            oZuoraRefund.Zuora__RefundDate__c = Date.today().addDays(-5);
            update oZuoraRefund;
            system.assertNotEquals(null, oZuoraRefund);

            Zuora__RefundInvoicePayment__c oZuoraRefundInvoicePayment = SetUpTestData.createZuoraRefundInvoicePayment(oZuoraRefund.Id,zPaymentInvoice.Id,1000.00); 
            system.assertNotEquals(null, oZuoraRefundInvoicePayment);

            String endpoint = 'https://apisandbox-api.zuora.com/rest/v1/files/2c92c08c5ca05646015ca09d80d403aa';
            Test.setMock(HttpCalloutMock.class, new MockInvoiceUnSuccessResponseBody());
            Test.startTest();
                PageReference pageRef2 = Page.InvoicePDFPage;
                Test.setCurrentPage(pageRef2);
                ApexPages.currentPage().getParameters().put('endpointForDownload',endpoint);

                InvoicePDFPageController invoicePDF = new InvoicePDFPageController();
                invoicePDF.getDoc();
                System.assert(invoicePDF.doc == null);
            Test.stopTest();
        }
    }

    @isTest 
    static void testInvoicePDFControllernUnSuccessStatus() {
        CreateTestDataforUnitTest.triggerSettings();
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        
        System.runAs(oCSUser) {
            
            Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'te@test.com', 'Active Paid');
            User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
            Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');

            Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
            Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
            zInv.Zuora__TaxExemptAmount__c = 100.00 ;
            zInv.Zuora__TaxAmount__c = 200.00 ;
            zInv.Zuora__TotalAmount__c = 5100.00;
            zInv.Name = 'INV00000832';
            update zInv;
            
            Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
            zPay.Zuora__Status__c = 'Processed';
            zPay.Zuora__Effective_Date__c = Date.today();
            zPay.Zuora__PaymentMethod__c = 'Credit Card Visa ************1111';
            update zPay;

            zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
            zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
            update zSubsr;
            
            Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'CreditCard', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
            
            Zuora__PaymentInvoice__c zPaymentInvoice = SetupTestData.createZuoraPaymentInvoice(zPay.Id, zInv.Id);
            zPaymentInvoice.Zuora__RefundAmount__c = 1000;
            update zPaymentInvoice; 
            Zuora__Refund__c oZuoraRefund = SetUpTestData.createZuoraRefund(oAccount.Id,bAccount.Id,'External','Payment Reversal',1000.00);
            oZuoraRefund.Zuora__Payment__c = zPay.Id;  
            oZuoraRefund.Zuora__RefundDate__c = Date.today().addDays(-5);
            update oZuoraRefund;
            system.assertNotEquals(null, oZuoraRefund);

            Zuora__RefundInvoicePayment__c oZuoraRefundInvoicePayment = SetUpTestData.createZuoraRefundInvoicePayment(oZuoraRefund.Id,zPaymentInvoice.Id,1000.00); 
            system.assertNotEquals(null, oZuoraRefundInvoicePayment);

            String endpoint = 'https://apisandbox-api.zuora.com/rest/v1/files/2c92c08c5ca05646015ca09d80d403aa';
            Test.setMock(HttpCalloutMock.class, new MockInvoiceUnSuccessResponseStatus());
            Test.startTest();
                PageReference pageRef2 = Page.InvoicePDFPage;
                Test.setCurrentPage(pageRef2);
                ApexPages.currentPage().getParameters().put('endpointForDownload',endpoint);

                InvoicePDFPageController invoicePDF = new InvoicePDFPageController();
                invoicePDF.getDoc();
                System.assert(invoicePDF.doc == null);
            Test.stopTest();
        }
    }
    
    public class MockInvoiceUnSuccessResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{    "invoices": [ "account": "testPDF SK", "invoiceDate": "2017-06-13", "invoiceNumber": "INV00000832", "body": "https://apisandbox-api.zuoraa", "invoiceItems": [                {                    "id": "2c92c0f85ca0567b015ca09d7bdc11f9",                    "subscriptionName": "A-S00000666",                    "subscriptionId": "2c92c0f85ca0567b015ca09d7b4711ea"}            ],            "invoiceFiles": [                {                    "id": "2c92c08c5ca05646015ca09d80d703ac",                    "versionNumber": 1497343295547,                    "pdfFileUrl": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08c5ca05646015ca09d80d403aa"                }            ]        },        {            "id": "2c92c0f85ca0567a015ca099da0c0809",            "accountId": "2c92c0f95ca064e6015ca0992a534dd5",            "accountNumber": "A00000696",            "accountName": "testPDF SK",            "invoiceDate": "2017-06-13",            "invoiceNumber": "INV00000831",            "body": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08b5ca0648a015ca09ab7f10383",            "invoiceItems": [                {                    "id": "2c92c0f85ca0567a015ca099da10080b", "subscriptionName": "A-S00000665", "subscriptionId": "2c92c0f85ca0567a015ca099d91e07f5" },  {  "id": "2c92c0f85ca0567a015ca099da10080c", "subscriptionName": "A-S00000665",  "subscriptionId": "2c92c0f85ca0567a015ca099d91e07f5"}            ],            "invoiceFiles": [                {                    "id": "2c92c08b5ca0648a015ca09ab7f50385",                    "versionNumber": 1497343113001,                    "pdfFileUrl": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08b5ca0648a015ca09ab7f10383"                }            ]        },        {            "id": "2c92c0f95ca064e6015ca0995c5b4e8a",            "accountId": "2c92c0f95ca064e6015ca0992a534dd5",            "accountNumber": "A00000696",            "accountName": "testPDF SK",            "invoiceDate": "2017-06-13",            "invoiceNumber": "INV00000830",            "body": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08d5ca06464015ca09a0e170383",            "invoiceItems": [                {                    "id": "2c92c0f95ca064e6015ca0995c5f4e8c",                    "subscriptionName": "A-S00000665",  "subscriptionId": "2c92c0f95ca064e6015ca0995b994e73"},                {                    "id": "2c92c0f95ca064e6015ca0995c604e8d",                    "subscriptionName": "A-S00000665",                    "subscriptionId": "2c92c0f95ca064e6015ca0995b994e73"}            ],            "invoiceFiles": [                {                    "id": "2c92c08d5ca06464015ca09a0e1a0385",                    "versionNumber": 1497343069481,                    "pdfFileUrl": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08d5ca06464015ca09a0e170383"                }            ]        }    ],    "success": true}'
            );
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockInvoiceUnSuccessResponseBody implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockInvoiceUnSuccessResponseStatus implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{    "invoices": [        {            "id": "2c92c0f85ca0567b015ca09d7bd711f7",            "accountId": "2c92c0f95ca064e6015ca0992a534dd5",            "accountNumber": "A00000696",            "accountName": "testPDF SK",            "invoiceDate": "2017-06-13",            "invoiceNumber": "INV00000832",            "body": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08c5ca05646015ca09d80d403aa",            "invoiceItems": [                {                    "id": "2c92c0f85ca0567b015ca09d7bdc11f9",                    "subscriptionName": "A-S00000666",                    "subscriptionId": "2c92c0f85ca0567b015ca09d7b4711ea"}            ],            "invoiceFiles": [                {                    "id": "2c92c08c5ca05646015ca09d80d703ac",                    "versionNumber": 1497343295547,                    "pdfFileUrl": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08c5ca05646015ca09d80d403aa"                }            ]        },        {            "id": "2c92c0f85ca0567a015ca099da0c0809",            "accountId": "2c92c0f95ca064e6015ca0992a534dd5",            "accountNumber": "A00000696",            "accountName": "testPDF SK",            "invoiceDate": "2017-06-13",            "invoiceNumber": "INV00000831",            "body": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08b5ca0648a015ca09ab7f10383",            "invoiceItems": [                {                    "id": "2c92c0f85ca0567a015ca099da10080b", "subscriptionName": "A-S00000665", "subscriptionId": "2c92c0f85ca0567a015ca099d91e07f5" },  {  "id": "2c92c0f85ca0567a015ca099da10080c", "subscriptionName": "A-S00000665",  "subscriptionId": "2c92c0f85ca0567a015ca099d91e07f5"}            ],            "invoiceFiles": [                {                    "id": "2c92c08b5ca0648a015ca09ab7f50385",                    "versionNumber": 1497343113001,                    "pdfFileUrl": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08b5ca0648a015ca09ab7f10383"                }            ]        },        {            "id": "2c92c0f95ca064e6015ca0995c5b4e8a",            "accountId": "2c92c0f95ca064e6015ca0992a534dd5",            "accountNumber": "A00000696",            "accountName": "testPDF SK",            "invoiceDate": "2017-06-13",            "invoiceNumber": "INV00000830",            "body": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08d5ca06464015ca09a0e170383",            "invoiceItems": [                {                    "id": "2c92c0f95ca064e6015ca0995c5f4e8c",                    "subscriptionName": "A-S00000665",  "subscriptionId": "2c92c0f95ca064e6015ca0995b994e73"},                {                    "id": "2c92c0f95ca064e6015ca0995c604e8d",                    "subscriptionName": "A-S00000665",                    "subscriptionId": "2c92c0f95ca064e6015ca0995b994e73"}            ],            "invoiceFiles": [                {                    "id": "2c92c08d5ca06464015ca09a0e1a0385",                    "versionNumber": 1497343069481,                    "pdfFileUrl": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08d5ca06464015ca09a0e170383"                }            ]        }    ],    "success": true}'
            );
            res.setStatusCode(400);
            return res;
        }
    }

    
    public class MockInvoiceSuccessResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{    "invoices": [        {            "id": "2c92c0f85ca0567b015ca09d7bd711f7",            "accountId": "2c92c0f95ca064e6015ca0992a534dd5",            "accountNumber": "A00000696",            "accountName": "testPDF SK",            "invoiceDate": "2017-06-13",            "invoiceNumber": "INV00000832",            "body": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08c5ca05646015ca09d80d403aa",            "invoiceItems": [                {                    "id": "2c92c0f85ca0567b015ca09d7bdc11f9",                    "subscriptionName": "A-S00000666",                    "subscriptionId": "2c92c0f85ca0567b015ca09d7b4711ea"}            ],            "invoiceFiles": [                {                    "id": "2c92c08c5ca05646015ca09d80d703ac",                    "versionNumber": 1497343295547,                    "pdfFileUrl": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08c5ca05646015ca09d80d403aa"                }            ]        },        {            "id": "2c92c0f85ca0567a015ca099da0c0809",            "accountId": "2c92c0f95ca064e6015ca0992a534dd5",            "accountNumber": "A00000696",            "accountName": "testPDF SK",            "invoiceDate": "2017-06-13",            "invoiceNumber": "INV00000831",            "body": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08b5ca0648a015ca09ab7f10383",            "invoiceItems": [                {                    "id": "2c92c0f85ca0567a015ca099da10080b", "subscriptionName": "A-S00000665", "subscriptionId": "2c92c0f85ca0567a015ca099d91e07f5" },  {  "id": "2c92c0f85ca0567a015ca099da10080c", "subscriptionName": "A-S00000665",  "subscriptionId": "2c92c0f85ca0567a015ca099d91e07f5"}            ],            "invoiceFiles": [                {                    "id": "2c92c08b5ca0648a015ca09ab7f50385",                    "versionNumber": 1497343113001,                    "pdfFileUrl": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08b5ca0648a015ca09ab7f10383"                }            ]        },        {            "id": "2c92c0f95ca064e6015ca0995c5b4e8a",            "accountId": "2c92c0f95ca064e6015ca0992a534dd5",            "accountNumber": "A00000696",            "accountName": "testPDF SK",            "invoiceDate": "2017-06-13",            "invoiceNumber": "INV00000830",            "body": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08d5ca06464015ca09a0e170383",            "invoiceItems": [                {                    "id": "2c92c0f95ca064e6015ca0995c5f4e8c",                    "subscriptionName": "A-S00000665",  "subscriptionId": "2c92c0f95ca064e6015ca0995b994e73"},                {                    "id": "2c92c0f95ca064e6015ca0995c604e8d",                    "subscriptionName": "A-S00000665",                    "subscriptionId": "2c92c0f95ca064e6015ca0995b994e73"}            ],            "invoiceFiles": [                {                    "id": "2c92c08d5ca06464015ca09a0e1a0385",                    "versionNumber": 1497343069481,                    "pdfFileUrl": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08d5ca06464015ca09a0e170383"                }            ]        }    ],    "success": true}'
            );
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockInvoiceSuccessResponsePDF implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{    "invoices": [        {            "id": "2c92c0f85ca0567b015ca09d7bd711f7",            "accountId": "2c92c0f95ca064e6015ca0992a534dd5",            "accountNumber": "A00000696",            "accountName": "testPDF SK",            "invoiceDate": "2017-06-13",            "invoiceNumber": "INV00000832",            "body": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08c5ca05646015ca09d80d403aa",            "invoiceItems": [                {                    "id": "2c92c0f85ca0567b015ca09d7bdc11f9",                    "subscriptionName": "A-S00000666",                    "subscriptionId": "2c92c0f85ca0567b015ca09d7b4711ea"}            ],            "invoiceFiles": [                {                    "id": "2c92c08c5ca05646015ca09d80d703ac",                    "versionNumber": 1497343295547,                    "pdfFileUrl": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08c5ca05646015ca09d80d403aa"                }            ]        },        {            "id": "2c92c0f85ca0567a015ca099da0c0809",            "accountId": "2c92c0f95ca064e6015ca0992a534dd5",            "accountNumber": "A00000696",            "accountName": "testPDF SK",            "invoiceDate": "2017-06-13",            "invoiceNumber": "INV00000831",            "body": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08b5ca0648a015ca09ab7f10383",            "invoiceItems": [                {                    "id": "2c92c0f85ca0567a015ca099da10080b", "subscriptionName": "A-S00000665", "subscriptionId": "2c92c0f85ca0567a015ca099d91e07f5" },  {  "id": "2c92c0f85ca0567a015ca099da10080c", "subscriptionName": "A-S00000665",  "subscriptionId": "2c92c0f85ca0567a015ca099d91e07f5"}            ],            "invoiceFiles": [                {                    "id": "2c92c08b5ca0648a015ca09ab7f50385",                    "versionNumber": 1497343113001,                    "pdfFileUrl": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08b5ca0648a015ca09ab7f10383"                }            ]        },        {            "id": "2c92c0f95ca064e6015ca0995c5b4e8a",            "accountId": "2c92c0f95ca064e6015ca0992a534dd5",            "accountNumber": "A00000696",            "accountName": "testPDF SK",            "invoiceDate": "2017-06-13",            "invoiceNumber": "INV00000830",            "body": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08d5ca06464015ca09a0e170383",            "invoiceItems": [                {                    "id": "2c92c0f95ca064e6015ca0995c5f4e8c",                    "subscriptionName": "A-S00000665",  "subscriptionId": "2c92c0f95ca064e6015ca0995b994e73"},                {                    "id": "2c92c0f95ca064e6015ca0995c604e8d",                    "subscriptionName": "A-S00000665",                    "subscriptionId": "2c92c0f95ca064e6015ca0995b994e73"}            ],            "invoiceFiles": [                {                    "id": "2c92c08d5ca06464015ca09a0e1a0385",                    "versionNumber": 1497343069481,                    "pdfFileUrl": "https://apisandbox-api.zuora.com/rest/v1/files/2c92c08d5ca06464015ca09a0e170383"                }            ]        }    ],    "success": true}'
            );
            res.setStatusCode(200);
            return res;
        }
    }
}