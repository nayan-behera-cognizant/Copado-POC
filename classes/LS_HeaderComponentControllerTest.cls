/**
* @author Cognizant Technology Solutuions
* @date 08/02/2016
* @description This test class will cover the code coverage for LS_HeaderComponentController
*/
@IsTest
public class LS_HeaderComponentControllerTest{
    static testMethod void testHeaderComponent() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom'); 
        SetUpTestData.testCreateDAZNConfiguration('HomePageURL', '/HomePage'); 
        Test.StartTest();
        System.RunAs(oUser) {
            Test.setCurrentPageReference(new PageReference('Page.MyAccount'));
            LS_HeaderComponentController newObj = new LS_HeaderComponentController();
            System.assertEquals('/HomePage', newObj.homePageURL);
            newObj.redirectToHomePage();
        }
        Test.StopTest();
    }
}