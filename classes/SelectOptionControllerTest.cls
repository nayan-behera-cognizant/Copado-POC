//This test class will cover the code coverage for SelectOptionController.
@IsTest
public class SelectOptionControllerTest{
    static testmethod void testSelectOption()
    {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Frozen');
        
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
       PageReference oPageReference = Page.Discount; 
        oPageReference.getParameters().put('id',oAccount.id); 
        Test.setCurrentPage(oPageReference); 
    
        Test.startTest();
        SelectOptionController oCancelSubscriptionBatch = new SelectOptionController();
        oCancelSubscriptionBatch.submit();
        System.assertEquals(true, oCancelSubscriptionBatch.flagForRecord);
        System.assertEquals(oAccount.Id, oCancelSubscriptionBatch.accountId);
        Test.stopTest();
    }
    
    static testmethod void testForCheckRole()
    {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('Test Rajesh', 'Test Reddy','WCTestNew1@test.com','Free Trial');
        User oUser = SetUpTestData.createCustomerServicesShiftLeaderUser(oAccount.Id, 'WCTestNew1@test.com', 'WCTestNew1@test.com', 'wctstr1','Europe/London','ISO-8859-1','en_US','en_US','Test Rajesh','Test Reddy',true);
        Account oPersonAccountInfo =[SELECT  Owner.Name, owner.UserRoleId From Account Where Id=:oAccount.Id];
        System.assertEquals(oAccount.Id, oPersonAccountInfo.Id);
        
        DAZNConfiguration__c dznConfigHelpSectionURL = SetUpTestData.testCreateDAZNConfiguration('CS_ShiftLeads_Roles', 'Customer Services Team Leader DACH');    
        UserRole oUserRole = [Select id,name from UserRole where Name = 'Customer Services Team Leader DACH'];
        oPersonAccountInfo.owner.UserRoleId = oUserRole.Id;
        update oPersonAccountInfo;     
        System.assertEquals(oUserRole.Id, oPersonAccountInfo.owner.UserRoleId);
        
        Test.StartTest();
        system.runAs(oUser){
            Boolean result = SelectOptionController.checkRoleForCSLeads(oPersonAccountInfo.owner.UserRoleId);
            system.assertEquals(result,true);
        }
        Test.stopTest();
    }
}