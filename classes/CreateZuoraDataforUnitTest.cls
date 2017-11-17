@IsTest
public class CreateZuoraDataforUnitTest {
    //This method is used to create ZuoraDeatils recode.
    @testSetup
    public static void createZuoraDeatils(){
        //Calling CreateTest Account and Users to setup data
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.CreateTestCommunityUsers();        
        List<Account> accList = [Select Id,Name,PersonContactId from Account];
        List<Zuora__CustomerAccount__c> bAccount = new List<Zuora__CustomerAccount__c>();
        List<Zuora__Subscription__c> lstSubscription =new list<Zuora__Subscription__c>();
        List<Zuora__PaymentMethod__c> oZuoraPayMethList = new List<Zuora__PaymentMethod__c>();
        Integer  bcount=100;
        for(Account accOb: accList){
            // add Zuora bAccount
            Zuora__CustomerAccount__c zCustomerAcct = new Zuora__CustomerAccount__c();
            zCustomerAcct.Zuora__Account__c = accOb.id;
            zCustomerAcct.Name = accOb.Name;
            zCustomerAcct.Zuora__Status__c = 'Active';
            zCustomerAcct.Zuora__AccountNumber__c = 'A'+bcount;
            //zCustomerAcct.Zuora__Zuora_Id__c = 'A'+bcount+'z';
            zCustomerAcct.Zuora__BillToName__c = 'billing account'+accOb.Name;
            zCustomerAcct.Zuora__BillToCountry__c = 'Japan';
            zCustomerAcct.Zuora__SoldToName__c = 'billing account'+accOb.Name;
            zCustomerAcct.Zuora__DefaultPaymentMethod__c= 'CreditCard';
            zCustomerAcct.Zuora__Batch__c= 'Batch1';
            zCustomerAcct.Zuora__Currency__c= 'JPY';
            zCustomerAcct.Zuora__BillCycleDay__c= '5th of the month';
            bAccount.add(zCustomerAcct);
            bcount++;
        }
        Database.insert(bAccount,true);
        //add Zuora PaymentMethod
        for(Zuora__CustomerAccount__c obill: bAccount){
            Zuora__PaymentMethod__c oPaymethMethod = new Zuora__PaymentMethod__c();
            oPaymethMethod.Zuora__PaymentMethodStatus__c = 'Active';
            oPaymethMethod.Zuora__Type__c = 'CreditCard';
            oPaymethMethod.Zuora__CreditCardMaskNumber__c = '************1111';
            oPaymethMethod.Zuora__CreditCardType__c = 'Visa';
            oPaymethMethod.Zuora__DefaultPaymentMethod__c = true;
            oPaymethMethod.Zuora__CreditCardExpirationMonth__c = '8';
            oPaymethMethod.Zuora__CreditCardExpirationYear__c = '2018';
            oPaymethMethod.Zuora__BankIdentificationNumber__c = '411111';
            oPaymethMethod.Zuora__LastTransactionStatus__c = 'Approved';
            oPaymethMethod.Zuora__BankTransferAccountNumber__c = '4111111111111111';
            oPaymethMethod.Zuora__BillingAccount__c = obill.id;
            oPaymethMethod.Zuora__PaypalEmail__c = 'test@test.test';
            oZuoraPayMethList.add(oPaymethMethod);
        }
        Database.insert(oZuoraPayMethList,true);
        System.debug('oZuoraPayMethList'+oZuoraPayMethList);
        /*Add Zuora Subscription*/
        for(Zuora__CustomerAccount__c obillAcc: bAccount){
            Zuora__Subscription__c oSubscription = new Zuora__Subscription__c();
            oSubscription.Name = 'test billing account';
            oSubscription.Zuora__Status__c = 'Active';
            oSubscription.Zuora__SubscriptionStartDate__c = Date.Today();
            oSubscription.Zuora__NextChargeDate__c = Date.today().addMonths(2);
            oSubscription.Zuora__Account__c = obillAcc.Zuora__Account__c;
            oSubscription.Zuora__CustomerAccount__c = obillAcc.Id;
            oSubscription.Zuora__TermStartDate__c = Date.Today();
            lstSubscription.add(oSubscription);
          
        }
          Database.insert(lstSubscription,true);
            System.debug('lstSubscription'+lstSubscription);
    }
    @testSetup
    public static void createInvoice()
    {
        List<Zuora__ZInvoice__c> oZuoraInvoice = new List<Zuora__ZInvoice__c>();
        List<Zuora__CustomerAccount__c> baccList = [Select Id,Zuora__Account__c from Zuora__CustomerAccount__c];
        for(Zuora__CustomerAccount__c baccOb: baccList){
            Zuora__ZInvoice__c oZInvoice = new Zuora__ZInvoice__c();
            oZInvoice.Zuora__Account__c = baccOb.Zuora__Account__c;
            oZInvoice.Zuora__BillingAccount__c = baccOb.id;
            oZInvoice.Zuora__PaymentAmount__c = 0.00;
            oZInvoice.Zuora__InvoiceDate__c =  (Date.today()).addMonths(1);
            oZInvoice.Zuora__TotalAmount__c = 180.00;
            oZInvoice.Name ='test Invoice account';
            oZuoraInvoice.add(oZInvoice);
        }
        System.debug('***oZuoraInvoice'+oZuoraInvoice);
        Database.insert(oZuoraInvoice,true);
    } 
    
}