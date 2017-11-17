global with sharing class RefundTransactionController {
    
    webservice static String refundTransaction(Id paymentId) {
        String result;
        result = refundAmount(paymentId);
        return result;
    }

    public static String refundAmount(String paymentId) {
        String result = 'not';
        List<Zuora__Payment__c> payment = [SELECT ID, Zuora__EXT_ID__c, Zuora__Account__c  
                                            FROM Zuora__Payment__c WHERE Id = : paymentId];
        
        if (!payment.isEmpty()) {
                    
            List<Zuora__Refund__c> refunds = [SELECT Zuora__Payment__c FROM Zuora__Refund__c WHERE Zuora__Payment__c = :payment[0].Id];

            if (refunds.isEmpty()) {
                result = EncodingUtil.urlDecode('/apex/CancelSubscription?Id=' + payment[0].Zuora__Account__c + '&refundPayment=' + payment[0].Id,'UTF-8');
            } else {
                result = Label.LS_Refund_already_in_process;
            }
        }
        
        return result;
    }

    public static Map<Id,Zuora__Payment__c> checkPaymentList(List<Zuora__Payment__c> payments) {
        Map<String,Zuora__Refund__c> refundAfterStatus = new Map<String,Zuora__Refund__c>();
        Map<Id,Zuora__Payment__c> paymentsAfterStatus = new Map<Id,Zuora__Payment__c>();

        Map<Id,Zuora__Payment__c> finalPayments = new Map<Id,Zuora__Payment__c>();

        for (Zuora__Payment__c item :payments) {
            paymentsAfterStatus.put(item.Id, item);
        }
        /*Checking Payment in Refund object*/
        if (!paymentsAfterStatus.isEmpty()) {
            List<Zuora__Refund__c> refunds = [SELECT Zuora__Payment__c FROM Zuora__Refund__c WHERE Zuora__Payment__c IN :paymentsAfterStatus.keySet()];

            if (!refunds.isEmpty()) {
                for (Zuora__Refund__c item :refunds) {
                    refundAfterStatus.put(item.Zuora__Payment__c, item);
                }

                for (Zuora__Payment__c item :paymentsAfterStatus.values()) {
                    if (!refundAfterStatus.containsKey(item.id)) {
                        finalPayments.put(item.Id, item);
                    }
                }
            } else {
                return paymentsAfterStatus;
            }
        }
        return finalPayments;
    }

    webservice static Boolean isAccessToRefundWeb() {
        return isAccessToRefund();
    }

    public static Boolean isAccessToRefund() {
        Boolean isResult = false;
        
        Map<Id,CustomPermission> customPermissions = new Map<Id,CustomPermission>([SELECT Id, DeveloperName FROM CustomPermission WHERE DeveloperName = 'Refund_Transaction']);
        List<SetupEntityAccess> setupEntities =  [SELECT SetupEntityId, SetupEntityType FROM SetupEntityAccess WHERE SetupEntityId IN :customPermissions.keySet() AND  ParentId IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId())];

        if (!Test.isRunningTest()) {
            if (!setupEntities.isEmpty()) {  isResult = true;  }
        } else {
            List<PermissionSet> pr = [SELECT Id from PermissionSet WHERE Name = 'Refund_TransactionTest'];
            if (!pr.isEmpty()) {
                List<PermissionSetAssignment> prAssignment = [SELECT PermissionSetId 
                                                                    FROM PermissionSetAssignment 
                                                                    WHERE AssigneeId = :UserInfo.getUserId() 
                                                                            AND PermissionSetId = :pr[0].Id];
                if (!prAssignment.isEmpty()) {
                    isResult = true;
                }
            }
            
        }

        return isResult;
    }

}