@isTest
private class NextChargeDateSectionControllerTest {
    
    @isTest 
    static void testNextChargeDateSection() {
        TriggerSetting__c triggerSet1 = new TriggerSetting__c(name ='BillingAccountTrigger', Disable__c = false);
        insert triggerSet1;
        TriggerSetting__c triggerSet2 = new TriggerSetting__c(name ='UpdateAccountTrigger', Disable__c = false);
        insert triggerSet2;
        TriggerSetting__c triggerSet3 = new TriggerSetting__c(name ='SubscriptionTrigger', Disable__c = false);
        insert triggerSet3;
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Cancelled', System.today(), system.today() + 30);
        zSubsp.Zuora__SubscriptionEndDate__c = system.today() + 2;
        update zSubsp;
        
        PageReference nextChargeDateSectionPage = Page.NextChargeDateSection;
        Test.setCurrentPage(nextChargeDateSectionPage);
        Test.startTest();
            NextChargeDateSectionController controller = new NextChargeDateSectionController(new ApexPages.StandardController(oAccount));
            System.assertEquals(true, controller.nextChargeDateString != null);
        Test.stopTest();
    }

    @isTest 
    static void testNextChargeDatePausedSection() {
        TriggerSetting__c triggerSet1 = new TriggerSetting__c(name ='BillingAccountTrigger', Disable__c = false);
        insert triggerSet1;
        TriggerSetting__c triggerSet2 = new TriggerSetting__c(name ='UpdateAccountTrigger', Disable__c = false);
        insert triggerSet2;
        TriggerSetting__c triggerSet3 = new TriggerSetting__c(name ='SubscriptionTrigger', Disable__c = false);
        insert triggerSet3;
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.Account_Status__c = 'Paused';
        oAccount.Pause_From__c = Date.today() - 1;
        oAccount.Pause_Until__c = Date.today() + 1;
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Cancelled', System.today(), system.today() + 30);
        zSubsp.Zuora__SubscriptionEndDate__c = system.today() + 2;
        update zSubsp;
        
        PageReference nextChargeDateSectionPage = Page.NextChargeDateSection;
        Test.setCurrentPage(nextChargeDateSectionPage);
        Test.startTest();
            NextChargeDateSectionController controller = new NextChargeDateSectionController(new ApexPages.StandardController(oAccount));
            DateTime dt = Date.today() + 1;
            System.assertEquals(dt.format('dd/MM/yyyy'), controller.nextChargeDateString);
        Test.stopTest();
    }
    
}