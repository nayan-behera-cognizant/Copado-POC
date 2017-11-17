trigger getContactTrigger on User (after insert, before Update) {
    
 /*   if(Trigger.isBefore && (Trigger.IsInsert || Trigger.IsUpdate)){
        for(User u : Trigger.new){           
            if(u.LanguageLocaleKey != null){
               u.Notification_Language_Code__c = u.LanguageLocaleKey;
            }
        }
    }
    
    if(Trigger.isAfter && (Trigger.IsInsert || Trigger.IsUpdate)){
        List<Account> lstAccount = new List<Account>();        
        Map<String, User> mapContactFields = new Map<String, User>();
        List<User> lstUser = new List<User>();
        
        for(User u : Trigger.new){           
            if(u.LanguageLocaleKey != null){
                if(Trigger.IsUpdate)
                {     
                    mapContactFields.put(u.ContactId, u);// get the contact associated with the user 
                }else{
                    mapContactFields.put(u.ContactId, u);// get the contact associated with the user 
                }
            }
        }
       
        
        for(Account acc: [Select Id, Notification_Language_Code__c, Notification_Country_Code__c, Notification_Email__c, PersonContactId from Account where (isPersonAccount = true AND PersonContactId in: mapContactFields.keySet())]){
            acc.Notification_Language_Code__c = mapContactFields.get(acc.PersonContactId).LanguageLocaleKey;
            acc.Notification_Country_Code__c = mapContactFields.get(acc.PersonContactId).CountryCode;
            acc.Notification_Email__c = mapContactFields.get(acc.PersonContactId).Email;
            lstAccount.add(acc);
        }
        
        if(!lstAccount.isEmpty()){
            update lstAccount;            
        }     
    } */        
}