@isTest
global class MockDocomoHttpResponse implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {        
        if(req.getEndpoint() == 'https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/token'){
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{"access_token":"access_token1", "dma_service10":"1"}');
	        res.setStatusCode(200);
	        return res;
        }
        else{
        	if(req.getEndpoint() == 'https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/userinfo'){
		        HttpResponse res = new HttpResponse();
		        res.setHeader('Content-Type', 'application/json');
		        res.setBody('{"accountid":"accountid1", "dma_service10":"1"}');
		        res.setStatusCode(200);
		        return res;
        	}
        	else{
        		if(req.getEndpoint() == 'https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/userinfo/noactivesubscription'){
			        HttpResponse res = new HttpResponse();
			        res.setHeader('Content-Type', 'application/json');
			        res.setBody('{"accountid":"accountid1", "dma_service10":"0"}');
			        res.setStatusCode(200);
			        return res;
        		}
        	}
        }

        return null;
    }
}