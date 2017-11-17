@isTest(seeAllData = true)
private class MyAccountControllerTestZuora {
    
    static testMethod void testGetSFDCSubscriptionDescription() {
        //SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'tqewtretrewtet@test.com', 'Active');
        
        Zuora.zObject sub = new Zuora.zObject('Subscription');
        sub.setValue('Id', '2c92c0f857ffa66201580b8d775358ad');
        sub.setValue('OriginalId', '2c92c0f857ffa66201580b8d775358ae');
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD', '1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Test Zuora', 'Active', System.today(), System.today() + 30);

        Test.startTest();
        String subscriptionDescription = MyAccountController.getSFDCSubscriptionDescription(
            'scenario',
            '[Zuora__NextChargeDate__c][Zuora__Price__c][Free_Trial_End_Date__c][Gift_Code_End_Date__c][Zuora__SubscriptionEndDate__c]',
            zSubsp,
            oAccount,
            'sCurrency'
        );
        Test.stopTest();

        System.assertNotEquals(null, subscriptionDescription);
    }

    static testMethod void testGetSFDCSubscriptionDescriptionScenario() {
        //SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'dfgdfsgdfgsd@test.com', 'Active');
        
        Zuora.zObject sub = new Zuora.zObject('Subscription');
        sub.setValue('Id', '2c92c0f857ffa66201580b8d775358ad');
        sub.setValue('OriginalId', '2c92c0f857ffa66201580b8d775358ae');
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD', '1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Test Zuora', 'Active', System.today(), System.today() + 30);

        Test.startTest();
        String subscriptionDescription = MyAccountController.getSFDCSubscriptionDescription(
            'Active PaidNOT blankActiveEVERGREEN',
            '[Zuora__NextChargeDate__c][Zuora__Price__c][Free_Trial_End_Date__c][Gift_Code_End_Date__c][Zuora__SubscriptionEndDate__c]',
            zSubsp,
            oAccount,
            'sCurrency'
        );
        Test.stopTest();

        System.assertNotEquals(null, subscriptionDescription);
    }

    

    static testMethod void testActivePaidShowResubscribe() {
        //SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'hjkhjkhjkghkhj@test.com', 'Active');
        //Nayan
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);         
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD', '1st of the month');
        Zuora.zObject sub = new Zuora.zObject('Subscription');
        sub.setValue('Id', '2c92c0f857ffa66201580b8d775358ad');
        sub.setValue('OriginalId', '2c92c0f857ffa66201580b8d775358ae');
        sub.setValue('Status', 'Cancelled');
        System.runAs(oUser){
            Test.startTest();
            MyAccountController ctrl = new MyAccountController();
            ctrl.lstCustomerAccount = new List<Zuora__CustomerAccount__c>{ bAccount };
            ctrl.sBannerName = 'cancellation';
            ctrl.activePaid();
            Test.stopTest();    
        }
        
    }

    

    static testMethod void testFreeTrialShowResubscribe() {
        //SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'fdhdgfhrethxcgbn@test.com', 'Active');
        //Nayan
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);         
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD', '1st of the month');
        

        Zuora.zObject sub = new Zuora.zObject('Subscription');
        sub.setValue('Id', '2c92c0f857ffa66201580b8d775358ad');
        sub.setValue('OriginalId', '2c92c0f857ffa66201580b8d775358ae');
        sub.setValue('Status', 'Cancelled');
        System.runAs(oUser){
            Test.startTest();
            MyAccountController ctrl = new MyAccountController();
            
            ctrl.lstCustomerAccount = new List<Zuora__CustomerAccount__c>{ bAccount };
            ctrl.sBannerName = 'cancellation';
            ctrl.freeTrial();
            Test.stopTest();    
        }
        
    }
    
    
     static testMethod void testGetSFDCSubscriptionDescriptionchargeDtNull() {
        //SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'dfgdfsgdfgsd@test.com', 'Active');
        
        Zuora.zObject sub = new Zuora.zObject('Subscription');
        sub.setValue('Id', '2c92c0f857ffa66201580b8d775358ad');
        sub.setValue('OriginalId', '2c92c0f857ffa66201580b8d775358ae');
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD', '1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Test Zuora', 'Active', null, null);

        Test.startTest();
        String subscriptionDescription = MyAccountController.getSFDCSubscriptionDescription(
            'scenario',
            '[Zuora__NextChargeDate__c][Zuora__Price__c][Free_Trial_End_Date__c][Gift_Code_End_Date__c][Zuora__SubscriptionEndDate__c]',
            zSubsp,
            oAccount,
            'sCurrency'
        );
        Test.stopTest();

        System.assertNotEquals(null, subscriptionDescription);
    }
}