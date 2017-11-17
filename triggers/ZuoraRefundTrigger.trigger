trigger ZuoraRefundTrigger on Zuora__Refund__c (after insert) {
    //***********Changes as per PD-7866************
    if(TriggerSetting__c.getInstance('ZuoraRefundTrigger').Disable__c){
        return;
    }
    //***********Changes End***********************   
     
    RefundTriggerHandler.updateRelatedAccount(Trigger.new);
}