@isTest
public class CaseExtTest {
   
    @isTest static void testCaseExtPositive() {
		
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

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm2testemail@email.com','Free Trial');
        oAccount.Type = 'DAZN for Docomo';
        update oAccount;
        SetUpTestData.createCommunityUser(oAccount.Id, 'pm2testemail@email.com', 'pm1testemail@email.com', 'tstals2','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        User oUser = [Select ID,CountryCode from User where Email='pm2testemail@email.com' limit 1];
        
        Case cas = new Case();
        CaseExt controller = new CaseExt(new ApexPages.StandardController(cas));
        system.assert(true, controller.doInit()!=null);
        system.assert(true, controller.isShowCase);

        System.runAs(oUser) { 
            controller = new CaseExt(new ApexPages.StandardController(cas)); 
            system.assert(true, controller.doInit()!=null);
            system.assertNotEquals(null, controller.isShowCase);
        }

    }

    @isTest static void testHideContactEmail() {
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

        Case newCase = SetUpTestData.testCreateCase();
        newCase.AccountId = oAccount.Id;
        update newCase;

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


            Case cas = [SELECT Id FROM Case WHERE Id = :newCase.Id];
            CaseExt controller = new CaseExt(new ApexPages.StandardController(cas));
            System.runAs(u) {
                controller = new CaseExt(new ApexPages.StandardController(cas));
                System.assertNotEquals(controller.isShowContactEmail, null);
            }
        Test.stopTest();
    }

    @isTest static void testOverideSt() {
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

        Case newCase = SetUpTestData.testCreateCase();
        newCase.AccountId = oAccount.Id;
        update newCase;

        EmailMessage[] newEmail = new EmailMessage[0];
        newEmail.add(new EmailMessage(FromAddress = 'someone@somewhere.com', Incoming = True, ToAddress= 'someone@salesforce.com', Subject = 'Test email', TextBody = 'Test', ParentId = newCase.Id)); 
        insert newEmail;

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


            Case cas = [SELECT Id FROM Case WHERE Id = :newCase.Id];
            System.runAs(u) {
                CaseExt.ovverideStandardReplyLink('[{\"link\":\"email_id='+newEmail[0].id+'&replyToAll=0&retURL=/apex/Case?id='+newCase.Id+'&sfdc.override=1\",\"caseId\":\"'+newCase.Id+'\"}]');
            }
        Test.stopTest();
    }

}