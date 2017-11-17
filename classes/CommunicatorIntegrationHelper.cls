/**
* @author Cognizant Technology Solutuions
* @date 30/03/2016
* @description Communicator Integration Helper class
*/
public class CommunicatorIntegrationHelper {
    static final integer iAPITimeOutLimit = integer.valueOf(DAZNCommunicatorConfig__c.getValues('CommunicatorAPITimeOutLimit').Value__c);
    //static final Integer DocomoMarketingMailingListID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('Docomo_MarketingMailingListID').Value__c);
    //static final integer DocomoContactTableID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('Docomo_Contact_Table_ID').Value__c);
    static final integer ContactTableID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('Contacts_Table_ID').Value__c);
    static final integer MailingListID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('MailingList_Transactional_ID').Value__c);
    static final integer SalesforceColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('SalesForceID_Column_ID').Value__c);
    static final integer EmailColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('Email_Column_ID').Value__c);
    static final integer FirstNameColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('FirstName_Column_ID').Value__c);
    static final integer LastNameColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('LastName_Column_ID').Value__c);
    static final integer SubscriptionEndDateColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('SubscriptionEndDate_Column_ID').Value__c);
    static final integer CurrencyColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('Currency_Column_ID').Value__c);
    static final integer SubscriptionAmountColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('SubscriptionAmount_Column_ID').Value__c);
    static final integer PlanDetailsColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('PlanDetails_Column_ID').Value__c);
    static final integer PaymentMethodTypeColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('PaymentMethodType_Column_ID').Value__c);
    static final integer FreeTrialEndDateColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('FreeTrialEndDate_Column_ID').Value__c);
    static final integer AccountStatusColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('AccountStatus_Column_ID').Value__c);
    static final integer NotificationLanguageColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('NotificationLanguageCode_Column_ID').Value__c);
    static final integer NotificationCountryColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('NotificationCountryCode_Column_ID').Value__c);
    static final integer CountryLanguageColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('CountryLanguage_Column_ID').Value__c);
    static final integer SignInLinkColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('SignInLink_Column_ID').Value__c);
    static final integer GermanyMarketingMailingListID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('Germany_Marketing_Mailing_List_ID').Value__c);
    static final integer UnsubscribeLanguageColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('UnsubscribeLanguage_Column_ID').Value__c);
    static final Integer MarketingMailingListID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('Marketing_Mailing_List_ID').Value__c);
    //PD-8706
    static final Integer HardOfferColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('HardOfferDateTime_Column_ID').Value__c);
    //PD-7603
    static final Integer ResetPasswordURLColumnID = (
        (DAZNCommunicatorConfig__c.getValues('ResetPasswordURL_Column_ID') != null) ?
        Integer.valueOf(DAZNCommunicatorConfig__c.getValues('ResetPasswordURL_Column_ID').Value__c) :
        (!Test.isRunningTest() ? null : 12345)
    );
    //PD-11966
    static final Integer PauseFromColumnID = (
        (DAZNCommunicatorConfig__c.getValues('PauseFrom_Column_ID') != null) ?
        Integer.valueOf(DAZNCommunicatorConfig__c.getValues('PauseFrom_Column_ID').Value__c) :
        (!Test.isRunningTest() ? null : 12345)
    );
    static final Integer PauseUntilColumnID = (
        (DAZNCommunicatorConfig__c.getValues('PauseUntil_Column_ID') != null) ?
        Integer.valueOf(DAZNCommunicatorConfig__c.getValues('PauseUntil_Column_ID').Value__c) :
        (!Test.isRunningTest() ? null : 12345)
    );
    //PD-12322
    static final Integer RebillDateColumnID = (
        (DAZNCommunicatorConfig__c.getValues('RebillDate_Column_ID') != null) ?
        Integer.valueOf(DAZNCommunicatorConfig__c.getValues('RebillDate_Column_ID').Value__c) :
        (!Test.isRunningTest() ? null : 12345)
    );
    //PD-12322
    static final Integer FirstMonthlySubscriptAmountColumnID = (
        (DAZNCommunicatorConfig__c.getValues('FirstMonthlySubscriptAmount_Column_ID') != null) ?
        Integer.valueOf(DAZNCommunicatorConfig__c.getValues('FirstMonthlySubscriptAmount_Column_ID').Value__c) :
        (!Test.isRunningTest() ? null : 12345)
    );
    //PD-12616
    static final Integer AnnualSubscriptionAmountColumnID = (
        (DAZNCommunicatorConfig__c.getValues('AnnualSubscriptionAmount_Column_ID') != null) ?
        Integer.valueOf(DAZNCommunicatorConfig__c.getValues('AnnualSubscriptionAmount_Column_ID').Value__c) :
        (!Test.isRunningTest() ? null : 12345)
    );
    //PD-13294
    static final Integer CardExpiryTextColumnID = (
        (DAZNCommunicatorConfig__c.getValues('CardExpiryText_Column_ID') != null) ?
        Integer.valueOf(DAZNCommunicatorConfig__c.getValues('CardExpiryText_Column_ID').Value__c) :
        (!Test.isRunningTest() ? null : 12345)
    );
    static final Integer CardExpiryDateColumnID = (
        (DAZNCommunicatorConfig__c.getValues('CardExpiryDate_Column_ID') != null) ?
        Integer.valueOf(DAZNCommunicatorConfig__c.getValues('CardExpiryDate_Column_ID').Value__c) :
        (!Test.isRunningTest() ? null : 12345)
    );
    //PD-13382
    static final Integer PreviousStatusColumnID = (
        (DAZNCommunicatorConfig__c.getValues('Previous_Status_Column_ID') != null) ?
        Integer.valueOf(DAZNCommunicatorConfig__c.getValues('Previous_Status_Column_ID').Value__c) :
        (!Test.isRunningTest() ? null : 12345)
    );
    static final Integer StatusChangeDateColumnID = (
        (DAZNCommunicatorConfig__c.getValues('Status_Change_Date_Column_ID') != null) ?
        Integer.valueOf(DAZNCommunicatorConfig__c.getValues('Status_Change_Date_Column_ID').Value__c) :
        (!Test.isRunningTest() ? null : 12345)
    );
    // PD-16055
    static final Integer GiftCodeExpiryDateColumnID = (
        (DAZNCommunicatorConfig__c.getValues('Gift_Code_Expiry_Date_Column_ID') != null) ?
        Integer.valueOf(DAZNCommunicatorConfig__c.getValues('Gift_Code_Expiry_Date_Column_ID').Value__c) :
        (!Test.isRunningTest() ? null : 12345)
    );

	//static final Integer DocomoMarketingMailingListID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('Docomo_MarketingMailingListID').Value__c);
    //static final integer DocomoContactTableID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('Docomo_Contact_Table_ID').Value__c);
	/*static final integer DocomoEmailColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('DFD_EmailColumnID').Value__c);
	static final integer DocomoFirstName = integer.valueOf(DAZNCommunicatorConfig__c.getValues('DFD_FirstName').Value__c);
	static final integer DocomoLastName = integer.valueOf(DAZNCommunicatorConfig__c.getValues('DFD_LastName').Value__c);
	static final integer DocomoNotificationCountryColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('DFD_NotificationCountryColumnID').Value__c);	
	static final integer DocomoUnsubscribeLanguageColumnID= integer.valueOf(DAZNCommunicatorConfig__c.getValues('DFD_UnsubscribeLanguageColumnID').Value__c);*/
	//static final integer DocomoSalesforceColumnID = integer.valueOf(DAZNCommunicatorConfig__c.getValues('DFD_SalesforceColumnID').Value__c);
    //static final integer DfdColumnID= integer.valueOf(DAZNCommunicatorConfig__c.getValues('DfdColumnID').Value__c);
    /*
        Description: Method to set communictor credential
    */
    private static DataService.CommunicatorCredentials getCommunicatorCreds(){
        
        // set communicator credentials.
        DataService.CommunicatorCredentials oCredentials = new DataService.CommunicatorCredentials();
        oCredentials.Username = DAZNConfiguration__c.getValues('CommunicatorAPIUserName').Value__c;
        oCredentials.Password = CommunityHelper.decrypt(DAZNConfiguration__c.getValues('EncryptionKey').Value__c, 
                                                        DAZNConfiguration__c.getValues('CommunicatorAPIUserPwd').Value__c); 
        return oCredentials;
    }
    
    /*
        Description: Method to get Column for SOAP Request
    */
    private static DataService.ColumnMapping getColumn(integer iColumnId, string sValue){
        DataService.ColumnMapping oColumnMap = new DataService.ColumnMapping();
        oColumnMap.ColumnId = iColumnId;
        oColumnMap.Value = sValue;
        return oColumnMap;
    }
    
    /*
        Description: Method to get subscription for SOAP Request
    */
    private static DataService.Subscription getSubscription(integer iMailingListId, Boolean bSubscribed, Boolean bHonourExistingUnsubscribes){
        DataService.Subscription oSubscription  = new DataService.Subscription();
        oSubscription.MailingListId = iMailingListId;
        oSubscription.Subscribed = bSubscribed;
        oSubscription.HonourExistingUnsubscribes = bHonourExistingUnsubscribes;
        return oSubscription;
    }
    
    /*
        Description: Method to get datarecord for soap request
    */
    private static DataService.DataRecord getDataRecord(DataService.ArrayOfColumnMapping arrColumnMap, DataService.ArrayOfSubscription arrSubscription, Boolean bGloballyUnsubscribed){
        DataService.DataRecord oDataRecord = new DataService.DataRecord();
        oDataRecord.ColumnMappings = arrColumnMap;
        oDataRecord.Subscriptions = arrSubscription;
        oDataRecord.IsGloballyUnsubscribed = bGloballyUnsubscribed;
        return oDataRecord;
    }
    
    /*
        Description: Method to get triggered dispatch for soap request
    */
    private static DataService.TriggeredDispatch getTriggeredDispatch(integer iDispatchId, string sTriggeredDispatchMethod){
        DataService.TriggeredDispatch oDispatch = new DataService.TriggeredDispatch();
        oDispatch.DispatchId = iDispatchId;
        oDispatch.TriggeredDispatchMethod = sTriggeredDispatchMethod;
        return oDispatch;
    }
    
    /*
        Description: Method to get data import for soap request
    */
    private static DataService.DataImport getDataImport(integer iClientTableId, string sType, DataService.ArrayOfDataRecord arrDataRecords, 
                                                                                        DataService.ArrayOfTriggeredDispatch arrTriggerDispatch){
        DataService.DataImport oDataImport = new DataService.DataImport();
        oDataImport.ClientTableId = iClientTableId; 
        oDataImport.Type_x = sType;
        oDataImport.Records = arrDataRecords;
        oDataImport.TriggeredDispatches = arrTriggerDispatch;
        return oDataImport;
    }
    
    /*
        Description: Method to create notification task for communicator integration.
    */
    private static List<Task> createNotificationTask(DataService.DataImportResponse oDataImportResponse, map<string, 
                                                List<WrapCommunicatorEmail>> mapSubscriptionEmail, string sCountryLanguage,
                                                string sTaskSubject){
         
        // Check record sync status and prepare a set of failure record id's.
        Set<Id> setFailedAccountId = new Set<Id>();
        for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
         if(oDataResponseDet.Result != 'SuccessUpdating' && oDataResponseDet.Result != 'SuccessInserting'){
                for(DataService.ColumnMapping oColumn : oDataResponseDet.Mappings.ColumnMapping){
                   if(oColumn.ColumnId == SalesforceColumnID){
                       setFailedAccountId.add(oColumn.Value);
                   }
                }
            }
        }
        
        // Prepare list of task to be created.
        List<Task> lstTask = new List<Task>();
        for(WrapCommunicatorEmail objWrap : mapSubscriptionEmail.get(sCountryLanguage)){
            if(!setFailedAccountId.contains(objWrap.ID)){
                lstTask.add(CommunityHelper.createTask(objWrap.ContactId, objWrap.ID, sTaskSubject, sTaskSubject));
            }
        }
         return lstTask;                                      
      }
    
    /*
        Description: Method to get unsubscribe language.
    */
    private static string getUnsubscribeLanguage(string sLanguage){
        if(!String.isBlank(sLanguage)){
            if(sLanguage.length() > 2 && sLanguage.indexOf('_') > -1){
                    sLanguage = sLanguage.split('_')[0];
            }
        }
        return sLanguage;
    }
    
    /*
        Description: Future call for Name Update email notification.
    */
    @future (callout=true)
    public static void doCallOutNameUpdateFromFuture(string sUserSFID, string sContactId,  string sEmail, String sLang, string sCountryCode){
        sendUserDetailsUpdateNotification(sUserSFID, sContactId, sEmail, 'Updated_Name', sLang, sCountryCode);
    }
    
    /*
        Description: Future call for Password update email notificaiton.
    */
    @future (callout=true)
    public static void doCallOutPasswordUpdateFromFuture(string sUserSFID, string sContactId, string sEmail, String sLang, string sCountryCode){
        sendUserDetailsUpdateNotification(sUserSFID, sContactId, sEmail, 'Updated_Password', sLang, sCountryCode);
    }

    //--- PD-7603 start ---
    /*
        Description: Future call for Password update email notificaiton.
    */
    @future (callout=true)
    public static void doCallOutResetPasswordFromFuture(String sSFID, String sContactId, String sFirstName, String sResetPasswordURL, String sLang, String sCountryCode) {
        sendResetPasswordNotification(sSFID, sContactId, sFirstName, sResetPasswordURL, 'Forgotten_Password', sLang, sCountryCode);
    }

    /*
      Description: Method to send notification email to user on reset password
      - User name
      - Payment
      - Password
    */
    public static void sendResetPasswordNotification(String sSFID, String sContactId, String sFirstName, String sResetPasswordURL, String sChangedInfo, String sLang, String sCountryCode ){
        try {          
            Integer dispatchId;
            
            //get the disptach id based on language 
            dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_' + sChangedInfo + '_'+ sCountryCode + '_'+ sLang).Value__c);
            
            List<DataService.ColumnMapping> lstColumnMapping = new List<DataService.ColumnMapping>();
            DataService.ColumnMapping oColumnMap1 = new DataService.ColumnMapping();
            lstColumnMapping.add(getColumn(SalesforceColumnID, sSFID));

            lstColumnMapping.add(getColumn(FirstNameColumnID, sFirstName));
            lstColumnMapping.add(getColumn(ResetPasswordURLColumnID, sResetPasswordURL));

            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(sLang)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, sLang));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, sCountryCode));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, sCountryCode + '_' + sLang));
            
            // create array of data column mapping
            DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
            arrColumnMap.ColumnMapping = lstColumnMapping;
            
            // set subscription
            List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
            lstSubscription.add(getSubscription(MailingListID, true, false));
           
            // create array of subscription
            DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
            arrSubscription.Subscription = lstSubscription;
            
            // Prepare data record
            List<DataService.DataRecord> lstDataRecord = new List<DataService.DataRecord>();            
            lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
            
            // create list of triggered dispatch
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
            lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
            
            // create array of data records.
            DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
            arrDataRecords.DataRecord = lstDataRecord;
            
            // create array of triggered dispatch
            DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
            arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
            
            // set the credentials
            DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
            oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
            oDataServiceSoap.timeout_x = iAPITimeOutLimit;
            
            // Invoke SOAP request and get response.
            DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
            oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
            
            List<Task> lstTask = new List<Task>();
            string sTaskSubject = '';

            for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                if(oDataResponseDet.Result == 'SuccessUpdating' || oDataResponseDet.Result == 'SuccessInserting'){
                    sTaskSubject = Label.LS_Communicator_Reset_Password_Email_Task_Subject;
                    lstTask.add(CommunityHelper.createTask(sContactId, sSFID, sTaskSubject, sTaskSubject));
                }
            }
            if (lstTask != null && !lstTask.isEmpty()) {
                insert lstTask;
            }
        } catch (Exception ex) {  
            CommunicatorFailureWebservice.createTask(sContactId, sSFID, Label.Webservice_Failed, ex.getMessage(), null, null, null, null);          
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendResetPasswordNotification', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }
    //--- PD-7603 end ---
    
    /*
      Description: Method to send notification email to user on personal detail update
      - User name
      - Payment
      - Password
    */
    public static void sendUserDetailsUpdateNotification(string sSFID, string sContactId, string sEmail, String sChangedInfo, String sLang, String sCountryCode ){
        try{          
            Integer dispatchId;
            
            //get the disptach id based on language 
            dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_' + sChangedInfo + '_'+ sCountryCode + '_'+ sLang).Value__c);
            
            List<DataService.ColumnMapping> lstColumnMapping = new List<DataService.ColumnMapping>();
            DataService.ColumnMapping oColumnMap1 = new DataService.ColumnMapping();
            lstColumnMapping.add(getColumn(SalesforceColumnID, sSFID));
            lstColumnMapping.add(getColumn(EmailColumnID, sEmail)); 
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(sLang)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, sLang));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, sCountryCode));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, sCountryCode + '_' + sLang));
            
            // create array of data column mapping
            DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
            arrColumnMap.ColumnMapping = lstColumnMapping;
            
            // set subscription
            List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
            lstSubscription.add(getSubscription(MailingListID, true, false));
           
            // create array of subscription
            DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
            arrSubscription.Subscription = lstSubscription;
            
            // Prepare data record
            List<DataService.DataRecord> lstDataRecord = new List<DataService.DataRecord>();            
            lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
            
            // create list of triggered dispatch
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
            lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
            
            // create array of data records.
            DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
            arrDataRecords.DataRecord = lstDataRecord;
            
            // create array of triggered dispatch
            DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
            arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
            
            // set the credentials
            DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
            oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
            oDataServiceSoap.timeout_x = iAPITimeOutLimit;
            
            // Invoke SOAP request and get response.
            DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
            oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
            
            List<Task> lstTask = new List<Task>();
            string sTaskSubject = '';
            for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                if(oDataResponseDet.Result == 'SuccessUpdating' || oDataResponseDet.Result == 'SuccessInserting'){
                    if(sChangedInfo == 'Updated_Payment')
                        sTaskSubject = Label.LS_Communicator_Payment_Method_Update_Email_Task_Subject;
                    else if(sChangedInfo == 'Updated_Password')
                        sTaskSubject = Label.LS_Communicator_Password_Changed_Email_Task_Subject;
                    
                    lstTask.add(CommunityHelper.createTask(sContactId, sSFID, sTaskSubject, sTaskSubject));
                }
            }
            if(lstTask != null && !lstTask.isEmpty())
                insert lstTask;
        }catch (Exception ex){  
            //Start PD-9012   
            CommunicatorFailureWebservice.createTask(sContactId, sSFID, Label.Webservice_Failed, ex.getMessage(), null, null, null, null);          
            //End PD-9012   
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendUserDetailsUpdateNotification', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }
    
    /*
      Description: Bulkified method to send notification email to users on personal detail update
      - User name
      - Payment
      - Password
    */
    /* Commented out according to PD-13009:
    public static void sendUserDetailsUpdateNotification (Map<String,List<Account>> mapAccount, string sChangedInfo){
        try{          
            Integer dispatchId;            
            List<DataService.ColumnMapping> lstColumnMapping = null;
            List<DataService.DataRecord> lstDataRecord = null;
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = null;
            List<Task> lstTask = null;
            
           
            if(mapAccount!= null && !mapAccount.isEmpty()){
                
                // Prepare list of task to be created.
                lstTask = new List<Task>();
                
                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;

               
               for(String sCountryLanguage : mapAccount.keySet()){
                    lstDataRecord = new List<DataService.DataRecord>(); 
                    
                    //get the disptach id based on language and changed Info
                    dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_' + sChangedInfo + '_' + sCountryLanguage).Value__c); 
                    
                    //iterate through the list of users for this language
                   
                   for(Account oAccount : mapAccount.get(sCountryLanguage)){
                        lstColumnMapping = new List<DataService.ColumnMapping>();
                        
                       
                        lstColumnMapping.add(getColumn(SalesforceColumnID, oAccount.ID));
                        lstColumnMapping.add(getColumn(EmailColumnID, oAccount.PersonEmail));
                        lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(oAccount.Notification_Language_Code__c)));
                        lstColumnMapping.add(getColumn(FirstNameColumnID, oAccount.FirstName));
                        lstColumnMapping.add(getColumn(LastNameColumnID, oAccount.LastName));
                        lstColumnMapping.add(getColumn(NotificationLanguageColumnID, oAccount.Notification_Language_Code__c));
                        lstColumnMapping.add(getColumn(NotificationCountryColumnID, oAccount.Notification_Country_Code__c));
                        lstColumnMapping.add(getColumn(CountryLanguageColumnID, oAccount.Notification_Country_Code__c + '_' + oAccount.Notification_Language_Code__c));
                        
                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                        arrColumnMap.ColumnMapping = lstColumnMapping;
                        
                        // set subscription
                        List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
                        lstSubscription.add(getSubscription(MailingListID, true, false));
                        
                        // create array of subscription
                        DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                        arrSubscription.Subscription = lstSubscription;
                        
                        // Prepare data record
                        lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                    }
                    // create list of triggered dispatch
                    lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
                    lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
                    
                    // create array of data records.
                    DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                    arrDataRecords.DataRecord = lstDataRecord;
                    
                    // create array of triggered dispatch
                    DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                    arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
                    
                    // Invoke SOAP request and get response.
                    DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
                    oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
                    
                   //Start PD-9012
                    // Check record sync status and prepare a set of failure record id's.
                    Set<Id> setFailedAccountId = new Set<Id>();
                    for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                        if(oDataResponseDet.Result != 'SuccessUpdating' && oDataResponseDet.Result != 'SuccessInserting'){
                            for(DataService.ColumnMapping oColumn : oDataResponseDet.Mappings.ColumnMapping){
                               if(oColumn.ColumnId == SalesforceColumnID){
                                   setFailedAccountId.add(oColumn.Value);
                               }
                            }
                        }
                    }
                    
                    //for(User oUser : mapUser.get(sCountryLanguage)){
                    for(Account oAccount: mapAccount.get(sCountryLanguage)){
                        if(!setFailedAccountId.contains(oAccount.Id)){
                           lstTask.add(CommunityHelper.createTask(oAccount.PersonContactId, oAccount.Id, Label.LS_Communicator_Name_Email_Update_Email_Task_Subject, 
                                                                                                     Label.LS_Communicator_Name_Email_Update_Email_Task_Subject));
                        }else{ 
                            CommunicatorFailureWebservice.createTask(null, null, Label.Webservice_Failed, Label.Webservice_Failed, mapAccount, null, null, null);                            
                        }
                    }
                }
                //end PD-9012
                if(lstTask != null && !lstTask.isEmpty())
                    insert lstTask;
            }
        }catch (Exception ex){
            //Start PD-9012   
            CommunicatorFailureWebservice.createTask(null, null, Label.Webservice_Failed, ex.getMessage(), mapAccount, null, null, null);                            
            //End PD-9012 
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendUserDetailsUpdateNotification', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }*/

    /*
        Description: Future call for Password update email notificaiton.
    */
    @future (callout=true)
    public static void doCallOutCancelledSubscriptionFromFuture(string sSFID, string sContactId, string sEmail, DateTime dtEndDate, String sLang, string sCountryCode){
        sendCancelledSubsriptionNotification(sSFID, sContactId, sEmail, dtEndDate, sLang, sCountryCode);
    }

    /*
        Description: Flag for CancelEmail method. Set to true if CommunicatorIntegrationHelper methods throw exceptions
    */
    public static Boolean isErrorDuringEmailSending;

    /*
        Description: Method to send notification email to user on cancellation of subscription - commented out according to PD-12102
    */
    /*public static void sendCancelledSubsriptionNotificationforStandard(Map<String,List<WrapCommunicatorEmail>> mapSubscriptionEmailforStandard){
        try{
            List<Task> lstTask = null;
            Integer dispatchStandardId;
            List<DataService.ColumnMapping> lstColumnMappingStandard = null;
            List<DataService.DataRecord> lstDataRecordStandard = null;
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
            List<Task> lstTaskAll = null;
            
            if(mapSubscriptionEmailforStandard!= null && !mapSubscriptionEmailforStandard.isEmpty()){
                lstTaskAll = new List<Task>();
                
                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;
                
                for(String sCountryLanguage : mapSubscriptionEmailForStandard.keySet()){
                    lstDataRecordStandard = new List<DataService.DataRecord>();                                

                    //get the disptach id based on language 
                    dispatchStandardId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_User_Cancel_'+ sCountryLanguage).Value__c); 

                    //iterate through the list of wrapper  class
                    for(WrapCommunicatorEmail objWrap : mapSubscriptionEmailForStandard.get(sCountryLanguage)){
                        lstColumnMappingStandard = new List<DataService.ColumnMapping>();
                        
                        lstColumnMappingStandard.add(getColumn(SalesforceColumnID, objWrap.Id));
                        lstColumnMappingStandard.add(getColumn(EmailColumnID, objWrap.Email));
                        lstColumnMappingStandard.add(getColumn(SubscriptionEndDateColumnID, objWrap.EndDate.format('dd/MM/yyyy')));
                        lstColumnMappingStandard.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(objWrap.NotificaitonLanguageCode)));
                        lstColumnMappingStandard.add(getColumn(NotificationLanguageColumnID, objWrap.NotificaitonLanguageCode));
                        lstColumnMappingStandard.add(getColumn(NotificationCountryColumnID, objWrap.NotificationCountryCode));
                        lstColumnMappingStandard.add(getColumn(CountryLanguageColumnID, objWrap.NotificationCountryCode + '_' + objWrap.NotificaitonLanguageCode));

                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                        arrColumnMap.ColumnMapping = lstColumnMappingStandard;
                        
                        // set subscription
                        List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
                        lstSubscription.add(getSubscription(MailingListID, true, false));
                        
                        // create array of subscription
                        DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                        arrSubscription.Subscription = lstSubscription;
                        
                        // Prepare data record
                        lstDataRecordStandard.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                    }
                    // create list of triggered dispatch
                    lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
                    lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchStandardId, 'SendToAllSubscribers'));
                    
                    // create array of data records.
                    DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                    arrDataRecords.DataRecord = lstDataRecordStandard;
                    
                    // create array of triggered dispatch
                    DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                    arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
                    
                    // Invoke SOAP request and get response.
                    DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
                    oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
                    
                    //Start PD-9012
                    for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                        if(oDataResponseDet.Result == 'SuccessUpdating' || oDataResponseDet.Result == 'SuccessInserting'){
                            lstTask = createNotificationTask(oDataImportResponse, mapSubscriptionEmailforStandard, sCountryLanguage, Label.LS_Communicator_Cancel_Subscription_Email_Task_Subject);
                        }
                        else{ 
                            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmailforStandard, Label.Webservice_Failed, Label.Webservice_Failed);            
                        } 
                    }
                    //End PD-9012
                    if(lstTask !=null && !lstTask.isEmpty()){
                        lstTaskAll.addAll(lstTask);
                    }
                }
                if(lstTaskAll !=null && !lstTaskAll.isEmpty()){
                    insert lstTaskAll;
                }
                isErrorDuringEmailSending = false;
            }
        }catch (Exception ex) {
            isErrorDuringEmailSending = true;
            //Start PD-9012
            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmailforStandard, Label.Webservice_Failed, ex.getMessage());
            //End PD-9012
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendCancelledSubsriptionNotificationforStandard', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }*/

    public static void sendCancelledSubsriptionNotification(string sSFID, string sContactId, string sEmail, DateTime endDate, String lang, string sCountryCode){
        try{          
            Integer dispatchId;
            //get the disptach id based on language 
            dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_User_Cancel_'+ sCountryCode +'_' +lang).Value__c);
            
            List<DataService.ColumnMapping> lstColumnMapping = new List<DataService.ColumnMapping>();
            DataService.ColumnMapping oColumnMap1 = new DataService.ColumnMapping();
            lstColumnMapping.add(getColumn(SalesforceColumnID, sSFID));
            lstColumnMapping.add(getColumn(EmailColumnID, sEmail));
            String strDate = endDate.format('dd/MM/yyyy');
            lstColumnMapping.add(getColumn(SubscriptionEndDateColumnID, strDate)); 
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(lang)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, lang));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, sCountryCode));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, sCountryCode + '_' + lang));
            
            // create array of data column mapping
            DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
            arrColumnMap.ColumnMapping = lstColumnMapping;
            
            // set subscription
            List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
            lstSubscription.add(getSubscription(MailingListID, true, false));
           
            // create array of subscription
            DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
            arrSubscription.Subscription = lstSubscription;
            
            // Prepare data record
            List<DataService.DataRecord> lstDataRecord = new List<DataService.DataRecord>();            
            lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                
            // create list of triggered dispatch
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
            lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
            
            // create array of data records.
            DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
            arrDataRecords.DataRecord = lstDataRecord;
            
            // create array of triggered dispatch
            DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
            arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
            
            // set the credentials
            DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
            oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
            oDataServiceSoap.timeout_x = iAPITimeOutLimit;
            
            // Invoke SOAP request and get response.
            DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
            oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
            
            List<Task> lstTask = new List<Task>();
            for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                if(oDataResponseDet.Result == 'SuccessUpdating' || oDataResponseDet.Result == 'SuccessInserting'){
                    lstTask.add(CommunityHelper.createTask(sContactId, sSFID, Label.LS_Communicator_Cancel_Subscription_Email_Task_Subject, 
                                                                              Label.LS_Communicator_Cancel_Subscription_Email_Task_Subject));
                }
                else{ //Start PD-9012
                    CommunicatorFailureWebservice.createTask(sContactId, sSFID, Label.Webservice_Failed,Label.Webservice_Failed, null, null, null, null);                                                                                 
                } //End PD-9012
            }
            if(lstTask != null && !lstTask.isEmpty())
                insert lstTask;
            
        }catch (Exception ex){
            //Start PD-9012                     
            CommunicatorFailureWebservice.createTask(sContactId, sSFID, Label.Webservice_Failed,ex.getMessage(), null, null, null, null);                                                                                 
            //End PD-9012 
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendCancelledSubsriptionNotification', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }
    /*
        Description : Method to send the Partial Welcome email when the user is Registered
    */
    public static void sendPartialWelcomeNotification(map<string, List<WrapCommunicatorEmail>> mapSubscriptionEmail){    
        try{
            Integer dispatchId;
            List<DataService.ColumnMapping> lstColumnMapping = null;
            List<DataService.DataRecord> lstDataRecord = null;
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
            if(mapSubscriptionEmail!= null && !mapSubscriptionEmail.isEmpty()){
                
                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;
                
                for(String sCountryLanguage : mapSubscriptionEmail.keySet()){
                    lstDataRecord = new List<DataService.DataRecord>();  
                    
                    //get the disptach id based on language 
                    dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Partial_Welcome_'+ sCountryLanguage).Value__c);  

                    //iterate through the list of wrapper  class
                    for(WrapCommunicatorEmail objWrap : mapSubscriptionEmail.get(sCountryLanguage)){
                        lstColumnMapping = new List<DataService.ColumnMapping>();
                        
                        lstColumnMapping.add(getColumn(SalesforceColumnID, objWrap.id));
                        lstColumnMapping.add(getColumn(EmailColumnID, objWrap.email));
                        lstColumnMapping.add(getColumn(FirstNameColumnID, objWrap.firstName));
                        lstColumnMapping.add(getColumn(CurrencyColumnID, objWrap.AccountCurrency  ));    
                        lstColumnMapping.add(getColumn(SubscriptionAmountColumnID, objWrap.SubscriptionAmt)); 
                        lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(objWrap.NotificaitonLanguageCode)));
                        lstColumnMapping.add(getColumn(NotificationLanguageColumnID, objWrap.NotificaitonLanguageCode));
                        lstColumnMapping.add(getColumn(NotificationCountryColumnID, objWrap.NotificationCountryCode));
                        lstColumnMapping.add(getColumn(CountryLanguageColumnID, objWrap.NotificationCountryCode + '_' + objWrap.NotificaitonLanguageCode));
                             
                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                        arrColumnMap.ColumnMapping = lstColumnMapping;
                        
                        // set subscription
                        List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
                        lstSubscription.add(getSubscription(MailingListID, true, false));
                       
                        // create array of subscription
                        DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                        arrSubscription.Subscription = lstSubscription;
                        
                        // Prepare data record
                        lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                    }
                    // create list of triggered dispatch                    
                    lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers')); 
                    
                    // create array of data records.
                    DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                    arrDataRecords.DataRecord = lstDataRecord;
                    
                    // create array of triggered dispatch
                    DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                    arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
                
                    // Invoke SOAP request and get response.
                    DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
                    oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
                }
            }
        } catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendPartialWelcomeNotification', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());     
        }
    }
    
    /*
        Description : Method to send the Free Trial Welcome email - commented out for PD-11936
    */
    public static void sendFreeTrialWelcomeNotification(map<string,list<WrapCommunicatorEmail>> mapSubscriptionEmail){
        try{            
            List<Task> lstTask = null;
            Integer dispatchId;
            List<DataService.ColumnMapping> lstColumnMapping = null;
            List<DataService.DataRecord> lstDataRecord = null;
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
            List<Task> lstTaskAll = null;
            
             if(mapSubscriptionEmail!= null && !mapSubscriptionEmail.isEmpty()){
                lstTaskAll = new List<Task>();
                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;
                
                for(String sCountryLanguage : mapSubscriptionEmail.keySet()){
                    lstDataRecord = new List<DataService.DataRecord>();  
                    
                    //get the disptach id based on language                     
                    dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Free_Trial_Welcome_'+ sCountryLanguage).Value__c);   
                      
                    //iterate through the list of wrapper  class                    
                    for(WrapCommunicatorEmail objWrap : mapSubscriptionEmail.get(sCountryLanguage)){                                                
                        lstColumnMapping = new List<DataService.ColumnMapping>();
                        
                        lstColumnMapping.add(getColumn(SalesforceColumnID, objWrap.Id));
                        lstColumnMapping.add(getColumn(EmailColumnID, objWrap.email));
                        lstColumnMapping.add(getColumn(FirstNameColumnID, objWrap.FirstName));
                        lstColumnMapping.add(getColumn(CurrencyColumnID, objWrap.AccountCurrency ));    
                        lstColumnMapping.add(getColumn(SubscriptionAmountColumnID, objWrap.SubscriptionAmt)); 
                        lstColumnMapping.add(getColumn(PlanDetailsColumnID, objWrap.PlanDetails)); 
                        lstColumnMapping.add(getColumn(PaymentMethodTypeColumnID, objWrap.PaymentType));                         
                        lstColumnMapping.add(getColumn(FreeTrialEndDateColumnID, objWrap.EndDate.format('dd/MM/yyyy'))); 
                        lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(objWrap.NotificaitonLanguageCode)));  
                        lstColumnMapping.add(getColumn(NotificationLanguageColumnID, objWrap.NotificaitonLanguageCode));
                        lstColumnMapping.add(getColumn(NotificationCountryColumnID, objWrap.NotificationCountryCode));
                        lstColumnMapping.add(getColumn(CountryLanguageColumnID, objWrap.NotificationCountryCode + '_' + objWrap.NotificaitonLanguageCode));
                        
                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                        arrColumnMap.ColumnMapping = lstColumnMapping;
                        
                        // set subscription
                        List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
                        lstSubscription.add(getSubscription(MailingListID, true, false));
                       
                        // create array of subscription
                        DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                        arrSubscription.Subscription = lstSubscription;
                        
                        // Prepare data record
                        lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                    }
                    // create list of triggered dispatch    
                    lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
                    // create array of data records.
                    DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                    arrDataRecords.DataRecord = lstDataRecord;
                
                    // create array of triggered dispatch
                    DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                    arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;                   
                    // Invoke SOAP request and get response.
                    DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
                    oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));                    
                     //Start PD-9012              
                     for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){                                           
                        if(oDataResponseDet.Result == 'SuccessUpdating' || oDataResponseDet.Result == 'SuccessInserting'){                            
                             // create task for succesfull notification.
                            lstTask = createNotificationTask(oDataImportResponse, mapSubscriptionEmail, sCountryLanguage, Label.LS_Communicator_Free_Trial_Welcome_Email_Task_Subject);
                        }
                        else{ 							
                            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmail, Label.Webservice_Failed,Label.Webservice_Failed);                            
                        } 
                    }
                    //End PD-9012       
                     
                    if(lstTask !=null && !lstTask.isEmpty()){
                        lstTaskAll.addAll(lstTask);
                    }
               }
                if(lstTaskAll !=null && !lstTaskAll.isEmpty()){
                    insert lstTaskAll;       
                }
            }
        }catch(Exception ex){   
            system.debug('ex=====>'+ex);
            //Start PD-9012
            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmail, Label.Webservice_Failed,ex.getMessage());
            //End PD-9012
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendFreeTrialWelcomeNotification', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());     
        }
    }
    
    /*
        Description : Method to send the Hard Offer Email - commented out according to PD-12083
    */
    /*public static void sendHardOfferWelcomeNotification(map<string,list<WrapCommunicatorEmail>> mapSubscriptionEmail){    
        try{
            List<Task> lstTask = null;
            Integer dispatchId;
            List<DataService.ColumnMapping> lstColumnMapping = null;
            List<DataService.DataRecord> lstDataRecord = null;
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
            List<Task> lstTaskAll = null;
            
            if(mapSubscriptionEmail!= null && !mapSubscriptionEmail.isEmpty()){
                lstTaskAll = new List<Task>();
                
                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;
                
                for(String sCountryLanguage : mapSubscriptionEmail.keySet()){
                    system.debug('sCountryLanguage=====>'+sCountryLanguage);
                    lstDataRecord = new List<DataService.DataRecord>();            

                    //get the disptach id based on language 
                    dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Hard_Offer_Welcome_'+ sCountryLanguage).Value__c);   
                    
                    //iterate through the list of wrapper  class
                    for(WrapCommunicatorEmail objWrap : mapSubscriptionEmail.get(sCountryLanguage)){
                        lstColumnMapping = new List<DataService.ColumnMapping>();
                        
                        lstColumnMapping.add(getColumn(SalesforceColumnID, objWrap.ID));
                        lstColumnMapping.add(getColumn(EmailColumnID, objWrap.Email));
                        lstColumnMapping.add(getColumn(FirstNameColumnID, objWrap.FirstName));
                        lstColumnMapping.add(getColumn(SignInLinkColumnID, objWrap.SignInLink ));                
                        lstColumnMapping.add(getColumn(PlanDetailsColumnID, objWrap.PlanDetails)); 
                        lstColumnMapping.add(getColumn(PaymentMethodTypeColumnID, objWrap.PaymentType));                         
                        lstColumnMapping.add(getColumn(FreeTrialEndDateColumnID, objWrap.EndDate.format('dd/MM/yyyy')));
                        lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(objWrap.NotificaitonLanguageCode)));
                        lstColumnMapping.add(getColumn(NotificationLanguageColumnID, objWrap.NotificaitonLanguageCode));
                        lstColumnMapping.add(getColumn(NotificationCountryColumnID, objWrap.NotificationCountryCode));
                        lstColumnMapping.add(getColumn(CountryLanguageColumnID, objWrap.NotificationCountryCode + '_' + objWrap.NotificaitonLanguageCode));
                        
                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                        arrColumnMap.ColumnMapping = lstColumnMapping;
                        
                        // set subscription
                        List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
                        lstSubscription.add(getSubscription(MailingListID, true, false));
                       
                        // create array of subscription
                        DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                        arrSubscription.Subscription = lstSubscription;
                        
                        // Prepare data record
                        lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                    }
                    // create list of triggered dispatch                    
                    lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers')); 
                    
                    // create array of data records.
                    DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                    arrDataRecords.DataRecord = lstDataRecord;
                    
                    // create array of triggered dispatch
                    DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                    arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
                    
                    // Invoke SOAP request and get response.
                    DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
                    oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
                    
                     //Start PD-9012
                     for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                        if(oDataResponseDet.Result == 'SuccessUpdating' || oDataResponseDet.Result == 'SuccessInserting'){
                             // create task for succesfull notification.
                            lstTask = createNotificationTask(oDataImportResponse, mapSubscriptionEmail, sCountryLanguage, Label.LS_Communicator_HardOffer_Welcome_Email_Task_Subject);
                        }
                        else{ 
                            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmail, Label.Webservice_Failed,Label.Webservice_Failed);            
                        } 
                    }
                    //End PD-9012  
                                        
                    
                    if(lstTask !=null && !lstTask.isEmpty()){
                        lstTaskAll.addAll(lstTask);
                    }
                }
                if(lstTaskAll !=null && !lstTaskAll.isEmpty()){
                    insert lstTaskAll;
                }            
            }
        }catch(Exception ex){   
            //Start PD-9012            
            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmail, Label.Webservice_Failed,ex.getMessage());            
            //End PD-9012
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendHardOfferWelcomeNotification', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());     
        }
    }
    */
    
    /*
        Description : Method to send the payment expiry notification before few days
    */    
    public static void sendPaymentExpiryNotification(Map<String,List<User>> mapUser){    
        try{
            Integer dispatchId;
            List<DataService.ColumnMapping> lstColumnMapping = null;
            List<DataService.DataRecord> lstDataRecord = null;
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
            List<Task> lstTask = null;
            
            if(mapUser!= null && !mapUser.isEmpty()){
                // Prepare list of task to be created.
                lstTask = new List<Task>();
                
                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;
                
                for(String sCountryLanguage : mapUser.keySet()){
                    lstDataRecord = new List<DataService.DataRecord>();        

                    //get the disptach id based on language 
                    dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Payment_Expiry_'+ sCountryLanguage).Value__c); 

                    //iterate through the list of wrapper  class
                    for(User oUser : mapUser.get(sCountryLanguage)){
                        lstColumnMapping = new List<DataService.ColumnMapping>();
                        
                        lstColumnMapping.add(getColumn(SalesforceColumnID, oUser.AccountId));
                        lstColumnMapping.add(getColumn(EmailColumnID, oUser.Email));
                        lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(oUser.LanguageLocaleKey)));
                        lstColumnMapping.add(getColumn(NotificationLanguageColumnID, oUser.LanguageLocaleKey));
                        lstColumnMapping.add(getColumn(NotificationCountryColumnID, oUser.CountryCode));
                        lstColumnMapping.add(getColumn(CountryLanguageColumnID, oUser.CountryCode + '_' + oUser.LanguageLocaleKey));

                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                        arrColumnMap.ColumnMapping = lstColumnMapping;
                        
                        // set subscription
                        List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
                        lstSubscription.add(getSubscription(MailingListID, true, false));
                        
                        // create array of subscription
                        DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                        arrSubscription.Subscription = lstSubscription;
                        
                        // Prepare data record
                        lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                    }
                    // create list of triggered dispatch
                    lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
                    lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
                    
                    // create array of data records.
                    DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                    arrDataRecords.DataRecord = lstDataRecord;
                    
                    // create array of triggered dispatch
                    DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                    arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
    
                    // Invoke SOAP request and get response.
                    DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
                    oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
                    
                    // Check record sync status and prepare a set of failure record id's.
                    Set<Id> setFailedAccountId = new Set<Id>();
                    for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                        if(oDataResponseDet.Result != 'SuccessUpdating' && oDataResponseDet.Result != 'SuccessInserting'){
                            for(DataService.ColumnMapping oColumn : oDataResponseDet.Mappings.ColumnMapping){
                               if(oColumn.ColumnId == SalesforceColumnID){
                                   setFailedAccountId.add(oColumn.Value);
                               }
                            }
                        }
                    }
                    
                    for(User oUser : mapUser.get(sCountryLanguage)){
                        if(!setFailedAccountId.contains(oUser.AccountId)){
                            lstTask.add(CommunityHelper.createTask(oUser.ContactId, oUser.AccountId, Label.LS_Communicator_Name_Email_Update_Email_Task_Subject, 
                                                                                                     Label.LS_Communicator_Name_Email_Update_Email_Task_Subject));
                        }
                        //Start PD-9012  
                        else{
                            CommunicatorFailureWebservice.createTask(null, null, Label.Webservice_Failed,Label.Webservice_Failed, null, null, null, mapUser);                                                                                              
                        }
                        //Start PD-9012  
                    }
                }
                if(lstTask !=null && !lstTask.isEmpty()){
                    insert lstTask;
                }            
            }
        }catch (Exception ex){
            //Start PD-9012    
            CommunicatorFailureWebservice.createTask(null, null, Label.Webservice_Failed,ex.getMessage(), null, null, null, mapUser);                                                                                              
            //End PD-9012 
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendPaymentExpiryNotification', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }
    /*
        Description : Email to be sent when the payment details needs an update
    */
    public static void sendPaymentUpdation(Map<String,List<WrapCommunicatorEmail>> mapSubscriptionEmail){    
        try{
            Integer dispatchId;
            List<DataService.ColumnMapping> lstColumnMapping = null;
            List<DataService.DataRecord> lstDataRecord = null;
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
            
             if(mapSubscriptionEmail!= null && !mapSubscriptionEmail.isEmpty()){
                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;
                
                for(String sCountryLanguage : mapSubscriptionEmail.keySet()){
                    lstDataRecord = new List<DataService.DataRecord>();        
                
                    //get the disptach id based on language 
                    dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Payment_Updatation_'+ sCountryLanguage).Value__c); 

                    //iterate through the list of wrapper  class
                    for(WrapCommunicatorEmail objWrap : mapSubscriptionEmail.get(sCountryLanguage)){
                        lstColumnMapping = new List<DataService.ColumnMapping>();
                        
                        lstColumnMapping.add(getColumn(SalesforceColumnID, objWrap.Id));
                        lstColumnMapping.add(getColumn(EmailColumnID, objWrap.Email));
                        lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(objWrap.NotificaitonLanguageCode)));
                        lstColumnMapping.add(getColumn(NotificationLanguageColumnID, objWrap.NotificaitonLanguageCode));
                        lstColumnMapping.add(getColumn(NotificationCountryColumnID, objWrap.NotificationCountryCode));
                        lstColumnMapping.add(getColumn(CountryLanguageColumnID, objWrap.NotificationCountryCode + '_' + objWrap.NotificaitonLanguageCode));

                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                        arrColumnMap.ColumnMapping = lstColumnMapping;
                        
                        // set subscription
                        List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
                        lstSubscription.add(getSubscription(MailingListID, true, false));
                        
                        // create array of subscription
                        DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                        arrSubscription.Subscription = lstSubscription;
                        
                        // Prepare data record
                        lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                    }
                    // create list of triggered dispatch
                    lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
                    lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
                    
                    // create array of data records.
                    DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                    arrDataRecords.DataRecord = lstDataRecord;
                    
                    // create array of triggered dispatch
                    DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                    arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
                    
                    // Invoke SOAP request and get response.
                    DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
                    oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
                }
            }
        }catch (Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendPaymentUpdation', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }
    
    /*
        Description : Email to be sent about the payment details - commented out according to PD-12533
    */
    /*public static void sendPaymentFailureNotification(Map<String,List<WrapCommunicatorEmail>> mapSubscriptionEmail) {
        try{
            Integer dispatchId;
            List<DataService.ColumnMapping> lstColumnMapping = null;
            List<DataService.DataRecord> lstDataRecord = null;
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
            List<Task> lstTaskAll = null;
            List<Task> lstTask = null;
            
            if(mapSubscriptionEmail!= null && !mapSubscriptionEmail.isEmpty()){
                lstTaskAll = new List<Task>();
                
                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;
                
                for(String sCountryLanguage : mapSubscriptionEmail.keySet()){
                    lstDataRecord = new List<DataService.DataRecord>();            

                    //get the disptach id based on language 
                    dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Payment_Failure_'+ sCountryLanguage).Value__c); 
                    
                    //iterate through the list of wrapper  class
                    for(WrapCommunicatorEmail objWrap : mapSubscriptionEmail.get(sCountryLanguage)){
                        lstColumnMapping = new List<DataService.ColumnMapping>();
                        
                        lstColumnMapping.add(getColumn(SalesforceColumnID, objWrap.Id));
                        lstColumnMapping.add(getColumn(EmailColumnID, objWrap.Email));
                        lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(objWrap.NotificaitonLanguageCode)));
                        lstColumnMapping.add(getColumn(NotificationLanguageColumnID, objWrap.NotificaitonLanguageCode));
                        lstColumnMapping.add(getColumn(NotificationCountryColumnID, objWrap.NotificationCountryCode));
                        lstColumnMapping.add(getColumn(CountryLanguageColumnID, objWrap.NotificationCountryCode + '_' + objWrap.NotificaitonLanguageCode));

                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                        arrColumnMap.ColumnMapping = lstColumnMapping;
                        
                        // set subscription
                        List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
                        lstSubscription.add(getSubscription(MailingListID, true, false));
                        
                        // create array of subscription
                        DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                        arrSubscription.Subscription = lstSubscription;
                        
                        // Prepare data record
                        lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                    }
                    // create list of triggered dispatch
                    lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
                    lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
                    
                    // create array of data records.
                    DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                    arrDataRecords.DataRecord = lstDataRecord;
                    
                    // create array of triggered dispatch
                    DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                    arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
                    
                    // Invoke SOAP request and get response.
                    DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
                    oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
                    
                     //Start PD-9012
                     for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                        if(oDataResponseDet.Result == 'SuccessUpdating' || oDataResponseDet.Result == 'SuccessInserting'){
                             // create task for succesfull notification.
                            lstTask = createNotificationTask(oDataImportResponse, mapSubscriptionEmail, sCountryLanguage, Label.LS_Communicator_Payment_Fail_Email_Task_Subject);
                        }
                        else{ 
                            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmail, Label.Webservice_Failed,Label.Webservice_Failed);            
                        } 
                    }
                    //End PD-9012                                         
                    
                    if(lstTask !=null && !lstTask.isEmpty()){
                        lstTaskAll.addAll(lstTask);
                    }
                }
                if(lstTaskAll !=null && !lstTaskAll.isEmpty()){
                    insert lstTaskAll;
                }            
            }
        }catch (Exception ex){      
            //Start PD-9012
            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmail, Label.Webservice_Failed,ex.getMessage());            
            //End PD-9012
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendPaymentFailureNotification', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }*/
    
    /*
        Description : Email to be sent about the successful payment - commented out according to PD-12615
    */
    /*public static void sendSuccessfulPaymentNotification(Map<String,List<WrapCommunicatorEmail>> mapSubscriptionEmail) {
        try{
            Integer dispatchId;
            List<DataService.ColumnMapping> lstColumnMapping = null;
            List<DataService.DataRecord> lstDataRecord = null;
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
            List<Task> lstTaskAll = null;
            List<Task> lstTask = null;
            
            if(mapSubscriptionEmail!= null && !mapSubscriptionEmail.isEmpty()){
                lstTaskAll = new List<Task>();
                
                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;
                
                for(String sCountryLanguage : mapSubscriptionEmail.keySet()){
                    lstDataRecord = new List<DataService.DataRecord>();            
                    
                    //get the disptach id based on language 
                    dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Payment_Successful_'+ sCountryLanguage).Value__c); 

                    //iterate through the list of wrapper  class
                    for(WrapCommunicatorEmail objWrap : mapSubscriptionEmail.get(sCountryLanguage)){
                        lstColumnMapping = new List<DataService.ColumnMapping>();
                        
                        lstColumnMapping.add(getColumn(SalesforceColumnID, objWrap.Id));
                        lstColumnMapping.add(getColumn(EmailColumnID, objWrap.Email));
                        lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(objWrap.NotificaitonLanguageCode)));
                        lstColumnMapping.add(getColumn(NotificationLanguageColumnID, objWrap.NotificaitonLanguageCode));
                        lstColumnMapping.add(getColumn(NotificationCountryColumnID, objWrap.NotificationCountryCode));
                        lstColumnMapping.add(getColumn(CountryLanguageColumnID, objWrap.NotificationCountryCode + '_' + objWrap.NotificaitonLanguageCode));
                        
                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                        arrColumnMap.ColumnMapping = lstColumnMapping;
                        
                        // set subscription
                        List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
                        lstSubscription.add(getSubscription(MailingListID, true, false));
                        
                        // create array of subscription
                        DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                        arrSubscription.Subscription = lstSubscription;
                        
                        // Prepare data record
                        lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                    }
                    // create list of triggered dispatch
                    lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
                    lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
                    
                    // create array of data records.
                    DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                    arrDataRecords.DataRecord = lstDataRecord;
                    
                    // create array of triggered dispatch
                    DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                    arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
                    
                    // Invoke SOAP request and get response.
                    DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
                    oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
                    
                     //Start PD-9012
                     for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                        if(oDataResponseDet.Result == 'SuccessUpdating' || oDataResponseDet.Result == 'SuccessInserting'){
                             // create task for succesfull notification.
                            lstTask = createNotificationTask(oDataImportResponse, mapSubscriptionEmail, sCountryLanguage, Label.LS_Communicator_Payment_Success_Email_Task_Subject);
                        }
                        else{ 
                            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmail, Label.Webservice_Failed,Label.Webservice_Failed);            
                        } 
                    }
                    //End PD-9012  
                    
                    if(lstTask !=null && !lstTask.isEmpty()){
                        lstTaskAll.addAll(lstTask);
                    }
                }
                if(lstTaskAll !=null && !lstTaskAll.isEmpty()){
                    insert lstTaskAll;
                }            
            }
        }catch (Exception ex){  
            //Start PD-9012
            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmail, Label.Webservice_Failed,ex.getMessage());            
            //End PD-9012
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendSuccessfulPaymentNotification', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }*/
    
    /*
        Description : Email to be sent about the end of subscription - commented out according to PD-12102
    */
    /*public static void sendSubscriptionEndNotification(Map<String,List<WrapCommunicatorEmail>> mapSubscriptionEmail){
        try{
             Integer dispatchId;
            List<DataService.ColumnMapping> lstColumnMapping = null;
            List<DataService.DataRecord> lstDataRecord = null;
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
            List<Task> lstTaskAll = null;
            List<Task> lstTask = null;
            if(mapSubscriptionEmail!= null && !mapSubscriptionEmail.isEmpty()){
            lstTaskAll = new List<Task>();
                
                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;
                
                for(String sCountryLanguage : mapSubscriptionEmail.keySet()){
                    lstDataRecord = new List<DataService.DataRecord>();                                

                    //get the disptach id based on language 
                    dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Subscription_End_'+ sCountryLanguage).Value__c); 

                    //iterate through the list of wrapper  class
                    for(WrapCommunicatorEmail objWrap : mapSubscriptionEmail.get(sCountryLanguage)){
                        lstColumnMapping = new List<DataService.ColumnMapping>();
                        
                        lstColumnMapping.add(getColumn(SalesforceColumnID, objWrap.Id));
                        lstColumnMapping.add(getColumn(EmailColumnID, objWrap.Email));
                        lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(objWrap.NotificaitonLanguageCode)));
                        lstColumnMapping.add(getColumn(NotificationLanguageColumnID, objWrap.NotificaitonLanguageCode));
                        lstColumnMapping.add(getColumn(NotificationCountryColumnID, objWrap.NotificationCountryCode));
                        lstColumnMapping.add(getColumn(CountryLanguageColumnID, objWrap.NotificationCountryCode + '_' + objWrap.NotificaitonLanguageCode));

                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                        arrColumnMap.ColumnMapping = lstColumnMapping;
                        
                        // set subscription
                        List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
                        lstSubscription.add(getSubscription(MailingListID, true, false));
                        
                        // create array of subscription
                        DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                        arrSubscription.Subscription = lstSubscription;
                        
                        // Prepare data record
                        lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                    }
                    // create list of triggered dispatch
                    lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
                    lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
                    
                    // create array of data records.
                    DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                    arrDataRecords.DataRecord = lstDataRecord;
                    
                    // create array of triggered dispatch
                    DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                    arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
                    
                    // Invoke SOAP request and get response.
                    DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
                    oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
                    
                     //Start PD-9012
                     for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                        if(oDataResponseDet.Result == 'SuccessUpdating' || oDataResponseDet.Result == 'SuccessInserting'){
                             // create task for succesfull notification.
                            lstTask = createNotificationTask(oDataImportResponse, mapSubscriptionEmail, sCountryLanguage, Label.LS_Communicator_Subscription_End_Email_Task_Subject);
                        }
                        else{ 
                            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmail, Label.Webservice_Failed,Label.Webservice_Failed);            
                        } 
                    }
                    //End PD-9012 
                    
                    if(lstTask !=null && !lstTask.isEmpty()){
                        lstTaskAll.addAll(lstTask);
                    }
                }
                if(lstTaskAll !=null && !lstTaskAll.isEmpty()){
                   insert lstTaskAll;
                }            
            }
            isErrorDuringEmailSending = false;
        }catch (Exception ex){
            isErrorDuringEmailSending = true;
            //Start PD-9012
            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmail, Label.Webservice_Failed,ex.getMessage());            
            //End PD-9012
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendSubscriptionEndNotification', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }*/
    
     /*
        Description : Email to be sent when a new device is connected
    */
    public static void sendNewDeviceConnected(Map<String,List<WrapCommunicatorEmail>> mapSubscriptionEmail){    
        try{
            Integer dispatchId;
            List<DataService.ColumnMapping> lstColumnMapping = null;
            List<DataService.DataRecord> lstDataRecord = null;
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
            List<Task> lstTaskAll = null;
            List<Task> lstTask = null;
            
            if(mapSubscriptionEmail!= null && !mapSubscriptionEmail.isEmpty()){
                lstTaskAll = new List<Task>();
                
                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;
                
                for(String sCountryLanguage : mapSubscriptionEmail.keySet()){
                    lstDataRecord = new List<DataService.DataRecord>();            

                    //get the disptach id based on language 
                    dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_New_Device_'+ sCountryLanguage).Value__c); 

                    //iterate through the list of wrapper  class
                    for(WrapCommunicatorEmail objWrap : mapSubscriptionEmail.get(sCountryLanguage)){
                        lstColumnMapping = new List<DataService.ColumnMapping>();
                        
                        lstColumnMapping.add(getColumn(SalesforceColumnID, objWrap.Id));
                        lstColumnMapping.add(getColumn(EmailColumnID, objWrap.Email));
                        lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(objWrap.NotificaitonLanguageCode)));
                        lstColumnMapping.add(getColumn(NotificationLanguageColumnID, objWrap.NotificaitonLanguageCode));
                        lstColumnMapping.add(getColumn(NotificationCountryColumnID, objWrap.NotificationCountryCode));
                        lstColumnMapping.add(getColumn(CountryLanguageColumnID, objWrap.NotificationCountryCode + '_' + objWrap.NotificaitonLanguageCode));
                        
                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                        arrColumnMap.ColumnMapping = lstColumnMapping;
                        
                        // set subscription
                        List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
                        lstSubscription.add(getSubscription(MailingListID, true, false));
                        
                        // create array of subscription
                        DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                        arrSubscription.Subscription = lstSubscription;
                        
                        // Prepare data record
                        lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                    }
                    // create list of triggered dispatch
                    lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
                    lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
                    
                    // create array of data records.
                    DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                    arrDataRecords.DataRecord = lstDataRecord;
                    
                    // create array of triggered dispatch
                    DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                    arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
                    
                    // Invoke SOAP request and get response.
                    DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
                    oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
                    
                     //Start PD-9012
                     for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                        if(oDataResponseDet.Result == 'SuccessUpdating' || oDataResponseDet.Result == 'SuccessInserting'){
                             // create task for succesfull notification.
                            lstTask = createNotificationTask(oDataImportResponse, mapSubscriptionEmail, sCountryLanguage, Label.LS_Communicator_New_Device_SignIn_Email_Task_Subject);
                        }
                        else{ 
                            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmail, Label.Webservice_Failed,Label.Webservice_Failed);            
                        } 
                    }
                    //End PD-9012 
                    
                    if(lstTask !=null && !lstTask.isEmpty()){
                        lstTaskAll.addAll(lstTask);
                    }
                }
                if(lstTaskAll !=null && !lstTaskAll.isEmpty()){
                    insert lstTaskAll;
                }            
            }
        }catch (Exception ex){      
            //Start PD-9012
            CommunicatorFailureWebservice.createNotificationTask(mapSubscriptionEmail, Label.Webservice_Failed,ex.getMessage());            
            //End PD-9012
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendNewDeviceConnected', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }
    
     /*
        Description : Method to update account in communicator.
    */
    /* Commented out according to PD-11495: new metnod is CommunicatorIntegrationHelper.handleDataImportEmailSyncRecords()
    public static void upsertAccountInformationInCommunicator(List<Account> lstAccount){  
        system.debug('lstAccount--------------->'+lstAccount);
        List<DataService.ColumnMapping> lstColumnMapping = null;
        List<DataService.DataRecord> lstDataRecord = null;
        String sCountries = '';
        Set<String> setDoubleOptInCountry = new Set<String>();
        DAZNConfiguration__c oDoubleOptinConfig = null;
        
        List<Account> lstUpdateAccount = new List<Account>();
        try{
            
            
            if(lstAccount!= null && !lstAccount.isEmpty()){
                oDoubleOptinConfig = DAZNConfiguration__c.getValues('DoubleOptInCountries');
                
                if(oDoubleOptinConfig != null){
                    sCountries = oDoubleOptinConfig.value__c;           
                    setDoubleOptInCountry.addAll(sCountries.split(','));    
                }
                //iterate through the list of account
                lstDataRecord = new List<DataService.DataRecord>();            
                for(Account oAccount : lstAccount){
                    lstColumnMapping = new List<DataService.ColumnMapping>();
                    
                    //PD-8706  
                    if(oAccount.Hard_Offer_date__c!=null ){
                        DateTime strDate = oAccount.Hard_Offer_date__c;
                        String strTempDate = String.ValueOf(strDate);
                        String[] tempStringArray = strTempDate.split(' ');                    
                        String strTime = tempStringArray[1];
                        String strDate2 = tempStringArray[0];                    
                        String[] tempStringDateArray = strDate2.split('-');
                        String strDay = tempStringDateArray[2];
                        String strMonth = tempStringDateArray[1];
                        String strYear = tempStringDateArray[0];                    
                        String finalStr = strDay+'/'+strMonth+'/'+strYear+' ' + strTime;
                        lstColumnMapping.add(getColumn(HardOfferColumnID, finalStr));                        
                    }
                    // End PD-8706                    
                    lstColumnMapping.add(getColumn(SalesforceColumnID, oAccount.id));
                    lstColumnMapping.add(getColumn(EmailColumnID, oAccount.personemail));
                    lstColumnMapping.add(getColumn(FirstNameColumnID, oAccount.FirstName));                    
                    lstColumnMapping.add(getColumn(LastNameColumnID, oAccount.LastName));
                    lstColumnMapping.add(getColumn(AccountStatusColumnID, oAccount.Account_Status__c));
                    lstColumnMapping.add(getColumn(NotificationLanguageColumnID, oAccount.Notification_Language_Code__c));
                    lstColumnMapping.add(getColumn(NotificationCountryColumnID, oAccount.Notification_Country_Code__c));
                    lstColumnMapping.add(getColumn(CountryLanguageColumnID, oAccount.Notification_Country_Code__c + '_' + oAccount.Notification_Language_Code__c));
                    lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(oAccount.Notification_Language_Code__c)));                    
                    
                    // create array of data column mapping
                    DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                     
                    arrColumnMap.ColumnMapping = lstColumnMapping;
                    
                    // set subscription
                    List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();   
                    
                    if(!setDoubleOptInCountry.isEmpty() && setDoubleOptInCountry.contains(oAccount.Notification_Country_Code__c)){
                        
                        //PD-8211 changes has been done here//
						   lstSubscription.add(getSubscription(GermanyMarketingMailingListID,(oAccount.All_Email_Preferences__c!=null?oAccount.All_Email_Preferences__c:false), false));
                        lstSubscription.add(getSubscription(MarketingMailingListID, (oAccount.Is_Double_OptIn__c!=null?oAccount.Is_Double_OptIn__c:false), false));
                            
                    }
					else{
                         
                        lstSubscription.add(getSubscription(MarketingMailingListID, (oAccount.All_Email_Preferences__c!=null?oAccount.All_Email_Preferences__c:false), false));
                    } 
                    
                    // create array of subscription
                    DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                    arrSubscription.Subscription = lstSubscription;
                    
                    // Prepare data record
                    lstDataRecord.add(getDataRecord(arrColumnMap, arrSubscription, false));
                    
                }
            }
                  
            // create array of data records.
            DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
            arrDataRecords.DataRecord = lstDataRecord;            
           // set the credentials
            DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
            oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds(); 
            oDataServiceSoap.timeout_x = iAPITimeOutLimit;
            
            // Invoke SOAP request and get response.
            DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
            oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, null));
            
            // Check record sync status and prepare a set of failure record id's.
            Set<Id> setFailedAccountId = new Set<Id>();
            for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                
                if(oDataResponseDet.Result!=null && oDataResponseDet.Result != 'SuccessUpdating' && oDataResponseDet.Result != 'SuccessInserting'){
                    
                    for(DataService.ColumnMapping oColumn : oDataResponseDet.Mappings.ColumnMapping){
                       if(oColumn.ColumnId == SalesforceColumnID){
                           setFailedAccountId.add(oColumn.Value);
                           //fix for PD-8703
                           Account oAccount = new Account(Id = oColumn.Value,Error_In_Contact_sync__c = true,  IsReadyToSyncInCommunicator__c = false, Sync_Error_Msg__c = oDataResponseDet.Result + 'with result '+oDataResponseDet.Response+ ' for row '+oColumn.Value);
                           lstUpdateAccount.add(oAccount);
                           ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'upsertAccountInformationInCommunicator', 'Upsert to Communicator failed', 
                           'Upsert to communicator failed', oDataResponseDet.Result + ' : '+oDataResponseDet.Response);
                           
                       }
                    }
                }
                        
                
            }
            
            
            for(Account oAccount : lstAccount){
                if(!setFailedAccountId.contains(oAccount.Id)){
                    
                    oAccount.IsReadyToSyncInCommunicator__c = false;
                    lstUpdateAccount.add(oAccount);
                    
                }
            }
            
            // Update accounts in salesforce to uncheck the sync flag.
            if(lstUpdateAccount != null && !lstUpdateAccount.isEmpty())
                update lstUpdateAccount;
        } catch(Exception ex){
            system.debug('ex==========>'+ex);
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'upsertAccountInformationInCommunicator', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());     
        }
    }*/

    /* PD-11495: Method updates account in communicator using Email_Sync_Queue__c records */
    public static void handleDataImportEmailSyncRecords(List<Email_Sync_Queue__c> dataImportEmailQueueList, Map<String, Set<Id>> statusEmailQueueIdsMap, Map<Id, String> emailSyncQueueIdErrorMap) {
        Map<Id, String> accountIdErrorMap = new Map<Id, String>();
        if (dataImportEmailQueueList != null && !dataImportEmailQueueList.isEmpty()) {
            List<DataService.ColumnMapping> lstColumnMapping = null;
            List<DataService.DataRecord> lstDataRecord = null;
            String sCountries = '';
            Set<String> setDoubleOptInCountry = new Set<String>();
            DAZNConfiguration__c oDoubleOptinConfig = null;

            Set<Id> completedEmailQueueIds = new Set<Id>();
            
            /* if we have data importer rows more than once of a single account, then just take the latest of those records, rather than all of them to be upserted to communicator. */
            List<Email_Sync_Queue__c> uniqueDataImportEmailQueueList = new List<Email_Sync_Queue__c>();
            Map<Id, Email_Sync_Queue__c> accountIdlatestEmailSyncQueueMap = new Map<Id, Email_Sync_Queue__c>();
            for (Email_Sync_Queue__c emailSync : dataImportEmailQueueList) {
                accountIdlatestEmailSyncQueueMap.put(emailSync.Account__c, emailSync);
            }
            uniqueDataImportEmailQueueList.addAll(accountIdlatestEmailSyncQueueMap.values());
            /* end */

            Set<Id> setFailedAccountIds = new Set<Id>(); // strores failed Account Ids handled in  Communicator.
            try {
                if (uniqueDataImportEmailQueueList != null && !uniqueDataImportEmailQueueList.isEmpty()) {
                    oDoubleOptinConfig = DAZNConfiguration__c.getValues('DoubleOptInCountries');

                    if (oDoubleOptinConfig != null) {
                        sCountries = oDoubleOptinConfig.value__c;
                        setDoubleOptInCountry.addAll(sCountries.split(','));
                    }
                    //iterate through the list of account
                    lstDataRecord = new List<DataService.DataRecord>();

                    for (Email_Sync_Queue__c emailQueueItem : uniqueDataImportEmailQueueList) {
                        lstColumnMapping = new List<DataService.ColumnMapping>();
                        
                        //PD-8706  
                        if (emailQueueItem.Hard_Offer_date__c != null) {
                            DateTime strDate = emailQueueItem.Hard_Offer_date__c;
                            String strTempDate = String.ValueOf(strDate);
                            String[] tempStringArray = strTempDate.split(' ');
                            String strTime = tempStringArray[1];
                            String strDate2 = tempStringArray[0];
                            String[] tempStringDateArray = strDate2.split('-');
                            String strDay = tempStringDateArray[2];
                            String strMonth = tempStringDateArray[1];
                            String strYear = tempStringDateArray[0];
                            String finalStr = strDay + '/' + strMonth + '/' + strYear + ' ' + strTime;
                            lstColumnMapping.add(getColumn(HardOfferColumnID, finalStr));
                        }
                        // End PD-8706
                        lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
                        lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
                        lstColumnMapping.add(getColumn(FirstNameColumnID, emailQueueItem.First_Name__c));
                        lstColumnMapping.add(getColumn(LastNameColumnID, emailQueueItem.Last_Name__c));
                        lstColumnMapping.add(getColumn(AccountStatusColumnID, emailQueueItem.Account_Status__c));
                        lstColumnMapping.add(getColumn(PreviousStatusColumnID, emailQueueItem.Account__r.Previous_Status__c));
                        if (emailQueueItem.Account__r.Status_Change_Date__c != NULL) {
                          lstColumnMapping.add(getColumn(StatusChangeDateColumnID, getStringFromDateTime(emailQueueItem.Account__r.Status_Change_Date__c)));
                        }
                        lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
                        lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
                        lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
                        lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));

                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();

                        arrColumnMap.ColumnMapping = lstColumnMapping;

                        // set subscription
                        List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();

                        lstSubscription.add(getSubscription(MailingListID, true, false));
                        if (!setDoubleOptInCountry.isEmpty() && setDoubleOptInCountry.contains(emailQueueItem.Notification_Country_Code__c)) {
                            //PD-8211 changes has been done here//
                            lstSubscription.add(getSubscription(GermanyMarketingMailingListID, (emailQueueItem.All_Email_Preferences__c != null ? emailQueueItem.All_Email_Preferences__c : false), false));
                            lstSubscription.add(getSubscription(MarketingMailingListID, (emailQueueItem.Is_Double_Opt_in__c != null ? emailQueueItem.Is_Double_Opt_in__c : false), false));
                        } else {
                            lstSubscription.add(getSubscription(MarketingMailingListID, (emailQueueItem.All_Email_Preferences__c != null ? emailQueueItem.All_Email_Preferences__c : false), false));
                        }

                        // create array of subscription
                        DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                        arrSubscription.Subscription = lstSubscription;
                        // Prepare data record
                        lstDataRecord.add(getDataRecord(arrColumnMap, arrSubscription, false));
                    }
                }

                // create array of data records.
                DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                arrDataRecords.DataRecord = lstDataRecord;
                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds(); 
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;

                // Invoke SOAP request and get response.
                DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
                oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, null));

                // Check record sync status and prepare a set of failure record id's.
                for (DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail) {
                    if (oDataResponseDet.Result !=null && oDataResponseDet.Result != 'SuccessUpdating' && oDataResponseDet.Result != 'SuccessInserting') {
                        for (DataService.ColumnMapping oColumn : oDataResponseDet.Mappings.ColumnMapping) {
                           if (oColumn.ColumnId == SalesforceColumnID) {
                               setFailedAccountIds.add(oColumn.Value);
                               accountIdErrorMap.put(oColumn.Value, oDataResponseDet.Result + ' with result ' + oDataResponseDet.Response + ' for row ' + oColumn.Value);
                           }
                        }
                    }
                }

                for (Email_Sync_Queue__c emailQueueItem : uniqueDataImportEmailQueueList) {
                    if (!setFailedAccountIds.contains(emailQueueItem.Account__c)) {
                         statusEmailQueueIdsMap.get('Completed').add(emailQueueItem.Id);
                         completedEmailQueueIds.add(emailQueueItem.Id);
                    } else {
                        statusEmailQueueIdsMap.get('Failed').add(emailQueueItem.Id);
                        if (accountIdErrorMap.get(emailQueueItem.Account__c) != null) {
                            emailSyncQueueIdErrorMap.put(emailQueueItem.Id, accountIdErrorMap.get(emailQueueItem.Account__c));
                        }
                    }
                }
            } catch (Exception ex) {
                for (Email_Sync_Queue__c emailQueueItem : uniqueDataImportEmailQueueList) {
                    if (!completedEmailQueueIds.contains(emailQueueItem.Id)) {
                        setFailedAccountIds.add(emailQueueItem.Account__c);
                        statusEmailQueueIdsMap.get('Failed').add(emailQueueItem.Id);
                        if (accountIdErrorMap.get(emailQueueItem.Account__c) != null) {
                            emailSyncQueueIdErrorMap.put(emailQueueItem.Id, accountIdErrorMap.get(emailQueueItem.Account__c));
                        } else {
                            emailSyncQueueIdErrorMap.put(emailQueueItem.Id, '\nERROR TYPE: ' + ex.getTypeName() + '\nERROR: ' + ex.getMessage() + '\nSTACK TRACE: ' + ex.getStackTraceString());
                        }
                    }
                }
            }
            for (Email_Sync_Queue__c emailSync : dataImportEmailQueueList) {
                if (setFailedAccountIds.contains(emailSync.Account__c)) {
                    statusEmailQueueIdsMap.get('Failed').add(emailSync.Id);
                    if (accountIdErrorMap.get(emailSync.Account__c) != null) {
                        emailSyncQueueIdErrorMap.put(emailSync.Id, accountIdErrorMap.get(emailSync.Account__c));
                    }
                } else {
                    statusEmailQueueIdsMap.get('Completed').add(emailSync.Id);
                }
            }
        }
    }

	/* PD-11495: Method sends double opt in email to users in Communicator using Email_Sync_Queue__c records */
    /* PD-11495: Method sends double opt in email to users in Communicator using Email_Sync_Queue__c records */
    public static void handleTriggeredDispatchEmailSyncRecords(List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList, Map<String, Set<Id>> statusEmailQueueIdsMap, Map<Id, String> emailSyncQueueIdErrorMap) {
        Map<Id, String> accountIdErrorMap = new Map<Id, String>();
        Map<Id, String> emailQueueIdErrorMap = new Map<Id, String>();
        if (triggeredDispatchEmailQueueList != null && !triggeredDispatchEmailQueueList.isEmpty()) {
            Integer dispatchId;
            Set<Id> processedEmailQueueIds = new Set<Id>();
            try {
                Map<String, String> dispatchNameValueMap = createDispatchNameValueMap(); // dispatchNameValueMap to distinguish logic for each dispatchId
                
                List<DataService.ColumnMapping> lstColumnMapping = null;
                List<DataService.DataRecord> lstDataRecord = null;
                List<DataService.TriggeredDispatch> lstTriggeredDispatch = null;

                if (triggeredDispatchEmailQueueList != null && !triggeredDispatchEmailQueueList.isEmpty()) {
                    Set<Id> setFailedAccountIds = new Set<Id>();
                    Set<Id> setFailedEmailQueueIds = new Set<Id>();
                    Set<Id> setRetriedEmailQueueIds = new Set<Id>();

                    // set the credentials
                    DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                    oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                    oDataServiceSoap.timeout_x = iAPITimeOutLimit;
                    
                    Map<String, List<Email_Sync_Queue__c>> dispatchIdEmailQueueMap = new Map<String, List<Email_Sync_Queue__c>>(); // Map: DispatchId -> List<Email_Sync_Queue__c>
                    Map<String, List<Email_Sync_Queue__c>> initialDispatchIdEmailQueueMap = new Map<String, List<Email_Sync_Queue__c>>();
                    populateDispatchIdEmailQueueMaps(triggeredDispatchEmailQueueList, dispatchIdEmailQueueMap, initialDispatchIdEmailQueueMap); // populates dispatchIdEmailQueueMap and initialDispatchIdEmailQueueMap Maps for grouping Email Sync Queue records by DispatchId

                    // PD-10958: start
                    Map<Id, String> accountIdSubAmountMap = new Map<Id, String>(); // Map which stores AccountId -> Subscription's Amount (MRR__c or TCV__c depending on TermSettingType__c)
                    Map<Id, Date> accountIdNextChargeDateMap = new Map<Id, Date>(); // Map which stores AccountId -> Next_Charge_Date__c from Zuora
                    Map<Id, Date> accountIdSubscriptionEndDate = new Map<Id, Date>(); // Map which stores AccountId -> Subscription End Date
                    Map<Id, String> accountIdBillingCurrencyMap = new Map<Id, String>(); // Map which stores AccountId -> Zuora__CustomerAccount__c.Zuora__Currency__c
                    Map<Id, String> accountIdSubTermType = new Map<Id, String>(); // Map which stores AccountId -> Zuora__Subscription__c.Zuora__TermSettingType__c from Zuora
                    Map<Id, String> accountIdSubSourceSystemMap = new Map<Id, String>(); // Map which stores AccountId -> Zuora__Subscription__c.SourceSystem__c from Zuora
                    Map<Id, String> accountIdCardExpirationTextMap = new Map<Id, String>(); // Map which stores AccountId -> Zuora__CustomerAccount__c.Zuora__CreditCard_Expiration__c from Zuora
                    Map<Id, String> accountIdPaymentMethodTypeMap = new Map<Id, String>(); // Map which stores AccountId -> Zuora__CustomerAccount__c.Zuora__PaymentMethod_Type__c from Zuora

                    Set<Id> accountIdsForQueryExtraInfo = populateAccountIdsForQueryExtraInfo(dispatchIdEmailQueueMap, dispatchNameValueMap); // Method populates Set Account Ids for which we need to query additional information
                    populateAccountInfoMaps(
                        accountIdsForQueryExtraInfo,
                        accountIdSubAmountMap,
                        accountIdNextChargeDateMap,
                        accountIdSubscriptionEndDate,
                        accountIdBillingCurrencyMap,
                        accountIdSubTermType,
                        accountIdSubSourceSystemMap,
                        accountIdCardExpirationTextMap,
                        accountIdPaymentMethodTypeMap
                    ); // PD-10958: Method populates Maps for Subscription's CMRR and ChargedThroughDate from Zuora by AccountIds
                    // PD-10958: end
                    handleHardOfferEmailSyncRecords(
                        dispatchIdEmailQueueMap,
                        dispatchNameValueMap,
                        accountIdSubTermType,
                        accountIdSubSourceSystemMap,
                        accountIdCardExpirationTextMap,
                        setRetriedEmailQueueIds,
                        setFailedEmailQueueIds,
                        emailQueueIdErrorMap
                    ); // populates DispathcId for 'hard Offer' Id for Annual and Monthly subscription

                    for (String aDispatchId : dispatchIdEmailQueueMap.keySet()) {
                        lstDataRecord = new List<DataService.DataRecord>();
                        dispatchId = Integer.valueOf(aDispatchId);

                        //iterate through the list of users for this language
                        for (Email_Sync_Queue__c emailQueueItem : dispatchIdEmailQueueMap.get(aDispatchId)) {
                            lstColumnMapping = new List<DataService.ColumnMapping>();
                            //populates List<DataService.ColumnMapping> lstColumnMapping depending on dispatchId
                            populateColumnMappingByDispatchId(
                                aDispatchId,
                                lstColumnMapping,
                                emailQueueItem,
                                dispatchNameValueMap,
                                accountIdSubAmountMap,
                                accountIdNextChargeDateMap,
                                accountIdSubscriptionEndDate,
                                accountIdBillingCurrencyMap,
                                accountIdCardExpirationTextMap,
                                accountIdPaymentMethodTypeMap
                            );
                            
                            // create array of data column mapping
                            DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                            arrColumnMap.ColumnMapping = lstColumnMapping;
                            
                            // set subscription
                            List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
                            if (aDispatchId == dispatchNameValueMap.get('DispatchID Double optin')) {
                                lstSubscription.add(getSubscription(GermanyMarketingMailingListID, true, false)); // GermanyMarketingMailingListID only for Double optin emails
                            } else {
                                lstSubscription.add(getSubscription(MailingListID, true, false));
                            }
                            
                            // create array of subscription
                            DataService.ArrayOfSubscription arrSubscription = new DataService.ArrayOfSubscription();
                            arrSubscription.Subscription = lstSubscription;
                            
                            // Prepare data record
                            lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                        }
                        // create list of triggered dispatch
                        lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
                        lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
                        
                        // create array of data records.
                        DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                        arrDataRecords.DataRecord = lstDataRecord;
                        
                        // create array of triggered dispatch
                        DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                        arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
                        
                        // Invoke SOAP request and get response.
                        DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
                        oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
                        // Check record sync status and prepare a set of failure record id's.
                        
                        for (DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail) {
                            if (oDataResponseDet.Result != 'SuccessUpdating' && oDataResponseDet.Result != 'SuccessInserting') {
                                for (DataService.ColumnMapping oColumn : oDataResponseDet.Mappings.ColumnMapping) {
                                    if (oColumn.ColumnId == SalesforceColumnID) {
                                        setFailedAccountIds.add(oColumn.Value);
                                        accountIdErrorMap.put(oColumn.Value, oDataResponseDet.Result + ' with result ' + oDataResponseDet.Response + ' for row ' + oColumn.Value);
                                    }
                                }
                            }
                        }
                    }
                    
                    for (String aDispatchId : initialDispatchIdEmailQueueMap.keySet()) {
                        for (Email_Sync_Queue__c emailQueueItem : initialDispatchIdEmailQueueMap.get(aDispatchId)) {
                            if (emailQueueIdErrorMap.get(emailQueueItem.Id) != NULL) {
                                if (setRetriedEmailQueueIds.contains(emailQueueItem.Id)) {
                                    statusEmailQueueIdsMap.get('Retried').add(emailQueueItem.Id);
                                    emailSyncQueueIdErrorMap.put(emailQueueItem.Id, emailQueueIdErrorMap.get(emailQueueItem.Id));
                                    processedEmailQueueIds.add(emailQueueItem.Id);
                                } else if (setFailedEmailQueueIds.contains(emailQueueItem.Id)) {
                                    statusEmailQueueIdsMap.get('Failed').add(emailQueueItem.Id);
                                    emailSyncQueueIdErrorMap.put(emailQueueItem.Id, emailQueueIdErrorMap.get(emailQueueItem.Id));
                                    processedEmailQueueIds.add(emailQueueItem.Id);
                                }
                            } else if (!setFailedAccountIds.contains(emailQueueItem.Account__c)) {
                                 statusEmailQueueIdsMap.get('Completed').add(emailQueueItem.Id);
                                 processedEmailQueueIds.add(emailQueueItem.Id);
                            } else {
                                statusEmailQueueIdsMap.get('Failed').add(emailQueueItem.Id);
                                if (accountIdErrorMap.get(emailQueueItem.Account__c) != null) {
                                    emailSyncQueueIdErrorMap.put(emailQueueItem.Id, accountIdErrorMap.get(emailQueueItem.Account__c));
                                }
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                for (Email_Sync_Queue__c emailQueueItem : triggeredDispatchEmailQueueList) {
                    if (!processedEmailQueueIds.contains(emailQueueItem.Id)) {
                        statusEmailQueueIdsMap.get('Failed').add(emailQueueItem.Id);
                        if (accountIdErrorMap.get(emailQueueItem.Account__c) != null) {
                            emailSyncQueueIdErrorMap.put(emailQueueItem.Id, accountIdErrorMap.get(emailQueueItem.Account__c));
                        } else {
                            emailSyncQueueIdErrorMap.put(emailQueueItem.Id, '\nERROR TYPE: ' + ex.getTypeName() + '\nERROR: ' + ex.getMessage() + '\nSTACK TRACE: ' + ex.getStackTraceString());
                        }
                    }
                }
            }
        }
    }
    
    /*
        Description: Method get DespatchId and according to it populates List<DataService.ColumnMapping> lstColumnMapping
    */
    public static void populateColumnMappingByDispatchId(String dispatchId,
                                                         List<DataService.ColumnMapping> lstColumnMapping,
                                                         Email_Sync_Queue__c emailQueueItem,
                                                         Map<String, String> dispatchNameValueMap,
                                                         Map<Id, String> accountIdSubAmountMap,
                                                         Map<Id, Date> accountIdNextChargeDateMap,
                                                         Map<Id, Date> accountIdSubscriptionEndDate,
                                                         Map<Id, String> accountIdBillingCurrencyMap,
                                                         Map<Id, String> accountIdCardExpirationTextMap,
                                                         Map<Id, String> accountIdPaymentMethodTypeMap) {

        if (dispatchId == dispatchNameValueMap.get('DispatchID Double optin')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Set_Edit_Pause_Confirmation')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(CurrencyColumnID, CommunityHelper.getCurrencySymbol(emailQueueItem.Account_Currency__c)));
            lstColumnMapping.add(getColumn(AccountStatusColumnID, emailQueueItem.Account_Status__c));
            lstColumnMapping.add(getColumn(FirstNameColumnID, emailQueueItem.First_Name__c));
            lstColumnMapping.add(getColumn(LastNameColumnID, emailQueueItem.Last_Name__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(PauseFromColumnID, getStringFromDate(emailQueueItem.Pause_From__c)));
            lstColumnMapping.add(getColumn(PauseUntilColumnID, getStringFromDate(emailQueueItem.Pause_Until__c)));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Cancelling_Scheduled_Pause')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(CurrencyColumnID, CommunityHelper.getCurrencySymbol(emailQueueItem.Account_Currency__c)));
            lstColumnMapping.add(getColumn(AccountStatusColumnID, emailQueueItem.Account_Status__c));
            lstColumnMapping.add(getColumn(FirstNameColumnID, emailQueueItem.First_Name__c));
            lstColumnMapping.add(getColumn(LastNameColumnID, emailQueueItem.Last_Name__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(PlanDetailsColumnID, emailQueueItem.Plan_Details__c));
            lstColumnMapping.add(getColumn(FirstMonthlySubscriptAmountColumnID, accountIdSubAmountMap.get(emailQueueItem.Account__c)));
            lstColumnMapping.add(getColumn(RebillDateColumnID, getStringFromDate(emailQueueItem.Rebill_Date__c)));
            lstColumnMapping.add(getColumn(PauseFromColumnID, getStringFromDate(emailQueueItem.Pause_From__c)));
            lstColumnMapping.add(getColumn(PauseUntilColumnID, getStringFromDate(emailQueueItem.Pause_Until__c)));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_EditingRestartDate_In_Pause')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(AccountStatusColumnID, emailQueueItem.Account_Status__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(PauseFromColumnID, getStringFromDate(emailQueueItem.Pause_From__c)));
            lstColumnMapping.add(getColumn(PauseUntilColumnID, getStringFromDate(emailQueueItem.Pause_Until__c)));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Welcome_Back_From_Pause')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(CurrencyColumnID, CommunityHelper.getCurrencySymbol(accountIdBillingCurrencyMap.get(emailQueueItem.Account__c))));
            lstColumnMapping.add(getColumn(SubscriptionAmountColumnID, accountIdSubAmountMap.get(emailQueueItem.Account__c)));
            lstColumnMapping.add(getColumn(PaymentMethodTypeColumnID, emailQueueItem.Payment_Method_Type__c));
            lstColumnMapping.add(getColumn(AccountStatusColumnID, emailQueueItem.Account_Status__c));
            lstColumnMapping.add(getColumn(FirstNameColumnID, emailQueueItem.First_Name__c));
            lstColumnMapping.add(getColumn(LastNameColumnID, emailQueueItem.Last_Name__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(PlanDetailsColumnID, emailQueueItem.Plan_Details__c));
            lstColumnMapping.add(getColumn(FreeTrialEndDateColumnID, getStringFromDate(emailQueueItem.Free_Trial_End_Date__c)));
            lstColumnMapping.add(getColumn(PauseFromColumnID, getStringFromDate(emailQueueItem.Pause_From__c)));
            lstColumnMapping.add(getColumn(PauseUntilColumnID, getStringFromDate(emailQueueItem.Pause_Until__c)));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Free_Trial_Welcome') || dispatchId == dispatchNameValueMap.get('DispatchID_Apple_Free_Trial_Welcome') || dispatchId == dispatchNameValueMap.get('DispatchID_Roku_Free_Trial_Welcome')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(FirstNameColumnID, emailQueueItem.First_Name__c));
            lstColumnMapping.add(getColumn(CurrencyColumnID, CommunityHelper.getCurrencySymbol(emailQueueItem.Account_Currency__c)));
            lstColumnMapping.add(getColumn(SubscriptionAmountColumnID, String.valueOf(emailQueueItem.Subscription_Amount__c)));
            lstColumnMapping.add(getColumn(PlanDetailsColumnID, emailQueueItem.Plan_Details__c));
            lstColumnMapping.add(getColumn(PaymentMethodTypeColumnID, accountIdPaymentMethodTypeMap.get(emailQueueItem.Account__c)));
            lstColumnMapping.add(getColumn(FreeTrialEndDateColumnID, getStringFromDate(emailQueueItem.Free_Trial_End_Date__c)));
            lstColumnMapping.add(getColumn(RebillDateColumnID, getStringFromDate(emailQueueItem.Rebill_Date__c)));
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(CardExpiryTextColumnID, accountIdCardExpirationTextMap.get(emailQueueItem.Account__c)));
            lstColumnMapping.add(getColumn(CardExpiryDateColumnID, getLastMonthDay(accountIdCardExpirationTextMap.get(emailQueueItem.Account__c))));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_User_Cancel')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(SubscriptionEndDateColumnID, getStringFromDate(emailQueueItem.Subscription_End_Date__c)));
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(SubscriptionAmountColumnID, String.valueOf(emailQueueItem.Subscription_Amount__c)));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Hard_Offer_Welcome') || dispatchId == dispatchNameValueMap.get('DispatchID_Apple_Hard_Offer_Welcome') || dispatchId == dispatchNameValueMap.get('DispatchID_Roku_Hard_Offer_Welcome')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(FirstNameColumnID, emailQueueItem.First_Name__c));
            lstColumnMapping.add(getColumn(SignInLinkColumnID, DAZNConfiguration__c.getValues('LoginPageURL').Value__c));
            lstColumnMapping.add(getColumn(RebillDateColumnID, getStringFromDate(accountIdNextChargeDateMap.get(emailQueueItem.Account__c))));
            lstColumnMapping.add(getColumn(PlanDetailsColumnID, emailQueueItem.Plan_Details__c));
            lstColumnMapping.add(getColumn(PaymentMethodTypeColumnID, accountIdPaymentMethodTypeMap.get(emailQueueItem.Account__c)));
            lstColumnMapping.add(getColumn(SubscriptionAmountColumnID, accountIdSubAmountMap.get(emailQueueItem.Account__c)));
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(CardExpiryTextColumnID, accountIdCardExpirationTextMap.get(emailQueueItem.Account__c)));
            lstColumnMapping.add(getColumn(CardExpiryDateColumnID, getLastMonthDay(accountIdCardExpirationTextMap.get(emailQueueItem.Account__c))));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Payment_Failure')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Payment_Successful')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Free_Trial_Welcome_Termed')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(FirstNameColumnID, emailQueueItem.First_Name__c));
            lstColumnMapping.add(getColumn(LastNameColumnID, emailQueueItem.Last_Name__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(SubscriptionEndDateColumnID, getStringFromDate(emailQueueItem.Subscription_End_Date__c)));
            lstColumnMapping.add(getColumn(FreeTrialEndDateColumnID, getStringFromDate(emailQueueItem.Free_Trial_End_Date__c)));
            lstColumnMapping.add(getColumn(AnnualSubscriptionAmountColumnID, String.valueOf(emailQueueItem.Subscription_Amount__c)));
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(PlanDetailsColumnID, emailQueueItem.Plan_Details__c));
            lstColumnMapping.add(getColumn(PaymentMethodTypeColumnID, accountIdPaymentMethodTypeMap.get(emailQueueItem.Account__c)));
            lstColumnMapping.add(getColumn(CardExpiryTextColumnID, accountIdCardExpirationTextMap.get(emailQueueItem.Account__c)));
            lstColumnMapping.add(getColumn(CardExpiryDateColumnID, getLastMonthDay(accountIdCardExpirationTextMap.get(emailQueueItem.Account__c))));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Hard_Offer_Welcome_Termed')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(FirstNameColumnID, emailQueueItem.First_Name__c));
            lstColumnMapping.add(getColumn(LastNameColumnID, emailQueueItem.Last_Name__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(SubscriptionEndDateColumnID, getStringFromDate(accountIdSubscriptionEndDate.get(emailQueueItem.Account__c))));
            lstColumnMapping.add(getColumn(RebillDateColumnID, getStringFromDate(accountIdNextChargeDateMap.get(emailQueueItem.Account__c))));
            lstColumnMapping.add(getColumn(AnnualSubscriptionAmountColumnID, accountIdSubAmountMap.get(emailQueueItem.Account__c)));
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(PaymentMethodTypeColumnID, accountIdPaymentMethodTypeMap.get(emailQueueItem.Account__c)));
            lstColumnMapping.add(getColumn(CardExpiryTextColumnID, accountIdCardExpirationTextMap.get(emailQueueItem.Account__c)));
            lstColumnMapping.add(getColumn(CardExpiryDateColumnID, getLastMonthDay(accountIdCardExpirationTextMap.get(emailQueueItem.Account__c))));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Updated_Name')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));
            lstColumnMapping.add(getColumn(FirstNameColumnID, emailQueueItem.First_Name__c));
            lstColumnMapping.add(getColumn(LastNameColumnID, emailQueueItem.Last_Name__c));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Updated_Payment')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(PaymentMethodTypeColumnID, accountIdPaymentMethodTypeMap.get(emailQueueItem.Account__c)));
            lstColumnMapping.add(getColumn(CardExpiryTextColumnID, accountIdCardExpirationTextMap.get(emailQueueItem.Account__c)));
            lstColumnMapping.add(getColumn(CardExpiryDateColumnID, getLastMonthDay(accountIdCardExpirationTextMap.get(emailQueueItem.Account__c))));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Immediate_Cancellation')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(SubscriptionEndDateColumnID, getStringFromDate(emailQueueItem.Subscription_End_Date__c)));
            lstColumnMapping.add(getColumn(SubscriptionAmountColumnID, String.valueOf(emailQueueItem.Subscription_Amount__c)));
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Paused_Cancellation')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(SubscriptionEndDateColumnID, getStringFromDate(emailQueueItem.Subscription_End_Date__c)));
            lstColumnMapping.add(getColumn(SubscriptionAmountColumnID, String.valueOf(emailQueueItem.Subscription_Amount__c)));
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Payment_Failed_User_Frozen')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(SubscriptionEndDateColumnID, getStringFromDate(emailQueueItem.Subscription_End_Date__c)));
            lstColumnMapping.add(getColumn(SubscriptionAmountColumnID, String.valueOf(emailQueueItem.Subscription_Amount__c)));
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
        } else if (dispatchId == dispatchNameValueMap.get('DispatchID_Gift_Code_Success')) {
            lstColumnMapping.add(getColumn(SalesforceColumnID, emailQueueItem.Account__c));
            lstColumnMapping.add(getColumn(FirstNameColumnID, emailQueueItem.First_Name__c));
            lstColumnMapping.add(getColumn(LastNameColumnID, emailQueueItem.Last_Name__c));
            lstColumnMapping.add(getColumn(EmailColumnID, emailQueueItem.Person_Email__c));
            lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(emailQueueItem.Notification_Language_Code__c)));
            lstColumnMapping.add(getColumn(NotificationLanguageColumnID, emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(NotificationCountryColumnID, emailQueueItem.Notification_Country_Code__c));
            lstColumnMapping.add(getColumn(CountryLanguageColumnID, emailQueueItem.Notification_Country_Code__c + '_' + emailQueueItem.Notification_Language_Code__c));
            lstColumnMapping.add(getColumn(FreeTrialEndDateColumnID, getStringFromDate(emailQueueItem.Free_Trial_End_Date__c)));
            lstColumnMapping.add(getColumn(RebillDateColumnID, getStringFromDate(emailQueueItem.Rebill_Date__c)));
            lstColumnMapping.add(getColumn(CurrencyColumnID, CommunityHelper.getCurrencySymbol(emailQueueItem.Account_Currency__c)));
            lstColumnMapping.add(getColumn(GiftCodeExpiryDateColumnID, getStringFromDate(emailQueueItem.Gift_Code_Expiry_Date__c)));
            if (emailQueueItem.Term_Setting_Type__c == 'EVERGREEN') {
                lstColumnMapping.add(getColumn(FirstMonthlySubscriptAmountColumnID, String.valueOf(emailQueueItem.Subscription_Amount__c)));
            } else if (emailQueueItem.Term_Setting_Type__c == 'TERMED') {
                lstColumnMapping.add(getColumn(AnnualSubscriptionAmountColumnID, String.valueOf(emailQueueItem.Subscription_Amount__c)));
            }
        }
    }
    
    /*
        Description: Method populates Map: Dispatch Id -> Integer value
    */
    public static Map<String, String> createDispatchNameValueMap() {
        Integer dispatchIdDoubleOptIn = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID Double optin').Value__c);
        Integer dispatchIdSetEditPauseConfirm = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Set_Edit_Pause_Confirmation').Value__c);
        Integer dispatchIdCancellingScheduledPause = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Cancelling_Scheduled_Pause').Value__c);
        Integer dispatchIdEditingRestartDateInPause = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_EditingRestartDate_In_Pause').Value__c);
        Integer dispatchIdWelcomeBackFromPause = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Welcome_Back_From_Pause').Value__c);
        Integer dispatchIdUserCancel = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_User_Cancel').Value__c);
        Integer dispatchIdFreeTrialWelcome = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Free_Trial_Welcome').Value__c);
        Integer dispatchIdHardOfferWelcome = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Hard_Offer_Welcome').Value__c);
        Integer dispatchIdPaymentFailure = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Payment_Failure').Value__c);
        Integer dispatchIdPaymentSuccessful = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Payment_Successful').Value__c);
        Integer dispatchIdFreeTrialWelcomeAnnualTermed = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Free_Trial_Welcome_Termed').Value__c);
        Integer dispatchIdHardOfferWelcomeAnnualTermed = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Hard_Offer_Welcome_Termed').Value__c);
        Integer dispatchIdUpdatedName = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Updated_Name').Value__c);
        Integer dispatchIdUpdatedPayment = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Updated_Payment').Value__c);
        Integer dispatchIdFreeTrialActivePaidCancellation = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Immediate_Cancellation').Value__c);
        Integer dispatchIdPausedCancellation = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Paused_Cancellation').Value__c);
        Integer dispatchIdPaymentFailedUserFrozen = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Payment_Failed_User_Frozen').Value__c);
        Integer dispatchIdAppleFreeTrialWelcome = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Apple_Free_Trial_Welcome').Value__c);
        Integer dispatchIdRokuFreeTrialWelcome = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Roku_Free_Trial_Welcome').Value__c);
        Integer dispatchIdAppleHardOfferWelcome = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Apple_Hard_Offer_Welcome').Value__c);
        Integer dispatchIdRokuHardOfferWelcome = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Roku_Hard_Offer_Welcome').Value__c);
        Integer dispatchIdGiftCodeSuccess = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Gift_Code_Success').Value__c);
        
        Map<String, String> dispatchNameValueMap = new Map<String, String> {
            'DispatchID Double optin' =>  String.valueOf(dispatchIdDoubleOptIn),
            'DispatchID_Set_Edit_Pause_Confirmation' =>  String.valueOf(dispatchIdSetEditPauseConfirm),
            'DispatchID_Cancelling_Scheduled_Pause' =>  String.valueOf(dispatchIdCancellingScheduledPause),
            'DispatchID_EditingRestartDate_In_Pause' =>  String.valueOf(dispatchIdEditingRestartDateInPause),
            'DispatchID_Welcome_Back_From_Pause' =>  String.valueOf(dispatchIdWelcomeBackFromPause),
            'DispatchID_User_Cancel' =>  String.valueOf(dispatchIdUserCancel),
            'DispatchID_Free_Trial_Welcome' =>  String.valueOf(dispatchIdFreeTrialWelcome),
            'DispatchID_Hard_Offer_Welcome' =>  String.valueOf(dispatchIdHardOfferWelcome),
            'DispatchID_Payment_Failure' =>  String.valueOf(dispatchIdPaymentFailure),
            'DispatchID_Payment_Successful' =>  String.valueOf(dispatchIdPaymentSuccessful),
            'DispatchID_Free_Trial_Welcome_Termed' =>  String.valueOf(dispatchIdFreeTrialWelcomeAnnualTermed),
            'DispatchID_Hard_Offer_Welcome_Termed' =>  String.valueOf(dispatchIdHardOfferWelcomeAnnualTermed),
            'DispatchID_Updated_Name' => String.valueOf(dispatchIdUpdatedName),
            'DispatchID_Updated_Payment' => String.valueOf(dispatchIdUpdatedPayment),
            'DispatchID_Immediate_Cancellation' => String.valueOf(dispatchIdFreeTrialActivePaidCancellation),
            'DispatchID_Paused_Cancellation' => String.valueOf(dispatchIdPausedCancellation),
            'DispatchID_Payment_Failed_User_Frozen' => String.valueOf(dispatchIdPaymentFailedUserFrozen),///
            'DispatchID_Apple_Free_Trial_Welcome' => String.valueOf(dispatchIdAppleFreeTrialWelcome),
            'DispatchID_Roku_Free_Trial_Welcome' => String.valueOf(dispatchIdRokuFreeTrialWelcome),
            'DispatchID_Apple_Hard_Offer_Welcome' => String.valueOf(dispatchIdAppleHardOfferWelcome),
            'DispatchID_Roku_Hard_Offer_Welcome' => String.valueOf(dispatchIdRokuHardOfferWelcome),
            'DispatchID_Gift_Code_Success' => String.valueOf(dispatchIdGiftCodeSuccess)
        };
        return dispatchNameValueMap;
    }
    
    /*
        Description: Method populates Set Account Ids for which we need to query additional information
    */
    public static Set<Id> populateAccountIdsForQueryExtraInfo(Map<String, List<Email_Sync_Queue__c>> dispatchIdEmailQueueMap, Map<String, String> dispatchNameValueMap) {
        Set<Id> accountIdsForQueryExtraInfo = new Set<Id>();
        for (String aDispatchId : dispatchIdEmailQueueMap.keySet()) {
            if (aDispatchId == dispatchNameValueMap.get('DispatchID_Free_Trial_Welcome') ||
                    aDispatchId == dispatchNameValueMap.get('DispatchID_Free_Trial_Welcome_Termed') ||
                    aDispatchId == dispatchNameValueMap.get('DispatchID_Welcome_Back_From_Pause') ||
                    aDispatchId == dispatchNameValueMap.get('DispatchID_Cancelling_Scheduled_Pause') ||
                    aDispatchId == dispatchNameValueMap.get('DispatchID_Updated_Payment') ||
                    aDispatchId == 'Hard Offer Welcome'
                ) {
                for (Email_Sync_Queue__c emailQueueItem : dispatchIdEmailQueueMap.get(aDispatchId)) {
                    accountIdsForQueryExtraInfo.add(emailQueueItem.Account__c);
                }
            }
        }
        return accountIdsForQueryExtraInfo;
    }
    
    
    /*
        Description: PD-11936: Method get Subscription's CMRR and ChargedThroughDate from Zuora by AccountIds 
        and populates maps: AccountId -> Subscription's CMRR; AccountId -> ChargedThroughDate
    */
    public static void populateAccountInfoMaps(Set<Id> accountIdsForQueryExtraInfo,
                                               Map<Id, String> accountIdSubAmountMap,
                                               Map<Id, DateTime> accountIdNextChargeDateMap,
                                               Map<Id, Date> accountIdSubscriptionEndDate,
                                               Map<Id, String> accountIdBillingCurrencyMap,
                                               Map<Id, String> accountIdSubTermType,
                                               Map<Id, String> accountIdSubSourceSystemMap,
                                               Map<Id, String> accountIdCardExpirationTextMap,
                                               Map<Id, String> accountIdPaymentMethodTypeMap) {
        Map<Id, String> accountIdSubscriptionIdMap = new Map<Id, String>();

        List<Zuora__Subscription__c> subscriptions = [
            SELECT Id, Zuora__Status__c, Zuora__External_Id__c, Zuora__Account__c, SubscriptionAmount__c, Zuora__TermSettingType__c, SourceSystem__c,
                Zuora__SubscriptionStartDate__c, NumGiftPeriods__c, NumFreeTrialPeriods__c, Zuora__SubscriptionEndDate__c, Zuora__NextChargeDate__c
            FROM Zuora__Subscription__c
            WHERE Zuora__Account__c IN :accountIdsForQueryExtraInfo
                AND (Zuora__Status__c = 'Active' OR (Zuora__Status__c = 'Cancelled' AND Zuora__SubscriptionEndDate__c > TODAY ))
            ORDER BY Zuora__SubscriptionStartDate__c DESC NULLS LAST
        ];
        for (Zuora__Subscription__c sub : subscriptions) {
            if (sub.Zuora__Status__c == 'Active' && !accountIdSubscriptionIdMap.containsKey(sub.Zuora__Account__c)) {
                accountIdSubscriptionIdMap.put(sub.Zuora__Account__c, sub.Zuora__External_Id__c);
                if (sub.SubscriptionAmount__c != null) {
                    accountIdSubAmountMap.put(sub.Zuora__Account__c, String.valueOf(sub.SubscriptionAmount__c));
                }
                if (sub.Zuora__TermSettingType__c != null) {
                    accountIdSubTermType.put(sub.Zuora__Account__c, String.valueOf(sub.Zuora__TermSettingType__c));
                }
                if (sub.SourceSystem__c != null) {
                    accountIdSubSourceSystemMap.put(sub.Zuora__Account__c, sub.SourceSystem__c);
                }
                populateAccountSubscriptionEndDateMap(sub, accountIdSubscriptionEndDate);
            }
            if (sub.Zuora__NextChargeDate__c != null && !accountIdNextChargeDateMap.containsKey(sub.Zuora__Account__c)) {
                accountIdNextChargeDateMap.put(sub.Zuora__Account__c, sub.Zuora__NextChargeDate__c);
            }
        }
        List<Zuora__CustomerAccount__c> lstBA =  [
            SELECT Id, Zuora__Currency__c, Zuora__Account__c, Zuora__PaymentMethod_Type__c, Zuora__CreditCard_Expiration__c
            FROM Zuora__CustomerAccount__c
            WHERE Zuora__Account__c IN :accountIdsForQueryExtraInfo
        ];
        for (Zuora__CustomerAccount__c bAcc : lstBA) {
            accountIdBillingCurrencyMap.put(bAcc.Zuora__Account__c, bAcc.Zuora__Currency__c);
            accountIdCardExpirationTextMap.put(bAcc.Zuora__Account__c, bAcc.Zuora__CreditCard_Expiration__c);
            accountIdPaymentMethodTypeMap.put(bAcc.Zuora__Account__c, bAcc.Zuora__PaymentMethod_Type__c);
        }
    }
    
    public static void populateAccountSubscriptionEndDateMap(Zuora__Subscription__c sub, Map<Id, Date> accountIdSubscriptionEndDate) {
        Date subscriptionEndDate;
        if (sub.Zuora__TermSettingType__c == 'TERMED' && sub.Zuora__SubscriptionStartDate__c != null) {
            subscriptionEndDate = sub.Zuora__SubscriptionStartDate__c;
            if (String.isNotBlank(sub.NumGiftPeriods__c) && Integer.valueOf(sub.NumGiftPeriods__c) > 0) {
               subscriptionEndDate = subscriptionEndDate.addMonths(Integer.valueOf(sub.NumGiftPeriods__c));
            }
            if (String.isNotBlank(sub.NumFreeTrialPeriods__c) && Integer.valueOf(sub.NumFreeTrialPeriods__c) > 0) {
                subscriptionEndDate = subscriptionEndDate.addMonths(Integer.valueOf(sub.NumFreeTrialPeriods__c));
            }
            subscriptionEndDate = subscriptionEndDate.addMonths(12);
        }
        accountIdSubscriptionEndDate.put(sub.Zuora__Account__c, subscriptionEndDate);
    }
    
    // populates DispathcId for 'hard Offer' Id for Annual and Monthly subscription
    public static void handleHardOfferEmailSyncRecords(Map<String, List<Email_Sync_Queue__c>> dispatchIdEmailQueueMap,
                                                       Map<String, String> dispatchNameValueMap,
                                                       Map<Id, String> accountIdSubTermType,
                                                       Map<Id, String> accountIdSubSourceSystemMap,
                                                       Map<Id, String> accountIdCardExpirationTextMap,
                                                       Set<Id> setRetriedEmailQueueIds,
                                                       Set<Id> setFailedEmailQueueIds,
                                                       Map<Id, String> emailQueueIdErrorMap) {
        if (dispatchIdEmailQueueMap.get('Hard Offer Welcome') != null) {
            Set<String> termTypes = new Set<String> {'EVERGREEN', 'TERMED'};
            for (Email_Sync_Queue__c emailQueueItem : dispatchIdEmailQueueMap.get('Hard Offer Welcome')) {
                if (emailQueueItem.Account__c != null && accountIdSubTermType.get(emailQueueItem.Account__c) != null && termTypes.contains(accountIdSubTermType.get(emailQueueItem.Account__c))) {
                    /*
                      Condition which checks if Account has populated Credit Card Expiration field on billing Account to added to solve the problem 
                      i see it at the time of free trial or hard offer zoura delete the subscription and create new subscription which sometime takes
                      few moment to update in Salesforce but since email is sending from Salesforce its real time and therefore in case where Zoura have delays in
                      updating the subscription we got the null values and its not updates in communicator.
                    */
                    if (accountIdCardExpirationTextMap.get(emailQueueItem.Account__c) == null && emailQueueItem.Status__c == 'Not Started') {
                        setRetriedEmailQueueIds.add(emailQueueItem.Id);
                        emailQueueIdErrorMap.put(emailQueueItem.Id, 'There is no populated Credit Card Expiration field for billing Account of this Account.');
                    } else if (accountIdSubSourceSystemMap.containsKey(emailQueueItem.Account__c) && accountIdSubSourceSystemMap.get(emailQueueItem.Account__c) == 'Apple') {
                        emailQueueItem.Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Apple_Hard_Offer_Welcome').Value__c);
                    } else if (accountIdSubSourceSystemMap.containsKey(emailQueueItem.Account__c) && accountIdSubSourceSystemMap.get(emailQueueItem.Account__c) == 'Roku') {
                        emailQueueItem.Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Roku_Hard_Offer_Welcome').Value__c);
                    } else if (accountIdSubTermType.get(emailQueueItem.Account__c) == 'EVERGREEN') {
                        emailQueueItem.Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Hard_Offer_Welcome').Value__c);
                    } else if (accountIdSubTermType.get(emailQueueItem.Account__c) == 'TERMED') {
                        emailQueueItem.Dispatch_ID__c = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Hard_Offer_Welcome_Termed').Value__c);
                    }
                } else {
                    if (emailQueueItem.Status__c == 'Not Started') {
                        setRetriedEmailQueueIds.add(emailQueueItem.Id);
                        emailQueueIdErrorMap.put(emailQueueItem.Id, 'There are no Active Subscription for this Account.');
                    } else if (emailQueueItem.Status__c == 'Retried') {
                        setFailedEmailQueueIds.add(emailQueueItem.Id);
                        emailQueueIdErrorMap.put(emailQueueItem.Id, 'There are no Active Subscription for this Account.');
                    }
                }
            }
            List<Email_Sync_Queue__c> hardOfferEmailSyncRecords = dispatchIdEmailQueueMap.remove('Hard Offer Welcome');
            for (Email_Sync_Queue__c hardEmailSync : hardOfferEmailSyncRecords) {
                String tmpDispatchId = String.valueOf(hardEmailSync.Dispatch_ID__c);
                if (hardEmailSync.Email_Name__c == 'Hard Offer Welcome' && hardEmailSync.Dispatch_ID__c == null) {
                    tmpDispatchId = 'Hard Offer Welcome';
                }
                if (tmpDispatchId != 'Hard Offer Welcome' && tmpDispatchId != null) {
                    if (dispatchIdEmailQueueMap.containsKey(tmpDispatchId)) {
                        dispatchIdEmailQueueMap.get(tmpDispatchId).add(hardEmailSync);
                    }
                    else {
                        dispatchIdEmailQueueMap.put(tmpDispatchId, new List<Email_Sync_Queue__c> {hardEmailSync});
                    }
                }
            }
        }
        
        if (dispatchIdEmailQueueMap.get(dispatchNameValueMap.get('DispatchID_Free_Trial_Welcome')) != null) {
            Boolean isNotStartedRecordsWithoutCardExpiryExist = false;
            for (Email_Sync_Queue__c emailQueueItem : dispatchIdEmailQueueMap.get(dispatchNameValueMap.get('DispatchID_Free_Trial_Welcome'))) {
                if (accountIdCardExpirationTextMap.get(emailQueueItem.Account__c) == null) {
                    if (emailQueueItem.Status__c == 'Not Started') {
                        isNotStartedRecordsWithoutCardExpiryExist = true;
                        setRetriedEmailQueueIds.add(emailQueueItem.Id);
                        emailQueueIdErrorMap.put(emailQueueItem.Id, 'There is no populated Credit Card Expiration field for billing Account of this Account.');
                    }
                }
            }
            if (isNotStartedRecordsWithoutCardExpiryExist) {
                List<Email_Sync_Queue__c> notRetriedQueueWelcomeRecords = new List<Email_Sync_Queue__c>();
                List<Email_Sync_Queue__c> freeTrialWelcomeEmailSyncRecords = dispatchIdEmailQueueMap.remove(dispatchNameValueMap.get('DispatchID_Free_Trial_Welcome'));
                for (Email_Sync_Queue__c emailSync : freeTrialWelcomeEmailSyncRecords) {
                    if (!setRetriedEmailQueueIds.contains(emailSync.Id)) {
                        notRetriedQueueWelcomeRecords.add(emailSync);
                    }
                }
                if (!notRetriedQueueWelcomeRecords.isEmpty()) {
                    dispatchIdEmailQueueMap.put(dispatchNameValueMap.get('DispatchID_Free_Trial_Welcome'), notRetriedQueueWelcomeRecords);
                }
            }
        }
        if (dispatchIdEmailQueueMap.get(dispatchNameValueMap.get('DispatchID_Free_Trial_Welcome_Termed')) != null) {
            Boolean isNotStartedRecordsWithoutCardExpiryExist = false;
            for (Email_Sync_Queue__c emailQueueItem : dispatchIdEmailQueueMap.get(dispatchNameValueMap.get('DispatchID_Free_Trial_Welcome_Termed'))) {
                if (accountIdCardExpirationTextMap.get(emailQueueItem.Account__c) == null) {
                    if (emailQueueItem.Status__c == 'Not Started') {
                        isNotStartedRecordsWithoutCardExpiryExist = true;
                        setRetriedEmailQueueIds.add(emailQueueItem.Id);
                        emailQueueIdErrorMap.put(emailQueueItem.Id, 'There is no populated Credit Card Expiration field for billing Account of this Account.');
                    }
                }
            }
            if (isNotStartedRecordsWithoutCardExpiryExist) {
                List<Email_Sync_Queue__c> notRetriedQueueWelcomeRecords = new  List<Email_Sync_Queue__c>();
                List<Email_Sync_Queue__c> freeTrialWelcomeEmailSyncRecords = dispatchIdEmailQueueMap.remove(dispatchNameValueMap.get('DispatchID_Free_Trial_Welcome_Termed'));
                for (Email_Sync_Queue__c emailSync : freeTrialWelcomeEmailSyncRecords) {
                    if (!setRetriedEmailQueueIds.contains(emailSync.Id)) {
                        notRetriedQueueWelcomeRecords.add(emailSync);
                    }
                }
                if (!notRetriedQueueWelcomeRecords.isEmpty()) {
                    dispatchIdEmailQueueMap.put(dispatchNameValueMap.get('DispatchID_Free_Trial_Welcome_Termed'), notRetriedQueueWelcomeRecords);
                }
            }
        }
    }
    
    // populates dispatchIdEmailQueueMap and initialDispatchIdEmailQueueMap Maps for grouping Email Sync Queue records by DispatchId
    public static void populateDispatchIdEmailQueueMaps(List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList,
                                                        Map<String, List<Email_Sync_Queue__c>> dispatchIdEmailQueueMap,
                                                        Map<String, List<Email_Sync_Queue__c>> initialDispatchIdEmailQueueMap) {
        for (Email_Sync_Queue__c emailQueueItem : triggeredDispatchEmailQueueList) {
            String tmpDispatchId;
            if (emailQueueItem.Dispatch_ID__c != null) {
                tmpDispatchId = String.valueOf(Integer.valueOf(emailQueueItem.Dispatch_ID__c));
            }
            if (emailQueueItem.Email_Name__c == 'Hard Offer Welcome') {
                tmpDispatchId = 'Hard Offer Welcome';
            }
            if (dispatchIdEmailQueueMap.containsKey(tmpDispatchId)) {
                dispatchIdEmailQueueMap.get(tmpDispatchId).add(emailQueueItem);
            }
            else {
                dispatchIdEmailQueueMap.put(tmpDispatchId, new List<Email_Sync_Queue__c> {emailQueueItem});
            }
            if (initialDispatchIdEmailQueueMap.containsKey(tmpDispatchId)) {
                initialDispatchIdEmailQueueMap.get(tmpDispatchId).add(emailQueueItem);
            }
            else {
                initialDispatchIdEmailQueueMap.put(tmpDispatchId, new List<Email_Sync_Queue__c> {emailQueueItem});
            }
        }
    }
    
    /*
        Description: PD-11495: Method updates Status on Email_Sync_Queue__c records to 'Completed' and to 'Failed'.
        If record has 'Failed' status then Sync_Error_Msg__c will be also populated from values presented in emailSyncQueueIdErrorMap.
    */
    public static void updateEmailSyncRecords(Map<String, Set<Id>> statusEmailQueueIdsMap, Map<Id, String> emailSyncQueueIdErrorMap) {
        Set<Id> completedEmailQueueIds = new Set<Id>();
        Set<Id> failedEmailQueueIds = new Set<Id>();
        Set<Id> retriedEmailQueueIds = new Set<Id>();
        Set<Id> allEmailQueueIds = new Set<Id>();
        
        completedEmailQueueIds.addAll(statusEmailQueueIdsMap.get('Completed'));
        failedEmailQueueIds.addAll(statusEmailQueueIdsMap.get('Failed'));
        retriedEmailQueueIds.addAll(statusEmailQueueIdsMap.get('Retried'));
        
        allEmailQueueIds.addAll(completedEmailQueueIds);
        allEmailQueueIds.addAll(failedEmailQueueIds);
        allEmailQueueIds.addAll(retriedEmailQueueIds);
        List<Email_Sync_Queue__c> emailQueuesForUpdate = [
            SELECT Id, Account__c, Status__c, Sync_Error_Msg__c
            FROM Email_Sync_Queue__c
            WHERE Id IN :allEmailQueueIds
        ];
        for (Email_Sync_Queue__c emailQueueItem : emailQueuesForUpdate) {
            if (retriedEmailQueueIds.contains(emailQueueItem.Id)) {
                emailQueueItem.Status__c = 'Retried';
                if (emailSyncQueueIdErrorMap.get(emailQueueItem.Id) != null) {
                    emailQueueItem.Sync_Error_Msg__c = emailSyncQueueIdErrorMap.get(emailQueueItem.Id);
                }
            } else if (failedEmailQueueIds.contains(emailQueueItem.Id)) {
                emailQueueItem.Status__c = 'Failed';
                if (emailSyncQueueIdErrorMap.get(emailQueueItem.Id) != null) {
                    emailQueueItem.Sync_Error_Msg__c = emailSyncQueueIdErrorMap.get(emailQueueItem.Id);
                }
            } else if (completedEmailQueueIds.contains(emailQueueItem.Id)) {
                emailQueueItem.Status__c = 'Completed';
                emailQueueItem.Sync_Error_Msg__c = '';
            }
        }
        update emailQueuesForUpdate;
    }

    /*
        Description: PD-11495: Method to update account and send double opt in email to users in Communicator using Email_Sync_Queue__c records.
    */
    public static void handleEmailSyncRecords(List<Email_Sync_Queue__c> dataImportEmailQueueList, List<Email_Sync_Queue__c> triggeredDispatchEmailQueueList) {
        Map<Id, String> emailSyncQueueIdErrorMap = new Map<Id, String>();
        Map<String, Set<Id>> statusEmailQueueIdsMap = new Map<String, Set<Id>>();
        statusEmailQueueIdsMap.put('Completed', new Set<Id>{});
        statusEmailQueueIdsMap.put('Failed', new Set<Id>{});
        statusEmailQueueIdsMap.put('Retried', new Set<Id>{});

        handleDataImportEmailSyncRecords(dataImportEmailQueueList, statusEmailQueueIdsMap, emailSyncQueueIdErrorMap);
        handleTriggeredDispatchEmailSyncRecords(triggeredDispatchEmailQueueList, statusEmailQueueIdsMap, emailSyncQueueIdErrorMap);

        updateEmailSyncRecords(statusEmailQueueIdsMap, emailSyncQueueIdErrorMap);
    }
    
    /*
        Description: PD-11936: Method to convert Date to DateTime, format this ang get as String
    */
    public static String getStringFromDate(Datetime aDate) {
       String convertedDate;
       if (aDate != null) {
           convertedDate = DateTime.newInstance(aDate.year(), aDate.month(), aDate.day()).format('dd/MM/yyyy');
       }
       return convertedDate;
    }

    public static String getStringFromDateTime(Datetime aDate) {
       return String.valueOf(aDate.format('dd/MM/yyyy hh:mm:ss'));
    }
    
    public static String getLastMonthDay(String cardExpiry) {
        String dateFromCardExpiry;
        if (cardExpiry != null) {
            List<String> dateParts = cardExpiry.split('/');
            if (!dateParts.isEmpty()) {
                Integer numberOfDaysInMonth = Date.daysInMonth(Integer.valueOf(dateParts[1]), Integer.valueOf(dateParts[0]));
                dateFromCardExpiry = DateTime.newInstance(Integer.valueOf(dateParts[1]), Integer.valueOf(dateParts[0]), numberOfDaysInMonth).format('dd/MM/yyyy');
            }
        }
        return dateFromCardExpiry;
    }

    /*
        Description : Method to send double opt in email to germany users.
    */
    /* Commented out according to PD-11495: new metnod is CommunicatorIntegrationHelper.handleTriggeredDispatchEmailSyncRecords()
    public static void sendDoubleOptInEmail(Map<String,List<User>> mapUser){ 
        try{
            Integer dispatchId;            
            List<DataService.ColumnMapping> lstColumnMapping = null;
            List<DataService.DataRecord> lstDataRecord = null;
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = null;
            List<Task> lstTask = null;

            if(mapUser!= null && !mapUser.isEmpty()){

                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;
                
                for(String sCountryLanguage : mapUser.keySet()){
                    lstDataRecord = new List<DataService.DataRecord>(); 
                    
                    //get the disptach id based on language and changed Info
                    dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Marketing_Germany_'+ sCountryLanguage).Value__c);    
                    
                    //iterate through the list of users for this language
                    for(User oUser : mapUser.get(sCountryLanguage)){
                        lstColumnMapping = new List<DataService.ColumnMapping>();
                        
                        lstColumnMapping.add(getColumn(SalesforceColumnID, oUser.AccountId));                        
                        lstColumnMapping.add(getColumn(EmailColumnID, oUser.Email));
                        lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(oUser.LanguageLocaleKey)));
                        lstColumnMapping.add(getColumn(NotificationLanguageColumnID, oUser.LanguageLocaleKey));
                        lstColumnMapping.add(getColumn(NotificationCountryColumnID, oUser.CountryCode));
                        lstColumnMapping.add(getColumn(CountryLanguageColumnID, oUser.CountryCode + '_' + oUser.LanguageLocaleKey));
                        
                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                        arrColumnMap.ColumnMapping = lstColumnMapping;
                        
                        // set subscription
                        List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
                        lstSubscription.add(getSubscription(GermanyMarketingMailingListID, true, false));
                        
                        // create array of subscription
                        DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                        arrSubscription.Subscription = lstSubscription;
                        
                        // Prepare data record
                        lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                    }
                    // create list of triggered dispatch
                    lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
                    lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
                    
                    // create array of data records.
                    DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                    arrDataRecords.DataRecord = lstDataRecord;
                
                    // create array of triggered dispatch
                    DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                    arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
                
                    // Invoke SOAP request and get response.
                    DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();                    
                    oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
                 // Check record sync status and prepare a set of failure record id's.
                    Set<Id> setFailedAccountId = new Set<Id>();
                    for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                        if(oDataResponseDet.Result != 'SuccessUpdating' && oDataResponseDet.Result != 'SuccessInserting'){
                            for(DataService.ColumnMapping oColumn : oDataResponseDet.Mappings.ColumnMapping){                                
                                if(oColumn.ColumnId == SalesforceColumnID){
                                    setFailedAccountId.add(oColumn.Value);
                                   
                                }                                
                            }
                        }                       
                    }
                
                    // Prepare list of task to be created.
                    lstTask = new List<Task>();
                    for(String sLanguage : mapUser.keySet()){
                        for(User oUser : mapUser.get(sLanguage)){
                            if(!setFailedAccountId.contains(oUser.AccountId)){
                                lstTask.add(CommunityHelper.createTask(oUser.ContactId, oUser.AccountId, Label.LS_Communicator_Double_OptIn_Email_Task_Subject, 
                                                                                                         Label.LS_Communicator_Double_OptIn_Email_Task_Subject));
                            } 
                            //Start PD-9012
                            else{
                                CommunicatorFailureWebservice.createTask(null, null, Label.Webservice_Failed, Label.Webservice_Failed, null, null, null, mapUser);          
                            }
                            //End PD-9012
                        }
                    }
                }
                if(lstTask != null && !lstTask.isEmpty())
                    insert lstTask;
            }
        }catch (Exception ex){  
            //Start PD-9012
            CommunicatorFailureWebservice.createTask(null, null, Label.Webservice_Failed, ex.getMessage(), null, null, null, mapUser);          
            //End PD-9012
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendDoubleOptInEmail', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }*/
    
    /*
        Description : Method to send double opt in email to germany users.
    */
    /* Commented out according to PD-11495: new metnod is CommunicatorIntegrationHelper.handleTriggeredDispatchEmailSyncRecords()
    public static void sendDoubleOptInEmail(Map<String,List<Account>> mapAccount){ 
        try{
            Integer dispatchId;            
            List<DataService.ColumnMapping> lstColumnMapping = null;
            List<DataService.DataRecord> lstDataRecord = null;
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = null;
            List<Task> lstTask = null;
            Map<Id,Account> mapAccounts = new Map<Id,Account>();
            
            if(mapAccount!= null && !mapAccount.isEmpty()){

                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;
                
                for(String sCountryLanguage : mapAccount.keySet()){
                    lstDataRecord = new List<DataService.DataRecord>(); 
                    
                    //get the disptach id based on language and changed Info
                    dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Marketing_Germany_'+ sCountryLanguage).Value__c);
                    
                    //iterate through the list of users for this language
                    for(Account oAccount : mapAccount.get(sCountryLanguage)){
                        
                        lstColumnMapping = new List<DataService.ColumnMapping>();
                        
                        lstColumnMapping.add(getColumn(SalesforceColumnID, oAccount.Id));                        
                        lstColumnMapping.add(getColumn(EmailColumnID, oAccount.PersonEmail));
                        lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(oAccount.Notification_Language_Code__c)));
                        lstColumnMapping.add(getColumn(NotificationLanguageColumnID, oAccount.Notification_Language_Code__c));
                        lstColumnMapping.add(getColumn(NotificationCountryColumnID, oAccount.Notification_Country_Code__c));
                        lstColumnMapping.add(getColumn(CountryLanguageColumnID, oAccount.Notification_Country_Code__c + '_' + oAccount.Notification_Language_Code__c));
                        
                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                        arrColumnMap.ColumnMapping = lstColumnMapping;
                        
                        // set subscription
                        List<DataService.Subscription> lstSubscription = new List<DataService.Subscription>();
                        lstSubscription.add(getSubscription(GermanyMarketingMailingListID, true, false));
                        
                        // create array of subscription
                        DataService.ArrayOfSubscription arrSubscription = new  DataService.ArrayOfSubscription();
                        arrSubscription.Subscription = lstSubscription;
                        
                        // Prepare data record
                        lstDataRecord.Add(getDataRecord(arrColumnMap, arrSubscription, false));
                    }
                    // create list of triggered dispatch
                    lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
                    lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
                    
                    // create array of data records.
                    DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                    arrDataRecords.DataRecord = lstDataRecord;
                
                    // create array of triggered dispatch
                    DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                    arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
                
                    // Invoke SOAP request and get response.
                    DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();                    
                    oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));
                 // Check record sync status and prepare a set of failure record id's.
                    Set<Id> setFailedAccountId = new Set<Id>();
                    
                    
                    for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                        if(oDataResponseDet.Result != 'SuccessUpdating' && oDataResponseDet.Result != 'SuccessInserting'){
                            for(DataService.ColumnMapping oColumn : oDataResponseDet.Mappings.ColumnMapping){                                
                                if(oColumn.ColumnId == SalesforceColumnID){
                                    setFailedAccountId.add(oColumn.Value);
                                   
                                }                                
                            }
                        }                  
                    }
                
                    
                    for(String sLanguage : mapAccount.keySet()){
                        for(Account oAccount : mapAccount.get(sLanguage)){
                            if(!setFailedAccountId.contains(oAccount.Id)){
                                oAccount.IsReadyToSyncInCommunicator__c = false;
                                mapAccounts.put(oAccount.Id,oAccount);
                            }
                            
                            //End PD-9012
                        }
                    }
                }
          
                
                if(mapAccounts!=null && !mapAccounts.isEmpty())
                    update mapAccounts.values();
            }
        }catch (Exception ex){  
            
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendDoubleOptInEmail', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }*/
     public static void sendInactiveDeviceNotification(Map<String,List<WrapCommunicatorEmail>> mapInactiveDevice){   
    // String s1 = 'Success'; 
        try{
            Integer dispatchId;
            
            List<DataService.ColumnMapping> lstColumnMapping = null;
            List<DataService.DataRecord> lstDataRecord = null;
            List<DataService.TriggeredDispatch> lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
            List<Task> lstTaskAll = null;
            List<Task> lstTask = null;
            
            if(mapInactiveDevice!= null && !mapInactiveDevice.isEmpty()){
                lstTaskAll = new List<Task>();
                
                // set the credentials
                DataService.DataServiceSoap oDataServiceSoap = new DataService.DataServiceSoap();
                oDataServiceSoap.CommunicatorCredentials =  getCommunicatorCreds();
                oDataServiceSoap.timeout_x = iAPITimeOutLimit;
               for(String sCountryLanguage : mapInactiveDevice.keySet()){
                    lstDataRecord = new List<DataService.DataRecord>();            

                    //get the disptach id based on language 
                    dispatchId = Integer.valueOf(DAZNCommunicatorConfig__c.getInstance('DispatchID_Inactive_Device_'+ sCountryLanguage).Value__c);                       
                   //iterate through the list of wrapper  class
                    for(WrapCommunicatorEmail objWrap : mapInactiveDevice.get(sCountryLanguage)){
                        lstColumnMapping = new List<DataService.ColumnMapping>();
                        
                        lstColumnMapping.add(getColumn(SalesforceColumnID, objWrap.Id));
                        lstColumnMapping.add(getColumn(EmailColumnID, objWrap.Email));
                        lstColumnMapping.add(getColumn(UnsubscribeLanguageColumnID, getUnsubscribeLanguage(objWrap.NotificaitonLanguageCode)));
                        lstColumnMapping.add(getColumn(NotificationLanguageColumnID, objWrap.NotificaitonLanguageCode));
                        lstColumnMapping.add(getColumn(NotificationCountryColumnID, objWrap.NotificationCountryCode));
                        lstColumnMapping.add(getColumn(CountryLanguageColumnID, objWrap.NotificationCountryCode + '_' + objWrap.NotificaitonLanguageCode));                        
                        
                        // create array of data column mapping
                        DataService.ArrayOfColumnMapping arrColumnMap = new DataService.ArrayOfColumnMapping();
                        arrColumnMap.ColumnMapping = lstColumnMapping;
                        
                        // set subscription
                        List<DataService.Subscription> lstInactiveDevice = new List<DataService.Subscription>();
                        lstInactiveDevice.add(getSubscription(MailingListID, true, false));                         
                         
                        // create array of subscription
                        DataService.ArrayOfSubscription arrInactiveDevice = new  DataService.ArrayOfSubscription();
                        arrInactiveDevice.Subscription = lstInactiveDevice;
                        
                        // Prepare data record
                        lstDataRecord.Add(getDataRecord(arrColumnMap, arrInactiveDevice, false));
                    }
                    // create list of triggered dispatch
                    lstTriggeredDispatch = new List<DataService.TriggeredDispatch>();
                    lstTriggeredDispatch.Add(getTriggeredDispatch(dispatchId, 'SendToAllSubscribers'));
                    
                    // create array of data records.
                    DataService.ArrayOfDataRecord arrDataRecords = new DataService.ArrayOfDataRecord();
                    arrDataRecords.DataRecord = lstDataRecord;
                    
                    // create array of triggered dispatch
                    DataService.ArrayOfTriggeredDispatch arrTriggerDispatch = new  DataService.ArrayOfTriggeredDispatch();
                    arrTriggerDispatch.TriggeredDispatch = lstTriggeredDispatch;
                    
                    // Invoke SOAP request and get response.
                    DataService.DataImportResponse oDataImportResponse = new DataService.DataImportResponse();
                    oDataImportResponse = oDataServiceSoap.DataImporter(getDataImport(ContactTableID, 'Upsert', arrDataRecords, arrTriggerDispatch));                    
                   
                     //Start PD-9012
                     for(DataService.DataImportResponseDetail oDataResponseDet : oDataImportResponse.ImportDetails.DataImportResponseDetail){
                        if(oDataResponseDet.Result == 'SuccessUpdating' || oDataResponseDet.Result == 'SuccessInserting'){
                             // create task for succesfull notification.
                            lstTask = createNotificationTask(oDataImportResponse, mapInactiveDevice, sCountryLanguage, Label.LS_Communicator_Inactive_User_Device_Email_Task_Subject);
                        }
                        else{ 
                            CommunicatorFailureWebservice.createNotificationTask(mapInactiveDevice, Label.Webservice_Failed,Label.Webservice_Failed);
                        } 
                    }
                    //End PD-9012 
                   
                    if(lstTask !=null && !lstTask.isEmpty()){
                        lstTaskAll.addAll(lstTask);
                    } 
                }              
                
                if(lstTaskAll !=null && !lstTaskAll.isEmpty()){
                    insert lstTaskAll;
                }    
                    
            }
            
        }catch (Exception ex){      
            //Start PD-9012
            CommunicatorFailureWebservice.createNotificationTask(mapInactiveDevice, Label.Webservice_Failed,ex.getMessage());           
            //End PD-9012          
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunicatorIntegrationHelper ', 'sendInactiveDeviceConnected', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
        
       // return s1;
    }
   
}