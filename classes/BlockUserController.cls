/**
* @author Cognizant Technology Solutuions
* @date 20/04/2016
* @description Block User  class
*/

global with sharing class BlockUserController {

    public String refundstatus { get; set; }
    public Account acc { get; set; }
    public String sAccountId { get; set; }
    public String Comment { get; set; }
    public User logInUser;
    public String sEffectiveDate = null;
    public boolean bShowPanel { get; set; }
    public boolean navigateError { get; set; }
    public String typeOfAccount { get; set; }
    
    /*Constructor*/
    public BlockUserController() {
        navigateError = false;
        if (ApexPages.CurrentPage() != null) {
            sAccountId = ApexPages.CurrentPage().getparameters().get('aId');
            //Validation on Account Id, if in case invalid Account id setting navigate Error flag to true *PD-7932*. 
            if (sAccountId != null  && sAccountId != '' && String.escapeSingleQuotes(sAccountId).isAlphanumeric()) {
                if (Schema.sObjectType.User.fields.AccountID.isAccessible()) {
                    List<User> userResults = [
                        SELECT Name, FirstName,LastName,Email,UserName,AccountID, CountryCode, Country, contactId, LanguageLocaleKey
                        FROM User
                        WHERE AccountID=:sAccountId
                    ]; 
                    if (userResults != null && userResults.size() > 0) {
                        logInUser = userResults[0];
                    } else {
                        reportErrorWithoutReturn(System.Label.LS_BlockUser_MissingInfo);
                    }
                }
                
                List<Account>  accList = [
                    SELECT Id, Firstname, LastName, Account_Status__c, Cancelled_Account__c, OwnerId, Type, Partner_ID__c,
                       (SELECT Name, Zuora__Status__c, Zuora__NextRenewalDate__c, Zuora__External_Id__c,Zuora__NextChargeDate__c, Zuora__SubscriptionEndDate__c 
                        FROM Zuora__Subscriptions__r
                        WHERE Zuora__Status__c = 'Active'
                        ORDER BY Zuora__SubscriptionStartDate__c DESC NULLS LAST)
                    FROM Account WHERE id = :sAccountId
                ];
                if (accList.size() > 0) {
                    acc = accList[0];
                    bShowPanel = true;
                } else {
                    reportErrorWithoutReturn(System.Label.LS_BlockUser_MissingInfo);
                }
            } else {
                reportErrorWithoutReturn(System.Label.LS_BlockUser_MissingInfo);
            }
        }
        
    }
    
    webservice static String saveWeb(Id accId) {
        BlockUserController ctrl = new BlockUserController();
        String result;
        ctrl.typeOfAccount = 'Apple';
        List<Account>  accList = [select id ,Firstname,LastName,Account_Status__c,Cancelled_Account__c,OwnerId,Type, Partner_ID__c, (SELECT Name, Zuora__Status__c, Zuora__NextRenewalDate__c,Zuora__External_Id__c,Zuora__NextChargeDate__c, Zuora__SubscriptionEndDate__c 
                                                                                                                                     FROM Zuora__Subscriptions__r Where Zuora__Status__c='Active'
                                                                                                                                     Order By Zuora__SubscriptionStartDate__c
                                                                                                                                     DESC NULLS LAST) from Account where id =: accId];
        
        List<User> userResults = [select Name, FirstName,LastName,Email,UserName,AccountID, CountryCode, Country, 
                                  contactId ,LanguageLocaleKey from User  where AccountID=:accId]; 
        ctrl.sAccountId = accId;

        if (userResults != null && userResults.size() > 0) {
            ctrl.logInUser = userResults[0];
            
        }
        
        if(accList.size() > 0) {
            ctrl.acc = accList[0];
        }
        
        result = JSON.serialize(String.valueOf(ctrl.save())) ;
        return result;
    }
    
    /*
      Method to do the Cancellation, User blocking
    */
    public PageReference save() {
        String cancellationType;
        Zuora__Subscription__c oSubscription;
        if (acc != null && !navigateError) {
            if (acc.Zuora__Subscriptions__r != null && acc.Zuora__Subscriptions__r.size() > 0) {
                oSubscription = acc.Zuora__Subscriptions__r[0];
            }
            
            if (refundstatus == System.Label.LS_Block_User_Without_Refund) {
                if (acc.Account_Status__c == 'Free trial') {
                    cancellationType = 'Standard';
                } else if (acc.Account_Status__c == 'Active Paid' || acc.Account_Status__c == 'Active Grace') {
                    cancellationType = 'Immediate';
                }
            } else {
                cancellationType = 'Immediate';
            }
            
            Map<String, String> outputResult = new Map<String, String>();
            
            if (cancellationType == 'Standard') {
                if (acc.Zuora__Subscriptions__r != null && acc.Zuora__Subscriptions__r.size() > 0) {
                    /*Check Account has at least one subscription and the subscription is active*/
                    if (oSubscription.Zuora__Status__c == 'Active') {
                        //added as part of PD-13271
                        Date ratePlanChargeChargedThroughDate = ZuoraTransactionHelper.getRatePlanChargeChargedThroughDateByAccountId(sAccountID);
                        if (ratePlanChargeChargedThroughDate != null) {
                            sEffectiveDate = CommunityHelper.ConvertDateToString(ratePlanChargeChargedThroughDate, 'ZouraFormat', 'NA');
                        } else {
                            return reportError(System.Label.LS_CancelSubscription_ErrMsg_NoRatePlanCharge);
                        }
                        outputResult = PauseCalloutHelper.runStandardCancelZuoraWorkflow(oSubscription.Name, sEffectiveDate);
                    }
                }
            } else if (cancellationType == 'Immediate') {
                /*Check Account has atleast one subscription and the subscription is active*/
                if (acc.Zuora__Subscriptions__r.size() > 0  && oSubscription.Zuora__Status__c == 'Active') {
                    String paymentId = '';
                    sEffectiveDate = CommunityHelper.ConvertDateToString(Date.today(), 'ZouraFormat', 'NA');
                    List<Zuora__Payment__c> paymentRecObj = new List<Zuora__Payment__c>();
                    paymentRecObj = [
                        SELECT Id, Name, Zuora__EXT_ID__c, Zuora__SettledOn__c, Zuora__CreatedDate__c, Zuora__Account__c
                        FROM Zuora__Payment__c
                        WHERE Zuora__Account__c = :acc.Id ORDER BY Zuora__CreatedDate__c DESC
                    ];
                    if (paymentRecObj.size() > 0) {
                        if (paymentRecObj[0].Zuora__SettledOn__c != null) {
                            paymentId = paymentRecObj[0].Zuora__EXT_ID__c;
                        } else {
                            return reportError(System.Label.LS_CancelSubscription_Page_Message_No_Settled_On);
                        }
                    }
                    outputResult = PauseCalloutHelper.runImmediateCancelZuoraWorkflow(oSubscription.Name, sEffectiveDate, paymentId);
                }
            }
            
            if (outputResult.get('success') != null && !Boolean.valueOf(outputResult.get('success'))) {
                if (outputResult.get('success') != null) {
                    return reportError(outputResult.get('message'));
                } else {
                    return reportError(System.Label.LS_BlockUser_FailedtoCancel);
                }
            }
            /* Updating the Account status */
            if (acc.Account_Status__c != System.Label.LS_Account_Status_Blocked) {
                if (acc.Account_Status__c == 'Free Trial') {
                    acc.Submitted_for_cancellation__c = true;
                    acc.Cancelled_Account__c = true;
                }
                acc.Account_Status__c = System.Label.LS_Account_Status_Blocked;
                acc.Cancelled_Account__c = true;
                acc.AuthKey__c = System.now(); //PD-9738 Reset the Auth Key when the user is blocked in salesforce
            } else if (acc.Account_Status__c == System.Label.LS_Account_Status_Blocked) {
                /*Added as a part of PD-10582*/
                if ((acc.Type == 'Docomo' && acc.Partner_ID__c != null) || acc.Type == 'Apple') {
                    acc.Account_Status__c = 'Active Paid';
                    acc.Cancelled_Account__c = false;
                } else { //End of PD-10582
                    acc.Account_Status__c = System.Label.LS_Account_Status_Forzen;
                }
            }
            
            /*Creating Task  */
            Task newTask = New Task();
            newTask.WhatID = acc.Id;
            newTask.Ownerid = UserInfo.getUserId();
            if (acc.Account_Status__c == System.Label.LS_Account_Status_Blocked) {
                newTask.Subject = acc.Firstname + '' + acc.LastName + ' ' + System.Label.LS_Block_User_Is_Blocked;
            } else {
                newTask.Subject = acc.Firstname + '' + acc.LastName + ' ' + System.Label.LS_UnblockUser_Comment;
            }
            newTask.description = Comment ;
            newTask.ActivityDate = Date.today();
            newTask.Status = 'Completed';
            newTask.Priority = 'Normal';
            insert newTask ;
            
            update acc;
            bShowPanel = false;
        }
        return new PageReference('/'+sAccountId);
    }
    
    public PageReference reportError (String message){
        if (typeOfAccount != null && typeOfAccount == 'Apple') {
            //returnErrorForApple(message);
            return new PageReference('/'+message);
        }
        apexpages.addmessage(new apexpages.message(ApexPages.severity.INFO, message));
        navigateError = true;
       
        return null;
    }
    
    public void reportErrorWithoutReturn (String message){
        
        apexpages.addmessage(new apexpages.message(ApexPages.severity.INFO, message));
        navigateError = true;
        return ;
    }

}