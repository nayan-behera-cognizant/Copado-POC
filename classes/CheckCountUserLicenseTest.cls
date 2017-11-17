@isTest
private class CheckCountUserLicenseTest {
	
	@isTest 
	static void testCheckCountLicense() {
		Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
		Contact testContact= new Contact();
            testContact.Email='someone@somewhere.com';
            testContact.LastName='lastname';
            testContact.Phone='1234567234';
            testContact.Title='hello';
        insert testContact;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        EmailTemplate validEmailTemplate = [SELECT Id,HtmlValue FROM EmailTemplate LIMIT 1 ];

        System.debug('#### validEmailTemplate = ' + validEmailTemplate);
		UserLicenseConfiguration__c config = new UserLicenseConfiguration__c(
					Email__c = oUser.Id, 
					Total_Community_Licenses__c = 20, 
					Total_Standard_License__c = 20,
					Contact_Id__c = testContact.Id,
					Email_TemplateId__c = validEmailTemplate.Id
				);
		insert config;

		License_Alert__c communityAlert = new License_Alert__c(
			Consumed__c = 20, 
			Name_of_License__c = 'Customer Community Login'
		);
		insert communityAlert;
		License_Alert__c standardLicense = new License_Alert__c(
			Consumed__c = 20, 
			Name_of_License__c = 'Salesforce Licenses'
		);
		insert standardLicense;
        Test.StartTest();
            System.RunAs(oUser){
                String CRON_EXP = '0 0 5 12 3 ? 2022';
                String jobId = System.schedule('CheckCountUserLicenseTest', CRON_EXP, new CheckCountUserLicense());
            }
        Test.StopTest(); 
	}
	
}