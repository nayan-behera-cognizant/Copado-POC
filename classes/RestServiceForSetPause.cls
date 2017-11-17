/**
 * @ Author : Nayan Behera (Cognizant Technology Solutions)
 * @ Date : 23/05/2017
 * @ Description : Apex class exposed as rest service to handle pause call back from Zoura
**/
@RestResource(urlMapping='/SetPause/*')
global class RestServiceForSetPause {
    
    @HttpPost
    global static void HandleRestServiceForSetPause() {
        RestRequest JSONRequest = RestContext.request;
        RestResponse res = RestContext.response;
        RestServiceForPauseCalloutHelper.SetPauseLogic(JSONRequest.requestBody.toString());
    }
}