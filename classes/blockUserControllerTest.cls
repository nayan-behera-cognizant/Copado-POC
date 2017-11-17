/*Testing the Block user Functionality */
@istest(seeAllData=True)
public class blockUserControllerTest {
    
    static testMethod void testIfErrorAccountNotFound() {
        /* Create Customer Agent User */
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        
        Test.StartTest();
        System.RunAs(oCSUser){  
            PageReference oPageReference = Page.BlockUserPage; 
            Test.setCurrentPage(oPageReference); 
            ApexPages.currentPage().getParameters().put('aId', '123456');
            blockUserController  objCntrl = new blockUserController();
            objCntrl.refundstatus='Block without Refund';
            objCntrl.reportError ('Test error reporting');
            objCntrl.reportErrorWithoutReturn ('Test error reporting');
            objCntrl.save();
            System.assertEquals(true, objCntrl.navigateError);
        } 
        Test.StopTest();
    }
    
	static testMethod void testIfErrorAccountNotFound2(){
        /* Create Customer Agent User */
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        
        Test.StartTest();
        System.RunAs(oCSUser){  
            PageReference oPageReference = Page.BlockUserPage; 
            Test.setCurrentPage(oPageReference); 
            ApexPages.currentPage().getParameters().put('aId', '123456');
            blockUserController  objCntrl = new blockUserController();
			objCntrl.typeOfAccount = 'Apple';
            objCntrl.refundstatus='Block without Refund';
            objCntrl.reportError ('Test error reporting');
            objCntrl.reportErrorWithoutReturn ('Test error reporting');
            objCntrl.save();
            System.assertEquals(true, objCntrl.navigateError);
        } 
        Test.StopTest();
    }
    
    /*
     * checks if Error page is visible in case of missing Account Id
    */
    static testMethod void testIfNavigatesToErrorPage() {
        /* Create Customer Agent User */
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        Test.StartTest();
        System.RunAs(oCSUser){  
            PageReference oPageReference = Page.BlockUserPage; 
            Test.setCurrentPage(oPageReference); 
            ApexPages.currentPage().getParameters().put('aId', '');
            blockUserController  objCntrl = new blockUserController();
            objCntrl.refundstatus='Block without Refund';
            objCntrl.save();
            System.assertEquals(true, objCntrl.navigateError);
        } 
        Test.StopTest();
    }
    
    static testMethod void testBlockUserWithoutRefund() {
        /* Create Customer Agent User */
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        /*Create Community User and related Zuora records*/
        Test.StartTest();
        System.RunAs(oCSUser) {
            Account oTestAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
            System.assertNotEquals(null, oTestAccount.Id);
            User oCommunityUser = SetUpTestData.createCommunityUser(oTestAccount.Id, 'testemail1@email.com', 'testusername1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
            Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oTestAccount.Id,'test billing account', 'Active', 'TESTBL73', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
            Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oTestAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
            Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oTestAccount.Id, bAccount.Id, 0.00 );
            Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oTestAccount.Id,bAccount.Id,zInv.Id, 0.00);
            /* Create User Devices */
            list<string> lstDeviceTypes = new List<string>{'Desktop','Laptop','Mobile','Tablet','TV'};
            System.assertEquals(5, lstDeviceTypes.size());
            for (String s : lstDeviceTypes) {
                SetUpTestData.createUserDevice(oTestAccount.Id, 'Test User Device', System.today(), s , 'Active');
            }
            PageReference oPageReference = Page.BlockUserPage; 
            Test.setCurrentPage(oPageReference); 
            ApexPages.currentPage().getParameters().put('aId', +oTestAccount.id);
            blockUserController  objCntrl = new blockUserController();
            objCntrl.refundstatus = 'Block without Refund';
            objCntrl.save();
            System.assertEquals(true, objCntrl.navigateError);
        } 
        Test.StopTest();
    }
    
    static testMethod void testBlockUserWithoutRefund2() {
        /* Create Customer Agent User */
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        /*Create Community User and related Zuora records*/
        Test.StartTest();
        System.RunAs(oCSUser) {
            Account oTestAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Active Grace');
            System.assertNotEquals(null, oTestAccount.Id);
            User oCommunityUser = SetUpTestData.createCommunityUser(oTestAccount.Id, 'testemail1@email.com', 'testusername1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
            Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oTestAccount.Id,'test billing account', 'Active', 'TESTBL73', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
            Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oTestAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
            Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oTestAccount.Id, bAccount.Id, 0.00 );
            Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oTestAccount.Id,bAccount.Id,zInv.Id, 0.00);
            /* Create User Devices */
            list<string> lstDeviceTypes = new List<string>{'Desktop','Laptop','Mobile','Tablet','TV'};
            System.assertEquals(5, lstDeviceTypes.size());
            for (String s : lstDeviceTypes) {
                SetUpTestData.createUserDevice(oTestAccount.Id, 'Test User Device', System.today(), s , 'Active');
            }
            PageReference oPageReference = Page.BlockUserPage; 
            Test.setCurrentPage(oPageReference); 
            ApexPages.currentPage().getParameters().put('aId', +oTestAccount.id);
            blockUserController  objCntrl = new blockUserController();
            objCntrl.refundstatus = 'Block without Refund';
            objCntrl.save();
            System.assertEquals(true, objCntrl.navigateError);
        } 
        Test.StopTest();
    }
    
    static testMethod void testBlockUserWithoutRefund3() {
        /* Create Customer Agent User */
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        /*Create Community User and related Zuora records*/
        Test.StartTest();
            System.RunAs(oCSUser) {
            Account oTestAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Active Grace');
            System.assertNotEquals(null, oTestAccount.Id);
            User oCommunityUser = SetUpTestData.createCommunityUser(oTestAccount.Id, 'testemail1@email.com', 'testusername1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
            Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oTestAccount.Id,'test billing account', 'Active', 'TESTBL73', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
            Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oTestAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
            Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oTestAccount.Id, bAccount.Id, 0.00 );
            Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oTestAccount.Id,bAccount.Id,zInv.Id, 0.00);
            zPay.Zuora__SettledOn__c = system.today();
            update zPay;
            /* Create User Devices */
            list<string> lstDeviceTypes = new List<string>{'Desktop','Laptop','Mobile','Tablet','TV'};
            System.assertEquals(5, lstDeviceTypes.size());
            for (String s : lstDeviceTypes) {
                SetUpTestData.createUserDevice(oTestAccount.Id, 'Test User Device', System.today(), s , 'Active');
            }
            PageReference oPageReference = Page.BlockUserPage; 
            Test.setCurrentPage(oPageReference); 
            ApexPages.currentPage().getParameters().put('aId', +oTestAccount.id);
            blockUserController  objCntrl = new blockUserController();
            objCntrl.refundstatus = 'Block without Refund';
            objCntrl.save();
            System.assertEquals(true, objCntrl.navigateError);
        } 
        Test.StopTest();
    }
    
    static testMethod void testBlockUserWithBlocked() {
        /* Create Customer Agent User */
        //SetUpTestData.triggerSettings();
        //SetUpTestData.emailCustsett();
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        /*Create Community User and related Zuora records*/
        Test.StartTest();
        System.RunAs(oCSUser) {
            Account oTestAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Blocked');
            System.assertNotEquals(null, oTestAccount.Id);
            
            User oCommunityUser = SetUpTestData.createCommunityUser(oTestAccount.Id, 'testemail1@email.com', 'testusername1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
            Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oTestAccount.Id,'test billing account blocked', 'Active', 'TESTBLOCKED', 'testbill Name blocked', 'United Kingdom', 'test bill name blocked', 'Credit Card', 'batch2', 'USD','1st of the month');
            Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oTestAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
            Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oTestAccount.Id, bAccount.Id, 0.00 );
            Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oTestAccount.Id,bAccount.Id,zInv.Id, 0.00);
            /* Create User Devices */
            list<string> lstDeviceTypes = new List<string>{'Desktop','Laptop','Mobile','Tablet','TV'};
            System.assertEquals(5, lstDeviceTypes.size());
            for (String s : lstDeviceTypes) {
                SetUpTestData.createUserDevice(oTestAccount.Id, 'Test User Device', System.today(), s , 'Active');
            }
            PageReference oPageReference = Page.BlockUserPage; 
            Test.setCurrentPage(oPageReference); 
            ApexPages.currentPage().getParameters().put('aId', +oTestAccount.id);
            blockUserController  objCntrl = new blockUserController();
            objCntrl.refundstatus = 'Blocked';
            objCntrl.save();
            System.assertEquals(true, objCntrl.navigateError);
        }
        Test.StopTest();
    }

    static testMethod void testBlockUserWithBlockedWeb() {
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        Test.StartTest();
            System.RunAs(oCSUser) {
                Account oTestAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Blocked');
                System.assertNotEquals(null, oTestAccount.Id);
                User oCommunityUser = SetUpTestData.createCommunityUser(oTestAccount.Id, 'testemail1@email.com', 'testusername1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
                Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oTestAccount.Id,'test billing account blocked', 'Active', 'TESTBLOCKED', 'testbill Name blocked', 'United Kingdom', 'test bill name blocked', 'Credit Card', 'batch2', 'USD','1st of the month');
                Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oTestAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
                Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oTestAccount.Id, bAccount.Id, 0.00 );
                Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oTestAccount.Id,bAccount.Id,zInv.Id, 0.00);
                /* Create User Devices */
                list<string> lstDeviceTypes = new List<string>{'Desktop','Laptop','Mobile','Tablet','TV'};
                System.assertEquals(5, lstDeviceTypes.size());
                for (String s : lstDeviceTypes) {
                    SetUpTestData.createUserDevice(oTestAccount.Id, 'Test User Device', System.today(), s , 'Active');
                }
                PageReference oPageReference = Page.BlockUserPage; 
                Test.setCurrentPage(oPageReference); 
                ApexPages.currentPage().getParameters().put('aId', +oTestAccount.id);
                BlockUserController.saveWeb(oTestAccount.Id);
            }
        Test.StopTest();
    }
    
    /*Added as a part of PD-10582*/
    /*Method to test docomo accounts*/
    static testMethod void testBlockUserWithBlockedDocomo() {
       User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        /*Create Community User and related Zuora records*/
        Test.StartTest();
        System.RunAs(oCSUser) {
            Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail@email.com','Blocked','testpartner123', 'Docomo');
            System.assertNotEquals(null, oTestAccount.Id);
            User oCommunityUser = SetUpTestData.createCommunityUser(oTestAccount.Id, 'testemail1@email.com', 'testusername1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
            PageReference oPageReference = Page.BlockUserPage; 
            Test.setCurrentPage(oPageReference); 
            ApexPages.currentPage().getParameters().put('aId', +oTestAccount.id);
            blockUserController  objCntrl = new blockUserController();
            objCntrl.refundstatus = 'Blocked';
            objCntrl.save();
            System.assertEquals(false, objCntrl.navigateError);
        }
        Test.StopTest();
    }
    
    static testMethod void testBlockUserWithUnblockedBlocked() {
       User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        /*Create Community User and related Zuora records*/
        Test.StartTest();
        System.RunAs(oCSUser) {
            Account oTestAccount = SetUpTestData.createDfDAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial','testpartner123', 'Docomo');
            System.assertNotEquals(null, oTestAccount.Id);
            User oCommunityUser = SetUpTestData.createCommunityUser(oTestAccount.Id, 'testemail1@email.com', 'testusername1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
            PageReference oPageReference = Page.BlockUserPage; 
            Test.setCurrentPage(oPageReference); 
            ApexPages.currentPage().getParameters().put('aId', +oTestAccount.id);
            blockUserController  objCntrl = new blockUserController();
            objCntrl.refundstatus = 'Blocked';
            objCntrl.save();
            System.assertEquals(false, objCntrl.navigateError);
        }
        Test.StopTest();
    }
    
}