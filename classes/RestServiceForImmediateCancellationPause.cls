/**
 * @ Author : Nayan Behera (Cognizant Technology Solutions)
 * @ Date : 23/05/2017
 * @ Description : Apex class exposed as rest service to handle pause call back from Zoura
**/
@RestResource(urlMapping='/ImmediateCancellationPause/*')
global class RestServiceForImmediateCancellationPause {
    
    @HttpPost
    global static void HandleRestServiceForImmediateCancellationPause() {
        RestRequest JSONRequest = RestContext.request;
		RestResponse res = RestContext.response;
        RestServiceForPauseCalloutHelper.ImmediateCancellationPauseLogic(JSONRequest.requestBody.toString());
    }
}