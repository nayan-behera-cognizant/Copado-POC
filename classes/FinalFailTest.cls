/**
* @ Author : Megha Jain (Cognizant Technology Solutions)
* @ Date : 31/03/2017
* @ Description : Apex class handling the logic for pause REST services
* @ Modified BY : Megha Jain
* @ Modified Date : 25/07/2017
**/

@isTest
public class FinalFailTest{
 
  public static testMethod void  testFinalFailWrapper(){
        SetUpTestData.triggerSettings();

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Active Paid');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail321@email.com', 'testusername321@email.com', 'tst321','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
         Zuora__ZInvoice__c zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00);  
        
        System.assertNotEquals(null, oAccount.Id);

         
        String jsonstring='{'+
        '"AccountCrmId":"'+ oAccount.Id +'",'+
        '"PaymentId":"' + zPay.Id + '"'+
        '}';                        
        
        Test.startTest();
       
        // Parse JSON response to get all the field values.
        FinalFail.finalFailJSON varfinalFailJSON = (FinalFail.finalFailJSON)JSON.deserialize(jsonstring, FinalFail.finalFailJSON.class);
         
         String AccountCrmId = varfinalFailJSON.AccountCrmId  ; 
         String PaymentId = varfinalFailJSON.PaymentId ;
        
        Test.stopTest();   
        
       
      } 
      
      
      static testMethod void testFirstFail() {
        SetUpTestData.triggerSettings();
       
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Active Paid');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail321@email.com', 'testusername321@email.com', 'tst321','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
         Zuora__ZInvoice__c zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00); 
        
         System.assertNotEquals(null, oAccount.Id);
        
        system.debug ('test'+ zSubsp.Name );
        RestRequest req = new RestRequest();
        req.requestURI = '/FinalFail/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{'+
        '"AccountCrmId":"' + oAccount.Id + '",'+
        '"PaymentId":"' + zPay.Id + '"'+
        '}');
        
         System.assertNotEquals(null, req.requestBody);
        
        RestContext.request = req;
      
        Test.StartTest();
        FinalFail sObj = new FinalFail();
       
        FinalFail.newSubscriptionPost();
        FinalFail.updateAccountStatusByZouraAccountId(oAccount.Id, 'Frozen');
        
        
        
        Test.StopTest();
    }

   }