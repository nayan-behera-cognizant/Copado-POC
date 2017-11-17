/**
* @author Cognizant Technology Solutuions
* @date 01/05/2016
* @description The SelectOptionController for giving the months of discount
*/

global with sharing class SelectOptionController {
    public List<SelectOption> discountLst {get;set;}
    public String selectedMonth{get;set;}
    public string accountId {get;set;}
    public list<User> userList{get;set;}
    public String selectedValues {get;set;}
    public boolean flagForRecord{ get; set; }
    public list<Zuora__Subscription__c> zuoraList ;
    String SubscriptionId;    
    
    
    public SelectOptionController(){
    flagForRecord = false;
        accountId = Apexpages.currentPage().getParameters().get('id');
        discountLst = new List<SelectOption>();
        discountLst.add(new SelectOption(System.label.LS_Discount_No_ONE,System.label.LS_Discount_No_ONE));
    }
    /*
        Description: Method to give the Discount Information,create respective task and update teh productdata info in Zuora.
    */
    public pageReference submit(){
       Zuora.zApi.AmendResult amendResultCheck;
       flagForRecord = true;
       userList = new list<User>();
       if(!String.isBlank(accountId)){
        userList = [SELECT id,Name FROM User Where AccountID =:accountId ];
       }
       if(userList!=null & !userList.isEmpty()){
         selectedValues =  System.label.LS_Discount_The_User +'   '+userList[0].Name+'   '+ System.label.LS_Discount_has_been_given +'  '+ selectedMonth +'  '+System.label.LS_Discount_month_s_free_access;
       }
       if(accountId != null & !String.isBlank(accountId) ){
       zuoraList = [SELECT Zuora__External_Id__c,Zuora__Account__c,Zuora__Status__c From Zuora__Subscription__c where Zuora__Account__c =:accountId AND Zuora__Status__c = 'Active' LIMIT 1 ];       
       }
       if(zuoraList != null  && !zuoraList.isEmpty()){       
          SubscriptionId = zuoraList[0].Zuora__External_Id__c;
          }
       String sEffectiveDate= ((DateTime)system.today()).format('yyyy-MM-dd');           
       amendResultCheck= ZuoraTransactionHelper.newProductUpdate(SubscriptionId,sEffectiveDate,false,selectedMonth);    
       if(!String.isBlank(accountId) && userList!=null & !userList.isEmpty() && !String.isBlank(selectedValues) && amendResultCheck != null){
       //Task Creation
        Task newTask =New Task();
            newTask.WhatID = accountId;
            newTask.Ownerid =userList[0].id;
            newTask.Subject = System.label.LS_Discount_Discount_Related_To +'  '+userList[0].Name ;
            newTask.description = selectedValues ;
            newTask.ActivityDate = Date.today();
            newTask.Status = System.label.LS_Discount_Completed; 
            newTask.Priority = System.label.LS_Discount_Normal;
            insert newTask ; 
            }
      return null;
     }
    /*
        Description: Method to Check the Role is having CS_ShiftLeads_Roles or not.
    */
    webservice static Boolean checkRoleForCSLeads(Id RoleId){
        string strAnonymousUserRoleName;
        Boolean result ;
        UserRole oUserRole = [SELECT Id, Name from UserRole where ID =: RoleId ];
        String strRoleName = oUserRole.Name ;
        DAZNConfiguration__c oDAZNConfiguration = DAZNConfiguration__c.getValues('CS_ShiftLeads_Roles');
        strAnonymousUserRoleName = oDAZNConfiguration.Value__c;
        string[] strRoles = strAnonymousUserRoleName.split(',');
        for(String s1 : strRoles)
        {
            result = s1.contains(strRoleName);
            if(result){
                break;
            }
        }
        return result ;
    }

}