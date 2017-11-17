/**
* The SendEmailWithErrorsToAdminsTest class implements improve the test coverage for SendEmailWithErrorsToAdmins
* 
*
* @Author       :Cognizant Technology Solutions
* @Base version :1.0
* @Date         :August 23rd 2016
* ***********************Update History*****************************************
* Version       Updated By              CR #                    Change Description                  
*
*/
@isTest
public class SendEmailWithErrorsToAdminsTest {

    @testSetup
    public static void testUser() {
        //Test SendEmailTestMethodCustomSetting
        EmailNotification__c emailCustomSettings = new EmailNotification__c();
        emailCustomSettings.Name = 'TestName';
        emailCustomSettings.Email__c = UserInfo.getUserEmail();
        insert emailCustomSettings;
        System.assertNotEquals(emailCustomSettings.id, null);
        
        CreateTestDataforUnitTest.triggerSettings();
        //creating a user with a Profile System Admin  
        List<Profile> pList = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1 ];
        
        //verify the size of the profile list
        System.assertEquals(1, pList.size());
    }

    static testMethod void SendEmailTestMethod() {
        CreateTestDataforUnitTest.triggerSettings();
        String errorMessage = 'Exception Error'; 
        Test.StartTest();
        SendEmailWithErrorsToAdmins.sendEmail(errorMessage);
        Test.stopTest();
    }
}