@isTest 
private class PaymentHistoryControllerSeeAllDataTest {
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
    
    static testMethod void unitPaymentMethodCreditCard(){
     
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();  
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','uniqueEmail1@test.com','Free Trial');
        oAccount.Free_Trial_Start_Date__c = Date.today();
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','fr_CA','fr_CA','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        system.assertNotEquals(null,bAccount.Id);
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
        zInv.Zuora__TaxExemptAmount__c = 100.00 ;
        zInv.Zuora__TaxAmount__c = 200.00 ;
        zInv.Zuora__TotalAmount__c = 5100.00;
        update zInv;
        
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
        zPay.Zuora__Status__c = 'Processed';
        zPay.Zuora__Effective_Date__c = Date.today();
        zPay.Zuora__EXT_ID__c = 'testpaymentID';
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
        Test.StartTest();
        System.RunAs(oUser){
             ApexPages.currentPage().getParameters().put('lang', 'fr_CA');
            ApexPages.currentPage().getParameters().put('Country', 'CA');

            PaymentHistoryController objCntrl = new PaymentHistoryController();
            objCntrl.isSeeAllDataTest = true;
                       
            objCntrl.getUserSubscription(); 
            objCntrl.getCustomerPaymentHistory();
        }
    } 
    static testMethod void unitPaymentMethodPayPal(){
     
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();  
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','uniqueEmail13@test.com','Free Trial');
        oAccount.Free_Trial_Start_Date__c = Date.today();
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','fr_CA','fr_CA','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        system.assertNotEquals(null,bAccount.Id);
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
        zInv.Zuora__TaxExemptAmount__c = 100.00 ;
        zInv.Zuora__TaxAmount__c = 200.00 ;
        zInv.Zuora__TotalAmount__c = 5100.00;
        update zInv;
        
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
        zPay.Zuora__Status__c = 'Processed';
        zPay.Zuora__Effective_Date__c = Date.today();
        zPay.Zuora__EXT_ID__c = 'testpaymentID';
        zPay.Zuora__PaymentMethod__c = 'Credit Card Visa ************1111';
        update zPay;

        zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
        zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
        update zSubsr;
        
        Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'PayPal', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
        
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
        Test.StartTest();
        System.RunAs(oUser){
             ApexPages.currentPage().getParameters().put('lang', 'fr_CA');
            ApexPages.currentPage().getParameters().put('Country', 'CA');

            PaymentHistoryController objCntrl = new PaymentHistoryController();
            objCntrl.isSeeAllDataTest = true;
                       
            objCntrl.getUserSubscription(); 
            objCntrl.getCustomerPaymentHistory();
        }
    } 
    static testMethod void unitPaymentMethodBankTransfer(){
     
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();  
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','uniqueEmail2@test.com','Free Trial');
        oAccount.Free_Trial_Start_Date__c = Date.today();
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','fr_CA','fr_CA','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        system.assertNotEquals(null,bAccount.Id);
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
        zInv.Zuora__TaxExemptAmount__c = 100.00 ;
        zInv.Zuora__TaxAmount__c = 200.00 ;
        zInv.Zuora__TotalAmount__c = 5100.00;
        zInv.Zuora__External_Id__c = 'testinvoiceID';
        update zInv;
        
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
        zPay.Zuora__Status__c = 'Processed';
        zPay.Zuora__Effective_Date__c = Date.today();
        zPay.Zuora__EXT_ID__c = 'testpaymentID';
        zPay.Zuora__PaymentMethod__c = 'Credit Card Visa ************1111';
        update zPay;

        zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
        zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
        update zSubsr;
        
        Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'BankTransfer', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
        
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
        Test.StartTest();
        System.RunAs(oUser){
             ApexPages.currentPage().getParameters().put('lang', 'fr_CA');
            ApexPages.currentPage().getParameters().put('Country', 'CA');

            PaymentHistoryController objCntrl = new PaymentHistoryController();
            objCntrl.isSeeAllDataTest = true;
                       
            objCntrl.getUserSubscription(); 
            objCntrl.getCustomerPaymentHistory();
        }
    }
    
}