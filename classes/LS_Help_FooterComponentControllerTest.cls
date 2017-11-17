/**
* @author Cognizant Technology Solutuions
* @date 11/11/2015
* @description This test class will cover the code coverage for LS_Help_FooterComponentController
*/
@IsTest
public class LS_Help_FooterComponentControllerTest{ 

    static testMethod void testEmailLinkNLiveChatVisibility1() {
        LiveChatLanguageSettings__c ls = new LiveChatLanguageSettings__c(
            Name = 'DE-en',
            Button_Id__c = 'test_id'
        );
        insert ls;

        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'testemail@email.com', 'Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true); 
        
        Test.StartTest();
        System.RunAs(oUser) {
            Test.setCurrentPageReference(Page.ContactUs);
            ApexPages.currentpage().getParameters().put('lang', 'en');
            ApexPages.currentpage().getParameters().put('Country', 'DE');
            
            LS_Help_FooterComponentController newObj = new LS_Help_FooterComponentController();

            System.assertEquals('test_id', newObj.liveChatButtonId);
            System.assertEquals(true, newObj.showLiveChat);
            System.assertEquals(false, newObj.showEmailLink);
            System.assertEquals(null, newObj.sTrakingParams);
            String s = newObj.faqLinkLabel;
        }
        Test.StopTest();
    }

}