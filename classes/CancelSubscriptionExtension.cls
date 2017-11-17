/**
* @author Cognizant Technology Solutuions
* @date 10/12/2015
* @description Cancel Subscription Extension class for service agent cancel subscription operation
*/

public without sharing class CancelSubscriptionExtension{
    public string reasonForCncl{get;set;}
    public Boolean showSubmitButton {get; set;}
    public Boolean showErrMsg{get;set;}
    public string cancellationType {get; set;}
    @TestVisible
    public List<Account> lstAccount {get;set;}
    private string sAccountID {get;set;}
    //public Boolean activeSubscriptions{get;set;}
    public string sAccountStatus{get;set;}
    public Boolean isFreeTrialAccount{get;set;}
    public string sPersonContactId {get;set;}
    public string sEmail {get;set;}
    public string sUserLanguage {get;set;}
    public string sUserCountryCode{get;set;}
    
    public Boolean isPauseScheduled {get;set;}
    String serviceStartDate/* = null*/;
    public List<Zuora__Payment__c> chosePayment;
    /*
Description: Constructor, used to enable / disable Cancel & Refund buttons based on subscription status.
*/
    public CancelSubscriptionExtension(ApexPages.StandardController controller) {
        // To get account id from controller PD-7932.
        sAccountID = controller.getId();
        showSubmitButton = true;
        isFreeTrialAccount = false;
        showErrMsg = false;
        serviceStartDate = null;

        /* Retrive subscriptions information for customer.*/
        if(sAccountID!=null){
            lstAccount =  [SELECT ID, Account_Status__c, PersonContactId, PersonEmail, Notification_Language_Code__c, Notification_Country_Code__c, Pause_From__c, PauseScheduled__c, Pause_Until__c, Previous_BCD__c,
                           (SELECT Name, Zuora__Status__c, Zuora__NextRenewalDate__c,Zuora__External_Id__c,Zuora__NextChargeDate__c, Zuora__SubscriptionEndDate__c 
                            FROM Zuora__Subscriptions__r 
                            Where Zuora__Status__c='Active'
                            Order By Zuora__SubscriptionStartDate__c 
                            DESC NULLS LAST)                                                    
                           FROM Account 
                           WHERE ID=:sAccountID 
                           LIMIT 1];
        }
        
        if(lstAccount !=null && !lstAccount.isEmpty()){
            sAccountStatus = lstAccount[0].Account_Status__c;
            sPersonContactId = lstAccount[0].PersonContactId;
            isPauseScheduled = lstAccount[0].PauseScheduled__c;
            sEmail = lstAccount[0].PersonEmail;
            sUserLanguage = lstAccount[0].Notification_Language_Code__c;
            sUserCountryCode = lstAccount[0].Notification_Country_Code__c;
            if(sAccountStatus == 'Partial' || sAccountStatus== 'Frozen' ||sAccountStatus == 'Expired'||sAccountStatus == 'Expired Marketing'){
                apexpages.addmessage(new apexpages.message(ApexPages.severity.INFO, System.Label.LS_CancelSubscription_ErrMsg_NoCancellation));
                showErrMsg = true;
                return;
            }
            if(sAccountStatus == 'Free Trial'){
                isFreeTrialAccount = true ;
            }
            if(lstAccount[0].Zuora__Subscriptions__r == null || lstAccount[0].Zuora__Subscriptions__r.isEmpty() )
            {
                apexpages.addmessage(new apexpages.message(ApexPages.severity.INFO, System.Label.LS_CancelSubscription_ErrMsg_NoActiveSubscription));
                showErrMsg = true;return;
            }
            
        }else{
            apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, System.Label.LS_CancelSubscription_Page_Message_No_Account_Found ));
            showSubmitButton = false;return;
        }                       
    }


    /*
    Description: Method to cancel the subscription and create a Refund based on cancellation type
    */
    public PageReference CancelSubscription() { 
        if (String.isNotBlank(reasonForCncl)) {
            reasonForCncl = reasonForCncl.replace('&amp;', '&');
        } else {
            reasonForCncl = 'Others';
        }
        Boolean bGenerateInvoice = false;
        showErrMsg = false;
        try {
            /* Check option is selected for cancellation.*/
            if (String.isNotBlank(cancellationType)) {
                /*Check if Cancellation Reason is specified*/
                if (String.isNotBlank(reasonForCncl)) {
                    Zuora__Subscription__c oSubscription = lstAccount[0].Zuora__Subscriptions__r[0];
                    /*Check Account has atleast one subscription and the subscription is active*/
                    if (lstAccount[0].Zuora__Subscriptions__r.size() > 0 && oSubscription.Zuora__Status__c == 'Active') {
                        if(cancellationType != 'Immediate') {
                            /*Start part of PD-11896. Standard cancelation Pause in Future*/
                            // std cancel for future pause
                            if (sAccountStatus == 'Paused') {
                                /*Standard cancelation Pause started*/
                                apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, System.Label.LS_MyAccount_StCancelationNotPossible));
                                showErrMsg = true;
                                return null;
                            } else if (sAccountStatus == 'Active Grace') {
                                apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, System.Label.LS_MyAccount_StCancelationForActiveGraceNotPossible));
                                showErrMsg = true;
                                return null;
                            } else {
                                //added as part of PD-13271
                                Date ratePlanChargeChargedThroughDate = ZuoraTransactionHelper.getRatePlanChargeChargedThroughDateByAccountId(sAccountID);
                                if (ratePlanChargeChargedThroughDate != null) {
                                    serviceStartDate = CommunityHelper.ConvertDateToString(ratePlanChargeChargedThroughDate,'ZouraFormat','NA');
                                } else {
                                    apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, System.Label.LS_CancelSubscription_ErrMsg_NoRatePlanCharge));
                                    showErrMsg = true;return null;
                                }
                                
                                if (isPauseScheduled) {
                                    return startFlowStandartFuture();
                                } else {
                                    return startStandardCancelZuoraWorkflow(oSubscription.Name, serviceStartDate);
                                }
                            }
                        } else {
                             String paymentId = '';
                             serviceStartDate = CommunityHelper.ConvertDateToString(Date.today(), 'ZouraFormat', 'NA');
                             bGenerateInvoice = true;
                            //PD-11761
                            List<Zuora__Payment__c> paymentRecObj = new List<Zuora__Payment__c>();
                            if (lstAccount.size() > 0) {
                                paymentRecObj = [
                                    SELECT Id, Name, Zuora__EXT_ID__c, Zuora__SettledOn__c, Zuora__CreatedDate__c, Zuora__Account__c
                                    FROM Zuora__Payment__c
                                    WHERE Zuora__Account__c = :lstAccount[0].Id ORDER BY Zuora__CreatedDate__c DESC
                                ];
                            }
                            if (paymentRecObj.size() > 0) {
                                if (paymentRecObj[0].Zuora__SettledOn__c != null) {
                                    paymentId = paymentRecObj[0].Zuora__EXT_ID__c;

                                    /*Start part of PD-11761*/
                                    if (!String.isBlank(paymentId)) {
                                        List<Zuora__Refund__c> refunds = [SELECT Zuora__Payment__c FROM Zuora__Refund__c WHERE Zuora__Payment__c = :paymentRecObj[0].Id];
                                        if (!refunds.isEmpty()) {
                                            paymentId = null;
                                        }
                                    }
                                    /*End part of PD-11761*/

                                } else{
                                    apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, System.Label.LS_CancelSubscription_Page_Message_No_Settled_On));
                                    showErrMsg = true;
                                    return null;
                                }
                            }
                            
                            if (isPauseScheduled) {
                                return startFlowImmediateFuture();
                            } else {
                                System.debug('##### paymentId = ' + paymentId);
                                return startImmediateCancelZuoraWorkflow(oSubscription.Name, serviceStartDate, paymentId);
                            }

                        }

                    } else {
                        apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, System.Label.LS_CancelSubscription_ErrMsg_NoActiveSubscription ));
                        showErrMsg = true;
                        return null;
                    }
                } else {
                    showSubmitButton = false;
                }
            } else {
                showSubmitButton = false;
            }
        } catch (Exception ex) {
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CancelSubscriptionExtension ', 'cancelSubscription', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
        if (showErrMsg) {
            return null;
        } else {
            return new PageReference('/' + sAccountId);
        }
    }
    
   

    public static void updateAccountStatusPause(Id sId, string sStatus){
        if(sId != null){
            Account objAccount=[Select ID, Account_Status__c, Submitted_for_cancellation__c, Cancelled_Account__c, Pause_From__c, PauseScheduled__c, Pause_Until__c, Previous_BCD__c From Account where ID =:sId Limit 1];
            if (sStatus != null) {
                objAccount.Account_Status__c = sStatus;
            }
            objAccount.Submitted_for_cancellation__c = true;
            objAccount.Pause_Until__c = null;
            objAccount.Pause_From__c = null;
            objAccount.Cancelled_Account__c = true;
            update objAccount;
        }
    }

    public PageReference startFlowStandartFuture() {
        Map<String, String> outputResult = PauseCalloutHelper.initPauseCalloutScheduledFuture(lstAccount[0], true);
        Boolean isResultSuccess = Boolean.valueOf(outputResult.get('success'));
        if (!isResultSuccess) {
            apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, System.Label.LS_MyAccount_FailSubscriptionPause));
            showErrMsg = true;
            return null;
        } else {
            updateAccountStatusPause(lstAccount[0].Id, null);
            createTaskForCancelation();
            apexpages.addmessage(new apexpages.message(ApexPages.severity.CONFIRM, System.Label.LS_CancelSubscription_Page_Message_Standard_Cancelled_Success));
            showErrMsg = true;
            return null;
        }
    }

    public PageReference startFlowImmediateFuture() {
        Map<String, String> outputResult = PauseCalloutHelper.initPauseCalloutScheduledFuture(lstAccount[0], false);
        Boolean isResultSuccess = Boolean.valueOf(outputResult.get('success'));
        if (isResultSuccess) {
            updateAccountStatusPause(lstAccount[0].Id, 'Frozen');
            createTaskForCancelation();
            //CommunityHelper.updateSignoutKey(lstAccount[0].Id); //Commented Redundant code as part of PD-11487
            apexpages.addmessage(new apexpages.message(ApexPages.severity.CONFIRM, System.Label.LS_MyAccount_SuccessSubscriptionPause));
            showErrMsg = true;
            return null;
        } else {
            apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, System.Label.LS_MyAccount_FailSubscriptionPause));
            showErrMsg = true;
            return null;
        }
    }
    
    public PageReference startImmediateCancelZuoraWorkflow(String subscriptionName, String cancelDate, String paymentId) {
        Map<String, String> outputResult = PauseCalloutHelper.runImmediateCancelZuoraWorkflow(subscriptionName, cancelDate, paymentId);
        Boolean isResultSuccess = Boolean.valueOf(outputResult.get('success'));
        if (isResultSuccess) {
            updateAccountFieldsAndStatusToFrozen(true);
            createTaskForCancelation();
            return null;
        } else {
            apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, outputResult.get('message')));
            showErrMsg = true;
            return null;
        }
    }
    
    public PageReference startStandardCancelZuoraWorkflow(String subscriptionName, String cancelDate) {
        Map<String, String> outputResult = PauseCalloutHelper.runStandardCancelZuoraWorkflow(subscriptionName, cancelDate);
        Boolean isResultSuccess = Boolean.valueOf(outputResult.get('success'));
        if (isResultSuccess) {
            List<Account> acc = [
                SELECT Id, Submitted_for_cancellation__c, Cancelled_Account__c
                FROM Account 
                WHERE Id =:sAccountID LIMIT 1
            ];
            if (acc != null && !acc.isEmpty()) {
                acc[0].Submitted_for_cancellation__c = true;
                acc[0].Cancelled_Account__c = true;
                update acc[0];
            }
            createTaskForCancelation();
            return new PageReference('/' + sAccountId);
        } else {
            apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, System.Label.LS_MyAccount_FailSubscriptionPause));
            showErrMsg = true;
            return null;
        }
    }

    public void createTaskForCancelation() {
        insert new Task(
            ActivityDate = system.today(),
            Description = reasonForCncl,
            Status = 'Completed',
            Subject = Label.LS_Why_Subscription_Cancellation,
            OwnerId = userinfo.getUserId(),
            WhatId = sAccountID
        );
    }

    /*Update Account Status on successful cancellation to "Frozen" */
    public void updateAccountFieldsAndStatusToFrozen(Boolean isShowMessage) {
        CommunityHelper.updateAccountStatus(sAccountID, 'Frozen');
                                                    
        apexpages.addmessage(new apexpages.message(ApexPages.severity.CONFIRM, System.Label.LS_CancelSubscription_Page_Message_Immediate_Cancelled_Success));
        showErrMsg = isShowMessage;
        // delete the user registered devices
        List<User_Devices__c> lstAllUserDevices = [
            SELECT Status__c
            FROM User_Devices__c 
            WHERE Account__c =:sAccountID and Status__c='Active' 
            LIMIT 100
        ];
        if (lstAllUserDevices!=null && !lstAllUserDevices.isEmpty()) {
            delete lstAllUserDevices;
        }
    }

    public static void updateAccountStatusAfterCancelSubscription(String accId, String effectiveDate) {
        Account accountToUpdate = [SELECT Id, Account_Status__c, Cancelled_Account__c FROM Account WHERE Id = :accId];
        Date dEffectiveDate = Date.valueOf(effectiveDate);
        if (dEffectiveDate <= Date.today()) {
            accountToUpdate.Account_Status__c = 'Frozen';
            accountToUpdate.Cancelled_Account__c = true;
        }
        update accountToUpdate;
    }
    
}