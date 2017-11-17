global without sharing class PartnerAccountController  {

    public string termsURL { get; set; }
    public string privacyURL { get; set; }
    public string sCountry { get; set; }
    public string sCountryName { get; set; }
    public string sCountryCode { get; set; }
    public string sLanguage { get; set; }
    public string sURLLang { get; set; }
    public string sLang { get; set; }
    public string sTrakingParams { get; set; }
    public boolean strCountryExist { get; set; }
    public boolean sCountryExists { get; set; }
    public static PageReference errorPage = null;

    public Partner_Account_Configuration__c partnerAccConfig { get; private set; }
    public Partner_Account_Configuration__c partnerAccConfigApple { get; private set; }
    public User user { get; private set; }
    public Account oAccount { get; set; }
    public string strMessage { get; set; }
    public String cookieCountry { get; private set; }

    // Name properties
    public string strFirstName { get; set; }
    public string strLastName { get; set; }
    public string sAccountName { get; set; }
    public boolean isNameEdit { get; set; }
    public boolean isNameEditForJP { get; set; }
    public string sNameValidFirstNameErrMsg { get; set; }
    public string sNameValidSurNameErrMsg { get; set; }

    // Email Properties
    public boolean isEmailEdit { get; set; }
    public string strNewEmail { get; set; }
    public string sEmailIncorrectPasswordErrorMsg { get; set; }
    public string sEmailProvideNewEmailErrorMsg { get; set; }

    // Subscription Properties
    public boolean showCancelSubscription { get; set; }
    public string sBanner { get; set; }
    public string sBannerHeader { get; set; }
    public Boolean showbanner { get; set; }
    public Boolean showbannerforSingledevice { get; set; }
    public Boolean showStartWatchingDAZN { get; set; }

    // Userdevices Properties
    private boolean bshowAllUserDevices;
    public boolean bshowAllUserDevicesButton { get; set; }
    public string showAllUserDevicesLabel { get; set; }
    public List<User_Devices__c> lstUserDevices { get; set; }
    public List<wrapUserDevices> wrapUDList{ get; set; }
    public String selectedDeviceID { get; set; }
    public boolean bShowSignOutButton { get; set; }
    //PD-12480
    public List <wrapUserDevices> wrapUDListFull { get; set; }

    // Language Properties
    public string strSelectedLanguage { get; set; }

    // Email Preferences Properties
    public boolean bEmailPreference { get; set; }
    
    public static boolean bDocomotest { get; set; }
    public static String strDocomoSts{ get; set; }
    public static String strDocomoStatus{ get; set; }
    public static String strDocStatusOfChild;
    public static String strDocSetStatusfromChild;
    public static String strDocomoResponseValue{ get; set; }
    public static String strDocomoPartnerId {get; set; }

    public static String subscriptionTypeText {get;set;}
    public static String subscriptionSubTypeText {get;set;}

    /*Start Part of PD-10449*/
    public Boolean isAppleUser                                  { get; set; }
    public String sSubscriptionTypeDescription                  { get; set; }
    public Zuora__PaymentMethod__c paymentDetails               { get; set; }
    public String showPayerror                                  { get; set; }
    public String sCurrentPaypalEmail                           { get; set; }
    public String sCurrentBTAccountNumber                       { get; set; }
    public String lastPaymentInfo                               { get; set; }
    public String sCCMaskNumber                                 { get; set; }
    public String paymentDispay                                 { get; set; }
    public List<Zuora__CustomerAccount__c> lstCustomerAccount   { get; set; }
    public Zuora.zObject oZPayment                              { get; set; }
    public string sCurrency                                     { get; set; }
    public String emailAccount                                  { get; set; }

    public String paymentHistoryLink                            { get; set; }
    public String changePaymentMethodLink                       { get; set; }
    public String cancelSubscriptionLink                        { get; set; }

    public String sFirstNameForPage                             { get; set; }
    public String sLastNameForPage                              { get; set; }
    public String accountStatus                                 { get; set; }

    public String freeTrialEndDate                              { get; set; }
    public String freeTrialCMR                                  { get; set; }
    public string subscriptionType                              { get; set; }
    public string description                                   { get; set; }
    public boolean showResubscribe                              { get; set; }
    public string strReactivationMsg                            { get; set; }
    private Zuora.zObject oZSubscription;

    /*password*/
    public Boolean isPasswordEdit                               { get; set; }
    public string strPassword                                   { get; set; }
    public string strNewPassword                                { get; set; }
    public string strRepeatPassword                             { get; set; }
    public string sPasswordIncorrectCurrentPasswordErrMsg       { get; set; }
    public string sPasswordProvideValidNewPasswordErrMsg        { get; set; }
    public string sForgotPasswordURL                            { get; set; }
    /*End Part of PD-10449*/

    public PartnerAccountPageData pageData { get; set; }

    public static boolean isStatus = false;
    public static boolean isErrorCode = false;

    //Culture info properties
    public string strCurrentCountry                      		{ get; set; }
    public Boolean firstTimeLoadEmailPref;

    //Part of PD-12491/15209/15208
    public Boolean isUpdateUserMISL;
    //Part of PD-12480
    public Boolean isDevicesFromMISL;
    public Boolean isDevicesFromMISLError {get;set;}
     
    /*
        Description: Page Controller.
    */
    public PartnerAccountController() {
        isNameEdit = bDocomotest = isEmailEdit = isPasswordEdit = false;
        isNameEditForJP = false;
        showCancelSubscription = false;
        bshowAllUserDevices = false;
        strDocomoStatus = 'Waiting for response';
        strSelectedLanguage = UserInfo.getLanguage().toLowerCase();
        isUpdateUserMISL = false; //Added as part of PD-12491/15209/15208
        isDevicesFromMISL = false; //Added as part of PD-12480
        isDevicesFromMISLError = false;


        /*start Part of PD-10449*/
        isAppleUser = CommunityHelper.isAppleUser();

        partnerAccConfig = Partner_Account_Configuration__c.getInstance('Docomo');
        
        if (partnerAccConfig != null && !isAppleUser) {
            subscriptionTypeText = partnerAccConfig.Subscription_Type_Heading_Text__c;
            subscriptionSubTypeText = partnerAccConfig.Subscription_Type_Sub_Heading_Text__c;
        }

        if (isAppleUser) {
            partnerAccConfigApple = Partner_Account_Configuration__c.getInstance('Apple'); 
            subscriptionTypeText = partnerAccConfigApple.Subscription_Type_Heading_Text__c;
            subscriptionSubTypeText = partnerAccConfigApple.Subscription_Type_Sub_Heading_Text__c;

            paymentHistoryLink = partnerAccConfigApple.Payment_History_URL__c;
            changePaymentMethodLink = partnerAccConfigApple.Change_Payment_method_URL__c;
            cancelSubscriptionLink = partnerAccConfigApple.Cancel_Subscription_URL_Large__c;
            sForgotPasswordURL = partnerAccConfigApple.Forgot_your_password_URL__c;
        }
        /*End Part of PD-10449*/

        pageData = new PartnerAccountPageData();

        if (user == null) {
            user = CommunityHelper.getCurrentUser();
        }
        if (userInfo.getUserType().Equals('Guest')) {
            redirectToErrorPage('mylogin');
        } else {
            getUserDevices();
            cookieCountry = CommunityHelper.getUserCountryName(User); 
        }    

        strCurrentCountry = user.CountryCode; //added for PD-5776

        if (user.AccountId != null) {
            oAccount = CommunityHelper.getAccountInfo(user.AccountId); 
                strDocomoPartnerId = oAccount.Partner_ID__c ;
            if (oAccount != null) {
               // sAccountName = oAccount.FirstName + ' ' + oAccount.LastName; commented by as per of PD-11206 @@13-03-2017
                if (isAppleUser) {
                    if(strCurrentCountry == 'JP'){
                        sAccountName = oAccount.LastName + ' ' + oAccount.FirstName;                    
                    }
                    else{                    
                        sAccountName = oAccount.FirstName + ' ' + oAccount.LastName;
                    }
                    sFirstNameForPage = oAccount.FirstName;
                    sLastNameForPage = oAccount.LastName;
                    emailAccount = oAccount.PersonEmail;
                    accountStatus = oAccount.Account_Status__c;
                    settingEmailPreference(oAccount);
                } else {
                    if(strCurrentCountry == 'JP'){
                        sAccountName = oAccount.DFD_Last_Name__c + ' ' + oAccount.DFD_First_Name__c;                    
                    }
                    else{                    
                        sAccountName = oAccount.DFD_First_Name__c + ' ' + oAccount.DFD_Last_Name__c;
                    }
                    emailAccount = oAccount.Secondary_Email__c;
                    sFirstNameForPage = oAccount.DFD_First_Name__c;
                    sLastNameForPage = oAccount.DFD_Last_Name__c;
                }
                
                showCancelSubscription = !oAccount.Account_Status__c.equals('Frozen') && !oAccount.Account_Status__c.equals('Expired') && !oAccount.Account_Status__c.equals('Blocked');
            } else {
               redirectToErrorPage('Not able to get the Account with provided Users accountid');
            }         
            //getEmailPreferences();
        }

        MISL_Configuration__c nameOfConfigForCurrentCountry = MISLCalloutHelper.getMISLConfiguration(MISLCalloutHelper.MISL_UPDATE_USER_DETAILS, strCurrentCountry);
        if (nameOfConfigForCurrentCountry != null) {
            isUpdateUserMISL = true;
        }

        /*Start part of PD-10449*/
        if(user.AccountId != null){
            paymentDetails = CommunityHelper.getPaymentInformation(user.AccountID);


            Account oAccount = [Select Account_Status__c,(Select Zuora__Zuora_Id__c,Zuora__Currency__c From R00N40000001kyLcEAI__r) From Account Where ID=:User.AccountId][0];
            lstCustomerAccount = oAccount.R00N40000001kyLcEAI__r;
            subscriptionType=oAccount.Account_Status__c; 
            Map<string,Zuora.zObject> mapSubscriptionPayment;
            
            if(lstCustomerAccount!=null && lstCustomerAccount.size()>0 && lstCustomerAccount[0].Zuora__Zuora_Id__c!=null){
                mapSubscriptionPayment = ZuoratransactionHelper.getUserSubscription(lstCustomerAccount[0].Zuora__Zuora_Id__c);
                sCurrency = lstCustomerAccount[0].Zuora__Currency__c;
            }
            
            if(Test.isRunningTest())
            {
                mapSubscriptionPayment=new Map<string,Zuora.zObject>();
                Zuora.zObject oZobj;
                mapSubscriptionPayment.put('Payment',oZobj);
                mapSubscriptionPayment.put('Subscription',oZobj);
            }
            if(mapSubscriptionPayment != NULL){                          
                if(mapSubscriptionPayment.containsKey('Payment') && mapSubscriptionPayment.get('Payment')!=null){            
                    oZPayment=mapSubscriptionPayment.get('Payment');  
                    lastPaymentInfo = CommunityHelper.getformattedAmount(CommunityHelper.getCurrencySymbol(lstCustomerAccount[0].Zuora__Currency__c),(Decimal)oZPayment.getValue('Amount'),user.Country) + ' ' + Label.LS_MyAccount_Label_On + ' ' + CommunityHelper.getDateByLocale( Datetime.valueOf(String.ValueOf(oZPayment.getValue('EffectiveDate'))) );
                }

                if( (mapSubscriptionPayment.containsKey('Subscription') && mapSubscriptionPayment.get('Subscription') !=null) ) {
                    oZSubscription = mapSubscriptionPayment.get('Subscription');
                    //sBannerName = getBanner();
                    if(subscriptionType !=null && subscriptionType.Equals('Free Trial')){
                        freeTrial();
                    } else if(subscriptionType !=null && subscriptionType.Equals('Active Paid')){
                        description = pageData.label_For_Active_Pais_Status;
                    }
                }
                
            } 
        } else{       
            showPayerror = pageData.change_payment_ErrMsg;//add for PD-9013
            if (!string.isEmpty(showPayerror)) {
                GTMHeaderController.errorDespFromAccountController(pageData.zuora_ConnectionError);
            }
        }
        if(paymentDetails != null){//
            if(paymentDetails.Zuora__PaypalEmail__c != null){
                sCurrentPaypalEmail = CommunityHelper.getObfuscatedEmail(paymentDetails.Zuora__PaypalEmail__c);
                paymentDispay = sCurrentPaypalEmail;
            }   
            if(paymentDetails.Zuora__CreditCardMaskNumber__c != null){
                sCCMaskNumber = pageData.paymentHistory_Label_Ending + ' ' + paymentDetails.Zuora__CreditCardMaskNumber__c.substring(paymentDetails.Zuora__CreditCardMaskNumber__c.length()-4, paymentDetails.Zuora__CreditCardMaskNumber__c.length()) ;
                paymentDispay =  paymentDetails.Zuora__CreditCardType__c + '' + sCCMaskNumber ;
            }
            if(paymentDetails.Zuora__BankTransferAccountNumber__c !=null){
                sCurrentBTAccountNumber = pageData.paymentHistory_Label_Ending + ' ' +  paymentDetails.Zuora__BankTransferAccountNumber__c.substring(paymentDetails.Zuora__BankTransferAccountNumber__c.length() - 3, paymentDetails.Zuora__BankTransferAccountNumber__c.length()); 
                paymentDispay =  pageData.paymentHistory_Label_Directdebit+''+ sCurrentBTAccountNumber ;
            }
        }
        else{
            // redirectToErrorPage('Not able to get the paymentDetails');      
            showPayerror = pageData.change_payment_ErrMsg;// added for PD-9013.
            if(!string.isEmpty(showPayerror)) {
                GTMHeaderController.errorDespFromAccountController(pageData.zuora_ConnectionError);
            }
        }
        /*End Part of PD-10449*/

        PageReference pRCurrentPage = ApexPages.currentPage();
        sCountry = pRCurrentPage.getParameters().get('Country');
        sLanguage = pRCurrentPage.getParameters().get('lang');
        sTrakingParams = pRCurrentPage.getParameters().get('TrakingParams');
        if (String.isBlank(sCountry) || String.isBlank(sLanguage)) {
            strCountryExist = false;
            sCountryName = CommunityHelper.getUserCountryName(null);
            DAZN_Help_Redirect__c strCountryCode = DAZN_Help_Redirect__c.getInstance(sCountryName);
            if (strCountryCode != null) {
                sCountryCode = strCountryCode.CountryISOCode__c;
            } else {
                Map<String, DAZN_Help_Redirect__c> HelpRedirectMap = DAZN_Help_Redirect__c.getall();
                for (DAZN_Help_Redirect__c DAZNHelpRe : HelpRedirectMap.values()) {
                    if (DAZNHelpRe.IsDefaultCountry__c != null && DAZNHelpRe.IsDefaultCountry__c) {
                        sCountryName = DAZNHelpRe.Country__c;
                        sCountryCode = DAZNHelpRe.CountryISOCode__c;
                        sLang = DAZNHelpRe.Language__c;
                        if (sCountryName != null && sCountryCode != null && sLang != null && sCountryName != '' && sCountryCode != '' && sLang != '') {
                            strCountryExist = true;
                        }
                    } 
                }
            }
            if (String.isNotBlank(sCountryCode) && strCountryExist) {   sCountryExists = true;  }
            sLang = CommunityHelper.getUserLanguageCode(sCountryName);
            if (sLang.length() > 2 && sLang.indexOf('_') > -1) {
                sURLLang = sLang.split('_')[0];
            } else {
                sURLLang = sLang;
            }

            termsURL = '/help/' + sCountryCode + '-' + sURLLang + '/terms' + (sTrakingParams == null ? '' : sTrakingParams);
            privacyURL = '/help/' + sCountryCode + '-' + sURLLang + '/privacy' + (sTrakingParams == null ? '' : sTrakingParams);
        } else {
            termsURL = '/help/' + sCountry + '-' + sLanguage + '/terms' + (sTrakingParams == null ? '' : sTrakingParams);
            privacyURL = '/help/' + sCountry + '-' + sLanguage + '/privacy' + (sTrakingParams == null ? '' : sTrakingParams);
        }
        if(strDocomoSts  == '300'){ 
                        strDocomoStatus =  pageData.dFD_300;    GTMHeaderController.errorDespFromAccountController(pageData.dFD_300);
        }
        showSetBanner();
    }

    private void showSetBanner() {
        String banner = ApexPages.currentPage().getParameters().get('banner'); 
        if (String.isNotBlank(banner) && banner.equalsIgnoreCase('updateLanguageFail')) {
            showbanner = true;
            sBannerHeader = Label.DECoup_BannerHeader_Problem;
            sBanner = Label.DECoup_Body_unable_update_language;
        } else if (String.isNotBlank(banner) && banner.equalsIgnoreCase('deregisterDeviceFail')) {
            showbanner = true;
            sBannerHeader = Label.DECoup_BannerHeader_Problem;
            sBanner = Label.DECoup_Unable_to_deregister_device;
        } 
    }

    public void settingEmailPreference(Account oAccount) {
        if (strCurrentCountry == 'DE') {
            bEmailPreference = oAccount.All_Email_Preferences__c && oAccount.Is_Double_OptIn__c ? true : false;
            firstTimeLoadEmailPref = bEmailPreference;
        } else {
            bEmailPreference = oAccount.All_Email_Preferences__c;
            firstTimeLoadEmailPref = bEmailPreference;
        }
        
    }

    /*
        Description: This method implement all edit request from page.
    */
    public void edit() {
        isAppleUser = CommunityHelper.isAppleUser();
        String field = apexpages.currentpage().getParameters().get('field');   
        isNameEdit = false;
        isNameEditForJP = false;
        isEmailEdit = false;  
        isPasswordEdit=false;  
        
        if (field.equals('Email')) {
            isEmailEdit = true; 
            if (isAppleUser) {
                strNewEmail = oAccount.PersonEmail;
            } else {
                strNewEmail = oAccount.Secondary_Email__c;
            }   
            
        } else if (field.equals('Name')) {
            if(strCurrentCountry == 'JP'){
                isNameEditForJP = true;
            }
            else{
                isNameEdit = true;
            } 
            if (isAppleUser) {
                strFirstName = oAccount.FirstName;
                strLastName = oAccount.LastName;
            } else {
                strFirstName =  oAccount.DFD_First_Name__c;
                strLastName = oAccount.DFD_Last_Name__c;
            }
            
        } else if( field.equals('Password')){       
            isPasswordEdit=true;
        } else {
            errorPage = System.Page.InternalServerError;
            errorPage.getParameters().put('Errormsg',' Not able to get the field parameter from URL'); 
        }
    }

    /*
        Description: This implement all Cancel request from page.
    */
    public void cancelEdit() {
        isAppleUser = CommunityHelper.isAppleUser();
        String field = apexpages.currentpage().getParameters().get('field');   
        strMessage = null;

        if (field.equals('Email')) {
            isEmailEdit = false;
            user = CommunityHelper.getCurrentUser();
        } else if(field.equals('Name')) {
            isNameEdit = false;
            isNameEditForJP = false;
            strFirstName = user.FirstName;
            strLastName = user.LastName;
        } else if( field.equals('Password')){       
            isPasswordEdit = false;
        } else {
            errorPage = System.Page.InternalServerError;
            errorPage.getParameters().put('Errormsg',' Not able to get the field parameter from URL');
        }
    }

    /*Start part of PD-10449*/

    public PageReference savePasswordChanges(){ // Removed the validations which are handled by UI - Ganesh
        isAppleUser = CommunityHelper.isAppleUser();
        if (isAppleUser) {
            return savePasswordChangesApple();
        } else {
            try{
                clearErrorFields();
                PageReference redirectUrl = Site.login(user.Username,strPassword,null);
                if(Test.isRunningTest()){
                    redirectUrl = new PageReference('CommunitiesLanding');
                }
                if (redirectUrl == null) {
                    sPasswordIncorrectCurrentPasswordErrMsg = Label.LS_MyAccount_ErrMsg_IncorrectPassword;
                }
                else{
                    if((!String.isblank(strNewPassword) )&&(!String.isblank(strRepeatPassword))&&(!String.isblank(strPassword)))
                    Site.changePassword(strNewPassword,strRepeatPassword,strPassword);                
                                    
                    isPasswordEdit=false;
                    strMessage=null;
                }
            }
            Catch(Exception ex){
                ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'savePasswordChanges', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
                 return redirectToErrorPage(ex.getMessage());   
            }
            return errorPage;
        }
        
    }

    public PageReference savePasswordChangesApple(){ // Removed the validations which are handled by UI - Ganesh
        try{
            clearErrorFields();
            PageReference redirectUrl = Site.login(user.Username,strPassword,null);
            if(Test.isRunningTest()){
                redirectUrl = new PageReference('CommunitiesLanding');
            }
            if (redirectUrl == null) {
                sPasswordIncorrectCurrentPasswordErrMsg = Label.LS_MyAccount_ErrMsg_IncorrectPassword;
            }
            else{
                if((!String.isblank(strNewPassword) )&&(!String.isblank(strRepeatPassword))&&(!String.isblank(strPassword)))
                Site.changePassword(strNewPassword,strRepeatPassword,strPassword);

                // send notification to user on password update.
                if((user.AccountId !=null)&&(user.AccountId !=null)&&(user.Email !=null)&&(user.LanguageLocaleKey !=null)&&(user.CountryCode !=null)) {
                    /*Added inspection for Turn off email PD-9179*/
                    Boolean isSend = true;
                    if (CommunityHelper.IsDfDUser()) {
                        Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
                        if (!CommunityHelper.checkSendEmailForAccount() && String.isBlank(pac.Change_password_email__c)) {
                            isSend = false;
                        }
                    } 
                            
                    if (isSend) {
                        if(!Test.isRunningTest()){
                            CommunicatorIntegrationHelper.doCallOutPasswordUpdateFromFuture(user.AccountId, user.contactId, user.Email, user.LanguageLocaleKey, user.CountryCode);
                        }
                    }
                    Task oTask = CommunityHelper.createTask(user.contactId , user.AccountId , 'Password changed email sent successfully.', 'Password changed email sent successfully.');
                insert oTask;
                    /*End PD-9179*/
                }
                
                                
                isPasswordEdit=false;
                strMessage=null;
            }
        }
        Catch(Exception ex){ ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'savePasswordChanges', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
             return redirectToErrorPage(ex.getMessage());   
        }
        return errorPage;
    }
    /*End Part of PD-10449*/

    /*
        Description: This method save customer name changes.
    */
    public PageReference saveNameChanges() {
        isAppleUser = CommunityHelper.isAppleUser();
        try {
            clearErrorFields();
            if (String.isNotBlank(strFirstName) && String.isNotBlank(strLastName)) {

                if (isAppleUser) {
                    oAccount.FirstName = strFirstName;
                    oAccount.LastName = strLastName;
                } else {
                    oAccount.DFD_First_Name__c = strFirstName;
                    oAccount.DFD_Last_Name__c = strLastName;
                }
                /*Start part of PD-16346*/
                if (isUpdateUserMISL) {
                    String currentAccountId = String.isNotBlank(user.Account.DAZN_Id__c) ? user.Account.DAZN_Id__c : user.AccountId;
                    Map<String, Object> payload = new Map<String, Object> {
                        'AccountID' => currentAccountId,
                        'NewFirstName' => strFirstName,
                        'NewLastName' => strLastName,
                        'IsCrmRequest' => true
                    };
                    MISLCalloutHelper.updateUserDetails(payload,user.AccountId,sCountryCode,true);
                }
                /*End part of PD-16346*/
                update oAccount;
                saveUserNameChanges(user.Id, strFirstName, strLastName);
                if (isAppleUser) {
                    if(strCurrentCountry == 'JP'){
                        sAccountName = oAccount.LastName + ' ' + oAccount.FirstName;                    
                    }
                    else{                    
                        sAccountName = oAccount.FirstName + ' ' + oAccount.LastName;
                    }
                } else {
                    if(strCurrentCountry == 'JP'){
                        sAccountName = oAccount.DFD_Last_Name__c + ' ' + oAccount.DFD_First_Name__c;                    
                    }
                    else{                    
                        sAccountName = oAccount.DFD_First_Name__c + ' ' + oAccount.DFD_Last_Name__c;
                    }
                }
                
                isNameEdit = false; 
				isNameEditForJP = false;
            }
        } catch (Exception ex) {
            ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'saveNameChanges', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return redirectToErrorPage(ex.getMessage());
        }
        return errorPage; 
    }

    /*
        Description: This method save customer name changes in User object.
    */
    @future
    private static void saveUserNameChanges(Id userId, String newFirstName, String newLastName) {
        List<User> user = [Select Id, FirstName, LastName From User Where Id = :userId LIMIT 1];
        if (!user.isEmpty()) {
            user[0].FirstName = newFirstName;
            user[0].LastName = newLastName;
            update user;
        }
    }

    /*
        Description: This method update the customer email address on User and Account object.
    */
    public PageReference saveEmailChanges() { 
        if (isAppleUser) {
           return saveEmailChangesApple();
        } else {
            try {
                clearErrorFields();
                user = CommunityHelper.getCurrentUser();
                if (user != null) {
                    if (user.Email == strNewEmail) {
                        sEmailProvideNewEmailErrorMsg = pageData.myaccount_ErrMsg_ProvideNewEmail;                          
                    } 
                    else{
                        /*PD-9980, PD-10364*/
                        String errorMessage = validateNewAccountEmail();
                        if(String.isNotBlank(errorMessage)){
                            sEmailProvideNewEmailErrorMsg = errorMessage;
                        }
                        else{
                            if (String.isNotBlank(strNewEmail)) {
                                if (isUpdateUserMISL) {
                                    sendEmailtoMISL(user, strNewEmail, strCurrentCountry);
                                }
                                oAccount.Secondary_Email__c = strNewEmail;
                                emailAccount = strNewEmail;
                                update oAccount;
                                saveUserEmailChanges(user.Id, strNewEmail);
                            }

                            //get latest information after update.
                            if (user.AccountId != null) { 
                                oAccount = CommunityHelper.getAccountInfo(user.AccountId);
                            }
                            isEmailEdit = false;
                        }
                    }
                } else {return redirectToErrorPage('Not able to get the current user');  }
            } catch(Exception ex) {
                ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'saveEmailChanges', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
                return redirectToErrorPage(ex.getMessage());    
            }
            return errorPage;
        }
        
    }

    /*
    Description: Method for sending request to MISL. If feature is Enable than Email will be updated on MISL if feature is disable then request  will not be send
    */
    public static void sendEmailtoMISL(User user, String strNewEmail, String strCurrentCountry) {
        String currentAccountId = String.isNotBlank(user.Account.DAZN_Id__c) ? user.Account.DAZN_Id__c : user.AccountId;
        Map<String, Object> payload = new Map<String, Object>{
            'AccountID' => currentAccountId,
            'NewEmail' => strNewEmail,
            'IsCrmRequest' => true
        };
        MISLCalloutHelper.updateUserDetails(payload,user.AccountId,strCurrentCountry,true);
    }

    public PageReference saveEmailChangesApple(){ 
        try{
            clearErrorFields();
            user = CommunityHelper.getCurrentUser();
            if(user != null ){
                if(user.Email == strNewEmail){
                    sEmailProvideNewEmailErrorMsg = Label.LS_Myaccount_ErrMsg_ProvideNewEmail;                          
                }else if([Select count() From Account Where PersonEmail =: strNewEmail]>0){
                    sEmailProvideNewEmailErrorMsg = Label.LS_MyAccount_ErrMsg_EmailIDExists; 
                }else if(string.isBlank(strPassword)){
                    sEmailIncorrectPasswordErrorMsg = Label.LS_MyAccount_ErrMsg_Provide_Password; 
                }
                else if((Site.login(user.Username,strPassword,null)== null) && !Test.isRunningTest()){
                    sEmailIncorrectPasswordErrorMsg = Label.LS_MyAccount_ErrMsg_IncorrectPassword;   
                }else{  
                    if (!string.isBlank(strNewEmail) ) {
                        if (isUpdateUserMISL) {
                            sendEmailtoMISL(user, strNewEmail, strCurrentCountry);
                        }
                        oAccount.PersonEmail = strNewEmail;
                        oAccount.Secondary_Email__c = strNewEmail;
                        emailAccount = strNewEmail;
                        update oAccount;                        

                    }
                    //get latest information after update.
                    if(user.AccountId != null){ 
                    oAccount = CommunityHelper.getAccountInfo(user.AccountId);
                    }  isEmailEdit=false;
                }
            }
            else{
                    return redirectToErrorPage('Not able to get the current user');         
            }
        }
        Catch(Exception ex){ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'saveEmailChanges', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return redirectToErrorPage(ex.getMessage());    
            
        }
        return errorPage;
    }

    /*PD-9980, PD-10364*/
    private String validateNewAccountEmail(){
        if(CommunityHelper.isDfDUser())
        {
            Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
            if (pac != null) {
                if ([Select count() From Account Where Partner_ID__c != null AND Type =: pac.Partner_Type__c AND Secondary_Email__c = :strNewEmail] > 0) {
                    return pageData.myAccount_ErrMsg_DocomoEmailIDExists; 
                }
            }
        }

        return null;
    }

    /*
        Description: This method save customer email changes in User object.
    */
    @future
    private static void saveUserEmailChanges(Id userId, String newEmail) {
        List<User> user = [Select Id, Email From User Where Id = :userId LIMIT 1];
        if (!user.isEmpty()) {
            user[0].Email = newEmail;
            update user;
        }
    }

    /* 
        Description: Method to clear all error messages value.
    */
    public void clearErrorFields() {
        sNameValidFirstNameErrMsg = sNameValidSurNameErrMsg  = '';
        sEmailProvideNewEmailErrorMsg = sEmailIncorrectPasswordErrorMsg = sEmailIncorrectPasswordErrorMsg ='';
        sPasswordProvideValidNewPasswordErrMsg = sPasswordIncorrectCurrentPasswordErrMsg = '';
    }

    /*
        Description: Method to redirect user to error page
    */
    public static PageReference redirectToErrorPage(String strErrMsg) {
        if (strErrMsg.contains('mylogin')) {
            errorPage = System.Page.mylogin;
            return errorPage;
        } else {
            errorPage = System.Page.InternalServerError;
            errorPage.getParameters().put('Errormsg', strErrMsg);
            errorPage.setRedirect(true);
            return errorPage;       
        }      
    }

    /*
        Description: This method get all active and registered devices for a customer.
    */
    public void showAllUserDevices(){
        bshowAllUserDevices = true;
        getUserDevices();
    }

    /*
        Description: This method get all active and registered devices for a customer
    */
    @Testvisible
    private PageReference getUserDevices(){
        try {
            wrapUDList = new List <wrapUserDevices>();
            wrapUDListFull = new List<wrapUserDevices>();
            Integer recordCount = 3;  
            MISLCalloutHelper.GetUserDevicesSuccessResponse getUserDevicesSuccessResponse;
            List<User_Devices__c> lstAllUserDevices;
            sCountryCode = user.CountryCode;
            MISL_Configuration__c nameOfConfigForCurrentCountry = MISLCalloutHelper.getMISLConfiguration(MISLCalloutHelper.MISL_GET_USER_DEVICES, sCountryCode);
            if (nameOfConfigForCurrentCountry != null) {
                isDevicesFromMISL = true;
            }
            
            if (isDevicesFromMISL) {
                Map<String, String> calloutResult = MISLCalloutHelper.getUserDevices(user.AccountId, sCountryCode);
                if (!calloutResult.isEmpty()) {
                    Boolean isResultSuccess = Boolean.valueOf(calloutResult.get('success'));
                    if (isResultSuccess) {
                        getUserDevicesSuccessResponse = (MISLCalloutHelper.GetUserDevicesSuccessResponse)JSON.deserialize(calloutResult.get('message'), MISLCalloutHelper.GetUserDevicesSuccessResponse.class);
                        for (MISLCalloutHelper.MISLDevices item : getUserDevicesSuccessResponse.Devices) {
                            wrapUDListFull.add(new wrapUserDevices(item,sCountryCode));
                        }
                    } else {
                        isDevicesFromMISLError = true;
                    }
                }
            } else {
                lstAllUserDevices = [SELECT Name, Account__c, Date_Of_Registration__c, Type__c, Status__c
                                                                FROM User_Devices__c 
                                                                WHERE Account__c = :user.AccountId 
                                                                    AND Status__c = 'Active' 
                                                                LIMIT 100];
                for (User_Devices__c item :lstAllUserDevices) {
                    wrapUDListFull.add(new wrapUserDevices(item, sCountryCode, null));
                }
            }
            if (!wrapUDListFull.isEmpty()) {
                if (wrapUDListFull.size() > recordCount) {
                    showAllUserDevicesLabel = pageData.myAccount_Button_ViewMore + ' (' + String.valueOf(wrapUDListFull.size() - recordCount) + ')' +  pageData.myaccount_Dropdown;
                    bshowAllUserDevicesButton = true;

                    if (!bshowAllUserDevices) {
                        
                        if (isDevicesFromMISL) {
                            for (Integer counter = 0; counter < recordCount && counter < getUserDevicesSuccessResponse.Devices.size(); counter++) {
                                    wrapUDList.add(new wrapUserDevices(getUserDevicesSuccessResponse.Devices.get(counter),sCountryCode));
                                }
                        } else {
                            for (Integer counter = 0; counter < recordCount && counter < lstAllUserDevices.size(); counter++) {
                                wrapUDList.add(new wrapUserDevices(lstAllUserDevices.get(counter), sCountryCode, null));
                            }
                        }

                    } else {
                        wrapUDList.addAll(wrapUDListFull);
                        bshowAllUserDevicesButton = false;
                    }
                } else {
                    showAllUserDevicesLabel = pageData.myAccount_Button_ViewMore;
                    bshowAllUserDevicesButton = false;    
                    wrapUDList.addAll(wrapUDListFull);
                }
            }
        } catch(Exception ex) { ExceptionLoggerHelper.createExceptionLog(user.Id, 'PartnerAccountController', 'getUserDevices', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return redirectToErrorPage(ex.getMessage());
        }
        return errorPage;
    }

    /*
        Description: This method is to sign out all logged in devices.
    */
    public pageReference signoutAllDevices(){
        try {
            if (ApexPages.currentPage().getParameters().get('cancelButtonclick') == 'true') {
                if (user.AccountId != null && user.ContactId != null) {
                    CommunityHelper.createSignOffTask(user.ContactId, user.AccountId, pageData.myAccount_SignOut_TaskSubject, pageData.myAccount_SignOut_TaskDesc);
                }
            } else {
                if (isDevicesFromMISL) {
                    Map<String,String> calloutResult = CommunityHelper.deRegisterDevicesMISL(user, null, true);
                    if (calloutResult == null || calloutResult.isEmpty() || (calloutResult != null && !calloutResult.isEmpty() && Boolean.valueOf(calloutResult.get('success')) == false)) {
                        return new PageReference('/PartnerAccount' + '?banner=deregisterDeviceFail')   ;
                    } 
                } else {
                    CommunityHelper.signOutOfAllDevices(user);
                }
            }
            String sLoginPageURL = CommunityHelper.getMassiveURLs(User.Country,'LoginPageURLType');
            String sLanguage = CommunityHelper.getLanguageCode();
            if (sLanguage.equals('en_GB') || sLanguage.equals('en_US')) {
                sLanguage = 'en';
            }
            String sTerritory = CommunityHelper.getUserCountry(user);
            
            if (String.isNotBlank(sLoginPageURL)) {
                if (sLoginPageURL.contains('language')) {
                    sLoginPageURL = sLoginPageURL.replace('language', sLanguage);
                }
                if (sLoginPageURL.contains('territory')) {
                    sLoginPageURL = sLoginPageURL.replace('territory', sTerritory);
                }
                PageReference oPageReference = new PageReference(sLoginPageURL);            
                return oPageReference;
            } else {
                return redirectToErrorPage('LoginPageURL is not coming');           
            }
        } catch(Exception ex) { ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'signoutAllDevices', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            errorPage = System.Page.InternalServerError;  errorPage.getParameters().put('errorMsg', ex.getMessage());      
            //throw ex;           
        }
        return errorPage;
    } 

    public void showSignOutBannerSinleDevice() {
        if (!isDevicesFromMISL) {
           User_Devices__c singelUserDevice = [SELECT Id, Type__c, Status__c
            FROM User_Devices__c
            WHERE Id = :selectedDeviceID AND Status__c = 'Active']; 
        }
        
        bShowSignOutButton = true;
        sBanner = pageData.warning_Popup_Msg;
        /*PD-10525*/
        if (strSelectedLanguage == 'ja') {
            sBannerHeader = pageData.signout_Singel_Device_Banner_Header;
        }
        else { sBannerHeader= pageData.signout_Singel_Device_Banner_Header;    }
        
        showbannerforSingledevice = true;
        showStartWatchingDAZN = false;
    }

    /*
        Description: Method to navigate on DAZN home page.
    */
    public PageReference DAZNHomePageNavigationHandler(){
        //string sHomePageURL = CommunityHelper.getMassiveURLs(User.Country, 'HomePageURLType');
        //if (!String.isBlank(sHomePageURL)) {
        //    PageReference reference = new PageReference(sHomePageURL);
        //    reference.setRedirect(true);
        //    return reference;
        //} else {
        //    return redirectToErrorPage('Not able to get the Homepage URL]');
        //}
        return null;
    }

    public void closeBanner() {
        showBanner = false;
        showbannerforSingledevice = false;
    }

    public void showSignOutBanner() {
        bShowSignOutButton = true;
        sBanner = pageData.myAccount_ConfirmMsg_Signoutalldevices;
        sBannerHeader = pageData.sign_out_Banner_Header;
        showBanner = true;
        showStartWatchingDAZN = false;
    }

       /*
        Description: This method is to Deregister the singel device.
		removed sourceIp logic and Sessions and devices deleted basics on selectedDeviceID as per the PD-11487. 
    */
    public PageReference deregisterSingelUserDevice() {
        if (String.isNotBlank(selectedDeviceID)) {

            if (isDevicesFromMISL) {
                Map<String, String> calloutResult = CommunityHelper.deRegisterDevicesMISL(user, selectedDeviceID, false);
                if (calloutResult == null || calloutResult.isEmpty() || (calloutResult != null && !calloutResult.isEmpty() && Boolean.valueOf(calloutResult.get('success')) == false)) {
                    return new PageReference('/PartnerAccount' + '?banner=deregisterDeviceFail')   ;
                } 
            } else {
                User_Devices__c singelUserDevice= [SELECT id,Account__c, Status__c,Type__c,IP_address__c FROM User_Devices__c where id=:selectedDeviceID];  
                List<Id> objId = new List<Id>();
                List<AuthSession> lstActiveUserSessionsDesktop =  new List<AuthSession>(); 
                lstActiveUserSessionsDesktop = [Select ID From AuthSession Where UsersId =: user.Id ];
                if(singelUserDevice != null){
                    objId.add(singelUserDevice.Id);
                }
                 //delete AuthSession
                if(lstActiveUserSessionsDesktop!=null && lstActiveUserSessionsDesktop.size()>0){
                   delete lstActiveUserSessionsDesktop;
                } 
                //delete Singel device
                if(objId!=null && objId.size()>0){
                    deleteUserDevice(objId);
                }
            }
            
            //mylogin redirect
            String sLoginPageURL = CommunityHelper.getMassiveURLs(User.Country,'LoginPageURLType');
            String sLanguage = CommunityHelper.getLanguageCode();
            if (sLanguage.equals('en_GB') || sLanguage.equals('en_US')) {
                sLanguage = 'en';
            }
            String sTerritory = CommunityHelper.getUserCountry(user);
            
            if (String.isNotBlank(sLoginPageURL)) {
                if (sLoginPageURL.contains('language')) {
                    sLoginPageURL = sLoginPageURL.replace('language', sLanguage);
                }
                if (sLoginPageURL.contains('territory')) {
                    sLoginPageURL = sLoginPageURL.replace('territory', sTerritory);
                }
                PageReference oPageReference = new PageReference(sLoginPageURL);            
                return oPageReference;
            } else {
                return redirectToErrorPage('LoginPageURL is not coming');           
            }
        }
            showbannerforSingledevice = false; return null;
    }//  End of Code part of the PD-9458

    /*
        Description: Method to get language options to display on page.
    */
    public List<CommunityHelper.UserLanguage> getLanguages() {
        // Store all required languages list.
        List<CommunityHelper.UserLanguage> languages = new List<CommunityHelper.UserLanguage>();
        DAZNLanguageSetting__c oDAZNLanguageSetting = DAZNLanguageSetting__c.getValues(User.Country);
        if (oDAZNLanguageSetting != null) {
            List<String> lstLanguages = oDAZNLanguageSetting.LanguageToDisplay__c.toLowerCase().split(',');
            for (String sLanguage : lstLanguages) {
                if (sLanguage.toLowerCase().equals('ja')) {
                    languages.add(new CommunityHelper.UserLanguage(sLanguage, pageData.myAccount_Language_Japanese_Label));
                } else if (sLanguage.toLowerCase().equals('en_gb') || sLanguage.toLowerCase().equals('en_us')) {
                    languages.add(new CommunityHelper.UserLanguage(sLanguage, pageData.myAccount_Language_English_Label));  
                } else if (sLanguage.toLowerCase().equals('fr_ca') || sLanguage.toLowerCase().equals('fr')){
                    languages.add(new CommunityHelper.UserLanguage(sLanguage, Label.LS_MyAccount_Language_French_Label));  
                } else if (sLanguage.toLowerCase().equals('de')) {
                    languages.add(new CommunityHelper.UserLanguage(sLanguage, pageData.myaccount_Language_UnitedKingdom_DE_Label));
                }
            }
        }
        return languages;
    }

    /*
        Description: Method to update user selected language in system.
    */
    public PageReference updateUserLanguage() {        
        try {
            if(strSelectedLanguage !=null && strSelectedLanguage.split('_').size() > 1){
                strSelectedLanguage = strSelectedLanguage.split('_')[0] +'_' + strSelectedLanguage.split('_')[1].toUpperCase();
            }
            
            if (isUpdateUserMISL) {
                String currentAccountId = String.isNotBlank(user.Account.DAZN_Id__c) ? user.Account.DAZN_Id__c : user.AccountId;
                Map<String, Object> payload = new Map<String, Object>{
                    'AccountID' => currentAccountId,
                    'NewLanguageCode' => strSelectedLanguage,
                    'IsCrmRequest' => true
                    };
                Map<String,String> calloutResult = MISLCalloutHelper.updateUserDetails(payload, user.AccountId, strCurrentCountry, true);
                if (calloutResult == null || calloutResult.isEmpty() || (calloutResult != null && !calloutResult.isEmpty() && Boolean.valueOf(calloutResult.get('success')) == false)) {
                    return new PageReference('/PartnerAccount' + '?banner=updateLanguageFail')   ;
                }
            }

            oAccount.Notification_Language_Code__c = strSelectedLanguage;
            update oAccount;
            user.LanguageLocaleKey = strSelectedLanguage;
            update User;
        } catch(Exception ex) {
            ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'updateUserLanguage', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            errorPage = System.Page.InternalServerError;
            errorPage.getParameters().put('errorMsg', ex.getMessage());
        }
        return errorPage;
    }

    /*
        Description: This method used to set the customer email preference on account.
    */
    public PageReference setEmailPreferences() {
        try {
            List<Account> lstAccount = [SELECT All_Email_Preferences__c, Is_Double_OptIn__c FROM Account WHERE ID = :user.AccountId limit 1];
            if (lstAccount != null && !lstAccount.isEmpty()) {
                Account oAccount = lstAccount[0];
                if (isAppleUser) {
                    if (strCurrentCountry == 'DE') {
                        if (bEmailPreference == false && firstTimeLoadEmailPref == true) {
                            oAccount.All_Email_Preferences__c = bEmailPreference;
                            oAccount.Is_Double_OptIn__c = bEmailPreference;
                        }
                        if (bEmailPreference == true && firstTimeLoadEmailPref == false) {
                            oAccount.All_Email_Preferences__c = bEmailPreference;
                        }
                    } else if (strCurrentCountry != 'DE') {
                        oAccount.All_Email_Preferences__c = bEmailPreference;
                    }
                } else  {
                    oAccount.All_Email_Preferences__c = bEmailPreference;
                    if (!bEmailPreference) {
                        oAccount.Is_Double_OptIn__c = bEmailPreference;
                    }
                }
                
                update oAccount;
            }
        } catch(Exception ex) {
            ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'setEmailPreferences', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            errorPage = System.Page.InternalServerError;
            errorPage.getParameters().put('errorMsg', ex.getMessage());
        }
        return errorPage;
    }



    /*
    Description: Wrapper class for user devices.
    */
    public class wrapUserDevices {

        //for 12480
        public String  typeOfDevice         { get; set; }
        public String idDevice              { get; set; }
        public String registrationDate      { get; set; }

        public wrapUserDevices(MISLCalloutHelper.MISLDevices device, String sCountry){
            typeOfDevice = device.Type;
            idDevice = device.Id;
            registrationDate = CommunityHelper.ConvertDateToString(makeDate(device.RegistrationDate),sCountry,null);
        }   

        public wrapUserDevices(User_Devices__c device, String sCountry, String sctingValue){
            typeOfDevice = device.Type__c;
            idDevice = device.Id;
            registrationDate = CommunityHelper.ConvertDateToString(device.Date_Of_Registration__c,sCountry,null);
        }

        public Date makeDate(String stringDate) {
            String[] myDateOnly = stringDate.split('T');
            String[] strDate = myDateOnly[0].split('-');
            
            Integer myIntDate = integer.valueOf(strDate[2]);
            Integer myIntMonth = integer.valueOf(strDate[1]);
            Integer myIntYear = integer.valueOf(strDate[0]);
            Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
            return d;
        }  
    }

    
    
    
    /*
    Description; This method is used for to get the response from Docomo and helps to do the lazy loading of dfd account page.
    */
    @RemoteAction
    global static string respFromDocomo(String DfdPartnerId)
    {           try{
                    String xml ='';
                    if (!String.isBlank(DfdPartnerId) ){
                    String strDfdPartnerId = DfdPartnerId;
                    xml = '<methodCall><methodName>MelMaga.ref</methodName><params><param><value><struct><member><name>siteId</name><value>DAZN4docomo</value></member><member><name>Idtype</name><value>AI</value></member><member><name>Id</name>';
                    xml = xml+  '<value>'+strDfdPartnerId+'</value>';
                    xml= xml+  '</member></struct></value></param></params></methodCall>';
                    }
                    PartnerAccountPageData pageData = new PartnerAccountPageData();
                    Http httpObj = new Http();
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
                    Dom.Document doc = new Dom.Document();
                    doc.load(xml);
                    HttpRequest req = new HttpRequest();
                    req.setHeader('Content-Type', 'text/xml');
                    req.setHeader('HOST', pageData.dFD_HOST);
                    req.setHeader('CONTENT-LENGTH', pageData.dFD_CONTENT_LENGTH);
                    req.setHeader('PORT',  pageData.dFD_PORT);
                    req.setEndpoint(pageData.dFD_SetEndpoint);
                    req.setMethod('POST');
                    req.setBodyDocument(doc);
                        
                    // Send the request, and return a response
                    
                        HttpResponse res = httpObj.send(req); 
                        DOM.Document xmlDOC = res.getBodyDocument();
        system.debug('xmlDOC=====>'+xmlDOC.toXmlString());
                        DOM.XMLNode rootElement = xmlDOC.getRootElement();
                    for(DOM.XMLNode xmlNodeObj : xmlDOC.getRootElement().getChildElements()){
                            strDocomoSts = loadChilds(xmlnodeobj); 
                        }   
            system.debug('strDocomoSts=====>'+strDocomoSts);
                    if(strDocomoSts  == '404'){
                        strDocomoStatus = pageData.dFD_404;
                        }
                    else if(strDocomoSts  == '500'){ 
                        strDocomoStatus = pageData.dFD_500;
                        }
                    else if(strDocomoSts  == '300'){ 
                        strDocomoStatus =  pageData.dFD_300;
                          
                        }
                    else if(strDocomoSts  == '0'){ 
                        strDocomoStatus = '0' ;
                        }
                    else if(strDocomoSts  == '1'){ 
                        strDocomoStatus = '1' ;
                        }         
                
                }
        catch (Exception ex){ ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'PartnerAccountController', 'respFromDocomo', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        }
        system.debug('strDocomoStatus=====>'+strDocomoStatus);
       return strDocomoStatus ;     
    }
    
    /*
    Description; This method is used for to Set the response from Docomo and helps to prevent the bombading the dfd checkbox on dfd account page.
    */
    
    @RemoteAction
    global static string respToSetTheDocomo( boolean bolDocomo , String DfdPartnerId)
    {           
                try{
                        string strDocomoBolnValue = '0'; // Setting the required value for i4 in request xml based on the check box result from UI
                        if(bolDocomo){
                            strDocomoBolnValue = '1' ;
                            }
                        if (!String.isBlank(DfdPartnerId) ){
                        String strDfdPartnerId = DfdPartnerId;  
                        string xml ='<?xml version="1.0" encoding="UTF-8"?><methodCall><methodName>MelMaga.edit</methodName><params><param><value><struct><member><name>siteId</name><value>DAZN4docomo</value></member><member><name>dmktSessionId</name><value>SESSIONID</value></member>';
                        xml = xml +'<member><name>group</name><value><array><data><value><struct>  <member><name>Idtype</name><value>AI</value></member>';
                        xml = xml +' <member><name>Id</name><value>'+strDfdPartnerId+'</value></member> ';
                        xml = xml +' <member><name>magaId</name><value>DZN000000001</value></member><member>';
                        xml = xml + '<name>flg</name><value><i4>'+strDocomoBolnValue+'</i4></value></member></struct></value></data></array></value></member></struct></value></param></params></methodCall>'; 
                        PartnerAccountPageData pageData = new PartnerAccountPageData();
                        Http httpObj = new Http();
                        Dom.Document doc = new Dom.Document();
                        doc.load(xml);
                        HttpRequest req = new HttpRequest();
                        req.setHeader('Content-Type', 'text/xml');
                        req.setHeader('HOST', pageData.dFD_HOST);
                        req.setHeader('CONTENT-LENGTH', pageData.dFD_CONTENT_LENGTH);
                        req.setHeader('PORT',  pageData.dFD_PORT);
                        req.setEndpoint(pageData.dFD_SetEndpoint);
                        req.setMethod('POST');
                        req.setBodyDocument(doc);
                        // Send the request, and return a response
                        HttpResponse res = httpObj.send(req);                           
                        DOM.Document xmlDOC = res.getBodyDocument();
                                system.debug('xmlDOC=====>'+xmlDOC.toXmlString());
                        DOM.XMLNode rootElement = xmlDOC.getRootElement();
                        for(DOM.XMLNode xmlNodeObj : xmlDOC.getRootElement().getChildElements()){
                            strDocomoResponseValue = loadChildsForSetResponse(xmlnodeobj); 
                            }                                    
                        }       
                        
                }
        catch (Exception ex){ ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'PartnerAccountController', 'respToSetTheDocomo', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        }
        system.debug('strDocomoResponseValue=====>'+strDocomoResponseValue);
        return  strDocomoResponseValue ;        
    }
    
    /*
    Description; This method is helper method of "respFromDocomo" method
    */
    @TestVisible    
    private  static string  loadChilds(DOM.XMLNode xmlnode)
            {                
                for(Dom.XMLNode child : xmlnode.getChildElements())
                    {
                            if(child.getText()!= null)
                            {
                                if(child.gettext()=='errorCode'){
                                    isErrorCode = true;
                                    }
                                if(child.gettext()=='status'){
                                    isStatus = true;
                                    }
                                if(child.getname()=='i4' && isErrorCode){
                                    if(child.gettext().length() > 1){
                                        strDocStatusOfChild = child.gettext(); break;
                                        }
                                    }
                                if(child.getname()=='i4' && isStatus){
                                    if(child.gettext().length() >= 1){
                                        strDocStatusOfChild = child.gettext();break;
                                        }
                                    }
                                loadChilds(child);
                            }
                    }
                return strDocStatusOfChild;
            }
    /*
    Description; This method is helper method of "respToSetTheDocomo" method.
    */
    @TestVisible        
    private  static string  loadChildsForSetResponse(DOM.XMLNode xmlnode)
            {                
                for(Dom.XMLNode child : xmlnode.getChildElements())
                {
                    if(child.getText()!= null)
                        {
                            if(child.gettext()=='errorCode'){
                                isErrorCode = true;
                                }
                            if(child.getname()=='i4' && isErrorCode){
                                    if(child.gettext().length() >= 1){
                                        strDocSetStatusfromChild = child.gettext();break;
                                    }
                                } 
                            loadChildsForSetResponse(child);
                        }
                    }
                return strDocSetStatusfromChild;
            }

    /*PD-10385*/
    public PageReference navigateUser() {
        if (!CommunityHelper.IsDfDUser() && !CommunityHelper.isAppleUser()) {
            return System.Page.MyAccount;
        }   return null;
    }
    
    public string navigatedfd( String s1) {
        String s2 = s1; return s2;
    }

    @future
    public Static void deleteUserDevice(List<Id> objUserId){
    try{
            Database.delete(objUserId);
        }
    catch(Exception ex){
          ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'MyAccountController', 'deleteUserDevice', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
           errorPage=System.Page.InternalServerError;
           errorPage.getParameters().Put('errorMsg',ex.getMessage());
        }
    }

    public void freeTrial(){
        sSubscriptionTypeDescription = ZuoraTransactionHelper.getSubscriptionDescription(Label.LS_Label_FreeSubscriptionTypeDescription,oZSubscription,lstCustomerAccount[0].Zuora__Currency__c);
        if (oZSubscription!=null && String.ValueOf(oZSubscription.getValue('Status')).equalsIgnoreCase('Active')) {
           List<Zuora__CustomerAccount__c> billAccount = [SELECT Zuora__MRR__c FROM Zuora__CustomerAccount__c WHERE Id = :lstCustomerAccount[0].Id];
           description = pageData.montly_subscription_cost_Apple + ' ' + String.valueOf(billAccount[0].Zuora__MRR__c) + CommunityHelper.getCurrencySymbol(lstCustomerAccount[0].Zuora__Currency__c);
        } else if (oZSubscription!=null && String.ValueOf(oZSubscription.getValue('Status')).equalsIgnoreCase('Cancelled')) {
            description=ZuoraTransactionHelper.getSubscriptionDescription(Label.LS_MyAccount_InfoMsg_SubscriptionDescFreeUnsubscribed,oZSubscription,lstCustomerAccount[0].Zuora__Currency__c);
            strReactivationMsg=ZuoraTransactionHelper.getSubscriptionDescription(Label.LS_MyAccount_InfoMsg_Reactivation,oZSubscription,lstCustomerAccount[0].Zuora__Currency__c);
            ///showResubscribe=true;
        }
    }
}