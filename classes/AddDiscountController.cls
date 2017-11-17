public with sharing class AddDiscountController {

    public List<SelectOption> discountLst { get; set; }
    public Boolean isErrorMode { get; private set; }
    public String selectedMonth { get; set; }
    private string sAccountID { get; set; }
    private List<Account> lstAccount;

    public AddDiscountController(ApexPages.StandardController controller) {
        isErrorMode = false;
        sAccountID = controller.getId();
        if (sAccountID != null) {
            lstAccount = [
                SELECT Id,
                    (SELECT Id, Name
                     FROM Zuora__Subscriptions__r 
                     WHERE Zuora__Status__c = 'Active'
                     ORDER BY Zuora__SubscriptionStartDate__c
                     DESC NULLS LAST)
                FROM Account
                WHERE Id = :sAccountID 
                LIMIT 1
            ];
            if (lstAccount == null || lstAccount.isEmpty() || lstAccount[0].Zuora__Subscriptions__r == null || lstAccount[0].Zuora__Subscriptions__r.isEmpty()) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LS_AddDiscount_No_Active_Supscriptions_Msg));
                isErrorMode = true;
            }
        }
        discountLst = new List<SelectOption>();
        discountLst.add(new SelectOption('1', '1'));
        discountLst.add(new SelectOption('2', '2'));
        discountLst.add(new SelectOption('3', '3'));
    }

    /* Add discount method */
    public PageReference submit() {
        DAZNConfiguration__c ratePlan1m = DAZNConfiguration__c.getValues('Livesport Rateplan 1m Discount');
        DAZNConfiguration__c ratePlan2m = DAZNConfiguration__c.getValues('Livesport Rateplan 2m Discount');
        DAZNConfiguration__c ratePlan3m = DAZNConfiguration__c.getValues('Livesport Rateplan 3m Discount');
        DAZNConfiguration__c endpointConfig = DAZNConfiguration__c.getValues('ZuoraAddDiscountUrl');
        DAZNConfiguration__c usernameConfig = DAZNConfiguration__c.getValues('ZuoraAddDiscountUsername');
        DAZNConfiguration__c passwordConfig = DAZNConfiguration__c.getValues('ZuoraAddDiscountPassword');

        String discountId1m = ratePlan1m != null ? ratePlan1m.Value__c : null;
        String discountId2m = ratePlan2m != null ? ratePlan2m.Value__c : null;
        String discountId3m = ratePlan3m != null ? ratePlan3m.Value__c : null;
        String endpointUrl = endpointConfig != null ? endpointConfig.Value__c : null;
        String username = usernameConfig != null ? usernameConfig.Value__c : null;
        String password = passwordConfig != null ? passwordConfig.Value__c : null;

        Map<String, String> monthDiscountIdMap = new Map<String, String> {
            '1' => discountId1m,
            '2' => discountId2m,
            '3' => discountId3m
        };
        Boolean isCustomSettingsEmpty = (
            String.isBlank(endpointUrl) ||
            String.isBlank(username) ||
            String.isBlank(password) ||
            monthDiscountIdMap.get(selectedMonth) == null
        );
        if (isCustomSettingsEmpty) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LS_AddDiscount_System_Error_Msg));
            isErrorMode = true;
            return null;
        }

        Blob authorizationBlob = Blob.valueOf(username + ':' + password);
        String authorization = EncodingUtil.base64Encode(authorizationBlob);

        HttpRequest request = new HttpRequest();

        request.setEndpoint(endpointUrl);
        request.setMethod('POST');
        request.setHeader('content-type', 'application/json');
        request.setHeader('Authorization', 'Basic ' + authorization);

        DiscountWrapper discountObject = new DiscountWrapper(
            monthDiscountIdMap.get(selectedMonth),
            lstAccount[0].Zuora__Subscriptions__r[0].Name
        );
        request.setBody(JSON.serialize(discountObject));

        Http http = new Http();
        try {
            HttpResponse response = http.send(request);

            Map<String, Object> mapOfResponseObj = (Map<String, Object>)JSON.deserializeUntyped(response.getbody());
            if (mapOfResponseObj.get('id') != null) {
                PageReference pageRef = new PageReference('/' + sAccountID);
                pageRef.setRedirect(true);
                return pageRef;
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LS_AddDiscount_System_Error_Msg));
                isErrorMode = true;
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LS_AddDiscount_System_Error_Msg));
            isErrorMode = true;
        }
        return null;
    }

    public class DiscountWrapper {
        public String DiscountID;
        public String SubscriptionName;

        public DiscountWrapper(String DiscountID, String SubscriptionName) {
            this.DiscountID = DiscountID;
            this.SubscriptionName = SubscriptionName;
        }
    }

}