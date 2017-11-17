/**
* @author Cognizant Technology Solutuions
* @date 11/05/2016
* @description refundTriggerHandler class.
* Update the related account's status as 'Frozen'.
*/
public class RefundTriggerHandler{
    public static void updateRelatedAccount(list<Zuora__Refund__c> allRefundRecords){
    list<Account> accRefList = new list<Account>();
    list<Account> updateAccRefList = new list<Account>();
    Map<Id,Account> accRefIds = new Map<Id,Account>();
    Map<Id, Zuora__Refund__c> mapZuoraRef = new Map<Id, Zuora__Refund__c>();
    for(Zuora__Refund__c  zurRef : allRefundRecords){
        if(zurRef.Zuora__Type__c =='External'  && (zurRef.Zuora__ReasonCodeName__c == 'Payment Reversal' || zurRef.Zuora__ReasonCodeName__c == 'Payment Rejection')){        
            mapZuoraRef.put( zurRef.Zuora__Account__c, zurRef );       
            }
        }
    accRefList = [SELECT id,Account_Status__c From Account where id IN: mapZuoraRef.keySet()];
    if(accRefList != null && !accRefList.isEmpty()){
        for(Account acc :accRefList ){
            accRefIds.put (acc.id,acc);     
            }
        List<Zuora__Subscription__c> lstSubscription = [Select Id, Zuora__Account__c,Zuora__Status__c,Zuora__Account__r.TestUser__c,Zuora__Account__r.Account_Status__c  from Zuora__Subscription__c where Zuora__Account__c IN: accRefIds.keySet() AND Zuora__Status__c = 'Active'];
        if(!lstSubscription.isEmpty() && lstSubscription!= null){
            for(Account acc :accRefIds.values()){
                acc.Account_Status__c= 'Frozen'; 
                updateAccRefList.add(acc);
                } 
            }
            update updateAccRefList;
        }
    }
}