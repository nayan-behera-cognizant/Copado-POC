public with sharing class SubmittedForCancelRedirectController {

	public Account oAccount { get; set; }

	public SubmittedForCancelRedirectController() {
		User user = CommunityHelper.getCurrentUser();
		if (user != null && user.AccountId != null) {
			oAccount = CommunityHelper.getAccountInfo(user.AccountId);
		}
	}

}