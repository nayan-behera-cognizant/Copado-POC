public with sharing class EmailHelpSubOptionExt {

    public Boolean isShowEmailHelpSubOption {get; set;}

    public EmailHelpSubOptionExt(ApexPages.StandardController sc) {

        isShowEmailHelpSubOption = true;

        User currentUser = [
            SELECT Id, Profile.Name
            FROM User
            WHERE Id = :UserInfo.getUserId()
        ];

        if (currentUser.Profile.Name == 'Customer Community User' || currentUser.Profile.Name == 'Customer Community Login User' || currentUser.Profile.Name == 'DfD Community User') {
            isShowEmailHelpSubOption = false;
        }

    }

    public PageReference doInit() {

        if (!isShowEmailHelpSubOption) {

            PageReference myAccountPage = new PageReference('https://' + ApexPages.currentPage().getHeaders().get('Host') + '/CommunitiesLanding');
            myAccountPage.setRedirect(true);
            return myAccountPage;

        }

        return null;

    }

}