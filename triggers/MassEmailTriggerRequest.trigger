trigger MassEmailTriggerRequest on Mass_Email_Request__c (before insert) {
    
    if (Trigger.isBefore && Trigger.isInsert) {
        MassEmailTriggerRequestHandler.checkingMassEmailRequest(Trigger.new);
    }
}