/* This test class will cover the code coverage for PopulateAccountInfoOnCase*/
@isTest
public class PopulateAccountInfoOnCaseTest {
    
    public static testMethod void webToCase_1() {
        SetUpTestData.triggerSettings();
        Set<Id> caseId = new Set<Id>(); 
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','testemail@email.com','Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.id, 'testemail@email.com', 'testusername@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFName','TestLName',true);
        
        Case oCase = SetUpTestData.testCreateCase();
        oCase.SuppliedEmail = 'testemail@email.com';
        update ocase;
        
        List<Case> oCaseList = new List<Case>();
        oCaseList.add(ocase);
        update oCaseList;
        for(Case c :oCaseList)
        {
            caseId.add(c.id);
        }
        Test.startTest();
            PopulateAccountInfoOnCase.UpdateCase(oCaseList);
            List<Case> caseLst = [select AccountId,ContactId from Case where id IN :caseId ];
            system.assertNotEquals(null,caseLst[0].ContactId);
            system.assertNotEquals(null,caseLst[0].AccountId);
            system.assertEquals(oAccount.id,caseLst[0].AccountId);
        Test.stopTest();
        
    }
    
}