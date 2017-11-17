/**
* @author Cognizant Technology Solutuions
* @date 04/11/2015
* @description User Subscrition information helper
*/
public without sharing class UserSubscriptionHelper {

    public User oUser {get;set;}
    public String subscriptionType {get;set;}
    public Boolean showCancelSubscription {get;set;}
    public Boolean showResubscribe {get; set;}
    public Zuora__Subscription__c subscription {get; set;} 
    public Boolean bFreeTrialMember{get;set;}
    
    /*
        Method to get the user subscription information.
    */
    public void getUserSubscription()
    {
        if(oUser == null){
            oUser = CommunityHelper.getCurrentUser();
        }
        
        bFreeTrialMember = false;
        
        string accountId = oUser.AccountId;/*Changes made for PD-7931*/
        
        if(accountId  != null && accountId  != '')
        {
            accountId = String.escapeSingleQuotes(accountId);/*Changes made for PD-7931*/
            List<Account> lstAccount=[select ID, (Select Zuora__Status__c,Zuora__NextRenewalDate__c,Zuora__SubscriptionEndDate__c,
                                                         Id,Zuora__External_Id__c, Zuora__NextChargeDate__c 
                                                  From Zuora__Subscriptions__r 
                                                  Order By Zuora__SubscriptionStartDate__c DESC NULLS LAST),
                                                  (Select ID,Name,Zuora__Status__c From Zuora__Payments__r)
                                      FROM Account 
                                      Where ID=:accountId];/*Changes made for PD-7931*/
                                      
            if(lstAccount != NULL && !lstAccount.isEmpty()){
                                      
                List<Zuora__Subscription__c> lstSubscription=lstAccount[0].Zuora__Subscriptions__r;
                List<Zuora__Payment__c> lstPayment=lstAccount[0].Zuora__Payments__r;
                   
                if(lstPayment==NULL || lstPayment.size()==0)
                {
                    if(lstSubscription!=null&& !lstSubscription.isEmpty()){
                        subscription=lstSubscription[0];            
                        if(lstSubscription[0].Zuora__Status__c.equalsIgnoreCase('Active')){
                            subscriptionType=Label.LS_MyAccount_InfoMsg_SubscriptionFreeSubscribed;                
                            showCancelSubscription=true;
                        }
                        else if(lstSubscription[0].Zuora__Status__c.equalsIgnoreCase('Cancelled')){
                            subscriptionType= Label.LS_MyAccount_InfoMsg_SubscriptionFreeUnsubscribed;
                        }
                        bFreeTrialMember=true;
                    }
                }
                else if(lstPayment!=NULL || lstPayment.size()>0)
                {
                    if(lstSubscription!=null && !lstSubscription.isEmpty()){
                        subscription=lstSubscription[0];
                        if(lstSubscription[0].Zuora__Status__c.equalsIgnoreCase('Active')){                
                            Date today=Date.today();
                            Date renewalDate=lstSubscription[0].Zuora__NextChargeDate__c;
                            
                            if(renewalDate != null && today>renewalDate && today<=renewalDate.addDays(2)){
                                if(!(lstPayment[0].Zuora__Status__c.Equals('Processed'))){
                                    subscriptionType=Label.LS_MyAccount_InfoMsg_SubscriptionGrace;                   
                                    showResubscribe=true;
                                }
                            }else{   
                                subscriptionType=Label.LS_MyAccount_InfoMsg_SubscriptionPaidSubscribed;                                  
                                showCancelSubscription=true;
                            }
                        }else if(lstSubscription[0].Zuora__Status__c.equalsIgnoreCase('Cancelled')){
                            subscriptionType=Label.LS_MyAccount_InfoMsg_SubscriptionPaidCancelled;                
                        }
                    }
                }
            }
        }
    }
}