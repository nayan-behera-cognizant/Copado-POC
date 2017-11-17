public without sharing class ResetPasswordController {

    public PageReference navigateUser() {
        PageReference errorPage = System.Page.InternalServerError;
        errorPage.getParameters().put('Errormsg', Label.DECoup_ForgotPassword_SystemError);

        String viewerId = ApexPages.currentPage().getParameters().get('vid');
        DocomoConfiguration__c dc = DocomoConfiguration__c.getValues('Default Password');
        if (String.isNotBlank(viewerId) && dc != null && String.isNotBlank(dc.Value__c)) {
            String passwordString = EncodingUtil.base64Decode(dc.Value__c).toString();
            viewerId = EncodingUtil.base64Decode(viewerId).toString();
            List<User> lstUser = [Select Id, AccountId, Username, Email, Profile.isSsoEnabled, Contact.Account.Notification_Country_Code__c From User Where Viewer_Id__c = :viewerId LIMIT 1];
            if (lstUser.isEmpty()) {
                return errorPage;
            }
            Boolean isError = false;
            if (lstUser[0].Profile.isSsoEnabled) {
                Map<String, Object> payload = new Map<String, Object> {
                    'Email' => lstUser[0].Email,
                    'CheckOldPassword' => 'false',
                    'NewPassword' => passwordString
                };
                Map<String, String> changePasswordRes = MISLCalloutHelper.changePassword(payload, lstUser[0].Contact.Account.Notification_Country_Code__c, lstUser[0].AccountId);
                isError = changePasswordRes == null || String.isBlank(changePasswordRes.get('success'))
                    || !changePasswordRes.get('success').equalsIgnoreCase('true');
            }
            if (isError) {
                return errorPage;
            }
            PageReference pr = Site.login(lstUser[0].Username, passwordString, '/ChangePassword');
            pr = (pr == null) ? errorPage : pr;
            return pr;
        }

        return errorPage;
    }

}