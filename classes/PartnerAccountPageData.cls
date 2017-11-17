public with sharing class PartnerAccountPageData {
	
	/*Labels from Page*/
	public final String myAccountTitle 							{ get; set; }
	public String button_OK 									{ get; set; }
	public String button_Cancel 								{ get; set; }
	public String myAccount_Banner_Button_Start_Watching_DAZN 	{ get; set; }
	public String button_YesDeregister 							{ get; set; }
	public String partnerAcc_Label_PersonalDesc 				{ get; set; }
	public String partnerAcc_Label_termsofUse 					{ get; set; }
	public String myAccount_Label_My_Details 					{ get; set; }
	public String partnerAcc_Label_PersonalDescAnd 				{ get; set; }
	public String partnerAcc_Label_PrivacyPolicy 				{ get; set; }
	public String partnerAcc_Label_PersonalDesc_Part1 			{ get; set; }
	public String partnerAcc_Label_PersonalDesc_Part2 			{ get; set; }
	public String myAccount_Name 								{ get; set; }
	public String myAccount_EmailAddress  						{ get; set; }
	public String button_Edit 									{ get; set; }
	public String myAccount_Label_Firstname 					{ get; set; }
	public String myAccount_Label_Surname 						{ get; set; }
	public String button_Save 									{ get; set; }
	public String myAccount_Label_Membership 					{ get; set; }
	public String button_Manage 								{ get; set; }
	public String myAccount_Link_ViewPaymentHistory 			{ get; set; }
	public String myAccount_Label_PaymentMethod 				{ get; set; }
	public String button_Change 								{ get; set; }
	public String button_CancelSubscription 					{ get; set; }
	public String myAccount_Label_MyDevices 					{ get; set; }
	public String myAccount_Label_Registered 					{ get; set; }
	public String button_Deregister_Single_Device 				{ get; set; }
	public String myAccount_InfoMsg_NoRegisteredDevices  		{ get; set; }
	public String myAccount_Button_SignOutAllDevices  			{ get; set; }
	public String myAccount_Label_Language 						{ get; set; }
	public String myaccount_Label_LanguageSection 				{ get; set; }
	public String myAccount_Label_Save_Language 				{ get; set; }
	public String partnerAcc_Label_EmailPref 					{ get; set; }
	public String partnerAcc_Label_DAZNComm						{ get; set; }
	public String myAccount_ErrMsg_Valid_Firstname 				{ get; set; }
	public String myAccount_ErrMsg_Valid_Surname 				{ get; set; }
	public String myAccount_ErrMsg_InvalidEmailID 				{ get; set; }
	public String myAccount_ErrMsg_NoMatch 						{ get; set; }
	public String myAccount_ErrMsg_Min5Chars 					{ get; set; }
	public String myAccount_ErrMsg_AtleastOneChar 				{ get; set; }
	public String myAccount_ErrMsg_NewPwdAndRepeatPwdDoNotMatch { get; set; }
	public String partnerAcct_URL 								{ get; set; }
	public String partnerAcc_Label_ErrorMsg 					{ get; set; }
	public String subscriptionType 								{ get; set; }
	public String myAccount_Label_LastPayment 					{ get; set; }

	/*Labels from Controller*/
	public String paymentHistory_Label_Ending 					{ get; set; }
	public String paymentHistory_Label_Directdebit 				{ get; set; }
	public String change_payment_ErrMsg 						{ get; set; }
	public String zuora_ConnectionError 						{ get; set; }
	public String myaccount_ErrMsg_ProvideNewEmail 				{ get; set; }
	public String myAccount_ErrMsg_DocomoEmailIDExists 			{ get; set; }
	public String myAccount_Button_ViewMore 					{ get; set; }
	public String myaccount_Dropdown 							{ get; set; }
	public String myAccount_SignOut_TaskSubject 				{ get; set; }
	public String myAccount_SignOut_TaskDesc 					{ get; set; }
	public String warning_Popup_Msg 							{ get; set; }
	public String signout_Singel_Device_Banner_Header 			{ get; set; }
	public String myAccount_ConfirmMsg_Signoutalldevices 		{ get; set; }
	public String sign_out_Banner_Header 						{ get; set; }
	public String myAccount_Language_Japanese_Label 			{ get; set; }
	public String myAccount_Language_English_Label 				{ get; set; }
	public String myaccount_Language_UnitedKingdom_DE_Label 	{ get; set; }
	public String dFD_HOST 										{ get; set; }
	public String dFD_CONTENT_LENGTH 							{ get; set; }
	public String dFD_PORT 										{ get; set; }
	public String dFD_404 										{ get; set; }
	public String dFD_500 										{ get; set; }
	public String dFD_300 										{ get; set; }
	public String dFD_SetEndpoint 								{ get; set; }
	public String myAccount_Cancelling_Subscription_Info 		{ get; set; }
	public String paymentmethod_description_apple 				{ get; set; }
	public String paymentmethod_title_apple 					{ get; set; }
	public String montly_subscription_cost_Apple 				{ get; set; }
	public String label_For_Active_Pais_Status 					{ get; set; }

	public Boolean isAppleAccount;

	public PartnerAccountPageData() {
		this.isAppleAccount = CommunityHelper.isAppleUser();
		if (this.isAppleAccount) {
			/*Start PD-14478*/
		    String appleEndPoint = (DAZNConfiguration__c.getValues('Apple_SetEndpoint') != null) ? DAZNConfiguration__c.getValues('Apple_SetEndpoint').Value__c : null;
			/*End PD-14478*/
			this.subscriptionType = Label.LS_Subscription_Type_Apple;
			this.myAccount_Label_LastPayment = Label.LS_MyAccount_Label_LastPayment_Apple;

			this.myAccountTitle = Label.LS_My_Account_Title_Apple;
			this.button_OK = Label.LS_Button_OK_Apple;
			this.myAccount_Banner_Button_Start_Watching_DAZN = Label.LS_MyAccount_Banner_Button_Start_Watching_DAZN_Apple;
			this.button_YesDeregister = Label.LS_Button_YesDeregister_Apple;
			this.partnerAcc_Label_PersonalDesc = Label.LS_PartnerAcc_Label_PersonalDesc_Apple;
			this.partnerAcc_Label_termsofUse = Label.LS_PartnerAcc_Label_termsofUse_Apple;
			this.myAccount_Label_My_Details = Label.LS_MyAccount_Label_My_Details_Apple;
			this.partnerAcc_Label_PersonalDescAnd = Label.LS_PartnerAcc_Label_PersonalDescAnd_Apple;
			this.partnerAcc_Label_PrivacyPolicy = Label.LS_PartnerAcc_Label_PrivacyPolicy_Apple;
			this.partnerAcc_Label_PersonalDesc_Part1 = Label.LS_PartnerAcc_Label_PersonalDesc_Part1_Apple;
			this.partnerAcc_Label_PersonalDesc_Part2 = Label.LS_PartnerAcc_Label_PersonalDesc_Part2_Apple;
			this.myAccount_Name = Label.LS_MyAccount_Name_Apple;
			this.button_Edit = Label.LS_Button_Edit_Apple;
			this.myAccount_Label_Firstname = Label.LS_MyAccount_Label_Firstname_Apple;
			this.myAccount_Label_Surname = Label.LS_MyAccount_Label_Surname_Apple;
			this.button_Save = Label.LS_Button_Save_Apple;
			this.button_Cancel = Label.LS_Button_Cancel_Apple;
			this.myAccount_EmailAddress = Label.LS_MyAccount_EmailAddress_Apple;
			this.myAccount_Label_Membership = Label.LS_MyAccount_Label_Membership_Apple;
			this.button_Manage = Label.LS_Button_Manage_Apple;
			this.myAccount_Cancelling_Subscription_Info = Label.LS_MyAccount_Cancelling_Subscription_Info_Apple;
			this.myAccount_Link_ViewPaymentHistory = Label.LS_MyAccount_Link_ViewPaymentHistory_Apple;
			this.myAccount_Label_PaymentMethod = Label.LS_MyAccount_Label_PaymentMethod_Apple;
			this.button_Change = Label.LS_Button_Change_Apple;
			this.button_CancelSubscription = Label.LS_Button_CancelSubscription_Apple;
			this.myAccount_Label_MyDevices = Label.LS_MyAccount_Label_MyDevices_Apple;
			this.myAccount_Label_Registered = Label.LS_MyAccount_Label_Registered_Apple;
			this.button_Deregister_Single_Device = Label.LS_Button_Deregister_Single_Device_Apple;
			this.myAccount_InfoMsg_NoRegisteredDevices = Label.LS_MyAccount_InfoMsg_NoRegisteredDevices_Apple;
			this.myAccount_Button_SignOutAllDevices = Label.LS_MyAccount_Button_SignOutAllDevices_Apple;
			this.myAccount_Label_Language = Label.LS_MyAccount_Label_Language_Apple;
			this.myaccount_Label_LanguageSection = Label.LS_Myaccount_Label_LanguageSection_Apple;
			this.myAccount_Label_Save_Language = Label.LS_MyAccount_Label_Save_Language_Apple;
			this.partnerAcc_Label_EmailPref = Label.LS_PartnerAcc_Label_EmailPref_Apple;
			this.partnerAcc_Label_DAZNComm = Label.LS_PartnerAcc_Label_DAZNComm_Apple;
			this.myAccount_ErrMsg_Valid_Firstname = Label.LS_MyAccount_ErrMsg_Valid_Firstname_Apple;
			this.myAccount_ErrMsg_Valid_Surname = Label.LS_MyAccount_ErrMsg_Valid_Surname_Apple;
			this.myAccount_ErrMsg_InvalidEmailID = Label.LS_MyAccount_ErrMsg_InvalidEmailID_Apple;
			this.myAccount_ErrMsg_NoMatch = Label.LS_MyAccount_ErrMsg_NoMatch_Apple;
			this.myAccount_ErrMsg_Min5Chars = Label.LS_MyAccount_ErrMsg_Min5Chars_Apple;
			this.myAccount_ErrMsg_AtleastOneChar = Label.LS_MyAccount_ErrMsg_AtleastOneChar_Apple;
			this.myAccount_ErrMsg_NewPwdAndRepeatPwdDoNotMatch = Label.LS_MyAccount_ErrMsg_NewPwdAndRepeatPwdDoNotMatch_Apple;
			this.partnerAcct_URL = Label.LS_PartnerAcct_URL_Apple;
			this.partnerAcc_Label_ErrorMsg = Label.LS_PartnerAcc_Label_ErrorMsg_Apple;
			this.paymentmethod_description_apple = Label.LS_paymentmethod_description_apple;
			this.paymentmethod_title_apple = Label.LS_paymentmethod_title_apple;

			this.montly_subscription_cost_Apple = Label.LS_montly_subscription_cost_Apple;

			/*Labels from Controller*/
			this.paymentHistory_Label_Ending = Label.LS_PaymentHistory_Label_Ending_Apple;
			this.paymentHistory_Label_Directdebit = Label.LS_PaymentHistory_Label_Directdebit_Apple;
			this.change_payment_ErrMsg = Label.LS_Change_payment_ErrMsg_Apple;
			this.zuora_ConnectionError = Label.LS_Zuora_ConnectionError_Apple;
			this.myaccount_ErrMsg_ProvideNewEmail = Label.LS_Myaccount_ErrMsg_ProvideNewEmail_Apple;
			this.myAccount_ErrMsg_DocomoEmailIDExists = Label.LS_MyAccount_ErrMsg_DocomoEmailIDExists_Apple;
			this.myAccount_Button_ViewMore = Label.LS_MyAccount_Button_ViewMore_Apple;
			this.myaccount_Dropdown = Label.LS_Myaccount_Dropdown_Apple;
			this.myAccount_SignOut_TaskSubject = Label.LS_MyAccount_SignOut_TaskSubject_Apple;
			this.myAccount_SignOut_TaskDesc = Label.LS_MyAccount_SignOut_TaskDesc_Apple;
			this.warning_Popup_Msg = Label.LS_Warning_Popup_Msg_Apple;
			this.signout_Singel_Device_Banner_Header = Label.LS_Signout_Singel_Device_Banner_Header_Apple;
			this.myAccount_ConfirmMsg_Signoutalldevices = Label.LS_MyAccount_ConfirmMsg_Signoutalldevices_Apple;
			this.sign_out_Banner_Header = Label.LS_Sign_out_Banner_Header_Apple;
			this.myAccount_Language_Japanese_Label = Label.LS_MyAccount_Language_Japanese_Label_Apple;
			this.myAccount_Language_English_Label = Label.LS_MyAccount_Language_English_Label_Apple;
			this.myaccount_Language_UnitedKingdom_DE_Label = Label.LS_Myaccount_Language_UnitedKingdom_DE_Label_Apple;
			this.dFD_HOST = Label.DFD_HOST_Apple;
			this.dFD_CONTENT_LENGTH = Label.DFD_CONTENT_LENGTH_Apple;
			this.dFD_PORT = Label.Apple_PORT;
			this.dFD_SetEndpoint = /*Label.Apple_SetEndpoint*/appleEndPoint;
			this.dFD_404 = Label.Apple_404;
			this.dFD_500 = Label.Apple_500;
			this.dFD_300 = Label.Apple_300;	
			this.label_For_Active_Pais_Status = Label.LS_Label_For_Active_Pais_Status;
		} else if (CommunityHelper.IsDfDUser()) {
			/*Start PD-14478*/
		    String docomoEndPoint = (DAZNConfiguration__c.getValues('DFD_SetEndpoint_Docomo') != null) ? DAZNConfiguration__c.getValues('DFD_SetEndpoint_Docomo').Value__c : null;
			/*End PD-14478*/
			this.myAccountTitle = Label.LS_My_Account_Title_Docomo;
			this.button_OK = Label.LS_Button_OK_Docomo;
			this.myAccount_Banner_Button_Start_Watching_DAZN = Label.LS_MyAccount_Banner_Button_Start_Watching_DAZN_Docomo;
			this.button_YesDeregister = Label.LS_Button_YesDeregister_Docomo;
			this.partnerAcc_Label_PersonalDesc = Label.LS_PartnerAcc_Label_PersonalDesc_Docomo;
			this.partnerAcc_Label_termsofUse = Label.LS_PartnerAcc_Label_termsofUse_Docomo;
			this.myAccount_Label_My_Details = Label.LS_MyAccount_Label_My_Details_Docomo;
			this.partnerAcc_Label_PersonalDescAnd = Label.LS_PartnerAcc_Label_PersonalDescAnd_Docomo;
			this.partnerAcc_Label_PrivacyPolicy = Label.LS_PartnerAcc_Label_PrivacyPolicy_Docomo;
			this.partnerAcc_Label_PersonalDesc_Part1 = Label.LS_PartnerAcc_Label_PersonalDesc_Part1_Docomo;
			this.partnerAcc_Label_PersonalDesc_Part2 = Label.LS_PartnerAcc_Label_PersonalDesc_Part2_Docomo;
			this.myAccount_Name = Label.LS_MyAccount_Name_Docomo;
			this.myAccount_EmailAddress = Label.LS_MyAccount_EmailAddress_Docomo;
			this.button_Edit = Label.LS_Button_Edit_Docomo;
			this.myAccount_Label_Firstname = Label.LS_MyAccount_Label_Firstname_Docomo;
			this.myAccount_Label_Surname = Label.LS_MyAccount_Label_Surname_Docomo;
			this.button_Save = Label.LS_Button_Save_Docomo;
			this.button_Cancel = Label.LS_Button_Cancel_Docomo;
			this.myAccount_Label_Membership = Label.LS_MyAccount_Label_Membership_Docomo;
			this.button_Manage = Label.LS_Button_Manage_Docomo;
			this.myAccount_Cancelling_Subscription_Info = Label.LS_MyAccount_Cancelling_Subscription_Info_Docomo;
			this.myAccount_Link_ViewPaymentHistory = Label.LS_MyAccount_Link_ViewPaymentHistory_Docomo;
			this.myAccount_Label_PaymentMethod = Label.LS_MyAccount_Label_PaymentMethod_Docomo;
			this.button_Change = Label.LS_Button_Change_Docomo;
			this.button_CancelSubscription = Label.LS_Button_CancelSubscription_Docomo;
			this.myAccount_Label_MyDevices = Label.LS_MyAccount_Label_MyDevices_Docomo;
			this.myAccount_Label_Registered = Label.LS_MyAccount_Label_Registered_Docomo;
			this.button_Deregister_Single_Device = Label.LS_Button_Deregister_Single_Device_Docomo;
			this.myAccount_InfoMsg_NoRegisteredDevices = Label.LS_MyAccount_InfoMsg_NoRegisteredDevices_Docomo;
			this.myAccount_Button_SignOutAllDevices = Label.LS_MyAccount_Button_SignOutAllDevices_Docomo;
			this.myAccount_Label_Language = Label.LS_MyAccount_Label_Language_Docomo;
			this.myaccount_Label_LanguageSection = Label.LS_Myaccount_Label_LanguageSection_Docomo;
			this.myAccount_Label_Save_Language = Label.LS_MyAccount_Label_Save_Language_Docomo;
			this.partnerAcc_Label_EmailPref = Label.LS_PartnerAcc_Label_EmailPref_Docomo;
			this.partnerAcc_Label_DAZNComm = Label.LS_PartnerAcc_Label_DAZNComm_Docomo;
			this.myAccount_ErrMsg_Valid_Firstname = Label.LS_MyAccount_ErrMsg_Valid_Firstname_Docomo;
			this.myAccount_ErrMsg_Valid_Surname = Label.LS_MyAccount_ErrMsg_Valid_Surname_Docomo;
			this.myAccount_ErrMsg_InvalidEmailID = Label.LS_MyAccount_ErrMsg_InvalidEmailID_Docomo;
			this.myAccount_ErrMsg_NoMatch = Label.LS_MyAccount_ErrMsg_NoMatch_Docomo;
			this.myAccount_ErrMsg_Min5Chars = Label.LS_MyAccount_ErrMsg_Min5Chars_Docomo;
			this.myAccount_ErrMsg_AtleastOneChar = Label.LS_MyAccount_ErrMsg_AtleastOneChar_Docomo;
			this.myAccount_ErrMsg_NewPwdAndRepeatPwdDoNotMatch = Label.LS_MyAccount_ErrMsg_NewPwdAndRepeatPwdDoNotMatch_Docomo;
			this.partnerAcct_URL = Label.LS_PartnerAcct_URL_Docomo;
			this.partnerAcc_Label_ErrorMsg = Label.LS_PartnerAcc_Label_ErrorMsg_Docomo;

			/*Labels from Controller*/
			this.paymentHistory_Label_Ending = Label.LS_PaymentHistory_Label_Ending_Docomo;
			this.paymentHistory_Label_Directdebit = Label.LS_PaymentHistory_Label_Directdebit_Docomo;
			this.change_payment_ErrMsg = Label.LS_Change_payment_ErrMsg_Docomo;
			this.zuora_ConnectionError = Label.LS_Zuora_ConnectionError_Docomo;
			this.myaccount_ErrMsg_ProvideNewEmail = Label.LS_Myaccount_ErrMsg_ProvideNewEmail_Docomo;
			this.myAccount_ErrMsg_DocomoEmailIDExists = Label.LS_MyAccount_ErrMsg_DocomoEmailIDExists_Docomo;
			this.myAccount_Button_ViewMore = Label.LS_MyAccount_Button_ViewMore_Docomo;
			this.myaccount_Dropdown = Label.LS_Myaccount_Dropdown_Docomo;
			this.myAccount_SignOut_TaskSubject = Label.LS_MyAccount_SignOut_TaskSubject_Docomo;
			this.myAccount_SignOut_TaskDesc = Label.LS_MyAccount_SignOut_TaskDesc_Docomo;
			this.warning_Popup_Msg = Label.LS_Warning_Popup_Msg_Docomo;
			this.signout_Singel_Device_Banner_Header = Label.LS_Signout_Singel_Device_Banner_Header_Docomo;
			this.myAccount_ConfirmMsg_Signoutalldevices = Label.LS_MyAccount_ConfirmMsg_Signoutalldevices_Docomo;
			this.sign_out_Banner_Header = Label.LS_Sign_out_Banner_Header_Docomo;
			this.myAccount_Language_Japanese_Label = Label.LS_MyAccount_Language_Japanese_Label_Docomo;
			this.myAccount_Language_English_Label = Label.LS_MyAccount_Language_English_Label_Docomo;
			this.myaccount_Language_UnitedKingdom_DE_Label = Label.LS_Myaccount_Language_UnitedKingdom_DE_Label_Docomo;
			this.dFD_HOST = Label.DFD_HOST_Docomo;
			this.dFD_CONTENT_LENGTH = Label.DFD_CONTENT_LENGTH_Docomo;
			this.dFD_PORT = Label.DFD_PORT_Docomo;
			this.dFD_SetEndpoint = /*Label.DFD_SetEndpoint_Docomo*/docomoEndPoint;
			this.dFD_404 = Label.DFD_404_Docomo;
			this.dFD_500 = Label.DFD_500_Docomo;
			this.dFD_300 = Label.DFD_300_Docomo;
		} else {
			this.myAccountTitle = Label.LS_My_Account_Title;
			this.button_OK = Label.LS_Button_OK;
			this.myAccount_Banner_Button_Start_Watching_DAZN = Label.LS_MyAccount_Banner_Button_Start_Watching_DAZN;
			this.button_YesDeregister = Label.LS_Button_YesDeregister;
			this.partnerAcc_Label_PersonalDesc = Label.LS_PartnerAcc_Label_PersonalDesc;
			this.partnerAcc_Label_termsofUse = Label.LS_PartnerAcc_Label_termsofUse;
			this.myAccount_Label_My_Details = Label.LS_MyAccount_Label_My_Details;
			this.partnerAcc_Label_PersonalDescAnd = Label.LS_PartnerAcc_Label_PersonalDescAnd;
			this.partnerAcc_Label_PrivacyPolicy = Label.LS_PartnerAcc_Label_PrivacyPolicy;
			this.partnerAcc_Label_PersonalDesc_Part1 = Label.LS_PartnerAcc_Label_PersonalDesc_Part1;
			this.partnerAcc_Label_PersonalDesc_Part2 = Label.LS_PartnerAcc_Label_PersonalDesc_Part2;
			this.myAccount_Name = Label.LS_MyAccount_Name;
			this.myAccount_EmailAddress = Label.LS_MyAccount_EmailAddress;
			this.button_Edit = Label.LS_Button_Edit;
			this.myAccount_Label_Firstname = Label.LS_MyAccount_Label_Firstname;
			this.myAccount_Label_Surname = Label.LS_MyAccount_Label_Surname;
			this.button_Save = Label.LS_Button_Save;
			this.button_Cancel = Label.LS_Button_Cancel;
			this.myAccount_Label_Membership = Label.LS_MyAccount_Label_Membership;
			this.button_Manage = Label.LS_Button_Manage;
			this.myAccount_Cancelling_Subscription_Info = Label.LS_MyAccount_Cancelling_Subscription_Info;
			this.myAccount_Link_ViewPaymentHistory = Label.LS_MyAccount_Link_ViewPaymentHistory;
			this.myAccount_Label_PaymentMethod = Label.LS_MyAccount_Label_PaymentMethod;
			this.button_Change = Label.LS_Button_Change;
			this.button_CancelSubscription = Label.LS_Button_CancelSubscription;
			this.myAccount_Label_MyDevices = Label.LS_MyAccount_Label_MyDevices;
			this.myAccount_Label_Registered = Label.LS_MyAccount_Label_Registered;
			this.button_Deregister_Single_Device = Label.LS_Button_Deregister_Single_Device;
			this.myAccount_InfoMsg_NoRegisteredDevices = Label.LS_MyAccount_InfoMsg_NoRegisteredDevices;
			this.myAccount_Button_SignOutAllDevices = Label.LS_MyAccount_Button_SignOutAllDevices;
			this.myAccount_Label_Language = Label.LS_MyAccount_Label_Language;
			this.myaccount_Label_LanguageSection = Label.LS_Myaccount_Label_LanguageSection;
			this.myAccount_Label_Save_Language = Label.LS_MyAccount_Label_Save_Language;
			this.partnerAcc_Label_EmailPref = Label.LS_PartnerAcc_Label_EmailPref;
			this.partnerAcc_Label_DAZNComm = Label.LS_PartnerAcc_Label_DAZNComm;
			this.myAccount_ErrMsg_Valid_Firstname = Label.LS_MyAccount_ErrMsg_Valid_Firstname;
			this.myAccount_ErrMsg_Valid_Surname = Label.LS_MyAccount_ErrMsg_Valid_Surname;
			this.myAccount_ErrMsg_InvalidEmailID = Label.LS_MyAccount_ErrMsg_InvalidEmailID;
			this.myAccount_ErrMsg_NoMatch = Label.LS_MyAccount_ErrMsg_NoMatch;
			this.myAccount_ErrMsg_Min5Chars = Label.LS_MyAccount_ErrMsg_Min5Chars;
			this.myAccount_ErrMsg_AtleastOneChar = Label.LS_MyAccount_ErrMsg_AtleastOneChar;
			this.myAccount_ErrMsg_NewPwdAndRepeatPwdDoNotMatch = Label.LS_MyAccount_ErrMsg_NewPwdAndRepeatPwdDoNotMatch;
			this.partnerAcct_URL = Label.LS_PartnerAcct_URL;
			this.partnerAcc_Label_ErrorMsg = Label.LS_PartnerAcc_Label_ErrorMsg;

			/*Labels from Controller*/
			this.paymentHistory_Label_Ending = Label.LS_PaymentHistory_Label_Ending;
			this.paymentHistory_Label_Directdebit = Label.LS_PaymentHistory_Label_Directdebit;
			this.change_payment_ErrMsg = Label.LS_Change_payment_ErrMsg;
			this.zuora_ConnectionError = Label.LS_Zuora_ConnectionError;
			this.myaccount_ErrMsg_ProvideNewEmail = Label.LS_Myaccount_ErrMsg_ProvideNewEmail;
			this.myAccount_ErrMsg_DocomoEmailIDExists = Label.LS_MyAccount_ErrMsg_DocomoEmailIDExists;
			this.myAccount_Button_ViewMore = Label.LS_MyAccount_Button_ViewMore;
			this.myaccount_Dropdown = Label.LS_Myaccount_Dropdown;
			this.myAccount_SignOut_TaskSubject = Label.LS_MyAccount_SignOut_TaskSubject;
			this.myAccount_SignOut_TaskDesc = Label.LS_MyAccount_SignOut_TaskDesc;
			this.warning_Popup_Msg = Label.LS_Warning_Popup_Msg;
			this.signout_Singel_Device_Banner_Header = Label.LS_Signout_Singel_Device_Banner_Header;
			this.myAccount_ConfirmMsg_Signoutalldevices = Label.LS_MyAccount_ConfirmMsg_Signoutalldevices;
			this.sign_out_Banner_Header = Label.LS_Sign_out_Banner_Header;
			this.myAccount_Language_Japanese_Label = Label.LS_MyAccount_Language_Japanese_Label;
			this.myAccount_Language_English_Label = Label.LS_MyAccount_Language_English_Label;
			this.myaccount_Language_UnitedKingdom_DE_Label = Label.LS_Myaccount_Language_UnitedKingdom_DE_Label;
			this.dFD_HOST = Label.DFD_HOST;
			this.dFD_CONTENT_LENGTH = Label.DFD_CONTENT_LENGTH;
			this.dFD_PORT = Label.DFD_PORT;
			this.dFD_SetEndpoint = Label.DFD_SetEndpoint;
			this.dFD_404 = Label.DFD_404;
			this.dFD_500 = Label.DFD_500;
			this.dFD_300 = Label.DFD_300;
		}
	}
	
}