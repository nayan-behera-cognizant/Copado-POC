/**
* @author Cognizant Technology Solutuions
* @date 03/02/2016
* @description This test class will cover the code coverage for ClsResetPassword and ClsForceSignOffUsersFromDevices.
*/
@isTest
private class CSTestFlows {
    @testSetup
    /*  calling CreateTestDataforUnitTest */  
    public static void getCommunityUsersTestData(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestUserDevices();
        CreateTestDataforUnitTest.createTestAccounts();
    }
    // create user
    public static User createProfile(String profileName){
        list<Profile> pList = [SELECT id, Name FROM Profile where name =: profileName limit 1 ];
        //verify the size of the profile list 
        System.assertEquals(1, pList.size() );
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId;
        uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
        User aUser =new User(  firstname = 'Test',
                             lastName = 'Member'+uniqueName,
                             email = 'TestMember'+uniqueName + '@test' +'.com',
                             Username = 'TestMember' + uniqueName+'@test'+ '.org',
                             EmailEncodingKey = 'ISO-8859-1',
                             Alias = 'Memeber',
                             TimeZoneSidKey = 'America/Los_Angeles', 
                             LocaleSidKey = 'en_US',
                             LanguageLocaleKey = 'en_US',
                             isActive =true,
                             ProfileId = pList[0].id );
        
        insert aUser;
        System.assertEquals('Test', aUser.FirstName);
        return aUser;
        
    }
    //test method to cover reset password functionality with customer service team member
    private static testMethod void testResetPasswordFlow() {
        ClsResetPassword resetpassword = new ClsResetPassword();
        resetpassword.describe();
        /*create the users*/
        User oProfileUser = createProfile('Customer Service Team Member');
        System.assertNotEquals(null, oProfileUser.Id);
        /*form the request*/
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put('name', oProfileUser.Id);
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result = resetpassword.invoke(request);
        System.assertEquals(TRUE, result.outputParameters.get('isSuccess')) ;
    }
     //test method to cover sign out of users from devices with customer service team member
    private static testMethod void testForceSignOffUsersFromDevices(){
        ClsForceSignOffUsersFromDevices forceSignOff = new ClsForceSignOffUsersFromDevices();
        forceSignOff.describe();
        /* set up users */
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Paid' limit 1];
        system.assert(accList.size()>0);
        User oProfileUser = createProfile('Customer Service Team Member');
        System.assertNotEquals(null, oProfileUser.Id);
        List<User_Devices__c> userDiv = [Select Id, Device_Name__c,Account__c,Date_Of_Registration__c,Type__c,Status__c from User_Devices__c where Account__c =: accList[0].id];
        system.assertNotEquals(null, userDiv);
        /*form the request*/
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put('accountId', accList[0].Id);
        inputParams.put('userId', oProfileUser.Id);
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result = forceSignOff.invoke(request);
        System.assertEquals(TRUE, result.outputParameters.get('isSuccess')) ;
    }
    // test method to cover password reset functionality if user is a livesport team member
    private static testMethod void testLSResetPasswordFlow() {
        ClsResetPassword resetpassword = new ClsResetPassword();
        resetpassword.describe();
        /*create the users*/
        User oProfileUser = createProfile('LiveSport Team Member');
        System.assertNotEquals(null, oProfileUser.Id);
        /*form the request*/
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put('name', oProfileUser.Id);
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result = resetpassword.invoke(request);
        System.assertEquals(TRUE, result.outputParameters.get('isSuccess')) ;
    }
     //test method to cover sign out of users from devices with livesport team member
    private static testMethod void testLSForceSignOffUsersFromDevices(){
        ClsForceSignOffUsersFromDevices forceSignOff = new ClsForceSignOffUsersFromDevices();
        forceSignOff.describe();
        /* set up users */
        List<Account> accList = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Paid' limit 1];
        system.assert(accList.size()>0);
        User oProfileUser = createProfile('LiveSport Team Member');
        System.assertNotEquals(null, oProfileUser.Id);
        List<User_Devices__c> userDiv = [Select Id, Device_Name__c,Account__c,Date_Of_Registration__c,Type__c,Status__c from User_Devices__c where Account__c =: accList[0].id];
        system.assertNotEquals(null, userDiv);
        /*form the request*/
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put('accountId', accList[0].Id);
        inputParams.put('userId', oProfileUser.Id);
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result = forceSignOff.invoke(request);
        System.assertEquals(TRUE, result.outputParameters.get('isSuccess')) ;
    }
    
}