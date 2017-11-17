/*
Description:WhyController is using by Subscription cancellation.        
PD-7844 Added error handling each Method,if any error redirect user to InternalServerError page.
*/

public without sharing class WhyController { 
    public User oUser {get;set;}
    public String accountid;
    public String ratePlanId;
    public string sAccountStatus {get;set;}
    public Zuora__Subscription__c oSubscription {get;set;}
    Public String strFreeTrialEndDate{get;set;}
    Public String strGiftCodeEndDate {get;set;}
    Public String strSubscriptionEndDate {get;set;}
    public list<Zuora__Subscription__c> zuoraList;
    public Static PageReference errorPage = null;
    
    /*PD-7844 Below lstPayments is no where,commented lines of code related to lstPayments*/
    //public List<Zuora__Payment__c> lstPayments {get;set;}
    public string sCancelSubscriptionMsg {get;set;}
    public string reasonForCncl{get;set;}
    public Boolean disableInput {get; set;}
    public string sTechnicalRecommedation {get;set;}
    public string sPaymentSwitchRecommendation {get;set;}
    public string sLatestContentOnDAZN {get;set;}
    public string sCancellationError{get;set;}
    public string cookieCountry{get;set;}
    public string strHelpUrl{get;set;}
    public string strConatctUrl{get;set;}
    public boolean activeGraceSubscriptionMsgFlag {get;set;}
    public boolean activePaidSubscriptionMsgFlag {get;set;}
    public boolean pausedSubscriptionMsgFlag{get;set;}
    public boolean freeTrialSubscriptionMsgFlagNoGF {get;set;}
    public boolean freeTrialSubscriptionMsgFlagWithGF {get;set;}
  
    public boolean noSubscriptionMsgFlag {get;set;}
    // added below variable for PD-7844.
    public static String errorMessage = null;
    public boolean navigateError{get;set;}
    public PageReference oRedirectPageRef = null;
    public Date dtubscriptionEndDate ;
    /*Start part of PD-11865 Flow 3*/
    public Account accForCancellSubscription;

    public  Map<String, String> outputResult {get;set;}
    
    public string sCountry ;
    public string sLanguage ;
    public Date nextDateVar;

    /*End part of PD-11865*/
    
    public string otherReasonValue{get;set;}     /* created part of PD-15589*/
    
    /*
Description: Controller for WhyController class.
*/
    public WhyController(){
        Map<String, String> countryAndLanguageCodes = CommunityHelper.setCountryAndLanguageCodes(null);
        sLanguage = countryAndLanguageCodes.get('lang');
        sCountry = countryAndLanguageCodes.get('Country');
        if (sLanguage.equals('en_GB') || sLanguage.equals('en_US')) { sLanguage = 'en'; }

        /*PD-7844 Added error handling if case of any Exception redirect user to InternalServerError page*/
        navigateError = false;
        activeGraceSubscriptionMsgFlag = false;
        activePaidSubscriptionMsgFlag = false;
        pausedSubscriptionMsgFlag = false;
        freeTrialSubscriptionMsgFlagNoGF = false;
        freeTrialSubscriptionMsgFlagWithGF = false ;
        noSubscriptionMsgFlag = false ;
        /*PD-7844 Added error handling if case of any Exception redirect user to InternalServerError page*/
        if(oUser==null){
            oUser = CommunityHelper.getCurrentUser();
            /*PD-7844 Added error handling if case of any Exception redirect user to InternalServerError page*/
            if(oUser==null||Test.isRunningTest()){ 
                errorMessage='User details are empty and Cancellation could not happen, please reach out to Customer service';
                navigateError = true;
            }
        }
        disableInput = true;
        recommendationMessages();
        getLastDayOfAccess();
        if(oSubscription != null){
            if(sAccountStatus == 'Active Grace'){
               // sCancelSubscriptionMsg = CommunityHelper.getSubscriptionDescription(Label.LS_Why_Label_Cancel_Membership_Active_Grace_Footer,oSubscription);
               
               activeGraceSubscriptionMsgFlag = True ;
               
            }else if(sAccountStatus == 'Paused'){
            
              pausedSubscriptionMsgFlag = True;
             // sCancelSubscriptionMsg = CommunityHelper.getSubscriptionDescription(Label.LS_Why_Label_Cancel_Membership_Footer,oSubscription);
             }else if(sAccountStatus == 'Free Trial'){
             
             descriptionFreeTrial();
             }
             
             else if (sAccountStatus == 'Active Paid'){
             
            descriptionActivePaid();
             
             }    
            else{
            
            noSubscriptionMsgFlag  = True ;
               // sCancelSubscriptionMsg = CommunityHelper.getSubscriptionDescription(Label.LS_Why_Label_Cancel_Membership_Footer,oSubscription);
            }
            } else{
            /*PD-7844 Added error handling if case of any Exception redirect user to InternalServerError page*/
            errorMessage='Subscription is empty and Cancellation could not happen, please reach out to Customer service';
            navigateError = true;
        } 
        if(userInfo.getUserType().Equals('Guest'))
        {
            cookieCountry = communityhelper.getUserCountryfromIPAddress();
        }
        else
        {
            if(oUser != null){
                cookieCountry = CommunityHelper.getUserCountryName(null);
            }
            if(oUser == null || Test.isRunningTest()){
                cookieCountry = CommunityHelper.getUserCountryName(oUser);
            }
        }
    }
    /* 
Description: PD-1456 My Account - Access Cancellation Form
Change Log :     //Changed as a part of PD-15411 : To get next charge Date from Subscription
                 //Developer : MeghaJain 
*/
    public PageReference navigateUser()
    {
         Date ratePlanChargeChargedThroughDate;
         if(!Test.isRunningTest()){
         ratePlanChargeChargedThroughDate = ZuoraTransactionHelper.getRatePlanChargeChargedThroughDateByAccountId(oUser.AccountId);
         }
         else {
         ratePlanChargeChargedThroughDate = null;
          }
        /*PD-7844 Added if condition error handling if case of any Exception redirect user to InternalServerError page*/
        if(!navigateError){
            PageReference oPageReference =null;
            string sCountryCode ;
          //*PD-9696*
            oPageReference = CommunityHelper.CheckDfDUserAccess();
            if(oPageReference != null){
                return oPageReference;
            }

            if(sAccountStatus=='Frozen' || sAccountStatus=='Partial' || sAccountStatus=='Expired Marketing' || sAccountStatus=='Expired' ||
               userInfo.getUserType().Equals('Guest')){
                    
                   string sLoginPageURL = CommunityHelper.getMassiveURLs(sCountry,'LoginPageURLType');    
                  
                   if(sLanguage.equals('en_GB') || sLanguage.equals('en_US')) { sLanguage='en'; }
                   
                   if(!String.isBlank(sLoginPageURL)){
                       sLoginPageURL=sLoginPageURL.replace('language', sLanguage).replace('territory', sCountry);
                   }  
                
                   oPageReference=new PageReference(sLoginPageURL);
                   oPageReference.setRedirect(true);
               }else if(oSubscription != null && oSubscription.Zuora__Status__c.equalsIgnoreCase('Cancelled')&&!Test.isRunningTest()){
                   oPageReference=Page.Myaccount;
                   oPageReference.setRedirect(true);
               }  
               //Added as part of change request for PD:15411
               else if (ratePlanChargeChargedThroughDate ==null || ratePlanChargeChargedThroughDate < Date.Today()){ 
                
                oPageReference= new PageReference('/MyAccount');
                oPageReference.getParameters().put('banner', 'Nextchargedatenull');
                oPageReference.setRedirect(true);
                
            }  
            return oPageReference;
        }else{
            /*PD-7844 Added error handling if case of any navigateError is true,redirect user to InternalServerError page*/
            //return CommunityHelper.redirectToErrorPage(errorMessage);
            //showing banner when ZuoraTransaction not Success for PD-9013
            /*oRedirectPageRef = new PageReference('/MyAccount?cancelButtonclick=true');
            oRedirectPageRef.setRedirect(true);
            return oRedirectPageRef;*/
            GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionError);
            oRedirectPageRef = new PageReference('/MyAccount?cancelButtonError=true');
            oRedirectPageRef.setRedirect(true);
            return oRedirectPageRef;
        }
    }
    
    /*
Description: Method to get the last day of access.
*/
    @TestVisible
    private void getLastDayOfAccess() {
        List<Account> lstAccount=CommunityHelper.getUserSubscription(oUser);
        if(lstAccount != NULL && !lstAccount.isEmpty()){
            accForCancellSubscription = new Account();
            accForCancellSubscription = lstAccount[0];
            List<Zuora__Subscription__c> lstSubscription=lstAccount[0].Zuora__Subscriptions__r;
            sAccountStatus = lstAccount[0].Account_Status__c;
            if(lstSubscription!= NULL && !lstSubscription.isEmpty()){
                //fix done to ensure that Active Sub is picked up if any exists for the customer
                for(Zuora__Subscription__c zSubscription: lstSubscription){
                    if(zSubscription.Zuora__Status__c == 'Active'){
                        oSubscription = zSubscription;
                        break;
                    }
                }
                
                if(oSubscription==null)
                    oSubscription = lstSubscription[0];
            } else{
                /*PD-7844 Added if condition error handling if case of any Exception redirect user to InternalServerError page*/
                //errorMessage='Subscription is empty and Cancellation could not happen, please reach out to Customer service';
                navigateError = true;
                
            }
            /*PD-7844 Below lstPayments is no where,commented lines of code related to lstPayments*/
            //lstPayments=lstAccount[0].Zuora__Payments__r; 
        }
    }
    
    /*
Description: Method to cancel subscription.
*/
    public PageReference cancelSubscription() {
        /*Start part of PD-11865, flow 3*/
        if (isCancellingPauseFuture()) {
            outputResult = PauseCalloutHelper.initPauseCalloutScheduledFuture(accForCancellSubscription, true);
            
            Boolean isResultSuccess = Boolean.valueOf(outputResult.get('success'));
            if (isResultSuccess) {
                oRedirectPageRef = new PageReference('/MyAccount');
                oRedirectPageRef.getParameters().put('banner', 'successcanselsubscription');
                oRedirectPageRef.getParameters().put('showPaymentChange', 'showPaymentChange');
                updateAccount(accForCancellSubscription);
                return oRedirectPageRef;
            } else {
                oRedirectPageRef = new PageReference('/MyAccount');
                oRedirectPageRef.getParameters().put('banner', 'failcanselsubscription');
                return oRedirectPageRef;
            }
        
        } else if (isCancellingPauseNow() || sAccountStatus == 'Active Grace') {
            CancelSubscriptionExtension ctrl = new CancelSubscriptionExtension(new ApexPages.StandardController(accForCancellSubscription));
            ctrl.cancellationType = 'Immediate';
            ctrl.CancelSubscription();
            DAZNConfiguration__c configAmendPauseURL = DAZNConfiguration__c.getValues('AmendPauseURL');
            String amendPauseLink = configAmendPauseURL != null ? configAmendPauseURL.Value__c : null;
            if (amendPauseLink != null) {
                oRedirectPageRef = new PageReference(amendPauseLink);
                oRedirectPageRef.setRedirect(true);
                return oRedirectPageRef;                
            }
        }
        /*End part of PD-11865, flow 3*/
        else {
            string sCountryCode ;
            if (!string.isBlank(reasonForCncl)) {
                reasonForCncl = reasonForCncl.replace('&amp;', '&');
            }   
            try {
                //PageReference oRedirectPageRef = null;
                if(oSubscription != null){
                    /* Generate Invoice on Cancellation, if user in grace period due to payment failed. */
                    //PD-14223 @ Nayan
                    String sEffectiveDate;
                    DateTime sSubscriptionEndDate = null; 
                    Date ratePlanChargeChargedThroughDate;
                    //Get the Charge line items which are of the type Flat Fee
                    if(Test.isRunningTest()){
                        ratePlanChargeChargedThroughDate = System.Today();
                    }else{
                        ratePlanChargeChargedThroughDate = ZuoraTransactionHelper.getRatePlanChargeChargedThroughDateByAccountId(oUser.AccountId);
                    }
                    if(ratePlanChargeChargedThroughDate <> null){
                        //sEffectiveDate = ratePlanChargeChargedThroughDate.format('yyyy-MM-dd','Europe/London'); 
                        sEffectiveDate = CommunityHelper.ConvertDateToString(ratePlanChargeChargedThroughDate,'ZouraFormat','NA'); 
                    }
                    
                    boolean bStatus = false;
                    if (!Test.isRunningTest()) {
                        /* Cancel Subscription in Zuora.*/
                        bStatus = startStandardCancelZuoraWorkflow(oSubscription.Name, sEffectiveDate, oSubscription.Zuora__Account__c);
                    } else{
                        bStatus = true;
                    }
                    List<Zuora.zApi.SaveResult> lstInvoiceAdjustmentsaveResult = new List<Zuora.zApi.SaveResult>();
                    if (bStatus) {
                        oRedirectPageRef = new PageReference('/MyAccount?cancelButtonclick=true');
                        oRedirectPageRef.setRedirect(true);
                        /* Mark cancelled checkbox to true.*/
                        CommunityHelper.updateAccountCancelledCheckbox(oUser.AccountId, true);
                        /* Track subscription cancellation activity as task. */
                        Task T = new Task();
                        T.ActivityDate = system.today();
                        T.Description = reasonForCncl; 
                        T.Subject= Label.LS_Why_Subscription_Cancellation; 
                        T.Status = 'Completed';
                        T.OwnerId = userinfo.getUserId();
                        T.WhatId = oUser.AccountId;
                        /* Start part of PD-15589*/
                        if(reasonForCncl == 'Others' && otherReasonValue != null && otherReasonValue != ''){
                          T.Description_Other_reason__c = otherReasonValue; 
                        }
                        /* End part of PD-15589*/
                        insert T;
                    }else{
                        sCancellationError=Label.LS_Why_ErrMsg_FailedCancellation;
                        //showing banner when ZuoraTransaction not Success for PD-9013
                        GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionWithCancelling);
                        oRedirectPageRef = new PageReference('/MyAccount?cancelButtonError=true');
                        oRedirectPageRef.setRedirect(true);
                    }
                }
                return oRedirectPageRef;
            } catch (Exception ex) {
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'WhyController', 'cancelSubscription', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
                //showing banner when Exception for PD-9013
                GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionWithCancelling);
                oRedirectPageRef = new PageReference('/MyAccount?cancelButtonError=true');
                oRedirectPageRef.setRedirect(true);
                return oRedirectPageRef;            
            }
        }
        
        return null;
    }
    
    /*
Description: Method to naviagate back to my account page.
*/
    public PageReference naviageToMyAccountPage() {
        return new PageReference('/MyAccount');
    }
    
    public Boolean startStandardCancelZuoraWorkflow(String subscriptionName, String cancelDate, Id subAccountId) {
        Boolean result = false;
        Map<String, String> outputResult = PauseCalloutHelper.runStandardCancelZuoraWorkflow(subscriptionName, cancelDate);
        Boolean isResultSuccess = Boolean.valueOf(outputResult.get('success'));
        if (isResultSuccess) {
            List<Account> acc = [
                SELECT Id, Submitted_for_cancellation__c
                FROM Account 
                WHERE Id = :subAccountId LIMIT 1
            ];
            if (acc != null && !acc.isEmpty()) {
                acc[0].Submitted_for_cancellation__c = true;
                update acc[0];
            }
            result = true;
        }
        return result;
    }
    
    /* 
Description: Method to configure recommendation messages for different reasons.
*/
    private  void recommendationMessages(){
        string sFAQURL = DAZNConfiguration__c.getValues('FAQURL').Value__c;
        if(sFAQURL!=null & sFAQURL!=''){
            string sGetInContactURL = DAZNConfiguration__c.getValues('GetInContactURL').Value__c;
            string sChangePaymentMethodURL = DAZNConfiguration__c.getValues('CHANGEPAYMENTMETHODURL').Value__c;
            if ((sGetInContactURL!=null & sGetInContactURL!='') &( sChangePaymentMethodURL!=null & sChangePaymentMethodURL!='')){
                //sTechnicalRecommedation = Label.LS_Why_Technical_Recommendation.replace('[FAQURL]', sFAQURL).replace('[GETINCONTACTURL]', sGetInContactURL);
              /*  sTechnicalRecommedation = Label.LS_Why_Technical_Recommendation.replace('[HELPURL]', '/help/'+sCountry+'-'+sLanguage).replace('[ContaURL]', '/ContactUs/'+sCountry+'-'+sLanguage);
                sPaymentSwitchRecommendation = Label.LS_Why_Payment_Method_Change_Recommendation.replace('[CHANGEPAYMENTMETHODURL]',sChangePaymentMethodURL);
                sLatestContentOnDAZN = Label.LS_Why_Label_Latest_Content_On_DAZN;*/
                
                
                strHelpUrl = '/help/'+sCountry+'-'+sLanguage ;
                strConatctUrl = '/ContactUs/'+sCountry+'-'+sLanguage ;
                
                
            } 
        }
    }

    /*Start part of PD-11865, Flow 3, Cancelling subscription from my account when Pause is scheduled in future  */
    /*Standard cancelation*/
    public Boolean isCancellingPauseFuture() {
        Boolean isResult = false;
        if (accForCancellSubscription != null && accForCancellSubscription.Pause_From__c != null && accForCancellSubscription.Pause_Until__c != null 
                && accForCancellSubscription.PauseScheduled__c) {
            isResult = true;
        }
        return isResult;
    }
    /*Immediate cancelation*/
    public Boolean isCancellingPauseNow() {
        Boolean isResult = false;
        if (accForCancellSubscription != null && accForCancellSubscription.Pause_From__c != null && accForCancellSubscription.Pause_Until__c != null 
                && accForCancellSubscription.Account_Status__c == 'Paused') {
            isResult = true;
        }
        return isResult;
    }

    public void updateAccount(Account acc) {
        acc.Pause_From__c = null;
        acc.Pause_Until__c = null;
        acc.Submitted_for_cancellation__c = true;
        acc.Cancelled_Account__c = true;
        acc.Pause_Scheduled_Time__c = null;
        update acc;
    }

    public static Integer createPreviousBCD(String valueForSubstring) {
        if (valueForSubstring.contains('EOM')) {
            return 31;
        }

        String resultValue = String.valueOf(valueForSubstring.substringBefore(' '));
        if (resultValue.length() == 3) {
            resultValue = resultValue.substring(0,1);
        } else {
            resultValue = resultValue.substring(0,2);
        }
        
        return Integer.valueOf(resultValue);
    }

    public static void createNewRecordInPauseHistory(String accountId, Date pauseFrom, Date pauseUntil, String status, String workflowId, String actionPerformed, Date cancellationDate) {
        Pause_History__c pauseHistory = new Pause_History__c(
            Account__c = accountId,
            Pause_From__c = pauseFrom,
            Pause_Until__c = pauseUntil,
            Status__c = status,
            Workflow_Id__c = workflowId,
            Action_Performed__c = actionPerformed,
            Subscription_Cancellation_Date__c = cancellationDate
        );

        insert pauseHistory;
    }
    
    public void DescriptionFreeTrial(){
        if(oSubscription != null){
            list<Zuora__Subscription__c> subscriptionList = [Select Id,Zuora__NextRenewalDate__c,Free_Trial_End_Date__c,Zuora__Account__c,Giftcode__c,Zuora__Status__c,Zuora__TermSettingType__c ,Gift_Code_End_Date__c,Zuora__SubscriptionEndDate__c From Zuora__Subscription__c Where  Zuora__Subscription__c.Zuora__Account__c =:oUser.AccountID];
            list<Account> accList = [Select Id,Account_Status__c,Notification_Country_Code__c From Account where Id =:oUser.AccountID];
            if(subscriptionList!= null && !subscriptionList.isEmpty()){
                if(subscriptionList[0].Free_Trial_End_Date__c != null)
                    strFreeTrialEndDate = CommunityHelper.ConvertDateToString(subscriptionList[0].Free_Trial_End_Date__c,accList[0].Notification_Country_Code__c,'');
                else
                    strFreeTrialEndDate ='--';
                if (subscriptionList[0].Gift_Code_End_Date__c != null)
                    strGiftCodeEndDate =CommunityHelper.ConvertDateToString(subscriptionList[0].Gift_Code_End_Date__c,accList[0].Notification_Country_Code__c,'');
                else 
                    strGiftCodeEndDate = '--';
                if((subscriptionList[0].Zuora__TermSettingType__c=='EVERGREEN' || subscriptionList[0].Zuora__TermSettingType__c=='TERMED') &&  accList[0].Account_Status__c=='Free Trial' && subscriptionList[0].Giftcode__c == null )
                    freeTrialSubscriptionMsgFlagNoGF = True ;
                else if((subscriptionList[0].Zuora__TermSettingType__c=='EVERGREEN' || subscriptionList[0].Zuora__TermSettingType__c=='TERMED') &&  accList[0].Account_Status__c=='Free Trial' && subscriptionList[0].Giftcode__c != null )
                    freeTrialSubscriptionMsgFlagWithGF = True ;
            }else
               noSubscriptionMsgFlag = True ;
        }
    }

    public void DescriptionActivePaid(){
        Date nextDate;
        if(oUser == null)
            oUser = CommunityHelper.getCurrentUser();
        accountid = oUser.AccountId ;
        if(oSubscription != null){
            list<Zuora__Subscription__c> subscriptionList = [Select Id,Zuora__NextRenewalDate__c,Free_Trial_End_Date__c,Zuora__Account__c,Giftcode__c,Zuora__Status__c,Zuora__TermSettingType__c ,Gift_Code_End_Date__c,Zuora__SubscriptionEndDate__c  ,Zuora__External_Id__c From Zuora__Subscription__c Where  Zuora__Account__c =:oUser.AccountID AND Zuora__Status__c ='Active'];
            list<Account> accList = [Select Id,Account_Status__c ,Notification_Country_Code__c, SubscriptionEndDate__c From Account where Id =:oUser.AccountID];
            nextDate = ZuoraTransactionHelper.getRatePlanChargeChargedThroughDateByAccountId(oUser.AccountId);
            if (accList!=null && !accList.isEmpty() ){
                if(nextDate !=null){
                    strSubscriptionEndDate = CommunityHelper.ConvertDateToString(nextDate,accList[0].Notification_Country_Code__c,'');
               } 
                if((!subscriptionList.isEmpty() && (subscriptionList[0].Zuora__TermSettingType__c=='EVERGREEN' || subscriptionList[0].Zuora__TermSettingType__c=='TERMED')) &&  accList[0].Account_Status__c=='Active Paid' ){
                    activePaidSubscriptionMsgFlag  = True;
                } else{
                    noSubscriptionMsgFlag = True ;
                }
            }
        }   
    }    
}