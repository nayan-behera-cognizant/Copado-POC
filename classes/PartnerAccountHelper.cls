global class PartnerAccountHelper {

	private static String strDocStatusOfChild = '';
	private static Boolean isErrorCode = false;
	private static Boolean isStatus = false;

	webservice static String checkMarketingOptInStatusForD4dUser(String dfdPartnerId) {
		String strDocomoStatus = 'ok';
		String strDocomoSts = '';
		String xml = '';
		try {
            if (String.isNotBlank(dfdPartnerId)) {
                xml = '<methodCall><methodName>MelMaga.ref</methodName><params><param><value><struct><member><name>siteId</name><value>DAZN4docomo</value></member><member><name>Idtype</name><value>AI</value></member><member><name>Id</name>';
                xml += '<value>' + dfdPartnerId + '</value>';
                xml += '</member></struct></value></param></params></methodCall>';

                PartnerAccountPageData pageData = new PartnerAccountPageData();
                Http httpObj = new Http();
                // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
                Dom.Document doc = new Dom.Document();
                doc.load(xml);
                HttpRequest req = new HttpRequest();
                req.setHeader('Content-Type', 'text/xml');
                req.setHeader('HOST', pageData.dFD_HOST);
                req.setHeader('CONTENT-LENGTH', pageData.dFD_CONTENT_LENGTH);
                req.setHeader('PORT',  pageData.dFD_PORT);
                req.setEndpoint(pageData.dFD_SetEndpoint);
                req.setMethod('POST');
                req.setBodyDocument(doc);

                System.debug('>>> HOST = ' + pageData.dFD_HOST);
                System.debug('>>> CONTENT-LENGTH = ' + pageData.dFD_CONTENT_LENGTH);
                System.debug('>>> PORT = ' + pageData.dFD_PORT);
                System.debug('>>> dFD_SetEndpoint = ' + pageData.dFD_SetEndpoint);
                System.debug('>>> req = ' + req);
                    
                // Send the request, and return a response
                HttpResponse res = httpObj.send(req);

                System.debug('>>> res = ' + res);
                System.debug('>>> body = ' + res.getBody());

                if (res.getStatusCode() == 300) {
                	strDocomoStatus = 'Never opted in';
                } else if (res.getStatusCode() == 200) {
                	DOM.Document xmlDOC = res.getBodyDocument();
                    DOM.XMLNode rootElement = xmlDOC.getRootElement();
                    for (DOM.XMLNode xmlNodeObj : xmlDOC.getRootElement().getChildElements()) {
                        strDocomoSts = loadChilds(xmlnodeobj); 
                    }
                    if (strDocomoSts == '0') { 
                        strDocomoStatus = 'Opted out';
                    } else if (strDocomoSts == '1') { 
                        strDocomoStatus = 'Opted in' ;
                    } else {
                    	strDocomoStatus = 'Error';
                    }
                } else {
                	strDocomoStatus = 'Error';
                }
            } else {
            	strDocomoStatus = 'Error';
            }
        } catch(Exception e) {
        	return 'Error';
        }
        return strDocomoStatus;
	}

	private static String loadChilds(DOM.XMLNode xmlnode) {
        for (Dom.XMLNode child : xmlnode.getChildElements()) {
            if (child.getText() != null) {
                if (child.gettext() == 'errorCode') {
                    isErrorCode = true;
                }
                if (child.gettext() == 'status') {
                    isStatus = true;
                }
                if (child.getname() == 'i4' && isErrorCode) {
                    if (child.gettext().length() > 1) {
                        strDocStatusOfChild = child.gettext();
                        break;
                    }
                }
                if (child.getname() == 'i4' && isStatus) {
                    if (child.gettext().length() >= 1) {
                        strDocStatusOfChild = child.gettext();
                        break;
                    }
                }
                loadChilds(child);
            }
        }
        return strDocStatusOfChild;
    }
}