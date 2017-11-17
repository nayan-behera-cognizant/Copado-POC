/**
* @ Author : Nayan Behera (Cognizant Technology Solutions)
* @ Date : 31/03/2017
* @ Description : Apex class handling the logic for pause REST services
* @ Modified BY : Megha Jain
* @ Modified Date : 25/07/2017
**/
public class RestServiceForPauseCalloutHelper {
    
    //Global Variables
    public static Map<string,Pause_Email_Service_Setting__c> emailSettingMap = Pause_Email_Service_Setting__c.getAll();
    public static String paymentMethodType;    
    public restServiceCalloutwrapper wrap {get;set;}
	
	
	
    /**
* @ Author : Nayan Behera (Cognizant Technology Solutions)
* @ Date : 31/03/2017
* @ Description : Apex Method implementing the logic for FLOW 1: Immediate Resume (Cancel Pause when already Paused)
* @ Modified BY : Megha Jain
* @ Modified Date : 25/07/2017
**/       
    public static void ImmediateResumePauseLogic(String JSONRequest){
        
        Date resumeDate;
        // Parse JSON response to get all the field values.
        
        restServiceForImmediateResumeWrapper.RootObject ro = (restServiceForImmediateResumeWrapper.RootObject)JSON.deserialize(JSONRequest,restServiceForImmediateResumeWrapper.RootObject.class);
        String accountId = ro.Subscription[0].AccountId;
        String resumeDt =  ro.Workflow.ResumeDate ;
        
        //Fetch the Salesforce account details from billing account 
        list<Account> SFAccountList = (list<Account>) RetrieveAccount(accountId );
        
        if (SFAccountList!=null && SFAccountList.size()>0){
            SFAccountList[0].Pause_Until__c = null;
            SFAccountList[0].Submitted_for_cancellation__c = false;
            update SFAccountList;
            
            //Create Pause History
            insert CreatePauseHistory(SFAccountList[0].Id);
            //Create record in Email Queue
            if (!SFAccountList[0].Disable_transactional_emails__c) {
                Email_Sync_Queue__c emailQueue = CreateEmailQueue(SFAccountList[0]);
                //Fetch the Resume Date from the workflow
                //If there is no resume date in JSON request then fetch resume date from Account
                if (resumeDt!='' && resumeDt!= null) {
                    resumeDate = setStringToDateFormat(resumeDt);
                } else if (SFAccountList[0] != null && SFAccountList.Size() > 0 && SFAccountList[0].Pause_Until__c <> null) {
                    resumeDate = SFAccountList[0].Pause_Until__c;
                }
                emailQueue.Free_Trial_End_Date__c = resumeDate.addMonths(1);
                emailQueue.Status__c = 'Not Started';
                emailQueue.Payment_Method_Type__c = paymentMethodType; //Changed as per PD-12323 @ Release: Cog 1.6.2
                emailQueue.Pause_From__c = null;
                emailQueue.Pause_Until__c = null;
                emailQueue.Dispatch_ID__c = emailSettingMap.get('FlowEarlyResume').Dispatch_ID__c;
                emailQueue.Email_Name__c = 'Welcome Back from Pause';
                insert emailQueue;
            }
        }
    }
    
    /**
* @ Author : Nayan Behera (Cognizant Technology Solutions)
* @ Date : 01/04/2017
* @ Description : Apex Method implementing the logic for FLOW 2: Cancel Pause Before Pause starts
* @ Modified BY : Megha Jain
* @ Modified Date : 25/07/2017
**/      
    public static void CancelPauseLogic(String JSONRequest){
        
        //Local Variables
        
        Date resumeDate;
        // Parse JSON response to get all the field values.
        restServiceForCancelPauseWrapper.RootObject ro = (restServiceForCancelPauseWrapper.RootObject)JSON.deserialize(JSONRequest,restServiceForCancelPauseWrapper.RootObject.class);
        String accountId = ro.Subscription[0].AccountId;
        String resumeDt =  ro.Workflow.ExecutionDate ;
        //Fetch the Salesforce account details from billing account 
        list<Account> SFAccountList = (list<Account>) RetrieveAccount(accountId );
        //Create record in Email Sync Queue
        if (SFAccountList != null && SFAccountList.size() > 0) {
            if (!SFAccountList[0].Disable_transactional_emails__c) {
                Email_Sync_Queue__c emailQueue = CreateEmailQueue(SFAccountList[0]);
                //Fetch the Resume Date from the workflow
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
            list<Pause_History__c> pauseHistoryList = [Select Id,Account__c From Pause_History__c where Account__c =: SFAccountList[0].Id AND Action_Performed__c= 'Cancel scheduled pause' order by CreatedDate DESC limit 1];                 
            
            if(pauseHistoryList != null && pauseHistoryList.size() > 0){
                pauseHistoryList[0].Status__c = 'Success';
                update pauseHistoryList[0];    
            } 
            //Update Account
            SFAccountList[0].Pause_From__c = null;
            SFAccountList[0].Pause_Until__c = null;
            SFAccountList[0].Submitted_for_cancellation__c = false;
            update SFAccountList[0];
        }
    }
    
    /**
* @ Author :Megha Jain(Cognizant Technology Solutions)
* @ Date : 01/04/2017
* @ Description : Apex Method implementing the logic for FLOW 3: Set Pause
* @ Modified BY : Megha Jain
* @ Modified Date : 25/07/2017
**/       
    public static void SetPauseLogic(String JSONRequest) {
        // Parse JSON response to get all the field values.
        restServiceForSetPauseWrapper.RootObject ro = (restServiceForSetPauseWrapper.RootObject)JSON.deserialize(JSONRequest, restServiceForSetPauseWrapper.RootObject.class);
        String accountId = ro.Subscription[0].AccountId;
        String resumeDt =  ro.Workflow.ResumeDate;
        string suspentDt = ro.Workflow.SuspendDate;
        
        //Fetch the Salesforce account details from billing account 
        list<Account> SFAccountList = (list<Account>) RetrieveAccount(accountId );
        
        //Update Pause History
        if (SFAccountList != null && SFAccountList.size() > 0) {
            Date resumeDate = setStringToDateFormat(resumeDt);
            Date suspendDate = setStringToDateFormat(suspentDt);
            
            list<Pause_History__c> pauseHistoryList = [Select Id,Account__c From Pause_History__c where Account__c =: SFAccountList[0].Id AND Pause_From__c =: suspendDate
                                                   AND Pause_Until__c =: resumeDate AND Action_Performed__c= 'Set Pause' order by CreatedDate DESC limit 1];
            if (pauseHistoryList <> null && pauseHistoryList.size() > 0) {
                pauseHistoryList[0].Status__c = 'Success';
                update pauseHistoryList[0];
            }
            
            SFAccountList[0].Submitted_for_cancellation__c = false;
            update SFAccountList[0];
            
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
    }
    
    /**
* @ Author : Nayan Behera (Cognizant Technology Solutions)
* @ Date : 01/04/2017
* @ Description : Apex Method implementing the logic for FLOW 4: Standard cancellation Pause
* @ Modified BY : Megha Jain
* @ Modified Date : 25/07/2017

**/      
    public static void StandardCancellationPauseLogic(String JSONRequest){
        string accountId ;
        list<Zuora__Subscription__c> zSubsList = new list<Zuora__Subscription__c>();
        list<Account> SFAccountList = new list<Account>() ;
        restServiceForStandardCancelatnWrapper.RootObject ro = (restServiceForStandardCancelatnWrapper.RootObject)JSON.deserialize(JSONRequest,restServiceForStandardCancelatnWrapper.RootObject.class);
        String subscripName = ro.Workflow.SubscriptionName;
        
        if (subscripName != null && subscripName !=''){
            
            zSubsList = [Select id , Name , Zuora__Account__c From Zuora__Subscription__c Where  Name =: subscripName];
            
            if (zSubsList!=null && zSubsList.size()>0){
                accountId  =  zSubsList[0].Zuora__Account__c ;
                SFAccountList = [Select Id,Submitted_for_cancellation__c , Account_Status__c From Account Where Id =:accountId];
                
                if (SFAccountList!=null && SFAccountList.size()>0){
                    SFAccountList[0].Submitted_for_cancellation__c = false;
                    update SFAccountList[0];
                    //Update Pause History
                    list<Pause_History__c> pauseHistoryList = [Select Id,Account__c From Pause_History__c where Account__c =: SFAccountList[0].Id AND Action_Performed__c= 'Cancel subscription' order by CreatedDate DESC limit 1];                 
                    if(pauseHistoryList <> null && pauseHistoryList.size() > 0){
                        pauseHistoryList[0].Status__c = 'Success';
                        update pauseHistoryList[0];
                    }
                }   
            } 
        } 
    }
    
    /**
* @ Author : Nayan Behera (Cognizant Technology Solutions)
* @ Date : 01/04/2017
* @ Description : Apex Method implementing the logic for FLOW 5: Immediate cancellation Pause
* @ Modified BY : Megha Jain
* @ Modified Date : 25/07/2017
**/      
    public static void ImmediateCancellationPauseLogic(String JSONRequest){
        
        
        // Parse JSON response to get all the field values.
        restSeriveForImmediateCancelatnWrapper.RootObject ro = (restSeriveForImmediateCancelatnWrapper.RootObject)JSON.deserialize(JSONRequest,restSeriveForImmediateCancelatnWrapper.RootObject.class);
        String accountId = ro.Subscription[0].AccountId;
        //Fetch the Salesforce account details from billing account 
        list<Account> SFAccountList = (list<Account>) RetrieveAccount(accountId );
        if (SFAccountList!=null && SFAccountList.size()>0){
            
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
    }
    
    /**
* @ Author : Nayan Behera (Cognizant Technology Solutions)
* @ Date : 01/04/2017
* @ Description : Apex Method implementing the logic for FLOW 6: Changing resume dates while in pause
* @ Modified BY : Megha Jain
* @ Modified Date : 25/07/2017
**/      
    public static void ChangingResumeDatesWhileInPauseLogic(String JSONRequest){
        
        restSeriveForChngResumDtInPauseWrapper.RootObject ro = (restSeriveForChngResumDtInPauseWrapper.RootObject)JSON.deserialize(JSONRequest,restSeriveForChngResumDtInPauseWrapper.RootObject.class);
        //Fetch the Salesforce account details from billing account 
        String accountId = ro.Subscription[0].AccountId;
        String resumeDt =  ro.Workflow.ResumeDate;
        list<Account> SFAccountList = (list<Account>) RetrieveAccount(accountId );
        
        if (SFAccountList!=null && SFAccountList.size()>0){
            Date resumeDate = setStringToDateFormat(resumeDt);
            
            SFAccountList[0].Pause_Until__c = resumeDate;
            
            SFAccountList[0].Submitted_for_cancellation__c = false;
            
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
        
    }  /**
* @ Author : Nayan Behera (Cognizant Technology Solutions)
* @ Date : 01/04/2017
* @ Description : Apex Method implementing the logic for FLOW 7: Change Resume Date when NOT in Pause success
* @ Modified BY : Megha Jain
* @ Modified Date : 25/07/2017
**/   
    public static void ChangeResumeDatesNotInPauseLogic(String JSONRequest){
        
        // Parse JSON response to get all the field values.
        restSeriveForChngResumDtSchPauseWrapper.RootObject ro = (restSeriveForChngResumDtSchPauseWrapper.RootObject)JSON.deserialize(JSONRequest,restSeriveForChngResumDtSchPauseWrapper.RootObject.class);
        //Fetch the Salesforce account details from billing account 
        String accountId = ro.Subscription[0].AccountId;
        String resumeDt =  ro.Workflow.ResumeDate;
        //Fetch the Salesforce account details from billing account 
        list<Account> SFAccountList = (list<Account>) RetrieveAccount(accountId );
        //Fetch the Resume Date from the workflowretrieveSFRecords
        if (SFAccountList!=null && SFAccountList.size()>0){
            
            Date resumeDate = setStringToDateFormat(resumeDt );
            SFAccountList[0].Pause_Until__c = resumeDate;
            SFAccountList[0].Submitted_for_cancellation__c = false;
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
    }
    
    /**
* @ Author : Megha Jain (Cognizant Technology Solutions)
* @ Date : 01/04/2017
* @ Description : Apex Method retrieving Account from Salesforce depending on request
**/
    public static list<sObject> RetrieveAccount(String accID) { 
        //Fetch the billing account details
        list<sObject> sObjectList = new list<sObject>();
        
        String accountId = accID;
        
        list<Zuora__CustomerAccount__c> billingAccList = [Select Id,Zuora__Account__c,Zuora__PaymentMethod_Type__c From Zuora__CustomerAccount__c Where Zuora__Zuora_Id__c =: accountId];
        paymentMethodType = billingAccList[0].Zuora__PaymentMethod_Type__c;
        sObjectList = [Select Id, OwnerId, CurrencyIsoCode, PersonEmail, FirstName, LastName, Pause_From__c, Pause_Until__c, Submitted_for_cancellation__c, Disable_transactional_emails__c From Account Where Id =: billingAccList[0].Zuora__Account__c];
        
        return sObjectList; 
    }
    
    /**
* @ Author : Cognizant Technology Solutions
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
        
        return accTask;
    }
    
    /**
* @ Author :Megha Jain(Cognizant Technology Solutions)
* @ Date : 01/07/2017
* @ Description : Apex Method for handling rest callout to Freeze Account
**/     
    public static void fetchAccountFromjson(String JSONRequest) {
        List<Account> accountList = new List<Account>();
        String sZuoraBillingAccountID;
        
        restServiceCalloutwrapper.RootObject ro = (restServiceCalloutwrapper.RootObject)JSON.deserialize(JSONRequest,restServiceCalloutwrapper.RootObject.class);
        String accountId = (String.isNotBlank(ro.AccountId)) ? ro.AccountId : ro.Refund[0].AccountId;
        
        List<Zuora__CustomerAccount__c> billingAccList = [Select Id, Zuora__Account__c, Zuora__PaymentMethod_Type__c, Zuora__External_Id__c From Zuora__CustomerAccount__c Where Zuora__Zuora_Id__c = :accountId];
        List<Zuora.zObject> lstZSubscriptions = new List<Zuora.zObject>();
        
        if (billingAccList != null || billingAccList.size() > 0) {
            accountList = [Select Id, OwnerId, CurrencyIsoCode, PersonEmail, FirstName, LastName, Pause_From__c, Pause_Until__c, Account_Status__c From Account Where Id = :billingAccList[0].Zuora__Account__c];
            //sZuoraBillingAccountID = billingAccList[0].Zuora__External_Id__c ;
            //lstZSubscriptions = ZuoraTransactionHelper.zQuery('Select CreatedDate,Status,TermEndDate,SubscriptionEndDate,ID,AccountId From Subscription where Status=\'Active\' AND AccountId=\'' + sZuoraBillingAccountID + '\' ');
            //if (lstZSubscriptions == null && accountList != null && accountList.size() > 0) {
                accountList[0].Account_Status__c = 'Frozen';
                update accountList;
            //}
        }
    }
    
}