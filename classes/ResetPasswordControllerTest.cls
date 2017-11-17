@isTest
private class ResetPasswordControllerTest {

	@testSetup
    public static void setUpTestData() {
        DocomoConfiguration__c dc = new DocomoConfiguration__c(
			Name = 'Default Password',
			Value__c = EncodingUtil.base64Encode(Blob.valueOf('test'))
		);
		insert dc;

		List<MISL_Configuration__c> mislConfig = new List<MISL_Configuration__c>();
        mislConfig.add(new MISL_Configuration__c(
            Name = 'MISL_ChangeUserPassword_DE',
            Value__c = 'test',
            Enabled_Country_Codes__c = 'DE',
            Timeout__c = 3000
        ));
        mislConfig.add(new MISL_Configuration__c(
            Name = 'MISL_ChangeUserPassword_CA',
            Value__c = 'test',
            Enabled_Country_Codes__c = 'CA',
            Timeout__c = 3000
        ));
        mislConfig.add(new MISL_Configuration__c(
            Name = 'MISL_Username',
            Value__c = 'test'
        ));
        mislConfig.add(new MISL_Configuration__c(
            Name = 'MISL_Password',
            Value__c = EncodingUtil.base64Encode(Blob.valueOf('test'))
        ));
        insert mislConfig;

        Account oAccount = SetUpTestData.createPersonAccount('JP', 'en_GB', 'FirstName', 'LastName', 'email@email.email', 'Free Trial');
    }
	
	@isTest static void testNavigateUserWithoutParams() {
		Test.startTest();
		ResetPasswordController resetPasswordController = new ResetPasswordController();
		PageReference pr = resetPasswordController.navigateUser();
		System.assertNotEquals(null, pr);
		PageReference testPage = System.Page.InternalServerError;
        testPage.getParameters().put('Errormsg', Label.DECoup_ForgotPassword_SystemError);
		System.assertEquals(testPage.getUrl(), pr.getUrl());
		Test.stopTest();
	}
	
	@isTest static void testNavigateUserWithParams() {
		List<Account> oAccount = [Select Id, PersonEmail, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
		User oUser = SetUpTestData.createCommunityUser(
			oAccount[0].Notification_Language_Code__c,
			oAccount[0].Notification_Country_Code__c,
			oAccount[0].Id,
			oAccount[0].PersonEmail,
			oAccount[0].PersonEmail,
			'tstals',
			'Europe/London',
			'ISO-8859-1',
			'en_US',
			'en_US',
			oAccount[0].FirstName,
			oAccount[0].LastName,
			true
		);
		String viewerId = [Select Viewer_Id__c From User Where Id = :oUser.Id].Viewer_Id__c;
		String encodedViewerId = EncodingUtil.base64Encode(Blob.valueOf(viewerId));

		User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];

		System.RunAs(u) {
			Test.startTest();
			PageReference pageRef = System.Page.ResetPassword;
			pageRef.getParameters().put('vid', encodedViewerId);
			Test.setCurrentPage(pageRef);
		    ResetPasswordController resetPasswordController = new ResetPasswordController();
		    PageReference pr = resetPasswordController.navigateUser();
		    System.assertNotEquals(null, pr);
		    PageReference testPage = System.Page.InternalServerError;
            testPage.getParameters().put('Errormsg', Label.DECoup_ForgotPassword_SystemError);
		    System.assertEquals(testPage.getUrl(), pr.getUrl());
		    Test.stopTest();
	    }
	}

	@isTest static void testNavigateUserWithParamsSSO() {
		List<Account> oAccount = [Select Id, PersonEmail, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
		User oUser = SetUpTestData.createCommunityUser(
			oAccount[0].Notification_Language_Code__c,
			oAccount[0].Notification_Country_Code__c,
			oAccount[0].Id,
			oAccount[0].PersonEmail,
			oAccount[0].PersonEmail,
			'tstals',
			'Europe/London',
			'ISO-8859-1',
			'en_US',
			'en_US',
			oAccount[0].FirstName,
			oAccount[0].LastName,
			true
		);
		oUser.ProfileId = [Select Id From Profile Where Name = 'Customer Community User SSO'].Id;
		update oUser;
		String viewerId = [Select Viewer_Id__c From User Where Id = :oUser.Id].Viewer_Id__c;
		String encodedViewerId = EncodingUtil.base64Encode(Blob.valueOf(viewerId));

		User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];

		System.RunAs(u) {
			Test.startTest();
			Test.setMock(HttpCalloutMock.class, new MockChangePasswordSuccess());
			PageReference pageRef = System.Page.ResetPassword;
			pageRef.getParameters().put('vid', encodedViewerId);
			Test.setCurrentPage(pageRef);
		    ResetPasswordController resetPasswordController = new ResetPasswordController();
		    PageReference pr = resetPasswordController.navigateUser();
		    System.assertNotEquals(null, pr);
		    PageReference testPage = System.Page.InternalServerError;
            testPage.getParameters().put('Errormsg', Label.DECoup_ForgotPassword_SystemError);
		    System.assertEquals(testPage.getUrl(), pr.getUrl());
		    Test.stopTest();
	    }
	}

	public class MockChangePasswordSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ Password Changed }');
            res.setStatusCode(200);
            return res;
        }
    }
}