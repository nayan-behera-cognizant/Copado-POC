/**
* The scheduledBatchForInactiveDevicesEmail class implements schedule the batch calss 'BatchForInactiveDevicesEmail' daily
* 
*
* @Author  		:Cognizant Technology Solutions
* @Base version :1.0
* @Date   		:August 23rd 2016
* ***********************Update History*****************************************
* Version		Updated By				CR #					Change Description					
*
*/
global class ScheduledBatchForInactiveDevicesEmail implements Schedulable {  
    
    /**
     * execute - for the schedulable class ScheduledBatchForInactiveDevicesEmail
     * 
     * > get number of batch jobs currently running in the syatem.
     * > if more than 4 jobs running then do not execute the batch and send the notification email to admin.
     * > if not excute the batch job
     * 
     * @Param 1 - SchedulableContext SC
     * 
     * @return -  Void - no return applicable
     * */
    global void execute(SchedulableContext sc) { 
        Integer cnt = BatchJobStatusUtility.getNumberOfBatchJobsRunningCurrently();
        if(cnt != null && cnt > 4 ){ 
            SendEmailWithErrorsToAdmins.sendEmail('scheduledBatchForInactiveDevicesEmail is Unscheduled due to more than 4 running jobs');
        } //end of if - null check 
        else{
            BatchForInactiveDevicesEmail bid = new BatchForInactiveDevicesEmail();
            Database.executeBatch(bid);   
        } //end of else - null check       
    }         
}