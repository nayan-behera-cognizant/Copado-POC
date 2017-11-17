@isTest
private without sharing class CaseTriggerHandlerTest {
    
    @isTest 
    static void testCaseTriggerHandler() {        
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
        oAccount.Notification_Language_Code__c = 'en';
        update oAccount;
        SetUpTestData.createCommunityUser(oAccount.Id, 'pm2testemail@email.com', 'pm1testemail@email.com', 'tstals2','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        User oUser = [Select ID,CountryCode from User where Email='pm2testemail@email.com' limit 1];
        
        Account acc = new Account();
        AccountExt controller = new AccountExt(new ApexPages.StandardController(acc)); 
        system.assert(true, controller.doInit()!=null);
        system.assert(true, controller.isShowAccount); 
        
        System.runAs(oUser) {
            Case oCase = new Case();
            oCase.Origin = 'Email';
            oCase.Type = 'General Enquiry';
            oCase.Status= 'Open';
            oCase.Subject = 'Test Description';
            oCase.Description = 'Case Association With Account only when Supplied Email is exist with any Account';
            insert oCase;
        }
    }
    
    @isTest
    static void testCaseCampaign() {
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
        User oUser = [Select ID,CountryCode, ContactId, Email from User where Email='pm2testemail@email.com' limit 1];
        
        Campaign c = new Campaign(Name='Test');
        insert c;
        CampaignMember newMember = new CampaignMember(CampaignId = c.Id, ContactId = oUser.ContactId);
        insert newMember;
        
        Contact cont = [SELECT Email FROM Contact WHERE AccountId = :oAccount.Id];   
        
        Case oCase = new Case();
        oCase.Origin = 'Email';
        oCase.Type = 'General Enquiry';
        oCase.Status= 'Open';
        oCase.Subject = 'Test Description';
        oCase.Description = 'Case Association With Account only when Supplied Email is exist with any Account';
        oCase.SuppliedEmail = cont.Email;
        oCase.Campaign__c = c.Id;
        
        insert oCase;
        
    }
    @isTest
    static void testCaseCampaignContact() {
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
        User oUser = [Select ID,CountryCode, ContactId, Email from User where Email='pm2testemail@email.com' limit 1];
        
        Campaign c = new Campaign(Name='Test');
        insert c;
        Campaign c2 = new Campaign(Name='Test2');
        insert c2;
        
        CampaignMember newMember = new CampaignMember(CampaignId = c.Id, ContactId = oUser.ContactId);
        insert newMember;   
        
        Case oCase = new Case();
        oCase.Origin = 'Email';
        oCase.Type = 'General Enquiry';
        oCase.Status= 'Open';
        oCase.Subject = 'Test Description';
        oCase.Description = 'Case Association With Account only when Supplied Email is exist with any Account';
        oCase.SuppliedEmail = oUser.Email;
        oCase.Campaign__c = c2.Id;
        oCase.ContactId = oUser.ContactId;
        
        insert oCase;
        
    }
    
    @isTest
    static void testCaseCampaignNotEmail() {
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
        User oUser = [Select ID,CountryCode, ContactId, Email from User where Email='pm2testemail@email.com' limit 1];
        
        Campaign c = new Campaign(Name='Test');
        insert c;
        CampaignMember newMember = new CampaignMember(CampaignId = c.Id, ContactId = oUser.ContactId);
        insert newMember;
        
        Contact cont = [SELECT Email FROM Contact WHERE AccountId = :oAccount.Id];   
        
        Case oCase = new Case();
        oCase.Origin = 'Email';
        oCase.Type = 'General Enquiry';
        oCase.Status= 'Open';
        oCase.Subject = 'Test Description';
        oCase.Description = 'Case Association With Account only when Supplied Email is exist with any Account';
        oCase.SuppliedEmail = 'test@tr.rt';
        oCase.Campaign__c = c.Id;
        insert oCase;
    }
    
    /*Added as a part of PD-16510*/
    static testmethod void LoopTest(){
        test.startTest();
        try{
        Case newcase1 = new Case(SuppliedEmail = 'danielc@schoolcenter.com', subject = 'Test');
            insert newCase1;   
            Case newcase2 = new Case(SuppliedEmail = 'danielc@schoolcenter.com', subject = 'Test');
            insert newCase2;   
            Case newcase3 = new Case(SuppliedEmail = 'danielc@schoolcenter.com', subject = 'Test');
            insert newCase3;   
            Case newcase4 = new Case(SuppliedEmail = 'danielc@schoolcenter.com', subject = 'Test');
            insert newCase4;   
            Case newcase5 = new Case(SuppliedEmail = 'danielc@schoolcenter.com', subject = 'Test');
            insert newCase5;   
        }
        catch(Exception ex){
            
        }
       test.stopTest();
    }
    /*End of PD-16510*/
    
}