@isTest
public class GiftInfoSectionControllerTest {
    
    static testMethod void testUpdateAccount() {
        TriggerSetting__c triggerSet1 = new TriggerSetting__c(name ='BillingAccountTrigger', Disable__c = false);
        insert triggerSet1;
        TriggerSetting__c triggerSet2 = new TriggerSetting__c(name ='UpdateAccountTrigger', Disable__c = false);
        insert triggerSet2;
        TriggerSetting__c triggerSet3 = new TriggerSetting__c(name ='SubscriptionTrigger', Disable__c = false);
        insert triggerSet3;
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Cancelled', System.today(), system.today() + 30);
        zSubsp.Zuora__SubscriptionStartDate__c =  system.today() + 1;
        zSubsp.Zuora__SubscriptionEndDate__c = system.today() + 2;
        zSubsp.CampaignID__c = 'TestCampaignID';
        zSubsp.Free_Trial_End_Date__c = system.today() + 2;
        zSubsp.Giftcode__c = 'TestGiftcode';
        zSubsp.Gift_Code_End_Date__c = system.today() + 2;
        zSubsp.NumFreeTrialPeriods__c = '3';
        zSubsp.NumGiftPeriods__c = '3';
        update zSubsp;
        
        PageReference giftInfoSectionPage = Page.GiftInfoSection;
        Test.setCurrentPage(giftInfoSectionPage);
        Test.startTest();
            GiftInfoSectionController controller = new GiftInfoSectionController(new ApexPages.StandardController(oAccount));
        Test.stopTest();
        List<Zuora__Subscription__c> subs = [
            SELECT Id,
                CampaignID__c,
                Free_Trial_End_Date__c,
                Gift_Code_End_Date__c,
                Gift_Code_Start_Date__c,
                Giftcode__c,
                Gift_Code_Status__c,
                NumFreeTrialPeriods__c,
                NumGiftPeriods__c
            FROM Zuora__Subscription__c
            WHERE Zuora__Account__c =: oAccount.id
        ];
        System.assertEquals(true, controller.giftInfo != null);
        System.assertEquals(true, controller.giftInfo.giftCode != null);
        System.assertEquals(true, controller.giftInfo.giftCodeStartDate != null);
        System.assertEquals(true, controller.giftInfo.giftCodeCampaignID != null);
        System.assertEquals(true, controller.giftInfo.giftCodeEndDate != null);
        System.assertEquals(true, controller.giftInfo.giftCodeStatus != null);
        System.assertEquals(true, controller.giftInfo.freeTrialEndDate != null);
        System.assertEquals(true, controller.giftInfo.numGiftPeriods != null);
        System.assertEquals(true, controller.giftInfo.numFreeTrials != null);
    }
    
}