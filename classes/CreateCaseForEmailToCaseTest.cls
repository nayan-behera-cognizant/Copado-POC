@isTest
public class CreateCaseForEmailToCaseTest {
   @testSetup
    public static void setUpTestDataOne() {
        List<DAZNConfiguration__c> dhr = new List<DAZNConfiguration__c>();
        dhr.add(new DAZNConfiguration__c(
            Name = 'PatternInEmailSubject',
            Value__c ='.*ref:(.{11}).(.{5})(.+):ref.*'
        ));
          insert dhr;
    }

    @isTest
    static void testFromAddressisFromDaznuser(){
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.triggerSettings();
        
        Id RecordTypeIdCase = [select id,Name from RecordType where SobjectType='Case' and Name='General Process' Limit 1].id;
        SetUpTestData.testCreateDAZNConfiguration('CaseGeneralProcessRecordTypeId', RecordTypeIdCase);
        list<Account> listOfAccounts = new list<account>();
        listOfAccounts =[select id,PersonEmail,Notification_Country_Code__c,Notification_Language_Code__c from account ]; 
        listOfAccounts[0].Notification_Country_Code__c='DE';
        listOfAccounts[0].Notification_Language_Code__c='en_GB';
        update listOfAccounts[0];
        
        Case caseObj = new Case(
        ContactId = listOfAccounts[0].PersonContactId,
        AccountId = listOfAccounts[0].Id,
        Status = 'Working',
        Origin = 'Phone',
        Subject = 'Test',
        Description = 'Test');    
        insert caseObj;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        email.subject = 'test12';
        email.plaintextbody = 'test12';
        email.fromAddress =  listOfAccounts[0].PersonEmail;
        CreateCaseForEmailToCase casetoEmail = new CreateCaseForEmailToCase();
        casetoEmail.handleInboundEmail(email, env ); 
        Case updatedCases = [SELECT id,Subject FROM Case WHERE subject = 'test12'];
        System.assertEquals(updatedCases.subject, email.subject);
    }
    @isTest
    static void testFromAddressisFromDaznuserOne(){
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.triggerSettings();
        Id RecordTypeIdCase = [select id,Name from RecordType where SobjectType='Case' and Name='General Process' Limit 1].id;
        SetUpTestData.testCreateDAZNConfiguration('CaseGeneralProcessRecordTypeId', RecordTypeIdCase);
        list<Account> listOfAccounts = new list<account>();
        listOfAccounts =[select id,PersonEmail,Notification_Country_Code__c,Notification_Language_Code__c from account ]; 
        listOfAccounts[0].Notification_Country_Code__c='DE';
        listOfAccounts[0].Notification_Language_Code__c='en_GB';
        update listOfAccounts[0];
        
        Case caseObj = new Case(
        ContactId = listOfAccounts[0].PersonContactId,
        AccountId = listOfAccounts[0].Id,
        Status = 'Working',
        Origin = 'Phone',
        Subject = 'Test',
        Description = 'Test');
    
        insert caseObj;
        
        list<EmailMessage> newEmail = new  list<EmailMessage>();         
        newEmail.add(new EmailMessage(FromAddress = 'testsalesforce@gmail.com',
        FromName = 'Test',
        ToAddress = 'test.salesforce.com',
        Subject = 'Test',
        TextBody = 'Test',
        HtmlBody = 'Test',
        ParentId = caseObj.Id)); 
         
        insert newEmail;
        String caseid = caseObj.Id;
          system.debug('===TestCaseId=='+caseId);
        List<string> str = new list<string>();
        str.add(listOfAccounts[0].PersonEmail);
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        email.subject = 'test12 Thread Id - ref:_00D268ulS._'+caseid.substring(0,5)+caseid.substring(10,15)+':ref:';
        //email.subject = 'test';
        email.plaintextbody = 'test12';
        email.fromAddress =  listOfAccounts[0].PersonEmail;
        email.toAddresses =  str;
        // add an Binary attachment
        /* Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };*/
        
        CreateCaseForEmailToCase casetoEmail = new CreateCaseForEmailToCase();
        casetoEmail.handleInboundEmail(email, env ); 
        Case updatedCases = [SELECT id,Subject FROM Case WHERE id =: caseid];
        System.assertEquals(updatedCases.Subject,'Test');
    }
    @isTest
    static void testFromAddressisFromDaznuserTwo(){
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.triggerSettings();
        Id RecordTypeIdCase = [select id,Name from RecordType where SobjectType='Case' and Name='General Process' Limit 1].id;
        SetUpTestData.testCreateDAZNConfiguration('CaseGeneralProcessRecordTypeId', RecordTypeIdCase);       
        list<Account> listOfAccounts = new list<account>();
        listOfAccounts =[select id,PersonEmail,Notification_Country_Code__c,Notification_Language_Code__c from account ]; 
        listOfAccounts[0].Notification_Country_Code__c='DE';
        listOfAccounts[0].Notification_Language_Code__c='en_GB';
        update listOfAccounts[0];
        
        
        Case caseObj = new Case(
        ContactId = listOfAccounts[0].PersonContactId,
        AccountId = listOfAccounts[0].Id,
        Status = 'Working',
        Origin = 'Phone',
        Subject = 'Test',
        Description = 'Test');
    
        insert caseObj;
        
        list<EmailMessage> newEmail = new  list<EmailMessage>();
        newEmail.add(new EmailMessage(FromAddress = 'testsalesforce@gmail.com',
        FromName = 'Test',
        ToAddress = 'test.salesforce.com',
        Subject = 'Test',
        TextBody = 'Test',
        HtmlBody = 'Test',
        ParentId = caseObj.Id)); 
         
        insert newEmail;
        String caseid = caseObj.Id;
        List<string> str = new list<string>();
        str.add(listOfAccounts[0].PersonEmail);
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        email.subject = 'test12 Thread Id - ref:_00D268ulS._'+caseid.substring(0,5)+caseid.substring(10,15)+':ref:';
        //email.subject = 'test';
        email.plaintextbody = 'test12';
        email.fromAddress =  listOfAccounts[0].PersonEmail;
        email.toAddresses =  str;
        
          
        /*Messaging.InboundEmail.TextAttachment txtattachment = new Messaging.InboundEmail.TextAttachment();
            txtattachment.body = 'my attachment text';
            txtattachment.fileName = 'textfileone.txt';
            txtattachment.mimeTypeSubType = 'text/plain';
            email.textAttachments = new Messaging.InboundEmail.TextAttachment[] { txtattachment };*/

        CreateCaseForEmailToCase casetoEmail = new CreateCaseForEmailToCase();
        casetoEmail.handleInboundEmail(email, env ); 
        Case updatedCases = [SELECT id,Subject,Priority FROM Case WHERE id =: caseid];
        System.assertEquals(updatedCases.Subject,'Test');
    }
     @isTest
    static void testFromAddressisFromDaznuserde(){
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.triggerSettings();
        
        Id RecordTypeIdCase = [select id,Name from RecordType where SobjectType='Case' and Name='General Process' Limit 1].id;
        SetUpTestData.testCreateDAZNConfiguration('CaseGeneralProcessRecordTypeId', RecordTypeIdCase);
        list<Account> listOfAccounts = new list<account>();
        listOfAccounts =[select id,PersonEmail,Notification_Country_Code__c,Notification_Language_Code__c from account ]; 
        listOfAccounts[0].Notification_Country_Code__c='DE';
        listOfAccounts[0].Notification_Language_Code__c='de';
        update listOfAccounts[0];
        
        Case caseObj = new Case(
        ContactId = listOfAccounts[0].PersonContactId,
        AccountId = listOfAccounts[0].Id,
        Status = 'Working',
        Origin = 'Phone',
        Subject = 'Test',
        Description = 'Test');
    
        insert caseObj;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        email.subject = 'test12';
        email.plaintextbody = 'test12';
        email.fromAddress =  listOfAccounts[0].PersonEmail;
        Messaging.InboundEmail.TextAttachment txtattachment = new Messaging.InboundEmail.TextAttachment();
            txtattachment.body = 'my attachment text';
            txtattachment.fileName = 'textfileone.txt';
            txtattachment.mimeTypeSubType = 'text/plain';
            email.textAttachments = new Messaging.InboundEmail.TextAttachment[] { txtattachment };
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
            attachment.body = blob.valueOf('my attachment text');
            attachment.fileName = 'textfileone.txt';
            attachment.mimeTypeSubType = 'text/plain';
            email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        CreateCaseForEmailToCase casetoEmail = new CreateCaseForEmailToCase();
        casetoEmail.handleInboundEmail(email, env ); 
        Case updatedCases = [SELECT id,Subject,Priority FROM Case WHERE subject ='Test'];
        System.assertEquals(updatedCases.Subject,'Test');
    }
    @isTest
    static void testFromAddressisFromJapanja(){
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.triggerSettings();
        Id RecordTypeIdCase = [select id,Name from RecordType where SobjectType='Case' and Name='General Process' Limit 1].id;
        SetUpTestData.testCreateDAZNConfiguration('CaseGeneralProcessRecordTypeId', RecordTypeIdCase);        
        list<Account> listOfAccounts = new list<account>();
        listOfAccounts =[select id,PersonEmail,Notification_Country_Code__c,Notification_Language_Code__c from account ]; 
        listOfAccounts[0].Notification_Country_Code__c='DE';
        listOfAccounts[0].Notification_Language_Code__c='de';
        update listOfAccounts[0];
        
        Case caseObj = new Case(
        ContactId = listOfAccounts[0].PersonContactId,
        AccountId = listOfAccounts[0].Id,
        Status = 'Working',
        Origin = 'Phone',
        Subject = 'Test',
        Description = 'Test');
    
        insert caseObj;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        email.subject = 'Test';
        email.plaintextbody = 'test12';
        email.fromAddress =  'test@jp';

        Messaging.InboundEmail.TextAttachment txtattachment = new Messaging.InboundEmail.TextAttachment();
            txtattachment.body = 'my attachment text';
            txtattachment.fileName = 'textfileone.txt';
            txtattachment.mimeTypeSubType = 'text/plain';
            email.textAttachments = new Messaging.InboundEmail.TextAttachment[] { txtattachment };
           // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
            attachment.body = blob.valueOf('my attachment text');
            attachment.fileName = 'textfileone.txt';
            attachment.mimeTypeSubType = 'text/plain';
            email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        CreateCaseForEmailToCase casetoEmail = new CreateCaseForEmailToCase();
        casetoEmail.handleInboundEmail(email, env );
        Case updatedCases = [SELECT id,Subject,Priority FROM Case WHERE subject ='Test'];
        System.assertEquals(updatedCases.Subject,email.Subject);        
    }
    @isTest
    static void testFromAddressisFromDACHAT(){
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.triggerSettings();
        Id RecordTypeIdCase = [select id,Name from RecordType where SobjectType='Case' and Name='General Process' Limit 1].id;
        SetUpTestData.testCreateDAZNConfiguration('CaseGeneralProcessRecordTypeId', RecordTypeIdCase);        
        list<Account> listOfAccounts = new list<account>();
        listOfAccounts =[select id,PersonEmail,Notification_Country_Code__c,Notification_Language_Code__c from account ]; 
        listOfAccounts[0].Notification_Country_Code__c='DE';
        listOfAccounts[0].Notification_Language_Code__c='de';
        update listOfAccounts[0];
        
        Case caseObj = new Case(
        ContactId = listOfAccounts[0].PersonContactId,
        AccountId = listOfAccounts[0].Id,
        Status = 'Working',
        Origin = 'Phone',
        Subject = 'test12',
        Description = 'Test');
    
        insert caseObj;
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        email.subject = 'test12';
        email.plaintextbody = 'test12';
        email.fromAddress =  'test@at';
        Messaging.InboundEmail.TextAttachment txtattachment = new Messaging.InboundEmail.TextAttachment();
            txtattachment.body = 'my attachment text';
            txtattachment.fileName = 'textfileone.txt';
            txtattachment.mimeTypeSubType = 'text/plain';
            email.textAttachments = new Messaging.InboundEmail.TextAttachment[] { txtattachment };
            // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
            attachment.body = blob.valueOf('my attachment text');
            attachment.fileName = 'textfileone.txt';
            attachment.mimeTypeSubType = 'text/plain';
            email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            // add an Binary attachment
        CreateCaseForEmailToCase casetoEmail = new CreateCaseForEmailToCase();
        casetoEmail.handleInboundEmail(email, env ); 
        Case updatedCases = [SELECT id,Subject,Priority FROM Case WHERE subject ='test12'];
        System.assertEquals(updatedCases.Subject,email.Subject);    
    }
    @isTest
    static void testFromAddressisFromDACHCH(){
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.triggerSettings();
        Id RecordTypeIdCase = [select id,Name from RecordType where SobjectType='Case' and Name='General Process' Limit 1].id;
        SetUpTestData.testCreateDAZNConfiguration('CaseGeneralProcessRecordTypeId', RecordTypeIdCase);        
        list<Account> listOfAccounts = new list<account>();
        listOfAccounts =[select id,PersonEmail,Notification_Country_Code__c,Notification_Language_Code__c from account ]; 
        listOfAccounts[0].Notification_Country_Code__c='DE';
        listOfAccounts[0].Notification_Language_Code__c='de';
        update listOfAccounts[0];
        
        Case caseObj = new Case(
        ContactId = listOfAccounts[0].PersonContactId,
        AccountId = listOfAccounts[0].Id,
        Status = 'Working',
        Origin = 'Phone',
        Subject = 'Test',
        Description = 'Test');
    
        insert caseObj;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        email.subject = 'test12';
        email.plaintextbody = 'test12';
        email.fromAddress =  'test@ch';
        Messaging.InboundEmail.TextAttachment txtattachment = new Messaging.InboundEmail.TextAttachment();
            txtattachment.body = 'my attachment text';
            txtattachment.fileName = 'textfileone.txt';
            txtattachment.mimeTypeSubType = 'text/plain';
            email.textAttachments = new Messaging.InboundEmail.TextAttachment[] { txtattachment };
            // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
            attachment.body = blob.valueOf('my attachment text');
            attachment.fileName = 'textfileone.txt';
            attachment.mimeTypeSubType = 'text/plain';
            email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        CreateCaseForEmailToCase casetoEmail = new CreateCaseForEmailToCase();
        casetoEmail.handleInboundEmail(email, env ); 
        Case updatedCases = [SELECT id,Subject,Priority FROM Case WHERE subject ='Test'];
        System.assertNotEquals(updatedCases.Subject,email.Subject); 
    }
    @isTest
    static void testFromAddressisFromDACHde(){
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.triggerSettings();
        Id RecordTypeIdCase = [select id,Name from RecordType where SobjectType='Case' and Name='General Process' Limit 1].id;
        SetUpTestData.testCreateDAZNConfiguration('CaseGeneralProcessRecordTypeId', RecordTypeIdCase);        
        list<Account> listOfAccounts = new list<account>();
        listOfAccounts =[select id,PersonEmail,Notification_Country_Code__c,Notification_Language_Code__c from account ]; 
        listOfAccounts[0].Notification_Country_Code__c='DE';
        listOfAccounts[0].Notification_Language_Code__c='de';
        update listOfAccounts[0];
        
        Case caseObj = new Case(
        ContactId = listOfAccounts[0].PersonContactId,
        AccountId = listOfAccounts[0].Id,
        Status = 'Working',
        Origin = 'Phone',
        Subject = 'Test',
        Description = 'Test');
    
        insert caseObj;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        email.subject = 'test12';
        email.plaintextbody = 'test12';
        email.fromAddress =  'test@de';
        Messaging.InboundEmail.TextAttachment txtattachment = new Messaging.InboundEmail.TextAttachment();
            txtattachment.body = 'my attachment text';
            txtattachment.fileName = 'textfileone.txt';
            txtattachment.mimeTypeSubType = 'text/plain';
            email.textAttachments = new Messaging.InboundEmail.TextAttachment[] { txtattachment };
            // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
            attachment.body = blob.valueOf('my attachment text');
            attachment.fileName = 'textfileone.txt';
            attachment.mimeTypeSubType = 'text/plain';
            email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        CreateCaseForEmailToCase casetoEmail = new CreateCaseForEmailToCase();
        casetoEmail.handleInboundEmail(email, env ); 
        Case updatedCases = [SELECT id,Subject,Priority FROM Case WHERE subject ='Test'];
        System.assertNotEquals(updatedCases.Subject,email.Subject); 
    }
    
    /*Added as a part of PD-12065*/
     @isTest
    static void testFromAddressisFromCanadaCA(){
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.triggerSettings();
        Id RecordTypeIdCase = [select id,Name from RecordType where SobjectType='Case' and Name='General Process' Limit 1].id;
        SetUpTestData.testCreateDAZNConfiguration('CaseGeneralProcessRecordTypeId', RecordTypeIdCase);        
        list<Account> listOfAccounts = new list<account>();
        listOfAccounts =[select id,PersonEmail,Notification_Country_Code__c,Notification_Language_Code__c from account ]; 
        listOfAccounts[0].Notification_Country_Code__c='DE';
        listOfAccounts[0].Notification_Language_Code__c='de';
        update listOfAccounts[0];
        
        Case caseObj = new Case(
        ContactId = listOfAccounts[0].PersonContactId,
        AccountId = listOfAccounts[0].Id,
        Status = 'Working',
        Origin = 'Phone',
        Subject = 'Test',
        Description = 'Test');
    
        insert caseObj;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        email.subject = 'test12';
        email.plaintextbody = 'test12';
        email.fromAddress =  'test@ca';
        Messaging.InboundEmail.TextAttachment txtattachment = new Messaging.InboundEmail.TextAttachment();
            txtattachment.body = 'my attachment text';
            txtattachment.fileName = 'textfileone.txt';
            txtattachment.mimeTypeSubType = 'text/plain';
            email.textAttachments = new Messaging.InboundEmail.TextAttachment[] { txtattachment };
            // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
            attachment.body = blob.valueOf('my attachment text');
            attachment.fileName = 'textfileone.txt';
            attachment.mimeTypeSubType = 'text/plain';
            email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        CreateCaseForEmailToCase casetoEmail = new CreateCaseForEmailToCase();
        casetoEmail.handleInboundEmail(email, env );
        Case updatedCases = [SELECT id,Subject,Priority FROM Case WHERE subject ='Test'];
        System.assertNotEquals(updatedCases.Subject,email.Subject);         
    }
    //End of PD-12065
   
     @isTest
    static void testFromAddressisFromUnknown(){
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.triggerSettings();
        Id RecordTypeIdCase = [select id,Name from RecordType where SobjectType='Case' and Name='General Process' Limit 1].id;
        SetUpTestData.testCreateDAZNConfiguration('CaseGeneralProcessRecordTypeId', RecordTypeIdCase);        
        list<Account> listOfAccounts = new list<account>();
        listOfAccounts =[select id,PersonEmail,Notification_Country_Code__c,Notification_Language_Code__c from account ]; 
        listOfAccounts[0].Notification_Country_Code__c='DE';
        listOfAccounts[0].Notification_Language_Code__c='de';
        update listOfAccounts[0];
        
        Case caseObj = new Case(
        ContactId = listOfAccounts[0].PersonContactId,
        AccountId = listOfAccounts[0].Id,
        Status = 'Working',
        Origin = 'Phone',
        Subject = 'Test',
        Description = 'Test');
    
        insert caseObj;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        email.subject = 'test12';
        email.plaintextbody = 'test12';
        email.fromAddress =  'test@';
        Messaging.InboundEmail.TextAttachment txtattachment = new Messaging.InboundEmail.TextAttachment();
            txtattachment.body = 'my attachment text';
            txtattachment.fileName = 'textfileone.txt';
            txtattachment.mimeTypeSubType = 'text/plain';
            email.textAttachments = new Messaging.InboundEmail.TextAttachment[] { txtattachment };
            // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
            attachment.body = blob.valueOf('my attachment text');
            attachment.fileName = 'textfileone.txt';
            attachment.mimeTypeSubType = 'text/plain';
            email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        CreateCaseForEmailToCase casetoEmail = new CreateCaseForEmailToCase();
        casetoEmail.handleInboundEmail(email, env );
        Case updatedCases = [SELECT id,Subject,Priority FROM Case WHERE subject ='Test'];
        System.assertNotEquals(updatedCases.Subject,email.Subject); 
    }
}