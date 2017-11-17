public with sharing class CheckingAccountTypeController {
	public Boolean isDocomoUser;
	public Boolean isAppleUser;
	public String docomoPartnerPage {get;set;}
	public CheckingAccountTypeController() {

		if (!userInfo.getUserType().Equals('Guest') || Test.isRunningTest()) {
			this.isAppleUser = false;
			this.isDocomoUser = false;
			if (CommunityHelper.isAppleUser()) {
				this.isAppleUser = true;
			}
			if (CommunityHelper.IsDfDUser()) {
				this.isDocomoUser = true;
			}
		}

		if (this.isAppleUser || this.isDocomoUser) {
			redirectToPage();
		}
	}

	public void redirectToPage() {
		Boolean isDaznUser = true;
		PageReference redirectPage;
		Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');

		if (this.isAppleUser) {
			isDaznUser = false;
			this.docomoPartnerPage = (String.isNotBlank(pac.Page_Name__c) && pac.Page_Name__c.contains('.')) ? pac.Page_Name__c.substring(0, pac.Page_Name__c.indexOf('.')) : pac.Page_Name__c;
		}
		if (this.isDocomoUser) {
			isDaznUser = false;
			this.docomoPartnerPage = (String.isNotBlank(pac.Page_Name__c) && pac.Page_Name__c.contains('.')) ? pac.Page_Name__c.substring(0, pac.Page_Name__c.indexOf('.')) : pac.Page_Name__c;
		}
	}

}