/*
 PD-8659 this class is for CS Team Member use Signoutfromalldevices button from saleforce
 */
global class CSSignoutfromalldevices {

    webservice static String CSForceSignout(String accID) {
        String statusMessage = 'Failed';
        if (accID != null) {
            List<User> lstUser = [
                SELECT Id, Account.DAZN_Id__c, AccountId, ContactID, Account.Notification_Country_Code__c
                FROM User
                WHERE AccountId =:accID LIMIT 1
            ];
            if (lstUser != null && lstUser.size() > 0) {
                statusMessage = CommunityHelper.signOutOfAllDevicesFromAccDetail(lstUser[0]);
            }
         }
         return statusMessage;
    }

}