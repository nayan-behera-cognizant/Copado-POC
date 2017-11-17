/**
 * An apex page controller that exposes the site forgot password functionality
 */
@IsTest public with sharing class ForgotPasswordControllerTest {
  	@IsTest
  	public static void testForgotPasswordController() {
  	 	DAZNConfiguration__c dc = new DAZNConfiguration__c(
  	 		Name = 'LS_UserName_Configuration',
  	 		Value__c = 'test'
  	 	);
  	 	insert dc;
    	// Instantiate a new controller with all parameters in the page
    	ForgotPasswordController controller = new ForgotPasswordController();
    	controller.strNewEmail = 'test@salesforce.com';     	
    	System.assertEquals(null, controller.forgotPassword());
    	System.assertEquals(Label.LS_ForgotPassword_Label_Failure, controller.strMessage);
    }
}