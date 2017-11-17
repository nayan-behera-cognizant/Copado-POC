global class GTMHeaderController {

    public static string errorMsgDsply { get; set; } // Using  to set the error description in data layer
    public static string strDispalyVersion { get; set; }//PD-8766
    public static string errorMsgDsply1 { get; set; }

    public String pageName { get; set; }
    public String customerId { get; set; }
    public String language { get; set; }
    public String territory { get; set; }
    
    //PD-8766 - To get version of the product from Static Resource 
    global GTMHeaderController() {
        StaticResource statRes = [SELECT Body FROM StaticResource WHERE Name = 'Version' LIMIT 1];
        if (statRes != null) {
            strDispalyVersion = statRes.Body.toString();
            strDispalyVersion = strDispalyVersion.substringAfter('Version ');
        }
        if (!UserInfo.getUserType().Equals('Guest')) {
            User oUser = [SELECT AccountID, CountryCode, LanguageLocaleKey, Viewer_Id__c FROM User WHERE Id = :UserInfo.getUserId()];
            
            customerId = (String.isEmpty(oUser.Viewer_Id__c)) ? '' : oUser.Viewer_Id__c;
            language = (String.isEmpty(oUser.LanguageLocaleKey)) ? '' : oUser.LanguageLocaleKey;
            territory = (String.isEmpty(oUser.CountryCode)) ? '' : oUser.CountryCode;
        }
    }// End of  PD-8766
    
    /*
        Description: Method to get the Error Message from MyAccounterror handler.
    */  
    public static void errorDespFromAccountController(String strErrDesp) {
        System.debug('strErrDesp-------->'+strErrDesp);
        errorMsgDsply = strErrDesp;
        System.debug('errorMsgDsply-------->'+errorMsgDsply);
    }

}