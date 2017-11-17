global class AnonymizerAccount implements Database.Batchable<sObject> {
	
	private String query;
	private String strEnvName;
	
	global AnonymizerAccount(String emailPattern) {
		this.query = 'Select Id, All_Email_Preferences__c, PersonEmail, Account_Status__c, FirstName, LastName From Account Where PersonEmail LIKE \'%' + String.escapeSingleQuotes(emailPattern) + '\'';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		Map<Id, User> usersForAccounts = new Map<Id, User>();
   		for (User u : [Select Id, FirstName, LastName, Username, Email, AccountId From User Where AccountId IN :scope]) {
   			usersForAccounts.put(u.AccountId, u);
   		}

   		List<Account> accountsForDeactivate = new List<Account>();
	    Account accountForDeactivate;
	    User userForAccount;
	    
	    for (sObject accountObj : scope) {
	    	accountForDeactivate = (Account)accountObj;
	    	userForAccount = usersForAccounts.get(accountForDeactivate.Id);
	    	if (userForAccount != null) {
	    		accountForDeactivate.All_Email_Preferences__c = false;
                accountForDeactivate.PersonEmail = userForAccount.Email;
                accountForDeactivate.Account_Status__c = 'Expired';
                accountForDeactivate.FirstName = userForAccount.FirstName;
                accountForDeactivate.LastName = userForAccount.LastName;

                accountsForDeactivate.add(accountForDeactivate);
	    	}
	    }
	    update accountsForDeactivate;	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}