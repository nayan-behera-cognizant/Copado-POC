/* This test class will cover the code coverage for AccountPlaybackHistoryController*/
@isTest
public class AccountPlaybackHistoryControllerTest{

    @isTest 
    static void testAccountPlaybackHistoryController() {
        DAZNConfiguration__c daznConfig = new DAZNConfiguration__c(
            Name = 'CustomerPlaybackHistory',
            Value__c = 'https://pulse.conviva.com/subscribers/?days=1&filter=97628&viewerId='
        );
        insert daznConfig;
        String convivaLink = DAZNConfiguration__c.getValues('CustomerPlaybackHistory').Value__c;

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        List<User> linkedUser = [
            SELECT Id, Viewer_Id__c
            FROM User
            WHERE Id =: oUser.Id
            LIMIT 1
        ];
        Account emptyAccount = new Account();
        AccountPlaybackHistoryController controller = new AccountPlaybackHistoryController(new ApexPages.StandardController(oAccount));
        AccountPlaybackHistoryController controller2 = new AccountPlaybackHistoryController(new ApexPages.StandardController(emptyAccount)); 

        PageReference accPlaybackHistoryPage = Page.AccountPlaybackHistory;
        Test.setCurrentPage(accPlaybackHistoryPage);
        Test.startTest();
            PageReference pageRef = controller2.doInit();
            
            accPlaybackHistoryPage.getParameters().put('id', 'Incorrect Id');
            Test.setCurrentPage(accPlaybackHistoryPage);
            PageReference pageRef2 = controller.doInit();
            
            accPlaybackHistoryPage.getParameters().put('id', oAccount.Id);
            Test.setCurrentPage(accPlaybackHistoryPage);
            PageReference pageRef3 = controller.doInit();
            
            delete daznConfig;
            PageReference pageRef4 = controller.doInit();
        Test.stopTest();

        System.assertEquals(convivaLink, pageRef.getUrl());
        System.assertEquals(convivaLink, pageRef2.getUrl());
        System.assertEquals(true, pageRef3.getUrl().containsIgnoreCase(convivaLink + linkedUser[0].Viewer_Id__c));
        System.assertEquals(null, pageRef4);
    }

}