global class CheckCountUserLicense implements Schedulable {
	

	global void execute(SchedulableContext sc) {
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :sc.getTriggerId()];
		checkCountLicense();
	}

	public static void checkCountLicense() {
		Decimal percentForCommunityLicense;
		Decimal percentForSalesforceLicense;
		List<UserLicenseConfiguration__c> csLicense = [SELECT Email__c, Email_TemplateId__c, Total_Community_Licenses__c, Total_Standard_License__c, Contact_Id__c, 
															Percent_for_Salesfore_License__c, Percent_for_Community_License__c 
														FROM UserLicenseConfiguration__c];
		
		List<License_Alert__c> licenseAlertsCommunity = [SELECT Consumed_in_percentage__c, Consumed__c, Name_of_License__c, OwnerId, CreatedDate, Name, Total_License_for_Record__c 
															FROM License_Alert__c 
															WHERE Name_of_License__c = 'Community Licenses'
															ORDER BY CreatedDate DESC LIMIT 1];
		List<License_Alert__c> licenseAlertsSalesforce = [SELECT Consumed_in_percentage__c, Consumed__c, Name_of_License__c, OwnerId, CreatedDate, Name, Total_License_for_Record__c 
															FROM License_Alert__c 
															WHERE Name_of_License__c = 'Salesforce Licenses'
															ORDER BY CreatedDate DESC LIMIT 1];

		percentForCommunityLicense = (!csLicense.isEmpty() && csLicense[0].Percent_for_Community_License__c != null) ? csLicense[0].Percent_for_Community_License__c : 70;
		percentForSalesforceLicense = (!csLicense.isEmpty() && csLicense[0].Percent_for_Salesfore_License__c != null) ? csLicense[0].Percent_for_Salesfore_License__c : 70;
														
		if (!licenseAlertsCommunity.isEmpty() && licenseAlertsCommunity[0].Consumed_in_percentage__c >= percentForCommunityLicense) {
			sendEmail(licenseAlertsCommunity, csLicense);
		}
		if (!licenseAlertsSalesforce.isEmpty() && licenseAlertsSalesforce[0].Consumed_in_percentage__c >= percentForSalesforceLicense) {
			sendEmail(licenseAlertsSalesforce, csLicense);
		}
		
	}

	public static void sendEmail(List<License_Alert__c> licenseAlerts, List<UserLicenseConfiguration__c> csLicense) {
		
		if (!csLicense.isEmpty()) {
			List<String> emailAdress = csLicense[0].Email__c.split(',');
			for (Integer i=0; i<emailAdress.size(); i++) {
				emailAdress[i].trim();
			}
			if (!emailAdress.isEmpty()) {
				EmailTemplate template = [SELECT Id,DeveloperName, Body, HtmlValue, Subject FROM EmailTemplate WHERE Id = :csLicense[0].Email_TemplateId__c];
               
				String htmlBody = template.HtmlValue == null ? '' : template.HtmlValue;
				String orgId = (DAZNConfiguration__c.getValues('ProdId') != null) ? DAZNConfiguration__c.getValues('ProdId').Value__c : null;
				if (UserInfo.getOrganizationId() != orgId) {
					htmlBody = htmlBody.replace('Hello Ops team ', 'Hello team ');
				}

				htmlBody = htmlBody.replace('{!License_Alert__c.Name}', licenseAlerts[0].Name);
				htmlBody = htmlBody.replace('{!License_Alert__c.Total_License_for_Record__c}', String.valueOf(licenseAlerts[0].Total_License_for_Record__c));
				htmlBody = htmlBody.replace('{!License_Alert__c.Consumed__c}', String.valueOf(licenseAlerts[0].Consumed__c));
				htmlBody = htmlBody.replace('{!License_Alert__c.Consumed_in_percentage__c}',  String.valueOf(licenseAlerts[0].Consumed_in_percentage__c));
				htmlBody = htmlBody.replace('{!Organization.Name}', UserInfo.getOrganizationName());
				
				String subjectEmail = template.Subject;
				subjectEmail = subjectEmail.replace('{!License_Alert__c.Consumed_in_percentage__c}', String.valueOf(licenseAlerts[0].Consumed_in_percentage__c));
				subjectEmail = subjectEmail.replace('{!License_Alert__c.Name}',  licenseAlerts[0].Name);
				subjectEmail = subjectEmail.replace('{!Organization.Name}', UserInfo.getOrganizationName());

				Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
				
				message.setHtmlBody(htmlBody);
				message.setSubject(subjectEmail);
				message.setWhatId(licenseAlerts[0].Id);
				message.setTargetObjectId(csLicense[0].Contact_Id__c);
				message.setSaveAsActivity(false);
				message.setToAddresses(emailAdress);
				Messaging.sendEmail(new Messaging.SingleEmailMessage [] {message});
			}
		}
	}
}