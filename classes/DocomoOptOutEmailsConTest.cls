@isTest
private class DocomoOptOutEmailsConTest{
    @testsetup
    static void createLead(){
        
        Account oAccount = new Account();
        oAccount.FirstName = 'TestFName';
        oAccount.LastName = 'TestLName';
        oAccount.PersonEmail = 'test@test1234.com';
        oAccount.Account_Status__c = 'Active Paid';
        oAccount.Partner_ID__c = 'NTG5OT5J5Q45540TP45TTTPQ';
        oAccount.Type = 'Docomo';
        oAccount.Secondary_Email__c ='test@test123.com';
        insert oAccount;
        
        CreateTestDataforUnitTest.CreateGuestUser();
        
    }
    
    
    static testmethod void optOutDocomoEmailsTest(){
        List<Profile> profile=[select id, Name from profile where Name='DAZN Profile'limit 1 ];
        List <User> gUser=[select id,UserName from user where profileid= :profile[0].Id  AND IsActive = true limit 1];
        system.assertEquals(1,gUser.size());
        
        test.startTest();
        SingleRequestMock fakeResponse1 = new SingleRequestMock(200,'Complete',DocomoOptOutEmailsConTest.dummyRespose(false),null);    
        Test.setMock(HttpCalloutMock.class, fakeResponse1);  
        String strDocomoPartnerId = 'TlRHNU9UNUo1UTQ1NTQwVFA0NVRUVFBR';
        
        Test.setCurrentPageReference(new PageReference('Page.DocomoOptOutEmails'));
        System.currentPageReference().getParameters().put('ACID', strDocomoPartnerId); 
        string acid = Apexpages.currentPage().getParameters().get('ACID');
        blob decodedACID = EncodingUtil.base64Decode(acid);
        string AcidDecoded = decodedACID.toString();
        list<account> ac=  [select id, Type,PersonEmail,Secondary_Email__c,Partner_ID__c  from account where Partner_ID__c =:AcidDecoded limit 1];          
        System.assertEquals(AcidDecoded, ac[0].Partner_ID__c);
        DocomoOptOutEmailsCon docOpt = New DocomoOptOutEmailsCon();
        docOpt.optOutDocomoEmails();
        docOpt.Closebanner();
        
        Test.stopTest(); 
        
        
    }
    static testmethod void optOutDocomoEmailsTestElse(){
        List<Profile> profile=[select id, Name from profile where Name='DAZN Profile'limit 1 ];
        List <User> gUser=[select id,UserName from user where profileid= :profile[0].Id  AND IsActive = true limit 1];
        system.assertEquals(1,gUser.size());
        
        test.startTest();
        SingleRequestMock fakeResponse1 = new SingleRequestMock(200,'Complete',DocomoOptOutEmailsConTest.dummyRespose(false),null);    
        Test.setMock(HttpCalloutMock.class, fakeResponse1);  
        String strDocomoPartnerId = '';
        
        Test.setCurrentPageReference(new PageReference('Page.DocomoOptOutEmails'));
        System.currentPageReference().getParameters().put('ACID', strDocomoPartnerId); 
        string acid = Apexpages.currentPage().getParameters().get('ACID');
        blob decodedACID = EncodingUtil.base64Decode(acid);
        string AcidDecoded = decodedACID.toString();
        list<account> ac=  [select id, Type,PersonEmail,Secondary_Email__c,Partner_ID__c  from account where Partner_ID__c =:AcidDecoded limit 1];          
        System.assertEquals(0, ac.size());
        DocomoOptOutEmailsCon docOpt = New DocomoOptOutEmailsCon();
        docOpt.optOutDocomoEmails();
        docOpt.Closebanner();
        
        Test.stopTest(); 
        
        
    }
    static testmethod void optOutDocomoEmailsTestNeg(){
        List<Profile> profile=[select id, Name from profile where Name='DAZN Profile'limit 1 ];
        List <User> gUser=[select id,UserName from user where profileid= :profile[0].Id  AND IsActive = true limit 1];
        system.assertEquals(1,gUser.size());
        System.RunAs(gUser[0]){
            test.startTest();
            try{
                SingleRequestMock fakeResponse1 = new SingleRequestMock(200,'Complete',DocomoOptOutEmailsConTest.dummyRespose(false),null);    
                Test.setMock(HttpCalloutMock.class, fakeResponse1);  
                String strDocomoPartnerId = 'TlRHNU9UNUo1UTQ1NT';
                list<account> ac=  [select id, Type,PersonEmail,Secondary_Email__c,Partner_ID__c  from account where Partner_ID__c =:strDocomoPartnerId limit 1]; 
                Test.setCurrentPageReference(new PageReference('Page.DocomoOptOutEmails'));
                System.currentPageReference().getParameters().put('ACID',strDocomoPartnerId );            
                DocomoOptOutEmailsCon docOpt = New DocomoOptOutEmailsCon();
                docOpt.optOutDocomoEmails();
                docOpt.Closebanner();
            }catch(exception ex){
            }
            Test.stopTest();
        }
    }
    
    
    public static string dummyRespose(boolean sucessorfail ){
        string response ='';
        if(sucessorfail){
            response  = '<?xml version="1.0" encoding="UTF-8"?><methodResponse xmlns:ex="http://ws.apache.org/xmlrpc/namespaces/extensions"><params><param><value>';
            response+='<struct><member><name>errorCode</name><value><i4>0</i4></value></member><member><name>group</name><value>';       
            response+='</value></member></struct></value></param></params></methodResponse>';
            
        }
        else{ 
            
            response  = '<?xml version="1.0" encoding="UTF-8"?><methodResponse xmlns:ex="http://ws.apache.org/xmlrpc/namespaces/extensions"><params><param><value>';
            response+='<struct><member><name>errorCode</name><value><i4>0</i4></value></member><member><name>group</name><value><array><data><value><struct><member><name>magaId</name><value>MAGAID0</value></member>';       
            response+='<member><name>status</name><value><i4>0</i4></value></member> </struct></value><value><struct><member><name>magaId</name><value>MAGAID1</value></member>';
            response+='<member><name>status</name><value><i4>0</i4></value></member></struct></value></data></array></value></member></struct></value></param></params></methodResponse>';
            
        }
        return response;     
        
    }
    
    
}