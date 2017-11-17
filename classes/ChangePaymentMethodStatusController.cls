public class ChangePaymentMethodStatusController {
    public User oUser {get;set;}
    public String sStatus {get;set;}
    public String sPaymentRenewalMessage {get;set;}
    public Zuora__Subscription__c oSubscription {get;set;}
    public string sFailureMessage{get;set;}
    
    /*
        Description: Change Payment Method Update Status controller
    */
    public ChangePaymentMethodStatusController(){
        if(oUser==null){
            oUser = CommunityHelper.getCurrentUser();
        }
        sStatus = ApexPages.currentPage().getParameters().get('success');        
        if(sStatus == 'true'){
            List<Account> lstAccount=CommunityHelper.getUserSubscription(oUser);
            if(lstAccount != NULL && !lstAccount.isEmpty()){
                List<Zuora__Subscription__c> lstSubscription=lstAccount[0].Zuora__Subscriptions__r;
                if(lstSubscription!=null && !lstSubscription.isEmpty()){
                    oSubscription=lstSubscription[0];
                }
            }
            if(oSubscription!=null){
                sPaymentRenewalMessage = CommunityHelper.getSubscriptionDescription(Label.LS_PaymentChangeSuccess_InfoMsg_PaymentDetailsUpdated,oSubscription);
            } 
            
            if(!Test.isRunningTest()){
                List<Zuora.zObject> lstBillingAccount = ZuoraTransactionHelper.zquery('Select Id,PaymentGateway,DefaultPaymentMethodId from Account where CrmId = \''+oUser.AccountId+'\'' );
               
                PaymentMethodOptionConfig__c oPaymentMethodOptionConfig = PaymentMethodOptionConfig__c.getValues(oUser.Country);
                string sZuoraPaymentMethodID = ApexPages.currentPage().getParameters().get('refId');
                
                ZuoraTransactionHelper.updatePaymentMethod(lstBillingAccount[0],oPaymentMethodOptionConfig.CardsPaymentGateway__c,sZuoraPaymentMethodID,true,oPaymentMethodOptionConfig.DefaultPaymentMethod__c);
                ZuoraTransactionHelper.setDefaultPayment(oUser.AccountId,sZuoraPaymentMethodID);
            }
        }
        else if(sStatus == 'false'){
            sFailureMessage=Label.LS_ChangePaymentMethodStatus_ValidateText;
        }
    }
    
    /*
        Description: Method to redirect user on my account page.
    */
    public PageReference redirectToMyAccount() {
        PageReference oMyAcc = new PageReference('/MyAccount?');
        oMyAcc.setRedirect(true);
        return oMyAcc ;
    }
    
    /*
        Description: Method to redirect user on change payment method page.
    */
    public PageReference redirectToChangePaymentMethod() {
            PageReference oChangePayMethod = new PageReference('/ChangePaymentMethod');
            oChangePayMethod.setRedirect(true);
            return oChangePayMethod;
    }
    
    /*
        Description: Method to create failure task for CC and DD method failure.
    */
    public void createPaymentTask(){
        if(sStatus == 'true'){
            /* Commented out according to PD-13294
            if(!Test.isRunningTest()){
                // send notification on payment method update
                CommunicatorIntegrationHelper.sendUserDetailsUpdateNotification(oUser.AccountId, oUser.contactId, oUser.Email, 'Updated_Payment', oUser.LanguageLocaleKey, oUser.CountryCode);
            }*/
            if (!oUser.Account.Disable_transactional_emails__c) {
                // PD-13294
                Email_Sync_Queue__c triggeredDispatchEmailQueue = new Email_Sync_Queue__c(
                    Account__c = oUser.AccountId,
                    Notification_Country_Code__c = oUser.CountryCode,
                    Notification_Language_Code__c = oUser.LanguageLocaleKey,
                    Person_Email__c = oUser.Email,
                    Status__c = 'Not Started',
                    Type_of_Email__c = 'Triggered Dispatch',
                    Unsubscribe_Language__c = oUser.LanguageLocaleKey,
                    Dispatch_ID__c = (!Test.isRunningTest()) ? Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Updated_Payment').Value__c) : 12340,
                    Email_Name__c = 'Updated Payment'
                );
                insert triggeredDispatchEmailQueue;
                
                Task paymentMethodSuccessTask = new Task();
                paymentMethodSuccessTask.ActivityDate = system.today();
                paymentMethodSuccessTask.Description = Label.LS_ChangePaymentMethodStatus_Label_Success_Task_Subject; 
                paymentMethodSuccessTask.Subject= Label.LS_ChangePaymentMethodStatus_Label_Success_Task_Subject; 
                paymentMethodSuccessTask.OwnerId = userinfo.getUserId();
                paymentMethodSuccessTask.WhatId = oUser.AccountId;
                paymentmethodSuccessTask.Status = 'Completed';
                insert paymentMethodSuccessTask;
            }
        } else{
            // Construct Error Description
            string sErrorDescription='Error Code: ' + ApexPages.currentPage().getParameters().get('errorCode') + 
                                     ', Error Message: ' + ApexPages.currentPage().getParameters().get('errorMessage') + 
                                     ', Payment method: ' + ApexPages.currentPage().getParameters().get('field_passthrough2');
                
            if(ApexPages.currentPage().getParameters().get('field_passthrough2') == 'CreditCard')
                sErrorDescription = sErrorDescription + ', Payment Type: ' + ApexPages.currentPage().getParameters().get('field_passthrough3');
                                     
            sErrorDescription =   sErrorDescription + ', Card: ' + ApexPages.currentPage().getParameters().get('field_passthrough4');
                
            // Create Task for failure.
            ZuoraTransactionHelper.createPaymentMethodFailureTask(sErrorDescription, oUser.AccountId);
        }
    }
}