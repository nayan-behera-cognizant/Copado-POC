public without sharing class KeepInTouchController {

    private User user;

    public String resumeDate { get; set; }
    public String suspendDate { get; set; }
    public String bannerType { get; set; }

    public KeepInTouchController() {
        Map<String, String> countryAndLanguageCodes = CommunityHelper.setCountryAndLanguageCodes(null);
        String slang = countryAndLanguageCodes.get('lang');
        String sCountry = countryAndLanguageCodes.get('Country');
        
        user = CommunityHelper.getCurrentUser();

        List<Account> usersAccount = [Select Id, Account_Status__c, Pause_From__c, Pause_Until__c, PauseScheduled__c, All_Email_Preferences__c, Is_Double_OptIn__c
            From Account
            Where Id = :user.AccountId
            LIMIT 1];
        if (usersAccount == null || usersAccount.isEmpty()) {
            PauseCalloutHelper.redirectToMyAccount('', '', '');
        }
        DateTime dtResumeDate = usersAccount[0].Pause_Until__c;
        DateTime dtSuspendDate = usersAccount[0].Pause_From__c;

        resumeDate = (dtResumeDate == null) ? '' : dtResumeDate.format('yyyy-MM-dd');
        suspendDate = (dtSuspendDate == null) ? '' : dtSuspendDate.format('yyyy-MM-dd');

        if (ApexPages.currentPage().getParameters().get('pauseAction') == 'initiate') {
            bannerType = 'initPause';
        } else if (ApexPages.currentPage().getParameters().get('pauseAction') == 'amend') {
            bannerType = 'amendedPause';
        }
    }

}