public without sharing class PauseCalloutHelper {


    public class SetPauseBody {
        public String SubscriptionName;
        public String ResumeDate;
        public String SuspendDate;
        public String BCD;

        public SetPauseBody(String SubscriptionName, String ResumeDate, String SuspendDate, String BCD) {
            this.SubscriptionName = SubscriptionName;
            this.ResumeDate = ResumeDate;
            this.SuspendDate = SuspendDate;
            this.BCD = BCD;
        }
    }
    
    public class SetStandardCancelBody {
        public String SubscriptionName;
        public String CancelDate;

        public SetStandardCancelBody(String SubscriptionName, String CancelDate) {
            this.SubscriptionName = SubscriptionName;
            this.CancelDate = CancelDate;
        }
    }
    
    public class SetImmediateCancelBody {
        public String SubscriptionName;
        public String CancelDate;
        public String PaymentID;

        public SetImmediateCancelBody(String SubscriptionName, String CancelDate, String PaymentID) {
            this.SubscriptionName = SubscriptionName;
            this.CancelDate = CancelDate;
            this.PaymentID = PaymentID;
        }
    }
    
    public class SetUndoCancellationBody {
        public String SubscriptionName;

        public SetUndoCancellationBody(String SubscriptionName) {
            this.SubscriptionName = SubscriptionName;
        }
    }

    public class EditPauseScheduledBody {
        public String SubscriptionName;
        public String ResumeDate;
        public String SuspendDate;
        public String BCD;

        public EditPauseScheduledBody(String SubscriptionName, String ResumeDate, String SuspendDate, String BCD) {
            this.SubscriptionName = SubscriptionName;
            this.ResumeDate = ResumeDate;
            this.SuspendDate = SuspendDate;
            this.BCD = BCD;
        }
    }

    public class EditPausePausedBody {
        public String SubscriptionName;
        public String ResumeDate;
        public String BCD;

        public EditPausePausedBody(String SubscriptionName, String ResumeDate, String BCD) {
            this.SubscriptionName = SubscriptionName;
            this.ResumeDate = ResumeDate;
            this.BCD = BCD;
        }
    }

    public class CancelPauseBeforeStartBody {
        public String SubscriptionName;
        public String PreviousBCD;
        public String CancelDate;

        public CancelPauseBeforeStartBody(String SubscriptionName, String PreviousBCD, String CancelDate) {
            this.SubscriptionName = SubscriptionName;
            this.PreviousBCD = PreviousBCD;
            this.CancelDate = CancelDate;
        }
    }

    public class SetPauseBodyCancelSubscription {
        public String SubscriptionName;
        public Integer PreviousBCD;
        public String CancelDate;
        public String PaymentID;

        public SetPauseBodyCancelSubscription(String SubscriptionName, Integer PreviousBCD, String CancelDate, String PaymentID) {
            this.SubscriptionName = SubscriptionName;
            this.PreviousBCD = PreviousBCD;
            this.CancelDate = CancelDate;
            this.PaymentID = PaymentID;
        }
    }

    public class SetPauseSuccessResponse {
        public String id;
        public String name;
        public String originalWorkflowId;
        public SetPauseSuccessResponseTasks tasks;
        public String runTime;
        public String cpuTime;
        public String createdAt;
        public String updatedAt;
    }

    public class SetPauseSuccessResponseTasks {
        public String total;
        public String queued;
        public String processing;
        public String pending;
        public String stopped;
        public String success;
        public String error;
    }

    public class SetPauseFailureResponse {
        public List<SetPauseFailureResponseError> errors;
    }

    public class SetPauseFailureResponseError {
        public String status;
        public String code;
        public String title;
    }

    public static HttpResponse performZuoraCallout(String endpointUrl, String method, String contetnType, String auth, String body) {
        HttpRequest request = new HttpRequest();

        request.setEndpoint(endpointUrl);
        request.setMethod(method);
        request.setHeader('content-type', contetnType);
        request.setHeader('Authorization', auth);

        request.setBody(body);
        Http http = new Http();
        HttpResponse response = http.send(request);
        return response;
    }

    /*
    Description: Method to initiate or amend pause. 
    */
    public static Map<String, String> initPauseCallout(String subscriptionName, String resumeDate, String suspendDate, String bcd) {
        Map<String, String> result;
        try {
            String endpointUrl = (DAZNConfiguration__c.getValues('ZuoraStandardPauseResumeScheduleUrl') != null) ? DAZNConfiguration__c.getValues('ZuoraStandardPauseResumeScheduleUrl').Value__c : null;
            String username = (DAZNConfiguration__c.getValues('ZuoraPauseUsername') != null) ? DAZNConfiguration__c.getValues('ZuoraPauseUsername').Value__c : null;
            String password = (DAZNConfiguration__c.getValues('ZuoraPausePassword') != null) ? DAZNConfiguration__c.getValues('ZuoraPausePassword').Value__c : null;

            Boolean isEmptyCalloutParameters = String.isBlank(endpointUrl) || String.isBlank(username) || String.isBlank(password);
            if (isEmptyCalloutParameters) {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Custom settings are missed: SetPauseURL/Username/Password' };
                return result;
            }
    
            Blob authorizationBlob = Blob.valueOf(username + ':' + password);
            String authorization = EncodingUtil.base64Encode(authorizationBlob);

            HttpResponse response = PauseCalloutHelper.performZuoraCallout(
                endpointUrl,
                'POST',
                'application/json',
                'Basic ' + authorization,
                JSON.serialize(new PauseCalloutHelper.SetPauseBody(subscriptionName, resumeDate, suspendDate, bcd))
            ); //calout to zuora

            Integer responseStatusCode = response.getStatusCode();
            String responseBody = response.getbody();
            if (responseStatusCode == 200) {
                PauseCalloutHelper.SetPauseSuccessResponse setPauseSuccessResponse = (PauseCalloutHelper.SetPauseSuccessResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseSuccessResponse.class);
                result = new Map<String, String>{ 'success' => 'true', 'message' => setPauseSuccessResponse.id };
            } else if (responseStatusCode == 406) {
                PauseCalloutHelper.SetPauseFailureResponse setPauseFailureResponse = (PauseCalloutHelper.SetPauseFailureResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseFailureResponse.class);
                String errorMsg = '';
                for (PauseCalloutHelper.SetPauseFailureResponseError error : setPauseFailureResponse.errors) {
                    errorMsg += error.title + '\n';
                }
                errorMsg = errorMsg.substring(0, errorMsg.length() - 2);
                result = new Map<String, String>{ 'success' => 'false', 'message' => errorMsg };
            } else {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Unknown error' };
            }
        } catch(Exception e) {
            result = new Map<String, String>{ 'success' => 'false', 'message' => e.getMessage() };
        }

        return result;
    }

    /*
    Description: Method to amend pause while user is already in pause. 
    */
    public static Map<String, String> amendPauseCallout(String subscriptionName, String resumeDate, String previousBCD) {
        Map<String, String> result;
        try {
            String endpointUrl = (DAZNConfiguration__c.getValues('ZuoraChangeResumeDatesWhileInPauseURL') != null) ? DAZNConfiguration__c.getValues('ZuoraChangeResumeDatesWhileInPauseURL').Value__c : null;
            String username = (DAZNConfiguration__c.getValues('ZuoraPauseUsername') != null) ? DAZNConfiguration__c.getValues('ZuoraPauseUsername').Value__c : null;
            String password = (DAZNConfiguration__c.getValues('ZuoraPausePassword') != null) ? DAZNConfiguration__c.getValues('ZuoraPausePassword').Value__c : null;

            Boolean isEmptyCalloutParameters = String.isBlank(endpointUrl) || String.isBlank(username) || String.isBlank(password);
            if (isEmptyCalloutParameters) {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Custom settings are missed: SetPauseURL/Username/Password' };
                return result;
            }
    
            Blob authorizationBlob = Blob.valueOf(username + ':' + password);
            String authorization = EncodingUtil.base64Encode(authorizationBlob);

            HttpResponse response = PauseCalloutHelper.performZuoraCallout(
                endpointUrl,
                'POST',
                'application/json',
                'Basic ' + authorization,
                JSON.serialize(new PauseCalloutHelper.EditPausePausedBody(subscriptionName, resumeDate, previousBCD))
            ); //calout to zuora

            Integer responseStatusCode = response.getStatusCode();
            String responseBody = response.getbody();
            if (responseStatusCode == 200) {
                PauseCalloutHelper.SetPauseSuccessResponse setPauseSuccessResponse = (PauseCalloutHelper.SetPauseSuccessResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseSuccessResponse.class);
                result = new Map<String, String>{ 'success' => 'true', 'message' => setPauseSuccessResponse.id };
            } else if (responseStatusCode == 406) {
                PauseCalloutHelper.SetPauseFailureResponse setPauseFailureResponse = (PauseCalloutHelper.SetPauseFailureResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseFailureResponse.class);
                String errorMsg = '';
                for (PauseCalloutHelper.SetPauseFailureResponseError error : setPauseFailureResponse.errors) {
                    errorMsg += error.title + '\n';
                }
                errorMsg = errorMsg.substring(0, errorMsg.length() - 2);
                result = new Map<String, String>{ 'success' => 'false', 'message' => errorMsg };
            } else {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Unknown error' };
            }
        } catch(Exception e) {
            result = new Map<String, String>{ 'success' => 'false', 'message' => e.getMessage() };
        }

        return result;
    }

    /*
    Description: Method to amend pause while user is about to pause. 
    */
    public static Map<String, String> amendFuturePauseCallout(String subscriptionName, String resumeDate, String previousBCD) {
        Map<String, String> result;
        try {
            String endpointUrl = (DAZNConfiguration__c.getValues('ZuoraChangeResumeDatesBeforePauseURL') != null) ? DAZNConfiguration__c.getValues('ZuoraChangeResumeDatesBeforePauseURL').Value__c : null;
            String username = (DAZNConfiguration__c.getValues('ZuoraPauseUsername') != null) ? DAZNConfiguration__c.getValues('ZuoraPauseUsername').Value__c : null;
            String password = (DAZNConfiguration__c.getValues('ZuoraPausePassword') != null) ? DAZNConfiguration__c.getValues('ZuoraPausePassword').Value__c : null;

            Boolean isEmptyCalloutParameters = String.isBlank(endpointUrl) || String.isBlank(username) || String.isBlank(password);
            if (isEmptyCalloutParameters) {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Custom settings are missed: SetPauseURL/Username/Password' };
                return result;
            }
    
            Blob authorizationBlob = Blob.valueOf(username + ':' + password);
            String authorization = EncodingUtil.base64Encode(authorizationBlob);

            HttpResponse response = PauseCalloutHelper.performZuoraCallout(
                endpointUrl,
                'POST',
                'application/json',
                'Basic ' + authorization,
                JSON.serialize(new PauseCalloutHelper.EditPausePausedBody(subscriptionName, resumeDate, previousBCD))
            ); //calout to zuora

            Integer responseStatusCode = response.getStatusCode();
            String responseBody = response.getbody();
            if (responseStatusCode == 200) {
                PauseCalloutHelper.SetPauseSuccessResponse setPauseSuccessResponse = (PauseCalloutHelper.SetPauseSuccessResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseSuccessResponse.class);
                result = new Map<String, String>{ 'success' => 'true', 'message' => setPauseSuccessResponse.id };
            } else if (responseStatusCode == 406) {
                PauseCalloutHelper.SetPauseFailureResponse setPauseFailureResponse = (PauseCalloutHelper.SetPauseFailureResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseFailureResponse.class);
                String errorMsg = '';
                for (PauseCalloutHelper.SetPauseFailureResponseError error : setPauseFailureResponse.errors) {
                    errorMsg += error.title + '\n';
                }
                errorMsg = errorMsg.substring(0, errorMsg.length() - 2);
                result = new Map<String, String>{ 'success' => 'false', 'message' => errorMsg };
            } else {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Unknown error' };
            }
        } catch(Exception e) {
            result = new Map<String, String>{ 'success' => 'false', 'message' => e.getMessage() };
        }

        return result;
    }

    /*
    Description: Method to initiate or amend pause. 
    */
    public static Map<String, String> cancelPauseCallout(String subscriptionName, String previousBCD) {
        Map<String, String> result;
        try {
            String endpointUrl = (DAZNConfiguration__c.getValues('ZuoraCancelPauseBeforeStartURL') != null) ? DAZNConfiguration__c.getValues('ZuoraCancelPauseBeforeStartURL').Value__c : null;
            String username = (DAZNConfiguration__c.getValues('ZuoraPauseUsername') != null) ? DAZNConfiguration__c.getValues('ZuoraPauseUsername').Value__c : null;
            String password = (DAZNConfiguration__c.getValues('ZuoraPausePassword') != null) ? DAZNConfiguration__c.getValues('ZuoraPausePassword').Value__c : null;

            Boolean isEmptyCalloutParameters = String.isBlank(endpointUrl) || String.isBlank(username) || String.isBlank(password);
            if (isEmptyCalloutParameters) {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Custom settings are missed: SetPauseURL/Username/Password' };
                return result;
            }
    
            Blob authorizationBlob = Blob.valueOf(username + ':' + password);
            String authorization = EncodingUtil.base64Encode(authorizationBlob);

            String strCancelDate = DateTime.now().format('yyyy-MM-dd');

            HttpResponse response = PauseCalloutHelper.performZuoraCallout(
                endpointUrl,
                'POST',
                'application/json',
                'Basic ' + authorization,
                JSON.serialize(new PauseCalloutHelper.CancelPauseBeforeStartBody(subscriptionName, previousBCD, strCancelDate))
            ); //calout to zuora

            Integer responseStatusCode = response.getStatusCode();
            String responseBody = response.getbody();
            if (responseStatusCode == 200) {
                PauseCalloutHelper.SetPauseSuccessResponse setPauseSuccessResponse = (PauseCalloutHelper.SetPauseSuccessResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseSuccessResponse.class);
                result = new Map<String, String>{ 'success' => 'true', 'message' => setPauseSuccessResponse.id };
            } else if (responseStatusCode == 406) {
                PauseCalloutHelper.SetPauseFailureResponse setPauseFailureResponse = (PauseCalloutHelper.SetPauseFailureResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseFailureResponse.class);
                String errorMsg = '';
                for (PauseCalloutHelper.SetPauseFailureResponseError error : setPauseFailureResponse.errors) {
                    errorMsg += error.title + '\n';
                }
                errorMsg = errorMsg.substring(0, errorMsg.length() - 2);
                result = new Map<String, String>{ 'success' => 'false', 'message' => errorMsg };
            } else {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Unknown error' };
            }
        } catch(Exception e) {
            result = new Map<String, String>{ 'success' => 'false', 'message' => e.getMessage() };
        }

        return result;
    }
    
 
   

    public static Map<String, String> initPauseCalloutScheduledFuture(Account acc, Boolean isStandard) {
        Map<String, String> result;
        try {
            String endpointUrl;
            if (isStandard) {
                endpointUrl = (DAZNConfiguration__c.getValues('ZuoraPauseCancelSubscSchInFuture') != null) ? DAZNConfiguration__c.getValues('ZuoraPauseCancelSubscSchInFuture').Value__c : null;
            } else {
                endpointUrl = (DAZNConfiguration__c.getValues('ZuoraPauseCancelSubscSchInFuture43') != null) ? DAZNConfiguration__c.getValues('ZuoraPauseCancelSubscSchInFuture43').Value__c : null;
            }
            
            String username = (DAZNConfiguration__c.getValues('ZuoraPauseCancelUserName') != null) ? DAZNConfiguration__c.getValues('ZuoraPauseCancelUserName').Value__c : null;
            String password = (DAZNConfiguration__c.getValues('ZuoraPauseCancelSubPass') != null) ? DAZNConfiguration__c.getValues('ZuoraPauseCancelSubPass').Value__c : null;
            
            Boolean isEmptyCalloutParameters = String.isBlank(endpointUrl) || String.isBlank(username) || String.isBlank(password);
            if (isEmptyCalloutParameters) {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Custom settings are missed: SetPauseURL/Username/Password' };
                return result;
            }

            Blob authorizationBlob = Blob.valueOf(username + ':' + password);
            String authorization = EncodingUtil.base64Encode(authorizationBlob);

            String subscriptionName = '';
            Integer previousBCD = Integer.valueOf(acc.Previous_BCD__c);
            String cancelDate = DateTime.now().format('yyyy-MM-dd');
            
            /*start PD-12600*/
            //commented as part of PD-13271
            /*Zuora__Subscription__c oSubscription = acc.Zuora__Subscriptions__r[0];
            String ratePlanId = ZuoraTransactionHelper.getRatePlanIdBySubscriptionId(oSubscription.Zuora__External_Id__c);
            if (String.isNotBlank(ratePlanId)) {
                DateTime ratePlanChargeChargedThroughDate = ZuoraTransactionHelper.getRatePlanChargeChargedThroughDateByRatePlanId(ratePlanId);*/
                //added as part of PD-13271
                if (isStandard) {
                    DateTime ratePlanChargeChargedThroughDate = ZuoraTransactionHelper.getRatePlanChargeChargedThroughDateByAccountId(acc.Id);
                    if (ratePlanChargeChargedThroughDate != null) { 
                        cancelDate = ratePlanChargeChargedThroughDate.format('yyyy-MM-dd');
                    }
                    
                  
                }
            //}
            /*enad PD-12600*/

            List<Zuora__Subscription__c> subscriptions = [Select Id, Name From Zuora__Subscription__c Where Zuora__Account__c = :acc.Id AND Zuora__Status__c = 'Active'];
            if (!subscriptions.isEmpty()) {
                subscriptionName = subscriptions[0].Name;
            }

            //PD-12216
            String paymentID = '';
            List<Zuora__Payment__c> payments = [Select Id, Zuora__External_Id__c From Zuora__Payment__c Where Zuora__Account__c = :acc.Id Order By Zuora__CreatedDate__c DESC LIMIT 1];
            if (!payments.isEmpty()) {
                paymentID = payments[0].Zuora__External_Id__c;
            }
            //---

            HttpResponse response = PauseCalloutHelper.performZuoraCallout(
                endpointUrl,
                'POST',
                'application/json',
                'Basic ' + authorization,
                JSON.serialize(new PauseCalloutHelper.SetPauseBodyCancelSubscription(subscriptionName, previousBCD, cancelDate, paymentID))
            );
            Integer responseStatusCode = response.getStatusCode();
            String responseBody = response.getbody();
            if (responseStatusCode == 200) {
                PauseCalloutHelper.SetPauseSuccessResponse setPauseSuccessResponse = (PauseCalloutHelper.SetPauseSuccessResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseSuccessResponse.class);
                result = new Map<String, String>{ 'success' => 'true', 'message' => setPauseSuccessResponse.id };
                WhyController.createNewRecordInPauseHistory(acc.Id, null, null, 'Success', setPauseSuccessResponse.Id, 'Cancel subscription', null);
            } else if (responseStatusCode == 406) {
                PauseCalloutHelper.SetPauseFailureResponse setPauseFailureResponse = (PauseCalloutHelper.SetPauseFailureResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseFailureResponse.class);
                String errorMsg = '';
                for (PauseCalloutHelper.SetPauseFailureResponseError error : setPauseFailureResponse.errors) {
                    errorMsg += error.title + '\n';
                }
                errorMsg = errorMsg.substring(0, errorMsg.length() - 2);
                result = new Map<String, String>{ 'success' => 'false', 'message' => errorMsg };
            } else {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Unknown error' };
            }
        } catch (Exception e) {
            result = new Map<String, String>{ 'success' => 'false', 'message' => e.getMessage() };
        }

        return result;
    }

    /*
    Description: Method to update NextChargeDate on active subscription.
    */
    private static void setSubscriptionNextChargeDate(String accountId, Date nextChargeDate) {
        List<Zuora__Subscription__c> sub = [Select Id, Zuora__NextChargeDate__c From Zuora__Subscription__c Where Zuora__Account__c = :accountId AND Zuora__Status__c = 'Active' LIMIT 1];
        if (!sub.isEmpty()) {
            sub[0].Zuora__NextChargeDate__c = nextChargeDate;
            update sub;
        }
    }

    /*
    Description: Method to process seccess result of pause callout. 
    */
    public static PageReference pauseFlowProcessSuccess(String strAction, User user, Account usersAccount, Date dResumeDate, Date dSuspendDate, String workflowId, Decimal billCycleDay, Boolean bSubmittedForCancellation, String country, String lang) {
        Boolean updateAccount = false;

        Date pauseFrom;
        Date pauseUntil;
        DateTime pauseScheduledTime;
        String accountStatus;
        Boolean submittedForCancellation = bSubmittedForCancellation;
        String workflowStatus = 'Unknown';
        String actionPerformed;
        Date subscriptionCancellationDate;

        DateTime dtSuspendDate = dSuspendDate;
        DateTime dt = Datetime.now();
        Integer timeDiff = dt.hour() - dt.hourGMT();
        DateTime currentDate = Date.today();
        currentDate = currentDate.addHours(timeDiff);
        
        Boolean isFutureAction = (dtSuspendDate > currentDate);

        PageReference resultPage;
        Boolean isKeepInTouchPageAvailable = false;
        if (strAction.equalsIgnoreCase('initiate')) { //set pause
            accountStatus = (isFutureAction) ? usersAccount.Account_Status__c : 'Paused';
            pauseFrom = dSuspendDate;
            pauseUntil = dResumeDate;
            pauseScheduledTime = dtSuspendDate.addHours(-1 * timeDiff);
            actionPerformed = 'Set Pause';

            isKeepInTouchPageAvailable = checkMarketingPreferences(user.Country, usersAccount.All_Email_Preferences__c, usersAccount.Is_Double_OptIn__c);
            if (isKeepInTouchPageAvailable) {
                resultPage = new PageReference('/keepintouch/initiate'); //go on KeepInTouch page
            } else {
                resultPage = redirectToMyAccount(dResumeDate.format(), dSuspendDate.format(), 'initPause');
            }
            updateAccount = true;
            //setSubscriptionNextChargeDate(usersAccount.Id, pauseUntil);
        } else if (strAction.equalsIgnoreCase('amend')) {
        
         //update pause
            pauseFrom = usersAccount.Pause_From__c;
            pauseUntil = dResumeDate;
            pauseScheduledTime = usersAccount.Pause_Scheduled_Time__c;
            accountStatus = usersAccount.Account_Status__c;

            if (isFutureAction) {
                actionPerformed = 'Edit Pause';
                isKeepInTouchPageAvailable = checkMarketingPreferences(user.Country, usersAccount.All_Email_Preferences__c, usersAccount.Is_Double_OptIn__c);
                if (isKeepInTouchPageAvailable) {
                    resultPage = new PageReference('/keepintouch/amend'); //go on KeepInTouch page
                } else {
                    resultPage = redirectToMyAccount(dResumeDate.format(), dSuspendDate.format(), 'amendedPause');
                }
            } else {
                actionPerformed = 'Edit resume dates in pause';
                resultPage = redirectToMyAccount('', '', '');
            }
            updateAccount = true;
            //setSubscriptionNextChargeDate(usersAccount.Id, pauseUntil);
        } else if (strAction.equalsIgnoreCase('cancel')) { //cancel pause
            pauseFrom = null;
            pauseUntil = null;
            pauseScheduledTime = null;
            accountStatus = 'Active Paid';

            if (usersAccount.PauseScheduled__c) {
                actionPerformed = 'Cancel scheduled pause';
                submittedForCancellation = true;
                resultPage = redirectToMyAccount('', '', 'stayActive');
                updateAccount = true;
            } else {
                actionPerformed = 'Cancel subscription in pause';
                resultPage = redirectToMyAccount(dResumeDate.format(), '', 'welcomeBack');
                //added as part of PD-13022
                usersAccount.Submitted_for_cancellation__c = true;
                update usersAccount;
            }
        }

        addNewRecordInPauseHistory(usersAccount.Id, pauseFrom, pauseUntil, workflowStatus, workflowId, actionPerformed, subscriptionCancellationDate);

        if (updateAccount) {
            //commented as part of PD-13022
            //updateUserAccount(usersAccount, pauseFrom, pauseUntil, pauseScheduledTime, accountStatus, billCycleDay, submittedForCancellation);
            updateUserAccount(usersAccount, pauseFrom, pauseUntil, pauseScheduledTime, accountStatus, billCycleDay, true);
        }

        return resultPage;
    }

    public static PageReference pauseFlowProcessSuccess(String strAction, User user, Account usersAccount, Date dResumeDate, Date dSuspendDate, String workflowId, Decimal billCycleDay, Boolean bSubmittedForCancellation) {
        Boolean updateAccount = false;

        Date pauseFrom;
        Date pauseUntil;
        DateTime pauseScheduledTime;
        String accountStatus;
        Boolean submittedForCancellation = bSubmittedForCancellation;
        String workflowStatus = 'Unknown';
        String actionPerformed;
        Date subscriptionCancellationDate;

        DateTime dtSuspendDate = dSuspendDate;
        DateTime dt = Datetime.now();
        Integer timeDiff = dt.hour() - dt.hourGMT();
        DateTime currentDate = Date.today();
        currentDate = currentDate.addHours(timeDiff);
        
        Boolean isFutureAction = (dtSuspendDate > currentDate);

        PageReference resultPage;
        Boolean isKeepInTouchPageAvailable = false;
        if (strAction.equalsIgnoreCase('initiate')) { //set pause
            accountStatus = (isFutureAction) ? usersAccount.Account_Status__c : 'Paused';
            pauseFrom = dSuspendDate;
            pauseUntil = dResumeDate;
            pauseScheduledTime = dtSuspendDate.addHours(-1 * timeDiff);
            actionPerformed = 'Set Pause';

            isKeepInTouchPageAvailable = checkMarketingPreferences(user.Country, usersAccount.All_Email_Preferences__c, usersAccount.Is_Double_OptIn__c);
            if (isKeepInTouchPageAvailable) {
                resultPage = new PageReference('/keepintouch/initiate'); //go on KeepInTouch page
            } else {
                resultPage = redirectToMyAccount(dResumeDate.format(), dSuspendDate.format(), 'initPause');
            }
            updateAccount = true;
            //setSubscriptionNextChargeDate(usersAccount.Id, pauseUntil);
        } else if (strAction.equalsIgnoreCase('amend')) { //update pause
            pauseFrom = usersAccount.Pause_From__c;
            pauseUntil = dResumeDate;
            pauseScheduledTime = usersAccount.Pause_Scheduled_Time__c;
            accountStatus = usersAccount.Account_Status__c;

            if (isFutureAction) {
                actionPerformed = 'Edit Pause';
                isKeepInTouchPageAvailable = checkMarketingPreferences(user.Country, usersAccount.All_Email_Preferences__c, usersAccount.Is_Double_OptIn__c);
                if (isKeepInTouchPageAvailable) {
                    resultPage = new PageReference('/keepintouch/amend'); //go on KeepInTouch page
                } else {
                    resultPage = redirectToMyAccount(dResumeDate.format(), dSuspendDate.format(), 'amendedPause');
                }
            } else {
                actionPerformed = 'Edit resume dates in pause';
                resultPage = redirectToMyAccount('', '', '');
            }
            updateAccount = true;
            //setSubscriptionNextChargeDate(usersAccount.Id, pauseUntil);
        } else if (strAction.equalsIgnoreCase('cancel')) { //cancel pause
            pauseFrom = null;
            pauseUntil = null;
            pauseScheduledTime = null;
            accountStatus = 'Active Paid';

            if (usersAccount.PauseScheduled__c) {
                actionPerformed = 'Cancel scheduled pause';
                submittedForCancellation = true;
                resultPage = redirectToMyAccount('', '', 'stayActive');
                updateAccount = true;
            } else {
                actionPerformed = 'Cancel subscription in pause';
                resultPage = redirectToMyAccount(dResumeDate.format(), '', 'welcomeBack');
                //added as part of PD-13022
                usersAccount.Submitted_for_cancellation__c = true;
                update usersAccount;
            }
        }

        addNewRecordInPauseHistory(usersAccount.Id, pauseFrom, pauseUntil, workflowStatus, workflowId, actionPerformed, subscriptionCancellationDate);

        if (updateAccount) {
            //commented as part of PD-13022
            //updateUserAccount(usersAccount, pauseFrom, pauseUntil, pauseScheduledTime, accountStatus, billCycleDay, submittedForCancellation);
            updateUserAccount(usersAccount, pauseFrom, pauseUntil, pauseScheduledTime, accountStatus, billCycleDay, true);
        }

        return resultPage;
    }

    /*
    Description: Method to process failure result of pause callout. 
    */
    public static PageReference pauseFlowProcessFailure(String strAction, User user, Account usersAccount, String pauseResultMessage) {
        String description;
        if (strAction.equalsIgnoreCase('initiate')) {
            description = Label.LS_keepinTouch_InitiatePauseFailureMsg + '\n' + pauseResultMessage;
        } else if (strAction.equalsIgnoreCase('amend') && usersAccount.PauseScheduled__c) {
            description = Label.LS_keepinTouch_AmendFuturePauseFailureMsg + '\n' + pauseResultMessage;
        } else if (strAction.equalsIgnoreCase('amend') && !usersAccount.PauseScheduled__c) {
            description = Label.LS_keepinTouch_AmendPauseFailureMsg + '\n' + pauseResultMessage;
        } else if (strAction.equalsIgnoreCase('cancel') && usersAccount.PauseScheduled__c) {
            description = Label.LS_keepinTouch_CancelFuturePauseFailureMsg + '\n' + pauseResultMessage;
        }
        addMsgToAccountActivityHistory(
            user.ContactId,
            user.AccountId,
            Label.LS_keepinTouch_TaskSubject,
            description
        );
        String banner = '';
        banner = (String.isNotBlank(strAction) && strAction.equalsIgnoreCase('cancel') && usersAccount.PauseScheduled__c) ? 'cancelReqFail' : '';
        banner = (String.isNotBlank(strAction) && strAction.equalsIgnoreCase('amend') && !usersAccount.PauseScheduled__c) ? 'amendReqFail' : '';
        return redirectToMyAccount('', '', banner);
    }

    /*
    Description: Method to update pause fields on Account object after callout to zuora was successfully completed. 
    */
    public static void updateUserAccount(Account usersAccount, Date pauseFrom, Date pauseUntil, DateTime pauseScheduledTime, String accountStatus, Decimal billCycleDay, Boolean submittedForCancellation) {
        usersAccount.Pause_From__c = pauseFrom;
        usersAccount.Pause_Until__c = pauseUntil;
        usersAccount.Pause_Scheduled_Time__c = pauseScheduledTime;
        usersAccount.Account_Status__c = accountStatus;
        usersAccount.Previous_BCD__c = billCycleDay;
        usersAccount.Submitted_for_cancellation__c = submittedForCancellation;
        
        update usersAccount;
    }

    /*
    Description: Method to update pause fields on Account object after callout to zuora was successfully completed. 
    */
    public static void addNewRecordInPauseHistory(Id AccountId, Date pauseFrom, Date pauseUntil, String status, String workflowId, String actionPerformed, Date subscriptionCancellationDate) {
        Pause_History__c pauseHistory = new Pause_History__c(
            Account__c = AccountId,
            Pause_From__c = pauseFrom,
            Pause_Until__c = pauseUntil,
            Status__c = status,
            Workflow_Id__c = workflowId,
            Action_Performed__c = actionPerformed,
            Subscription_Cancellation_Date__c = subscriptionCancellationDate
        );

        insert pauseHistory;
    }

    /*
    Description: Method to check user's marketing preferences:
    user is from Japan or Austria or Switzerland and has 'All Email Preferences' unchecked OR the user is from Germany and has Is Double Opt in unchecked. 
    */
    public static Boolean checkMarketingPreferences(String userCountry, Boolean allEmailPreferences, Boolean isDoubleOptIn) {
        return String.isNotBlank(userCountry) &&
           (((userCountry.equalsIgnoreCase('Japan') || userCountry.equalsIgnoreCase('Austria') || userCountry.equalsIgnoreCase('Switzerland')) && !allEmailPreferences) ||
           (userCountry.equalsIgnoreCase('Germany') && !isDoubleOptIn));
    }

    /*
    Description: Method to redirect user to MyAccount page. 
    */
    public static PageReference redirectToMyAccount(String resDate, String suspDate, String banner) {
        PageReference pr = new PageReference('/myaccount');

        if (String.isNotBlank(resDate)) {
            pr.getParameters().put('resumeDate', resDate);
        }
        if (String.isNotBlank(suspDate)) {
            pr.getParameters().put('suspendDate', suspDate);
        }
        if (String.isNotBlank(banner)) {
            pr.getParameters().put('banner', banner);
        }

        return pr;
    }

    /*
    Description: Method to add error record on the Activity history of the account. 
    */
    public static void addMsgToAccountActivityHistory(Id contactId, Id accountId, String subject, String description) {
        Task accountHistoryErrorMessage = CommunityHelper.createTask(
            contactId,
            accountId,
            subject,
            description
        );
        if (accountHistoryErrorMessage != null) {
            insert accountHistoryErrorMessage;
        }
    }
    
    /*
    Description: Method to initiate Standard Cancellation.
    */
    public static Map<String, String> runStandardCancelZuoraWorkflow(String subscriptionName, String cancelDate) {
        Map<String, String> result;
        try {
            String endpointUrl = (DAZNConfiguration__c.getValues('ZuoraStandardCancelUrl') != null) ? DAZNConfiguration__c.getValues('ZuoraStandardCancelUrl').Value__c : null;
            String username = (DAZNConfiguration__c.getValues('ZuoraPauseUsername') != null) ? DAZNConfiguration__c.getValues('ZuoraPauseUsername').Value__c : null;
            String password = (DAZNConfiguration__c.getValues('ZuoraPausePassword') != null) ? DAZNConfiguration__c.getValues('ZuoraPausePassword').Value__c : null;

            Boolean isEmptyCalloutParameters = String.isBlank(endpointUrl) || String.isBlank(username) || String.isBlank(password);
            if (isEmptyCalloutParameters) {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Custom settings are missed: StandardCancellUrl/Username/Password'};
                return result;
            }
    
            Blob authorizationBlob = Blob.valueOf(username + ':' + password);
            String authorization = EncodingUtil.base64Encode(authorizationBlob);

            HttpResponse response = PauseCalloutHelper.performZuoraCallout(
                endpointUrl,
                'POST',
                'application/json',
                'Basic ' + authorization,
                JSON.serialize(new PauseCalloutHelper.SetStandardCancelBody(subscriptionName, cancelDate))
            ); //calout to zuora

            Integer responseStatusCode = response.getStatusCode();
            String responseBody = response.getbody();
            if (responseStatusCode == 200) {
                PauseCalloutHelper.SetPauseSuccessResponse setPauseSuccessResponse = (PauseCalloutHelper.SetPauseSuccessResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseSuccessResponse.class);
                result = new Map<String, String>{ 'success' => 'true', 'message' => setPauseSuccessResponse.id };
            } else if (responseStatusCode == 406) {
                PauseCalloutHelper.SetPauseFailureResponse setPauseFailureResponse = (PauseCalloutHelper.SetPauseFailureResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseFailureResponse.class);
                String errorMsg = '';
                System.debug('XXX');
                for (PauseCalloutHelper.SetPauseFailureResponseError error : setPauseFailureResponse.errors) {
                    System.debug(error.title);
                    errorMsg += error.title + '\n';
                }
                System.debug(errorMsg);
                errorMsg = errorMsg.substring(0, errorMsg.length() - 2);
                result = new Map<String, String>{ 'success' => 'false', 'message' => errorMsg };
            } else {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Unknown error' };
            }
        } catch(Exception e) {
            result = new Map<String, String>{ 'success' => 'false', 'message' => e.getMessage() };
        }

        return result;
    }
    
    /*
    Description: Method to initiate Immediate Cancellation.
    */
    public static Map<String, String> runImmediateCancelZuoraWorkflow(String subscriptionName, String cancelDate, String paymentID) {
        Map<String, String> result;
        try {
            String endpointUrl = (DAZNConfiguration__c.getValues('ZuoraImmediateCancelUrl') != null) ? DAZNConfiguration__c.getValues('ZuoraImmediateCancelUrl').Value__c : null;
            String username = (DAZNConfiguration__c.getValues('ZuoraPauseUsername') != null) ? DAZNConfiguration__c.getValues('ZuoraPauseUsername').Value__c : null;
            String password = (DAZNConfiguration__c.getValues('ZuoraPausePassword') != null) ? DAZNConfiguration__c.getValues('ZuoraPausePassword').Value__c : null;

            Boolean isEmptyCalloutParameters = String.isBlank(endpointUrl) || String.isBlank(username) || String.isBlank(password);
            if (isEmptyCalloutParameters) {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Custom settings are missed: ImmediateCancellUrl/Username/Password'};
                return result;
            }
    
            Blob authorizationBlob = Blob.valueOf(username + ':' + password);
            String authorization = EncodingUtil.base64Encode(authorizationBlob);

            HttpResponse response = PauseCalloutHelper.performZuoraCallout(
                endpointUrl,
                'POST',
                'application/json',
                'Basic ' + authorization,
                JSON.serialize(new PauseCalloutHelper.SetImmediateCancelBody(subscriptionName, cancelDate, paymentID))
            ); //calout to zuora

            Integer responseStatusCode = response.getStatusCode();
            String responseBody = response.getbody();
            if (responseStatusCode == 200) {
                PauseCalloutHelper.SetPauseSuccessResponse setPauseSuccessResponse = (PauseCalloutHelper.SetPauseSuccessResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseSuccessResponse.class);
                result = new Map<String, String>{ 'success' => 'true', 'message' => setPauseSuccessResponse.id };
            } else if (responseStatusCode == 406) {
                PauseCalloutHelper.SetPauseFailureResponse setPauseFailureResponse = (PauseCalloutHelper.SetPauseFailureResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseFailureResponse.class);
                String errorMsg = '';
                for (PauseCalloutHelper.SetPauseFailureResponseError error : setPauseFailureResponse.errors) {
                    errorMsg += error.title + '\n';
                }
                errorMsg = errorMsg.substring(0, errorMsg.length() - 2);
                result = new Map<String, String> { 'success' => 'false', 'message' => errorMsg };
            } else {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Unknown error' };
            }
        } catch(Exception e) {
            result = new Map<String, String>{ 'success' => 'false', 'message' => e.getMessage() };
        }

        return result;
    }
    
    /*
    Description: Method to reactivate subscrition.
    */
    public static Map<String, String> runUndoCancellationZuoraWorkflow(String subscriptionName) {
        Map<String, String> result;
        try {
            String endpointUrl = (DAZNConfiguration__c.getValues('ZuoraReactivationUrl') != null) ? DAZNConfiguration__c.getValues('ZuoraReactivationUrl').Value__c : null;
            String username = (DAZNConfiguration__c.getValues('ZuoraPauseUsername') != null) ? DAZNConfiguration__c.getValues('ZuoraPauseUsername').Value__c : null;
            String password = (DAZNConfiguration__c.getValues('ZuoraPausePassword') != null) ? DAZNConfiguration__c.getValues('ZuoraPausePassword').Value__c : null;

            Boolean isEmptyCalloutParameters = String.isBlank(endpointUrl) || String.isBlank(username) || String.isBlank(password);
            if (isEmptyCalloutParameters) {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Custom settings are missed: ZuoraReactivationUrl/Username/Password'};
                return result;
            }
    
            Blob authorizationBlob = Blob.valueOf(username + ':' + password);
            String authorization = EncodingUtil.base64Encode(authorizationBlob);

            HttpResponse response = PauseCalloutHelper.performZuoraCallout(
                endpointUrl,
                'POST',
                'application/json',
                'Basic ' + authorization,
                JSON.serialize(new PauseCalloutHelper.SetUndoCancellationBody(subscriptionName))
            ); //calout to zuora

            Integer responseStatusCode = response.getStatusCode();
            String responseBody = response.getbody();
            if (responseStatusCode == 200) {
                PauseCalloutHelper.SetPauseSuccessResponse setPauseSuccessResponse = (PauseCalloutHelper.SetPauseSuccessResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseSuccessResponse.class);
                result = new Map<String, String>{ 'success' => 'true', 'message' => setPauseSuccessResponse.id };
            } else if (responseStatusCode == 406) {
                PauseCalloutHelper.SetPauseFailureResponse setPauseFailureResponse = (PauseCalloutHelper.SetPauseFailureResponse)JSON.deserialize(responseBody, PauseCalloutHelper.SetPauseFailureResponse.class);
                String errorMsg = '';
                for (PauseCalloutHelper.SetPauseFailureResponseError error : setPauseFailureResponse.errors) {
                    errorMsg += error.title + '\n';
                }
                errorMsg = errorMsg.substring(0, errorMsg.length() - 2);
                result = new Map<String, String>{ 'success' => 'false', 'message' => errorMsg };
            } else {
                result = new Map<String, String>{ 'success' => 'false', 'message' => 'Unknown error' };
            }
        } catch(Exception e) {
            result = new Map<String, String>{ 'success' => 'false', 'message' => e.getMessage() };
        }

        return result;
    }
}