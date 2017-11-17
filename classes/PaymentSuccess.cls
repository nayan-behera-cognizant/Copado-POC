@RestResource(urlMapping='/PaymentSuccess/*')
global class PaymentSuccess {
    
    @HttpPost  
    global static String newSubscriptionPost() {
        String accountID;
        String requestString;
        UpdateAccount updateAccount;
        
        updateAccount = new UpdateAccount();
        RestRequest req = RestContext.request;
        requestString = req.requestBody.toString();
        accountID=updateAccount.getAccountId(requestString);
        updateAccount.processSuccessfulPayment(accountID);
        
        return accountID;
    }
}