/**
* The DAZNUserDeviceFeed class implements all necessary logic to be executed when a Trigger event is fired on DAZNUserDeviceFeed 
* 
*
* @Author       :Cognizant Technology Solutions
* @Base version :1.0
* @Date         :Dec 09 2016
* ***********************Update History*****************************************
* Version       Updated By              CR #                    Change Description                  
*
*/

public class DAZNUserDeviceFeedTriggerHandler {

/* Called by the trigger in After Insert Context to insert the new user devices based on user feed devices data into the respective account */

    public static void daznUserFeedDeviceCreationOnAccount(set<ID> setOFUSerfeedIDs ){
        system.debug('setOFUSerfeedIDs---------->'+setOFUSerfeedIDs);
        list<User_Devices__c> listInsertDev = new list<User_Devices__c> ();
        list<DAZNUserFeed__c> listOFUserFeedObj = new list<DAZNUserFeed__c>();
        list <DAZN_User_Device_Feed__c> userDevAccountID  = new list <DAZN_User_Device_Feed__c>();
        if(setOFUSerfeedIDs.size()>0){    
            listOFUserFeedObj = [SELECT id,AccountId__c,DAZN_Id__c from DAZNUserFeed__c Where id IN : setOFUSerfeedIDs ];
            system.debug('listOFUserFeedObj=====>'+listOFUserFeedObj);
        }
        //removed Device_version__c,Device_manufacturer__c,Device_Name__c,IP_address__c from query as per PD-9900
        userDevAccountID =[select id, DAZN_User_feed__r.AccountId__c ,Date_of_Registration__c,Device_Id__c,Device_Registration_Date__c,
                           Device_Type__c,Operating_System_Name__c,Operating_System_Version__c,
                           User_Agent__c,IP_address__c from DAZN_User_Device_Feed__c WHERE ID  IN: trigger.new ];
        system.debug('userDevAccountID---------->'+userDevAccountID);
           
        try{
                        if(listOFUserFeedObj.size()>0 &&  userDevAccountID.size()>0 ){
                            for(DAZNUserFeed__c DZUSerFeedObj :listOFUserFeedObj ){
                                if(DZUSerFeedObj.AccountId__c != null ){                        
                                    for(DAZN_User_Device_Feed__c DazUserDevFeedObj :userDevAccountID ){
                                        if(DZUSerFeedObj.AccountId__c   == DazUserDevFeedObj.DAZN_User_feed__r.AccountId__c){
                                            	User_Devices__c insertUserDevObj = new User_Devices__c ();
                                            	system.debug('AccountID---------->');
                                                insertUserDevObj.Date_Of_Registration__c  = DazUserDevFeedObj.Date_of_Registration__c;
                                                insertUserDevObj.Account__c =  DZUSerFeedObj.AccountId__c;
                                                insertUserDevObj.Device_Id__c =  DazUserDevFeedObj.Device_Id__c;
                                                //insertUserDevObj.Device_manufacturer__c = DazUserDevFeedObj.Device_manufacturer__c;//PD-9900
                                                //insertUserDevObj.Device_Name__c =  DazUserDevFeedObj.Device_Name__c;//PD-9900
                                                insertUserDevObj.Device_Registration_Date__c =  DazUserDevFeedObj.Device_Registration_Date__c;
                                                insertUserDevObj.Type__c=  DazUserDevFeedObj.Device_Type__c;
                                                insertUserDevObj.IP_address__c =  DazUserDevFeedObj.IP_address__c;//PD-9900
                                                //insertUserDevObj.Device_version__c=  DazUserDevFeedObj.Device_version__c;//PD-9900
                                                insertUserDevObj.Operating_System_Name__c=  DazUserDevFeedObj.Operating_System_Name__c;
                                                insertUserDevObj.Operating_System_Version__c=  DazUserDevFeedObj.Operating_System_Version__c;
                                                insertUserDevObj.Status__c=  'Active';
                                                insertUserDevObj.User_Agent__c =  DazUserDevFeedObj.User_Agent__c; 
                                                listInsertDev.add(insertUserDevObj);
                                            	
                                                }
                                        }
                                }
                        }
                     system.debug('listInsertDev---------->'+listInsertDev);
                     insert listInsertDev;
                     system.debug('listInsertDev11111-------->'+listInsertDev);    
                     
            }
        }       
        catch(Exception ex){
            	system.debug('ex-------->'+ex);
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'daznUserFeedDeviceCreationOnAccount', 'daznUserFeedDeviceCreationOnAccount', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            }
    } 
}