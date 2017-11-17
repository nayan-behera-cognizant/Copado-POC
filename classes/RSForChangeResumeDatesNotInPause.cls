/**
 * @ Author : Nayan Behera (Cognizant Technology Solutions)
 * @ Date : 23/05/2017
 * @ Description : Apex class exposed as rest service to handle pause call back from Zoura
**/
@RestResource(urlMapping='/ChangeResumeDatesNotInPause/*')
global class RSForChangeResumeDatesNotInPause {
    
    @HttpPost
    global static void HandleRestServiceForChangeResumeDatesNotInPause() {
        RestRequest JSONRequest = RestContext.request;
		RestResponse res = RestContext.response;
        RestServiceForPauseCalloutHelper.ChangeResumeDatesNotInPauseLogic(JSONRequest.requestBody.toString());
    }
}