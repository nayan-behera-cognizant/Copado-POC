/**
* @author Cognizant Technology Solutuions
* @date 19/08/2016
* @description Test class to cover MyAccountController functionality.
*/
@IsTest
public class MyAccountControllerTest {
    @testSetup /*  calling CreateTestDataforUnitTest */  
    public static void getCommunityUsersTestData() {
        CreateTestDataforUnitTest.createTestcustomsetting();
        SetUpTestData.triggerSettings();
        SetUpTestData.createPartnerAccountConfig();        
        SetUpTestData.createGiftCode();
        //SetUpTestData.createMISLSetting();
        SetUpTestData.emailCustsett();
        SetUpTestData.createountryListForPause();
      
        DAZNConfiguration__c dznConfig = new DAZNConfiguration__c(Value__c ='https://test.dazn.com,https://lsqa-dazn.cs88.force.com',name='RefererAcceptURL');
        insert dznConfig;

        SetUpTestData.testCreateDAZNConfiguration('LoginPageURL', 'test.salesforce.com');
        SetUpTestData.testCreateDAZNConfiguration('EncryptionKey', '160ab450f9c22gb1');
        SetUpTestData.testCreateDAZNConfiguration('CommunicatorAPIUserName', 'test');
        SetUpTestData.testCreateDAZNConfiguration('CommunicatorAPIUserPwd', 'oL9IBIKPqWGSvVXHuhKawxjDx/PhfrWZGHjsKrMA/J8=');
        
        SetUpTestData.createCommunicatorSeeting();

        List<DAZNConfiguration__c> daznConfig = new List<DAZNConfiguration__c>();
        daznConfig.add(new DAZNConfiguration__c(
            Name = 'SSO Comunity User Profile Id',
            Value__c = [Select Id From Profile Where Name = 'Customer Community User SSO' LIMIT 1].Id
        ));
        daznConfig.add(new DAZNConfiguration__c(
            Name = 'SSO Enabled Country Codes',
            Value__c = 'DE, CA, US'
        ));
        insert daznConfig;
    }


    /*Testing the Password Change Functionality with customer service team member */
    static testMethod void testpasswordChanges() {

        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00); 

        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        
        System.runAs(oUser){
            Test.StartTest();
                PageReference pageRef2 = Page.MyAccount;
                Test.setCurrentPage(pageRef2);
                ApexPages.currentPage().getParameters().put('field','Password');
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.oActSubscription = zSubsp;
                objCntrl.strPassword = 'TestPassword';
                objCntrl.strNewPassword = 'test1234';
                objCntrl.strRepeatPassword = 'test1234';            
                objCntrl.cancelEdit();
                system.assertEquals(objCntrl.isPasswordEdit, false);
                objCntrl.edit();
                system.assertEquals(objCntrl.isPasswordEdit, true);
                objCntrl.savePasswordChanges();
                ApexPages.currentPage().getParameters().put('field','test');
                objCntrl.cancelEdit();
                objCntrl.edit();
                system.assert(objCntrl.isNameEdit == false);
            Test.stopTest();
        }
    }
    
    /*Testing the Password Change Functionality with Livesport team member */
    static testMethod void testpasswordFunctionality() {

        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00); 

        system.setPassword(oUser.ID, 'TestPassword12345!');
        Test.setMock(WebServiceMock.class, new ComunicatorMockImpl());
        System.runAs(oUser){
            Test.StartTest();
                PageReference pageRef2 = Page.MyAccount;
                Test.setCurrentPage(pageRef2);
                ApexPages.currentPage().getParameters().put('field','Password');
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.strPassword = 'TestPassword';
                objCntrl.strNewPassword = 'test1234';
                objCntrl.strRepeatPassword = 'test1234';            
                objCntrl.cancelEdit();
                system.assertEquals(objCntrl.isPasswordEdit, false);
                objCntrl.edit();
                system.assertEquals(objCntrl.isPasswordEdit, true);
                objCntrl.savePasswordChanges();
                ApexPages.currentPage().getParameters().put('field','test');
                objCntrl.cancelEdit();
                objCntrl.edit();
                objCntrl.paymentDetails();
                system.assert(objCntrl.isNameEdit == false);
            Test.stopTest();
        }
    }
    
    /*Testing the Password Change Functionality Validations with customer service team member */
    static testMethod void testPasswordChangesValidation() { 
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser){
            Test.StartTest();
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.clearErrorFields();
                objCntrl.strNewPassword = 'Test1234';
                objCntrl.strRepeatPassword = 'Test1234';
                objCntrl.strPassword = 'Test12@15';
                objCntrl.savePasswordChanges();   
                objCntrl.sCountryCode = 'JP';
            
            Test.StopTest();
            system.assertNotEquals(null, oUser.id);
        }
    } 
    
    /*Testing the Password Change Functionality Validations with Livesport team member */
    static testMethod void testPasswordValidation() { 
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser){
            Test.StartTest();
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.clearErrorFields();
                objCntrl.strNewPassword = '';
                objCntrl.savePasswordChanges();
                
                objCntrl.strNewPassword = 'Test123@1234512345678996541237897';
                objCntrl.savePasswordChanges();
                
                objCntrl.strNewPassword = 'Test123@12345';
                objCntrl.strRepeatPassword = 'Test123@1234567';
                objCntrl.savePasswordChanges();
                
                objCntrl.strNewPassword = 'Test1234';
                objCntrl.strRepeatPassword = 'Test1234';
                objCntrl.strPassword = 'Test12@15';
                objCntrl.savePasswordChanges();   
                
                objCntrl.user=oUser;
                objCntrl.strNewPassword = '';
                objCntrl.strRepeatPassword = '';
                objCntrl.strPassword = 'Test12@15';
                objCntrl.sCountryCode ='CA';
                objCntrl.savePasswordChanges();
            Test.StopTest();
            system.assertNotEquals(null, oUser.id);
        }
    }  
    
    /*Testing the Deregister single Device Functionality with customer service team member */
    static testMethod void testderegisterSingleDevice() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        User_Devices__c singleDev = SetUpTestData.createUserDevice(oAccount.Id, 'Test User Device', System.today(), 'Desktop' , 'Active');
        
        System.runAs(oUser){   
            PageReference oPageReference = Page.MyAccount; 
            Test.setCurrentPage(oPageReference); 
            MyAccountController objCntrl = new MyAccountController();
            objCntrl.selectedDeviceID = singleDev.id;
            objCntrl.deregisterSingelUserDevice();
            List<User_Devices__c> userDivCou = [Select Id from User_Devices__c where Account__c = :oAccount.id];
            System.assert(userDivCou.isEmpty() != true);
        }        
    }
    
    /*Testing to display the Deregister single Device Functionality with Customer Service Team Member */
    static testMethod void testShowallleDevice() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        List<User_Devices__c> singleDev = SetUpTestData.createUserDevices(oAccount.Id, 'Test User Device', System.today(), 'Active');

        System.runAs(oUser){   
            PageReference oPageReference = Page.MyAccount; 
            Test.setCurrentPage(oPageReference); 
            MyAccountController objCntrl = new MyAccountController();
            objCntrl.showAllUserDevices();
            System.assertNotEquals(null, objCntrl.wrapUDList);
        }        
    }

    /*Testing the display banner on page or not Functionality with Customer Service Team Member  */
    static testMethod void testCSCancelBanner(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        List<User_Devices__c> singleDev = SetUpTestData.createUserDevices(oAccount.Id, 'Test User Device', System.today(), 'Active');

        System.runAs(oUser){
            Test.StartTest();
                MyAccountController objCntrl = new MyAccountController();
                apexpages.currentpage().getParameters().put('cancelButtonclick', 'true');
                objCntrl.signoutAllDevices();
                objCntrl.getBanner();
            Test.stopTest();
        }
        System.assertNotEquals(null,oUser.id);
    }    
    
    //test method for reactivation banner with Customer Service Team Member 
    static testMethod void testReactivationBanner(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser){
            Test.StartTest();
                MyAccountController objCntrl = new MyAccountController();
                apexpages.currentpage().getParameters().put('showReactivationBanner', 'true');
                objCntrl.getBanner();
            Test.stopTest();
        }
        system.assertNotEquals(null,oUser.id);
    }   

    //test method for reactivation banner with Customer Service Team Member 
    static testMethod void testcancelReactivation() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser){
            Test.StartTest();
                MyAccountController objCntrl = new MyAccountController();
                apexpages.currentpage().getParameters().put('cancelButtonError', 'true');
                objCntrl.getBanner();
            Test.stopTest();
        }
        System.assertNotEquals(null,oUser.id);
    }
   
    //test method for reactivation banner with Customer Service Team Member 
    static testMethod void testReactivation() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser){
            Test.StartTest();
                MyAccountController objCntrl = new MyAccountController();
                apexpages.currentpage().getParameters().put('ResubscribesError', 'true');
                objCntrl.getBanner();
            Test.stopTest();
        }
        System.assertNotEquals(null,oUser.id);
    }
    
    static testMethod void testGetBannerChangePaymentMethodError() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser) {
            ApexPages.currentPage().getParameters().put('ChangePaymentMethodError', 'true');
            MyAccountController myAccountController = new MyAccountController();
            String str = myAccountController.getBanner();
            System.assertEquals('ChangePaymentMethodError', str);
        }
    }

    /*Testing the Signout Device Functionality with Customer Service Team Member */
    static testMethod void testGetNSingoutDevices() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        List<User_Devices__c> singleDev = SetUpTestData.createUserDevices(oAccount.Id, 'Test User Device', System.today(), 'Active');

        System.runAs(oUser){
            Test.StartTest();
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.signoutAllDevices();
                objCntrl.selectedDeviceID = singleDev[0].id;
                objCntrl.showSignOutBannersinledevice();
                objCntrl.showSignOutBanner();
                objCntrl.closeBanner();
            Test.StopTest();
        }      
        System.assertNotEquals(null,oUser.id);
    }
    
    /*Testing the Delete Signout Device Functionality with Customer Service Team Member */
    static testMethod void testsignOutOfDevicesUpdated() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        List<User_Devices__c> singleDev = SetUpTestData.createUserDevices(oAccount.Id, 'Test User Device', System.today(), 'Active');

        System.runAs(oUser){
            Test.StartTest();
                MyAccountController.signOutOfSingleDevicesUpdated(singleDev,new List<User>{oUser},singleDev[0].id);
                MyAccountController.signOutOfSingleDevicesUpdated(null,new List<User>{oUser},singleDev[0].id);
                MyAccountController.signOutOfSingleDevicesUpdated(singleDev, new List<User>{oUser}, null);
            Test.StopTest();
        }        
        System.assertNotEquals(null,oUser.id);
    }   
    
    /* Testing forgot password link with Customer Service Team Member */
    static testMethod void testForgotPasswordNavigationHandler(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser){
            Test.StartTest();
                MyAccountController objCntrl = new MyAccountController();
                PageReference pagcall = objCntrl.forgotPasswordNavigationHandler();
                system.assertEquals(DAZNConfiguration__c.getValues('ForgotPasswordLink').Value__c,pagcall.getURL());
            Test.StopTest();
        }
    }
    
    // test for navigate user
    static testMethod void testNavigateuser(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser){
            Test.startTest();
                MyAccountController objctrl = new MyAccountController();
                objctrl.navigateUser();
                objctrl.navigationHandler();
                objctrl.naviagateToWhyPage();
                objctrl.DAZNHomePageNavigationHandler();
                objctrl.callpageredirect();
                PageReference oPgf = objctrl.navigateUser();
                System.assertEquals(null, oPgf);
            Test.stopTest();
        }
    }

    static testMethod void testNavigateuserCancellation(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        oAccount.Submitted_for_cancellation__c = true;
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser){
            Test.startTest();
                MyAccountController objctrl = new MyAccountController();
                objctrl.showAddPaymentFlag = false;
                objctrl.navigateUser();
                System.assert(objctrl.user != null);
            Test.stopTest();
        }
    }

    static testMethod void testNavigateuserSetEmailPref(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        oAccount.All_Email_Preferences__c = true;
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser){
            Test.startTest();
                ApexPages.currentPage().getParameters().put('setepref', 'true');
                ApexPages.currentPage().getHeaders().put('referer', 'test');
                MyAccountController objctrl = new MyAccountController();
                objctrl.navigateUser();

            Test.stopTest();
        }

        Account a = [Select Id, All_Email_Preferences__c From Account Where Id = :oUser.AccountId];
        System.assertEquals(true, a.All_Email_Preferences__c);
    }
    
    // test for name,email changes
    static testMethod void testNameChange(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        oAccount.Retrieve_Email__c = oAccount.FirstName + '-' + oAccount.LastName + '-' + '1111';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objctrl = new MyAccountController(); 
                objctrl.saveNameChanges();
                objctrl.setEmailPreferences();
                objctrl.getLanguages();
                objctrl.updateUserLanguage();
                objctrl.formatYear();
                objctrl.strFirstName = 'TestFirstName';
                objctrl.strLastName = 'TestLastName0';
                objctrl.saveNameChanges();

                Account accAfterUpdate = [Select Id, FirstName, LastName, Retrieve_Email__c From Account Where Id = :oAccount.Id];
                
                MyAccountController objctr = new MyAccountController();
                MyAccountController.redirectToErrorPage('strErrMsg');
                objctr.saveEmailChanges();
                
                MyAccountController objcnt = new MyAccountController();
                apexpages.currentpage().getParameters().put('field', 'Name');
                objcnt.cancelEdit();
                objcnt.edit(); 
                
                MyAccountController objCntr = new MyAccountController();
                ApexPages.currentPage().getParameters().put('field', 'Email');
                objCntr.cancelEdit();
                objCntr.edit();
                System.assertNotEquals(null,oUser.id);
            Test.stopTest();
        }        
    }

    //test first name and last name fields order for JP users (PD-5776)
    static testmethod void testNameFieldsOrderForJP(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objctrl = new MyAccountController();
                objctrl.sCountryCode= 'JP';
                objctrl.strFirstName = 'FirstName1';
                objctrl.strLastName = 'LastName1';
                objctrl.saveNameChanges();
                String testName = objctrl.strLastName + ' ' + objctrl.strFirstName;

                System.assertEquals(objctrl.sAccountName, testName);
            Test.stopTest();

        }

    }        

    static testmethod void testNameFieldsOrderForJPError(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objctrl = new MyAccountController();
                objctrl.sCountryCode= 'DE';
                objctrl.strFirstName = 'FirstName1';
                objctrl.strLastName = 'LastName1';
                objctrl.saveNameChanges();
                string testName = objctrl.strLastName + ' ' + objctrl.strFirstName;

                System.assertNotEquals(objctrl.sAccountName, testName);
            Test.stopTest();
        }
    }    
        
    
    /*Added as Part of PD-11615 with Country Canada French*/
    static testMethod void testLocaleChangeCanadaFrench(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        oAccount.Notification_Country_Code__c = 'CA';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                oUser.LanguageLocaleKey = 'fr';
                update oUser;
                MyAccountController objctrl = new MyAccountController(); 
                objctrl.updateUserLanguage();
                System.assertNotEquals(null,oUser.id);
            Test.stopTest();
        }
    } 
    
    /*Added as Part of PD-11615 with Country Canada English*/
    static testMethod void testLocaleChangeCanadaEnglish(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        oAccount.Notification_Country_Code__c = 'CA';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser) {
            Test.startTest();
                oUser.LanguageLocaleKey = 'en_US';
                update oUser;
                MyAccountController objctrl = new MyAccountController(); 
                objctrl.updateUserLanguage();
                System.assertNotEquals(null,oUser.id);
            Test.stopTest();
        }
    } 
    /*End of PD-11615*/       
            
    //test for redirect to error page
    static testMethod void testErrorPage(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);        
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser){
            Test.startTest();
                MyAccountController.redirectToErrorPage('mylogin');
                MyAccountController objctr = new MyAccountController();
                objctr.oActSubscription = zSubsp;
                ApexPages.currentPage().getParameters().put('paymentMethodSuccess','true');
                objctr.showPaymentMethodSuccessBanner();
                System.assertNotEquals(null,oUser.id);
            Test.stopTest();
        }
    }
    
    //test to getlanguage
    static testmethod void testGetLanguage(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser){
            Test.startTest();
                MyAccountController objctr = new MyAccountController();
                objctr.getLanguages();
                System.assertNotEquals(null,oUser.id);
            Test.stopTest();
        }
    }


    // test to update language
    static testmethod void testUpdateLanguage(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser){
            Test.startTest();
                MyAccountController objctr = new MyAccountController();
                objctr.updateUserLanguage();
                objctr.strSelectedLanguage = null;
                objctr.updateUserLanguage();
                System.assertNotEquals(null,oUser.id);
            Test.stopTest();
        }
    }

    static testMethod void testNavigateuserDfD() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Grace');
        oAccount.Type = 'Docomo';
        oAccount.Partner_ID__c = '1';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                MyAccountController mac = new MyAccountController();
                PageReference oPgf = mac.navigateUser();
                System.assertEquals('/PartnerAccount', oPgf.getURL());
            Test.stopTest();
        }        
    }

    static testMethod void testSendNotif() { 
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        oAccount.Disable_all_transactional_emails__c = false;
        oAccount.Type = 'Docomo';
        oAccount.Partner_ID__c = '123';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);        
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        Test.StartTest();
            System.runAs(oUser){
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.savePasswordChanges();
                System.assertNotEquals(null,oUser.id);
            }
        Test.StopTest();
    }
    
    static testMethod void testNavigateToWhyPage() { 
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');      
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser){
            Test.StartTest();
                MyAccountController objCntrl = new MyAccountController();
                pageReference pager = page.PauseUpsell;
                Test.setCurrentPage(pager);
                objCntrl.naviagateToWhyPage();
                System.assertNotEquals(null,oUser.id);
            Test.StopTest();
        } 
    } 
    
    static testMethod void testNavigateToWhyPageTrue() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');      
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        Test.StartTest();
            System.runAs(oUser){
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.naviagateToWhyPage();
                System.assertNotEquals(null,oUser.id);
            }
        Test.StopTest();
    }
       
    static testMethod void testShowSetPauseBannerInitPause() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');      
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                ApexPages.currentPage().getParameters().put('resumeDate', '2017-03-11');
                ApexPages.currentPage().getParameters().put('suspendDate', '2017-05-11');
                ApexPages.currentPage().getParameters().put('banner', 'initPause');

                MyAccountController myAccountController = new MyAccountController();
                myAccountController.showSetPauseBanner();

                System.assertEquals(true, myAccountController.showbanner);
            Test.stopTest();
        }
    }

    static testMethod void testShowSetPauseBannerAmendedPause() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');      
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                ApexPages.currentPage().getParameters().put('resumeDate', '2017-03-11');
                ApexPages.currentPage().getParameters().put('suspendDate', '2017-05-11');
                ApexPages.currentPage().getParameters().put('banner', 'amendedPause');

                MyAccountController myAccountController = new MyAccountController();
                myAccountController.showSetPauseBanner();

                System.assertEquals(true, myAccountController.showbanner);
            Test.stopTest();
        }
    }

    static testMethod void testShowSetPauseBannerStayActive() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');      
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                ApexPages.currentPage().getParameters().put('banner', 'stayActive');

                MyAccountController myAccountController = new MyAccountController();
                myAccountController.showSetPauseBanner();

                System.assertEquals(true, myAccountController.showbanner);
            Test.stopTest();
        }
    }

    static testMethod void testShowSetPauseBannerWelcomeBack() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');      
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                ApexPages.currentPage().getParameters().put('resumeDate', '2017-03-11');
                ApexPages.currentPage().getParameters().put('banner', 'welcomeBack');

                MyAccountController myAccountController = new MyAccountController();
                myAccountController.showSetPauseBanner();

                System.assertEquals(true, myAccountController.showbanner);
            Test.stopTest();
        }
    }

    static testMethod void testShowSetPauseBannerSuccesscanselsubscription() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');      
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                ApexPages.currentPage().getParameters().put('showPaymentChange', 'showPaymentChange');
                ApexPages.currentPage().getParameters().put('banner', 'successcanselsubscription');

                MyAccountController myAccountController = new MyAccountController();
                myAccountController.showSetPauseBanner();

                System.assertEquals(true, myAccountController.showbanner);
            Test.stopTest();
        }
    }

    static testMethod void testShowSetPauseBannerFailcanselsubscription() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');      
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                ApexPages.currentPage().getParameters().put('banner', 'failcanselsubscription');

                MyAccountController myAccountController = new MyAccountController();
                myAccountController.showSetPauseBanner();

                System.assertEquals(true, myAccountController.showbanner);
            Test.stopTest();
        }
    }

    static testMethod void testShowSetPauseBannerCancelReqFail() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');      
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                ApexPages.currentPage().getParameters().put('banner', 'cancelReqFail');

                MyAccountController myAccountController = new MyAccountController();
                myAccountController.showSetPauseBanner();

                System.assertEquals(true, myAccountController.showbanner);
            Test.stopTest();
        }
    }

    static testMethod void testShowSetPauseBannerAmendReqFail() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');      
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                ApexPages.currentPage().getParameters().put('banner', 'amendReqFail');

                MyAccountController myAccountController = new MyAccountController();
                myAccountController.showSetPauseBanner();

                System.assertEquals(true, myAccountController.showbanner);
            Test.stopTest();
        }
    }
       
 
    
    static testMethod void TestpauseDescription() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        oAccount.Pause_From__c = Date.today() + 1;
        oAccount.Pause_Until__c = Date.today() + 11;
        oAccount.Notification_Language_Code__c = 'en_GB';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        bAccount.Zuora__MRR__c = 100.00;
        update bAccount;
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);        
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        PaymentMethodOptionConfig__c oPaymentMethodConfig = SetUpTestData.testCreatePaymentMethodOptionConfigForPause('United Kingdom', 'GB', true, true, false, 'test', 'test', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Gateway', 'CreditCard','Batch3','#,###');        

        Test.StartTest();
            System.runAs(oUser) {
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.oActSubscription = zSubsp;
                objCntrl.pauseDescription(); 
                System.assert(objCntrl.pauseSchedule == true);           
            }
        Test.StopTest();
    }
    
    static testMethod void TestpauseDescriptionFreeTrial() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        oAccount.Pause_From__c =date.newinstance(2017,4,15);
        oAccount.Pause_Until__c =date.newinstance(2017,5,15);
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        bAccount.Zuora__MRR__c = 100.00;
        update bAccount;
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);        
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        PaymentMethodOptionConfig__c oPaymentMethodConfig = SetUpTestData.testCreatePaymentMethodOptionConfigForPause('United Kingdom', 'GB', true, true, false, 'test', 'test', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Gateway', 'CreditCard','Batch3','#,###');        

        Test.StartTest();
            System.runAs(oUser) {
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.oActSubscription = zSubsp;
                objCntrl.pauseDescription();
                objCntrl.calcNextPaymentForPause();
                System.assert(objCntrl.pauseSchedule == true);
            }
        Test.StopTest();
    }
    
    static testMethod void testPauseDoneDescription() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        oAccount.Pause_From__c =date.newinstance(2025,4,15);
        oAccount.Pause_Until__c = date.newinstance(2025,5,15);
        oAccount.Notification_Language_Code__c = 'en_GB';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        bAccount.Zuora__MRR__c = 100.00;
        update bAccount; 
        
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        PaymentMethodOptionConfig__c oPaymentMethodConfig = SetUpTestData.testCreatePaymentMethodOptionConfigForPause('United Kingdom', 'GB', true, true, false, 'test', 'test', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Gateway', 'CreditCard','Batch3','#,###');        

        Test.StartTest();
            System.runAs(oUser) {
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.pauseDoneDescription();
                objCntrl.calcNextPaymentForPause();
                System.assert(objCntrl.user != null);
            }
        Test.StopTest();
    }

    static testMethod void testPauseDoneDescriptionInPause() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Paused');
        oAccount.Pause_From__c =date.newinstance(2025,4,15);
        oAccount.Pause_Until__c = date.newinstance(2025,5,15);
        oAccount.Notification_Language_Code__c = 'en_GB';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        bAccount.Zuora__MRR__c = 100.00;
        update bAccount; 
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);

        PaymentMethodOptionConfig__c oPaymentMethodConfig = SetUpTestData.testCreatePaymentMethodOptionConfigForPause('United Kingdom', 'GB', true, true, false, 'test', 'test', 'test', 'Paypal Japan - Dev','2c92c0f85313118601531e3196c82c3b','2c92c0f9533b0a120153411aa19367a6','Test Gateway', 'CreditCard','Batch3','#,###');        

        Test.StartTest();
            System.runAs(oUser) {
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.pauseDoneDescription();
                System.assert(objCntrl.user != null);
            }
        Test.StopTest();
    }
    
    static testMethod void testNaviagateToSetPause(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        oAccount.Pause_From__c =date.newinstance(2517, 4, 15);
        oAccount.Pause_Until__c = date.newinstance(2517, 5, 15);
        oAccount.Account_Status__c='Active Paid';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        Test.StartTest();
            System.runAs(oUser){
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.naviagateToSetPause();
                System.assert(objCntrl.user != null);
            }
        Test.StopTest();
    }
    
    static testMethod void testNaviagateToSetPauseElse() {        
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        oAccount.Pause_From__c =date.newinstance(2517, 4, 15);
        oAccount.Pause_Until__c = date.newinstance(2517, 5, 15);
        oAccount.Account_Status__c='Paused';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        Test.StartTest();
            System.runAs(oUser){
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.naviagateToSetPause();
                System.assert(objCntrl.user != null);
            }
        Test.StopTest();
    }

    static testMethod void testKeepMyDaznActivePauseEnabled() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        oAccount.Pause_From__c = Date.today() + 1;
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);        
        User oUser = SetUpTestData.createCommunityUserDE(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        Test.StartTest();
            System.runAs(oUser) {
                Test.setMock(HttpCalloutMock.class, new MockSetPauseSuccessResponse());
                MyAccountController objCntrl = new MyAccountController();
                PageReference pr = objCntrl.keepMyDaznActive();
                System.assertNotEquals(null, pr);
                objCntrl.sBannerName = 'test';
                objCntrl.freeTrial();
            }
        Test.StopTest();
    }

    static testMethod void testKeepMyDaznActivePauseEnabledFail() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        oAccount.Pause_From__c = Date.today() + 1;
        update oAccount;
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);   
        User oUser = SetUpTestData.createCommunityUserDE(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        Test.StartTest();
            System.runAs(oUser) {
                Test.setMock(HttpCalloutMock.class, new MockSetPauseFailureResponse());
                MyAccountController objCntrl = new MyAccountController();
                PageReference pr = objCntrl.keepMyDaznActive();
                System.assertNotEquals(null, pr);

                objCntrl.sBannerName = 'test';
                objCntrl.freeTrial();
            }
        Test.StopTest();
    }

    public class MockSetPauseSuccessResponse implements HttpCalloutMock {
        
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

    public class MockSetPauseFailureResponse implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{ '+
                '    "errors": [ '+
                '         { '+
                '             "status": 406, '+
                '             "code": "invalid", '+
                '             "title": "Required field for Workflow-ResumeDate does not have a set value. Ensure parameter \'ResumeDate\' is present." '+
                '         } '+
                '    ], '+
                '    "parameters": { '+
                '        "SubscriptionName": "A-S00000251", '+
                '        "SuspendDate": "2017-03-10", '+
                '        "BCD": 20, '+
                '        "workflow": {} '+
                '    } '+
                '}'
            );
            res.setStatusCode(406);
            return res;
        }
    }

    static testMethod void testRestartNow() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');       
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.StartTest();
                MyAccountController objCntrl = new MyAccountController();
                PageReference pr = objCntrl.restartNow();
            Test.StopTest();
            System.assertNotEquals(null, pr);
        }  
    }

    //start increase test coverage 28.03.2017
    static testMethod void testConstr() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month'); 
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                MyAccountController myAccountController = new MyAccountController();
                myAccountController.strReactivationMsg = 'q';
                myAccountController.sBannerName = 'q';
                myAccountController.sBannerName = null;
                myAccountController.sCurrentPaypalEmail = 'q';
                myAccountController.lastPaymentInfo = 'q';
                myAccountController.oZPayment = null;
                System.assertNotEquals(null, myAccountController);
            Test.stopTest();
        }
    }

    static testMethod void testActiveGrace() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        bAccount.Zuora__MRR__c = 100.00;
        update bAccount;
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        zSubsp.Zuora__TermSettingType__c = 'EVERGREEN';
        update zSubsp;
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);        
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            MyAccountController myAccountController = new MyAccountController();
            myAccountController.getZuoraUserSubscription();
            myAccountController.activeGrace();
            System.assertNotEquals(null, myAccountController);
        }
    }

    static testMethod void testSignOutOfSingleDevicesUpdated1() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        User_Devices__c singleDev = SetUpTestData.createUserDevice(oAccount.Id, 'Test User Device', System.today(), 'Desktop' , 'Active');

        System.runAs(oUser){
            Test.StartTest();
                PageReference pr = MyAccountController.signOutOfSingleDevicesUpdated(new List<User_Devices__c>{singleDev}, new List<User>{oUser});
                System.assertEquals(null, pr);
            Test.StopTest();
        }        
    }

    static testMethod void testSignOutOfSingleDevicesUpdated1Exception() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        User_Devices__c singleDev = SetUpTestData.createUserDevice(oAccount.Id, 'Test User Device', System.today(), 'Desktop' , 'Active');

        System.runAs(oUser){
            Test.StartTest();
                PageReference pr = MyAccountController.signOutOfSingleDevicesUpdated(new List<User_Devices__c>(), new List<User>{oUser});
                System.assertNotEquals(null, pr);
            Test.StopTest();
        }        
    }
    //end increase test coverage 28.03.2017

    // test for email changes
    static testMethod void testEmailChangeOldEmail(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        oAccount.Retrieve_Email__c = oAccount.FirstName + '-' + oAccount.LastName + '-' + '1111';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        

        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objctrl = new MyAccountController(); 
                objctrl.strNewEmail = oUser.Email;
                objctrl.saveEmailChanges();
            Test.stopTest();

            System.assertEquals(Label.LS_Myaccount_ErrMsg_ProvideNewEmail, objctrl.sEmailProvideNewEmailErrorMsg);
        }
    }

    // test for email changes
    static testMethod void testEmailChangeEmailExists(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        oAccount.Retrieve_Email__c = oAccount.FirstName + '-' + oAccount.LastName + '-' + '1111';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objctrl = new MyAccountController(); 
                objctrl.strNewEmail = oAccount.PersonEmail;
                objctrl.saveEmailChanges();
            Test.stopTest();

            System.assertEquals(Label.LS_MyAccount_ErrMsg_EmailIDExists, objctrl.sEmailProvideNewEmailErrorMsg);
        }
    }

    // test for email changes
    static testMethod void testEmailChangeEmailcorrectPass(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        oAccount.Retrieve_Email__c = oAccount.FirstName + '-' + oAccount.LastName + '-' + '1111';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objctrl = new MyAccountController(); 
                objctrl.strPassword = 'qqq';
                objctrl.strNewEmail = 'test123@test.tt';
                objctrl.saveEmailChanges();
            Test.stopTest();
        }
    }

    // test for email changes
    static testMethod void testUpdateUserLanguageException(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
    
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objctr = new MyAccountController();
                objctr.strSelectedLanguage = '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
                PageReference pr = objctr.updateUserLanguage();
            Test.stopTest();
            System.assertNotEquals(null, pr);
        }
    }

    static testMethod void testActivePaidReactivation() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);        
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            MyAccountController myAccountController = new MyAccountController();
            myAccountController.oActSubscription = zSubsp;
            myAccountController.sBannerName = 'reactivation';
            myAccountController.getZuoraUserSubscription();
            myAccountController.activePaid();
            System.assertNotEquals(null, myAccountController);
        }
    }

    static testMethod void testActivePaidCancellation() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);        
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            MyAccountController myAccountController = new MyAccountController();
            myAccountController.sBannerName = 'cancellation';
            myAccountController.getZuoraUserSubscription();
            myAccountController.activePaid();
            System.assertNotEquals(null, myAccountController);
        }
    }

    static testMethod void testFreeTrialReactivation() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);        
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            MyAccountController myAccountController = new MyAccountController();
            myAccountController.oActSubscription = zSubsp;
            myAccountController.sBannerName = 'reactivation';
            myAccountController.freeTrial();
            System.assertNotEquals(null, myAccountController);
        }
    }

    static testMethod void testFreeTrialCancellation() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Frozen');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);        
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            MyAccountController myAccountController = new MyAccountController();
            myAccountController.sBannerName = 'cancellation';
            myAccountController.freeTrial();
            System.assertNotEquals(null, myAccountController);
        }
    }

    static testMethod void testGetUserDevices() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        List<User_Devices__c> listofUserDevices = new list<User_Devices__c>();
        listofUserDevices.add(
            new User_Devices__c(
                Account__c = oAccount.id,
                Device_Name__c = 'DN-0000011111',
                Date_Of_Registration__c = System.today(),
                Type__c = 'Tablet',
                Status__c = 'Active'
            )
        );
        listofUserDevices.add(
            new User_Devices__c(
                Account__c = oAccount.id,
                Device_Name__c = 'DN-0000011112',
                Date_Of_Registration__c = System.today(),
                Type__c = 'Tablet',
                Status__c = 'Active'
            )
        );
        listofUserDevices.add(
            new User_Devices__c(
                Account__c = oAccount.id,
                Device_Name__c = 'DN-0000011113',
                Date_Of_Registration__c = System.today(),
                Type__c = 'Tablet',
                Status__c = 'Active'
            )
        );
        listofUserDevices.add(
            new User_Devices__c(
                Account__c = oAccount.id,
                Device_Name__c = 'DN-0000011114',
                Date_Of_Registration__c = System.today(),
                Type__c = 'Tablet',
                Status__c = 'Active'
            )
        );
        insert listofUserDevices;

        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        Test.StartTest();
            System.runAs(oUser) {
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.showAllUserDevices();
                System.assertNotEquals(null, objCntrl);
            }
        Test.StopTest();
    }

    static testMethod void testGetEmailPreferences() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
           Test.startTest();
                MyAccountController myAccountController = new MyAccountController();
                myAccountController.getEmailPreferences();
                System.assertEquals(true, myAccountController.bEmailPreference);
            Test.stopTest(); 
        }
    }

    static testMethod void testNavigateuserShowCancelSubscription(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        oAccount.Submitted_for_cancellation__c = true;
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 


        Test.startTest();
            System.runAs(oUser){
                ApexPages.currentPage().getParameters().put('setepref', 'true');
                ApexPages.currentPage().getHeaders().put('referer', 'https://lsdev-dazn.cs88.force.com/MyAccount');

                MyAccountController objctrl = new MyAccountController();
                objctrl.subscriptionType = 'test';
                objctrl.navigateUser();
                System.assertEquals(false, objctrl.showCancelSubscription);
            }
        Test.stopTest();
    }

    static testMethod void testNavigateuserIsShowPaymentChange(){
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        oAccount.Submitted_for_cancellation__c = false;
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        Test.startTest();
            System.runAs(oUser){
                ApexPages.currentPage().getParameters().put('setepref', 'true');
                MyAccountController objctrl = new MyAccountController();
                objctrl.subscriptionType = 'test';
                objctrl.navigateUser();
                System.assertEquals(false, objctrl.isShowPaymentChange);
            }
        Test.stopTest();
    }

    static testMethod void testSingleDeviceFunctionalityException() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        User_Devices__c singleDev = SetUpTestData.createUserDevice(oAccount.Id, 'Test User Device', System.today(), 'Desktop' , 'Active');
        
        System.runAs(oUser) {   
            PageReference oPageReference = Page.MyAccount; 
            Test.setCurrentPage(oPageReference); 
            MyAccountController objCntrl = new MyAccountController();
            objCntrl.selectedDeviceID = null;
            objCntrl.user = oUser;
            objCntrl.deregisterSingelUserDevice();
            System.assertNotEquals(null, MyAccountController.errorPage);
        }        
    }

    static testMethod void testsaveNameChangesException() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        User_Devices__c singleDev = SetUpTestData.createUserDevice(oAccount.Id, 'Test User Device', System.today(), 'Desktop' , 'Active');
        
        System.runAs(oUser) {   
            PageReference oPageReference = Page.MyAccount; 
            Test.setCurrentPage(oPageReference); 
            MyAccountController objCntrl = new MyAccountController();
            objCntrl.strFirstName = 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
            objCntrl.strLastName = 'llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll';
            objCntrl.saveNameChanges();
            System.assertNotEquals(null, MyAccountController.errorPage);
        }
    }

    static testMethod void testNavigateToWhyPagePauseOrCancel() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        oAccount.Account_Status__c = 'Active Paid';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        Test.StartTest();
            System.runAs(oUser) {
                MyAccountController objCntrl = new MyAccountController();
                
                PageReference pr = objCntrl.naviagateToWhyPage();

                objCntrl.getNFLMarketingPreferences();
                objCntrl.setNFLMarketingPreferences();

                System.assertNotEquals(null, pr);
            }
        Test.StopTest();
    }

    static testMethod void testShowBannerNextChargeDateNull() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser) {
            Test.startTest();
            ApexPages.currentPage().getParameters().put('resumeDate', '2017-03-11');
            ApexPages.currentPage().getParameters().put('suspendDate', '2017-05-11');
            ApexPages.currentPage().getParameters().put('banner','Nextchargedatenull');

            MyAccountController myAccountController = new MyAccountController();
            myAccountController.showSetPauseBanner();

            System.assertEquals(true, myAccountController.showbanner);
            Test.stopTest();
        }
    }

    static testMethod void testGiftCodeExpiryBanner() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        oAccount.DAZN_Id__c = '3fsddfe0';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser) {
            Test.startTest();
                MyAccountController myAccountController = new MyAccountController();
        
                myAccountController.showGiftCodeExpiryBanner = true;
                myAccountController.closeGiftCodeExpiryBanner();
                System.assertEquals(false, myAccountController.showGiftCodeExpiryBanner);

                myAccountController.showGiftCodeExpiryBanner = true;
                PageReference pr = myAccountController.updatePaymentSettings();
                System.assertEquals(false, myAccountController.showGiftCodeExpiryBanner);
                System.assertEquals(Page.ChangePaymentMethod.getURL(), pr.getUrl());
            Test.stopTest();
        }        
    }

    /*PD-15208*/
    @IsTest
    static void testChangeLanguageCorrect() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        oAccount.DAZN_Id__c = '3fsddfe0';
        oAccount.Notification_Country_Code__c = 'en_GB';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objCntrl = new MyAccountController();
                Test.setMock(HttpCalloutMock.class, new MockUpdateUserDetailsSuccessResponse());
                objCntrl.sCountryCode= 'DE';
                objCntrl.strSelectedLanguage = 'DE';            
                objCntrl.updateUserLanguage();
            Test.stopTest();
            User us = [SELECT Id, LanguageLocaleKey, Account.Notification_Country_Code__c FROM User WHERE Id = :oUser.Id LIMIT 1];
            System.assert(us.Account.Notification_Country_Code__c.toLowerCase() != null);
        }

        
    }

    @IsTest
    static void testChangeLanguageCorrectfr() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        oAccount.DAZN_Id__c = '3fsddfe0';
        oAccount.Notification_Country_Code__c = 'CA';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser) {
            Test.startTest();
                
                MyAccountController objCntrl = new MyAccountController();
                Test.setMock(HttpCalloutMock.class, new MockUpdateUserDetailsSuccessResponse());
                objCntrl.sCountryCode= 'CA';
                objCntrl.strSelectedLanguage = 'fr';            
                objCntrl.updateUserLanguage();
            Test.stopTest();
            User us = [SELECT Id, LanguageLocaleKey, Account.Notification_Country_Code__c FROM User WHERE Id = :oUser.Id LIMIT 1];
            System.assert(us.Account.Notification_Country_Code__c.toLowerCase() != null);
        }        
    }
    @IsTest
    static void testChangeLanguageCorrectfr_CA() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        oAccount.DAZN_Id__c = '3fsddfe0';
        oAccount.Notification_Country_Code__c = 'CA';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser) {
            Test.startTest();
                
                MyAccountController objCntrl = new MyAccountController();
                Test.setMock(HttpCalloutMock.class, new MockUpdateUserDetailsSuccessResponse());
                objCntrl.sCountryCode= 'CA';
                objCntrl.strSelectedLanguage = 'fr_CA';            
                objCntrl.updateUserLanguage();
            Test.stopTest();
            User us = [SELECT Id, LanguageLocaleKey, Account.Notification_Country_Code__c FROM User WHERE Id = :oUser.Id LIMIT 1];
            System.assert(us.Account.Notification_Country_Code__c.toLowerCase() != null);
        }        
    }
    @IsTest
    static void testChangeLanguageCorrecten_US() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        oAccount.DAZN_Id__c = '3fsddfe0';
        oAccount.Notification_Country_Code__c = 'CA';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        

        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objCntrl = new MyAccountController();
                Test.setMock(HttpCalloutMock.class, new MockUpdateUserDetailsSuccessResponse());
                objCntrl.sCountryCode= 'CA';
                objCntrl.strSelectedLanguage = 'en_US';            
                objCntrl.updateUserLanguage();
            Test.stopTest();
            User us = [SELECT Id, LanguageLocaleKey, Account.Notification_Country_Code__c FROM User WHERE Id = :oUser.Id LIMIT 1];
            System.assert(us.Account.Notification_Country_Code__c.toLowerCase() != null);
        }        
    }
    public class MockUpdateUserDetailsSuccessResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                  '"UserDetails": {' +
                    '"AccountId": "0019E00000PEe1mQAD",' +
                    '"Email": "test@test.test",' +
                    '"FirstName": "TestDEUseTest",' +
                    '"LastName": "SkorTest",' +
                    '"LanguageCode": "DE",' +
                    '"DaznEmailsOptIn": false,' +
                    '"NflEmailsOptIn": false,' +
                    '"UserAccountStatus": "Active Paid"' +
                  '}' +
               '}'
            );
            res.setStatusCode(200);
            return res;
        }
    }

    @IsTest
    static void testChangeLanguageShowBanner() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        oAccount.DAZN_Id__c = '3fsddfe0';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        
        System.runAs(oUser) {
            Test.startTest();
                ApexPages.currentPage().getParameters().put('banner', 'updateLanguageFail');
                MyAccountController myAccountController = new MyAccountController();
                myAccountController.nextPayValForPause = 'test';
                myAccountController.expiryYear = 'test';
                myAccountController.expiryMonth = 'test';
                myAccountController.sCurrency = 'test';
                System.assert(myAccountController.showbanner == true);
            Test.stopTest();
        }
    }
    /*End 15208*/

    /*Start PD-15209*/
    @IsTest
    static void testSendToMISL() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active Paid');
        oAccount.DAZN_Id__c = '3fsddfe0';
        update oAccount;
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        User us = [SELECT Id, Account.DAZN_Id__c, AccountId FROM User WHERE Id = :oUser.Id];
        System.runAs(us) {
            Test.startTest();
                MyAccountController.sendEmailtoMISL(us,'strNewEmail@test.te', 'DE');
                new MyAccountController().redeemGiftCode();
                new MyAccountController().showPayerror = 'test';
            Test.stopTest();
        }
    }
    /*End part of 15209*/

    /*Start part of PD-12480*/
    @IsTest
    static void testGetDevicesIncorrectJSON() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1146543@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                
                Test.setMock(HttpCalloutMock.class, new MockUserDevicesResponse());
                MyAccountController myAccountController = new MyAccountController();
                myAccountController.getUserDevices();
                System.assert(myAccountController.isDevicesFromMISL == true);
                
                System.assert(myAccountController.wrapUDList.isEmpty());

            Test.stopTest();
        }
    }

    @IsTest
    static void testGetDevicesCorrectJSON() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1145322@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                
                Test.setMock(HttpCalloutMock.class, new MockUserDevicesResponseCorrectJSON());
                MyAccountController myAccountController = new MyAccountController();
                myAccountController.getUserDevices();
                System.assert(myAccountController.isDevicesFromMISL == true);
                System.assert(myAccountController.wrapUDList.isEmpty() == false);

            Test.stopTest();
        }
    }

    @IsTest
    static void testGetDevicesFourDevices() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1149876@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                
                Test.setMock(HttpCalloutMock.class, new MockUserDevicesResponseFourDevices());
                MyAccountController myAccountController = new MyAccountController();
                myAccountController.getUserDevices();
                System.assert(myAccountController.isDevicesFromMISL == true);
                System.assert(myAccountController.wrapUDListFull.size() > 3);

            Test.stopTest();
        }
    }

    @IsTest
    static void testGetDevicesFourDevicesShowAllUserDevices() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername114534@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                
                Test.setMock(HttpCalloutMock.class, new MockUserDevicesResponseFourDevices());
                MyAccountController myAccountController = new MyAccountController();
                myAccountController.showAllUserDevices();
                myAccountController.getUserDevices();
                System.assert(myAccountController.isDevicesFromMISL == true);
                System.assert(myAccountController.wrapUDListFull.size() > 3);

            Test.stopTest();
        }
    }

    @IsTest
    static void testShowSignOutBannersinledevice() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername1141111@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                
                Test.setMock(HttpCalloutMock.class, new MockUserDevicesResponseFourDevices());
                MyAccountController myAccountController = new MyAccountController();
                myAccountController.getUserDevices();
                System.assert(myAccountController.isDevicesFromMISL == true);
                myAccountController.showSignOutBannersinledevice();
                System.assert(myAccountController.showStartWatchingDAZN == false);

            Test.stopTest();
        }
    }

    @IsTest
    static void testDeregisterSingelUserDevice() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername11214@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();

                MyAccountController myAccountController = new MyAccountController();
                myAccountController.selectedDeviceID = 'deviceId1';
                //myAccountController.strCurrentCountry = 'DE';
                Test.setMock(HttpCalloutMock.class, new MockDeregisterSingleDevice());
                myAccountController.deregisterSingelUserDevice();
                List<AuthSession> auth = [SELECT Id FROM AuthSession WHERE UsersId = :oUser.Id];
                System.assert(auth.isEmpty());
            Test.stopTest();
        }
    }

    @IsTest
    static void testDeregisterSingelUserDeviceSuccess() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        /*oAccount.Notification_Country_Code__c = 'de';
        update oAccount;*/
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusernam123e114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();

                MyAccountController myAccountController = new MyAccountController();
                myAccountController.selectedDeviceID = 'deviceId1';
                //myAccountController.strCurrentCountry = 'DE';
                Test.setMock(HttpCalloutMock.class, new MockDeregisterSingleDevice());
                myAccountController.deregisterSingelUserDevice();
                List<AuthSession> auth = [SELECT Id FROM AuthSession WHERE UsersId = :oUser.Id];
                System.assert(auth.isEmpty());
            Test.stopTest();
        }
    }
    @IsTest
    static void testDeleteAuth() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testuse12rname114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();

                MyAccountController.deleteAuth(oUser.Id);
                
            Test.stopTest();
            List<AuthSession> auth = [SELECT Id FROM AuthSession WHERE UsersId = :oUser.Id];
            System.assert(auth.isEmpty());
        }
    }

    @IsTest
    static void testDeregisterSingelUserDeviceError() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        oAccount.Notification_Country_Code__c = 'de';
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusernamwe114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                ApexPages.currentPage().getParameters().put('banner', 'deregisterDeviceFail');
                MyAccountController myAccountController = new MyAccountController();
                myAccountController.signoutAllDevices();
                System.assert(myAccountController.showbanner == true);
            Test.stopTest();
        }
    }

    @IsTest
    static void testSignOutFromAllDevice() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        oAccount.Notification_Country_Code__c = 'de';
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusernfghame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();

                MyAccountController myAccountController = new MyAccountController();
                myAccountController.selectedDeviceID = 'deviceId1';
               // myAccountController.strCurrentCountry = 'DE';
                Test.setMock(HttpCalloutMock.class, new MockDeregisterSingleDevice());
                myAccountController.signoutAllDevices();
                List<AuthSession> auth = [SELECT Id FROM AuthSession WHERE UsersId = :oUser.Id];
                System.assert(auth.isEmpty());
            Test.stopTest();
        }
    }

    @IsTest
    static void testSignOutFromAllDeviceCancell() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        oAccount.Notification_Country_Code__c = 'de';
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testuserfghname114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();

                MyAccountController myAccountController = new MyAccountController();
                myAccountController.selectedDeviceID = 'deviceId1';
               // myAccountController.strCurrentCountry = 'DE';
                ApexPages.currentPage().getParameters().put('cancelButtonclick', 'true');
                Test.setMock(HttpCalloutMock.class, new MockDeregisterSingleDevice());
                myAccountController.signoutAllDevices();
                List<AuthSession> auth = [SELECT Id FROM AuthSession WHERE UsersId = :oUser.Id];
                System.assert(auth.isEmpty());
            Test.stopTest();
        }
    }

    @IsTest
    static void testCloseBanner() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testuserndasame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();

                MyAccountController myAccountController = new MyAccountController();
                myAccountController.closeBanner();
                System.assert(myAccountController.showbanner == false);
            Test.stopTest();
        }
    }

    @IsTest
    static void testShowSignOutBanner() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusersdfname114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();

                MyAccountController myAccountController = new MyAccountController();
                myAccountController.nextPayValForPause = 'test';
                myAccountController.showSignOutBanner();
                System.assert(myAccountController.showbanner == true);
            Test.stopTest();
        }
    }
    public class MockUserDevicesResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                    '"Devices": [' +
                        '{' +
                            '"Id": "deviceId1",' +
                            '"RegistrationDate": "2017-03-10 10:42:43.379Z",' +
                            '"Type": "Tablet"' +
                        '},' +
                        '{' +
                            '"Id": "deviceId2",' +
                            '"RegistrationDate": "2017-03-11 10:44:43.379Z",' +
                            '"Type": "TV"' +
                        '}' +
                    ']' +
                '}'
            );
            res.setStatusCode(200);
            return res;
        }
    }
    public class MockUserDevicesResponseCorrectJSON implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                    '"Devices": [' +
                        '{' +
                            '"Id": "deviceId1",' +
                            '"RegistrationDate": "2017-03-10T10:42:43.379Z",' +
                            '"Type": "Tablet"' +
                        '},' +
                        '{' +
                            '"Id": "deviceId2",' +
                            '"RegistrationDate": "2017-03-11T10:44:43.379Z",' +
                            '"Type": "TV"' +
                        '}' +
                    ']' +
                '}'
            );
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockUserDevicesResponseFourDevices implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                    '"Devices": [' +
                        '{' +
                            '"Id": "deviceId1",' +
                            '"RegistrationDate": "2017-03-10T10:42:43.379Z",' +
                            '"Type": "Tablet"' +
                        '},' +
                        '{' +
                            '"Id": "deviceId2",' +
                            '"RegistrationDate": "2017-03-11T10:44:43.379Z",' +
                            '"Type": "TV"' +
                        '},' +
                        '{' +
                            '"Id": "deviceId3",' +
                            '"RegistrationDate": "2017-03-10T10:42:43.379Z",' +
                            '"Type": "Tablet"' +
                        '},' +
                        '{' +
                            '"Id": "deviceId4",' +
                            '"RegistrationDate": "2017-03-10T10:42:43.379Z",' +
                            '"Type": "Tablet"' +
                        '}'+
                    ']' +
                '}'
            );
            res.setStatusCode(200);
            return res;
        }
    }
    public class MockDeregisterSingleDevice implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                '"Device(s) de-registered"' +
                '}'
            );
            res.setStatusCode(204);
            return res;
        }
    }
    /*End part of PD12480*/
   static testMethod void testGetSFDCSubscriptionDescription() {
        //SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'tqewtretrewtet@test.com', 'Active Paid');
       
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD', '1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Test Zuora', 'Active', System.today(), System.today() + 30);

        Test.startTest();
        String subscriptionDescription = MyAccountController.getSFDCSubscriptionDescription(
            'scenario',
            '[Zuora__NextChargeDate__c][Zuora__Price__c][Free_Trial_End_Date__c][Gift_Code_End_Date__c][Zuora__SubscriptionEndDate__c]',
            zSubsp,
            oAccount,
            'sCurrency'
        );
        Test.stopTest();

        System.assertNotEquals(null, subscriptionDescription);
    }

    static testMethod void testGetSFDCSubscriptionDescriptionScenario() {
        //SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'dfgdfsgdfgsd@test.com', 'Active Paid');
        
                
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD', '1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Test Zuora', 'Active', System.today(), System.today() + 30);

        Test.startTest();
        String subscriptionDescription = MyAccountController.getSFDCSubscriptionDescription(
            'Active PaidNOT blankActiveEVERGREEN',
            '[Zuora__NextChargeDate__c][Zuora__Price__c][Free_Trial_End_Date__c][Gift_Code_End_Date__c][Zuora__SubscriptionEndDate__c]',
            zSubsp,
            oAccount,
            'sCurrency'
        );
        Test.stopTest();

        System.assertNotEquals(null, subscriptionDescription);
    }

    

    static testMethod void testActivePaidShowResubscribe() {
        //SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'hjkhjkhjkghkhj@test.com', 'Active Paid');
        //Nayan
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);         
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD', '1st of the month');
        
        System.runAs(oUser){
            Test.startTest();
            MyAccountController ctrl = new MyAccountController();
            ctrl.lstCustomerAccount = new List<Zuora__CustomerAccount__c>{ bAccount };
            ctrl.sBannerName = 'cancellation';
            ctrl.activePaid();
            Test.stopTest();    
        }
        
    }

  

    static testMethod void testFreeTrialShowResubscribe() {
        //SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'fdhdgfhrethxcgbn@test.com', 'Active Paid');
        //Nayan
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);         
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD', '1st of the month');
      
        System.runAs(oUser){
            Test.startTest();
            MyAccountController ctrl = new MyAccountController();
            
            ctrl.lstCustomerAccount = new List<Zuora__CustomerAccount__c>{ bAccount };
            ctrl.sBannerName = 'cancellation';
            ctrl.freeTrial();
            Test.stopTest();    
        }
        
    }
    
    
     static testMethod void testGetSFDCSubscriptionDescriptionchargeDtNull() {
        //SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'dfgdfsgdfgsd@test.com', 'Active Paid');
       
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD', '1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Test Zuora', 'Active', null, null);

        Test.startTest();
        String subscriptionDescription = MyAccountController.getSFDCSubscriptionDescription(
            'scenario',
            '[Zuora__NextChargeDate__c][Zuora__Price__c][Free_Trial_End_Date__c][Gift_Code_End_Date__c][Zuora__SubscriptionEndDate__c]',
            zSubsp,
            oAccount,
            'sCurrency'
        );
        Test.stopTest();

        System.assertNotEquals(null, subscriptionDescription);
    }
    /*Start part of PD-16346*/
    @IsTest
    static void testSaveNameMISL() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        oAccount.Notification_Country_Code__c = 'de';
        update oAccount;
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testuserfghname114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();

                MyAccountController myAccountController = new MyAccountController();
                ApexPages.currentPage().getParameters().put('cancelButtonclick', 'true');
                myAccountController.sCountryCode = null;
                myAccountController.strFirstName = 'NameTest';
                myAccountController.strLastName = 'NameTestSec';
                myAccountController.saveNameChanges();
                System.assert(myAccountController.sAccountName == 'NameTest NameTestSec');
            Test.stopTest();
        }
    }
    /*End part of PD-16346*/

    @IsTest
    static void testpasswordChangesMISLSuccess() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusernamdfg43e114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objCntrl = new MyAccountController();
                Test.setMock(HttpCalloutMock.class, new MockChangePassword());
                objCntrl.strPassword = 'TestPassword';
                objCntrl.strNewPassword = 'test1234';
                objCntrl.strRepeatPassword = 'test1234';            
                objCntrl.savePasswordChanges();
                System.assert(objCntrl.isPasswordEdit == false);
            Test.stopTest();
        }
    }

    @IsTest
    static void testpasswordChangesMISLError() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testuserna34rfme114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.strPassword = 'TestPassword';
                objCntrl.strNewPassword = 'test1234';
                objCntrl.strRepeatPassword = 'test1234';            
                objCntrl.savePasswordChanges();
                System.assert(objCntrl.sPasswordIncorrectCurrentPasswordErrMsg != null);
            Test.stopTest();
        }
    }

    @IsTest
    static void testpasswordChangesMISLSuccessSSO() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUserSSO(oAccount.Id, 'testemail@email.com', 'testus34dername114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objCntrl = new MyAccountController();
                Test.setMock(HttpCalloutMock.class, new MockChangePassword());
                objCntrl.strPassword = 'TestPassword';
                objCntrl.strNewPassword = 'test1234';
                objCntrl.strRepeatPassword = 'test1234';            
                objCntrl.savePasswordChanges();
                System.assert(objCntrl.sPasswordIncorrectCurrentPasswordErrMsg != null);
            Test.stopTest();
        }
    }
    @IsTest
    static void testpasswordChangesMISLSuccessUserIsNOTSSO() {
        SetUpTestData.createMISLSetting();
        DAZNConfiguration__c daznConfig = DAZNConfiguration__c.getValues('SSO Enabled Country Codes');
        daznConfig.Value__c = 'CA';
        update daznConfig;
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testus34dername114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objCntrl = new MyAccountController();
                Test.setMock(HttpCalloutMock.class, new MockChangePassword());
                objCntrl.strPassword = 'TestPassword';
                objCntrl.strNewPassword = 'test1234';
                objCntrl.strRepeatPassword = 'test1234';            
                objCntrl.savePasswordChanges();
                System.assert(objCntrl.sPasswordIncorrectCurrentPasswordErrMsg != null);
            Test.stopTest();
        }
    }

    @IsTest
    static void testpasswordChangesMISLErrorSSO() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');

        User oUser = SetUpTestData.createCommunityUserSSO(oAccount.Id, 'testemail@email.com', 'testuseertrname114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objCntrl = new MyAccountController();
                objCntrl.strPassword = 'TestPassword';
                objCntrl.strNewPassword = 'test1234';
                objCntrl.strRepeatPassword = 'test1234';            
                objCntrl.savePasswordChanges();
                System.assert(objCntrl.sPasswordIncorrectCurrentPasswordErrMsg != null);
            Test.stopTest();
        }
    }

    @IsTest
    static void testChangePasswordShowBanner() {
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        User oUser = SetUpTestData.createCommunityUserSSO(oAccount.Id, 'testemail@email.com', 'testuserdfgbname114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 
        System.runAs(oUser) {
            Test.startTest();
                ApexPages.currentPage().getParameters().put('banner', 'updatePasswordFail');
                MyAccountController myAccountController = new MyAccountController();

                System.assert(myAccountController.showbanner == true);
            Test.stopTest();
        }
    }
    /*end 12483*/

    public class MockChangePassword implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                '"Password Changed"' +
                '}'
            );
            res.setStatusCode(200);
            return res;
        }
    }

    /*Start part of PD-12491*/
    @IsTest
    static void testChangeEmailPreferenceCorrect() {
        SetUpTestData.createMISLSetting();
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        oAccount.Notification_Country_Code__c = 'de';
        update oAccount;
        User oUser = SetUpTestData.createCommunityUserSSO(oAccount.Id, 'testemail@email.com', 'testuserndgf45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                MyAccountController objCntrl = new MyAccountController();
                Test.setMock(HttpCalloutMock.class, new MockUpdateUserDetailsSuccessResponse());
                objCntrl.sCountryCode = 'DE';
                objCntrl.bEmailPreference = false;            
                objCntrl.setEmailPreferences();
            Test.stopTest();
            //User us = [SELECT Id, LanguageLocaleKey FROM User WHERE Id = :oUser.Id LIMIT 1];
            //System.assertEquals(us.LanguageLocaleKey,'de');
        }
    }

    @IsTest
    static void testChangeEmailPreferenceShowBanner() {
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFName', 'TestLName', 'test@test.com', 'Active');
        oAccount.Notification_Country_Code__c = 'de';
        update oAccount;
        User oUser = SetUpTestData.createCommunityUserSSO(oAccount.Id, 'testemail@email.com', 'testusern45ame114@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','Test First Name','Test Last Name',true); 

        System.runAs(oUser) {
            Test.startTest();
                ApexPages.currentPage().getParameters().put('banner', 'updateEmailPreferenceFail');
                MyAccountController myAccountController = new MyAccountController();

                System.assert(myAccountController.showbanner == true);
            Test.stopTest();
        }
    }

    public class MockChangeEmailPreference implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{' +
                '"User Updated"' +
                '}'
            );
            res.setStatusCode(200);
            return res;
        }
    }
    /*End part of PD-12491*/
}