public with sharing class SamplePageCon {
public string caseID;
public case cases{get;set;}

public samplePageCon(){
   // try{
     caseID = ApexPages.currentPage().getParameters().get('parent_id');
      if(caseID != null){
       cases =[select id, casenumber,subject,description,status,recordtype.name,recordtype.id,Notification_Country_Code__c,
                        Notification_Language_Code__c,Account.Notification_Country_Code__c,ContactEmail,Previous_Customer_Comments__c,Account.Notification_Language_Code__c,Accountid,Account.name,Account.Secondary_Email__c,SuppliedEmail,Account.Partner_ID__c, Account.Type,account.firstname,
                        account.lastname from case where id =:caseID ];
      
                        
      
      }
     
     
   /*}catch(exception ex){
   system.debug('Constructor------>'+ex.getMessage()+' line No :'+ex.getStackTraceString());
    ExceptionLoggerHelper.createExceptionLog(userinfo.getuserid(), 'CaseCommentExtCon', 'CaseCommentExtCon', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
   apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, System.Label.Please_Contact_Your_Admi));
                        
   
   }*/


}

    
  
    

}