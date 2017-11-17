/**
 * @Author Cognizant Technology Solutuions
 * @Date 10-Oct-2017
 * @Description : This class contains the Global method related to Gift Code Functionality 
*/
public class GiftCodeHelper {
    
    public static User user ;
    public static Boolean showRedeemLinkFlag ;
    public static Boolean showAddPaymentFlag;
    public static PageReference ref;
    public static Boolean isGiftCodeAvailable;
    public static String sCountry ;

    public Static List<Zuora__CustomerAccount__c> lstCustomerAccount;
    
    
    /**
     * @Author Cognizant Technology Solutuions
     * @Date 10-Oct-2017
     * @Description : This method is used to check if user country is available for Gift code
     * @Parameter1 : user 
    */
    public Static Boolean checkGiftCodeAvailable( User usr ){
    sCountry  = usr.CountryCode;
  
    
    Map<String, CountryListForGiftCode__c> showGiftCodeMap= CountryListForGiftCode__c.getAll();        
   
    if (showGiftCodeMap.containsKey(sCountry) ) {
            
       isGiftCodeAvailable = CountryListForGiftCode__c.getValues(sCountry).IsGiftCodeAvailable__c;
  
    }
     return isGiftCodeAvailable ;
  }  
 
    
    /**
     * @Author Cognizant Technology Solutuions
     * @Date 10-Oct-2017
     * @Description : This method is used to check the if Add Payment link should be visible or not 
     * @Parameter1 :  Subscription and Billing Account Object 
    */
    public Static Boolean checkPaymentMethod( Zuora__Subscription__c zsubs , Zuora__CustomerAccount__c billAcc) {
        showAddPaymentFlag = false;
        User user = CommunityHelper.getCurrentUser(); 
        if ( zsubs != null  && billAcc!= null &&  !CommunityHelper.IsDfDUser() && !CommunityHelper.isAppleUser() ){
            if ( String.isBlank(billAcc.Zuora__Default_Payment_Method__c) && billAcc.Zuora__Default_Payment_Method__c == null && !billAcc.Zuora__AutoPay__c && String.isNotBlank(zsubs.NumGiftPeriods__c) && Integer.valueOf(zsubs.NumGiftPeriods__c) > 0){
                showAddPaymentFlag = true;
            }
        }  
        return showAddPaymentFlag ;
    }
    
    
   
    /**
     * @Author Cognizant Technology Solutuions
     * @Date 10-Oct-2017
     * @Description : This method is used to check the if Add Gift code link should be visible or not 
     * @Parameter1 : accountId 
    */
    public Static Boolean checkRedeemLinkCriteria(Account acc , User user ) {
       Boolean showRedeemLinkFlag = false; 
      isGiftCodeAvailable =checkGiftCodeAvailable(user);
       
      if (isGiftCodeAvailable  != null ){
        if (  isGiftCodeAvailable  && acc!= null && !acc.Submitted_for_cancellation__c  && !acc.PauseScheduled__c && !acc.Cancelled_Account__c&&  (acc.Account_Status__c == 'Active Paid' || acc.Account_Status__c == 'Active Grace' || acc.Account_Status__c == 'Free Trial') ){
            showRedeemLinkFlag = true;
        }
        }
        else {
            showRedeemLinkFlag = false;
        }
        return showRedeemLinkFlag ;
    }
    
    /**
     * @Author Cognizant Technology Solutuions
     * @Date 10-Oct-2017
     * @Description : This method is used to Navigate to Redeem URL page
     * @Parameter1 :
    */
    public static PageReference redeemGiftCode() {
        
        String redeemUrl = (DAZNConfiguration__c.getValues('RedeemGiftCode') != null) ? DAZNConfiguration__c.getValues('RedeemGiftCode').Value__c : null;
        if (String.isNotBlank(redeemUrl)) {
            ref = new PageReference(redeemUrl);
            ref.setRedirect(true); 
        }
        return ref;
    }
    
        public Static Boolean checkRedeemLinkCriteria(User user ) {
        Boolean showRedeemLinkFlag = false;
        List<Account> lstAcc = [Select Id, Account_Status__c, Cancelled_Account__c , Notification_Country_Code__c, Submitted_for_cancellation__c , PauseScheduled__c FROM Account WHERE ID =:user.AccountId limit 1];
        
         isGiftCodeAvailable =checkGiftCodeAvailable(user);
        
        if (isGiftCodeAvailable  != null ){
        if (isGiftCodeAvailable  && lstAcc != null && !lstAcc.isEmpty()  && !lstAcc[0].Submitted_for_cancellation__c  && !lstAcc[0].PauseScheduled__c && !lstAcc[0].Cancelled_Account__c&&  (lstAcc[0].Account_Status__c == 'Active Paid' || lstAcc[0].Account_Status__c == 'Active Grace' || lstAcc[0].Account_Status__c == 'Free Trial') ){
            showRedeemLinkFlag = true;
        }
        }
        else {
            showRedeemLinkFlag = false;
        }
        return showRedeemLinkFlag ;
    }


    /**
     * @Author Cognizant Technology Solutuions
     * @Date 10-Oct-2017
     * @Description : This method is used to get the actual gift code end date
     * @Parameter1 : accountId : Id of person account for which gift code will be searched
    */
    public static Date getLatesGiftCodeEndDate(String accountId) {

        isGiftCodeAvailable = checkGiftCodeAvailable(CommunityHelper.getCurrentUser());
        if (isGiftCodeAvailable == null || !isGiftCodeAvailable) {
            return null;
        }
        
        List<Zuora__Subscription__c> sub = [Select Id, Gift_Code_End_Date__c
            From Zuora__Subscription__c
            Where Zuora__Account__c = :accountId
                AND (Zuora__Status__c = 'Active'OR (Zuora__Status__c = 'Cancelled' AND Zuora__SubscriptionEndDate__c > TODAY))
                AND Gift_Code_End_Date__c != null Order By Gift_Code_End_Date__c DESC LIMIT 1];

        List<Gift_Code_History__c> gch = [Select Id, Gift_Code_End_Date__c
            From Gift_Code_History__c
            Where Account__c = :accountId AND Gift_Code_End_Date__c != null Order By Gift_Code_End_Date__c DESC LIMIT 1];

        Date latesGiftCodeEndDate;

        if ((sub != null && !sub.isEmpty()) && (gch != null && !gch.isEmpty())) {
            latesGiftCodeEndDate = (sub[0].Gift_Code_End_Date__c > gch[0].Gift_Code_End_Date__c) ? sub[0].Gift_Code_End_Date__c : gch[0].Gift_Code_End_Date__c;
        } else if (sub != null && !sub.isEmpty()) {
            latesGiftCodeEndDate = sub[0].Gift_Code_End_Date__c;
        }  else if (gch != null && !gch.isEmpty()) {
            latesGiftCodeEndDate = gch[0].Gift_Code_End_Date__c;
        }

        return latesGiftCodeEndDate;
    }

    /**
     * @Author Cognizant Technology Solutuions
     * @Date 10-Oct-2017
     * @Description : This method is used to determine if gift code will expire soon or not
     * @Parameter1 : accountId : Id of person account for which gift code will be searched
    */
    public static Boolean isGiftCodeEndDateExpire(String accountId) {
        Date giftCodeEndDate = getLatesGiftCodeEndDate(accountId);
        return (giftCodeEndDate != null) && (giftCodeEndDate <= (Date.today() + 14));
    }
    
    /**
     * @Author Cognizant Technology Solutuions
     * @Date 11-Oct-2017
     * @Description : This method is used to pull information related to Gif Codes
     * @Parameter1 : accountId : Id of person account for which gift code will be searched
    */
    public Static Zuora__Subscription__c getSubscriptionWithGigtInfo(String accountId) {
         Zuora__Subscription__c subscriptionWithGiftInfo;
         List<Zuora__Subscription__c> subscriptions = [
            SELECT Id,
                CampaignID__c,
                Free_Trial_End_Date__c,
                Gift_Code_End_Date__c,
                Gift_Code_Start_Date__c,
                Giftcode__c,
                Gift_Code_Status__c,
                NumFreeTrialPeriods__c,
                NumGiftPeriods__c
            FROM Zuora__Subscription__c
            WHERE Zuora__Account__c =: accountId
                AND (Zuora__Status__c = 'Active' OR (Zuora__Status__c = 'Cancelled' AND Zuora__SubscriptionEndDate__c > TODAY ))
            ORDER BY Zuora__SubscriptionStartDate__c DESC NULLS LAST LIMIT 1
        ];
        if (!subscriptions.isEmpty()) {
            subscriptionWithGiftInfo = subscriptions[0];
        }
        return subscriptionWithGiftInfo;
    }
    
}