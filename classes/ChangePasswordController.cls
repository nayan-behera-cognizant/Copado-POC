/**
 * An apex page controller that exposes the change password functionality
 */
public with sharing class ChangePasswordController {
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}   
    public string strMessage {get;set;}
    public string sProvideValidNewPasswordErrMsg {get;set;}
    public string sLanguage{get;set;}
    public string sCountry{get;set;}
    public User user {get;set;}
    public string cookieCountry{get;set;}
    public void showMessage(string strMsg){
        strMessage=strMsg;
    }
    
    /* 
        Description: Method to change password and redirect on my Account page.
    */
    public PageReference changePassword() {
        try {
            if (string.isblank(newPassword)) {
                sProvideValidNewPasswordErrMsg = Label.LS_MyAccount_ErrMsg_BlankPassword;
            } else if (newPassword.length() < 5 || newPassword.length() > 30) {
                sProvideValidNewPasswordErrMsg = Label.LS_MyAccount_ErrMsg_PasswordLength;
            }
            //else if((Pattern.compile('(?=.*[ :#^&*(){}\'"/<>])').matcher(newPassword)).find()||!(Pattern.compile('(^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[_.!@$%])[a-zA-Z0-9_.!@£$%])').matcher(newPassword)).find()||(Pattern.compile('(?=.*[ :#^&*(){}\'"/<>])').matcher(newPassword)).find())
            //    sProvideValidNewPasswordErrMsg = Label.LS_MyAccount_ErrMsg_InvalidNewPassword;
            else if (!newPassword.equals(verifyNewPassword)) {
                sProvideValidNewPasswordErrMsg = Label.LS_MyAccount_ErrMsg_NewPwdAndRepeatPwdDoNotMatch;
            } else {
                if(user == null){
                    user = CommunityHelper.getCurrentUser();
                }

                if (CommunityHelper.isRunSSOFlow(user.Contact.Account.Notification_Country_Code__c)) { //run new flow for sso users
                    Map<String, Object> payload = new Map<String, Object> {
                        'Email' => user.Email,
                        'CheckOldPassword' => 'false',
                        'NewPassword' => newPassword
                    };
                    Map<String, String> changePasswordRes = MISLCalloutHelper.changePassword(payload, user.Contact.Account.Notification_Country_Code__c, user.AccountId);
                    Boolean isError = changePasswordRes == null || String.isBlank(changePasswordRes.get('success'))
                        || !changePasswordRes.get('success').equalsIgnoreCase('true');
                    if (isError) {
                        sProvideValidNewPasswordErrMsg = Label.DECoup_ForgotPassword_SystemError;
                        return null;
                    }
                    Id ssoProfileId = CommunityHelper.getSSOProfileIdForNonSSOUser(user.Id);
                    if (String.isNotBlank(ssoProfileId)) {
                        CommunityHelper.updateUserProfile(user.Id, ssoProfileId);
                    }
                } else { //run old flow
                    if (String.isEmpty(oldPassword)) {
                        System.setPassword(user.Id, newPassword);
                    } else {
                        Site.changePassword(newPassword, verifyNewPassword, oldPassword);
                    }
                }

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
                /*End PD-9179*/       
                showMessage(Label.LS_ForgotPassword_InfoMsg_Password_Changed_Successfully);
                PageReference pageRef = new PageReference('/MyAccount');
                pageRef.setRedirect(true);
                return pageRef;
            }
            return null;
        }catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ChangePasswordController', 'changePassword', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            throw ex;
        }
        return null;
    }
    
    public ChangePasswordController() {
        user = CommunityHelper.getCurrentUser();
        if (user != null && String.isNotBlank(user.LanguageLocaleKey)) {
            sLanguage = user.LanguageLocaleKey;
        }
        if (userInfo.getUserType().Equals('Guest')) {
            cookieCountry = communityhelper.getUserCountryfromIPAddress();
            System.debug('***GuestUser***' + cookieCountry );
        } else {
            cookieCountry = CommunityHelper.getUserCountryName(user);
            System.debug('***usernull***' + cookieCountry );
        }
    }

    /*
    Description: Method to validate user access and redirect user based on access. *PD-9696*
    */
    public PageReference navigateUser(){
        PageReference oPageReference = CommunityHelper.CheckDfDUserAccess();
        if(oPageReference != null){
            return oPageReference;
        }

        return null;
    }
}