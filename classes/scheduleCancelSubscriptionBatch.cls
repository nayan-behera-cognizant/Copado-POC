global class scheduleCancelSubscriptionBatch implements Schedulable {
global void execute(SchedulableContext SC) {
       CancelSubscriptionBatch  NotifyBatch  = new CancelSubscriptionBatch();
       ID batchprocessid = Database.executeBatch(NotifyBatch, 1);       
   }
}