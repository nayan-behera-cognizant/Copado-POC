/**
 * @Author Cognizant Technology Solutuions
 * @Date 16-Oct-2017
 * @Description : This class is used to update Account Status to Active Paid for those Accounts whose subscriptions have TODAY >= Gift_Code_Start_Date__c
*/
public class ScheduledUpdateAccountStatus implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        List<Zuora__Subscription__c> subscriptions = [
            SELECT Id, Zuora__Account__c, NumGiftPeriods__c
            FROM Zuora__Subscription__c
            WHERE Gift_Code_Start_Date__c <= TODAY
                AND Zuora__Account__r.Account_Status__c != 'Active Paid'
                AND NumGiftPeriods__c != NULL
            LIMIT 10000
        ];
        
        Set<Id> accountIds = new Set<Id>();
        for (Zuora__Subscription__c sub : subscriptions) {
            if (String.isNotBlank(sub.NumGiftPeriods__c) && Integer.valueOf(sub.NumGiftPeriods__c) > 0) {
                accountIds.add(sub.Zuora__Account__c);
            }
        }
        
        List<Account> accounts = [
            SELECT Id, Account_Status__c
            FROM Account
            WHERE Id IN : accountIds
        ];
        for (Account acc : accounts) {
            acc.Account_Status__c = 'Active Paid';
        }
        update accounts;
    }
    
}