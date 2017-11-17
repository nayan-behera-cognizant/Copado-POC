@isTest
private class RefundTransactionControllerTest {
    
    @isTest 
    static void testRefundTransaction() {
        SetUpTestData.triggerSettings();
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');    
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 10.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 10.00);
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagentyguihgkjhg@email.com', 'testcsagentkjgfj@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);

        Test.startTest();
        System.runAs(oCSUser) {
            System.assertNotEquals(RefundTransactionController.refundTransaction(zPay.Id), 'not');
        }
        Test.stopTest();
    }

    @isTest 
    static void testCheckPaymentList() {
        SetUpTestData.triggerSettings();

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemailrecomanded@email.com', 'testemailrecomanded@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');    
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 10.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 10.00);
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent123@email.com', 'testcsagent123@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);


        Test.startTest();
        System.runAs(oCSUser) {
            Map<Id,Zuora__Payment__c> checkPaymentList = RefundTransactionController.checkPaymentList(new List<Zuora__Payment__c>{zPay});
            System.assert(checkPaymentList.size() > 0);
        }
        Test.stopTest();
    }

    @isTest 
    static void testCheckPaymentListRefund() {
        SetUpTestData.triggerSettings();
        
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');    
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 10.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 10.00);
        Zuora__Refund__c oZuoraRefund = SetUpTestData.createRefund (oAccount.Id, bAccount.Id, zPay.Id);

        Test.startTest();
            System.runAs(oCSUser) {
                Map<Id,Zuora__Payment__c> checkPaymentList = RefundTransactionController.checkPaymentList(new List<Zuora__Payment__c>{zPay});
                System.assert(checkPaymentList.isEmpty());
            }
        Test.stopTest();
    }

    @isTest
    static void testIsAccessToRefund() {
                
        SetUpTestData.triggerSettings();
        
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        
        
        System.runAs(oCSUser) {
            Test.startTest();
            PermissionSet pr = new PermissionSet(Name = 'Refund_TransactionTest', Label = 'Refund_TransactionTest');
            insert pr;
            insert new PermissionSetAssignment(AssigneeId=oCSUser.Id, PermissionSetId=pr.Id);
            Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
            User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
            
            
                Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');    
                Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 10.00 );
                Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 10.00);
                Boolean isResult = RefundTransactionController.isAccessToRefund();
                System.assertEquals(isResult, true);

            Test.stopTest();
        }
    }
    @isTest
    static void testIsAccessToRefundWeb() {
        
        SetUpTestData.triggerSettings();
        
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        
        
        System.runAs(oCSUser) {
            PermissionSet pr = new PermissionSet(Name = 'Refund_TransactionTest', Label = 'Refund_TransactionTest');
            insert pr;
            insert new PermissionSetAssignment(AssigneeId=oCSUser.Id, PermissionSetId=pr.Id);
            Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
            User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
            
            Test.startTest();
                Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');    
                Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 10.00 );
                Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 10.00);
                Boolean isResult = RefundTransactionController.isAccessToRefundWeb();
                System.assertEquals(isResult, true);
            Test.stopTest();
        }
    }
}