public with sharing class FinalCancellationConfirmationController {    
    
    public User oUser {get;set;}
    public Zuora__Subscription__c oSubscription {get;set;}
    public String sCancelSubscriptionMsg {get;set;}
    public String urlHomePage {get;set;}
    public Boolean bFreeOrPaidMember {get;set;}

    public FinalCancellationConfirmationController(){ 
        if(oUser==null){
            oUser = CommunityHelper.getCurrentUser();
        }
        List<Account> lstAccount=CommunityHelper.getUserSubscription(oUser);
        if(lstAccount != NULL && !lstAccount.isEmpty()){
            List<Zuora__Subscription__c> lstSubscription=lstAccount[0].Zuora__Subscriptions__r;
            if(lstSubscription!=null && !lstSubscription.isEmpty()){
                oSubscription=lstSubscription[0];
            }
        }
        sCancelSubscriptionMsg = CommunityHelper.getSubscriptionDescription(Label.LS_FinalConfirmation_Label_Subscription_End_date,oSubscription);
    }
    
    public void cancelSubscription(){
    }
    
    public PageReference redirectToMyAccountPage() {
    
        try {
             
            PageReference oMyAcc= new PageReference('/apex/MyAccount?cancelButtonclick=true');
            oMyAcc.setRedirect(true);
            return oMyAcc;
            } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error opening new page'));
            return null;
        }
        return null;
    }
    
    public PageReference redirectToHomePage(){
        DAZNConfiguration__c oDAZNConfig = DAZNConfiguration__c.getValues('HomePageURL');
        urlHomePage = oDAZNConfig.Value__c;
       
        PageReference reference=new PageReference(urlHomePage);
        reference.setRedirect(true);
        return reference;
    }
}