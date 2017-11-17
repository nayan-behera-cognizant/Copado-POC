@isTest
private class ResetPasswordTest {

	@testSetup
    public static void setData(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        List<DAZNCommunicatorConfig__c> lstCustomSetting = new List<DAZNCommunicatorConfig__c>();
        List<DAZNConfiguration__c> lstConfig = new List<DAZNConfiguration__c>();
        
        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'test.salesforce.com');
        SetUpTestData.testCreateDAZNConfiguration('EncryptionKey', '160ab450f9c22gb1');
        SetUpTestData.testCreateDAZNConfiguration('CommunicatorAPIUserName', 'test');
        SetUpTestData.testCreateDAZNConfiguration('CommunicatorAPIUserPwd', 'oL9IBIKPqWGSvVXHuhKawxjDx/PhfrWZGHjsKrMA/J8=');
        
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_User_Cancel_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Updated_Name_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Updated_Password_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Forgotten_Password_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Partial_Welcome_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Free_Trial_Welcome_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Hard_Offer_Welcome_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Successful_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Failure_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Subscription_End_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_New_Device_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Updatation_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Expiry_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Contacts_Table_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='MailingList_Transactional_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SalesForceID_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Email_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='FirstName_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='LastName_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SubscriptionEndDate_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Currency_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SubscriptionAmount_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='PlanDetails_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='PaymentMethodType_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='FreeTrialEndDate_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='AccountStatus_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='NotificationLanguageCode_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='NotificationCountryCode_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='CountryLanguage_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SignInLink_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Germany_Marketing_Mailing_List_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Marketing_Germany_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='UnsubscribeLanguage_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='CommunicatorAPITimeOutLimit',Value__c=60000));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Marketing_Mailing_List_ID',Value__c=63500)); 
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Inactive_Device_DE_en_GB',Value__c=60000)); 
        lstConfig.add(new DAZNConfiguration__c(name='DoubleOptInCountries',Value__c='DE,AT'));
        // added new 
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Docomo_MarketingMailingListID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Docomo_Contact_Table_ID',Value__c=21345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DFD_SalesforceColumnID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DfdColumnID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='HardOfferDateTime_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='ResetPasswordURL_Column_ID',Value__c=12345));
        insert lstCustomSetting;   
        insert lstConfig;

        Account oAccount = SetUpTestData.createPersonAccount('JP', 'en_GB', 'FirstName', 'LastName', 'email@email.email', 'Free Trial');

        DocomoConfiguration__c dc = new DocomoConfiguration__c(
			Name = 'Default Password',
			Value__c = EncodingUtil.base64Encode(Blob.valueOf('ttt'))
		);
		insert dc;

		DAZNConfiguration__c config = new DAZNConfiguration__c(
			Name = 'ResetPasswordReturnURL',
			Value__c = '/ChangePassword'
		);
		insert config;

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
    }
	
	@isTest static void testResetUserPassword() {
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

		RestRequest req = new RestRequest();
		req.requestURI = '/ResetPassword/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "viewerId":"' + viewerId + '" }');
        RestContext.request = req;

		Test.startTest();
		String statusMessage = ResetPassword.resetUserPassword();
		//System.assertEquals('Success', statusMessage);
		Test.stopTest();
	}

	@isTest static void testResetUserPasswordNoUser() {
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

		RestRequest req = new RestRequest();
		req.requestURI = '/ResetPassword/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "viewerId":"' + 'fake id' + '" }');
        RestContext.request = req;

		Test.startTest();
		String statusMessage = ResetPassword.resetUserPassword();
		System.assertEquals('Failure', statusMessage);
		Test.stopTest();
	}

	@isTest static void testResetUserPasswordNoDefaultPassword() {
		delete DocomoConfiguration__c.getValues('Default Password');

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

		RestRequest req = new RestRequest();
		req.requestURI = '/ResetPassword/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "viewerId":"' + viewerId + '" }');
        RestContext.request = req;

		Test.startTest();
		String statusMessage = ResetPassword.resetUserPassword();
		System.assertEquals('Failure', statusMessage);
		Test.stopTest();
	}

	@isTest static void testResetUserPasswordNoUserSSO() {
		List<Account> oAccount = [Select Id, PersonEmail, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account Where PersonEmail = 'email@email.email'];
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

		RestRequest req = new RestRequest();
		req.requestURI = '/ResetPassword/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "viewerId":"' + viewerId + '" }');
        RestContext.request = req;

        User u = [Select Id From User Where UserType = 'Guest' AND IsActive = true LIMIT 1];
        System.runAs(u) {
        	Test.startTest();
		    Test.setMock(HttpCalloutMock.class, new MockChangePasswordSuccess());
		    String statusMessage = ResetPassword.resetUserPassword();
		    System.assertEquals('Failure', statusMessage);
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