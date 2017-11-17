global class AnonymizerUser implements Database.Batchable<sObject> {
    
    private String query;
    private String emailPattern;
    private String strEnvName;
    private DAZNConfiguration__c oDAZNConfiguration;
    
    global AnonymizerUser(String emailPattern) {
        this.emailPattern = emailPattern;
        oDAZNConfiguration = DAZNConfiguration__c.getValues('EnviornmentName');
        strEnvName = oDAZNConfiguration.Value__c;
        this.query = 'Select Id, FirstName, LastName, Username, Email From User Where IsActive = true AND Email LIKE \'%' + String.escapeSingleQuotes(emailPattern) + '\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<User> usersForDeactivate = new List<User>();
        User userForDeactivate;
        for (sObject userObj : scope) {
            userForDeactivate = (User)userObj;

            userForDeactivate.FirstName = 'anonymous[' + strEnvName + ']' + userForDeactivate.Id;
            userForDeactivate.LastName = 'anonymous[' + strEnvName + ']' + userForDeactivate.Id;
            userForDeactivate.Username = 'anonymous[' + strEnvName + ']' + userForDeactivate.Id + '@livesport.com';
            userForDeactivate.Email = 'anonymous' + strEnvName + userForDeactivate.Id + '@livesport.com';
            userForDeactivate.isActive = false;
            usersForDeactivate.add(userForDeactivate);
        }
        update usersForDeactivate;
    }
    
    global void finish(Database.BatchableContext BC) {
        AnonymizerAccount AnonymizerAccount = new AnonymizerAccount(emailPattern);
        if (!Test.isRunningTest()) {
            Database.executeBatch(anonymizerAccount, 1000);
        }
    }
    
}