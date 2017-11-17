/**
* @author Cognizant Technology Solutuions
* @date 13/02/2017
* @description Batch Class to update communicator with the updated hard offer accounts in salesforce.
*/
global class docomoDailyBatchToUpdPartnerRdytoSync implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
    Map<Id,String> mapAccountIdAndPartnerId = new Map<Id,String>();
    Integer limSize = integer.valueof(Label.LimitSize);
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([select id,Partner_ID__c,Partner_Ready_to_Sync__c from Account where  Partner_Ready_to_Sync__c = true and Type = 'Docomo' and Partner_ID__c != null LIMIT : limSize]);
        
    }

    global void execute(Database.BatchableContext bc, List<Account> acclist ){
        system.debug('acclist===>'+acclist);
        String assgnDocomo = '1';
        for(Account acc : acclist){
            if(acc.Partner_Ready_to_Sync__c == False){
                    assgnDocomo = '0';//Just for checking purpose
            }
            string partnerValue = acc.Partner_ID__c +','+ assgnDocomo;
            mapAccountIdAndPartnerId.put(acc.Id,partnerValue);
        }
    }
                     
    global void finish(Database.BatchableContext bc){
        list <Account> accLsit = new list<Account>();
        list <Account> updateAccLsit = new list<Account>();
        /*Start PD-14478*/
        String dfdBulkEndPoint = (DAZNConfiguration__c.getValues('DFD_BulkEndPoint') != null) ? DAZNConfiguration__c.getValues('DFD_BulkEndPoint').Value__c : null;
        /*End PD-14478*/
        String bodyValue = 'siteId=DAZN4docomo'+'\r\n'
            +'magaId=DZN000000001'+'\r\n'           
            +'flg=1'+ '\r'+'\n'+'\r'+'\n';
            
    if(mapAccountIdAndPartnerId != null && mapAccountIdAndPartnerId.keySet().size()>0){
            for(String str: mapAccountIdAndPartnerId.values()){
                bodyValue = bodyValue + str+'\r\n';
            }
        }
        try {
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                req.setHeader('content-type', 'text/plain;charset=utf-8');
                req.setHeader('HOST', Label.DFD_HOST);
                req.setHeader('PORT',  Label.DFD_PORT);        
                req.setHeader('Content-Length',Label.DFD_BulkContentLengh);            
                req.setEndpoint(/*Label.DFD_BulkEndPoint*/dfdBulkEndPoint);
                req.setBody(bodyValue);
                req.setTimeout(120000);
                HttpResponse res = http.send(req);
                Map<String, Object> mapOfResponseObj= (Map<String, Object>)JSON.deserializeUntyped(res.getbody());
                String detailsObject = ( String)mapOfResponseObj.get('result');  // Converting string from Json 
                if( mapAccountIdAndPartnerId.keySet().size()>0){           
                    accLsit = [SELECT id,Partner_Ready_to_Sync__c,Partner_Sync_Error__c from Account where  id =:mapAccountIdAndPartnerId.keySet() ];               
                }   
                if(accLsit.size()>0){//Checking the Account List based on scope Ids
                    for (Account acc : accLsit){ 
                        if(detailsObject == '000'){// Checking the Success response
                            acc.Partner_Ready_to_Sync__c = False;    
                            updateAccLsit.add(acc);                           
                        }
                        else{
                            acc.Partner_Sync_Error__c = detailsObject ;
                            acc.Partner_Ready_to_Sync__c = False;                           
                            updateAccLsit.add(acc);
                        }                       
                    }             
                }   
                if(updateAccLsit.size()>0){
                    Database.update (updateAccLsit);// Updated the scope of account in batch based on response 
                }
            }  
        catch (exception ex){
             ExceptionLoggerHelper.createExceptionLog(userinfo.getUserId(), 'docomoDailyBatchToUpdPartnerRdytoSync', 'docomoDailyBatchToUpdPartnerRdytoSync', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            }
            
        }
        
    

}