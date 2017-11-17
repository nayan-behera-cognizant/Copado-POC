public class getcountryclass{
 public static HttpResponse getcountry(string stripadd){
     Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String userIPAddress = stripadd;//Assign user IP address here
        String endpoint = 'http://freegeoip.net'+'/json/'+userIPAddress;        
        request.setEndPoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = httpProtocol.send(request);
        
        return response;
    }

}