/**
*  @author Megha Jain
*  @date March 16, 2017
*  @description PauseHelper
@Modification Log:        
------------------------------------------------------------------------------------        
Developer                Mod Number       Date                Description        
------------------------------------------------------------------------------------        
Megha Jain               -           16/03/2017           Initial version created.
*/
public without sharing class SetPauseController {
    // Pause Properties
    public User user { get; set; }
    public String accountid;
    public String ratePlanId;
    public Date nextDateVar;
    public Date myTodaystring;
    public DateTime nextDate;
    public String SubscriptionId;
    public String nextBillingDate { get; set; }
    public String formattedString  { get; set; }
//    public String strSelectedLanguage { get; set; }
    public String majEventDateFormatted { get; set; }
    public String majEventDescription { get; set; }
    public String majEventLocalDate { get; set; }
    public Boolean aboutToPauseFlag { get; set; }
    public Boolean pauseIsDoneFlag { get; set; }
    public Boolean majEventDescriptionflag { get; set; }
    public Boolean showOtherEventsFlag { get; set; }
    public Boolean pauseDoneBillingDateFlag { get; set; }
    public Static PageReference errorPage = null;
    public Integer nonMajorEventCount { get; set; }
    // public PageReference oRedirectPageRef = null;//Added as part of change request for PD:15411
    
    public DAZN_Events_Calendar__c majEvent { get; set; }
    public DAZN_Events_Calendar__c otherEvent { get; set; }

    public List<DAZN_Events_Calendar__c> OtherEventLst {
        get {
            Date mydtstring;
            Date eventDisplayDate;
            Boolean isAccountExist = lstAcc != null && !lstAcc.isEmpty();
            if (isAccountExist && lstAcc[0].PauseScheduled__c) {
                mydtstring = lstAcc[0].Pause_From__c;
                eventDisplayDate = lstAcc[0].Pause_Until__c;
            } else if (isAccountExist && lstAcc[0].Account_Status__c == 'Paused') {
                mydtstring = Date.today();
                eventDisplayDate = lstAcc[0].Pause_Until__c;
            } else {
                List<DAZN_Events_Calendar__c> defaultMajEventLst = [Select Localised_Date__c, Localised_Event_description__c, Event_Date__c, Event_Country__c, Country_language__c
                    FROM DAZN_Events_Calendar__c 
                    WHERE Event_Date__c >= :nextDateVar AND Is_Major_Event__c = TRUE AND Event_Country__c = :sCountryCode AND Country_language__c = :strLangCode
                    ORDER BY Event_Date__c DESC LIMIT 1];
                
                mydtstring = nextDateVar;
                eventDisplayDate = (defaultMajEventLst.isEmpty()) ? null : defaultMajEventLst[0].Event_Date__c;
            }
            
            if (String.isNotBlank(strEventDate)) {
                eventDisplayDate = setStringToDateFormat(strEventDate);
            }

            List<DAZN_Events_Calendar__c> otherEvents = new List<DAZN_Events_Calendar__c>();
            if (mydtstring != null && eventDisplayDate != null) {
                otherEvents = [SELECT Localised_Date__c, Localised_Event_description__c
                    FROM DAZN_Events_Calendar__c 
                    WHERE Event_Date__c >= :mydtstring AND Event_Date__c <= :eventDisplayDate AND Is_Major_Event__c = False AND Event_Country__c = :sCountryCode and Country_language__c = :strLangCode
                    ORDER BY Event_Date__c ASC];
            }
            nonMajorEventCount = otherEvents.size();

            return otherEvents;
        }
        set;
    }
    
    public List<DAZN_Events_Calendar__c> majEventLst {
        get {
            majEventDescriptionflag = false;
            Date mydtstring;
            List<DAZN_Events_Calendar__c> majEvents = new LIST<DAZN_Events_Calendar__c>();
            Boolean isAccountExist = lstAcc != null && !lstAcc.isEmpty();

            if (String.isNotBlank(strEventDate)) {
                mydtstring = setStringToDateFormat(strEventDate);
                if (mydtstring != null) {
                    majEvents = [SELECT Localised_Date__c, Is_Major_Event__c, Localised_Event_description__c, Event_Date__c, Event_Country__c, Country_language__c
                        FROM DAZN_Events_Calendar__c 
                        WHERE Event_Date__c = :mydtstring AND Is_Major_Event__c = TRUE AND Event_Country__c = :sCountryCode AND Country_language__c = :strLangCode
                        ORDER BY Event_Date__c DESC LIMIT 1];
                }
            } else {
                if (majEvents == null || majEvents.isEmpty()) {
                    mydtstring = (isAccountExist && !lstAcc[0].PauseScheduled__c && lstAcc[0].Account_Status__c == 'Paused') ? lstAcc[0].Pause_From__c : nextDateVar;
                    if (mydtstring != null) {
                        majEvents = [SELECT Localised_Date__c, Is_Major_Event__c, Localised_Event_description__c, Event_Date__c, Event_Country__c, Country_language__c
                            FROM DAZN_Events_Calendar__c 
                            WHERE Event_Date__c >= :mydtstring AND Is_Major_Event__c = TRUE AND Event_Country__c = :sCountryCode AND Country_language__c = :strLangCode
                            ORDER BY Event_Date__c DESC LIMIT 1];
                    }
                }
                if (majEvents == null || majEvents.isEmpty()) {
                    majEvents = [Select Localised_Date__c, Localised_Event_description__c, Event_Date__c, Event_Country__c, Country_language__c
                        FROM DAZN_Events_Calendar__c 
                        WHERE Event_Date__c <= :mydtstring AND Is_Major_Event__c = TRUE AND Event_Country__c = :sCountryCode AND Country_language__c = :strLangCode
                        ORDER BY Event_Date__c DESC LIMIT 1];
                }
            }

            if (majEvents != null && !majEvents.isEmpty()) {
                majEvent = majEvents[0];
            } else {
                return null;
            }
            
            Date majD = majEvent.Event_Date__c;

            if (isAccountExist && (lstAcc[0].PauseScheduled__c || lstAcc[0].Account_Status__c == 'Paused')) {
                if (lstAcc[0].Pause_Until__c == majD) {
                    majEventDateFormatted = getStringFromDate(lstAcc[0].Pause_Until__c);
                    majEventDescription = majEvent.Localised_Event_description__c;
                    majEventLocalDate = majEvent.Localised_Date__c;
                    majEventDescriptionflag = true;
                } else {
                    majEventDateFormatted = getStringFromDate(lstAcc[0].Pause_Until__c);
                    majEventDescriptionflag = false;
                    majEventLocalDate = CommunityHelper.ConvertDateToString(lstAcc[0].Pause_Until__c, strLangCode);
                }
            } else {
                majEventDateFormatted = getStringFromDate(majD);
                majEventDescription = majEvent.Localised_Event_description__c;
                majEventLocalDate = majEvent.Localised_Date__c;
                majEventDescriptionflag = true;
            }

            return majEvents;
        }
        set;
    }

    public list<Zuora__Subscription__c> zuoraList;
    public list<Zuora__SubscriptionProductCharge__c > lstRatePlan ;
    
    public List<Account> lstAcc { get; set; }
    
    public String strAction { get; set; }
    public String strSuspendDate { get; set; }
    public String strResumeDate { get; set; }
    public String strEventDate{ get; set; }
    public String strEventTime{ get; set; }

    public String sCountryCode {
        get {
            String sCountry = ApexPages.currentpage().getCookies().get('Country').getValue();
            return (String.isNotBlank(sCountry)) ? sCountry : user.CountryCode;
        }
        set;
    }
    public String strLangCode {
        get {
            String slang = ApexPages.currentpage().getCookies().get('lang').getValue();
            slang = ((String.isNotBlank(slang)) ? slang : CommunityHelper.getLanguageCode()).toUpperCase();
            return (slang.equalsIgnoreCase('en')) ? slang + '_GB' : slang;
        }
        set;
    }
    
    public SetPauseController() {
        CommunityHelper.setCountryAndLanguageCodes(null);

        user = CommunityHelper.getCurrentUser();
        accountid = user.AccountId;

        calcNextBillingdate();
        toggleButton();
        fetchPauseAccount();
    }
    
    @RemoteAction
    public static PageReference processPause(String strAction, String strSuspendDate, String strResumeDate, String country, String lang) {
        //public PageReference processPause() {
        User user = CommunityHelper.getCurrentUser();
        Decimal billCycleDay;
        
        Date dResumeDate = getDateFromString(strResumeDate);
        Date dSuspendDate = getDateFromString(strSuspendDate);
        
        List<Account> usersAccount = [Select Id, Submitted_for_cancellation__c, Account_Status__c, Pause_From__c,
                                      Previous_BCD__c, Pause_Until__c, PauseScheduled__c, Pause_Scheduled_Time__c, Notification_Country_Code__c,
                                      All_Email_Preferences__c, Is_Double_OptIn__c
                                      From Account
                                      Where Id = :user.AccountId
                                      LIMIT 1];
        if (usersAccount == null || usersAccount.isEmpty()) {
            return PauseCalloutHelper.redirectToMyAccount('', '', '');
        }
        
        List<Zuora__Subscription__c> subscriptions = [Select Id, Name, Zuora__CustomerAccount__r.Zuora__BillCycleDay__c
                                                      From Zuora__Subscription__c
                                                      Where Zuora__Account__c = :user.AccountId AND Zuora__Status__c = 'Active'];
        if (subscriptions.isEmpty()) {
            return PauseCalloutHelper.redirectToMyAccount('', '', '');
        }
        //check parameters:
        //- action should always be set
        //- resumeDate and suspendDate should be set for 'initiate' and 'amend' actions, and should be in 'yyyy-mm-dd' format
        Boolean isParametersInvalid = String.isEmpty(strAction) ||
            (strAction.equalsIgnoreCase('amend') && (String.isEmpty(strResumeDate) || strResumeDate.split('-') == null || strResumeDate.split('-').size() != 3 || dResumeDate == null)) ||
            (strAction.equalsIgnoreCase('initiate') && (String.isEmpty(strResumeDate) || String.isEmpty(strSuspendDate) || strResumeDate.split('-') == null || strResumeDate.split('-').size() != 3 || strSuspendDate.split('-') == null || strSuspendDate.split('-').size() != 3 || dResumeDate == null || dSuspendDate == null));
        if (isParametersInvalid) {
            return null;
        }
        if (strAction.equalsIgnoreCase('amend')) {
            DateTime dtSuspendDate = usersAccount[0].Pause_From__c;
            strSuspendDate = dtSuspendDate.format('yyyy-MM-dd');
            dSuspendDate = usersAccount[0].Pause_From__c;
        }
        
        String subscriptionName = subscriptions[0].Name;
        String bcd;
        
        Map<String, String> pauseCalloutResult;
        if (strAction.equalsIgnoreCase('initiate')) { //set pause
            bcd = strResumeDate.split('-')[2]; //get day from Resume Date
            pauseCalloutResult = PauseCalloutHelper.initPauseCallout(subscriptionName, strResumeDate, strSuspendDate, bcd);
            billCycleDay = subscriptions[0].Zuora__CustomerAccount__r.Zuora__BillCycleDay__c != null ? WhyController.createPreviousBCD(subscriptions[0].Zuora__CustomerAccount__r.Zuora__BillCycleDay__c) : usersAccount[0].Previous_BCD__c;
        } else if (strAction.equalsIgnoreCase('amend')) {
            //update pause
            if (dResumeDate == usersAccount[0].Pause_Until__c) {
                return PauseCalloutHelper.redirectToMyAccount('', '', '');
            }
            bcd = strResumeDate.split('-')[2]; //get day from Resume Date
            billCycleDay = usersAccount[0].Previous_BCD__c;
            
            if (usersAccount[0].PauseScheduled__c) {
                //pauseCalloutResult = initPauseCallout(subscriptionName, strResumeDate, strSuspendDate, bcd);
                //changes 10.04.2017 - If the customer is editing a future pause, then we need to call the same workflow as called for ‘Edit Resume dates when already Paused’
                
                pauseCalloutResult = PauseCalloutHelper.amendFuturePauseCallout(subscriptionName, strResumeDate, bcd);
            } else {
                pauseCalloutResult = PauseCalloutHelper.amendPauseCallout(subscriptionName, strResumeDate, bcd);
            }
        } else if (strAction.equalsIgnoreCase('cancel')) { //cancel pause
            //here will be the code for process pause cancellation
            billCycleDay = usersAccount[0].Previous_BCD__c;
            if (usersAccount[0].PauseScheduled__c) {
                pauseCalloutResult = PauseCalloutHelper.cancelPauseCallout(subscriptionName, String.valueOf(billCycleDay));
            } else {
                //return redirectToMyAccount('', '', '');
                DAZNConfiguration__c daznConfig = DAZNConfiguration__c.getValues('AmendPauseURL');
                return (daznConfig != null && String.isNotBlank(daznConfig.Value__c)) ? new PageReference(daznConfig.Value__c) : PauseCalloutHelper.redirectToMyAccount('', '', '');
            }
        }
        
        Boolean pauseResultIsSuccess = Boolean.valueOf(pauseCalloutResult.get('success'));
        String pauseResultMessage = pauseCalloutResult.get('message');
        
        PageReference resultPage;
        if (pauseResultIsSuccess) {
            resultPage = PauseCalloutHelper.pauseFlowProcessSuccess(
                strAction,
                user,
                usersAccount[0],
                dResumeDate,
                dSuspendDate,
                pauseResultMessage,
                billCycleDay,
                usersAccount[0].Submitted_for_cancellation__c,
                country,
                lang
            );
        } else {
            resultPage = PauseCalloutHelper.pauseFlowProcessFailure(
                strAction,
                user,
                usersAccount[0],
                pauseResultMessage
            );
        }
        resultPage.setRedirect(true);
        return resultPage;
    }
    
    /**
*  @author Megha Jain
*  @date March 26, 2017
*  @description :Description: Method to redirect user to error page
@Parameter : Month in interger 
*/
    public static PageReference redirectToErrorPage(String strErrMsg) {
        if (strErrMsg.contains('mylogin')) {
            errorPage = System.Page.mylogin;
            return errorPage;
        } else{
            errorPage = System.Page.InternalServerError;
            errorPage.getParameters().Put('Errormsg',strErrMsg);
            errorPage.setRedirect(true);
            return errorPage;       
        }      
    }
  
    
    /**
*  @author Megha Jain
*  @date March 26, 2017
*  @description :Returns the date in the form of string of format dd/MM/YYYY
@Parameter : DateTime
*/
    @TestVisible
    public static String getStringFromDate(Date strDate) {
        String convertedDate;
        convertedDate = Datetime.newInstance(strDate.year(), strDate.month(), strDate.day()).format('dd/MM/YYYY');
        return convertedDate;
    }
    
    /**
*  @author Megha Jain
*  @date March 26, 2017
*  @description : This is used to calculate the next billing date of user
   @Change Log ://Changed as a part of PD-15411 : To get next charge Date from Subscription
                //Developer : MeghaJain 
@Parameter : 
*/
    @TestVisible
    public PageReference calcNextBillingdate () {
        PageReference oRedirectPageRef = null;//Added as part of change request for PD:15411
        List<Account> lstAccount = fetchPauseAccount();
        try {
            if (user == null) {
                user = CommunityHelper.getCurrentUser();
            }
            accountid = user.AccountId ;
            if (accountId != null & !String.isBlank(accountId)) {
                
                nextDate = ZuoraTransactionHelper.getRatePlanChargeChargedThroughDateByAccountId(accountId );
            }
            if(!lstAccount[0].PauseScheduled__c && lstAccount[0].Account_Status__c!='Paused' ) {
                // If else condition added as a part of PD-15411
                
                if (nextDate != null && nextDate > Date.Today()){
                    nextDateVar = nextDate.Date();
                    
                    nextBillingDate = CommunityHelper.ConvertDateToString(nextDateVar,strLangCode );
                    formattedString = getStringFromDate(nextDateVar);
                }else {
                    
                    oRedirectPageRef = new PageReference('/MyAccount');    //Added as part of change request for PD:15411
                    oRedirectPageRef.getParameters().put('banner', 'Nextchargedatenull');
                    oRedirectPageRef.setRedirect(true);
                    
                }
            } else if (lstAccount[0].PauseScheduled__c && lstAccount[0].Account_Status__c != 'Paused') {
                nextBillingDate = CommunityHelper.ConvertDateToString(lstAccount[0].Pause_From__c,strLangCode);
                formattedString = getStringFromDate(lstAccount[0].Pause_From__c);
                nextDateVar = lstAccount[0].Pause_From__c;
            } else if (!lstAccount[0].PauseScheduled__c && lstAccount[0].Account_Status__c == 'Paused' ) {
                nextBillingDate = CommunityHelper.ConvertDateToString(lstAccount[0].Pause_Until__c,strLangCode);
                formattedString = getStringFromDate(lstAccount[0].Pause_From__c);
                nextDateVar = lstAccount[0].Pause_From__c;
            }
        } catch(Exception ex) {
            if (!Test.isRunningTest()) {
                ExceptionLoggerHelper.createExceptionLog(user.Id, 'MyAccountController', 'calcNextBillingdate', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            }
        }
        return oRedirectPageRef; 
    }
    
    /**
*  @author Megha Jain
*  @date March 26, 2017
*  @description : Used to pass parameter to keep In Touch  Page
*/  
    @TestVisible 
    public String getNextDateForSetPause() {
        return (nextDate == null) ? '' : nextDate.format('YYYY-MM-dd');
    }
    
    /**
*  @author Megha Jain
*  @date March 26, 2017
*  @description : This is used to Search all the Accounts for Pause Flow
*/   
    @TestVisible
    public List<Account> fetchPauseAccount() {
        if (user == null) {
            user = CommunityHelper.getCurrentUser();
        }
        lstAcc = [SELECT Id, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, Notification_Country_Code__c, All_Email_Preferences__c, Is_Double_OptIn__c FROM Account WHERE ID = :user.AccountId LIMIT 1];
        return lstAcc ;
    } 
    
    /**
*  @author Megha Jain
*  @date March 26, 2017
*  @description : This is used to set flag to show and hide Buttons 
*/   
    @TestVisible
    public void toggleButton () {
        List<Account> lstAccount = fetchPauseAccount();
        if (lstAccount != null && !lstAccount.isEmpty()) {
            if (!lstAccount[0].PauseScheduled__c && lstAccount[0].Account_Status__c != 'Paused') {
                aboutToPause(); 
            }
            /* else if(lstAccount[0].PauseScheduled__c && lstAccount[0].Account_Status__c=='Active Paid') {
aboutToPause();*/
            else {
                pauseIsDone();
            }
        }
    }
    
    /**
*  @author Megha Jain
*  @date March 26, 2017
*  @description : This is used to set flag to show and hide Buttons 
*/   
    @TestVisible
    public void aboutToPause(){
        List<Account> lstAccount = fetchPauseAccount();
        if (lstAccount != null && !lstAccount.isEmpty()) {
            if (!lstAccount[0].PauseScheduled__c && lstAccount[0].Account_Status__c != 'Paused') {
                aboutToPauseFlag = true;
                pauseIsDoneFlag = false;
            }
        } 
    }
    
    /**
*  @author Megha Jain
*  @date March 26, 2017
*  @description : This is used to set flag to show and hide Buttons 
*/            
    @TestVisible
    public void pauseIsDone() {
        List<Account> lstAccount = fetchPauseAccount();
        if(lstAccount !=null && !lstAccount.isEmpty()){
            if (lstAccount[0].PauseScheduled__c && lstAccount[0].Account_Status__c!='Paused' ){
                pauseIsDoneFlag = true;
                aboutToPauseFlag = false;
                pauseDoneBillingDateFlag = false ;
            } else if (lstAccount[0].Account_Status__c == 'Paused') {
                pauseIsDoneFlag = true;
                aboutToPauseFlag = false;
                pauseDoneBillingDateFlag = true;
                
            }
        } 
    }
    
    /*
Description: Method to convert string parameter to Date type. 
*/
    @TestVisible
    private static Date getDateFromString(String strDate) {
        Date convertedDate;
        try {
            convertedDate = Date.valueOf(strDate);
        } catch(Exception e) {
            return convertedDate;
        }
        return convertedDate;
    }
    
    public static Date setStringToDateFormat(String myDate) { 
        String[] myDateOnly = myDate.split(' ');
        String[] strDate = myDateOnly[0].split('-');       
        Integer myIntYear = integer.valueOf(strDate[0]);
        Integer myIntMonth = integer.valueOf(strDate[1]);
        Integer myIntDate = integer.valueOf(strDate[2]);        
        Date convertedDate = Date.newInstance(myIntYear,myIntMonth,myIntDate);
        return convertedDate;
    }
    
    public PageReference searchEventDynamically() {
        return null;
    }
}