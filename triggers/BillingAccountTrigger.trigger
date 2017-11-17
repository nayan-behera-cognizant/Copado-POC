/*Trigger to populate the payment related information On Account from Billing Account*/

trigger BillingAccountTrigger on Zuora__CustomerAccount__c (after Insert, after Update) {

    //***********Changes as per PD-7866************
   /* if (TriggerSetting__c.getInstance('BillingAccountTrigger').Disable__c) 
        return;
    }*/
    //***********Changes End***********************
    
    if (Trigger.isAfter) {
        BillingAccountTriggerHandler.populateBillingAccountInfoOnAccount(Trigger.new, Trigger.isInsert);
    }
    
}