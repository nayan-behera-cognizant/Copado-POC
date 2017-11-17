/**
* @author Cognizant Technology Solutuions
* @date 05/02/2015
* @description This class test ChangePaymentMethod Controller functionality.
*/
@istest
public class ChangePaymentMethodControllerTest {
    
    @testSetup 
    static void SetupData()
    {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();

        SetUpTestData.testCreateDAZNConfiguration('paypalAPIURL', 'https://www.sandbox.paypal.com');
        SetUpTestData.testCreateDAZNConfiguration('paypalURL', 'https://api-3t.sandbox.paypal.com/nvp'); 
        SetUpTestData.testCreateDAZNConfiguration('PaypalReturnUrl', 'https://lsdev-lsdev.cs80.force.com/livesport/PaypalReturnUrl'); 
        SetUpTestData.testCreateDAZNConfiguration('PaypalCancelUrl', 'https://lsdev-lsdev.cs80.force.com/livesport/ChangePaymentMethod');
        SetUpTestData.testCreateDAZNConfiguration('ZuoraHostedPageDomain', 'https://lsdev-lsdev.cs80.force.com');
        SetUpTestData.testCreateDAZNConfiguration('ZuoraPublicHostedPageURL', 'https://apisandbox.zuora.com/apps/PublicHostedPageLite.do');
        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', '/LoginPageURL');
        SetUpTestData.testCreateDAZNConfiguration('ZuoraRSASignatureEndPointURL', 'https://apisandbox-api.zuora.com/rest/v1/rsa-signatures');
        SetUpTestData.testCreateDAZNConfiguration('ZuoraAPIUserId', 'Alok.Agnihotri_livesport_sandbox@cognizant.com');
        SetUpTestData.testCreateDAZNConfiguration('ZuoraAPIUserPassword', 'P@ssw0rd#');
        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', '/LoginPageURL');
        SetUpTestData.testCreateDAZNConfiguration('PaypalExpressCheckoutURL', '/cgi-bin/webscr?cmd=_express-checkout');
        SetUpTestData.testCreateDAZNConfiguration('PaypalRequestTokenTimeout', '3000');
        SetUpTestData.testCreateDAZNConfiguration('PaypalGetBillingIDZuoraTimeout', '1000');
        
        SetUpTestData.createDAZNConfigurations();

        List<DAZN_Country_Currency_ISO_Code__c> cur = new List<DAZN_Country_Currency_ISO_Code__c>();
        cur.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'CAD',
            CurrencySymbol__c = '$'
        ));
        cur.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'CHF',
            CurrencySymbol__c = 'CHF'
        ));
        cur.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'CNY',
            CurrencySymbol__c = '元'
        ));
        cur.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'EUR',
            CurrencySymbol__c = '€'
        ));
        cur.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'GBP',
            CurrencySymbol__c = '£'
        ));
        cur.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'JPY',
            CurrencySymbol__c = '¥'
        ));
        cur.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'KRW',
            CurrencySymbol__c = '₩'
        ));
        cur.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'USD',
            CurrencySymbol__c = '$'
        ));
        insert cur;

        List<PaymentMethodOptionConfig__c> paymConf = new List<PaymentMethodOptionConfig__c>();
        paymConf.add(new PaymentMethodOptionConfig__c(
            Name = 'Austria',
            Billing_Batch__c = 'Batch3 (Austria)',
            CardsPaymentGateway__c = 'DAZN Adyen AT',
            CountryCode__c = 'AT',
            Credit_Card__c = true,
            Currency_Format__c = '#,###',
            DefaultPaymentMethod__c = 'DirectDebit',
            Direct_Debit__c = true,
            Paypal__c = true,
            PaypalMerchantPassword__c = 'WPQFUKTE9E6DFL9G',
            PaypalMerchantSignature__c = 'AOEtP8wVTUF4cOZ.sx4oFW50MVtkATy6RujnFFGwTSmEkqN8hF4WQM3w',
            PaypalMerchantUsername__c = 'DAZN.PAYPAL.DACH_api1.performgroup.com',
            PaypalPaymentGateway__c = 'DAZN PayPal DACH',
            ZuoraCreditCardPageId__c = '2c91a0fa596d46ff01598cf6dd883ad2',
            ZuoraDirectDebitPageId__c = '2c91a0fb596d4d3d01598cfbdda30e4c'
        ));
        paymConf.add(new PaymentMethodOptionConfig__c(
            Name = 'Germany',
            Billing_Batch__c = 'Batch2 (Germany)',
            CardsPaymentGateway__c = 'DAZN Adyen DE',
            CountryCode__c = 'DE',
            Credit_Card__c = true,
            Currency_Format__c = '#,###',
            DefaultPaymentMethod__c = 'DirectDebit',
            Direct_Debit__c = true,
            Paypal__c = true,
            PaypalMerchantPassword__c = 'WPQFUKTE9E6DFL9G',
            PaypalMerchantSignature__c = 'AOEtP8wVTUF4cOZ.sx4oFW50MVtkATy6RujnFFGwTSmEkqN8hF4WQM3w',
            PaypalMerchantUsername__c = 'DAZN.PAYPAL.DACH_api1.performgroup.com',
            PaypalPaymentGateway__c = 'DAZN PayPal DACH',
            ZuoraCreditCardPageId__c = '2c91a0fa596d46ff01598cf6dd883ad2',
            ZuoraDirectDebitPageId__c = '2c91a0fb596d4d3d01598cfbdda30e4c'
        ));
        paymConf.add(new PaymentMethodOptionConfig__c(
            Name = 'Japan',
            Billing_Batch__c = 'Batch1 (Japan)',
            CardsPaymentGateway__c = 'DAZN Adyen JP',
            CountryCode__c = 'JP',
            Credit_Card__c = true,
            Currency_Format__c = '#,###',
            DefaultPaymentMethod__c = 'CreditCard',
            Direct_Debit__c = false,
            Paypal__c = true,
            PaypalMerchantPassword__c = 'ASXDCR5KXCKMT6WC',
            PaypalMerchantSignature__c = 'AFcWxV21C7fd0v3bYYYRCpSSRl31AdMj1OLMeudVF2hj-.fmjUmA2I24',
            PaypalMerchantUsername__c = 'DAZN.PAYPAL.JP-facilitator_api1.performgroup.com',
            PaypalPaymentGateway__c = 'DAZN Paypal JP',
            ZuoraCreditCardPageId__c = '2c91a0fa596d46ff01598cf6dd883ad2',
            ZuoraDirectDebitPageId__c = '2c91a0fb596d4d3d01598cfbdda30e4c'
        ));
        paymConf.add(new PaymentMethodOptionConfig__c(
            Name = 'Switzerland',
            Billing_Batch__c = 'Batch4 (Switzerland)',
            CardsPaymentGateway__c = 'DAZN Adyen CH',
            CountryCode__c = 'CH',
            Credit_Card__c = true,
            Currency_Format__c = '#,###',
            DefaultPaymentMethod__c = 'CreditCard',
            Direct_Debit__c = true,
            Paypal__c = true,
            PaypalMerchantPassword__c = 'WPQFUKTE9E6DFL9G',
            PaypalMerchantSignature__c = 'AOEtP8wVTUF4cOZ.sx4oFW50MVtkATy6RujnFFGwTSmEkqN8hF4WQM3w',
            PaypalMerchantUsername__c = 'DAZN.PAYPAL.DACH_api1.performgroup.com',
            PaypalPaymentGateway__c = 'DAZN PayPal DACH',
            ZuoraCreditCardPageId__c = '2c91a0fa596d46ff01598cf6dd883ad2',
            ZuoraDirectDebitPageId__c = '2c91a0fb596d4d3d01598cfbdda30e4c'
        ));
        paymConf.add(new PaymentMethodOptionConfig__c(
            Name = 'United Kingdom',
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
    }
    
    /*static testmethod void testchangePaymentMethodPaypalSuccess()
{   
SetUpTestData.triggerSettings();
SetUpTestData.emailCustsett();
Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm1testemail@email.com','Free Trial');
SetUpTestData.createCommunityUser(oAccount.Id, 'pm1testemail@email.com', 'pm1testemail@email.com', 'tstals1','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
SetUpTestData.testCreatePaymentMethodOptionConfiguration('United Kingdom', 'GB', true, true, false, 'test', 'test', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Gateway', 'Paypal','Batch3'); 
Test.startTest();
Test.setMock(HttpCalloutMock.class, new MockHttpPaypalRequestGenerator());
User oUser = [Select ID from User where Email='pm1testemail@email.com' limit 1];
System.assertNotEquals(null, oUser.Id);        
System.runAs(oUser)
{ 
ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
oChangePaymentMethodController.strPmtMode='Paypal';            
oChangePaymentMethodController.redirectToPaypal();
PaypalReturnUrlController oPaypalReturnUrlController = new PaypalReturnUrlController();
oPaypalReturnUrlController.redirectToPaypalStatusPage();          
}
Test.stopTest();
}*/
    static testmethod void testchangePaymentMethodPaypalFailureInvalidCountry()
    {
        //SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm2testemail@email.com','Free Trial');
        SetUpTestData.createCommunityUser(oAccount.Id, 'pm2testemail@email.com', 'pm1testemail@email.com', 'tstals2','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
        //SetUpTestData.testCreatePaymentMethodOptionConfiguration('United Kingdom', 'GB', true, true, false, 'test', 'test', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Gateway', 'Paypal','Batch3'); 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockPaypalFailureResponse());
        User oUser = [Select ID,CountryCode from User where Email='pm2testemail@email.com' limit 1];
        System.assertNotEquals(null, oUser.Id);
        System.runAs(oUser)
        { 
            ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
            oChangePaymentMethodController.strPmtMode='Paypal';            
            oChangePaymentMethodController.redirectToPaypal();
            PaypalCancelUrlController oPaypalCancelUrlController = new PaypalCancelUrlController();  
            PaypalResponse oPaypalResponse = new PaypalResponse();
            PageReference pageRefPaypalResponse = oPaypalResponse.getRequest();
            PaypalReturnUrlController oPaypalReturnUrl = new PaypalReturnUrlController();
            PageReference pageRefPaypalReturnUrl = oPaypalReturnUrl.redirectToPaypalStatusPage();
            PageReference pageRef = Page.ChangePaymentMethod;
            pageRef.getParameters().put('success','false');
            pageRef.getParameters().put('errorcode','invalidcountry');
            pageRef.getParameters().put('errorMessage','https://lsdev-lsdev.cs80.force.com/livesport/changepaymentmethod?success=false&errorCode=GatewayTransactionError&errorMessage=Transaction%20declined.Refused%20-%20FRAUD&field_passthrough2=CreditCard&field'); 
            Test.setCurrentPage(pageRef);
            ChangePaymentMethodController oChangePaymentMethodControllerFailure = new ChangePaymentMethodController();
            oChangePaymentMethodControllerFailure.closeBanner();
            oChangePaymentMethodControllerFailure.getPaymentMode();
            oChangePaymentMethodControllerFailure.getMonths();
            oChangePaymentMethodControllerFailure.getYears();
        }
        Test.stopTest();
    }
    static testmethod void testchangePaymentMethodPaypalFailure()
    {      
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm2testemail@email.com','Free Trial');
        SetUpTestData.createCommunityUser(oAccount.Id, 'pm2testemail@email.com', 'pm1testemail@email.com', 'tstals2','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
        //SetUpTestData.testCreatePaymentMethodOptionConfiguration('United Kingdom', 'GB', true, true, false, 'test', 'test', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Gateway', 'Paypal','Batch3'); 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockPaypalFailureResponse());
        User oUser = [Select ID,CountryCode from User where Email='pm2testemail@email.com' limit 1];  
        System.assertNotEquals(null, oUser.Id);
        System.runAs(oUser)
        { 
            ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
            oChangePaymentMethodController.strPmtMode='Paypal';            
            oChangePaymentMethodController.redirectToPaypal();
            PaypalCancelUrlController oPaypalCancelUrlController = new PaypalCancelUrlController();         
            PageReference pageRef = Page.ChangePaymentMethod;
            pageRef.getParameters().put('token','test');
            
            Test.setCurrentPage(pageRef);
            ChangePaymentMethodController oChangePaymentMethodControllerFailure = new ChangePaymentMethodController();
        }
        Test.stopTest();
    }
    
    static testMethod void testCurrentPaymentMethodCCNOption(){
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        //PaymentMethodOptionConfig__c oPaymentMethodConfig = SetUpTestData.testCreatePaymentMethodOptionConfiguration('United Kingdom', 'GB', true, true, false, 'test', 'test', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Gateway', 'CreditCard','Batch3'); 
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm44testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'pm44testemail@email.com', 'pm44testemail@email.com', 'tstals3','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'TESTCPM73', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        Zuora__PaymentMethod__c zPaymentMethod = SetupTestData.createZuoraPaymentMethod(bAccount.Id, 'Active', 'CreditCard', '4111111111111111', 'Visa', 'Test Test', String.valueOf(System.Today().month()), String.valueOf(System.Today().year()), '123', 'Success');
        zPaymentMethod.Zuora__DefaultPaymentMethod__c = true;
        update zPaymentMethod;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockPaypalFailureResponse());
        System.runAs(oUser)
        { 
            ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
            System.assertEquals('CreditCard', oChangePaymentMethodController.currentPaymentMethod);
            System.assertEquals(true, oChangePaymentMethodController.showCC);
            System.assertEquals(true, oChangePaymentMethodController.showDD);
            System.assertEquals(true, oChangePaymentMethodController.showPP);
            oChangePaymentMethodController.showMessage('test');
            System.assertEquals('test', oChangePaymentMethodController.strMessage);
            PageReference oPgf = oChangePaymentMethodController.onCancelOperation();
            System.assertEquals('/MyAccount', oPgf.getURL());
        }
        Test.stopTest();
    }
    
    static testMethod void testCurrentPaymentMethodPPNOption(){
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        //PaymentMethodOptionConfig__c oPaymentMethodConfig = SetUpTestData.testCreatePaymentMethodOptionConfiguration('United Kingdom', 'GB', true, true, false, 'test', 'test', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Gateway', 'Paypal','Batch3'); 
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm4testemail@email.com','Active Paid');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'pm4testemail@email.com', 'pm4testemail@email.com', 'tstals4','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'TESTCPM74', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        Zuora__PaymentMethod__c zPaymentMethod = SetupTestData.createZuoraPaymentMethod(bAccount.Id, 'Active', 'Paypal', '4111111111111111', 'Visa', 'Test Test', String.valueOf(System.Today().month()), String.valueOf(System.Today().year()), '123', 'Success');
        zPaymentMethod.Zuora__DefaultPaymentMethod__c = true;
        update zPaymentMethod;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockPaypalFailureResponse());
        System.runAs(oUser)
        { 
            ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
            System.assertEquals('PayPal', oChangePaymentMethodController.currentPaymentMethod);
            System.assertEquals(true, oChangePaymentMethodController.showCC);
            System.assertEquals(true, oChangePaymentMethodController.showDD);
            System.assertEquals(true, oChangePaymentMethodController.showPP);
            oChangePaymentMethodController.showMessage('test');
            System.assertEquals('test', oChangePaymentMethodController.strMessage);
            PageReference oPgf = oChangePaymentMethodController.onCancelOperation();
            System.assertEquals('/MyAccount', oPgf.getURL());
        }
        Test.stopTest();
    }
    
    static testMethod void testCurrentPaymentMethodDDNOption(){
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        //PaymentMethodOptionConfig__c oPaymentMethodConfig = SetUpTestData.testCreatePaymentMethodOptionConfiguration('United Kingdom', 'GB', true, true, true, 'test', 'test', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Gateway', 'DirectDebit','Batch3'); 
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm5testemail@email.com','Active Grace');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'pm5testemail@email.com', 'pm5testemail@email.com', 'tstals5','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'TESTCPM75', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        Zuora__PaymentMethod__c zPaymentMethod = SetupTestData.createZuoraPaymentMethod(bAccount.Id, 'Active', 'BankTransfer', '4111111111111111', 'Visa', 'Test Test', String.valueOf(System.Today().month()), String.valueOf(System.Today().year()), '123', 'Success');
        zPaymentMethod.Zuora__DefaultPaymentMethod__c = true;
        update zPaymentMethod;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockPaypalFailureResponse());
        System.runAs(oUser)
        { 
            ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
            System.assertEquals('BankTransfer', oChangePaymentMethodController.currentPaymentMethod);
            System.assertEquals(true, oChangePaymentMethodController.showCC);
            System.assertEquals(true, oChangePaymentMethodController.showDD);
            System.assertEquals(true, oChangePaymentMethodController.showPP);
        }
        Test.stopTest();
    }
    
    /* static testMethod void testMonthsNYearList(){
//SetUpTestData.triggerSettings();
//SetUpTestData.emailCustsett();
Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm6testemail@email.com','Free Trial');
User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'pm6testemail@email.com', 'pm6testemail@email.com', 'tstals6','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
System.assertNotEquals(null, oUser.Id);
Test.startTest();
System.runAs(oUser){ 
ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
oChangePaymentMethodController.getMonths();
oChangePaymentMethodController.getYears();
}
Test.stopTest();

}
*/
    
    static testmethod void testUserNavigationWithPartialStatus()
    { 
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm7testemail@email.com','Partial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'pm7testemail@email.com', 'pm7testemail@email.com', 'tstals7','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'TESTCPM76', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Test.StartTest();
        System.RunAs(oUser){
            ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
            PageReference oPgf = oChangePaymentMethodController.navigateUser();
            //System.assertEquals('/LoginPageURL', oPgf.getURL());
        }
        Test.stopTest();
    }
    
    static testmethod void testUserNavigationWithCancelledSubscription()
    {
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm8testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'pm8testemail@email.com', 'pm8testemail@email.com', 'tstals8','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'TESTCPM77', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Cancelled', System.today(), system.today()+30);
        Test.StartTest();
        System.RunAs(oUser){
            ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
            PageReference oPgf = oChangePaymentMethodController.navigateUser();
            System.assertEquals('/MyAccount', oPgf.getURL());
        }
        Test.stopTest();
    }
    
    /* Testing page navigations*/
    static testMethod void testBanner(){
        //SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm9testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'pm9testemail@email.com', 'pm9testemail@email.com', 'tstals9','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        System.assertNotEquals(null, oUser.Id);
        System.RunAs(oUser){
            Test.StartTest();
            ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
            PageReference pageRef1 = Page.ChangePaymentMethod;
            Test.setCurrentPage(pageRef1);
            ApexPages.currentPage().getParameters().put('token','testtest');
            Apexpages.currentpage().getParameters().put('success', 'false');
            Test.stopTest();
        }
    }
    
    /* For Credit Card with status false*/
    
    static testmethod void testCreditCardPayment()
    { 
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm2testemail@email.com','Free Trial');
        SetUpTestData.createCommunityUser(oAccount.Id, 'pm2testemail@email.com', 'pm1testemail@email.com', 'tstals2','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        //SetUpTestData.testCreatePaymentMethodOptionConfiguration('United Kingdom', 'GB', true, false, false, 'S6ML4UB9N2QZCXYG', 'ALi8-v7bG.erpzNN6gL-NuQBIpX4AShyB5NtMjlYJR7SQSvWef2hVaTs', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Adyen', 'CreditCard','Batch5'); 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockPaypalFailureResponse());
        User oUser = [Select ID,CountryCode from User where Email='pm2testemail@email.com' limit 1];   
        System.assertNotEquals(null, oUser.Id);
        System.runAs(oUser)
        { 
            
            // PaypalCancelUrlController oPaypalCancelUrlController = new PaypalCancelUrlController();         
            PageReference pageRef = Page.ChangePaymentMethod;
            pageRef.getParameters().put('token','test');
            pageRef.getParameters().put('success','false');
            pageRef.getParameters().put('errorcode','invalidcountry');
            pageRef.getParameters().put('field_passthrough2','CreditCard');
            pageRef.getParameters().put('errorMessage','https://lsdev-lsdev.cs80.force.com/livesport/changepaymentmethod?success=false&errorCode=GatewayTransactionError&errorMessage=Transaction%20declined.Refused%20-%20FRAUD&field_passthrough2=CreditCard&field'); 
            Test.setCurrentPage(pageRef);
            //ChangePaymentMethodController oChangePaymentMethodControllerFailure = new ChangePaymentMethodController();
            ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
            oChangePaymentMethodController.strPmtMode='CreditCard';            
            oChangePaymentMethodController.showBanner();
        }
        Test.stopTest();
    }
    /* For card type is Debit Card with status false */
    
    static testmethod void testDebitCardPayment()
    {
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm2testemail@email.com','Free Trial');
        SetUpTestData.createCommunityUser(oAccount.Id, 'pm2testemail@email.com', 'pm1testemail@email.com', 'tstals2','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        // SetUpTestData.testCreatePaymentMethodOptionConfiguration('United Kingdom', 'GB', true, false, false, 'S6ML4UB9N2QZCXYG', 'ALi8-v7bG.erpzNN6gL-NuQBIpX4AShyB5NtMjlYJR7SQSvWef2hVaTs', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Adyen', 'CreditCard','Batch5'); 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockPaypalFailureResponse());
        User oUser = [Select ID,CountryCode from User where Email='pm2testemail@email.com' limit 1]; 
        System.assertNotEquals(null, oUser.Id);
        System.runAs(oUser)
        { 
            
            //PaypalCancelUrlController oPaypalCancelUrlController = new PaypalCancelUrlController();         
            PageReference pageRef = Page.ChangePaymentMethod;
            pageRef.getParameters().put('token','test');
            pageRef.getParameters().put('success','false');
            pageRef.getParameters().put('errorcode','invalidcountry');
            pageRef.getParameters().put('field_passthrough2','DirectDebit');
            pageRef.getParameters().put('errorMessage','https://lsdev-lsdev.cs80.force.com/livesport/changepaymentmethod?success=false&errorCode=GatewayTransactionError&errorMessage=Transaction%20declined.Refused%20-%20FRAUD&field_passthrough2=DirectDebit&field'); 
            Test.setCurrentPage(pageRef);
            // ChangePaymentMethodController oChangePaymentMethodControllerFailure = new ChangePaymentMethodController();
            ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
            oChangePaymentMethodController.strPmtMode='DirectDebit';            
            oChangePaymentMethodController.showBanner();  
        }
        Test.stopTest();
    }
    /* For error code is invalid country and payment mode is paypal */
    
    static testmethod void testErrorCodeInvalidCountry()
    {
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm2testemail@email.com','Free Trial');
        SetUpTestData.createCommunityUser(oAccount.Id, 'pm2testemail@email.com', 'pm1testemail@email.com', 'tstals2','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        //SetUpTestData.testCreatePaymentMethodOptionConfiguration('United Kingdom', 'GB', true, false, false, 'S6ML4UB9N2QZCXYG', 'ALi8-v7bG.erpzNN6gL-NuQBIpX4AShyB5NtMjlYJR7SQSvWef2hVaTs', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Adyen', 'CreditCard','Batch5'); 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockPaypalFailureResponse());
        User oUser = [Select ID,CountryCode from User where Email='pm2testemail@email.com' limit 1];
        System.assertNotEquals(null, oUser.Id);
        System.runAs(oUser)
        { 
            
            PageReference pageRef = Page.ChangePaymentMethod;
            pageRef.getParameters().put('token','test');
            pageRef.getParameters().put('success','false');
            pageRef.getParameters().put('errorcode','invalidcountry');
            pageRef.getParameters().put('field_passthrough2','Paypal');
            pageRef.getParameters().put('errorMessage','https://lsdev-lsdev.cs80.force.com/livesport/changepaymentmethod?success=false&errorCode=GatewayTransactionError&errorMessage=Transaction%20declined.Refused%20-%20FRAUD&field_passthrough2=DirectDebit&field'); 
            Test.setCurrentPage(pageRef);
            ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
            oChangePaymentMethodController.strPmtMode='Paypal';            
            oChangePaymentMethodController.showBanner();
            
        }
        Test.stopTest();
    }
    
    
    /* For payment failure task */
    
    static testmethod void testpaymentFailureTask()
    {
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm2testemail@email.com','Free Trial');
        system.assertnotequals(oAccount ,null);
        oAccount.Retrieve_Email__c = 'TestFirstName' + '-' + 'TestLastName' + '-' + '1111';
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'pm2testemail@email.com', 'pm1testemail@email.com', 'tstals2','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        system.assertnotequals(oAccount.Id,null);
        //SetUpTestData.testCreatePaymentMethodOptionConfiguration('United Kingdom', 'GB', true, false, false, 'S6ML4UB9N2QZCXYG', 'ALi8-v7bG.erpzNN6gL-NuQBIpX4AShyB5NtMjlYJR7SQSvWef2hVaTs', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Adyen', 'CreditCard','Batch5'); 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockPaypalFailureResponse());
        //User oUser = [Select ID,CountryCode from User where Email='pm2testemail@email.com' limit 1];
        System.assertNotEquals(null, oUser.Id);
        System.runAs(oUser)
        { 
            
            // PaypalCancelUrlController oPaypalCancelUrlController = new PaypalCancelUrlController();         
            PageReference pageRef = Page.ChangePaymentMethod;
            pageRef.getParameters().put('token','test');
            pageRef.getParameters().put('success','true');
            pageRef.getParameters().put('errorcode','invalidcountry');
            pageRef.getParameters().put('field_passthrough2','CreditCard');
            pageRef.getParameters().put('field_passthrough3','Visa');
            pageRef.getParameters().put('field_passthrough4','4644'); 
            pageRef.getParameters().put('errorMessage','https://lsdev-lsdev.cs80.force.com/livesport/changepaymentmethod?success=false&errorCode=GatewayTransactionError,errorMessage=Transaction%20declined.Refused%20-%20,field_passthrough2=CreditCard,field_passthrough1=2c92c0f85599d51a01559ba83e880dcb,field_passthrough4=4644,field_passthrough3=Visa'); 
            Test.setCurrentPage(pageRef);
            //ChangePaymentMethodController oChangePaymentMethodControllerFailure = new ChangePaymentMethodController();
            ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
            oChangePaymentMethodController.strPmtMode='CreditCard';            
            oChangePaymentMethodController.createTaskOnPaymentMethodOperation();

            Account oAccountAfterUpdate = [Select Id, Retrieve_Email__c From Account Where Id = :oAccount.Id];
            System.assertEquals('TestFirstName-TestLastName-4644', oAccountAfterUpdate.Retrieve_Email__c);

            oChangePaymentMethodController.sendUserPaymentMethodUpdateNotification();
            oChangePaymentMethodController.sBTFNErrMsg = 'Test';
            oChangePaymentMethodController.sCCNumErrMsg = 'Test';
            oChangePaymentMethodController.sCCEMErrMsg = 'Test';
            oChangePaymentMethodController.sCCEYErrMsg = 'Test';
            oChangePaymentMethodController.sCCCVCErrMsg = 'Test';
            oChangePaymentMethodController.sBTFNErrMsg = 'Test';
            oChangePaymentMethodController.sCCEMErrMsg = 'Test';
            oChangePaymentMethodController.sBTSNErrMsg = 'Test';
            oChangePaymentMethodController.sBTBANumErrMsg = 'Test';
            oChangePaymentMethodController.zuoraAccountId = 'Test';
            oChangePaymentMethodController.sCCHolderNameErrMsg = 'Test';
            ChangePaymentMethodController.ZuoraPageResponse testCPaymentMethodCtrl = new ChangePaymentMethodController.ZuoraPageResponse();
            testCPaymentMethodCtrl.signature = 'Test';
            testCPaymentMethodCtrl.token = 'Test';
            testCPaymentMethodCtrl.tenantId = 'Test';
            testCPaymentMethodCtrl.key = 'Test';
            testCPaymentMethodCtrl.success = 'Test';
        }
        Test.stopTest();
    }   
    static testmethod void testcreateTaskOnPaymentMethodOperation()
    {
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm2testemail@email.com','Free Trial');
        system.assertnotequals(oAccount ,null);
        SetUpTestData.createCommunityUser(oAccount.Id, 'pm2testemail@email.com', 'pm1testemail@email.com', 'tstals2','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        system.assertnotequals(oAccount.Id,null);
        //SetUpTestData.testCreatePaymentMethodOptionConfiguration('United Kingdom', 'GB', true, false, false, 'S6ML4UB9N2QZCXYG', 'ALi8-v7bG.erpzNN6gL-NuQBIpX4AShyB5NtMjlYJR7SQSvWef2hVaTs', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Adyen', 'CreditCard','Batch5'); 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockPaypalFailureResponse());
        User oUser = [Select ID,CountryCode from User where Email='pm2testemail@email.com' limit 1];
        System.assertNotEquals(null, oUser.Id);
        System.runAs(oUser)
        { 
            
            // PaypalCancelUrlController oPaypalCancelUrlController = new PaypalCancelUrlController();         
            PageReference pageRef = Page.ChangePaymentMethod;
            pageRef.getParameters().put('token','test');
            pageRef.getParameters().put('success','false');
            pageRef.getParameters().put('errorcode','invalidcountry');
            pageRef.getParameters().put('field_passthrough2','CreditCard');
            pageRef.getParameters().put('field_passthrough3','Visa');
            pageRef.getParameters().put('field_passthrough4','4644'); 
            pageRef.getParameters().put('errorMessage','https://lsdev-lsdev.cs80.force.com/livesport/changepaymentmethod?success=false&errorCode=GatewayTransactionError,errorMessage=Transaction%20declined.Refused%20-%20,field_passthrough2=CreditCard,field_passthrough1=2c92c0f85599d51a01559ba83e880dcb,field_passthrough4=4644,field_passthrough3=Visa'); 
            Test.setCurrentPage(pageRef);
            //ChangePaymentMethodController oChangePaymentMethodControllerFailure = new ChangePaymentMethodController();
            ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
            oChangePaymentMethodController.strPmtMode='CreditCard';            
            oChangePaymentMethodController.createTaskOnPaymentMethodOperation();   
        }
        Test.stopTest();
    }   
    static testMethod void testPaymentMethodCCNOption(){
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        //PaymentMethodOptionConfig__c oPaymentMethodConfig = SetUpTestData.testCreatePaymentMethodOptionConfiguration('United Kingdom', 'GB', true, true, false, 'test', 'test', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Gateway', 'CreditCard','Batch3'); 
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm44testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'pm44testemail@email.com', 'pm44testemail@email.com', 'tstals3','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        Zuora__PaymentMethod__c zPaymentMethod = SetupTestData.createZuoraPaymentMethod(bAccount.Id, 'Active', 'CreditCard', '4111111111111111', 'Visa', 'Test Test', '1', String.valueOf(System.Today().year()), '123', 'Success');
        zPaymentMethod.Zuora__DefaultPaymentMethod__c = true;
        update zPaymentMethod;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockPaypalFailureResponse());
        System.runAs(oUser)
        { 
            ChangePaymentMethodController oChangePaymentMethodController = new ChangePaymentMethodController();
            System.assertEquals('CreditCard', oChangePaymentMethodController.currentPaymentMethod);
            System.assertEquals(true, oChangePaymentMethodController.showCC);
            System.assertEquals(true, oChangePaymentMethodController.showDD);
            System.assertEquals(true, oChangePaymentMethodController.showPP);
            oChangePaymentMethodController.showMessage('test');
            System.assertEquals('test', oChangePaymentMethodController.strMessage);
            PageReference oPgf = oChangePaymentMethodController.onCancelOperation();
            System.assertEquals('/MyAccount', oPgf.getURL());
        }
        Test.stopTest();
    }
    
}