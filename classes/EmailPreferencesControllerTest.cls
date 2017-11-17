/**
* @author Cognizant Technology Solutuions
* @date 05/02/2015
* @description This class test emailpreferences functionality
*/
@isTest
public class EmailPreferencesControllerTest {
    @testSetup 
    public static void getCommunityUsersTestData(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        CreateTestDataforUnitTest.createTestcustomsetting();
        }

    /* Test email preference update*/
    static testMethod void testEmailPreferencesUpdate() {
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Free Trial'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        
            PageReference oPageReference = Page.EmailPreferences; 
            Test.setCurrentPage(oPageReference); 
            ApexPages.currentPage().getParameters().put('UserId','UID'+accList[0].id);
            
            // Initiate email preference class
            EmailPreferencesController oEmailPreference = new EmailPreferencesController();
            
            // Unsubscribe and verify changes.
            oEmailPreference.Unsubscribe();
            oEmailPreference.navigateError = true;
            oEmailPreference.navigateToErrorPage();
                
            
            List<Account> lstAccount = [Select id, All_Email_Preferences__c from Account where Id=:accList[0].id];
            system.assertEquals(false, lstAccount[0].All_Email_Preferences__c);
            
    }
    
    /* Test email preference update*/
    static testMethod void testEmailPreferencesUpdation() {
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Free Trial'];
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        }
        List<User> oUser = [Select Id, Name, UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        
        System.RunAs(oUser[0]){
            Test.StartTest();
            PageReference oPageReference = Page.EmailPreferences; 
            Test.setCurrentPage(oPageReference); 
            ApexPages.currentPage().getParameters().put('UserId','UID'+accList[0].id);
            
            // Initiate email preference class
            EmailPreferencesController oEmailPreference = new EmailPreferencesController();
            
            // Unsubscribe and verify changes.
            oEmailPreference.Unsubscribe();
            oEmailPreference.navigateError = true;
            oEmailPreference.navigateToErrorPage();
                
            
            List<Account> lstAccount = [Select id, All_Email_Preferences__c from Account where Id=:accList[0].id];
            
            Test.StopTest();
        }
    }
}