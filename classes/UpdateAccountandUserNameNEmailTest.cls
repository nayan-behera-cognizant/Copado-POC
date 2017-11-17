@istest
public class UpdateAccountandUserNameNEmailTest {
    static testMethod void testUpdateAccount() {
      CreateTestDataforUnitTest.triggerSettings();
      CaseCountryLanguageUpdateTest.CreateCSUser();
      CreateTestDataforUnitTest.createTestAccounts();  
         List<Profile> profile=[select id, Name from profile where Name='Customer Service Team Member'limit 1 ]; 
        system.assert(profile.size()>0);
        User csUser=[select id,UserName from user where profileid= :profile[0].Id  AND IsActive = true limit 1]; 
        Account acc = [select id,FirstName,LastName,PersonEmail,Type,Partner_ID__c,DFD_First_Name__c,DFD_Last_Name__c from Account limit 1];
        acc.LastName = 'test';
        update acc;
        Test.startTest();
        //System.RunAs(cSUser){
            ApexPages.currentPage().getParameters().put('sAccountid', '001784795944');
            UpdateAccountandUserNameNEmail UpdateAccountandUser = new UpdateAccountandUserNameNEmail(new ApexPages.StandardController(acc));
            UpdateAccountandUser.SaveRecord();
        //}
        System.RunAs(cSUser){
            ApexPages.currentPage().getParameters().put('sAccountid', '001784795944');
            UpdateAccountandUserNameNEmail UpdateAccountandUsera = new UpdateAccountandUserNameNEmail(new ApexPages.StandardController(acc));
            UpdateAccountandUsera.SaveRecord();
        }
        Test.stopTest();
    }
    static testMethod void testUpdateDocomoAccount() {
      CreateTestDataforUnitTest.triggerSettings();
      CaseCountryLanguageUpdateTest.CreateCSUser();
      CreateTestDataforUnitTest.createTestAccountsDocomo();  
         List<Profile> profile=[select id, Name from profile where Name='Customer Service Team Member'limit 1 ]; 
        system.assert(profile.size()>0);
        User csUser=[select id,UserName from user where profileid= :profile[0].Id  AND IsActive = true limit 1]; 
        Account acc = [select id,FirstName,LastName,PersonEmail,Type,Partner_ID__c,DFD_First_Name__c,DFD_Last_Name__c from Account limit 1];
       
        Test.startTest();
        System.RunAs(cSUser){
            ApexPages.currentPage().getParameters().put('sAccountid', '001784795944');
            UpdateAccountandUserNameNEmail UpdateAccountandUser = new UpdateAccountandUserNameNEmail(new ApexPages.StandardController(acc));
            UpdateAccountandUser.SaveRecord();
            UpdateAccountandUser.cancelAction();
        }
        Test.stopTest();
    }
}