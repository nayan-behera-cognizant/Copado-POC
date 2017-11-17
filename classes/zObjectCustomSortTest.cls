@isTest(seeAllData = true)
private class zObjectCustomSortTest {
	
	@isTest static void testConstructor() {
		Zuora.zObject sub = new Zuora.zObject('Subscription');
        sub.setValue('CreatedDate', '2011-04-01');
        sub.setValue('Status', 'Active');
        sub.setValue('TermEndDate', '2011-04-01');
        sub.setValue('SubscriptionEndDate', '2011-04-01');
        sub.setValue('Id', 'testsubId');
        sub.setValue('AccountId', 'testAccountId');

        zObjectCustomSort zObjCustomSort = new zObjectCustomSort(sub);
        System.assertNotEquals(null, zObjCustomSort);
	}
	
	@isTest static void testCompareTo() {
		Zuora.zObject sub1 = new Zuora.zObject('Subscription');
        sub1.setValue('CreatedDate', DateTime.now());
        zObjectCustomSort zObjCustomSort1 = new zObjectCustomSort(sub1);

        Zuora.zObject sub2 = new Zuora.zObject('Subscription');
        sub2.setValue('CreatedDate', DateTime.now() + 1);
        zObjectCustomSort zObjCustomSort2 = new zObjectCustomSort(sub2);

        Zuora.zObject sub3 = new Zuora.zObject('Subscription');
        sub3.setValue('CreatedDate', DateTime.now() - 1);
        zObjectCustomSort zObjCustomSort3 = new zObjectCustomSort(sub3);

        integer res12 = zObjCustomSort1.compareTo(zObjCustomSort2);
        System.assertEquals(1, res12);

        integer res13 = zObjCustomSort1.compareTo(zObjCustomSort3);
        System.assertEquals(-1, res13);
	}
	
}