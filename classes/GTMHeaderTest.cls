@isTest
public class GTMHeaderTest {

    public static testMethod void MyaccountGTMHeader() {
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        CreateTestDataforUnitTest.CreateGuestUser();
        List<Account> accList = [Select Id, Name, PersonEmail, PersonContactId From Account Where Account_Status__c = 'Free Trial' LIMIT 1];
        List<User> oUser = [Select Id, FirstName, LastName, UserName, Alias, Country, CountryCode, LanguageLocaleKey, Viewer_Id__c From User Where ContactId = :accList[0].PersonContactId LIMIT 1];
        System.runAs(oUser[0]) {
            GTMHeaderController gtmObj = new GTMHeaderController();
            gtmObj.pageName = 'myaccount';
            GTMHeaderController.errorMsgDsply = 'test';
            GTMHeaderController.errorMsgDsply1 = 'test';

            GTMHeaderController.errorDespFromAccountController('test');
            
            System.assertEquals(gtmObj.language, oUser[0].LanguageLocaleKey);
            System.assertEquals(gtmObj.territory, oUser[0].CountryCode);
            System.assertEquals(gtmObj.customerId, oUser[0].Viewer_Id__c);
        }
    }

}