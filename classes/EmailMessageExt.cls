public with sharing class EmailMessageExt {
    
    public Boolean isHideEmailAndName      { get; set; }
    public String emailText                { get; set; }
    public String nameText                 { get; set; }

    public String textBodyForReply         { get; set; }
    public String subjectForReply          { get; set; }
    public String relatedToForReply        { get; set; }
    public String toForReply               { get; set; }
    public String ccForReplay              { get; set; }
    public String bccForReplay             { get; set; }

    public EmailMessage emailMessage;

    public EmailMessageExt(ApexPages.StandardController sc) {
        User currentUser = [
            SELECT Id, Profile.Name, Profile.Id
            FROM User
            WHERE Id = :UserInfo.getUserId()
        ];

        this.emailMessage = (EmailMessage)sc.getRecord();
        EmailMessage singleItem = [SELECT FromAddress,FromName,ParentId, TextBody, Subject, BccAddress, CcAddress FROM EmailMessage WHERE Id = :this.emailMessage.Id];
        this.isHideEmailAndName = hideEmailAndName(currentUser, singleItem);
        if (this.isHideEmailAndName) {
            
            this.emailText = singleItem.FromAddress;
            this.nameText = singleItem.FromName;
        }

        this.textBodyForReply = EncodingUtil.urlEncode(singleItem.TextBody,'UTF-8');
        this.subjectForReply = 'RE: ' + EncodingUtil.urlEncode(singleItem.Subject,'UTF-8');
        if (this.subjectForReply.length() > 100) {
            this.subjectForReply = this.subjectForReply.substring(0,100);
        }
        this.relatedToForReply = singleItem.ParentId;
        if (!String.isBlank(singleItem.FromAddress)) {
            List<Contact> cont = [SELECT Id, Email FROM Contact WHERE Email = : singleItem.FromAddress LIMIT 1];
            if (!cont.isEmpty()) {
                this.toForReply = cont[0].Id;
            }
            
        }
        this.ccForReplay = singleItem.CcAddress;
        this.bccForReplay = singleItem.BccAddress;
        
    }

    public  Boolean hideEmailAndName(User currentUser, EmailMessage singleItem) {
        Boolean isResult = false;
        Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
        Case cas = [SELECT AccountId, Account.Partner_ID__c, Account.Type FROM Case WHERE ID = :singleItem.ParentId];
        List<Customer_Service_Profile_Configuration__c> config = [SELECT Profile_Name__c FROM Customer_Service_Profile_Configuration__c];
        if (!config.isEmpty() && !String.isBlank(cas.Account.Partner_ID__c) && !String.isBlank(pac.Partner_Type__c) && !String.isBlank(cas.Account.Type) && cas.Account.Type.equals(pac.Partner_Type__c)) {
            for (Customer_Service_Profile_Configuration__c item : config) {
                if (item.Profile_Name__c == currentUser.Profile.Id) {
                    isResult = true;
                    break;
                }
            }             
        }
        
        return isResult;        
    }
}