@isTest 
public class CaseFeedbakRatingControllerTest{
    static testMethod void caseRatingServed() {                     
        Case testCaseInsert =SetUpTestData.createCaseForTest('General Enquiry', 'Login Issue', '', 'test'); 
        System.assertNotEquals(null, testCaseInsert.id);
        Test.setCurrentPageReference(new PageReference('Page.CaseFeedbackRatingPage')); 
        System.currentPageReference().getParameters().put('y', testCaseInsert.id); 
        ApexPages.StandardController sc = new ApexPages.StandardController(testCaseInsert);
        CaseFeedbakRatingController caseFeedBack = new CaseFeedbakRatingController(sc);
        caseFeedBack.served();
    }
}