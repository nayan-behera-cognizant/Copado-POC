/**
*  @author Dasetti Venkata Ramaiah(Cognizant)
*  @date May 09, 2017
*  @description CaseCommentExtCon
*  @Modification Log:        
------------------------------------------------------------------------------------        
Developer                Vesrsion No       Date                Description        
------------------------------------------------------------------------------------        
Dasetti Venkat Ramaiah       -           9/05/2017           Initial version created.
*/
public with sharing class CaseCommentExtCon {
    //properties
    public string caseStatusValue{get;set;}
    public caseComment cComment{get;set;}
    public case cases{get;set;}
    public string CaseThred{get;set;}
    public list<caseComment> caseCommentsList;
    public list<EmailMessage> emailMsglist{get;set;}
    public string caseID{get;set;}
    public boolean isPublished ;
    public boolean Iserror{get;set;}       
    
    //Templating section code varibles
    @testVisible private List<EmailTemplate> allEmailTemplates;
    @testVisible private List<Folder> allEmailTemplateFolders;
    public String selectedEmailTemplateFolder{get;set;}
    public String foldervalue;
    public map<string,EmailTemplate> emailTempMap;
    // public string caseCommentBody{get;set;}
    
    public String selectedEmailTemplate {public get; public set;}
    
    public string emailAdd;
    public final string CLASSNAME = 'CaseCommentExtCon';
    public final string caseCommentThreelines = '\n\n\n\n\n';
    public string caseDescription;
    
    //Boolean property to hold a value of add thread or not:PD-16580
    public boolean threadToInclude{get;set;}
    
    
    //Constructor
    public CaseCommentExtCon(ApexPages.StandardController controller) {
        try{ 
            threadToInclude = false;
            emailAdd ='';
            caseDescription = '';
            // Iserror = false;
            emailMsglist = new list<EmailMessage>();
            cComment = new caseComment();
            //string caseCommentThreelines ='\n\n\n\n';
            CaseThred ='';
            caseID = ApexPages.currentPage().getParameters().get('parent_id');    
            
            allEmailTemplateFolders = [select Id, Name from Folder where Type = 'Email' order by Name asc];        
            if(caseID != null){
                cases =[select id, casenumber,subject,description,status,recordtype.name,recordtype.id,Notification_Country_Code__c,
                        Notification_Language_Code__c,Account.Notification_Country_Code__c,ContactEmail,Previous_Customer_Comments__c,Account.Notification_Language_Code__c,Accountid,Account.name,Account.Secondary_Email__c,SuppliedEmail,Account.Partner_ID__c, Account.Type,account.DFD_First_Name__c,
                        account.DFD_Last_Name__c from case where id =:caseID ];
                
                caseCommentsList = [select id,CommentBody,IsPublished,ParentId, createddate, lastmodifieddate, CreatedBy.name, CreatedBy.id, LastModifiedBy.name,LastModifiedBy.id from caseComment where ParentId=:cases.id order by createddate DESC ];
                emailMsglist  = [SELECT FromAddress,FromName,ParentId,Subject,TextBody,BccAddress,HtmlBody , CcAddress  FROM EmailMessage WHERE ParentId=:caseID order by createddate DESC limit 1];
                if(cases != null ){
                    emailAdd = emailValidation(cases );
                    caseDescription = '\n\n'+ 'Description : '+ cases.description;
                    
                } 
                
                
                
                // cComment.CommentBody= caseCommentThreelines ;
                if(!emailMsglist.isEmpty() && !String.isBlank(emailMsglist[0].TextBody) ){
                    //for(EmailMessage emsg:emailMsglist ){
                     CaseThred = CaseThred + emailMsglist[0].TextBody.replace('>','').replace('<','');//.stripHtmlTags();
                    // }
                }
                if(CaseThred.length() > 110000){
                    CaseThred = CaseThred.substring(0,110000);
                    
                    
                }
                if(cases != null && !emailMsglist.isEmpty() && !string.isBlank(CaseThred)){
                    
                    CaseThred  = maskCaseComment(cases , CaseThred);
                                      
                }
                
                
                
            }
        }
        catch(Exception ex){

             apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, System.Label.Please_Contact_Your_Admi));
            
        }
        
    }
    
    /**     
*  @Method: emailValidation     
*  @description : This method is to vaild email - PD-12354      
*  @Parameter : Case object and string to be masked     
*/
    public string emailValidation(case caseObj ){
        if(!String.isBlank(caseObj.SuppliedEmail)){
            
            return caseObj.SuppliedEmail;
            
        }else{
            return caseObj.ContactEmail;
            
        }
        
    }       
    
    
    /**
*  @Method: maskCaseComment
*  @description : This method is used to dispay the case status drop down 
*  @Parameter : Case object and string to be masked
*/
    public String maskCaseComment(case cas, string fullCaseCmtString){     
        
        if(!String.isBlank(cas.Account.id) && cas.Account.Type == 'Docomo' && cas.Notification_Country_Code__c =='JP'  && !String.isBlank(cas.Account.Partner_ID__c)){
           
            if(!String.isBlank(cas.Account.DFD_Last_Name__c)){
              string strLast= cas.Account.DFD_Last_Name__c;
               fullCaseCmtString = fullCaseCmtString.replace(strLast, '######');               
            }
            if(!String.isBlank(cas.Account.DFD_First_Name__c)){
                string strFirst= cas.Account.DFD_First_Name__c;
                fullCaseCmtString = fullCaseCmtString.replace(strFirst, '######');                             
            }
            
            if(!String.isBlank(cas.Account.Secondary_Email__c)){
                string actsecondaryEmail = cas.Account.Secondary_Email__c;
                fullCaseCmtString = fullCaseCmtString.replace(actsecondaryEmail, '<######>');
                
            }
             if(!String.isBlank(cas.suppliedemail)){
                  string supp = cas.suppliedemail;
                fullCaseCmtString = fullCaseCmtString.replace(supp, '<######>');
                
             }
             
             if(!String.isBlank(cas.ContactEmail)){
                 string contactEmail = cas.ContactEmail;
                fullCaseCmtString = fullCaseCmtString.replace(contactEmail, '<######>');
             }
            
        }
                
        return fullCaseCmtString ;
        
    }
    
    
    /**
*  @Method: getCaseStatus
*  @description : This method is used to dispay the case status drop down 
*  @Parameter : No
*/
    public list<selectOption> getCaseStatus(){
        list<selectOption> options = new list<selectoption>();
        options.add(new selectOption('Waiting for Customer','Waiting for Customer'));
        options.add(new selectOption('Resolved','Resolved'));
        options.add(new selectOption('Closed','Closed'));
        options.add(new selectOption('Leave Unchanged','Leave Unchanged'));
        
        return options;
    }
    
    /**
*  @Method: getCaseComments
*  @description : TODO- display the list of Case comments in page and displayed in 3 lines 
*  @Parameter : No
*/    
    public list<ReadMore> getCaseComments(){
        try{
            list<ReadMore> readMorelist = new list<ReadMore>();
            if(!caseCommentsList.isEmpty() ){
                for(caseComment  cc:caseCommentsList){
                    ReadMore rm = new ReadMore();
                    rm.ccom = cc;
                    if(cc.CommentBody!= null){
                        string st = cc.CommentBody;
                        
                        if(st.length() > 451){
                            rm.halfstring = st.substring(0,450) ;
                            
                        }else{
                            rm.halfstring = st;//.substring(0,st.length()) ;
                            
                        }
                        
                        readMorelist.add(rm);
                    }
                    
                }
                
            }
            return readMorelist;
        }catch(exception ex)
        {      
           
            apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, System.Label.Please_Contact_Your_Admi));
            return null;
            
        }
       
    }
    
    //Templating section of logic startes here 
    public List<SelectOption> getEmailTemplateFolderOpts() {
        List<SelectOption> opts = new List<SelectOption>();
        opts.add(new SelectOption('null', ' - Select - '));
        for ( Folder f : allEmailTemplateFolders )
            opts.add(new SelectOption(f.Id, f.Name));
        // add an option for templates in the Unfiled Public folder
        opts.add(new SelectOption(UserInfo.getOrganizationId(), 'Unfiled Public'));
        return opts;
    }
    
    
    public List<SelectOption> EmailTemplateOpts{get;set;}    
    public PageReference refreshEmailTemplateSection() {
        emailTempMap = new  map<string,EmailTemplate>();
        EmailTemplateOpts = new List<SelectOption>();
        if (selectedEmailTemplateFolder != null ) {
            allEmailTemplates = [select Id, Name,developerName, Subject, Body, FolderId from EmailTemplate where FolderId =:selectedEmailTemplateFolder order by Name asc];
            EmailTemplateOpts.add(new SelectOption('null', ' - Select - '));
            for(EmailTemplate et : allEmailTemplates){
                EmailTemplateOpts.add(new SelectOption(et.Id, et.Name));
                emailTempMap.put(et.Id,et);
                
            }
            
        }
        
        return null;
    }
    
    public void copyEmailTemplateData(){
        if(selectedEmailTemplate!=null){
            if(emailTempMap.containsKey(selectedEmailTemplate)){
                EmailTemplate  temp = emailTempMap.get(selectedEmailTemplate);
                cComment.CommentBody =  temp.body ; 
                
                
            }
        }
        
        
        
    }
    
    
    /**
*  @Method: SaveRecord
*  @description : TODO- Save the casecomment and updating case status if any changes happened 
*  @Parameter : No
*/    
    public PageReference saveRecord(){
        Savepoint sp = null;
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.allowFieldTruncation = true;
        try{
            sp = Database.setSavepoint();   
            if(String.isBlank(cComment.CommentBody)){
                Iserror = true;
                apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, 'Comment: Please enter the value'));
                
                return null;
                
            }else{
                
                integer count = 0;
                
                cComment.ParentId = cases.id;
                string fnalstring =  cComment.CommentBody;//+'\n\n'+CaseThred.replace('<br/>','\r\n'); 
                
                String finalcomment = cComment.CommentBody ;//+ caseCommentThreelines + CaseThred; 
                if(emailMsglist.isEmpty()){
                    finalcomment = finalcomment + caseDescription ;
                    
                }
                //PD-16580
                if(CaseThred!=null && threadToInclude){
                
                    finalcomment = finalcomment +caseCommentThreelines +  CaseThred ;
                    
                }
                if(finalcomment.length() > 3999){      
                    count = [SELECT count() FROM Attachment where ParentId=:cases.id]; 
                    count = count==0?1:count+1;                 
                    Attachment a = new Attachment();
                    a.ParentId = caseID ;
                    a.Name = 'Attach:'+count +' - ' + System.Now();
                    a.ContentType = 'text/plain;charset=UTF-8';
                    a.Body = Blob.valueOf( finalcomment );                 
                    insert a;
                    cComment.CommentBody = finalcomment.substring(0,3970) ;
                    isPublished = cComment.IsPublished!=null?cComment.IsPublished:false;
                    Database.insert(cComment, dmo);
                    
                }else{
                    isPublished = cComment.IsPublished!=null?cComment.IsPublished:false;
                    // cComment.CommentBody = fnalstring;
                    Database.insert(cComment, dmo);
                    
                }            
                
                cases.Previous_Customer_Comments__c = finalcomment;
                if(caseStatusValue != 'Leave Unchanged'){
                    cases.status = caseStatusValue ;
                    
                } 
                //update ;
                Database.SaveResult saRestult = database.update(cases );
                if(saRestult.isSuccess()){
                    if( isPublished  &&  emailAdd !=null && cComment.CommentBody!= null ){
                        sendMail(emailAdd , fnalstring,cases );
                        
                    }
                    
                }else{
                    Database.rollback(sp); 
                    
                }
                
                /* if( isPublished  &&  cases.SuppliedEmail!=null && cComment.CommentBody!= null ){
sendMail(cases.SuppliedEmail, fnalstring,cases );

}*/
            }    
            
        }catch(exception ex){
            Database.rollback(sp); 
            Iserror = true;
          
            ExceptionLoggerHelper.createExceptionLog(userinfo.getuserid(), CLASSNAME, 'saveRecord', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, Ex.getmessage()+'ex.getlinenumber():'+ex.getlinenumber()));
            return null;
        }
        
        return null;
        
    }
    
    /***********************************
* Method:sendMail
* Description: Will send the mail when case comment is checked public
* Returntype:Void
* 
* ********************************/
    
    public  void sendMail(string lstToEmailAddress,string emailBody,case c){
        
        list<contact> u  ;
        String[] toAddresses = new list<string>();
        string caseThredId ;
        string useriD ;
        contact con;
        try{
            if(lstToEmailAddress!= null){
                
                toAddresses.add(lstToEmailAddress);
                u =[select id from contact where Email =:lstToEmailAddress ];
                if ( u.size() > 0){
                    useriD=  u[0].Id;
                }else{
                    // Create a dummy contact to use setTargetObjecId and Also can avoid hitting the send emails limit
                    con = new Contact(FirstName ='Test',LastName = 'Contact',Email = lstToEmailAddress);
                    insert con;           
                    useriD = con.id;
                }
            }
            
            if(!toAddresses.isEmpty() && !String.isBlank(emailBody)  ){
                
                string tempUnqName = selectionTemplate();
                
                string OrgEmailAddres = Label.LS_Org_Wide_Addresses;
                EmailTemplate templat = [select Id,developerName, Subject,htmlvalue, Body from EmailTemplate where developerName =:tempUnqName limit 1];
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:OrgEmailAddres ];
                Messaging.SingleEmailMessage mail = null;
                mail = new Messaging.SingleEmailMessage();                     
                mail.setToAddresses(toAddresses);
                mail.setSaveAsActivity(false);
                mail.setTargetObjectId(useriD);               
                mail.setTemplateID(templat.Id); 
                mail.setWhatId(c.id);
                mail.setOrgWideEmailAddressId(owea[0].id);
                mail.setReplyTo(Label.LS_Label_Email_Services_Address);//);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                if( con!= null &&con.email!= null ){
                    delete con;
                }
                
            }
        }catch(exception ex){
           
            ExceptionLoggerHelper.createExceptionLog(userinfo.getuserid(), CLASSNAME, 'sendMail', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            
        }
        
    }
    /* Method:selectionTemplate
* Description: Will return the template name based on case country 
* Returntype : string  
* 
*/
    
    public string selectionTemplate(){      
        
        string TemplateName ='';
        string uniqueTemp ='';
        try{
            Map<String,EmailTemplateSelection__c> allTempNames = EmailTemplateSelection__c.getAll();
            
            if(cases.AccountId!= null && cases.Account.Notification_Country_Code__c != null & cases.Account.Notification_Language_Code__c != null ){
               if(cases.Account.Notification_Language_Code__c.contains('_')){
                string lang  =  cases.Account.Notification_Language_Code__c.split('_')[0];
                TemplateName = label.ls_member_template+'_'+cases.Account.Notification_Country_Code__c.toUpperCase()+'_'+lang.toUpperCase();
               }else{
                TemplateName = label.ls_member_template+'_'+cases.Account.Notification_Country_Code__c.toUpperCase()+'_'+cases.Account.Notification_Language_Code__c.toUpperCase();
                }
                
            } else{
                if(cases.AccountId == null && cases.Notification_Language_Code__c.contains('_')){
                    string langCurncy = cases.Notification_Language_Code__c;
                    string lang  = langCurncy.split('_')[0];
                    string Countrycode = cases.Notification_Country_Code__c!= null ?cases.Notification_Country_Code__c:'CA';
                    TemplateName = label.ls_non_member_template+'_'+Countrycode.toUpperCase()+'_'+lang.toUpperCase();
                    
                }else{
                     TemplateName = label.ls_non_member_template+'_'+cases.Notification_Country_Code__c.toUpperCase()+'_'+cases.Notification_Language_Code__c.toUpperCase();
                
                }
                
            }
           
            if(TemplateName!='' & allTempNames.containsKey(TemplateName)){
                uniqueTemp = allTempNames.get(TemplateName).Template_Unique_Name__c;
                
            }else{
                uniqueTemp = allTempNames.get(label.ls_non_member_template+'_AT_EN').Template_Unique_Name__c;
              
            }
            return uniqueTemp ;
        }catch(exception ex){           
           
            ExceptionLoggerHelper.createExceptionLog(userinfo.getuserid(), CLASSNAME, 'selectionTemplate', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return null;
        
        }
       
    }
    
    
    
    /**
*  @Method: cancelRecord
*  @description : TODO- Cancel the transaction and navigate to previous state 
*  @Parameter : No
*/    
    public pagereference cancelRecord(){
        
        Iserror = false;
        
        return null;
    }      
    
    
    //Wrapper Class  
    public class ReadMore{
        public caseComment ccom{get;set;}
        public string halfstring{get;set;}
        
    }
    
    
}