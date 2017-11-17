global class SetAccountDisableAllTransactionalEmails implements Database.Batchable<sObject> {
    
    String query;
    
    global SetAccountDisableAllTransactionalEmails() {
        this.query = 'Select Id, Type, Disable_all_transactional_emails__c From Account Where Type = \'Do not contact\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        for (Account acc : (List<Account>)scope) {
            acc.Disable_all_transactional_emails__c = true;
            acc.Type = null;
        }
        update scope;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}