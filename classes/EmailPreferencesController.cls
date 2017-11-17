/**
* @author Cognizant Technology Solutions
* @date 16/03/2016
* @description Email Preferences update class
*/
public class EmailPreferencesController{
    public User oUser {get;set;}
    public string sAccountId {get;set;}    
    public boolean bIsUnsubscribe {get;set;}
    public string sHomepageURL {get;set;}
    public string sCountry {get;set;}
    public string sLanguage {get;set;}
    public boolean bShowUnsubscribeButton {get;set;}
    public Account oAccount {get;set;}
    public string sPersonEmail {get;set;}
    public string cookieCountry{get;set;}
    public boolean navigateError{get;set;}
    public boolean exceptioncatch{get;set;}
    public string errorMessage{get;set;}
    public  static PageReference errorPage = null;
    
    /*
Description: Email Preferences class constructor.
*/
    public EmailPreferencesController(){
     navigateError = false;
        if(oUser==null){/*Changes made for PD-7848*/
            oUser = CommunityHelper.getCurrentUser();
        }
        sHomepageURL = DAZNConfiguration__c.getValues('HomePageURL').Value__c;
        sAccountId = Apexpages.currentPage().getParameters().get('UserId');
        //Validation on Account Id, if in case invalid Account id setting navigate Error flag to true *PD-7932*. 
        /*if(sAccountId !=null && sAccountId != '' && String.escapeSingleQuotes(sAccountId).isAlphanumeric()){
            sAccountId = sAccountId;
        }else {
            navigateError = true;
        }*/
        sAccountId = sAccountId;
        bIsUnsubscribe = false;
        bShowUnsubscribeButton = false;
        
        // Country and Language Information.
        getCountryNLanguageInfo();
        
        // get account information.
        getAccountInformation();
        
        if(userInfo.getUserType().Equals('Guest'))
        {
            cookieCountry = communityhelper.getUserCountryfromIPAddress();
       }
        else
        {
            if(oUser != null){
                cookieCountry = CommunityHelper.getUserCountryName(null);
            }
            if(oUser == null){
                cookieCountry = CommunityHelper.getUserCountryName(oUser);
            }
        }
    }
    
    /*
Description: Method to extract country and language information from URL. 
*/
    private void getCountryNLanguageInfo(){
        sCountry = ApexPages.currentpage().getParameters().get('Country');
        sLanguage = ApexPages.currentpage().getParameters().get('lang'); 
        
        // Set country and language if user has not provided.
        if(string.isBlank(sCountry))
            sCountry = CommunityHelper.getUserCountry(null);
        if(string.isBlank(sLanguage)){
            string sLang = CommunityHelper.getLanguageCode();
            if(sLang.length() > 2 && sLang.indexOf('_') > -1){
                sLanguage = sLang.split('_')[0];
            }else{
                sLanguage = sLang;
            }
        }
    }
    
    /*
Description: Method to get account information to update email preferences. 
*/
    private void getAccountInformation(){
        
        
        // remove UID from accountid got from URL
        if(sAccountId != null)
        {
        sAccountId = sAccountId.substring(3, sAccountId.length());
            if(!String.isBlank(sAccountId)){
                List<Account> lstAccount = [Select Id, PersonEmail, All_Email_Preferences__c from Account where Id=: sAccountId];
                if(lstAccount != null && !lstAccount.isEmpty()){
                    oAccount = lstAccount[0];
                    
                    sPersonEmail = oAccount.PersonEmail;
                    
                    if(oAccount.All_Email_Preferences__c == false)
                        bIsUnsubscribe = true;
                    else
                        bShowUnsubscribeButton = true;
                }
            }
        }
        else{
                navigateError = true;/*Changes made for PD-7848*/
              
        }
    }
    
    /*
Description: Method to Method to unsubscribe user from email preferences.
*/
    public PageReference unSubscribe() {
        try{
            if(oAccount != null){   /*Changes made for PD-7848*/
                oAccount.All_Email_Preferences__c = false;
                update oAccount;
                bIsUnsubscribe= true;
            }else{
                navigateError = true;/*Changes made for PD-7848*/
            }
            
        }catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(userinfo.getuserId(), 'EmailPreferences', 'Unsubscribe', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            errorMessage = 'Unsubscription could not happen, please reach out to Customer service';/*Changes made for PD-7848*/
            CommunityHelper.redirectToErrorPage(errorMessage); 
        }
        return null;
    }
    
    // This method is used to  navigate to error page which invalid Account Id form Page  /*Changes made for PD-7848*/
    public PageReference navigateToErrorPage(){
        //*PD-9696*
        PageReference oPageReference = CommunityHelper.CheckDfDUserAccess();
        if(oPageReference != null){
            return oPageReference;
        }

        if(navigateError){
            
            errorPage=System.Page.InternalServerError;
            errorPage.getParameters().Put('Errormsg',System.Label.LS_NoAcc);
            errorPage.setRedirect(true);
        }

        return errorPage;
    }
}