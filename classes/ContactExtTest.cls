@isTest
public class ContactExtTest {
	@isTest static void testContactExtPositive() {
		
        Test.setCurrentPage(Page.Contact);
        
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
        Contact con = new Contact();
        ContactExt controller = new ContactExt(new ApexPages.StandardController(con));
        system.assert(true, controller.doInit()!=null);
        system.assert(true, controller.isShowContact);
        
        System.runAs(oUser) {
            controller = new ContactExt(new ApexPages.StandardController(con)); 
            system.assert(true, controller.doInit()!=null);
            system.assertEquals(false, controller.isShowContact);
        }
    }
}