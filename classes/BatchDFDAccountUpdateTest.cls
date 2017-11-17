@isTest
public class BatchDFDAccountUpdateTest {
    static testMethod void testCreationAccount(){
        CreateTestDataforUnitTest.triggerSettings();
        SetUpTestData.createDAZNConfigurations();
        Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
            Name = 'Docomo',
            Partner_Type__c = 'Docomo',
            Page_Name__c = 'PartnerAccount.page',
            Subscription_Type_Heading_Text__c = 'Docomo',
            Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
            Payment_History_URL__c = 'https://www.google.com',
            Cancel_Subscription_URL_Small__c = 'https://www.google.com',
            Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
            Cancel_Subscription_URL_Large__c = 'https://www.google.com',
            Change_password_email__c = '123',
            Double_opt_in_email__c = '123',
            Name_change_email__c = '123',
            Payment_success_email__c = '123',
            Updated_payment_method_email__c = '123'

        );
        insert pac;
        String orgId = UserInfo.getOrganizationId();
        List<Account> accList = new List<Account>();
        for (Integer i = 0;i<7;i++){
            String uniqueName = orgId;
            uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
            Account oAccount = new Account();
            oAccount.FirstName = 'TestFirstNames';
            oAccount.LastName = 'TestLastNames'+i;
            oAccount.PersonEmail = 'emails'+uniqueName+i+ '@testdomain.org';
            oAccount.Notification_Country_Code__c='JP';
            oAccount.Type = 'Docomo';
            oAccount.Partner_ID__c = '1' + String.valueOf(i);
            oAccount.All_Email_Preferences__c = true;
            
            oAccount.Account_Status__c = 'Active Grace';
            
            accList.add(oAccount);
            
        } //end of for - Account data preparation
        Database.insert(accList,true);
        
        list<Account> listofAccounts = new list<Account>();
		BatchDFDAccountUpdate bAD = new BatchDFDAccountUpdate();
        Database.executeBatch(bAD);
    }
}