/**
*  @author Dasetti Venkata Ramaiah(Cognizant)
*  @date May 19, 2017
*  @description CaseCommetnExtConTest 
*  @Modification Log:        
------------------------------------------------------------------------------------        
Developer                Vesrsion No       Date                Description        
------------------------------------------------------------------------------------        
Dasetti Venkat Ramaiah       -           19/05/2017           Initial version created.
*/

@isTest
public class CaseCommetnExtConTest{
    
    public static void testDatadcvsdvSetUp(){
        user u =[select id from user where id=:userinfo.getUserId()];
        system.runAs(u){
            EmailTemplate et = new EmailTemplate();  
            et.isActive = true;  
            et.Name = 'testTemplate';  
            et.DeveloperName = 'Agent_Commented_AT_EN';  
            et.TemplateType = 'text';  
            et.FolderId = UserInfo.getUserId();  
            et.Body = '';             
            insert et;   
            
            
        }
        EmailTemplateSelection__c setting = new EmailTemplateSelection__c(
            Name = 'AT_EN',
            Template_Unique_Name__c = 'Agent_Commented_AT_EN',
            Country_Code__c ='AT',
            Language_Code__c='EN'  
            
        );
        insert setting;
        //To create a long string
        String sample = 'abcde12345'; //10-digit string.
        integer length = 30000;
        for (Integer cutoff = 4; cutoff <= 31000; cutoff = cutoff * 10) {
            if (length <= cutoff) {
                
                sample.substring(0, length);
            }
            else {
                String newSample = '';
                for (Integer i = 0; i < 7; i ++) {
                    newSample += sample;
                }
                sample = newSample;
                
            }
        }
        //To create a long string
        String sample1 = 'abcde12345'; //10-digit string.
        string scj ='';
        for (Integer i = 0; i < 4000; i ++) {
            scj += sample1;
        }
        
        Account oAccount = new Account();
        oAccount.DFD_Last_Name__c = 'strFirstName';
        oAccount.DFD_First_Name__c = 'strLastName';
         oAccount.LastName = 'strFirstName';
        oAccount.FirstName = 'strLastName';
        
       // oAccount.PersonEmail = 'pm2testemail@email.com';
        oAccount.Account_Status__c = 'Active Paid';
        oAccount.Partner_ID__c = '13412341234233434';
        oAccount.Type = 'Docomo';
        oAccount.Secondary_Email__c='pm2testemail@email.com';
        oAccount.Notification_Country_Code__c ='JP';
        oAccount.Notification_Language_Code__c ='en';
        insert oAccount;
        account ac = [Select Id,Name,PersonContactId, Owner.Name, owner.UserRoleId,PersonEmail from Account where PersonEmail='pm2testemail@email.com' ];
        contact con = new contact();
        con.AccountId = oAccount.id;
        con.Email='pm2testemail@email.com';
        con.LastName ='strLastName';
        con.FirstName = 'strFirstName';
        insert con;
        recordtype rty = [select id, name from recordtype where developerName='DFD_Customer' and sobjecttype='Case' ];
        recordtype rty1 = [select id, name from recordtype where developerName='General_Process' and sobjecttype='Case' ];
        
        case case1 = new Case(Subject ='testSubject',Description ='testdescription',Type='General Enquiry',status='Waiting for Customer',SuppliedEmail='pm2testemail@email.com',accountid =oAccount.id,Notification_Country_Code__c ='JP',Notification_Language_Code__c='ja');
        
        insert case1;
        // EmailMessage Creation
        
        EmailMessage[] newEmail = new EmailMessage[0];
        
        newEmail.add(new EmailMessage(FromAddress = 'pm2testemail@email.com', Incoming = True, ToAddress= 'pm2testemail@email.com', Subject = 'Test emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest email', TextBody = sample , ParentId = case1.id));
        newEmail.add(new EmailMessage(FromAddress = 'pm2testemail@email.com', Incoming = True, ToAddress= 'pm2testemail@email.com', Subject = 'Test emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest email', TextBody = sample , ParentId = case1.id));
        newEmail.add(new EmailMessage(FromAddress = 'pm2testemail@email.com', Incoming = True, ToAddress= 'pm2testemail@email.com', Subject = 'Test emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest email', TextBody = sample , ParentId = case1.id)); 
        newEmail.add(new EmailMessage(FromAddress = 'pm2testemail@email.com', Incoming = True, ToAddress= 'pm2testemail@email.com', Subject = 'Test emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest email', TextBody = sample , ParentId = case1.id)); 
        newEmail.add(new EmailMessage(FromAddress = 'pm2testemail@email.com', Incoming = True, ToAddress= 'pm2testemail@email.com', Subject = 'Test emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest email', TextBody = sample , ParentId = case1.id)); 
        newEmail.add(new EmailMessage(FromAddress = 'pm2testemail@email.com', Incoming = True, ToAddress= 'pm2testemail@email.com', Subject = 'Test emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest email', TextBody = sample , ParentId = case1.id));
        newEmail.add(new EmailMessage(FromAddress = 'pm2testemail1@email.com', Incoming = True, ToAddress= 'pm2testemail@email.com', Subject = 'Test emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest email', TextBody = 'fhfkhkfhkhvkhvhhb' , ParentId = case1.id));
        insert newEmail;
        
        //Creating casecomment
        list<Casecomment> cclist = new list<Casecomment>();
        Casecomment ccmntObj = new casecomment();
        ccmntObj.CommentBody =sample1;
        ccmntObj.IsPublished = true;
        ccmntObj.ParentId = case1.id;
        //insert ccmntObj;
        cclist.add(ccmntObj);
        Casecomment ccmntObj1 = new casecomment();
        ccmntObj1.CommentBody =sample1;
        ccmntObj1.IsPublished = true;
        ccmntObj1.ParentId = case1.Id;
        cclist.add(ccmntObj1);
        Casecomment ccmntObj2 = new casecomment();
        ccmntObj2.CommentBody =sample1;
        ccmntObj2.IsPublished = true;
        ccmntObj2.ParentId = case1.Id;
        cclist.add(ccmntObj2);
        insert cclist;
        
        case c=[select id, status from case where SuppliedEmail='pm2testemail123@email.com' limit 1];
       system.assertEquals('Waiting for Customer',c.status);
        
        
    }
    //positive testing case
    static testmethod void CaseComntTestMethod(){            
        
        Account oAccount = new Account( LastName = 'strFirstName', FirstName = 'strLastName',DFD_First_Name__c = 'strFirstName',DFD_Last_Name__c = 'strLastName',
                                       Account_Status__c = 'Active Paid',Partner_ID__c = '13412341234233434',Type = 'Docomo',Secondary_Email__c='pm2testemail@email.com',
                                       Notification_Country_Code__c ='JP',Notification_Language_Code__c ='en_gbp');
        insert oAccount;
        system.assert(oAccount.id != null,'account record is not inserted');
        
        case case1 = new Case(Subject ='testSubject',Description ='testdescription',Type='General Enquiry',status='Waiting for Customer',SuppliedEmail='pm2testemail@email.com',accountid =oAccount.id,Notification_Country_Code__c ='JP',
                              Notification_Language_Code__c ='en_GBP');
        insert case1;
        String sample1 = 'abcde12345'; //10-digit string.
        string scj ='';
        for (Integer i = 0; i < 300; i ++) {
            scj += sample1;
        }
        Casecomment ccmntObj = new casecomment();
        ccmntObj.CommentBody ='fgfsgsfjsjhkkjkjhjhadjhadjkhkjahkjadhvkjavkjckjvjvjhvjdjdajhgkjsadhjashkjahgkjahkjhakjghakjhkjs';
        ccmntObj.IsPublished = true;
        ccmntObj.ParentId = case1.id;
        insert ccmntObj;
        Casecomment ccmntObj12 = new casecomment();
        ccmntObj12.CommentBody ='fgfsgsfjsjhkkjkjhjhadjhadjkhkjahkjadhvkjavkjckjvjvjhvjdjdajhgkjsadhjashkjahgkjahkjhakjghakjhkjs';
        ccmntObj12.IsPublished = true;
        ccmntObj12.ParentId = case1.id;
        insert ccmntObj12;
        
        system.assert(case1.id != null,'case record is not inserted');
        
        string fnalstring = scj + scj +scj+scj;        
        EmailMessage em = new EmailMessage(FromAddress = 'pm2testemail@email.com', Incoming = True, ToAddress= 'pm2testemail@email.com', Subject = 'Test emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest email', TextBody = fnalstring , ParentId = case1.id);
        insert em;
        EmailTemplateSelection__c setting = new EmailTemplateSelection__c(
            Name = 'Member_AT_EN',
            Template_Unique_Name__c = 'Agent_Commented_AT_EN',
            Country_Code__c ='AT',
            Language_Code__c='EN'  
        );
        insert setting;
        List<Profile> listOfProfiles = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
        account ac =[select id,PersonContactId from account where Secondary_Email__c='pm2testemail@email.com' limit 1 ];
        
        
        PageReference pageRef = Page.casecomment;
        pageRef.getParameters().put('parent_id', case1.ID);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController stdController = new Apexpages.StandardController(case1); 
        CaseCommentExtCon ccmInstance = New CaseCommentExtCon(stdController);
        ccmInstance.cComment.CommentBody =scj ;
        ccmInstance.cComment.isPublished = true;
        ccmInstance.threadToInclude = true;
        list<user> uer =[select id, email from user where email ='pm2testemail@email.com' limit 1];
        ccmInstance.getEmailTemplateFolderOpts();
        ccmInstance.selectedEmailTemplateFolder = UserInfo.getUserId();
        
        ccmInstance.refreshEmailTemplateSection();       
        ccmInstance.getCaseStatus();
        ccmInstance.getCaseComments();
        //ccmInstance.sendMail(uer[0].email,caseCommentsList[0].CommentBody,case1);
        
        
        ccmInstance.cancelRecord();
        // ccmInstance.selectionTemplate();
        // ccmInstance.selectedEmailTemplate = [select id,Body from EmailTemplate where developername='Agent_Commented_AT_EN' ].id;
        ccmInstance.copyEmailTemplateData();
        ccmInstance.saveRecord();   
        
    }
    //negative testing scenario
    static testmethod void CaseComntNegtiveTestMethod(){ 
         EmailTemplateSelection__c setting = new EmailTemplateSelection__c(
            Name = 'Member_AT_EN',
            Template_Unique_Name__c = 'Agent_Commented_AT_EN',
            Country_Code__c ='AT',
            Language_Code__c='EN'  
        );
        insert setting;
        recordtype rty = [select id, name from recordtype where developerName='DFD_Customer' and sobjecttype='Case' ];
        Case caseobj=new Case(recordtypeid=rty.id,Subject ='testSubject',Description ='testdescription',Type='General Enquiry',status='Waiting for Customer',SuppliedEmail='pm2testemail1@email.com',Notification_Country_Code__c ='JP');
        insert caseobj;         
        Casecomment ccmntObj = new casecomment();
        ccmntObj.CommentBody ='Hello Test data';
        ccmntObj.IsPublished = false;
        ccmntObj.ParentId = caseobj.id;
        insert ccmntObj;
        EmailMessage st =  new EmailMessage(FromAddress = 'pm2testemail1@email.com', Incoming = True, ToAddress= 'pm2testemail@email.com', Subject = 'Test emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest email', TextBody = 'fhfkhkfhkhvkhvhhb' , ParentId = caseobj.Id); 
        insert st;
        Test.setCurrentPageReference(new PageReference('Page.casecomment'));
        System.currentPageReference().getParameters().put('parent_id', caseobj.ID);
        Apexpages.StandardController stdController = new Apexpages.StandardController(ccmntObj); 
        CaseCommentExtCon ccmInstance = New CaseCommentExtCon(stdController);
        ccmInstance.getCaseStatus();
        ccmInstance.getCaseComments();
        ccmInstance.saveRecord();
        ccmInstance.cancelRecord();
        case c=[select id, status from case where SuppliedEmail='pm2testemail1@email.com' limit 1];
       system.assertEquals('Waiting for Customer',c.status);
        
    }
    //Exception testing scenario
    static testmethod void CaseComntExpetionTestMethod(){ 
        try{
            Test.setCurrentPageReference(new PageReference('Page.casecomment'));
            System.currentPageReference().getParameters().put('parent_id', '');
            Apexpages.StandardController stdController = new Apexpages.StandardController(new casecomment()); 
            CaseCommentExtCon ccmInstance = New CaseCommentExtCon(stdController);
            ccmInstance.getCaseStatus();
            ccmInstance.getCaseComments();
            ccmInstance.saveRecord();
            ccmInstance.cancelRecord();
            ccmInstance.sendMail(null,null,new case());
        }catch(exception ex){
            
            
        }
    }
    
    //Template Folder and Template code coverage method
    static testMethod void caseCommentTemplateFolderTest(){
        list<EmailTemplateSelection__c> emailTemp = new list<EmailTemplateSelection__c>();
        emailTemp.add(new EmailTemplateSelection__c( Name = 'Member_AT_EN', Template_Unique_Name__c = 'Agent_Commented_AT_EN',
                                                                          Country_Code__c ='AT', Language_Code__c='EN'));
         emailTemp.add(new EmailTemplateSelection__c( Name = 'Non_Member_AT_EN', Template_Unique_Name__c = 'Agent_Commented_Non_Member_AT_EN',
                                                                          Country_Code__c ='AT', Language_Code__c='EN'));
        insert emailTemp;
        
      //  recordtype rty = [select id, name from recordtype where developerName='DFD_Customer' and sobjecttype='Case' ];
        Case caseobj=new Case(Subject ='testSubject',Description ='testdescription',Type='General Enquiry',SuppliedEmail='pm2testemail123@email.com',Notification_Country_Code__c ='AT',Notification_Language_Code__c='en_gbp');
        insert caseobj;     
        Casecomment ccmntObj = new casecomment();
        ccmntObj.CommentBody ='dfgsdfgsdfgsfg';
        ccmntObj.IsPublished = true;
        ccmntObj.ParentId = caseobj.id;
        insert ccmntObj;
        PageReference pageRef = Page.casecomment;
        pageRef.getParameters().put('parent_id', caseobj.ID);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController stdController = new Apexpages.StandardController(caseobj); 
        CaseCommentExtCon ccmInstance = New CaseCommentExtCon(stdController);
         ccmInstance.cComment.CommentBody ='dfhajfhafhashdfkashfkhasdfkhsdkfhkasdfhkasdfh' ;
        ccmInstance.cComment.isPublished = true;
        ccmInstance.threadToInclude = true;
         ccmInstance.getEmailTemplateFolderOpts();
        ccmInstance.selectedEmailTemplateFolder = UserInfo.getUserId();        
        ccmInstance.refreshEmailTemplateSection();       
        ccmInstance.getCaseStatus();
        ccmInstance.getCaseComments();
        ccmInstance.copyEmailTemplateData();
        ccmInstance.saveRecord();   
         ccmInstance.cancelRecord();
       case c=[select id, status from case where SuppliedEmail='pm2testemail123@email.com' limit 1];
       system.assertEquals('Waiting for Customer',c.status);
    }
      //Testing email template functionality :PD-16580
   static testmethod void caseEmailTemplate(){            
    
    Account oAccount = new Account( LastName = 'strFirstName', FirstName = 'strLastName',DFD_First_Name__c = 'strFirstName',DFD_Last_Name__c = 'strLastName',
       Account_Status__c = 'Active Paid',Partner_ID__c = '13412341234233434',Type = 'Docomo',Secondary_Email__c='pm2testemail@email.com',
       Notification_Country_Code__c ='JP',Notification_Language_Code__c ='en');
    insert oAccount;
    system.assert(oAccount.id != null,'account record is not inserted');
    
    case case1 = new Case(Subject ='testSubject',Description ='testdescription',Type='General Enquiry',status='Waiting for Customer',SuppliedEmail='pm2testemail@email.com',accountid =oAccount.id,Notification_Country_Code__c ='JP',
    Notification_Language_Code__c ='en');
    insert case1;
    String sample1 = 'abcde12345'; //10-digit string.
    string scj ='';
    for (Integer i = 0; i < 300; i ++) {
    scj += sample1;
    }
    Casecomment ccmntObj = new casecomment();
    ccmntObj.CommentBody ='fgfsgsfjsjhkkjkjhjhadjhadjkhkjahkjadhvkjavkjckjvjvjhvjdjdajhgkjsadhjashkjahgkjahkjhakjghakjhkjs';
    ccmntObj.IsPublished = true;
    ccmntObj.ParentId = case1.id;
    insert ccmntObj;
      PageReference pageRef = Page.casecomment;
        pageRef.getParameters().put('parent_id', case1.ID);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController stdController = new Apexpages.StandardController(case1); 
        CaseCommentExtCon ccmInstance = New CaseCommentExtCon(stdController);
           ccmInstance.cComment.CommentBody ='dfhajfhafhashdfkashfkhasdfkhsdkfhkasdfhkasdfh' ;
           ccmInstance.cComment.isPublished = true;
           ccmInstance.threadToInclude = true;
           ccmInstance.getEmailTemplateFolderOpts();
           ccmInstance.selectedEmailTemplateFolder = UserInfo.getUserId();        
           ccmInstance.refreshEmailTemplateSection();       
           ccmInstance.getCaseStatus();
           ccmInstance.getCaseComments();
           ccmInstance.copyEmailTemplateData();
           ccmInstance.saveRecord();           
         recordtype rty = [select id, name from recordtype where developerName='DFD_Customer' and sobjecttype='Case' ];
        Case caseobj=new Case(recordtypeid=rty.id,Subject ='testSubject',Description ='testdescription',Type='General Enquiry',status='Waiting for Customer',SuppliedEmail='pm2testemail1@email.com',Notification_Country_Code__c ='JP',Notification_Language_Code__c='jp');
        insert caseobj;         
        Casecomment ccmntObjnew = new casecomment();
        ccmntObjnew.CommentBody ='Hello Test data';
        ccmntObjnew.IsPublished = false;
        ccmntObjnew.ParentId = caseobj.id;
        insert ccmntObjnew;
        EmailMessage st =  new EmailMessage(FromAddress = 'pm2testemail1@email.com', Incoming = True, ToAddress= 'pm2testemail@email.com', Subject = 'Test emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest emailTest email', TextBody = 'fhfkhkfhkhvkhvhhb' , ParentId = caseobj.Id); 
        insert st;
        Test.setCurrentPageReference(new PageReference('Page.casecomment'));
        System.currentPageReference().getParameters().put('parent_id', caseobj.ID);
        Apexpages.StandardController stdControllertwo = new Apexpages.StandardController(caseobj); 
        CaseCommentExtCon ccmInstancetwo = New CaseCommentExtCon(stdControllertwo);
        ccmInstancetwo.getCaseStatus();
        ccmInstancetwo.getCaseComments();
        ccmInstancetwo.saveRecord();
        ccmInstancetwo.cancelRecord();
    }
    
}