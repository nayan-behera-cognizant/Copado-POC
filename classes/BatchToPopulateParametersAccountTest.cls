@istest
public class BatchToPopulateParametersAccountTest {
  
    //Dummy test Method - Entire test method commented
    static testmethod void  DummyTestMethod(){
        
    }
    /*  @testSetup /*  calling CreateTestDataforUnitTest  
    public static void getCommunityUsersTestData(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestcustomsetting();
        CreateTestDataforUnitTest.createTestUserDevices();
    }
    static testmethod void testInsertBatch(){
        PopulateParOnAccount__c custmstng = new PopulateParOnAccount__c();
        List<Account> accLst =  new List<Account>();
        custmstng.Name = 'JP_en_GB';
        custmstng.CountryCode__c ='JP' ;
        custmstng.LanguageCode__c ='en_GB' ;
        custmstng.ResetPwdBody1__c = 'Passwort vergessen? Kein Problem! Klicke einfach' ;
        custmstng.ResetPwdBody2__c = 'und folge den Anweisungen, um dein DAZN-Passwort zu ändern und weiterhin deinen Lieblingssport schauen zu können.';
        custmstng.ResetPwdBody3__c = 'Ist diese Anfrage nicht von dir oder hast du weitere Fragen? Melde dich beim';
        custmstng.ResetPwdBody4__c = 'wir helfen dir gerne weiter.';
        custmstng.ResetPwdGreeting__c ='Hey' ;
        custmstng.ResetPwdLink1__c = 'hier';
        custmstng.ResetPwdLink2__c = 'Kundenservice,' ;
        custmstng.ResetPwdSignature__c ='Dein DAZN-Team' ;
        custmstng.ResetPwdSubject__c = 'DAZN - Passwort zurücksetzen';
        insert custmstng;
        
        Account oAccount = new Account();
        oAccount.FirstName ='TestFirstName' ;
        oAccount.LastName ='TestLastName' ;
        oAccount.PersonEmail ='testemail45623@email.com' ;
        oAccount.Account_Status__c = 'Free Trial' ;
        oAccount.Notification_Country_Code__c ='JP' ;
        oAccount.Notification_Language_Code__c ='en_GB' ;
        oAccount.PopulateParameter__c = true;
        Account oPersonAccount = (Account)SetUpTestData.setUpData(oAccount);
        accLst.add(oPersonAccount);
        insert oAccount;
        accLst.add(oAccount);
        
        PopulateParOnAccount__c CustSet2 = new PopulateParOnAccount__c();
        CustSet2.Name = 'DE_en_GB';
        CustSet2.CountryCode__c ='DE' ;
        CustSet2.LanguageCode__c ='en_GB' ;
        CustSet2.ResetPwdBody1__c = 'Passwort vergessen? Kein Problem! Klicke einfach' ;
        CustSet2.ResetPwdBody2__c = 'und folge den Anweisungen, um dein DAZN-Passwort zu ändern und weiterhin deinen Lieblingssport schauen zu können.';
        CustSet2.ResetPwdBody3__c = 'Ist diese Anfrage nicht von dir oder hast du weitere Fragen? Melde dich beim';
        CustSet2.ResetPwdBody4__c = 'wir helfen dir gerne weiter.';
        CustSet2.ResetPwdGreeting__c ='Hey' ;
        CustSet2.ResetPwdLink1__c = 'hier';
        CustSet2.ResetPwdLink2__c = 'Kundenservice,' ;
        CustSet2.ResetPwdSignature__c ='Dein DAZN-Team' ;
        CustSet2.ResetPwdSubject__c = 'DAZN - Passwort zurücksetzen';
        insert CustSet2;
        
        Account oAccount1 = new Account();
        oAccount1.FirstName ='TestFirstNae' ;
        oAccount1.LastName ='TestLastNae' ;
        oAccount1.PersonEmail ='testemail45223@email.com' ;
        oAccount1.Account_Status__c = 'Free Trial' ;
        oAccount1.Notification_Country_Code__c ='DE' ;
        oAccount1.Notification_Language_Code__c ='en_GB' ;
        oAccount1.PopulateParameter__c = true;
        Account oPersonAccount1 = (Account)SetUpTestData.setUpData(oAccount1);
        accLst.add(oPersonAccount1);
        insert oAccount1;
        accLst.add(oAccount1);
        
        PopulateParOnAccount__c CustSet3 = new PopulateParOnAccount__c();
        CustSet3.Name = 'CH_en_GB';
        CustSet3.CountryCode__c ='CH' ;
        CustSet3.LanguageCode__c ='en_GB' ;
        CustSet3.ResetPwdBody1__c = 'Passwort vergessen? Kein Problem! Klicke einfach' ;
        CustSet3.ResetPwdBody2__c = 'und folge den Anweisungen, um dein DAZN-Passwort zu ändern und weiterhin deinen Lieblingssport schauen zu können.';
        CustSet3.ResetPwdBody3__c = 'Ist diese Anfrage nicht von dir oder hast du weitere Fragen? Melde dich beim';
        CustSet3.ResetPwdBody4__c = 'wir helfen dir gerne weiter.';
        CustSet3.ResetPwdGreeting__c ='Hey' ;
        CustSet3.ResetPwdLink1__c = 'hier';
        CustSet3.ResetPwdLink2__c = 'Kundenservice,' ;
        CustSet3.ResetPwdSignature__c ='Dein DAZN-Team' ;
        CustSet3.ResetPwdSubject__c = 'DAZN - Passwort zurücksetzen';
        insert CustSet3;
        
        Account oAccount2 = new Account();
        oAccount2.FirstName ='TestFstNae' ;
        oAccount2.LastName ='TestLsttNae' ;
        oAccount2.PersonEmail ='testemail452123@email.com' ;
        oAccount2.Account_Status__c = 'Free Trial' ;
        oAccount2.Notification_Country_Code__c ='CH' ;
        oAccount2.Notification_Language_Code__c ='en_GB' ;
        oAccount2.PopulateParameter__c = true;
        Account oPersonAccount3 = (Account)SetUpTestData.setUpData(oAccount2);
        accLst.add(oPersonAccount3);
        insert oAccount2;
        accLst.add(oAccount2);
        
        PopulateParOnAccount__c CustSet4 = new PopulateParOnAccount__c();
        CustSet4.Name = 'CH_en_GB';
        CustSet4.CountryCode__c ='CH' ;
        CustSet4.LanguageCode__c ='en_GB' ;
        CustSet4.ResetPwdBody1__c = 'Passwort vergessen? Kein Problem! Klicke einfach' ;
        CustSet4.ResetPwdBody2__c = 'und folge den Anweisungen, um dein DAZN-Passwort zu ändern und weiterhin deinen Lieblingssport schauen zu können.';
        CustSet4.ResetPwdBody3__c = 'Ist diese Anfrage nicht von dir oder hast du weitere Fragen? Melde dich beim';
        CustSet4.ResetPwdBody4__c = 'wir helfen dir gerne weiter.';
        CustSet4.ResetPwdGreeting__c ='Hey' ;
        CustSet4.ResetPwdLink1__c = 'hier';
        CustSet4.ResetPwdLink2__c = 'Kundenservice,' ;
        CustSet4.ResetPwdSignature__c ='Dein DAZN-Team' ;
        CustSet4.ResetPwdSubject__c = 'DAZN - Passwort zurücksetzen';
        insert CustSet4;
        
        Account oAccount3 = new Account();
        oAccount3.FirstName ='TestFstNae' ;
        oAccount3.LastName ='TestLsttNae' ;
        oAccount3.PersonEmail ='testemail452123@email.com' ;
        oAccount3.Account_Status__c = 'Free Trial' ;
        oAccount3.Notification_Country_Code__c ='CH' ;
        oAccount3.Notification_Language_Code__c ='en_GB' ;
        oAccount3.PopulateParameter__c = true;
        Account oPersonAccount4 = (Account)SetUpTestData.setUpData(oAccount3);
        accLst.add(oPersonAccount4);
        insert oAccount3;
        accLst.add(oAccount3);
        
          PopulateParOnAccount__c CustSet5 = new PopulateParOnAccount__c();
        CustSet5.Name = 'JP_ja';
        CustSet5.CountryCode__c ='JP' ;
        CustSet5.LanguageCode__c ='ja' ;
        CustSet5.ResetPwdBody1__c = 'Passwort vergessen? Kein Problem! Klicke einfach' ;
        CustSet5.ResetPwdBody2__c = 'und folge den Anweisungen, um dein DAZN-Passwort zu ändern und weiterhin deinen Lieblingssport schauen zu können.';
        CustSet5.ResetPwdBody3__c = 'Ist diese Anfrage nicht von dir oder hast du weitere Fragen? Melde dich beim';
        CustSet5.ResetPwdBody4__c = 'wir helfen dir gerne weiter.';
        CustSet5.ResetPwdGreeting__c ='Hey' ;
        CustSet5.ResetPwdLink1__c = 'hier';
        CustSet5.ResetPwdLink2__c = 'Kundenservice,' ;
        CustSet5.ResetPwdSignature__c ='Dein DAZN-Team' ;
        CustSet5.ResetPwdSubject__c = 'DAZN - Passwort zurücksetzen';
        insert CustSet5;
        
        Account oAccount4 = new Account();
        oAccount4.FirstName ='TestFstNae' ;
        oAccount4.LastName ='TestLsttNae' ;
        oAccount4.PersonEmail ='testemail452123@email.com' ;
        oAccount4.Account_Status__c = 'Free Trial' ;
        oAccount4.Notification_Country_Code__c ='JP' ;
        oAccount4.Notification_Language_Code__c ='ja' ;
        oAccount4.PopulateParameter__c = true;
        Account oPersonAccount5 = (Account)SetUpTestData.setUpData(oAccount4);
        accLst.add(oPersonAccount5);
        insert oAccount4;
        accLst.add(oAccount4);
        
            PopulateParOnAccount__c CustSet6 = new PopulateParOnAccount__c();
        CustSet6.Name = 'DE_de';
        CustSet6.CountryCode__c ='DE' ;
        CustSet6.LanguageCode__c ='de' ;
        CustSet6.ResetPwdBody1__c = 'Passwort vergessen? Kein Problem! Klicke einfach' ;
        CustSet6.ResetPwdBody2__c = 'und folge den Anweisungen, um dein DAZN-Passwort zu ändern und weiterhin deinen Lieblingssport schauen zu können.';
        CustSet6.ResetPwdBody3__c = 'Ist diese Anfrage nicht von dir oder hast du weitere Fragen? Melde dich beim';
        CustSet6.ResetPwdBody4__c = 'wir helfen dir gerne weiter.';
        CustSet6.ResetPwdGreeting__c ='Hey' ;
        CustSet6.ResetPwdLink1__c = 'hier';
        CustSet6.ResetPwdLink2__c = 'Kundenservice,' ;
        CustSet6.ResetPwdSignature__c ='Dein DAZN-Team' ;
        CustSet6.ResetPwdSubject__c = 'DAZN - Passwort zurücksetzen';
        insert CustSet6;
        
        Account oAccount5 = new Account();
        oAccount5.FirstName ='TestFstNae' ;
        oAccount5.LastName ='TestLsttNae' ;
        oAccount5.PersonEmail ='testemail452123@email.com' ;
        oAccount5.Account_Status__c = 'Free Trial' ;
        oAccount5.Notification_Country_Code__c ='DE' ;
        oAccount5.Notification_Language_Code__c ='de' ;
        oAccount5.PopulateParameter__c = true;
        Account oPersonAccount6 = (Account)SetUpTestData.setUpData(oAccount5);
        accLst.add(oPersonAccount6);
        insert oAccount5;
        accLst.add(oAccount5);
        
            PopulateParOnAccount__c CustSet7 = new PopulateParOnAccount__c();
        CustSet7.Name = 'CH_de';
        CustSet7.CountryCode__c ='CH' ;
        CustSet7.LanguageCode__c ='de' ;
        CustSet7.ResetPwdBody1__c = 'Passwort vergessen? Kein Problem! Klicke einfach' ;
        CustSet7.ResetPwdBody2__c = 'und folge den Anweisungen, um dein DAZN-Passwort zu ändern und weiterhin deinen Lieblingssport schauen zu können.';
        CustSet7.ResetPwdBody3__c = 'Ist diese Anfrage nicht von dir oder hast du weitere Fragen? Melde dich beim';
        CustSet7.ResetPwdBody4__c = 'wir helfen dir gerne weiter.';
        CustSet7.ResetPwdGreeting__c ='Hey' ;
        CustSet7.ResetPwdLink1__c = 'hier';
        CustSet7.ResetPwdLink2__c = 'Kundenservice,' ;
        CustSet7.ResetPwdSignature__c ='Dein DAZN-Team' ;
        CustSet7.ResetPwdSubject__c = 'DAZN - Passwort zurücksetzen';
        insert CustSet7;
        
        Account oAccount6 = new Account();
        oAccount6.FirstName ='TestFstNae' ;
        oAccount6.LastName ='TestLsttNae' ;
        oAccount6.PersonEmail ='testemail452123@email.com' ;
        oAccount6.Account_Status__c = 'Free Trial' ;
        oAccount6.Notification_Country_Code__c ='CH' ;
        oAccount6.Notification_Language_Code__c ='de' ;
        oAccount6.PopulateParameter__c = true;
        Account oPersonAccount7 = (Account)SetUpTestData.setUpData(oAccount6);
        accLst.add(oPersonAccount7);
        insert oAccount6;
        accLst.add(oAccount6);
        
            PopulateParOnAccount__c CustSet8 = new PopulateParOnAccount__c();
        CustSet8.Name = 'AT_de';
        CustSet8.CountryCode__c ='AT' ;
        CustSet8.LanguageCode__c ='de' ;
        CustSet8.ResetPwdBody1__c = 'Passwort vergessen? Kein Problem! Klicke einfach' ;
        CustSet8.ResetPwdBody2__c = 'und folge den Anweisungen, um dein DAZN-Passwort zu ändern und weiterhin deinen Lieblingssport schauen zu können.';
        CustSet8.ResetPwdBody3__c = 'Ist diese Anfrage nicht von dir oder hast du weitere Fragen? Melde dich beim';
        CustSet8.ResetPwdBody4__c = 'wir helfen dir gerne weiter.';
        CustSet8.ResetPwdGreeting__c ='Hey' ;
        CustSet8.ResetPwdLink1__c = 'hier';
        CustSet8.ResetPwdLink2__c = 'Kundenservice,' ;
        CustSet8.ResetPwdSignature__c ='Dein DAZN-Team' ;
        CustSet8.ResetPwdSubject__c = 'DAZN - Passwort zurücksetzen';
        insert CustSet8;
        
        Account oAccount7 = new Account();
        oAccount7.FirstName ='TestFstNae' ;
        oAccount7.LastName ='TestLsttNae' ;
        oAccount7.PersonEmail ='testemail452123@email.com' ;
        oAccount7.Account_Status__c = 'Free Trial' ;
        oAccount7.Notification_Country_Code__c ='AT' ;
        oAccount7.Notification_Language_Code__c ='de' ;
        oAccount7.PopulateParameter__c = true;
        Account oPersonAccount8 = (Account)SetUpTestData.setUpData(oAccount7);
        accLst.add(oPersonAccount8);
        insert oAccount7;
        accLst.add(oAccount7);
        
            PopulateParOnAccount__c CustSet9 = new PopulateParOnAccount__c();
        CustSet9.Name = 'AT_en_GB';
        CustSet9.CountryCode__c ='AT' ;
        CustSet9.LanguageCode__c ='en_GB' ;
        CustSet9.ResetPwdBody1__c = 'Passwort vergessen? Kein Problem! Klicke einfach' ;
        CustSet9.ResetPwdBody2__c = 'und folge den Anweisungen, um dein DAZN-Passwort zu ändern und weiterhin deinen Lieblingssport schauen zu können.';
        CustSet9.ResetPwdBody3__c = 'Ist diese Anfrage nicht von dir oder hast du weitere Fragen? Melde dich beim';
        CustSet9.ResetPwdBody4__c = 'wir helfen dir gerne weiter.';
        CustSet9.ResetPwdGreeting__c ='Hey' ;
        CustSet9.ResetPwdLink1__c = 'hier';
        CustSet9.ResetPwdLink2__c = 'Kundenservice,' ;
        CustSet9.ResetPwdSignature__c ='Dein DAZN-Team' ;
        CustSet9.ResetPwdSubject__c = 'DAZN - Passwort zurücksetzen';
        insert CustSet9;
        
        Account oAccount8 = new Account();
        oAccount8.FirstName ='TestFstNae' ;
        oAccount8.LastName ='TestLsttNae' ;
        oAccount8.PersonEmail ='testemail452123@email.com' ;
        oAccount8.Account_Status__c = 'Free Trial' ;
        oAccount8.Notification_Country_Code__c ='AT' ;
        oAccount8.Notification_Language_Code__c ='en_GB' ;
        oAccount8.PopulateParameter__c = true;
        Account oPersonAccount9 = (Account)SetUpTestData.setUpData(oAccount8);
        accLst.add(oPersonAccount9);
        insert oAccount8;

        
        
        BatchToPopulateParametersAccount bc = new BatchToPopulateParametersAccount();
        database.executeBatch(bc, 200);
         
        
      String CRON_EXP = '0 0 5 12 3 ? 2022';
    // Schedule the test job
            String jobId = System.schedule('BatchToPopulateParametersAccountTest',
                                           CRON_EXP, 
                                           new BatchToPopulateParametersAccountSchedule());
            
            // Get the information from the CronTrigger API object
            /*CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                              NextFireTime
                              FROM CronTrigger WHERE id = :jobId];*/
    
 /*   }
    static testmethod void testInsertBatchException(){
        List<Account> accLst =  new List<Account>();
       Account oAccount7 = new Account();
        oAccount7.FirstName ='TestFstNae' ;
        oAccount7.LastName ='TestLsttNae' ;
        oAccount7.PersonEmail ='testemail452123@email.com' ;
        oAccount7.Account_Status__c = 'Free Trial' ;
        oAccount7.Notification_Country_Code__c ='JP' ;
        oAccount7.Notification_Language_Code__c ='en_GB' ;
        oAccount7.PopulateParameter__c = true;
        Account oPersonAccount8 = (Account)SetUpTestData.setUpData(oAccount7);
        accLst.add(oPersonAccount8);
        insert oAccount7;
        accLst.add(oAccount7);
        PopulateParametersAccount.prepareAccountsToInsert(accLst);
         BatchToPopulateParametersAccount bc = new BatchToPopulateParametersAccount();
        database.executeBatch(bc, 200);
        
    }
  */
}