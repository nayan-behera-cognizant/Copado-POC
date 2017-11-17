public class PaypalProc {
    public PageReference sendRequest(){ 
        PageReference reference;
        PaypalSup paypalSupport;        
        String URL;
        paypalSupport= new PaypalSup();        
        reference=paypalSupport.redirectToPaypall('0.0');        //amount to be charged 
        return reference;
    }
}