@isTest
public class BatchSendPaymentExpiryNotificationTest{
    public static String CRON_EXP = '0 1 * * * ?';
    
    /*
        Description: Setup required data.
    */
    @testSetup
    public static void setData(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
        system.AssertnotEquals(oAccount ,null);
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true);
        system.AssertnotEquals(oAccount.Id,null);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        system.AssertnotEquals(oAccount.Id,null);
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        system.AssertnotEquals(bAccount.Id,null);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        system.AssertnotEquals(bAccount.Id,null);
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
        system.AssertnotEquals(zInv.Id,null);
        Zuora__PaymentMethod__c zPaymentMethod = SetupTestData.createZuoraPaymentMethod(bAccount.Id, 'Active', 'CreditCard', '4111111111111111', 'Visa', 'Test Test', String.valueOf(System.Today().month()), String.valueOf(System.Today().year()), '123', 'Success');
        system.AssertnotEquals(bAccount.Id,null);
        zPaymentMethod.Zuora__DefaultPaymentMethod__c = true;
        update zPaymentMethod;
        
        //create custom setting data        
        List<DAZNCommunicatorConfig__c> lstCustomSetting = new List<DAZNCommunicatorConfig__c>();
        List<DAZNConfiguration__c> lstConfig = new List<DAZNConfiguration__c>();
        
        lstConfig.add(new DAZNConfiguration__c(name='LoginPageURL', Value__c='test.salesforce.com'));
        lstConfig.add(new DAZNConfiguration__c(name='CommunicatorAPIUserName', Value__c='test'));
        lstConfig.add(new DAZNConfiguration__c(name='CommunicatorAPIUserPwd', Value__c='test'));
        insert lstConfig;
                
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Expiry_en_GB',Value__c=12345));
        insert lstCustomSetting;    
    }
    
    @isTest
    public static void testExpiryNotification(){
     Test.startTest();

        // Schedule the test job
        String jobId = System.schedule('scheduleExpiryNotification', CRON_EXP, new scheduleExpiryNotification());
         
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();   
        
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendPaymentExpiryNotification' ];
        system.assert(lstException.isEmpty());  
    }
}