/**
* @author Cognizant Technology Solutuions
* @date 02/06/2016
* @description Internal server error controller class
*/

public class InternalServerErrorController {
    public String sCountryName { get; set; }
    public String cookieCountry { get; set; }
    public String strLang { get; set; }
    
    public InternalServerErrorController() {
        if (userInfo.getUserType().Equals('Guest')) {
            cookieCountry = communityhelper.getUserCountryfromIPAddress();
        }
        
        sCountryName = CommunityHelper.getUserCountryName(null);
    }

}