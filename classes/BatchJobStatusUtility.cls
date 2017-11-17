/**
* The BatchJobStatusUtility class implements all necessary logic to find details of the Batch jobs 
* currently running in the system
* 
*
* @Author  		:Cognizant Technology Solutions
* @Base version :1.0
* @Date   		:August 23rd 2016
* ***********************Update History*****************************************
* Version		Updated By				CR #					Change Description					
*
*/
public class BatchJobStatusUtility {
    /**
     * getDeviceSettingsData - Method to Initialize Device Settings Data
     * 
     * > Used to Fetch Custom settings data - DeviceSettings__c
     * > To Fetch the number of user devices allowed in a specific country
     * > And overall minimum number of devices
     * 
     * @Param 1 - no params required - Initialising Data
     * 
     * @return -  Void - no return applicable
     * */
    public static Integer getNumberOfBatchJobsRunningCurrently(){
        Integer cnt;
        cnt = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Processing' or Status = 'Preparing' )];
        return cnt;
    }

}