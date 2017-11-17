/**
* @author Cognizant Technology Solutuions
* @date 1/02/2015
* @description Test class to cover update Account trigger handler functionality.
*/
@isTest(SeeAllData = false)
public class UpdateAccountTriggerTest{
    
    /*Added as a part of PD-7829*/
    public static User createProfile(String profileName){
        
        list<Profile> pList = [SELECT id, Name FROM Profile where name =: profileName limit 1 ];
        
        //verify the size of the profile list 
        System.assertEquals(1, pList.size() );
        
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId;
        uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
        //list<User> alistUser =new list<User>();
        User aUser =new User(  firstname = 'Test',
                             lastName = 'Member'+uniqueName,
                             email = 'TestMember'+uniqueName + '@test' +'.com',
                             Username = 'TestMember' + uniqueName+'@test'+ '.org',
                             EmailEncodingKey = 'ISO-8859-1',
                             Alias = 'Memeber',
                             TimeZoneSidKey = 'America/Los_Angeles', 
                             LocaleSidKey = 'en_US',
                             LanguageLocaleKey = 'en_US',
                             isActive =true,
                             ProfileId = pList[0].id );
        
        insert aUser;
        System.assertEquals('Test', aUser.FirstName);
        return aUser;
    }
    /*Description: Test method to verify the functionality of trigger when trigger settings are disabled*/
    public static testMethod void testTriggerSettings(){
        SetUpTestData.triggerSettings();
        TriggerSetting__c oTrigSetting = TriggerSetting__c.getInstance('UpdateAccountTrigger');
        oTrigSetting.Disable__c = true;
        update oTrigSetting;
        System.assertEquals(true, TriggerSetting__c.getInstance('UpdateAccountTrigger').Disable__c);
        Account oAccount= SetUpTestData.createPersonAccount('TestFirstName1', 'TestLastName1','test@test1.com','Free Trial');
        /*Updating the Email of the account to test the trigger settings disable functionality*/
        Test.startTest();
        oAccount.PersonEmail = 'Testtriggersettings@test.com';
        update oAccount;
        Test.stopTest(); 
    }
    
    
    /*
Description: Test method to verify email already exist validation.
*/
    public static testMethod void testCheckDuplicateEmail() {
        SetUpTestData.createDAZNConfigurations();
        try{
            SetUpTestData.triggerSettings();
            List<Account> lstAcc = new List<Account>();
                        
            Account oAccount1 = new Account();
            oAccount1.FirstName = 'TestFirst1';
            oAccount1.LastName = 'TestLast1';
            oAccount1.PersonEmail = 'TestLast1@gmail.com';
            oAccount1.Account_Status__c = 'Free Trial';
            oAccount1.All_Email_Preferences__c = false;
            oAccount1.Disable_all_transactional_emails__c  = false;
            insert oAccount1;
            
            Account oAccount2 = new Account();
            oAccount2.FirstName = 'TestFirst2';
            oAccount2.LastName = 'TestLast2';
            oAccount2.PersonEmail = 'TestLast2@gmail.com';
            oAccount2.All_Email_Preferences__c = false;
            oAccount2.Disable_all_transactional_emails__c  = false;
            oAccount2.Account_Status__c = 'Free Trial';
            insert oAccount2;
            
            oAccount2.PersonEmail = 'TestLast3@gmail.com';
            Update oAccount2;
            
            oAccount1.PersonEmail = 'TestLast3@gmail.com';
            //update oAccount1;
            Database.SaveResult[] srList = Database.update(new List<Account> {oAccount1}, false);
            
            Test.startTest();
            Test.stopTest();
        }
        catch(Exception e)
        {
            String message = e.getMessage();
            System.assert(message.contains( Label.LS_MyAccount_ErrMsg_EmailIDExists), 'message=' + message);
        }
    }
    
    /*
Description: Test method to verify user name, email update.
*/
    public static testMethod void testUpdateUserRecord() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        
        SetUpTestData.createDAZNConfigurations();

        List<string> lstAcc = new List<String>();
        Account oAccount1 = SetUpTestData.createPersonAccount('TestFirstName', 'TestLName','testemailur1@email.com','Free Trial');
        oAccount1.FirstName='TestFName';
        oAccount1.Type = 'Apple';
        lstAcc.add(oAccount1.id);
        System.assert(lstAcc.size()>0);
        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'DAZN for Docomo', 'DAZN for Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        
       
        User cUser = SetUpTestData.createCommunityUser(lstAcc[0], 'testemailur1@email.com', 'testemailur1@email.com.ls', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        User oProfileUser = createProfile('LiveSport Team Member');
        System.assertNotEquals(null, oProfileUser.Id);
        
        
        System.runAs (oProfileUser) {
            test.startTest();
            update oAccount1;
            UpdateAccountTriggerHandler.updateUser(lstAcc);
            test.stopTest();
        }
        
        User oUser = [select id ,Username,FirstName,LastName,Email from User where AccountId = : lstAcc[0] ];
        
        String usernameConfiguration = (DAZNConfiguration__c.getValues('LS_UserName_Configuration') != null) ? DAZNConfiguration__c.getValues('LS_UserName_Configuration').Value__c : null;

        Account oAcc = [select id ,FirstName,LastName,PersonEmail from Account where Id = : lstAcc[0] ];
        system.assertEquals(oUser.FirstName,oAcc.FirstName);
        system.assertEquals(oUser.LastName ,oAcc.LastName);
        system.assertEquals(oUser.Email ,oAcc.PersonEmail);
        system.assertEquals(oUser.Username ,oAcc.PersonEmail+ '.' + usernameConfiguration);
        List<User> users = [Select ID From User Where Id =: UserInfo.getUserId()];
        if (!users.isEmpty()) {
            UpdateAccountTriggerHandler.authSessionDeletion(JSON.serialize(users));
        }
    }
    
    public static testMethod void testUpdateUserRecordException() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();

        SetUpTestData.createDAZNConfigurations();

        List<string> lstAcc = new List<String>();
        Account oAccount1 = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName',null ,'Free Trial');
        lstAcc.add(oAccount1.id);     
        User cUser = SetUpTestData.createCommunityUser(lstAcc[0], 'testemailur1@email.com', 'testemailur1@email.com.ls', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        User oProfileUser = createProfile('LiveSport Team Member');
        System.assertNotEquals(null, oProfileUser.Id);
        
        System.runAs (oProfileUser) {
            test.startTest();
            UpdateAccountTriggerHandler.updateUser(lstAcc);
            test.stopTest();
        }  
    }
    
    /*
Description: Test method to verify and cover the name change notification functionality.
*/
    public static testMethod void testNameChangeNotification(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        SetUpTestData.testCreateDAZNConfiguration('DoubleOptInCountries', 'United Kingdom');
        SetUpTestData.createDAZNConfigurations();


        List<Account> lstUpdatedAccount = new List<Account>();
        Account oAccount1 = SetUpTestData.createPersonAccount('TestFirstNames1lsdev', 'TestLastNames1','tests@test1.com','Free Trial');
        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'DAZN for Docomo', 'DAZN for Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        
       
        string randomName = string.valueof(Datetime.now()).replace('-','').replace(':','').replace(' ','');
        User oUser1 = SetUpTestData.createCommunityUser(oAccount1.Id, 'testpsafd1@test1.com', 'testpsafd1@email.com.ls', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFirstNames1','TestLastNames1',true);
        
        oAccount1.FirstName = 'TestFirstName11';
        oAccount1.LastName = 'TestLastName11';
        oAccount1.Type = 'Docomo';
        oAccount1.Partner_ID__c = '123';
        lstUpdatedAccount.add(oAccount1);
        System.assert(lstUpdatedAccount.size()>0);
        
        List<Account> lstAccount = [Select id from Account where personemail in ('test@test1.com')];
        list<String> lstAccountId = new list<String>();
        for(Account oAccount : lstAccount){
            lstAccountId.add(oAccount.Id);
        }
        
        User oProfileUser = createProfile('LiveSport Team Member');
        System.assertNotEquals(null, oProfileUser.Id);
        
        System.runAs (oProfileUser) {
            test.startTest();
            update lstUpdatedAccount;
            UpdateAccountTriggerHandler.updateUser(lstAccountId);
            //UpdateAccountTriggerHandler.sendNameChangeNotification(lstAccountId); - Commented out according to PD-13009
            test.stoptest(); 
        }
        
        List<User> lstUser = [select id, AccountId ,Username, FirstName,LastName,Email from User where AccountId in:(lstAccountId)];
        for(User oUser: lstUser){
            if(oUser.AccountId == oAccount1.Id){
                system.assertEquals(oUser.FirstName,oAccount1.FirstName);
                system.assertEquals(oUser.LastName ,oAccount1.LastName); 
            }
        }
    }
    
    
    /*
Description: Test method to verify subscription welcome email functionality for active paid customer.
*/
    public static testMethod void testSubscriptionWelcomeEmailForActivePaidCustomer(){
        DAZN_Country_Currency_ISO_Code__c isoUSD = new DAZN_Country_Currency_ISO_Code__c();
        isoUSD.name = 'USD';
        isoUSD.CurrencySymbol__c = '$';
        insert isoUSD;
        System.assertEquals('USD', isoUSD.name);
        
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        SetUpTestData.testCreateDAZNConfiguration('DoubleOptInCountries', 'United Kingdom');
        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', '/LoginPageURL');
        Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
            Name = 'Docomo',
            Partner_Type__c = 'Docomo',
            Page_Name__c = 'PartnerAccount.page',
            Subscription_Type_Heading_Text__c = 'Docomo',
            Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
            Payment_History_URL__c = 'https://www.google.com',
            Cancel_Subscription_URL_Small__c = 'https://www.google.com',
            Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
            Cancel_Subscription_URL_Large__c = 'https://www.google.com',
            Change_password_email__c = '123',
            Double_opt_in_email__c = '123',
            Name_change_email__c = '123',
            Payment_success_email__c = '123',
            Updated_payment_method_email__c = '123'

        );
        insert pac;

        SetUpTestData.createDAZNConfigurations();

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName ','TestNew1@test.com','Frozen');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'TestNew1@test.com', 'testlsut1@email.com.ls', 'tsnewtr1','Europe/London','ISO-8859-1','en_GB','en_GB','TestFirstName','TestLastName',true);
        oAccount.Notification_Language_Code__c = 'en_GB';
        update oAccount;
        
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        List<Account> lstUpdatedAccount = new List<Account>();
        oAccount.Account_Status__c = 'Active Paid';
        lstUpdatedAccount.add(oAccount);
        System.assert(lstUpdatedAccount.size()>0);
        
        List<Account> lstAccount = [Select id from Account where personemail in ('TestNew1@test.com')];
        list<String> lstAccountId = new list<String>();
        for(Account oAcc : lstAccount){
            lstAccountId.add(oAcc.Id);
        }
        System.assert(lstAccountId.size()>0);
        
        User oProfileUser = createProfile('System Administrator');
        System.assertNotEquals(null, oProfileUser.Id);
        
        System.runAs (oProfileUser) {
            test.startTest();
            update lstUpdatedAccount;
            UpdateAccountTriggerHandler.createHardOfferWelcomeEmailQueueRecords(lstAccountId);
            test.stoptest(); 
        }
    }
    
    /*
Description: Test method to verify subscription welcome email functionality for active paid customer DACH.
*/
    public static testMethod void testSubscriptionWelcomeEmailForActivePaidCustomerDACH(){
        DAZN_Country_Currency_ISO_Code__c isoUSD = new DAZN_Country_Currency_ISO_Code__c();
        isoUSD.name = 'GBP';
        isoUSD.CurrencySymbol__c = '?';
        insert isoUSD;
        System.assertEquals('GBP', isoUSD.name);
        
        Payment_Method__c oPayment = new Payment_Method__c();
        oPayment.Name = 'Bank Transfer';
        oPayment.German__c = 'LastSchrift';
        insert oPayment;
        System.assertEquals('Bank Transfer', oPayment.name);
        
        Plan_Details__c oPlandetails = new Plan_Details__c();
        oPlandetails.Name = 'Active Paid';
        oPlandetails.German__c = 'harte Angebot';
        insert oPlandetails;
        System.assertEquals('Active Paid', oPlandetails.name);
        
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        SetUpTestData.testCreateDAZNConfiguration('DoubleOptInCountries', 'United Kingdom');
        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', '/LoginPageURL');
        SetUpTestData.createDAZNConfigurations();
        Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
            Name = 'Docomo',
            Partner_Type__c = 'Docomo',
            Page_Name__c = 'PartnerAccount.page',
            Subscription_Type_Heading_Text__c = 'Docomo',
            Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
            Payment_History_URL__c = 'https://www.google.com',
            Cancel_Subscription_URL_Small__c = 'https://www.google.com',
            Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
            Cancel_Subscription_URL_Large__c = 'https://www.google.com',
            Change_password_email__c = '123',
            Double_opt_in_email__c = '123',
            Name_change_email__c = '123',
            Payment_success_email__c = '123',
            Updated_payment_method_email__c = '123'

        );
        insert pac;

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName ','TestNew1@test.com','Frozen');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'TestNew1@test.com', 'testlsut1@email.com.ls', 'tsnewtr1','Europe/London','ISO-8859-1','de','de','TestFirstName','TestLastName',true);
        oAccount.Notification_Language_Code__c = 'de';
        update oAccount;
        
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'Germany', 'test bill name', 'PayPal', 'batch2', 'GBP','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        
        List<Account> lstUpdatedAccount = new List<Account>();
        oAccount.Account_Status__c = 'Active Paid';
        lstUpdatedAccount.add(oAccount);
        System.assert(lstUpdatedAccount.size()>0);
        
        List<Account> lstAccount = [Select id from Account where personemail in ('TestNew1@test.com')];
        list<String> lstAccountId = new list<String>();
        for(Account oAcc : lstAccount){
            lstAccountId.add(oAcc.Id);
        }
        System.assert(lstAccountId.size()>0);
        
        User oProfileUser = createProfile('System Administrator');
        System.assertNotEquals(null, oProfileUser.Id);
        
        System.runAs (oProfileUser) {
            test.startTest();
            update lstUpdatedAccount;
            UpdateAccountTriggerHandler.createHardOfferWelcomeEmailQueueRecords(lstAccountId);
            test.stoptest(); 
        }
    }
    
    /*
Description: Test method to verify subscription welcome email functionality for active paid customer Japan.
*/
    public static testMethod void testSubscriptionWelcomeEmailForActivePaidCustomerJapan(){
        DAZN_Country_Currency_ISO_Code__c isoUSD = new DAZN_Country_Currency_ISO_Code__c();
        isoUSD.name = 'JPY';
        isoUSD.CurrencySymbol__c = '?';
        insert isoUSD;
        System.assertEquals('?', isoUSD.CurrencySymbol__c);
        
        Payment_Method__c oPayment = new Payment_Method__c();
        oPayment.Name = 'Bank Transfer';
        oPayment.Japan__c = '????';
        insert oPayment;
        System.assertEquals('Bank Transfer', oPayment.Name);
        
        Plan_Details__c oPlandetails = new Plan_Details__c();
        oPlandetails.Name = 'Active Paid';
        oPlandetails.Japan__c = '???????';
        insert oPlandetails;
        System.assertEquals('Active Paid', oPlandetails.Name);
        
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', '/LoginPageURL');
        SetUpTestData.createDAZNConfigurations();
        Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
            Name = 'Docomo',
            Partner_Type__c = 'Docomo',
            Page_Name__c = 'PartnerAccount.page',
            Subscription_Type_Heading_Text__c = 'Docomo',
            Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
            Payment_History_URL__c = 'https://www.google.com',
            Cancel_Subscription_URL_Small__c = 'https://www.google.com',
            Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
            Cancel_Subscription_URL_Large__c = 'https://www.google.com',
            Change_password_email__c = '123',
            Double_opt_in_email__c = '123',
            Name_change_email__c = '123',
            Payment_success_email__c = '123',
            Updated_payment_method_email__c = '123'

        );
        insert pac;

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName ','TestNew1@test.com','Frozen');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'TestNew1@test.com', 'testlsut1@email.com.ls', 'tsnewtr1','Europe/London','ISO-8859-1','ja','ja','TestFirstName','TestLastName',true);
        oAccount.Notification_Language_Code__c = 'ja';
        update oAccount;
        
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'Japan', 'test bill name', 'PayPal', 'batch1', 'JPY','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        
        List<Account> lstUpdatedAccount = new List<Account>();
        oAccount.Account_Status__c = 'Active Paid';
        lstUpdatedAccount.add(oAccount);
        System.assert(lstUpdatedAccount.size()>0);
        
        List<Account> lstAccount = [Select id from Account where personemail in ('TestNew1@test.com')];
        list<String> lstAccountId = new list<String>();
        for(Account oAcc : lstAccount){
            lstAccountId.add(oAcc.Id);
        }
        System.assert(lstAccountId.size()>0);
        
        User oProfileUser = createProfile('System Administrator');
        System.assertNotEquals(null, oProfileUser.Id);
        
        System.runAs (oProfileUser) {
            test.startTest();
            update lstUpdatedAccount;
            UpdateAccountTriggerHandler.createHardOfferWelcomeEmailQueueRecords(lstAccountId);
            test.stoptest(); 
        }
    }
    
    /*
Description: Test method to verify and cover the double optin notification functionality.
*/
    public static testMethod void testDoubleOptInNotification(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        SetUpTestData.testCreateDAZNConfiguration('DoubleOptInCountries', 'Germany');
        
        SetUpTestData.createDAZNConfigurations();

        List<Account> lstUpdatedAccount = new List<Account>();
        Account oAccount1 = SetUpTestData.createPersonAccount('TestFirstName1', 'TestLastName1','test@test1.com','Free Trial');
        
        Account oAccount2 = SetUpTestData.createPersonAccount('TestFirstName2', 'TestLastName2','test@test2.com','Free Trial');
        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'DAZN for Docomo', 'DAZN for Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        
       
        User oUser1 = SetUpTestData.createCommunityUser(oAccount1.Id, 'test@test1.com', 'testlsut1@email.com.ls', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFirstName1','TestLastName1',true);
        User oUser2 = SetUpTestData.createCommunityUser(oAccount2.Id, 'test@test2.com', 'testlsut2@email.com.ls', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFirstName2','TestLastName2',true);
        
        list<User> listUpdatedUser = new list<User>();
        
        oUser1.Country='Germany';
        listUpdatedUser.add(oUser1);
        
        oUser2.Country='Germany';
        listUpdatedUser.add(oUser2);
        System.assert(listUpdatedUser.size()>0);
        
        oAccount1.All_Email_Preferences__c = true;
        lstUpdatedAccount.add(oAccount1);
        
        oAccount2.All_Email_Preferences__c = true;
        lstUpdatedAccount.add(oAccount2);
        System.assert(lstUpdatedAccount.size()>0);
        
        List<Account> lstAccount = [Select id from Account where personemail in ('test@test1.com', 'test@test2.com')];
        list<String> lstAccountId = new list<String>();
        for(Account oAccount : lstAccount){
            lstAccountId.add(oAccount.Id);
        }
        System.assert(lstAccountId.size()>0);
        
        User oProfileUser = createProfile('System Administrator');
        System.assertNotEquals(null, oProfileUser.Id);
        
        System.runAs (oProfileUser) {
            test.startTest();
            update lstUpdatedAccount;
            update listUpdatedUser;
            //UpdateAccountTriggerHandler.sendDoubleOptInNotification(lstAccountId); Commented out according to PD-11495
            //UpdateAccountTriggerHandler.sendNameChangeNotification(lstAccountId); - Commented out according to PD-13009
            //UpdateAccountTriggerHandler.sendPaymentSuccessAfterFailureNotification(lstAccountId); - Commented out according to PD-12615
            test.stoptest();
        }
    }  
    //test method when account status is frozen and type is Dazn for Docomo
    static testmethod void testException(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        SetUpTestData.testCreateDAZNConfiguration('DoubleOptInCountries', 'United Kingdom');
        SetUpTestData.createDAZNConfigurations();

        List<string> lstAcc = new List<String>();
        Account oAccount1 = SetUpTestData.createPersonAccount('TestFirstName', ' Testlastname','testemailur1@email.com ','Active Paid');
        oAccount1.Account_Status__c = 'Frozen';
        update oAccount1;
        lstAcc.add(oAccount1.Id);
        System.assert(lstAcc.size()>0);
        SetUpTestData.createUserDevice(oAccount1.Id, 'test', system.today(),'Tablet','Active');
        User cUser = SetUpTestData.createCommunityUser(lstAcc[0], 'testemailur1@email.com', 'testemailur1@email.com.ls', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        User oProfileUser = createProfile('System Administrator');
        System.assertNotEquals(null, oProfileUser.Id);
        System.runAs (oProfileUser) {
            test.startTest();
            UpdateAccountTriggerHandler.deleteUseDevicesWhenStatusFrozen(lstAcc);
            test.stopTest();
        }
        
    }

    public static testMethod void test(){
        DAZN_Country_Currency_ISO_Code__c isoUSD = new DAZN_Country_Currency_ISO_Code__c();
        isoUSD.name = 'USD';
        isoUSD.CurrencySymbol__c = '$';
        insert isoUSD;
        System.assertEquals('USD', isoUSD.name);
        
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        SetUpTestData.testCreateDAZNConfiguration('DoubleOptInCountries', 'United Kingdom');
        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', '/LoginPageURL');
        SetUpTestData.createDAZNConfigurations();

        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'Docomo', 'Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName ','TestNew1@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'TestNew1@test.com', 'testlsut1@email.com.ls', 'tsnewtr1','Europe/London','ISO-8859-1','en_GB','en_GB','TestFirstName','TestLastName',true);
        oAccount.Notification_Language_Code__c = 'en_GB';
          oAccount.Type = 'Docomo';
        oAccount.Disable_all_transactional_emails__c = false;
        update oAccount;
        
        Zuora__CustomerAccount__c oCustAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c oSubscription = SetupTestData.createZuoraSubscription(oAccount.Id, oCustAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );
        List<Account> lstUpdatedAccount = new List<Account>();
        oAccount.Account_Status__c = 'Active Paid';
       lstUpdatedAccount.add(oAccount);
        System.assert(lstUpdatedAccount.size()>0);
        
        List<Account> lstAccount = [Select id from Account where personemail in ('TestNew1@test.com')];
        list<String> lstAccountId = new list<String>();
        for(Account oAcc : lstAccount){
            lstAccountId.add(oAcc.Id);
        }
        System.assert(lstAccountId.size()>0);
        
        User oProfileUser = createProfile('System Administrator');
        System.assertNotEquals(null, oProfileUser.Id);
        
        System.runAs (oProfileUser) {
            test.startTest();
            update lstUpdatedAccount;
            UpdateAccountTriggerHandler.createHardOfferWelcomeEmailQueueRecords(lstAccountId);
            test.stoptest(); 
        }
        System.assertEquals(true, [SELECT Id FROM Email_Sync_Queue__c WHERE Email_Name__c = 'Hard Offer Welcome'].size() > 0);
    }
    
    static testMethod void accountFreeTrialStartDateUpdatesTest() {
        SetUpTestData.triggerSettings();
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

        SetUpTestData.createDAZNConfigurations();

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        oAccount.Account_Status__c = 'Partial';
        update oAccount;
        Test.StartTest();
            oAccount.Account_Status__c = 'Free Trial';
            update oAccount;
        Test.StopTest();
        List<Account> freeTrialAccounts = [SELECT Id, Free_Trial_Start_Date__c FROM Account WHERE Id =:oAccount.Id];
        System.assertEquals(true, freeTrialAccounts[0].Free_Trial_Start_Date__c != null);
    }
    
    //PD-8706
    public static testMethod void TestaccountStatusFrozentoActivepaid(){
        SetUpTestData.createDAZNConfigurations();
        SetUpTestData.triggerSettings();
        Map<Id,Account> mapOld = new Map<Id,Account>();
        Map<Id,Account> mapNew = new Map<Id,Account>();     
        Test.startTest();
        Account oAccountFrozen = SetUpTestData.createPersonAccount('TestFirstNames1lsdevfrozen', 'TestLastNames1','testsfrozen@test1.com','Frozen');               
        oAccountFrozen.Account_Status__c = 'Active Paid';
        update oAccountFrozen;  
        Test.stoptest();
    }
    //PD-8706

    public static testMethod void testToSetTheEndDateTime() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
       
        SetUpTestData.testCreateDAZNConfiguration('DoubleOptInCountries', 'United Kingdom');

        SetUpTestData.createDAZNConfigurations();

        List<Account> lstUpdatedAccount = new List<Account>();
        Account oAccount1 = SetUpTestData.createPersonAccount('TestFirstNames1lsdev', 'TestLastNames1','tests@test1.com','Free Trial');
        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'Docomo', 'Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        
       
        string randomName = string.valueof(Datetime.now()).replace('-','').replace(':','').replace(' ','');
        User oUser1 = SetUpTestData.createCommunityUser(oAccount1.Id, 'tests@test1.com', 'tests@test1.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFirstNames1','TestLastNames1',true);
        
        oAccount1.FirstName = 'TestFirstName11';
        oAccount1.LastName = 'TestLastName11';
        oAccount1.Type = 'Docomo';
        oAccount1.Partner_ID__c = '123';
        oAccount1.Disable_all_transactional_emails__c = false;
        lstUpdatedAccount.add(oAccount1);
        
        
        List<Account> lstAccount = [Select id,PersonEmail, Type from Account limit 10];
        list<String> lstAccountId = new list<String>();
        for(Account oAccount : lstAccount){
            lstAccountId.add(oAccount.Id);
        }
        update lstUpdatedAccount;
        
        
        System.runAs (oUser1) {
            Test.startTest();

            Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
            UpdateAccountTriggerHandler.toSetTheStartDateTime();
            
            Test.stoptest(); 
        }
        
    }
    
    public static testMethod void testBlockedUser(){
        SetUpTestData.triggerSettings();
        list<Account> lstacc = new list<Account>();
         Account oAccountBlocked = SetUpTestData.createPersonAccount('TestFirstNames1', 'TestLastNames1','testsBlock@test1.com','Blocked');               
          User oUser1 = SetUpTestData.createCommunityUser(oAccountBlocked.Id, 'tests@test1.com', 'tests@test1.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFirstNames1','TestLastNames1',true);
        lstacc.add(oAccountBlocked);
        System.runAs (oUser1) {
            Test.startTest();
         
           UpdateAccountTriggerHandler.runOnce();
            Test.stopTest();
        }
       
        
    }
    
    public static testMethod void testAccountEmailPreferencesUpdate() {
        SetUpTestData.triggerSettings();
        DAZNCommunicatorConfig__c configDoubleOptIn = new DAZNCommunicatorConfig__c(name='DispatchID Double optin',Value__c=12345);
        insert configDoubleOptIn;
        Map<Id,Account> mapOld = new Map<Id,Account>();
        Map<Id,Account> mapNew = new Map<Id,Account>();

        SetUpTestData.createDAZNConfigurations();

        Test.startTest();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstNames2lsdevfrozen', 'TestLastNames2','testsfrozen@test2.com','Free Trial');
        oAccount.Notification_Country_Code__c = 'DE';
        oAccount.All_Email_Preferences__c = false;
        update oAccount;
        oAccount.All_Email_Preferences__c = true;
        update oAccount;
        Test.stoptest();
        System.assertEquals(true, [SELECT Id FROM Email_Sync_Queue__c WHERE Account__c = :oAccount.Id AND Type_of_Email__c = 'Triggered Dispatch' AND Dispatch_ID__c = :configDoubleOptIn.Value__c LIMIT 1].size() > 0);
    }
    
    public static testMethod void testAccountStatusChangeTestUser2() {
        Test.StartTest();
        SetUpTestData.triggerSettings();
        Account oAccount = new Account();
        oAccount.FirstName = 'TestFirstName';
        oAccount.LastName = 'TestLastName';
        oAccount.PersonEmail = 'test@test.com';
        oAccount.TestUser__c = false;
        oAccount.Account_Status__c = Label.LS_ACC_STATUS;
        oAccount.All_Email_Preferences__c = false;
        oAccount.Disable_all_transactional_emails__c  = false;
        insert oAccount;

        try {
            oAccount.TestUser__c = true;
            update oAccount;
        } catch (System.DmlException e) {
            system.assertEquals(e.getDmlMessage(0), 'You cant Activate it . The status is in Frozen');
        }
        Test.StopTest();
    }

    public static testMethod void testAccountStatusChangeTestUserFromTrueToFalse() {
        Test.StartTest();
        SetUpTestData.triggerSettings();
        Account oAccount = new Account();
        oAccount.FirstName = 'TestFirstName';
        oAccount.LastName = 'TestLastName';
        oAccount.PersonEmail = 'test@test.com';
        oAccount.TestUser__c = true;
        oAccount.Account_Status__c = Label.LS_ACC_STATUS;
        oAccount.All_Email_Preferences__c = false;
        oAccount.Disable_all_transactional_emails__c  = false;
        insert oAccount;

        try {
            oAccount.TestUser__c = false;
            update oAccount;
        } catch (System.DmlException e) {
            system.assertEquals(e.getDmlMessage(0), 'You cant Activate it . The status is in Frozen');
        }
        Test.StopTest();
    }

    public static testMethod void testAccountAfterUpdateTestUser() {
        Test.StartTest();
        SetUpTestData.triggerSettings();
        Account oAccount = new Account();
        oAccount.FirstName = 'TestFirstName';
        oAccount.LastName = 'TestLastName';
        oAccount.PersonEmail = 'test@test.com';
        oAccount.TestUser__c = false;
        insert oAccount;

        oAccount.TestUser__c = true;
        update oAccount;
        System.assertEquals(true, [Select Id, TestUser__c From Account Where Id = :oAccount.Id].TestUser__c);
        Test.StopTest();
    }
    
    public static testMethod void testRunVoid() {
        UpdateAccountTriggerHandler.runOnce();
        system.assertEquals(UpdateAccountTriggerHandler.runOnce(), false);
    }

    public static testMethod void testPopulateUniqueEmail() {
        List<Account> acc = new List<Account>();
        acc.add(new Account(
            FirstName = 'testf',
            LastName = 'testl',
            PersonEmail = 'dssdfgdfg@rdhg.tyu',
            UniqueEmail__c = ''
        ));
        UpdateAccountTriggerHandler.populateUniqueEmail(acc);
        system.assertEquals(acc[0].PersonEmail, acc[0].UniqueEmail__c);
    }

}