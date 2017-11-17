@isTest
private class GiftCodeHelperTest {
    
    @isTest static void testGetLatesGiftCodeEndDate() {
        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'te@test.com', 'Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'uniqueemail123@email.com', 'uniqueemail123@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_GB', 'en_GB', 'PauseUserFName', 'PauseUserLName', true);

        System.runAs(cUser) {
            Date giftCodeEndDate0 = GiftCodeHelper.getLatesGiftCodeEndDate(oAccount.Id);
            System.assertEquals(null, giftCodeEndDate0);
    
            CountryListForGiftCode__c cs = new CountryListForGiftCode__c (Name = 'US', IsGiftCodeAvailable__c = true);
            insert cs;
    
            Date giftCodeEndDate1 = GiftCodeHelper.getLatesGiftCodeEndDate(oAccount.Id);
            System.assertEquals(null, giftCodeEndDate1);
        }
    
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD', '1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Test Zuora', 'Active', System.today(), System.today() + 30);
        
        zSubsp.Free_Trial_End_Date__c = Date.today();
        zSubsp.Zuora__SubscriptionStartDate__c = Date.today();
        zSubsp.Giftcode__c = 'test';
        zSubsp.NumGiftPeriods__c = '1';
        update zSubsp;

        System.runAs(cUser) {
            Date giftCodeEndDate2 = GiftCodeHelper.getLatesGiftCodeEndDate(oAccount.Id);
            System.assertEquals([Select Id, Gift_Code_End_Date__c From Zuora__Subscription__c Where Id = :zSubsp.Id LIMIT 1].Gift_Code_End_Date__c, giftCodeEndDate2);
    
            Gift_Code_History__c gch = new Gift_Code_History__c();
            gch.Name = 'test';
            gch.Account__c = oAccount.Id;
            gch.Gift_Code_End_Date__c = Date.today() + 40;
            insert gch;
            Date giftCodeEndDate3 = GiftCodeHelper.getLatesGiftCodeEndDate(oAccount.Id);
            System.assertEquals(gch.Gift_Code_End_Date__c, giftCodeEndDate3);
    
            GiftCodeHelper.getLatesGiftCodeEndDate(oAccount.Id);
        }
    }
    
    @isTest static void testIsGiftCodeEndDateExpire() {
        CountryListForGiftCode__c cs = new CountryListForGiftCode__c (Name = 'US', IsGiftCodeAvailable__c = true);
        insert cs;

        SetUpTestData.triggerSettings();
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName', 'te@test.com', 'Free Trial');
        User cUser = SetUpTestData.createCommunityUser(oAccount.Id, 'uniqueemail123@email.com', 'uniqueemail123@email.com', 'tstals', 'Europe/London', 'ISO-8859-1', 'en_GB', 'en_GB', 'PauseUserFName', 'PauseUserLName', true);
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id, 'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD', '1st of the month');
        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id, bAccount.Id, 'Test Zuora', 'Active', System.today(), System.today() + 30);

        System.runAs(cUser) {
            Boolean isGiftCodeEndDateExpire1 = GiftCodeHelper.isGiftCodeEndDateExpire(oAccount.Id);
            System.assertEquals(false, isGiftCodeEndDateExpire1);
    
            Gift_Code_History__c gch = new Gift_Code_History__c();
            gch.Name = 'test';
            gch.Account__c = oAccount.Id;
            gch.Gift_Code_End_Date__c = Date.today() + 10;
            insert gch;
            Boolean isGiftCodeEndDateExpire2 = GiftCodeHelper.isGiftCodeEndDateExpire(oAccount.Id);
            System.assertEquals(true, isGiftCodeEndDateExpire2);
        }
    }
    
    
    static testMethod void TestcheckPaymentMethod() {
        SetUpTestData.triggerSettings();

        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','uniqueemail123@email.com','Active Paid');
           
        User cUser = SetUpTestData.createCommunityUser('de', 'DE', oAccount.Id, 'uniqueemail123@email.com', 'uniqueemail123@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','PauseUserFName','PauseUserLName',true);
        
        Zuora__CustomerAccount__c bAccount = SetUpTestData.createBillingAccount(oAccount.Id,'test billing account', 'Active', 'A00000073', 'testbill Name', 'United Kingdom', 'test bill name', 'Credit Card', 'batch2', 'USD','1st of the month');
        bAccount.Zuora__Default_Payment_Method__c = null ;
        bAccount.Zuora__AutoPay__c = False ;
        update bAccount  ;
        
        System.assertNotEquals(bAccount.Zuora__AutoPay__c , True);

        Zuora__Subscription__c zSubsp = SetUpTestData.createZuoraSubscription(oAccount.Id ,bAccount.Id, 'Test Zuora', 'Active', System.today(), system.today()+30);
        zSubsp.Zuora__NextChargeDate__c = Date.today() + 10;
        zSubsp.NumGiftPeriods__c = '1';
        zSubsp.Zuora__SubscriptionStartDate__c = Date.today() ;
        update zSubsp ; 
        
        Zuora__ZInvoice__c zInv = SetUpTestData.createZuoraInvoice(oAccount.Id, bAccount.Id, 0.00 );
        Zuora__Payment__c zPay = SetUpTestData.createZuoraPayment(oAccount.Id,bAccount.Id,zInv.Id, 0.00); 
        
        System.assertNotEquals(null, zSubsp );

        Test.StartTest();
        
        System.RunAs(cUser) {
        
            GiftCodeHelper.checkPaymentMethod(zSubsp ,bAccount);
            GiftCodeHelper.getSubscriptionWithGigtInfo(oAccount.id);
        }
        Test.StopTest();
    }


     static testMethod void TestcheckRedeemLinkCriteria() {
         SetUpTestData.triggerSettings();
       
       List<CountryListForGiftCode__c > lstCustomSetting  = new List<CountryListForGiftCode__c >();
         
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='AT',  IsGiftCodeAvailable__c= True));
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='CH',  IsGiftCodeAvailable__c= True));
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='DE',  IsGiftCodeAvailable__c= True));
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='JP',  IsGiftCodeAvailable__c= True));
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='CA',  IsGiftCodeAvailable__c= True));
        
        insert lstCustomSetting  ; 
        
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','uniqueemail123@email.com','Active Paid');
        oAccount.Submitted_for_cancellation__c  = False ;
        oAccount.Pause_From__c = null;
        oAccount.Pause_Until__c = null;
        oAccount.Cancelled_Account__c  = False ;
        
        update oAccount;
        
         
        System.assertEquals(oAccount.Submitted_for_cancellation__c, False);
        System.assertEquals(oAccount.PauseScheduled__c , False);
        System.assertEquals(oAccount.Cancelled_Account__c, False);
        
        User cUser = SetUpTestData.createCommunityUser('de', 'DE', oAccount.Id, 'uniqueemail123@email.com', 'uniqueemail123@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','PauseUserFName','PauseUserLName',true);
        
        
        Test.StartTest();
        
        System.RunAs(cUser) {
        
            GiftCodeHelper.checkGiftCodeAvailable(cUser);
           
            GiftCodeHelper.checkRedeemLinkCriteria(oAccount , cUser );
            GiftCodeHelper.checkRedeemLinkCriteria(cUser);
            
            
        }
        Test.StopTest();
    }
  
  
  
     static testMethod void TestcheckRedeemLinkFalseCriteria() {
         SetUpTestData.triggerSettings();
       
        List<CountryListForGiftCode__c > lstCustomSetting  = new List<CountryListForGiftCode__c >();
         
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='AT',  IsGiftCodeAvailable__c= True));
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='CH',  IsGiftCodeAvailable__c= True));
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='DE',  IsGiftCodeAvailable__c= True));
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='JP',  IsGiftCodeAvailable__c= True));
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='CA',  IsGiftCodeAvailable__c= True));
        
         insert lstCustomSetting  ; 
    
        Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','uniqueemail123@email.com','Active Paid');
        oAccount.Submitted_for_cancellation__c  = True;
       
        update oAccount;
        
         
        System.assertEquals(oAccount.Submitted_for_cancellation__c, True);
        
        User cUser = SetUpTestData.createCommunityUser('de', 'DE', oAccount.Id, 'uniqueemail123@email.com', 'uniqueemail123@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','PauseUserFName','PauseUserLName',true);
        
        
        Test.StartTest();
        
        System.RunAs(cUser) {
            GiftCodeHelper.checkGiftCodeAvailable(cUser);
            GiftCodeHelper.checkRedeemLinkCriteria(oAccount , cUser );
            GiftCodeHelper.checkRedeemLinkCriteria(cUser  );
           

        
        }
        Test.StopTest();
    }

   static testMethod void TestredeemGiftCode(){
   SetUpTestData.triggerSettings();

   Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','uniqueemail123@email.com','Active Paid');
   User cUser = SetUpTestData.createCommunityUser('de', 'DE', oAccount.Id, 'uniqueemail123@email.com', 'uniqueemail123@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','PauseUserFName','PauseUserLName',true);

   List<DAZNConfiguration__c> config = new List<DAZNConfiguration__c>();
        config.add(new DAZNConfiguration__c(
            Name = 'RedeemGiftCode',
            Value__c = 'test.salesforce.com'
        ));
    insert config;
    
        Test.StartTest();
        
    System.RunAs(cUser) {
        
            GiftCodeHelper.redeemGiftCode();
            
        }
        Test.StopTest();
   }
    
    
    static testMethod void TestcheckGiftCodeAvailable(){
   SetUpTestData.triggerSettings();

   Account oAccount = SetUpTestData.createPersonAccount('TestFirstName', 'TestLastName','uniqueemail123@email.com','Active Paid');
   User cUser = SetUpTestData.createCommunityUser('de', 'DE', oAccount.Id, 'uniqueemail123@email.com', 'uniqueemail123@email.com', 'tstals','Europe/London','ISO-8859-1','en_GB','en_GB','PauseUserFName','PauseUserLName',true);
       
             System.assertNotEquals(null,cUser);
          
        List<CountryListForGiftCode__c > lstCustomSetting  = new List<CountryListForGiftCode__c >();
         
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='AT',  IsGiftCodeAvailable__c= True));
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='CH',  IsGiftCodeAvailable__c= True));
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='DE',  IsGiftCodeAvailable__c= True));
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='JP',  IsGiftCodeAvailable__c= True));
        lstCustomSetting.add(new CountryListForGiftCode__c  (name='CA',  IsGiftCodeAvailable__c= True));
        
         insert lstCustomSetting  ; 
  
        Test.StartTest();
        
    System.RunAs(cUser) {
        
            GiftCodeHelper.checkGiftCodeAvailable(cUser);
            
        }
        Test.StopTest();
   }
    
}