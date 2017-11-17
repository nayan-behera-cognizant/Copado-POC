/*
 Description: MembershipReactivationControllerTest is using by Reactivate Subscription Test class.
 PD-7810- Test class is changed as per PD notes. 
*/
@isTest
public class MembershipReactivationControllerTest {
    @testSetup 
    public static void getCommunityUsersTestData(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateZuoraDataforUnitTest.createZuoraDeatils();
        CreateZuoraDataforUnitTest.createInvoice();
        CreateTestDataforUnitTest.createTestcustomsetting();
        CreateTestDataforUnitTest.CreateGuestUser();
    }    
    static testmethod void testReactivateMembershipForFreeTrial()
    {
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Paid'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        List<Zuora__CustomerAccount__c> getlstZaccount=[Select Id, Zuora__Status__c,Zuora__Account__c   from Zuora__CustomerAccount__c where Zuora__Account__c In : accList ];
        List<Zuora__Subscription__c> getlstSubscription=[Select Id, Zuora__Status__c,Zuora__CustomerAccount__c  from Zuora__Subscription__c where Zuora__CustomerAccount__c In :getlstZaccount];
        List<Zuora__PaymentMethod__c> getlstPayment=[Select Id, Zuora__Type__c, Zuora__CreditCardExpirationMonth__c, Zuora__BillingAccount__c  from Zuora__PaymentMethod__c where Zuora__BillingAccount__c In :getlstZaccount];
        getlstSubscription[0].Zuora__Status__c='Cancelled';
        update getlstSubscription;
       System.assertNotEquals(null,oUser[0]);
        System.runAs(oUser[0])
        { 
            Test.startTest();
            MembershipReactivationController oMembershipReactivationController = new MembershipReactivationController();      
            oMembershipReactivationController.ReactivateMembership();
            String navigatreslut = oMembershipReactivationController.redirectToMyAccount().getUrl();
            System.assertEquals('/MyAccount',navigatreslut);
            String navigatHandler = oMembershipReactivationController.navigationHandler().getUrl();
            Test.stopTest();
        }
    }
    
    static testmethod void testReactivateMembershipForFreeTrial11()
    {
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Paid'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        List<Zuora__CustomerAccount__c> getlstZaccount=[Select Id, Zuora__Status__c,Zuora__Account__c   from Zuora__CustomerAccount__c where Zuora__Account__c In : accList ];
        List<Zuora__Subscription__c> getlstSubscription=[Select Id, Zuora__Status__c,Zuora__CustomerAccount__c  from Zuora__Subscription__c where Zuora__CustomerAccount__c In :getlstZaccount];
        List<Zuora__PaymentMethod__c> getlstPayment=[Select Id, Zuora__Type__c, Zuora__CreditCardExpirationMonth__c, Zuora__BillingAccount__c  from Zuora__PaymentMethod__c where Zuora__BillingAccount__c In :getlstZaccount];
        getlstSubscription[0].Zuora__Status__c='Cancelled';
        update getlstSubscription;
        getlstPayment[0].Zuora__CreditCardExpirationMonth__c = '12';
        update getlstPayment;
       System.assertNotEquals(null,oUser[0]);
        System.runAs(oUser[0])
        { 
            Test.startTest();
            MembershipReactivationController oMembershipReactivationController = new MembershipReactivationController();      
            oMembershipReactivationController.ReactivateMembership();
            String navigatreslut = oMembershipReactivationController.redirectToMyAccount().getUrl();
            System.assertEquals('/MyAccount',navigatreslut);
            String navigatHandler = oMembershipReactivationController.navigationHandler().getUrl();
            Test.stopTest();
        }
    }
    
    static testmethod void testReactivateMembershipForActivePaid()
    {
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Free Trial'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        List<Zuora__CustomerAccount__c> getlstZaccount=[Select Id, Zuora__Status__c,Zuora__Account__c   from Zuora__CustomerAccount__c where Zuora__Account__c In : accList ];
        List<Zuora__Subscription__c> getlstSubscription=[Select Id, Zuora__Status__c,Zuora__CustomerAccount__c  from Zuora__Subscription__c where Zuora__CustomerAccount__c In :getlstZaccount];
        List<Zuora__PaymentMethod__c> getlstPayment=[Select Id, Zuora__Type__c, Zuora__CreditCardExpirationMonth__c, Zuora__BillingAccount__c  from Zuora__PaymentMethod__c where Zuora__BillingAccount__c In :getlstZaccount];
        getlstSubscription[0].Zuora__Status__c='Cancelled';
       //getlstSubscription[0].Zuora__External_Id__c = '1';
       update getlstSubscription;
        getlstPayment[0].Zuora__CreditCardExpirationMonth__c = '';
        getlstPayment[0].Zuora__CreditCardExpirationYear__c = '';
      update getlstPayment;
        System.assertNotEquals(null,accList[0]);
        System.runAs(oUser[0])
        { 
            Test.startTest(); 
            MembershipReactivationController oMembershipReactivationController = new MembershipReactivationController();      
            //oMembershipReactivationController.sCountry = 'CA';
            oMembershipReactivationController.ReactivateMembership();
            String navigatreslut = oMembershipReactivationController.navigateToErrorPage().getUrl();
            System.assertEquals('/MyAccount?ResubscribesError=true',navigatreslut.substringBefore('Errormsg'));
            
            oMembershipReactivationController.navigateError = false;
            oMembershipReactivationController.navigateToErrorPage();

            Test.stopTest();
        }
      //Below lines to cover , Without use accessing Reactivation page.
       MembershipReactivationController oMembershipReactivationControllerWithoutUser = new MembershipReactivationController();      
       oMembershipReactivationControllerWithoutUser.getUserSubscription();
    }
    static testmethod void testReactivateMembershipForActivePaid4()
    {
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Free Trial'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        //List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        List<Zuora__CustomerAccount__c> getlstZaccount=[Select Id, Zuora__Status__c,Zuora__Account__c   from Zuora__CustomerAccount__c where Zuora__Account__c In : accList ];
        List<Zuora__Subscription__c> getlstSubscription=[Select Id, Zuora__Status__c,Zuora__CustomerAccount__c  from Zuora__Subscription__c where Zuora__CustomerAccount__c In :getlstZaccount];
        List<Zuora__PaymentMethod__c> getlstPayment=[Select Id, Zuora__Type__c, Zuora__CreditCardExpirationMonth__c, Zuora__BillingAccount__c  from Zuora__PaymentMethod__c where Zuora__BillingAccount__c In :getlstZaccount];
        getlstSubscription[0].Zuora__Status__c='Cancelled';
      // getlstSubscription[0].Zuora__External_Id__c = '';
       update getlstSubscription;
        getlstPayment[0].Zuora__CreditCardExpirationMonth__c = '';
        getlstPayment[0].Zuora__CreditCardExpirationYear__c = '';
      update getlstPayment;
        System.assertNotEquals(null,accList[0]);
        //System.runAs(oUser[0])
        //{ 
            Test.startTest(); 
            MembershipReactivationController oMembershipReactivationController = new MembershipReactivationController();      
            oMembershipReactivationController.ReactivateMembership();
            //oMembershipReactivationController.sCountry = 'CA';
            String navigatreslut = oMembershipReactivationController.navigateToErrorPage().getUrl();
            System.assertEquals('/MyAccount?ResubscribesError=true',navigatreslut.substringBefore('Errormsg'));
            oMembershipReactivationController.navigateError = false;
            oMembershipReactivationController.navigateToErrorPage();

            Test.stopTest();
        //}
      //Below lines to cover , Without use accessing Reactivation page.
       MembershipReactivationController oMembershipReactivationControllerWithoutUser = new MembershipReactivationController();      
       oMembershipReactivationControllerWithoutUser.getUserSubscription();
    }

    static testmethod void testNavigateToErrorPage() {
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Free Trial'];
        
        List<Zuora__CustomerAccount__c> getlstZaccount = [Select Id, Zuora__Status__c,Zuora__Account__c   from Zuora__CustomerAccount__c where Zuora__Account__c = :accList[0].Id];
        List<Zuora__Subscription__c> getlstSubscription = [Select Id, Zuora__Status__c,Zuora__CustomerAccount__c  from Zuora__Subscription__c where Zuora__CustomerAccount__c In :getlstZaccount];
        List<Zuora__PaymentMethod__c> getlstPayment = [Select Id, Zuora__Type__c, Zuora__CreditCardExpirationMonth__c, Zuora__BillingAccount__c  from Zuora__PaymentMethod__c where Zuora__BillingAccount__c In :getlstZaccount];
        getlstSubscription[0].Zuora__Status__c = 'Active';
        getlstSubscription[0].Zuora__NextChargeDate__c = Date.today() + 1;
        update getlstSubscription;

        System.runAs([Select Id From User Where AccountId = :accList[0].Id][0]) { 
            Test.startTest(); 
            MembershipReactivationController oMembershipReactivationController = new MembershipReactivationController();
            oMembershipReactivationController.navigateError = false;
            PageReference navigatreslut = oMembershipReactivationController.navigateToErrorPage();
            System.assertEquals(null, navigatreslut);
            Test.stopTest();
        }
    }   
   
    static testMethod void TestgetUserSubscription() {
  
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Free Trial');
       
        
         User cUser = SetUpTestData.createCommunityUser('de', 'DE', oAccount.Id, 'pauseuser@email.com', 'pauseuseree@email.com', 'tstals','Europe/London','ISO-8859-1','de','de','PauseUserFName','PauseUserLName',true);
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Cancelled', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Cancelled', System.today(), system.today()+30);
       
        String scCountry = 'CA';
        PageReference pageRef = Page.resubscribe;
        pageRef.getParameters().put('Country', scCountry);
        Test.setCurrentPage(pageRef);
        
                   
            Test.StartTest();
 
            System.RunAs(cUser){
         
             MembershipReactivationController oMembershipReactivationController = new MembershipReactivationController();      
            oMembershipReactivationController.ReactivateMembership();
            oMembershipReactivationController.getUserSubscription();
            
            Test.StopTest();
        }
           
    }
   
    static testMethod void TestgetUserSubscription_1() {
  
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
       
        
         User cUser = SetUpTestData.createCommunityUser('de', 'DE', oAccount.Id, 'pauseuser@email.com', 'pauseuseree@email.com', 'tstals','Europe/London','ISO-8859-1','de','de','PauseUserFName','PauseUserLName',true);
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Cancelled', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Cancelled', System.today(), system.today()+30);
       
        String scCountry = 'CA';
        PageReference pageRef = Page.resubscribe;
        pageRef.getParameters().put('Country', scCountry);
        Test.setCurrentPage(pageRef);
        
                   
            Test.StartTest();
 
            System.RunAs(cUser){
         
             MembershipReactivationController oMembershipReactivationController = new MembershipReactivationController();      
            oMembershipReactivationController.ReactivateMembership();
            oMembershipReactivationController.getUserSubscription();
            
            Test.StopTest();
        }
           
    }
   
   
    static testMethod void TestgetUserSubscription_2() {
  
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm3testemail@email.com','Active Paid');
       
        
         User cUser = SetUpTestData.createCommunityUser('de', 'DE', oAccount.Id, 'pauseuser@email.com', 'pauseuseree@email.com', 'tstals','Europe/London','ISO-8859-1','de','de','PauseUserFName','PauseUserLName',true);
       
                   
            Test.StartTest();
 
            System.RunAs(cUser){
         
             MembershipReactivationController oMembershipReactivationController = new MembershipReactivationController();      
            oMembershipReactivationController.ReactivateMembership();
            oMembershipReactivationController.getUserSubscription();
            
            Test.StopTest();
        }
           
    }
   
    static testMethod void tesStartUndoCancellationZuoraWorkflow() {
        //Create personal account
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testCustomer123@email.com','Active Paid');
        oAccount.Submitted_for_cancellation__c = true;
        update oAccount;
        //Create Billing Account
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        Zuora__Subscription__c subscription = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Zuora__Subscription__c', '', date.today(), date.today().addDays(7));
        List<Zuora__Subscription__c> subscriptions = [SELECT Id, Name FROM Zuora__Subscription__c WHERE Id =: subscription.Id];
        
        List<DAZNConfiguration__c> config = new List<DAZNConfiguration__c>();
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraReactivationUrl',
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
            MembershipReactivationController objwhyCntrl = new MembershipReactivationController();
            objwhyCntrl.startUndoCancellationZuoraWorkflow(subscriptions[0].Name, oAccount.Id);
            Test.setMock(HttpCalloutMock.class, new MockStandardUndoCancelResponse());
            MembershipReactivationController objwhyCntrl2 = new MembershipReactivationController();
            objwhyCntrl2.startUndoCancellationZuoraWorkflow(subscriptions[0].Name, oAccount.Id);
        Test.stopTest();
    }
    
    public class MockStandardUndoCancelResponse implements HttpCalloutMock {
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