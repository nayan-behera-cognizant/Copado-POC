/**
* @author Cognizant Technology Solutuions
* @date 14/04/2016
* @description This test class will cover the code coverage for CancelSubscriptionExtension.
*/
@IsTest 
public class CancelSubscriptionExtensionTest{
    
    @testSetup
    public static void createUser(){
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

        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        /*list<Profile> lstProf = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId;
        uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        uniqueName += Integer.valueOf(math.rint(math.random()*1000000));*/
        /*list<User> lstUser =new list<User>();
        User cSUser =new User(firstname = 'Test',
                              lastName = 'Member'+uniqueName,
                              email = 'TestMember'+uniqueName + '@test' +'.com',
                              Username = 'TestMember' + uniqueName+'@test'+ '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = 'Memeber',
                              TimeZoneSidKey = 'America/Los_Angeles', 
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              isActive =true,
                              ProfileId = lstProf[0].id  );
        
        lstUser.add(cSUser);
        insert lstUser;*/
        CreateTestDataforUnitTest.createTestUserDevices();
    }

    public static void createUserForTest() {
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId;
        list<Profile> lstProf = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
        //String uniqueName = orgId;
        uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
        list<User> lstUser =new list<User>();
        User cSUser =new User(firstname = 'Test',
                              lastName = 'Member'+uniqueName,
                              email = 'TestMember'+uniqueName + '@test' +'.com',
                              Username = 'TestMember' + uniqueName+'@test'+ '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = 'Memeber',
                              TimeZoneSidKey = 'America/Los_Angeles', 
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              isActive =true,
                              ProfileId = lstProf[0].id  );
        
        lstUser.add(cSUser);
        insert lstUser;
    }
    
    static testMethod void testNoAccountFound(){
        createUserForTest();
        list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
        List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
        
        Test.StartTest();
        System.RunAs(cSUser[0]){
            Account accObj = new Account();
            CancelSubscriptionExtension objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(accObj));
            objCancelSubscription.cancellationType = 'Immediate';
            objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
            objCancelSubscription.CancelSubscription();
        }
        Test.StopTest();
    }
    static testMethod void testCancelSubscription_NoAccountSelected() {
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        System.RunAs(oCSUser){
            Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
            User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
            list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
            //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
            Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
            Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
            Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
            Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
            SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
            SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD','$');
            Test.StartTest();
                Zuora__ZInvoice__c oZInvoice = [Select Zuora__PaymentAmount__c,Zuora__RefundedAmount__c From Zuora__ZInvoice__c limit 1];
                oZInvoice.Zuora__PaymentAmount__c = 1;
                oZInvoice.Zuora__RefundedAmount__c = 1;
                update oZInvoice;
                System.assertEquals(1, oZInvoice.Zuora__RefundedAmount__c);
                
                Zuora__Subscription__c oZSubscription = [Select Zuora__Status__c From Zuora__Subscription__c limit 1];
                oZSubscription.Zuora__Status__c = 'Cancelled';
                update oZSubscription;
                System.assertEquals('Cancelled', oZSubscription.Zuora__Status__c);
                Account accObj = [Select Id From Account Limit 1];
                CancelSubscriptionExtension objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(accObj));
                objCancelSubscription.cancellationType = 'Immediate';
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                objCancelSubscription.CancelSubscription();
            }
        Test.StopTest();
    }
    
    static testMethod void testCancelSubscription_NoCancellationType() {
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        Test.StartTest();
            System.RunAs(oCSUser){
                Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
                User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
                list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
                //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
                Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
                Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
                Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
                Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
                SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
                SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD','$');
                Zuora__ZInvoice__c oZInvoice = [Select Zuora__PaymentAmount__c,Zuora__TotalAmount__c From Zuora__ZInvoice__c limit 1];
                oZInvoice.Zuora__TotalAmount__c = -1;
                oZInvoice.Zuora__PaymentAmount__c = 1;
                update oZInvoice;
                System.assertEquals(-1, oZInvoice.Zuora__TotalAmount__c);
                
                Zuora__Subscription__c zSub = [Select Zuora__Status__c From Zuora__Subscription__c limit 1];
                zSub.Zuora__Status__c = 'Cancelled';
                update zSub;
                System.assertEquals('Cancelled', zSub.Zuora__Status__c);
                //Account accObj = [Select Id From Account Limit 1];
                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                CancelSubscriptionExtension objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                objCancelSubscription.CancelSubscription();
                //CancelSubscriptionExtension.signoutAllDevices(oAccount.Id, oAccount.PersonContactId);
            }
        Test.StopTest();
    }
    
    static testMethod void testCancelSubscription_NoInvoicePartial() {
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        Test.StartTest();
            System.RunAs(oCSUser){
                Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Partial');
                User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
                list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
                 Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');

                //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
                Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
                SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
                 SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD','$');      
               
                //Account accObj = [Select Id From Account Limit 1];
                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                CancelSubscriptionExtension objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                //objCancelSubscription.cancellationType = 'Immediate';
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                objCancelSubscription.CancelSubscription(); 
                System.assertEquals(false, objCancelSubscription.showErrMsg);
            }
        Test.StopTest();
    }
    
    static testMethod void testCancelSubscription_Standard() {
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        Test.StartTest();
            System.RunAs(oCSUser){
                Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active paid');
                User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
                list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
                //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
                Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
                Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
                Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
                Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
                SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
            //Test.StartTest();
            //System.RunAs(cSUser[0]){
                Zuora__Subscription__c oZSubscription = [Select Zuora__Status__c From Zuora__Subscription__c limit 1];
                oZSubscription.Zuora__Status__c = 'Cancelled';
                update oZSubscription;
                System.assertEquals('Cancelled', oZSubscription.Zuora__Status__c);
                
                Zuora__ZInvoice__c oZInvoice = [Select Zuora__PaymentAmount__c,Zuora__RefundedAmount__c From Zuora__ZInvoice__c limit 1];
                oZInvoice.Zuora__PaymentAmount__c = 1;
                update oZInvoice;
                System.assertEquals(1, oZInvoice.Zuora__PaymentAmount__c);            
                //Account accObj = [Select Id From Account Limit 1];
                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                CancelSubscriptionExtension objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.cancellationType = 'Standard';
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';            
                objCancelSubscription.CancelSubscription();
                
            }
        Test.StopTest();
    }
    
    static testMethod void testCancelSubscription_Immediate1() {
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        Test.StartTest();
            System.RunAs(oCSUser){
                Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
                User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
                list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
                //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
                Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
                Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
                Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
                zInv.Zuora__Zuora_Id__c = '1';
                update zInv;
                Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
                
                SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
                //Test.StartTest();

                CancelSubscriptionExtension objCancelSubscription;
            
            //System.RunAs(cSUser[0]){
               
                //Account accObj = [Select Id From Account Limit 1];
                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.cancellationType = 'Immediate';
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                objCancelSubscription.CancelSubscription();
                //System.assertEquals(True, objCancelSubscription.showErrMsg);
                
            }
        Test.StopTest();

        //System.assertEquals(true, objCancelSubscription.showErrMsg);
    }
    
    static testMethod void testCancelSubscription_Immediate1WithoutZuoraPayment() {
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        Test.StartTest();
            System.RunAs(oCSUser){
                Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
                User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
                list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
                //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
                Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
                Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
                Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
                zInv.Zuora__Zuora_Id__c = '1';
                update zInv;
                //Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
                
                SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
                //Test.StartTest();

                CancelSubscriptionExtension objCancelSubscription;
            
            //System.RunAs(cSUser[0]){
               
                //Account accObj = [Select Id From Account Limit 1];
                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.cancellationType = 'Immediate';
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                objCancelSubscription.CancelSubscription();
                //System.assertEquals(True, objCancelSubscription.showErrMsg);
                
            }
        Test.StopTest();

        //System.assertEquals(true, objCancelSubscription.showErrMsg);
    }
    
    static testMethod void testCancelSubscription_NoReasonForCancellation() {
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        Test.StartTest();
            System.RunAs(oCSUser){
                Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
                User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
                list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
                //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
                Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
                Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
                Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
                Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
                SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
            //Test.StartTest();
            //System.RunAs(cSUser[0]){
                Zuora__Subscription__c oZSubscription = [Select Zuora__Status__c From Zuora__Subscription__c limit 1];
                oZSubscription.Zuora__Status__c = 'Cancelled';
                update oZSubscription;
                System.assertEquals('Cancelled', oZSubscription.Zuora__Status__c);
                
                Zuora__ZInvoice__c oZInvoice = [Select Zuora__PaymentAmount__c,Zuora__RefundedAmount__c From Zuora__ZInvoice__c limit 1];
                oZInvoice.Zuora__PaymentAmount__c = 1;
                update oZInvoice;
                System.assertEquals(1, oZInvoice.Zuora__PaymentAmount__c);
                
                //Account accObj = [Select Id From Account Limit 1];
                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                CancelSubscriptionExtension objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.cancellationType = 'Immediate';
                objCancelSubscription.CancelSubscription();
            }
        Test.StopTest();
    }
    
    static testMethod void testCancelSubscription_NoInvoiceActivePaid() {
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        Test.StartTest();
            System.RunAs(oCSUser){
                Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
                User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
                list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
                //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
                Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
                Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
                SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
                
                List<DAZNConfiguration__c> config = new List<DAZNConfiguration__c>();
                config.add(new DAZNConfiguration__c(
                    Name = 'ZuoraImmediateCancelUrl',
                    Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/552/run'
                ));
                config.add(new DAZNConfiguration__c(
                    Name = 'ZuoraPauseUsername',
                    Value__c = 't1'
                ));
                config.add(new DAZNConfiguration__c(
                    Name = 'ZuoraPausePassword',
                    Value__c = 't2'
                ));
                insert config;
            //Test.StartTest();
            
            //System.RunAs(cSUser[0]){
                
                //Account accObj = [Select Id From Account Limit 1];
                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                Test.setMock(HttpCalloutMock.class, new MockStandardCancelSuccessResponse());
                CancelSubscriptionExtension objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.cancellationType = 'Immediate';
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                objCancelSubscription.isFreeTrialAccount = false;
                objCancelSubscription.CancelSubscription();
            }
        Test.StopTest();
    }
    //for cancellation type is not immediate
   static testMethod void testnotimmediate() {
    User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        Test.StartTest();
            System.RunAs(oCSUser){
                Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
                User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
                list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
                //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
                Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
                Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
                SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
            //Test.StartTest();
            //System.RunAs(cSUser[0]){
               
                //Account accObj = [Select Id From Account Limit 1];
                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                CancelSubscriptionExtension objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.cancellationType = 'test';
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                objCancelSubscription.CancelSubscription();
                //System.assertEquals(false, objCancelSubscription.showErrMsg);
                
            }
        Test.StopTest();
    }
    
   //for cancellation type is not immediate
   static testMethod void testnotimmediatePaused() {
    User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        Test.StartTest();
            System.RunAs(oCSUser){
                Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Paused');
                User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
                list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
                //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
                Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
                Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
                SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
            //Test.StartTest();
            //System.RunAs(cSUser[0]){
               
                //Account accObj = [Select Id From Account Limit 1];
                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                CancelSubscriptionExtension objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.cancellationType = 'test';
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                objCancelSubscription.CancelSubscription();
                System.assertEquals(true, objCancelSubscription.showErrMsg);
                
            }
        Test.StopTest();
    }

    //when  isfree trail is true and cancellation type is immediate
    static testMethod void testCancelSubscription_FreeTrail() {
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        Test.StartTest();
            System.RunAs(oCSUser){
                Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trail');
                User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
                list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
                //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
                Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
                Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
                Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
                zInv.Zuora__Zuora_Id__c = '1';
                update zInv;
                Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
                
                SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
            //Test.StartTest();
            
            //System.RunAs(cSUser[0]){
               
                //Account accObj = [Select Id From Account Limit 1];
                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                CancelSubscriptionExtension objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.cancellationType = 'Immediate';
                objCancelSubscription.isFreeTrialAccount=True;
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                objCancelSubscription.CancelSubscription();
                System.assert(objCancelSubscription.showErrMsg != null);
            }
        Test.StopTest();
    }

    //when cancellation type is immediate and reason for cancellation is null
    static testMethod void testCancelSubscription_ReasonNull() {
        
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        Test.StartTest();
            System.RunAs(oCSUser){
                Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
                User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
                list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
                //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
                Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
                Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
                Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
                zInv.Zuora__Zuora_Id__c = '1';
                update zInv;
                Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
                
                SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
            //Test.StartTest();
            
            //System.RunAs(cSUser[0]){
                
                //Account accObj = [Select Id From Account Limit 1];
                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                CancelSubscriptionExtension objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.cancellationType = 'Immediate';
                objCancelSubscription.reasonForCncl = ' ';
                objCancelSubscription.CancelSubscription();
                //System.assertEquals(FALSE, objCancelSubscription.showErrMsg);
            }
        Test.StopTest();
    }

    static testMethod void testCancelSubscriptionWithoutSubscriptions() {
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        
        Test.StartTest();
            System.RunAs(oCSUser){
                Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trail');
                User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
                list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
                //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
                Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
                Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
                Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
                zInv.Zuora__Zuora_Id__c = '1';
                update zInv;
                Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
                
                SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
            
            //Test.StartTest();
            //System.RunAs(cSUser[0]){
               
                //Account accObj = [Select Id From Account Limit 1];
                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                CancelSubscriptionExtension objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.cancellationType = 'Immediate';
                objCancelSubscription.isFreeTrialAccount=True;
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                
                objCancelSubscription.lstAccount[0].Zuora__Subscriptions__r[0].Zuora__Status__c = 'Cancelled';

                objCancelSubscription.CancelSubscription();
                System.assertEquals(true, objCancelSubscription.showErrMsg);
            }
        Test.StopTest();
    }

    static testMethod void testCancelSubscription_ImmediatePause() {
         List<DAZNConfiguration__c> config = new List<DAZNConfiguration__c>();
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelSubscSchInFuture',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/42/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelUserName',
            Value__c = 'david.francesconi@dazn.com'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelSubPass',
            Value__c = '58c89e0f46f549eded0a140e8d9a842f'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelSubscSchInFuture43',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/43/run'
        ));
        insert config;
        //User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
     
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
        CreateTestDataforUnitTest.createTestUserDevices();
        oAccount.Pause_Until__c = Date.today().addDays(10);
        oAccount.Pause_From__c = Date.today().addDays(5);
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        zInv.Zuora__Zuora_Id__c = '1';
        update zInv;
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
        zPay.Zuora__SettledOn__c = DateTime.now();
        update zPay;
                
        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
        //CreateTestDataforUnitTest.createTestUserDevices();
        
        System.RunAs(oUser){
            Test.StartTest();

            Test.setMock(HttpCalloutMock.class, new WhyControllerTest.MockSetPauseSuccessResponse());
            CancelSubscriptionExtension objCancelSubscription;
            
            ApexPages.currentPage().getParameters().put('id',oAccount.id);
            objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
            objCancelSubscription.cancellationType = 'Immediate';
            objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
            objCancelSubscription.CancelSubscription();
        Test.StopTest();}
    }

    static testMethod void testCancelSubscription_StandardPauseInFuture() {
        List<DAZNConfiguration__c> config = new List<DAZNConfiguration__c>();
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelSubscSchInFuture',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/42/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelUserName',
            Value__c = 'david.francesconi@dazn.com'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelSubPass',
            Value__c = '58c89e0f46f549eded0a140e8d9a842f'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseCancelSubscSchInFuture43',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/43/run'
        ));
        insert config;
        //User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
        oAccount.Pause_Until__c = Date.today().addDays(3);
        oAccount.Pause_From__c = Date.today().addDays(1);
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
        //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        zInv.Zuora__Zuora_Id__c = '1';
        update zInv;
        Zuora__SubscriptionProductCharge__c ratePlanCharge = new Zuora__SubscriptionProductCharge__c(
            Name = 'RatePlanCharge',
            Zuora__Price__c = 9,
            Zuora__ChargedThroughDate__c = Date.today(),
            Zuora__Model__c = 'Flat Fee Pricing',
            Zuora__Account__c = oAccount.Id,
            Zuora__Subscription__c = zSubsp.Id
        );
        insert ratePlanCharge;
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
                
        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
        //Test.StartTest();
        System.RunAs(oUser){
            Test.StartTest();
                Test.setMock(HttpCalloutMock.class, new WhyControllerTest.MockSetPauseSuccessResponse());
                CancelSubscriptionExtension objCancelSubscription;

                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.cancellationType = 'Standard';
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                objCancelSubscription.CancelSubscription();

            Test.StopTest();
        }
    }

    static testMethod void testCancelSubscription_StandardPauseInFutureFail() {
        SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
        oAccount.Pause_Until__c = Date.today().addDays(3);
        oAccount.Pause_From__c = Date.today().addDays(1);
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
        //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        zInv.Zuora__Zuora_Id__c = '1';
        update zInv;
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
                
        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
        //Test.StartTest();
        System.RunAs(oUser){
            Test.StartTest();
                Test.setMock(HttpCalloutMock.class, new WhyControllerTest.MockSetPauseFailureResponse());
                CancelSubscriptionExtension objCancelSubscription;

                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.cancellationType = 'Standard';
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                objCancelSubscription.CancelSubscription();

            Test.StopTest();
        }
    }
    static testMethod void testCancelSubscription_ImmidaitePauseInFutureFail() {
        SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
        oAccount.Pause_Until__c = Date.today().addDays(3);
        oAccount.Pause_From__c = Date.today().addDays(1);
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
        //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        zInv.Zuora__Zuora_Id__c = '1';
        update zInv;
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
                
        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');
        //Test.StartTest();
        System.RunAs(oUser){
            Test.StartTest();
                Test.setMock(HttpCalloutMock.class, new WhyControllerTest.MockSetPauseFailureResponse());
                CancelSubscriptionExtension objCancelSubscription;

                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.cancellationType = 'Immediate';
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                objCancelSubscription.CancelSubscription();

            Test.StopTest();
        }
    }

    static testMethod void testFail() {
        SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
        oAccount.Pause_Until__c = Date.today().addDays(3);
        oAccount.Pause_From__c = Date.today().addDays(1);
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        list<Profile> lstCSProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
        //List<User> cSUser = [select id,FirstName,IsActive,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ProfileId =: lstCSProfile[0].id  AND IsActive = true LIMIT 1];
        /*Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        zInv.Zuora__Zuora_Id__c = '1';
        update zInv;
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);
                
        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'LoginPageURL');*/
        //Test.StartTest();
        System.RunAs(oUser){
            Test.StartTest();
                /*Test.setMock(HttpCalloutMock.class, new WhyControllerTest.MockSetPauseFailureResponse());*/
                CancelSubscriptionExtension objCancelSubscription;

                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
                objCancelSubscription.cancellationType = 'ImmediateTR';
                //objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                //objCancelSubscription.cancellImmediate(null);

            Test.StopTest();
        }
    }

    static testMethod void testCancelSubscription_ImmediateCancellationBeforeGiftCodeEndDate() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        zInv.Zuora__Zuora_Id__c = '1';
        update zInv;
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);

        System.RunAs(oUser){
            Test.StartTest();
                CancelSubscriptionExtension objCancelSubscription;

                ApexPages.currentPage().getParameters().put('id',oAccount.id);
                objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));

                objCancelSubscription.cancellationType = 'Immediate';
                objCancelSubscription.reasonForCncl = 'I want to switch my payment method';
                objCancelSubscription.CancelSubscription();

                System.assertEquals(true, objCancelSubscription.showErrMsg);
            Test.StopTest();
        }
    }


    static testMethod void testUpdateAccountStatusAfterCancelSubscription() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Active Paid');
        Test.StartTest();
        DateTime dt = DateTime.now();
        CancelSubscriptionExtension.updateAccountStatusAfterCancelSubscription(oAccount.Id, dt.format('yyyy-MM-dd'));
        Test.StopTest();
        Account oAccountAfter = [Select Id, Account_Status__c From Account Where Id = :oAccount.Id];
        System.assertEquals('Frozen', oAccountAfter.Account_Status__c);
    }
    
    static testMethod void testStartStandardCancelZuoraWorkflow() {
        //Create personal account
        //User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        //System.RunAs(oCSUser){
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testCustomer123@email.com','Active Paid');
        oAccount.Submitted_for_cancellation__c = true;
        update oAccount;
        //Create Billing Account
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        Zuora__Subscription__c subscription = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Zuora__Subscription__c', '', date.today(), date.today().addDays(7));
        List<Zuora__Subscription__c> subscriptions = [SELECT Id, Name FROM Zuora__Subscription__c WHERE Id =: subscription.Id];
        
        List<DAZNConfiguration__c> config = new List<DAZNConfiguration__c>();
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraStandardCancelUrl',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/552/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseUsername',
            Value__c = 't1'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPausePassword',
            Value__c = 't2'
        ));
        insert config;

        Test.StartTest();
            CancelSubscriptionExtension objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
            objCancelSubscription.startStandardCancelZuoraWorkflow(subscriptions[0].Name, DateTime.now().format('yyyy-MM-dd'));
            Test.setMock(HttpCalloutMock.class, new MockStandardCancelSuccessResponse());
            CancelSubscriptionExtension objCancelSubscription2 = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
            objCancelSubscription2.startStandardCancelZuoraWorkflow(subscriptions[0].Name, DateTime.now().format('yyyy-MM-dd'));
        Test.stopTest();
    }
    
    static testMethod void testStartImmediateCancelZuoraWorkflow() {
        //Create personal account
        //User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        //System.RunAs(oCSUser){
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testCustomer123@email.com','Active Paid');
        oAccount.Submitted_for_cancellation__c = true;
        update oAccount;
        //Create Billing Account
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        Zuora__Subscription__c subscription = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Zuora__Subscription__c', '', date.today(), date.today().addDays(7));
        List<Zuora__Subscription__c> subscriptions = [SELECT Id, Name FROM Zuora__Subscription__c WHERE Id =: subscription.Id];
        
        List<DAZNConfiguration__c> config = new List<DAZNConfiguration__c>();
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraImmediateCancelUrl',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/552/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseUsername',
            Value__c = 't1'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPausePassword',
            Value__c = 't2'
        ));
        insert config;

        Test.StartTest();
            CancelSubscriptionExtension objCancelSubscription = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
            objCancelSubscription.startImmediateCancelZuoraWorkflow(subscriptions[0].Name, DateTime.now().format('yyyy-MM-dd'), '');
            Test.setMock(HttpCalloutMock.class, new MockStandardCancelSuccessResponse());
            CancelSubscriptionExtension objCancelSubscription2 = new CancelSubscriptionExtension(new ApexPages.StandardController(oAccount));
            objCancelSubscription2.startImmediateCancelZuoraWorkflow(subscriptions[0].Name, DateTime.now().format('yyyy-MM-dd'), '');
            objCancelSubscription2.createTaskForCancelation();
        Test.stopTest();
    }
    
    public class MockStandardCancelSuccessResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{ '+
                '    "id": 57, '+
                '    "name": "WF-9-00000011", '+
                '    "originalWorkflowId": 9, '+
                '    "type": "Workflow::Instance", '+
                '    "tasks": { '+
                '        "total": 1, '+
                '        "queued": 1, '+
                '        "processing": 0, '+
                '        "pending": 0, '+
                '        "stopped": 0, '+
                '        "success": 0, '+
                '        "error": 0 '+
                '    }, '+
                '    "runTime": null, '+
                '    "cpuTime": "00:00:00", '+
                '    "createdAt": "2017-03-24 09:56:17 UTC", '+
                '    "updatedAt": "2017-03-24 09:56:17 UTC" '+
                '}'
            );
            res.setStatusCode(200);
            return res;
        }
    }
    
}