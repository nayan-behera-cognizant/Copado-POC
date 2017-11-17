public with sharing class AccountPlaybackHistoryController {

    public AccountPlaybackHistoryController(ApexPages.StandardController sc) {}
    
    /* Methos gets the User.Viewer_Id__c for current Account and redirect to Playback History link
     * 'https://pulse.conviva.com/subscribers/?days=1&filter=97628&viewerId={!User.Viewer_Id__c}''
     */
    public pageReference doInit() {
        String accountId = ApexPages.currentpage().getParameters().get('Id');
        DAZNConfiguration__c configPlaybackHistoryUrl = DAZNConfiguration__c.getValues('CustomerPlaybackHistory');
        String playbackHistoryLink = configPlaybackHistoryUrl != null ? configPlaybackHistoryUrl.Value__c : null;

        if (String.isNotBlank(playbackHistoryLink) && String.isNotBlank(accountId)) {
            List<User> linkedUser = [
                SELECT Id, Viewer_Id__c
                FROM User
                WHERE AccountId =: accountId
                LIMIT 1
            ];
            if (!linkedUser.isEmpty()) {
                playbackHistoryLink += linkedUser[0].Viewer_Id__c;
            }
        }
        if (String.isNotBlank(playbackHistoryLink)) {
            PageReference pageRef = new PageReference(playbackHistoryLink);
            pageRef.setRedirect(true);
            return pageRef;
        } else {
            return null;
        }
	}

}