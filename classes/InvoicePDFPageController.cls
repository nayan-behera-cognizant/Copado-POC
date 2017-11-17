public with sharing class InvoicePDFPageController {
    
    public String doc;
    public String linkError {get;set;}
    public String GTMError{get;set;}//Added as part of PD-6921
    /*Description: Method using for downloadinf PDF from Zuora and open on VisualForce page*/
    public String getDoc() {
        linkError = DAZNConfiguration__c.getValues('PaymentHistoryDownloadError').Value__c;
        String endpointForDownload = ApexPages.currentPage().getParameters().get('endpointForDownload');
        String username = (DAZNConfiguration__c.getValues('ZuoraAPIUserId') != null) ? DAZNConfiguration__c.getValues('ZuoraAPIUserId').Value__c : null;
        String password = (DAZNConfiguration__c.getValues('ZuoraAPIUserPassword') != null) ? DAZNConfiguration__c.getValues('ZuoraAPIUserPassword').Value__c : null;
        Blob authorizationBlob = Blob.valueOf(username + ':' + password);
        String authorization = EncodingUtil.base64Encode(authorizationBlob);

        HttpRequest requestDownload = new HttpRequest();
        requestDownload.setEndpoint(endpointForDownload);
        requestDownload.setMethod('GET');
        requestDownload.setTimeout(Integer.valueOf(DAZNConfiguration__c.getValues('InvoicePDFGettingTimeout').Value__c));
        requestDownload.setHeader('content-type','application/json');
        requestDownload.setHeader('Authorization', 'Basic ' + authorization);
        
        try {
            Http httpDownload = new Http();
            HttpResponse responseLoad = httpDownload.send(requestDownload);
           
            if (responseLoad.getStatusCode() == 200) {
                Blob docBlob =  responseLoad.getBodyAsBlob();
                doc = EncodingUtil.Base64Encode(docBlob);
                GTMError =System.label.InvoiceDownloadedSuccessfully; //Added as part of PD-6921
                return doc;
            } else {
                //Added as part of PD-6921 
               GTMError = System.label.InvoiceDownloadIssue;  return 'issue';
            }
        }   
        catch (Exception ex) {
            //Added as part of PD-6921
            GTMError = ex.getMessage();  ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserID(), 'InvoicePDFPageController', 'getDoc', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());            
         }          
        return null;
                 
    }
}