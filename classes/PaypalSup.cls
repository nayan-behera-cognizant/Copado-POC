public class PaypalSup {
    /*
     Description: Method to fetch login creadentials for Paypal.  
    */
    DAZNConfiguration__c timeOut;
    private String getLoginDetailsURLpart(){    
        String user;
        //Changed variable form Password to PWd for *PD-7937* String password
        String pwd;
        String signiture;        
        User oUser= [Select Country From User Where ID =: UserInfo.getUserId()];
        PaymentMethodOptionConfig__c oPaymentMethodOptionConfig = PaymentMethodOptionConfig__c.getValues(oUser.Country);
        if(oPaymentMethodOptionConfig != null){
            user = oPaymentMethodOptionConfig.PaypalMerchantUsername__c;
            pwd = oPaymentMethodOptionConfig.PaypalMerchantPassword__c;
            signiture = oPaymentMethodOptionConfig.PaypalMerchantSignature__c;
        }
        return 'USER='+user+'&PWD='+pwd+'&SIGNATURE='+signiture;
    }
    //folowing methods are used to built up name value string to create URL
    private String getMethodTypeURLpart(String methodType){
        String method=methodType;
        return '&METHOD='+method;
    }
    
    //Method to get Return URL
    private String getReturnURL(){        
        DAZNConfiguration__c oDAZNConfiguration = DAZNConfiguration__c.getValues('PaypalReturnUrl');
        if(oDAZNConfiguration!=null)       
            return '&RETURNURL='+oDAZNConfiguration.Value__c;   
        else
            return '';
    }
    //Method to get Cancel URL
    private String getCancelURL(){                
        DAZNConfiguration__c oDAZNConfiguration = DAZNConfiguration__c.getValues('PaypalCancelUrl');
        if(oDAZNConfiguration!=null)       
            return '&CANCELURL='+oDAZNConfiguration.Value__c;   
        else
            return '';
    }
    
    private String getBillingTypeURLpart(){
        return '&BILLINGTYPE=MerchantInitiatedBilling';
    }
    
    /** Added by B.Venkat  **/
    private String getVersionURLpart(){
        return '&version=109.0';
    }
    
    private String getPaymentRequestActionURLpart(){
        return '&PAYMENTREQUEST_0_PAYMENTACTION=Sale';
    }    
    
    private String getAmountURLpart(String amt){
        return '&AMT='+amt;
    }
    
    //generetes URL for request to receive security token
    private String generateTokenURL(String amt){
        String URL;
        URL=getBasicURL();
        return URL;
    }
    
    //Added by B.Venkat
    private String generateBody(String amt){
        String Body;
        Body=getLoginDetailsURLpart()+getMethodTypeURLpart('SetExpressCheckout')+getVersionURLpart()+getPaymentRequestActionURLpart()+getAmountURLpart(amt)+getReturnURL()+getCancelURL()+getBillingTypeURLpart();
        return Body;
    }
    
    //folowing methods are used to built up name value string to create URL
    private String getTokenURLpart(String token){
        return '&token='+token;
    }
    
    private String getPayerIDURLpart(String customerID){
        return '&PayerID='+customerID;
    }
    
    private String getBasicURL(){
        DAZNConfiguration__c oDAZNConfiguration_paypalURL = DAZNConfiguration__c.getValues('paypalURL');
        return oDAZNConfiguration_paypalURL.Value__c;
    }
    
    //change link to live version URL
    private String generatePaypalURL(String token){
        String URL;
        DAZNConfiguration__c oDAZNConfiguration_paypalAPIURL = DAZNConfiguration__c.getValues('paypalAPIURL');
        DAZNConfiguration__c PaypalExpressCheckoutURL = DAZNConfiguration__c.getValues('PaypalExpressCheckoutURL');
        URL=oDAZNConfiguration_paypalAPIURL.Value__c+PaypalExpressCheckoutURL.Value__c+getTokenURLpart(token);
        return URL;
    }
    
    
    //creates URL for BAID request, consequently creates payment method in zuora
    public Map<string,string> getBillingAgreementToken(){        
        String billingAgreementURL = '';
        String billingAgreementBody = '';
        String billingID = '';
        billingAgreementURL=createBillingAgreementURL();
        billingAgreementBody=createBillingAgreementBody();      
        billingID=getBillingID(billingAgreementURL,billingAgreementBody);
        return addBAIDtoZuora(billingID);
    }
    
    //generates payment method in zuora with specific BAID
    private Map<string,string> addBAIDtoZuora(String billingID){        
        User oUser=CommunityHelper.getCurrentUser();
        Map<string,string> mapResult=new MAP<string,string>();
        String sGetExpressCheckoutResponse = '';
        sGetExpressCheckoutResponse = getExpressCheckout();
        string sPaypalEmail  = sGetExpressCheckoutResponse.substringAfterLast('EMAIL=').substringBefore('&PAYERID');
        string sPaypalcountryCode = sGetExpressCheckoutResponse.substringAfter('COUNTRYCODE=').substringBefore('&SHIPTONAME');
        if(oUser.CountryCode.equals(sPaypalcountryCode))
        { 
            string sUserCountryCode=CommunityHelper.getUserCountry(null);
            Zuora__PaymentMethod__c oZPaymentMethod = new Zuora__PaymentMethod__c();
            oZPaymentMethod.Zuora__PaypalBaid__c= billingID;
            oZPaymentMethod.Zuora__PaypalEmail__c= EncodingUtil.urlDecode(sPaypalEmail,'UTF-8');        
            oZPaymentMethod.Zuora__Type__c= 'Paypal';
            string sMessage = ZuoraTransactionHelper.changePaymentMethod(oZPaymentMethod,oUser,'','');
            mapResult.put('success',sMessage);
        }
        else
        {
            mapResult.put('success','false');
            mapResult.put('errorcode','invalidcountry');
        }
        return mapResult;   
    }
    
    //request to receive BAID
    private String getBillingID(String URL,string Body){
        try{ //PD-7939 -added try &catch block and null check for URL
            String  billingID;
            Http httpSender;
            HttpRequest httpreq ;
            HttpResponse resp;        
            httpreq = new HttpRequest();
            httpSender= new Http();  
            if(!String.isBlank(URL)){ 
                httpreq.setEndpoint(URL);
                httpreq.setBody(Body);
            }              
            httpreq.setMethod('POST');
            //Fetch time out from DAZNConfiguration__c
            timeOut = DAZNConfiguration__c.getValues('PaypalGetBillingIDZuoraTimeout');
            httpreq.setTimeout(Integer.valueOf(timeOut.Value__c));//Current time out is set as 1000 ms
            resp=httpSender.send(httpreq);
            billingID=getBillingIDFromString(resp.getBody());            
            return billingID;
        }
        catch(Exception ex){
              ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'PaypalSup', 'getBillingID', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return '';
        }
    }    
    public string getExpressCheckout()
    {
        try{ //PD-7939 -added try &catch block and null check for URL
            string tokenURLpart=getTokenURLpart(ApexPages.currentPage().getParameters().get('token'));
            String sURL = getBasicURL();
            String sBody = getLoginDetailsURLpart()+getMethodTypeURLpart('GetExpressCheckoutDetails')+tokenURLpart+getVersionURLpart();
            String  billingID;
            Http httpSender;
            HttpRequest httpreq ;
            HttpResponse resp;        
            httpreq = new HttpRequest();
            httpSender= new Http();  
            if(!String.isBlank(sURL)){
                httpreq.setEndpoint(sURL); 
                httpreq.setBody(sBody); 
            }              
            httpreq.setMethod('POST');
            resp=httpSender.send(httpreq);
            return resp.getBody();
        }
         catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'PaypalSup', 'getBillingID', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return '';
        }
    }
    
    //returns Billing ID from URL
    private String getBillingIDFromString(String body){
        String billingID = '';
        billingID=body.substringAfterLast('BILLINGAGREEMENTID=').substringBefore('&TIMESTAMP');      
        //updated as a part of PD-11503
        if(billingID <> '' && billingID.contains('%2d'))
        	billingID = billingID.replace('%2d','-');
        return billingID;
    }
    //creates URL to get BAID
    public String createBillingAgreementURL(){
        String token;
        String payerID;
        String payerIDURLpart;
        String tokenURLpart;
        token= ApexPages.currentPage().getParameters().get('token');
        payerID= ApexPages.currentPage().getParameters().get('PayerID'); 
        tokenURLpart=getTokenURLpart(token);
        payerIDURLpart=getPayerIDURLpart(payerID);                
        return getBasicURL();
    }
    public String createBillingAgreementBody(){
        String token;
        String payerID;
        String payerIDURLpart;
        String tokenURLpart;
        token= ApexPages.currentPage().getParameters().get('token');
        payerID= ApexPages.currentPage().getParameters().get('PayerID'); 
        tokenURLpart=getTokenURLpart(token);
        payerIDURLpart=getPayerIDURLpart(payerID);                
        return getLoginDetailsURLpart()+getMethodTypeURLpart('CreateBillingAgreement')+tokenURLpart+payerIDURLpart+getVersionURLpart()+getPaymentRequestActionURLpart()+getAmountURLpart('2.0')+getReturnURL()+getCancelURL()+getBillingTypeURLpart();
    }
    
    //redirection to paypal, based on token 
    public PageReference redirectToPaypall(String amt){
        String token;
        String paypalURL;
        PageReference reference;
        token=requestToken(amt);
        paypalURL=generatePaypalURL(token);
        reference=new PageReference(paypalURL);
        reference.setRedirect(true);        
        return reference;
    }
    
    // redirection to home page
    public PageReference returnHome(MAP<string,string> mapResult){
        PageReference oPageReference;
        if(mapResult.get('success').equals('false')){  
            oPageReference=Page.ChangePaymentMethod; 
            for(string sParam : mapResult.keySet())            
                oPageReference.getParameters().put(sParam,mapResult.get(sParam));
        }else{
            oPageReference=Page.MyAccount; 
            oPageReference.getParameters().put('paymentMethodSuccess','true');
        }
        oPageReference.setRedirect(true);        
        return oPageReference;
    }
    
    // request to receive token
    private String requestToken(String amt){
        Http httpSender;
        HttpRequest req ;
        HttpResponse resp;        
        String token;
        req = new HttpRequest();
        httpSender= new Http();    
        try{
            string sURL=generateTokenURL(amt);  // Changed by Venkat       
            string Body=generateBody(amt);
            req.setBody(Body);
            req.setEndpoint(sURL);              
            req.setMethod('POST');
        	resp=httpSender.send(req);        
            token =getTokenFromString(resp.getBody());
            return token;    
        }catch(Exception ex){
        	ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'PaypalSup', 'requestToken', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return '';    
        }
        
    }
    
    //returns token from URL
    private String getTokenFromString(String str){
        String token;
        token=str.replace('TOKEN=', '').substringBefore('&TIMESTAMP'); 
        return token;
    }
}