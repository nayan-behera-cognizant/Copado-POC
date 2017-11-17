/**
* @author Cognizant Technology Solutuions
* @date 11/28/2016
* @description Test class to cover DAZNUserDeviceFeedTriggerHandler functionality.
*/
@istest
public class DAZNUserDeviceFeedTriggerHandlerTest{
    @testSetup /*  calling CreateTestDataforUnitTest */  
    public static void getCommunityUsersTestData(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateZuoraDataforUnitTest.createZuoraDeatils();
        CreateTestDataforUnitTest.createTestcustomsetting();
        CreateTestDataforUnitTest.createTestUserDevices();
    }
    public static testmethod void testCreateAccount(){ 
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        DAZNUserFeed__c userdetails=new  DAZNUserFeed__c();
        userdetails.First_Name__c='firsttest';
        userdetails.Last_Name__c='lasttest';
        userdetails.Email__c='test2344@test.com';
        userdetails.BillingCountryCode__c='JP';
        userdetails.LanguageLocaleKey__c='ja';
        userdetails.Email_Preferences__c=true;
        userdetails.Secondary_Email__c='test222@test.com';
        userdetails.Alias__c = 'tt23';
        userdetails.TimeZoneSidKey__c = 'Asia/Tokyo';
        userdetails.LocaleSidKey__c = 'ja_JP';
        userdetails.Account_Status__c='Active Paid';
        userdetails.Partner_Registration_status__c='complete';
        userdetails.Partner_Id__c='asdghh243';
		userdetails.AccountId__c = oAccount.id;
        userdetails.ViewerId__c = '222121223';
        userdetails.DAZN_Id__c = '2323223';
        insert userdetails;
        system.assertNotEquals(null, userdetails);        
    	List<Profile> profile=[select Id,Name from profile where Name='External User' limit 1];
        system.assert(profile.size()>0);
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,profileId,LanguageLocaleKey from User where profileId=:profile[0].id and IsActive=True limit 1];
        system.assertNotEquals(null, oUser);
        System.RunAs(oUser[0]){
            list <DAZN_User_Device_Feed__c> listOfDaznUserDev = new  list <DAZN_User_Device_Feed__c>();        
            for(Integer i=0;i<5;i++) {
                DAZN_User_Device_Feed__c  DazUserDevFeedObj = new DAZN_User_Device_Feed__c ();
                DazUserDevFeedObj.Date_of_Registration__c = system.today();
                DazUserDevFeedObj.Device_Id__c = '12345';
                DazUserDevFeedObj.DAZN_User_feed__c =userdetails.id;
                listOfDaznUserDev.add(DazUserDevFeedObj);
            	}
            insert listOfDaznUserDev;
        }
       
        
    }
  
  
  
  
        }