public without sharing class MyAccountHomePageController  {

public User user { get; set; }
public Account oAccount { get; set; }
public string cookieCountry { get; set; }
Transient Public String sCountryName;
Transient Public String sCountryCode;
Transient Public String sLanguage;
Transient Public Id sAccountId ;
public string sCurrency ;
public string strMessage ;

public  static PageReference errorPage = null;//
public string subscriptionType { get; set; }
public Boolean showAddPaymentFlag  { get; set; }
public Boolean isShowPaymentChange { get; set; }
public boolean showCancelSubscription { get; set; }

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

// Password Prooperties
public boolean isPasswordEdit { get; set; }
public string strPassword { get; set; }
public string strNewPassword { get; set; }
public string strRepeatPassword { get; set; }
public string sPasswordIncorrectCurrentPasswordErrMsg {get; set; }
public string sPasswordProvideValidNewPasswordErrMsg {get; set; }
public string sForgotPasswordURL{get;set;}
  public string urlForgotPassword { get; set; }

// Userdevices Properties
public List<User_Devices__c> lstUserDevices { get; set; }
private boolean bshowAllUserDevices;
public boolean bshowAllUserDevicesButton { get; set; }
public string showAllUserDevicesLabel { get; set; }
public List <wrapUserDevices> wrapUDList { get; set; }
Public id selectedDeviceID { get; set; }
Public User_Devices__c singelUserDevice;
public boolean bShowSignOutButton { get; set; }

 // Banner  Properties
public string sBanner { get; set; }
public string sBannerHeader { get; set; }
public Boolean showbannerforSingledevice { get; set; }
public Boolean showStartWatchingDAZN { get; set; }
public Boolean showbanner { get; set; }
public Boolean showGiftCodeExpiryBanner { get; set; }
public boolean showOnlyError {get;set;} //Added string part of PD-9013
public string showPayerror {get;set;} //Added string part of PD-9013


//Subscription Properties
 public List<Zuora__Subscription__c> lstZSubscriptions ;
 public List<Zuora__CustomerAccount__c> lstCustomerAccount ;
 public List<Zuora__Payment__c> lstZPayments ;
 public Zuora__Subscription__c oActSubscription ;
 Public Static  Date ratePlanChargeChargedThroughDate ; 
 public Zuora__Payment__c oZPayment { get; set; } 
 public string lastPaymentInfo { get; set; }
 public string sSubscriptionTypeDescription { get; set; }
 public string description { get; set; }
 public string strReactivationMsg { get; set; }
 public boolean showResubscribe { get; set; }
 public string sBannerName { get; set; }


//Gift Code Properties 
public Boolean showAddGiftCodeFlag { get; set;}

// Language Properties
public string strSelectedLanguage { get; set; }


//Pause Properties 

Public Boolean pauseSchBool ;
Public Boolean isPauseEnable;
Public String nextPayValForPause { get; set; }
Public Boolean pauseSchedule { get; set; }
Public Boolean pauseDone { get; set; }
Public String pauseStartDate;
Public String pauseStopDate;


// Email Preferences Properties
public boolean bEmailPreference { get; set; }

// NFL Marketing Properties
public boolean bNFLMarketing { get; set; }
public boolean bNFLMarketingFlag {get;set;}

//Payment method 
public string paymentMethodPaypal { get; set; } //Added string part of PD-16572
public Zuora__PaymentMethod__c paymentDetails { get; set; }
public string sCurrentPaypalEmail { get; set; }
public string PaymentDispay { get; set; } //Added string part of PD-9013
public string sCCMaskNumber { get; set; }
public string sCurrentBTAccountNumber { get; set; }
public string expiryYear { get; set; }
public string expiryMonth { get; set; }


public MyAccountHomePageController(){  

user  = [Select Id,
         Contact.Id,
         Contact.Account.Type,
         Contact.Account.Partner_ID__c, 
         AccountId,
         Account.Submitted_for_cancellation__c,
         FirstName,
         LastName,
         Email,
         UserName, 
         CountryCode,
         Country, 
         contactId,
         LanguageLocaleKey,
         Account.Disable_Payment_method_updated_emails__c,
         Account.Disable_transactional_emails__c, profileid,
         Account.DAZN_Id__c
         
         From User Where Id = :UserInfo.getUserId()];

system.debug('user$$$$$$$$'+user);
         
If (user!= null){
sLanguage =userInfo.getLanguage();
sCountryCode = user.CountryCode;
sCountryName = user.Country;
strSelectedLanguage = UserInfo.getLanguage().toLowerCase();        

system.debug('sCountryCode $$$$$$$$'+sCountryCode);

}

if (user.AccountId != null) { 
   
   sAccountId = user.AccountId ;
   
        oAccount = [Select Id, 
                   FirstName, 
                   LastName, 
                   DFD_Last_Name__c, 
                   DFD_First_Name__c, 
                   PersonEmail,
                   Secondary_Email__c, 
                   IsPersonAccount,
                   Account_Status__c,
                   Partner_ID__c, 
                   Retrieve_Email__c, 
                   Notification_Country_Code__c,
                   Notification_Language_Code__c,
                   Submitted_for_cancellation__c,
                   All_Email_Preferences__c,
                   Is_Double_OptIn__c ,
                   PauseScheduled__c,
                   Cancelled_Account__c ,
                   Pause_Until__c,
                   Previous_BCD__c,
                   Pause_From__c
                   From Account Where Id = :sAccountId Limit 1];
}   

system.debug('sAccountId$$$$$$$$'+sAccountId);

 lstCustomerAccount = [select id ,
                      Zuora__Default_Payment_Method__c, 
                      Zuora__AutoPay__c ,
                      Zuora__Zuora_Id__c, 
                      Zuora__Currency__c ,
                      Zuora__MRR__c 
                      From Zuora__CustomerAccount__c where Zuora__Account__c =:oAccount.id];
 
 system.debug('lstCustomerAccount$$$$$$$$'+lstCustomerAccount);
 
 if (lstCustomerAccount != null && !lstCustomerAccount.isEmpty()){
 sCurrency = lstCustomerAccount[0].Zuora__Currency__c;
 }
 
 lstZSubscriptions = [Select id,Name,
                            Zuora__CustomerAccount__c ,
                            SubscriptionAmount__c,
                            Zuora__ContractEffectiveDate__c,
                            Zuora__External_Id__c,
                            Giftcode__c,
                            Zuora__Status__c,
                            Gift_Code_End_Date__c,
                            Zuora__SubscriptionEndDate__c,
                            Zuora__NextRenewalDate__c,
                            Free_Trial_End_Date__c,
                            Zuora__Account__c,
                            Zuora__TermSettingType__c,
                            Zuora__NextChargeDate__c,
                            NumGiftPeriods__c, 
                            Zuora__CustomerAccount__r.Zuora__Currency__c
                            From Zuora__Subscription__c Where  Zuora__Account__c =:oAccount.id AND (Zuora__Status__c='Active'OR (Zuora__Status__c='Cancelled' AND Zuora__SubscriptionEndDate__c > TODAY ))] ;
                            
  if (lstZSubscriptions != null && !lstZSubscriptions.isEmpty()){
     oActSubscription = lstZSubscriptions[0] ;
     }
  
   system.debug('oActSubscription$$$$$$$$'+oActSubscription);

  lstZPayments = [Select Zuora__Amount__c,
                       Zuora__External_Id__c
                       From Zuora__Payment__c Where  Zuora__Account__c =:oAccount.id ];
                       
  if(lstZPayments != null && !lstZPayments.isEmpty()){
  oZPayment = lstZPayments[0]; 
  }
  system.debug('oZPayment$$$$$$$$'+oZPayment);


    isNameEdit = isEmailEdit = isPasswordEdit = false;
    isNameEditForJP = false;
    showCancelSubscription = false;   
    showStartWatchingDAZN = false;
    showOnlyError = false; // Added For PD-9013
    bshowAllUserDevices = false;


     if (userInfo.getUserType().Equals('Guest')) {
        redirectToErrorPage('mylogin');
    } else {
        cookieCountry = user.Country; //@Megha 
    
     if (oAccount != null) {
            
            subscriptionType = oAccount.Account_Status__c;
            paymentDetails = CommunityHelper.getPaymentInformation(user.AccountID);

            if(sCountryCode == 'JP'){
                  sAccountName = oAccount.LastName + ' ' + oAccount.FirstName;                    
            }
            else{                    
                sAccountName = oAccount.FirstName + ' ' + oAccount.LastName;
            }
            
            if(sCountryCode.contains('CA'))
            {
            getNFLMarketingPreferences();
            bNFLMarketingFlag = true;
            }else
            {
                bNFLMarketingFlag = false;
        }
                 showGiftCodeExpiryBanner = GiftCodeHelper.isGiftCodeEndDateExpire(user.AccountId);

                 getBanner();
                 getEmailPreferences();
                 getZuoraUserSubscription();   
                 getUserDevices();   
                 sForgotPasswordURL = getForgotpasswordURL();
                 showPaymentMethodSuccessBanner();
                 showSetPauseBanner();
                 paymentDetails();

            
        } 
        else   { 
               
        showPayerror = Label.LS_Change_payment_ErrMsg.replace('[Scountry]',sCountryCode).replace('[Slang]',sLanguage);//add for PD-9013
        if (!string.isEmpty(showPayerror)) {
            GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionError);
            }
            
            else {
            redirectToErrorPage('Not able to get the Account with provided Users accountid');
        } 
       }
        
    }   
   

}

public Void paymentDetails() {


        if (paymentDetails != null) {
        paymentMethodPaypal = '';
        if (paymentDetails.Zuora__PaypalEmail__c != null) {
            sCurrentPaypalEmail = CommunityHelper.getObfuscatedEmail(paymentDetails.Zuora__PaypalEmail__c);
            paymentMethodPaypal = Label.LS_PaymentHistory_Label_PayPal; 
            PaymentDispay = sCurrentPaypalEmail;
        }   
        if (paymentDetails.Zuora__CreditCardMaskNumber__c != null) {
            sCCMaskNumber = Label.LS_PaymentHistory_Label_Ending + ' ' + paymentDetails.Zuora__CreditCardMaskNumber__c.substring(paymentDetails.Zuora__CreditCardMaskNumber__c.length()-4, paymentDetails.Zuora__CreditCardMaskNumber__c.length()) ;
            PaymentDispay =  paymentDetails.Zuora__CreditCardType__c+' '+ sCCMaskNumber ;
        }
        if (paymentDetails.Zuora__BankTransferAccountNumber__c != null) {
            sCurrentBTAccountNumber = Label.LS_PaymentHistory_Label_Ending + ' ' +  paymentDetails.Zuora__BankTransferAccountNumber__c.substring(paymentDetails.Zuora__BankTransferAccountNumber__c.length() - 3, paymentDetails.Zuora__BankTransferAccountNumber__c.length()); 
            PaymentDispay =  Label.LS_PaymentHistory_Label_Directdebit+' '+ sCurrentBTAccountNumber ;
        }
        
    } else if ((oActSubscription != null && lstCustomerAccount != null) && (GiftCodeHelper.checkPaymentMethod(oActSubscription , lstCustomerAccount[0]))){
        showAddPaymentFlag = GiftCodeHelper.checkPaymentMethod(oActSubscription , lstCustomerAccount[0]); 
        
    }
    else {
    
    
    showPayerror = Label.LS_Change_payment_ErrMsg.replace('[Scountry]',sCountryCode).replace('[Slang]',sLanguage); // added for PD-9013.//PD-11051
        if (!string.isEmpty(showPayerror)) {
            GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionError);
      }
    }  


}



public static PageReference redirectToErrorPage(String strErrMsg) {
    if (strErrMsg.contains('mylogin')) {
        errorPage = System.Page.mylogin;
        return errorPage;
    } else {
        errorPage = System.Page.InternalServerError;
        errorPage.getParameters().Put('Errormsg',strErrMsg);
        errorPage.setRedirect(true);
        return errorPage;       
    }      


}

public pagereference callpageredirect() {
        PageReference demoPage = new pagereference('/apex/mylogin');
        demoPage.setRedirect(true);
        return demoPage;
    }

public PageReference navigateUser(){
    PageReference oPageReference = null;
    

    String setepref = ApexPages.currentPage().getParameters().get('setepref');
    if (String.isNotBlank(setepref) && setepref.equalsIgnoreCase('true')) {
        
        if (oAccount.All_Email_Preferences__c) {
            oAccount.All_Email_Preferences__c = false;
            update oAccount;
        }
        oAccount.All_Email_Preferences__c = true;
        update oAccount;
    }
    
  
    if (sLanguage.equals('en_GB') || sLanguage.equals('en_US')) { sLanguage = 'en'; }
   
    ApexPages.currentPage().getParameters().put('lang', sLanguage);
    ApexPages.currentPage().getParameters().put('Country', sCountryCode);
    
    if (subscriptionType == 'Frozen' || subscriptionType == 'Partial' || subscriptionType == 'Expired Marketing' || subscriptionType == 'Expired'|| subscriptionType == 'Blocked') {
        // Get login url, user language and territory.
        string sLoginPageURL = CommunityHelper.getMassiveURLs(user.Country,'LoginPageURLType');
        if (!String.isBlank(sLoginPageURL)) {
            sLoginPageURL = sLoginPageURL.replace('language', sLanguage).replace('territory', sCountryCode);
        }
        oPageReference = new PageReference(sLoginPageURL);
        oPageReference.setRedirect(true);
        return oPageReference; // Added line part of PD-8643
    } else {
        Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
        String docomuserType;
        String docomoPartnerPage;
        
        Boolean isDocomoSettings = false;
        Boolean isDfDUser = false;
        
        if (pac != null) {
            isDocomoSettings = true;
            docomuserType = pac.Partner_Type__c;
            docomoPartnerPage = (String.isNotBlank(pac.Page_Name__c) && pac.Page_Name__c.contains('.')) ? pac.Page_Name__c.substring(0, pac.Page_Name__c.indexOf('.')) : pac.Page_Name__c;
            
            isDfDUser = (user.Contact != null) && (user.Contact.Account != null) && String.isNotBlank(user.Contact.Account.Type) && String.isNotBlank(docomuserType) && user.Contact.Account.Type.equals(docomuserType) && String.isNotBlank(user.Contact.Account.Partner_ID__c);
            
            if (isDocomoSettings && isDfDUser) {
                oPageReference = new PageReference('/' + docomoPartnerPage);
                return oPageReference;
            }
        }
    }
    if (user.Account.Submitted_for_cancellation__c && !showAddPaymentFlag ) {
        isShowPaymentChange = user.Account.Submitted_for_cancellation__c;
        showCancelSubscription = false;
    } else {
        isShowPaymentChange = false;
    }
     //PD-11360: Code added by Dasetti
    //To get the header and find the referer in it
   Map<String, String> headers=ApexPages.currentPage().getHeaders();
    if(!headers.isEmpty() && headers.get('Referer')!= null){
    String referrer=headers.get('Referer');
    
    // custom setting 
    DAZNConfiguration__c daznConRefUrl = DAZNConfiguration__c.getValues('RefererAcceptURL');
   
    string refererAceptUrl = (daznConRefUrl != null) ? daznConRefUrl.Value__c : '';
    Integer lastSlashPos = (String.isNotBlank(referrer)) ? referrer.lastIndexOf('.com') : 0;
    
    //adding the three postion of string to fetch the execat value 
    lastSlashPos += 4;
    String resultStr='';   
    
    // fetch the domain from the referer url
    resultStr = (String.isNotBlank(referrer)) ? referrer.substring(0,lastSlashPos) : '';   
    // check the condition if it matches than navigate to pagenot found page
    if(string.isNotBlank(referrer) &&  string.isNotBlank(refererAceptUrl) && !refererAceptUrl.containsIgnoreCase(resultStr) ){
   
        pagereference pg = page.PageNotFound;                      
        pg.setRedirect(true);
        return pg;
    }
 }
    // PD-11360:logic ends       

    return errorPage;  
}


/*
Description: This method save customer name changes.
*/
public PageReference saveNameChanges() { // commented  the validations which are handled by UI - Ganesh
    try {
        clearErrorFields();
        if (String.isNotBlank(strFirstName) && String.isNotBlank(strLastName)) {
            oAccount.FirstName = strFirstName;
            oAccount.LastName = strLastName;
            
            // For PD-12084: - Cog 1.6.2
            String oldRetrieveEmail = oAccount.Retrieve_Email__c;
            if (String.isNotBlank(oldRetrieveEmail)) {
                List<String> oldRetrieveEmailParts = oldRetrieveEmail.split('-');
                if (oldRetrieveEmailParts.size() == 3) {
                    oAccount.Retrieve_Email__c = strFirstName + '-' + strLastName + '-' + oldRetrieveEmailParts[2];
                }
            }

            update oAccount;    
            
            // get latest information after update.
            if (user.AccountId != null ) { //added null check for userAccountid
                oAccount = CommunityHelper.getAccountInfo(user.AccountId);
                if (oAccount != null ) {
                    
                    if(sCountryCode == 'JP'){
                           sAccountName = oAccount.LastName + ' ' + oAccount.FirstName;                    
                    }
                    else{                    
                          sAccountName = oAccount.FirstName + ' ' + oAccount.LastName;
                    }                       
                } else {
                    return redirectToErrorPage('Not able to get the Account with provided Users accountid');
                }  
            }
            isNameEdit = false; 
            isNameEditForJP = false;
        }
    } catch(Exception ex) {
        if (!Test.isRunningTest()) {
            ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'saveNameChanges', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        }
        return redirectToErrorPage(ex.getMessage());
    }
    return errorPage; 
}


public void clearErrorFields() {
    sNameValidFirstNameErrMsg = sNameValidSurNameErrMsg  = '';
    sEmailProvideNewEmailErrorMsg = sEmailIncorrectPasswordErrorMsg = sEmailIncorrectPasswordErrorMsg ='';
    sPasswordProvideValidNewPasswordErrMsg = sPasswordIncorrectCurrentPasswordErrMsg = '';
}


 public void showSignOutBannersinledevice() {
    User_Devices__c singelUserDevice = [Select Id, Type__c, Status__c From User_Devices__c Where Id = :selectedDeviceID AND Status__c = 'Active'];
    bShowSignOutButton = true;
    sBanner = Label.LS_Warning_Popup_Msg;
    sBannerHeader = Label.LS_Signout_Singel_Device_Banner_Header;
    showbannerforSingledevice = true;
    showStartWatchingDAZN = false;
}


/*
Description: Wrapper class for user devices.
*/
public class wrapUserDevices{
    public User_Devices__c  ouserDev {get;set;}
    public string oRegDate {get;set;}
    public wrapUserDevices(User_Devices__c oUD, String str){
        ouserDev = oUD ;
        oRegDate = str;
    }   
}


/*
Description: This method update the customer email address on User and Account object.
*/
public PageReference saveEmailChanges() { 
    try {
        clearErrorFields();
        if (user != null) {
            if (user.Email == strNewEmail) {
                sEmailProvideNewEmailErrorMsg = Label.LS_Myaccount_ErrMsg_ProvideNewEmail;                          
            } else if ([Select count() From Account Where PersonEmail = :strNewEmail] > 0) {
                sEmailProvideNewEmailErrorMsg = Label.LS_MyAccount_ErrMsg_EmailIDExists; 
            } else if (string.isBlank(strPassword)) {
                sEmailIncorrectPasswordErrorMsg = Label.LS_MyAccount_ErrMsg_Provide_Password; 
            } else if ((!Test.isRunningTest()) && (Site.login(user.Username, strPassword, null) == null)) {
                sEmailIncorrectPasswordErrorMsg = Label.LS_MyAccount_ErrMsg_IncorrectPassword;   
            } else {  
                if (string.isNotBlank(strNewEmail)) {
                    sendEmailtoMISL(user, strNewEmail, sCountryCode);
                    oAccount.PersonEmail = strNewEmail;
                    oAccount.Secondary_Email__c = strNewEmail;
                    update oAccount;                        
                }
                //get latest information after update.
                /*if (user.AccountId != null) { 
                    oAccount = CommunityHelper.getAccountInfo(user.AccountId);
                }  @Megha : Cant find the use of this */
                
                isEmailEdit = false;
            }
        } else {
            return redirectToErrorPage('Not able to get the current user');         
        }
    } catch(Exception ex) {ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'saveEmailChanges', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        return redirectToErrorPage(ex.getMessage());    
    }
    return errorPage;
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



    /*
Description: This method is update customer password on user record using site class.
*/
public PageReference savePasswordChanges() { // Removed the validations which are handled by UI - Ganesh
    try {
        clearErrorFields();
        PageReference redirectUrl = Site.login(user.Username,strPassword,null);
        if (Test.isRunningTest()) {
            redirectUrl = new PageReference('CommunitiesLanding');
        }
        if (redirectUrl == null) {
            sPasswordIncorrectCurrentPasswordErrMsg = Label.LS_MyAccount_ErrMsg_IncorrectPassword;
        } else {
            if (String.isNotBlank(strNewPassword) && String.isNotBlank(strRepeatPassword) && String.isNotBlank(strPassword)) {
                Site.changePassword(strNewPassword,strRepeatPassword,strPassword);
            }
            
            // send notification to user on password update.
            if ((user.AccountId != null) && (user.AccountId != null) && (user.Email != null) && (user.LanguageLocaleKey != null) && (user.CountryCode != null)) {
                
                if(!Test.isRunningTest()){
                    CommunicatorIntegrationHelper.doCallOutPasswordUpdateFromFuture(user.AccountId, user.contactId, user.Email, user.LanguageLocaleKey, user.CountryCode);
                }
              }
            
            isPasswordEdit = false;
            strMessage = null;
        }
    } catch(Exception ex) {
        ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'savePasswordChanges', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); return redirectToErrorPage(ex.getMessage());   
    }
    return errorPage;
}

/*
Description: This implement all Cancel request from page.
*/
public void cancelEdit() {
    String field = apexpages.currentpage().getParameters().get('field');   
    strMessage = null;  
    if (field.equals('Email')) {
        isEmailEdit = false;
    } else if (field.equals('Name')) {
        isNameEdit = false;
        isNameEditForJP = false;
        strFirstName = user.FirstName;
        strLastName = user.LastName;
    } else if (field.equals('Password')) {
        isPasswordEdit = false;
    } else {
        errorPage = System.Page.InternalServerError;
        errorPage.getParameters().Put('Errormsg',' Not able to get the field parameter from URL');
    }
}

public void closeBanner() {
    showBanner = false;
    showbannerforSingledevice = false;
}

public void closeGiftCodeExpiryBanner() {
    showGiftCodeExpiryBanner = false;
}

public PageReference updatePaymentSettings() {
    showGiftCodeExpiryBanner = false;
    return Page.ChangePaymentMethod;
}

public void showSignOutBanner() {
    bShowSignOutButton = true;
    sBanner = Label.LS_MyAccount_ConfirmMsg_Signoutalldevices;
    sBannerHeader = Label.LS_Sign_out_Banner_Header;
    showBanner = true;
    showStartWatchingDAZN = false;
}


 /*
Description: This method implement all edit request from page.
*/
public void edit() {
    String field = apexpages.currentpage().getParameters().get('field'); 
    isNameEdit = false;
    isNameEditForJP = false;
    isEmailEdit = false;    
    isPasswordEdit = false;
    
    if (field.equals('Email')) {
        isEmailEdit = true;    
        strNewEmail = oAccount.PersonEmail;
    } else if (field.equals('Name')) {
        if(sCountryCode == 'JP'){
            isNameEditForJP = true;
        }
        else{
            isNameEdit = true;
        }            
        strFirstName = oAccount.FirstName;
        strLastName = oAccount.LastName;
    } else if (field.equals('Password')) {       
        isPasswordEdit = true;
    } else {
        errorPage = System.Page.InternalServerError;
        errorPage.getParameters().Put('Errormsg',' Not able to get the field parameter from URL'); 
    }
}


    
/*
Description: This method get the customer subscription information to display membership type and description on page.
*/

public PageReference getZuoraUserSubscription() { // This Method broken and kept inthis controller , there is no scope to keep this in zuora trans helper as all the parts just updating the values - Ganesh
    try {
         Account oAccount = new  Account ();
        if(user.AccountId != null){
          
        pauseSchBool = oAccount.PauseScheduled__c;

        }
        
        showAddGiftCodeFlag =GiftCodeHelper.checkRedeemLinkCriteria(oAccount ,user);   
             
        showAddPaymentFlag = GiftCodeHelper.checkPaymentMethod(oActSubscription , lstCustomerAccount[0]); 
        
        system.debug('oActSubscription !!!!!'+oActSubscription + oZPayment);

        if ( oActSubscription != null ) {                           
            if (oZPayment!= null && oActSubscription.SubscriptionAmount__c != null && lstCustomerAccount != null && lstCustomerAccount.size() > 0 && lstCustomerAccount[0].Zuora__Zuora_Id__c != null  ) {            

            lastPaymentInfo = CommunityHelper.getformattedAmount(CommunityHelper.getCurrencySymbol(lstCustomerAccount[0].Zuora__Currency__c),oActSubscription.SubscriptionAmount__c, oAccount.Notification_Country_Code__c) + ' ' + Label.LS_MyAccount_Label_On + ' ' + CommunityHelper.ConvertDateToString(oActSubscription.Zuora__ContractEffectiveDate__c,oAccount.Notification_Country_Code__c,'');
             system.debug('lastPaymentInfo !!!!!'+lastPaymentInfo);
            }
            
            else{                
                //add for PD-9013
            sSubscriptionTypeDescription = Label.LS_ErrorPage_Label_Internal_Server_Error;
            description = Label.LS_Change_payment_ErrMsg.replace('[Scountry]',sCountryCode).replace('[Slang]',sLanguage );   //PD-11051                              

            }
            
              system.debug('subscriptionType !!!!!'+subscriptionType + pauseSchBool);
              
           
            if(oActSubscription != null  &&  pauseSchBool == false && subscriptionType != 'Paused'){
                
         
                if (subscriptionType !=null && subscriptionType.Equals('Free Trial')) {
                    freeTrial();
                } else if (subscriptionType != null && subscriptionType.Equals('Active Paid')) {
                    activePaid();
                } else if (subscriptionType != null && subscriptionType.Equals('Active Grace')) {
                    activeGrace();
                }
            } else if (oActSubscription != null  && pauseSchBool == true && subscriptionType != 'Paused') {
               
                 pauseDescription();
                 
            } else if (oActSubscription != null  && subscriptionType == 'Paused') {
                 
                 system.debug('pauseDoneDescription !!!!!');
                 
                pauseDoneDescription();
            } else {                
                //add for PD-9013
                showOnlyError = true;
                sSubscriptionTypeDescription = Label.LS_ErrorPage_Label_Internal_Server_Error;
                description = Label.LS_Display_Subscription_ErrMsg;
                if (!string.isEmpty(description)) {
                    GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionError);
                }
            }
        } else {                
            //add for PD-9013
            showOnlyError = true;
            sSubscriptionTypeDescription = Label.LS_ErrorPage_Label_Internal_Server_Error;
            description = Label.LS_Display_Subscription_ErrMsg;
            if(!String.isEmpty(description)) {
                GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionError);
            }
        }
    } catch(Exception ex) { GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionError); }
    return errorPage;
}

 public void freeTrial(){
    //Nayan : PD-11544
    
    SetSubscriptionHeaderAndSubHeader(oActSubscription,lstCustomerAccount[0].Zuora__Currency__c);
    if(oActSubscription!=null && oActSubscription.Zuora__Status__c=='Active'){
        showCancelSubscription=true;
    } else if(oActSubscription!=null && oActSubscription.Zuora__Status__c=='Cancelled'){
        if(oAccount != null && oAccount.Notification_Country_Code__c != null && oAccount.Notification_Language_Code__c != null){
         strReactivationMsg=CommunityHelper.getSubscriptionDescription(Label.LS_MyAccount_InfoMsg_Reactivation,oActSubscription);

         showResubscribe=true;
        }
    }
    if(sBannerName.equals('reactivation')){
        sBannerHeader=Label.LS_Reactivation_Banner_Header;
        if(oAccount.Notification_Language_Code__c == 'fr_CA' ){
            sBanner=CommunityHelper.getSubscriptionDescription(Label.LS_FreeTrial_Reactivation_Banner, oActSubscription);
        }
        else{
            sBanner=CommunityHelper.getSubscriptionDescription(Label.LS_FreeTrial_Reactivation_Banner, oActSubscription);
        }
    }else if(sBannerName.equals('cancellation')){
        Date dtNextChargeDate;
        sBannerHeader=Label.LS_MyAccount_Title_BannerMsg;
        
        //added as part of PD-13271,PD-14250
        dtNextChargeDate = (test.isRunningTest()) ? Date.today() : oActSubscription.Zuora__NextChargeDate__c ;
        string sDays;
        if (dtNextChargeDate != null) {
            sDays=string.ValueOf(system.now().Date().daysBetween(dtNextChargeDate));
            sBanner = Label.LS_MyAccount_Label_FreeTrial_Member_Banner.replace('[DAYS]', sDays);
            if (oAccount != null && oAccount.Notification_Country_Code__c != null) {
                sBanner = Label.LS_MyAccount_Label_FreeTrial_Member_Banner.replace('[Zuora__SubscriptionEndDate__c]', CommunityHelper.ConvertDateToString(dtNextChargeDate, oAccount.Notification_Country_Code__c,''));
            }
        } else {
            sBanner = Label.LS_Global_ErrMsg_NoNextChargeDateFound;  //Added as part of change request for PD:15411
        }
    }
}

public void activePaid(){
    //Nayan : PD-11544
    
    SetSubscriptionHeaderAndSubHeader(oActSubscription,lstCustomerAccount[0].Zuora__Currency__c);    
    if(oActSubscription!=null && oActSubscription.Zuora__Status__c=='Active') {   
        showCancelSubscription=true;
    } else if(oActSubscription!=null && oActSubscription.Zuora__Status__c=='Cancelled'){
        if(oAccount != null && oAccount.Notification_Country_Code__c != null && oAccount.Notification_Language_Code__c != null){
        strReactivationMsg= CommunityHelper.getSubscriptionDescription(Label.LS_MyAccount_InfoMsg_Reactivation,oActSubscription);
        }
        showResubscribe=true;
    }
    if(sBannerName.equals('reactivation')){
        sBannerHeader=Label.LS_Reactivation_Banner_Header;
        
        sBanner=CommunityHelper.getSubscriptionDescription(Label.LS_Member_Reactivation_Banner,oActSubscription);
        
    }else if(sBannerName.equals('cancellation')){
        sBannerHeader=Label.LS_MyAccount_Title_BannerMsg;
        
        
        sBanner = (Test.isRunningTest()) ? '' :CommunityHelper.getSubscriptionDescription(Label.LS_MyAccount_Label_Paid_Member_Banner, oActSubscription);
        
    }
}

public void activeGrace() {
    //Nayan : PD-11544
    SetSubscriptionHeaderAndSubHeader(oActSubscription,lstCustomerAccount[0].Zuora__Currency__c);    
    if (oActSubscription!=null && oActSubscription.Zuora__Status__c=='Active') {
        showCancelSubscription = true;                        
    } else if(oActSubscription!=null && oActSubscription.Zuora__Status__c=='Cancelled') {
        showResubscribe = true;        
    }
}

/**
*  @author : Nayan Behera (Cognizant)
*  @date : 08-May-2017 
*  @description : This method created as a part of PD-11544 and it will be used to set the subscription header and sub header depending on different scenarios
*/
public void SetSubscriptionHeaderAndSubHeader(Zuora__Subscription__c oZSubscription,string sCurrency) {
    //Fetch the custom setting record
    list<Zuora__Subscription__c> subscriptionList = new list<Zuora__Subscription__c> ();
    String uniqueKeyStr = '';
    String campaignIdStr = '';
   
   if(oZSubscription <> null) {
        //Added 'SubscriptionAmount__c' in SOQL as part PD-14237
        subscriptionList.add (oZSubscription) ; 
    }
    
    if(subscriptionList != null && !subscriptionList.isEmpty()){
        list<Account> accList = [Select Id,Account_Status__c From Account where Id =: subscriptionList[0].Zuora__Account__c];
         if(subscriptionList[0].Giftcode__c <> null && subscriptionList[0].Giftcode__c <> '')
            campaignIdStr = 'NOT blank';
        else
            campaignIdStr = 'IS blank';
        if(test.isRunningTest())
            uniqueKeyStr = 'Active PaidIS blankActiveEVERGREEN';
        else
            uniqueKeyStr = oAccount.Account_Status__c + campaignIdStr + subscriptionList[0].Zuora__Status__c + subscriptionList[0].Zuora__TermSettingType__c;
        for(GiftCode_settings__c giftCode : GiftCode_settings__c.getall().values()){
            if(giftCode.Page_Name__c == 'MyAccount' && giftCode.Unique_Identifier__c == uniqueKeyStr){  
                //Update the Subscription header
                string headerLabelStr = giftCode.Heading_Label__c;
                Component.Apex.OutputText output = new Component.Apex.OutputText();
                output.expressions.value = '{!$Label.' + headerLabelStr + '}';                              
                sSubscriptionTypeDescription = getSFDCSubscriptionDescription(uniqueKeyStr,string.valueOf(output.value),subscriptionList[0],oAccount,lstCustomerAccount[0].Zuora__Currency__c);
                //Update the Subscription Sub header
                string subHeaderLabelStr = giftCode.Sub_Heading_Label__c;
                output = new Component.Apex.OutputText();
                output.expressions.value = '{!$Label.' + subHeaderLabelStr + '}';                           
                description = getSFDCSubscriptionDescription(uniqueKeyStr,string.valueOf(output.value),subscriptionList[0],oAccount,lstCustomerAccount[0].Zuora__Currency__c);
                break;
            }   
        }
    }
}

/**
*  @author : Nayan Behera
*  @date : 11-May-2017 
*  @description : This method created as a part of PD-11544 and it will be used to get the subscription details from variable custom label
*/
public static String getSFDCSubscriptionDescription(String scenario,String Message, Zuora__Subscription__c oZSubscription,Account acc,string sCurrency){
    String strMessage=Message;
    Account accObj = [Select id,Notification_Country_Code__c,Notification_Language_Code__c from account where id =: acc.Id];
    List<String> lstField=new List<String>();
    Zuora__SubscriptionProductCharge__c ratePlanCharge;
    while(strMessage.contains('[') && strMessage.contains(']')){
        String strField=strMessage.substringBetween('[',']');
        lstField.add(strField);
        strMessage=strMessage.remove('['+strField+']');
    }
    if(lstField.size()>0){
        if(oZSubscription != null){
            //get the Charge line items which are of the type Flat Fee
            ratePlanChargeChargedThroughDate = oZSubscription.Zuora__NextChargeDate__c;
            Date nextChargeDate = oZSubscription.Zuora__NextChargeDate__c;
            for(string strField : lstField){
                //Update Next Payment Date
                if(strField.equals('Zuora__NextChargeDate__c')){ 
                    if ((scenario <> 'Active PaidNOT blankActiveEVERGREEN' && scenario <> 'Active PaidNOT blankActiveTERMED')) {
                        //Else IF block Added as part of change request for PD:15411
                        if (ratePlanChargeChargedThroughDate != null) {
                            Message = Message.replace('['+strField+']', CommunityHelper.ConvertDateToString(ratePlanChargeChargedThroughDate,accObj.Notification_Country_Code__c, ''));
                        } else {
                            Message = Label.LS_Global_ErrMsg_NoNextChargeDateFound;
                        }
                    } else if (nextChargeDate <> null || oZSubscription.Gift_Code_End_Date__c <> null) {
                        if (oZSubscription.Gift_Code_End_Date__c > System.today()) {
                            Message = Message.replace('['+strField+']', CommunityHelper.ConvertDateToString(oZSubscription.Gift_Code_End_Date__c, accObj.Notification_Country_Code__c, ''));
                        } else {
                            Message = Message.replace('['+strField+']', CommunityHelper.ConvertDateToString(nextChargeDate, accObj.Notification_Country_Code__c, ''));
                        }
                    } else {
                        Message = Message.replace('['+strField+']', '--');
                    }
                }
                //Update Price 
                if(strField.equals('Zuora__Price__c')){
                    String sPrice = '';
                    // Added as part PD-14237
                    if(oZSubscription.SubscriptionAmount__c != null){
                        //if condition was replaced in terms of PD-14237
                        sPrice = CommunityHelper.getformattedAmount(CommunityHelper.getCurrencySymbol(sCurrency), oZSubscription.SubscriptionAmount__c, accObj.Notification_Country_Code__c);
                    }
                    if(sPrice <> '')
                        Message=Message.replace('['+strField+']',sPrice );
                    else
                        Message = Message.replace('['+strField+']', '--');
                }
                //Update Free Trail End Date
                if(strField.equals('Free_Trial_End_Date__c')){
                    if(oZSubscription.Free_Trial_End_Date__c <> null)
                        Message = Message.replace('['+strField+']', CommunityHelper.ConvertDateToString(oZSubscription.Free_Trial_End_Date__c, accObj.Notification_Country_Code__c, ''));
                    else 
                        Message = Message.replace('['+strField+']', '--');
                }
                //Update Gift Code End Date
                if(strField.equals('Gift_Code_End_Date__c')){
                    if(oZSubscription.Gift_Code_End_Date__c <> null)
                        Message = Message.replace('['+strField+']', CommunityHelper.ConvertDateToString(oZSubscription.Gift_Code_End_Date__c,accObj.Notification_Country_Code__c,''));                          
                    else 
                        Message = Message.replace('['+strField+']', '--');
                }
                //Update Subscription End Date
                if(strField.equals('Zuora__SubscriptionEndDate__c')){
                    if(oZSubscription.Zuora__SubscriptionEndDate__c <> null )
                        Message = Message.replace('['+strField+']', CommunityHelper.ConvertDateToString(oZSubscription.Zuora__SubscriptionEndDate__c,accObj.Notification_Country_Code__c,'NA'));                                                         
                    else
                        Message = Message.replace('['+strField+']', '--');
                } 
            }
        }
    } 
    return Message;
}


/**
*  @author Megha Jain
*  @date March 21, 2017
*  @description : This Method is called when  user click on Cancle Subscription
@Parameter : 
*/
@TestVisible
public PageReference naviagateToWhyPage() {
    
    PageReference ref;
    sCountryCode = user.CountryCode;
    system.debug('oAccount &&&&&'+oAccount  +user +sCountryCode); 
     
    Map<String, CountryListForPauseFlow__c> enablePauseMap= CountryListForPauseFlow__c.getAll();        
    if (oAccount != null ) {
          system.debug('sCountryCode &&&&&'+sCountryCode); 
          
        if (enablePauseMap.containsKey(sCountryCode) ) {
            isPauseEnable = CountryListForPauseFlow__c.getValues(sCountryCode).IsPauseEnable__c;
            
            system.debug('isPauseEnable &&&&&'+isPauseEnable); 
            
            if (isPauseEnable && oAccount.Account_Status__c == 'Active Paid'&& !oAccount.PauseScheduled__c && !oAccount.Cancelled_Account__c) {
                ref = new PageReference('/pause-or-cancel');
                ref.setRedirect(true); 
            } else {
                ref = new PageReference('/cancel');
                ref.setRedirect(true); 
            } 
        } 
    }
    system.debug('ref &&&&&'+ref); 
    return ref;  
}

 
/**
*  @author Megha Jain
*  @date March 21, 2017
*  @description : This Method is called when  user click on Amend restart Date 
@Parameter : 
*/
@TestVisible 
public PageReference naviagateToSetPause() {
    PageReference ref ;
    ref = new PageReference('/SetPause?pauseAction=amend');
    return ref;
}


   /**
*  @author Megha Jain
*  @date March 21, 2017
*  @description : This method is used to calculate the next payment amount for Paused user
@Parameter : Return String 
*/   
@testVisible
Public String calcNextPaymentForPause(){
        
    String sCurrencyISOCode;
    String nextpay;
    if(oAccount !=null ){
       
        if(lstCustomerAccount !=null && !lstCustomerAccount.isEmpty()){
            sCurrencyISOCode = lstCustomerAccount[0].Zuora__Currency__c ;              
            nextpay = CommunityHelper.getformattedAmount(CommunityHelper.getCurrencySymbol(sCurrencyISOCode ),lstCustomerAccount[0].Zuora__MRR__c,null) + ' ' + Label.LS_MyAccount_Label_On + ' ' ; 
        }
    }
    return nextPay ;
    
}



  /**
*  @author Megha Jain
*  @date March 21, 2017
*  @description : This method is used to check if Pause is scheduled or not , and render buttons on page accordingly 
@Parameter : 
*/     
@TestVisible    
public void pauseDescription(){
    
    pauseSchedule = true;
    
    
    if(oAccount !=null ){
       
        if (oAccount.PauseScheduled__c == true && oAccount.Pause_From__c != null && oAccount.Pause_Until__c != null && oAccount.Account_Status__c!='Paused' && oAccount.Notification_Language_Code__c!=null){                
            pauseStartDate = CommunityHelper.ConvertDateToString(oAccount.Pause_From__c ,sLanguage );
            pauseStopDate = CommunityHelper.ConvertDateToString(oAccount.Pause_Until__c, sLanguage );                
            if(oAccount.Account_Status__c =='Free Trial'){                    
                sSubscriptionTypeDescription=CommunityHelper.getSubscriptionDescription(Label.LS_Label_FreeSubscriptionTypeDescription,oActSubscription);    
            }else if (oAccount.Account_Status__c=='Active Paid'){
                
                sSubscriptionTypeDescription=CommunityHelper.getSubscriptionDescription(Label.LS_Label_MemberSubscriptionTypeDescription,oActSubscription);
            }
            
            if (pauseStartDate !=null && pauseStopDate !=null ){ 
                description = Label.LS_MyAccount_subscription_pause_msg1.replace('{0}', pauseStartDate ).replace('{1}', pauseStopDate ).replace('{2}', pauseStopDate );
                if(oAccount.Notification_Country_Code__c != null && oAccount.Notification_Country_Code__c != '')
                    nextPayValForPause = calcNextPaymentForPause()+''+CommunityHelper.ConvertDateToString(oAccount.Pause_Until__c,oAccount.Notification_Country_Code__c,'');
            }
            pauseSchedule = oAccount.PauseScheduled__c;
            showCancelSubscription= false;
            pauseDone =false;
            
        }
    }
}


 /**
*  @author Megha Jain
*  @date March 21, 2017
*  @description : This method is used to check if Pause is done or not , and render buttons on page accordingly 
@Parameter : 
*/      
@TestVisible
public void pauseDoneDescription(){
       
       system.debug('oAccount %%%%%'+oAccount +pauseDone + showCancelSubscription + pauseSchedule);
            
       if(oAccount !=null ){

        if( oAccount.Pause_From__c != null && oAccount.Pause_Until__c != null && oAccount.Account_Status__c=='Paused' && oAccount.Notification_Language_Code__c !=null){
            pauseSchedule = true; 
            pauseDone =true;
            showCancelSubscription= false;
            
            system.debug('pauseSchedule !!!!!'+pauseDone + '**'+ sLanguage + '**'+ oAccount.Pause_From__c + oAccount.Pause_Until__c );
            
            pauseStartDate = CommunityHelper.ConvertDateToString(oAccount.Pause_From__c ,sLanguage );
            pauseStopDate = CommunityHelper.ConvertDateToString(oAccount.Pause_Until__c,sLanguage );
            
            system.debug('pauseStartDate !!!!!'+pauseStartDate + pauseStopDate + pauseSchedule);

            
            if (pauseStartDate !=null && pauseStopDate !=null ){ 
                description = Label.LS_MyAccount_subscription_pause_msg2.replace('{0}', pauseStopDate).replace('{1}', pauseStopDate );
                if(oAccount.Notification_Country_Code__c != null && oAccount.Notification_Country_Code__c != '')
                    nextPayValForPause = calcNextPaymentForPause()+''+CommunityHelper.ConvertDateToString(oAccount.Pause_Until__c,oAccount.Notification_Country_Code__c,'');                   
            }
            sSubscriptionTypeDescription=CommunityHelper.getSubscriptionDescription(Label.LS_Label_MemberSubscriptionTypeDescription,oActSubscription);
            system.debug('desc!!!!!'+description + nextPayValForPause + sSubscriptionTypeDescription);

        }
    }
}


 public PageReference keepMyDaznActive() {
    PageReference ref;
    sCountryCode = user.CountryCode;
    Map<String, CountryListForPauseFlow__c> enablePauseMap = CountryListForPauseFlow__c.getAll();
    if (oAccount != null && enablePauseMap.containsKey(sCountryCode)) {
        isPauseEnable = CountryListForPauseFlow__c.getValues(sCountryCode).IsPauseEnable__c ;
        
        if (oActSubscription!= null  && isPauseEnable && oAccount.Account_Status__c == 'Active Paid' && oAccount.PauseScheduled__c && !oAccount.Cancelled_Account__c) {
            //ref = new PageReference('/keepintouch?pauseAction=cancel');
            Map<String, String> pauseCalloutResult = PauseCalloutHelper.cancelPauseCallout(oActSubscription.Name, String.valueOf(oAccount.Previous_BCD__c));
            Boolean pauseResultIsSuccess = Boolean.valueOf(pauseCalloutResult.get('success'));
            String pauseResultMessage = pauseCalloutResult.get('message');
            if (pauseResultIsSuccess) {
                ref = PauseCalloutHelper.pauseFlowProcessSuccess(
                    'cancel',
                    user,
                    oAccount,
                    null,
                    null,
                    pauseResultMessage,
                    oAccount.Previous_BCD__c,
                    oAccount.Submitted_for_cancellation__c
                );
            } else {
                ref = PauseCalloutHelper.pauseFlowProcessFailure(
                    'cancel',
                     user,
                     oAccount,
                     pauseResultMessage
                );
            }
            ref.setRedirect(true); 
        }
    }
    return ref;
}


public PageReference restartNow() {
    PageReference ref;
    String restartUrl = (DAZNConfiguration__c.getValues('AmendPauseURL') != null) ? DAZNConfiguration__c.getValues('AmendPauseURL').Value__c : null;
    if (String.isNotBlank(restartUrl)) {
        ref = new PageReference(restartUrl);
        ref.setRedirect(true); 
    }
    return ref;
}


/**
 * @Author Cognizant Technology Solutuions
 * @Date 10-Oct-2017
 * @Description : This method is used to Navigate to Redeem URL page
 * @Parameter1 :
*/

 public PageReference redeemGiftCode() {
    PageReference ref = GiftCodeHelper.redeemGiftCode();
    return ref;
} 

// User Devices Section 


    /*
Description: This method get all active and registered devices for a customer.
*/
public void showAllUserDevices() {
    bshowAllUserDevices = true;
    getUserDevices();
}

/*
Description: This method get all active and registered devices for a customer
*/
private PageReference getUserDevices(){
    try {
        lstUserDevices = new List<User_Devices__c>();
        Integer recordCount = 3;     
        String strByLocale = '';
        
         system.debug('user.AccountId $$$$$$'+user.AccountId );
        
        Account oAccount = new Account();
        List<User_Devices__c> lstAllUserDevices = [Select Name, Account__c, Date_Of_Registration__c, Type__c, Status__c
          
                                                   From User_Devices__c Where Account__c =: user.AccountId AND Status__c = 'Active' LIMIT 100];
        
        system.debug('stAllUserDevices $$$$$$'+ lstAllUserDevices );  
        
        system.debug('bshowAllUserDevices $$$$$$'+ bshowAllUserDevices );  
                                                   
        if (bshowAllUserDevices) {
            recordCount=lstAllUserDevices.size();
        }
       if(user.AccountId != null){
             oAccount = [Select Account_Status__c,Notification_Country_Code__c,Notification_Language_Code__c From Account Where Id = :user.AccountId][0];              
        }
        wrapUDList = new List <wrapUserDevices>();
        for (Integer counter = 0; counter < recordCount && counter < lstAllUserDevices.size(); counter++) {
           if(oAccount.Notification_Language_Code__c == 'fr_CA' || oAccount.Notification_Country_Code__c == 'CA'){
               strByLocale = CommunityHelper.ConvertDateToString(lstAllUserDevices.get(counter).Date_Of_Registration__c);
                }
            else{
                 strByLocale = CommunityHelper.getDateByLocale(lstAllUserDevices.get(counter).Date_Of_Registration__c);
            }                
            if (string.isNotBlank(strByLocale)) {
                wrapUDList.add(new wrapUserDevices(lstAllUserDevices.get(counter), strByLocale));
            }
            lstUserDevices.add(lstAllUserDevices.get(counter));
        } 
        if (lstAllUserDevices.size() > recordCount) {
            showAllUserDevicesLabel = Label.LS_MyAccount_Button_ViewMore + ' (' + String.valueOf(lstAllUserDevices.size() - recordCount) + ')' + Label.LS_Myaccount_Dropdown;
            bshowAllUserDevicesButton = true;    
        } else {
            showAllUserDevicesLabel = Label.LS_MyAccount_Button_ViewMore;
            bshowAllUserDevicesButton = false;    
        }
    } catch(Exception ex) {
        ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'getUserDevices', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());return redirectToErrorPage( ex.getMessage());
    }
    return errorPage;
  
}


  /*
Description: This method implement all redirection from page.
*/
public PageReference navigationHandler() {
    return new PageReference('/'+ apexpages.currentpage().getParameters().get('PageName'));
}

/*
Description: This method is to sign out all logged in devices.
*/
public pageReference signoutAllDevices(){
    try {
        sCountryCode = user.CountryCode;
        if (ApexPages.currentPage().getParameters().get('cancelButtonclick') == 'true') {
            if (user.AccountId != null && user.ContactId != null ) {
                CommunityHelper.createSignOffTask(user.ContactId, user.AccountId, System.Label.LS_MyAccount_SignOut_TaskSubject, System.Label.LS_MyAccount_SignOut_TaskDesc);
            }
        } else {
            CommunityHelper.signOutOfAllDevices(user);
        }
        string sLoginPageURL = CommunityHelper.getMassiveURLs(user.Country, 'LoginPageURLType');
        if (sLanguage.equals('en_GB') || sLanguage.equals('en_US')) { sLanguage = 'en'; }

        if (String.isNotBlank(sLoginPageURL)) {
            if (sLoginPageURL.contains('language')) {
                sLoginPageURL = sLoginPageURL.replace('language', sLanguage);
            }
            if (sLoginPageURL.contains('territory')) {
                sLoginPageURL = sLoginPageURL.replace('territory', sCountryCode);
            }
            PageReference oPageReference = new PageReference(sLoginPageURL);            
            return oPageReference;
        } else {
            return redirectToErrorPage('LoginPageURL is not coming');           
        }
    } catch(Exception ex) {
        ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'signoutAllDevices', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        errorPage = System.Page.InternalServerError;errorPage.getParameters().Put('errorMsg',ex.getMessage()); throw ex;           
    }
    return errorPage;
}


  /*
Description: This method is to Deregister the singel device.
*/
// Added Code part of the PD-9458
// removed IP logic and Sessions and devices deleted basics on selectedDeviceID as per the PD-11487. 
public PageReference deregisterSingelUserDevice() {
    try {
        User_Devices__c singelUserDevice = [Select Id, Account__c, Status__c, Type__c, IP_address__c From User_Devices__c Where Id = :selectedDeviceID];
        List<Id> objId = new List<Id>();
        List<AuthSession> lstActiveUserSessionsDesktop = new List<AuthSession>(); 
        lstActiveUserSessionsDesktop = [Select Id From AuthSession Where UsersId = :user.Id];
        if (lstActiveUserSessionsDesktop != null && lstActiveUserSessionsDesktop.size() > 0) {
            delete lstActiveUserSessionsDesktop;               
        }             
        //delete Singel device
        if (singelUserDevice != null) {
            objId.add(singelUserDevice.Id);
        }
        if (objId != null && objId.size() > 0) {
            deleteUserDevice(objId);
        }  
    } catch(Exception ex) {
        ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'deregisterSingelUserDevice', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        errorPage = System.Page.InternalServerError; errorPage.getParameters().Put('errorMsg',ex.getMessage());
    }
    if (errorPage != null) {
        return errorPage;
    } else {
        return new PageReference(DAZNConfiguration__c.getValues('MyAccountURL').Value__c);
    }
}
// End Code part of the PD-9458

/*
Description: This method is used to get the customer email preference from account.
*/
public PageReference getEmailPreferences() {
    try {
       
        if (oAccount != null ) {
            bEmailPreference = oAccount.All_Email_Preferences__c;
        } else {
            bEmailPreference = false;
        } 
    } catch (Exception ex) {
        ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'getEmailPreferences', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        return redirectToErrorPage(ex.getMessage());
        //some thing need to added data layer
    }
    return errorPage;
}

/*
Description: This method used to set the customer email preference on account.
*/
public PageReference setEmailPreferences() {
    try {
        if (oAccount != null ) {
          
            oAccount.All_Email_Preferences__c = bEmailPreference;
            if (!bEmailPreference) {
                oAccount.Is_Double_OptIn__c = bEmailPreference;
            }
            update oAccount;
        }
    } catch(Exception ex) {
        ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'setEmailPreferences', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); return redirectToErrorPage(ex.getMessage());
        //some thing need to added data layer
    }
    return errorPage;
}

/*
Description: This method is used to get the customer email preference from account.
*/
public PageReference getNFLMarketingPreferences() {
    try {
      
        if (oAccount != null) {
            bNFLMarketing = oAccount.NFL_marketing__c;
        } else{
            bNFLMarketing = false;
        } 
    } catch (Exception ex) {
        ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'getNFLEmailPreferences', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());return redirectToErrorPage(ex.getMessage());
        //some thing need to added data layer
    }
    return errorPage;
}

/*
Description: This method used to set the NFL Marketing email on account.
*/
public PageReference setNFLMarketingPreferences() {
    try {
       
        if (oAccount != null ) {
           
            oAccount.NFL_marketing__c = bNFLMarketing; // Added as a Part of PD-15477 , To track NFL marketing Opt in/out on Account detail page
            oAccount.NFL_Opt_In_Change_Date__c = System.today() ;
            update oAccount;
        }
    } catch(Exception ex) {
        ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'setNFLMarketingPreferences', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());return redirectToErrorPage(ex.getMessage());
        //some thing need to added data layer
    }
    return errorPage;
}


/*
Description: Method to navigate on DAZN home page.
*/
public PageReference DAZNHomePageNavigationHandler(){
    string sHomePageURL = CommunityHelper.getMassiveURLs(user.Country,'HomePageURLType');
    if(!String.isBlank(sHomePageURL)){
        PageReference reference=new PageReference(sHomePageURL);
        reference.setRedirect(true);
        return reference;
    }
    else{
        return redirectToErrorPage('Not able to get the Homepage URL]');
    }
    
}

@future
public Static void deleteUserDevice(List<Id> objUserId){
    try {
        Database.delete(objUserId);
    } catch(Exception ex) {
        ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'MyAccountController', 'deleteUserDevice', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        errorPage = System.Page.InternalServerError; errorPage.getParameters().Put('errorMsg',ex.getMessage());
    }
} 

public static PageReference signOutOfSingleDevicesUpdated(List<User_Devices__c> listUserDevices, List<User> listUserObj, string strDeviceId){
    try{
        List<Id> objId = new List<Id>();
        for(User_Devices__c userDevicesIds :listUserDevices){
            objId.add(userDevicesIds.id);
        }
        if(objId != null)
            deleteUserDevice(objId);
        List<AuthSession> lstActiveUserSessionsDesktop = [Select ID From AuthSession Where UsersId =: listUserObj[0].Id];
        //if(strDeviceId == null || strDeviceId ==''){
        //delete lstActiveUserSessionsDesktop; 
        //} 
        //else{
        //if(listUserDevices[0].Type__c == 'Desktop'){
        delete lstActiveUserSessionsDesktop;  
        //}
        //}     
    }catch(Exception ex){
        ExceptionLoggerHelper.createExceptionLog(listUserObj[0].Id, 'MyAccountController', 'signOutOfSingleDevicesUpdated', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        errorPage=System.Page.InternalServerError;errorPage.getParameters().Put('errorMsg',ex.getMessage());
    }
    return errorPage;       
}

//  Added Code part of the PD-9458
public static PageReference signOutOfSingleDevicesUpdated(List<User_Devices__c> listUserDevices, List<User> listUserObj){
    try{
        List<Id> objId = new List<Id>();
        Boolean isSucess = False;
        List<AuthSession> lstActiveUserSessionsDesktop =  new List<AuthSession>(); 
        List<LoginHistory> lstLoginHistory = [SELECT UserId,LoginTime,SourceIp from LoginHistory where UserId =:listUserObj[0].id AND Logintype = 'Chatter Communities External User'];
        if(lstLoginHistory!= null && lstLoginHistory.size()>0 && listUserDevices[0].IP_address__c != null ){
            isSucess = CommunityHelper.IpaddressCompare(lstLoginHistory[lstLoginHistory.size()-1].SourceIp,listUserDevices[0].IP_address__c);
        }
        if(listUserDevices != null) {
            objId.add(listUserDevices[0].Id);
        }
        if(isSucess){
            lstActiveUserSessionsDesktop = [Select ID From AuthSession Where UsersId =: listUserObj[0].Id and SourceIp =: lstLoginHistory[lstLoginHistory.size()-1].SourceIp ];
        } 
        if( lstActiveUserSessionsDesktop!=null && lstActiveUserSessionsDesktop.size()>0){
            delete lstActiveUserSessionsDesktop;
        }
        if(objId!=null && objId.size()>0){
            deleteUserDevice(objId);
        }
    }catch(Exception ex){
        ExceptionLoggerHelper.createExceptionLog(listUserObj[0].Id, 'MyAccountController', 'signOutOfSingleDevicesUpdated', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        errorPage=System.Page.InternalServerError;errorPage.getParameters().Put('errorMsg',ex.getMessage());
    }
    return errorPage;       
}// End of PD-9458

/*
Description: Method to navigate on forgot password page.
*/
public PageReference forgotPasswordNavigationHandler(){
    urlForgotPassword = CommunityHelper.getMassiveURLs(user.Country,'ForgotPasswordLinkType');
    if(!string.isBlank(urlForgotPassword)){
        PageReference reference=new PageReference(urlForgotPassword);
        reference.setRedirect(true);
        return reference;       
    }
    else{       
        return redirectToErrorPage('Massive Page URL is not coming');       
    }
}

/*
Description: Method to generate forgot password massive page url.
*/
private string getForgotpasswordURL(){
    string sForgotpasswordURL = CommunityHelper.getMassiveURLs(user.Country,'ForgotPasswordLinkType');
    if(!string.isBlank(sForgotpasswordURL)){
        return sForgotpasswordURL ;
    }
    return sForgotpasswordURL ;
}



/*Added as a part of PD-10041
added new language for en_US and Fr for PD-11615*/
public List<CommunityHelper.UserLanguage> getLanguages() {
    // Store all required languages list.
    List<CommunityHelper.UserLanguage> languages = new List<CommunityHelper.UserLanguage>();
    DAZNLanguageSetting__c oDAZNLanguageSetting = DAZNLanguageSetting__c.getValues(user.Country);
    if (oDAZNLanguageSetting != null) {
        List<String> lstLanguages = oDAZNLanguageSetting.LanguageToDisplay__c.toLowerCase().split(',');
        for (String sLanguage : lstLanguages) {
            if (sLanguage.toLowerCase().equals('ja')) {
                languages.add(new CommunityHelper.UserLanguage(sLanguage, Label.LS_MyAccount_Language_Japanese_Label));
            } else if (sLanguage.toLowerCase().equals('en_gb') || sLanguage.toLowerCase().equals('en_us')) {
                languages.add(new CommunityHelper.UserLanguage(sLanguage, Label.LS_MyAccount_Language_English_Label));  
            } else if(sLanguage.toLowerCase().equals('fr_ca') || sLanguage.toLowerCase().equals('fr')){
                languages.add(new CommunityHelper.UserLanguage(sLanguage, Label.LS_MyAccount_Language_French_Label));
            }else if (sLanguage.toLowerCase().equals('de')) {
                languages.add(new CommunityHelper.UserLanguage(sLanguage, Label.LS_Myaccount_Language_UnitedKingdom_DE_Label));
            }
        }
    }
    return languages;
}
/*End of PD-10041*/

/*
Description: Method to update user selected language in system.
*/
public PageReference updateUserLanguage(){   //PD-11813 update account first Next User       
    try{
        sCountryCode = user.CountryCode;
        if(strSelectedLanguage !=null && strSelectedLanguage.split('_').size() > 1){
            strSelectedLanguage = strSelectedLanguage.split('_')[0] +'_' + strSelectedLanguage.split('_')[1].toUpperCase();
        }
        if(strSelectedLanguage !=null ){
            String currentAccountId = String.isNotBlank(user.Account.DAZN_Id__c) ? user.Account.DAZN_Id__c : user.AccountId;
            Map<String, Object> payload = new Map<String, Object>{
                'AccountID' => currentAccountId,
                'NewLanguageCode' => strSelectedLanguage,
                'IsCrmRequest' => true
                };
            Map<String,String> calloutResult = MISLCalloutHelper.updateUserDetails(payload, user.AccountId, sCountryCode, true);
            
            if (isCheckResultCallout(calloutResult)) {
                    oAccount.Notification_Language_Code__c = strSelectedLanguage;
                    update oAccount;
                    user.LanguageLocaleKey = strSelectedLanguage;
                    
                    /*Added as a part of PD-11615*/
                    if(oAccount.Notification_Country_Code__c == 'CA'){
                        if(strSelectedLanguage == 'fr'){ user.LocaleSidKey = 'fr' ; }
                        else if(strSelectedLanguage == 'fr_CA'){ user.LocaleSidKey = 'fr_CA' ;}
                        else if(strSelectedLanguage == 'en_US'){ user.LocaleSidKey = 'en_CA' ;}
                    }
                    /*End of PD-11615*/
                    
                    update user;
            } else {
                return new PageReference(DAZNConfiguration__c.getValues('MyAccountURL').Value__c + '?banner=updateLanguageFail');
            }
        }
    }catch(Exception ex){ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'updateUserLanguage', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        return redirectToErrorPage(ex.getMessage());
    }
    return errorPage;
}

public static Boolean isCheckResultCallout(Map<String,String> calloutResult) {
    Boolean isResult = false;
    if (Boolean.valueOf(calloutResult.get('success'))) {
        isResult = true;
    }
    if (Boolean.valueOf(calloutResult.get('success')) == false && String.valueOf(calloutResult.get('message')) == 'UpdateUserDetails endpoint is disabled') {
        isResult = true;
    }
    return isResult;
}
//End of PD-11813

/*
Description: This method is used to check whether to display banner on page or not.
*/
public string getBanner(){
    

    showbanner = false;        
    if(ApexPages.currentPage().getParameters().get('cancelButtonclick') == 'true'){
        showbanner=true;
        bShowSignOutButton=false;
        return 'cancellation';
    }
    else if(ApexPages.currentPage().getParameters().get('showReactivationBanner') =='true')
    {
        showbanner=true;
        bShowSignOutButton=false;
        showStartWatchingDAZN = true;
        return 'reactivation';            
    }else if(ApexPages.currentPage().getParameters().get('cancelButtonError') =='true')//showing banner when ZuoraTransaction not Success for PD-9013
    {
        showbanner=true;
        bShowSignOutButton=false;
        showStartWatchingDAZN = false;
        sBannerHeader = Label.LS_ErrorPage_Label_Internal_Server_Error;          
        sBanner = Label.LS_Cancel_subscription_ErrMsg;
        if(!string.isEmpty(sBanner))
        {
            GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionError);
        }
        return null;            
    }else if(ApexPages.currentPage().getParameters().get('ResubscribesError') =='true')//showing banner when ZuoraTransaction not Success for PD-9013
    {
        showbanner=true;
        bShowSignOutButton=false;
        showStartWatchingDAZN = false;
        sBannerHeader = Label.LS_ErrorPage_Label_Internal_Server_Error;          
        sBanner = Label.LS_Reactivate_subscription_ErrMsg;
        if(!string.isEmpty(sBanner))
        {
            GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionError);
        }
        return null;                
    }else if(ApexPages.currentPage().getParameters().get('ChangePaymentMethodError') =='true')//showing banner when ZuoraTransaction not Success for PD-9013
    {
        showbanner=true;
        bShowSignOutButton=false;
        showStartWatchingDAZN = false;
        //as per PD-11051 labels are added if change payment method is false
        sBannerHeader = Label.LS_ChangePaymentMethod_CreditCard_Failure_Title;        
        sBanner = Label.LS_Change_payment_ErrMsg.replace('[Scountry]',sCountryCode).replace('[Slang]',sLanguage);//PD-11051
        if(!string.isEmpty(sBanner))
        {
            GTMHeaderController.errorDespFromAccountController(Label.LS_Zuora_ConnectionError);
        }
        return 'ChangePaymentMethodError';                
    }
    return 'none'; 
}
@Testvisible
private void showPaymentMethodSuccessBanner(){
    if(ApexPages.currentPage().getParameters().get('paymentMethodSuccess') =='true'){
        showbanner=true;
        bShowSignOutButton=false;
        sBannerHeader=Label.LS_ChangePaymentMethodStatus_Success;
        sBanner=CommunityHelper.getSubscriptionDescription(Label.LS_PaymentChangeSuccess_InfoMsg_PaymentDetailsUpdated, oActSubscription);

        
    }
}

  /*
Description: This method is used to format year in required format.
*/
    public void formatYear(){
        if(paymentDetails != null && paymentDetails.Zuora__CreditCardExpirationYear__c !=null){
            expiryYear = paymentDetails.Zuora__CreditCardExpirationYear__c.substring(2,2);
        }
        if(paymentDetails != null && paymentDetails.Zuora__CreditCardExpirationMonth__c !=null){
            if((paymentDetails.Zuora__CreditCardExpirationMonth__c).length() < 2){
                expiryMonth = '0'+paymentDetails.Zuora__CreditCardExpirationMonth__c;
            }else{
                expiryMonth = paymentDetails.Zuora__CreditCardExpirationMonth__c;
            }
        }
    } 
    
 @TestVisible
private void showSetPauseBanner() {
    String banner = ApexPages.currentPage().getParameters().get('banner'); //can be 'initPause', 'amendedPause', 'stayActive' or 'welcomeBack'
    String resumeDate = ApexPages.currentPage().getParameters().get('resumeDate');
    String suspendDate = ApexPages.currentPage().getParameters().get('suspendDate');
    String showPaymentChange = ApexPages.currentPage().getParameters().get('showPaymentChange');
    
    if (String.isNotBlank(banner) && String.isNotBlank(resumeDate) && String.isNotBlank(suspendDate) && banner.equalsIgnoreCase('initPause')) {
        showbanner = true;
        sBannerHeader = Label.LS_keepinTouch_bannerHeader_text;
        sBanner = Label.LS_keepinTouch_bannerBody_text.replace('{0}', suspendDate).replace('{1}', resumeDate);
    } else if (String.isNotBlank(banner) && String.isNotBlank(resumeDate) && String.isNotBlank(suspendDate) && banner.equalsIgnoreCase('amendedPause')) {
        showbanner = true;
        sBannerHeader = Label.LS_MyAccount_BannerHeader_PauseAmended;
        sBanner = Label.LS_MyAccount_BannerBody_PauseAmended.replace('{0}', suspendDate).replace('{1}', resumeDate);
    } else if (String.isNotBlank(banner) && banner.equalsIgnoreCase('stayActive')) {
        showbanner = true;
        sBannerHeader = Label.LS_MyAccount_BannerHeader_StayActive;
        sBanner = Label.LS_MyAccount_BannerBody_StayActive;
    } else if (String.isNotBlank(banner) && String.isNotBlank(resumeDate) && banner.equalsIgnoreCase('welcomeBack')) {
        showbanner = true;
        sBannerHeader = Label.LS_MyAccount_BannerHeader_WelcomeBack;
        sBanner = Label.LS_MyAccount_BannerBody_WelcomeBack.replace('{0}', resumeDate);
    } else if (String.isNotBlank(banner) && banner.equalsIgnoreCase('successcanselsubscription')) {
        showbanner = true;
        sBanner = Label.LS_MyAccount_SuccessSubscriptionPause;
        if (String.isNotBlank(showPaymentChange) && showPaymentChange.equalsIgnoreCase('showPaymentChange') && !showAddPaymentFlag ) {
            isShowPaymentChange = true;
        }
    } else if (String.isNotBlank(banner) && banner.equalsIgnoreCase('failcanselsubscription')) {
        showbanner = true;
        sBanner = Label.LS_MyAccount_FailSubscriptionPause;
    } else if (String.isNotBlank(banner) && banner.equalsIgnoreCase('cancelReqFail')) {
        showbanner = true;
        sBanner = Label.LS_MyAccount_BannerBody_CancelRequestFailure;
    } else if (String.isNotBlank(banner) && banner.equalsIgnoreCase('amendReqFail')) {
        showbanner = true;
        sBanner = Label.LS_MyAccount_BannerBody_AmendRequestFailure;
    }
    //Added as part of change request for PD:15411
    else if (String.isNotBlank(banner) && banner.equalsIgnoreCase('Nextchargedatenull')) {
        showbanner = true;
        sBannerHeader = Label.LS_Global_ErrMsg_Header;
        sBanner = Label.LS_Global_ErrMsg_NoNextChargeDateFound;
    } else if (String.isNotBlank(banner) && banner.equalsIgnoreCase('updateLanguageFail')) {
        showbanner = true;
        sBannerHeader = Label.DECoup_BannerHeader_Problem;
        sBanner = Label.DECoup_Body_unable_update_language;
    }
}

}