/*9104*/
public without sharing class DocomoSignInController {
    public Boolean PersonalDetailsNotCompleted {get;set;}
    public Boolean NoActiveDAZNSubscriptionOnDocomoAccount {get;set;}
    public Boolean TechErrorBetweenDAccountAuthAndCognizant {get;set;}
    public Boolean isBlockedAccount {get;set;}
    
    public String redirectSignInDAccountLink { get; set; }
    public String redirectHelpLinkLink { get; set; }
    public String redirectToSingUpPageLink { get; set; }
    public String State {get;set;}
    public String Nonce {get;set;}
    public String ReturnUrl {get;set;}

    public String testR {get;set;}

    public DocomoSignInController() {
        redirectSignInDAccountLink = (DAZNConfiguration__c.getValues('SignInDAccountUrl') != null) ? DAZNConfiguration__c.getValues('SignInDAccountUrl').Value__c : '';
        redirectHelpLinkLink = (DAZNConfiguration__c.getValues('DocomoHelpLinkUrl') != null) ? DAZNConfiguration__c.getValues('DocomoHelpLinkUrl').Value__c : '';
        redirectToSingUpPageLink = (DAZNConfiguration__c.getValues('SignUpUrl') != null) ? DAZNConfiguration__c.getValues('SignUpUrl').Value__c : '';
    }

    public PageReference redirectToHomePage(){
        return CommunityHelper.redirectToHomePage();
    }

    public PageReference Authentication(){
        PersonalDetailsNotCompleted = false;
        NoActiveDAZNSubscriptionOnDocomoAccount = false;
        TechErrorBetweenDAccountAuthAndCognizant = false;

        string error = ApexPages.currentPage().getParameters().get('error');
        if(error == 'error1'){
            TechErrorBetweenDAccountAuthAndCognizant = true;
            return null;
        }
        else{
            if(error == 'error2'){
                NoActiveDAZNSubscriptionOnDocomoAccount = true;
                return null;
            }
        }

        //if (userInfo.getUserType().Equals('Guest')) {
        if (ApexPages.currentPage().getParameters().get('auth') != null && ApexPages.currentPage().getParameters().get('auth').equalsIgnoreCase('true')) {   
            return AuthenticationRequest();
        }

        User usr = [SELECT Account.Partner_Registration_Status__c FROM User WHERE Id =: UserInfo.getUserId()];
        if (usr.Account.Partner_Registration_Status__c == 'incomplete') {
            PersonalDetailsNotCompleted = true;
            return null;
        }
        
        String stateParam = ApexPages.currentPage().getParameters().get('state');
        PageReference authPage;
        if (String.isBlank(stateParam) || stateParam.equalsIgnoreCase('myaccount')) {
            authPage = System.Page.PartnerAccount;
        } else {
            List<String> stateParams = stateParam.split(';');
            if (stateParams.size() == 4) {
                authPage = new PageReference('/' + stateParams[0] + '/' + stateParams[2] + '-' + stateParams[3] + '/' + stateParams[1]);
            } else if (stateParams.size() == 3) {
                authPage = new PageReference('/' + stateParams[0] + '/' + stateParams[1] + '-' + stateParams[2]);
            } else {
                authPage = new PageReference('/' + stateParams[0] + '?type=' + stateParams[1]);
            }
        }
        authPage.setRedirect(true);
        return authPage;
        //return System.Page.PartnerAccount;
    }

    public PageReference AuthenticationRequest(){
        //ReturnUrl = Site.getBaseUrl() + '/myaccount';

        Map<String,String> docomoConfigurationMap = new Map<String,String>();
        List<DocomoConfiguration__c> docomoConfigurations = [SELECT Name, Value__c FROM DocomoConfiguration__c];
        for(DocomoConfiguration__c docomoConfiguration : docomoConfigurations) {
            docomoConfigurationMap.put(docomoConfiguration.Name, docomoConfiguration.Value__c);
        }

        ReturnUrl = Site.getBaseUrl() + docomoConfigurationMap.get('ReturnUrl');
        
        String approvalCode = RetriveApprovalCode();
        if(String.isNotBlank(approvalCode))
        {
            Account account= RetriveAccount(approvalCode, docomoConfigurationMap);
            if(account != null){
                return DocomoLogin(account, docomoConfigurationMap);
            }
            else{
                return null;
            }
        }

        //State = generateRandomString(60);
        String typeParam = ApexPages.currentPage().getParameters().get('type');
        State = (String.isBlank(typeParam)) ? 'myaccount' : typeParam;
        Nonce = generateRandomString(60);                

        /*Preprod
        String url = String.Format('https://id.smt.docomo.ne.jp/cgi8/oidc/authorize?scope=openid offline_access accountid_n dma_service10&response_type=code&client_id=g00_0010_0001_01&redirect_uri={0}&state={1}&nonce={2}&authiden=1', 
                                    new String[]{ReturnUrl, State, Nonce});
        */
        String url = String.Format(docomoConfigurationMap.get('Authentication Request'), 
                                    new String[]{ReturnUrl, State, Nonce});
        return new PageReference(url);
    }

    public PageReference DocomoLogin(Account account, Map<String, String> docomoConfigurationMap) {
        List<Contact> contacts = [Select Id From Contact Where AccountID = :account.Id];
        if (contacts.size() == 1) {
            List<User> users = [Select Id, Username From User Where ContactId = :contacts[0].Id];
            if (users.size() == 1) {
                String password = EncodingUtil.base64Decode(docomoConfigurationMap.get('Default Password')).toString();
                System.setPassword(users[0].Id, password);
                PageReference redirectUrl = Site.login(users[0].Username, password, '');
                if (Test.isRunningTest()) {
                    redirectUrl = new PageReference('CommunitiesLanding');
                }
                if (redirectUrl != null) {
                    String originalUrl;
                    String stateParam = ApexPages.currentPage().getParameters().get('state');
                    originalUrl = redirectUrl.getUrl().replace('CommunitiesLanding', 'docomosignin?state=' + ((String.isBlank(stateParam)) ? 'myaccount' : stateParam));
                    PageReference docomoSignIn = new PageReference(originalUrl);
                    return docomoSignIn;
                }
            }
        }
		TechErrorBetweenDAccountAuthAndCognizant = true;
        return null;
    }

    public String RetriveApprovalCode(){
        String returnUrlState = ApexPages.currentPage().getParameters().get('state');
        if(String.isNotBlank(returnUrlState))
        {       
            String returnUrlCode = ApexPages.currentPage().getParameters().get('code');
            if(String.isNotBlank(returnUrlCode))
            {
                return returnUrlCode; 
            }
        }

        return null;
    }

    public Account RetriveAccount(String approvalCode, Map<String,String> docomoConfigurationMap){
        try
        {
            String token = TokenRequest(approvalCode, docomoConfigurationMap);
            if(String.isNotBlank(token))
            {           
                /*PD-10365*/
                HTTPResponse userInfoResponse = UserInfoRequest(token, docomoConfigurationMap);
                String status = ParseToken(userInfoResponse.getBody(), 'dma_service10');
                if(status == '1'){
                    String accountId = ParseToken(userInfoResponse.getBody(), 'accountid');

                    if(String.isNotBlank(accountId)){   
                        List<Account> accounts = [SELECT Id, Account_Status__c FROM Account WHERE Partner_ID__c =: accountId];

                        if(accounts.size() == 1){
                            /*Start part of PD-10581*/
                            if (accounts[0].Account_Status__c == 'Blocked') {
                                TechErrorBetweenDAccountAuthAndCognizant = true;
                                isBlockedAccount = true;
                                return null;
                            }/*End part of PD-10581*/
                            return accounts[0];
                        }
                    }
                }
                else
                {
                    NoActiveDAZNSubscriptionOnDocomoAccount = true;
                    return null;
                }
            }   
        }
        catch(Exception ex)
        {   
            /*Start part of PD-13188*/
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'DocomoSignInController', 'RetriveAccount', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
            /*End part of PD-13188*/
            System.debug(ex.getStackTraceString() + ex.getMessage());
        }

        TechErrorBetweenDAccountAuthAndCognizant = true;

        return null;
    }

    public String TokenRequest(String approvalCode, Map<String,String> docomoConfigurationMap){
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HttpResponse resp = new HttpResponse();
        /* Preprod
        req.setEndpoint('https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/token');
        req.setBody(String.Format('grant_type=authorization_code&code={0}&redirect_uri={1}', new String[] {approvalCode, ReturnUrl})); 

        req.setMethod('POST');
        req.setHeader('Host', 'docomoproxy.performgroup.com');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
        req.setHeader('Authorization','Basic ZzAwXzAwMTBfMDAwMV8wMTpodXNqWXpwZFhURVljc2R5ejM0QVI1cHd1WVAydWE3cA==');
        */

        req.setEndpoint(docomoConfigurationMap.get('Token Request'));
        req.setBody(String.Format('grant_type=authorization_code&code={0}&redirect_uri={1}', new String[] {approvalCode, ReturnUrl})); 

        req.setMethod('POST');
        req.setHeader('Host', docomoConfigurationMap.get('Host'));
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
        
        Blob authorizationBlob = Blob.valueOf(docomoConfigurationMap.get('Client ID') + ':' + docomoConfigurationMap.get('Client Password'));
        String authorization = EncodingUtil.base64Encode(authorizationBlob);
        req.setHeader('Authorization','Basic ' + authorization);

        HTTPResponse response = http.send(req);

        return ParseToken(response.getBody(), 'access_token');
    }

    public String ParseToken(String jsonStr, String fieldName){
        JSONParser parser = JSON.createParser(jsonStr);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == fieldName)) {

                parser.nextToken();

                return parser.getText();
            }
        }

        return null;
    }

    public HTTPResponse UserInfoRequest(String token, Map<String,String> docomoConfigurationMap){
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HttpResponse resp = new HttpResponse();
        /* Preprod
        req.setEndpoint('https://docomoproxy.performgroup.com/conf.uw.docomo.ne.jp/userinfo');

        req.setMethod('GET');
        req.setHeader('content-type', ' application/x-www-form-urlencoded;charset=UTF-8');
        req.setHeader('Authorization', String.Format('Bearer {0}', new String[] {token}));
        */
        req.setEndpoint(docomoConfigurationMap.get('UserInfo Request'));

        req.setMethod('GET');
        req.setHeader('content-type', ' application/x-www-form-urlencoded;charset=UTF-8');
        req.setHeader('Authorization', String.Format('Bearer {0}', new String[] {token}));

        HTTPResponse response = http.send(req);

        return response;
    }

    private String generateRandomString(Integer length) {
        String charDictionary = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String result = '';
        while (result.length() < length) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), charDictionary.length());
           result += charDictionary.substring(idx, idx+1);
        }
        return result; 
    }

    /*PD-10285*/
    public PageReference redirectToDualSignInPage() {
        
        return System.Page.SignIn;
    }

	/*PD-9838*/
    public PageReference redirectToSingUpPage() {
    	DAZNConfiguration__c daznSignUpUrl = DAZNConfiguration__c.getValues('SignUpUrl') ;
        return new PageReference(daznSignUpUrl.Value__c);
    }

    /*PD-9838*/
    public PageReference redirectSignInDAccount() {
    	DAZNConfiguration__c daznSignUpUrl = DAZNConfiguration__c.getValues('SignInDAccountUrl') ;
        return new PageReference(daznSignUpUrl.Value__c);
    }
    
    /*PD-9838*/
    public PageReference redirectHelpLink() {
    	DAZNConfiguration__c daznSignUpUrl = DAZNConfiguration__c.getValues('DocomoHelpLinkUrl') ;
        return new PageReference(daznSignUpUrl.Value__c);
    }
}