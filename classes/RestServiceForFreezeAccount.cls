/**
 * @ Author : Cognizant Technology Solutions
 * @ Date : 27/06/2017
 * @ Description : Apex class exposed as rest service to freeze a customer whose last payment resulted in a chargeback 
**/
@RestResource(urlMapping='/FreezeAccount/*')
global class RestServiceForFreezeAccount {
    
    @HttpPost
    global static void HandleRestServiceForFreezeAccount() {
        RestRequest JSONRequest = RestContext.request;
    RestResponse res = RestContext.response;
    RestServiceForPauseCalloutHelper.fetchAccountFromjson(JSONRequest.requestBody.toString());
    
	}
}