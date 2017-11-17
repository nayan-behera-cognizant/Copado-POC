/**
* @author Cognizant Technology Solutuions
* @date 11/02/2016
* @description test class for UserTriggerHandler
*/
@isTest
public class UserTriggerHandlerTest {
    
    /*Added as a part of PD-7831*/
    public static User createProfile(String profileName){
        
        list<Profile> pList = [SELECT id, Name FROM Profile where name =: profileName limit 1 ];
        System.assertEquals(1, pList.size() );
        
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId;
        uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
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
        System.assertEquals('Test', aUser.firstname);
        return aUser;
    }
    public static testMethod void testsendUpdateToOldEmail(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        insert new DAZNConfiguration__c(
            Name = 'LinkToDAZN',
            Value__c = 'https://dev.daz.com'
        );
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
         
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        System.runAs(oCSUser){
            User oProfileUser = createProfile('External User');
            System.assertNotEquals(null, oProfileUser.Id);
        }
        User usProfExternal = [select user.id FROM User WHERE user.profile.name ='External User' AND Alias = 'Memeber' AND firstname = 'Test' LIMIT 1];
         

         System.RunAs(usProfExternal){				
            User oUserOld = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testname@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
            oUserOld.CountryCode = 'JP';
            oUserOld.LanguageLocaleKey = 'ja';
            update oUserOld;
            System.assertEquals('JP', oUserOld.CountryCode);
            System.assertEquals('ja', oUserOld.LanguageLocaleKey);
            Test.startTest();
            oUserOld.Email = 'testemailNew@gmail.com';
            update oUserOld ;
            System.assertEquals('testemailNew@gmail.com', oUserOld.Email);
            Test.stopTest();
        }
    }
    
    // added for PD-7831
    public static testMethod void testsendUpdateToOldEmailByLiveSport(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        insert new DAZNConfiguration__c(
            Name = 'LinkToDAZN',
            Value__c = 'https://dev.daz.com'
        );
        

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');

        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        System.runAs(oCSUser){
            User oProfileUser = createProfile('LiveSport Team Member');
            System.assertNotEquals(null, oProfileUser.Id);
        }
        User usProfExternal = [select user.id FROM User WHERE user.profile.name ='LiveSport Team Member' AND Alias = 'Memeber' AND firstname = 'Test' LIMIT 1];

        /*User oProfileUser = createProfile('LiveSport Team Member');
        System.assertNotEquals(null, oProfileUser.Id);*/
        System.RunAs(usProfExternal){				
            oAccount.Notification_Country_Code__c = 'JP';
            oAccount.Notification_Language_Code__c = 'ja';
            Test.startTest();
            update oAccount ;
            System.assertEquals('ja', oAccount.Notification_Language_Code__c);
            System.assertEquals('JP', oAccount.Notification_Country_Code__c);
            Test.stopTest();
        }
    }

    public static testMethod void testStartTrigger(){
        TriggerSetting__c setting = new TriggerSetting__c(Name = 'test' , Disable__c = true);
        insert setting;
        insert new DAZNConfiguration__c(
            Name = 'LinkToDAZN',
            Value__c = 'https://dev.daz.com'
        );
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User usr3 = new User(Alias = 'stat3', Email='standarduser3@testorg.com', 
                                        EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
                                        LocaleSidKey='en_US', ProfileId = p.Id,
                                        TimeZoneSidKey='America/Los_Angeles', UserName='standardus@testorg3.com', isActive = true);
        insert usr3;
    }

    public static testMethod void testStartTriggerFirstNameNull(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User usr3 = new User(Alias = 'stat3', Email='standarduser3@testorg.com', 
                                        EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
                                        LocaleSidKey='en_US', ProfileId = p.Id,
                                        TimeZoneSidKey='America/Los_Angeles', UserName='standardus@testorg3.com', isActive = true);
        insert usr3;
    }

    public static testMethod void testWithoutAccess() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        insert new DAZNConfiguration__c(
            Name = 'LinkToDAZN',
            Value__c = 'https://dev.daz.com'
        );

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        /*User oProfileUser = createProfile('External User');
        System.assertNotEquals(null, oProfileUser.Id);*/
        User usr3 = new User(Alias = 'stat3', Email='standarduser3@testorg.com', 
                                        EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
                                        LocaleSidKey='en_US', ProfileId = p.Id,
                                        TimeZoneSidKey='America/Los_Angeles', UserName='standardus@testorg3.com', isActive = true);
        insert usr3;
        UserTriggerHandler.userNotificationLanguage(new List<User>{usr3});
        User oUserOld = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusename@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        System.RunAs(usr3){                
            
            oUserOld.CountryCode = 'JP';
            oUserOld.LanguageLocaleKey = 'ja';
            update oUserOld;
            Test.startTest();
            oUserOld.Email = 'testemailNew@gmail.com';
            update oUserOld ;
            Test.stopTest();
        }
    }

    public static testMethod void testsendUpdateToOldEmailDfd(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        insert new DAZNConfiguration__c(
            Name = 'LinkToDAZN',
            Value__c = 'https://dev.daz.com'
        );
        CreateTestDataforUnitTest.createTestAccountsDocomo();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        SetUpTestData.testCreatePartnerAccountConfiguration('Docomo', 'PartnerAccount.page', 'Docomo', 'Docomo', 
                                                            'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.', 'https://www.google.com', 'Docomo', 'https://www.google.com', 
                                                            'https://www.google.com', 'https://www.google.com', 'https://www.google.com', 'https://www.google.com');
        //private static User getDfDUser() {
        Id userAccId = [Select Id From Account Where Type = 'Docomo' AND Account_Status__c = 'Active Grace' AND Partner_ID__c != null LIMIT 1].Id;
        User us = [Select Id, AccountId, Country, LanguageLocaleKey, Account.Type, Account.Partner_ID__c  From User Where AccountId = :userAccId];
    
        System.RunAs(us){    
                       
            us.CountryCode = 'JP';
            us.LanguageLocaleKey = 'ja';
            update us;
            Test.startTest();
            us.Email = 'testemailNew@gmail.com';
            update us;
            System.assertEquals('testemailNew@gmail.com', us.Email);
            Test.stopTest();
        }
    }

    public static testMethod void testsendUpdate(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        insert new DAZNConfiguration__c(
            Name = 'LinkToDAZN',
            Value__c = 'https://dev.daz.com'
        );
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');

        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        System.runAs(oCSUser){
            User oProfileUser = createProfile('External User');
            System.assertNotEquals(null, oProfileUser.Id);
        }
        User usProfExternal = [select user.id FROM User WHERE user.profile.name ='External User' AND Alias = 'Memeber' AND firstname = 'Test' LIMIT 1];
         

        /*User oProfileUser = createProfile('External User');
        System.assertNotEquals(null, oProfileUser.Id);*/

        System.RunAs(usProfExternal){                
            User oUserOld = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testuse@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
            oUserOld.CountryCode = 'JP';
            oUserOld.LanguageLocaleKey = 'ja';
            update oUserOld;
            System.assertEquals('JP', oUserOld.CountryCode);
            System.assertEquals('ja', oUserOld.LanguageLocaleKey);
            Test.startTest();
            oUserOld.Email = 'testemailNew@gmail.com';
            update oUserOld ;
            System.assertEquals('testemailNew@gmail.com', oUserOld.Email);
            Test.stopTest();
        }
    }

    public static testMethod void testRun() {
        UserTriggerHandler.run = false;
        UserTriggerHandler.runOnce();
    }

     public static testMethod void testsend(){
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        insert new DAZNConfiguration__c(
            Name = 'LinkToDAZN',
            Value__c = 'https://dev.daz.com'
        );
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
         
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        System.runAs(oCSUser){
            User oProfileUser = createProfile('External User');
            System.assertNotEquals(null, oProfileUser.Id);
        }
        User usProfExternal = [select user.id FROM User WHERE user.profile.name ='External User' AND Alias = 'Memeber' AND firstname = 'Test' LIMIT 1];
         

         /*User oProfileUser = createProfile('External User');
         System.assertNotEquals(null, oProfileUser.Id);*/
         System.RunAs(usProfExternal){    
         UserTriggerHandler.isTest = true;
             UserTriggerHandler.run = false;
            User oUserOld = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testuname@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
            oUserOld.CountryCode = 'JP';
            oUserOld.LanguageLocaleKey = 'ja';
            update oUserOld;
            System.assertEquals('JP', oUserOld.CountryCode);
            System.assertEquals('ja', oUserOld.LanguageLocaleKey);
            Test.startTest();
            oUserOld.Email = 'testemailNew@gmail.com';
            update oUserOld ;
            System.assertEquals('testemailNew@gmail.com', oUserOld.Email);
            Test.stopTest();
        }
    }

    public static testMethod void testsendUpdateNo(){
       // SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        insert new DAZNConfiguration__c(
            Name = 'LinkToDAZN',
            Value__c = 'https://dev.daz.com'
        );
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        System.runAs(oCSUser){
            User oProfileUser = createProfile('External User');
            System.assertNotEquals(null, oProfileUser.Id);
        }
        User usProfExternal = [select user.id FROM User WHERE user.profile.name ='External User' AND Alias = 'Memeber' AND firstname = 'Test' LIMIT 1];
         
        /*User oProfileUser = createProfile('External User');
        System.assertNotEquals(null, oProfileUser.Id);*/

        System.RunAs(usProfExternal){                
            User oUserOld = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testuser@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
            oUserOld.CountryCode = 'JP';
            oUserOld.LanguageLocaleKey = 'ja';
            update oUserOld;
            /*System.assertEquals('JP', oUserOld.CountryCode);
            System.assertEquals('ja', oUserOld.LanguageLocaleKey);
            Test.startTest();
            oUserOld.Email = 'testemailNew@gmail.com';
            update oUserOld ;
            System.assertEquals('testemailNew@gmail.com', oUserOld.Email);
            Test.stopTest();*/
        }
    }
}