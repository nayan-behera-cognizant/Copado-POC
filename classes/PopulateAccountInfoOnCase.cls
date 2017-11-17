global class PopulateAccountInfoOnCase{

    
   @InvocableMethod
   public static void UpdateCase(List<Case> lstCase) {
   
       // Collect all email ID in list.
       List<String> lstEmail = new List<String>();
       for(Case oCase: lstCase){
            
            if(String.isBlank(oCase.SuppliedEmail)){
                continue;
            }
            lstEmail.add(oCase.SuppliedEmail); 
       }
       
       List<Account> lstAccount = [SELECT Id, PersonContactId, PersonEmail FROM Account where PersonEmail in: lstEmail];
       Map<String, Account> mapAccount = new Map<String, Account>();
       for(Account oAccount : lstAccount){
           mapAccount.put(oAccount.PersonEmail, oAccount);
       }
       
       if(lstAccount.size() > 0){
      
           List<Case> lstUpdateCase = new List<Case>();
           Case oCaseCopy = null;
           for(Case oCase: lstCase){
                 oCaseCopy = new Case();
                 oCaseCopy.Id = oCase.Id;
                 oCaseCopy.AccountId= mapAccount.get(oCase.SuppliedEmail).Id;
                 oCaseCopy.ContactId = mapAccount.get(oCase.SuppliedEmail).PersonContactId;
                 lstUpdateCase.add(oCaseCopy);
           }
           update lstUpdateCase;
       }
   }
}