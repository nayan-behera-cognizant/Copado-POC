public with sharing class CampaignTriggerHandler {
	//Start part of PD-7838
	public static void UpdateCaseStatusAfterCampaignUpdate(List<Campaign> afterUpdateCampaign) {
		for(Campaign camp : afterUpdateCampaign) {
			if (camp.Status == 'Completed') {
				List<Case> lstCases= [SELECT Status FROM Case WHERE Campaign__c =: camp.id];
				if (!lstCases.isEmpty()) {
					for (Case cas : lstCases) {
						cas.Status = 'Waiting for Customer';
					}					
					update lstCases;
				}
				
			}
		}
	}
}