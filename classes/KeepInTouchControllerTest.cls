@isTest
private class KeepInTouchControllerTest {

    @testSetup
    public static void setUpTestData() {
        List<DAZN_Country_Currency_ISO_Code__c> currencyCodes = new List<DAZN_Country_Currency_ISO_Code__c>();
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'CAD',
            CurrencySymbol__c = '$'
        ));
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'CHF',
            CurrencySymbol__c = 'CHF'
        ));
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'CNY',
            CurrencySymbol__c = '元'
        ));
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'EUR',
            CurrencySymbol__c = '€'
        ));
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'GBP',
            CurrencySymbol__c = '£'
        ));
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'JPY',
            CurrencySymbol__c = '¥'
        ));
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'KRW',
            CurrencySymbol__c = '₩'
        ));
        currencyCodes.add(new DAZN_Country_Currency_ISO_Code__c(
            Name = 'USD',
            CurrencySymbol__c = '$'
        ));
        insert currencyCodes;

        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'te@test.com', 'Active Paid');
    }

    public static void insertZuoraIntegrationParameters() {
        List<DAZNConfiguration__c> config = new List<DAZNConfiguration__c>();
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraStandardPauseResumeScheduleUrl',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/9/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraCancelPauseBeforeStartURL',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/151/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraChangeResumeDatesWhileInPauseURL',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/150/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraChangeResumeDatesBeforePauseURL',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/285/run'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseUsername',
            Value__c = 'david.francesconi@dazn.com'
        ));
        config.add(new DAZNConfiguration__c(
            Name = 'ZuoraPausePassword',
            Value__c = '58c89e0f46f549eded0a140e8d9a842f'
        ));
        insert config; 
    }

    @isTest
    static void testConstructor() {
        Account oAccount = [Select Id, Notification_Country_Code__c, Notification_Language_Code__c, Payment_Type_Last_Digits_and_Expiry_Date__c, FirstName, LastName From Account];
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'testemail@email.com', 'testusername12@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_US', 'en_US', 'TestFName', 'TestLName', true);
        User oUser = [Select Id, ContactId From User Where Id = :cUser.Id];

        Test.startTest();
        System.runAs(oUser) {
            ApexPages.currentPage().getParameters().put('pauseAction', 'initiate');
            KeepInTouchController keepInTouchController = new KeepInTouchController();
            System.assertNotEquals(null, keepInTouchController);
            System.assertEquals('initPause', keepInTouchController.bannerType);

            ApexPages.currentPage().getParameters().put('pauseAction', 'amend');
            KeepInTouchController keepInTouchController1 = new KeepInTouchController();
            System.assertNotEquals(null, keepInTouchController1);
            System.assertEquals('amendedPause', keepInTouchController1.bannerType);
        }
        Test.stopTest();
    }

}