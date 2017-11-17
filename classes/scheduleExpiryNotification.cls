/*
    Description : Class to send emails to users before the Payment expiry date
    Author      : Cognizant 
*/
global class scheduleExpiryNotification implements Schedulable {
   global void execute(SchedulableContext SC) {
       BatchSendPaymentExpiryNotification  NotifyBatch  = new BatchSendPaymentExpiryNotification();
       ID batchprocessid = Database.executeBatch(NotifyBatch, 200);       
   }
}