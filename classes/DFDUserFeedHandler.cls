/****************************************************************************************************
* @author Cognizant Technology Solutuions
* @date 11/21/2016
* @description DFDUserFeedHandler class is used to insert Account and user records based on user feed object. 
History
================
Version     Date            Author                  Reason
-------     ----------      ------------------      ------------------
1.0         11/21/2016       CTS                     Initial version

******************************************************************************************************/
Public class DFDUserFeedHandler  {
    public static List<DAZNUserFeed__c> userFeedToUpdate = new List<DAZNUserFeed__c>();//to store userfeed details
    Public static Map<String,Id> accsucceedEmailMap = new Map<String,Id>();//to store successfully inserted account personal email and account id
    Public static Map<String,DAZNUserFeed__c> DAZNFldAnduserFeedMap = new Map<String,DAZNUserFeed__c>();//to store successfully inserted account personal email and account id
    Public static Map<String,DAZNUserFeed__c> ViewerIdAnduserFeedMap = new Map<String,DAZNUserFeed__c>();//to store successfully inserted account personal email and account id
    Public static Schema.SObjectField accDAZNFld = Account.Fields.DAZN_Id__c;
    Public static Schema.SObjectField usrViewerld = User.Fields.ViewerId__c;
    Public static Set<string> accountDAZNIDsSet = new Set<string>();// store updated userfeed account details
    Public static Set<String> accDAZNIDSet = new Set<String>();
    Public static Set<String> usrViewrIDSet = new Set<String>();
    Public static List<Account> lstAccountExisiting;
    Public Static DAZNUserFeed__c daznUserFeedObj;
    /******************************************************************************
@Method Name: prepareAccountsToInsert
@Method Description: Method to prepare the accounts insert the Accounts
@Param:List of DAZNUserFeed__c 
******************************************************************************/
    public static void prepareAccountsToInsert(List<DAZNUserFeed__c> lstUserFeed){
        List<Account> accountsToInsert = new List<Account>();//this list is used to add accounts that are to be inserted
        Map<string, Account> mapOfAccountIdandAccount = new Map<string, Account>();
        Map<string, Account> mapOfBlockedAccountIdandAccount = new Map<string, Account>();		
        list<DAZNUserFeed__c>  userAccUserNull= new list<DAZNUserFeed__c>();//PD-11100
        list<string> ActfirstNLastNames = label.Account_First_and_Last_Name.split(',');// As Part of PD-11206 
        // Get Person Record Type ID.
        Id PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('DFD Customer').getRecordTypeId();
        //iterate over the userfeedlist
        if(lstUserFeed != null && lstUserFeed.size()>0){
            try {
                for(DAZNUserFeed__c usrFeedRec : lstUserFeed){
                    if(usrFeedRec.DAZN_Id__c != null){
                        accDAZNIDSet.add(usrFeedRec.DAZN_Id__c);
                    }
                    if(usrFeedRec.ViewerId__c != null){
                        usrViewrIDSet.add(usrFeedRec.ViewerId__c);
                    }
                }
                if(accDAZNIDSet!= null && accDAZNIDSet.size()>0){
                    lstAccountExisiting = new List <Account>([select Id,FirstName,LastName,DFD_First_Name__c,DFD_Last_Name__c,PersonEmail,BillingCountryCode,Notification_Country_Code__c,Notification_Language_Code__c,All_Email_Preferences__c,
                                                              Secondary_Email__c,Account_Status__c,Partner_Registration_Status__c,Partner_ID__c,AuthKey__c,DAZN_Id__c from Account where DAZN_Id__c in:accDAZNIDSet LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())]);
                }
                if(lstAccountExisiting != null && lstAccountExisiting.size() >0){
                    for(Account accValue : lstAccountExisiting){
                        mapOfAccountIdandAccount.put(accValue.DAZN_Id__c, accValue);
                        
                        /*Added as part of PD-11515*/
                        if(accValue.Account_Status__c == 'Blocked'){
                            mapOfBlockedAccountIdandAccount.put(accValue.DAZN_Id__c, accValue); //Retrieving existing blocked accounts into a map
                        } //End of PD-11515
                    } 
                }
                
                /*Added as part of PD-11515*/
                for(DAZNUserFeed__c oldUsrFeed : lstUserFeed){
                    DAZNUserFeed__c newUsrFeed = new DAZNUserFeed__c();
                    newUsrFeed.ID = oldUsrFeed.ID;
                    newUsrFeed.DAZN_Id__c = oldUsrFeed.DAZN_Id__c;
                    newUsrFeed.ViewerId__c = oldUsrFeed.ViewerId__c;
                    if(newUsrFeed.DAZN_Id__c != null && newUsrFeed.ViewerId__c != null && mapOfBlockedAccountIdandAccount !=null && mapOfBlockedAccountIdandAccount.size()>0 && mapOfBlockedAccountIdandAccount.containsKey(newUsrFeed.DAZN_Id__c)){
                        newUsrFeed.Status__c = 'Successful';
                        userFeedToUpdate.add(newUsrFeed);
                    }
                } /* End of PD-11515*/
                
                
                for(DAZNUserFeed__c usrFeed : lstUserFeed){ 
                    daznUserFeedObj = usrFeed;
                    // To check if the account is a new one or a retry account
                    if(usrFeed.DAZN_Id__c != null && usrFeed.ViewerId__c != null  && mapOfAccountIdandAccount.containsKey(usrFeed.DAZN_Id__c)){
                        
                        /*Added as part of PD-11515*/
                        if(mapOfAccountIdandAccount.get(usrFeed.DAZN_Id__c).Account_Status__c =='Blocked'){
                            break;
                        } /*End of PD-11515*/
                        
                       if(usrFeed.DAZN_Id__c == mapOfAccountIdandAccount.get(usrFeed.DAZN_Id__c).DAZN_Id__c ){
                            Account oAccount = new Account();
                            oAccount.Id = mapOfAccountIdandAccount.get(usrFeed.DAZN_Id__c).Id;
                            if(usrFeed.First_Name__c != null){
                                oAccount.DFD_First_Name__c = usrFeed.First_Name__c;// As Part of PD-11206
                                //oAccount.FirstName = ActfirstNLastNames[0];
                            }
                            if(usrFeed.Last_Name__c != null){
                                oAccount.DFD_Last_Name__c = usrFeed.Last_Name__c;// As Part of PD-11206
                                //oAccount.LastName = ActfirstNLastNames[1];
                                
                            }
                            if(usrFeed.BillingCountryCode__c != null){
                                oAccount.BillingCountryCode  = usrFeed.BillingCountryCode__c;
                            }
                            if(usrFeed.LanguageLocaleKey__c != null){
                                oAccount.Notification_Language_Code__c = usrFeed.LanguageLocaleKey__c; //PD-11100
                            }
                            if(usrFeed.BillingCountryCode__c != null){
                                oAccount.Notification_Country_Code__c  = usrFeed.BillingCountryCode__c; //PD-11100
                            }
                            if(usrFeed.Secondary_Email__c!= null){
                                oAccount.Secondary_Email__c = usrFeed.Secondary_Email__c;
                            }
                            if(usrFeed.Account_Status__c!= null){
                                
                                oAccount.Account_Status__c = usrFeed.Account_Status__c;
                                if(usrFeed.Account_Status__c == 'Frozen'){
                                    oAccount.Cancelled_Account__c = true;  
                                }
                            }
                            if(usrFeed.Partner_Registration_status__c!= null){
                                oAccount.Partner_Registration_Status__c = usrFeed.Partner_Registration_status__c;
                            }
                            if(usrFeed.Partner_Id__c!= null){
                                oAccount.Partner_ID__c = usrFeed.Partner_Id__c;
                            }
                            if(usrFeed.DAZN_Id__c!= null){
                                oAccount.DAZN_Id__c = usrFeed.DAZN_Id__c;
                            }
                            if(usrFeed.Email__c != null){
                                oAccount.PersonEmail = usrFeed.Email__c;
                            }
                            if(usrFeed.User_Type__c != null){
                                oAccount.Type = usrFeed.User_Type__c;
                            }
                           
                           /*Added as part of PD-11569*/
                           if(usrFeed.Subscription_Start_Date__c != null){
                                oAccount.Subscription_Date__c = usrFeed.Subscription_Start_Date__c;
                            }
                           if(usrFeed.Subscription_End_Date__c != null){
                                oAccount.Next_Charge_Date__c = usrFeed.Subscription_End_Date__c;
                            } 
                           //oAccount.Partner_Ready_to_Sync__c = true; //PD-12531
                           //End of PD-11569
                           
                            //oAccount.All_Email_Preferences__c = true; //PD-11100
                            accountsToInsert.add(oAccount);
                             DAZNFldAnduserFeedMap.put(usrFeed.DAZN_Id__c, usrFeed);
                              
                        }
                        
                    }
                    else if(usrFeed.DAZN_Id__c != null && usrFeed.ViewerId__c != null ){
                        
                        // Create Account
                        Account oAccount = new Account();
                        if(usrFeed.First_Name__c != null ){
                            oAccount.DFD_First_Name__c = usrFeed.First_Name__c;// As Part of PD-11206
                            oAccount.FirstName = ActfirstNLastNames[0];// As Part of PD-11206
                            
                        }else{
                            oAccount.DFD_First_Name__c = 'DFD Docomo'; // Added code part of PD-11141
                            oAccount.FirstName = ActfirstNLastNames[0];// As Part of PD-11206
                        }
                        if(usrFeed.Last_Name__c != null){
                            oAccount.DFD_Last_Name__c = usrFeed.Last_Name__c;  // As Part of PD-11206                                          
                            oAccount.LastName = ActfirstNLastNames[1];     // As Part of PD-11206                                       
                        }else if(usrFeed.Partner_Id__c != null){
                            oAccount.LastName = ActfirstNLastNames[1]; // Added code part of PD-11141
                        }
                        if(usrFeed.Secondary_Email__c != null){
                            oAccount.Secondary_Email__c = usrFeed.Secondary_Email__c;
                        }
                        if(usrFeed.Email__c != null){
                            oAccount.PersonEmail = usrFeed.Email__c;
                        }
                        if(usrFeed.BillingCountryCode__c!= null){
                            oAccount.BillingCountryCode  = usrFeed.BillingCountryCode__c;
                        }
                        if(usrFeed.LanguageLocaleKey__c != null){
                            oAccount.Notification_Language_Code__c = usrFeed.LanguageLocaleKey__c;//PD-11100
                        }else
                        {
                            oAccount.Notification_Language_Code__c = 'ja'; //PD-11100
                        }
                        if(usrFeed.BillingCountryCode__c != null){
                            oAccount.Notification_Country_Code__c  = usrFeed.BillingCountryCode__c;//PD-11100
                        }else{
                            oAccount.Notification_Country_Code__c = 'JP'; //PD-11100
                        }
                        if(PersonRecordTypeId!= null){
                            oAccount.RecordTypeId = PersonRecordTypeId;
                        }
                        if(usrFeed.Account_Status__c!= null){
                            oAccount.Account_Status__c = usrFeed.Account_Status__c;
                        }
                        if(usrFeed.Partner_Registration_status__c!= null){
                            oAccount.Partner_Registration_Status__c = usrFeed.Partner_Registration_status__c;
                        }else{
                            oAccount.Partner_Registration_Status__c = 'Incomplete';  //PD-11100 
                        }
                        if(usrFeed.Partner_Id__c!= null){
                            oAccount.Partner_ID__c = usrFeed.Partner_Id__c;
                        }
                        if(usrFeed.Auth_Key__c!= null){
                            oAccount.AuthKey__c = usrFeed.Auth_Key__c;
                        }
                        if(usrFeed.IP_address__c!= null){
                            oAccount.IP_address__c = usrFeed.IP_address__c;
                        }
                        if(usrFeed.DAZN_Id__c!= null){
                            oAccount.DAZN_Id__c = usrFeed.DAZN_Id__c;
                        } 
                        if(usrFeed.User_Type__c != null){
                            oAccount.Type = usrFeed.User_Type__c;
                        }
                        
                        /*Added as part of PD-11569*/
                        if(usrFeed.Subscription_Start_Date__c != null){
                                oAccount.Subscription_Date__c = usrFeed.Subscription_Start_Date__c;
                            }
                           if(usrFeed.Subscription_End_Date__c != null){
                                oAccount.Next_Charge_Date__c = usrFeed.Subscription_End_Date__c;
                            }
                        //End of PD-11569
 						//oAccount.Partner_Ready_to_Sync__c = true; //PD-12531
                        accountsToInsert.add(oAccount);
                        DAZNFldAnduserFeedMap.put(usrFeed.DAZN_Id__c, usrFeed);     
                    }
                }
                
                
            }catch(Exception ex){
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'DFDUserFeedHandler', 'prepareAccountsToInsert', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
                if(daznUserFeedObj != null){
                   exceptionDaznUserFeeds(daznUserFeedObj,ex.getMessage());
                }
            }
        }
        
        /*Added as part of PD-11515*/
        if(mapOfBlockedAccountIdandAccount != null  && mapOfBlockedAccountIdandAccount.size()>0){
            updateUserFeedRecords();
        } //End of PD-11515
        
        if((accountsToInsert != null && accountsToInsert.size()>0) && (lstUserFeed != null && lstUserFeed.size()>0)){
            insertAccountForUserFeeds(accountsToInsert, lstUserFeed);
        }
        
    }
    
    /******************************************************************************
@Method Name: insertAccountForUserFeeds
@Method Description: Method to inserting the Accounts
@Param:List of Accounts and List of DAZNUserFeed__c 
******************************************************************************/            
    public static void insertAccountForUserFeeds(List<Account> accountsToInsert, List<DAZNUserFeed__c> lstUserFeed){ 
        List<Account> existingAccounts = new List<Account>();//this list is used to add accounts that are to be inserted
        Database.UpsertResult[] srAccList ;//to store the inserted account details
        Set<String> accFailedEmailSet = new Set<String>();//to store failed account email
        Map<String,String> accFailedErrorMsgMap = new Map<String,String>();//stores email of succeeded user
        List<Contact> lstCont = new List<Contact> ();
        
        try{
            //to check whether account List is null or not
            if(accountsToInsert != null && accountsToInsert.size()>0){
                srAccList = Database.upsert(accountsToInsert,accDAZNFld,false); // Upserting based on DAZNID value
                //to iterate over the inserted list of accounts
                if(srAccList!= null && srAccList.size()>0){
                    for(Integer i=0;i<srAccList.size();i++){
                        if (srAccList.get(i).isSuccess()){
                            //account inserted successfully
                            accsucceedEmailMap.put(accountsToInsert.get(i).DAZN_Id__c,srAccList.get(i).getId());
                        }
                        else if (!srAccList.get(i).isSuccess()){
                            //DML operation failed
                            Database.Error error = srAccList.get(i).getErrors().get(0);
                            accountsToInsert.get(i);//failed record from the list
                            accFailedEmailSet.add(accountsToInsert.get(i).PersonEmail);
                            accFailedErrorMsgMap.put(accountsToInsert.get(i).PersonEmail,error.getMessage());
                            accountDAZNIDsSet.add(accountsToInsert.get(i).DAZN_Id__c);
                        }
                    }
                }
            }
            // this list is used to store queried userfeed fields 
            List<DAZNUserFeed__c> UserFeedLst = [Select id,First_Name__c,Last_Name__c,BillingCountryCode__c,Email_Preferences__c,Secondary_Email__c,Account_Status__c,Partner_Registration_status__c,Partner_Id__c,
                                                 CurrencyIsoCode,LanguageLocaleKey__c,EmailEncodingKey__c,LocaleSidKey__c,TimeZoneSidKey__c,Auth_Key__c,User_Type__c,
                                                 CommunityNickname__c,Alias__c,Status__c,Email__c,UserId__c,AccountId__c,Num_Retries__c,Request_Type__c,IP_address__c,DAZN_Id__c,Account_Type__c,ViewerId__c from DAZNUserFeed__c Where Id in: lstUserFeed LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())];
            //iterating over the userfeedlist
            IF(UserFeedLst != null && UserFeedLst.size() > 0){
                for(DAZNUserFeed__c usrFd : UserFeedLst){
                    daznUserFeedObj =usrFd;
                    if(accFailedEmailSet.contains(usrFd.Email__c) && (usrFd.Num_Retries__c < 5) && accountDAZNIDsSet.contains(usrFd.DAZN_Id__c) ){
                        DAZNUserFeed__c usrfeedRec = new DAZNUserFeed__c(); 
                        usrfeedRec.Id = DAZNFldAnduserFeedMap.get(usrFd.DAZN_Id__c).Id;
                        usrfeedRec.Num_Retries__c = usrFd.Num_Retries__c +1;
                        usrfeedRec.Status__c = 'To be retried';
                        usrfeedRec.Error_Message__c = accFailedErrorMsgMap.get(usrFd.Email__c);
                        userFeedToUpdate.add(usrfeedRec);
                    }else if(accFailedEmailSet.contains(usrFd.Email__c) && (usrFd.Num_Retries__c >= 5) &&  accountDAZNIDsSet.contains(usrFd.DAZN_Id__c)){
                        DAZNUserFeed__c usrfeedRec1 = new DAZNUserFeed__c(); 
                        usrfeedRec1.Id = DAZNFldAnduserFeedMap.get(usrFd.DAZN_Id__c).Id;
                        usrfeedRec1.Status__c = 'Failed';
                        usrfeedRec1.Error_Message__c = accFailedErrorMsgMap.get(usrFd.Email__c);
                        userFeedToUpdate.add(usrFd);
                    }
                }
            }
            if(accsucceedEmailMap != null && accsucceedEmailMap.size() > 0){
                lstCont = [select id, email from Contact where AccountId in:accsucceedEmailMap.Values() LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows()) ];
                //deleteDevices();
            }
             if(accFailedEmailSet != null && accFailedEmailSet.size()>0){
                updateUserFeedRecords();
            } 
            //check if contact list is null or not
            if(lstCont != null && lstCont.size() > 0){
                prepareUsersToInsert(lstCont,lstUserFeed);
            }
           
         }
        catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'DFDUserFeedHandler', 'insertAccountForUserFeeds', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        	 if(daznUserFeedObj != null){
                   exceptionDaznUserFeeds(daznUserFeedObj,ex.getMessage());
                }
        }
    }
    /******************************************************************************
@Method Name: prepareUsersToInsert
@Method Description: Method to prepare the list of users to insert 
@Param:List of Contacts and List of DAZNUserFeed__c 
******************************************************************************/
    public static void prepareUsersToInsert(List<Contact> lstCont, List<DAZNUserFeed__c> lstUserFeed){
        List<User> userIsertLst =  new List<User>();//to store inserted users
        List<User> existingUserLst =  new List<User>();//to store inserted users
        Map<string,User> mapOfUserIdandUser = new map<string,User>();
        set<Id> usrIdSet = new set<Id>();
        List<DAZNUserFeed__c> usrFeedToUpdate = new List<DAZNUserFeed__c>();//to store users updated details
        Map<String,Id> contEmailAndIdMap = new Map<String,Id>();//stores Contact email and Id value
        string aliasValue;
        // Get User Profile ID
        Profile oProfile = [SELECT Id FROM Profile where name = 'DfD Community User'];
        // Set DML Options

        /*Start PD-14478*/
        String usernameConfiguration = (DAZNConfiguration__c.getValues('LS_UserName_Configuration') != null) ? DAZNConfiguration__c.getValues('LS_UserName_Configuration').Value__c : null;
        /*End PD-14478*/

        Database.DMLOptions oDMLOption = new Database.DMLOptions();
        oDMLOption.EmailHeader.triggerUserEmail = false;
        oDMLOption.EmailHeader.triggerOtherEmail = false;
        if(lstUserFeed != null && lstUserFeed.size() > 0 && lstCont != null && lstCont.size() > 0){ 
            try{
                for(contact cont : lstCont){
                    contEmailAndIdMap.put(cont.Email, cont.Id);
                }
                If(contEmailAndIdMap != null && contEmailAndIdMap.size() > 0 ){
                    if(usrViewrIDSet!= null && usrViewrIDSet.size()>0){
                        existingUserLst = [Select Id,FirstName,LastName,CountryCode,Email,Username,Alias,ContactId,CommunityNickName,
                                           TimeZoneSidkey,LocaleSidKey,EmailEncodingKey,LanguageLocaleKey,CurrencyISOCode,ViewerId__c FROM User where ViewerId__c In: usrViewrIDSet LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())];
                    }
                    if(existingUserLst!= null && existingUserLst.size()>0){
                        for(User usrValue : existingUserLst){
                            mapOfUserIdandUser.put(usrValue.ViewerId__c, usrValue);
                        }
                    }
                    //iterate over the list
                    for(DAZNUserFeed__c usrFeed : lstUserFeed){
                        daznUserFeedObj =usrFeed;
                        if(usrfeed.ViewerId__c != null && accsucceedEmailMap.containsKey(usrFeed.DAZN_Id__c) && usrViewrIDSet.contains(usrFeed.ViewerId__c) && mapOfUserIdandUser !=null && mapOfUserIdandUser.size()>0 && mapOfUserIdandUser.containsKey(usrfeed.ViewerId__c)){
                            if(usrfeed.ViewerId__c == mapOfUserIdandUser.get(usrfeed.ViewerId__c).ViewerId__c){
                                User oUser = new User();
                                oUser.Id = mapOfUserIdandUser.get(usrfeed.ViewerId__c).Id;
                                if(usrFeed.Secondary_Email__c!=null){
                                    aliasValue = usrFeed.Secondary_Email__c;
                                }
                                if(usrFeed.First_Name__c!=null){
                                    oUser.FirstName = usrFeed.First_Name__c;
                                }
                                if(usrFeed.Last_Name__c!=null){
                                    oUser.LastName = usrFeed.Last_Name__c;
                                }
                                if(usrFeed.BillingCountryCode__c!=null){
                                    oUser.CountryCode = usrFeed.BillingCountryCode__c;
                                }
                                if(aliasValue != '' && aliasValue!=null){
                                    oUser.Alias = aliasValue.left(8);
                                }
                                if(usrFeed.CommunityNickname__c!=null){
                                    oUser.CommunityNickName = usrFeed.CommunityNickname__c;
                                }
                                if(usrFeed.TimeZoneSidKey__c!=null){
                                    oUser.TimeZoneSidkey = usrFeed.TimeZoneSidKey__c;
                                }
                                if(usrFeed.LocaleSidKey__c!=null){
                                    oUser.LocaleSidKey = usrFeed.LocaleSidKey__c;
                                }
                                if(usrFeed.EmailEncodingKey__c!=null){
                                    oUser.EmailEncodingKey = usrFeed.EmailEncodingKey__c;
                                }
                                if(usrFeed.LanguageLocaleKey__c!=null){
                                    oUser.LanguageLocaleKey = usrFeed.LanguageLocaleKey__c;
                                }
                                if(usrFeed.ViewerId__c!=null){
                                    oUser.ViewerId__c = usrFeed.ViewerId__c;
                                }
                                userIsertLst.add(oUser);
                                ViewerIdAnduserFeedMap.put(usrFeed.ViewerId__c, usrFeed);
                            }
                            
                        }else if(usrfeed.ViewerId__c != null && contEmailAndIdMap.containsKey(usrFeed.Email__c) && accsucceedEmailMap.containsKey(usrFeed.DAZN_Id__c)){
                            User oUser = new User();
                            if(usrfeed.First_Name__c != null ){
                                oUser.FirstName = usrFeed.First_Name__c;
                            }else{
                                oUser.FirstName = 'DFD Docomo'; // Added code part of PD-11141
                            }
                            if(usrFeed.Last_Name__c != null){
                                oUser.LastName = usrFeed.Last_Name__c; 
                            }else if(usrFeed.Partner_Id__c != null){
                                oUser.LastName = usrFeed.Partner_Id__c; // Added code part of PD-11141
                            }
                            if(usrFeed.Email__c != null){
                                oUser.Email = usrFeed.Email__c;
                            }
                            if(usrFeed.Email__c != null){
                                oUser.Username = usrFeed.Email__c + '.'+ /*Label.LS_UserName_Configuration*/usernameConfiguration;
                            }
                            if(usrFeed.BillingCountryCode__c!= null){
                                oUser.CountryCode  = usrFeed.BillingCountryCode__c;
                            }
                            if(oProfile.Id!= null){
                                oUser.ProfileId = oProfile.Id;
                            }
                            if(usrFeed.Email__c!= null && contEmailAndIdMap.get(usrFeed.Email__c)!= null){
                                oUser.ContactId = contEmailAndIdMap.get(usrFeed.Email__c);
                            }
                            if(usrFeed.CommunityNickname__c!= null){
                                oUser.CommunityNickName = usrFeed.CommunityNickname__c;
                            }
                            if(usrFeed.TimeZoneSidKey__c!= null){
                                oUser.TimeZoneSidkey = usrFeed.TimeZoneSidKey__c ;
                            }else{
                                oUser.TimeZoneSidkey = 'Asia/Tokyo';
                            }
                            if(usrFeed.LocaleSidKey__c!= null){
                                oUser.LocaleSidKey = usrFeed.LocaleSidKey__c ;
                            }else{
                                oUser.LocaleSidKey = 'ja_JP';
                            }
                            if(usrFeed.EmailEncodingKey__c!= null){
                                oUser.EmailEncodingKey = usrFeed.EmailEncodingKey__c;
                            }else{
                                oUser.EmailEncodingKey = 'UTF-8';
                            }
                            if(usrFeed.LanguageLocaleKey__c!= null){
                                oUser.LanguageLocaleKey = usrFeed.LanguageLocaleKey__c;
                            }else{
                                oUser.LanguageLocaleKey = 'ja';
                            }
                            if(usrFeed.ViewerId__c != null){
                                oUser.ViewerId__c = usrFeed.ViewerId__c;
                            }
                            if(usrFeed.Partner_Id__c != null){
                                aliasValue = usrFeed.Partner_Id__c;
                            }
                            if(aliasValue!= null && aliasValue !=''){
                                oUser.Alias = aliasValue.left(8);
                            }
                            oUser.IsActive = true;
                            oUser.CurrencyISOCode = 'JPY';
                            userIsertLst.add(oUser);
                            ViewerIdAnduserFeedMap.put(usrFeed.ViewerId__c, usrFeed);
                        }
                    }
                }
                
            }catch(Exception ex){
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'DFDUserFeedHandler', 'prepareUsersToInsert', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            	 if(daznUserFeedObj != null){
                   exceptionDaznUserFeeds(daznUserFeedObj,ex.getMessage());
                }
            }
        }
        if(userIsertLst != null && userIsertLst.size()> 0){
            insertUsersForUserFeeds(userIsertLst,lstUserFeed);
        }
        
    }
    /******************************************************************************
@Method Name: insertUsersForUserFeeds
@Method Description: Method to insert the users
@Param:List of Users and List of DAZNUserFeed__c and users
******************************************************************************/
    public static void insertUsersForUserFeeds(List<User> userIsertLst,List<DAZNUserFeed__c> lstUserFeed){
        Database.UpsertResult[] srUsrList ; //to store inserted user details
        set<Id> usrIdSet = new set<Id>();
        Map<String,Id> usrsucceedEmailMap = new Map<String,Id>();//stores email of succeeded user
        Set<String> usrFailedEmailSet = new Set<String>();//stores email of insertion failed user
        Map<String,String> usrFailedErrorMsgMap = new Map<String,String>();//stores email of succeeded user
        Set<Id> userFeedUserUpdateSet = new Set<Id>(); //to store updated userfeed records
        Set<string> userViewerIdSet = new Set<string>();// store updated userfeed account details
        List<DAZNUserFeed__c> lstfd = new List<DAZNUserFeed__c>();//to store list of users
        
        try{
            //this list is used to check if user is null or not
            if(userIsertLst != null && userIsertLst.size()> 0){
                srUsrList = Database.upsert(userIsertLst,usrViewerld,false);
            }
            if(srUsrList != null && srUsrList.size() > 0){ 
                //to iterate over the users list
                for(Integer i=0; i<srUsrList.size();i++){
                    if (srUsrList.get(i).isSuccess()){
                        //user inserted successfully
                        usrIdSet.add(srUsrList.get(i).getId());
                        usrsucceedEmailMap.put(userIsertLst.get(i).ViewerId__c,srUsrList.get(i).getId());
                    }
                    else if (!srUsrList.get(i).isSuccess()){  //checking the 
                        // DML operation failed
                        Database.Error error = srUsrList.get(i).getErrors().get(0);
                        usrFailedEmailSet.add(userIsertLst.get(i).Email);
                        usrFailedErrorMsgMap.put(userIsertLst.get(i).Email, error.getMessage());
                        userViewerIdSet.add(userIsertLst.get(i).ViewerId__c);
                    }
                }
            }
            
            //this list is used to store queried fields in to list
            List<DAZNUserFeed__c> UserFeedLst = [Select id,Status__c,Email__c,UserId__c,AccountId__c,Num_Retries__c,Partner_Registration_status__c,Auth_Key__c,ViewerId__c,DAZN_Id__c from DAZNUserFeed__c Where Id in: lstUserFeed LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())];
            if(UserFeedLst != null && UserFeedLst.size() > 0){
                //to iterate over userfeed list 
                for(DAZNUserFeed__c usrFd : UserFeedLst){
                    daznUserFeedObj =usrFd;
                    //to check if map contains users email with registration status as complete
                    if(usrsucceedEmailMap != null && usrsucceedEmailMap.size() > 0 && usrsucceedEmailMap.containsKey(usrFd.ViewerId__c) ){
                        usrFd.UserId__c = usrsucceedEmailMap.get(usrFd.ViewerId__c);
                        usrFd.AccountId__c = accsucceedEmailMap.get(usrFd.DAZN_Id__c);
                        usrFd.Status__c = 'Successful';
                        usrFd.Error_Message__c = '';
                        usrFd.Num_Retries__c = 0;
                        userFeedUserUpdateSet.add(usrFd.Id);
                        lstfd.add(usrFd);
                        userFeedToUpdate.add(usrFd);
                        //if succeededmap contains users email
                    }else if(usrFailedEmailSet != null && usrFailedEmailSet.size() > 0 && usrFailedEmailSet.contains(usrFd.Email__c) && usrFd.Num_Retries__c < 5 && userViewerIdSet.contains(usrFd.ViewerId__c)){
                        if(accsucceedEmailMap.containsKey(usrFd.Email__c) && UsrFd.AccountId__c == null ){
                            UsrFd.AccountId__c = accsucceedEmailMap.get(usrFd.DAZN_Id__c);
                        }
                        usrFd.Num_Retries__c = usrFd.Num_Retries__c +1;
                        usrFd.Status__c = 'To be retried';
                        usrFd.Error_Message__c = usrFailedErrorMsgMap.get(usrFd.Email__c);
                        userFeedUserUpdateSet.add(usrFd.Id);
                        lstfd.add(usrFd);
                        userFeedToUpdate.add(usrFd);
                    }else if(usrFailedEmailSet != null && usrFailedEmailSet.size() > 0 &&usrFailedEmailSet.contains(usrFd.Email__c) && usrFd.Num_Retries__c >= 5 && userViewerIdSet.contains(usrFd.ViewerId__c)){
                        usrFd.Status__c = 'Failed';
                        usrFd.Error_Message__c = usrFailedErrorMsgMap.get(usrFd.Email__c);
                        userFeedToUpdate.add(usrFd);
                    }
                }
            }
            
            
        }catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'DFDUserFeedHandler', 'insertUsersForUserFeeds', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        	 if(daznUserFeedObj != null){
                   exceptionDaznUserFeeds(daznUserFeedObj,ex.getMessage());
                }
        }
        //to check if list is null or not
        if(userFeedToUpdate != null && userFeedToUpdate.size() > 0){
            updateUserFeedRecords();
        }
        
    }
    
    /******************************************************************************
@Method Name: updateUserFeedRecords
@Method Description: Method to check the updated user records
@Param:   
******************************************************************************/
    public static void updateUserFeedRecords(){
        Database.SaveResult[] srUsrList ;//to store inserted user details
        set<Id> usrIdSet = new set<Id>();
        Map<Id,String> usrFailedErrorMsgMap = new Map<Id,String>();//stores email of succeeded user
        List<DAZNUserFeed__c> failedUsrFeedErrorMsgUpdate = new List<DAZNUserFeed__c>();
        try{
            //to check if set is null or not
            if(userFeedToUpdate != null && userFeedToUpdate.size()>0){
                srUsrList = Database.update(userFeedToUpdate,false); 
            }
        }catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'DFDUserFeedHandler', 'updateUserFeedRecords', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
        }
    }
    
    /******************************************************************************
@Method Name: beforeAccountIsertUpdateName
@Method Description: Method to add the account first name and last name 
@Param: List Of Accounts  
******************************************************************************/
    public static void beforeAccountIsertUpdateName(List<Account> lstAccounts){
        /*for(Account acc: lstAccounts){
if(acc.FirstName == null){
acc.FirstName = 'DFD Docomo';
}
if(acc.LastName == null && acc.Partner_ID__c != null){
acc.LastName = acc.Partner_ID__c;
}
}*/
    }
    /******************************************************************************
@Method Name: beforeAccountIsertUpdateName
@Method Description: Method to add the account first name and last name 
@Param: List Of Accounts  
******************************************************************************/
    public static void beforeUserIsertUpdateName(List<User> lstusers){
        /*for(user usr: lstusers){
if(usr.FirstName == null){
usr.FirstName = 'DFD Docomo';
}
if(usr.LastName == null && usr.ViewerId__c != null){
usr.LastName = usr.ViewerId__c;
}
}*/
    }
    
    /*Method to delete devices

public static void deleteDevices(){
List<Id> lstDeviceIds = new List<Id>();
try{
List<Account> accList = [Select id from Account where id IN: accsucceedEmailMap.values() and Account_Status__c = 'Frozen'];
List<User_Devices__c> lstAllUserDevices = [SELECT id, Device_Id__c, Account__c FROM User_Devices__c where Account__c IN: accList];
if(lstAllUserDevices != null && lstAllUserDevices.size() > 0){
database.delete(lstAllUserDev-ices, false);
}
}catch(Exception ex){
ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'DFDUserFeedHandler', 'deleteDevices', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
}
}*/
    
    public static void exceptionDaznUserFeeds(DAZNUserFeed__c daznUserFeed,String exceptionMessage){
         			DAZNUserFeed__c daznfeed =new DAZNUserFeed__c();
                    daznfeed.UserId__c = daznUserFeed.UserId__c;
                    daznfeed.AccountId__c = daznUserFeed.AccountId__c;
                    daznfeed.Status__c = 'To be retried';
                    daznfeed.Error_Message__c = exceptionMessage;
                    daznfeed.Num_Retries__c = daznUserFeed.Num_Retries__c + 1;
                    userFeedToUpdate.add(daznfeed);
    }
}