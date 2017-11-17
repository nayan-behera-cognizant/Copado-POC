/**
* The BatchJobStatusUtilityTest class implements improve the test coverage for BatchJobStatusUtility
* 
*
* @Author  		:Cognizant Technology Solutions
* @Base version :1.0
* @Date   		:August 23rd 2016
* ***********************Update History*****************************************
* Version		Updated By				CR #					Change Description					
*
*/
@IsTest
public class BatchJobStatusUtilityTest{
    static testMethod void BatchJobStatusUtilityTestMethod() { 
        Test.StartTest();   
        BatchJobStatusUtility batchJobUtl = new BatchJobStatusUtility();
        BatchJobStatusUtility.getNumberOfBatchJobsRunningCurrently();
        Test.stopTest(); 
    }
}