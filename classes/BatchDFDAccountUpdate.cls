global class BatchDFDAccountUpdate implements Database.Batchable<sObject>,Database.stateful,Database.AllowsCallouts {
     
    global Database.QueryLocator start(Database.BatchableContext bc ){
          
            return Database.getQueryLocator([select Id,FirstName,LastName,DFD_First_Name__c,DFD_Last_Name__c,Type from Account where FirstName != 'DFD' and LastName !='Customer'and Type = 'Docomo']);            
       
    }
   
    global void execute(Database.BatchableContext bc, List<Account> listOfAccounts){    
        list<Account> accountsUpdateList = new list<Account>();
        for(Account acc: listOfAccounts){
            acc.DFD_First_Name__c = acc.FirstName;
            acc.DFD_Last_Name__c = acc.LastName;
            acc.FirstName ='DFD';
            acc.LastName ='Customer';
            accountsUpdateList.add(acc);
        }
        
        if(accountsUpdateList!=null && accountsUpdateList.size() >0){
            Database.update(accountsUpdateList);
        }
    }
     
    global void finish(Database.BatchableContext bc){        
                  
    }
}