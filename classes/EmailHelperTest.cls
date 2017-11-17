@isTest

/*Added Assert statements as per PD-7938*/
public class EmailHelperTest {    
    static testmethod void testSendMail()
    {
        List<string> lstToEmailAddress = new List<string>();
        lstToEmailAddress.add('test@emailtestlivesport.com');
        string sSubject='Test Subject';
        string sMessage='Test Message';
        EmailHelper.sendMail(lstToEmailAddress, sSubject, sMessage);
    }
    static testmethod void testSendMail_Template()
    {
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'name';
        validEmailTemplate.DeveloperName = 'unique_name_addSomethingSpecialHere';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();        
        insert validEmailTemplate;        
        List<string> lstToEmailAddress = new List<string>();
        lstToEmailAddress.add('test@emailtestlivesport.com');        
        EmailHelper.sendMail(lstToEmailAddress, validEmailTemplate.ID);        
    }
    static testmethod void testSendPasswordChangeEmailtoUser()
    {
        EmailHelper.sendPasswordChangeEmailtoUser('testNewEmail@emailtestlivesport.com', 'PasswordChange', '', '');
    }
    static testmethod void testSendCancelSubscriptionEmailtoUser()
    {
        EmailHelper.sendCancelSubscriptionEmailtoUser('testNewEmail@emailtestlivesport.com','CancelSubscription');
    }
    static testmethod void testSendReactivationSubscriptionEmailtoUser()
    {
        EmailHelper.sendReactivationSubscriptionEmailtoUser('testNewEmail@emailtestlivesport.com','ReactivateSubscription');
    }
    static testmethod void testsendInactiveDevicesNotification(){
        SetUpTestData.triggerSettings();
        //Insert account
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm1testemail@email.com','Free Trial');                
        oAccount.Notification_Country_Code__c = 'JP';
        update oAccount;
        list<id> listacc = new list<id>();
        listacc.add(oAccount.id);   
        System.assertEquals('JP', oAccount.Notification_Country_Code__c);
        EmailHelper.sendInactiveDevicesNotification(listacc);
    }
}