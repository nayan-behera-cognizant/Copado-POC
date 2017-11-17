/**
* @author Cognizant Technology Solutuions
* @date 24/04/2017
* @description Test class to cover paymentRelListController functionality.
*/

@isTest 
public class paymentRelListControllerTest{
    static testMethod void testHandleDelProcess() {
        SetUpTestData.triggerSettings();
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');    
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 10.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 10.00);
        // Query your permission set name from Organization that your want to test.
        User us = [SELECT Id FROM User WHERE AccountId = :oAccount.Id LIMIT 1];
        System.runAs(us) {

            ApexPages.StandardController sc = new ApexPages.StandardController(oAccount);
            paymentRelListController testAccPlan = new paymentRelListController(sc);  
            Test.setCurrentPageReference(new PageReference('Page.PaymentRelList')); 
            System.currentPageReference().getParameters().put('id', oAccount.id); 
            testAccPlan.PayDelId = zPay.id;
            testAccPlan.PayEditId = zPay.id;
            testAccPlan.refundProcess();
            testAccPlan.editdelProcess();
            List<Zuora__Payment__c> paymentAfterDel = [SELECT Id FROM Zuora__Payment__c ];
            System.assert(!paymentAfterDel.isEmpty());
              
        }
        
    }

    static testMethod void testHandleRefundProcess() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');    
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 10.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 10.00);
        
        System.runAs(oUser){
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(oAccount);
            paymentRelListController testAccPlan = new paymentRelListController(sc);  
            Test.setCurrentPageReference(new PageReference('Page.PaymentRelList')); 
            List<Zuora__Refund__c> refundBefore = [SELECT ID FROM Zuora__Refund__c];
            System.currentPageReference().getParameters().put('id', oAccount.id); 
            testAccPlan.PayRecId =zPay.id;
            testAccPlan.choosePaymentId = zPay.Id;

            testAccPlan.refundProcess();     
            List<ApexPages.Message> msgList = ApexPages.getMessages();

            for(ApexPages.Message msg :  ApexPages.getMessages()) {
                System.assertEquals(Label.LS_Refund_processed, msg.getSummary());
            }
            Test.stopTest();        
        }
        
    }
    
    static testMethod void testHandleRefundProcessWithFalse() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        User  cSTeamMember  =SetUpTestData.createCustomerServicesShiftLeaderUser(oAccount.Id, 'pm3testemail@emailOne.com', 'pm3testemailOne@email.com', 'tstals3','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');    

        SetUpTestData.createZuoraInvoicesAndPayments(oAccount.Id, bAccount.Id, 10.00, 10.00);
        Zuora__Payment__c zPay = [SELECT Id FROM Zuora__Payment__c LIMIT 1];

        System.runAs(cSTeamMember){
            ApexPages.StandardController sc = new ApexPages.StandardController(oAccount);
            paymentRelListController testAccPlan = new paymentRelListController(sc);  
            Test.setCurrentPageReference(new PageReference('Page.PaymentRelList')); 
            System.currentPageReference().getParameters().put('id', oAccount.id); 
            testAccPlan.PayRecId =zPay.id;
            testAccPlan.refundProcess();
            for(ApexPages.Message msg :  ApexPages.getMessages()) {
                System.assertEquals(Label.LS_Refund_processed, msg.getSummary());
            }              
        }
        
    }

    static testMethod void testHandleRefundProcessWithRefund() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');    
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 10.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 10.00);

        Zuora__Refund__c oZuoraRefund = SetUpTestData.createZuoraRefund(oAccount.Id,bAccount.Id,'External','Payment Reversal',1000.00);
            oZuoraRefund.Zuora__Payment__c = zPay.Id;  
            oZuoraRefund.Zuora__RefundDate__c = Date.today().addDays(-5);
        update oZuoraRefund;
        
        System.runAs(oUser){
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(oAccount);
            paymentRelListController testAccPlan = new paymentRelListController(sc);  
            Test.setCurrentPageReference(new PageReference('Page.PaymentRelList')); 
            List<Zuora__Refund__c> refundBefore = [SELECT ID FROM Zuora__Refund__c];
            System.currentPageReference().getParameters().put('id', oAccount.id); 
            testAccPlan.PayRecId =zPay.id;
            testAccPlan.choosePaymentId = zPay.Id;

            testAccPlan.refundProcess();     
            List<ApexPages.Message> msgList = ApexPages.getMessages();

            for(ApexPages.Message msg :  ApexPages.getMessages()) {
                System.assertEquals(Label.LS_Refund_Refund_not_possible, msg.getSummary());
            }
            Test.stopTest();        
        }
    }

    static testMethod void testRefreshPage() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');    
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 10.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 10.00);

        System.runAs(oUser){
            Test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(oAccount);
                paymentRelListController testAccPlan = new paymentRelListController(sc);  
                Test.setCurrentPageReference(new PageReference('Page.PaymentRelList')); 
                testAccPlan.refreshPage();
                System.assert(testAccPlan.isShowTable == true);
            Test.stopTest();        
        }
    }
}