/*
Description: Trigger Handler for Mass_Email_Request__c
*/
public with sharing class MassEmailTriggerRequestHandler {
	
	//Description: Checking new Mass Email Request
	public static void checkingMassEmailRequest(List<Mass_Email_Request__c> massEmailRequests) {
		String result;
		for (Mass_Email_Request__c item : massEmailRequests) {
			if (MassEmailHelper.checkMassEmailRequestForUser()) {
		        item.addError(Label.ME_Only_one_Mass_Email_equest);
		        break;
		    }
		    if (item.Status__c != 'Draft') {
	    		item.addError(Label.ME_cannot_modify_Status);
	    		break;
	    	}
		}
	}
	
}