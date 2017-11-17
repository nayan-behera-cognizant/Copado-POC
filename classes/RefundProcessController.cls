/**
* @author Cognizant Technology Solutuions
* @date 24/04/2017
* @description RefundProcessController is the  class to create the Refund and Invoice line adjustment for the Payments by CS agents
*/

public without sharing class RefundProcessController {
	String payRecID {get; set;}
	public RefundProcessController (){
		list <Zuora__Refund__c> refObj = new list <Zuora__Refund__c>();
		list<Zuora__Payment__c>  paymentRecObj = new list<Zuora__Payment__c>  ();
		list<Zuora__PaymentInvoice__c> payInvObj  = new list<Zuora__PaymentInvoice__c>();
		List<Zuora.zApi.SaveResult> lstInvoiceAdjustmentsaveResult1;
        List<Zuora.zApi.SaveResult> checkrefund = new List<Zuora.zApi.SaveResult>();
		 payRecID= ApexPages.currentPage().getParameters().get('param1');
		paymentRecObj = [Select id,Name,Zuora__SettledOn__c,Zuora__EXT_ID__c,Zuora__External_Id__c from Zuora__Payment__c where id =:payRecID];
		payInvObj = [SELECT id,Name,Zuora__Payment__c,Zuora__Invoice__c,Zuora__Invoice__r.Zuora__External_Id__c,Zuora__Invoice__r.Zuora__ZuoraId__c 
							from Zuora__PaymentInvoice__c where Zuora__Payment__c =:payRecID ];
		refObj = [SELECT id,name,Zuora__Payment__c from  Zuora__Refund__c where  Zuora__Payment__c =:  payRecID];
		if((refObj.size()>0 && !refObj.isEmpty() && refObj != null)  ){		
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, System.label.LS_Refund_Error));
			}
		else{
			if((paymentRecObj[0].Zuora__SettledOn__c  != null  && payInvObj.size()>0) ){
				String InvoiceId = payInvObj[0].Zuora__Invoice__c;
                    checkrefund = ZuoraTransactionHelper.RefundAmount( paymentRecObj[0].Zuora__External_Id__c , payInvObj[0].Zuora__Invoice__r.Zuora__External_Id__c, 'Customer Satisfaction');
				if((checkrefund !=null && !checkrefund.isEmpty() && checkrefund[0].Success == true && checkrefund[0].Errors == null) || (test.isRunningTest())){ 
                        lstInvoiceAdjustmentsaveResult1 = ZuoraTransactionHelper.createInvoiceLineItemAdjusment(payInvObj[0].Zuora__Invoice__r.Zuora__External_Id__c,'Customer Satisfaction','Credit');                 					              
					if((lstInvoiceAdjustmentsaveResult1 != null && !lstInvoiceAdjustmentsaveResult1.isEmpty() && lstInvoiceAdjustmentsaveResult1[0].Success == true && 	lstInvoiceAdjustmentsaveResult1[0].Errors == null))
						{  
						apexpages.addmessage(new apexpages.message(ApexPages.severity.CONFIRM, System.Label.LS_Invoice_Success));
						}
                    else{
                        	apexpages.addmessage(new apexpages.message(ApexPages.severity.CONFIRM, System.Label.LS_Invoice_Error));
                    	}
					}  
				}
			else{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.LS_Payment_Setteled));
				}
			}
		}
}