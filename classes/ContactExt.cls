public with sharing class ContactExt {

    public Boolean isShowContact {get; set;}

    public ContactExt(ApexPages.StandardController sc) {

        isShowContact = true;

        User currentUser = [
            SELECT Id, Profile.Name
            FROM User
            WHERE Id =: UserInfo.getUserId()
        ];

        if (currentUser.Profile.Name == 'Customer Community User' || currentUser.Profile.Name == 'Customer Community Login User' || currentUser.Profile.Name == 'DfD Community User') {
            isShowContact = false;
        }

    }

    public PageReference doInit() {

        if (!isShowContact) {

            PageReference myAccountPage = new PageReference('https://' + ApexPages.currentPage().getHeaders().get('Host') + '/CommunitiesLanding');
            myAccountPage.setRedirect(true);
            return myAccountPage;

        }

        return null;

    }

}