/**
* @author Cognizant Technology Solutuions
* @date 13/11/2015
* @description This class test the FinalCancellationConfirmation functionality.
*/
@istest
public class FinalCancellationConfirmationTest {
    
    static testMethod void testSubscriptionCancellationMessage() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD','$');
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id);
        zPay.Zuora__Status__c='Processed';
        update zPay;
       
        System.RunAs(oUser){
            FinalCancellationConfirmationController objCntrl = new FinalCancellationConfirmationController();
            objCntrl.oUser = new user();
            objCntrl.oSubscription = new Zuora__Subscription__c();
            objCntrl.bFreeOrPaidMember = false;
            objCntrl.cancelSubscription();
            Test.StartTest();
            Date myDate = Date.Today();
            //Nayan
            String localeFormattedDate = CommunityHelper.ConvertDateToString(myDate,'','');
            string strMsg = Label.LS_FinalConfirmation_Label_Subscription_End_date;
            if(strMsg.contains('[Zuora__SubscriptionEndDate__c]')){
                strMsg = strMsg.replace('[Zuora__SubscriptionEndDate__c]', localeFormattedDate);
            }else if(strMsg.contains('[Zuora__NextChargeDate__c]')){
                strMsg = strMsg.replace('[Zuora__NextChargeDate__c]', localeFormattedDate);
            }
            system.assertequals(objCntrl.sCancelSubscriptionMsg,strMsg);
            Test.StopTest();
        }
        
    }
    
    static testMethod void testURLRedirection() {
        SetUpTestData.triggerSettings();
        SetUpTestData.emailCustsett();
        SetUpTestData.testCreateDAZNCountryCurrencyISOCode('USD','$');
        Test.StartTest();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','test@test.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true); 
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        Zuora__ZInvoice__c  zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id);
        zPay.Zuora__Status__c='Processed';
        update zPay;
        DAZNConfiguration__c setting = new DAZNConfiguration__c();
        setting.Name = 'HomePageURL';
        setting.Value__c = 'Whatever.com';
        insert setting;
        
        System.RunAs(oUser){
            FinalCancellationConfirmationController objCntrl = new FinalCancellationConfirmationController();
            pageReference pRef = objCntrl.redirectToMyAccountPage();
            system.assertEquals(pRef.getUrl(),'/apex/MyAccount?cancelButtonclick=true');
            pageReference pRef2 = objCntrl.redirectToHomePage();
            system.assertEquals(pRef2.getUrl(),'Whatever.com');
        }
        Test.StopTest();
    }
}