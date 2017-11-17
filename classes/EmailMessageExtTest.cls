@isTest
private class EmailMessageExtTest {
	
	@isTest 
	static void testEmailMessageExt() {
		Test.setCurrentPage(Page.Case);
        
        TriggerSetting__c setting = new TriggerSetting__c(
        	Name = 'UpdateAccountTrigger',
            Disable__c = true
        );
		insert setting;
        
        TriggerSetting__c settingTr = new TriggerSetting__c(
        	Name = 'UserTrigger',
            Disable__c = true
        );
		insert settingTr;

		Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
            Name = 'Docomo',
            Partner_Type__c = 'Docomo',
            Page_Name__c = 'PartnerAccount.page',
            Subscription_Type_Heading_Text__c = 'Docomo',
            Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
            Payment_History_URL__c = 'https://www.google.com',
            Cancel_Subscription_URL_Small__c = 'https://www.google.com',
            Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
            Cancel_Subscription_URL_Large__c = 'https://www.google.com'
        );
        insert pac;

		Customer_Service_Profile_Configuration__c conf = new Customer_Service_Profile_Configuration__c();
        conf.Name = '1';
        conf.Profile_Name__c = UserInfo.getProfileId();
        insert conf;

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm2testemail@email.com','Free Trial');
        oAccount.Type = 'Docomo';
        oAccount.Partner_ID__c = '123';
        update oAccount;
        SetUpTestData.createCommunityUser(oAccount.Id, 'pm2testemail@email.com', 'pm1testemail@email.com', 'tstals2','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        User oUser = [Select ID,CountryCode from User where Email='pm2testemail@email.com' limit 1];
        
        Case cas = new Case(Origin = 'Self Service   Portal', Subject = 'Unit Test', Type = 'Support', Status = 'Closed', AccountId = oAccount.Id, Description = 'test');
    	insert cas;

        Contact testContact= new Contact();
            testContact.Email='someone@somewhere.com';
            testContact.LastName='lastname';
            testContact.Phone='1234567234';
            testContact.Title='hello';
        insert testContact;


    	EmailMessage[] newEmail = new EmailMessage[0];
    	newEmail.add(new EmailMessage(FromAddress = 'someone@somewhere.com', Incoming = True, ToAddress= 'someone@salesforce.com', Subject = 'Test emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest email', TextBody = 'Test', ParentId = cas.Id)); 
        insert newEmail;

        EmailMessageExt controller = new EmailMessageExt(new ApexPages.StandardController(newEmail[0]));
        System.assert(controller != null);
	}
	
}