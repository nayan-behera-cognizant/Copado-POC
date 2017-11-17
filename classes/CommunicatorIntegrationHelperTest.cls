/**
* @author Cognizant Technology Solutuions
* @date 14/04/2016
* @description Test class to cover communicator integration helper functionality.
*/
/*Added Assert statements as per PD-7938*/

@isTest
public class CommunicatorIntegrationHelperTest{
    
    
    /*
Description: Setup required data.
*/
    @testSetup
    public static void setData(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail99@email.com','Active Paid');
        system.Assertnotequals(oAccount.Id, null);
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail99@email.com', 'testusername335@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true, 'Japan');
        system.Assertnotequals(oUser.Id, null);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        system.Assertnotequals(bAccount.Id, null);
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        zSubsp.Zuora__TermSettingType__c = 'TERMED';
        zSubsp.Zuora__MRR__c = 9.99;
        zSubsp.Zuora__TCV__c = 9.99;
        zSubsp.Zuora__SubscriptionStartDate__c = Date.today();
        zSubsp.NumGiftPeriods__c = '1';
        zSubsp.NumFreeTrialPeriods__c = '1'; 
        update zSubsp;
        system.Assertnotequals(zSubsp.Id, null);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        system.Assertnotequals(zInv.Id, null);
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
        system.Assertnotequals(zPay.Id, null);
        //create custom setting data
        List<DAZNCommunicatorConfig__c> lstCustomSetting = new List<DAZNCommunicatorConfig__c>();
        List<DAZNConfiguration__c> lstConfig = new List<DAZNConfiguration__c>();
        
        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'test.salesforce.com');
        SetUpTestData.testCreateDAZNConfiguration('EncryptionKey', '160ab450f9c22gb1');
        SetUpTestData.testCreateDAZNConfiguration('CommunicatorAPIUserName', 'test');
        SetUpTestData.testCreateDAZNConfiguration('CommunicatorAPIUserPwd', 'oL9IBIKPqWGSvVXHuhKawxjDx/PhfrWZGHjsKrMA/J8=');
        
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_User_Cancel_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Updated_Name_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Updated_Password_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Forgotten_Password_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Partial_Welcome_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Free_Trial_Welcome_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Hard_Offer_Welcome_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Successful_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Failure_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Subscription_End_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_New_Device_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Updatation_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Expiry_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Contacts_Table_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='MailingList_Transactional_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SalesForceID_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Email_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='FirstName_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='LastName_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SubscriptionEndDate_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Currency_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SubscriptionAmount_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='PlanDetails_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='PaymentMethodType_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='FreeTrialEndDate_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='AccountStatus_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='NotificationLanguageCode_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='NotificationCountryCode_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='CountryLanguage_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SignInLink_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Germany_Marketing_Mailing_List_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Marketing_Germany_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='UnsubscribeLanguage_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='CommunicatorAPITimeOutLimit',Value__c=60000));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Marketing_Mailing_List_ID',Value__c=63500)); 
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Inactive_Device_DE_en_GB',Value__c=60000));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID Double optin',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Set_Edit_Pause_Confirmation',Value__c=12330));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Cancelling_Scheduled_Pause',Value__c=12331));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_EditingRestartDate_In_Pause',Value__c=12332));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Welcome_Back_From_Pause',Value__c=12333));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Free_Trial_Welcome',Value__c=12334));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_User_Cancel',Value__c=12336));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Hard_Offer_Welcome',Value__c=12337));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Failure',Value__c=12338));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Successful',Value__c=12339));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Free_Trial_Welcome_Termed',Value__c=12340));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Hard_Offer_Welcome_Termed',Value__c=12341));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Updated_Name',Value__c=12342));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Updated_Payment',Value__c=12343));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Immediate_Cancellation',Value__c=12344));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Paused_Cancellation',Value__c=13345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Failed_User_Frozen',Value__c=13346));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Apple_Free_Trial_Welcome',Value__c=22341));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Roku_Free_Trial_Welcome',Value__c=22342));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Apple_Hard_Offer_Welcome',Value__c=23343));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Roku_Hard_Offer_Welcome',Value__c=23344));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Gift_Code_Success',Value__c=23345));
        lstConfig.add(new DAZNConfiguration__c(name='DoubleOptInCountries',Value__c='DE,AT'));
        // added new 
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Docomo_MarketingMailingListID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Docomo_Contact_Table_ID',Value__c=21345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DFD_SalesforceColumnID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DfdColumnID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='HardOfferDateTime_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='ResetPasswordURL_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Previous_Status_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Status_Change_Date_Column_ID',Value__c=12345));

        insert lstCustomSetting;
        insert lstConfig;
        
        SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD','$');

        //--- PD-11495 start ---
        oAccount.Account_Status__c = 'Partial';
        oAccount.Hard_Offer_Date__c = System.Date.today().addDays(1);
        update oAccount;
        system.assertnotequals(oAccount, null);

        Account oAccount2 = SetUpTestData.createPersonAccount('TestFirstName2', 'TestLastName2','test2@test2.com','Active Paid');
        oAccount2.LastName = 'TestLastName3';
        update oAccount2;

        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.PersonEmail = 'testemail99@email.com' LIMIT 1
        ];
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Hard_Offer_Date__c = System.Date.today().addDays(1);
            emailSyncQueues[0].Notification_Country_Code__c = 'DE';
            update emailSyncQueues[0];
        }

        List<Email_Sync_Queue__c> emailSyncQueues2 = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName3' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues2.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues2.isEmpty()) {
            emailSyncQueues2[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID Double optin').Value__c);
            emailSyncQueues2[0].Type_of_Email__c = 'Triggered Dispatch';
            update emailSyncQueues2[0];
        }
        //--- PD-11495 end ---
    }
    
    /*
Description: Test method to test the user details update notification functionlity.
*/
    public static testMethod void testSendUserDetailsUpdateNotification1(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id, AccountId, ContactId, email, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        test.startTest();
        CommunicatorIntegrationHelper.sendUserDetailsUpdateNotification(oUser.AccountId, oUser.ContactId, oUser.email, 'Updated_Name', 'en_GB', 'JP');
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendUserDetailsUpdateNotification' ];
        
    }
   
    /*
Description: Test method to test the user details update notification functionlity.
*/
    public static testMethod void testSendUserDetailsUpdateNotification2(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, ContactId, email, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        test.startTest();
        CommunicatorIntegrationHelper.sendUserDetailsUpdateNotification(oUser.AccountId, oUser.ContactId, oUser.email, 'Updated_Password', 'en_GB', 'JP');
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendUserDetailsUpdateNotification' ];
        
    }
    public static testMethod void testSendUserDetailsUpdateNotificationException(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, ContactId, email, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        test.startTest();
        CommunicatorIntegrationHelper.sendUserDetailsUpdateNotification(oUser.AccountId, oUser.ContactId, oUser.email, 'Updated_Password', 'Test', 'Test');
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendUserDetailsUpdateNotification' ];
        
    }
    /*
Description: Test method to test the user details update notification functionlity.
*/
    /* Commented out according to PD-13009:
    public static testMethod void testSendUserDetailsUpdateNotificationBulk(){
        Map<String,List<Account>> mapAccount = new Map<String,List<Account>>();
        List<Account> lstAccount = new List<Account>();
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        Account oAccount = [SELECT Id, PersonContactId, PersonEmail, FirstName, LastName, Notification_Language_Code__c, Notification_Country_Code__c  FROM Account WHERE PersonEmail = 'testemail99@email.com'];
        system.assertnotequals(oAccount,null);
        lstAccount.add(oAccount);
        mapAccount.put('JP_en_GB', lstAccount);
        
        test.startTest();
        CommunicatorIntegrationHelper.sendUserDetailsUpdateNotification(mapAccount, 'Updated_Name');
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendUserDetailsUpdateNotification' ];
        
    }*/
    
    /*
Description: Test method to test the subscription cancellation email notification functionality.
*/
    public static testMethod void testSendCancelledSubsriptionNotification(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id ,AccountId, ContactId, email, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        test.startTest();
        CommunicatorIntegrationHelper.sendCancelledSubsriptionNotification(oUser.AccountId, oUser.ContactId, oUser.email , System.Now().addDays(10), 'en_GB', 'JP');
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendCancelledSubsriptionNotification' ];
        
    }
    
    /*
Description: Test method to test the partial email notfication functionality.
*/
    public static testMethod void testSendPartialWelcomeNotification(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.firstName          = oUser.FirstName;
        objWrap.AccountCurrency    ='$';
        objWrap.SubscriptionAmt    = '100';
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        objWrap.DeviceName = 'TestDevice';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('JP_en_GB', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendPartialWelcomeNotification(mapSubscriptionEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendPartialWelcomeNotification' ];
        
    }
    
    /*
Description: Test method to test the free trial welecome email notfication functionality.
*/
    public static testMethod void testSendFreeTrialWelcomeNotification(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.firstName          = oUser.FirstName;
        objWrap.AccountCurrency    ='$';
        objWrap.SubscriptionAmt    = '100';
        objWrap.PlanDetails    = 'Free Trial';
        objWrap.PaymentType    = '100';
        objWrap.EndDate    = System.Now().addDays(10);
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('JP_en_GB', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendFreeTrialWelcomeNotification(mapSubscriptionEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendFreeTrialWelcomeNotification' ];
        
    }
     public static testMethod void testSendFreeTrialWelcomeNotificationException(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.firstName          = oUser.FirstName;
        objWrap.AccountCurrency    ='$';
        objWrap.SubscriptionAmt    = '100';
        objWrap.PlanDetails    = 'Free Trial';
        objWrap.PaymentType    = '100';
        objWrap.EndDate    = System.Now().addDays(10);
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('Test', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendFreeTrialWelcomeNotification(mapSubscriptionEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendFreeTrialWelcomeNotification' ];
        
    }
    /*
Description: Test method to test the hard offer welecome email notfication functionality.
*/
    /* - commented out according to PD-12083
    public static testMethod void testSendHardOfferWelcomeNotification(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.firstName          = oUser.FirstName;
        objWrap.AccountCurrency    ='$';
        objWrap.SubscriptionAmt    = '100';
        objWrap.PlanDetails    = 'Hard offer';
        objWrap.PaymentType    = '100';
        objWrap.EndDate    = System.Now().addDays(10);
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('JP_en_GB', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendHardOfferWelcomeNotification(mapSubscriptionEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendHardOfferWelcomeNotification' ];
        
    }
     public static testMethod void testSendHardOfferWelcomeNotificationException(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.firstName          = oUser.FirstName;
        objWrap.AccountCurrency    ='$';
        objWrap.SubscriptionAmt    = '100';
        objWrap.PlanDetails    = 'Hard offer';
        objWrap.PaymentType    = '100';
        objWrap.EndDate    = System.Now().addDays(10);
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('Test', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendHardOfferWelcomeNotification(mapSubscriptionEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendHardOfferWelcomeNotification' ];
        
    }*/
    /*
Description: Test method to test the payment expirty notification functionality.
*/
    public static testMethod void testSendPaymentExpiryNotification(){
        
        Map<String,List<User>> mapUser = new Map<String,List<User>>();
        List<User> lstUser = new List<User>();
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id, AccountId, ContactId, email, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        lstUser.add(oUser);
        
        mapUser.put('JP_en_GB', lstUser);
        test.startTest();
        CommunicatorIntegrationHelper.sendPaymentExpiryNotification(mapUser);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendPaymentExpiryNotification' ];
        
    }
    
    /*
Description: Test method to test the payment updation notification functionality.
*/
    public static testMethod void testSendPaymentUpdation(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, contactId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.contactId          = oUser.contactId;
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('JP_en_GB', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendPaymentUpdation(mapSubscriptionEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendPaymentUpdation' ];
        
    }
    
    /*
Description: Test method to test the payment failure notification functionality.
*/
    /* - commented out according to PD-12533
    public static testMethod void testSendPaymentFailureNotification(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('JP_en_GB', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendPaymentFailureNotification(mapSubscriptionEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendPaymentFailureNotification' ];
        
    }
    public static testMethod void testSendPaymentFailureNotificationException(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('test', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendPaymentFailureNotification(mapSubscriptionEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendPaymentFailureNotification' ];
        
    }*/
    /*
     Description: Test method to test the payment success notification functionality.
    */
    /* Commented out according to PD-12615:
    public static testMethod void testSendSuccessfulPaymentNotification(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('JP_en_GB', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendSuccessfulPaymentNotification(mapSubscriptionEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendSuccessfulPaymentNotification' ];
        
    }
    public static testMethod void testSendSuccessfulPaymentNotificationException(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('Test', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendSuccessfulPaymentNotification(mapSubscriptionEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendSuccessfulPaymentNotification' ];
        
    }*/
    /*
Description: Test method to test the new device notification functionality.
*/
    public static testMethod void testsendNewDeviceConnected(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, LanguageLocaleKey, CountryCode, firstName from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        map<string, List<WrapCommunicatorEmail>> mapNewDeviceEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapNewDeviceEmail.put('JP_en_GB', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendNewDeviceConnected(mapNewDeviceEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendNewDeviceConnected' ];
        
    }
    public static testMethod void testsendNewDeviceConnectedException(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, LanguageLocaleKey, CountryCode, firstName from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        map<string, List<WrapCommunicatorEmail>> mapNewDeviceEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapNewDeviceEmail.put('Test', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendNewDeviceConnected(mapNewDeviceEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendNewDeviceConnected' ];
        
    }
    /*
Description: Test method to test the subscription end notification functionality.
*/
    /* - commented out according to PD-12102
    public static testMethod void testSendSubscriptionEndNotification(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('JP_en_GB', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendSubscriptionEndNotification(mapSubscriptionEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendSubscriptionEndNotification' ];
        
    }
    public static testMethod void testSendSubscriptionEndNotificationException(){
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('Test', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendSubscriptionEndNotification(mapSubscriptionEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendSubscriptionEndNotification' ];
        
    }*/
    /*
     Description: Test method to upsert accounts in communicator from salesfore.
    */
    /* Commented out according to PD-11495:
    public static testMethod void testUpsertAccountInformationInCommunicator() {
        
        Account oAccount1 = SetUpTestData.createPersonAccountWithCountryCode('TestFirstName1', 'TestLastName1','test1@test.com','Free Trial','JP');
        oAccount1.Hard_Offer_date__c = system.now();
        update oAccount1;
        Account oAccount2 = SetUpTestData.createPersonAccountWithCountryCode('TestFirstName2', 'TestLastName2','test2@test.com','Active Paid','DE');
        oAccount2.Hard_Offer_date__c = system.now();
        update oAccount2;
        system.assertnotequals(oAccount1,null);
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        List<Account> lstAccount = new List<Account>();
        lstAccount.add(oAccount1);
        lstAccount.add(oAccount2);
        
        test.startTest();
        CommunicatorIntegrationHelper.upsertAccountInformationInCommunicator(lstAccount);
        test.stopTest();
        
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id, Exception_Message__c,StackTrace_Message__c from Exception_Log__c where Method_Name__c='upsertAccountInformationInCommunicator' ];
        system.assertnotequals(lstException,null);
        
    }*/
    
    /*
     Description: Test method to test the double optin notification functionlity.
    */
    /* Commented out according to PD-11495:
    public static testMethod void testSendDoubleOptInEmail(){
        Map<String,List<User>> mapUser = new Map<String,List<User>>();
        List<User> lstUser = new List<User>();
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id, AccountId, ContactId, LanguageLocaleKey, CountryCode, email  from user where Email ='testemail99@email.com'];
        lstUser.add(oUser);
        System.assertNotEquals(null, lstUser.size()>0);
        
        mapUser.put('JP_en_GB', lstUser);
        
        test.startTest();
        CommunicatorIntegrationHelper.sendDoubleOptInEmail(mapUser);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendDoubleOptInEmail' ];
        
    }*/
    /* Commented out according to PD-11495:
	public static testMethod void testSendDoubleOptInEmailException(){
        Map<String,List<User>> mapUser = new Map<String,List<User>>();
        List<User> lstUser = new List<User>();
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id, AccountId, ContactId, LanguageLocaleKey, CountryCode, email  from user where Email ='testemail99@email.com'];
        lstUser.add(oUser);
        System.assertNotEquals(null, lstUser.size()>0);
        
        mapUser.put('Test', lstUser);
        
        test.startTest();
        CommunicatorIntegrationHelper.sendDoubleOptInEmail(mapUser);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendDoubleOptInEmail' ];
        
    }*/
    public static testMethod void testSendInactiveDeviceNotification(){
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        System.assertNotEquals(null, oUser);
        oUser.CountryCode = 'DE';
        oUser.LanguageLocaleKey = 'en_GB';
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();                
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'DE';
        objWrap.RebillDate = System.Now().addDays(10);
        objWrap.SignInLink = 'SignInLink';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('DE_en_GB', lstWrap);
        test.startTest();        
        CommunicatorIntegrationHelper.sendInactiveDeviceNotification(mapSubscriptionEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendInactiveDeviceNotification' ];
        
    }
	public static testMethod void testSendInactiveDeviceNotificationException(){
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        System.assertNotEquals(null, oUser);
        oUser.CountryCode = 'DE';
        oUser.LanguageLocaleKey = 'en_GB';
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();                
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'DE';
         lstwrap.add(objWrap);
        mapSubscriptionEmail.put('Test', lstWrap);
        test.startTest();        
        CommunicatorIntegrationHelper.sendInactiveDeviceNotification(mapSubscriptionEmail);
        test.stopTest();
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id from Exception_Log__c where Method_Name__c='sendInactiveDeviceNotification' ];
        
    }
    /* - commented out according to PD-12102
    public static testMethod void testsendCancelledSubsriptionNotificationforStandard(){
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();    
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.firstName          = oUser.FirstName;
        objWrap.AccountCurrency    ='$';
        objWrap.SubscriptionAmt    = '100';
        objWrap.PlanDetails    = 'sendCancelledSubsriptionNotificationforStandard';
        objWrap.PaymentType    = '100';
        objWrap.EndDate    = System.Now().addDays(10);
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('JP_en_GB', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendCancelledSubsriptionNotificationforStandard(mapSubscriptionEmail);
        test.stopTest();
        
    }    
	 public static testMethod void testsendCancelledSubsriptionNotificationforStandardException(){
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        User oUser = [Select id , AccountId, email, firstName, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();    
        objWrap.id                 = oUser.AccountId;
        objWrap.email              = oUser.Email;
        objWrap.firstName          = oUser.FirstName;
        objWrap.AccountCurrency    ='$';
        objWrap.SubscriptionAmt    = '100';
        objWrap.PlanDetails    = 'sendCancelledSubsriptionNotificationforStandard';
        objWrap.PaymentType    = '100';
        objWrap.EndDate    = System.Now().addDays(10);
        objWrap.NotificaitonLanguageCode = 'en_GB';
        objWrap.NotificationCountryCode = 'JP';
        lstwrap.add(objWrap);
        mapSubscriptionEmail.put('test', lstWrap);
        test.startTest();
        CommunicatorIntegrationHelper.sendCancelledSubsriptionNotificationforStandard(mapSubscriptionEmail);
        test.stopTest();
        
    }*/
    //to cover future methods
    public static testmethod void testFutureMethods(){
        User oUser = [Select id, AccountId, ContactId, email, LanguageLocaleKey, CountryCode from user where Email ='testemail99@email.com'];
        system.assertnotequals(oUser,null);
        CommunicatorIntegrationHelper.doCallOutNameUpdateFromFuture(oUser.AccountId, oUser.ContactId, oUser.email, 'en_GB', 'JP');
        CommunicatorIntegrationHelper.doCallOutPasswordUpdateFromFuture(oUser.AccountId, oUser.ContactId, oUser.email, 'en_GB', 'JP'); 
        CommunicatorIntegrationHelper.doCallOutCancelledSubscriptionFromFuture(oUser.AccountId, oUser.ContactId, oUser.email , System.Now().addDays(10), 'en_GB', 'JP');   
        
    }
    
  // to cover exceptions
    public static testmethod void testSendExceptions(){
        Map<String,List<User>> mapUser = new Map<String,List<User>>();
        List<User> lstUser = new List<User>();
         // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        User oUser = [Select id, AccountId, ContactId, LanguageLocaleKey, CountryCode, email  from user where Email ='testemail99@email.com'];
        lstUser.add(oUser);
        System.assertNotEquals(null, lstUser.size()>0);
        mapUser.put(' ', lstUser);
        test.startTest();
        //CommunicatorIntegrationHelper.sendDoubleOptInEmail(mapUser); Commented out according to PD-11495
        CommunicatorIntegrationHelper.sendPaymentExpiryNotification(mapUser);
        test.stopTest();
     }  
/*
Description: Test method to upsert DFD accounts in communicator from salesfore.
*/
	 
    public static testMethod void testUpsertAccountInformationInCommunicatorDFD(){
        
        Account oAccount1 = SetUpTestData.createPersonAccountWithCountryCodeDFD('TestFirstName1', 'TestLastName1','test1@test.com','Frozen','JP',true,'pdi123','Docomo','ja',true,true,true);
        /*oAccount1.Type = 'Docomo';
        oAccount1.All_Email_Preferences__c = true;
        oAccount1.IsReadyToSyncInCommunicator__c = true; */
        oAccount1.Hard_Offer_date__c  = system.now();
        update oAccount1;
        Account oAccount2 = SetUpTestData.createPersonAccountWithCountryCodeDFD('TestFirstName2', 'TestLastName2','test2@test.com','Frozen','JP',true,'pdi123','Docomo','ja',true,true,true);
        /*oAccount2.Type = 'Docomo';
        oAccount2.All_Email_Preferences__c = true;
        oAccount2.IsReadyToSyncInCommunicator__c = true;*/
        oAccount2.Hard_Offer_date__c  = system.now();
        update oAccount2;
        system.assertnotequals(oAccount1,null);
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        List<Account> lstAccount = new List<Account>();
        lstAccount.add(oAccount1);
        lstAccount.add(oAccount2);
        
        test.startTest();
        //CommunicatorIntegrationHelper.upsertAccountInformationInCommunicatorDfd(lstAccount);
        test.stopTest();
        
        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select id, Exception_Message__c,StackTrace_Message__c from Exception_Log__c where Method_Name__c='upsertAccountInformationInCommunicatorDfd' ];
        system.assertnotequals(lstException,null);
    }

    //--- PD-7603 start ---
    public static testMethod void testDoCallOutResetPasswordFromFuture(){
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());

        User oUser = [Select Id, AccountId, ContactId, FirstName, Email, LanguageLocaleKey, CountryCode From User Where Email = 'testemail99@email.com'];
        System.assertNotEquals(oUser,null);

        Test.startTest();
        CommunicatorIntegrationHelper.doCallOutResetPasswordFromFuture(oUser.AccountId, oUser.ContactId, oUser.FirstName, '/ChangePassword', 'en_GB', 'JP');
        Test.stopTest();

        List<Exception_Log__c> lstException = new List<Exception_Log__c>();
        lstException = [Select Id From Exception_Log__c Where Method_Name__c = 'sendResetPasswordNotification'];
        
    }
    //--- PD-7603 end ---

    //--- PD-11495 start ---
    @isTest
    public static void testHandleEmailSyncRecordsSuccessDoubleOptIn() {
        DAZNConfiguration__c setting = new DAZNConfiguration__c(
            Name = 'DoubleOptInCountries',
            Value__c = 'Germany,DE,Austria,AT,Switzerland,CH'
        );
        insert setting;
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }

    @isTest
    public static void testHandleEmailSyncRecordsSuccessSetEditPause() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName3' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Set_Edit_Pause_Confirmation').Value__c);
            emailSyncQueues[0].Pause_From__c = System.today().addDays(1);
            emailSyncQueues[0].Pause_Until__c = System.today().addDays(2);
            update emailSyncQueues[0];
        }
        
        DAZNConfiguration__c setting = new DAZNConfiguration__c(
            Name = 'DoubleOptInCountries',
            Value__c = 'Germany,DE,Austria,AT,Switzerland,CH'
        );
        insert setting;
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }

    @isTest
    public static void testHandleEmailSyncRecordsSuccessCancellingScheduledPause() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Rebill_Date__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName3' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Cancelling_Scheduled_Pause').Value__c);
            emailSyncQueues[0].Pause_From__c = System.today().addDays(1);
            emailSyncQueues[0].Pause_Until__c = System.today().addDays(2);
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Rebill_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Plan_Details__c = 'TestPlanDetails';
            update emailSyncQueues[0];
        }
        
        DAZNConfiguration__c setting = new DAZNConfiguration__c(
            Name = 'DoubleOptInCountries',
            Value__c = 'Germany,DE,Austria,AT,Switzerland,CH'
        );
        insert setting;
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Rebill_Date__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }

    @isTest
    public static void testHandleEmailSyncRecordsSuccessEditingRestartDateInPause() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName3' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_EditingRestartDate_In_Pause').Value__c);
            emailSyncQueues[0].Pause_From__c = System.today().addDays(1);
            emailSyncQueues[0].Pause_Until__c = System.today().addDays(2);
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Plan_Details__c = 'TestPlanDetails';
            update emailSyncQueues[0];
        }
        
        DAZNConfiguration__c setting = new DAZNConfiguration__c(
            Name = 'DoubleOptInCountries',
            Value__c = 'Germany,DE,Austria,AT,Switzerland,CH'
        );
        insert setting;
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }

    @isTest
    public static void testHandleEmailSyncRecordsSuccessWelcomeBackFromPause() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName3' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Welcome_Back_From_Pause').Value__c);
            emailSyncQueues[0].Pause_From__c = System.today().addDays(1);
            emailSyncQueues[0].Pause_Until__c = System.today().addDays(2);
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Plan_Details__c = 'TestPlanDetails';
            update emailSyncQueues[0];
        }
        
        DAZNConfiguration__c setting = new DAZNConfiguration__c(
            Name = 'DoubleOptInCountries',
            Value__c = 'Germany,DE,Austria,AT,Switzerland,CH'
        );
        insert setting;
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }

    @isTest
    public static void testHandleEmailSyncRecordsFreeTrialWelcome() {
        SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD','$');
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Free_Trial_Welcome').Value__c);
            emailSyncQueues[0].Account_Currency__c = 'USD';
            emailSyncQueues[0].Subscription_Amount__c = 34.534;
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Pause_From__c = System.today().addDays(1);
            emailSyncQueues[0].Pause_Until__c = System.today().addDays(2);
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Plan_Details__c = 'TestPlanDetails';
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            emailSyncQueues[0].Rebill_Date__c = System.today().addDays(1);
            update emailSyncQueues[0];
            
            List<Zuora__CustomerAccount__c> billAcc = [
                SELECT Id
                FROM Zuora__CustomerAccount__c
                WHERE Zuora__Account__c =: emailSyncQueues[0].Account__c LIMIT 1
            ];
            if (!billAcc.isEmpty()) {
                Zuora__PaymentMethod__c zPaymentMethod = SetupTestData.createZuoraPaymentMethod(
                    billAcc[0].Id,
                    'Active',
                    'CreditCard',
                    '4111111111111111',
                    'Visa',
                    'Test Test',
                    String.valueOf(System.Today().month()),
                    String.valueOf(System.Today().year()),
                    '123',
                    'Success'
                );
                billAcc[0].Zuora__DefaultPaymentMethod__c = zPaymentMethod.Id;
                update billAcc[0];
            }
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Rebill_Date__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
        List<Email_Sync_Queue__c> emailSyncQueuesCompleted = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Rebill_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Completed' AND Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueuesCompleted.isEmpty());
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsFreeTrialWelcomeWithoutCardExpiry() {
        SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD','$');
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Free_Trial_Welcome').Value__c);
            emailSyncQueues[0].Account_Currency__c = 'USD';
            emailSyncQueues[0].Subscription_Amount__c = 34.534;
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Pause_From__c = System.today().addDays(1);
            emailSyncQueues[0].Pause_Until__c = System.today().addDays(2);
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Plan_Details__c = 'TestPlanDetails';
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            emailSyncQueues[0].Rebill_Date__c = System.today().addDays(1);
            update emailSyncQueues[0];
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Rebill_Date__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }
    

    @isTest
    public static void testHandleEmailSyncRecordsHardOfferWelcome() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName3' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Hard_Offer_Welcome').Value__c);
            emailSyncQueues[0].Pause_From__c = System.today().addDays(1);
            emailSyncQueues[0].Pause_Until__c = System.today().addDays(2);
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Plan_Details__c = 'TestPlanDetails';
            update emailSyncQueues[0];
        }
        
        DAZNConfiguration__c setting = new DAZNConfiguration__c(
            Name = 'DoubleOptInCountries',
            Value__c = 'Germany,DE,Austria,AT,Switzerland,CH'
        );
        insert setting;
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }

    @isTest
    public static void testHandleEmailSyncRecordsUserCancel() {
        SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD','$');
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_User_Cancel').Value__c);
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            update emailSyncQueues[0];
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }

    @isTest
    public static void testHandleEmailSyncRecordsPaymentFailure() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Payment_Failure').Value__c);
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            update emailSyncQueues[0];
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }

    @isTest
    public static void testHandleEmailSyncRecordsPaymentSuccessful() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Payment_Successful').Value__c);
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            update emailSyncQueues[0];
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsFreeTrialWelcomeAnnual() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Account__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method

        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Free_Trial_Welcome_Termed').Value__c);
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            update emailSyncQueues[0];
            
            List<Zuora__CustomerAccount__c> billAcc = [
                SELECT Id
                FROM Zuora__CustomerAccount__c
                WHERE Zuora__Account__c =: emailSyncQueues[0].Account__c LIMIT 1
            ];
            if (!billAcc.isEmpty()) {
                Zuora__PaymentMethod__c zPaymentMethod = SetupTestData.createZuoraPaymentMethod(
                    billAcc[0].Id,
                    'Active',
                    'CreditCard',
                    '4111111111111111',
                    'Visa',
                    'Test Test',
                    String.valueOf(System.Today().month()),
                    String.valueOf(System.Today().year()),
                    '123',
                    'Success'
                );
                billAcc[0].Zuora__DefaultPaymentMethod__c = zPaymentMethod.Id;
                update billAcc[0];
            }
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
        List<Email_Sync_Queue__c> emailSyncQueuesCompleted = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Rebill_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Completed' AND Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueuesCompleted.isEmpty());
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsFreeTrialWelcomeAnnualWithoutCardExpiry() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Account__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method

        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Free_Trial_Welcome_Termed').Value__c);
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            update emailSyncQueues[0];
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsHardOfferWelcomeAnnual() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Email_Name__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = 0;
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            emailSyncQueues[0].Email_Name__c = 'Hard Offer Welcome';
            update emailSyncQueues[0];
            
            List<Zuora__CustomerAccount__c> billAcc = [
                SELECT Id
                FROM Zuora__CustomerAccount__c
                WHERE Zuora__Account__c =: emailSyncQueues[0].Account__c LIMIT 1
            ];
            if (!billAcc.isEmpty()) {
                Zuora__PaymentMethod__c zPaymentMethod = SetupTestData.createZuoraPaymentMethod(
                    billAcc[0].Id,
                    'Active',
                    'CreditCard',
                    '4111111111111111',
                    'Visa',
                    'Test Test',
                    String.valueOf(System.Today().month()),
                    String.valueOf(System.Today().year()),
                    '123',
                    'Success'
                );
                billAcc[0].Zuora__DefaultPaymentMethod__c = zPaymentMethod.Id;
                update billAcc[0];
            }
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
        List<Email_Sync_Queue__c> emailSyncQueuesCompleted = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Rebill_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Completed' AND Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueuesCompleted.isEmpty());
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsHardOfferWelcomeApple() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Email_Name__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = 0;
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            emailSyncQueues[0].Email_Name__c = 'Hard Offer Welcome';
            update emailSyncQueues[0];
            List<Zuora__CustomerAccount__c> billAcc = [
                SELECT Id
                FROM Zuora__CustomerAccount__c
                WHERE Zuora__Account__c =: emailSyncQueues[0].Account__c LIMIT 1
            ];
            if (!billAcc.isEmpty()) {
                Zuora__PaymentMethod__c zPaymentMethod = SetupTestData.createZuoraPaymentMethod(
                    billAcc[0].Id,
                    'Active',
                    'CreditCard',
                    '4111111111111111',
                    'Visa',
                    'Test Test',
                    String.valueOf(System.Today().month()),
                    String.valueOf(System.Today().year()),
                    '123',
                    'Success'
                );
                billAcc[0].Zuora__DefaultPaymentMethod__c = zPaymentMethod.Id;
                update billAcc[0];
            }
            List<Zuora__Subscription__c> subscriptions = [
                SELECT Id, SourceSystem__c
                FROM Zuora__Subscription__c 
                WHERE Zuora__Status__c = 'Active' AND Zuora__Account__c = :emailSyncQueues[0].Account__c
                ORDER BY Zuora__SubscriptionStartDate__c DESC NULLS LAST
            ];
            if (!subscriptions.isEmpty()) {
                subscriptions[0].SourceSystem__c = 'Apple';
                update subscriptions[0];
            }
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
        List<Email_Sync_Queue__c> emailSyncQueuesCompleted = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Rebill_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Completed' AND Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueuesCompleted.isEmpty());
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsHardOfferWelcomeRoku() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Email_Name__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = 0;
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            emailSyncQueues[0].Email_Name__c = 'Hard Offer Welcome';
            update emailSyncQueues[0];
            List<Zuora__CustomerAccount__c> billAcc = [
                SELECT Id
                FROM Zuora__CustomerAccount__c
                WHERE Zuora__Account__c =: emailSyncQueues[0].Account__c LIMIT 1
            ];
            if (!billAcc.isEmpty()) {
                Zuora__PaymentMethod__c zPaymentMethod = SetupTestData.createZuoraPaymentMethod(
                    billAcc[0].Id,
                    'Active',
                    'CreditCard',
                    '4111111111111111',
                    'Visa',
                    'Test Test',
                    String.valueOf(System.Today().month()),
                    String.valueOf(System.Today().year()),
                    '123',
                    'Success'
                );
                billAcc[0].Zuora__DefaultPaymentMethod__c = zPaymentMethod.Id;
                update billAcc[0];
            }
            List<Zuora__Subscription__c> subscriptions = [
                SELECT Id, SourceSystem__c
                FROM Zuora__Subscription__c 
                WHERE Zuora__Status__c = 'Active' AND Zuora__Account__c = :emailSyncQueues[0].Account__c
                ORDER BY Zuora__SubscriptionStartDate__c DESC NULLS LAST
            ];
            if (!subscriptions.isEmpty()) {
                subscriptions[0].SourceSystem__c = 'Roku';
                update subscriptions[0];
            }
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
        List<Email_Sync_Queue__c> emailSyncQueuesCompleted = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Rebill_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Completed' AND Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueuesCompleted.isEmpty());
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsGiftCodeSuccess() {
        SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD','$');
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Gift_Code_Success').Value__c);
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            emailSyncQueues[0].Term_Setting_Type__c = 'EVERGREEN';
            emailSyncQueues[0].Account_Currency__c = 'USD';
            update emailSyncQueues[0];
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c,
                Rebill_Date__c, Gift_Code_Expiry_Date__c, Term_Setting_Type__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }
        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
        List<Email_Sync_Queue__c> emailSyncQueuesCompleted = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Rebill_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Completed' AND Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueuesCompleted.isEmpty());
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsHardOfferWelcomeAnnualWithoutCardExpiry() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Email_Name__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = 0;
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            emailSyncQueues[0].Email_Name__c = 'Hard Offer Welcome';
            update emailSyncQueues[0];
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsHardOfferWelcomeAnnualRetried() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Account__c, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Email_Name__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            List<Zuora__Subscription__c> subscriptions = [
                SELECT Id, Zuora__External_Id__c, Zuora__Account__c, Zuora__MRR__c, Zuora__TermSettingType__c
                FROM Zuora__Subscription__c 
                WHERE Zuora__Status__c = 'Active' AND Zuora__Account__c = :emailSyncQueues[0].Account__c
                ORDER BY Zuora__SubscriptionStartDate__c DESC NULLS LAST
            ];
            if (!subscriptions.isEmpty()) {
                subscriptions[0].Zuora__TermSettingType__c = null;
                update subscriptions[0];
            }
            emailSyncQueues[0].Dispatch_ID__c = 0;
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            emailSyncQueues[0].Email_Name__c = 'Hard Offer Welcome';
            update emailSyncQueues[0];
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c 
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }
        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
        List<Email_Sync_Queue__c> emailSyncQueues2 = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c 
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Retried' AND Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues2.isEmpty());
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsHardOfferWelcomeAnnualFailed() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Account__c, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Email_Name__c, Status__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            List<Zuora__Subscription__c> subscriptions = [
                SELECT Id, Zuora__External_Id__c, Zuora__Account__c, Zuora__MRR__c, Zuora__TermSettingType__c
                FROM Zuora__Subscription__c 
                WHERE Zuora__Status__c = 'Active' AND Zuora__Account__c = :emailSyncQueues[0].Account__c
                ORDER BY Zuora__SubscriptionStartDate__c DESC NULLS LAST
            ];
            if (!subscriptions.isEmpty()) {
                subscriptions[0].Zuora__TermSettingType__c = null;
                update subscriptions[0];
            }
            emailSyncQueues[0].Dispatch_ID__c = 0;
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            emailSyncQueues[0].Email_Name__c = 'Hard Offer Welcome';
            emailSyncQueues[0].Status__c = 'Retried';
            update emailSyncQueues[0];
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
        List<Email_Sync_Queue__c> emailSyncQueues3 = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Failed' AND Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues3.isEmpty());
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsUpdateName() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Email_Name__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Updated_Name').Value__c);
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            emailSyncQueues[0].Email_Name__c = 'Update Name';
            update emailSyncQueues[0];
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsUpdatedPayment() {
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c, Email_Name__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Updated_Payment').Value__c);
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            emailSyncQueues[0].Email_Name__c = 'Update Payment';
            update emailSyncQueues[0];
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsUserImmediateCancellation() {
        SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD','$');
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Immediate_Cancellation').Value__c);
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            update emailSyncQueues[0];
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsPausedCancellation() {
        SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD','$');
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Paused_Cancellation').Value__c);
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            update emailSyncQueues[0];
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsPaymentFailedUserFrozen() {
        SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD','$');
        List<Email_Sync_Queue__c> emailSyncQueues = [
            SELECT Id, Dispatch_ID__c, Type_of_Email__c, Pause_From__c, Pause_Until__c
            FROM Email_Sync_Queue__c
            WHERE Account__r.LastName = 'TestLastName' LIMIT 1
        ];
        System.assertEquals(true , !emailSyncQueues.isEmpty()); // Test UpdateAccountTriggerHandler.createEmailSyncQueueRecords() method
        if (!emailSyncQueues.isEmpty()) {
            emailSyncQueues[0].Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getValues('DispatchID_Payment_Failed_User_Frozen').Value__c);
            emailSyncQueues[0].Payment_Method_Type__c = 'Credit Type';
            emailSyncQueues[0].Free_Trial_End_Date__c = System.today().addDays(3);
            emailSyncQueues[0].Type_of_Email__c = 'Triggered Dispatch';
            update emailSyncQueues[0];
        }
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Success', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }
    
    @isTest
    public static void testHandleEmailSyncRecordsFailure() {
        DAZNConfiguration__c setting = new DAZNConfiguration__c(
            Name = 'DoubleOptInCountries',
            Value__c = 'Germany,DE,Austria,AT,Switzerland,CH'
        );
        insert setting;
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Failure', accountIds));
        Test.startTest();
            System.AssertNotEquals(CommunicatorIntegrationHelper.getLastMonthDay('08/2017'), null);
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }

    @isTest
    public static void testHandleEmailSyncRecordsException() {
        DAZNConfiguration__c setting = new DAZNConfiguration__c(
            Name = 'DoubleOptInCountries',
            Value__c = 'Germany,DE,Austria,AT,Switzerland,CH'
        );
        insert setting;
        List<Email_Sync_Queue__c> emailSyncRecords = [
            SELECT Id, Account__c, Account_Currency__c, Account_Status__c, All_Email_Preferences__c, Dispatch_ID__c, First_Name__c, Free_Trial_End_Date__c,
                Hard_Offer_Date__c, Is_Double_Opt_in__c, Last_Name__c, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Method_Type__c,
                Person_Email__c, Plan_Details__c, Status__c, Subscription_Amount__c, Subscription_End_Date__c, Type_of_Email__c, Unsubscribe_Language__c,
                Pause_From__c, Pause_Until__c, Sync_Error_Msg__c, Email_Name__c, Account__r.Previous_Status__c, Account__r.Status_Change_Date__c
            FROM Email_Sync_Queue__c
            WHERE Status__c = 'Not Started' OR Status__c = 'Retried'
        ];
        List<Email_Sync_Queue__c> dataImportEmailQueueList = new List<Email_Sync_Queue__c>();
        List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList = new List<Email_Sync_Queue__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Email_Sync_Queue__c emailSyncQueue : emailSyncRecords) {
            accountIds.add(emailSyncQueue.Account__c);
            if (emailSyncQueue.Type_of_Email__c == 'Data Import') {
                dataImportEmailQueueList.add(emailSyncQueue);
            } else if (emailSyncQueue.Type_of_Email__c == 'Triggered Dispatch') {
                triggeredDispatchEmailQueueList.add(emailSyncQueue);
            }
        }

        Test.setMock(WebServiceMock.class, new ComunicatorMockHandleEmailSync('Exception', accountIds));
        Test.startTest();
            CommunicatorIntegrationHelper.handleEmailSyncRecords(dataImportEmailQueueList, triggeredDispatchEmailQueueList);
        Test.stopTest();
    }

    public class ComunicatorMockHandleEmailSync implements WebServiceMock {
        public String type;
        public Set<Id> accountIds;
        public ComunicatorMockHandleEmailSync(final String type, Set<Id> accountIds) {
            this.type = type;
            this.accountIds = accountIds;
        }
        public void doInvoke(
               Object stub,
               Object request,
               Map<String, Object> response,
               String endpoint,
               String soapAction,
               String requestName,
               String responseNS,
               String responseName,
               String responseType) {

            DataService.DataImporterResponse_element responseActual = new DataService.DataImporterResponse_element();
            DataService.DataImportResponse respElement = new DataService.DataImportResponse();
            DataService.ArrayOfDataImportResponseDetail ImportDetailsArr = new DataService.ArrayOfDataImportResponseDetail();
            
            DataService.DataImportResponseDetail detail = new DataService.DataImportResponseDetail();
            List<DataService.DataImportResponseDetail> lstDetail = new List<DataService.DataImportResponseDetail>();
            if (type == 'Success') {
                detail.Row = 1;
                detail.Result ='SuccessUpdating';
                detail.Response ='Mock response';
                lstDetail.add(detail);
            }
            if (type == 'Failure') {
                List<DataService.ColumnMapping> lstColumnMapping = new List<DataService.ColumnMapping>();
                for (Id accountId : accountIds) {
                    DataService.ColumnMapping oColumnMap = new DataService.ColumnMapping();
                    oColumnMap.ColumnId = 12345; // need to be the same as value of DAZNCommunicatorConfig__c.getValues('SalesForceID_Column_ID').Value__c
                    oColumnMap.Value = accountId;
                    lstColumnMapping.add(oColumnMap);
                }
                detail.Row = 1;
                detail.Result ='ForeignKeyViolation';
                detail.Response ='An attempt to violate a unique Foreign Key column constraint was made';

                DataService.ArrayOfColumnMapping arrColumnMapping = new DataService.ArrayOfColumnMapping();
                arrColumnMapping.ColumnMapping = lstColumnMapping;
                detail.Mappings = arrColumnMapping;

                lstDetail.add(detail);
            }
            if (type == 'Exception') {
                CalloutException e = new CalloutException();
                e.setMessage('Validation Error(s) occurred during SOAP request.');
                throw e;
            }
            ImportDetailsArr.DataImportResponseDetail = lstDetail;
            respElement.ImportDetails = ImportDetailsArr;
            responseActual.DataImporterResult = respElement;
            response.put('response_x', responseActual); 
       }
    }
    //--- PD-11495 end ---
    
}