/**
* @author Cognizant Technology Solutuions
* @date 01/06/2016
* @description Page Not found controller class
*/

public class PageNotFoundController {
    public String sCountryName { get; set; }
    public String cookieCountry { get; set; }
    public String strLang { get; set; }
    public String strLanguage { get; set; }
    
    public PageNotFoundController() {
        if (userInfo.getUserType().Equals('Guest')) {
            cookieCountry = communityhelper.getUserCountryfromIPAddress();
        }
        
        sCountryName = CommunityHelper.getUserCountryName(null);
    }

}