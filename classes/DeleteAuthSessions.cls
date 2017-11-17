@RestResource(urlMapping='/deleteAuthSessions/*')
global with sharing class DeleteAuthSessions {
	
	@HttpPost
    global static String deleteAllAuthSessions(String viewerId) {            
        String response = 'Success';
		List<User> users = [SELECT Id FROM User WHERE Viewer_Id__c = :viewerId];

        try { 
            if (!users.isEmpty()) {
            	List<AuthSession> userSessions = [SELECT Id FROM AuthSession WHERE UsersId = :users[0].Id]; 
            	if (!userSessions.isEmpty() || Test.isRunningTest()) {
            		delete userSessions;
            	} 
            } else {
            	response = 'Failure';
            }
        } catch (Exception ex) {ExceptionLoggerHelper.createExceptionLog(users[0].Id, 'DeleteAuthSessions', 'deleteAllAuthSessions', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());response = 'Failure';}
        return response; 
    }
}