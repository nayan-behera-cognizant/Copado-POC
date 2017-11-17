public class PaymentHistoryController {
    public User oUser                                           { get; set; }
    public List<WrapPaymentHistory> lstWrapPaymentHistoryTemp   { get; set; }
    public List<WrapPaymentHistory> lstWrapPaymentHistory       { get; set; }
    public String sCurrency                                     { get; set; }
    public String sCountryName                                  { get; set; }
    public String cookieCountry                                 { get; set; }
    public Boolean navigateError                                { get; set; }
    public String slang                                         { get; set; }
    public String sCountry                                      { get; set; }
    public String linkDownload                                  { get; set; }
    public Boolean showDownloadLink                             { get; set; }
    public Boolean showbanner                                   { get; set; }
    public String sBanner                                       { get; set; }
    public String sBannerHeader                                 { get; set; }

    public static String sortBy                                 { get; set; }
    public static String errorMessage = null;
    public static PageReference errorPage = null;

    private string sZouraAccountId;

    public Account accObj = new Account ();
    public Boolean isShowForActiveSubscription;
    public Date startDateSubscription;
    public Boolean isFreeTrialWithGiftCode;
    public Boolean isFreeTrialWithGiftCodeFuture;
    public Boolean isShowSubscription;
    public List<Zuora__Subscription__c> activeSubscriptionList;
    public Zuora__Subscription__c activeSubscription;
    public Boolean isShowGiftCode;
    public Boolean isShowFreeTrial;
    public Date giftCodeStartDate;
    public String strCurrentCountry;
    public String subscriptionType;
    public String accStatus;
    public Boolean isSeeAllDataTest;
    public Map<String, Zuora__ZInvoice__c> mapInvoice;

    /*
        Description: PaymentHistoryController Class constructor.
    */
    public PaymentHistoryController () {
        navigateError                   = false;
        isShowForActiveSubscription     = false;
        isFreeTrialWithGiftCode         = false;
        isFreeTrialWithGiftCodeFuture   = false;
        isShowSubscription              = true;
        isShowFreeTrial                 = false;
        isShowGiftCode                  = false;
        navigateError                   = false;
        showDownloadLink                = false;
        showbanner                      = false;

        Map<String, String> countryAndLanguageCodes = CommunityHelper.setCountryAndLanguageCodes(null);
        slang = countryAndLanguageCodes.get('lang');
        sCountry = countryAndLanguageCodes.get('Country');

        String sUrl = ApexPages.currentPage().getUrl();
        String downloadError = ApexPages.currentPage().getParameters().get('dowloaderror');

        if (downloadError != null && downloadError == '1') {
            showbanner = true;
            sBannerHeader = Label.LS_Invoice_Issue_download_header;
            sBanner = Label.LS_Invoice_Issue_dowload_body;
        }
        if (oUser == null) {
            oUser = CommunityHelper.getCurrentUser();
            /*As per PD-7846 if block to handle error*/
            if (oUser == null) {
                navigateError = true;
                errorMessage =label.LS_PaymentHistory_Label_NoUser;
            }
        }
        if (userInfo.getUserType().Equals('Guest')) {
            cookieCountry = communityhelper.getUserCountryfromIPAddress();
        }
        else {
            if (oUser != null) {
                cookieCountry = CommunityHelper.getUserCountryName(null);
            }
            if (oUser == null) {
                cookieCountry = CommunityHelper.getUserCountryName(oUser);
            }
        }
        if (oUser != null && oUser.AccountId != null ) {

            accObj = [SELECT Id, Notification_Country_Code__c, Notification_Language_Code__c, FirstName, Account_Status__c
                        FROM Account
                        WHERE Id= :oUser.AccountId];

            strCurrentCountry = oUser.CountryCode.toLowerCase();

            showDownloadLink = PaymentHistoryControllerHelper.setShowDownloadLink(strCurrentCountry);

            getUserSubscription();
            getCustomerPaymentHistory();
            if (showDownloadLink) {
                loadPdfPage();
            }
        }
    }
    public void closeBanner() {
        showBanner = false;
    }
    /*Start part of PD-11325*/
    public void loadPdfPage() {
        InvoicePDFCalloutHelper.SuccessResponceInvoice invoicesResponse = InvoicePDFCalloutHelper.initInvoiceCallout(oUser);
        Map<String, InvoicePDFCalloutHelper.Invoices> invoiceResponseByInvoiceNumber = new Map<String, InvoicePDFCalloutHelper.Invoices>();
        if (invoicesResponse != null) {
            for (InvoicePDFCalloutHelper.Invoices item : invoicesResponse.invoices) {
                invoiceResponseByInvoiceNumber.put(item.invoiceNumber, item);
            }

            if (!invoiceResponseByInvoiceNumber.isEmpty() && lstWrapPaymentHistoryTemp != null && !lstWrapPaymentHistoryTemp.isEmpty()) {
                for (WrapPaymentHistory itemWrap :lstWrapPaymentHistoryTemp) {
                    if (invoiceResponseByInvoiceNumber.containsKey(itemWrap.name)) {
                        for (InvoicePDFCalloutHelper.InvoiceFiles it : invoiceResponseByInvoiceNumber.get(itemWrap.name).invoiceFiles) {
                                itemWrap.linkDownload = DAZNConfiguration__c.getValues('InvoicePDFLink').Value__c + it.pdfFileUrl;
                                itemWrap.pdfFileUrlLink = it.pdfFileUrl;
                            }
                        itemWrap.showlLink = true;
                    } else {
                        itemWrap.showlLink = false;
                    }
                }
                Integer countOfPdfLink = 0;
                for (WrapPaymentHistory itemWrap :lstWrapPaymentHistoryTemp) {
                    if (itemWrap.showlLink == true) {
                        countOfPdfLink+=1;
                    }
                }
                if (countOfPdfLink == 0) {
                    showDownloadLink = false;
                }
            } else {
                showDownloadLink = false;
            }
        } else {
            showDownloadLink = false;
        }

    }
    /*End Part of PD-11325*/

    /*Start part of PD-14075*/
    public void getUserSubscription() {
        String subscriptionIdActive;
        activeSubscriptionList = PaymentHistoryControllerHelper.getActiveSubscritions(accObj.Id);

        if (!activeSubscriptionList.isEmpty()) {
            subscriptionType = activeSubscriptionList[0].Zuora__TermSettingType__c;
            activeSubscription = activeSubscriptionList[0];
        }
        //Checking Gift Code for Active Subscription
        if (activeSubscription != null && !String.isBlank(activeSubscription.Giftcode__c) && activeSubscription.Gift_Code_Start_Date__c != null && activeSubscription.NumGiftPeriods__c != null) {
            if (activeSubscription.Gift_Code_Start_Date__c <= Date.today() && Integer.valueOf(activeSubscription.NumGiftPeriods__c) > 0) {
                isShowGiftCode = true;
                giftCodeStartDate = activeSubscription.Gift_Code_Start_Date__c;
            }
        }
        //Checking Free Trial for Active Subscription
        if (activeSubscription != null && !String.isBlank(activeSubscription.NumFreeTrialPeriods__c) && Integer.valueOf(activeSubscription.NumFreeTrialPeriods__c) > 0) {
            isShowFreeTrial = PaymentHistoryControllerHelper.setShowFreeTrial(strCurrentCountry, subscriptionType);
        }

        if (activeSubscription != null) {
            if (isFindBySubscriptionStartDate(activeSubscription)) {
                isShowForActiveSubscription = true;
                startDateSubscription = activeSubscription.Zuora__SubscriptionStartDate__c;
            }
        }
    }

    public Boolean isFindBySubscriptionStartDate(Zuora__Subscription__c activeSubscription) {
        Boolean isResult = false;
        if (activeSubscription != null && activeSubscription.Zuora__TermSettingType__c == 'Active') {
            isResult = true;
        } else if (activeSubscription != null && activeSubscription.Zuora__TermSettingType__c == 'Cancelled' && Date.today() < PaymentHistoryControllerHelper.getDateFromText(String.valueOf(activeSubscription.Zuora__SubscriptionEndDate__c))) {
            isResult = true;
        }
        return isResult;
    }

    /*
    Description: This method get the logged-in user payment history.
    */
    @TestVisible
    private void getCustomerPaymentHistory() {
        WrapPaymentHistory oWrapPH;
        List<WrapPaymentHistory> freeTrialPaymentHistory = new List<WrapPaymentHistory>();
        List<WrapPaymentHistory> giftCodePaymentHistory = new List<WrapPaymentHistory>();
        lstWrapPaymentHistoryTemp = new List<WrapPaymentHistory>();
        lstWrapPaymentHistory = new List<WrapPaymentHistory>();
        List<Zuora__PaymentInvoice__c>  lstInvoicePayment;
        List<Zuora__PaymentMethod__c> lstPaymentMethod;


        lstInvoicePayment = Database.query(PaymentHistoryControllerHelper.createInvoicePaymentQuery(isShowForActiveSubscription, startDateSubscription, accObj.Id));
        /* Get Payment method information. */
        lstPaymentMethod = PaymentHistoryControllerHelper.getPaymentMethod(accObj.Id);

        /* Check if invoice payment exist for customer*/
        if (lstInvoicePayment != null && !lstInvoicePayment.isEmpty()) {

            sCurrency = CommunityHelper.getCurrencySymbol(lstInvoicePayment[0].Zuora__Payment__r.Zuora__BillingAccount__r.Zuora__Currency__c);
            sZouraAccountId=lstInvoicePayment[0].Zuora__Payment__r.Zuora__BillingAccount__r.Zuora__External_Id__c;

            /* Create Map to hold payment information with PayMethod Zuora ID as key and Payment Method object as value.*/
            Map<string, Zuora__PaymentMethod__c> mapPaymentMethod = new Map<string, Zuora__PaymentMethod__c>();
            if (lstPaymentMethod != null && !lstPaymentMethod .isEmpty()) {
                for (Zuora__PaymentMethod__c oPayMethod : lstPaymentMethod) {
                    if (!mapPaymentMethod.containskey(String.valueOf(oPayMethod.Zuora__External_Id__c))) {
                        mapPaymentMethod.put(String.valueOf(oPayMethod.Zuora__External_Id__c), oPayMethod);
                    }
                }
            }

            Map<String, Zuora__Payment__c> mapPayment = PaymentHistoryControllerHelper.getPaymentById(accObj.Id);

            mapInvoice = PaymentHistoryControllerHelper.getInvoicesById(accObj.Id);
            System.debug('##### mapInvoice= ' + mapInvoice);
            /* Create a list of Wrapper class object using Invoice Payment list and Invoice details from Zuora*/
            for (Zuora__PaymentInvoice__c oZPayInvoice :  lstInvoicePayment) {
                String sCreditCardNumber;
                String sBankAccountNumber;
                oWrapPH = new WrapPaymentHistory();
                oWrapPH.name = oZPayInvoice.Zuora__Invoice__r.Name;

                if (oZPayInvoice.Zuora__Payment__r.Zuora__Amount__c != null) {
                    oWrapPH.amount = CommunityHelper.getformattedAmount(sCurrency, oZPayInvoice.Zuora__Payment__r.Zuora__Amount__c,oUser.Country);
                    oWrapPH.phType = Label.LS_PaymentHistory_Label_Subscription;
                }
                if (oZPayInvoice.Zuora__Payment__r.Zuora__Effective_Date__c != null) {
                    oWrapPH.effectiveDate = CommunityHelper.ConvertDateToString(Date.valueOf(String.valueOf(oZPayInvoice.Zuora__Payment__r.Zuora__Effective_Date__c)),accObj.Notification_Country_Code__c,'');
                }

                if (!mapPayment.isEmpty()) {
                    if (mapPayment.containskey(String.valueOf(oZPayInvoice.Zuora__Payment__c))) {
                        oWrapPH.createdDate = DateTime.valueOf(mapPayment.get(oZPayInvoice.Zuora__Payment__c).CreatedDate);
                        String typeOfPayment = mapPayment.get(oZPayInvoice.Zuora__Payment__c).Zuora__PaymentMethod__c;
                        if (typeOfPayment.contains('Credit Card')) {
                            oWrapPH.paymentType = 'CreditCard';
                            oWrapPH.cardType = typeOfPayment.replace('Credit Card', '');
                            oWrapPH.cardType = oWrapPH.cardType.substringBefore('*');
                            oWrapPH.cardNumber = Label.LS_PaymentHistory_Label_Ending + ' ' + typeOfPayment.substring(typeOfPayment.length()-4, typeOfPayment.length());
                        }
                        if (typeOfPayment.contains('Bank Transfer')) {
                            oWrapPH.paymentType = 'BankTransfer';
                            sBankAccountNumber = typeOfPayment.substringAfterLast('*');
                            if (sBankAccountNumber != null) {
                                oWrapPH.bankAccountNumber = Label.LS_PaymentHistory_Label_Ending + ' ' +  sBankAccountNumber.substring(sBankAccountNumber.length() - 3, sBankAccountNumber.length());
                            }
                        }
                        if (typeOfPayment.contains('Pay Pal')) {
                            oWrapPH.paymentType = 'PayPal';
                            oWrapPH.paypalEmail = typeOfPayment.substringAfter('Pay Pal');
                        }
                    }

                }
                /* Get tax details from invoice map.*/
                if (mapInvoice != null && mapInvoice.containsKey(oZPayInvoice.Zuora__Invoice__c)) {
                    if (mapInvoice.get(oZPayInvoice.Zuora__Invoice__c).Zuora__AmountWithoutTax__c != null) {
                        oWrapPH.amountWithoutTax = CommunityHelper.getformattedAmount(sCurrency ,(Decimal)mapInvoice.get(oZPayInvoice.Zuora__Invoice__c).Zuora__AmountWithoutTax__c,oUser.Country);

                        if (mapInvoice.get(oZPayInvoice.Zuora__Invoice__c).Zuora__TaxAmount__c != null) {
                            oWrapPH.taxAmount =  ' (' + CommunityHelper.getformattedAmount(sCurrency ,(Decimal)mapInvoice.get(oZPayInvoice.Zuora__Invoice__c).Zuora__TaxAmount__c,oUser.Country) + ' ' + Label.LS_PaymentHistory_Label_Tax + ')';
                        }
                    }
                }

                lstWrapPaymentHistoryTemp.add(oWrapPH);

                if (oZPayInvoice.Zuora__RefundAmount__c != null && oZPayInvoice.Zuora__RefundAmount__c > 0) {
                    WrapPaymentHistory oWrapPHRefund = oWrapPH.clone();
                    oWrapPHRefund.amount = CommunityHelper.getformattedAmount(sCurrency ,oZPayInvoice.Zuora__RefundAmount__c,oUser.Country);
                    oWrapPHRefund.phType = Label.LS_PaymentHistory_Label_Refund;
                    if (accObj.Notification_Country_Code__c== 'CA' && accObj.Notification_Country_Code__c != null) {
                        oWrapPHRefund.effectiveDate = CommunityHelper.ConvertDateToString(Date.valueOf(String.valueOf(oZPayInvoice.Zuora__RefundInvoicePayments__r[0].Zuora__Refund__r.Zuora__RefundDate__c)),accObj.Notification_Country_Code__c,'');
                    } else {
                        oWrapPHRefund.effectiveDate = CommunityHelper.ConvertDateToString(Date.valueOf(String.valueOf(oZPayInvoice.Zuora__RefundInvoicePayments__r[0].Zuora__Refund__r.Zuora__RefundDate__c)),accObj.Notification_Country_Code__c,'');
                    }
                    lstWrapPaymentHistoryTemp.add(oWrapPHRefund);
                }
            }
        }

        if (String.isBlank(sCurrency) || Test.isRunningTest()) {
            List<Zuora__CustomerAccount__c> lstBA =  [SELECT Zuora__Currency__c FROM Zuora__CustomerAccount__c WHERE Zuora__Account__c=:oUser.AccountId];
            if(!lstBA.isEmpty()) {
                sCurrency = CommunityHelper.getCurrencySymbol(lstBA[0].Zuora__Currency__c);
            }
                
        }
        /*Description: Getting Gift Code History from Gift Code History object*/
        giftCodePaymentHistory = PaymentHistoryControllerHelper.createListGiftCodeHistory(accObj, oUser, sCurrency);
        if (!giftCodePaymentHistory.isEmpty()) {
            lstWrapPaymentHistoryTemp.addAll(giftCodePaymentHistory);
        }

        // Add Free Trial invoice in history to display on UI.
        if (lstPaymentMethod !=null && !lstPaymentMethod.isEmpty()) {
            freeTrialPaymentHistory = getCustomerFreeTrailInvoiceInfo(lstPaymentMethod[0]);
            if (!freeTrialPaymentHistory.isEmpty()) {
                lstWrapPaymentHistoryTemp.addAll(freeTrialPaymentHistory);
            }
        }

        //Sorting 
        if (lstWrapPaymentHistoryTemp != null && !lstWrapPaymentHistoryTemp.isEmpty()) {
            lstWrapPaymentHistoryTemp.sort();
        }

        // sort list in decending order.
        for (Integer iCount = lstWrapPaymentHistoryTemp.size()-1; iCount >=0; iCount--) {
            lstWrapPaymentHistory.add(lstWrapPaymentHistoryTemp.get(iCount));
        }

    }

    /*
        Description: Method to get customer freetrial invoice to show in history.
    */
    private List<WrapPaymentHistory> getCustomerFreeTrailInvoiceInfo(Zuora__PaymentMethod__c oPaymentMethod){
        List<WrapPaymentHistory> itemsForFreeTrialAndGift = new List<WrapPaymentHistory>();
        if (isShowFreeTrial) {
            WrapPaymentHistory oWrapFreeTrial = new WrapPaymentHistory();
            oWrapFreeTrial.createdDate = activeSubscription.Zuora__SubscriptionStartDate__c;
            oWrapFreeTrial.effectiveDate = CommunityHelper.ConvertDateToString(Date.valueOf(String.valueOf(activeSubscription.Zuora__SubscriptionStartDate__c)), accObj.Notification_Country_Code__c,'');
            List<Zuora__ZInvoice__c> lstInvoice = new List<Zuora__ZInvoice__c>();
            if (mapInvoice == null) {
                mapInvoice = PaymentHistoryControllerHelper.getInvoicesById(accObj.Id);
            }
            
            if (mapInvoice != null) {
                lstInvoice.addAll(mapInvoice.values());
            } 
            createPaymentHistoryForFreeTrial(oWrapFreeTrial, accObj, lstInvoice, oPaymentMethod);
            itemsForFreeTrialAndGift.add(oWrapFreeTrial);
        }

        if (isShowGiftCode) {
            wrapPaymentHistory oWrapPH = new wrapPaymentHistory();
            oWrapPH.createdDate = activeSubscription.Gift_Code_Start_Date__c;
            oWrapPH.effectiveDate = CommunityHelper.ConvertDateToString(Date.valueOf(String.valueOf(activeSubscription.Gift_Code_Start_Date__c)),accObj.Notification_Country_Code__c,'');
            createPaymetHistoryForGiftCode(oWrapPH, activeSubscription);
            itemsForFreeTrialAndGift.add(oWrapPH);

        }

        return itemsForFreeTrialAndGift;
    }

    public wrapPaymentHistory createPaymetHistoryForGiftCode(wrapPaymentHistory itemGiftCode, Zuora__Subscription__c activeSubscription) {

        itemGiftCode.cardType = '';
        itemGiftCode.cardNumber = Label.LS_PaymentHistory_Label_Gift_Code;
        itemGiftCode.paypalEmail = '';
        itemGiftCode.phType = 'Subscription';
        
        itemGiftCode.cardType = String.valueOf(activeSubscription.Gift_Code_Start_Date__c.monthsBetween(activeSubscription.Gift_Code_End_Date__c)) + ' ' + Label.LS_Payment_History_Month; 
        itemGiftCode.paymentType = 'Gift Code';

        itemGiftCode.bankAccountNumber = '';

        createAmounts(itemGiftCode, null);
        return itemGiftCode;
    }

    public WrapPaymentHistory createPaymentHistoryForFreeTrial(WrapPaymentHistory oWrapPH, Account customerAcc, List<Zuora__ZInvoice__c> lstInvoice, Zuora__PaymentMethod__c oPaymentMethod) {

        oWrapPH.phType = Label.LS_PaymentHistory_Label_FreeTrial;// Changes made for PD-8157
        oWrapPH.paymentType = oPaymentMethod.Zuora__Type__c;
        if (lstInvoice != null && !lstInvoice.isEmpty()) {
            oWrapPH.name = lstInvoice[0].Name;
        }

        if (oPaymentMethod.Zuora__Type__c == 'CreditCard') {
            oWrapPH.cardType = oPaymentMethod.Zuora__CreditCardType__c;
            if (oPaymentMethod.Zuora__CreditCardMaskNumber__c != null) {
                oWrapPH.cardNumber = Label.LS_PaymentHistory_Label_Ending + ' ' + oPaymentMethod.Zuora__CreditCardMaskNumber__c.substring(oPaymentMethod.Zuora__CreditCardMaskNumber__c.length()-4, oPaymentMethod.Zuora__CreditCardMaskNumber__c.length()) ;
            }
        } else if (oPaymentMethod.Zuora__Type__c == 'PayPal') {
             oWrapPH.paypalEmail = CommunityHelper.getObfuscatedEmail(oPaymentMethod.Zuora__PaypalEmail__c);
        } else if (oPaymentMethod.Zuora__Type__c == 'BankTransfer') {
            if (oPaymentMethod.Zuora__BankTransferAccountNumber__c !=null)
            oWrapPH.bankAccountNumber = Label.LS_PaymentHistory_Label_Ending + ' ' +  oPaymentMethod.Zuora__BankTransferAccountNumber__c.substring(oPaymentMethod.Zuora__BankTransferAccountNumber__c.length() - 3, oPaymentMethod.Zuora__BankTransferAccountNumber__c.length());
        }

        createAmounts(oWrapPH, lstInvoice);
        return oWrapPH;
    }

    public WrapPaymentHistory createAmounts(WrapPaymentHistory oWrapPH, List<Zuora__ZInvoice__c> lstInvoice) {
        if (lstInvoice != null && oWrapPH.phType != 'Free Trial') {
            oWrapPH.amountWithoutTax = CommunityHelper.getformattedAmount(sCurrency ,lstInvoice[0].Zuora__TaxExemptAmount__c,oUser.Country);
            oWrapPH.taxAmount = ' (' + CommunityHelper.getformattedAmount(sCurrency ,lstInvoice[0].Zuora__TaxAmount__c,oUser.Country) + ' '+ Label.LS_PaymentHistory_Label_Tax + ')';
            oWrapPH.amount = communityHelper.getformattedAmount(sCurrency , lstInvoice[0].Zuora__TotalAmount__c,oUser.Country);
        } else {
            oWrapPH.amountWithoutTax = CommunityHelper.getformattedAmount(sCurrency ,0,oUser.Country);
            oWrapPH.taxAmount = ' (' + CommunityHelper.getformattedAmount(sCurrency ,0,oUser.Country) + ' '+ Label.LS_PaymentHistory_Label_Tax + ')';
            oWrapPH.amount = communityHelper.getformattedAmount(sCurrency , 0 ,oUser.Country);
        }
        return oWrapPH;
    }

    /*
        Description: Method to redirect user to myaccount page.
    */
    public pagereference redirectToMyAccount(){
        pagereference oPageref = new pagereference('/MyAccount');
        oPageref.setredirect(true);
        return oPageref ;
    }

    // This method is used to  navigate to internal server error page   /*As per PD-7846 else block to handle error*/
    public PageReference navigateToErrorPage(){
        if(navigateError || Test.isRunningTest()){
            errorPage=System.Page.InternalServerError;
            errorPage.getParameters().Put('Errormsg',errorMessage);
            errorPage.setRedirect(true);

        }

        //*PD-9696*
        PageReference oPageReference = CommunityHelper.CheckDfDUserAccess();
        if(oPageReference != null){
            return oPageReference;
        }

        return errorPage;
    }

    /*
        Description: Wrapper class for Payment History
    */
    public class WrapPaymentHistory implements Comparable
    {
        public string amount            { get; set; }
        public string effectiveDate     { get; set; }
        public string phType            { get; set; }
        public string amountWithoutTax  { get; set; }
        public string taxAmount         { get; set; }
        public string paymentType       { get; set; }
        public string cardType          { get; set; }
        public string cardNumber        { get; set; }
        public string cardExpiry        { get; set; }
        public string paypalEmail       { get; set; }
        public string bankAccountNumber { get; set; }
        public DateTime createdDate     { get; set; }

        /*Start part of PD-11325*/
        public String name              { get; set; }
        public String linkDownload      { get; set; }
        public String pdfFileUrlLink    { get; set; }
        public Boolean showlLink        { get; set; }
        /**/

        public Integer compareTo(Object compareTo) {
            WrapPaymentHistory compareToPH = (WrapPaymentHistory)compareTo;
            if(createdDate == compareToPH.createdDate) return 0;
            if(createdDate > compareToPH.createdDate) return 1;
            return -1;
        }
    }
}