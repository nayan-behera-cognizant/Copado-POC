global class CancelSubscriptionBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{

   global final String Query;

    global CancelSubscriptionBatch()
    {
        Query='select Zuora__External_Id__c From Zuora__Subscription__c Where Zuora__Status__c = \'Active\' and Zuora__Account__r.TestUser__c=false and Zuora__Account__r.Account_Status__c=\'Frozen\' Limit 50';
    }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

    global void execute(Database.BatchableContext BC, List<Zuora__Subscription__c> lstSubscription){
        if(lstSubscription!=null && lstSubscription.size()>0)
        {
            List<String> lstSubscriptionID=new List<String>();            
            for(Zuora__Subscription__c oSubscription : lstSubscription)
            {
                lstSubscriptionID.add(oSubscription.Zuora__External_Id__c);
            }            
            String sEffectiveDate= ((DateTime)system.today()).format('yyyy-MM-dd');            
            if(!lstSubscriptionID.isEmpty())
            	ZuoraTransactionHelper.cancelSubscriptionsForTestUser(lstSubscriptionID,sEffectiveDate,false);
            }
    }

   global void finish(Database.BatchableContext BC){
   }
}