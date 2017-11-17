@RestResource(urlMapping='/ProcessRefund/*')
global class RefundProcessor {
    /*
Main method - to handle the chargeback callout from Zuora.
*/
    @HttpPost  
    global static String handleRefund() {
        String accountID;
        String requestString;
        String reasonCode;
        String paymentId;
        String lastInvoiceDate ;
        UpdateAccount updateAccount;
        final String CHARGEBACK = 'Chargeback';
        
        
        Map<String,String> mapAttributes = new Map<String,String> { 'AccountId' => '', 'RefundReasonCode' => '', 'PaymentID' => '', 'AccountLastInvoiceDate' => ''};
            updateAccount = new UpdateAccount();
        RestRequest req = RestContext.request;
        requestString = req.requestBody.toString();
        mapAttributes = updateAccount.getValuesFromRequestXML(mapAttributes,requestString);
        
        accountID = mapAttributes.get('AccountId');
        reasonCode = mapAttributes.get('RefundReasonCode');
        paymentId = mapAttributes.get('PaymentID');
        lastInvoiceDate = mapAttributes.get('AccountLastInvoiceDate');
        
        String[] invoiceDate = lastInvoiceDate.split('-',3);
        
        if(reasonCode == CHARGEBACK){
            
            if(!Test.isRunningTest()){
                ZuoraTransactionHelper.handleChargeBacks (paymentId , Date.parse(invoiceDate[2]+'/'+invoiceDate[1]+'/'+invoiceDate[0]));
            }
            updateAccount(accountID);
            
        }
        
        return accountID;
    }
    
    /*Update the account status to Blocked, since the User has been cancelled in zuora*/
    private static void updateAccount(String billingAccountId){
        List<Zuora__CustomerAccount__c> lstAccount = [Select Zuora__Account__c from Zuora__CustomerAccount__c where Zuora__External_Id__c = :billingAccountId];
        if(lstAccount != null &&  !lstAccount.isEmpty()){
            Account account = new Account (Id = lstAccount[0].Zuora__Account__c, Account_Status__c = 'Blocked', All_Email_Preferences__c = false, Is_Double_OptIn__c = false);
            update account;
        }
    }
    
    
}