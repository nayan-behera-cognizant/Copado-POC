public class NextChargeDateSectionController {
    
    public String nextChargeDateString { get; set; }
    
    public NextChargeDateSectionController(ApexPages.StandardController controller) {
        Account acc = [Select Id, Pause_Until__c, Account_Status__c, PauseScheduled__c From Account Where Id = :controller.getRecord().Id];
        DateTime nextChargeDate = ZuoraTransactionHelper.getRatePlanChargeChargedThroughDateByAccountId(acc.Id);
        if (acc.Account_Status__c.equalsIgnoreCase('Paused') || acc.PauseScheduled__c) {
        	nextChargeDate = acc.Pause_Until__c;
        }
        nextChargeDateString = (nextChargeDate != null) ? nextChargeDate.format('dd/MM/yyyy') : null;
    }
    
}