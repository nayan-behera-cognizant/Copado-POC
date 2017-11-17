/**
 * @ Author : Cognizant Technology Solutions
 * @ Date : 22/05/2017
 * @ Description : Apex class exposed as rest service to update Account status on Final payment failure from zuora
**/

@RestResource(urlMapping='/FinalFail/*')
global class FinalFail {
    
    public Static String straccountID;
    public Static String strpaymentID ;
    public Static String cancelDate;
    public Static String statusMessage;
    
    @HttpPost  
    global static void newSubscriptionPost() {
        
        String strJSONRequest ; 
        
        RestRequest JSONRequest = RestContext.request;
        RestResponse res = RestContext.response;
        
        if ( JSONRequest!= null){
            strJSONRequest = JSONRequest.requestBody.toString() ; 
        }
        
        FinalFail.finalFailJSON varfinalFailJSON = (FinalFail.finalFailJSON)JSON.deserialize(strJSONRequest, FinalFail.finalFailJSON.class);
        straccountID = varfinalFailJSON.AccountCrmId;
        strpaymentID = varfinalFailJSON.PaymentId ; 
        
        FinalFail.FinalPaymentFailAction(straccountID , strpaymentID  ); 
        
    }
    
    public static String FinalPaymentFailAction(String accountId, String strpaymentID  ){
        
        cancelDate = CommunityHelper.ConvertDateToString(Date.today(), 'ZouraFormat', 'NA');
        
        List<Zuora__Subscription__c> oSubscription = [Select Id,
                                                      Name From Zuora__Subscription__c
                                                      Where Zuora__Account__c = :accountId 
                                                      AND (Zuora__Status__c = 'Active'
                                                      OR (Zuora__Status__c = 'Cancelled'
                                                      AND Zuora__SubscriptionEndDate__c > TODAY))];
        
        Map<String, String> outputResult = PauseCalloutHelper.runImmediateCancelZuoraWorkflow(oSubscription[0].Name, cancelDate, strpaymentID);
        Boolean isResultSuccess = Boolean.valueOf(outputResult.get('success'));
        statusMessage = outputResult.get('message');
        
        if (!isResultSuccess) {
            
            return statusMessage; 
        }
        else {
            updateAccountStatusByZouraAccountId(straccountID, 'Frozen');
        }
        
        return statusMessage;
    }

    /*
Description: Method to update Account status based on payment status and Zuora Account Id.
*/
    public static void updateAccountStatusByZouraAccountId(String accountId, String sStatus) {

        List<Account> lstAccount = [
            SELECT Id, Account_Status__c
            FROM Account
            WHERE Id =:accountId LIMIT 1
        ];
        
        if (lstAccount!= NULL && !lstAccount.isEmpty()) {
            Account oAccount = lstAccount[0];
            oAccount.Account_Status__c = sStatus;
            
            if (sStatus =='Frozen') {
                oAccount.AuthKey__c = System.now();
            }
            
            update oAccount;
        }
    }
    
    public class finalFailJSON   
    {
        public String AccountCrmId; 
        public String PaymentId;
        
    }
}