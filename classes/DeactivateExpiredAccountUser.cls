/* This class is used to anonymise User*/
global class DeactivateExpiredAccountUser
{
    /*
Description : This method checks the role of logged in User.
*/
    webservice static Boolean checkRole(Id RoleId){
        string strAnonymousUserRoleName;
        Boolean result ;
        time t;
        UserRole oUserRole = [SELECT Id, Name from UserRole where ID =: RoleId ];
        String strRoleName = oUserRole.Name ;
        DAZNConfiguration__c oDAZNConfiguration = DAZNConfiguration__c.getValues('Role');
        DAZNConfiguration__c oDAZNConfigurationCS = DAZNConfiguration__c.getValues('CS Roles'); //Added as part of PD-11649
        strAnonymousUserRoleName = oDAZNConfiguration.Value__c + ',' + oDAZNConfigurationCS.Value__c ; //Modified as part of PD-11649
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
    
    
    /*
Description : This method performs the functionality to anonymise user name , email address
and opt out from marketing Communication on Account.
*/
    webservice static string executeDeactivateAccountUser(Id AccountId) // you can pass parameters
    { 
        string strMsg = 'Success' ;
        try{
            Account oAcc =  [Select Id,All_Email_Preferences__c,Account_Status__c From Account Where Id  =: AccountId ];
            if(oAcc.Account_Status__c == 'Expired' || oAcc.Account_Status__c == 'Expired Marketing'){
                strMsg = 'AccountExpired';
            }
            else{
                list<User> lstUser = new list<User>();
                
                DAZNConfiguration__c oDAZNConfiguration = DAZNConfiguration__c.getValues('EnviornmentName');
                String strEnvName = oDAZNConfiguration.Value__c;
                
                lstUser = new list<User>();
                User usr = [Select Id,Email,Username,isActive,ViewerId__c, FirstName, LastName From User Where AccountId  =: AccountId ];

                //Added as a part of PD-11948
                string cachedEmail = usr.Email;
                string cachedFName = usr.FirstName;
                string cachedLName = usr.LastName;   

                System.debug('usr***'+usr);
                usr.FirstName = 'anonymous['+strEnvName+']'+usr.Id ;
                usr.LastName = 'anonymous['+strEnvName+']'+usr.Id ;
                usr.Username = 'anonymous['+strEnvName+']'+usr.Id+'@livesport.com';
                usr.Email = 'anonymous'+strEnvName+usr.Id+'@livesport.com';
                usr.isActive = false;
                System.debug('ViewerId__c***'+usr.ViewerId__c);
                
                /*Added as a part of PD-10582*/
                if(usr.ViewerId__c != null){
                    usr.ViewerId__c = '';
                } //End of PD-10582
                
                lstUser.add(usr);
                if(lstUser != null && lstUser.size()>0 ){
                    updateAccount(AccountId, cachedEmail, cachedFName, cachedLName);
                    update lstUser; 
                }
            }
            
        }catch(Exception ex){
            system.debug('error '+ex);
            ExceptionLoggerHelper.createExceptionLog(userInfo.getUserId(), 'DeactivateExpiredAccountUser', 'executeDeactivateAccountUser', ex.getMessage(),'','');            
            strMsg = 'Failed';
        }
        return strMsg ;
        
    }
    
    @future
    public static void updateAccount(Id AccountId, string c_Email, string c_FName, string c_Lname){
        Boolean accStatusExpired = false ;
        DAZNConfiguration__c oDAZNConfiguration = DAZNConfiguration__c.getValues('EnviornmentName');
        String strEnvName = oDAZNConfiguration.Value__c;
        Account oAcc =  [Select Id,FirstName,LastName,All_Email_Preferences__c,Account_Status__c,Partner_ID__c,Secondary_Email__c, Type, Cached_Email__c, Cached_FirstName__c, Cached_LastName__c   From Account Where Id  =: AccountId ];
        User oUser = [Select Email,FirstName,LastName From User Where AccountId  =: AccountId ];
        oAcc.All_Email_Preferences__c = false ;
        oAcc.PersonEmail = oUser.Email ;
        oAcc.Account_Status__c = 'Expired';
        oAcc.FirstName = oUser.FirstName  ;
        oAcc.LastName = oUser.LastName;
        oAcc.Cached_Email__c = c_Email;
        oAcc.Cached_FirstName__c = c_FName;
        oAcc.Cached_LastName__c = c_Lname;
        
        /*Added as a part of PD-10582*/
        if(oAcc.Type == 'Docomo' && oAcc.Partner_ID__c != null){
            oAcc.Secondary_Email__c = 'anonymousSecondary'+strEnvName+oUser.Id+'@livesport.com';
            oAcc.Partner_ID__c = 'anonymous['+strEnvName+']'+oUser.Id;
        } //End of PD-10582
        
        update oAcc ;
    }
    
}