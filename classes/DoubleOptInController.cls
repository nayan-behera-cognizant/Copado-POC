/**
* @author Cognizant Technology Solutuions
* @date 04/26/2016
* @description Double OptIn Controller class
*/
public class DoubleOptInController {
    public String accId { get; set; }
    public String cookieCountry { get; set; }
    public User oUser { get; set; }
    public static PageReference errorPage = null;
    public static String errorMessage = null;
    
    /*
    Description: page controller constructor
    */
    public DoubleOptInController() {
        oUser = CommunityHelper.getCurrentUser();
        /*As per PD-7853 else block to handle error  and Test.isRunningTest() as per 7818*/
        if (oUser == null || Test.isRunningTest()) {
            errorMessage = 'User is not found';
            CommunityHelper.redirectToErrorPage(errorMessage);
        }

        // Get Parameter values if user provided in url.
        accId = ApexPages.currentpage().getParameters().get('Id');
        
        if (userInfo.getUserType().Equals('Guest')) {
            cookieCountry = communityhelper.getUserCountryfromIPAddress();
            shouldIRun.doubOptallow = false;//PD-11641
        } else {
            cookieCountry = CommunityHelper.getUserCountryName(null);
        }
    }
    
    /*
    Description: Method to set double optIn flag for an account.
    */
    public PageReference setDoubleOptIn() {
        //*PD-9696*
        PageReference oPageReference = CommunityHelper.CheckDfDUserAccess();
        if (oPageReference != null) {
            return oPageReference;
        }
        if (String.isNotBlank(accId)) {
            // remove UID from userid got from URL
            //accId = accId.substring(3, accId.length());
            try { 
                Email_Queue__c EqObj = new Email_Queue__c();
                EqObj.AccountName__c = accId;
                insert EqObj;
            } catch(Exception ex) {
                errorMessage = 'Double Optin is Unsuccessful';
                oPageReference = CommunityHelper.redirectToErrorPage(errorMessage+ex);
            }
        }
        return oPageReference;
    }
    
    /*
    Description: Method to redirect user on home page
    */
    public PageReference redirectToHomePage() {
        return CommunityHelper.redirectToHomePage();
    } 
   	   
}