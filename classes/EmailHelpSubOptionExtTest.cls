@isTest
private class EmailHelpSubOptionExtTest {
	
    @isTest static void testEmailHelpSubOptionExtPositive() {
		
        Test.setCurrentPage(Page.EmailHelpSubOption);
        
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
        
        Email_Help_SubOption__c emailHelpSubOption = new Email_Help_SubOption__c();
        EmailHelpSubOptionExt controller = new EmailHelpSubOptionExt(new ApexPages.StandardController(emailHelpSubOption));
        system.assert(true, controller.doInit()!=null);
        system.assert(true, controller.isShowEmailHelpSubOption);

        System.runAs(oUser) { 
            controller = new EmailHelpSubOptionExt(new ApexPages.StandardController(emailHelpSubOption)); 
            system.assert(true, controller.doInit()!=null);
            system.assertNotEquals(null, controller.isShowEmailHelpSubOption);
        }

    }
	
}