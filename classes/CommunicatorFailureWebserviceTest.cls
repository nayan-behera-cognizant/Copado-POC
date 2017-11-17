@isTest
public class CommunicatorFailureWebserviceTest {
    static testMethod void testcreateTask(){
        SetUpTestData.triggerSettings();
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account oAccount = new Account();      
        oAccount.FirstName = 'TestAccount';
        oAccount.LastName = 'TestAccount';
        oAccount.PersonEmail = 'TestAccount@gmail.com';                
        oAccount.Type = 'Test User';
        oAccount.Account_Status__c = 'Frozen';
        oAccount.RecordTypeId = RecTypeId;
        insert oAccount;
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        User oCommunityUser=(User)SetUpTestData.setUpData(cUser); 
		
        System.RunAs(cUser){  
        	CommunicatorFailureWebservice.createTask(cUser.ContactID, oAccount.Id, 'TestSubject', 'TestDescription',null, null, null, null);
        }
    }    
    static testMethod void testcreateTaskMapAccounts(){
        SetUpTestData.triggerSettings();
        Map<String,List<Account>> mapAccounts = new Map<String,List<Account>>();
        List<Account> lstAcc = new List<Account>();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        lstAcc.add(oAccount);
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        User oCommunityUser=(User)SetUpTestData.setUpData(cUser); 
        mapAccounts.put('ja',lstAcc);
        Test.StartTest();
        System.RunAs(cUser){            
            // for create task 
            CommunicatorFailureWebservice.createTask(null, null, 'TestSubject', 'TestDescription',mapAccounts, null, null, null);
           
        }
        Test.stopTest();
    }  
      static testMethod void testcreateTaskMapUsers(){
        SetUpTestData.triggerSettings();
        Map<String,List<User>> mapUser = new Map<String,List<User>>();
        List<User> lstUser = new List<User>();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');        
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        User oCommunityUser=(User)SetUpTestData.setUpData(cUser); 
        lstUser.add(oCommunityUser);
        mapUser.put('ja',lstUser);
        Test.StartTest();
        System.RunAs(cUser){            
            // for create task 
            CommunicatorFailureWebservice.createTask(null, null, 'TestSubject', 'TestDescription',null, null, null, mapUser);
           
        }
        Test.stopTest();
    } 
     static testMethod void testcreateNotificationTask(){
        SetUpTestData.triggerSettings();
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account oAccount = new Account();      
        oAccount.FirstName = 'TestAccount';
        oAccount.LastName = 'TestAccount';
        oAccount.PersonEmail = 'TestAccount@gmail.com';                
        oAccount.Type = 'Test User';
        oAccount.Account_Status__c = 'Frozen';
        oAccount.RecordTypeId = RecTypeId;
        insert oAccount;
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        User oCommunityUser=(User)SetUpTestData.setUpData(cUser); 
        map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail = new map<string, List<WrapCommunicatorEmail>>();
        List<WrapCommunicatorEmail> lstWrap = new List<WrapCommunicatorEmail>();
        WrapCommunicatorEmail objWrap = new WrapCommunicatorEmail();
        objWrap.id                 = oAccount.Id;
        objWrap.email              = oAccount.PersonEmail;
        objWrap.firstName          = oAccount.FirstName;
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
        System.RunAs(cUser){            
            // for create task 
            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmail, 'TestSubject', 'TestDescription');
           
        }
        Test.stopTest();
    } 
}