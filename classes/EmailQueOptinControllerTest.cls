@istest
public class EmailQueOptinControllerTest {

 @testSetup
    public static void testUser(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        CreateTestDataforUnitTest.CreateGuestUser();//As per PD-7938
        SetUpTestData.emailCustsett();
    }
    
    //for CommunityUser
    static testMethod void testDoubleOptInFunctionalityEmailQue(){    
    Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
     Account oAccount1 = SetUpTestData.createPersonAccount('TestFirstNameOne', 'TestLastNameOne','testemailOne@email.com','Free Trial');
    User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true, 'United Kingdom');
        system.runAs(oUser){
             Email_Queue__c EqObj = new Email_Queue__c();                
             EqObj.AccountName__c = oAccount.id;
            insert EqObj;
        }
    
    }
// to cover catch exception
    static testMethod void testDoubleOptCatchException(){    
    Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
    Account oAccount1 = SetUpTestData.createPersonAccount('TestFirstNameOne', 'TestLastNameOne','testemailOne@email.com','Free Trial');
    User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','TestFName','TestLName',true, 'United Kingdom');
     oAccount.FirstName='cfdfd25';
        update oAccount;
        Test.startTest();
       system.runAs(oUser){
             Email_Queue__c EqObj = new Email_Queue__c();                
             EqObj.AccountName__c = oAccount.id;
            insert EqObj;
        }
        Test.stopTest();
    
    }
  static testMethod void testDoubleOptCatchExceptionCover(){    
         try{
      Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        set<Id> accSet = new set<Id>();
         Test.startTest();
              account ac = [select id, name,LastName from account where id =:oAccount.Id limit 1];
             Email_Queue__c EqObj = new Email_Queue__c();    
             EqObj.AccountName__c = ac.id;
            insert EqObj;
            accSet.add(ac.Id);
      	system.assertEquals(EqObj.AccountName__c, oAccount.Id);    
        EmailQueOptinController.accDouOPtinCheck(null);
           Test.stopTest();
      }catch(DMLException e){
          
      }
    }
}