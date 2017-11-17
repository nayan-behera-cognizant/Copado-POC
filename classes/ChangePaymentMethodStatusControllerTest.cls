/**
* @author Cognizant Technology Solutuions
* @date 05/02/2015
* @description This class test ChangePaymentMethodstatus Controller functionality.
*/
@istest
public class ChangePaymentMethodStatusControllerTest {
    
    static testMethod void testChangePaymentMethodStatusSuccess() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName','CPS3testemail@test.com','Active');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'CPS3testemail@email.com', 'CPS3testemail@email.com', 'cpsls3','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true);  
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');        
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );        
        SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD', '$');
        Test.StartTest();
        System.RunAs(cUser){
            Test.setCurrentPage(Page.ChangePaymentMethodStatus);
            ApexPages.currentPage().getParameters().put('success','true');
            ChangePaymentMethodStatusController objCntrl = new ChangePaymentMethodStatusController();
            system.assertEquals(objCntrl.oUser.ID, Userinfo.getUserId());
            system.assertEquals(objCntrl.sStatus, 'true');
        }
        Test.StopTest();
    }
    
    static testMethod void testChangePaymentMethodStatusFailure() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName','CPS4testemail@test.com','Active');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'CPS4testemail@email.com', 'CPS4testemail@email.com', 'cpsls4','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true);  
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');        
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );        
        
        Test.StartTest();
        System.RunAs(cUser){
            Test.setCurrentPage(Page.ChangePaymentMethodStatus);
            ApexPages.currentPage().getParameters().put('success','false');
            ApexPages.currentPage().getParameters().put('field_passthrough2','CreditCard');
            ChangePaymentMethodStatusController objCntrl = new ChangePaymentMethodStatusController();
            system.assertEquals(objCntrl.oUser.ID, Userinfo.getUserId());
            system.assertEquals(objCntrl.sStatus, 'false');
            objCntrl.createPaymentTask(); 
        }
        Test.StopTest();
    }
        
    static testMethod void testChangePaymentMethodStatusMyAccountRedirect() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName','CPS5testemail@test.com','Active');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'CPS5testemail@email.com', 'CPS5testemail@email.com', 'cpsls5','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true);  
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );

        Test.StartTest();
        System.RunAs(cUser){
            ChangePaymentMethodStatusController objCntrl = new ChangePaymentMethodStatusController();
            pagereference pRef = objCntrl.redirectToMyAccount();
            system.assertequals(pRef.getUrl(),'/MyAccount');
            PageReference pageRef = new PageReference('/MyAccount?');
            Test.setCurrentPage(pageRef);
            objCntrl.redirectToMyAccount();
        }
        Test.StopTest();
    }
    
        
    static testMethod void testChangePaymentMethodStatusCPMRedirect() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName','CPS6testemail@test.com','Active');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'CPS6testemail@email.com', 'CPS6testemail@email.com', 'cpsls6','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true);   
        Test.StartTest();
        System.RunAs(cUser){
            ChangePaymentMethodStatusController objCntrl = new ChangePaymentMethodStatusController();
            pagereference pRef = objCntrl.redirectToChangePaymentMethod();
            system.assertequals(pRef.getUrl(),'/ChangePaymentMethod');
        }
        Test.StopTest();
    }
    
    //method to cover create payment method as per PD-10616
    static testMethod void testcreatePaymentTask() {
    SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD', '$');
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName','CPS4testemail@test.com','Active');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'CPS4testemail@email.com', 'CPS4testemail@email.com', 'cpsls4','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true);  
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'PayPal', 'batch2', 'USD','1st of the month');        
        Zuora__Subscription__c zSubsr = SetupTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'test billing account', 'Active', Date.Today(), Date.today().addMonths(2) );        
        
        Test.StartTest();
        System.RunAs(cUser){
            Test.setCurrentPage(Page.ChangePaymentMethodStatus);
            ApexPages.currentPage().getParameters().put('success','True');
            ChangePaymentMethodStatusController objCntrl = new ChangePaymentMethodStatusController();
            system.assertEquals(objCntrl.oUser.ID, Userinfo.getUserId());
            system.assertEquals(objCntrl.sStatus, 'True');
            objCntrl.createPaymentTask(); 
        }
        Test.StopTest();
    }
    
}