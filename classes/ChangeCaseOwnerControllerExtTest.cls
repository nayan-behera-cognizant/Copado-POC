/**
*  @author Dasetti Venkata Ramaiah(Cognizant)
*  @date Aug 22, 2017
*  @description ChangeCaseOwnerControllerExtTest 
*  @Modification Log:        
------------------------------------------------------------------------------------        
Developer                Vesrsion No       Date                Description        
------------------------------------------------------------------------------------        
Dasetti Venkat Ramaiah       -           22/08/2017           Initial version created.
*/

@isTest
private class ChangeCaseOwnerControllerExtTest {
    
    @isTest 
    static void testChangeCaseOwner() {
        Case caseobj=new Case();
        caseobj.Subject='testSubject';
        caseobj.Description='testdescription';
        caseobj.Type = 'General Enquiry';
        insert caseobj;
        
        Test.startTest();
        
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        
        Case cs = [SELECT OwnerId FROM Case WHERE Id = :caseobj.Id LIMIT 1];
        Test.setCurrentPageReference(new PageReference('Page.ChangeCaseOwner'));
        System.currentPageReference().getParameters().put('id', caseobj.Id);
        ChangeCaseOwnerControllerExt ctrl = new ChangeCaseOwnerControllerExt(new ApexPages.StandardController(caseobj));
        ctrl.newCase.User_internal__c= oCSUser.id;
        ctrl.changeCaseOwner();
        ctrl.cancelAction();
        Test.stopTest();
        Case csAfter = [SELECT OwnerId FROM Case WHERE Id = :caseobj.Id LIMIT 1];
        System.assertNotEquals(cs.OwnerId, csAfter.OwnerId);
    }
    @isTest 
    static void testChangeOwnerExcept(){
        
        Case caseobj=new Case();
        caseobj.Subject='testSubject';
        caseobj.Description='testdescription';
        caseobj.Type = 'General Enquiry';
        
        insert caseobj;
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom'); 
        
        Test.startTest();
        Case cs = [SELECT OwnerId,status FROM Case WHERE Id = :caseobj.Id LIMIT 1];
        
        try{ 
            Test.setCurrentPageReference(new PageReference('Page.ChangeCaseOwner'));
            System.currentPageReference().getParameters().put('id', caseobj.Id);
            ChangeCaseOwnerControllerExt ctrl = new ChangeCaseOwnerControllerExt(new ApexPages.StandardController(caseobj));
            ctrl.newCase.User_internal__c=oUser.id;
            ctrl.changeCaseOwner();
        }catch(Exception e){}
        test.stopTest();
        Case csAfter = [SELECT OwnerId,status FROM Case WHERE Id = :caseobj.Id LIMIT 1];
         System.assertEquals(cs.status , csAfter.status );
    }
    @isTest 
    static void testChangeOwnerNeg(){
        
        Case caseobj=new Case();
        caseobj.Subject='testSubject';
        caseobj.Description='testdescription';
        caseobj.Type = 'General Enquiry';
        insert caseobj;
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User oUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true, 'United Kingdom'); 
        
        Test.startTest();
        try{ 
            Test.setCurrentPageReference(new PageReference('Page.ChangeCaseOwner'));
            System.currentPageReference().getParameters().put('id', null);
            ChangeCaseOwnerControllerExt ctrl = new ChangeCaseOwnerControllerExt(new ApexPages.StandardController(caseobj));
            ctrl.changeCaseOwner();
        }catch(Exception e){}
        test.stopTest();
    }
    
}