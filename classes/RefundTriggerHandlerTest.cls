/**
* @author Cognizant Technology Solutuions
* @date 14/04/2016
* @description Test class to cover Refund trigger and handler functionality
*/
@isTest
public class RefundTriggerHandlerTest{    
    /*
Description: Test method to test the Refund trigger and handler .
*/
    public static testMethod void testrefundReleatedAccountUpdate(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName ','TestNew1@test.com','Free Trial');
        System.assertNotEquals(null, oAccount.Id);
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'TestNew1@test.com', 'TestNew1@test.com', 'tsnewtr1','Europe/London','ISO-8859-1','en_GB','en_GB','TestFirstName','TestLastName',true);
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        Zuora__Refund__c zurObj1 = SetupTestData.createZuoraRefund(oAccount.Id, oCustAccount.Id, 'External','Payment Reversal',10.00);
        list<Zuora__Refund__c> zurRefundList = new list<Zuora__Refund__c> ();
        zurRefundList.add(zurObj1);
        Zuora__Refund__c zurObj2 = SetupTestData.createZuoraRefund(oAccount.Id, oCustAccount.Id, 'Electronic','Payment Reversal',10.00);
        zurRefundList.add(zurObj2);
        update zurRefundList;
        System.assert(zurRefundList.size()>0);
        zurObj2.Zuora__Type__c = 'External';
        update zurObj2;      
        test.startTest();
        refundTriggerHandler.updateRelatedAccount(zurRefundList);
        test.stopTest();
    }
    /* Method when  trigger is disabled*/
    public static testMethod void testrefund(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        TriggerSetting__c trigSet= TriggerSetting__c.getInstance('ZuoraRefundTrigger');
        trigSet.Disable__c=true;
        Update trigSet;
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName ','TestNew1@test.com','Free Trial');
        System.assertNotEquals(null, oAccount.Id);
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'TestNew1@test.com', 'TestNew1@test.com', 'tsnewtr1','Europe/London','ISO-8859-1','en_GB','en_GB','TestFirstName','TestLastName',true);
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        Zuora__Refund__c zurObj1 = SetupTestData.createZuoraRefund(oAccount.Id, oCustAccount.Id, 'External','Payment Reversal',10.00);
        list<Zuora__Refund__c> zurRefundList = new list<Zuora__Refund__c> ();
        zurRefundList.add(zurObj1);
        Zuora__Refund__c zurObj2 = SetupTestData.createZuoraRefund(oAccount.Id, oCustAccount.Id, 'Electronic','Payment Reversal',10.00);
        zurRefundList.add(zurObj2);
        update zurRefundList;
        System.assert(zurRefundList.size()>0);
        zurObj2.Zuora__Type__c = 'External';
        update zurObj2;      
        test.startTest();
        refundTriggerHandler.updateRelatedAccount(zurRefundList);
        test.stopTest();
    }
}