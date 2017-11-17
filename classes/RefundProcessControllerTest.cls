/**
* @author Cognizant Technology Solutuions
* @date 24/04/2017
* @description Test class to cover RefundProcessController functionality.
*/
@isTest(seeAllData=True)  

public class RefundProcessControllerTest{
  
    static testMethod void testRefundProcess() {
       	 Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName3443','testTwo@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername123@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
        zInv.Zuora__TaxExemptAmount__c = 100.00 ;
        zInv.Zuora__TaxAmount__c = 200.00 ;
        zInv.Zuora__TotalAmount__c = 5100.00;
        update zInv;
        
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
        zPay.Zuora__Status__c = 'Processed';
        zPay.Zuora__SettledOn__c = system.today();
        update zPay;
        
        Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'PayPal', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
        
        
        Zuora__PaymentInvoice__c zPaymentInvoice = SetupTestData.createZuoraPaymentInvoice(zPay.Id, zInv.Id);
        zPaymentInvoice.Zuora__RefundAmount__c = 1000;
        update zPaymentInvoice; 
         system.runAs(oUser){
               Test.setCurrentPageReference(new PageReference('Page.RefundProcessPage')); 
         ApexPages.currentPage().getParameters().put('param1', zPay.id); 
           RefundProcessController testAccPlan = new RefundProcessController();            
          }
        
        }
    
     static testMethod void testRefundProcesssetteledOn() {
       	 Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName123','testone@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 5000.00 );
        zInv.Zuora__TaxExemptAmount__c = 100.00 ;
        zInv.Zuora__TaxAmount__c = 200.00 ;
        zInv.Zuora__TotalAmount__c = 5100.00;
        update zInv;
        
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 5000.00);
        zPay.Zuora__Status__c = 'Processed';
        update zPay;
        
        Zuora__PaymentMethod__c zPaymentMethod = SetUpTestData.createZuoraPaymentMethod(bAccount.Id,'Active', 'PayPal', '************7735', 'Visa', 'TestFirstName TestLastName', '04', '2018', '123456', 'Processed');
        
        
        Zuora__PaymentInvoice__c zPaymentInvoice = SetupTestData.createZuoraPaymentInvoice(zPay.Id, zInv.Id);
        zPaymentInvoice.Zuora__RefundAmount__c = 1000;
        update zPaymentInvoice; 
         system.runAs(oUser){
               Test.setCurrentPageReference(new PageReference('Page.RefundProcessPage')); 
         ApexPages.currentPage().getParameters().put('param1', zPay.id); 
           RefundProcessController testAccPlan = new RefundProcessController();            
          }
        
        }

        }