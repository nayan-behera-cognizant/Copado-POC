public class PaypalResponse {
    public PageReference getRequest(){ 		
        PaypalSup paypalSupport = new PaypalSup();        
        Map<string,string> mapResult = paypalSupport.getBillingAgreementToken();        
        PageReference oPageReference = paypalSupport.returnHome(mapResult);        
        oPageReference.setRedirect(true);
     	return oPageReference;
    }
}