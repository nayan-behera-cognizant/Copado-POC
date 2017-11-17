/**
 * @Author Cognizant Technology Solutuions
 * @Date 09-Oct-2017
 * @Description : This class is used to process callouts from Zuora after user applied a new gift code
*/
@RestResource(urlMapping='/GiftCodeProvider/*')
global without sharing class GiftCodeProvider {

    /**
     * @Author Cognizant Technology Solutuions
     * @Date 09-Oct-2017
     * @Description : This method is used to process a POST requests from Zuora when a new gift code is applied
    */
    @HttpPost
    global static String createGiftCodeHistory() {
        RestRequest req = RestContext.request;
        String requestBodyJSONString = req.requestBody.toString();

        GiftCodeProvider.CallbackJSONBody callbackJSONBody = (GiftCodeProvider.CallbackJSONBody)JSON.deserialize(req.requestBody.toString(), GiftCodeProvider.CallbackJSONBody.class);
        
        List<Zuora__Subscription__c> subscription = [
            SELECT Id, Zuora__NextChargeDate__c, SubscriptionAmount__c, Zuora__Account__c, Zuora__TermSettingType__c,
                Zuora__CustomerAccount__r.Zuora__Currency__c, Zuora__Account__r.Account_Status__c, Zuora__Account__r.All_Email_Preferences__c,
                Zuora__Account__r.FirstName, Zuora__Account__r.LastName, Zuora__Account__r.Is_Double_OptIn__c, Free_Trial_End_Date__c,
                Zuora__Account__r.Notification_Country_Code__c, Zuora__Account__r.Notification_Language_Code__c,
                Zuora__Account__r.PersonEmail, Zuora__Account__r.Disable_transactional_emails__c
            FROM Zuora__Subscription__c
            WHERE Name = :callbackJSONBody.Workflow.SubscriptionName
        ];
        if (subscription == null || subscription.isEmpty()) {
            RestContext.response.statusCode = 400;
            return 'Error';
        }

        Gift_Code_History__c gch = new Gift_Code_History__c(
            Name = callbackJSONBody.Workflow.GiftCode,
            Account__c = subscription[0].Zuora__Account__c,
            Applied_On__c = callbackJSONBody.Workflow.ExecutionDate,
            Campaign_Id__c = callbackJSONBody.Workflow.CampaignName,
            Gift_Code_Start_Date__c = callbackJSONBody.Workflow.VoucherCodeEffectiveDate,
            Gift_Code_End_Date__c = callbackJSONBody.Workflow.VoucherCodeEffectiveDate.addMonths(callbackJSONBody.Workflow.UpToPeriods),
            Number_Of_Periods__c = callbackJSONBody.Workflow.UpToPeriods
        );
        insert gch;
        
        if (!subscription[0].Zuora__Account__r.Disable_transactional_emails__c) {
            Email_Sync_Queue__c triggeredDispatchEmailQueue = new Email_Sync_Queue__c(
                Account__c = subscription[0].Zuora__Account__c,
                Account_Status__c = subscription[0].Zuora__Account__r.Account_Status__c,
                All_Email_Preferences__c = subscription[0].Zuora__Account__r.All_Email_Preferences__c,
                First_Name__c = subscription[0].Zuora__Account__r.FirstName,
                Last_Name__c = subscription[0].Zuora__Account__r.LastName,
                Is_Double_Opt_in__c = subscription[0].Zuora__Account__r.Is_Double_OptIn__c,
                Notification_Country_Code__c =  subscription[0].Zuora__Account__r.Notification_Country_Code__c,
                Notification_Language_Code__c =  subscription[0].Zuora__Account__r.Notification_Language_Code__c,
                Person_Email__c =  subscription[0].Zuora__Account__r.PersonEmail,
                Plan_Details__c = subscription[0].Zuora__Account__r.Account_Status__c,
                Status__c = 'Not Started',
                Type_of_Email__c = 'Triggered Dispatch',
                Unsubscribe_Language__c = subscription[0].Zuora__Account__r.Notification_Language_Code__c,
                Email_Name__c = 'Gift Code Success',
                Dispatch_ID__c = (!Test.isRunningTest()) ? Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Gift_Code_Success').Value__c) : 12340,
                Free_Trial_End_Date__c = subscription[0].Free_Trial_End_Date__c,
                Rebill_Date__c = subscription[0].Zuora__NextChargeDate__c,
                Account_Currency__c = subscription[0].Zuora__CustomerAccount__r.Zuora__Currency__c,
                Subscription_Amount__c = subscription[0].SubscriptionAmount__c,
                Term_Setting_Type__c = (subscription[0].Zuora__TermSettingType__c == 'TERMED') ? 'TERMED' : 'EVERGREEN',
                Gift_Code_Expiry_Date__c = gch.Gift_Code_End_Date__c
            );
            insert triggeredDispatchEmailQueue;
        }

        APILogger.CreateAPILogs(
            subscription[0].Zuora__Account__c,
            '/GiftCodeProvider',
            'Inbound',
            callbackJSONBody.Workflow.ProcessId,
            requestBodyJSONString,
            null,
            null,
            null
        );

        return 'Success';
    }



    private class CallbackJSONBody {
        private CallbackJSONBodyWorkflow Workflow;
    }

    private class CallbackJSONBodyWorkflow {
        private Date ExecutionDate;
        private String GiftCode;
        private String CampaignName;
        private String ProcessId;
        private Integer UpToPeriods;
        private String SubscriptionName;
        private String ProductRatePlanChargeId;
        private String CallbackUrl;
        private String RegionOrigin;
        private String ProductRatePlanId;
        private Date VoucherCodeEffectiveDate;
    }

}