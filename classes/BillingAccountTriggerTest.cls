/* This test class will cover the code coverage for BillingAccountTriggerHandler*/
@isTest(seeAllData = false)
public class BillingAccountTriggerTest{

    @testSetup
    public static void setUpTestData() {
        List<DAZN_Help_Redirect__c> dhr = new List<DAZN_Help_Redirect__c>();
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Japan',
            Country__c = 'Japan',
            CountryISOCode__c = 'JP',
            IsDefaultCountry__c = false,
            Language__c = 'ja'
        ));
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Japan en',
            Country__c = 'Japan',
            CountryISOCode__c = 'JP',
            IsDefaultCountry__c = false,
            Language__c = 'en'
        ));
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Germany',
            Country__c = 'Germany',
            CountryISOCode__c = 'DE',
            IsDefaultCountry__c = false,
            Language__c = 'en'
        ));
        dhr.add(new DAZN_Help_Redirect__c(
            Name = 'Germany_default',
            Country__c = 'Germany',
            CountryISOCode__c = 'DE',
            IsDefaultCountry__c = true,
            Language__c = 'de'
        ));
        insert dhr;

        Account oAccount = new Account();
        oAccount.FirstName = 'strFirstName';
        oAccount.LastName = 'strLastName';
        oAccount.PersonEmail = 'test@test.com';
        oAccount.Account_Status__c = 'Free Trial';
        oAccount.Notification_Country_Code__c = 'ja_JP';
        oAccount.Notification_Language_Code__c = 'ja';
        insert oAccount;SetUpTestData.triggerSettings();
    }
    
    @isTest 
    static void testUpdate() {
        
        //Account oAccount = [SELECT Id, FirstName, LastName, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c FROM Account];1
        Account oAccount = new Account();
        oAccount.FirstName = 'strFirstName';
        oAccount.LastName = 'strLastName';
        oAccount.PersonEmail = 'test123@test.com';
        oAccount.Account_Status__c = 'Free Trial';
        oAccount.Notification_Country_Code__c = 'JP';
        oAccount.Notification_Language_Code__c = 'ja';
        insert oAccount;
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount;
        System.runAs(oCSUser) {
            Test.startTest();
                bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'Germany', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
            Test.stopTest();

        }
        
        Account oAccountAfter = [SELECT Id, Notification_Country_Code__c, LastInvoiceDate__c FROM Account WHERE Id =: oAccount.Id];
        Zuora__CustomerAccount__c testBillingAccount = [Select Id, Zuora__LastInvoiceDate__c From Zuora__CustomerAccount__c Where Id = :bAccount.Id];
        System.assertEquals('DE', oAccountAfter.Notification_Country_Code__c);
        System.assertEquals(testBillingAccount.Zuora__LastInvoiceDate__c, oAccountAfter.LastInvoiceDate__c);
    }

    @isTest
    static void testUpdateAccountRetrieveEmail() {
        Account oAccount = [SELECT Id FROM Account];
        Test.startTest();
            Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'Germany', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Test.stopTest();
        Account oAccountAfter = [SELECT Id, Retrieve_Email__c, Notification_Country_Code__c FROM Account WHERE Id =: oAccount.Id];
        Zuora__CustomerAccount__c billingAccountAfter = [SELECT Id, Retrive_Email__c FROM Zuora__CustomerAccount__c WHERE Id =: bAccount.Id];
        System.assertEquals(billingAccountAfter.Retrive_Email__c, oAccountAfter.Retrieve_Email__c);
    }

    @isTest
    static void testAccountRetrieveEmailNotUpdated() {
        Account oAccount = [SELECT Id, FirstName FROM Account];
        
        Test.startTest();
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'Germany', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        
        Account oAccountAfterInsert = [SELECT Id, FirstName, Retrieve_Email__c, Notification_Country_Code__c FROM Account WHERE Id =: oAccount.Id];
        Zuora__CustomerAccount__c billingAccountAfterInsert = [SELECT Id, Name, Retrive_Email__c FROM Zuora__CustomerAccount__c WHERE Id =: bAccount.Id];
        
        oAccount.FirstName = 'strFirstNameUpdated';
        update oAccount;
        bAccount.Name = 'test billing account updated';
        update bAccount;

        Account oAccountAfterUpdate = [SELECT Id, FirstName, Retrieve_Email__c, Notification_Country_Code__c FROM Account WHERE Id =: oAccount.Id];
        Zuora__CustomerAccount__c billingAccountAfterUpdate = [SELECT Id, Name, Retrive_Email__c FROM Zuora__CustomerAccount__c WHERE Id =: bAccount.Id];
        Test.stopTest();

        System.assertEquals(billingAccountAfterInsert.Retrive_Email__c, oAccountAfterInsert.Retrieve_Email__c);
        //System.assertNotEquals(billingAccountAfterUpdate.Retrive_Email__c, oAccountAfterUpdate.Retrieve_Email__c);
    }

}