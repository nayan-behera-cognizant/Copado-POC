/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class ForgotPasswordController {
    public User user { get; set; }
    public String strNewEmail { get; set; }
    public Boolean showMessage { get; set; }
    public String strMessage { get; set; }
       
    public ForgotPasswordController() {
        showMessage = false;
        strMessage = '';
        strNewEmail = '';
        user = CommunityHelper.getCurrentUser();
    }

    public PageReference forgotPassword() {
        /*Start PD-14478*/
        String usernameConfiguration = (DAZNConfiguration__c.getValues('LS_UserName_Configuration') != null) ? DAZNConfiguration__c.getValues('LS_UserName_Configuration').Value__c : null;
        /*End PD-14478*/
        try {           
            String sUserName;
            sUserName = strNewEmail + '.' + usernameConfiguration; 
            Boolean success = Site.forgotPassword(sUserName);
            showMessage = true;            
            strMessage = (success) ? Label.LS_ForgotPassword_Label_Success : Label.LS_ForgotPassword_Label_Failure;
        } catch(Exception ex) {
            ExceptionLoggerHelper.createExceptionLog(user.Id, 'ForgotPasswordController', 'forgotPassword', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        }
        return null;
    }
}