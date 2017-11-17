trigger SubscriptionTrigger on Zuora__Subscription__c (after insert, after update, before insert, before update) {
    
    //***********Changes as per PD-7866************
    if (TriggerSetting__c.getInstance('SubscriptionTrigger').Disable__c) {
        return;
    }
    
    if (trigger.isAfter) {
        SubscriptionTriggerHandler oSubscriptionHandler = new SubscriptionTriggerHandler();
        if (trigger.isInsert) {
            SubscriptionTriggerHandler.createWelcomeEmailSyncQueueRecords(Trigger.newMap);
            oSubscriptionHandler.UpdateSubscriptionInfoOnAccount(Trigger.new);
        }
    
        if (trigger.isUpdate) {
            oSubscriptionHandler.UpdateSubscriptionInfoOnAccount(Trigger.new);
        }
    }
    
    //start PD-12557
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        SubscriptionTriggerHandler oSubscriptionHandler = new SubscriptionTriggerHandler();
        oSubscriptionHandler.setFreeTrialEndDate(Trigger.new);
    }
    //end PD-12557
    
}