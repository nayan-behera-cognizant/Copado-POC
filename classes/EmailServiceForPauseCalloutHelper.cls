/**
 * @ Author : Nayan Behera (Cognizant Technology Solutions)
 * @ Date : 31/03/2017
 * @ Description : Apex class handling the logic for pause email service
**/
public class EmailServiceForPauseCalloutHelper {
    
    //Global Variables
    public static Map<string,Pause_Email_Service_Setting__c> emailSettingMap = Pause_Email_Service_Setting__c.getAll();
    public static String paymentMethodType;
    
    /**
     * @ Author : Nayan Behera (Cognizant Technology Solutions)
     * @ Date : 31/03/2017
     * @ Description : Apex Method implementing the logic for FLOW 1: Immediate Resume
    **/       
    public static void ImmediateResumePause_FLOW_1(Messaging.inboundEmail email){
        
        //Local Variables
        list<Zuora__Subscription__c> subscriptionRecList = new list<Zuora__Subscription__c>();
        Date resumeDate;
        // Parse JSON response to get all the field values.
        String emailBodyStr = email.htmlBody;
        Map<String, Object> mapParentObj = (Map<String, Object>) JSON.deserializeUntyped(emailBodyStr);
        //Fetch the Salesforce account details from billing account 
		list<Account> SFAccountList = (list<Account>) retrieveSFRecords(mapParentObj,'Subscription','Account',null,'ImmediateResumePause');
    	SFAccountList[0].Account_Status__c = 'Active Paid';
        SFAccountList[0].Pause_From__c = null;
        SFAccountList[0].Pause_Until__c = null;
        SFAccountList[0].Submitted_for_cancellation__c = false;
        update SFAccountList;
        //Create Pause History
        insert CreatePauseHistory(SFAccountList[0].Id);
        //Create record in Email Queue
        if (!SFAccountList[0].Disable_transactional_emails__c) {
            Email_Sync_Queue__c emailQueue = CreateEmailQueue(SFAccountList[0]);
            //Fetch the Resume Date from the workflow
            Map<String, object> workFlowMap = (Map<String, object>) mapParentObj.get('Workflow'); 
            //If there is no resume date in JSON request then fetch resume date from Account
            if ((String) workFlowMap.get('ResumeDate') <> '' && (String) workFlowMap.get('ResumeDate') <> null) {
                resumeDate = setStringToDateFormat((String) workFlowMap.get('ResumeDate'));
            } else if(SFAccountList[0].Pause_Until__c <> null) {
                resumeDate = SFAccountList[0].Pause_Until__c;
            }
            emailQueue.Free_Trial_End_Date__c = resumeDate.addMonths(1);
            emailQueue.Status__c = 'Not Started';
            //Changed as per PD-12323 @ Release: Cog 1.6.2
            emailQueue.Payment_Method_Type__c = paymentMethodType;
            //End
            emailQueue.Pause_From__c = null;
            emailQueue.Pause_Until__c = null;
            emailQueue.Dispatch_ID__c = emailSettingMap.get('FlowEarlyResume').Dispatch_ID__c;
            emailQueue.Email_Name__c = 'Welcome Back from Pause';
            insert emailQueue;
        }
    }
	
	/**
     * @ Author : Nayan Behera (Cognizant Technology Solutions)
     * @ Date : 01/04/2017
     * @ Description : Apex Method implementing the logic for FLOW 2: Cancel Pause
    **/       
    public static void CancelPause_FLOW_2(Messaging.inboundEmail email){
        
        //Local Variables
        list<Zuora__Subscription__c> subscriptionRecList = new list<Zuora__Subscription__c>();
        Date resumeDate;
        // Parse JSON response to get all the field values.
        String emailBodyStr = email.htmlBody;
        System.debug(email.htmlBody);
        System.debug(email);
        Map<String, Object> mapParentObj = (Map<String, Object>) JSON.deserializeUntyped(emailBodyStr);
		System.debug(mapParentObj);
        //Fetch the Salesforce account details from billing account 
		list<Account> SFAccountList = (list<Account>) retrieveSFRecords(mapParentObj,'Subscription','Account',null,'CancelPause');
        //Create record in Email Sync Queue
        if (!SFAccountList[0].Disable_transactional_emails__c) {
            Email_Sync_Queue__c emailQueue = CreateEmailQueue(SFAccountList[0]);
            //Fetch the Resume Date from the workflow
            map<String,object> workFlowMap = (map<String,object>) mapParentObj.get('Workflow'); 
            //Changed as per PD-12322 @ Release: Cog 1.6.2
            emailQueue.Free_Trial_End_Date__c = null;
            emailQueue.Rebill_Date__c = ZuoraTransactionHelper.getRatePlanChargeChargedThroughDateByAccountId(SFAccountList[0].Id);
            //End
            emailQueue.Status__c = 'Not Started';
            emailQueue.Dispatch_ID__c = emailSettingMap.get('FlowCancelPause').Dispatch_ID__c;
            emailQueue.Email_Name__c = 'Cancels scheduled Pause';
            insert emailQueue;
        }
        //Update Pause History
        List<Pause_History__c> pauseHistoryList = [Select Id,Account__c From Pause_History__c where Account__c =: SFAccountList[0].Id AND Action_Performed__c= 'Cancel scheduled pause' order by CreatedDate DESC limit 1];
        if (pauseHistoryList <> null && pauseHistoryList.size() > 0) {
            pauseHistoryList[0].Status__c = 'Success';
            update pauseHistoryList[0];
        }
        //Update Account
        SFAccountList[0].Pause_From__c = null;
        SFAccountList[0].Pause_Until__c = null;
        SFAccountList[0].Submitted_for_cancellation__c = false;
        update SFAccountList[0];
    }
	
    /**
     * @ Author : Nayan Behera (Cognizant Technology Solutions)
     * @ Date : 01/04/2017
     * @ Description : Apex Method implementing the logic for FLOW 3: Set Pause
    **/       
    public static void SetPause_FLOW_3(Messaging.inboundEmail email){
        
        //Local Variables
        list<Zuora__Subscription__c> subscriptionRecList = new list<Zuora__Subscription__c>();
        // Parse JSON response to get all the field values.
        String emailBodyStr = email.htmlBody;
        Map<String, Object> mapParentObj = (Map<String, Object>) JSON.deserializeUntyped(emailBodyStr);
        //Fetch the Salesforce account details from billing account 
		list<Account> SFAccountList = (list<Account>) retrieveSFRecords(mapParentObj,'Subscription','Account',null,'SetPause');
        //Fetch Date from the workflow
        map<String,object> workFlowMap = (map<String,object>) mapParentObj.get('Workflow');
        Date resumeDate = setStringToDateFormat((String) workFlowMap.get('ResumeDate'));
        Date suspendDate = setStringToDateFormat((String) workFlowMap.get('SuspendDate'));
        //Update Pause History
        list<Pause_History__c> pauseHistoryList = [Select Id,Account__c From Pause_History__c where Account__c =: SFAccountList[0].Id AND Pause_From__c =: suspendDate 
        											AND Pause_Until__c =: resumeDate AND Action_Performed__c= 'Set Pause' order by CreatedDate DESC limit 1];                 
        if(pauseHistoryList <> null && pauseHistoryList.size() > 0) {
            pauseHistoryList[0].Status__c = 'Success';
            update pauseHistoryList[0];
        }
        //Create record in Email Queue
        if (!SFAccountList[0].Disable_transactional_emails__c) {
            Email_Sync_Queue__c emailQueue = CreateEmailQueue(SFAccountList[0]);
            emailQueue.Status__c = 'Not Started';
            emailQueue.Pause_From__c = suspendDate;
            emailQueue.Pause_Until__c = resumeDate;
            emailQueue.Dispatch_ID__c = emailSettingMap.get('FlowEdit/SetPause').Dispatch_ID__c;
            emailQueue.Email_Name__c = 'Creates or edits scheduled Pause';
            insert emailQueue;
        }
    }
    
    /**
     * @ Author : Nayan Behera (Cognizant Technology Solutions)
     * @ Date : 01/04/2017
     * @ Description : Apex Method implementing the logic for FLOW 4: Standard cancellation Pause
    **/       
    public static void StandardCancellationPause_FLOW_4(Messaging.inboundEmail email){
        
        //Local Variables
        list<Zuora__Subscription__c> subscriptionRecList = new list<Zuora__Subscription__c>();
        // Parse JSON response to get all the field values.
        String emailBodyStr = email.htmlBody;
        Map<String, Object> mapParentObj = (Map<String, Object>) JSON.deserializeUntyped(emailBodyStr);
        //Fetch the Salesforce account details from billing account 
		list<Account> SFAccountList = (list<Account>) retrieveSFRecords(mapParentObj,'Subscription','Account',null,'StandardCancellationPause');
		
        SFAccountList[0].Submitted_for_cancellation__c = false;
        update SFAccountList[0];
        //Update Pause History
        list<Pause_History__c> pauseHistoryList = [Select Id,Account__c From Pause_History__c where Account__c =: SFAccountList[0].Id AND Action_Performed__c= 'Cancel subscription' order by CreatedDate DESC limit 1];                 
        if(pauseHistoryList <> null && pauseHistoryList.size() > 0){
        	pauseHistoryList[0].Status__c = 'Success';
        	update pauseHistoryList[0];    
        } 
    }
    
    /**
     * @ Author : Nayan Behera (Cognizant Technology Solutions)
     * @ Date : 01/04/2017
     * @ Description : Apex Method implementing the logic for FLOW 5: Immediate cancellation Pause
    **/       
    public static void ImmediateCancellationPause_FLOW_5(Messaging.inboundEmail email){
        
        //Local Variables
        list<Zuora__Subscription__c> subscriptionRecList = new list<Zuora__Subscription__c>();
        // Parse JSON response to get all the field values.
        String emailBodyStr = email.htmlBody;
        Map<String, Object> mapParentObj = (Map<String, Object>) JSON.deserializeUntyped(emailBodyStr);
        //Fetch the Salesforce account details from billing account 
		list<Account> SFAccountList = (list<Account>) retrieveSFRecords(mapParentObj,'Subscription','Account',null,'ImmediateCancellationPause');
		
        list<Pause_History__c> pauseHistoryList = [Select Id,Account__c From Pause_History__c where Account__c =: SFAccountList[0].Id AND Action_Performed__c= 'Cancel subscription' order by CreatedDate DESC limit 1];                 
        if(pauseHistoryList <> null && pauseHistoryList.size() > 0){
        	pauseHistoryList[0].Status__c = 'Success';
        	update pauseHistoryList[0];    
        } 
    	Task taskPause = CreateTask(SFAccountList[0]);
        taskPause.Subject = Label.Task_Subject_2;
		taskPause.Description = Label.Task_Description_3;
        insert taskPause;
    }
    
    /**
     * @ Author : Nayan Behera (Cognizant Technology Solutions)
     * @ Date : 01/04/2017
     * @ Description : Apex Method implementing the logic for FLOW 6: Changing resume dates while in pause
    **/       
    public static void ChangingResumeDatesWhileInPause_FLOW_6(Messaging.inboundEmail email){
        
        //Local Variables
        list<Zuora__Subscription__c> subscriptionRecList = new list<Zuora__Subscription__c>();
        // Parse JSON response to get all the field values.
        String emailBodyStr = email.htmlBody;
        Map<String, Object> mapParentObj = (Map<String, Object>) JSON.deserializeUntyped(emailBodyStr);
        //Fetch the Salesforce account details from billing account 
		list<Account> SFAccountList = (list<Account>) retrieveSFRecords(mapParentObj,'Subscription','Account',null,'ChangingResumeDatesWhileInPause');
		//Fetch the Resume Date from the workflow
        map<String,object> workFlowMap = (map<String,object>) mapParentObj.get('Workflow'); 
        Date resumeDate = setStringToDateFormat((String) workFlowMap.get('ResumeDate'));
        
        SFAccountList[0].Pause_Until__c = resumeDate;
        update SFAccountList[0];
        //Update Pause History
        list<Pause_History__c> pauseHistoryList = [Select Id,Account__c From Pause_History__c where Account__c =: SFAccountList[0].Id AND 
        											Pause_Until__c =: resumeDate AND Action_Performed__c= 'Edit resume dates in pause' order by CreatedDate DESC limit 1];                 
        if(pauseHistoryList <> null && pauseHistoryList.size() > 0){
        	pauseHistoryList[0].Status__c = 'Success';
        	update pauseHistoryList[0];    
        } 
        //Create record in Email Sync Queue
        if (!SFAccountList[0].Disable_transactional_emails__c) {
            Email_Sync_Queue__c emailQueue = CreateEmailQueue(SFAccountList[0]);
            emailQueue.Status__c = 'Not Started';
            emailQueue.Pause_From__c = SFAccountList[0].Pause_From__c;
            emailQueue.Pause_Until__c = resumeDate;
            emailQueue.Account_Status__c = 'Paused';
            emailQueue.Plan_Details__c = '';
            emailQueue.Dispatch_ID__c = emailSettingMap.get('FlowChangeResumePause').Dispatch_ID__c;
            emailQueue.Email_Name__c = 'Edits Restart date during Pause';
            insert emailQueue;
        }
    }
    
    /**
     * @ Author : Nayan Behera (Cognizant Technology Solutions)
     * @ Date : 01/04/2017
     * @ Description : Apex Method implementing the logic for FLOW 7: Change Resume Date when NOT in Pause success
    **/       
    public static void ChangeResumeDatesNotInPause_FLOW_7(Messaging.inboundEmail email){
        
        //Local Variables
        list<Zuora__Subscription__c> subscriptionRecList = new list<Zuora__Subscription__c>();
        // Parse JSON response to get all the field values.
        //String emailBodyStr = email.plaintextbody;
        String emailBodyStr = email.htmlBody;
        Map<String, Object> mapParentObj = (Map<String, Object>) JSON.deserializeUntyped(emailBodyStr);
        //Fetch the Salesforce account details from billing account 
		list<Account> SFAccountList = (list<Account>) retrieveSFRecords(mapParentObj,'Subscription','Account',null,'ChangingResumeDatesWhileInPause');
		//Fetch the Resume Date from the workflow
        map<String,object> workFlowMap = (map<String,object>) mapParentObj.get('Workflow'); 
        Date resumeDate = setStringToDateFormat((String) workFlowMap.get('ResumeDate'));
        SFAccountList[0].Pause_Until__c = resumeDate;
        update SFAccountList[0];
        //Update Pause History
        list<Pause_History__c> pauseHistoryList = [Select Id,Account__c From Pause_History__c where Account__c =: SFAccountList[0].Id AND 
        											Pause_Until__c =: resumeDate AND Action_Performed__c= 'Edit Pause' order by CreatedDate DESC limit 1];                 
        if(pauseHistoryList <> null && pauseHistoryList.size() > 0){
        	pauseHistoryList[0].Status__c = 'Success';
        	update pauseHistoryList[0];    
        } 
        //Create record in Email Sync Queue
        if (!SFAccountList[0].Disable_transactional_emails__c) {
            Email_Sync_Queue__c emailQueue = CreateEmailQueue(SFAccountList[0]);
            emailQueue.Status__c = 'Not Started';
            emailQueue.Pause_From__c = SFAccountList[0].Pause_From__c;
            emailQueue.Pause_Until__c = resumeDate;
            emailQueue.Plan_Details__c = '';
            emailQueue.Dispatch_ID__c = emailSettingMap.get('FlowEdit/SetPause').Dispatch_ID__c;
            emailQueue.Email_Name__c = 'Creates or edits scheduled Pause';
            insert emailQueue;
        }
    }
    
	/**
     * @ Author : Nayan Behera (Cognizant Technology Solutions)
     * @ Date : 01/04/2017
     * @ Description : Apex Method retrieving data from Salesforce depending on request
    **/
    public static list<sObject> RetrieveSFRecords(map<String,object> sObjectParentMap,String parentNode,String ObjectType,list<Account> accList,String callOutType) { 
        //Fetch the billing account details
		list<sObject> sObjectList = new list<sObject>();
        paymentMethodType = '';
        System.debug('TestData1***'+sObjectParentMap);
        System.debug('TestData2***'+parentNode);
        System.debug('TestData3***'+ObjectType);
        map<String,object> sObjectChildMap = (map<String,object>) sObjectParentMap.get(parentNode);       
        If(ObjectType == 'Account'){
			String accountId = ((String) sObjectChildMap.get('AccountId')).trim();
			System.debug('accountId' +accountId);			
			list<Zuora__CustomerAccount__c> billingAccList = [Select Id,Zuora__Account__c,Zuora__PaymentMethod_Type__c From Zuora__CustomerAccount__c Where Zuora__Zuora_Id__c =: accountId];
			paymentMethodType = billingAccList[0].Zuora__PaymentMethod_Type__c;
            sObjectList = [Select Id,OwnerId,CurrencyIsoCode,PersonEmail,FirstName,LastName,Pause_From__c,Pause_Until__c,Disable_transactional_emails__c From Account Where Id =: billingAccList[0].Zuora__Account__c];
		}
		System.debug(sObjectList);
		return sObjectList;	
    }
    
	/**
     * @ Author : Nayan Behera (Cognizant Technology Solutions)
     * @ Date : 01/04/2017
     * @ Description : Apex Method creating pause history record
    **/
    public static Pause_History__c CreatePauseHistory(Id accountId){
		Pause_History__c pauseHistory = new Pause_History__c();
		pauseHistory.Account__c = accountId;
        pauseHistory.Pause_From__c = null;
        pauseHistory.Pause_Until__c = null;
        pauseHistory.Action_Performed__c = 'Early resume';
        pauseHistory.Subscription_Cancellation_Date__c = null;
		pauseHistory.Status__c = 'Success';
		return pauseHistory;
	}
	
	/**
     * @ Author : Nayan Behera (Cognizant Technology Solutions)
     * @ Date : 01/04/2017
     * @ Description : Apex Method retrieving data from Salesforce depending on request
    **/
    public static Email_Sync_Queue__c CreateEmailQueue(Account SFAccount){
		Email_Sync_Queue__c emailQueue = new Email_Sync_Queue__c();
        emailQueue.Account__c = SFAccount.Id;
		emailQueue.Account_Currency__c = SFAccount.CurrencyIsoCode;
		emailQueue.Account_Status__c = 'Active Paid';
		emailQueue.First_Name__c = SFAccount.FirstName;
		emailQueue.Last_Name__c = SFAccount.LastName;
		emailQueue.Person_Email__c = SFAccount.PersonEmail;
		emailQueue.Plan_Details__c = 'Monthly';
        emailQueue.Type_of_Email__c = 'Triggered Dispatch';
		return emailQueue;
	}

	/**
     * @ Author : Nayan Behera (Cognizant Technology Solutions)
     * @ Date : 01/04/2017
     * @ Description : Apex Method converting to appropriate date format
    **/
    public static Date setStringToDateFormat(String myDate) { 
        String[] myDateOnly = myDate.split(' ');
        String[] strDate = myDateOnly[0].split('-');       
        Integer myIntYear = integer.valueOf(strDate[0]);
        Integer myIntMonth = integer.valueOf(strDate[1]);
		Integer myIntDate = integer.valueOf(strDate[2]);        
        Date convertedDate = Date.newInstance(myIntYear,myIntMonth,myIntDate);
        return convertedDate;
    }
    
    /**
     * @ Author : Nayan Behera (Cognizant Technology Solutions)
     * @ Date : 01/04/2017
     * @ Description : Apex Method to create task
    **/
    public static Task CreateTask(Account SFAccount) { 
        Task accTask = new Task(); 
        accTask.WhatId = SFAccount.Id; 
        accTask.Subject = Label.Task_Subject_1;
        accTask.Description = Label.Task_Description_1;
        accTask.OwnerId = SFAccount.OwnerId;
        accTask.Status = 'Completed';
        accTask.Priority = 'Medium';
        accTask.CurrencyIsoCode = SFAccount.CurrencyIsoCode;
      	System.debug('accTask'+accTask);
        return accTask;
    }
}