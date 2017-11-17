/**
* @author Cognizant Technology Solutuions
* @date 30/03/2016
* @description Wrapper calss to hold information required for communicator to send notification email.
*/
public class WrapCommunicatorEmail{
    public string ID {get; set;}
    public string ContactId{get;set;}
    public string Email {get; set;}
    public string FirstName {get;set;} 
    public string AccountCurrency {get;set;}
    public string SubscriptionAmt {get;set;}
    public string PlanDetails {get;set;}
    public string PaymentType {get; set;}
    public datetime EndDate {get;set;}
    public datetime RebillDate {get;set;}
    public string SignInLink {get;set;}
    public string DeviceName {get;set;}
    public string NotificationCountryCode{get;set;}
    public string NotificaitonLanguageCode{get;set;}
    
    // constructor
    public WrapCommunicatorEmail(){
    }
}