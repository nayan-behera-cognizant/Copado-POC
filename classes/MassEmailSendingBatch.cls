/*
Description: Batch for Sending Mass email through Mass Email class and Single Email class
*/

global class MassEmailSendingBatch implements Database.Batchable<sObject> {
	
	String query;
	Integer countForSending;
	String massEmailId;
	Set<String> massEmailDetailIds;
	
	global MassEmailSendingBatch(Integer countForSending, String massEmailId, Set<String> massEmailDetailIds) {
		this.countForSending = countForSending;
		this.massEmailId = massEmailId;
		this.massEmailDetailIds = massEmailDetailIds;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String userId = UserInfo.getUserId();
		query = 'SELECT Account__c, Case__c, Email__c, Language__c, Mass_Email_Request__c, Email_Sent__c, ' +
						'Thread_Id__c, Mass_Email_Request__r.English_email_template__c, Account__r.PersonEmail, ' +
						'Case__r.CaseNumber, Account__r.FirstName, Theard_Id_Formula__c, Lead__c ' +
					'FROM Mass_Email_Request_Detail__c ' +
					'WHERE CreatedById =  ' + '\''+ userId +'\'' +
						'AND Id IN :massEmailDetailIds ' + 
					'ORDER BY CreatedDate ASC ' +
					'LIMIT ' + String.valueOf(countForSending);
		Mass_Email_Request__c request = [SELECT Id, Status__c FROM Mass_Email_Request__c WHERE Id = :massEmailId LIMIT 1];
		request.Status__c = 'In process';
		update request;

		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Mass_Email_Request_Detail__c> scope) {

		List<Mass_Email_Request_Detail__c> massEmailWithoutAccount = new List<Mass_Email_Request_Detail__c>();
		List<Mass_Email_Request_Detail__c> massEmailAccount = new List<Mass_Email_Request_Detail__c>();
		Set<String> setofAccountId = new Set<String>();
		
		for (Mass_Email_Request_Detail__c item : scope) {
			if (!String.isBlank(item.Account__c)) {
				massEmailAccount.add(item);
				setofAccountId.add(item.Account__c);
			} else {
				massEmailWithoutAccount.add(item);
			}
		}

		if (!massEmailAccount.isEmpty()) {
			sendEmailWithTargetContact(massEmailAccount, setofAccountId, massEmailId);
		}

		if (!massEmailWithoutAccount.isEmpty()) {
			sendEmailWithTargetLead(massEmailWithoutAccount, massEmailId);
		}

	}
	
	global void finish(Database.BatchableContext BC) {
		AsyncApexJob apexJob = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()];        
		
		if (apexJob.Status == 'Completed') {
			Messaging.SingleEmailMessage emails = MassEmailHelper.createFinishEmail(massEmailId);
			Messaging.SendEmail(new Messaging.SingleEmailMessage[]{emails});
		}
		
		Mass_Email_Request__c request = [SELECT Id, Status__c FROM Mass_Email_Request__c WHERE Id = :massEmailId LIMIT 1];
		request.Status__c = 'Completed';
		update request;

	}

	/*
	Desciption: Method for sending Mass Email if Case has Account Id
	*/
	public static void sendEmailWithTargetContact(List<Mass_Email_Request_Detail__c> massEmailAccount, Set<String> setofAccountId, String massEmailId) {
		
		Map<String, Contact> contactMap = MassEmailHelper.getContactByAccountId(setofAccountId);

		Map<String, MassEmailHelper.TemplateAfterSend> sendEmailByDetailId = new Map<String,MassEmailHelper.TemplateAfterSend>();
		Map<String, EmailTemplate> templateByLanguage = MassEmailHelper.getTemplatesIdByLanguage(massEmailId);
		Map<String, Mass_Email_Request_Detail__c> massEmailDetailByCaseId = new Map<String, Mass_Email_Request_Detail__c>();

		List<MassEmailHelper.MassEmailBycontact> sendingObject = new List<MassEmailHelper.MassEmailBycontact>();
		for (Mass_Email_Request_Detail__c item :massEmailAccount) {
			sendingObject.add(new MassEmailHelper.MassEmailBycontact(item, templateByLanguage.get(item.Language__c), contactMap.get(item.Account__c).Id));
		}

		List<Messaging.SingleEmailMessage> resultEmailMessages = MassEmailHelper.createSingleEmailMassage(sendingObject,true);

		if (!resultEmailMessages.isEmpty()) {

			for (MassEmailHelper.MassEmailBycontact item :sendingObject) {
				String htmlBody = MassEmailHelper.createEmailBody(item);
				String subjectEmail = MassEmailHelper.createEmailSubject(item);
				sendEmailByDetailId.put(item.massDetailId, new MassEmailHelper.TemplateAfterSend(htmlBody,subjectEmail));
			}

			Messaging.SendEmail(resultEmailMessages);
			addedEmailsToCase(massEmailAccount, contactMap, sendEmailByDetailId);
		}	
	}

	/*
	Desciption: Method for sending Mass Email if Case doesn't have Account Id, for this scenario we use Lead as target object
	*/
	public static void sendEmailWithTargetLead(List<Mass_Email_Request_Detail__c> massEmailAccount, String massEmailId) {
		
		Map<String, MassEmailHelper.TemplateAfterSend> sendEmailByDetailId = new Map<String,MassEmailHelper.TemplateAfterSend>();
		Map<String, EmailTemplate> templateByLanguage = MassEmailHelper.getTemplatesIdByLanguage(massEmailId);
		Map<String, Mass_Email_Request_Detail__c> massEmailDetailByCaseId = new Map<String, Mass_Email_Request_Detail__c>();

		List<MassEmailHelper.MassEmailBycontact> sendingObject = new List<MassEmailHelper.MassEmailBycontact>();
		for (Mass_Email_Request_Detail__c item :massEmailAccount) {
			sendingObject.add(new MassEmailHelper.MassEmailBycontact(item, templateByLanguage.get(item.Language__c), null));
		}

		List<Messaging.SingleEmailMessage> resultEmailMessages = MassEmailHelper.createSingleEmailMassage(sendingObject, false);

		if (!resultEmailMessages.isEmpty()) {

			for (MassEmailHelper.MassEmailBycontact item :sendingObject) {
				String htmlBody = MassEmailHelper.createEmailBody(item);
				String subjectEmail = MassEmailHelper.createEmailSubject(item);
				sendEmailByDetailId.put(item.massDetailId, new MassEmailHelper.TemplateAfterSend(htmlBody,subjectEmail));
			}

			Messaging.SendEmail(resultEmailMessages);
			addedEmailsToCase(massEmailAccount, null, sendEmailByDetailId);
		}
	}

	//Description add EmailMessage to Case
	public static void addedEmailsToCase(List<Mass_Email_Request_Detail__c> massEmailAccount, Map<String, Contact> contactMap, Map<String, MassEmailHelper.TemplateAfterSend> sendEmailByDetailId) {
		try {
			List<EmailMessage> newEmailMessages = new List<EmailMessage>();
			Set<String> caseIds = new Set<String>();
			for (Mass_Email_Request_Detail__c item : massEmailAccount) {
				EmailMessage emailMsg = new EmailMessage(); 
				emailMsg.ToAddress = item.Account__r.PersonEmail;

				emailMsg.Subject = sendEmailByDetailId.get(item.Id).subjectEmail;
				emailMsg.HtmlBody = sendEmailByDetailId.get(item.Id).htmlBody;
				
				emailMsg.ParentId = item.Case__c;
				emailMsg.MessageDate = system.now();
				emailMsg.Status = '0';

				if (contactMap != null && contactMap.containsKey(item.Account__c)) {
					emailMsg.FromName = contactMap.get(item.Account__c).FirstName;
				}
				if (contactMap != null && contactMap.containsKey(item.Account__c)) {
					emailMsg.FromAddress = contactMap.get(item.Account__c).Email;
				}

				if (contactMap == null) {
					emailMsg.FromAddress = item.Email__c;
				}
				
				newEmailMessages.add(emailMsg);
				caseIds.add(item.Case__c);
				item.Email_Sent__c = true;


			}
			insert newEmailMessages;
			updateCaseStatus(caseIds);
			update massEmailAccount;
		} catch (Exception ex) {
			ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'MassEmailHelper', 'addedEmailsToCase', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
		}
	}

	//Description update Case 
	public static void updateCaseStatus(Set<String> caseIds) {
		List<Case> cases = [SELECT Id, Status FROM Case WHERE Id IN :caseIds];
		for (Case item : cases) {
			item.Status = 'Resolved';
		}
		update cases;
	}

}