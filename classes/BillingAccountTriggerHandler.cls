/**
* @author Cognizant Technology Solutuions
* @date 1/02/2015
* @description BillingAccountTriggerHandler class for populating the payment related information on Account from Billing Account.
*/
public class BillingAccountTriggerHandler {
    public static void populateBillingAccountInfoOnAccount(list<Zuora__CustomerAccount__c> lstNewBillingAccount, Boolean isInsert){
        Map<ID, Account> oAccount = new Map<ID, Account>();
        Set<Id> setIds = new Set<Id>();
        
        for (Zuora__CustomerAccount__c oBillingAccount : lstNewBillingAccount ) {
            setIds.add(oBillingAccount.Zuora__Account__c);
        }
        
        oAccount = new Map<Id, Account>([
            SELECT Id, Notification_Country_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, Retrieve_Email__c, Type, LastInvoiceDate__c
            FROM Account WHERE ID IN :setIds
        ]);
        updateAccountRetrieveEmail(lstNewBillingAccount, oAccount, isInsert); // for PD-10958 - Cog 1.5
        updateAccountCountry(lstNewBillingAccount, oAccount, setIds);
        for (Zuora__CustomerAccount__c oCustAccount: lstNewBillingAccount) {
            if (oCustAccount.Zuora__PaymentMethod_Type__c != null) {
                if (oAccount.containsKey(oCustAccount.Zuora__Account__c)) {
                    if (!string.isBlank(oCustAccount.Zuora__CreditCard_Number__c))
                        oAccount.get(oCustAccount.Zuora__Account__c).Payment_Type_Last_Digits_and_Expiry_Date__c = oCustAccount.Zuora__PaymentMethod_Type__c +' '+oCustAccount.Zuora__CreditCard_Number__c.substring(oCustAccount.Zuora__CreditCard_Number__c.length()-4,oCustAccount.Zuora__CreditCard_Number__c.length())+' '+oCustAccount.Zuora__CreditCard_Expiration__c;
                    else
                        oAccount.get(oCustAccount.Zuora__Account__c).Payment_Type_Last_Digits_and_Expiry_Date__c = oCustAccount.Zuora__PaymentMethod_Type__c ;
                }
            }
            //added as part of PD-13731
            if (oAccount.containsKey(oCustAccount.Zuora__Account__c)) {
                oAccount.get(oCustAccount.Zuora__Account__c).LastInvoiceDate__c = oCustAccount.Zuora__LastInvoiceDate__c;
            }
        }
        
        try {
            if(oAccount.values() != null) {
                update oAccount.values();
            }
        }
        catch(Exception ex) {
            ExceptionLoggerHelper.createExceptionLog(CommunityHelper.getCurrentUser().Id, 'BillingAccountTriggerHandler', 'populateBillingAccountInfoOnAccount', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        }
    }

    // For PD-10958: - Cog 1.5
    // Assumed that the method will be used only when Zuora__CustomerAccount__c record exists because Zuora__CustomerAccount__c.Retrive_Email__c is a formula
    public static void updateAccountRetrieveEmail(List<Zuora__CustomerAccount__c> lstNewBillingAccount, Map<Id, Account> oAccount, Boolean isInsert) {
        List<Account> accountsForUpdate = new List<Account>();
        Account accountForUpdate;
        for (Zuora__CustomerAccount__c item : lstNewBillingAccount) {
            if (oAccount.containsKey(item.Zuora__Account__c)) {
                accountForUpdate = oAccount.get(item.Zuora__Account__c);
                // For PD-12084: - Cog 1.6.2 (Retrieve Email should be populated via BillingAccounttriger for after Insert and only for customers who are not docomo)
                Boolean isUpdateNeeded = /*isInsert &&*/ accountForUpdate.Type != 'Docomo' && accountForUpdate.Retrieve_Email__c != item.Retrive_Email__c;
                if (isUpdateNeeded) {
                    accountForUpdate.Retrieve_Email__c = item.Retrive_Email__c;
                    accountsForUpdate.add(accountForUpdate);
                }
            }
        }
        update accountsForUpdate;
    }

    public static void updateAccountCountry(list<Zuora__CustomerAccount__c> lstNewBillingAccount, Map<Id, Account> oAccount, Set<Id> setIds) {
        Set<String> accountsId = new Set<String>();
        Set<String> billingsId = new Set<String>();
        List<DAZN_Help_Redirect__c> countryCodes = [SELECT Country__c, CountryISOCode__c, IsDefaultCountry__c, Language__c FROM DAZN_Help_Redirect__c LIMIT 10000];
        Map<String,DAZN_Help_Redirect__c> helpRedirectByCountry = new Map<String,DAZN_Help_Redirect__c>();

        for (DAZN_Help_Redirect__c item :countryCodes) {
            helpRedirectByCountry.put(item.Country__c, item);
        }


        if (!helpRedirectByCountry.isEmpty()) {
            for (Zuora__CustomerAccount__c item : lstNewBillingAccount) {
                if (oAccount.containsKey(item.Zuora__Account__c) 
                        && !String.isBlank(oAccount.get(item.Zuora__Account__c).Notification_Country_Code__c) 
                        && helpRedirectByCountry.containsKey(item.Zuora__BillToCountry__c)) {

                    if (helpRedirectByCountry.get(item.Zuora__BillToCountry__c).CountryISOCode__c != oAccount.get(item.Zuora__Account__c).Notification_Country_Code__c) {
                        billingsId.add(item.Id);
                        accountsId.add(oAccount.get(item.Zuora__Account__c).Id);
                    }
                }
            }
        }
        
        if (!accountsId.isEmpty()) {
            updateUser(helpRedirectByCountry, accountsId, billingsId);
        }
    }

    public static void updateUser(Map<String,DAZN_Help_Redirect__c> helpRedirectByCountry, Set<String> accountsId, Set<String> billingsId) {
        List<User> users = [SELECT LocaleSidKey, AccountId, CountryCode, Country FROM User WHERE AccountId IN :accountsId];
        
        List<DAZN_Help_Redirect__c> countryCodes = [SELECT Country__c, CountryISOCode__c, IsDefaultCountry__c, Language__c FROM DAZN_Help_Redirect__c LIMIT 10000];
 
        Map<Id, Account> oAccount;
        Map<Id, Zuora__CustomerAccount__c> billingAccountsByAccountId = new Map<Id, Zuora__CustomerAccount__c>();
        
        oAccount = new Map<Id, Account>([
            SELECT id, Notification_Country_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c
            FROM Account WHERE Id IN :accountsId
        ]);
        for (Zuora__CustomerAccount__c item : [SELECT id, Zuora__Account__c, Zuora__BillToCountry__c FROM Zuora__CustomerAccount__c WHERE Id IN :billingsId]) {
            billingAccountsByAccountId.put(item.Zuora__Account__c, item);
        }
        if (!users.isEmpty()) {
            for (User item :users) {
                if (oAccount.containsKey(item.AccountId)) {
                    String newCountryForUser = billingAccountsByAccountId.get(item.AccountId).Zuora__BillToCountry__c;
                    String newISOCountryCodeForUser = helpRedirectByCountry.get(newCountryForUser).CountryISOCode__c;
                    String newLocale = createLocaleCode(newISOCountryCodeForUser);

                    if (!String.isBlank(newLocale)) {
                        item.LocaleSidKey = newLocale;
                    } 
                    
                    item.CountryCode = newISOCountryCodeForUser;
                    item.Country = billingAccountsByAccountId.get(item.AccountId).Zuora__BillToCountry__c;
                }
            }
            update users;
        }
    }

    public static String createLocaleCode(String country) {
        Schema.PicklistEntry[] locales = Schema.SObjectType.User.fields.LocaleSidKey.PicklistValues;
        Boolean isContains = false;
        List<String> localeForCountryList = new List<String>();
        for (PicklistEntry locale : locales) {
            String localeForCountry = locale.getValue().substringAfter('_');
            if (localeForCountry.contains(country)) {
                localeForCountryList.add(locale.getValue());
            }
        }
        return localeForCountryList[0];
    }

}