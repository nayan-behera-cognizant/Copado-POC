public with sharing class EmailHelpOptionExt {

    public Boolean isShowEmailHelpOption {get; set;}

    public EmailHelpOptionExt(ApexPages.StandardController sc) {

        isShowEmailHelpOption = true;

        User currentUser = [
            SELECT Id, Profile.Name
            FROM User
            WHERE Id = :UserInfo.getUserId()
        ];

        if (currentUser.Profile.Name == 'Customer Community User' || currentUser.Profile.Name == 'Customer Community Login User' || currentUser.Profile.Name == 'DfD Community User') {
            isShowEmailHelpOption = false;
        }

    }

    public PageReference doInit() {

        if (!isShowEmailHelpOption) {

            PageReference myAccountPage = new PageReference('https://' + ApexPages.currentPage().getHeaders().get('Host') + '/CommunitiesLanding');
            myAccountPage.setRedirect(true);
            return myAccountPage;

        }

        return null;

    }

}