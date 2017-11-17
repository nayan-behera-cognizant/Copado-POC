/**
* @author Cognizant Technology Solutuions
* @date 21/10/2015
* @description Community Helper class
*/

public without sharing class CommunityHelper {
    
    //Added below line for PD-8706 Send Welcome Back email via Communicator
    public static boolean firstRun = true;
    public static boolean StrExceptn = true;
    
    /**
     * @author Cognizant Technology Solutuions
     * @date 21/10/2015
     * @description: This method is used to construct subscription messages for various pages.
    */
    public static String getSubscriptionDescription(String Message, Zuora__Subscription__c oSubscription){
        list<Account> accList = new list<Account>();
        if(oSubscription.Zuora__Account__c != null){
            accList = [Select id,Notification_Country_Code__c,Notification_Language_Code__c From Account where Id =: oSubscription.Zuora__Account__c];  
        }  
        String strMessage=Message;
        List<String> lstField=new List<String>();
        while(strMessage.contains('[') && strMessage.contains(']')){
            String strField=strMessage.substringBetween('[',']');
            lstField.add(strField);
            strMessage=strMessage.remove('['+strField+']');
        }//Nayan : PD-12109
        for(string strField : lstField){
            if(strField.equals('Zuora__Price__c')){
                //Add as part of PD-14237
                //Removed 2 fields : Zuora__TCV__c, Zuora__MRR__c
                List<Zuora__Subscription__c> subscriptionList = [Select ID, Zuora__TermSettingType__c, SubscriptionAmount__c From Zuora__Subscription__c Where Id = : oSubscription.Id ];
                if(subscriptionList<> null && subscriptionList.size() > 0){
                    //Check if Annual subscription
                    //Added as part of PD-14237
                    Message=Message.replace('['+strField+']', getformattedAmount(getCurrencySymbol(oSubscription.Zuora__CustomerAccount__r.Zuora__Currency__c),Decimal.valueOf(String.valueOf(subscriptionList[0].SubscriptionAmount__c)).setscale(2) ,null) );
                }else{
                    Message=Message.replace('['+strField+']','--');         
                } 
            }else{
                if(oSubscription.get(strField) !=null){      
                    Message=Message.replace('['+strField+']',ConvertDateToString(Date.ValueOf(String.ValueOf(oSubscription.get(strField))),accList[0].Notification_Country_Code__c,''));
            	}    
            }
        }
        return Message;
    }
    
    public static String getSubscriptionDescriptionForCanada(String Message, Zuora__Subscription__c oSubscription, String Slang, String Scountry){    
        list<Account> accList = new list<Account>();
        if(oSubscription.Zuora__Account__c != null){
            accList = [Select id,Notification_Country_Code__c,Notification_Language_Code__c From Account where Id =: oSubscription.Zuora__Account__c];  
        }  
        String strMessage=Message;
        List<String> lstField=new List<String>();
        while(strMessage.contains('[') && strMessage.contains(']')){
            String strField=strMessage.substringBetween('[',']');
            lstField.add(strField);
            strMessage=strMessage.remove('['+strField+']');
        }
        for(string strField : lstField){
            if(strField.equals('Zuora__Price__c')){
                //Add as part of PD-14237
                //Removed 2 fields : Zuora__TCV__c, Zuora__MRR__c
                List<Zuora__Subscription__c> subscriptionList = [Select ID,Zuora__TermSettingType__c, SubscriptionAmount__c From Zuora__Subscription__c Where Id = : oSubscription.Id ];
                if(subscriptionList<> null && subscriptionList.size() > 0){
                    //Check if Annual subscription
                    Message=Message.replace('['+strField+']', getformattedAmount(getCurrencySymbol(oSubscription.Zuora__CustomerAccount__r.Zuora__Currency__c),Decimal.valueOf(String.valueOf(subscriptionList[0].SubscriptionAmount__c)).setscale(2) ,null) );                             
                }else{
                    Message=Message.replace('['+strField+']','--');         
                } 
            }else{
                if(oSubscription.get(strField) !=null){
                    Message=Message.replace('['+strField+']',ConvertDateToString(Date.ValueOf(String.ValueOf(oSubscription.get(strField))),accList[0].Notification_Country_Code__c,''));
                }    
            }
        }
        return Message;
    }
    
    /*
Description: Update this filed to let Massive know that the user has logged out.
*/
    @future
    public static void updateSignoutKey(String accountId){
        //checking whether this object have DML permissions and checking field level security for this profile(PD-7929)
        try{
            //commented because isAccessible doesn't make sense here
            //if(schema.SObjectType.Account.fields.AuthKey__c.isAccessible() ){
                Account updatesignoutkey = new Account();
                updatesignoutkey.Id = accountId;
                updatesignoutkey.AuthKey__c = System.now();
                update updatesignoutkey;                       
            //}                     
            //else{ //if this user doest have permition to update then notify the same to system admin    
            //    String strError = 'Error faced while update :'+' User Id :'+UserInfo.getUserID();
            //    SendEmailWithErrorsToAdmins.sendEmail(strError);             
            //} 
        }
        catch (Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunityHelper', 'getAllDataCategories', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            String strError = 'Error faced while update Account fields:'+' User Id :'+UserInfo.getUserID();
            SendEmailWithErrorsToAdmins.sendEmail(strError);    
        }
    }
    /*
Description: Method to delete User Devices
*/
    @future
    public static void removeDevices(List<ID> lstUserDevicesIDs){
        try{
            Database.delete(lstUserDevicesIDs);
        }
        catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunityHelper', 'removeDevice', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            String strError = 'Error faced while update :'+' User Id :'+UserInfo.getUserID();
            SendEmailWithErrorsToAdmins.sendEmail(strError);  
        }        
    }
    /*
Description: Method to delete User Device
*/
    
    public static void removeDevice(ID SUserDevicesID){
        try{
            Database.delete(SUserDevicesID);
        }
        catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunityHelper', 'removeDevice', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            String strError = 'Error faced while update :'+' User Id :'+UserInfo.getUserID();
            SendEmailWithErrorsToAdmins.sendEmail(strError);  
        }        
    }   
    
    /*
Description: This method get the current user information.
*/
    public static User getCurrentUser(){
        List<User> lstuser = [
            SELECT Name, FirstName, LastName, Email, UserName, AccountID, CountryCode, Country, contactId, LanguageLocaleKey, Contact.Account.Notification_Country_Code__c,
                Account.Disable_Payment_method_updated_emails__c, Account.Disable_transactional_emails__c, profileid, Profile.IsSsoEnabled, Account.DAZN_Id__c, Account.Notification_Country_Code__c
            FROM User
            WHERE ID = :UserInfo.getUserId() LIMIT 1
        ];
        return (lstuser != null && lstuser.size() > 0) ? lstuser[0] : null;
    }
    
    /*
Description: This method is used to identify logged in user country.
*/
    public static string getUserCountry(User oUser){
        if(oUser==null)
            oUser = getCurrentUser();
        // Getting Country Code form user and Validation than return string*this is changed for PD-7886*  
        string oUsrCountryCode = oUser.CountryCode;
        if(oUsrCountryCode!=null && oUsrCountryCode !='') {
            return oUsrCountryCode;
        }
        return null;            
    }
    
    /*
Description: This method get the payment method details for logged-in user.
*/
    public static Zuora__PaymentMethod__c getPaymentInformation(Id AccountId){
        List <Zuora__PaymentMethod__c> lstPaymentMethod =  [Select Zuora__BillingAccount__r.Zuora__Account__c, 
                                                            Zuora__Type__c,Zuora__CreditCardType__c, Zuora__DefaultPaymentMethod__c, 
                                                            Zuora__CreditCardExpirationMonth__c, Zuora__CreditCardExpirationYear__c, 
                                                            Zuora__CreditCardMaskNumber__c, Zuora__PaypalEmail__c,
                                                            Zuora__BankTransferAccountNumber__c
                                                            from Zuora__PaymentMethod__c
                                                            where Zuora__DefaultPaymentMethod__c = true and  
                                                            Zuora__BillingAccount__r.Zuora__Account__c = :AccountId
                                                            order by Zuora__CreatedDate__c DESC]; 
        if(lstPaymentMethod!= NULL && !lstPaymentMethod.isEmpty()){
            return lstPaymentMethod[0];
        }
        return null;
    }
    
    /*
Description: This method is used to get the user language code.
*/
    public static string getLanguageCode(){
        string strLanguage;
        if(userInfo.getUserType().Equals('Guest')){                
            if(ApexPages.currentPage()!=null && !String.IsEmpty(ApexPages.currentPage().getParameters().get('lang')))
                strLanguage=ApexPages.currentPage().getParameters().get('lang');
            else
                strLanguage='en_GB';
        }
        else
            strLanguage=userInfo.getLanguage();
        return strLanguage;
    }
    
    /*
Description: This method is used to get all data categories configured in system
*/
    public static MAP<String,String>  getAllDataCategories(String strDataCategory){
        MAP<String,String> mapHomePageDataCategories;
        List<DescribeDataCategoryGroupResult> describeCategoryResult;
        List<DescribeDataCategoryGroupStructureResult> describeCategoryStructureResult;
        
        try {
            List<String> objType = new List<String>();
            objType.add('KnowledgeArticleVersion');
            describeCategoryResult = Schema.describeDataCategoryGroups(objType);
            List<DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
            
            for(DescribeDataCategoryGroupResult singleResult: describeCategoryResult){
                DataCategoryGroupSobjectTypePair p = new DataCategoryGroupSobjectTypePair();
                p.setSobject(singleResult.getSobject());
                p.setDataCategoryGroupName(singleResult.getName());
                pairs.add(p);
            }
           describeCategoryStructureResult = Schema.describeDataCategoryGroupStructures(pairs, false);
            
            for(DescribeDataCategoryGroupStructureResult singleResult : describeCategoryStructureResult){
                DataCategory [] toplevelCategories = singleResult.getTopCategories();
                List<DataCategory> allCategories = getAllCategories(toplevelCategories);                                
                for(DataCategory category : allCategories) {                 
                    if(category.getName().Equals(strDataCategory))
                    {
                        mapHomePageDataCategories=new Map<String,String>();
                        for(DataCategory dataCategory : category.getChildCategories())
                        {                  
                            mapHomePageDataCategories.put(dataCategory.getName(),dataCategory.getLabel());
                        }
                    }
                }
                }
        }catch (Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunityHelper', 'getAllDataCategories', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        }
        return mapHomePageDataCategories;
    }
    
    /*
Description: This method is used to get all data categories by Data Category Group Name
*/
    public static MAP<String,String> getDataCategoriesByDataCategoryGroupName(String strDataCategoryGroup){
        MAP<string,string> mapHomePageDataCategories=new MAP<string,string>();
        List<DescribeDataCategoryGroupResult> describeCategoryResult;
        List<DescribeDataCategoryGroupStructureResult> describeCategoryStructureResult;
        
        try {
            List<String> objType = new List<String>();
            objType.add('KnowledgeArticleVersion');
            describeCategoryResult = Schema.describeDataCategoryGroups(objType);
            List<DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
            
            for(DescribeDataCategoryGroupResult singleResult: describeCategoryResult){
                DataCategoryGroupSobjectTypePair p = new DataCategoryGroupSobjectTypePair();
                p.setSobject(singleResult.getSobject());
                p.setDataCategoryGroupName(singleResult.getName());
                if(singleResult.getName().equals(strDataCategoryGroup))
                    pairs.add(p);
            }
            describeCategoryStructureResult = Schema.describeDataCategoryGroupStructures(pairs, false);
            
            for(DescribeDataCategoryGroupStructureResult singleResult : describeCategoryStructureResult){
                
                DataCategory [] toplevelCategories = singleResult.getTopCategories();
                List<DataCategory> allCategories = getAllCategories(toplevelCategories);
                for(DataCategory category : allCategories) {                       
                    for(DataCategory dataCategory : category.getChildCategories())
                    {
                        mapHomePageDataCategories.put(dataCategory.getName(),dataCategory.getLabel());
                    }
                }
            }
        }catch (Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CommunityHelper ', 'getDataCategoriesByDataCategoryGroupName', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
        return mapHomePageDataCategories;
    }
    
    
    /*
Description: This method is used to get all child categories for parent categories.
*/
    private static DataCategory[] getAllCategories(DataCategory [] categories){
        if(categories.isEmpty()){
            return new DataCategory[]{};
                } else {
                    DataCategory [] categoriesClone = categories.clone();
                    DataCategory category = categoriesClone[0];
                    DataCategory[] allCategories = new DataCategory[]{category};
                        categoriesClone.remove(0);
                    categoriesClone.addAll(category.getChildCategories());
                    allCategories.addAll(getAllCategories(categoriesClone));
                    return allCategories;
                }
    }
    
    /*
Method to get the user subscription information.
*/
    public static List<Account> getUserSubscription(User oUser){
        if(oUser == null){
            oUser = CommunityHelper.getCurrentUser();
            
        }
        
        List<Account> lstAccount=[select ID, Account_Status__c, Pause_From__c, PauseScheduled__c, Pause_Until__c, Previous_BCD__c, Submitted_for_cancellation__c,
                                  (Select Zuora__Status__c,Name,Zuora__NextRenewalDate__c,Zuora__Account__c,Zuora__SubscriptionEndDate__c,
                                   Id,Zuora__External_Id__c, Zuora__NextChargeDate__c,Zuora__CustomerAccount__r.Zuora__Currency__c 
                                   From Zuora__Subscriptions__r 
                                   Order By CreatedDate DESC NULLS LAST),
                                  (Select ID, Zuora__Amount__c, Zuora__EffectiveDate__c,Zuora__Status__c, Zuora__BillingAccount__r.Zuora__Currency__c 
                                   From Zuora__Payments__r 
                                   Order By Zuora__EffectiveDate__c DESC NULLS LAST
                                  )
                                  FROM Account 
                                  Where ID=:oUser.AccountId];
        return lstAccount;
    }
    
    
    /***********************************************************************************
@Method Name: checkIfAllSubscriptionsCancelled
@Method Description: Added method to check if all subs for an account are cancelled or not
@Param: List of z subscriptions
***********************************************************************************/
    public static Boolean checkIfAllSubscriptionsCancelled(List<Zuora__Subscription__c> lstSubscription){
        Boolean isAllCancelled = true;
        for(Zuora__Subscription__c zSub : lstSubscription){
            if(zSub.Zuora__Status__c == 'Active'){
                isAllCancelled = false;
                break;
            }
        }
        
        return isAllCancelled;
        
    }
    
    /*
Method to get the date as per the locale of the user
*/
    public static string getDateByLocale(Datetime dt){
    String localeFormattedDate = null;
        if(dt != null){
            String paymentEffectiveDate = (dt).format();
            localeFormattedDate = paymentEffectiveDate.substring(0,paymentEffectiveDate.indexOf(' '));   //.replace('/', '.');            
        }
        return localeFormattedDate;
    }  
/*
Method to get the date as per the locale of the user
*/
   public static string ConvertDateToString(Datetime dt) {
        String localeFormattedDate = null;
        String Month = null;
        String strDate = null;
        if (dt != null) {
            Integer dy = dt.day();
            Integer mon = dt.month();
            Month = String.valueOf(mon);
            strDate = String.valueOf(dy);
            if (mon < 10) {
                Month = '0' + String.valueOf(mon);
            }
            if (dy < 10) {
                strDate = '0' + String.valueOf(dy);
            }
            Integer yr = dt.year();
          localeFormattedDate = strDate + '/' + Month + '/' + String.valueOf(yr);
        }
        return localeFormattedDate;
    } 

/**
*  @author Megha Jain
*  @date September 26, 2017
*  @description : This method is used to create the Localized  date  per the user language 
   @Parameter : Date 
*/
 public static String localMonthNameForLanguageSwitch(Integer month , String sLangCode){
        
        String key;
        String sCountryCode;
        String strLangCode;
        String monthName;
        User user ; 
        if(user==null)
        {
            user = CommunityHelper.getCurrentUser();
        }
        if (sLangCode.equalsIgnoreCase('en_GB') || sLangCode.equalsIgnoreCase('EN_GB') ) {
            strLangCode ='en_GB';
        }
         else if(sLangCode.equalsIgnoreCase('DE') || sLangCode.equalsIgnoreCase('de') ) {
         strLangCode ='de';
      }
      
        List<String>countryList = new List<String>();
        Map<String,String>monthAndCountryMap = new Map<String,String>();

        if(!String.isBlank(strLangCode)  && month !=null ){
            key = strLangCode +':'+month ;
            
           List<DAZN_Country_Localized_Month__c> conRecords = [SELECT Month_In_Local_Lang__c , Month_In_Number__c , Language_Code__c FROM DAZN_Country_Localized_Month__c];
            
            for (DAZN_Country_Localized_Month__c localMonth :conRecords ){
                
                monthAndCountryMap.put(localMonth.Language_Code__c+':'+localMonth.Month_In_Number__c,localMonth.Month_In_Local_Lang__c);
                
                   if(monthAndCountryMap.containsKey(key) ){
                    monthName = monthAndCountryMap.get(key); 
                   
                }         
            }      
        }
        return monthName;
    }



  /**
*  @author Megha Jain
*  @date March 26, 2017
*  @description : This method is used to create the Localized  date  per the user language 
   @Parameter : Date 
*/
    public static string ConvertDateToString (Date dt,String localLang){
        
        Integer month =dt.month();
        Integer year = dt.Year();
        Integer day= dt.day();
      
        String strLocaleFormattedDate = null;
        string strLanguage = localLang;
        string locMonth = localMonthNameForLanguageSwitch(month ,strLanguage);
    
        if ( strLanguage.equalsIgnoreCase('ja')){
            
            if(dt != null){
                strLocaleFormattedDate = year+'/'+month +'/'+day;   
            }
                 
        }else if (strLanguage.equalsIgnoreCase('de')) {

            string nday = (day<10 ? string.valueof('0'+day):string.valueof(day));
            strLocaleFormattedDate = nday +'.'+locMonth+' '+year ;
        }else if (strLanguage.equalsIgnoreCase('en_GB')){
            strLocaleFormattedDate = day+' '+locMonth+' '+year;
        }
        return strLocaleFormattedDate ;
    }

    /**
    *  @author : Nayan Behera (Cognizant)
    *  @date : 02-Aug-2018 
    *  @description : This method is created as a part of PD-14250 to convert date to string inorder to avoid locale issue.
    */    
   public static string ConvertDateToString(Date dt,String country,String lang){
        String formattedDateStr = null;
        String monthStr = null;
        String dateStr = null;
       	System.debug('DateBefore'+dt);
        if(dt != null){
            Integer dayInt = dt.day();
            Integer monthInt = dt.month();            
            Integer yearInt = dt.year();
            monthStr =String.valueOf(monthInt);
            dateStr = String.valueOf(dayInt);
            if (monthInt < 10) {
                 monthStr = '0'+String.valueOf(monthInt);
            }
            if (dayInt < 10) {
                 dateStr = '0'+String.valueOf(dayInt);
            }            
        	if(country == 'CA' || country == 'DE')//Date format for Canada and German
                formattedDateStr =  dateStr+'/'+monthStr+'/'+String.valueOf(yearInt);
            else if(country == 'AT')//Date format for DACH
                formattedDateStr =  dateStr+'.'+monthStr+'.'+String.valueOf(yearInt);
            else if(country == 'ZouraFormat')
                formattedDateStr =  String.valueOf(yearInt)+'-'+monthStr+'-'+dateStr;
            else//Date format for JP and rest of the countries
                formattedDateStr =  String.valueOf(yearInt)+'/'+monthStr+'/'+dateStr;
        }
       	
        return formattedDateStr;
    } 
    
    /* 
Description: This method update Account status. 
Note: This method is implemented for Cancellation.
*/
    public static void updateAccountStatus(Id sId, string sStatus){
        if(sId != null && sStatus != null){
            Account objAccount=[Select ID, Account_Status__c, Submitted_for_cancellation__c, Cancelled_Account__c, Pause_From__c, PauseScheduled__c, Pause_Until__c, Previous_BCD__c From Account where ID =:sId Limit 1];
            if (sStatus == 'Frozen' && (objAccount.Account_Status__c == 'Paused' || objAccount.PauseScheduled__c)) {
                objAccount.Submitted_for_cancellation__c = true;
                objAccount.Pause_Until__c = null;
                objAccount.Pause_From__c = null;
                objAccount.Cancelled_Account__c = true;
            }
            objAccount.Account_Status__c = sStatus;
            
            update objAccount;
        }
    }
    
    /* 
Description: This method update Account cancelled checkbox. 
*/
    public static void updateAccountCancelledCheckbox(Id sId, boolean sCancelledStatus){
        if(!string.isBlank(sId)){
            Account objAccount=[Select ID, Cancelled_Account__c From Account where ID =:sId Limit 1];
            objAccount.Cancelled_Account__c = sCancelledStatus;
            update objAccount;
        }
    }
    
    /*
Description: This method obfucate the email address.
*/
    public static string getObfuscatedEmail(string sEmailToObfuscate){
        string sObfuscatedEmail = null;
        if(sEmailToObfuscate != null && sEmailToObfuscate.indexOf('@') > -1){
            string[] arrString = sEmailToObfuscate.split('@');
            string sStars = '';
            for(Integer iCount = 0; iCount < arrString[0].length()-2; iCount++){
                sStars = sStars + '*';
            }
            sObfuscatedEmail = arrString[0].subString(0,1) + sStars + arrString[0].subString(arrString[0].length()-1,arrString[0].length()) + '@' + arrString[1];
        }else{
            sObfuscatedEmail = sEmailToObfuscate;
        } 
        return sObfuscatedEmail;
    }
    
    /*
Description: Method to get currency symbol based on currency ISO code on Billing Account object from zuora.
*/
    public static string getCurrencySymbol(string sCurrencyISOCode){
        
        /*if('JPY' == sCurrencyISOCode )
{
if(UserInfo.getLanguage().equals('ja'))
return '¥' ;
else
return '¥' ;
}*/
        // Changes made for PD-8514
        String currencySymbol= DAZN_Country_Currency_ISO_Code__c.getValues(sCurrencyISOCode).CurrencySymbol__c;
        if (UserInfo.getLanguage() == 'ja' && DAZN_Country_Currency_ISO_Code__c.getValues(sCurrencyISOCode).CurrencySymbol__c == '¥') {
            currencySymbol = '円';
        }
        return currencySymbol;
    }
    
    /*
Description: Method to create signoff task.
*/
    @future
    public static void createSignOffTask(string contactId, string accountId, string sTaskSubject, string sTaskDescription){
        try{
            //Checking the user has an access to the fields below before inserting Task (PD-7903)
            //if(schema.SObjectType.Task.fields.Priority.isAccessible()&& 
            //   schema.SObjectType.Task.fields.Status.isAccessible()&& 
            //   schema.SObjectType.Task.fields.subject.isAccessible()&&
            //   schema.SObjectType.Task.fields.Description.isAccessible()&& 
            //   schema.SObjectType.Task.fields.ActivityDate.isAccessible())  {
                   
                   Task signOutTask = new Task ( WhoId = contactId, WhatId = accountId,
                                                priority = 'High', status = 'Completed', 
                                                Subject = sTaskSubject,
                                                description = sTaskDescription, ActivityDate = Date.today()
                                                
                                               );
                   
                   insert signOutTask;
            //   }
            //else
            //{ //if this user doesn't have permission to create a task then notify the same to system admin
            //    String strError = 'Error faced while inserting a Task :'+' User Id :'+UserInfo.getUserID();
            //    SendEmailWithErrorsToAdmins.sendEmail(strError);   
            //}
        }
        catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserID(), 'CommunityHelper', 'createSignOffTask', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());                   
        }
        
    }

    public static String formatDecimal(Decimal decimalToFormat) {
        String strDecimal = String.valueOf(decimalToFormat);
        List<String> splittedDecimal = strDecimal.split('\\.');
        String strDecimalInt = splittedDecimal[0];
        String formattedDecimal = '';
        for (Integer endInd = strDecimalInt.length(); endInd > 0; endInd -= 3) {
            Integer startInd = (endInd - 3 < 0) ? 0 : endInd - 3;
            formattedDecimal = ',' + strDecimalInt.substring(startInd, endInd) + formattedDecimal;
        }
        formattedDecimal = formattedDecimal.removeStart(',') + ((splittedDecimal.size() > 1) ? '.' + splittedDecimal[1] : '');

        return formattedDecimal;
    }
    
    /**
     * @ Author : Cognizant Technology Solutions
     * @ Description: Centralized method to format currency for different country and language.
     * @ PD-15067 : Merged getformattedAmountForCA to this method so that same method can also be used for candian user.
    */
    public static String getformattedAmount(String sCurrencyISOCode, Decimal sAmount, String sCountry) {
        String sCurrencyFormatByCountry = '#,###.##';
        String sFormatedCurrencyWithSymbol;
        String sFormattedCurrency = '';
        if (sCountry == null) {
            sCountry = getCurrentUser().Country;
        }        
        PaymentMethodOptionConfig__c oCurrencyFormatByCountry=PaymentMethodOptionConfig__c.getValues(sCountry);
        if (oCurrencyFormatByCountry != null && !String.isBlank(oCurrencyFormatByCountry.Currency_Format__c)) {
            sCurrencyFormatByCountry=oCurrencyFormatByCountry.Currency_Format__c;
        }
        List<String> args = new String[]{'0', 'number', sCurrencyFormatByCountry};
        if (UserInfo.getLanguage() == 'ja'|| sCountry.equalsIgnoreCase('Japan') || sCountry.equalsIgnoreCase('JP') ){
        sFormattedCurrency = String.format(formatDecimal(Integer.valueOf(sAmount)), args);
        }else {
        sFormattedCurrency = String.format(formatDecimal(sAmount), args);
        }

        //PD-8557:Appended Zero(0) to make currency two digits 
        String[] decimalValue = new String[]{};
        if (sFormattedCurrency.contains(',')) {
            decimalValue = sFormattedCurrency.split(',');
        } else if (sFormattedCurrency.contains('.')) {
            decimalValue = sFormattedCurrency.split('\\.');
        }
        /*Added as a part of PD-11618*/
        if (sCurrencyISOCode == '$') {
            if (!sFormattedCurrency.contains('.')) {
                sFormattedCurrency = sFormattedCurrency + '.' + System.Label.Zero + System.Label.Zero;
            }
        }
        //End of PD-11618
        if (decimalValue.size() > 1  && decimalValue[1].length() == 1) {
            sFormattedCurrency = sFormattedCurrency + System.Label.Zero;  
        }//End of PD-8557
        
		if (sCurrencyISOCode == '?' || sCurrencyISOCode == '€') {
            sFormatedCurrencyWithSymbol = sFormattedCurrency + sCurrencyISOCode;
        /*start PD-6304*/
        }else{
            if(UserInfo.getLanguage() == 'ja' || UserInfo.getLanguage() == 'fr_CA' || UserInfo.getLanguage() == 'fr')//PD-15067: Check if it's a Japan or canada user
                sFormatedCurrencyWithSymbol =  sFormattedCurrency + sCurrencyISOCode;
            else
                sFormatedCurrencyWithSymbol = sCurrencyISOCode + sFormattedCurrency;
        }
        /*end PD-6304*/
        return sFormatedCurrencyWithSymbol;
    }
    /*
Description: Method to get account information.
*/
    public static Account getAccountInfo(Id sAccountId){
      //Added new two fields as part of PD-11206- 13-03-2017
        List<Account> lstAccount = [Select Id, FirstName, LastName, DFD_Last_Name__c, DFD_First_Name__c, PersonEmail, Secondary_Email__c, IsPersonAccount, Account_Status__c, Partner_ID__c, Retrieve_Email__c, Notification_Country_Code__c,Notification_Language_Code__c,Submitted_for_cancellation__c, All_Email_Preferences__c,Is_Double_OptIn__c From Account Where Id = :sAccountId Limit 1];
        if(lstAccount != null && lstAccount.size()>0){       
            return lstAccount[0];
        }
        else{
            return null;
        }
    }
    
    /*
Description: Method to get zuora account information.
*/
    public static Zuora__CustomerAccount__c getZuoraAccountInfo(Id sAccountId){
        List<Zuora__CustomerAccount__c> lstBillingAccount = new List<Zuora__CustomerAccount__c>();
        lstBillingAccount=[Select ID, Zuora__Zuora_Id__c From Zuora__CustomerAccount__c where Zuora__Account__c =:sAccountId Limit 1];
        return lstBillingAccount[0]; 
    }
    
    /*
Description: Method to redirect user to home page.
*/
    public static PageReference redirectToHomePage() {
        string sCountry = getUserCountryName(null);
        PageReference oPageReference = null ;
        string sHomePageURL = getMassiveURLs(sCountry,'HomePageURLType');
        if (sHomePageURL != null ){
            oPageReference = new PageReference(sHomePageURL);
            oPageReference.setRedirect(true);
        }
        return oPageReference;
    }
    /*
Description: Method to redirect user to home page based on ipaddress and country
*/
    public static PageReference validateIPAddress(String sPageName,String afterHelp){  
        
        string ReturnValue = '';  
        string country;
        String languageName;
        ReturnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        if (ReturnValue == '' || ReturnValue == null) {
            ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        } 
        if (ReturnValue == '' || ReturnValue == null) {
            ReturnValue = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
        } 
        Http httpObj = new Http();
        HttpRequest req = new HttpRequest();
        //Modified IPADDRESSFINDER Url from custom label to custom settings as part of PD-15349
        if(!String.isBlank(DAZNConfiguration__c.getValues('IPADDRESSFINDER').Value__c) && !String.isBlank(ReturnValue)){ //PD-7939
            req.setEndpoint(DAZNConfiguration__c.getValues('IPADDRESSFINDER').Value__c+ReturnValue);
        }
        req.setMethod('GET');
        req.setTimeout(Integer.valueOf(DAZNConfiguration__c.getValues('Geo IP timeout').Value__c));// Modified timeout period from 120000 ms to 4999 ms as pert of PD-12993
        
        HttpResponse res;
        try{
            res = httpObj.send(req);
        }
        catch(Exception ex){
            
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserID(), 'CommunityHelper', 'getUserCountryfromIPAddress', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());           
            redirectToErrorPage(ex.getMessage());
        }
        if( res.getStatusCode() != 200){
            list<DAZN_Help_Redirect__c> notsupportedString = [select Name from DAZN_Help_Redirect__c where IsDefaultCountry__c = true ];
            country =notsupportedString[0].Name;
            String countryName = DAZN_Help_Redirect__c.getInstance(country).CountryISOCode__c;
            languageName = DAZN_Help_Redirect__c.getInstance(country).Language__c;
            PageReference retPage;        
            retPage  = new pagereference(Site.getBaseUrl()+ '/'+ sPageName + '/'+ countryName+'-'+languageName+afterHelp);
            retPage.setRedirect(true);
            return retPage;  
        }               
        else{
            Map<String, Object> mapOfResponseObj= (Map<String, Object>)JSON.deserializeUntyped(res.getbody());           
            Map <String, Object> detailsObject = (Map <String, Object>)mapOfResponseObj.get('country');                    
            country =(String)detailsObject.get('name');
            list<DAZN_Help_Redirect__c> customSetList = [select Name from DAZN_Help_Redirect__c LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())];
            set<string> cusSet = new set<string>(); 
            For(DAZN_Help_Redirect__c daznObj :customSetList){ 
                cusSet.add(daznObj.Name); 
            } 
            if(cusSet.contains(country)){
                String countryName = DAZN_Help_Redirect__c.getInstance(country).CountryISOCode__c;
                languageName = DAZN_Help_Redirect__c.getInstance(country).Language__c;
                PageReference retPage;
                retPage  = new pagereference(Site.getBaseUrl()+ '/'+ sPageName + '/' + countryName +'-'+ languageName+afterHelp);
                retPage.setRedirect(true);
                return retPage;                     
            }
            else{
                list<DAZN_Help_Redirect__c> notsupportedString = [select Name from DAZN_Help_Redirect__c where IsDefaultCountry__c = true ];
                country =notsupportedString[0].Name;
                String countryName = DAZN_Help_Redirect__c.getInstance(country).CountryISOCode__c;
                languageName = DAZN_Help_Redirect__c.getInstance(country).Language__c;
                PageReference retPage;        
                retPage  = new pagereference(Site.getBaseUrl()+ '/'+ sPageName  + '/'+ countryName+'-'+languageName+afterHelp);
                retPage.setRedirect(true);
                return retPage;                     
            }                   
        }              
    }
    
    /*
Description: Method to redirect user signed in redirect to the users Language and Territory of the user:
*/
    public static PageReference signUsrRed(String sPageName,String afterHelp){  
        User existUser = [select firstname,Notification_Language_Code__c,CountryCode from user where id=:userinfo.getuserid()];
        String userLang = existUser.Notification_Language_Code__c;
        String userCountry = existUser.CountryCode;
        
        if(userLang == 'en_GB' || userLang == 'en_US')
            userLang='en';        
        PageReference oPageReference = new PageReference(Site.getBaseUrl()+'/'+sPageName+'/'+userCountry+'-'+userLang+afterHelp);
        oPageReference.setRedirect(true);
        return oPageReference;
    }

    /*
    decide if future context is needed or not 
    */
    public static void callFutureOrNot(List<Id> idList) {
        if (!System.isBatch() && !System.isFuture() && !Test.isRunningTest()){
            //call the future context method
            ZuoraTransactionHelper.updateTestUserAccountBulkFuture(idList);
        } else if (!Test.isRunningTest()) {
            //don't call the future context method
            ZuoraTransactionHelper.updateTestUserAccountBulk(idList);
        }
    }

    /*
Description: Method to create task in future
*/
    @future
    public static void createTaskFromFuture(string sContactId, string sAccountId, string sTaskSubject, string sTaskDescription){
        //Checking the user has a access to the fields below before inserting thr Task(PD-7903)
        //if(schema.SObjectType.Task.fields.Priority.isAccessible()&& 
        //   schema.SObjectType.Task.fields.Status.isAccessible()&& 
        //   schema.SObjectType.Task.fields.subject.isAccessible()&&
        //   schema.SObjectType.Task.fields.Description.isAccessible()&& 
        //   schema.SObjectType.Task.fields.ActivityDate.isAccessible())  {
               
               Task oFutureTask = new Task ( WhoId = sContactId, WhatId = sAccountId,
                                            priority = 'High', status = 'Completed', 
                                            Subject = sTaskSubject,
                                            description = sTaskDescription, ActivityDate = Date.today()
                                           );
               
               insert oFutureTask;
        //   }
        //else
        //{ //if this user doesn't have permission to create a task then notify the same to system admin
        //    String strError = 'Error faced while inserting a Task :'+' User Id :'+UserInfo.getUserID();
        //    SendEmailWithErrorsToAdmins.sendEmail(strError);   
        //}
    }
    
    /*
Description: Method to create task
*/
    public static Task createTask(string sContactId, string sAccountId, string sTaskSubject, string sTaskDescription){
        //Checking the user has a access to the fields below before inserting Task (PD-7903)
        //if(schema.SObjectType.Task.fields.Priority.isAccessible()&& 
        //   schema.SObjectType.Task.fields.Status.isAccessible()&& 
        //   schema.SObjectType.Task.fields.subject.isAccessible()&&
        //   schema.SObjectType.Task.fields.Description.isAccessible()&& 
        //   schema.SObjectType.Task.fields.ActivityDate.isAccessible())  {
               
               Task oTask = new Task ( WhoId = sContactId, WhatId = sAccountId,
                                      priority = 'Medium', status = 'Completed', 
                                      Subject = sTaskSubject,
                                      description = sTaskDescription, ActivityDate = Date.today()
                                     );
               
               return oTask;
        //   }
        //else
        //{ //if this user doesn't have permission to create a task then notify the same to system admin
        //    String strError = 'Error faced while inserting a Task :'+' User Id :'+UserInfo.getUserID();
        //    SendEmailWithErrorsToAdmins.sendEmail(strError);   
        //    return null;
        //}
    }
    
    /*
Description: MEthod to get a list of Billing Accounts on the basis of the Account Ids
*/
    
    public static List<Zuora__CustomerAccount__c> getZBillingAccounts(Set<Id> accountIDs){
        return [SELECT Zuora__Account__c,Zuora__External_Id__c FROM Zuora__CustomerAccount__c where Zuora__Account__c IN :accountIDs];
        
    }
    
    /*
Description: Method to encrypt plain text using crypto class.
*/
    public static String encrypt(String sKey, String sText){
        try{
            Blob data = Blob.valueOf(sText);
            Blob cryptoKey = Blob.valueOf(sKey);
            Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey, data);
            return EncodingUtil.base64Encode(encryptedData);
        }catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(userinfo.getUserId(), 'CommunityHelper', 'encrypt', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return null;
        }
    }
    
    /*
Description: Method to encrypt text using crypto class.
*/
    public static String decrypt(String sKey, String sText){
        try{
            Blob cryptoKey = Blob.valueOf(sKey);
            Blob encryptedData = EncodingUtil.base64Decode(sText);
            Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey, encryptedData);
            return decryptedData.toString();
        }catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(userinfo.getUserId(), 'CommunityHelper', 'decrypt', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return null;
        }
    }
    
    
    /* 
Description: Method to signout user from all devices
*/    
    public static void signOutOfAllDevices(User oUser)
    {
        try{
            if(oUser!= null){
                List<User_Devices__c> lstAllUserDevices = [SELECT id,Status__c
                                                           FROM User_Devices__c where Account__c =:oUser.AccountId and Status__c='Active' LIMIT 100];
                List<ID> lstUserDevicesID=new List<ID>();
                List<AuthSession> lstActiveUserSessions = [Select ID From AuthSession Where UsersId =: oUser.Id]; 
                if(lstAllUserDevices!=null && !lstAllUserDevices.isEmpty())
                {
                    for(User_Devices__c oUser_Devices : lstAllUserDevices)
                        lstUserDevicesID.add(oUser_Devices.ID);
                }
                if(lstActiveUserSessions!=null && !lstActiveUserSessions.isEmpty()){
                    delete(lstActiveUserSessions);
                    }
                if(lstUserDevicesID.size()>0){
                    removeDevices(lstUserDevicesID);
                }   
                if(oUser.AccountId != null){
                    updateSignoutKey(oUser.AccountId);   
                }
                if(oUser.AccountId != null && oUser.ContactId != null ){ 
                    createSignOffTask(oUser.ContactId, oUser.AccountId,System.Label.LS_SignOutDevice_TaskSubject, System.Label.LS_SignOutDevice_TaskDesc);
                }     
            }
        }
        catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(oUser.id, 'CommunityHelper', 'signOutOfAllDevices', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            redirectToErrorPage(ex.getMessage());
        }
    }
    
    /* 
     Description: Method to signout user from all devices from Account Detail. Sends callout to MISL.
    */
    public static String signOutOfAllDevicesFromAccDetail(User oUser) {
        String statusMessage = 'Failed';
        if (oUser != null) {
            String currentAccountId = String.isNotBlank(oUser.Account.DAZN_Id__c) ? oUser.Account.DAZN_Id__c : oUser.AccountId;
            Map<String, Object> payload = new Map<String, Object>{
                'AllDevices' => true,
                'AccountId' => currentAccountId
            };
            Map<String, String> calloutResult = MISLCalloutHelper.deRegisterDevices(payload, oUser.AccountId, oUser.Account.Notification_Country_Code__c);
            Boolean isResultSuccess = Boolean.valueOf(calloutResult.get('success'));
            if (isResultSuccess) {
                statusMessage = 'Success';
                MyAccountController.deleteAuth(oUser.Id);
            } else {
                if (calloutResult.get('message') == 'DeRegisterDevices endpoint is disabled') {
                    List<Id> lstUserDevicesIds = new List<Id>();
                    List<User_Devices__c> lstAllUserDevices = [
                        SELECT Id, Status__c
                        FROM User_Devices__c
                        WHERE Account__c = :oUser.AccountId AND Status__c = 'Active' LIMIT 100
                    ];
                    if (!lstAllUserDevices.isEmpty()) {
                        for (User_Devices__c userDevice : lstAllUserDevices) {
                            lstUserDevicesIds.add(userDevice.Id);
                        }
                    }
                    if (lstUserDevicesIds.size() > 0) {
                        removeDevices(lstUserDevicesIds);
                    }
                    if (oUser.AccountId != null) {
                        updateSignoutKey(oUser.AccountId);
                    }
                    statusMessage = 'Success';
                    MyAccountController.deleteAuth(oUser.Id);
                } else {
                    statusMessage = calloutResult.get('message');
                    statusMessage = (statusMessage == '404 - No devices found.') ? 'NoDevices' : statusMessage;
                }
            }
        }
        return statusMessage;
    }
    
    /*Description: Method to signout user from device or all devices from Account Detail. Sends callout to MISL.*/
    public static Map<String, String> deRegisterDevicesMISL(User oUser, String deviceId, Boolean isAllDevice) {
        Map<String, String> result = new Map<String, String>();
        try {
            if (oUser != null) {
                
                String currentAccountId = String.isNotBlank(oUser.Account.DAZN_Id__c) ? oUser.Account.DAZN_Id__c : oUser.AccountId;
                Map<String, Object> payload;
                if (isAllDevice) {
                    payload = new Map<String, Object>{
                        'AllDevices' => isAllDevice,
                        'AccountId' => currentAccountId
                        
                    };
                } else {
                    payload = new Map<String, Object>{
                        'AllDevices' => isAllDevice,
                        'AccountId' => currentAccountId,
                        'DeviceId' => deviceId
                    };
                }
                
                result = MISLCalloutHelper.deRegisterDevices(payload, oUser.AccountId,oUser.Account.Notification_Country_Code__c);
                
                MyAccountController.deleteAuth(oUser.Id);
                
            }
        }
        catch (Exception ex) {
            ExceptionLoggerHelper.createExceptionLog(oUser.id, 'CommunityHelper', 'deRegisterDevicesMISL', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            redirectToErrorPage(ex.getMessage());
        }
        return result;
    }

    @future
    public Static void deleteUserDevice(Id objUserId){
        try{
            Database.delete(objUserId);
        }
        catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserID(), 'CommunityHelper', 'deleteUserDevice', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            String strError = 'Error faced while update :'+' User Id :'+UserInfo.getUserID();
            SendEmailWithErrorsToAdmins.sendEmail(strError);  
        }
    }   
    
    /*public static void signOutOfSingleDevices(String strEmail, String oUserDevicesID, List<String> oSourceIp)
    {                         
        if(strEmail != null && strEmail != '')/*Change made for PD-7931*/
        /*{
            strEmail = String.escapeSingleQuotes(strEmail);/*Change made for PD-7931*/
            /*User objUser = [SELECT Id,AccountId,Email FROM User WHERE Email = : strEmail];          
            
            if(oUserDevicesID != null && oUserDevicesID != '')
            {
                oUserDevicesID = String.escapeSingleQuotes(oUserDevicesID);/*Change made for PD-7931*/
                /*User_Devices__c singelUserDevice= [SELECT id,Account__c, Status__c,Type__c FROM User_Devices__c WHERE Account__c =:objUser.AccountId AND Device_Id__c = :oUserDevicesID];                         
                
                List<AuthSession> lstActiveUserSessionsDesktop = new List<AuthSession>();
                List<AuthSession> lstActiveUserSessions = new List<AuthSession>();
                if(oSourceIp != null && !oSourceIp.isEmpty()){            
                    lstActiveUserSessions = [Select ID, SourceIp From AuthSession Where UsersId =: objUser.Id AND SourceIp IN:oSourceIp]; 
                    
                    
                }else{                       
                    lstActiveUserSessionsDesktop = [Select ID From AuthSession Where UsersId =: objUser.Id];              
                }
                Id objId = singelUserDevice.id; 
                deleteUserDevice(objId);
                if(singelUserDevice.Type__c == 'Desktop'){                                         
                    delete lstActiveUserSessionsDesktop;                              
                }
                if(!lstActiveUserSessions.isEmpty() && lstActiveUserSessions != null){
                    delete lstActiveUserSessions;
                }  
            }
        }
    }*/
    
    /* 
Description: Method to signout user from all devices
*/  
    
    public static void signOutOfAllDevices(string sAccountID,string sUserID,string sContactID)
    {
        try{            
            
            List<User_Devices__c> lstAllUserDevices = [SELECT Status__c FROM User_Devices__c where Status__c='Active' LIMIT 100];
            
            List<ID> lstUserDevicesID=new List<ID>();
            List<ID> lstActiveUserSessionsIds=new List<ID>();
            list<Id> sessionIdsList = new list<Id>();
            List<AuthSession> lstActiveUserSessions = [Select ID From AuthSession Where UsersId =: sUserID];
            
            if(lstAllUserDevices!=null && !lstAllUserDevices.isEmpty())
            {
                for(User_Devices__c oUser_Devices : lstAllUserDevices)
                    lstUserDevicesID.add(oUser_Devices.ID);
            }
            if(lstActiveUserSessions!=null && !lstActiveUserSessions.isEmpty()){
                for(AuthSession authObj : lstActiveUserSessions){
                    sessionIdsList.add(authObj.id);     
                }
            }
            if(sessionIdsList.size()>0){
                deleteAuthSessions(sessionIdsList);
            }
            if(lstUserDevicesID.size()>0){
                RemovetheItems(lstUserDevicesID);
            }      
            if(!string.isBlank(sAccountId)){
                updateSignoutKey(sAccountId);    
            }
            
            if(!string.isBlank(sAccountId) && !string.isBlank(sContactId)  ){
                createSignOffTask(sContactId, sAccountId,System.Label.LS_SignOutDevice_TaskSubject, System.Label.LS_SignOutDevice_TaskDesc);
            }    
        }
        catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(sUserID, 'CommunityHelper', 'signOutOfAllDevices', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            redirectToErrorPage(ex.getMessage());
        }
    }
    
    public static void RemovetheItems(List<ID> lstUserDevicesID){
        removeDevices(lstUserDevicesID);
    }   
    
    @future
    public Static void deleteAuthSessions( List<Id> lstSeesions){
        try{
            Database.delete(lstSeesions);
        }
        catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(userinfo.getUserid(), 'CommunityHelper', 'deleteAuthSessions', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            String strError = 'Error faced while deleting Auth sessions :'+' User Id :'+UserInfo.getUserID();
            SendEmailWithErrorsToAdmins.sendEmail(strError);  
        }
    }     
    /* 
Description: Method to find out the country of the user from his IP Address
*/
    public static string getUserCountryfromIPAddress(){       
        
        string ReturnValue = '';  
        string country;
        ReturnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        if (ReturnValue == '' || ReturnValue == null) {
            ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        } 
        if (ReturnValue == '' || ReturnValue == null) {
            ReturnValue = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
        } 
        Http httpObj = new Http();
        HttpRequest req = new HttpRequest();
        //Modified IPADDRESSFINDER Url from custom label to custom settings as part of PD-15349
        if(DAZNConfiguration__c.getValues('IPADDRESSFINDER') != null && String.isNotBlank(DAZNConfiguration__c.getValues('IPADDRESSFINDER').Value__c) && String.isNotBlank(ReturnValue)) {//PD-7939
            req.setEndpoint(DAZNConfiguration__c.getValues('IPADDRESSFINDER').Value__c+ReturnValue);
        }
        req.setMethod('GET');

        if(DAZNConfiguration__c.getValues('Geo IP timeout') != null && String.isNotBlank(DAZNConfiguration__c.getValues('Geo IP timeout').Value__c)) {
            req.setTimeout(Integer.valueOf(DAZNConfiguration__c.getValues('Geo IP timeout').Value__c));// Modified timeout period from 120000 ms to 4999 ms as pert of PD-15349
        }
        HttpResponse res;
        try{
            res = httpObj.send(req); 
        }
        catch(Exception ex){
            if(shouldIRun.doubOptallow){//PD-11641
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserID(), 'CommunityHelper', 'getUserCountryfromIPAddress', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
                redirectToErrorPage(ex.getMessage());
            }
            
        }
        if(res !=null && res.getStatusCode() == 200){
            Map<String, Object> mapOfResponseObj= (Map<String, Object>)JSON.deserializeUntyped(res.getbody());           
            Map <String, Object> detailsObject = (Map <String, Object>)mapOfResponseObj.get('country');                    
            country =(String)detailsObject.get('name');
        } else {
            list<DAZN_Help_Redirect__c> notsupportedString = [select Name from DAZN_Help_Redirect__c where IsDefaultCountry__c = true ];
            country =notsupportedString[0].Name;
        }
        return country ;
    }
    
    /*
Description: This method is used to get the user language code.
*/
    public static string getUserLanguageCode(string strCountry){
       string strLanguage;
       String lang = ApexPages.currentpage().getParameters().get('lang');
       if (!String.isBlank(lang)) {
        return lang;
       }
        if(userInfo.getUserType().Equals('Guest')){     
            List<DAZNLanguageConfiguration__c> oDAZNLang = DAZNLanguageConfiguration__c.getall().values();
            Map<String,String> listOfCountries = new Map<String, String>();
            for(DAZNLanguageConfiguration__c oLang : oDAZNLang){
                listOfCountries.put(oLang.Country__c,oLang.Default_Language__c);  
            }
            if(listOfCountries!=null && listOfCountries.size() >0){
             if (listOfCountries.containsKey(strCountry)) {
                    strLanguage = listOfCountries.get(strCountry);
                }
                else {
                    strLanguage = 'en_GB';
                 }
            }
        }
        else{
            strLanguage=userInfo.getLanguage();
       }
        return strLanguage;
        
     }
    /*
Description: This method is used to get the user language code.
*/
    /*public static string getUserLanguageCode(string strCountry, string browserLang){
        string strLanguage;
        if(userInfo.getUserType().Equals('Guest')){     
            DAZN_Help_Redirect__c strCountryCode = DAZN_Help_Redirect__c.getInstance(strCountry);
            if(strCountryCode != null){
                strLanguage = browserLang;
            }
            else {
                strLanguage = 'en';
            }
        }
        else{
            strLanguage=userInfo.getLanguage();
        }
        return strLanguage;
    }*/
    
    /*
Description: This method is used to get the country of the user.
*/
    public static string getUserCountryName(User oUser){
        string sCountryName;
        if(userInfo.getUserType().Equals('Guest')){
                sCountryName = getUserCountryfromIPAddress();
        }
        else{
            if(oUser==null)
                oUser = CommunityHelper.getCurrentUser();
            sCountryName = oUser.Country;
        }
        return sCountryName;
        
    }
    
    /*
Description: This method is used to get the massive URLs.
*/
    public static string getMassiveURLs(string sCountry, string sURL){
        string sMassiveURL;
        DAZNBetaConfiguration__c oDAZNBetaConfig = DAZNBetaConfiguration__c.getValues(sCountry);
        DAZNConfiguration__c oDAZNConfiguration ;
        if(oDAZNBetaConfig != null && oDAZNBetaConfig.IsBeta__c){
            if( sURL == 'ForgotPasswordLinkType'){
                oDAZNConfiguration = DAZNConfiguration__c.getValues('ForgotPasswordLinkBeta');
                sMassiveURL = oDAZNConfiguration.Value__c;
            }
            else if( sURL == 'LoginPageURLType'){
                oDAZNConfiguration = DAZNConfiguration__c.getValues('LoginPageURLBeta');
                sMassiveURL = oDAZNConfiguration.Value__c;
            }
            else if( sURL == 'HomePageURLType'){
                oDAZNConfiguration = DAZNConfiguration__c.getValues('HomePageURLBeta');
                sMassiveURL = oDAZNConfiguration.Value__c;
            }
            else if( sURL == 'ForgotEmailURLType'){
                oDAZNConfiguration = DAZNConfiguration__c.getValues('Mylogin_ForgotEmailBeta');
                sMassiveURL = oDAZNConfiguration.Value__c;
            }
            else if( sURL == 'PasswordResetURLType'){
                oDAZNConfiguration = DAZNConfiguration__c.getValues('Mylogin_PasswordResetBeta');
                sMassiveURL = oDAZNConfiguration.Value__c;
            }
        }
        else{
            if( sURL == 'ForgotPasswordLinkType'){
                oDAZNConfiguration = DAZNConfiguration__c.getValues('ForgotPasswordLink');
                sMassiveURL = oDAZNConfiguration.Value__c;
            }
            else if( sURL == 'LoginPageURLType'){
                oDAZNConfiguration = DAZNConfiguration__c.getValues('LoginPageURL');
                sMassiveURL = oDAZNConfiguration.Value__c;
            }
            else if( sURL == 'HomePageURLType'){
                oDAZNConfiguration = DAZNConfiguration__c.getValues('HomePageURL');
                sMassiveURL = oDAZNConfiguration.Value__c;
            }
            else if( sURL == 'ForgotEmailURLType'){
                oDAZNConfiguration = DAZNConfiguration__c.getValues('Mylogin_ForgotEmail');
                sMassiveURL = oDAZNConfiguration.Value__c;
            }
            else if( sURL == 'PasswordResetURLType'){
                oDAZNConfiguration = DAZNConfiguration__c.getValues('Mylogin_PasswordReset');
                sMassiveURL = oDAZNConfiguration.Value__c;
            }
        }
        return sMassiveURL ;
    }
    
    //Method to redirect based on country
    /*  public Static void redirectBasedOnCountry(String strCountry){

DAZNBetaConfiguration__c oDAZNBetaConfig = DAZNBetaConfiguration__c.getValues(strCountry);
DAZNConfiguration__c oDAZNConfiguration ;

} */
    
    //  Description: Method to redirect Guest user in redirect to the users Language and Territory of the user
    
    public static PageReference PageRestBaseonTerritory(String sPageName,String afterHelp,String sTerritory){        
        String languageName;
        PageReference retPage;
        String countryName;
        if(DAZN_Help_Redirect__c.getInstance(sTerritory)!=null){
            
            countryName = DAZN_Help_Redirect__c.getInstance(sTerritory).CountryISOCode__c;
            languageName = DAZN_Help_Redirect__c.getInstance(sTerritory).Language__c;
            
            retPage  = new pagereference(Site.getBaseUrl()+ '/'+ sPageName + '/' + countryName +'-'+ languageName+afterHelp);
            retPage.setRedirect(true);
            return retPage;                     
        }
        
        else{
            
            list<DAZN_Help_Redirect__c> notsupportedString = [select Name, CountryISOCode__c,Language__c  from DAZN_Help_Redirect__c where IsDefaultCountry__c = true ];
            
            countryName = notsupportedString[0].CountryISOCode__c;
            languageName = notsupportedString[0].Language__c;
            
            retPage  = new pagereference(Site.getBaseUrl()+ '/'+ sPageName  + '/'+ countryName+'-'+languageName+afterHelp);
            retPage.setRedirect(true);
            return retPage;                     
        }         
    } 
    
    /***********************************************************************************
@Method Name: redirectToErrorPage
@Method Description: Added reusuable method for InternalServerError redirection page
@Param: PageReference  
***********************************************************************************/
    public static PageReference redirectToErrorPage(String strErrMsg){
        PageReference errorPage = null;
        errorPage = System.Page.InternalServerError;
        errorPage.getParameters().Put('Errormsg',strErrMsg);

        String paramLang = ApexPages.currentPage().getParameters().get('lang');
        String paramCountry = ApexPages.currentPage().getParameters().get('Country');
        if (String.isNotBlank(paramCountry) && String.isNotBlank(paramLang)) {
            errorPage.getParameters().put('lang', paramLang);
            errorPage.getParameters().put('Country', paramCountry);
        }

        errorPage.setRedirect(true);
        return errorPage;
    }
    
    
    /*
Description: This method is used to check DfD user access. *PD-9696*
*/
    public static PageReference CheckDfDUserAccess(){
        Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
        
        if (pac != null) {
            String docomoUserType = pac.Partner_Type__c;
            User u = [Select Id, Contact.Id, Contact.Account.Type, Contact.Account.Account_Status__c, Contact.Account.Partner_ID__c From User Where Id = :UserInfo.getUserId()];
            Boolean isDfDUser = (u.Contact != null) && (u.Contact.Account != null) && String.isNotBlank(u.Contact.Account.Type) && String.isNotBlank(docomoUserType) && u.Contact.Account.Type.equals(docomoUserType) && String.isNotBlank(u.Contact.Account.Partner_ID__c);
            if(isDfDUser){
                String accountStatus = u.Contact.Account.Account_Status__c;
                if(accountStatus == 'Active Paid'){
                    return Page.PartnerAccount;
                }
                else{
                    if(accountStatus == 'Frozen'){
                        List<AuthSession> lstActiveUserSessions = [Select ID From AuthSession Where UsersId =: UserInfo.getUserId()];
                        list<Id> sessionIdsList = new list<Id>();
                        
                        if(lstActiveUserSessions != null && !lstActiveUserSessions.isEmpty()) { for(AuthSession authObj : lstActiveUserSessions) { sessionIdsList.add(authObj.id);} }
                        
                        if(sessionIdsList.size() > 0) { deleteAuthSessions(sessionIdsList); }
                        
                        return Page.mylogin;
                    }
                }
            }           
        }
        
        return null;
    }
    
    public static Boolean IsDfDUser(){
        Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
        
        if (pac != null) {
            String docomoUserType = pac.Partner_Type__c;
            User u = [Select Id, Contact.Id, Contact.Account.Type, Contact.Account.Account_Status__c, Contact.Account.Partner_ID__c From User Where Id = :UserInfo.getUserId()];
            Boolean isDfDUser = (u.Contact != null) && (u.Contact.Account != null) && String.isNotBlank(u.Contact.Account.Type) && String.isNotBlank(docomoUserType) && u.Contact.Account.Type.equals(docomoUserType) && String.isNotBlank(u.Contact.Account.Partner_ID__c);
            if(isDfDUser){
                return true;
            }           
        }
        
        return false;
    }

    /*Start Part of PD-10449*/
    public static Boolean isAppleUser() {
        Partner_Account_Configuration__c pacApple = Partner_Account_Configuration__c.getInstance('Apple');
        
        if (pacApple != null) {   
            Boolean isDfDUser = IsDfDUser();
            String appleUserType = pacApple.Partner_Type__c;
            User u = [Select Id, Contact.Id, Contact.Account.Type, Contact.Account.Account_Status__c, Contact.Account.Partner_ID__c From User Where Id = :UserInfo.getUserId()];
            Boolean isAppleUser = (u.Contact != null) && (u.Contact.Account != null) && String.isNotBlank(u.Contact.Account.Type) && String.isNotBlank(appleUserType) && u.Contact.Account.Type.equals(appleUserType) && !isDfDUser;
            if(isAppleUser){
                return true;
            }
        }
        
        return false;
    }
    /*End Part of PD-10449*/
    
    /*
Description: This method is used to check DfD user access.
*/
    public static PageReference docomoAuthentication(String selectedSubject){
        PageReference dSignIn = System.Page.DocomoSignIn;
        dSignIn.getParameters().put('auth', 'true');
        if (String.isNotBlank(selectedSubject)) dSignIn.getParameters().put('type', selectedSubject);
        return dSignIn;
    }
    //public static PageReference docomoAuthentication(){
    //    return System.Page.DocomoSignIn;
    //}
    
    /*Method for check send of email notification PD-8670*/
    public static Boolean checkSendEmailForAccount() {
        Boolean isSend = true;
        List<Account> acc = [SELECT Disable_transactional_emails__c FROM Account WHERE Id IN (SELECT AccountId FROM User WHERE Id = :UserInfo.getUserId())];
        if (!acc.isEmpty() && acc[0].Disable_transactional_emails__c) {
            isSend = false;
        }
        return isSend;
    }
    
    public class UserLanguage {
        public String language { get; set; }
        public String label { get; set; }
        
        public UserLanguage(String language, String label) {
            this.language = language;
            this.label = label;
        }
    }
   
     
    // Added Code part of the PD-9458   
    public static boolean  IpaddressCompare(String DevIp,string SourceIP)
    {
        boolean IpAddValue = FALSE ;
        string url = DevIp;
        string[] arrParam = url.split('\\.');
        string url1 = SourceIP;
        string[] arrParam1 = url1.split('\\.');
        if (arrParam[0].equals(arrParam1[0])){ 
            if (arrParam[1] .equals(arrParam1[1] )){
                if (arrParam[2] .equals(arrParam1[2])){ 
                    if (arrParam[3] .equals(arrParam1[3])){
                        IpAddValue = TRUE;
                    }
                }
            }
        }
        return IpAddValue;  
    }//Ended code part of the PD-9458   
    
       /*PD-10671
Description: Method to redirect user to My page.
*/
    public static PageReference redirectToMylogin() {
        string sCountry = getUserCountryName(null);
        PageReference oPageReference = null ;
        string sMyPageURL = '/signin';
        if (sMyPageURL != null ){
            oPageReference = new PageReference(sMyPageURL);
            oPageReference.setRedirect(true);
        }
        return oPageReference;
    }

/*    public static PageReference myloginFetchUserLocale(String pageName, String browserLang) {
        if (browserLang.startsWithIgnoreCase('en')) {
            browserLang = 'en';
        }

        String paramLang = ApexPages.currentPage().getParameters().get('lang');
        String paramCountry = ApexPages.currentPage().getParameters().get('Country');
        String paramLoginType = ApexPages.currentPage().getParameters().get('loginType');
        String paramPauseAction = ApexPages.currentPage().getParameters().get('pauseAction');
        String paramDownloadError = ApexPages.currentPage().getParameters().get('dowloaderror');

        PageReference pr;
        String strCountryCode;
        String strLanguageCode;

        Boolean isRedirectNeeded = false;

        if (UserInfo.getUserType().Equals('Guest')) { //fetch language and country for Guest user
            String strCountry = Communityhelper.getUserCountryfromIPAddress();
            if (strCountry.equalsIgnoreCase('Canada') && browserLang.startsWithIgnoreCase('fr')) {
                browserLang = 'fr_CA';
            }
            List<DAZN_Help_Redirect__c> helpRedirectSettings = CommunityHelper.getLocaleSettings(paramCountry, paramLang, strCountry, browserLang);
            if (helpRedirectSettings != null && helpRedirectSettings.size() > 0) {
                strCountryCode = helpRedirectSettings[0].CountryISOCode__c;
                strLanguageCode = helpRedirectSettings[0].Language__c;
            }
            //determine if we should update language and country parameters for page
            isRedirectNeeded = String.isNotBlank(pageName) && String.isNotBlank(strCountryCode) && String.isNotBlank(strLanguageCode)
                && (!strCountryCode.equalsIgnoreCase(paramCountry) || !strLanguageCode.equalsIgnoreCase(paramLang));


        } else { //fetch language and country for non Guest user
            if (String.isNotBlank(paramLang) && String.isNotBlank(paramCountry)) {
                strCountryCode = paramCountry;
                strLanguageCode = paramLang;
            } else {
                User currentUser = [Select Id, FirstName, LastName, Notification_Language_Code__c, CountryCode, Account.Notification_Country_Code__c, Account.Notification_Language_Code__c From User Where Id = :UserInfo.getUserId()];
                strCountryCode = currentUser.Account.Notification_Country_Code__c;
                strLanguageCode = currentUser.Account.Notification_Language_Code__c;
            }
            
            if (String.isNotBlank(strLanguageCode) && strLanguageCode.startsWithIgnoreCase('en')) {
                strLanguageCode = 'en';
            }
            //determine if we should update language and country parameters for page
            isRedirectNeeded = String.isNotBlank(pageName) && String.isNotBlank(strCountryCode) && String.isNotBlank(strLanguageCode);
        }

        //set language and country parameters for page if needed
        if (isRedirectNeeded) {
            if ((!pageName.equalsIgnoreCase('DocomoSignIn') &&
                 !pageName.equalsIgnoreCase('InternalServerError') &&
                 !pageName.equalsIgnoreCase('PageNotFound')) &&
                (!strCountryCode.equalsIgnoreCase(paramCountry) ||
                 !strLanguageCode.equalsIgnoreCase(paramLang))) { //refresh page for contactus (for not breaking the existing behaviour)
                pr = new PageReference(Site.getBaseUrl() + '/' + pageName + '/' + strCountryCode + '-' + strLanguageCode + ((String.isBlank(paramPauseAction)) ? '' : '/' + paramPauseAction) + ((String.isBlank(paramDownloadError)) ? '' : '/' + paramDownloadError));
            }
            if (pr == null) {
                ApexPages.currentPage().getParameters().put('Country', strCountryCode);
                ApexPages.currentPage().getParameters().put('lang', strLanguageCode);
            } else {
                if (String.isNotBlank(paramLoginType)) {
                    pr.getParameters().put('loginType', paramLoginType);
                }
            }
        }
        return pr;
    }

    public static List<DAZN_Help_Redirect__c> getLocaleSettings(String paramCountry, String paramLang, String userCountry, String userLanguage) {
        List<DAZN_Help_Redirect__c> helpRedirectSettings;
        if (String.isNotBlank(paramCountry) && String.isNotBlank(paramLang)) {
            helpRedirectSettings = [Select Country__c, CountryISOCode__c, Language__c From DAZN_Help_Redirect__c Where CountryISOCode__c = :paramCountry AND Language__c = :paramLang];
            if (helpRedirectSettings.isEmpty()) {
                helpRedirectSettings = [Select Country__c, CountryISOCode__c, Language__c From DAZN_Help_Redirect__c Where CountryISOCode__c = :paramCountry AND IsDefaultLanguage__c = true];
                if (helpRedirectSettings.isEmpty()) {
                    helpRedirectSettings = [Select Country__c, CountryISOCode__c, Language__c From DAZN_Help_Redirect__c Where IsDefaultCountry__c = true];
                }
            }
        } else {
            helpRedirectSettings = [Select Country__c, CountryISOCode__c, Language__c From DAZN_Help_Redirect__c Where Country__c = :userCountry AND Language__c = :userLanguage];
            if (helpRedirectSettings.isEmpty()) {
                helpRedirectSettings = [Select Country__c, CountryISOCode__c, Language__c From DAZN_Help_Redirect__c Where Country__c = :userCountry AND IsDefaultLanguage__c = true];
                if (helpRedirectSettings.isEmpty()) {
                    helpRedirectSettings = [Select Country__c, CountryISOCode__c, Language__c From DAZN_Help_Redirect__c Where IsDefaultCountry__c = true];
                }
            }
        }
        return helpRedirectSettings;
    }*/

    public static PageReference myloginFetchUserLocale(String pageName, String browserLang) {
        if (browserLang.startsWithIgnoreCase('en')) {
            browserLang = 'en';
        }

        String paramLang = ApexPages.currentPage().getParameters().get('lang');
        String paramCountry = ApexPages.currentPage().getParameters().get('Country');
        String paramLoginType = ApexPages.currentPage().getParameters().get('loginType');
        String paramPauseAction = ApexPages.currentPage().getParameters().get('pauseAction');

        PageReference pr;
        String strCountryCode;
        String strLanguageCode;

        Boolean isRedirectNeeded = false;

        if (UserInfo.getUserType().Equals('Guest')) { //fetch language and country for Guest user
            String strCountry = Communityhelper.getUserCountryfromIPAddress();
            if (strCountry.equalsIgnoreCase('Canada') && browserLang.startsWithIgnoreCase('fr')) {
                browserLang = 'fr_CA';
            }
            DAZN_Help_Redirect__c helpRedirectSettings = CommunityHelper.getLocaleSettings(paramCountry, paramLang, strCountry, browserLang);
            if (helpRedirectSettings != null) {
                strCountryCode = helpRedirectSettings.CountryISOCode__c;
                strLanguageCode = helpRedirectSettings.Language__c;
            }
            //determine if we should update language and country parameters for page
            isRedirectNeeded = String.isNotBlank(pageName) && String.isNotBlank(strCountryCode) && String.isNotBlank(strLanguageCode)
                && (!strCountryCode.equalsIgnoreCase(paramCountry) || !strLanguageCode.equalsIgnoreCase(paramLang));


        } else { //fetch language and country for non Guest user
            if (String.isNotBlank(paramLang) && String.isNotBlank(paramCountry)) {
                strCountryCode = paramCountry;
                strLanguageCode = paramLang;
            } else {
                User currentUser = [Select Id, FirstName, LastName, Notification_Language_Code__c, CountryCode, Account.Notification_Country_Code__c, Account.Notification_Language_Code__c From User Where Id = :UserInfo.getUserId()];
                strCountryCode = currentUser.Account.Notification_Country_Code__c;
                strLanguageCode = currentUser.Account.Notification_Language_Code__c;
            }
            
            if (String.isNotBlank(strLanguageCode) && strLanguageCode.startsWithIgnoreCase('en')) {
                strLanguageCode = 'en';
            }
            //determine if we should update language and country parameters for page
            isRedirectNeeded = String.isNotBlank(pageName) && String.isNotBlank(strCountryCode) && String.isNotBlank(strLanguageCode);
        }

        //set language and country parameters for page if needed
        if (isRedirectNeeded) {
            if ((!pageName.equalsIgnoreCase('DocomoSignIn') &&
                 !pageName.equalsIgnoreCase('InternalServerError') &&
                 !pageName.equalsIgnoreCase('PageNotFound')) &&
                (!strCountryCode.equalsIgnoreCase(paramCountry) ||
                 !strLanguageCode.equalsIgnoreCase(paramLang))) { //refresh page for contactus (for not breaking the existing behaviour)
                pr = new PageReference(Site.getBaseUrl() + '/' + pageName + '/' + strCountryCode + '-' + strLanguageCode + ((String.isBlank(paramPauseAction)) ? '' : '/' + paramPauseAction));
            }
            if (pr == null) {
                ApexPages.currentPage().getParameters().put('Country', strCountryCode);
                ApexPages.currentPage().getParameters().put('lang', strLanguageCode);
            } else {
                if (String.isNotBlank(paramLoginType)) {
                    pr.getParameters().put('loginType', paramLoginType);
                }
            }
        }
        return pr;
    }

    public static Map<String, String> getCountryAndLanguageCodes(String strBrowserLang) {
        Map<String, String> countryAndLanguageCodes = new Map<String, String>();

        PageReference currentPage = ApexPages.currentPage();
        Cookie lang = (currentPage != null) ? currentPage.getCookies().get('lang') : null;
        Cookie country = (currentPage != null) ? currentPage.getCookies().get('Country') : null;

        Boolean isLangAndCountryAreKnown = (lang != null && country != null) &&
            String.isNotBlank(lang.getValue()) && String.isNotBlank(country.getValue());

        if (isLangAndCountryAreKnown && UserInfo.getUserType().equalsIgnoreCase('Guest')) {
            countryAndLanguageCodes.put('lang', lang.getValue());
            countryAndLanguageCodes.put('Country', country.getValue());
            return countryAndLanguageCodes;
        }
        
        String strCountryCode;
        String strLanguageCode;

        if (UserInfo.getUserType().equalsIgnoreCase('Guest')) { //fetch language and country for Guest user
            String strCountry = Communityhelper.getUserCountryfromIPAddress();
            DAZN_Help_Redirect__c helpRedirectSettings = CommunityHelper.getLocaleSettings(null, null, strCountry, strBrowserLang);
            if (helpRedirectSettings != null) {
                strCountryCode = helpRedirectSettings.CountryISOCode__c;
                strLanguageCode = helpRedirectSettings.Language__c;
            }
        } else { //fetch language and country for non Guest user
            User currentUser = [Select Id, FirstName, LastName, Notification_Language_Code__c, CountryCode, Account.Notification_Country_Code__c, Account.Notification_Language_Code__c From User Where Id = :UserInfo.getUserId()];
            strCountryCode = currentUser.Account.Notification_Country_Code__c;
            strLanguageCode = currentUser.Account.Notification_Language_Code__c;
        }

        if (String.isNotBlank(strCountryCode) && String.isNotBlank(strLanguageCode)) {
            countryAndLanguageCodes.put('lang', strLanguageCode);
            countryAndLanguageCodes.put('Country', strCountryCode);
        } else {
            countryAndLanguageCodes.put('lang', 'en');
            countryAndLanguageCodes.put('Country', 'DE');
        }

        return countryAndLanguageCodes;
    }

    public static Map<String, String> setCountryAndLanguageCodes(String strBrowserLang) {
        PageReference currentPage = ApexPages.currentPage();
        Map<String, String> countryAndLanguageCodes = getCountryAndLanguageCodes(strBrowserLang);
        
        if (currentPage != null) {
            currentPage.getParameters().put('lang', countryAndLanguageCodes.get('lang'));
            currentPage.getParameters().put('Country', countryAndLanguageCodes.get('Country'));

            Cookie lang = new Cookie('lang', countryAndLanguageCodes.get('lang'), null, -1, false);
            Cookie country = new Cookie('Country', countryAndLanguageCodes.get('Country'), null, -1, false);
            currentPage.setCookies(new Cookie[] {lang, Country});
        }
        
        return countryAndLanguageCodes;
    }

    public static DAZN_Help_Redirect__c getLocaleSettings(String paramCountry, String paramLang, String userCountry, String userLanguage) {
        List<DAZN_Help_Redirect__c> helpRedirectSettings;
        if (String.isNotBlank(paramCountry) && String.isNotBlank(paramLang)) {
            helpRedirectSettings = [Select Country__c, CountryISOCode__c, Language__c From DAZN_Help_Redirect__c Where CountryISOCode__c = :paramCountry AND Language__c = :paramLang];
            if (helpRedirectSettings.isEmpty()) {
                helpRedirectSettings = [Select Country__c, CountryISOCode__c, Language__c From DAZN_Help_Redirect__c Where CountryISOCode__c = :paramCountry AND IsDefaultLanguage__c = true];
            }
        } else if (String.isNotBlank(userCountry) && String.isNotBlank(userLanguage)) {
            helpRedirectSettings = [Select Country__c, CountryISOCode__c, Language__c From DAZN_Help_Redirect__c Where Country__c = :userCountry AND Language__c = :userLanguage];
            if (helpRedirectSettings.isEmpty()) {
                helpRedirectSettings = [Select Country__c, CountryISOCode__c, Language__c From DAZN_Help_Redirect__c Where Country__c = :userCountry AND IsDefaultLanguage__c = true];
            }
        }
        if (helpRedirectSettings == null || helpRedirectSettings.isEmpty()) {
            helpRedirectSettings = [Select Country__c, CountryISOCode__c, Language__c From DAZN_Help_Redirect__c Where IsDefaultCountry__c = true];
        }
        return (helpRedirectSettings == null || helpRedirectSettings.isEmpty()) ? null : helpRedirectSettings[0];
    }

    public static String formatLangCode(String countryName, String countryCode, String langCode) {
        String formattedLangCode = langCode;
        
        if (String.isNotBlank(formattedLangCode) && formattedLangCode.startsWithIgnoreCase('en')) {
            formattedLangCode = 'en';
        } else if (String.isNotBlank(countryName) && countryName.equalsIgnoreCase('Canada') && langCode.startsWithIgnoreCase('fr')) {
            formattedLangCode = 'fr_CA';
        }
        
        return formattedLangCode;
    }
    
    public static String CurRetunForCanadaFr(String strRef) {
        String s1 = strRef;
        String s2 = s1.substring(1);
        String lastPaymentInfo = s2+'$';
        return lastPaymentInfo;
    }

    public static Id getSSOProfileIdForNonSSOUser(Id userId) {
        if (String.isBlank(userId)) {
            return null;
        }
        DAZNConfiguration__c daznSSOProfileConfig = DAZNConfiguration__c.getValues('SSO Comunity User Profile Id');
        Boolean noProfileInfo = daznSSOProfileConfig == null || String.isBlank(daznSSOProfileConfig.Value__c);
        if (noProfileInfo) {
            return null;
        }
        List<User> lstuser = [Select Id, Profile.IsSsoEnabled From User Where Id = :userId LIMIT 1];
        Boolean isUserProfileWithoutSSO = lstuser != null && !lstuser.isEmpty() && !lstuser[0].Profile.IsSsoEnabled;
        return (isUserProfileWithoutSSO) ? daznSSOProfileConfig.Value__c : null;
    }

    public static Map<String, String> changeProfileToSSO(String emailaddress, String password, Id userId, String accountId, Id ssoProfileId, String curentCountryCode) {
        if (String.isBlank(emailaddress) || String.isBlank(password) || String.isBlank(userId) || String.isBlank(ssoProfileId)) {
            return new Map<String, String> {
                'success' => 'false',
                'message' => 'Required parameters are missed: email/password/user id/profile id'
            };
        }

        Map<String, Object> payload = new Map<String, Object> {
            'Email' => emailaddress,
            'CheckOldPassword' => 'false',
            'NewPassword' => password
        };
        Map<String, String> changePasswordRes = MISLCalloutHelper.changePassword(payload, curentCountryCode, accountId);
        
        Boolean isUpdateUserProfileToSSO = changePasswordRes != null && String.isNotBlank(changePasswordRes.get('success'))
            && changePasswordRes.get('success').equalsIgnoreCase('true');
        if (isUpdateUserProfileToSSO) {
            updateUserProfile(userId, ssoProfileId);
        }

        return changePasswordRes;
    }

    @future(callout=true)
    public static void updateUserProfile(Id userId, Id profileId) {
        String endpoint = (DAZNConfiguration__c.getValues('UpdateProfileEndpoint') != null) ? DAZNConfiguration__c.getValues('UpdateProfileEndpoint').Value__c : null;
        String username = (DAZNConfiguration__c.getValues('UpdateProfileUsername') != null) ? DAZNConfiguration__c.getValues('UpdateProfileUsername').Value__c : null;
        String password = (DAZNConfiguration__c.getValues('UpdateProfilePassword') != null) ? DAZNConfiguration__c.getValues('UpdateProfilePassword').Value__c : null;

        if (String.isNotBlank(endpoint) && String.isNotBlank(username) && String.isNotBlank(password)) {
            password = EncodingUtil.base64Decode(password).toString();

            Map<String, Object> reqBodyMap = new Map<String, Object> {
                'userId' => userId,
                'profileId' => profileId
            };

            partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
            partnerSoapSforceCom.LoginResult loginResult = (Test.isRunningTest()) ? new partnerSoapSforceCom.LoginResult() : sp.login(username, password);

            HTTPRequest req = new HTTPRequest();
            req.setHeader('Authorization', 'Bearer ' + loginResult.sessionId);
            req.setHeader('content-type', 'application/json');
            req.setMethod('POST');
            req.setBody(JSON.serialize(reqBodyMap));
            req.setEndpoint(endpoint);
            HTTPResponse res = new Http().send(req);
        }
    }

    public static Boolean isRunSSOFlow(String countryCode) {
        Boolean isRunSSOFlow = false;

        DAZNConfiguration__c daznConfig = DAZNConfiguration__c.getValues('SSO Enabled Country Codes');
        if (daznConfig == null || String.isBlank(daznConfig.Value__c) || String.isBlank(countryCode)) {
            return isRunSSOFlow;
        }

        String countryCodes = daznConfig.Value__c;
        Set<String> enabledCountryCodes = new Set<String>();
        if (countryCodes != null) {
            List<String> countryCodesList = countryCodes.toLowerCase().split(',');
            for (String codeItem : countryCodesList) {
                enabledCountryCodes.add(codeItem.trim());
            }
        }
        isRunSSOFlow = enabledCountryCodes.contains(countryCode.toLowerCase());

        return isRunSSOFlow;
    }
}