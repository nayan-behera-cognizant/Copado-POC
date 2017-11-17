/**
* @author Cognizant Technology Solutuions
* @date 06/11/2015
* @description Change Payment Method Controller class
*/

public without sharing class ChangePaymentMethodController{ 
    
    public User oUser {get;set;}
    
    /* Current Payment Method Properties*/
    public string currentPaymentMethod {get;set;}
    public string ccPaymentMethodName {get;set;}
    public string ppPaymentMethodName {get;set;}
    public string ddPaymentMethodName {get;set;}
    public string sCurrentCCMaskNumber {get;set;}
    public string sCurrentCCExpiry {get;set;}
    public string sCurrentPaypalEmail {get;set;}
    public string sCurrentBTAccountNumber{get;set;}
    public string sCCType{get;set;}
    
    /* New Payment Method (CC) Properties*/
    public boolean showCC{get;set;}
    public string sCCHolderNameErrMsg{get;set;}
    public string sCCNumErrMsg{get;set;}
    public string sCCEMErrMsg{get;set;}
    public string sCCEYErrMsg{get;set;}
    public string sCCCVCErrMsg{get;set;}
    public ZuoraPageResponse zCCPageResponse {get;set;}
    public string zCCPageId {get;set;}
    public string sCCSecurityError {get;set;}
    public boolean isCCSecurityCheckPass {get;set;}
    
    /* New Payment Method (DD) Properties*/
    public boolean showDD{get;set;}
    public string sBTFNErrMsg{get;set;}
    public string sBTSNErrMsg{get;set;}
    public string sBTBANumErrMsg{get;set;}
    public ZuoraPageResponse zDDPageResponse {get;set;}
    public string zDDPageId {get;set;}
    public string sDDSecurityError {get;set;}
    public boolean isDDSecurityCheckPass {get;set;}
    public Boolean showAddGiftCodeFlag { get; set; }
    
    /* Banner Properties*/
    public boolean showbanner {get;set;}
    public string sBannerHeader {get;set;}
    public string sBanner{get;set;}
    
    /* Other Properties*/
    public string strPmtMode{get; set;}
    public string strMessage {get;set;}
    public string status {get;set;}
    public boolean showPP{get;set;}
    public string sAcknowledgementOnSave {get;set;}
    public string sPaypalAcknowledgement {get;set;}
    public Integer sCurrentMonth {get;set;}
    public Integer sCurrentYear {get;set;}
    public string hostDomain {get;set;}
    public string publicKey {get;set;}
    public string zuoraAccountId {get;set;}
    public string paymentGateway {get;set;}
    public string hostedPageURL {get;set;}
    public string sCardType {get;set;}
    public  static PageReference errorPage = null;
    
    /*
    Description: Zuora Page Request class
    */
    public class ZuoraPageRequest{
        public string uri {get;set;}
        public string method {get;set;}
        public string pageId {get;set;}
    }
    
    /*
    Description: Zuora Page Responese class
    */
    public class ZuoraPageResponse{
        public string signature {get;set;}
        public string token {get;set;}
        public string tenantId {get;set;}
        public String key {get;set;}
        public string success {get;set;}
    }
    
    /*
    Description: page controller constructor
    */
    public ChangePaymentMethodController(){
        
        try{
        
             if (oUser == null) {
            oUser = CommunityHelper.getCurrentUser();
             }
            Map<String, String> countryAndLanguageCodes = CommunityHelper.setCountryAndLanguageCodes(null);
            String slang = countryAndLanguageCodes.get('lang');
            String sCountry = countryAndLanguageCodes.get('Country');



            /* Get current user details*/
            oUser = CommunityHelper.getCurrentUser();
            
            /* Set values */
            sCardType= ApexPages.currentPage().getParameters().get('field_passthrough2');
            status = ApexPages.currentPage().getParameters().get('success');
            
            if(!Test.isRunningTest()){
                /* Get Zuora Account ID*/
                zuoraAccountId = CommunityHelper.getZuoraAccountInfo(oUser.AccountId).Zuora__Zuora_Id__c;
            }
            
            /*Get the current month & Year*/
            sCurrentMonth = System.Today().month();
            sCurrentYear = System.Today().year();
            
            /* set and show current payment method on page*/
            showCurrentPaymentMethod();
            
            /* Zuora Hosted Page Operation related configuration*/

            //publicKey = Label.Zuora_Public_Key;
            publicKey = !String.isBlank(DAZNConfiguration__c.getValues('Zuora_Public_Key_Second_Part').Value__c) ? DAZNConfiguration__c.getValues('Zuora_Public_Key').Value__c 
                                                                                                                        + DAZNConfiguration__c.getValues('Zuora_Public_Key_Second_Part').Value__c 
                                                                                                                : DAZNConfiguration__c.getValues('Zuora_Public_Key').Value__c;
            hostDomain = DAZNConfiguration__c.getValues('ZuoraHostedPageDomain').Value__c;
            hostedPageURL = DAZNConfiguration__c.getValues('ZuoraPublicHostedPageURL').Value__c;
            
            /* show payment method options*/
            getPaymentMethodConfiguration();
            
            /* show payment method based on conditions.*/
            setPaymentMethodVisibility();
            
            /* Get Policy URL's from custom settings.*/
            getAcknowledgementOnSaveMsg();
            
            /* Method to show cancel messages for paypal method cancellations.*/
            showPaypalCancelMessage();
            
            /*Method to show failure success banner*/
            showBanner();
            
            /*Boolean to check Add Payment Link*/
            showAddGiftCodeFlag =GiftCodeHelper.checkRedeemLinkCriteria(oUser);

        }catch(Exception ex){
            errorPage = System.Page.InternalServerError;
            errorPage.getParameters().Put('Errormsg',' Billing details not available');
        }
    }
    
    /*
    Description: Method to set Payment Method visibility.
    */
    private void setPaymentMethodVisibility(){
        if(!String.isBlank(sCardType)){
            if(sCardType == 'CreditCard')
                strPmtMode = 'CreditCard';
            else if(sCardType == 'DirectDebit')
                strPmtMode = 'DirectDebit';
        }
    }
    
    /*
    Description: Method to validate user access and redirect user based on access. 
    */
    public PageReference navigateUser(){
        PageReference oPageReference = null;
        string sCountryCode ;
        //*PD-9696*
        oPageReference = CommunityHelper.CheckDfDUserAccess();
        if(oPageReference != null){
            return oPageReference;
        }
        List<Account> lstAccounts = CommunityHelper.getUserSubscription(oUser);
        if(lstAccounts != NULL && !lstAccounts.isEmpty()){
            string sAccountStatus = lstAccounts[0].Account_Status__c;
            if(string.isBlank(sAccountStatus) || sAccountStatus=='Frozen' || sAccountStatus=='Partial' || sAccountStatus=='Expired Marketing' || sAccountStatus=='Expired'){
                string sCountry = CommunityHelper.getUserCountry(oUser);
                string sLoginPageURL = CommunityHelper.getMassiveURLs(sCountry,'LoginPageURLType');
                string sLanguage = CommunityHelper.getLanguageCode();
                if(sLanguage.equals('en_GB') || sLanguage.equals('en_US')) { sLanguage='en'; }
                if(!String.isBlank(sLoginPageURL)){
                    sLoginPageURL=sLoginPageURL.replace('language', sLanguage).replace('territory', sCountry);
                }
                oPageReference=new PageReference(sLoginPageURL);
                oPageReference.setRedirect(true);
            }else{
                List<Zuora__Subscription__c> lstSubscription=lstAccounts[0].Zuora__Subscriptions__r;
                if(lstSubscription !=null && !lstSubscription.isEmpty() && CommunityHelper.checkIfAllSubscriptionsCancelled(lstSubscription)){
                    oPageReference=new PageReference('/MyAccount');
                    oPageReference.setRedirect(true);
                }
            }
        }
        pagereference oPageRef = createTaskOnPaymentMethodOperation();
        if(oPageRef != null){
            return oPageRef;
        }
        return oPageReference;
    }
    
    /*
    Description: This method is used to identify customer current payment method and set the payment option on page accordingly.
    */
    private void showCurrentPaymentMethod(){
        Zuora__PaymentMethod__c oZPaymentMethod = CommunityHelper.getPaymentInformation(oUser.AccountId);
        /* show customer payment method */
        if(oZPaymentMethod !=null){
            if(oZPaymentMethod.Zuora__Type__c == 'CreditCard'){
                currentPaymentMethod = ccPaymentMethodName = oZPaymentMethod.Zuora__Type__c;
                if(oZPaymentMethod.Zuora__CreditCardMaskNumber__c != null){
                    sCurrentCCMaskNumber = Label.LS_PaymentHistory_Label_Ending + ' ' + oZPaymentMethod.Zuora__CreditCardMaskNumber__c.substring(oZPaymentMethod.Zuora__CreditCardMaskNumber__c.length()-4, oZPaymentMethod.Zuora__CreditCardMaskNumber__c.length()) ;
                }
                sCCType = oZPaymentMethod.Zuora__CreditCardType__c;
                string expiryMonth;
                if((oZPaymentMethod.Zuora__CreditCardExpirationMonth__c).length() < 2){
                    expiryMonth = '0'+oZPaymentMethod.Zuora__CreditCardExpirationMonth__c;
                }else{
                    expiryMonth = oZPaymentMethod.Zuora__CreditCardExpirationMonth__c;
                }
                sCurrentCCExpiry = expiryMonth + ' / ' + (!String.isEmpty(oZPaymentMethod.Zuora__CreditCardExpirationYear__c)? oZPaymentMethod.Zuora__CreditCardExpirationYear__c.substring(2, 4):'' );
            }
            else if(oZPaymentMethod.Zuora__Type__c == 'PayPal'){
                currentPaymentMethod = ppPaymentMethodName = oZPaymentMethod.Zuora__Type__c;
                sCurrentPaypalEmail = CommunityHelper.getObfuscatedEmail(oZPaymentMethod.Zuora__PaypalEmail__c);
            }
            else if(oZPaymentMethod.Zuora__Type__c == 'BankTransfer'){
                currentPaymentMethod = ddPaymentMethodName = oZPaymentMethod.Zuora__Type__c;
                if(oZPaymentMethod.Zuora__BankTransferAccountNumber__c != null){                    
                    sCurrentBTAccountNumber = Label.LS_PaymentHistory_Label_Ending + ' ' +  oZPaymentMethod.Zuora__BankTransferAccountNumber__c.substring(oZPaymentMethod.Zuora__BankTransferAccountNumber__c.length() - 3, oZPaymentMethod.Zuora__BankTransferAccountNumber__c.length());                     
                } 
            }
        }
    }
    
    /*
    Description: This method is used to display payment method options based on user country.
    */
    private void getPaymentMethodConfiguration(){
        // set default value to true for all options.
        showCC = showDD = showPP = true;
        
        PaymentMethodOptionConfig__c oPaymentMethodOptionConfig = PaymentMethodOptionConfig__c.getValues(oUser.Country);
        
        // set options based on country.
        if(oPaymentMethodOptionConfig != null){
            showCC = oPaymentMethodOptionConfig.Credit_Card__c;
            showDD = oPaymentMethodOptionConfig.Direct_Debit__c;
            showPP = oPaymentMethodOptionConfig.Paypal__c;
            zCCPageId = oPaymentMethodOptionConfig.ZuoraCreditCardPageId__c;
            paymentGateway = oPaymentMethodOptionConfig.CardsPaymentGateway__c;
            zDDPageId = oPaymentMethodOptionConfig.ZuoraDirectDebitPageId__c;
            strPmtMode = oPaymentMethodOptionConfig.DefaultPaymentMethod__c;
            
            /* Generate digital signature for Credit card paymet method operation*/
            if(showCC){
                zCCPageResponse = generateDigitalSignature(zCCPageId);
                isCCSecurityCheckPass = true;
                if(zCCPageResponse != null && publicKey != zCCPageResponse.key){
                    sCCSecurityError = Label.LS_ChangePaymentMethod_CreditCard_Authorization_Message;
                    isCCSecurityCheckPass = false;
                }
            }
            
            /* Generate digital signature for direct debit payment method operation*/
            if(showDD){
                zDDPageResponse = generateDigitalSignature(zDDPageId);
                isDDSecurityCheckPass = true;
                if(zDDPageResponse !=null && publicKey != zDDPageResponse.key) {
                    sDDSecurityError = Label.LS_ChangePaymentMethod_DirectDebit_Authorization_Message;
                    isDDSecurityCheckPass = false;
                }
            }
        }
    }
    
    /*
    Description: Get and construct acknowledge information.
    */
    private void getAcknowledgementOnSaveMsg(){
        
        string sLang = CommunityHelper.getLanguageCode();
        string strLanguage;
        if(sLang.length() > 2 && sLang.indexOf('_') > -1){
            strLanguage = sLang.split('_')[0];
        }else{
            strLanguage = sLang;
        }
        string sPrivacyPolicyURL = '/help/' + CommunityHelper.getUserCountry(oUser) + '-'+ strLanguage + '/privacy';
        string sTermsOfUseURL = '/help/' + CommunityHelper.getUserCountry(oUser) + '-'+ strLanguage + '/terms';
        sAcknowledgementOnSave = Label.LS_Change_Payment_Method_Label_Acknowledgement_On_Save.replace('[OPERATION]', Label.LS_Button_Save).replace('[TERMSOFUSEURL]', sTermsOfUseURL).replace('[PRIAVCYPOLICYURL]', sPrivacyPolicyURL);
        sPaypalAcknowledgement = Label.LS_Change_Payment_Method_Label_Acknowledgement_On_Save.replace('[OPERATION]', Label.LS_ChangePaymentMethod_Button_CONTINUE_TO_PAYPAL).replace('[TERMSOFUSEURL]', sTermsOfUseURL).replace('[PRIAVCYPOLICYURL]', sPrivacyPolicyURL);
    }
    
    public PageReference getPaymentMode() {
        return null;
    }
    
    /*
    Description: Method to show message on paypal method cancellation during update.
    */
    private void showPaypalCancelMessage(){        
        string sToken = ApexPages.currentPage().getParameters().get('token');
        if(String.isBlank(sToken) == false){
            showbanner=true;
            sBannerHeader=Label.LS_ChangePaypalPaymentMethodStatus_Failure;
            sBanner=Label.LS_PaymentMethodChange_Paypal_cancel_Msg;
            strPmtMode = 'Paypal';
            return;
        }
    }
    
    /*
Description: Method to navigate on MyAccount page on cancel button click.
*/
    public pagereference onCancelOperation(){
        pagereference oPageref = new pagereference('/MyAccount');
        oPageref.setredirect(true);
        return oPageref ;
    }
    
    /*
Description: Method create new payment method in zuora and assign it as default.
*/
    public Pagereference redirectToPaypal(){
        try{
            PaypalProc oPaypalProc = new PaypalProc();
            return oPaypalProc.sendRequest();                 
        }catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(oUser.Id, 'ChangePaymentMethodController', 'changePaymentMethod', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return null;
        }
    }
    
    /*
Description: Method used to initialize string to show error/information message on page.
*/
    public void showMessage(string strMsg){
        strMessage=strMsg;
    }
    
    /*
Description: Method to get Months in numbers.
*/
    public List<string> getMonths(){
        List<string> lstMonth = new List<string>();
        for(Integer iMonth = 1; iMonth<=12; iMonth++){
            if(iMonth<10)
                lstMonth.add('0' + iMonth);
            else
                lstMonth.add(string.valueOf(iMonth));
        }
        return lstMonth;
    }
    
    /*
Description: Method to get Years.
*/
    public List<string> getYears(){
        List<string> lstYear = new List<string>();
        for(Integer iYear = sCurrentYear; iYear<= sCurrentYear + 20; iYear++){
            lstYear.add(string.valueOf(iYear));
        }
        return lstYear;
    }
    
    /*
Decription: Method to generate digital signature for zuora pages operation
*/
    private ZuoraPageResponse generateDigitalSignature(string sPageId){
        
        ZuoraPageRequest oZPageRequest = new ZuoraPageRequest();
        oZPageRequest.uri = hostedPageURL;
        oZPageRequest.method = 'POST';
        oZPageRequest.pageId = sPageId;
        
        
        /* Prepare Request for Digital Signature*/
        HttpRequest request = new HttpRequest(); 
        if(!String.isBlank(DAZNConfiguration__c.getValues('ZuoraRSASignatureEndPointURL').Value__c)){ //PD-7939    
            request.setEndpoint(DAZNConfiguration__c.getValues('ZuoraRSASignatureEndPointURL').Value__c);
            request.setMethod('POST');
            request.setHeader('content-type', 'application/json');
            request.setHeader('apiAccessKeyId', DAZNConfiguration__c.getValues('ZuoraAPIUserId').Value__c);
            request.setHeader('apiSecretAccessKey', DAZNConfiguration__c.getValues('ZuoraAPIUserPassword').Value__c);
            request.setBody(JSON.serialize(oZPageRequest));
        }
        /* Get response*/
        Http oHttp = new Http();
        try {
            system.debug('request.getBody()============>'+request); 
            HTTPResponse response = oHttp.send(request);    
            if(Test.isRunningTest()){
                return (ZuoraPageResponse)JSON.deserialize('{"signature": "test", "token": "test","tenantId": "test","key": "test", "success":"true"}', ZuoraPageResponse.class);
            }else{
                system.debug('response.getBody()============>'+response.getBody());
                return (ZuoraPageResponse)JSON.deserialize(response.getBody(), ZuoraPageResponse.class);
            }
        } catch(System.CalloutException ex) {
        system.debug('System.CalloutException ex============>'+ex); 
            throw ex;
        }
        return null;
    }
    
    /*
Description: Method to close Banner.
*/
    public void closeBanner(){
        showbanner=false;
    }
    
    /*
Description: Method to show banner on paypal error.
*/
    public void showBanner(){
        string errorMessage = ApexPages.currentPage().getParameters().get('errorcode');
        string sLang = CommunityHelper.getLanguageCode();
        string strLanguage;
        if(sLang.length() > 2 && sLang.indexOf('_') > -1){
            strLanguage = sLang.split('_')[0];
        }else{
            strLanguage = sLang;
        }
        string ContactCustomerSupportURL='/contactus/' + CommunityHelper.getUserCountry(oUser) + '-'+ strLanguage;             
        if(!string.isBlank(status)){            
            showbanner=true;            
            if(status.equals('false')){
                if(errorMessage.equals('invalidcountry')){//Added as a part of PD-12767
                	sBannerHeader = Label.daznui_error_10086_header;
                	sBanner = Label.daznui_error_10086;    
                }else{//End
                	sBannerHeader = Label.LS_ChangePaymentMethod_CreditCard_Failure_Title;
                	sBanner = Label.LS_ChangePaymentMethod_CreditCard_Failure_Message;    
                }
                strPmtMode=sCardType; 
            }
        }
    }
    
    
    /*
     * Description: Method send notification on payment method update
     */
    public void sendUserPaymentMethodUpdateNotification() {
        /*Added inspection for Turn off email PD-9179*/
        Boolean isSend = true;
        if (CommunityHelper.IsDfDUser()) {
            Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
            if (!CommunityHelper.checkSendEmailForAccount() && String.isBlank(pac.Updated_payment_method_email__c)) {
                isSend = false;
            }
        } 
        Boolean isDisableSend = oUser.Account.Disable_Payment_method_updated_emails__c || oUser.Account.Disable_transactional_emails__c; // For PD-8928 and PD-11577
        if (isSend && !isDisableSend) {
            /* Commented out according to PD-13294
            if (!Test.isRunningTest()) {
                CommunicatorIntegrationHelper.sendUserDetailsUpdateNotification(oUser.AccountId, oUser.contactId, oUser.Email, 'Updated_Payment', oUser.LanguageLocaleKey, oUser.CountryCode);
            }*/
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
            // Create task on payment method success operation.
            Task oTask = CommunityHelper.createTask(
                oUser.contactId,
                oUser.AccountId,
                Label.LS_ChangePaymentMethodStatus_Label_Success_Task_Subject,
                Label.LS_ChangePaymentMethodStatus_Label_Success_Task_Subject
            );
            insert oTask;
        }
    }
    
    /*
    Description: Method to create payment method success/failure task.
    */
    public PageReference createTaskOnPaymentMethodOperation() {
        PageReference oRedirectPageRef = null;
        if(sCardType == 'CreditCard' || sCardType == 'DirectDebit'){
            if(status == 'true'){
                //if(!Test.isRunningTest()){
                    List<Zuora.zObject> lstBillingAccount = ZuoraTransactionHelper.zquery('Select Id,PaymentGateway,DefaultPaymentMethodId from Account where CrmId = \''+oUser.AccountId+'\'' );
                    PaymentMethodOptionConfig__c oPaymentMethodOptionConfig = PaymentMethodOptionConfig__c.getValues(oUser.Country);
                    string sZuoraPaymentMethodID = ApexPages.currentPage().getParameters().get('refId');
                    // added null check and moved to Myaccount with error for PD-9013* Start.
                    if(lstBillingAccount != null){
                        ZuoraTransactionHelper.updatePaymentMethod(lstBillingAccount[0],oPaymentMethodOptionConfig.CardsPaymentGateway__c,sZuoraPaymentMethodID,true,oPaymentMethodOptionConfig.DefaultPaymentMethod__c);
                        ZuoraTransactionHelper.setDefaultPayment(oUser.AccountId,sZuoraPaymentMethodID);
                        
                        // send notification on payment method update
                        sendUserPaymentMethodUpdateNotification();
                        /*End PD-9179*/
                    } else{
                        GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionError); 
                        oRedirectPageRef = new PageReference('/MyAccount?ChangePaymentMethodError=true');
                        oRedirectPageRef.setRedirect(true);
                        // added null check and moved to Myaccount with error for PD-9013* end.
                    }
                //}

                // For PD-12084: - Cog 1.6.2
                User user = CommunityHelper.getCurrentUser();
                Account oAccount = CommunityHelper.getAccountInfo(user.AccountId);
                String oldRetrieveEmail = oAccount.Retrieve_Email__c;
                String ccLast4Digits = ApexPages.currentPage().getParameters().get('field_passthrough4');
                if (String.isNotBlank(oldRetrieveEmail) && String.isNotBlank(ccLast4Digits)) {
                    List<String> oldRetrieveEmailParts = oldRetrieveEmail.split('-');
                    if (oldRetrieveEmailParts.size() == 3) {
                        oAccount.Retrieve_Email__c = oldRetrieveEmailParts[0] + '-' + oldRetrieveEmailParts[1] + '-' + ccLast4Digits;
                        update oAccount;
                    }
                }
                oRedirectPageRef = new PageReference('/MyAccount?paymentMethodSuccess=true');
                oRedirectPageRef.setRedirect(true);
            } else{
                //Construct Error Description
                string sErrorDescription='Error Code: ' + ApexPages.currentPage().getParameters().get('errorCode') + 
                    ', Error Message: ' + ApexPages.currentPage().getParameters().get('errorMessage') + 
                    ', Payment method: ' + ApexPages.currentPage().getParameters().get('field_passthrough2');
                
                if(ApexPages.currentPage().getParameters().get('field_passthrough2') == 'CreditCard')
                    sErrorDescription = sErrorDescription + ', Payment Type: ' + ApexPages.currentPage().getParameters().get('field_passthrough3');
                
                sErrorDescription =   sErrorDescription + ', Card: ' + ApexPages.currentPage().getParameters().get('field_passthrough4');
                sErrorDescription =   sErrorDescription + ', JCB Card: ' + ApexPages.currentPage().getParameters().get('param_supportedTypes');
                // Create Task for failure.
                // Changed to new banner as per the PD-9013 if any issue come on Change Payment Method. 
                ZuoraTransactionHelper.createPaymentMethodFailureTask(sErrorDescription, oUser.AccountId);
                GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionError);
                oRedirectPageRef = new PageReference('/MyAccount?ChangePaymentMethodError=true');
                oRedirectPageRef.setRedirect(true);
            }
        }
        return oRedirectPageRef;
    }
    
     /**
     * @Author Cognizant Technology Solutuions
     * @Date 10-Oct-2017
     * @Description : This method is used to Navigate to Redeem Fift code  page
     * @Parameter1 :
    */
     public PageReference redeemGiftCode() {
        PageReference ref = GiftCodeHelper.redeemGiftCode();
        return ref;
    }
}