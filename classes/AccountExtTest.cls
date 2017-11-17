@isTest
public class AccountExtTest {
	@isTest static void testAccountExtPositive() {
		
        Test.setCurrentPage(Page.Account);
        
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
        
        Account acc = new Account();
        AccountExt controller = new AccountExt(new ApexPages.StandardController(acc)); 
        system.assert(true, controller.doInit()!=null);
        system.assert(true, controller.isShowAccount); 
        
        System.runAs(oUser) {
            controller = new AccountExt(new ApexPages.StandardController(acc)); 
            system.assert(true, controller.doInit()!=null);
			system.assertEquals(false, controller.isShowAccount); 
        }
    }

    @isTest static void testHideAccountName() {
        Test.setCurrentPage(Page.Account);
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
        oAccount.Type = 'Docomo';
        oAccount.Partner_ID__c = '123123';
        update oAccount;
        System.currentPageReference().getParameters().put('id', oAccount.Id);

        Test.startTest();
            Profile oProfile = [SELECT Id, Name from Profile where Id = :UserInfo.getProfileId() limit 1]; 
            User u = new User (
                Alias = 'standt', 
                Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', 
                LastName='Testing', 
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', 
                ProfileId = oProfile.Id,
                TimeZoneSidKey='America/Los_Angeles', 
                UserName='standarduser@testorgtest.testcom'
            );
            insert u;

            Account acc = [SELECT Id FROM Account WHERE Id = :oAccount.id];
            AccountExt controller = new AccountExt(new ApexPages.StandardController(acc)); 

            System.runAs(u) {
                controller = new AccountExt(new ApexPages.StandardController(acc));
                System.assertNotEquals(controller.isShowAccountName, null);
            }
        Test.stopTest();
    }
}