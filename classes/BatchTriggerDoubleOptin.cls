global class BatchTriggerDoubleOptin implements Database.Batchable<sObject>, Database.AllowsCallouts{
    String sQuery;
    global Database.QueryLocator start(Database.BatchableContext bc){
      /*  sQuery = 'SELECT Id,Secondary_Email__c,PersonEmail,FirstName,LastName,Account_Status__c,Is_Double_OptIn__c,Partner_ID__c,Type,Notification_Language_Code__c,Notification_Country_Code__c,Hard_Offer_date__c,';
        sQuery += 'All_Email_Preferences__c,IsReadyToSyncInCommunicator__c FROM Account ';  
        sQuery += 'WHERE All_Email_Preferences__c=True AND IsReadyToSyncInCommunicator__c = true AND Type != \'Docomo\' AND Notification_Country_Code__c = \'DE\' AND Account_Status__c=\'Partial\'';  
		*/
        return Database.getQueryLocator(sQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        /*List<Account> deenAccounts = new List<Account>();
        List<Account> dedeAccounts = new List<Account>();
        Map<String,List<Account>> mapAccounts = new Map<String,List<Account>>();
        
        if(!Test.isRunningTest()){
            for(Account acc : scope){
                if(acc.Notification_Language_Code__c == 'de')
                    dedeAccounts.add(acc);
                else if(acc.Notification_Language_Code__c == 'en_GB')
                    deenAccounts.add(acc);
            }
            
          if(!deenAccounts.isEmpty())  
            mapAccounts.put('DE_en_GB',deenAccounts)  ;
            if(!dedeAccounts.isEmpty())
            mapAccounts.put('DE_de',dedeAccounts)  ;
            
          //CommunicatorIntegrationHelper.sendDoubleOptInEmail(mapAccounts);
        }*/
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}