/**
* An apex page controller that exposes the site login functionality
*/
/*Added Assert statements as per PD-7938*/

@IsTest global with sharing class CommunitiesLoginControllerTest {
    @IsTest(SeeAllData=true) 
    global static void testCommunitiesLoginController () {
        CommunitiesLoginController oCommunitiesLoginController = new CommunitiesLoginController();
        Test.startTest();
        oCommunitiesLoginController.forwardToAuthPage();
        System.assertEquals(DAZNConfiguration__c.getValues('LoginPageURL').Value__c, oCommunitiesLoginController.forwardToAuthPage().getURL());
        Test.stopTest();
    }    
}