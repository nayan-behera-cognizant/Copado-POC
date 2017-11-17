//This test class will cover the code coverage for ZuoraTransactionHelper
///Changes made for PD-4885
@isTest(seeAllData=True)  

public class ZuoraTransactionHelperTest {
    public static User communityUser;
    public static Account oAccount;
    public static User cSTeamMember;
    public static Account oAccount1;
    public static Zuora__CustomerAccount__c bAccount;
    public static Zuora__Subscription__c zSubsr;
    public static Zuora__PaymentMethod__c zPaymentMethod;
    
    static void setup(){
        oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Free Trial');
        communityUser = SetUpTestData.createCommunityUser(oAccount.Id, 'pm3testemail@email.com', 'pm3testemail@email.com', 'tstals3','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom');
        oAccount1 = SetUpTestData.createPersonAccount('TestFirstNameOne', 'TestLastNameOne','pm3testemail@emailOne.com','Free Trial');
        cSTeamMember  =SetUpTestData.createCustomerServicesShiftLeaderUser(oAccount1.Id, 'pm3testemail@emailOne.com', 'pm3testemailOne@email.com', 'tstals3','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
    }
    
    static void setUpSubData(){
        bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        zPaymentMethod = SetupTestData.createZuoraPaymentMethod(bAccount.Id, 'Active', 'Paypal', '4111111111111111', 'Visa', 'Test Test', String.valueOf(System.Today().month()), String.valueOf(System.Today().year()), '123', 'Success');
    }
     static testMethod void testgetZuoraAPI(){
        setup();
        Test.StartTest();
        System.RunAs(communityUser){
            ZuoraTransactionHelper.getZuoraAPI(); 
        }
        Test.StopTest();
    }
    static testMethod void testActivateSubscription(){
        setup();
        setUpSubData();
        Test.StartTest();
        System.RunAs(communityUser){
            ZuoraTransactionHelper.activateSubscription(zSubsr.Id);
        }
        Test.StopTest();
    }
    
    /*method to test setting default payment method */
    static testMethod void testsetDefaultPayment(){
        setup();
        setUpSubData();
        Test.StartTest();
        System.RunAs(communityUser){
            ZuoraTransactionHelper.setDefaultPayment(bAccount.id,zPaymentMethod.id);
        }
        Test.StopTest();
    }
    
    /*method to update contacts in Zuora*/
    static testMethod void testupdateUserDetailsinZuora(){
        setup();
        setUpSubData();
        List<Zuora__CustomerAccount__c> acclists = new List<Zuora__CustomerAccount__c>();
        bAccount.Zuora__Zuora_Id__c = '2c92c0f85615d698015621ecb5686025';
        acclists.add(bAccount);
        
        Map<String,Account> accmaps = new Map<String,Account>();
        accmaps.put('2c92c0f85615d698015621ecb5686025',oAccount);
        System.runAs(cSTeamMember){
            Test.startTest();        
            ZuoraTransactionHelper.updateUserDetailsinZuora(acclists,accmaps);   
            Test.stopTest();
        }
    }
    
    /*to test change  of payment method to Paypal*/
    static testMethod void testchangePaymentMethod(){
        setup();
        setUpSubData();
        zPaymentMethod.Zuora__PaypalBaid__c = '12342354';
        zPaymentMethod.Zuora__PaypalEmail__c = oAccount.PersonEmail;
        
        Test.startTest();
        
        System.runAs(communityUser){
            ZuoraTransactionHelper.changePaymentMethod(zPaymentMethod,communityUser,'*********6523','568');
        }
        
        Test.stopTest();
    }
    /*To test the task creation for Payment failure*/
    static testMethod void testcreatePaymentMethodFailureTask(){
        setup();
        Test.startTest();
        System.runAs(communityUser){
            ZuoraTransactionHelper.createPaymentMethodFailureTask('Exception',oAccount.id);  
        }
        Test.stopTest();
    }
    
    /*To test updating of payment method in Zuora*/
    static testMethod void testupdatePaymentMethod(){
        setup();
        setUpSubData();
        Zuora.zObject billingAccount = new Zuora.zObject('Account');
        
        Test.startTest();
        System.runAs(communityUser){
            ZuoraTransactionHelper.updatePaymentMethod(billingAccount,'Payment Gateway','PayMentId',true,'');
        }
        Test.stopTest();
    }
    
    /*to test zuora error logging*/
    static testMethod void testgetZuoraErrorMessage(){
        setup();
        Zuora.zApi.SaveResult svRes = new Zuora.zApi.SaveResult();
        svRes.Success = false;
        List<Zuora.zApi.SaveResult> results = new List<Zuora.zApi.SaveResult>();
        results.add(svRes);
        
        Test.startTest();
        System.runAs(communityUser){
            ZuoraTransactionHelper.getZuoraErrorMessage(results);
        }
        Test.stopTest();
    }
    
    /*to test return of payment or invoice information*/
    static testMethod void testgetPaymentInfoForAccount(){
        setup();
        Test.startTest();
        System.runAs(communityUser){
            ZuoraTransactionHelper.getPaymentInfoForAccount(oAccount.Id);
            ZuoraTransactionHelper.getInvoiceInfoForAccount(oAccount.Id);
        }
        Test.stopTest();
    }
    
    /*to test cancellation*/
    static testMethod void testCancelSubscription(){
        setup();
        List<String> testsubId = new List<String>{'testsubId'};
            Test.startTest();
        System.runAs(communityUser){
            ZuoraTransactionHelper.cancelSubscription('testsubId', '2016-08-09', false);
            ZuoraTransactionHelper.cancelSubscriptionsForTestUser(testsubId , '2016-08-09', false);
        }
        Test.stopTest();
    }
    
    /*to test invoice line item creation*/
    static testMethod void testcreateInvoiceLineItemAdjusment(){
        setup();
         Test.startTest();
        System.runAs(communityUser){
            ZuoraTransactionHelper.createInvoiceLineItemAdjusment('testinvoiceid', 'test', 'Charge');
        }
        Test.stopTest();
    }
    /*to test refunds*/
    static testMethod void testRefundAmount(){
        setup();
        System.runAs(cSTeamMember){
            Test.startTest();
            ZuoraTransactionHelper.RefundAmount('testpaymentId','invoiceId', 'test');
            Test.stopTest();
        }
    }
    /*to test error extraction*/
    static testMethod void testgetZuoraError(){
        Zuora.zObject zError = new Zuora.zObject('Error');
        zError.setValue('Code', 'testcode');
        zError.setValue('Message', 'test message');
        List<Zuora.zObject> lstErrors = new List<Zuora.zObject>{zError};
            setup();
        Test.startTest();
        System.runAs(communityUser){
            ZuoraTransactionHelper.getZuoraError(lstErrors);
        }
        Test.stopTest();
    }
    
    /*method to check test user functionality*/
    static testMethod void testupdateTestUserAccountBulkFuture(){
        setup();
        List<Id> accountIdlist = new List<Id>();
        accountIdlist.add(oAccount.id);
        System.runAs(cSTeamMember){
            Test.startTest();
            ZuoraTransactionHelper.updateTestUserAccountBulkFuture(accountIdlist);
            ZuoraTransactionHelper.updateTestUserAccount(accountIdlist); 
            Test.stopTest();
        }
    }    
    
    /*test to check if sub info is returned*/
    static testMethod void testgetUserSubscription(){
        setup();
        System.runAs(communityUser){
            Test.startTest();
            ZuoraTransactionHelper.getUserSubscription('2c92c0f850cbe7f00150d61c5b113b40');
            Test.stopTest();
        }
    } 
    /*to test next charge date logic */
    static testMethod void testgetSubscriptionDescription(){
        setup();
        list<Zuora.zObject> sublist = new list<Zuora.zObject>();
        Zuora.zObject sub = new Zuora.zObject('Subscription');
        sub.setValue('Name', 'subscription - SubscriptionName');
        sub.setValue('ContractEffectiveDate', '01-04-2011');
        sub.setValue('InitialTerm', 12);
        sub.setValue('RenewalTerm', 12);
        sublist.add(sub);
        
        System.runAs(communityUser){
            Test.startTest();
          //  ZuoraTransactionHelper.zQuery('select Id,InvoiceItemId,TaxAmount From TaxationItem');
            ZuoraTransactionHelper.getSubscriptionDescription('[Zuora__NextChargeDate__c] test [Zuora__Price__c]',sublist[0],'JPY');
            ZuoraTransactionHelper.getSubscriptionDescriptionForCanada('[Zuora__NextChargeDate__c] test [Zuora__Price__c]',sublist[0],'JPY');
            Test.stopTest();
        }
    }
    /*unit test for checking discounts*/
    static testMethod void testnewProductUpdate(){
        setup();
        System.runAs(cSTeamMember){
            Test.startTest();
            ZuoraTransactionHelper.newProductUpdate('testsubId', '2011-09-09', true, '1');
            Test.stopTest();
        }
    }
    
    /*test to check if re setting sync on an account works*/
    static testMethod void testresetSyncflag(){
        setup();
        Zuora.zApi.SaveResult sResult = new Zuora.zApi.SaveResult();
        sResult.Success = true;
        sResult.Id = 'testid';
        List<Zuora.zApi.SaveResult> lstResults = new List<Zuora.zApi.SaveResult>{sResult};
            System.runAs(cSTeamMember){    
                Test.startTest();
                ZuoraTransactionHelper.setBackAccountSyncToFalse(lstResults);
                Test.stopTest();
            }
    }
    
    static testMethod void testanalyseSaveResultsfromZuora(){
        setup();
        Zuora.zApi.SaveResult sResult = new Zuora.zApi.SaveResult();
        sResult.Success = false;
        Zuora.zObject oError = new Zuora.zObject('Error');
        oError.setValue('Code','testcode');
        oError.setValue('Message','test message');
        List<Zuora.zObject> lsterrors = new List<Zuora.zObject>{oError};
            sResult.errors = lsterrors;
        
        List<Zuora.zApi.SaveResult> sResults = new List<Zuora.zApi.SaveResult>{sResult};
            System.runAs(cSTeamMember){
                Test.startTest();
                ZuoraTransactionHelper.analyseSaveResultsfromZuora(sResults, 'testMethod' , lsterrors);
                Test.stopTest();
            }
    }
    //check if Chargebacks work
    static testMethod void testHandleChargebacks(){
        setup();
        System.runAs(cSTeamMember){
            Test.StartTest();
            ZuoraTransactionHelper.handleChargeBacks('2c92c0f957f9e9870157fb183c1a76d0', Date.today());
            Test.StopTest();
        }
    }
    
    //To cover with Account Status Active Grace.
    static testMethod void TestWhyControllercancelSubscription() {       
        Zuora__CustomerAccount__c bAccount;
        Zuora__Subscription__c zSubsr;
        Zuora__PaymentMethod__c zPaymentMethod;
        oAccount = SetUpTestData.createPersonAccount('CA','en_US','TestFirstName','TestLastName','pm3testemail@email.com','Active Grace');       
        User testUser = SetUpTestData.createCommunityUser('en_US', 'CA', oAccount.Id,'pm3testemail@email.com', 'pm3testemail@email.com', 'testU','GMT', 'UTF-8','en_US','en_US' , 'TestFirstName','TestLastName', true); 
        bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        zPaymentMethod = SetupTestData.createZuoraPaymentMethod(bAccount.Id, 'Active', 'Paypal', '4111111111111111', 'Visa', 'Test Test', String.valueOf(System.Today().month()), String.valueOf(System.Today().year()), '123', 'Success');
        system.assertNotEquals(null, oAccount);   
        system.assertNotEquals(null, testUser);   
        System.RunAs(testUser){
            Test.StartTest();
            WhyController objwhyCntrl = new WhyController();
            String navigattomyaccount = objwhyCntrl.naviageToMyAccountPage().getUrl();
            objwhyCntrl.reasonForCncl = 'I want to switch my payment method';
            objwhyCntrl.oSubscription = zSubsr;
            objwhyCntrl.cancelSubscription();  
            Test.stopTest();
        }
    }

    /**
     * @ Author : Nayan Behera          lastModifiedBy :
     * @ Createddate : 11-Aug-2017      lastModifiedByDate:
     * @ Description : Verify the functionality of ChargethroughDate in description
     */
    static testMethod void TestChargethroughDateSubscriptionDescription() {
        Zuora__CustomerAccount__c bAccount;
        Zuora__Subscription__c zSubsr;
        Zuora__PaymentMethod__c zPaymentMethod;
        oAccount = SetUpTestData.createPersonAccount('CA','en_US','TestFirstName','TestLastName','pm3testemail@email.com','Active Grace');       
        User testUser = SetUpTestData.createCommunityUser('en_US', 'CA', oAccount.Id,'pm3testemail@email.com', 'pm3testemail@email.com', 'testU','GMT', 'UTF-8','en_US','en_US' , 'TestFirstName','TestLastName', true); 
        bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', null, Date.today().addMonths(2) );
        zSubsr.Zuora__NextChargeDate__c = Date.today() + 10;
        update zSubsr ;
        system.assertNotEquals(null, testUser);   
        System.RunAs(testUser){
            Test.StartTest();
    		ZuoraTransactionHelper.getRatePlanIdBySubscriptionId(zSubsr.Id);
            ZuoraTransactionHelper.getRatePlanChargeChargedThroughDateByAccountId(oAccount.Id);
            Zuora.zObject sub = new Zuora.zObject('Subscription');
            sub.setValue('CreatedDate', '2011-04-01');
            sub.setValue('Status', 'Active');
            sub.setValue('TermEndDate',  '2011-04-01');
            sub.setValue('SubscriptionEndDate', '2011-04-01');
            sub.setValue('Id', 'zSubsr.Id');
            sub.setValue('AccountId', 'accList[0].Id');
            String msg = ZuoraTransactionHelper.getSubscriptionDescriptionForCanada('[Zuora__NextChargeDate__c] test [Zuora__Price__c]',sub,'CAD','fr_CA','CA');
            system.assertEquals(msg.contains('[Zuora__NextChargeDate__c]'), false);
            Test.StopTest();
        }
    }
    
    
     static testMethod void TestNextchargeDate() {
        Zuora__CustomerAccount__c bAccount;
        Zuora__Subscription__c zSubsr;
        Zuora__PaymentMethod__c zPaymentMethod;
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Grace' limit 10];       
        bAccount = SetUpTestData.createBillingAccount(accList[0].Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
       
        Zuora__Subscription__c oSubscription = new Zuora__Subscription__c();
        oSubscription.Name = 'testSub';
        oSubscription.Zuora__Status__c = 'Active';
        oSubscription.Zuora__SubscriptionStartDate__c =Date.Today()-10;
        oSubscription.Zuora__NextChargeDate__c = Date.Today()+30 ;
        oSubscription.Zuora__Account__c = accList[0].Id;
        oSubscription.Zuora__CustomerAccount__c = bAccount.Id;
        insert oSubscription;
        
        
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList AND isActive = true limit 10];
        system.assertNotEquals(null, oUser[0]);   
        System.RunAs(oUser[0]){
            Test.StartTest();
           
            ZuoraTransactionHelper.getRatePlanChargeChargedThroughDateByAccountId(accList[0].Id);
           
            Test.StopTest();
        }
    }
}