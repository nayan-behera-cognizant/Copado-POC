public class PaypalReturnUrlController{
    public pageReference redirectToPaypalStatusPage(){
        PaypalResponse oPaypalResponse=new PaypalResponse();
        return oPaypalResponse.getRequest();
    }    
}