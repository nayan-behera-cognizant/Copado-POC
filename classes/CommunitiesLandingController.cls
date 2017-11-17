/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
   /* public PageReference forwardToStartPage() {
        return Network.communitiesLanding();
    }*/
    
     public PageReference forwardToStartPage() {
        String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        System.debug('>>> userAgent = ' + userAgent);

        //PageReference reference=new PageReference('/myaccountproxy');
        //reference.setRedirect(true);
        //return reference;

        // PD-8870 start (DfD users are redirected to PartnerAccount page - Partner_Account_Configuration__c.Page_Name__c, other users are redirected to MyAccount)
        Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
        
        /*Start part of PD-10449*/
        Partner_Account_Configuration__c pacApple = Partner_Account_Configuration__c.getInstance('Apple');
        
        Boolean isAppleSettings = false;
        Boolean isAppleUser = false;
        String appleUserType;
        /*End part of PD-10449*/

        String docomoUserType;
        String docomoPartnerPage;

        Boolean isDocomoSettings = false;
        Boolean isDfDUser = false;

        if (pac != null) {
            isDocomoSettings = true;
            docomoUserType = pac.Partner_Type__c;
            docomoPartnerPage = (String.isNotBlank(pac.Page_Name__c) && pac.Page_Name__c.contains('.')) ? pac.Page_Name__c.substring(0, pac.Page_Name__c.indexOf('.')) : pac.Page_Name__c;
        }

        /*Start part of PD-10449*/
        if (pacApple != null) {
            isAppleSettings = true;
            appleUserType = pacApple.Partner_Type__c;
        }
        /*End part of PD-10449*/

        PageReference myAccount;
        User u = [Select Id, Contact.Id, Contact.Account.Type, Contact.Account.Partner_ID__c From User Where Id = :UserInfo.getUserId()];
        isDfDUser = (u.Contact != null) && (u.Contact.Account != null) && String.isNotBlank(u.Contact.Account.Type) && String.isNotBlank(docomoUserType) && u.Contact.Account.Type.equals(docomoUserType) && String.isNotBlank(u.Contact.Account.Partner_ID__c);
        
        /*Start part of PD-10449*/
        isAppleUser = (u.Contact != null) && (u.Contact.Account != null) && String.isNotBlank(u.Contact.Account.Type) && String.isNotBlank(appleUserType) && u.Contact.Account.Type.equals(appleUserType) && !isDfDUser;
        /*End part of PD-10449*/
        
        if (isDocomoSettings && isDfDUser) {
            myAccount = new PageReference('/' + docomoPartnerPage);
        } 
        /*Start part of PD-10449*/
        else if (isAppleSettings && !isDfDUser && isAppleUser && isDocomoSettings) {
            myAccount = new PageReference('/' + docomoPartnerPage);

        }
        /*End part of PD-10449*/
        else {
            myAccount = new PageReference('/myaccount');
        }       
        myAccount.setRedirect(true);
        return myAccount;
        // PD-8870 end
    }
    
    public CommunitiesLandingController() {}
}