@isTest
public class StandardCancelTest{

    @testSetUp
    public static void CreateCustomSetting(){
        //Create Custom setting record for trigger setting
        TriggerSetting__c triggerSet1 = new TriggerSetting__c(name ='BillingAccountTrigger', Disable__c = false);
        insert triggerSet1;
        TriggerSetting__c triggerSet2 = new TriggerSetting__c(name ='UpdateAccountTrigger', Disable__c = false);
        insert triggerSet2;
        TriggerSetting__c triggerSet3 = new TriggerSetting__c(name ='SubscriptionTrigger', Disable__c = false);
        insert triggerSet3;
        //Create Custom setting record for Pause email setting
        Pause_Email_Service_Setting__c pauseEmailSetting1 = new Pause_Email_Service_Setting__c(name ='FlowCancelPause', Dispatch_ID__c = 5336309);
        insert pauseEmailSetting1;
        Pause_Email_Service_Setting__c pauseEmailSetting2 = new Pause_Email_Service_Setting__c(name ='FlowEarlyResume', Dispatch_ID__c = 5336383);
        insert pauseEmailSetting2;
        Pause_Email_Service_Setting__c pauseEmailSetting3 = new Pause_Email_Service_Setting__c(name ='FlowEdit/SetPause', Dispatch_ID__c = 5336253);
        insert pauseEmailSetting3;
        Pause_Email_Service_Setting__c pauseEmailSetting4 = new Pause_Email_Service_Setting__c(name ='FlowChangeResumePause', Dispatch_ID__c = 5336350);
        insert pauseEmailSetting4;
    }

    public static testMethod void testStandardCancelWorkflow() {
        //Create personal account
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testCustomer123@email.com','Active Paid');
        oAccount.Submitted_for_cancellation__c = true;
        update oAccount;
        //Create Billing Account
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        Zuora__Subscription__c subscription = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Zuora__Subscription__c', '', date.today(), date.today().addDays(7));
        List<Zuora__Subscription__c> subscriptions = [SELECT Id, Name FROM Zuora__Subscription__c WHERE Id =: subscription.Id];

        Test.startTest();

        RestRequest req = new RestRequest();
        req.requestURI = '/StandardCancel/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{' +  
               '"Workflow":{' + 
                  '"CancelDate":"2019-08-21",' + 
                  '"ExecutionDate":"2017-07-07",' + 
                  '"SubscriptionName":"' + subscriptions[0].Name + '"' + 
               '},' + 
               '"Amendment":{' + 
                  '"Id":"2c91a0fb5d089283015d1dc0874d12b5",' + 
                  '"Type":"CancelSubscription",' + 
                  '"TotalDeltaMRR":0.0,' + 
                  '"TotalDeltaTCV":0.0' + 
               '},' + 
               '"Subscription":[' + 
                  '{' + 
                     '"Id":"2c91a0fb5d089283015d1dc0875d12ba",' + 
                     '"PreviousSubscriptionId":"2c91a0b35cf2413a015d1c32d7061820"' + 
                  '},' + 
                  '{' + 
                     '"Id":"2c91a0a95cf24d75015d1c301be968c5"' + 
                  '},' + 
                  '{' + 
                     '"Id":"2c91a0fb5cf25476015d1c2ced7c6fbf"' + 
                  '}' + 
               ']' + 
            '}'
        );
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        StandardCancel.handleStandardCancelFromZuoraWorkflow();
        
        String brokenJsonString = '{"AccountCrmId BROKEN JSON - test Failure}';
        req.requestBody = Blob.valueof(brokenJsonString);
        StandardCancel.handleStandardCancelFromZuoraWorkflow();

        Test.stopTest();
    }

}