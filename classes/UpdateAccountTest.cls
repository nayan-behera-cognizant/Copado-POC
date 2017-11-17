// This test class will cover the code coverage for UpdateAccount
/*Added Assert statements as per PD-7938*/

@isTest
public class UpdateAccountTest{
    static testMethod void unitTest() {
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
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        System.assertNotEquals(null, oAccount.Id);
        System.debug('oAccount.Id**' + oAccount.Id);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        bAccount.Zuora__Zuora_Id__c = 'AA12345';
        update bAccount;
        System.assertEquals('AA12345', bAccount.Zuora__Zuora_Id__c);
        
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Cancelled', System.today(), system.today()+30);
        zSubsp.Zuora__Status__c = 'Active';
        update zSubsp;
        Zuora__ZInvoice__c zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 10.00);
        
        String zuoraCalloutString = '<?xml version="1.0"?><callout><parameter name="AccountID"></parameter></callout>';
        
        Map<String,String> attribute = new Map<String,String>();
        attribute.put('AccountID', 'test');
        
        Test.StartTest();
        
        //Account objAcct = [Select Id From Account Limit 1];
        UpdateAccount obj = new UpdateAccount();
        obj.processSuccessfulPayment(bAccount.Zuora__Zuora_Id__c);
        obj.processFirstTrial(bAccount.Zuora__Zuora_Id__c);
        obj.getFirstTrial(bAccount.Zuora__Zuora_Id__c);
        obj.isProcessSuccessPaymentNeeded(bAccount.Zuora__Zuora_Id__c);
        obj.setFirstTrial(bAccount.Zuora__Zuora_Id__c,true);
        String result = obj.performImmediateCancellation(bAccount.Zuora__Zuora_Id__c);
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id, bAccount.Id, zInv.Id, 0.00);
        result = obj.performImmediateCancellation(bAccount.Zuora__Zuora_Id__c);
        zPay.Zuora__SettledOn__c = DateTime.now();
        update zPay;
        result = obj.performImmediateCancellation(bAccount.Zuora__Zuora_Id__c);
        delete zSubsp;
        result = obj.performImmediateCancellation(bAccount.Zuora__Zuora_Id__c);
        obj.setSuccessfulPayment(bAccount.Zuora__Zuora_Id__c,true);
        obj.getAccountId(zuoraCalloutString);
        obj.getValuesFromRequestXML(attribute, zuoraCalloutString);
        obj.TransitionAccountToFrozen(bAccount.Zuora__Zuora_Id__c);//Pd-10617
        oAccount.Account_Status__c = 'Active Grace';
        oAccount.Hard_Offer_Date__c = DateTime.now();
        update oAccount;
        obj.isProcessSuccessPaymentNeeded(bAccount.Zuora__Zuora_Id__c);
        obj.createPaymentSuccessfulEmailQueueRecords(bAccount.Zuora__Zuora_Id__c);
        oAccount.Account_Status__c = 'Active Grace';
        update oAccount;
        obj.createPaymentSuccessfulEmailQueueRecords(bAccount.Zuora__Zuora_Id__c);
        System.assertEquals(true, [SELECT Id FROM Email_Sync_Queue__c WHERE Dispatch_ID__c = 12345 AND Account__c =: oAccount.Id].size() > 0);
        result = obj.performImmediateCancellation(bAccount.Zuora__Zuora_Id__c);
        delete bAccount;
        result = obj.performImmediateCancellation(bAccount.Zuora__Zuora_Id__c);
        System.assertEquals(false, obj.isProcessSuccessPaymentNeeded(bAccount.Zuora__Zuora_Id__c));
        System.assertEquals(false, obj.getFirstTrial(bAccount.Zuora__Zuora_Id__c));
        Test.StopTest();
    }
    
    static testMethod void unitTest2() {
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
        
        List<DAZNConfiguration__c> config = new List<DAZNConfiguration__c>();
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraImmediateCancelUrl',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/553/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseUsername',
            Value__c = 't1'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPausePassword',
            Value__c = 't2'
        ));
        insert config;
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        System.assertNotEquals(null, oAccount.Id);
        System.debug('oAccount.Id**' + oAccount.Id);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        bAccount.Zuora__Zuora_Id__c = 'AA12345';
        update bAccount;
        
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Cancelled', System.today(), system.today()+30);
        zSubsp.Zuora__Status__c = 'Active';
        update zSubsp;
        Zuora__ZInvoice__c zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 10.00);
        
        String zuoraCalloutString = '<?xml version="1.0"?><callout><parameter name="AccountID"></parameter></callout>';
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockImmediateFromFinalFailResponse());
        UpdateAccount obj = new UpdateAccount();
        String result = obj.performImmediateCancellation(bAccount.Zuora__Zuora_Id__c);
        System.assertEquals('Success', result);
        Test.StopTest();
    }
    
    static testMethod void catchException(){
        String zuoraCalloutString = 'Test Data';
        Map<String,String> attribute = new Map<String,String>();
        attribute.put('test', 'test');
        
        UpdateAccount obj = new UpdateAccount();
        obj.getAccountId(zuoraCalloutString);
        obj.getValuesFromRequestXML(attribute, zuoraCalloutString);
    }
    
    static testMethod void accountFreeTrialStartDateUpdateTest() {
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
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.Account_Status__c = 'Partial';
        update oAccount;
        Test.StartTest();
            oAccount.Account_Status__c = 'Free Trial';
            update oAccount;
        Test.StopTest();
        List<Account> freeTrialAccounts = [SELECT Id, Free_Trial_Start_Date__c FROM Account WHERE Id =:oAccount.Id];
        System.assertEquals(true, freeTrialAccounts[0].Free_Trial_Start_Date__c != null);
    }
    
    public class MockImmediateFromFinalFailResponse implements HttpCalloutMock {
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

}