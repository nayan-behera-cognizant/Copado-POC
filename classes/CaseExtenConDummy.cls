public with sharing class CaseExtenConDummy {
    public case cas;
    public Boolean isShowCase {get; set;}
    public Boolean isAccountDfD {get; set;}
    public integer emailSize {get; set;}
    public integer caseCommentSize {get; set;}

    public CaseExtenConDummy(ApexPages.StandardController controller) {
      cas = (case)controller.getRecord();
      system.debug('Case Record'+cas);
      isShowCase = true;

        User currentUser = [
            SELECT Id, Profile.Name, Profile.Id
            FROM User
            WHERE Id = :UserInfo.getUserId()
        ];

        if (currentUser.Profile.Name == 'Customer Community User' || currentUser.Profile.Name == 'Customer Community Login User' || currentUser.Profile.Name == 'DfD Community User') {
            isShowCase = false;
        } 
        isAccountDfD = isAccountDfDmethod();
        
    }
    
    public PageReference doInit() {

        if (!isShowCase) {

            PageReference myAccountPage = new PageReference('https://' + ApexPages.currentPage().getHeaders().get('Host') + '/CommunitiesLanding');
            myAccountPage.setRedirect(true);
            return myAccountPage;

        }

        return null;

    }
     public Boolean isAccountDfDmethod() {
        Boolean isDfD = false;
        Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');
        String caseId = ApexPages.currentpage().getParameters().get('Id');
        List<Case> cas = [SELECT Account.Type, Account.Partner_ID__c FROM Case WHERE Id = :caseId];
        if (!cas.isEmpty() && !String.isBlank(cas[0].Account.Partner_ID__c) && cas[0].Account.Type.equals(pac.Partner_Type__c)) {
            isDfD = true;
        }
        return isDfD;
    }
    
    public list<casecomment> getCaseComments(){
     list<casecomment> caslist = new list<casecomment>();
      if(cas.id!= null){
         for(casecomment cc:[select id,CommentBody,IsPublished,ParentId, createddate, lastmodifieddate, CreatedBy.name, CreatedBy.id, LastModifiedBy.name,LastModifiedBy.id from caseComment where ParentId=:cas.id order by createddate DESC ]){
            caslist.add(cc);
        }
        caseCommentSize = caslist.size();  // Venkat new
      }
    
    return caslist;
    
    }
    
    /*public list<CaseTeamMember> getCaseTeam(){
     list<CaseTeamMember> caslist = new list<CaseTeamMember>();
      if(cas.id!= null){
         for(CaseTeamMember cc:[select id,Member.Name,TeamRole.Name,TeamRole.AccessLevel,TeamRole.PreferencesVisibleInCSP,LastModifiedBy.Name,lastmodifieddate
         from CaseTeamMember where ParentId=:cas.id order by createddate DESC ]){
            caslist.add(cc);
    }
      }
    
    return caslist;
    
    }*/
    
    public string ccId{get;set;}
    public pageReference deleteRec(){
        system.debug('===ccId'+ccId);
        if(ccId!= null){
        casecomment cas = new casecomment();
        cas.id = ccId;
        delete cas;
        }
    PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
    pageRef.setRedirect(true);
    return pageRef;
    //Return null;
    }
    
    public string emId{get;set;}
    public pageReference deleteRecEmail(){
        system.debug('===emId'+emId);
        if(emId!= null){
        emailMessage eMessage = new emailMessage();
        eMessage.id = emId;
        delete eMessage;
        }
    PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
    pageRef.setRedirect(true);
    return pageRef;
    //Return null;
    }
    
    public boolean pubprivate{get;set;}
    public string recordId{get;set;}

    public pageReference privatePub(){

      if(recordId!= null){
       casecomment c = new casecomment();
       c.id =   recordId;
       if(pubprivate){
       c.IsPublished = false;
       }else{
          c.IsPublished = true;
       
       }
       update c;
      }

    return null;
    }

    public list<EmailMessage> getEmailMessages(){
      list<EmailMessage> emailMesg = new list<EmailMessage>();
              if(cas.id!= null){
              for(emailMessage em:[select id,toLabel(Status),FromAddress,FromName,ParentId,Subject,TextBody,BccAddress,HtmlBody, CcAddress,MessageDate from EmailMessage where ParentId=:cas.id order by createddate DESC]){
              emailMesg.add(em);
              
              }
              emailSize = emailMesg.size();  // Venkat new
              
              }

    return emailMesg;
    }

    public PageReference goToCaseComment() {
            PageReference myAccountPage = new PageReference('/apex/casecomment');
            myAccountPage.getParameters().put('parent_id',cas.id);
            myAccountPage.getParameters().put('retURL',cas.id);
            myAccountPage.setRedirect(true);
            return myAccountPage;
    }
    public PageReference updateToEscalate() {
        cas.Status='Escalated';
        update cas;
        return null;
    }
    public PageReference takeOwnership() {
        if(cas.Status == 'Open'){
        cas.Status = 'In Progress';
        }
        else{
        cas.Status = 'Being Handled';
        } 
        cas.OwnerId = UserInfo.getUserId();
        update cas;
        PageReference tempPage = ApexPages.currentPage();            
        tempPage.setRedirect(true);
        return tempPage ;
        //return null;
    }
    public PageReference assignCase() {
        PageReference ChangeOwnerPage = new PageReference('/apex/ChangeCaseOwner');
            ChangeOwnerPage.getParameters().put('Id',cas.id);
            ChangeOwnerPage.setRedirect(true);
            return ChangeOwnerPage;
    }
    public PageReference updateToOnHold() {
        cas.Status='On-Hold';
        update cas;
        return null;
    }
    /*public PageReference ResolveCase() {
        PageReference ChangeOwnerPage = new PageReference('/flow/Resolve_Case?CaseId={!Case.Id}&UserId={!$User.Id}');
            //ChangeOwnerPage.getParameters().put('Id',cas.id);
            ChangeOwnerPage.setRedirect(true);
            return ChangeOwnerPage;
    }
    public PageReference deleteRecord() {
    
        Contact c = [select id from Contact where id =: delId];
        delete c;
        
        PageReference pageRef = new PageReference('/apex/AccountVFP?id='+acc.Id);
        pageRef.setredirect(true);

       
        return pageRef;
    }*
    /*public PageReference caseteampage() {
    
        String hostVal  = ApexPages.currentPage().getHeaders().get('Host');
        
        PageReference caseteampage = new PageReference('{!$Site.Prefix}/0B6/e');
            caseteampage.getParameters().put('kp','500');
            caseteampage.getParameters().put('pid',cas.Id);
            caseteampage.getParameters().put('retURL',cas.Id);
            caseteampage.setRedirect(true);
            return caseteampage;
    }
    public String getRedirectbacktoCase () {
    if (ApexPages.hasMessages()) {
        return null;
    }
    PageReference pr = Page.CasePage;
    pr.getParameters().put('Id', cas.Id);
    pr.setRedirect(true);
    return pr.getURL();
    }*/
}