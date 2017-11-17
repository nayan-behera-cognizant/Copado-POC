@RestResource(urlMapping = '/ResetPassword/*')
global class ResetPassword {

    @HttpPost
    global static String resetUserPassword() {
    	String statusMessage; // can be "Success" or "Failure" status
        try {
            statusMessage = 'Success';
            String requestBodyJSONString;

            RestRequest req = RestContext.request;
            requestBodyJSONString = req.requestBody.toString();

            ResetPasswordBody resetPswd = (ResetPasswordBody)System.JSON.deserialize(requestBodyJSONString, ResetPasswordBody.class);

            List<User> lstUser = [Select Id, Email, AccountId, ContactId, FirstName, Contact.Account.Notification_Language_Code__c, Contact.Account.Notification_Country_Code__c, Profile.isSsoEnabled From User Where Viewer_Id__c = :resetPswd.viewerId LIMIT 1];
            if (lstUser.isEmpty()) {
                statusMessage = 'Failure';
                return statusMessage;
            }

            DAZNConfiguration__c config = DAZNConfiguration__c.getValues('ResetPasswordReturnURL');
            DocomoConfiguration__c dc = DocomoConfiguration__c.getValues('Default Password');
            if (dc == null || String.isEmpty(dc.Value__c) || config == null || String.isEmpty(config.Value__c)) {
                statusMessage = 'Failure';
                return statusMessage;
            }
            String resetPasswordReturnURL = config.Value__c;
            String passwordString = EncodingUtil.base64Decode(dc.Value__c).toString();
            
            if (lstUser[0].Profile.isSsoEnabled) {
                Map<String, Object> payload = new Map<String, Object> {
                    'Email' => lstUser[0].Email,
                    'CheckOldPassword' => 'false',
                    'NewPassword' => passwordString
                };
                Map<String, String> changePasswordRes = MISLCalloutHelper.changePassword(payload, lstUser[0].Contact.Account.Notification_Country_Code__c, lstUser[0].AccountId);
                Boolean isError = changePasswordRes == null || String.isBlank(changePasswordRes.get('success'))
                    || !changePasswordRes.get('success').equalsIgnoreCase('true');
                if (isError) {
                    statusMessage = 'Failure';
                }
            } else {
                System.setPassword(lstUser[0].Id, passwordString);
            }
            CommunicatorIntegrationHelper.doCallOutResetPasswordFromFuture(
                lstUser[0].AccountId,
                lstUser[0].ContactId,
                lstUser[0].FirstName,
                resetPasswordReturnURL + '?vid=' + EncodingUtil.base64Encode(Blob.valueOf(resetPswd.viewerId)),
                lstUser[0].Contact.Account.Notification_Language_Code__c,
                lstUser[0].Contact.Account.Notification_Country_Code__c
            );
        } catch(Exception e) {
        	statusMessage = 'Failure';
        }

        return statusMessage;
    }

    private class ResetPasswordBody {
        public String viewerId;
    }

}