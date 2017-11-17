/**************************************************************************************************************************************
Trigger Name : CaseAssociationWithAccount.
Trigger Description : PD-8637 Before Case insert Association With Account only when Supplied Email is exist with any Account.
**************************************************************************************************************************************/
trigger CaseAssociationWithAccount on Case (before insert) {
    if(Trigger.isBefore && Trigger.isInsert) {
        CaseTriggerHandler.AddingAccountAndContactToCase(trigger.new);
        CaseTriggerHandler.emailToCaseLoopKiller(trigger.new);
    }
}