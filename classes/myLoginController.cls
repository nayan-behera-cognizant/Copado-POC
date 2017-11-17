/**
* @author Cognizant Technology Solutuions
* @date 21/10/2015
* @description Community Helper class
* @modified date 20/09/2016 
*/

/**
* An apex page controller that exposes the site login functionality
*/
global with sharing class myLoginController {
    global String email { get; set; }
    global String password { get; set; }
    public String sCountry { get; set; }
    public Boolean showBanner { get; set; }
    public String cookieCountry { get; set; }
    public Boolean isBlockedUser { get; set; }
    
    public String isBlockedUserMessageHeader { get; set; }
    public String isBlockedUserMessageBanner { get; set; }
    
    public String errorMessage;
    public String username; 
    String sForgotEmailURL;
    String sPasswordResetURL;
    global String  RetURl { get; set; }
     //Added as per PD-11364
    public Boolean isInvalidUser { get; set; }
    //end of PD-11364
    
  
    global String emailaddress{ get; set; }
    
    global myLoginController() {        
        if (UserInfo.getUserType().equalsIgnoreCase('Guest')) {
            cookieCountry = Communityhelper.getUserCountryfromIPAddress();
        } else {
            cookieCountry = CommunityHelper.getUserCountryName(null);                
        }
        
        showBanner = false;
        isBlockedUser =false;
    }
    
    global PageReference login() {   
        /*Start PD-14478*/
        String usernameConfiguration = (DAZNConfiguration__c.getValues('LS_UserName_Configuration') != null) ? DAZNConfiguration__c.getValues('LS_UserName_Configuration').Value__c : null;
        /*End PD-14478*/

        List<User> u = [Select Id, AccountId, Profile.isSsoEnabled, CountryCode From User Where Email = :emailaddress LIMIT 1];
        Id userId = (u != null && !u.isEmpty()) ? u[0].Id : null;
        String countryCode = (u != null && !u.isEmpty()) ? u[0].CountryCode : null;
        String accountId = (u != null && !u.isEmpty()) ? u[0].AccountId : null;
        
        username = emailaddress + '.' + usernameConfiguration;

        String startUrl = ApexPages.currentpage().getParameters().get('retUrl');
        startUrl = (String.isBlank(startUrl)) ? '' : '/' + startUrl;
        PageReference redirect = Site.login(username, password, startUrl);
        /*if (Test.isRunningTest()) {
            redirect = new PageReference('CommunitiesLanding');
        }*/
        if (redirect == null) {
		    // As per PD-11364
            MyLoginControllerWithouSharing mylog = new MyLoginControllerWithouSharing();
            isInvalidUser = mylog.invalidLogin(emailaddress);
			if (isInvalidUser == true) {
                isBlockedUser = true;
            }//end of PD-11364
            showBanner = true;
            return null;
        } else {
            Id ssoProfileId = CommunityHelper.getSSOProfileIdForNonSSOUser(userId);
            if (String.isNotBlank(userId) && String.isNotBlank(countryCode) && CommunityHelper.isRunSSOFlow(countryCode) && String.isNotBlank(ssoProfileId)) {
                CommunityHelper.changeProfileToSSO(emailaddress, password, userId, accountId, ssoProfileId, countryCode);
            }
            return getRedirectUrl();
        }
    }

    /*PD-8875*/
    public PageReference getRedirectUrl() {
        String startUrl = ApexPages.currentpage().getParameters().get('retUrl');
        startUrl = (String.isBlank(startUrl)) ? '' : '/' + startUrl;
        PageReference redirectUrl = Site.login(username, password, startUrl);
        if (Test.isRunningTest()) {
            redirectUrl = new PageReference('CommunitiesLanding');
        }
        /*PD-9874*/
        if (new MyLoginControllerWithouSharing().isBlocked(username)) {
            isBlockedUserMessageHeader = Label.LS_Mylogin_Login_Issue_Banner_Blocked_User_Header_Label;
            isBlockedUserMessageBanner = Label.LS_MyLogin_Login_Issue_Banner_Blocked_User_Message;
            showBanner = true;
            isBlockedUser = true;
            return null;
        }
        
        if (redirectUrl != null) {
            String contactUsSubject = ApexPages.currentPage().getParameters().get('type');
            if (String.isNotBlank(contactUsSubject)) {
                String currentRequestURL= System.URL.getCurrentRequestUrl().toExternalForm();
                if (!currentRequestURL.contains('lang=') && !currentRequestURL.contains('Country=')) {
                    String url = EncodingUtil.urlEncode('contactus/' + ApexPages.currentpage().getParameters().get('Country') + '-' + ApexPages.currentpage().getParameters().get('lang') + '?type=' + contactUsSubject, 'UTF-8');
                    String originalUrl = redirectUrl.getUrl().replace('CommunitiesLanding', url);
                    PageReference contactUs = new PageReference(originalUrl);
                    return contactUs;
                }
            }
        }
        
        return redirectUrl;
    }
    
    public string getRememberEmailURL() {  
        sCountry = CommunityHelper.getUserCountryName(null);
        if (sCountry != null && sCountry != '') {
            sForgotEmailURL = CommunityHelper.getMassiveURLs(sCountry,'ForgotEmailURLType');             
        } else { //PD-7849
            errorMessage = 'country is not found';
            CommunityHelper.redirectToErrorPage(errorMessage);             
        }    
        return String.valueOf(sForgotEmailURL);    
    }
    
    public string getPasswordResetURL() { 
        sCountry = CommunityHelper.getUserCountryName(null);
        if(sCountry!=null && sCountry!=''){
            sPasswordResetURL = CommunityHelper.getMassiveURLs(sCountry,'PasswordResetURLType'); 
        }else{ //PD-7849
            errorMessage = 'country is not found';
            CommunityHelper.redirectToErrorPage(errorMessage); 
        }        
        return String.valueOf(sPasswordResetURL);
    }
    
    /*
Description: method to close banner.
*/
    public void closeBanner() {
        showBanner = false;
    }
    
    /*
Description: Method to redirect user on home page.
*/
    public PageReference redirectToHomePage() {
        return CommunityHelper.redirectToHomePage();
    }
    
    /*PD-9874*/
    public without sharing class MyLoginControllerWithouSharing {
        
        public Boolean isBlocked(String usernameS) {
            /*Start PD-14478*/
            String usernameConfiguration = (DAZNConfiguration__c.getValues('LS_UserName_Configuration') != null) ? DAZNConfiguration__c.getValues('LS_UserName_Configuration').Value__c : null;
            /*End PD-14478*/

            Boolean isResult = false;
            if (Test.isRunningTest() && usernameS != null) {
                usernameS = usernameS.replace('.' + /*Label.LS_UserName_Configuration*/usernameConfiguration, '');
                
            }
            
            List<Account> acc = [select id, Account_Status__c, Type from Account Where Id IN (select accountid from user where username = :usernameS)];
            if (!acc.isEmpty() && acc[0].Account_Status__c == 'Blocked') {
                
                isResult = true;
            }
            
            return isResult;
        }
  
		// As per PD-11364 method for invalid login attempts
        public boolean invalidLogin(String emailaddress){
            if(emailaddress!= null){
                list<User> ouser=[select id,Username,email,name from user where email=:emailaddress limit 1];     
                if(ouser!=null){
                    List<LoginHistory> logininfo=[SELECT UserId,status, LoginTime from LoginHistory where UserId =:ouser[0].id order by LoginTime Desc limit 1];  
                    if(logininfo!=null){
                        if(!test.isRunningTest()){
                            if(logininfo[0].status=='Password Lockout'){
                                return true;
                            }
                        }
                    }
                } 
            }
            return false;
        }//end of PD-11364          
        
        /*PD-9524*/
        public PageReference redirectToDocomoSignInPage() {
            return System.Page.SignIn;
        }
        
    }

    public PageReference navigateUser() {
        PageReference retPR;
        String startUrl = ApexPages.currentpage().getParameters().get('retUrl');
        if (!UserInfo.getUserType().equalsIgnoreCase('Guest') && String.isNotBlank(startUrl) && startUrl.equalsIgnoreCase('ChangePaymentMethod')) {
            retPR = Page.ChangePaymentMethod;
        }
        return retPR;
    }
}