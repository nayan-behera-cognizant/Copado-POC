public with sharing class AccountExt {

    public Boolean isShowAccount {get; set;}
    public Boolean isShowAccountName {get;set;}
    public Boolean isAppleOrDocomoAccount {get;set;}

    public AccountExt(ApexPages.StandardController sc) {
        isAppleOrDocomoAccount = false;
        isShowAccount = true;

        User currentUser = [
            SELECT Id, Profile.Name, Profile.Id
            FROM User
            WHERE Id = :UserInfo.getUserId()
        ];
		system.debug('currentUser===>'+currentUser);
        if (currentUser.Profile.Name == 'Customer Community User' || currentUser.Profile.Name == 'Customer Community Login User' || currentUser.Profile.Name == 'DfD Community User') {
            isShowAccount = false;
        } 
        /*PD-10738*/        
        isShowAccountName = hideAcountName(currentUser);
        /* endPD-10738*/
        
        /*PD-7429*/
        isAppleOrDocomoAccount = isAccountDocomoOrApple();
        /*end PD-7429*/
    }

    public PageReference doInit() {

        if (!isShowAccount) {        

            PageReference myAccountPage = new PageReference('https://' + ApexPages.currentPage().getHeaders().get('Host') + '/CommunitiesLanding');
            myAccountPage.setRedirect(true);            
            return myAccountPage;

        } 

        return null;

    }

    public  Boolean hideAcountName(User currentUser) {
        Boolean isResult = false;
        List<Customer_Service_Profile_Configuration__c> config = [SELECT Profile_Name__c FROM Customer_Service_Profile_Configuration__c];
        if (!config.isEmpty()) {
            //Set<String> profName = new Set<String>();
            for (Customer_Service_Profile_Configuration__c item : config) {
                //profName.add(item.Profile_Name__c);
                if (item.Profile_Name__c == currentUser.Profile.Id && isAccountDfD()) {
                    isResult = true;
                    break;
                }
            }            
            //if (profName.contains(currentUser.Profile.Name) && isAccountDfD()) {            
            //    isResult = true;                
            //}
            
        }
        
        return isResult;        
    }

    public  Boolean isAccountDfD() {
        Boolean isDfD = false;
        Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
        String accountId = ApexPages.currentpage().getParameters().get('Id');
        List<Account> acc = [SELECT Partner_ID__c, Type FROM Account WHERE Id = :accountId];
        if (!acc.isEmpty() && !String.isBlank(acc[0].Partner_ID__c) && !String.isBlank(acc[0].Type) && acc[0].Type.equals(pac.Partner_Type__c)) {
            isDfD = true;            
        }
        return isDfD;        
        
    }

    /*PD-7429*/
    public Boolean isAccountDocomoOrApple() {
        Boolean isAppleOrDocomoAccount = false;
        Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
        Partner_Account_Configuration__c pacApple = Partner_Account_Configuration__c.getInstance('Apple');
        String accountId = ApexPages.currentpage().getParameters().get('Id');
        List<Account> acc = [SELECT Partner_ID__c, Type FROM Account WHERE Id = :accountId];
        if (!acc.isEmpty() && !String.isBlank(acc[0].Partner_ID__c) && !String.isBlank(acc[0].Type)) {
            if (acc[0].Type.equals(pac.Partner_Type__c) || acc[0].Type.equals(pacApple.Partner_Type__c)) {
                isAppleOrDocomoAccount = true;
            }
        }
        return isAppleOrDocomoAccount;
    }
    /*end PD-7429*/

}