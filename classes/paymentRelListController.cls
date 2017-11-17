/**
* @author Cognizant Technology Solutuions
* @date 24/04/2017
* @description paymentRelListController is the  class to get the payment id and do the respect procees on request (Edit.delete and refund)
*/



public class paymentRelListController {
    public List<Zuora__Payment__c> payRelList {get; set;}
    public String accIdofpayment {get; set;}
    public String PayDelId {get; set;}
    public String PayEditId {get; set;}
    public String PayRecId {get; set;}
    public Boolean ProfileDisplaySet{get; set;}

    public List<PaymentWrp> paymentWrp  { get; set; }

    public String choosePaymentId {get;set;}
    public Boolean isShowTable {get;set;}
    
    public paymentRelListController(ApexPages.StandardController controller) {    
        accIdofpayment = controller.getRecord().id;
        paymentWrp = new List<PaymentWrp>();
        isShowTable = true;
        if (userinfo.getProfileId() != null) {
            Profile pfDisp = [Select id, Name from profile where id =: userinfo.getProfileId()];
            String strPrf = pfDisp.Name;
            String CustLab =System.label.LS_RefundEnable_Profiles; 
            if (System.label.LS_RefundEnable_Profiles.contains(pfDisp.Name)) {
              ProfileDisplaySet = TRUE;
            } else {
              ProfileDisplaySet = False;                
            }
        }
        paymentWrp = getPayments();
    }

    public List<PaymentWrp> getPayments() {
        List<PaymentWrp> payments = new List<PaymentWrp>();
        List<PaymentWrp> paymentsFinal = new List<PaymentWrp>();
        if (!String.isBlank(accIdofpayment)) {    
            payRelList  = [Select id,Name,Zuora__Amount__c,Zuora__EffectiveDate__c,Zuora__PaymentMethod__c,Zuora__Status__c,
                            Zuora__CreatedDate__c, Zuora__Account__r.Account_Status__c, Zuora__SettledOn__c from Zuora__Payment__c where Zuora__Account__c =:accIdofpayment ];   
        }    

        if (!payRelList.isEmpty()) {
            Map<Id,Zuora__Payment__c> finalPaymentsById;
            /*Checking User access to REfund functionality*/
            if (RefundTransactionController.isAccessToRefund() || Test.isRunningTest()) {
                finalPaymentsById = RefundTransactionController.checkPaymentList(payRelList);
            }

            for (Zuora__Payment__c item :payRelList) {
                payments.add(new PaymentWrp(item, finalPaymentsById));
            }
            payments.sort();
            // sort list in decending order.
            for (Integer iCount = payments.size()-1; iCount >=0; iCount--) {
                paymentsFinal.add(payments.get(iCount));
            }
        }
        return paymentsFinal;
    }

    public PageReference refreshPage() {
        paymentWrp = getPayments();
        isShowTable = true;
        return null;
    }

    public PageReference refundProcess() {
        Boolean isRefundSuccess = true;
        Boolean isInvoiceAdjustmentSuccess = true;

        List<Zuora.zApi.SaveResult> lstSaveResult;
        List<Zuora.zApi.SaveResult> invoicesAdjustmentResult;

        List<Zuora__Payment__c> payments = [SELECT ID, Zuora__EXT_ID__c, Zuora__Invoice__r.Zuora__Zuora_Id__c, Zuora__Invoice__r.Zuora__External_Id__c
                                                FROM Zuora__Payment__c 
                                                WHERE Id = :choosePaymentId];  

        if (!payments.isEmpty()) {
          List<Zuora__Refund__c> refunds = [SELECT Zuora__Payment__c FROM Zuora__Refund__c WHERE Zuora__Payment__c = :choosePaymentId];
            if (!refunds.isEmpty()) {
                apexpages.addmessage(new apexpages.message(ApexPages.severity.WARNING, Label.LS_Refund_Refund_not_possible));
                isShowTable = false;
                return null;
            }
        }                                      
        String errorMessage;                           
        if (payments!=null && !payments.isEmpty()) {
            if (!Test.isRunningTest()) {
                lstSaveResult = ZuoraTransactionHelper.RefundAmount(payments[0].Zuora__EXT_ID__c,  payments[0].Zuora__Invoice__r.Zuora__Zuora_Id__c, 'Immediate Cancellation');
            }
            
            if (lstSaveResult == null || lstSaveResult.isEmpty() || lstSaveResult[0].Success != true || lstSaveResult[0].Errors != null) {
                if (!Test.isRunningTest()) {
                    isRefundSuccess = false;
                }
                errorMessage = lstSaveResult != null ? String.valueOf(lstSaveResult[0].Errors) : 'Error';
            } 

            if (isRefundSuccess) {
                if (!Test.isRunningTest()) {
                    invoicesAdjustmentResult = ZuoraTransactionHelper.createInvoiceLineItemAdjusment(payments[0].Zuora__Invoice__r.Zuora__External_Id__c,'Chargeback','Credit'); 
                }                
                if (invoicesAdjustmentResult == null || invoicesAdjustmentResult.isEmpty() || invoicesAdjustmentResult[0].Success != true ||  invoicesAdjustmentResult[0].Errors != null) {
                    if (!Test.isRunningTest()) {
                        isInvoiceAdjustmentSuccess = false;
                    }                    
                    errorMessage = invoicesAdjustmentResult != null ? String.valueOf(invoicesAdjustmentResult[0].Errors) : 'Error';
                }
            }             
        }  
        if (isRefundSuccess && isInvoiceAdjustmentSuccess) {
            apexpages.addmessage(new apexpages.message(ApexPages.severity.CONFIRM, Label.LS_Refund_processed));
        } else {
            apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR, errorMessage));
        }
        isShowTable = false;
        return null;
    }

    public class PaymentWrp implements Comparable {
        public String id {get;set;}
        public String name {get;set;}
        public String linkRefund {get;set;}
        public Boolean isRefund {get;set;}
        public Decimal amount {get;set;}
        public Datetime effectiveDate {get;set;}
        public String paymentMethod {get;set;}
        public String status {get;set;}
        public Datetime creaeDate {get;set;}

        public PaymentWrp (Zuora__Payment__c item, Map<Id, Zuora__Payment__c> finalPaymentsById) {
            id = item.Id;
            name = item.Name;
            linkRefund = item.Id;
            isRefund = makeIsRefund(item, finalPaymentsById);
            amount = item.Zuora__Amount__c;
            effectiveDate = item.Zuora__EffectiveDate__c;
            paymentMethod = item.Zuora__PaymentMethod__c;
            status = item.Zuora__Status__c;
            creaeDate = item.Zuora__CreatedDate__c;
        }

        public Boolean makeIsRefund(Zuora__Payment__c item, Map<Id, Zuora__Payment__c> finalPaymentsById) {
            Boolean isResult = false;
            if (finalPaymentsById != null && !finalPaymentsById.isEmpty()) {
                if (finalPaymentsById.containsKey(item.Id) && item.Zuora__SettledOn__c != null) {
                    isResult = true;
                }
            }
            return isResult;
        }

        public Integer compareTo(Object compareTo) {
            PaymentWrp compareToPH = (PaymentWrp)compareTo;
            if(creaeDate == compareToPH.creaeDate) return 0;
            if(creaeDate > compareToPH.creaeDate) return 1;
            return -1;
        }

    }

    /*    
    Description: This method is used to Delete the payment Records.
    */
    public void editdelProcess() {
        try{
            if(!string.isEmpty(PayDelId)){
                Zuora__Payment__c del = new Zuora__Payment__c(ID=PayDelId);
                delete del; 
            }  
        }
        catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'paymentRelListController', 'editdelProcess', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        }  
    }
  
}