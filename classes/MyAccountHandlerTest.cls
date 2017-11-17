@IsTest
public class MyAccountHandlerTest {
    @testSetup /* calling CreateTestDataforUnitTest */  
    public static void getCommUsersTestData(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateZuoraDataforUnitTest.createZuoraDeatils();
        CreateTestDataforUnitTest.createTestcustomsetting();
    }
    
    /*Testing the Name Change Functionality with multiple scenarios*/
    static testmethod void testsaveNameChanges(){
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Free Trial'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id,FirstName,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        system.runAs(oUser[0]){
            Test.startTest(); 
            MyAccountController objCntrl = new MyAccountController();
            PageReference pageRef1 = Page.MyAccount;
            Test.setCurrentPage(pageRef1);
            ApexPages.currentPage().getParameters().put('field','Name');
            objCntrl.strFirstName = oUser[0].FirstName;       
            objCntrl.strLastName = oUser[0].LastName;   
            objCntrl.cancelEdit();
            system.assertEquals(objCntrl.isNameEdit, false);
            objCntrl.edit();
            system.assertEquals(objCntrl.isNameEdit, true);
            objCntrl.strFirstName = 'TestFirstName';
            objCntrl.strLastName= 'TestLastName';
            objCntrl.SaveNameChanges();
            
            ApexPages.currentPage().getParameters().put('field','');
            objCntrl.strFirstName = oUser[0].FirstName;       
            objCntrl.strLastName = oUser[0].LastName;   
            objCntrl.Edit();
            
            ApexPages.currentPage().getParameters().put('field','');
            objCntrl.strFirstName = oUser[0].FirstName;       
            objCntrl.strLastName = oUser[0].LastName;   
            objCntrl.cancelEdit();
            
            Test.StopTest(); 
        }
    }
    /*Testing Name Change Functionality Validations*/
    static testmethod void testsaveNameChangesValidation(){
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Free Trial'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, FirstName,Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        system.runAs(oUser[0]){
            Test.StartTest();
            MyAccountController objCntrl = new MyAccountController();
            
            apexpages.currentpage().getParameters().put('cancelButtonError', 'true');
            objCntrl.sBannerName = objCntrl.getBanner();
            /*objCntrl.freeTrial();
            
            objCntrl.sBannerName = 'ResubscribesError';
            objCntrl.freeTrial(); */
            
            objCntrl.clearErrorFields();          
			
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4);
            objCntrl.strLastName = '';
            objCntrl.saveNameChanges();
            
            objCntrl.strFirstName = '1';
            objCntrl.saveNameChanges();
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4);
            objCntrl.strLastName = '2';
            objCntrl.saveNameChanges();
			
            
            objCntrl.strFirstName = '';
            objCntrl.strLastName = '';
            objCntrl.saveNameChanges();
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4)+'@#$%';
            objCntrl.saveNameChanges();
			
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4);
            objCntrl.strLastName = 'Test%^&*(12)$';
            objCntrl.saveNameChanges();
			
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4)+123;
            objCntrl.saveNameChanges();
			
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4);
            objCntrl.strLastName = 'Test123456';
            objCntrl.saveNameChanges();
			
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4)+123;
            objCntrl.saveNameChanges();
			
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4);
            objCntrl.strLastName = ' Test123456';
            objCntrl.saveNameChanges();
			
            Test.StopTest();            
        }    
		System.assertNotEquals(null, oUser[0].id);
		System.assertNotEquals(null, accList[0].id);
    }
    /* Testing  Method to navigate user on DAZN home */
    static testMethod void testDAZNHomePageNav(){
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Frozen'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        System.RunAs(oUser[0]){
            Test.StartTest();
            MyAccountController objCntrl = new MyAccountController();
            PageReference oPgf = objCntrl.DAZNHomePageNavigationHandler();
            objCntrl.callpageredirect();
            System.assertEquals(DAZNConfiguration__c.getValues('HomePageURL').Value__c, oPgf.getURL());
            Test.stopTest();
        }
    }
    /*Testing the Email Preference Functionality */
    static testMethod void testEmailPreference() {
        List<Account> accList = [Select Id,PersonContactId,Account_Status__c,All_Email_Preferences__c,Is_Double_OptIn__c from Account where Account_Status__c = 'Active Paid'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        System.RunAs(oUser[0]){
            Test.StartTest();
            MyAccountController objCntrl = new MyAccountController();
            objCntrl.bEmailPreference = accList[0].All_Email_Preferences__c;
            objCntrl.setEmailPreferences();
            objCntrl.getEmailPreferences();
            system.assertEquals(objCntrl.bEmailPreference, true);
            MyAccountController objCntrl1 = new MyAccountController();
            objCntrl1.bEmailPreference = null;
            objCntrl1.setEmailPreferences();
            objCntrl1.getEmailPreferences();
            Test.StopTest();
        }
    }
    /*Testing the Email Change Functionality */
    static testMethod void testsaveEmailChanges() {
        List<Account> accList = [select id,Name,PersonEmail,PersonContactId from Account LIMIT 10];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [select id, Name, Username,Email from User where ContactId IN: contactIdList];
        System.setPassword(oUser[1].Id, 'password@123');
        
        System.RunAs(oUser[1]){
            Test.StartTest();
            MyAccountController objCntrl = new MyAccountController();
            objCntrl.clearErrorFields();
            PageReference pageRef1 = Page.MyAccount;
            Test.setCurrentPage(pageRef1);
            ApexPages.currentPage().getParameters().put('field','Email');
            
            objCntrl.strNewEmail = acclist[1].PersonEmail;
            objCntrl.saveEmailChanges();
            system.assertEquals(objCntrl.sEmailProvideNewEmailErrorMsg, Label.LS_Myaccount_ErrMsg_ProvideNewEmail);
            
            
            objCntrl.strNewEmail = acclist[2].PersonEmail;
            objCntrl.saveEmailChanges();
            system.assertEquals(objCntrl.sEmailProvideNewEmailErrorMsg, Label.LS_MyAccount_ErrMsg_EmailIDExists);
            
            
            objCntrl.strNewEmail = 'A1'+acclist[2].PersonEmail;
            objCntrl.strPassword = '';
            objCntrl.saveEmailChanges();
            system.assertEquals(objCntrl.sEmailIncorrectPasswordErrorMsg, Label.LS_MyAccount_ErrMsg_Provide_Password);
            
            objCntrl.cancelEdit();
            system.assertEquals(objCntrl.isEmailEdit, false);
            objCntrl.edit();
            system.assertEquals(objCntrl.isEmailEdit, true);
            
            objCntrl.strNewEmail = 'A'+acclist[2].PersonEmail;
            objCntrl.strPassword = 'password@123';
            objCntrl.saveEmailChanges();
            
            Test.stopTest();
        }
    }
    /*Testing the Language update Functionality*/
    static testMethod void testLanguageVisibilityNUpdate(){
        List<Account> accList = [Select Id,PersonContactId from Account where Account_Status__c='Active Paid'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name,LanguageLocaleKey from User where ContactId In : contactIdList];
        System.RunAs(oUser[0]){
            Test.StartTest();
            MyAccountController objCntrl = new MyAccountController();
            apexpages.currentpage().getParameters().put('ResubscribesError', 'true');
            objCntrl.getBanner();
            
            MyAccountController objCntrl1 = new MyAccountController();
            List<CommunityHelper.UserLanguage>lstLanguages = objCntrl.getLanguages();
            if(lstLanguages !=null){
                string sLanguageCode = lstLanguages[1].label;
                objCntrl.strSelectedLanguage = sLanguageCode;
                objCntrl.updateUserLanguage();
                objCntrl.strSelectedLanguage = null;
                objCntrl.updateUserLanguage();
                System.assertEquals('de',oUser[0].LanguageLocaleKey);
            }
            Test.StopTest();
        }
    }
    /* Testing user navigation when user status is Frozen*/
    static testMethod void testnavigateUser(){
        List<Account> accList = [Select Id,PersonContactId,Account_Status__c from Account where Account_Status__c='Frozen'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name,LanguageLocaleKey from User where ContactId In : contactIdList];
        System.RunAs(oUser[0]){
            Test.StartTest();
            MyAccountController objCntrl = new MyAccountController();
            objCntrl.subscriptionType = accList[0].Account_Status__c;
            PageReference oPgf = objCntrl.navigateUser();
            Test.stopTest();
        }
		System.assertNotEquals(null, contactIdList[0]);
    } 
    /* Testing page navigations to why page*/
    static testMethod void testPageNavigation() {
        List<CountryListForPauseFlow__c> lstCustomSetting = new List<CountryListForPauseFlow__c>();
        lstCustomSetting.add(new CountryListForPauseFlow__c(Name = 'AT', IsPauseEnable__c = false));
        lstCustomSetting.add(new CountryListForPauseFlow__c(Name = 'CH', IsPauseEnable__c = false));
        lstCustomSetting.add(new CountryListForPauseFlow__c(Name = 'DE', IsPauseEnable__c = false));
        lstCustomSetting.add(new CountryListForPauseFlow__c(Name = 'JP', IsPauseEnable__c = false));
        insert lstCustomSetting;

        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Paid'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        System.RunAs(oUser[0]){
            Test.StartTest();
            MyAccountController objCntrl = new MyAccountController();
            apexpages.currentpage().getParameters().put('PageName', 'why');
            PageReference oPgf = objCntrl.navigationHandler();
            System.assertEquals('/why', oPgf.getURL());
            PageReference oPgf1 = objCntrl.naviagateToWhyPage();
            System.assertEquals('/cancel', oPgf1.getURL());
            
           
            apexpages.currentpage().getParameters().put('cancelButtonError', 'true');
            objCntrl.sBannerName = objCntrl.getBanner();
            
          
            Test.stopTest();
        }
    }
    
     /* Testing page navigations to why page*/
    static testMethod void testFreeTrailActivePaidNGrace(){
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Paid'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(accList[0].Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(accList[0].Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);

        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        System.RunAs(oUser[0]){
            Test.StartTest();
            MyAccountController objCntrl = new MyAccountController();
            objCntrl.oActSubscription = zSubsp;      
            objCntrl.sBannerName ='reactivation';
            objCntrl.freeTrial();
            objCntrl.activeGrace();
            objCntrl.activePaid();
            
            objCntrl.sBannerName ='cancellation';
            objCntrl.freeTrial();
            objCntrl.activeGrace();
            objCntrl.activePaid();
            Test.stopTest();
            
        }
		System.assertNotEquals(null, accList[0].id);
    }
       /*Testing Name Change Functionality Validations*/
    static testmethod void testsaveNameChangesValidation1(){
		//scheduleCancelSubscriptionBatchTest.testUser();
		
 		List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Free Trial'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id,FirstName,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        
        
        system.runAs(oUser[0]){
            Test.StartTest();
            MyAccountController objCntrl = new MyAccountController();
            objCntrl.clearErrorFields();
            PageReference oPgf = objCntrl.navigateUser();
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4);
            objCntrl.strLastName = '';
            objCntrl.saveNameChanges();			
            
            objCntrl.strFirstName = '1';
            objCntrl.saveNameChanges();			
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4);
            objCntrl.strLastName = '2';
            objCntrl.saveNameChanges();			
            
            objCntrl.strFirstName = '';
            objCntrl.strLastName = '';
            objCntrl.saveNameChanges();
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4)+'@#$%';
            objCntrl.saveNameChanges();
			
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4);
            objCntrl.strLastName = 'Test%^&*(12)$';
            objCntrl.saveNameChanges();
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4)+123;
            objCntrl.saveNameChanges();
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4);
            objCntrl.strLastName = 'Test123456';
            objCntrl.saveNameChanges();			
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4)+123;
            objCntrl.saveNameChanges();			
            
            objCntrl.strFirstName = oUser[0].FirstName.substring(0,4);
            objCntrl.strLastName = ' Test123456';
            objCntrl.saveNameChanges();
			
            Test.StopTest();            
        } 
		System.assertNotEquals(null, Ouser[0].id);
    }
     /*Testing Validations*/
    static testmethod void testValidation(){
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Grace'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        List<Zuora__PaymentMethod__c > oPaymethMethod =[Select Zuora__Type__c, Zuora__CreditCardMaskNumber__c , Zuora__DefaultPaymentMethod__c ,Zuora__BankTransferAccountNumber__c from Zuora__PaymentMethod__c LIMIT 1];
        System.RunAs(oUser[0]){
            Test.StartTest();
            MyAccountController objCntrl = new MyAccountController();
            apexpages.currentpage().getParameters().put('cancelButtonError', 'true');
            objCntrl.sBannerName = objCntrl.getBanner();
            objCntrl.activeGrace();
            
            objCntrl.sBannerName = 'ResubscribesError';
            objCntrl.activeGrace();
            
            Test.StopTest();            
        } 
    }
}