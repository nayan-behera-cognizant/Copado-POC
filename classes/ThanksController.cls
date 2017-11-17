global with sharing class ThanksController {
    
    public User oUser { get; set; }
    static List<String> lstArticleType = new List<String>();

    public String strLanguage {
        get {
            String sLang = ApexPages.currentpage().getParameters().get('lang');
            return (String.isBlank(sLang)) ? sLang : sLang.split('_')[0];
        }
        set;
    }

    public String sCountry {
        get {
            return ApexPages.currentpage().getParameters().get('Country');
        }
        set;
    }

    public String thanksInfoMsg {
        get {
            return (String.isBlank(sCountry)) ? null : getLabelString('LS_Thanks_InfoMsg_CustomerServiceCentre' + sCountry.toUpperCase());
        }
        set;
    } //Added as part of PD-13525

    public ThanksController() {
        oUser = CommunityHelper.getCurrentUser();
    }
    
	/*Added as part of PD-13525
    Method to return the label value dynamically based on the parameter  */
    public static String getLabelString(String labelName ){
        Component.Apex.OutputText output = new Component.Apex.OutputText();
        output.expressions.value = '{!$Label.' + labelName + '}';
        return String.valueOf(output.value);
    }// End of PD-13525
	
    /*
        Description: This method implement to redirect user on myaccount page.
    */
    public PageReference redirectToHome() {
        return CommunityHelper.redirectToHomePage();
    }

}