global with sharing class ResetD4DAccount {
	
	webservice static String resetAccount(Id accId) {
        String result = 'unsuccess';
        List<Account>  accList = [select id ,Firstname,LastName, DAZN_Id__c,Type, Partner_ID__c, PersonEmail, Secondary_Email__c from Account where id =: accId];
        if (!accList.isEmpty()) {
        	for (Account item :accList) {
        		item.Partner_ID__c = accList[0].Id;
	        	item.Secondary_Email__c = 'resetD4DAccount@test.test';
	        	item.PersonEmail = 'resetD4DAccount' +accList[0].Id+ '@test.test';
	        	item.Firstname = 'resetAccount';
	        	item.LastName = 'resetAccount';
	        	item.DAZN_Id__c = accList[0].Id;
        	}
        	
        	update accList;
        	resetViewerIdUser(accId);
        	result = 'success';
        }      
        
        return result;
    }

    public static void resetViewerIdUser(String accId) {
    	List<User> us = [SELECT ViewerId__c, ExternalID__c FROM User WHERE AccountId = :accId LIMIT 1];
    	if (!us.isEmpty()) {
    		for (User item :us) {
    			item.ViewerId__c = null;
    		}
    		update us;
    	} 
    }
}