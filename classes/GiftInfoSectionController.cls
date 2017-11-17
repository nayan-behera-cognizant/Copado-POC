public class GiftInfoSectionController {
    
    public GiftInfo giftInfo { get; set; }
    
    public GiftInfoSectionController(ApexPages.StandardController controller) {
        Zuora__Subscription__c subscription = GiftCodeHelper.getSubscriptionWithGigtInfo(controller.getRecord().id);
        if (subscription != null) {
            giftInfo = new GiftInfo(
                subscription.Giftcode__c,
                subscription.Gift_Code_Start_Date__c,
                subscription.CampaignID__c,
                subscription.Gift_Code_End_Date__c,
                subscription.Gift_Code_Status__c,
                subscription.Free_Trial_End_Date__c,
                subscription.NumGiftPeriods__c,
                subscription.NumFreeTrialPeriods__c
            );
        }
    }
    
    public class GiftInfo {
        public String giftCode { get; set; }
        public String giftCodeStartDate { get; set; }
        public String giftCodeCampaignID { get; set; }
        public String giftCodeEndDate { get; set; }
        public String giftCodeStatus { get; set; }
        public String freeTrialEndDate { get; set; }
        public String numGiftPeriods { get; set; }
        public String numFreeTrials { get; set; }
        
        public GiftInfo(String giftCode,
                        Date giftCodeStartDate,
                        String giftCodeCampaignID,
                        Date giftCodeEndDate,
                        String giftCodeStatus,
                        Date freeTrialEndDate,
                        String numGiftPeriods,
                        String numFreeTrials) {
            this.giftCode = giftCode;
            this.giftCodeStartDate = giftCodeStartDate != null ? giftCodeStartDate.format() : null;
            this.giftCodeCampaignID = giftCodeCampaignID;
            this.giftCodeEndDate = giftCodeEndDate != null ? giftCodeEndDate.format() : null;
            this.giftCodeStatus = giftCodeStatus;
            this.freeTrialEndDate = freeTrialEndDate != null ? freeTrialEndDate.format() : null;
            this.numGiftPeriods = numGiftPeriods;
            this.numFreeTrials = numFreeTrials;
        }
    }
    
}