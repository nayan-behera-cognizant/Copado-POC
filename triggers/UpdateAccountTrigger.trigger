/*Trigger to populate the Account related information(Firstname, lastName, Email) On User from Account*/

trigger UpdateAccountTrigger on Account(before update, after update) {  
    
        List<Id> listAccountFrozen = new List<Id>(); //PD-8834  
        //***********Changes as per PD-7866************
    
        if(TriggerSetting__c.getInstance('UpdateAccountTrigger').Disable__c){
            return;
        }
        //***********Changes End*********************** 
        
        if(Trigger.isBefore && Trigger.isUpdate){ // Added code part of the PD-10362
            List<Account> accountToPopulateParameterLst = new List<Account>(); //PD-11145 Populate Reset PWD parameters on Account
            List<Account> listFrozenAccount = new List<Account>();
            //Commented as a Part of PD-15912 , To remove Diff Layout for Blocked and Unlocked Account 
            //UpdateAccountTriggerHandler.toRemoveWorkflowUpdatesOnAcccount(Trigger.new);//Added code as part of the PD-10362
          
            //commented as part of PD-13612
            //UpdateAccountTriggerHandler.checkIfEmailAlreadyExists(Trigger.new);
            //added as part of PD-13612
            UpdateAccountTriggerHandler.populateUniqueEmail(Trigger.new);

            UpdateAccountTriggerHandler.setAccountForSyncWithZuora(Trigger.oldMap, Trigger.newMap);
            //PD-8706 Send Welcome Back email via Communicator
            List<Account> accountList = new List<Account>();
            List<Account> accountFreeTrialStartDateUpdateList = new List<Account>();
            for (Account acc: trigger.new) {
                if (acc.Account_Status__c == 'Active Paid' && trigger.oldMap.get(acc.id).Account_Status__c == 'Frozen') {
                    accountList.add(acc);
                }
                if (acc.Account_Status__c == 'Free Trial' && trigger.oldMap.get(acc.id).Account_Status__c == 'Partial') { // For PD-11936
                    accountFreeTrialStartDateUpdateList.add(acc);
                }
                
                /*Added as a part of PD-11487*/
                if (trigger.oldMap.get(acc.id).Account_Status__c != acc.Account_Status__c && acc.Account_Status__c == 'Frozen') {
                    listFrozenAccount.add(acc);
                } //End of PD-11487

                // Added as a part of PD-13382
                if (acc.Account_Status__c != trigger.oldMap.get(acc.id).Account_Status__c) {
                    acc.Previous_Status__c = trigger.oldMap.get(acc.id).Account_Status__c;
                    acc.Status_Change_Date__c = dateTime.Now();
                }//End of PD-13382
                
            }
            if (accountList != null && accountList.size() > 0) {
                UpdateAccountTriggerHandler.accountStatusFrozentoActivepaidUpdate(accountList);
            }
            if (accountFreeTrialStartDateUpdateList != null && accountFreeTrialStartDateUpdateList.size() > 0) { // For PD-11936
                UpdateAccountTriggerHandler.accountFreeTrialStartDateUpdate(accountFreeTrialStartDateUpdateList);
            }
            //End PD-8706 Send Welcome Back email via Communicator
            
            /*Added as a part of PD-11487*/
            if(listFrozenAccount != null && listFrozenAccount.size() > 0){
                UpdateAccountTriggerHandler.authKeyUpdate(listFrozenAccount);
            } //End of PD-11487
            
        }




        if (Trigger.isAfter && Trigger.isUpdate) {
                //PD-8706 Send Welcome Back email via Communicator
                if (CommunityHelper.firstRun) {
                    List<String> listAccountIds = new List<String>();
                    for (Account acc : trigger.new) {
                        Boolean isDisableSend = acc.Disable_Hard_offer_emails__c || acc.Disable_transactional_emails__c; // For PD-8928 and PD-11577
                        if (acc.Account_Status__c == 'Active Paid' && trigger.oldMap.get(acc.id).Account_Status__c == 'Frozen' && !isDisableSend) {
                            listAccountIds.add(acc.Id);
                        }
                    }
                    if (listAccountIds != null && listAccountIds.size() > 0) {
                        UpdateAccountTriggerHandler.createHardOfferWelcomeEmailQueueRecords(listAccountIds);
                        CommunityHelper.firstRun = false;
                    }
                }
                //End PD-8706 Send Welcome Back email via Communicator
                
                //PD-8834 Sign out of all devices on Docomo Cancellation
                if (CommunityHelper.firstRun) {
                    for (Account acc : Trigger.New) {
                       Account oldAccount = Trigger.oldMap.get(acc.ID);
                        //Below condition is changed as per the PD-11487, Removed DoCoMo. 
                        if (oldAccount.Account_Status__c != acc.Account_Status__c && acc.Account_Status__c == 'Frozen') {
                            listAccountFrozen.add(acc.id);
                        }
                    }
                    if (!System.isFuture() && !System.isBatch() && listAccountFrozen != null && listAccountFrozen.size() > 0) {
                        UpdateAccountTriggerHandler.deleteUseDevicesWhenStatusFrozen(listAccountFrozen);
                    }
                }
               //End 8834
                UpdateAccountTriggerHandler.setAccountAfterUpdate(trigger.oldMap, trigger.newMap);
                UpdateAccountTriggerHandler.createEmailSyncQueueRecords(trigger.oldMap, trigger.newMap);
             
        }
    //}
}