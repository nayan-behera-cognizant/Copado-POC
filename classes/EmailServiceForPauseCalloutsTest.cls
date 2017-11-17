/**
 * @ Author : Nayan Behera (Cognizant Technology Solutions)
 * @ Date : 13/04/2017
 * @ Description : Test classes for Email Service For Pause Callouts
**/
@isTest
public class EmailServiceForPauseCalloutsTest{
	
	/**
	 * @ Author : Nayan Behera (Cognizant Technology Solutions)
	 * @ Date : 13/04/2017
	 * @ Description : Test method to create custom setting records
	**/
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
 	
 	/**
	 * @ Author : Nayan Behera (Cognizant Technology Solutions)
	 * @ Date : 10/04/2017
	 * @ Description : Test method to test ImmediateResumePause_FLOW_1
	**/
	public static testMethod void TestImmediateResumeWorkflow(){   
        //Create personal account
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testCustomer123@email.com','Active Paid');
        //Create Billing Account
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        bAccount.Zuora__Zuora_Id__c= '2c92c0f95774f27501577a7d88b378aa';
        update bAccount ;
        //Create sample email message
        Messaging.InboundEmail testEmail = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        testEmail.subject = 'Immediate Resume Workflow success';
        testEmail.fromAddress = 'xxx@dazn.com';
        testEmail.htmlBody ='{'+
          '"Account": {'+          
          '},'+
          '"Invoice": {'+
            '"Id": "2c91a0fa5b42da5b015b5887f12056e5"'+
          '},'+
          '"Workflow": {'+
            '"BCD": 10,'+
            '"ResumeDate": "2017-04-10",'+
            '"ExecutionDate": "2017-04-10",'+
            '"SubscriptionName": "A-S00374145"'+
          '},'+
          '"Amendment": {'+
            '"Id": "2c91a0fa5b42da5b015b5887f04956cb",'+
            '"Type": "ResumeSubscription",'+
            '"TotalDeltaMRR": 0.0,'+
            '"TotalDeltaTCV": 0.0'+
          '},'+
          '"Subscription": {'+
            '"Id": "2c92c0f95aff3b56015b1001b56c4e80",'+
            '"AccountId": "2c92c0f95774f27501577a7d88b378aa",'+
            '"PreviousSubscriptionId": "2c91a0fb5b42e0af015b587e8fab79ac"'+
          '}'+
        '}';
        EmailServiceForPauseCallouts sObj = new EmailServiceForPauseCallouts();
        sObj.handleInboundEmail(testEmail, env);     
    }
    
    /**
	 * @ Author : Nayan Behera (Cognizant Technology Solutions)
	 * @ Date : 10/04/2017
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
        Messaging.InboundEmail testEmail = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        testEmail.subject = 'Cancel Pause Resume before Pause Starts success';
        testEmail.fromAddress = 'xxx@cognizant.com';
        testEmail.htmlBody ='{'+
          '"Account": {'+          
          '},'+
          '"Invoice": {'+
            '"Id": "2c91a0fa5b42da5b015b5887f12056e5"'+
          '},'+
          '"Workflow": {'+
            '"BCD": 10,'+
            '"ResumeDate": "2017-04-10",'+
            '"ExecutionDate": "2017-04-10",'+
            '"SubscriptionName": "A-S00374145"'+
          '},'+
          '"Amendment": {'+
            '"Id": "2c91a0fa5b42da5b015b5887f04956cb",'+
            '"Type": "ResumeSubscription",'+
            '"TotalDeltaMRR": 0.0,'+
            '"TotalDeltaTCV": 0.0'+
          '},'+
          '"Subscription": {'+
            '"Id": "2c92c0f95aff3b56015b1001b56c4e80",'+
            '"AccountId": "2c92c0f95774f27501577a7d88b378aa",'+
            '"PreviousSubscriptionId": "2c92c0f85aff3453015b0ffaaf1251df"'+
          '}'+
        '}';
        //Send Sample Email  
        EmailServiceForPauseCallouts sObj = new EmailServiceForPauseCallouts();
        sObj.handleInboundEmail(testEmail, env);
             
    }
  	
  	 /**
	 * @ Author : Nayan Behera (Cognizant Technology Solutions)
	 * @ Date : 10/04/2017
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
        Messaging.InboundEmail testEmail = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        testEmail.subject = 'Suspend Pause Workflow success';
        testEmail.fromAddress = 'xxx@cognizant.com';      
        testEmail.htmlBody ='{'+
        '"Account": {'+ 
        '},'+
        '"Workflow": {'+
        '"BCD": 29,'+
        '"ResumeDate": "2017-06-13",'+
        '"SuspendDate":"2017-05-05",'+
        '"ExecutionDate": "2017-03-27",'+
        '"SubscriptionName": "A-S00025677"'+
        '},'+
        '"Amendment":[{'+  
         '"Id":"2c91a0fb5b42e0b1015b5823df8c02a3",'+
         '"Type":"SuspendSubscription",'+
         '"TotalDeltaMRR":0.0,'+
         '"TotalDeltaTCV":0.0'+
      	'},'+
      	'{'+ 
         '"Id":"2c91a0f95b42e09c015b5823ee591751",'+
         '"Type":"ResumeSubscription",'+
         '"TotalDeltaMRR":0.0,'+
         '"TotalDeltaTCV":0.0'+
      	'}'+
   		'],'+
        '"Subscription": {'+
        '"Id": "2c92c0f95aff3b56015b1001b56c4e80",'+
        '"AccountId":"2c92c0f95774f27501577a7d88b378aa",'+
        '"PreviousSubscriptionId": "2c92c0f85aff3453015b0ffaaf1251df"'+
        '}'+
        '}';
        //Send Sample Email  
        EmailServiceForPauseCallouts sObj = new EmailServiceForPauseCallouts();
        sObj.handleInboundEmail(testEmail, env);            
    }
   	
   	/**
	 * @ Author : Nayan Behera (Cognizant Technology Solutions)
	 * @ Date : 10/04/2017
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
        Messaging.InboundEmail testEmail = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        testEmail.subject = 'Standard Cancel with Scheduled Pause success';
        testEmail.fromAddress = 'xxx@cognizant.com';
        testEmail.htmlBody ='{'+
        '"Account": {'+
        '},'+
        '"Invoice": {'+
        '"Id": "2c91a0fb5b42e0ad015b61898f923502"'+
        '},'+
        '"Workflow": {'+
        '"PaymentID": "2c91a0b35b42cb10015b6188b21404a7",'+
		'"CancelDate": "2017-04-12",'+
        '"PreviousBCD": 29,'+
        '"ExecutionDate": "2017-03-27",'+
        '"SubscriptionName": "A-S00025677"'+
        '},'+
        '"Amendment": {'+
        '"Id": "2c92c0f95aff3b56015b1001b55f4e7b",'+
        '"Type": "ResumeSubscription",'+
        '"TotalDeltaMRR": 0.0,'+
        '"TotalDeltaTCV": 0.0'+
        '},'+
        '"Subscription": {'+
        '"Id": "2c92c0f95aff3b56015b1001b56c4e80",'+
        '"AccountId": "2c92c0f95774f27501577a7d88b378aa",'+
        '"PreviousSubscriptionId": "2c92c0f85aff3453015b0ffaaf1251df"'+
        '}'+
        '}';
        //Send Sample Email   
        EmailServiceForPauseCallouts sObj = new EmailServiceForPauseCallouts();
        sObj.handleInboundEmail(testEmail, env);
    }
    
	/**
	 * @ Author : Nayan Behera (Cognizant Technology Solutions)
	 * @ Date : 10/04/2017
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
        //Create sample email message
        Messaging.InboundEmail testEmail = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        testEmail.subject = 'Immediate Cancel with Scheduled Pause success';
        testEmail.fromAddress = 'xxx@cognizant.com';
        testEmail.htmlBody ='{'+
        '"Account": {'+
        '},'+
        '"Invoice": {'+
        '"Id": "2c91a0fb5b42e0ad015b61898f923502"'+
        '},'+
        '"Workflow": {'+
        '"PaymentID": "2c91a0b35b42cb10015b6188b21404a7",'+
		'"CancelDate": "2017-04-12",'+
        '"PreviousBCD": 29,'+
        '"ExecutionDate": "2017-03-27",'+
        '"SubscriptionName": "A-S00025677"'+
        '},'+
        '"Amendment": {'+
        '"Id": "2c92c0f95aff3b56015b1001b55f4e7b",'+
        '"Type": "ResumeSubscription",'+
        '"TotalDeltaMRR": 0.0,'+
        '"TotalDeltaTCV": 0.0'+
        '},'+
        '"Subscription": {'+
        '"Id": "2c92c0f95aff3b56015b1001b56c4e80",'+
        '"AccountId": "2c92c0f95774f27501577a7d88b378aa",'+
        '"PreviousSubscriptionId": "2c92c0f85aff3453015b0ffaaf1251df"'+
        '}'+
        '}';
        //Send Sample Email    
        EmailServiceForPauseCallouts sObj = new EmailServiceForPauseCallouts();
        sObj.handleInboundEmail(testEmail, env);
    }
   
   
	/**
	 * @ Author : Nayan Behera (Cognizant Technology Solutions)
	 * @ Date : 10/04/2017
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
        //Create sample email message 
        Messaging.InboundEmail testEmail = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        testEmail.subject = 'Change Resume Date when in Pause success';
        testEmail.fromAddress = 'xxx@cognizant.com';
        testEmail.htmlBody ='{'+
        '"Account": {'+
        '},'+
        '"Invoice": {'+
        '"Id": "2c91a0fb5b42e0ad015b61898f923502"'+
        '},'+
        '"Workflow": {'+
		'"BCD": 20,'+
		'"ResumeDate": "2018-04-20",'+
		'"ExecutionDate": "2017-04-11",'+
		'"SubscriptionName": "A-S00374194"'+
		'},'+
        '"Amendment": {'+
        '"Id": "2c92c0f95aff3b56015b1001b55f4e7b",'+
        '"Type": "ResumeSubscription",'+
        '"TotalDeltaMRR": 0.0,'+
        '"TotalDeltaTCV": 0.0'+
        '},'+
        '"Subscription": {'+
        '"Id": "2c92c0f95aff3b56015b1001b56c4e80",'+
        '"AccountId": "2c92c0f95774f27501577a7d88b378aa",'+
        '"PreviousSubscriptionId": "2c92c0f85aff3453015b0ffaaf1251df"'+
        '}'+
        '}';
        //Send Sample Email 
        EmailServiceForPauseCallouts sObj = new EmailServiceForPauseCallouts();
        sObj.handleInboundEmail(testEmail, env);
    }
	
	/**
	 * @ Author : Nayan Behera (Cognizant Technology Solutions)
	 * @ Date : 10/04/2017
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
        //Create sample email message 
        Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        testEmail.subject = 'Change Resume date not in pause';
        testEmail.fromAddress = 'xxx@cognizant.com';
        testEmail.htmlBody ='{'+
        '"Account": {'+
        '},'+
        '"Workflow": {'+
        '"BCD": 27,'+
        '"ResumeDate": "2018-04-20",'+
        '"ExecutionDate": "2017-03-27",'+
        '"SubscriptionName": "A-S00025677"'+
        '},'+
        '"Amendment": {'+
		'"Id": "2c91a0fb5b42e0ad015b5c7d5ab47ff6",'+
		'"Type": "ResumeSubscription",'+
		'"TotalDeltaMRR": 0.0,'+
		'"TotalDeltaTCV": 0.0'+
		'},'+
        '"Subscription": {'+
        '"Id": "2c92c0f95aff3b56015b1001b56c4e80",'+
        '"AccountId": "2c92c0f95774f27501577a7d88b378aa",'+
        '"PreviousSubscriptionId": "2c92c0f85aff3453015b0ffaaf1251df"'+
        '}'+
        '}';
        //Send Sample Email   
        EmailServiceForPauseCallouts sObj = new EmailServiceForPauseCallouts();
        sObj.handleInboundEmail(testEmail, env);
    }
    
    /**
	 * @ Author : Nayan Behera (Cognizant Technology Solutions)
	 * @ Date : 10/04/2017
	 * @ Description : Test method to test utility methods
	**/ 
	public static testMethod void testCreateTask(){    
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Paused');
		string strDate = '2017-03-29';
		Test.StartTest();
        EmailServiceForPauseCalloutHelper.CreateTask(oAccount );
        EmailServiceForPauseCalloutHelper.setStringToDateFormat(strDate);
        EmailServiceForPauseCalloutHelper.CreateEmailQueue(oAccount );
        EmailServiceForPauseCalloutHelper.CreatePauseHistory(oAccount.id);
        Test.StopTest();
    } 
}