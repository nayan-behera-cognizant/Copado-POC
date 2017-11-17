/** 
* @author Zuora and Cognizant Technology Solutuions
* @date 21/10/2015
* @description Class to update Account status on payment failure.
*/
global without sharing class UpdateAccount {

    /*
        Description: Process successful payment.
    */
    public void processSuccessfulPayment(String accountId){
        //Note: Code changed to mark Account Status = "Active Paid" if payment successfully processed in first attempt.
        if (isProcessSuccessPaymentNeeded(accountId)) {
            createPaymentSuccessfulEmailQueueRecords(accountId); // creates 'Successful Payment Retry' Email Sync Queue record only if Account_Status__c = 'Active Grace'/'Paused' and Disable_transactional_emails__c = false
            setSuccessfulPayment(accountId, true);
            setFirstTrial(accountID, false);
        }
    }
    
    /*
        Description: creates Email Sync Queue records with 'DispatchID_Payment_Successful' dispatch Id.
    */
    public void createPaymentSuccessfulEmailQueueRecords(String accountId) {
        List<Zuora__CustomerAccount__c> anAccount = [
            SELECT Id, Name, Zuora__Currency__c, Zuora__PaymentMethod_Type__c, Zuora__Account__c, Zuora__Account__r.Type,
                Zuora__Account__r.Notification_Country_Code__c, Zuora__Account__r.Notification_Language_Code__c, Zuora__Account__r.PersonEmail,
                Zuora__Account__r.All_Email_Preferences__c,	Zuora__Account__r.FirstName, Zuora__Account__r.LastName, Zuora__Account__r.Hard_Offer_Date__c,
                Zuora__Account__r.Is_Double_OptIn__c
            FROM Zuora__CustomerAccount__c
            WHERE Zuora__Zuora_Id__c = :accountId.trim()
                AND Zuora__Account__r.Disable_transactional_emails__c = false
                AND (Zuora__Account__r.Account_Status__c = 'Active Grace' OR Zuora__Account__r.Account_Status__c = 'Paused') LIMIT 1 // check according to PD-13456
        ];
        if (!anAccount.isEmpty()) {
            Date hardOfferDate;
            if (anAccount[0].Zuora__Account__r.Hard_Offer_Date__c != null) {
                DateTime hardOfferDateTmp = anAccount[0].Zuora__Account__r.Hard_Offer_Date__c;
                hardOfferDate = Date.newInstance(hardOfferDateTmp.year(), hardOfferDateTmp.month(), hardOfferDateTmp.day());
            }
            Email_Sync_Queue__c triggeredDispatchEmailQueue = new Email_Sync_Queue__c(
                Account__c = anAccount[0].Zuora__Account__c,
                Account_Currency__c = anAccount[0].Zuora__Currency__c,
                Account_Status__c = 'Active Paid',
                All_Email_Preferences__c = anAccount[0].Zuora__Account__r.All_Email_Preferences__c,
                Dispatch_ID__c = (!Test.isRunningTest()) ? Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Payment_Successful').Value__c) : 12345,
                First_Name__c = anAccount[0].Zuora__Account__r.FirstName,
                Last_Name__c = anAccount[0].Zuora__Account__r.LastName,
                Free_Trial_End_Date__c = null,
                Hard_Offer_Date__c = hardOfferDate,
                Is_Double_Opt_in__c = anAccount[0].Zuora__Account__r.Is_Double_OptIn__c,
                Notification_Country_Code__c = anAccount[0].Zuora__Account__r.Notification_Country_Code__c,
                Notification_Language_Code__c = anAccount[0].Zuora__Account__r.Notification_Language_Code__c,
                Payment_Method_Type__c = anAccount[0].Zuora__PaymentMethod_Type__c,
                Person_Email__c = anAccount[0].Zuora__Account__r.PersonEmail,
                Plan_Details__c = 'Active Paid',
                Status__c = 'Not Started',
                Type_of_Email__c = 'Triggered Dispatch',
                Unsubscribe_Language__c = anAccount[0].Zuora__Account__r.Notification_Language_Code__c,
                Email_Name__c = 'Successful Payment Retry'
            );
            insert triggeredDispatchEmailQueue;
        }
    }

    /*
        Description: Process first payment failure.
    */
    public void processFirstTrial(String accountId){
        setFirstTrial(accountID.trim(), true);
        setSuccessfulPayment(accountId.trim(), false);
    }

    /*
        Description: Get first payment failure status.
    */
    public Boolean getFirstTrial(String accountId){
        List<Zuora__CustomerAccount__c> selectedAccount = [select name, id,First_Payment_Trial__c from Zuora__CustomerAccount__c where Zuora__Zuora_Id__c =:accountId LIMIT 1];        
        for(Zuora__CustomerAccount__c acc :selectedAccount){
            return acc.First_Payment_Trial__c;
        }
        return false;
    }

    /*
        Description: Get final payment failure status.
    */
    public Boolean isProcessSuccessPaymentNeeded(String accountId) {
        List<Zuora__CustomerAccount__c> selectedAccount = [
            SELECT Id, Name, Zuora__Account__c, Zuora__Account__r.Account_Status__c
            FROM Zuora__CustomerAccount__c
            WHERE Zuora__Zuora_Id__c =:accountId LIMIT 1
        ];
        if (!selectedAccount.isEmpty()) {
            return (selectedAccount[0].Zuora__Account__r.Account_Status__c == 'Paused' ||
                selectedAccount[0].Zuora__Account__r.Account_Status__c == 'Active Grace' || // condition for PD-12615
                selectedAccount[0].Zuora__Account__r.Account_Status__c == 'Free Trial' // condition for PD-13456
            ) ;
        }
        return false;
    }

    /*
        Description: Mark first payment trial in salesforce.
    */
    public void setFirstTrial(String accountId, Boolean state){
        List<Zuora__CustomerAccount__c> selectedAccount = [select name, id,First_Payment_Trial__c, Zuora__Account__r.Id from Zuora__CustomerAccount__c where Zuora__Zuora_Id__c =:accountId LIMIT 1];
        for(Zuora__CustomerAccount__c acc :selectedAccount){  
            acc.First_Payment_Trial__c=state;                                       
        } 
        update(selectedAccount);
        if(state == true && selectedAccount!= NULL && !selectedAccount.isEmpty()){
            shouldIRun.allow = true; //allow account trigger to execute
            updateAccountStatus(selectedAccount[0].Zuora__Account__r.Id, 'Active Grace');
        }
    }

    /*
        Description: Perform an Immediate Cancellation via Zuora Workflows.
    */
    public String performImmediateCancellation(String accountId) {
        String statusMessage;
        List<Zuora__CustomerAccount__c> selectedAccount = [
            SELECT Id, Name, Zuora__Account__c, Zuora__Account__r.Id
            FROM Zuora__CustomerAccount__c
            WHERE Zuora__Zuora_Id__c =:accountId.trim() LIMIT 1
        ];
        if (!selectedAccount.isEmpty()) {
            // Get account and subscription information for zuora account.
            Zuora__Subscription__c oSubscription;
            List<Account> lstAccount = [
                SELECT ID, Account_Status__c,
                    (SELECT Id, Name
                        FROM Zuora__Subscriptions__r 
                        WHERE Zuora__Status__c = 'Active'
                        ORDER By CreatedDate DESC NULLS LAST)
                FROM Account 
                WHERE Id =:selectedAccount[0].Zuora__Account__c
            ];
            if (lstAccount != NULL && !lstAccount.isEmpty()) {
                List<Zuora__Subscription__c> lstSubscription = lstAccount[0].Zuora__Subscriptions__r;
                if (lstSubscription!= NULL && !lstSubscription.isEmpty()) {
                    oSubscription = lstSubscription[0];
                    
                    String paymentId = '';
                    String cancelDate = CommunityHelper.ConvertDateToString(Date.today(), 'ZouraFormat', 'NA');
                    List<Zuora__Payment__c> paymentRecObj = new List<Zuora__Payment__c>();
                    paymentRecObj = [
                        SELECT Id, Name, Zuora__EXT_ID__c, Zuora__SettledOn__c, Zuora__CreatedDate__c, Zuora__Account__c
                        FROM Zuora__Payment__c
                        WHERE Zuora__Account__c = :lstAccount[0].Id ORDER BY Zuora__CreatedDate__c DESC
                    ];
                    if (paymentRecObj.size() > 0) {
                        if (paymentRecObj[0].Zuora__SettledOn__c != null) {
                            paymentId = paymentRecObj[0].Zuora__EXT_ID__c;
                        } else {
                            statusMessage = System.Label.LS_CancelSubscription_Page_Message_No_Settled_On;
                            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'UpdateAccount', 'setFinalTrial', '', '', System.Label.LS_CancelSubscription_Page_Message_No_Settled_On);
                            return statusMessage;
                        }
                    }
                    // Invocation of Zuora Workflows to do Immediate Cancellation
                    Map<String, String> outputResult = PauseCalloutHelper.runImmediateCancelZuoraWorkflow(oSubscription.Name, cancelDate, paymentId);
                    Boolean isResultSuccess = Boolean.valueOf(outputResult.get('success'));
                    if (isResultSuccess) {
                        shouldIRun.allow = true; //allow account trigger to execute
                        updateAccountStatus(selectedAccount[0].Zuora__Account__r.Id, 'Frozen');
                        statusMessage = 'Success';
                    } else {
                        statusMessage = outputResult.get('message');
                        ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'UpdateAccount', 'setFinalTrial', '', '', outputResult.get('message'));
                    }
                } else {
                    statusMessage = 'There are no active subscriptions for this Account';
                    ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'UpdateAccount', 'setFinalTrial', '', '', 'There are no active subscriptions for this Account');
                }
            }
        } else {
            statusMessage = 'Billing Account with such ID is not found';
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'UpdateAccount', 'setFinalTrial', '', '', 'Billing Account with such ID is not found');
        }

        return statusMessage;
    }
    
    /*
        Description: Mark payment successful in salesforce.
    */
    public void setSuccessfulPayment(String accountId,Boolean state){
        List<Zuora__CustomerAccount__c> selectedAccount = [select name, id,Payment_Success__c, Zuora__Account__r.Id, Zuora__Account__r.Account_Status__c from Zuora__CustomerAccount__c where Zuora__Zuora_Id__c =:accountId LIMIT 1];
        for(Zuora__CustomerAccount__c acc :selectedAccount){
            acc.Payment_Success__c=state;                  
        } 
        update(selectedAccount);
        if (state == true && selectedAccount!= NULL && !selectedAccount.isEmpty()) {
            shouldIRun.allow = true; //allow account trigger to execute
            updateAccountStatus(selectedAccount[0].Zuora__Account__r.Id, 'Active Paid');
        }
        if (state != null && state == false) {
            updateAccountStatus(selectedAccount[0].Zuora__Account__r.Id, 'Active Grace');
        }
    }

    /*
        Description: Get Zuora Account id from request xml.
    */
    public String getAccountId(String zuoraCalloutString){
        DOM.Document zuoraCalloutAsDOM = new DOM.Document();
        try {
            zuoraCalloutAsDOM.load(zuoraCalloutString);   
            DOM.XMLNode root = zuoraCalloutAsDOM.getRootElement();        
            if (root.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            if('callout'.equals(root.getName())){
            for (Integer i = 0; i< root.getChildElements().size(); i++ ) {
            //loop through all "parameters" sent
            DOM.XMLNode thisChild = root.getChildElements().get(i);
            if ('AccountID'.equals(thisChild.getAttribute('name', null))) {
            return thisChild.getText();
            }}}}
        } catch (System.XMLException e) {  // invalid XML
            System.debug(e.getMessage());
        }
        return null;
    }

    /*Start part of PD-11138*/
    public String getSubscriptionId(String zuoraCalloutString) {
        DOM.Document zuoraCalloutAsDOM = new DOM.Document();
        try {
            zuoraCalloutAsDOM.load(zuoraCalloutString);   
            DOM.XMLNode root = zuoraCalloutAsDOM.getRootElement();        
            if (root.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            if('callout'.equals(root.getName())){
            for (Integer i = 0; i< root.getChildElements().size(); i++ ) {
            //loop through all "parameters" sent
            DOM.XMLNode thisChild = root.getChildElements().get(i);
            if ('SubscriptionID'.equals(thisChild.getAttribute('name', null))) {
            return thisChild.getText();
            }}}}
        } catch (System.XMLException e) {  // invalid XML
            System.debug(e.getMessage());
        }
        return null;
    }
    /*End part of PD-11138*/
    
    /*
        Description: Get values from request XML.
    */
    public Map<String,String> getValuesFromRequestXML(Map<String,String> attribute, String zuoraCalloutString){
        
        DOM.Document zuoraCalloutAsDOM = new DOM.Document();
        try {
            zuoraCalloutAsDOM.load(zuoraCalloutString);   
            
            DOM.XMLNode root = zuoraCalloutAsDOM.getRootElement();   
            
            if (root.getNodeType() == DOM.XMLNodeType.ELEMENT) {
                if('callout'.equals(root.getName())){
                    for (Integer i = 0; i< root.getChildElements().size(); i++ ) {
                    //loop through all "parameters" sent
                        DOM.XMLNode thisChild = root.getChildElements().get(i);
                        if (attribute.containsKey((thisChild.getAttribute('name', null)))) {
                             attribute.put(thisChild.getAttribute('name', null), thisChild.getText());
                        }
                        
                    }
                    
                }
                
            }
        } catch (System.XMLException e) {  // invalid XML
            System.debug(e.getMessage());
        }
        return attribute;
    }
    
    /*
        Description: Method to update Account status based on payment status.
    */
    private void updateAccountStatus(Id sAccountId, string sStatus){
        List<Account> lstAccount = [Select Id, Account_Status__c, PauseScheduled__c, Pause_From__c, Pause_Until__c from Account where ID=:sAccountId LIMIT 1];
        if(lstAccount!= NULL && !lstAccount.isEmpty()){
            Account oAccount = lstAccount[0];
            oAccount.Pause_From__c = null;
            oAccount.Pause_Until__c = null;
            oAccount.Pause_Scheduled_Time__c = null;
            oAccount.Account_Status__c = sStatus;
            update oAccount;
        }
    }

    /*
        Description: Method to update Account status based on payment status. PD-9349
    */
    public void TransitionAccountToFrozen(String accountId)
    {   
        List<Zuora__CustomerAccount__c> selectedAccount = [select name, id,Payment_Success__c, Zuora__Account__r.Id from Zuora__CustomerAccount__c where Zuora__Zuora_Id__c =:accountId LIMIT 1];
        if(selectedAccount!= NULL && !selectedAccount.isEmpty()){
            /*start part of PD-11138*/
            List<Zuora__Subscription__c> subscroptions = [SELECT Zuora__Account__c, Zuora__Status__c 
                                                        FROM Zuora__Subscription__c 
                                                        WHERE Zuora__Account__c = :selectedAccount[0].Zuora__Account__r.Id 
                                                            AND Zuora__Status__c = 'Active'];
            /*end part of PD-11138*/
            if (subscroptions.isEmpty()) {
                shouldIRun.allow = true; //allow account trigger to execute
                updateAccountStatus(selectedAccount[0].Zuora__Account__r.Id, 'Frozen');
            }
            
        }
    }
}