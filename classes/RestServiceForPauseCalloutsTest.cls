/**
* @ Author : Nayan Behera (Cognizant Technology Solutions)
* @ Date : 13/04/2017
* @ Description : Test classes for Email Service For Pause Callouts
* @ Modified By : Megha Jain
* @ Date : 26/07/2017
**/
@isTest
public class RestServiceForPauseCalloutsTest{
    
    public static Zuora__Subscription__c zSubsr;
   
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
   
    public static testMethod void TestImmediateResumeWorkflow(){   
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testCustomer123@email.com','Active Paid');
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        bAccount.Zuora__Zuora_Id__c= '2c92c0f95774f27501577a7d88b378aa';
        update bAccount ;
  
        String jsonstring='{'+
            '\"Account\":{},'+
            '\"Invoice\":{\"Id\":\"2c91a0f85d089f23015d555e44591bcf\"},'+
            '\"Payment\":{\"Id\":\"2c91a0f85d089f23015d555e449a1bdb\"},'+
            '\"Workflow\":{\"BCD\":18,'+
            '           \"ResumeDate\":\"2017-07-18\",'+
            '           \"ExecutionDate\":\"2017-07-18\",'+
            '           \"SubscriptionName\":\"A-S00398530\"},'+
            '\"Amendment\":[{\"Id\":\"2c91a0fb5cf25476015d555bdc4b6ebe\"},'+
            '           {\"Id\":\"2c91a0f85d089f23015d555e43781bba\",'+
            '\"Type\":\"ResumeSubscription\",'+
            '       \"TotalDeltaMRR\":0.0,'+
            '       \"TotalDeltaTCV\":0.0}],'+
            '\"Subscription\":[{\"Id\":\"2c91a0f85d089f23015d555e43811bbf\",'+
            '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
            '               \"PreviousSubscriptionId\":\"2c91a0f95d089216015d555bd52e0cb8\"}]}';
       
        Test.startTest();
        
        System.assert(jsonstring != null);
        
        RestRequest req = new RestRequest();
        req.requestURI = '/ImmediateResumePause/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{'+
                                       '\"Account\":{},'+
                                       '\"Invoice\":{\"Id\":\"2c91a0f85d089f23015d555e44591bcf\"},'+
                                       '\"Payment\":{\"Id\":\"2c91a0f85d089f23015d555e449a1bdb\"},'+
                                       '\"Workflow\":{\"BCD\":18,'+
                                       '           \"ResumeDate\":\"2017-07-18\",'+
                                       '           \"ExecutionDate\":\"2017-07-18\",'+
                                       '           \"SubscriptionName\":\"A-S00398530\"},'+
                                       '\"Amendment\":[{\"Id\":\"2c91a0fb5cf25476015d555bdc4b6ebe\"},'+
                                       '           {\"Id\":\"2c91a0f85d089f23015d555e43781bba\",'+
                                       '\"Type\":\"ResumeSubscription\",'+
                                       '       \"TotalDeltaMRR\":0.0,'+
                                       '       \"TotalDeltaTCV\":0.0}],'+
                                       '\"Subscription\":[{\"Id\":\"2c91a0f85d089f23015d555e43811bbf\",'+
                                       '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
                                       '               \"PreviousSubscriptionId\":\"2c91a0f95d089216015d555bd52e0cb8\"}]}'
                                      );
        
        RestContext.request = req;
       
        RestServiceForImmediateResumePause.HandleRestServiceForImmediateResumePause();
      
        Test.stopTest();    
    }
    
    /**
*
* @ Description : Test method to test CancelPause_FLOW_2
**/
    public static testMethod void TestCancelPauseWorkflow(){    
        //Create personal account
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testCustomer456@email.com','Active Paid');
        //Create Billing Account
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        bAccount.Zuora__Zuora_Id__c= '2c92c0f95774f27501577a7d88b378aa';
        update bAccount ;
        //Create test pause history
        Pause_History__c pauseHistoryRec = new Pause_History__c();
        pauseHistoryRec.Account__c = oAccount.Id; 
        pauseHistoryRec.Action_Performed__c = 'Cancel scheduled pause';
        insert pauseHistoryRec;
        //Create sample email message
        
        zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'A-S00398528', 'Active', Date.Today(), Date.today().addMonths(2) );
        
        
        String jsonstring ='{\"Account\":{},'+
            '\"Workflow\":{\"PreviousBCD\":12,'+
            '           \"ExecutionDate\":\"2017-07-12\",'+
            '           \"SubscriptionName\":\"A-S00398431\"},'+
            '\"Amendment\":[{\"Id\":\"2c91a0f95d089216015d37f40ee47a6b\"}],'+
            '\"Subscription\":[{\"Id\":\"2c91a0f95d089216015d37f410017a70\",'+
            '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
            '               \"PreviousSubscriptionId\":\"2c91a0fa5d08a4d4015d37f13abd1120\"}]}';
        //Send Sample Email  
        
        Test.startTest();
        
        System.assert(jsonstring != null);
        
        RestRequest req = new RestRequest();
        req.requestURI = '/CancelPause/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{\"Account\":{},'+
                                       '\"Workflow\":{\"PreviousBCD\":12,'+
                                       '           \"ExecutionDate\":\"2017-07-12\",'+
                                       '           \"SubscriptionName\":\"A-S00398431\"},'+
                                       '\"Amendment\":[{\"Id\":\"2c91a0f95d089216015d37f40ee47a6b\"}],'+
                                       '\"Subscription\":[{\"Id\":\"2c91a0f95d089216015d37f410017a70\",'+
                                       '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
                                       '               \"PreviousSubscriptionId\":\"2c91a0fa5d08a4d4015d37f13abd1120\"}]}');
        
        RestContext.request = req;
 
        RestServiceForCancelPause.HandleRestServiceForCancelPause();
        
        Test.stopTest();   
    }
    
    /**
*
* @ Description : Test method to test SetPause_FLOW_3
**/
    public static testMethod void TestSuspendPauseWorkflowSuccess(){   
        //Create personal account
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
        //Create Billing Account
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        bAccount.Zuora__Zuora_Id__c= '2c92c0f95774f27501577a7d88b378aa';
        update bAccount ;
        //Create test pause history
        Pause_History__c pauseHistoryRec = new Pause_History__c();
        pauseHistoryRec.Account__c = oAccount.Id; 
        pauseHistoryRec.Action_Performed__c = 'Set Pause';
        pauseHistoryRec.Pause_From__c = Date.newInstance(2017,05,05);
        pauseHistoryRec.Pause_Until__c = Date.newInstance(2017,06,13);
        insert pauseHistoryRec;
        //Create sample email message
        
        String jsonstring ='{\"Account\":{},'+
            ''+
            '\"Workflow\":{\"BCD\":20,'+
            ''+
            '           \"ResumeDate\":\"2017-09-20\",'+
            ''+
            '          \"SuspendDate\":\"2017-08-11\",'+
            ''+
            '          \"ExecutionDate\":\"2017-07-11\",'+
            ''+
            '          \"SubscriptionName\":\"A-S00398356\"},'+
            ''+
            '          '+
            '\"Amendment\":[{\"Id\":\"2c91a0fa5cf24cb9015d31392bbf7e11\",'+
            ''+
            '             \"Type\":\"SuspendSubscription\",'+
            ''+
            '            \"TotalDeltaMRR\":0.0,'+
            ''+
            '            \"TotalDeltaTCV\":0.0},'+
            ''+
            '            {\"Id\":\"2c91a0fb5d089283015d3139342f1728\",'+
            ''+
            '            \"Type\":\"ResumeSubscription\",'+
            ''+
            '            \"TotalDeltaMRR\":0.0,'+
            '\"TotalDeltaTCV\":0.0}],'+
            ''+
            '\"Subscription\":[{\"Id\":\"2c91a0fb5d089283015d31393438172d\",'+
            ''+
            '                \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
            ''+
            '               \"PreviousSubscriptionId\":\"2c91a0fa5cf24cb9015d31392bc87e16\"}'+
            '               ]}';
 
        Test.startTest();  
        
        System.assert(jsonstring != null);
        
        RestRequest req = new RestRequest();
        req.requestURI = '/SetPause/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{\"Account\":{},'+
                                       ''+
                                       '\"Workflow\":{\"BCD\":20,'+
                                       ''+
                                       '           \"ResumeDate\":\"2017-09-20\",'+
                                       ''+
                                       '          \"SuspendDate\":\"2017-08-11\",'+
                                       ''+
                                       '          \"ExecutionDate\":\"2017-07-11\",'+
                                       ''+
                                       '          \"SubscriptionName\":\"A-S00398356\"},'+
                                       ''+
                                       '          '+
                                       '\"Amendment\":[{\"Id\":\"2c91a0fa5cf24cb9015d31392bbf7e11\",'+
                                       ''+
                                       '             \"Type\":\"SuspendSubscription\",'+
                                       ''+
                                       '            \"TotalDeltaMRR\":0.0,'+
                                       ''+
                                       '            \"TotalDeltaTCV\":0.0},'+
                                       ''+
                                       '            {\"Id\":\"2c91a0fb5d089283015d3139342f1728\",'+
                                       ''+
                                       '            \"Type\":\"ResumeSubscription\",'+
                                       ''+
                                       '            \"TotalDeltaMRR\":0.0,'+
                                       '\"TotalDeltaTCV\":0.0}],'+
                                       ''+
                                       '\"Subscription\":[{\"Id\":\"2c91a0fb5d089283015d31393438172d\",'+
                                       ''+
                                       '                \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
                                       ''+
                                       '               \"PreviousSubscriptionId\":\"2c91a0fa5cf24cb9015d31392bc87e16\"}'+
                                       '               ]}'
                                      );
        
        RestContext.request = req;
        
        RestServiceForSetPause.HandleRestServiceForSetPause();
        
        Test.stopTest();             
    }
    
    /**
*
* @ Description : Test method to test StandardCancellationPause_FLOW_4
**/
    public static testMethod void TestStandardCancelwithScheduledPauseSuccess(){   
        //Create personal account
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
        //Create Billing Account
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        bAccount.Zuora__Zuora_Id__c= '2c92c0f95774f27501577a7d88b378aa';
        update bAccount ;
        //Create test pause history
        Pause_History__c pauseHistoryRec = new Pause_History__c();
        pauseHistoryRec.Account__c = oAccount.Id; 
        pauseHistoryRec.Action_Performed__c = 'Cancel subscription';
        insert pauseHistoryRec;
        //Create sample email message
        
        zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'A-S00398528', 'Active', Date.Today(), Date.today().addMonths(2) );
  
        String jsonstring ='{"Account":{},'+
            '"Workflow":{"CancelDate":"2017-07-23",'+
            '           "PreviousBCD":23,'+
            '           "ExecutionDate":"2017-07-18",'+
            '           "SubscriptionName":"A-S00398528"},'+
            '"Amendment":[{"Id":"2c91a0fb5cf25476015d554a83246e68"},'+
            '           {"Id":"2c91a0fb5d089283015d554b002e404e",'+
            '           "Type":"CancelSubscription",'+
            '           "TotalDeltaMRR":0.0,'+
            '           "TotalDeltaTCV":0.0}],'+
            '"Subscription":[{"Id":"2c91a0fb5d089283015d554b003f4053",'+
            '               "PreviousSubscriptionId":"2c91a0fa5d08a4d4015d552d8d7706de"}]}';
  
        Test.startTest(); 
        
        System.assert(jsonstring != null);
        
        RestRequest req = new RestRequest();
        req.requestURI = '/ImmediateResumePause/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"Account":{},'+
                                       '"Workflow":{"CancelDate":"2017-07-23",'+
                                       '           "PreviousBCD":23,'+
                                       '           "ExecutionDate":"2017-07-18",'+
                                       '           "SubscriptionName":"A-S00398528"},'+
                                       '"Amendment":[{"Id":"2c91a0fb5cf25476015d554a83246e68"},'+
                                       '           {"Id":"2c91a0fb5d089283015d554b002e404e",'+
                                       '           "Type":"CancelSubscription",'+
                                       '           "TotalDeltaMRR":0.0,'+
                                       '           "TotalDeltaTCV":0.0}],'+
                                       '"Subscription":[{"Id":"2c91a0fb5d089283015d554b003f4053",'+
                                       '               "PreviousSubscriptionId":"2c91a0fa5d08a4d4015d552d8d7706de"}]}');
        
        RestContext.request = req;
    
        RestServiceForStandardCancellationPause.HandleRestServiceForStandardCancellationPause();
        
        Test.stopTest();             
        
    }
    
     
    /**
*
* @ Description : Test method to test ImmediateCancellationPause_FLOW_5
**/  
    public static testMethod void TestImmediateCancelwithScheduledPauseSuccess(){
        //Create personal account
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
        //Create Billing Account
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        bAccount.Zuora__Zuora_Id__c= '2c92c0f95774f27501577a7d88b378aa';
        update bAccount ;
        //Create test pause history
        Pause_History__c pauseHistoryRec = new Pause_History__c();
        pauseHistoryRec.Account__c = oAccount.Id; 
        pauseHistoryRec.Action_Performed__c = 'Cancel subscription';
        insert pauseHistoryRec;
        
        String jsonstring ='{'+
            '\"Refund\":{\"Id\":\"2c91a0f95d089216015d5554c30f0c04\",'+
            '           \"Type\":\"Electronic\",'+
            '           \"Amount\":9.99,'+
            '           \"PaymentId\":\"2c91a0fa5cf24cb9015d5551522141b0\",'+
            '           \"ReasonCode\":\"Immediate Cancellation\"},'+
            '\"Account\":{},'+
            '\"Invoice\":[{\"Id\":\"2c91a0f95d089216015d5551a5b40bf7\"},'+
            '{       \"Amount\":9.99,'+
            '       \"Balance\":0.0,'+
            '       \"AccountId\":\"2c91a0fb59b56f45015a049813ef325e\",'+
            '       \"InvoiceDate\":\"2017-06-23\",'+
            '       \"InvoiceNumber\":\"INV02191878\"}],'+
            '\"Workflow\":{\"PaymentID\":\"2c91a0fa5cf24cb9015d5551522141b0\",'+
            '           \"CancelDate\":\"2017-07-18\",'+
            '           \"PreviousBCD\":23,'+
            '           \"ExecutionDate\":\"2017-07-18\",'+
            '           \"SubscriptionName\":\"A-S00398528\"},'+
            '\"Amendment\":{\"Id\":\"2c91a0f95d089216015d5551a4e30be2\",'+
            '           \"Type\":\"CancelSubscription\",'+
            '           \"TotalDeltaMRR\":0.0,'+
            '           \"TotalDeltaTCV\":0.0},'+
            '\"InvoiceItem\":[{\"Id\":\"2c91a0a95cf24d75015d554968a472ee\",'+
            '               \"ChargeAmount\":8.39,'+
            '               \"SubscriptionId\":\"2c91a0fa5d08a4d4015d552d8d7706de\",'+
            '               \"SubscriptionNumber\":\"A-S00398528\"}],'+
            '\"Subscription\":[{\"Id\":\"2c91a0f95d089216015d5551a4f30be7\",'+
            '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
            '               \"PreviousSubscriptionId\":\"2c91a0fa5d08a4d4015d55503d4b08e9\"}],'+
            '\"TaxationItem\":[{\"Id\":\"2c91a0a95cf24d75015d5549678b72ea\",'+
            '               \"TaxAmount\":1.6,'+
            '               \"ExemptAmount\":0.0,'+
            '               \"InvoiceItemId\":\"2c91a0a95cf24d75015d554968a472ee\"}],'+
            '\"InvoicePayment\":[{\"Amount\":9.99,'+
            '               \"InvoiceId\":\"2c91a0a95cf24d75015d554968a072ec\"}],'+
            '\"InvoicePayments\":[{\"Id\":\"2c91a0fa5cf24cb9015d5551522141b1\",'+
            '               \"Amount\":\"9.99\",'+
            '               \"InvoiceId\":\"2c91a0a95cf24d75015d554968a072ec\",'+
            '               \"PaymentId\":\"2c91a0fa5cf24cb9015d5551522141b0\",'+
            '               \"RefundAmount\":\"9.99\"}],'+
            '\"InvoiceItemAdjustment\":[{\"Id\":\"2c91a0fb5d08b321015d5554d1b97937\",'+
            '                           \"Type\":\"Credit\",'+
            '                           \"Amount\":1.6,'+
            '                           \"SourceId\":\"2c91a0a95cf24d75015d5549678b72ea\",'+
            '                           \"InvoiceId\":\"2c91a0a95cf24d75015d554968a072ec\",'+
            '                           \"ReasonCode\":\"Immediate Cancel\",'+
            '                           \"SourceType\":\"Tax\",'+
            '                           \"ReferenceId\":\"\",'+
            '                           \"AdjustmentDate\":\"2017-07-18\",'+
            '                           \"DeferredRevenueAccount\":\"\",'+
            '                           \"RecognizedRevenueAccount\":\"\"},'+
            '                           {\"Id\":\"2c91a0fb5d08b321015d5554d1c87939\",'+
            '                           \"Type\":\"Credit\",'+
            '                           \"Amount\":8.39,'+
            '                           \"SourceId\":\"2c91a0a95cf24d75015d554968a472ee\",'+
            '                           \"InvoiceId\":\"2c91a0a95cf24d75015d554968a072ec\",'+
            '                           \"ReasonCode\":\"Immediate Cancel\",'+
            '                           \"SourceType\":\"InvoiceDetail\",'+
            '                           \"ReferenceId\":\"\",'+
            '                           \"AdjustmentDate\":\"2017-07-18\",'+
            '                           \"DeferredRevenueAccount\":\"7074\",'+
            '                           \"RecognizedRevenueAccount\":\"1015\"}]}';
        
        //Send Sample Email    
        
        Test.startTest();  
        
        System.assert(jsonstring != null);
        
        RestRequest req = new RestRequest();
        req.requestURI = '/ImmediateCancellationPause/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{'+
                                       '\"Refund\":{\"Id\":\"2c91a0f95d089216015d5554c30f0c04\",'+
                                       '           \"Type\":\"Electronic\",'+
                                       '           \"Amount\":9.99,'+
                                       '           \"PaymentId\":\"2c91a0fa5cf24cb9015d5551522141b0\",'+
                                       '           \"ReasonCode\":\"Immediate Cancellation\"},'+
                                       '\"Account\":{},'+
                                       '\"Invoice\":[{\"Id\":\"2c91a0f95d089216015d5551a5b40bf7\"},'+
                                       '{       \"Amount\":9.99,'+
                                       '       \"Balance\":0.0,'+
                                       '       \"AccountId\":\"2c91a0fb59b56f45015a049813ef325e\",'+
                                       '       \"InvoiceDate\":\"2017-06-23\",'+
                                       '       \"InvoiceNumber\":\"INV02191878\"}],'+
                                       '\"Workflow\":{\"PaymentID\":\"2c91a0fa5cf24cb9015d5551522141b0\",'+
                                       '           \"CancelDate\":\"2017-07-18\",'+
                                       '           \"PreviousBCD\":23,'+
                                       '           \"ExecutionDate\":\"2017-07-18\",'+
                                       '           \"SubscriptionName\":\"A-S00398528\"},'+
                                       '\"Amendment\":{\"Id\":\"2c91a0f95d089216015d5551a4e30be2\",'+
                                       '           \"Type\":\"CancelSubscription\",'+
                                       '           \"TotalDeltaMRR\":0.0,'+
                                       '           \"TotalDeltaTCV\":0.0},'+
                                       '\"InvoiceItem\":[{\"Id\":\"2c91a0a95cf24d75015d554968a472ee\",'+
                                       '               \"ChargeAmount\":8.39,'+
                                       '               \"SubscriptionId\":\"2c91a0fa5d08a4d4015d552d8d7706de\",'+
                                       '               \"SubscriptionNumber\":\"A-S00398528\"}],'+
                                       '\"Subscription\":[{\"Id\":\"2c91a0f95d089216015d5551a4f30be7\",'+
                                       '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
                                       '               \"PreviousSubscriptionId\":\"2c91a0fa5d08a4d4015d55503d4b08e9\"}],'+
                                       '\"TaxationItem\":[{\"Id\":\"2c91a0a95cf24d75015d5549678b72ea\",'+
                                       '               \"TaxAmount\":1.6,'+
                                       '               \"ExemptAmount\":0.0,'+
                                       '               \"InvoiceItemId\":\"2c91a0a95cf24d75015d554968a472ee\"}],'+
                                       '\"InvoicePayment\":[{\"Amount\":9.99,'+
                                       '               \"InvoiceId\":\"2c91a0a95cf24d75015d554968a072ec\"}],'+
                                       '\"InvoicePayments\":[{\"Id\":\"2c91a0fa5cf24cb9015d5551522141b1\",'+
                                       '               \"Amount\":\"9.99\",'+
                                       '               \"InvoiceId\":\"2c91a0a95cf24d75015d554968a072ec\",'+
                                       '               \"PaymentId\":\"2c91a0fa5cf24cb9015d5551522141b0\",'+
                                       '               \"RefundAmount\":\"9.99\"}],'+
                                       '\"InvoiceItemAdjustment\":[{\"Id\":\"2c91a0fb5d08b321015d5554d1b97937\",'+
                                       '                           \"Type\":\"Credit\",'+
                                       '                           \"Amount\":1.6,'+
                                       '                           \"SourceId\":\"2c91a0a95cf24d75015d5549678b72ea\",'+
                                       '                           \"InvoiceId\":\"2c91a0a95cf24d75015d554968a072ec\",'+
                                       '                           \"ReasonCode\":\"Immediate Cancel\",'+
                                       '                           \"SourceType\":\"Tax\",'+
                                       '                           \"ReferenceId\":\"\",'+
                                       '                           \"AdjustmentDate\":\"2017-07-18\",'+
                                       '                           \"DeferredRevenueAccount\":\"\",'+
                                       '                           \"RecognizedRevenueAccount\":\"\"},'+
                                       '                           {\"Id\":\"2c91a0fb5d08b321015d5554d1c87939\",'+
                                       '                           \"Type\":\"Credit\",'+
                                       '                           \"Amount\":8.39,'+
                                       '                           \"SourceId\":\"2c91a0a95cf24d75015d554968a472ee\",'+
                                       '                           \"InvoiceId\":\"2c91a0a95cf24d75015d554968a072ec\",'+
                                       '                           \"ReasonCode\":\"Immediate Cancel\",'+
                                       '                           \"SourceType\":\"InvoiceDetail\",'+
                                       '                           \"ReferenceId\":\"\",'+
                                       '                           \"AdjustmentDate\":\"2017-07-18\",'+
                                       '                           \"DeferredRevenueAccount\":\"7074\",'+
                                       '                           \"RecognizedRevenueAccount\":\"1015\"}]}');
        
        
        RestContext.request = req;
        
        
        RestServiceForImmediateCancellationPause.HandleRestServiceForImmediateCancellationPause();
        
        Test.stopTest();    
    }
    /**
*
* @ Description : Test method to test ChangingResumeDatesWhileInPause_FLOW_6
**/  
    public static testMethod void TestChangeResumeDateWhenInPauseSuccess(){
        //Create personal account 
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
        //Create Billing Account
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        bAccount.Zuora__Zuora_Id__c= '2c92c0f95774f27501577a7d88b378aa';
        update bAccount ;
        //Create test pause history
        Pause_History__c pauseHistoryRec = new Pause_History__c();
        pauseHistoryRec.Account__c = oAccount.Id; 
        pauseHistoryRec.Pause_Until__c = Date.newInstance(2018,04,20);
        pauseHistoryRec.Action_Performed__c = 'Edit resume dates in pause';
        insert pauseHistoryRec;
        
        String jsonstring ='{\"Account\":{},'+
            '\"Workflow\":{\"BCD\":20,'+
            '           \"ResumeDate\":\"2017-07-20\",'+
            '           \"ExecutionDate\":\"2017-07-18\",'+
            '           \"SubscriptionName\":\"A-S00398528\"},'+
            '\"Amendment\":[{\"Id\":\"2c91a0f95d089216015d553083b40a75\"},'+
            '           {\"Id\":\"2c91a0fa5d08a4d4015d5532740a0783\",'+
            '           \"Type\":\"ResumeSubscription\",'+
            '           \"TotalDeltaMRR\":0.0,'+
            '           \"TotalDeltaTCV\":0.0}],'+
            '\"Subscription\":[{\"Id\":\"2c91a0fa5d08a4d4015d553274140788\",'+
            '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
            '               \"PreviousSubscriptionId\":\"2c91a0fb5d089283015d55307c463f6a\"}]}';
        
        
        Test.startTest();
        
        System.assert(jsonstring != null);
        
        RestRequest req = new RestRequest();
        req.requestURI = '/ChangingResumeDatesWhileInPause/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{\"Account\":{},'+
                                       '\"Workflow\":{\"BCD\":20,'+
                                       '           \"ResumeDate\":\"2017-07-20\",'+
                                       '           \"ExecutionDate\":\"2017-07-18\",'+
                                       '           \"SubscriptionName\":\"A-S00398528\"},'+
                                       '\"Amendment\":[{\"Id\":\"2c91a0f95d089216015d553083b40a75\"},'+
                                       '           {\"Id\":\"2c91a0fa5d08a4d4015d5532740a0783\",'+
                                       '           \"Type\":\"ResumeSubscription\",'+
                                       '           \"TotalDeltaMRR\":0.0,'+
                                       '           \"TotalDeltaTCV\":0.0}],'+
                                       '\"Subscription\":[{\"Id\":\"2c91a0fa5d08a4d4015d553274140788\",'+
                                       '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
                                       '               \"PreviousSubscriptionId\":\"2c91a0fb5d089283015d55307c463f6a\"}]}'
                                      );
        
        RestContext.request = req;
        
        
        RSChangingResumeDatesWhileInPause.HandleRestServiceForChangingResumeDatesWhileInPause();
        
        Test.stopTest();    
    }
    
    /**
*
* @ Description : Test method to test ChangeResumeDatesNotInPause_FLOW_7
**/   
    public static testMethod void TestChangeResumeDatesNotInPause_FLOW_7(){   
        //Create personal account 
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
        //Create Billing Account
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        bAccount.Zuora__Zuora_Id__c= '2c92c0f95774f27501577a7d88b378aa';
        update bAccount ;
        //Create test pause history
        Pause_History__c pauseHistoryRec = new Pause_History__c();
        pauseHistoryRec.Account__c = oAccount.Id; 
        pauseHistoryRec.Pause_Until__c = Date.newInstance(2018,04,20);
        pauseHistoryRec.Action_Performed__c = 'Edit Pause';
        insert pauseHistoryRec;
        
        String jsonstring ='{'+
            '\"Account\":{},'+
            '\"Workflow\":{\"BCD\":\"13\",'+
            '           \"ResumeDate\":\"2017-08-13\",'+
            '           \"ExecutionDate\":\"2017-07-11\",'+
            '           \"SubscriptionName\":\"A-S00398375\"},'+
            '\"Amendment\":[{\"Id\":\"2c91a0f95d089216015d323555dc4e23\"},'+
            '           {\"Id\":\"2c91a0fb5d08b321015d3238d9f766a0\",'+
            '           \"Type\":\"ResumeSubscription\",'+
            '           \"TotalDeltaMRR\":0.0,'+
            '           \"TotalDeltaTCV\":0.0}],'+
            '\"Subscription\":[{\"Id\":\"2c91a0fb5d08b321015d3238da0066a5\",'+
            '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
            '               \"PreviousSubscriptionId\":\"2c91a0fa5d08a3bd015d32354edb3ea1\"}]}';
 
        Test.startTest();
        
        System.assert(jsonstring != null);
        
        RestRequest req = new RestRequest();
        req.requestURI = '/ChangeResumeDatesNotInPause/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf( '{'+
                                       '\"Account\":{},'+
                                       '\"Workflow\":{\"BCD\":\"13\",'+
                                       '           \"ResumeDate\":\"2017-08-13\",'+
                                       '           \"ExecutionDate\":\"2017-07-11\",'+
                                       '           \"SubscriptionName\":\"A-S00398375\"},'+
                                       '\"Amendment\":[{\"Id\":\"2c91a0f95d089216015d323555dc4e23\"},'+
                                       '           {\"Id\":\"2c91a0fb5d08b321015d3238d9f766a0\",'+
                                       '           \"Type\":\"ResumeSubscription\",'+
                                       '           \"TotalDeltaMRR\":0.0,'+
                                       '           \"TotalDeltaTCV\":0.0}],'+
                                       '\"Subscription\":[{\"Id\":\"2c91a0fb5d08b321015d3238da0066a5\",'+
                                       '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
                                       '               \"PreviousSubscriptionId\":\"2c91a0fa5d08a3bd015d32354edb3ea1\"}]}'
                                      );
        
        RestContext.request = req;
  
        RSForChangeResumeDatesNotInPause.HandleRestServiceForChangeResumeDatesNotInPause();
        
        Test.stopTest();    
    }
    
    /**
*
* @ Description : Test method to test utility methods
**/ 
    public static testMethod void testCreateTask(){    
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Paused');
        string strDate = '2017-03-29';
        Test.StartTest();
        RestServiceForPauseCalloutHelper.CreateTask(oAccount );
        RestServiceForPauseCalloutHelper.setStringToDateFormat(strDate);
        RestServiceForPauseCalloutHelper.CreateEmailQueue(oAccount );
        RestServiceForPauseCalloutHelper.CreatePauseHistory(oAccount.id);
        Test.StopTest();
    } 
  
    public static testMethod void TestfetchAccountFromjson() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        bAccount.Zuora__External_Id__c ='2c92c0f85ab26970015ac74cdaa56bf7';
        bAccount.Zuora__Account__c =oAccount.id ;
        bAccount.Zuora__Zuora_Id__c= '2c92c0f85ab26970015ac74cdaa56bf7';
        update bAccount ;
        
        zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        
        Test.startTest();
        
        String jsonstring ='{ '+
            '    "Refund":  ['+
            '         { '+
            '             "Id":"2c91a0fb5ccf56f3015ce4a1a2346eef", '+
            '             "AccountId":"2c92c0f85ab26970015ac74cdaa56bf7"'+          
            '         } '+
            '    ] '+
            
            '}';
        
        RestServiceForPauseCalloutHelper.fetchAccountFromjson(jsonstring );
        RestServiceForPauseCalloutHelper.RetrieveAccount(bAccount.Zuora__External_Id__c);
        
        RestRequest req = new RestRequest();
        req.requestURI = '/FreezeAccount/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ '+
                                       '    "Refund":  ['+
                                       '         { '+
                                       '             "Id":"2c91a0fb5ccf56f3015ce4a1a2346eef", '+
                                       '             "AccountId":"2c92c0f85ab26970015ac74cdaa56bf7"'+          
                                       '         } '+
                                       '    ] '+
                                       
                                       ' }');
        
        RestContext.request = req;
       
        RestServiceForFreezeAccount.HandleRestServiceForFreezeAccount();
        
        Test.StopTest();
    }

    public static testMethod void testFetchAccountFromjsonNewFormat() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'pm3testemail@email.com', 'Active Paid');
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD', '1st of the month'); 
        bAccount.Zuora__External_Id__c ='testAccId';
        bAccount.Zuora__Account__c = oAccount.id ;
        bAccount.Zuora__Zuora_Id__c= 'testAccId';
        update bAccount ;
        
        zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2));
        
        Test.startTest();
        String jsonstring = '{"AccountId":"testAccId"}';
        RestServiceForPauseCalloutHelper.fetchAccountFromjson(jsonstring);
        Test.StopTest();

        System.assertEquals('Frozen', [Select Id, Account_Status__c From Account Where Id = :oAccount.Id].Account_Status__c);
    }
    
}