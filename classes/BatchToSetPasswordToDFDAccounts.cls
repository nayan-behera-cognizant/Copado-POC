/* @author Cognizant Technology Solutuions
* @date 01/06/2017
* Description : Batch class to set passwords for DFD accounts and DFD users based on UserFeed object updated records
* 1. Get all userfeed records where Partner_Registration_status__c is Complete and Account_Status__c is Active Paid
* 2. Set the Password to Users  
*/
global class BatchToSetPasswordToDFDAccounts implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc ){
        return Database.getQueryLocator([Select id,First_Name__c,Last_Name__c,BillingCountryCode__c,Email_Preferences__c,Secondary_Email__c,Account_Status__c,Partner_Registration_status__c,Partner_Id__c,
                                         CurrencyIsoCode,LanguageLocaleKey__c,EmailEncodingKey__c,LocaleSidKey__c,TimeZoneSidKey__c,Auth_Key__c,User_Type__c,
                                         CommunityNickname__c,Alias__c,Status__c,Email__c,UserId__c,AccountId__c,Num_Retries__c,Request_Type__c,IP_address__c,DAZN_Id__c,Account_Type__c,ViewerId__c,Is_Password_Set__c
                                         from DAZNUserFeed__c where Is_Password_Set__c = false and (UserId__c != null or AccountId__c != null) AND Partner_Registration_status__c ='Complete']);
    }
    
    global void execute(Database.BatchableContext bc, List<DAZNUserFeed__c> userFeedRecordsList){
       string custvalue = DocomoConfiguration__c.getValues('Default Password').Value__c;
        blob bPassword = EncodingUtil.base64Decode(custvalue);
        string passWordvalue = bPassword.toString();
        set<string> ViewerIdSet = new set<string>(); //to store viewerIds
        List<DAZNUserFeed__c> userFeedLst = new List<DAZNUserFeed__c>();//to store the users whose password is updated
        try{
        if(userFeedRecordsList != null && userFeedRecordsList.size() > 0){
            //to iterate over userfeed list
            for(DAZNUserFeed__c oDaznUser : userFeedRecordsList){
                ViewerIdSet.add(oDaznUser.ViewerId__c);
                oDaznUser.Is_Password_Set__c = true;
                userFeedLst.add(oDaznUser);
            }
        }
        
        /* List to get the users to set the password */
        List<User> passowordUpdateUsrList = [Select id, Name,ViewerId__c from User where ViewerId__c =: ViewerIdSet];
        //to check if list is null or not
        if(passowordUpdateUsrList != null && passowordUpdateUsrList.size() > 0){
            for(User usr: passowordUpdateUsrList){
                System.setPassword(usr.Id,passWordvalue);
               } 
        }
        
        //to check if list is null or not
        if(userFeedLst != null && userFeedLst.size() > 0){
            update userFeedLst;
        }
    }catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'BatchToSetPasswordToDFDAccounts', 'execute', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        }
    }
    
    global void finish(Database.BatchableContext bc){   
        
    }
    
}