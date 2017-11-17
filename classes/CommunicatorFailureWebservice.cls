/**
* @author Cognizant Technology Solutuions
* @date 11/28/2016
* @description CommunicatorIntegrationHelper webservice failed utility
*/
public class CommunicatorFailureWebservice{

    /*
        Description: Method to create task for CommunicatorIntegrationHelper webservice failures
    */
	public static void createTask(string sContactId, string sAccountId, string sTaskSubject, string sTaskDescription, Map<String,List<Account>> mapAccount, DataService.DataImportResponse oDataImportResponse, List<WrapCommunicatorEmail> mapSubscriptionEmailforStandard, Map<String,List<User>> mapUser){
        //Checking the user has a access to the fields below before inserting Task (PD-7903)
        if(schema.SObjectType.Task.fields.Priority.isAccessible()&& 
           schema.SObjectType.Task.fields.Status.isAccessible()&& 
           schema.SObjectType.Task.fields.subject.isAccessible()&&
           schema.SObjectType.Task.fields.Description.isAccessible()&& 
           schema.SObjectType.Task.fields.ActivityDate.isAccessible())  {
               if(sContactId != null && sAccountId != null){
					Task oTask = new Task ( WhoId = sContactId, WhatId = sAccountId,
										  priority = 'Medium', status = 'Completed', 
										  Subject = sTaskSubject,
										  description = sTaskDescription, ActivityDate = Date.today()
										 );
				   
				   insert oTask;
			   }
			   else if(mapAccount != null){
					List<Account> lstAccount = new List<Account>();
					for(String sLanguage : mapAccount.keySet()){
						for(Account oAccount : mapAccount.get(sLanguage)){                    
							lstAccount.add(oAccount);                                             
						}
					}   
					Task oTask = new Task ( WhoId = lstAccount[0].PersonContactId, WhatId = lstAccount[0].id,
										  priority = 'Medium', status = 'Completed', 
										  Subject = sTaskSubject,
										  description = sTaskDescription, ActivityDate = Date.today()
										 );
				   
				   insert oTask;
					
			   }    
               else if(mapUser != null){
                   List<User> lstUser = new List<User>();
					for(String sLanguage : mapUser.keySet()){
						for(User oUser : mapUser.get(sLanguage)){                    
							lstUser.add(oUser);                                             
						}
					} 
                   Task oTask = new Task ( WhoId = lstUser[0].ContactId, WhatId = lstUser[0].AccountId,
										  priority = 'Medium', status = 'Completed', 
										  Subject = sTaskSubject,
										  description = sTaskDescription, ActivityDate = Date.today()
										 );
				   
				   insert oTask;
               }
           }
        else{ //if this user doesn't have permission to create a task then notify the same to system admin
            String strError = 'Error faced while inserting a Task :'+' User Id :'+UserInfo.getUserID();
            SendEmailWithErrorsToAdmins.sendEmail(strError);               
        }
    }  
	 public static void createNotificationTask(Map<String,List<WrapCommunicatorEmail>> mapSubscriptionEmailforStandard,
                                                string sTaskSubject, String sTaskDescription){
         
       
        
        // Prepare list of task to be created.
        Task oTask = new Task();
            for(String sLanguage : mapSubscriptionEmailforStandard.keySet()){
						for(WrapCommunicatorEmail objWrap : mapSubscriptionEmailforStandard.get(sLanguage)){                                       	        	  			
							oTask = new Task ( WhoId = objWrap.ContactId, WhatId = objWrap.ID,
									  priority = 'Medium', status = 'Completed', 
									  Subject = sTaskSubject,
									  description =  sTaskDescription, ActivityDate = Date.today()
									 );
                        }
				insert oTask;	
           
        }         
    }
}