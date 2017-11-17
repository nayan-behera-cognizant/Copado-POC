@RestResource(urlMapping='/CancelEmail/*')
global class CancelEmail {

    @HttpPost
    global static String cancelSubscriptionPost() {
        String requestString;
        String statusMessage; // can be "Success" or "Failure" status

        String accountCrmId; // salesforce Id of Account
        String accountId; // salesforce Id of the Zuora__CustomerAccount__c
        Date subscriptionTermEndDate; // the end date after which subscription is cancelled
        Integer accountBillCycleDay; // what day of the month this account gets billed
        String defaultPaymentMethodType;
        String subscriptionName;

        CancellactionJSON inputJSON;

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try {
            requestString = req.requestBody.toString();
            System.debug('### request String ###' + requestString);

            inputJSON = parse(requestString);

            accountCrmId = inputJSON.AccountCrmId;
            accountId = inputJSON.AccountId;
            subscriptionTermEndDate = String.isNotBlank(inputJSON.SubscriptionTermEndDate) ? Date.valueOf(inputJSON.SubscriptionTermEndDate) : null;
            accountBillCycleDay = String.isNotBlank(inputJSON.AccountBillCycleDay) ? Integer.valueOf(inputJSON.AccountBillCycleDay) : null;
            defaultPaymentMethodType = inputJSON.DefaultPaymentMethodType;
            subscriptionName = inputJSON.SubscriptionName;

            if (String.isBlank(accountCrmId) || String.isBlank(accountId) || subscriptionTermEndDate == null || accountBillCycleDay == null) {
                res.statusCode = 400;
                return 'Failure';
            }

            List<Zuora__CustomerAccount__c> billingAccount = [
                SELECT Id, Zuora__Account__c
                FROM Zuora__CustomerAccount__c
                WHERE Zuora__External_Id__c = :accountId
                LIMIT 1
            ];
            if (!billingAccount.isEmpty()) {
                sendSubscriptionCancelationEmails(billingAccount[0].Id, billingAccount[0].Zuora__Account__c, subscriptionTermEndDate, accountBillCycleDay, defaultPaymentMethodType, subscriptionName);
                statusMessage = 'Success';
                res.statusCode = 200;
            }
            else {
                statusMessage = 'Failure';
                res.statusCode = 400;
            }
        } catch (Exception e) {
            statusMessage = 'Failure';
            res.statusCode = 500;
        }

        return statusMessage;
    }

    /* 
    Description: Send Cancellation Email to users using communicator.
    */
    public static void sendSubscriptionCancelationEmails(Id billingCanAccountId, Id accountCrmId, Date subscriptionTermEndDate, Integer accountBillCycleDay, String defaultPaymentMethodType, String subscriptionName) {
        if (billingCanAccountId != null && accountCrmId != null) {
            Map<Id, Zuora__CustomerAccount__c> mapCanBillingAccount = new Map<Id, Zuora__CustomerAccount__c>([SELECT id, Zuora__Account__r.Account_Status__c,
                                                                                                              Zuora__Account__c,
                                                                                                              Zuora__Account__r.Notification_Language_Code__c,
                                                                                                              Zuora__Account__r.PersonEmail, 
                                                                                                              Zuora__Account__r.FirstName,
                                                                                                              Zuora__Account__r.LastName,
                                                                                                              Zuora__Account__r.PersonContactId,
                                                                                                              Zuora__Currency__c, Zuora__PaymentMethod_Type__c,
                                                                                                              Zuora__Account__r.Notification_Country_Code__c,
                                                                                                              Zuora__Account__r.Disable_immediate_cancel_email__c,
                                                                                                              Zuora__Account__r.Disable_transactional_emails__c,
                                                                                                              Zuora__Account__r.All_Email_Preferences__c,
                                                                                                              Zuora__Account__r.Hard_Offer_Date__c,
                                                                                                              Zuora__Account__r.Is_Double_OptIn__c,
                                                                                                              Zuora__Account__r.Previous_Status__c
                                                                                                              FROM Zuora__CustomerAccount__c
                                                                                                              WHERE Id = :billingCanAccountId
                                                                                                              LIMIT 1]);

            String cancellationType;
            // If SubscriptionTermEndDate is in the past/present then send an immediate cancel email else send a standard cancel email.
            // if SubscriptionTermEndDate = Today and Today Day = AccountBillCycleDay then send a standard cancel email.
            if (subscriptionTermEndDate <= System.Date.today()) {
                if (subscriptionTermEndDate == System.Date.today() && System.Date.today().day() == accountBillCycleDay) {
                    cancellationType = 'Standard';
                }
                else {
                    cancellationType = 'Immediate';
                }
            }
            else {
                cancellationType = 'Standard';
            }
            
            Date hardOfferDate;
            if (mapCanBillingAccount.get(billingCanAccountId).Zuora__Account__r.Hard_Offer_Date__c != null) {
                DateTime hardOfferDateTmp = mapCanBillingAccount.get(billingCanAccountId).Zuora__Account__r.Hard_Offer_Date__c;
                hardOfferDate = Date.newInstance(hardOfferDateTmp.year(), hardOfferDateTmp.month(), hardOfferDateTmp.day());
            }
            
            Map<Integer, String> dispatchIdNameValueMap = new Map<Integer, String> {
                Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_User_Cancel').Value__c) => 'Subscription Cancel',
                Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Payment_Failed_User_Frozen').Value__c) => 'Payment Failed - User Frozen Cancel',
                Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Immediate_Cancellation').Value__c) => 'Immediate cancellation email',
                Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Paused_Cancellation').Value__c) => 'Pause & Subscription has been cancelled'
            };

            Integer dispatchID = getDispachId(subscriptionTermEndDate, mapCanBillingAccount.get(billingCanAccountId));
            String emailName = dispatchIdNameValueMap.get(dispatchID);
            Decimal subscriptionAmount = getSubscriptionAmount(subscriptionName, accountCrmId);

            Email_Sync_Queue__c triggeredDispatchEmailQueue = newEmailSyncQueue(
                mapCanBillingAccount.get(billingCanAccountId),
                dispatchID,
                subscriptionAmount,
                defaultPaymentMethodType,
                hardOfferDate,
                subscriptionTermEndDate,
                emailName
            );
            
            if (cancellationType == 'Standard') {
                /* Email Sync Queue record for Standard cancellation emails. */
                triggeredDispatchEmailQueue.Account_Status__c = mapCanBillingAccount.get(billingCanAccountId).Zuora__Account__r.Account_Status__c;
            }
            else if (cancellationType == 'Immediate') {
                /* Email Sync Queue record for Immediate cancellation emails. */
                triggeredDispatchEmailQueue.Account_Status__c = 'Frozen';
            }

            Boolean isDisableSend = (
                mapCanBillingAccount.get(billingCanAccountId).Zuora__Account__r.Disable_immediate_cancel_email__c || // for PD-8928
                mapCanBillingAccount.get(billingCanAccountId).Zuora__Account__r.Disable_transactional_emails__c // for PD-11577
            );
            if (!isDisableSend) {
                insert triggeredDispatchEmailQueue;
            }
        }
    }

    public class CancellactionJSON {
        public String AccountCrmId;
        public String AccountId;
        public String SubscriptionTermEndDate;
        public String DefaultPaymentMethodType;
        public String AccountBillCycleDay;
        public String SubscriptionName;
    }

    public static CancellactionJSON parse(String json) {
        return (CancellactionJSON) System.JSON.deserialize(json, CancellactionJSON.class);
    }

    //////////////////////
    private static String ACTIVE_GRACE = 'Active Grace';
    private static String FREE_TRIAL = 'Free Trial';
    private static String ACTIVE_PAID = 'Active Paid';
    private static String PAUSED = 'Paused';
    private static String FROZEN = 'Frozen';

    private static Integer getDispachId(Date subscriptionTermEndDate, Zuora__CustomerAccount__c account) {
        Integer dispatchID;
        String currentStatus = account.Zuora__Account__r.Account_Status__c;
        String previousStatus = account.Zuora__Account__r.Previous_Status__c;
        if (subscriptionTermEndDate > Date.today()) {
            dispatchID = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_User_Cancel').Value__c);
        } else {
            if (isCancelationType(currentStatus, previousStatus, ACTIVE_GRACE)) {
                dispatchID = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Payment_Failed_User_Frozen').Value__c);
            } else if (isCancelationType(currentStatus, previousStatus, FREE_TRIAL)) {
                dispatchID = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Immediate_Cancellation').Value__c);
            } else if (isCancelationType(currentStatus, previousStatus, ACTIVE_PAID)) {
                dispatchID = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Immediate_Cancellation').Value__c);
            } else if (isCancelationType(currentStatus, previousStatus, PAUSED)) {
                dispatchID = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Paused_Cancellation').Value__c);
            } else {
                dispatchID = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_User_Cancel').Value__c);
            }
        }
        return dispatchID;
    }

    private static Boolean isCancelationType(String newStatus, String oldStatus, String statusType) {
        return (newStatus == statusType || (oldStatus == statusType && newStatus == FROZEN)) ? true : false;
    }

    private static Email_Sync_Queue__c newEmailSyncQueue(Zuora__CustomerAccount__c account,
                                                         Integer dispatchID,
                                                         Decimal subscriptionAmount,
                                                         String defaultPaymentMethodType,
                                                         Date hardOfferDate,
                                                         Date subscriptionTermEndDate,
                                                         String emailName) {
        return new Email_Sync_Queue__c(
            Account__c = account.Zuora__Account__c,
            Account_Currency__c = account.Zuora__Currency__c,
            All_Email_Preferences__c = account.Zuora__Account__r.All_Email_Preferences__c,
            Dispatch_ID__c = dispatchID,
            First_Name__c = account.Zuora__Account__r.FirstName,
            Last_Name__c = account.Zuora__Account__r.LastName,
            Free_Trial_End_Date__c = null,
            Hard_Offer_Date__c = hardOfferDate,
            Is_Double_Opt_in__c = account.Zuora__Account__r.Is_Double_OptIn__c,
            Notification_Country_Code__c = account.Zuora__Account__r.Notification_Country_Code__c,
            Notification_Language_Code__c = account.Zuora__Account__r.Notification_Language_Code__c,
            Payment_Method_Type__c = defaultPaymentMethodType,
            Person_Email__c = account.Zuora__Account__r.PersonEmail,
            Status__c = 'Not Started',
            Subscription_End_Date__c = subscriptionTermEndDate,
            Sync_Error_Msg__c = null,
            Type_of_Email__c = 'Triggered Dispatch',
            Unsubscribe_Language__c = account.Zuora__Account__r.Notification_Language_Code__c,
            Email_Name__c = emailName,
            Subscription_Amount__c = subscriptionAmount
        );
    }

    private static Decimal getSubscriptionAmount(String subscriptionName, Id accountCrmId) {

        System.debug('LOG : method -> getSubscriptionAmount(subscriptionName = '+ subscriptionName + ', accountCrmId = '+ accountCrmId +' )');
        //Added as part of PD-14237
        if(String.isNotBlank(subscriptionName) && accountCrmId != null){

            List<Zuora__Subscription__c> subscriptions = [
                SELECT SubscriptionAmount__c
                FROM Zuora__Subscription__c 
                WHERE Name = : subscriptionName
                AND Zuora__Account__c = : accountCrmId
            ];

            System.debug('LOG : method -> getSubscriptionAmount() -> subscriptions = ' + subscriptions);

            if(!subscriptions.isEmpty()){
                return subscriptions.get(0).SubscriptionAmount__c;
            }else{
                return 0;
            }
        }
        return 0;

        //Commented as part of PD-14237
        
        /*Decimal subscriptionAmount;
        if (subscriptionName != NULL) {
            
            List<Zuora__Subscription__c> subscr = [
                SELECT Zuora__MRR__c, Zuora__TCV__c, Zuora__TermSettingType__c
                FROM Zuora__Subscription__c 
                WHERE Name = : subscriptionName
                    AND Zuora__Account__c = : accountCrmId
            ];

            if (subscr.size() > 0) {
                if (subscr[0].Zuora__TermSettingType__c == 'TERMED') {
                    subscriptionAmount = subscr[0].Zuora__TCV__c;
                } else {
                    subscriptionAmount = subscr[0].Zuora__MRR__c;
                }
            }
        }
        return subscriptionAmount;*/
    }
}