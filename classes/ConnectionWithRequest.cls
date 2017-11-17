global class ConnectionWithRequest implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Notification_Language_Code__c, SuppliedEmail, AccountId FROM Case LIMIT 10000';

		return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Case> scope) {
        List<Mass_Email_Request_Detail__c> massEmailDetails = new List<Mass_Email_Request_Detail__c>();
        for (Case item: scope) {
            Mass_Email_Request_Detail__c massEmailDetail = new Mass_Email_Request_Detail__c();
			if (!String.isBlank(item.AccountId) || !String.isBlank(item.SuppliedEmail)) {
				massEmailDetail.Account__c = item.AccountId;
				massEmailDetail.Case__c = item.Id;
				massEmailDetail.Email__c =  item.SuppliedEmail;
				if (String.isBlank(item.Notification_Language_Code__c) || item.Notification_Language_Code__c == 'Unknown') {
					massEmailDetail.Language__c = 'en';
				} else {
					massEmailDetail.Language__c = item.Notification_Language_Code__c.toLowerCase();
				}
				massEmailDetail.Mass_Email_Request__c = 'a229E0000001ujv';
				massEmailDetails.add(massEmailDetail);
			}
        }
        insert massEmailDetails;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}