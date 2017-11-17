@isTest 
public class signOutOfAllDevicesControllerTest{    
    static testMethod void signOutOfAllDevicesPostMethod() {    
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        String Email = 'test@email.com';
        signOutOfAllDevicesController.signOutOfAllDevicesPost(Email);
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Frozen');
        System.assertNotEquals(null, oAccount.Id);
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);               
        signOutOfAllDevicesController.signOutOfAllDevicesPost(oUser.Email);          
        signOutOfAllDevicesController.response resposne = new signOutOfAllDevicesController.response();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();        
        req.requestURI = '/services/apexrest/signOutOfAllDevicesFromEmail';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type          
    }
    
}