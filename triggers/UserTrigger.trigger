trigger UserTrigger on User (before update, after update) {
   
    //***********Changes as per PD-7866************
    if(TriggerSetting__c.getInstance('UserTrigger') == null || TriggerSetting__c.getInstance('UserTrigger').Disable__c){
        return;
    }
    //***********Changes End***********************
    
    if(Trigger.isBefore && Trigger.isUpdate){ // Added code part of the PD-10362
         
            
                // method assigns the user language          
                //logic for capturing old email address
               UserTriggerHandler.sendUpdateToOldEmail(Trigger.oldMap, Trigger.newMap);
             
        
    }  
     //Commented as part of PD-11813
   /*if(Trigger.isAfter && Trigger.isUpdate && !System.isFuture() && !System.isBatch()){                   
        UserTriggerHandler.updateAccount(Trigger.newMap.keySet());  
       
    }*/

        

}