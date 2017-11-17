/** 
* @author Cognizant Technology Solutuions
* @date 13/11/2015
* @description This class test the thanks controller functionality.
*/
@istest
public class ThanksControllerTest {
	
	static testMethod void redirectToHomeTest() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'testemail@email.com', 'Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true, 'United Kingdom'); 
        DAZNConfiguration__c dznConfigForgotPasswordURL = SetUpTestData.testCreateDAZNConfiguration('HomePageURL', '/HomePage');
        
        Test.startTest();
        System.RunAs(oUser) {
            ApexPages.currentpage().getParameters().put('lang', 'en');
            ApexPages.currentpage().getParameters().put('Country', 'DE');

            ThanksController obj = new ThanksController();
            PageReference pgRef = obj.redirectToHome();
            //***********changes as per PD-7817 & PD-7938*********
            System.assertEquals('/HomePage', pgRef.getURL());
            ThanksController.getLabelString('LS_Thanks_InfoMsg_CustomerServiceCentreDE');

            System.assertEquals('en', obj.strLanguage);
            System.assertEquals('DE', obj.sCountry);
            System.assertEquals(Label.LS_Thanks_InfoMsg_CustomerServiceCentreDE, obj.thanksInfoMsg);
        }
        Test.stopTest();
 	}

}