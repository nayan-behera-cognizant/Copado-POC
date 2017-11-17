/**
* @author Cognizant Technology Solutuions
* @date 11/28/2016
* @description Test class to cover DFDUserFeedHandler functionality.
*/
@istest
public class DFDUserFeedHandlerTest {
    @testSetup /*  calling CreateTestDataforUnitTest */  
    public static void getCommunityUsersTestData(){
        CreateTestDataforUnitTest.triggerSettings();
        //CreateZuoraDataforUnitTest.createZuoraDeatils();
        CreateTestDataforUnitTest.createTestcustomsetting();
        CreateTestDataforUnitTest.createTestUserDevices();
    }
    //test method to create account and user 
    public static testmethod void toCreateAccountAndUserwithAllValues(){
        List<Profile> profile=[select Id,Name from profile where Name='External User' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=True limit 1];
        system.assertNotEquals(null, oUser);
        CreateTestDataforUnitTest.triggerSettings();
        DocomoConfiguration__c custmstng = new DocomoConfiguration__c();
        custmstng.Name = 'Default Password';
        custmstng.Value__c = 'cGFzNzg5dzByZA==';
        insert custmstng;
        System.RunAs(oUser[0]){
            DAZNUserFeed__c userdetails = CreateTestDataforUnitTest.createTestDFDUserFeedRecords();
            insert userdetails;
            system.assertNotEquals(null, userdetails);
        }
        
        
    }
    //test method to create user with registration status is complete 
    static testmethod void toCreateAccountAndUserwithOutAllValues(){
        List<Profile> profile=[select Id,Name from profile where Name='External User' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=True limit 1];
        system.assertNotEquals(null, oUser);
        DocomoConfiguration__c custmstng = new DocomoConfiguration__c();
        custmstng.Value__c = 'cGFzNzg5dzByZA==';
        custmstng.Name = 'Default Password';
        insert  custmstng;
        System.RunAs(oUser[0]){
            DAZNUserFeed__c userdetails = CreateTestDataforUnitTest.createTestDFDUserFeedRecords();
            userdetails.First_Name__c = '';
            userdetails.Last_Name__c='';
            userdetails.Secondary_Email__c='';
            userdetails.Alias__c = '';
            userdetails.Account_Status__c='';
            insert userdetails;
            system.assertNotEquals(null, userdetails);
        }
        
    }
    //when registration status is incomplete
    static testmethod void totestNumberOfRetries(){
        CreateTestDataforUnitTest.triggerSettings();
        List<Profile> profile=[select Id,Name from profile where Name='External User' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=True limit 1];
        system.assertNotEquals(null, oUser);
        DocomoConfiguration__c custmstng = new DocomoConfiguration__c();
        custmstng.Name = 'Default Password';
        custmstng.Value__c = 'cGFzNzg5dzByZA==';
        insert custmstng;
        System.RunAs(oUser[0]){
            DAZNUserFeed__c userdetails = CreateTestDataforUnitTest.createTestDFDUserFeedRecords();
            userdetails.BillingCountryCode__c='';
            userdetails.LanguageLocaleKey__c='';
            userdetails.TimeZoneSidKey__c = '';
            userdetails.EmailEncodingKey__c = '';
            userdetails.LocaleSidKey__c = '';
            userdetails.Email__c = '';
            insert userdetails;
            system.assertNotEquals(null, userdetails);
        }
        
    }
    static testmethod void toTestFailedStatus(){
        CreateTestDataforUnitTest.triggerSettings();
        List<Profile> profile=[select Id,Name from profile where Name='External User' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=True limit 1];
        system.assertNotEquals(null, oUser);
        System.RunAs(oUser[0]){
            DAZNUserFeed__c userdetails = CreateTestDataforUnitTest.createTestDFDUserFeedRecords();
            userdetails.BillingCountryCode__c='';
            userdetails.LanguageLocaleKey__c='';
            userdetails.TimeZoneSidKey__c = '';
            userdetails.Num_Retries__c = 5;
            insert userdetails;
            system.assertNotEquals(null, userdetails);
        }
        
    }
    //when account and user insertion fails
    static testmethod void toTestAccountCreationFailure(){
        CreateTestDataforUnitTest.triggerSettings();
        List<Profile> profile=[select Id,Name from profile where Name='External User' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=True limit 1];
        system.assertNotEquals(null, oUser);
        List<DAZNUserFeed__c> lstDAZNFeedLst = new List<DAZNUserFeed__c>();
        System.RunAs(oUser[0]){
            DAZNUserFeed__c userdetails = CreateTestDataforUnitTest.createTestDFDUserFeedRecords();
            userdetails.LanguageLocaleKey__c='';
            userdetails.TimeZoneSidKey__c = '';
            userdetails.Num_Retries__c = 4;
            lstDAZNFeedLst.add(userdetails);
            DAZNUserFeed__c userdetails1 = CreateTestDataforUnitTest.createTestDFDUserFeedRecords();
            userdetails1.DAZN_Id__c = '2223e2';
            userdetails1.Partner_Id__c = '332e32';
            userdetails1.ViewerId__c = '232232e23';
            userdetails1.Num_Retries__c = 5;
            userdetails1.Last_Name__c = '';
            lstDAZNFeedLst.add(userdetails1);
            Insert lstDAZNFeedLst ;
            DFDUserFeedHandler.exceptionDaznUserFeeds(userdetails,'Exception' );
       }
        
    }
//method to test when num of retries is greater than 5
 public static testmethod void toTestBulkRecords(){
        CreateTestDataforUnitTest.triggerSettings();
        List<Profile> profile=[select Id,Name from profile where Name='External User' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=True limit 1];
        system.assertNotEquals(null, oUser);
        List<DAZNUserFeed__c> lstDAZNFeedLst = new List<DAZNUserFeed__c>();
        System.RunAs(oUser[0]){
            lstDAZNFeedLst = CreateTestDataforUnitTest.createTestDFDUserFeedRecordsBulk(50);
            Insert lstDAZNFeedLst;
        }
    }
    static testmethod void toTestFailedUserStatus(){
        //CreateTestDataforUnitTest.triggerSettings();
        List<Profile> profile=[select Id,Name from profile where Name='External User' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=True limit 1];
        system.assertNotEquals(null, oUser);
        List<DAZNUserFeed__c> lstDAZN = new List<DAZNUserFeed__c>(); 
        System.RunAs(oUser[0]){
            DAZNUserFeed__c userdetails = CreateTestDataforUnitTest.createTestDFDUserFeedRecords();
            DAZNUserFeed__c userdetails1 = CreateTestDataforUnitTest.createTestDFDUserFeedRecords();
            userdetails.BillingCountryCode__c='';
            userdetails.LanguageLocaleKey__c='';
            userdetails.TimeZoneSidKey__c = '';
            userdetails.TimeZoneSidKey__c = '';
           // userdetails.DAZN_Id__c = '';
            userdetails1.BillingCountryCode__c='';
            userdetails1.Num_Retries__c = 5;
           // userdetails1.ViewerId__c = '';
            lstDAZN.add(userdetails);
            lstDAZN.add(userdetails1);
            insert lstDAZN;
            system.assertNotEquals(null, userdetails);
        }
        
    }
    
    
   /*Added as part of PD-11515*/
    /* Method to test Blocked accounts*/
   static testmethod void toTestBlockedAccounts(){
        //CreateTestDataforUnitTest.triggerSettings();
        List<Profile> profile=[select Id,Name from profile where Name='External User' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=True limit 1];
        system.assertNotEquals(null, oUser);
        List<DAZNUserFeed__c> lstDAZN = new List<DAZNUserFeed__c>(); 
       test.startTest();
            DAZNUserFeed__c userdetails = CreateTestDataforUnitTest.createTestDFDUserFeedRecords();
        insert userdetails;
            
		DAZNUserFeed__c DAZNuser = [select id,AccountId__c from DAZNUserFeed__c where id =: userdetails.id];
        account acc = [select id from account where id =: DAZNuser.AccountId__c];
        acc.Account_Status__c = 'Blocked';
        update acc;
        DAZNUserFeed__c newUserdetails=new  DAZNUserFeed__c();
            newUserdetails.Email__c='test2344@test.com';
            newUserdetails.Email_Preferences__c=true;
            newUserdetails.Secondary_Email__c='test22222@test.com';
            newUserdetails.Account_Status__c='Active Paid';
            newUserdetails.Partner_Id__c='asdghh243';
            newUserdetails.DAZN_Id__c = '2323223';
            newUserdetails.ViewerId__c = '222121223';
        insert newUserdetails;
        test.stopTest();
    } //End of PD-11515
    
    
    /*Method to test frozen account*/
     static testmethod void toTestFrozenAccounts(){
        //CreateTestDataforUnitTest.triggerSettings();
        List<Profile> profile=[select Id,Name from profile where Name='External User' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=True limit 1];
        system.assertNotEquals(null, oUser);
        List<DAZNUserFeed__c> lstDAZN = new List<DAZNUserFeed__c>(); 
        test.startTest();
        DAZNUserFeed__c userdetails = CreateTestDataforUnitTest.createTestDFDUserFeedRecords();
        insert userdetails;
        DAZNUserFeed__c DAZNuser = [select id,AccountId__c from DAZNUserFeed__c where id =: userdetails.id];
        account acc = [select id from account where id =: DAZNuser.AccountId__c];
        DAZNUserFeed__c newUserdetails=new  DAZNUserFeed__c();
        newUserdetails.Email__c='test2344@test.com';
            newUserdetails.Email_Preferences__c = true;
            newUserdetails.Secondary_Email__c='test22222@test.com';
            newUserdetails.Account_Status__c='Frozen';
            newUserdetails.Partner_Id__c='asdghh243';
            newUserdetails.DAZN_Id__c = '2323223';
            newUserdetails.ViewerId__c = '222121223';
            newUserdetails.First_Name__c = 'TestFirstName';
            newUserdetails.Last_Name__c = 'TestLastName';
            newUserdetails.BillingCountryCode__c = 'JP';
            newUserdetails.LanguageLocaleKey__c = 'ja';
            newUserdetails.Partner_Registration_status__c = 'incomplete';
            newUserdetails.User_Type__c = 'Docomo';
            newUserdetails.Subscription_Start_Date__c = System.today() + 3;
            newUserdetails.CommunityNickname__c =  '1test1Te';
            newUserdetails.TimeZoneSidKey__c = 'Asia/Tokyo';
            newUserdetails.LocaleSidKey__c = 'ja_JP';
            newUserdetails.EmailEncodingKey__c = 'UTF-8';
        insert newUserdetails;
        test.stopTest();
    } 
    
}