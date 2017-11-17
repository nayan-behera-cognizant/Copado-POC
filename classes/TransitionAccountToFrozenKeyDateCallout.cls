/*PD-9349*/
@RestResource(urlMapping='/KeyDate/*')
global class TransitionAccountToFrozenKeyDateCallout {
    
  @HttpPost  
  global static String endSubscriptionPost() {
    String accountID;
    String subscriptionID;
    String requestString;
    UpdateAccount updateAccount;
      
    updateAccount = new UpdateAccount();
    RestRequest req = RestContext.request;
    requestString = req.requestBody.toString();
    accountID=updateAccount.getAccountId(requestString);
    updateAccount.TransitionAccountToFrozen(accountID);
    
    return accountID;
  }
}