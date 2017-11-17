/**
* @author Cognizant Technology Solutuions
* @date 01/05/2016
* @description AuthCallout  class to get response from Json and display on PartnerAndPromotion page.
*/
global with sharing class AuthCallout {
    public string accountId;
    public AuthCallout (){
    accountId = Apexpages.currentPage().getParameters().get('id');
    }
    public list<AvailblePrmotionCode> lstOfAvailblePrmotionCode{get;set;}  
    public String codeForAvaObj {get;set;}  
    public Summary[] Summaries { get; set; }
    DAZNConfiguration__c daznendPoint = DAZNConfiguration__c.getValues('zuoraEndPointUrl') ;
    DAZNConfiguration__c daznClientId = DAZNConfiguration__c.getValues('zuoraClientId') ;
    DAZNConfiguration__c daznenPromos = DAZNConfiguration__c.getValues('zuoraPromos') ;
    DAZNConfiguration__c daznAuthHeader = DAZNConfiguration__c.getValues('authorizationHeaderValue') ;
    String endpoint = daznendPoint.Value__c ;
    String clientId = daznClientId.Value__c ;
    String promos = daznenPromos.Value__c ;
    String authorizationHeader = daznAuthHeader.Value__c  ;
    /*get the response from the Endpoint*/
    public void basicAuthCallout(){
        List<ResultClass> results = new List<ResultClass>();
         try
        {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint+clientId+promos);
        req.setMethod('GET');        
        req.setHeader('Authorization', authorizationHeader);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        ResultClass ResponseObj= (ResultClass)JSON.deserialize(res.getbody(),ResultClass.class);
            responseViewer(ResponseObj);  
        }     
     catch (exception e){
         system.debug('exe'+e);
         }
        
    }
    
    /*deserialize the response and get the required information */
    public void responseViewer(ResultClass ResponseObj){
    lstOfAvailblePrmotionCode = new list<AvailblePrmotionCode>(); 
    set<string> setOfTids = new set<string>();
        for(Data dataObj : ResponseObj.data){
            if(dataObj.effectiveFrom != null && dataObj.effectiveTo != null){
                string strEffFrom = dataObj.effectiveFrom.split('T')[0];
                string strEffTo = dataObj.effectiveTo.split('T')[0];  
                Date dtEffFrom = returnDate(strEffFrom);
                Date dtEffTo   = returnDate(strEffTo);  
                if(dtEffFrom <= Date.Today() && dtEffTo >= Date.Today()){  
                         AvailblePrmotionCode jsonCodeIds = new AvailblePrmotionCode();    
                        jsonCodeIds.TID = dataObj.code;
                        setOfTids.add(jsonCodeIds.TID);    
                }
            }      
        }  
        list<Zuora__Subscription__c> actZuoraIds = [Select TrackingID__c from Zuora__Subscription__c where TrackingID__c IN : setOfTids AND Zuora__Status__c= 'Active' AND Zuora__Account__c =:accountId];
        if(actZuoraIds != null && !actZuoraIds.isEmpty()){      
            for (Zuora__Subscription__c strId : actZuoraIds){
                codeForAvaObj = (String) strId.TrackingID__c;
                    for (Data dataObj : ResponseObj.data){
                        if(codeForAvaObj  == dataObj.code){
                        AvailblePrmotionCode availObj = new AvailblePrmotionCode(); 
                        availObj.TID = dataObj.code;
                        availObj.ClientID = clientId;  
                          if(dataObj.CustomFields != null && dataObj.CustomFields.countryid != null){
                                availObj.Country = dataObj.CustomFields.countryid.value; 
                            }                            
                            if(dataObj.CustomFields != null && dataObj.CustomFields.platformid != null){
                                availObj.PlatFormId = dataObj.CustomFields.platformid.value;
                            }
                            if(dataObj.CustomFields != null && dataObj.CustomFields.manufactureid != null){
                                availObj.manufactureid = dataObj.CustomFields.manufactureid.value;
                            }
                            availObj.PromotionType = dataObj.campaign;
                            list<string> lstOfExlUsers = new list<string>();                            
                            if(dataObj.CustomFields != null && dataObj.CustomFields.frozenuser != null){
                                if(dataObj.CustomFields.frozenuser.value == '0'){
                                    lstOfExlUsers.add('frozenuser');
                                }
                            }   
                            if(dataObj.CustomFields != null && dataObj.CustomFields.expireduser != null){
                                if(dataObj.CustomFields.expireduser.value == '0'){
                                    lstOfExlUsers.add('expireduser');
                                }
                            }
                            if(dataObj.CustomFields != null && dataObj.CustomFields.partialuser != null){
                                if(dataObj.CustomFields.partialuser.value == '0'){
                                    lstOfExlUsers.add('partialuser');
                                }
                            }
                            if(dataObj.CustomFields != null && dataObj.CustomFields.activepaiduser != null){
                                if(dataObj.CustomFields.activepaiduser.value == '0'){
                                    lstOfExlUsers.add('activepaiduser');
                                }
                            }
                            if(dataObj.CustomFields != null && dataObj.CustomFields.activegraceuser != null){
                                if(dataObj.CustomFields.activegraceuser.value == '0'){
                                    lstOfExlUsers.add('activegraceuser');
                                }
                            }
                            if(dataObj.CustomFields != null && dataObj.CustomFields.freetrialuser != null){
                                if(dataObj.CustomFields.freetrialuser.value == '0'){
                                    lstOfExlUsers.add('freetrialuser');
                                }
                            }
                            if(dataObj.CustomFields != null && dataObj.CustomFields.newusers != null){
                                if(dataObj.CustomFields.newusers.value == '0'){
                                    lstOfExlUsers.add('newusers');
                                }
                            }
                        availObj.lstOfExclusiveUsers = lstOfExlUsers;
                        lstOfAvailblePrmotionCode.add(availObj);
                    }     
                }  
            
                }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.label.LS_AuthCallOut_No_Promotions));
        }
        
        List<AggregateResult> ResultofPromo = new List<AggregateResult>();
        ResultofPromo = [Select Count(Id) id from Zuora__Subscription__c where TrackingID__c IN :setOfTids] ;
        Summaries = new List<Summary>();
        for(AggregateResult ar : ResultofPromo) {   
            Summaries.add(new Summary(ar));
            }   
    }
    
    public class ResultClass{
        public List<Data> data {get;set;} 
    }
    
    public class Summary {
        public Integer Quantity { get; private set; }
        public Summary(AggregateResult ar) {
            Quantity = (Integer) ar.get('id');
        }
        
    }
    
    public class Data{
        public String code {get;set;} 
        public String campaign {get;set;} 
        public String effectiveFrom {get;set;} 
        public String effectiveTo {get;set;} 
        public CustomFields customFields {get;set;} 
        
    }
    
    public class CustomFields {
        public dataValue  platformid {get;set;} 
        public dataValue  manufactureid {get;set;} 
        public dataValue  countryid {get;set;} 
        public dataValue  frozenuser {get;set;} 
        public dataValue  expireduser {get;set;} 
        public dataValue  partialuser {get;set;} 
        public dataValue  activepaiduser {get;set;} 
        public dataValue  activegraceuser {get;set;} 
        public dataValue  freetrialuser {get;set;}
        public dataValue  newusers {get;set;}
    }
    
    public class dataValue  {
        public String value {get;set;} 
    }
    
    Date returnDate(string strDate){
        integer year;
        integer month;
        integer intdate;        
        year    = integer.valueOf(strDate.split('-')[0]);
        month   = integer.valueOf(strDate.split('-')[1]);
        intdate = integer.valueOf(strDate.split('-')[2]);        
        return date.newinstance(year, month, intdate);
    }
    
    public class AvailblePrmotionCode{
        public string TID{get;set;}
        public string ClientID{get;set;}
        public string Country{get;set;}
        public string PlatFormId{get;set;}
        public string manufactureid{get;set;}
        public string PromotionType{get;set;}
        public string UsersOnPromotion{get;set;}
        public list<string> lstOfExclusiveUsers{get;set;}
    }    
    webservice static Boolean checkCsAgentprofile(Id ProfileId){
        string strAnonymousUseProfileName;
        Boolean result ;
        Profile oUserProfile = [SELECT Id, Name from Profile where ID =: ProfileId ];
        String strProfName = oUserProfile.Name ;
        DAZNConfiguration__c oDAZNConfiguration = DAZNConfiguration__c.getValues('CS_Agents_Profiles');
        strAnonymousUseProfileName = oDAZNConfiguration.Value__c;
        string[] strProfile = strAnonymousUseProfileName.split(',');
        for(String s1 : strProfile)
        {
            result = s1.contains(strProfName);
            if(result){
                break;
            }
        }
        return result ;
    }   
}