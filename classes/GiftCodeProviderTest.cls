@isTest
private class GiftCodeProviderTest {
	
	@isTest static void testCreateGiftCodeHistory() {
		SetUpTestData.triggerSettings();
		Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'te@test.com', 'Free Trial');
		Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD', '1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Test Zuora', 'Active', System.today(), System.today() + 30);

		RestRequest req = new RestRequest();
		req.requestURI = '/GiftCodeProvider';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
        	'{ '+
            '    "Workflow": { '+
            '        "ExecutionDate": "2017-09-23", '+
            '        "GiftCode": "GiftCodedkadjsfladj", '+
            '        "CampaignName": "string", '+
            '        "ProcessId": "ProcessIDdfasdfads", '+
            '        "UpToPeriods": 2, '+
            '        "SubscriptionName": "' + zSubsp.Name + '", '+
            '        "ProductRatePlanChargeId": "2c92c0f9587b0ad001588c6a447257ca", '+
            '        "CallbackUrl": "CallbackURL", '+
            '        "RegionOrigin": "EU", '+
            '        "ProductRatePlanId": "2c92c0f85bf61f6b015bfc3ebcd6179a", '+
            '        "VoucherCodeEffectiveDate":"2017-09-20" '+
            '    } '+
            '}'
        );
        RestContext.request = req;

		Test.startTest();
		String res = GiftCodeProvider.createGiftCodeHistory();
		System.assertEquals('Success', res);
		Test.stopTest();

		System.assertEquals(1, [Select Id From Gift_Code_History__c].size());
		System.assertEquals(1, [Select Id From API_Log__c].size());
	}
	
}