/**
 * @ Description : Apex class exposed as rest service to handle callback from Zoura Workflows for Standard Cancel
**/
@RestResource(urlMapping='/StandardCancel/*')
global class StandardCancel {

    @HttpPost
    global static void handleStandardCancelFromZuoraWorkflow() {
        RestRequest JSONRequest = RestContext.request;
        RestResponse res = RestContext.response;
        try {
            uncheckSubmittedForCancellationCheckbox(JSONRequest.requestBody.toString());
            res.statusCode = 200;
        } catch (Exception e) {
            res.statusCode = 500;
        }
    }

    public static void uncheckSubmittedForCancellationCheckbox(String JSONRequest) {
        Map<String, Object> mapParentObj = (Map<String, Object>)JSON.deserializeUntyped(JSONRequest);
        Map<String, Object> workFlowMap = (Map<String, Object>)mapParentObj.get('Workflow'); 
        
        if ((String)workFlowMap.get('SubscriptionName') != '' && (String)workFlowMap.get('SubscriptionName') != null) {
            List<Zuora__Subscription__c> subscriptions = [
                SELECT Id, Zuora__Account__c
                FROM Zuora__Subscription__c 
                WHERE Name = :(String)workFlowMap.get('SubscriptionName')
            ];
            if (!subscriptions.isEmpty()) {
                List<Account> accs = [
                    SELECT Id, Submitted_for_cancellation__c
                    FROM Account 
                    WHERE Id =:subscriptions[0].Zuora__Account__c
                        AND Submitted_for_cancellation__c = true
                    LIMIT 1
                ];
                if (!accs.isEmpty()) {
                    accs[0].Submitted_for_cancellation__c = false;
                    update accs[0];
                }
            }
        }
    }

}