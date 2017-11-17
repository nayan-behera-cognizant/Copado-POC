@isTest
private class TransitionAccountToFrozenKeyDateTest {
	
	static testMethod void testKeyDate() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        
        bAccount.Zuora__Zuora_Id__c = 'TestFF123';
        update bAccount;
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

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/KeyDate';
        req.requestBody = Blob.valueof('<?xml version="1.0" encoding="UTF-8"?><callout><parameter name="AccountID">'+ bAccount.Zuora__Zuora_Id__c +'</parameter></callout>');
        req.httpMethod = 'POST';
        RestContext.request = req;
        
        String accountId = TransitionAccountToFrozenKeyDateCallout.endSubscriptionPost();
        System.assertEquals(bAccount.Zuora__Zuora_Id__c, accountId);
        
        List<Account> lstAccount = [Select Account_Status__c from Account where Id =: oAccount.Id limit 1];
        System.assertEquals('Frozen', lstAccount[0].Account_Status__c);
        
        Test.StopTest();
    }
}