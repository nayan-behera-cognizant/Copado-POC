/**
 * @ Author : Nayan Behera (Cognizant Technology Solutions)
 * @ Date : 22/05/2017
 * @ Description : Apex class exposed as rest service to handle pause call back from Zoura for Immediate Resume Workflow success
**/
@RestResource(urlMapping='/ImmediateResumePause/*')
global class RestServiceForImmediateResumePause {
    
    @HttpPost
    global static void HandleRestServiceForImmediateResumePause() {
        RestRequest JSONRequest = RestContext.request;
		RestResponse res = RestContext.response;
        RestServiceForPauseCalloutHelper.ImmediateResumePauseLogic(JSONRequest.requestBody.toString());
    }
}