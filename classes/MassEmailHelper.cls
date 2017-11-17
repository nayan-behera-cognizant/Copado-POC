global with sharing class MassEmailHelper {

	//Description: Method for adding Case to Mass Email and Validation curent Userr
	webservice static String addToMassEmail(List<String> caseId) {
		String result = Label.ME_techical_error;
		String mssEmailRequestId;
		try {
			List<Case> addCase = [SELECT Id, Notification_Language_Code__c, SuppliedEmail, AccountId FROM Case WHERE Id IN :caseId LIMIT 5000];
			//Checking mass email request for curent user
			List<Mass_Email_Request__c> masterMassEmail = [SELECT Id, Status__c
																FROM Mass_Email_Request__c 
																WHERE 	Status__c = 'Draft' AND CreatedById = :UserInfo.getUserId() 
																ORDER BY CreatedDate DESC 
																LIMIT 1];
			
			if (masterMassEmail.isEmpty()) {
				
				result = Label.ME_Only_one_Mass_Email_equest;

			} else if (!addCase.isEmpty() && !masterMassEmail.isEmpty() && masterMassEmail[0].Status__c == 'Draft') {
				List<Mass_Email_Request_Detail__c> massEmailDetails = new List<Mass_Email_Request_Detail__c>();
				
				Set<Id> caseIdInRequest = new Set<Id>();
				List<Mass_Email_Request_Detail__c> oldMassEmailForRequest = [SELECT Case__c FROM Mass_Email_Request_Detail__c WHERE Mass_Email_Request__c = :masterMassEmail[0].Id LIMIT 10000];
				if (!oldMassEmailForRequest.isEmpty()) {
					for (Mass_Email_Request_Detail__c item :oldMassEmailForRequest) {
						caseIdInRequest.add(item.Case__c);
					}
				}
				//Creating Mass Email Request Detail for List of Case
				Map<String,Case> caseWithoutAccount = new Map<String,Case>();
				for (Case item :addCase) {
					Boolean isContain = false;
					if (!caseIdInRequest.isEmpty() && caseIdInRequest.contains(item.Id)) {
						isContain = true;
					}
					if (!isContain) {
						Mass_Email_Request_Detail__c massEmailDetail = new Mass_Email_Request_Detail__c();
						if (!String.isBlank(item.AccountId) || !String.isBlank(item.SuppliedEmail)) {
							massEmailDetail.Account__c = item.AccountId;
							massEmailDetail.Case__c = item.Id;
							massEmailDetail.Email__c =  item.SuppliedEmail;
							if (String.isBlank(item.Notification_Language_Code__c) || item.Notification_Language_Code__c == 'Unknown') {
								massEmailDetail.Language__c = 'en';
							} else {
								String language = item.Notification_Language_Code__c.toLowerCase();
								massEmailDetail.Language__c = language.length() > 2 ? language.substring(0,2) : language;
							}
							massEmailDetail.Mass_Email_Request__c = masterMassEmail[0].Id;
							massEmailDetails.add(massEmailDetail);
						} 
						if (String.isBlank(item.AccountId) && !String.isBlank(item.SuppliedEmail)) {
							caseWithoutAccount.put(item.Id,item);
						}
					}
				}
				
				if (massEmailDetails != null && !massEmailDetails.isEmpty()) {
					insert massEmailDetails;
				} 	
				
				//Creating Lead for Case without Account Id
				Boolean isCreateLead = true;
				if (!caseWithoutAccount.isEmpty()) {
					isCreateLead = createdLeadForEmailDetail(massEmailDetails);

				}
				if (isCreateLead) {
					result = 'success';
				}
				
			}
		} catch (Exception ex){
			ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'MassEmailHelper', 'addToMassEmail', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
			result = Label.ME_techical_error;
		}
		
		return result;
	}

	/*
	Method for Creating Lead for Case without Accout Id
	*/
	public static Boolean createdLeadForEmailDetail(List<Mass_Email_Request_Detail__c> massEmailDetails) {
		Boolean isResult = false;
		try {
			Map<String,Mass_Email_Request_Detail__c> detailsById = new Map<String,Mass_Email_Request_Detail__c>();
			List<Lead> newListOfLead = new List<Lead>();
			for (Mass_Email_Request_Detail__c item :massEmailDetails) {
				if (String.isBlank(item.Account__c)) {
					Lead newLead = new Lead(); 
					newLead.Email = item.Email__c;
					newLead.LastName = item.Email__c;
					newLead.Company = item.Id;
					newListOfLead.add(newLead);
					detailsById.put(item.Id,item);
				}
			}
			if (newListOfLead != null && !newListOfLead.isEmpty()) {
				insert newListOfLead;
			}
			
			for (Lead item :newListOfLead) {
				if (detailsById.containsKey(item.Company)) {
					detailsById.get(item.Company).Lead__c = item.Id;
				}
			}
			if (detailsById != null && !detailsById.values().isEmpty()) {
				update detailsById.values();
			}
			
			isResult = true;
		} catch (Exception ex){
			ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'MassEmailHelper', 'createdLeadForEmailDetail', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
			isResult = false;
		}
		return isResult;
	}

	//Description: Method for checking and start Mass Email
	webservice static String sendEmail(String massEmailId) {
		Set<String> massEmailAccount = new Set<String>();
		Integer countEmailForSingleEmailRemaining;
		Boolean isCheckLimit;

		String result = 'fail';	

		if (!checkCountOfBatchProcess()) {
			return Label.ME_Mass_Email_Request_in_process;
		}

		if (!checkStatusRequestForUser(massEmailId)) {
			return Label.ME_Mass_Email_Request_in_process;
		}

		String checkingEmailLimit = (DAZNConfiguration__c.getValues('CheckingEmailsLimit') != null) ? DAZNConfiguration__c.getValues('CheckingEmailsLimit').Value__c : 'No';
		isCheckLimit = checkingEmailLimit == 'No' ? false : true;
		
		if (isCheckLimit) {
			LimitsInfo info = getCurrentLimitForMassEmail();
			if (info != null && info.MassEmail != null) {
				if (info.SingleEmail.Remaining == 0) {
					return Label.ME_consumed_daily_limit;
				} else {
					countEmailForSingleEmailRemaining = Integer.valueOf(info.SingleEmail.Remaining);
				}
			} else {
				return Label.ME_techical_error;
			}
		}
		
		List<Mass_Email_Request_Detail__c> massEmailDetail = [SELECT Account__c, Case__c, Email__c, Language__c, Mass_Email_Request__c, Email_Sent__c, 
																		Thread_Id__c, Mass_Email_Request__r.English_email_template__c, Account__r.PersonEmail,
																		Case__r.CaseNumber, Account__r.FirstName
																	FROM Mass_Email_Request_Detail__c 
																	WHERE CreatedById = :UserInfo.getUserId()
																		AND Email_Sent__c = false
																		AND Mass_Email_Request__c = :massEmailId
																		AND Language__c != null
																	ORDER BY CreatedDate ASC
																	LIMIT 10000];
		if (!massEmailDetail.isEmpty()) {

			for (Mass_Email_Request_Detail__c item : massEmailDetail) {
				massEmailAccount.add(item.Id);
			}

			Integer limitSingle = (DAZNConfiguration__c.getValues('SingleEmailLimits') != null) ? Integer.valueOf(DAZNConfiguration__c.getValues('SingleEmailLimits').Value__c) : 10000;
			if (isCheckLimit) {
				limitSingle = Integer.valueOf(massEmailDetail.size() <= countEmailForSingleEmailRemaining ? massEmailDetail.size() : countEmailForSingleEmailRemaining);
			}	
			MassEmailSendingBatch bc = new MassEmailSendingBatch(limitSingle,massEmailId, massEmailAccount);
			Database.executeBatch(bc, 100);
		}

		return 'success';
	}

	/*
	Description: Method for checking count of working batch
	*/
	public static Boolean checkCountOfBatchProcess() {
		Boolean isResult = false;
		Set<String> completedStatus = new Set<String>{'Aborted', 'Completed', 'Failed'};
		Integer countOfApexJob = [SELECT Count() FROM AsyncApexJob WHERE Status NOT IN :completedStatus];
		if (countOfApexJob < 50) {
			isResult = true;
		}
		return isResult;
	}

	/*
	Description: Method for checking Mass Email Request status
	*/
	public static Boolean checkStatusRequestForUser(String massEmailId) {
		Boolean isResult = true;
		Mass_Email_Request__c massRequest = [SELECT Status__c FROM Mass_Email_Request__c WHERE Id = :massEmailId];
		if (massRequest.Status__c == 'In process' || massRequest.Status__c == 'Completed') {
			isResult = false;
		}
		return isResult;
	}

	/*
	Description: Method for creating Map with Contact by Account Id
	*/
	public static Map<String, Contact> getContactByAccountId(Set<String> setofAccountId) {
		Map<String, Contact> contactsByAccountId = new Map<String, Contact>();
		List<Contact> contacts = [SELECT Id, Email, AccountId, FirstName FROM Contact WHERE AccountId IN :setofAccountId LIMIT 10000];
		if (!contacts.isEmpty()) {
			for (Contact item : contacts) {
				contactsByAccountId.put(item.AccountId,item);
			}
		}
		return contactsByAccountId;
	}

	/*
	Description: Method for creating Map with Email Template by language code
	*/
	public static Map<String,EmailTemplate> getTemplatesIdByLanguage(String massEmailId) {
		Map<String,EmailTemplate> templatesIdByLang = new Map<String,EmailTemplate>();
		Set<String> names = new Set<String>();
		List<Mass_Email_Request__c> massEmailRequest = [SELECT English_email_template__c, French_email_template__c, German_email_template__c, Japanese_email_template__c 
		 													FROM Mass_Email_Request__c
		 													WHERE CreatedById = :UserInfo.getUserId()
		 															AND Id = :massEmailId];

		if (!massEmailRequest.isEmpty()) {
			for (Mass_Email_Request__c item :massEmailRequest) {
				names.add(item.English_email_template__c);
				names.add(item.French_email_template__c);
				names.add(item.German_email_template__c);
				names.add(item.Japanese_email_template__c);
			}
			List<EmailTemplate> emailTemplates = [SELECT Id, DeveloperName,HtmlValue,Subject FROM EmailTemplate WHERE DeveloperName IN :names];
			for (EmailTemplate item :emailTemplates) {
				if (item.DeveloperName == massEmailRequest[0].English_email_template__c) {
					templatesIdByLang.put('en',item);
				}
				if (item.DeveloperName == massEmailRequest[0].French_email_template__c) {
					templatesIdByLang.put('fr',item);
				}
				if (item.DeveloperName == massEmailRequest[0].German_email_template__c) {
					templatesIdByLang.put('de',item);
				}
				if (item.DeveloperName == massEmailRequest[0].Japanese_email_template__c) {
					templatesIdByLang.put('ja',item);
				}
			}
		}
		return templatesIdByLang;
	}

	/*
	Description: Method for creating Single Email Message
	*/
	public static List<Messaging.SingleEmailMessage> createSingleEmailMassage(List<MassEmailBycontact> sendingObject, Boolean isForContact) {
		List<Messaging.SingleEmailMessage> resultEmailMessages = new List<Messaging.SingleEmailMessage>();
		
		for (MassEmailHelper.MassEmailBycontact item :sendingObject) {
			
			Messaging.SingleEmailMessage emails = new Messaging.SingleEmailMessage(); 
			
			String htmlBody = createEmailBody(item);
			String subjectEmail = createEmailSubject(item);
			if (isForContact) {
				emails.setTargetObjectId(item.contactId);
			} else {
				emails.setTargetObjectId(item.leadId);
			}			
			emails.setHTMLBody(htmlBody);
			emails.setSubject(subjectEmail);
			String emailForFrom = getFromEmail();
			if (!String.isBlank(emailForFrom)) {
				emails.setOrgWideEmailAddressId(emailForFrom);
			}

			resultEmailMessages.add(emails);
		}
		return resultEmailMessages;
	}

	/*
	Description: Method for getting Id from OrgWideEmailAddress and use it email in FROM
	*/
	public static String getFromEmail() {
		String result = '';
        List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress LIMIT 1];
		if (!owea.isEmpty()) {
			result = owea[0].Id;
		}
		return result;
		
	}

	/*Method for creating Body for Single email*/
	public static String createEmailBody(MassEmailHelper.MassEmailBycontact item) {
		String htmlBody = item.htmlBody;
		htmlBody = htmlBody.replace('{!Case.CaseNumber}', item.caseNumber);
		htmlBody = htmlBody.replace('{!Account.FirstName}', item.accFirstName);
		htmlBody = htmlBody.replace('{!Case.Thread_Id}', item.theardId);
		return htmlBody;
	}	

	/*Method for creating Body for Mass email*/
	public static String createEmailSubject(MassEmailHelper.MassEmailBycontact item) {
		String subjectEmail = item.subject;
		subjectEmail = subjectEmail.replace('{!Case.Thread_Id}', item.theardId); 
		return subjectEmail;
	}

	//Cheking Mass Email Request for curent user, if user hasn't Draft Mass Email Request return false
	public static Boolean checkMassEmailRequestForUser() {
		Boolean isResult = false;
		List<Mass_Email_Request__c> oldMassEmail = [SELECT Id FROM Mass_Email_Request__c WHERE CreatedById = :UserInfo.getUserId() AND Status__c = 'Draft'];
		if (!oldMassEmail.isEmpty()) {
			isResult = true;
		}
		return isResult;
	}

	//Chaking Single email and Mass email limits, return object: LimitsInfo:[MassEmail=BodyResponse:[Max=5000.0, Remaining=5000.0], SingleEmail=BodyResponse:[Max=5000.0, Remaining=5000.0]]
	public static LimitsInfo getCurrentLimitForMassEmail() {
		LimitsInfo limitsInfoResponse = new LimitsInfo();
		String endpointUrl = (DAZNConfiguration__c.getValues('useLimitsSF') != null) ? DAZNConfiguration__c.getValues('useLimitsSF').Value__c : null;
		if (endpointUrl.length() > 1) {
			HttpRequest request = new HttpRequest();
			request.setEndpoint(endpointUrl);
			request.setMethod('GET');
			request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
			Http http = new Http();
			HttpResponse response = http.send(request);
			if (response.getStatusCode() == 200) {
				limitsInfoResponse  = (LimitsInfo)JSON.deserialize(response.getBody(), LimitsInfo.class);
			}
		}
		return limitsInfoResponse;
	}

	public static Messaging.SingleEmailMessage createFinishEmail(String massEmailId) {
		String templateForFinish = (DAZNConfiguration__c.getValues('FinishEmailIdForMassEmailRequest') != null) ? DAZNConfiguration__c.getValues('FinishEmailIdForMassEmailRequest').Value__c : '';
		Messaging.SingleEmailMessage emails = new Messaging.SingleEmailMessage(); 
		if (!String.isBlank(templateForFinish)) {
			EmailTemplate emailFinish = [SELECT Id, DeveloperName, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = :templateForFinish];

			emails.setToAddresses(new List<String>{UserInfo.getUserEmail()});
			String htmlBody = emailFinish.HtmlValue;
			String linkForCS = (DAZNConfiguration__c.getValues('MassEmailRequestLinkForCs') != null) ? DAZNConfiguration__c.getValues('MassEmailRequestLinkForCs').Value__c : '';
			htmlBody = htmlBody.replace('{link}', linkForCS + massEmailId);
			emails.setHTMLBody(htmlBody);
			emails.setSubject(emailFinish.Subject);
			emails.setOrgWideEmailAddressId(getFromEmail());
		}
		return emails;
	}

	public class LimitsInfo {
		public BodyResponse MassEmail;
		public BodyResponse SingleEmail;
	}

	public class BodyResponse {
		public Double Max;
		public Double Remaining;
	}

	public class MassEmailBycontact {
		public String email;
		public String language;
		public string caseId;
		public String leadId;
		public String templateId;
		public String subject;
		public String htmlBody;
		public String theardId;
		public String caseNumber;
		public String accFirstName;
		public String massDetailId;
		public String contactId;

		public MassEmailBycontact(Mass_Email_Request_Detail__c detail, EmailTemplate template, String contactId) {
			this.email = detail.Email__c;
			this.language = detail.Language__c;
			this.caseId = detail.Case__c;
			this.templateId = template.Id;
			this.subject = template.Subject;
			this.htmlBody = template.HtmlValue;
			this.theardId = detail.Theard_Id_Formula__c;
			this.caseNumber = detail.Case__r.CaseNumber;
			this.accFirstName = String.isBlank(detail.Account__r.FirstName) ? '' : detail.Account__r.FirstName;
			this.massDetailId = detail.Id;
			if (String.isBlank(contactId)) {
				this.leadId = detail.Lead__c;
			} else {
				this.contactId = contactId;
			}
			
		}
	}

	public class TemplateAfterSend {
		public String htmlBody;
		public String subjectEmail;
		public TemplateAfterSend(String htmlBody, String subjectEmail) {
			this.htmlBody = htmlBody;
			this.subjectEmail = subjectEmail;
		}
	}
	
}