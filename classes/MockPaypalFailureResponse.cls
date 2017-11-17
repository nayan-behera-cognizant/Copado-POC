@isTest
global class MockPaypalFailureResponse implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('TOKEN=TESTTOKEN&EMAIL=testemail@email.com&PAYERID=testPAYERID&COUNTRYCODE=UK&SHIPTONAME=testSHIPTONAME&BILLINGAGREEMENTID=testBILLINGAGREEMENTID');
        res.setStatusCode(200);
        return res;
    }
}