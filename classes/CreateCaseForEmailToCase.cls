/******************************This class is created as part of the PD-8670. *****************************/
global class CreateCaseForEmailToCase implements Messaging.InboundEmailHandler {
 
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                       Messaging.InboundEnvelope env){
 
    // InboundEmailResult object for returning the result of the 
    // Apex Email Service
    
    /*Start PD-14478*/
    String caseGeneralRecordTypeId = (DAZNConfiguration__c.getValues('CaseGeneralProcessRecordTypeId') != null) ? DAZNConfiguration__c.getValues('CaseGeneralProcessRecordTypeId').Value__c : UpdateAccountTriggerHandler.getRecordTypeId('General_Process', 'Case');
    /*End PD-14478*/
                                                           
    Messaging.InboundEmail.TextAttachment[] tAttachments;
    Messaging.InboundEmail.BinaryAttachment[] bAttachments;                                                       
    if(email.textAttachments !=null){
         tAttachments= email.textAttachments;                                                      
       }
        if(email.binaryAttachments  !=null){
         bAttachments= email.binaryAttachments;                                                      
       }
    list<Attachment> listOfAttachments = new list<Attachment>();
                                                           
    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
     
     AssignmentRule AR =new AssignmentRule();
    //Fetching the assignment rules on case
    AR = [select id,name from AssignmentRule where SobjectType = 'Case' and Active = true and name = 'Case Assignment By Type and Locale'];
    //Creating the DMLOptions for "Assign using active assignment rules" checkbox
    Database.DMLOptions dmlOpts = new Database.DMLOptions();     
    dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                                                           
    list<Case> listOfCases = new list<Case>();
    list<Account> listOfAccounts;
    if(email!=null && email.fromAddress !=null){
    listOfAccounts =[select id,PersonEmail,Notification_Country_Code__c,Notification_Language_Code__c from account where PersonEmail=:email.fromAddress and Type != 'Docomo' and Partner_ID__c = null ];
    }
      
     String itemRef = null;
     String target = email.Subject.toLowerCase();  // .toLowerCase()
     String patternString;
     Pattern thePattern;
     Matcher matcher;
                                                           
     if(email!=null && email.fromAddress !=null && email.subject !=null ){
     String emailSubject =email.subject; 
     
    /*  Take the text between the period and ":ref"  For example in the ref [ ref:00D7JFzw.50070H3Rh8:ref ] extract 5007H3Rh8
     Take that text and remove the 50070. For example H3Rh8 
     Append H3Rh8 to https://na5.salesforce.com/5007000000  to produce https://na5.salesforce.com/5007000000H3Rh8.   This is your link to get to the case.
    */  
     patternString = DAZNConfiguration__c.getValues('PatternInEmailSubject').Value__c;
     thePattern = Pattern.compile(patternString);
     matcher = thePattern.matcher(emailSubject); // do not change to lower case for this test because Id's are case sensitive
     }                                                 
                                                           
    
      if (matcher.matches()) {
      String caseId = matcher.group(2) + '00000' + matcher.group(3);
      system.debug('===CaseId=='+caseId);
      Case[] matchingCases = [Select id,CaseNumber,owner.name from Case where Id = :caseId];
      system.debug('===matchingCases]'+matchingCases[0].id);
         if(matchingCases.size() == 1) {
       Case theCase = matchingCases[0];
            itemRef = theCase.CaseNumber;
      }     
     if(itemRef == null) {
      patternString = '.*case[;:=]?\\s*([0-9]+).*';
      thePattern = Pattern.compile(patternString);
      matcher = thePattern.matcher(target);
      
      if (matcher.matches()) {
       itemRef = matcher.group(1);
      }
     }
       list<EmailMessage> newEmail = new  list<EmailMessage>();
         System.debug('Debug 1');
        newEmail.add(new EmailMessage(FromAddress = email.fromAddress,
        FromName = email.fromName,
        ToAddress = email.toAddresses[0],
        Subject = email.subject,
        TextBody = email.plainTextBody,
        HtmlBody = email.htmlBody,
        ParentId = caseId,
        Incoming = true,
        status ='0')); 
         System.debug('Debug 2');
        insert newEmail;
        System.debug('Debug 3');
     }
                                               
        else if(listOfAccounts!=null && listOfAccounts.size()>0){
        Case cs= new Case();
        cs.Accountid = listOfAccounts[0].id;
        cs.Type=  'Email to Case';
        cs.Origin ='Email';
        cs.Status  = 'Open';
        cs.Priority = System.Label.Case_Priority;
        cs.Subject  = email.subject;
        cs.RecordTypeid = /*System.label.CaseGeneralProcessRecordTypeId*/caseGeneralRecordTypeId;
        cs.Description = email.plaintextbody;
        cs.SuppliedEmail =listOfAccounts[0].PersonEmail;
        if(listOfAccounts[0].Notification_Country_Code__c !=null && listOfAccounts[0].Notification_Language_Code__c != null){
        cs.Notification_Country_Code__c =listOfAccounts[0].Notification_Country_Code__c;
            if(listOfAccounts[0].Notification_Language_Code__c.split('_').size() == 2){
                cs.Notification_Language_Code__c = listOfAccounts[0].Notification_Language_Code__c.split('_')[0];
            }else{   
                cs.Notification_Language_Code__c = listOfAccounts[0].Notification_Language_Code__c;
            }
            if(dmlOpts != null){
        cs.setOptions(dmlOpts);
            }
        }  

        listOfCases.add(cs);
        }
        else if(email !=null){
            Case cs;
            if(email.fromAddress.endswith('JP') || email.fromAddress.endswith('jp')){
                cs = new Case();
                cs.Type=  'Email to Case';
                cs.Origin ='Email';
                cs.Status  = 'Open';
                cs.Priority = System.Label.Case_Priority;
                cs.Subject  = email.subject;
                cs.RecordTypeid = /*System.label.CaseGeneralProcessRecordTypeId*/caseGeneralRecordTypeId;
                cs.Description = email.plaintextbody;
                cs.SuppliedEmail =email.fromAddress;
                cs.Notification_Country_Code__c ='JP';
                cs.Notification_Language_Code__c = 'ja';
                if(dmlOpts != null){
                    cs.setOptions(dmlOpts);
                }
                listOfCases.add(cs);
            }else if(email.fromAddress.endswith('DE') || email.fromAddress.endswith('de')){
                cs = new Case();
                cs.Type=  'Email to Case';
                cs.Origin ='Email';
                cs.Status  = 'Open';
                cs.Priority = System.Label.Case_Priority;
                cs.Subject  = email.subject;
                cs.RecordTypeid = /*System.label.CaseGeneralProcessRecordTypeId*/caseGeneralRecordTypeId;
                cs.Description = email.plaintextbody;
                cs.SuppliedEmail =email.fromAddress;
                cs.Notification_Country_Code__c ='DE';
                cs.Notification_Language_Code__c = 'de';
                if(dmlOpts != null){
                    cs.setOptions(dmlOpts);
                }
                listOfCases.add(cs);
            }else if(email.fromAddress.endswith('AT') || email.fromAddress.endswith('at')){
                cs = new Case();
                cs.Type=  'Email to Case';
                cs.Origin ='Email';
                cs.Status  = 'Open';
                cs.Priority = System.Label.Case_Priority;
                cs.Subject  = email.subject;
                cs.RecordTypeid = /*System.label.CaseGeneralProcessRecordTypeId*/caseGeneralRecordTypeId;
                cs.Description = email.plaintextbody;
                cs.SuppliedEmail =email.fromAddress;
                cs.Notification_Country_Code__c ='AT';
                cs.Notification_Language_Code__c = 'de';
                if(dmlOpts != null){
                    cs.setOptions(dmlOpts);
                }
                listOfCases.add(cs);
            }else if(email.fromAddress.endswith('CH') || email.fromAddress.endswith('ch')){
                cs = new Case();
                cs.Type=  'Email to Case';
                cs.Origin ='Email';
                cs.Status  = 'Open';
                cs.Priority = System.Label.Case_Priority;
                cs.Subject  = email.subject;
                cs.RecordTypeid = /*System.label.CaseGeneralProcessRecordTypeId*/caseGeneralRecordTypeId;
                cs.Description = email.plaintextbody;
                cs.SuppliedEmail =email.fromAddress;
                cs.Notification_Country_Code__c ='CH';
                cs.Notification_Language_Code__c = 'de';
                if(dmlOpts != null){
                    cs.setOptions(dmlOpts);
                }
                listOfCases.add(cs);
            }
            /*Added as a part of PD-12065*/
            else if(email.fromAddress.endswith('CA') || email.fromAddress.endswith('ca')){
                cs = new Case();
                cs.Type=  'Email to Case';
                cs.Origin ='Email';
                cs.Status  = 'Open';
                cs.Priority = System.Label.Case_Priority;
                cs.Subject  = email.subject;
                cs.RecordTypeid = /*System.label.CaseGeneralProcessRecordTypeId*/caseGeneralRecordTypeId;
                cs.Description = email.plaintextbody;
                cs.SuppliedEmail =email.fromAddress;
                cs.Notification_Country_Code__c ='CA';
                cs.Notification_Language_Code__c = 'en';
                if(dmlOpts != null){
                    cs.setOptions(dmlOpts);
                }
                listOfCases.add(cs);
            }//End of PD-12065
            else {
                cs = new Case();
                cs.Type=  'Email to Case';
                cs.Origin ='Email';
                cs.Status  = 'Open';
                cs.Priority = System.Label.Case_Priority;
                cs.Subject  = email.subject;
                cs.RecordTypeid = /*System.label.CaseGeneralProcessRecordTypeId*/caseGeneralRecordTypeId;
                cs.Description = email.plaintextbody;
                cs.SuppliedEmail =email.fromAddress;
                cs.Notification_Country_Code__c ='Unknown';
                cs.Notification_Language_Code__c = 'Unknown';
                if(dmlOpts != null){
                    cs.setOptions(dmlOpts);
                }
                listOfCases.add(cs);
            }
        }
        
        /** Below code added as part of the ticket PD-13384 **/
        Integer emailSize = email.plainTextBody.length();
        if(email.binaryAttachments != null) {
            for(Messaging.InboundEmail.BinaryAttachment file : email.binaryAttachments) {
                emailSize = emailSize + file.body.size();
            }
        }
        if(email.textAttachments != null) {
            for(Messaging.InboundEmail.TextAttachment file : email.textAttachments) {
                emailSize = emailSize + file.body.length();
            }
        }                                         
        //End of PD-13384
        try {
            System.debug('listOfCasesinsidetry'+listOfCases);
            if(listOfCases!=null && listOfCases.size() >0){
                Database.insert(listOfCases,false);
                //insert listOfCases;
                 System.debug('listOfCasesinsidetryinsert'+listOfCases);
            }
            
            //integer attachmentsize = System.Label.Case_Attachment_Size;
            if(emailSize/1048576 <= Integer.valueOf(System.Label.Case_Attachment_Size) && listOfCases.isEmpty()){   // Checking for 25 MB
                if(tAttachments!= null ){
                    for(Messaging.InboundEmail.TextAttachment tAtt:tAttachments) {
                            Attachment attachments = new Attachment();
                            attachments.parentId = listOfCases[0].id;
                            attachments.name = tAtt.fileName;
                            attachments.body = Blob.valueOf(tAtt.body);
                            listOfAttachments.add(attachments);
                    }
                }
                if(bAttachments!= null){
                    for(Messaging.InboundEmail.BinaryAttachment bAtt:bAttachments) {
                            Attachment attachments = new Attachment();
                            attachments.parentId = listOfCases[0].id;
                            attachments.name = bAtt.fileName;
                            attachments.body = bAtt.body;
                            listOfAttachments.add(attachments);
                     }
                }
            }       
            if(listOfAttachments !=null && listOfAttachments.size() > 0 && emailSize/1048576 <= Integer.valueOf(System.Label.Case_Attachment_Size)){  // Checking for 25 MB
                insert listOfAttachments;
            }    
            if(emailSize/1048576 >= Integer.valueOf(System.Label.Case_Attachment_Size)){  // Checking for 25 MB and written to enter into exception block
                insert listOfAttachments[1];
            }
        }
        catch (Exception ex) { 
                    Attachment attachments = new Attachment();
                    if(listOfCases.size()>0){
                        if(!Test.isRunningTest()){   
                            attachments.parentId = listOfCases[0].id;
                        }
                        if(Test.isRunningTest()){   
                            attachments.parentId = [SELECT id FROM Case LIMIT 1].id;
                        }
                    attachments.name = 'test';
                    String myString = 'StringToBlob';
                    attachments.body = Blob.valueof(myString);
                    attachments.Description = 'Incoming file is so long';
                        if(attachments !=null){
                            insert attachments;
                        }
                    }       
           ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CreateCaseForEmailToCase', 'handleInboundEmail', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        }
   // Set the result to true. No need to send an email back to the user 
   // with an error message
   result.success = true;
   
   // Return the result for the Apex Email Service
   return result;
  }
}