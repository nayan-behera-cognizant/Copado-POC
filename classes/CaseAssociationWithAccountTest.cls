/**************************************************************************************************************************************
Class  Name : CaseAssociationWithAccountTest.
Class  Description : Test class for CaseAssociationWithAccount Trigger.
**************************************************************************************************************************************/
@isTest
public class CaseAssociationWithAccountTest {
    static testMethod void testCaseAssociation() {
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.CreateTestCommunityUsers();
        
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId,Account_Status__c from Account where Account_Status__c = 'Active Paid'];
        System.assertEquals('Active Paid', accList[0].Account_Status__c);
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id,FirstName,LastName,UserName,Alias,Country,LanguageLocaleKey,email from User where ContactId In : contactIdList];
        System.assertEquals(oUser[0].email, accList[0].PersonEmail);
        System.RunAs(oUser[0])
        {
            Test.StartTest();
            Case oCase = new Case();
            oCase.Origin = 'Email';
            oCase.Type = 'General Enquiry';
            oCase.Status= 'Open';
            oCase.Subject = 'Test Description';
            oCase.Description = 'Case Association With Account only when Supplied Email is exist with any Account';
            oCase.SuppliedEmail = oUser[0].email;
            insert oCase;
            Test.StopTest();
        }
    }
    static testMethod void testCaseTriggerHandler() {
         CreateTestDataforUnitTest.triggerSettings();
        account ac = new account(firstName = 'TestFirstName',LastName='TestLastName',personEmail='emailtestfirst@gmail.com',
                                 Notification_Language_Code__c ='en_GB',Account_Status__c = 'Free Trial',All_Email_Preferences__c = true);
        insert ac;
         Campaign c=new Campaign(Name = 'Email',IsActive=True);
         Insert c;
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId,Account_Status__c from Account where personEmail = 'emailtestfirst@gmail.com'];
        System.assertEquals('emailtestfirst@gmail.com', accList[0].PersonEmail);
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        Campaignmember cm=new Campaignmember(ContactId = contactIdList[0],CampaignId=c.id,Status='Responded');
        insert cm;
        CreateTestDataforUnitTest.CreateTestCommunityUsers();
        List<User> oUser = [Select Id,FirstName,LastName,UserName,Alias,Country,LanguageLocaleKey,email from User where ContactId In : contactIdList];
        System.assertEquals(oUser[0].email, accList[0].PersonEmail);
        System.RunAs(oUser[0]){
        Test.StartTest();
            Case oCase = new Case();
            oCase.AccountId =accList[0].id;
           // oCase.Campaign__c = c.id;
            oCase.Origin = 'Email';
            oCase.Type = 'General Enquiry';
            oCase.Status= 'Open';
            oCase.Subject = 'Test Description';
            oCase.Description = 'Case Association With Account only when Supplied Email is exist with any Account';
            //oCase.SuppliedEmail = oUser[0].email;
            insert oCase;
            Test.StopTest();
        }   
    
    }
    static testMethod void TestAddingCaseContactToCampaign() {
        list<account> actlist = new list<account>();
        list<case> caseList = new list<case>();
        List<Campaign> campList = new list<Campaign>();
        list<Campaignmember> Cmemlist = new list<Campaignmember>();
        for(integer i =0; i<5;i++){
        actlist.add(new account(firstName = 'TestFirstName00'+i,LastName='TestLastName00'+i,personEmail='emailtestfirst00'+i+'@gmail.com',
                                 Notification_Language_Code__c ='en_GB',Account_Status__c = 'Free Trial',All_Email_Preferences__c = true));
        }
            insert actlist;
        List<Account> accList = [Select Id, Name,firstName, PersonEmail,PersonContactId,Account_Status__c from Account where Account_Status__c = 'Free Trial'];
        System.assertEquals(5, accList.size());
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
            campList.add(new Campaign(Name = 'Email'+acc.name,IsActive=True));
           
        }       
        Insert campList;
        list<Campaign> Camp =[select id from Campaign];
        for(integer i=0;i< Camp.size()-1;i++){
            Cmemlist.add(new Campaignmember(ContactId = contactIdList[i],CampaignId=Camp[i].id,Status='Responded'));
            
        }
        // insert Cmemlist;
        for(integer i=0;i<5;i++){
           caseList.add(new Case(AccountId =accList[i].id,ContactId =contactIdList[i],Campaign__c = Camp[i].id,
                                Origin = 'Email',Status= 'Open',Subject = 'Test Description',
                                Description = 'Case Association With Account only when Supplied Email is exist with any Account',
                                SuppliedEmail = accList[i].PersonEmail,SuppliedName =accList[i].firstName)); 
            
        }
         caseList.add(new Case(AccountId =accList[4].id,Campaign__c = Camp[4].id,
                                Origin = 'Email',Status= 'Open',Subject = 'Test Description',
                                Description = 'Case Association With Account only when Supplied Email is exist with any Account',
                                SuppliedEmail = accList[4].PersonEmail,SuppliedName =accList[4].firstName)); 
         caseList.add(new Case(AccountId =accList[0].id,Campaign__c = Camp[4].id,
                                Origin = 'Email',Status= 'Open',Subject = 'Test Description',
                                Description = 'Case Association With Account only when Supplied Email is exist with any Account',
                                SuppliedEmail = 'doesnotexist@gmail.com',SuppliedName =accList[4].firstName)); 
        
        
        insert caseList;
        
    }
        
     
        
     
}