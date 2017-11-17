/**
 * @ Author : Nayan Behera (Cognizant Technology Solutions)
 * @ Date : 23/05/2017
 * @ Description : Apex class exposed as rest service to handle pause call back from Zoura
**/
@RestResource(urlMapping='/CancelPause/*')
global class RestServiceForCancelPause {
    
    @HttpPost
    global static void HandleRestServiceForCancelPause() {
        RestRequest JSONRequest = RestContext.request;
		RestResponse res = RestContext.response;
        RestServiceForPauseCalloutHelper.CancelPauseLogic(JSONRequest.requestBody.toString());
    }
}