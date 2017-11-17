public with sharing class PaymentHistoryControllerHelper {
	
    /*Description: Method for checking Country for showing download link*/
	public static Boolean setShowDownloadLink(String strCurrentCountry) {
		Boolean isResult = false;
		List<PaymentHistoryDownloadConfiguration__c> paymentHistoryConfig = [SELECT Country_code__c, Download_Invoice__c FROM PaymentHistoryDownloadConfiguration__c];
        if (!paymentHistoryConfig.isEmpty()) {
            for (PaymentHistoryDownloadConfiguration__c item :paymentHistoryConfig) {
                if (strCurrentCountry == item.Country_code__c.toLowerCase()) {
                    isResult = item.Download_Invoice__c;
                    break;
                }
            }
        }
        return isResult;
	}

    /*Description: Method for creating Date from String*/
	public static Date getDateFromText(String dateText) {
        String[] invoiceDate = dateText.substringBefore(' ').split('-',3);
        return Date.newInstance(Integer.valueOf(invoiceDate[2]), Integer.valueOf(invoiceDate[1]), Integer.valueOf(invoiceDate[0]));
    }

    /*Description: Method for checking country for showing Free Trial items on Payment History page*/
    public static Boolean setShowFreeTrial(String strCurrentCountry, String subscriptionType) {
    	Boolean isResult = false;
    	List<Payment_history_configuration__c> paymentHistoryConfig = [SELECT Country_code__c, Show_free_trial__c,  Subscription_type__c FROM Payment_history_configuration__c];
        if (!paymentHistoryConfig.isEmpty()) {
            for (Payment_history_configuration__c item :paymentHistoryConfig) {
                if (strCurrentCountry == item.Country_code__c.toLowerCase() && subscriptionType == item.Subscription_type__c) {
                    isResult = item.Show_free_trial__c;
                    break;
                }
            }
        }
        return isResult;
    }

    /*Description: Method for getting Payment Method*/
    public static List<Zuora__PaymentMethod__c> getPaymentMethod(String accountId) {
    	return [SELECT Id, Zuora__BillingAccount__c,Zuora__Type__c, Zuora__CreditCardType__c, 
                        Zuora__CreditCardMaskNumber__c, Zuora__BankTransferAccountNumber__c, Zuora__External_Id__c,
                        Zuora__PaypalEmail__c, Zuora__CreditCardExpirationMonth__c, Zuora__CreditCardExpirationYear__c
                FROM Zuora__PaymentMethod__c
                WHERE Zuora__BillingAccount__r.Zuora__Account__c = :accountId
                ORDER BY CreatedDate];
    }

    /*Description: Method for creating query*/
    public static String createInvoicePaymentQuery(Boolean isShowForActiveSubscription, Date startDateSubscription, String accountId) {
        String condition = '';
        if (isShowForActiveSubscription && startDateSubscription != null) {
            condition = ' AND Zuora__Payment__r.Zuora__Effective_Date__c >= :startDateSubscription ';
        }

        String query = 'SELECT Zuora__Payment__r.Id,Zuora__RefundAmount__c, Zuora__Payment__r.Zuora__EXT_ID__c, Zuora__Payment__r.Zuora__PaymentMethod__c, ' +
                                'Zuora__Payment__r.Zuora__Amount__c, Zuora__Payment__r.Zuora__Effective_Date__c,  ' +
                                'Zuora__Payment__r.Zuora__BillingAccount__r.Zuora__Zuora_Id__c,  ' +
                                'Zuora__Payment__r.Zuora__BillingAccount__r.Zuora__External_Id__c, Zuora__Payment__r.Zuora__External_Id__c, ' +
                                'Zuora__Payment__r.Zuora__BillingAccount__r.Zuora__Currency__c, Zuora__Invoice__r.Name, ' +
                                'Zuora__EXT_ID__c, Zuora__Invoice__c, Zuora__Invoice__r.Zuora__External_Id__c, ' +
                                '(Select ID,Zuora__Refund__r.Zuora__RefundDate__c From Zuora__RefundInvoicePayments__r) ' +
                            'FROM Zuora__PaymentInvoice__c ' +
                            'WHERE Zuora__Payment__r.Zuora__Account__c = ' + '\'' + accountId + '\'' + ' '+ 
                                'AND ' +
                                'Zuora__Payment__r.Zuora__Status__c = \'Processed\' ' +
                                condition +
                            'ORDER BY Zuora__Payment__r.Zuora__EffectiveDate__c ' + 
                            'DESC NULLS LAST ';
        return query;
    }

    /*Description: Method for creating List of records from Gift Code History object*/
    public static List<PaymentHistoryController.WrapPaymentHistory> createListGiftCodeHistory(Account accObj, User oUser, String sCurrency) {
        List<PaymentHistoryController.WrapPaymentHistory> paymentHistoryGiftCodeHistory = new List<PaymentHistoryController.WrapPaymentHistory>();
        Map<Datetime, PaymentHistoryController.WrapPaymentHistory> paymentHistoryGiftCodeHistoryByStartDate = new Map<Datetime, PaymentHistoryController.WrapPaymentHistory>();
        
        List<Gift_Code_History__c> giftCodeHistoryRecords = [SELECT Id, Account__c, Applied_On__c, Campaign_Id__c, Gift_Code_End_Date__c, Gift_Code_Start_Date__c, Number_Of_Periods__c, Name 
                                                                FROM Gift_Code_History__c 
                                                                WHERE Account__c = :accObj.Id
                                                                ORDER BY Gift_Code_Start_Date__c DESC
                                                                LIMIT 10000];
        if (!giftCodeHistoryRecords.isEmpty()) {
            for (Gift_Code_History__c item :giftCodeHistoryRecords) {
                PaymentHistoryController.WrapPaymentHistory payHistoryGiftCode = new PaymentHistoryController.WrapPaymentHistory();

                payHistoryGiftCode.cardType = '';
                payHistoryGiftCode.cardNumber = Label.LS_PaymentHistory_Label_Gift_Code;
                payHistoryGiftCode.paypalEmail = '';
                payHistoryGiftCode.phType = 'Subscription';
                
                payHistoryGiftCode.cardType = String.valueOf(item.Gift_Code_Start_Date__c.monthsBetween(item.Gift_Code_End_Date__c)) + ' ' + Label.LS_Payment_History_Month;
                payHistoryGiftCode.paymentType = 'Gift Code';

                payHistoryGiftCode.bankAccountNumber = '';
                payHistoryGiftCode.effectiveDate = CommunityHelper.ConvertDateToString(Date.valueOf(String.valueOf(item.Gift_Code_Start_Date__c)),accObj.Notification_Country_Code__c,'');    
                payHistoryGiftCode.createdDate = item.Gift_Code_Start_Date__c;
                
                payHistoryGiftCode.amountWithoutTax = CommunityHelper.getformattedAmount(sCurrency ,0,oUser.Country);
                payHistoryGiftCode.taxAmount = ' (' + CommunityHelper.getformattedAmount(sCurrency ,0,oUser.Country) + ' '+ Label.LS_PaymentHistory_Label_Tax + ')';
                payHistoryGiftCode.amount = communityHelper.getformattedAmount(sCurrency , 0 ,oUser.Country);

                if (!paymentHistoryGiftCodeHistoryByStartDate.containsKey(payHistoryGiftCode.createdDate)) {
                    paymentHistoryGiftCodeHistoryByStartDate.put(payHistoryGiftCode.createdDate, payHistoryGiftCode);
                }
                
            }
        }

        paymentHistoryGiftCodeHistory.addAll(paymentHistoryGiftCodeHistoryByStartDate.values());

        return paymentHistoryGiftCodeHistory;
    }

    /*Description: Method for getting Active Subscription*/
    public static List<Zuora__Subscription__c> getActiveSubscritions(String accountId) {
        return [SELECT Zuora__SubscriptionStartDate__c, Zuora__TermSettingType__c, Zuora__SubscriptionEndDate__c, Gift_Code_Start_Date__c, Giftcode__c, NumGiftPeriods__c,NumFreeTrialPeriods__c, Gift_Code_End_Date__c
                    FROM Zuora__Subscription__c 
                    WHERE Zuora__Account__c = :accountId 
                            AND (Zuora__Status__c = 'Active' 
                            OR (Zuora__Status__c = 'Cancelled' AND Zuora__SubscriptionEndDate__c > TODAY ))
                    LIMIT 10000];
    }

    /*Description: Method for getting Payment by Id*/
    public static Map<String, Zuora__Payment__c> getPaymentById(String accountId) {
        return new Map<String, Zuora__Payment__c>([SELECT Id, Zuora__Account__c, Zuora__Amount__c, Zuora__Effective_Date__c, CreatedDate, Zuora__PaymentMethod__c, Zuora__Status__c, Zuora__Type__c
                                                    FROM Zuora__Payment__c
                                                    WHERE Zuora__Account__c = :accountId
                                                    LIMIT 10000]);
    }

    /*description: Method for getting Invoice by Id*/
    public static Map<String, Zuora__ZInvoice__c> getInvoicesById(String accountId) {
        return new Map<String, Zuora__ZInvoice__c>([SELECT Id, Zuora__Account__c, Zuora__AmountWithoutTax__c, Zuora__TaxAmount__c, Name, Zuora__TotalAmount__c, Zuora__TaxExemptAmount__c
                                                    FROM Zuora__ZInvoice__c
                                                    WHERE Zuora__Account__c = :accountId
                                                    LIMIT 10000]);
    }
}