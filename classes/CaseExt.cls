public with sharing class CaseExt {

    public Boolean isShowCase {get; set;}
    public Boolean isShowContactEmail { get;set; }

    public CaseExt(ApexPages.StandardController sc) {

        isShowCase = true;

        User currentUser = [
            SELECT Id, Profile.Name, Profile.Id
            FROM User
            WHERE Id = :UserInfo.getUserId()
        ];

        if (currentUser.Profile.Name == 'Customer Community User' || currentUser.Profile.Name == 'Customer Community Login User' || currentUser.Profile.Name == 'DfD Community User') {
            isShowCase = false;
        } 
        /*PD-10738*/
        isShowContactEmail = hideContactEmail(currentUser);
        /*end PD-10738*/

    }

    public PageReference doInit() {

        if (!isShowCase) {

            PageReference myAccountPage = new PageReference('https://' + ApexPages.currentPage().getHeaders().get('Host') + '/CommunitiesLanding');
            myAccountPage.setRedirect(true);
            return myAccountPage;

        }

        return null;

    }

    public  Boolean hideContactEmail(User currentUser) {
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
            //if (profName.contains(currentUser.Profile.Id) && isAccountDfD()) {
            //    isResult = true;
            //}
        }
        
        return isResult;
    }

    public Boolean isAccountDfD() {
        Boolean isDfD = false;
        Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
        String caseId = ApexPages.currentpage().getParameters().get('Id');
        List<Case> cas = [SELECT Account.Type, Account.Partner_ID__c FROM Case WHERE Id = :caseId];
        if (!cas.isEmpty() && !String.isBlank(cas[0].Account.Partner_ID__c) && cas[0].Account.Type.equals(pac.Partner_Type__c)) {
            isDfD = true;
        }
        return isDfD;
    }

    public class ReplyLink {
        public String link;
        public String oldLink;
        public String outBoundEmail;
        public String caseId;
        public String subject;
    }

    @RemoteAction
    public static String ovverideStandardReplyLink(String obj) {
        List<ReplyLink> itemMsg = (List<ReplyLink>)JSON.deserialize(obj, List<ReplyLink>.class);
        Set<String> outBoundEmailsId = new Set<String>();
        for (ReplyLink item : itemMsg) {
            if (item.link.contains('email_id=')) {
                String newLink = '';
                newLink = item.link.substringAfter('email_id=');
                newLink = newLink.substringBefore('&');
                item.outBoundEmail = newLink;
                item.oldLink = item.link;
                item.link = item.link.substringBefore('email_id=') + 'p3_lkid=' + item.caseId;
                outBoundEmailsId.add(newLink);
            } 
        }
        //System.debug('##### final itemMsg = ' + itemMsg);
        Map<Id,EmailMessage> emailMessageById = new Map<Id,EmailMessage>([SELECT FromAddress,FromName,ParentId, TextBody, Subject, BccAddress, CcAddress 
                                                                            FROM EmailMessage 
                                                                            WHERE Id IN :outBoundEmailsId]);
        for (ReplyLink item : itemMsg) {
            if (emailMessageById.containsKey(item.outBoundEmail)) {
                item.subject = emailMessageById.get(item.outBoundEmail).Subject;
                item.link +=  '&p6=' + 'RE: ' + item.subject;

            }
        }
        return JSON.serialize(itemMsg);
    }

}