/**
* @author Cognizant Technology Solutuions
* @date 05/02/2015
* @description This class test payment history functionality.
*/
@IsTest
public without sharing class PaymentHistoryControllerTest{    
    @testSetup static void DAZN_Country_Currency() {
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

    // http://community.zuora.com/t5/API/quot-Zuora-zAPIException-Please-upload-Zuora-WSDL-at-first-quot/td-p/2214
    static testMethod void unitTestPaymentMethodaPayPal(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.Free_Trial_Start_Date__c = Date.today();
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
        zInv.Zuora__TaxExemptAmount__c = 100.00 ;
        zInv.Zuora__TaxAmount__c = 200.00 ;
        zInv.Zuora__TotalAmount__c = 5100.00;
        update zInv;
        
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
        zPay.Zuora__Status__c = 'Processed';
        zPay.Zuora__Effective_Date__c = Date.today();
        zPay.Zuora__PaymentMethod__c = 'Pay Pal Visa ************1111';
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
        system.assertEquals(1000.00, oZuoraRefund.Zuora__Amount__c);
        Zuora__RefundInvoicePayment__c oZuoraRefundInvoicePayment = new Zuora__RefundInvoicePayment__c();
        oZuoraRefundInvoicePayment.Zuora__Refund__c = oZuoraRefund.Id;
        oZuoraRefundInvoicePayment.Zuora__InvoicePayment__c =  zPaymentInvoice.Id;
        oZuoraRefundInvoicePayment.Zuora__RefundAmount__c = 1000.00;    
        insert oZuoraRefundInvoicePayment;    
        
        Test.StartTest();
            System.RunAs(oUser){
                
                PaymentHistoryController objCntrl = new PaymentHistoryController();
                System.assertequals(objCntrl.oUser.Id,Userinfo.getUserId());
                objCntrl.redirectToMyAccount();
                system.assertEquals('/MyAccount', objCntrl.redirectToMyAccount().getURL());
                objCntrl.navigateToErrorPage();
            }
        Test.stopTest();
    }
    
    static testMethod void unitPaymentMethodCreditCard(){
     
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
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
                System.assertequals(objCntrl.oUser.Id,Userinfo.getUserId());
                           
                objCntrl.redirectToMyAccount(); 
                system.assertEquals('/MyAccount',objCntrl.redirectToMyAccount().getURL());
            }
        Test.stopTest();
    }     
    
    static testMethod void unitPaymentMethodBankTransfer(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.Free_Trial_Start_Date__c = Date.today();
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
        
        User u = [SELECT Id, AccountId FROM User WHERE AccountId = :oAccount.Id];
        System.RunAs(u){

        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
        zInv.Zuora__TaxExemptAmount__c = 100.00 ;
        zInv.Zuora__TaxAmount__c = 200.00 ;
        zInv.Zuora__TotalAmount__c = 5100.00;
        update zInv;
        }
        Zuora__ZInvoice__c zInv = [SELECT Id FROM Zuora__ZInvoice__c WHERE Zuora__Account__c = :oAccount.Id];
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
        zPay.Zuora__Status__c = 'Processed';
        zPay.Zuora__Effective_Date__c = Date.today();
        zPay.Zuora__PaymentMethod__c = 'Bank Transfer Visa ************1111';
        update zPay;
        
        Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'BankTransfer', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
        zPaymentMethod.Zuora__BankTransferAccountNumber__c = '123456';
        update zPaymentMethod;

        zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
        zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
        update zSubsr;
        
        Zuora__PaymentInvoice__c zPaymentInvoice = SetupTestData.createZuoraPaymentInvoice(zPay.Id, zInv.Id);
        zPaymentInvoice.Zuora__RefundAmount__c = 1000;
        update zPaymentInvoice; 
        system.assertEquals(1000, zPaymentInvoice.Zuora__RefundAmount__c);
        
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

            System.RunAs(u){
                PaymentHistoryController objCntrl = new PaymentHistoryController();
                System.assertequals(objCntrl.oUser.Id,Userinfo.getUserId());
                objCntrl.redirectToMyAccount();
                system.assertEquals('/MyAccount',objCntrl.redirectToMyAccount().getURL());
                
            }
        Test.stopTest();
    }
    
    static testMethod void unitTestNoPaymentMethod(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
        zInv.Zuora__TaxExemptAmount__c = 100.00 ;
        zInv.Zuora__TaxAmount__c = 200.00 ;
        zInv.Zuora__TotalAmount__c = 5100.00;
        update zInv;
        system.assertEquals(5100.00, zInv.Zuora__TotalAmount__c);
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
        zPay.Zuora__Status__c = 'Processed';
        zPay.Zuora__PaymentMethod__c = 'Credit Card Visa ************1111';
        update zPay;
        
        Zuora__PaymentMethod__c zPaymentMethod;
        
        Zuora__Refund__c oZuoraRefund = new Zuora__Refund__c();
        oZuoraRefund.Zuora__Account__c = oAccount.Id;
        oZuoraRefund.Zuora__BillingAccount__c = bAccount.Id;
        oZuoraRefund.Zuora__Payment__c = zPay.Id;
        oZuoraRefund.Zuora__Amount__c = 1000.00;    
        oZuoraRefund.Zuora__RefundDate__c = Date.today().addDays(-5);
        insert oZuoraRefund;
        system.assertNotEquals(null,oZuoraRefund);
        
        Test.StartTest();
        
            System.RunAs(oUser){
                           
                PaymentHistoryController objCntrl = new PaymentHistoryController();
                objCntrl.slang = 'fr_CA';
                objCntrl.sCountryName = 'CA';
                PaymentHistoryController.sortBy = 'ASC';
                System.assertequals(objCntrl.oUser.Id,Userinfo.getUserId());
                objCntrl.redirectToMyAccount();
                objCntrl.navigateToErrorPage();
            }
        Test.stopTest();
    }
    
    static testMethod void unitPaymentMethodBankTransfer1(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.Free_Trial_Start_Date__c = Date.today();
        update oAccount;
        System.debug('test Class'+oAccount);
        
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','fr_CA','fr_CA','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
        update zSubsr;
        oAccount.Notification_Country_Code__c = 'CA';
        update oAccount;

        zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
        zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
        zSubsr.Giftcode__c = 'testCode';
        zSubsr.Free_Trial_End_Date__c = Date.today();
        zSubsr.Campaign_Id__c = 'testCampId';
        update zSubsr;
        
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
        zInv.Zuora__TaxExemptAmount__c = 100.00 ;
        zInv.Zuora__TaxAmount__c = 200.00 ;
        zInv.Zuora__TotalAmount__c = 5100.00;
        update zInv;
        
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
        zPay.Zuora__Status__c = 'Processed';
        zPay.Zuora__Effective_Date__c = Date.today();
        zPay.Zuora__PaymentMethod__c = 'Bank Transfer Visa ************1111';
        update zPay;
        
        Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'BankTransfer', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
        zPaymentMethod.Zuora__BankTransferAccountNumber__c = '123456';
        update zPaymentMethod;
        
        Zuora__PaymentInvoice__c zPaymentInvoice = SetupTestData.createZuoraPaymentInvoice(zPay.Id, zInv.Id);
        zPaymentInvoice.Zuora__RefundAmount__c = 1000;
        update zPaymentInvoice; 
        system.assertEquals(1000, zPaymentInvoice.Zuora__RefundAmount__c);
        
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
                PageReference pageRef = Page.paymenthistory;//Observe how we set the Page here
                Test.setCurrentPage(pageRef);
                PaymentHistoryController objCntrl = new PaymentHistoryController();
                System.assertequals(objCntrl.oUser.Id,Userinfo.getUserId());
                objCntrl.redirectToMyAccount();
                system.assertEquals('/MyAccount',objCntrl.redirectToMyAccount().getURL());
                
            }
        Test.stopTest();
    }
    
    static testMethod void unitPaymentMethodBankTransferCA_Fr(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.Free_Trial_Start_Date__c = Date.today();
        update oAccount;
        System.debug('test Class'+oAccount);
        
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','fr_CA','fr_CA','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
        zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
        zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
        zSubsr.Giftcode__c = 'testcode';
        zSubsr.Free_Trial_End_Date__c = system.today();
        zSubsr.Campaign_Id__c = 'TestCampId';
        update zSubsr;
        oAccount.Notification_Country_Code__c = 'CA';
        update oAccount;
        
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
        zInv.Zuora__TaxExemptAmount__c = 100.00 ;
        zInv.Zuora__TaxAmount__c = 200.00 ;
        zInv.Zuora__TotalAmount__c = 5100.00;
        zInv.Zuora__AmountWithoutTax__c = 200.00;
        update zInv;
        
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
        zPay.Zuora__Status__c = 'Processed';
        zPay.Zuora__Effective_Date__c = Date.today();
        zPay.Zuora__PaymentMethod__c = 'Bank Transfer Visa ************1111';
        update zPay;
        
        Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'BankTransfer', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
        zPaymentMethod.Zuora__BankTransferAccountNumber__c = '123456';
        update zPaymentMethod;
        
        Zuora__PaymentInvoice__c zPaymentInvoice = SetupTestData.createZuoraPaymentInvoice(zPay.Id, zInv.Id);
        zPaymentInvoice.Zuora__RefundAmount__c = 1000;
        update zPaymentInvoice; 
        system.assertEquals(1000, zPaymentInvoice.Zuora__RefundAmount__c);
        
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
            PageReference pageRef = Page.paymenthistory;//Observe how we set the Page here
            Test.setCurrentPage(pageRef);
            //Add parameters to page URL
          ApexPages.currentPage().getParameters().put('lang', 'fr_CA');
            ApexPages.currentPage().getParameters().put('Country', 'CA');
            PaymentHistoryController objCntrl = new PaymentHistoryController();
            System.assertequals(objCntrl.oUser.Id,Userinfo.getUserId());
            objCntrl.redirectToMyAccount();
            system.assertEquals('/MyAccount',objCntrl.redirectToMyAccount().getURL());
            
        }
    }

    static testMethod void testGiftCode(){
     
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.All_Email_Preferences__c = false;
        oAccount.Disable_all_transactional_emails__c  = false;
        update oAccount;

        Account acc = [SELECT Id from account where id = :oAccount.Id];
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','fr_CA','fr_CA','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        system.assertNotEquals(null,bAccount.Id);
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
        zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
        zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
        zSubsr.Giftcode__c = 'dfdfs';
        zSubsr.Gift_Code_End_Date__c = Date.today().addDays(3);
        zSubsr.NumGiftPeriods__c = '1';
        zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
        zSubsr.Free_Trial_End_Date__c = Date.today();
        update zSubsr;
        Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'CreditCard', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
        
        User us = [Select Id, AccountId FRom User Where Id = :oUser.Id];
        
        Test.StartTest();
            System.RunAs(us){
                ApexPages.currentPage().getParameters().put('lang', 'fr_CA');
                ApexPages.currentPage().getParameters().put('Country', 'CA');

                PaymentHistoryController objCntrl = new PaymentHistoryController();
                System.assert(objCntrl.lstWrapPaymentHistoryTemp != null);

            }
        Test.stopTest();
    }

    static testMethod void testGiftCode2(){
     
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.All_Email_Preferences__c = false;
        oAccount.Disable_all_transactional_emails__c  = false;
        update oAccount;

        Account acc = [SELECT Id from account where id = :oAccount.Id];
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','fr_CA','fr_CA','TestFName','TestLName',true); 

        User us = [Select Id, AccountId, profileId FRom User Where Id = :oUser.Id];
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        system.assertNotEquals(null,bAccount.Id);
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
        zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
        zSubsr.Giftcode__c = 'dfdfs';
        zSubsr.Gift_Code_End_Date__c = Date.today().addDays(3);
        zSubsr.NumGiftPeriods__c = '1';
        zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
        zSubsr.Campaign_Id__c  = 'testCampId';
        zSubsr.Free_Trial_End_Date__c = Date.today();
        update zSubsr;
        
        Test.StartTest();
            System.RunAs(us){
                ApexPages.currentPage().getParameters().put('lang', 'fr_CA');
                ApexPages.currentPage().getParameters().put('Country', 'CA');

                PaymentHistoryController objCntrl = new PaymentHistoryController();
                System.assert(objCntrl.lstWrapPaymentHistoryTemp != null);

            }
        Test.stopTest();
    }
    static testMethod void testGiftCode3(){
     
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.All_Email_Preferences__c = false;
        oAccount.Disable_all_transactional_emails__c  = false;
        update oAccount;

        Account acc = [SELECT Id from account where id = :oAccount.Id];
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','fr_CA','fr_CA','TestFName','TestLName',true); 

        User us = [Select Id, AccountId, profileId FROM User Where Id = :oUser.Id];
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        system.assertNotEquals(null,bAccount.Id);
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
        zSubsr.Free_Trial_End_Date__c = Date.today().addDays(-2);
        zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
        zSubsr.Giftcode__c = 'dfdfs';
        zSubsr.Gift_Code_End_Date__c = Date.today().addDays(3);
        zSubsr.NumGiftPeriods__c = '1';
        zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
        zSubsr.Campaign_Id__c  = 'TestCampId';
        update zSubsr;
        
        Test.StartTest();
            System.RunAs(us){
                ApexPages.currentPage().getParameters().put('lang', 'fr_CA');
                ApexPages.currentPage().getParameters().put('Country', 'CA');

                PaymentHistoryController objCntrl = new PaymentHistoryController();
                System.assert(objCntrl.lstWrapPaymentHistoryTemp != null);
            }
        Test.stopTest();
    }

    static testMethod void testCreatePaymetHistoryForGiftCode() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.All_Email_Preferences__c = false;
        oAccount.Disable_all_transactional_emails__c = false;
        update oAccount;
        Account acc = [SELECT Id from account where id = :oAccount.Id];
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','fr_CA','fr_CA','TestFName','TestLName',true); 

        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        system.assertNotEquals(null,bAccount.Id);

        Zuora__Subscription__c oSubscription = SetUpTestData.createSubscriptionWithGiftCode(oAccount.Id, bAccount.Id);
        
        User us = [Select Id, AccountId, profileId FRom User Where Id = :oUser.Id];
        
        Test.StartTest();
            System.RunAs(us){
                PaymentHistoryController.wrapPaymentHistory wrapPayment = new PaymentHistoryController.wrapPaymentHistory();
                Zuora__Subscription__c oSubscriptionTest = [SELECT Gift_Code_Start_Date__c, Gift_Code_End_Date__c FROM Zuora__Subscription__c WHERE Id = :oSubscription.Id];
                new PaymentHistoryController().CreatePaymetHistoryForGiftCode(wrapPayment, oSubscriptionTest);
                System.assert(wrapPayment != null);
            }
        Test.stopTest();
    }

    static testMethod void testFreeTrial(){
     
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.All_Email_Preferences__c = false;
        oAccount.Disable_all_transactional_emails__c  = false;
        update oAccount;
        
        Test.StartTest();

            User oUser = SetUpTestData.createCommunityUserDE(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
            Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
            
            Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
            zSubsr.NumFreeTrialPeriods__c = '1';
            zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
            zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
            update zSubsr;

            Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
            zInv.Zuora__TaxExemptAmount__c = 100.00 ;
            zInv.Zuora__TaxAmount__c = 200.00 ;
            zInv.Zuora__TotalAmount__c = 5100.00;
            zInv.Zuora__AmountWithoutTax__c = 200.00;
            update zInv;
            
            Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
            zPay.Zuora__Status__c = 'Processed';
            zPay.Zuora__Effective_Date__c = Date.today();
            zPay.Zuora__PaymentMethod__c = 'Credit Card Visa ************1111';
            update zPay;
            
            Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'PayPal', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
            
            Zuora__PaymentInvoice__c zPaymentInvoice = SetupTestData.createZuoraPaymentInvoice(zPay.Id, zInv.Id);
            SetUpTestData.createGiftCodeHistory(oAccount.Id);

            System.RunAs(oUser){
                
                PaymentHistoryController objCntrl = new PaymentHistoryController();
                System.assert(objCntrl.lstWrapPaymentHistoryTemp != null);

            }
        Test.stopTest();
    }
    static testMethod void testFreeTrialWithGiftCode(){
     
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.All_Email_Preferences__c = false;
        oAccount.Disable_all_transactional_emails__c  = false;
        update oAccount;
        
        Test.StartTest();

            User oUser = SetUpTestData.createCommunityUserDE(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
            Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');

            Zuora__Subscription__c oSubscription = SetUpTestData.createSubscriptionWithGiftCode(oAccount.Id, bAccount.Id);

            Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
            zInv.Zuora__TaxExemptAmount__c = 100.00 ;
            zInv.Zuora__TaxAmount__c = 200.00 ;
            zInv.Zuora__TotalAmount__c = 5100.00;
            zInv.Zuora__AmountWithoutTax__c = 200.00;
            update zInv;
            
            Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
            zPay.Zuora__Status__c = 'Processed';
            zPay.Zuora__Effective_Date__c = Date.today();
            zPay.Zuora__PaymentMethod__c = 'Credit Card Visa ************1111';
            update zPay;
            
            Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'PayPal', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
            
            Zuora__PaymentInvoice__c zPaymentInvoice = SetupTestData.createZuoraPaymentInvoice(zPay.Id, zInv.Id);
            SetUpTestData.createGiftCodeHistory(oAccount.Id);

            System.RunAs(oUser){
                
                PaymentHistoryController objCntrl = new PaymentHistoryController();
                System.assert(objCntrl.lstWrapPaymentHistoryTemp != null);

            }
        Test.stopTest();
    }

    static testMethod void testFreeTrialPayPal(){
     
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.All_Email_Preferences__c = false;
        oAccount.Disable_all_transactional_emails__c  = false;
        update oAccount;

        User oUser = SetUpTestData.createCommunityUserDE(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');

        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
        zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
        zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
        update zSubsr;

        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
        zInv.Zuora__TaxExemptAmount__c = 100.00 ;
        zInv.Zuora__TaxAmount__c = 200.00 ;
        zInv.Zuora__TotalAmount__c = 5100.00;
        zInv.Zuora__AmountWithoutTax__c = 5100.00;
        update zInv;
        Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'PayPal', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
        
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
        zPay.Zuora__Status__c = 'Processed';
        zPay.Zuora__Effective_Date__c = Date.today();
        zPay.Zuora__PaymentMethod__c = 'Pay Pal ************1111';
        update zPay;
        
        Test.StartTest();
            System.RunAs(oUser){
                
                PaymentHistoryController objCntrl = new PaymentHistoryController();
                System.assert(objCntrl.lstWrapPaymentHistoryTemp != null);

            }
        Test.stopTest();
    }
    static testMethod void testFreeTrialBankTransfer(){
     
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.All_Email_Preferences__c = false;
        oAccount.Disable_all_transactional_emails__c  = false;
        update oAccount;

        User oUser = SetUpTestData.createCommunityUserDE(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');

        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
        zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
        zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
        zSubsr.Giftcode__c = 'test';
        zSubsr.NumGiftPeriods__c = '1';
        zSubsr.Campaign_Id__c = 'test';
        update zSubsr;

        Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'BankTransfer', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
        
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
        zInv.Zuora__TaxExemptAmount__c = 100.00 ;
        zInv.Zuora__TaxAmount__c = 200.00 ;
        zInv.Zuora__TotalAmount__c = 5100.00;
        zInv.Zuora__AmountWithoutTax__c = 200.00;
        update zInv;

        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
        zPay.Zuora__Status__c = 'Processed';
        zPay.Zuora__Effective_Date__c = Date.today();
        zPay.Zuora__PaymentMethod__c = 'Bank Transfer ************1111';
        update zPay;
        
        Test.StartTest();
            System.RunAs(oUser){
                
                PaymentHistoryController objCntrl = new PaymentHistoryController();
                System.assert(objCntrl.lstWrapPaymentHistoryTemp != null);

            }
        Test.stopTest();
    }

    static testMethod void testShowBaner() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();    
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.All_Email_Preferences__c = false;
        oAccount.Disable_all_transactional_emails__c  = false;
        update oAccount;
        
        User oUser = SetUpTestData.createCommunityUserDE(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');

        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account subs', 'Active', Date.Today(), Date.today().addMonths(2) );
        zSubsr.Zuora__SubscriptionStartDate__c = Date.today();
        zSubsr.Zuora__TermSettingType__c = 'EVERGREEN';
        update zSubsr;

        Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'BankTransfer', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
        zInv.Zuora__TaxExemptAmount__c = 100.00 ;
        zInv.Zuora__TaxAmount__c = 200.00 ;
        zInv.Zuora__TotalAmount__c = 5100.00;
        zInv.Zuora__AmountWithoutTax__c = 200.00;
        update zInv;

        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
        zPay.Zuora__Status__c = 'Processed';
        zPay.Zuora__Effective_Date__c = Date.today();
        zPay.Zuora__PaymentMethod__c = 'Credit Card Visa ************1111';
        update zPay;
        User us = [Select Id, AccountId FRom User Where Id = :oUser.Id];

        
        Test.StartTest();
            System.RunAs(us){
                ApexPages.currentPage().getParameters().put('dowloaderror', '1');
                PaymentHistoryController objCntrl = new PaymentHistoryController();
                objCntrl.linkDownload = 'false';
                System.assertEquals(objCntrl.showbanner,true);
                objCntrl.closeBanner();
                System.assertEquals(objCntrl.showbanner,false);
            }
        Test.stopTest();
    }

}