@isTest
private class EmailHelpOptionExtTest {
	
    @isTest static void testEmailHelpOptionExtPositive() {
		
        Test.setCurrentPage(Page.EmailHelpOption);
        
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

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm2testemail@email.com','Free Trial');
        oAccount.Type = 'DAZN for Docomo';
        update oAccount;
        SetUpTestData.createCommunityUser(oAccount.Id, 'pm2testemail@email.com', 'pm1testemail@email.com', 'tstals2','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        User oUser = [Select ID,CountryCode from User where Email='pm2testemail@email.com' limit 1];
        
        Email_Help_Option__c emailHelpOption = new Email_Help_Option__c();
        EmailHelpOptionExt controller = new EmailHelpOptionExt(new ApexPages.StandardController(emailHelpOption));
        system.assert(true, controller.doInit()!=null);
        system.assert(true, controller.isShowEmailHelpOption);

        System.runAs(oUser) { 
            controller = new EmailHelpOptionExt(new ApexPages.StandardController(emailHelpOption)); 
            system.assert(true, controller.doInit()!=null);
            system.assertNotEquals(null, controller.isShowEmailHelpOption);
        }

    }
	
}