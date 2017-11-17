@isTest
public class DeactivateExpiredAccountUserTest {
    
    private static testMethod void checkRole() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('Test Rajesh', 'Test Reddy','WCTestNew1@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'WCTestNew1@test.com', 'WCTestNew1@test.com', 'wctstr1','Europe/London','ISO-8859-1','en_US','en_US','Test Rajesh','Test Reddy',true);
        Account oPersonAccountInfo =[SELECT  Owner.Name, owner.UserRoleId From Account Where Id=:oAccount.Id];
        DAZNConfiguration__c dznConfigHelpSectionURL = SetUpTestData.testCreateDAZNConfiguration('Role', 'Head of Customer Service'); 
        DAZNConfiguration__c dznConfigCSRoles = SetUpTestData.testCreateDAZNConfiguration('CS Roles', 'Customer Services Shift Leader DACH,Customer Services Team Leader DACH,Customer Services Regional Manager DACH,Customer Services Regional Manager Japan,Customer Services Team Leader Japan,Customer Services Shift Leader Japan'); 
        UserRole oUserRole = new UserRole(Id =oPersonAccountInfo.owner.UserRoleId,Name ='Head of Customer Service');
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
        Test.StartTest();
        system.runAs(oUser){
            Boolean result = DeactivateExpiredAccountUser.checkRole(oPersonAccountInfo.owner.UserRoleId);
            system.assertNotEquals(null, result);
        }
        Test.stopTest();
    }
    
    private static testMethod void executeDeactivateFreeTrialAccountUser() {
        SetUpTestData.triggerSettings();
        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'DAZN for Docomo', 'DAZN for Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        
        Account oAccount = SetUpTestData.createPersonAccount('Test Rajesh', 'Test Reddy','WCTestNew1@test.com','Free Trial');
        oAccount.All_Email_Preferences__c = true ;
        update oAccount ;
        System.assertEquals(true, oAccount.All_Email_Preferences__c);
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'anonymous12@livesport.com', 'anonymous12@livesport.com', 'wctstr1','Europe/London','ISO-8859-1','en_US','en_US','Test Rajesh','Test Reddy',true);
        SetUpTestData.testCreateDAZNConfiguration('EnviornmentName', 'LSDEV'); 
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
        Test.StartTest();
        DeactivateExpiredAccountUser.executeDeactivateAccountUser(oAccount.Id);
        Test.stopTest();
    }
    
    private static testMethod void executeDeactivateExpiredAccountUser() {
        SetUpTestData.triggerSettings();
        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'DAZN for Docomo', 'DAZN for Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        
        Account oAccount = SetUpTestData.createPersonAccount('Test Rajesh', 'Test Reddy','WCTestNew1@test.com','Expired');
        oAccount.All_Email_Preferences__c = true ;
        update oAccount ;
        System.assertEquals(true, oAccount.All_Email_Preferences__c);
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'anonymous12@livesport.com', 'anonymous12@livesport.com', 'wctstr1','Europe/London','ISO-8859-1','en_US','en_US','Test Rajesh','Test Reddy',true);
        SetUpTestData.testCreateDAZNConfiguration('EnviornmentName', 'LSDEV'); 
        Test.StartTest();
        DeactivateExpiredAccountUser.executeDeactivateAccountUser(oAccount.Id);
        Test.stopTest();
    }
    
    /*Added a part of PD-10582*/
    /*Method to test to deactivate Docomo Activepaid Account*/
    
    private static testMethod void executeDeactivateActivepaidDocomoAccount() {
        SetUpTestData.triggerSettings();
        SetUpTestData.testCreateDAZNConfiguration('EnviornmentName', 'LSDEV'); 
        
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        
        Account oAccount = SetUpTestData.createDfDAccount('Test Rajesh', 'Test Reddy','WCTestNew1@test.com','Active Paid', 'TestPartner123', 'Docomo');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'anonymous12@livesport.com', 'anonymous12@livesport.com', 'wctstr1','Europe/London','ISO-8859-1','en_US','en_US','Test Rajesh','Test Reddy',true);
        oUser.ViewerId__c = 'testViewer123';
        Test.StartTest();
        System.runAs(oCSUser){
            update oUser;
            DeactivateExpiredAccountUser.executeDeactivateAccountUser(oAccount.Id);
        }
        Test.stopTest();
    }
    
}