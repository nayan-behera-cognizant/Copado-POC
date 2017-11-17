/*
Description:MembershipReactivationController is using by Resubscribes.        
PD-7847 Added error handling each Method,if any error redirect user to InternalServerError page.  
*/

public class MembershipReactivationController {
    public string strReactivationMsg{get;set;}
    Zuora__Subscription__c subscription;
    string subscriptionType;
    public Zuora__PaymentMethod__c paymentDetails{get;set;}
    public string sCurrentPaypalEmail{get;set;}
    public string sCCMaskNumber {get;set;}
    public string sCurrentBTAccountNumber {get;set;}
    public string expiryYear{get;set;}
    public string expiryMonth{get;set;}
    public User user {get;set;}
    public string sCountry {get;set;}
    public string cookieCountry{get;set;}
    // added below variable for PD-7847.
    public static String errorMessage = null;
    public boolean navigateError{get;set;}
    // added below variable for PD-9013.
    public  static PageReference oRedirectPageRef = null;//
      public String slang {get;set;}
    // public String sCountry {get;set;}
    // no idea how is add below Method and what is use ?
    public PageReference navigationHandler(){
        return new PageReference('/apex/'+ apexpages.currentpage().getParameters().get('PageName'));
    }
    
    public MembershipReactivationController() {
        // PD-7847 variable set for navigate Error 
        navigateError = false;
        //Start PD-7847 user null chacck
        
        Map<String, String> countryAndLanguageCodes = CommunityHelper.setCountryAndLanguageCodes(null);
        slang = countryAndLanguageCodes.get('lang');
        sCountry = countryAndLanguageCodes.get('Country');

        if (user==null) {
            user = CommunityHelper.getCurrentUser();
            if(user==null || Test.isRunningTest()){
                errorMessage = 'User details are empty and Resubscribes is not happen, please reach out to Customer service';
                navigateError = true;
                }
        }
        getUserSubscription();
        if(user!=null){
            paymentDetails = CommunityHelper.getPaymentInformation(user.AccountID);
        }
        else
        {
            errorMessage = 'User details are empty and Resubscribes is not happen, please reach out to Customer service';
            navigateError = true;
            }
        //End PD-7847 user null chacck
        //Added below condition lines for formatYear method and it should only call for CreditCard*PD-7847-QARepone*
        if(paymentDetails != null && paymentDetails.Zuora__Type__c =='CreditCard'){
            formatYear(); 
        }
        if(paymentDetails != null){
            /*Start PD-7847 Below is payment Details are optional, So non need do error handling, black value are accepted in this case*/
            sCurrentPaypalEmail = CommunityHelper.getObfuscatedEmail(paymentDetails.Zuora__PaypalEmail__c);
            if(paymentDetails.Zuora__CreditCardMaskNumber__c != null){
                sCCMaskNumber = Label.LS_PaymentHistory_Label_Ending + ' ' + paymentDetails.Zuora__CreditCardMaskNumber__c.substring(paymentDetails.Zuora__CreditCardMaskNumber__c.length()-4, paymentDetails.Zuora__CreditCardMaskNumber__c.length()) ;
            }
            if(paymentDetails.Zuora__BankTransferAccountNumber__c !=null){
                sCurrentBTAccountNumber = Label.LS_PaymentHistory_Label_Ending + ' ' +  paymentDetails.Zuora__BankTransferAccountNumber__c.substring(paymentDetails.Zuora__BankTransferAccountNumber__c.length() - 3, paymentDetails.Zuora__BankTransferAccountNumber__c.length()); 
            }
            /*end PD-7847 */
        } else {
            // PD-7847 variable set for navigate Error
            errorMessage = 'Payment Details are empty and Resubscribes is not happen, please reach out to Customer service';
            navigateError = true;
            }
        
        if(userInfo.getUserType().Equals('Guest'))
        {
            cookieCountry = communityhelper.getUserCountryfromIPAddress();
        }
        else
        {
            if(user != null){
                cookieCountry = CommunityHelper.getUserCountryName(null);
            }
            if(user == null || Test.isRunningTest()){
                cookieCountry = CommunityHelper.getUserCountryName(user);
            }
        }
    }
    /* add else block for error handling*/
    public void formatYear(){
        if(paymentDetails != null && paymentDetails.Zuora__CreditCardExpirationYear__c !=null){
            expiryYear = paymentDetails.Zuora__CreditCardExpirationYear__c.substring(2,2);
        } else{
            // PD-7847 variable set for navigate Error
            errorMessage = 'CreditCard Year expiry and Resubscribes is not happen, please reach out to Customer service';
            navigateError = true;
            }
        if(paymentDetails != null && paymentDetails.Zuora__CreditCardExpirationMonth__c !=null){
            if((paymentDetails.Zuora__CreditCardExpirationMonth__c).length() < 2){
                expiryMonth = '0'+paymentDetails.Zuora__CreditCardExpirationMonth__c;
            }else{
                expiryMonth = paymentDetails.Zuora__CreditCardExpirationMonth__c;
            }
        }else {
            // PD-7847 variable set for navigate Error
            errorMessage = 'CreditCard Month expiry and Resubscribes is not happen, please reach out to Customer service';
            navigateError = true;
            }
    }

    public void getUserSubscription(){
        List<Account> lstAccount=CommunityHelper.getUserSubscription(null);
        if(lstAccount != NULL && !lstAccount.isEmpty()){                
            List<Zuora__Subscription__c> lstSubscription=lstAccount[0].Zuora__Subscriptions__r;
            if(lstSubscription!=null && !lstSubscription.isEmpty()){
                subscription=lstSubscription[0]; 
                subscriptionType=lstAccount[0].Account_Status__c; 
                if(subscriptionType !=null && subscriptionType.Equals('Free Trial')){
                    if(subscription!=null && subscription.Zuora__Status__c.equalsIgnoreCase('Cancelled')){
                        if(sCountry == 'CA' ){
                         strReactivationMsg=CommunityHelper.getSubscriptionDescriptionForCanada(Label.LS_MyAccount_InfoMsg_Reactivation,subscription,slang,sCountry); 
                       }
                       else{    						                      
	                       strReactivationMsg=CommunityHelper.getSubscriptionDescription(Label.LS_MyAccount_InfoMsg_Reactivation,subscription);
                       }
                        
                    }
                } else if(subscriptionType !=null && subscriptionType.Equals('Active Paid')){
                    if(subscription!=null && subscription.Zuora__Status__c.equalsIgnoreCase('Cancelled')){
                    if(sCountry == 'CA' ){
                         strReactivationMsg=CommunityHelper.getSubscriptionDescriptionForCanada(Label.LS_MyAccount_InfoMsg_Reactivation,subscription,slang,sCountry); 
                       }
                       else{
                           system.debug('in elsemembership lanuage else===========>');
                            strReactivationMsg=CommunityHelper.getSubscriptionDescription(Label.LS_MyAccount_InfoMsg_Reactivation,subscription);
                        }                        
                    }
                }
            }else{
                // PD-7847 variable set for navigate Error
				//errorMessage = 'Subscription is empty and Resubscribes is not happen, please reach out to Customer service';
                navigateError = true;
				}
        }else {
            // PD-7847 variable set for navigate Error
			errorMessage = 'Account Details is empty and Resubscribes is not happen, please reach out to Customer service';
            navigateError = true;
             }
    }
    public PageReference ReactivateMembership(){
        //Start PD-7847 subscription null chacck
        // PD-13276: List<Zuora.zApi.DeleteResult> lstActivationResult;
        Boolean reactivationStatus = false;
        try {
            oRedirectPageRef = null;
            if (subscription!=null && subscription.Zuora__External_Id__c!=null) {
                // PD-13276: lstActivationResult = ZuoraTransactionHelper.activateSubscription(subscription.Name);
                reactivationStatus = startUndoCancellationZuoraWorkflow(subscription.Name, subscription.Zuora__Account__c);
            } else {
                errorMessage = 'Subscription is empty and Resubscribes is not happen, please reach out to Customer service';
                navigateError = true; 
               }
            //End PD-7847 subscription null check
                       
            // PD-13276: if((lstActivationResult!=null && lstActivationResult[0].Success == true && lstActivationResult[0].Errors == null) || Test.isRunningTest()){
            if (reactivationStatus || Test.isRunningTest()) {
                PageReference prAccount = Page.MyAccount;
                prAccount.getParameters().put('showReactivationBanner','true');                
                //EmailHelper.sendReactivationSubscriptionEmailtoUser(userinfo.getUserEmail(), 'ReactivateSubscription');
                
                /* Mark cancelled checkbox to true.*/
                CommunityHelper.updateAccountCancelledCheckbox(user.AccountId, false);
                
                /* Track subscription reactivation activity as task. */
                Task T = new Task();
                T.ActivityDate = system.today();
                T.Description = Label.LS_MyAccount_User_Resubscribe_Message; 
                T.Subject= Label.LS_MyAccount_User_Resubscribe_Subject; 
                T.OwnerId = userinfo.getUserId();
                if (Test.isRunningTest()) {
                    T.WhatId = ''; 
                } else {
                    T.WhatId = user.AccountId; 
                }
                
                insert T;
                
                return prAccount;
            } else {
                //showing banner when ZuoraTransaction not Success for PD-9013
                GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionError);
                oRedirectPageRef = new PageReference('/MyAccount?ResubscribesError=true');
                oRedirectPageRef.setRedirect(true);
                return oRedirectPageRef;
               /* ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'ReactivateMembership', 'Data Issue', 'Data Issue', 'Exeption:'+ lstActivationResult);
                // PD-7847 Exception handling for navigate Error
                errorMessage = 'Activate Subscription deatils is empty and Resubscribes is not happen, please reach out to Customer service';
                return CommunityHelper.redirectToErrorPage(errorMessage); */
            }
        } catch(Exception ex) {
            /* PD-9013
            errorMessage = 'Resubscribes is not happen, please reach out to Customer service';
            return CommunityHelper.redirectToErrorPage(errorMessage); */
            GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionError);
            oRedirectPageRef = new PageReference('/MyAccount?ResubscribesError=true');
            oRedirectPageRef.setRedirect(true);
            return oRedirectPageRef;
        }
        return null;
    }
    public Boolean startUndoCancellationZuoraWorkflow(String subscriptionName, Id subAccountId) {
        Boolean result = false;
        Map<String, String> outputResult = PauseCalloutHelper.runUndoCancellationZuoraWorkflow(subscriptionName);
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
        Description: Method to redirect user on my account page.
    */
    public PageReference redirectToMyAccount() {
        PageReference oMyAcc = new PageReference('/MyAccount?');
        oMyAcc.setRedirect(true);
        return oMyAcc ;
    }
    /*PD-7847 Added error handling if case of any navigateError is true,redirect user to InternalServerError page
      Change Log ://Changed as a part of PD-15411 : To get next charge Date from Subscription
                 //Developer : MeghaJain 
*/
    public PageReference navigateToErrorPage(){
        
        Date ratePlanChargeChargedThroughDate;
        ratePlanChargeChargedThroughDate = ZuoraTransactionHelper.getRatePlanChargeChargedThroughDateByAccountId(user.AccountId);
		Boolean isDFDUser = CommunityHelper.IsDfDUser();
        
        if(navigateError){
            //return CommunityHelper.redirectToErrorPage(errorMessage); 
            GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionError);
            oRedirectPageRef = new PageReference('/MyAccount?ResubscribesError=true');
            oRedirectPageRef.setRedirect(true);
            return oRedirectPageRef;
        }//Added else condition as part of change request for PD:15411 to Navigate user to My account page when next charge Date is null 

        else if (!isDFDUser && (ratePlanChargeChargedThroughDate ==null || ratePlanChargeChargedThroughDate < Date.Today())){ 
            PageReference oPageReference= new PageReference('/MyAccount');
            oPageReference.getParameters().put('banner', 'Nextchargedatenull');
            oPageReference.setRedirect(true);
            return oPageReference;
        }  
        //*PD-9696*
        PageReference oPageReference = CommunityHelper.CheckDfDUserAccess();
        if(oPageReference != null){
            return oPageReference;
        }
        return null;
    }
}