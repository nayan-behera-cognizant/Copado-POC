/**
 * @ Author : Nayan Behera (Cognizant Technology Solutions)
 * @ Date : 23/05/2017
 * @ Description : Apex class exposed as rest service to handle pause call back from Zoura
**/
@RestResource(urlMapping='/StandardCancellation/*')
global class RestServiceForStandardCancellationPause {
    
    @HttpPost
    global static void HandleRestServiceForStandardCancellationPause() {
        RestRequest JSONRequest = RestContext.request;
		RestResponse res = RestContext.response;
        RestServiceForPauseCalloutHelper.StandardCancellationPauseLogic(JSONRequest.requestBody.toString());
    }
}