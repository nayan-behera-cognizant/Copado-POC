trigger DAZNUserFeedTrigger on DAZNUserFeed__c (after insert) {
    	if(trigger.isInsert && trigger.isAfter){    	
        	DFDUserFeedHandler.prepareAccountsToInsert(trigger.new);
        }
}