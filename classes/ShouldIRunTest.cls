@isTest
private class ShouldIRunTest {
	
	@isTest 
	static void testShouldIRun() {
		shouldIRun.stopTrigger();
		System.assertEquals(shouldIRun.allow, false);
	}

	@isTest 
	static void testShouldIRuncanIRun() {
		System.assertEquals(shouldIRun.canIRun(), true	);
	}
	
}