/**
* @author Cognizant Technology Solutuions
* @date 13/02/2017
* @description class to schedule docomoDailyBatchToUpdPartnerRdytoSync.
*/
global class scheduledocomoBatchToUpdPartnerRdytoSync implements Schedulable {
   global void execute(SchedulableContext SC) {
       docomoDailyBatchToUpdPartnerRdytoSync DocomoBatch  = new docomoDailyBatchToUpdPartnerRdytoSync();
       ID batchprocessid = Database.executeBatch(DocomoBatch , 1000);       
   }
}