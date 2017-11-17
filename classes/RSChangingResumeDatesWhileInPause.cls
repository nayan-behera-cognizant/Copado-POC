/**
 * @ Author : Nayan Behera (Cognizant Technology Solutions)
 * @ Date : 23/05/2017
 * @ Description : Apex class exposed as rest service to handle pause call back from Zoura
**/
@RestResource(urlMapping='/ChangingResumeDatesWhileInPause/*')
global class RSChangingResumeDatesWhileInPause {
    
    @HttpPost
    global static void HandleRestServiceForChangingResumeDatesWhileInPause() {
        RestRequest JSONRequest = RestContext.request;
		RestResponse res = RestContext.response;
        RestServiceForPauseCalloutHelper.ChangingResumeDatesWhileInPauseLogic(JSONRequest.requestBody.toString());
    }
}