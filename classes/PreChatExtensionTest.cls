/**
* @author Cognizant Technology Solutuions
* @date 11/11/2015
* @description PreChatExtension Test class.
*/
@isTest
public class PreChatExtensionTest {

    static testMethod void myUnitTest() {
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(new Account());
        PreChatExtension chatExt = new PreChatExtension(sc);
        system.assertEquals(chatExt.oCurrentUser.Id, userinfo.getuserId());
        Test.stopTest();
    }

}