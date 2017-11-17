public with sharing class InvoicePDFCalloutHelper {
    
    public class SuccessResponceInvoice {
        public List<Invoices> invoices;
    }

    public class Invoices {
        public String id;
        public String accountId;
        public String accountNumber;
        public String invoiceNumber;
        public List<InvoiceItems> invoiceItems;
        public List<InvoiceFiles> invoiceFiles;
    }

    public class InvoiceItems {
        public String id;
        public String subscriptionName;
    }

    public class InvoiceFiles {
        public String pdfFileUrl;
    }
    /*Description: Method using for getting endpoint for download PDF file from Zuora and getting information about Invoice*/
    public static SuccessResponceInvoice initInvoiceCallout(User oUser) {
        String endpointUrl = (DAZNConfiguration__c.getValues('ZuoraEndPointInvoiceURL') != null) ? DAZNConfiguration__c.getValues('ZuoraEndPointInvoiceURL').Value__c : null;
        String username = (DAZNConfiguration__c.getValues('ZuoraAPIUserId') != null) ? DAZNConfiguration__c.getValues('ZuoraAPIUserId').Value__c : null;
        String password = (DAZNConfiguration__c.getValues('ZuoraAPIUserPassword') != null) ? DAZNConfiguration__c.getValues('ZuoraAPIUserPassword').Value__c : null;

        List<Zuora__CustomerAccount__c> billAccount = [SELECT id,  Zuora__Zuora_Id__c FROM Zuora__CustomerAccount__c WHERE Zuora__Account__c = :oUser.AccountID limit 1];
        if (endpointUrl.length() > 1 && username.length() > 1 && password.length() > 1 && !billAccount.isEmpty()) {

            Blob authorizationBlob = Blob.valueOf(username + ':' + password);
            String authorization = EncodingUtil.base64Encode(authorizationBlob);

            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpointUrl + billAccount[0].Zuora__Zuora_Id__c);
            request.setMethod('GET');
            request.setTimeout(Integer.valueOf(DAZNConfiguration__c.getValues('InvoicePDFGettingTimeout').Value__c));
            request.setHeader('content-type','application/json');
            request.setHeader('Authorization', 'Basic ' + authorization);
            Http http = new Http();
            try {
                HttpResponse response = http.send(request);
                if (response.getStatusCode() == 200) {
                    SuccessResponceInvoice setPauseSuccessResponse = (SuccessResponceInvoice)JSON.deserialize(response.getBody(), SuccessResponceInvoice.class);
                    return setPauseSuccessResponse;
                }
            }
            catch (Exception ex) {
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserID(), 'InvoicePDFCalloutHelper', 'initInvoiceCallout', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            }
        }
        return null;
    }
}