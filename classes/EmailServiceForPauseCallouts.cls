/**
 * @ Author : Nayan Behera (Cognizant Technology Solutions)
 * @ Date : 30/03/2017
 * @ Description : Apex class receiving the Email Call outs and calling specific handler method by reading the subject of the email
**/
global class EmailServiceForPauseCallouts implements Messaging.InboundEmailHandler{
	
    /**
     * @ Author : Nayan Behera (Cognizant Technology Solutions)
     * @ Date : 31/03/2017
     * @ Description : Method handling the web service call outs
	**/ 
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email,Messaging.InboundEnvelope env){
 
        // Apex Email Service Result
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();   
        try {
            //Check if it is flow 1 : Immediate Resume Workflow
            if(email.subject == Label.Subject_ImmediateResume)
                EmailServiceForPauseCalloutHelper.ImmediateResumePause_FLOW_1(email);
            //Check if it is flow 2 : Cancel Pause Workflow
            if(email.subject == Label.Subject_CancelPauseResume)
                EmailServiceForPauseCalloutHelper.CancelPause_FLOW_2(email); 
            //Check if it is flow 3 : Cancel Pause Workflow
            if(email.subject == Label.Subject_SuspendPause)
            	EmailServiceForPauseCalloutHelper.SetPause_FLOW_3(email);
            //Check if it is flow 4 : Standard Cancel with Scheduled Pause success
            if(email.subject == Label.Subject_StandardCancel)
                EmailServiceForPauseCalloutHelper.StandardCancellationPause_FLOW_4(email);
            //Check if it is flow 5 : Immediate Cancel with Scheduled Pause success
            if(email.subject == Label.Subject_ImmediateCancel)
                EmailServiceForPauseCalloutHelper.ImmediateCancellationPause_FLOW_5(email);
            //Check if it is flow 6 : Change Resume Date when in Pause success
            if(email.subject == Label.Subject_ChangeResumeDate)
                EmailServiceForPauseCalloutHelper.ChangingResumeDatesWhileInPause_FLOW_6(email);
            //Check if it is flow 7 : Change Resume Date when NOT in Pause success
            if(email.subject == Label.Subject_ChangeResumeDateNotPause)
                EmailServiceForPauseCalloutHelper.ChangeResumeDatesNotInPause_FLOW_7(email);
            // with a success message
        	result.success = true; 
        }catch (exception ex) { 
            // with an error message
        	result.success = false;
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CreateCaseForEmailToCase', 'handleInboundEmail', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
       }              
        // Return the result for the Apex Email Service
        return result;
    }
}