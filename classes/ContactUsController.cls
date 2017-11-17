/**************************************************************************************************************************************
Class  Name : ContactUsController.
Class  Description : ContactUs Controller for ContactUs VF Page.
History of Changes:                 
-----------------------------------------------------------------------------------------------------------------------------------
        Date                              Developer                                                            Comments
----------------------------------------------------------------------------------------------------------------------------------
      04-Oct-2016                         Srikanth                                                      PD-8637 Changed class sharing model form without to with.

**************************************************************************************************************************************/

/*Changed the class to with sharing as per PD-7930
PD-8637 -Changed class sharing model form without to with */
global with sharing class ContactUsController {
    public Boolean isEmailEdit { get; set; }  
    public User oUser { get; set; }
    public String strNewEmail { get; set; }
    public String caseDescription { get; set; } 
    public String sCaseSubject { get; set; }
    public String sCaseType { get; set; }
    public String sCaseLanguage { get; set; }
    public String sCaseCountry { get; set; }
    public String sUniqueCaseType { get; set; }
    public String sCaseSubType { get; set; }
    public Boolean bIsGuestUser { get; set; }
    public String sTrakingParams { get; set; }
    public Boolean isDfDUser { get; set; }
    public String selectedProvider { get; set; }
    public List<Email_Help_Option__c> subjects { get; set; }

    public String strCountry {
        get {
            Cookie country = ApexPages.currentpage().getCookies().get('Country');
            String sCountry = (country != null) ? country.getValue() : ApexPages.currentpage().getParameters().get('Country');
            return (String.isNotBlank(sCountry)) ? sCountry : strCountry;
        }
        set;
    }

    public String strLanguage {
        get {
            Cookie lang = ApexPages.currentpage().getCookies().get('lang');
            String sLanguage = (lang != null) ? lang.getValue() : ApexPages.currentpage().getParameters().get('lang');
            sLanguage = (String.isNotBlank(sLanguage)) ? sLanguage.split('_')[0] : sLanguage;
            return (String.isNotBlank(sLanguage)) ? sLanguage : strLanguage;
        }
        set;
    }
    
    public String selectedSubject {
        get {
            String selectedEmailHelpOption;
            if (String.isNotBlank(sCaseType)) {
                for (Email_Help_Option__c eho : typeOfCase) {
                    if (eho.Name == sCaseType) {
                        selectedEmailHelpOption = eho.Type__c;
                        break;
                    }
                }
            }
            return selectedEmailHelpOption;
        }
        set;
    }
    
    public List<Custom_Provider__c> userTypes {
        get {
            String sLanguage = (String.isNotBlank(strLanguage)) ? strLanguage.split('_')[0] : strLanguage;
            String sCountry = strCountry;
            if (String.isNotBlank(sCountry) && String.isNotBlank(sLanguage)) {
                return [SELECT Name, Provider_Type__c FROM Custom_Provider__c 
                        WHERE Language__c = :sLanguage AND Country_Code__c = :sCountry
                        ORDER BY NAME LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())];
            } else {
                return null;
            }
        }
        set;
    }

    public List<Email_Help_Option__c> typeOfCase {
        get {
            String sLanguage = (String.isNotBlank(strLanguage)) ? strLanguage.split('_')[0] : strLanguage;
            String sCountry = strCountry;
            List<Email_Help_Option__c> emailHelpOptions = new List<Email_Help_Option__c>();
            if (String.isNotBlank(sCountry) && String.isNotBlank(sLanguage)) {
                for (Email_Help_Option__c caseType : subjects) {
                    Boolean isAppropriateCaseType = String.isNotBlank(caseType.Language__c) && caseType.Language__c == sLanguage
                        && String.isNotBlank(caseType.Country__c) && caseType.Country__c == sCountry
                        && String.isNotBlank(caseType.Provider_Type__c) && caseType.Provider_Type__c == selectedProvider;
                    
                    if (isAppropriateCaseType) {
                        emailHelpOptions.add(caseType);
                    }
                }
            }
            return emailHelpOptions;
        }
        set;
    }

    /*
    Description: ContactUs Constructor PD-8875
    */
    public ContactUsController() {
        sCaseType = ApexPages.currentpage().getParameters().get('type');
        if (String.isNotBlank(sCaseType) && String.escapeSingleQuotes(sCaseType.deleteWhitespace()).isAlpha()) {
            sCaseType = sCaseType;
        }
        
        sTrakingParams = ApexPages.currentpage().getParameters().get('TrakingParams');

        subjects = [SELECT Name, Type__c, Country__c, Language__c, Case_Resolution_Owner__c, Case_Resolution_Text__c, Sign_in_Needed__c, Provider_Type__c, Display_Sequence__c
                    FROM EMAIL_HELP_OPTION__c
                    ORDER BY Display_Sequence__c ASC NULLS LAST LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())];
        
        // check for User
        if (userInfo.getUserType().Equals('Guest')) {
            isEmailEdit = true;
            bIsGuestUser = true;
            isDfDUser = false;
        } else {
            oUser = CommunityHelper.getCurrentUser();
            isEmailEdit = false;
            bIsGuestUser = false;
            strNewEmail = oUser.Email;
            isDfDUser = CommunityHelper.IsDfDUser();

            if (isDfDUser) {
                selectedProvider = 'Docomo';
            } else {
                selectedProvider = 'DAZN';
            }
        }
    }
    
    /*
    Description: Event to edit email
    */
    public void edit() {
        String field = apexpages.currentpage().getParameters().get('field');  
        isEmailEdit = true;      
        if (String.isNotBlank(field) && field.equals('Email')) {
            strNewEmail = oUser.Email;
        }
    }
    
    /*
    Description: Method to create case for email inquiry. 
    */
    public PageReference createCase() {
        try {
            if (String.isEmpty(sCaseSubject)) {
                sCaseSubject = DAZNConfiguration__c.getValues('DefaultCaseSubject').Value__c;
                sCaseType = DAZNConfiguration__c.getValues('DefaultCaseType').Value__c;
            }
            Database.DMLOptions oDMLOptiono = new Database.DMLOptions();
            oDMLOptiono.assignmentRuleHeader.useDefaultRule= true;
            Case oCase = new Case();
            oCase.Origin = 'Email';
            oCase.Type = sCaseType;
            oCase.Status= 'Open';
            oCase.Subject = sCaseSubject;
            oCase.Description= caseDescription;
            oCase.SuppliedEmail = strNewEmail;
            oCase.Contact_us_email__c = strNewEmail;
            oCase.setOptions(oDMLOptiono);
            //added as part of PD-15017 ticket
            oCase.Notification_Language_Code__c = (String.isNotBlank(sCaseLanguage) && sCaseLanguage.startsWithIgnoreCase('en')) ? sCaseLanguage.split('_')[0] : sCaseLanguage;
            oCase.Notification_Country_Code__c = (String.isNotBlank(sCaseCountry)) ? sCaseCountry.toUpperCase() : '';
            oCase.IsGuestUser__c = bIsGuestUser;
            oCase.Sub_Type__c = !String.isBlank(sCaseSubType) ? sCaseSubType : oCase.Sub_Type__c;

            /*PD-9519*/
            oCase.Provider_Type__c = selectedProvider;

            /* PD-11053: Replaced guestDAZNUserBehaviour() method from CaseTriggerHandler to CaseAssociationHelper class */
            if (bIsGuestUser) {
                CaseAssociationHelper.guestDAZNUserBehaviour(new List<Case> {oCase});
            } else {
                insert oCase;
            }

            Pagereference oPageref = new Pagereference('/Thanks');
            oPageref.setredirect(true);
            return oPageref;
        } catch (Exception ex) {
            ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'ContactUsController', 'createCase', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            //Changes as per PD-7852 --- Start
            //throw ex;
            //return null;
            return CommunityHelper.redirectToErrorPage(ex.getMessage());
            //PD-7852 Changes End
        }
    }

    /*PD-8875*/
    public Pagereference daznSignIn() {
        PageReference daznLogin = null;
        daznLogin = new PageReference('/mylogin');
        if (String.isNotBlank(selectedSubject)) {
            daznLogin.getParameters().put('type', selectedSubject);
        }
        daznLogin.getParameters().put('loginType', 'DAZN');
        daznLogin.setRedirect(true);
        return daznLogin;
    }
    
    /*PD-9104*/
    public PageReference redirectToDocomoSignInPage() {
        String subjectParam = 'contactus' + ';' + selectedSubject;
        return CommunityHelper.docomoAuthentication(subjectParam);
    }
}