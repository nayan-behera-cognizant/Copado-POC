@isTest
private class MassEmailHelperTest {
	
	@testSetup
	public static void setup() {
		List<DAZNConfiguration__c> config = new List<DAZNConfiguration__c>();

		config.add(new DAZNConfiguration__c(
            Name = 'useLimitsSF',
            Value__c = 'limits'
        ));
        config.add(new DAZNConfiguration__c(
        	Name = 'MassEmailRequestLinkForCs',
            Value__c = 'test'
        ));
        config.add(new DAZNConfiguration__c(
        	Name = 'FinishEmailIdForMassEmailRequest',
        	Value__c = 'testFinish'
        ));
        insert config;
        
	}

	@isTest 
	static void testAddToMassEmailError() {
		Case cs = SetupTestData.createCase('Live Stream Issue', 'I have a live stream issue', 'Open', 'test', UserInfo.getUserEmail(), 'en');

		User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);

		System.runAs(oCSUser) {
			String result = MassEmailHelper.addToMassEmail(new List<String>{cs.Id});
			System.assert(result == Label.ME_Only_one_Mass_Email_equest);
		}
	}
	
	@isTest 
	static void testAddToMassEmail() {

		User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);

		System.runAs(oCSUser) {
			Case cs = SetupTestData.createCase('Live Stream Issue', 'I have a live stream issue', 'Open', 'test', 'test@tect.ts', 'en');

			Mass_Email_Request__c massRequest = new Mass_Email_Request__c();
			insert massRequest;
			String result = MassEmailHelper.addToMassEmail(new List<String>{cs.Id});
			System.assert(result == 'success');

			List<Mass_Email_Request_Detail__c> details = [SELECT Id FROM Mass_Email_Request_Detail__c];
			System.assertEquals(details.isEmpty(), false);
		}
	}

	@isTest 
	static void testSendEmailNoLimit() {
		User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
		insert new DAZNConfiguration__c(Name = 'CheckingEmailsLimit', Value__c = 'Yes');
		System.runAs(oCSUser) {
			Case cs = SetupTestData.createCase('Live Stream Issue', 'I have a live stream issue', 'Open', 'test', 'test@tect.ts', 'en');
			
			Mass_Email_Request__c massRequest = new Mass_Email_Request__c();
			insert massRequest;

			String result = MassEmailHelper.addToMassEmail(new List<String>{cs.Id});
			System.assert(result == 'success');

			List<Mass_Email_Request_Detail__c> details = [SELECT Id FROM Mass_Email_Request_Detail__c];
			System.assertEquals(details.isEmpty(), false);

			Test.startTest();
				Test.setMock(HttpCalloutMock.class, new MockSetLimitResponseNoEmail());
				String sendEmailResult = MassEmailHelper.sendEmail(massRequest.Id);
				System.assert(sendEmailResult == Label.ME_consumed_daily_limit);
			Test.stopTest();
		}
	}

	@isTest 
	static void testSendEmail() {
		User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
		SetUpTestData.createEmailTemplate();
		System.runAs(oCSUser) {
			Case cs = SetupTestData.createCase('Live Stream Issue', 'I have a live stream issue', 'Open', 'test', 'test@tect.ts', 'en');

			List<EmailTemplate> emailTemplates = [SELECT Id, DeveloperName FROM EmailTemplate];
			
			Mass_Email_Request__c massRequest = new Mass_Email_Request__c();
			for (EmailTemplate item : emailTemplates) {
				if (item.DeveloperName == 'testTemplateEn') {
					massRequest.English_email_template__c = item.DeveloperName;
				}
				if (item.DeveloperName == 'testTemplateJA') {
					massRequest.Japanese_email_template__c = item.DeveloperName;
				}
				if (item.DeveloperName == 'testTemplateDE') {
					massRequest.German_email_template__c = item.DeveloperName;
				}
				if (item.DeveloperName == 'testTemplateFR') {
					massRequest.French_email_template__c = item.DeveloperName;
				}
			}
			
			insert massRequest;

			String result = MassEmailHelper.addToMassEmail(new List<String>{cs.Id});
			System.assert(result == 'success');

			List<Mass_Email_Request_Detail__c> details = [SELECT Id FROM Mass_Email_Request_Detail__c];
			System.assertEquals(details.isEmpty(), false);

			Test.startTest();
				Test.setMock(HttpCalloutMock.class, new MockSetLimitResponse());
				String sendEmailResult = MassEmailHelper.sendEmail(massRequest.Id);
				System.assert(sendEmailResult == 'success');
			Test.stopTest();
		}
	}

	@isTest 
	static void testSendEmailWithTarget() {
		User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
		SetUpTestData.createEmailTemplate();
		System.runAs(oCSUser) {
			Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm2testemail@email.com','Free Trial');
			Case cs = SetupTestData.createCase('Live Stream Issue', 'I have a live stream issue', 'Open', 'test', 'test@tect.ts', 'en', oAccount.Id);

			List<EmailTemplate> emailTemplates = [SELECT Id, DeveloperName FROM EmailTemplate];
			
			Mass_Email_Request__c massRequest = new Mass_Email_Request__c();
			for (EmailTemplate item : emailTemplates) {
				if (item.DeveloperName == 'testTemplateEn') {
					massRequest.English_email_template__c = item.DeveloperName;
				}
				if (item.DeveloperName == 'testTemplateJA') {
					massRequest.Japanese_email_template__c = item.DeveloperName;
				}
				if (item.DeveloperName == 'testTemplateDE') {
					massRequest.German_email_template__c = item.DeveloperName;
				}
				if (item.DeveloperName == 'testTemplateFR') {
					massRequest.French_email_template__c = item.DeveloperName;
				}
			}
			
			insert massRequest;

			String result = MassEmailHelper.addToMassEmail(new List<String>{cs.Id});
			System.assert(result == 'success');

			List<Mass_Email_Request_Detail__c> details = [SELECT Id FROM Mass_Email_Request_Detail__c];
			System.assertEquals(details.isEmpty(), false);

			Test.startTest();
				Test.setMock(HttpCalloutMock.class, new MockSetLimitResponse());
				String sendEmailResult = MassEmailHelper.sendEmail(massRequest.Id);
				System.assert(sendEmailResult == 'success');
			Test.stopTest();
			List<Mass_Email_Request_Detail__c> detailsAfterBatch = [SELECT Id, 	Email_Sent__c FROM Mass_Email_Request_Detail__c];
			Integer sentEmail = 0;
			for (Mass_Email_Request_Detail__c item :detailsAfterBatch) {
				if (item.Email_Sent__c) {
					sentEmail+=1;
				}
			}
			System.assertEquals(sentEmail,1);
		}
	}

	@isTest 
	static void testSendEmailWithTargetDE_JA_FR() {
		User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
		SetUpTestData.createEmailTemplate();
		System.runAs(oCSUser) {
			Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm2testemail@email.com','Free Trial');
			Case cs = SetupTestData.createCase('Live Stream Issue', 'I have a live stream issue', 'Open', 'test', 'test1@tect.ts', 'de', oAccount.Id);

			Account oAccountFR = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm2testemail1@email.com','Free Trial');
			Case csFR = SetupTestData.createCase('Live Stream Issue', 'I have a live stream issue', 'Open', 'test', 'test2@tect.ts', 'fr', oAccountFR.Id);

			Account oAccountJA = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','pm2testemail2@email.com','Free Trial');
			Case csJA = SetupTestData.createCase('Live Stream Issue', 'I have a live stream issue', 'Open', 'test', 'test3@tect.ts', 'ja', oAccountJA.Id);

			List<EmailTemplate> emailTemplates = [SELECT Id, DeveloperName FROM EmailTemplate];
			
			Mass_Email_Request__c massRequest = new Mass_Email_Request__c();
			for (EmailTemplate item : emailTemplates) {
				if (item.DeveloperName == 'testTemplateEn') {
					massRequest.English_email_template__c = item.DeveloperName;
				}
				if (item.DeveloperName == 'testTemplateJA') {
					massRequest.Japanese_email_template__c = item.DeveloperName;
				}
				if (item.DeveloperName == 'testTemplateDE') {
					massRequest.German_email_template__c = item.DeveloperName;
				}
				if (item.DeveloperName == 'testTemplateFR') {
					massRequest.French_email_template__c = item.DeveloperName;
				}
			}
			
			insert massRequest;

			String result = MassEmailHelper.addToMassEmail(new List<String>{cs.Id, csFR.Id, csJA.Id});
			System.assert(result == 'success');

			List<Mass_Email_Request_Detail__c> details = [SELECT Id FROM Mass_Email_Request_Detail__c];
			System.assertEquals(details.isEmpty(), false);

			Test.startTest();
				Test.setMock(HttpCalloutMock.class, new MockSetLimitResponse());
				String sendEmailResult = MassEmailHelper.sendEmail(massRequest.Id);
				System.assert(sendEmailResult == 'success');
			Test.stopTest();
			List<Mass_Email_Request_Detail__c> detailsAfterBatch = [SELECT Id, 	Email_Sent__c FROM Mass_Email_Request_Detail__c];
			Integer sentEmail = 0;
			for (Mass_Email_Request_Detail__c item :detailsAfterBatch) {
				if (item.Email_Sent__c) {
					sentEmail+=1;
				}
			}
			System.assertEquals(sentEmail,3);
		}
	}

	@isTest
	static void testMassEmailRequestTrigger() {
		User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);

		System.runAs(oCSUser) {

			Mass_Email_Request__c massRequest = new Mass_Email_Request__c();
			insert massRequest;
			
			try {
				Mass_Email_Request__c massRequest2 = new Mass_Email_Request__c();
				insert massRequest2;
			} catch(Exception ex) {
				System.assertEquals(ex.getMessage().contains(Label.ME_Only_one_Mass_Email_equest), true);
			}
			
		}
	}

	@isTest
	static void testMassEmailRequestTriggerStatus() {
		User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);

		System.runAs(oCSUser) {

			try {
				Mass_Email_Request__c massRequest2 = new Mass_Email_Request__c();
				massRequest2.Status__c = 'In process';
				insert massRequest2;
			} catch(Exception ex) {
				System.assertEquals(ex.getMessage().contains(Label.ME_cannot_modify_Status), true);
			}
			
		}
	}

	public class MockSetLimitResponseNoEmail implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{"MassEmail" : { "Max" : 10, "Remaining" : 0 }, "SingleEmail" : { "Max" : 15, "Remaining" : 0 }}'
            );
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockSetLimitResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{"MassEmail" : { "Max" : 10, "Remaining" : 10 }, "SingleEmail" : { "Max" : 15, "Remaining" : 15 }}'
            );
            res.setStatusCode(200);
            return res;
        }
    }
}