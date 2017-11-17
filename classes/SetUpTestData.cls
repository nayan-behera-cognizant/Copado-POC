public class SetUpTestData {
   
    public static void triggerSettings(){
        List<TriggerSetting__c> triggerSet = new List<TriggerSetting__c>();
        List<string> objSettings = new List<string> {'BillingAccountTrigger','UserTrigger','SubscriptionTrigger','UpdateAccountTrigger','UserDeviceTrigger','ZuoraRefundTrigger'};
        for(string objSet : objSettings){
            TriggerSetting__c trigSet = new TriggerSetting__c(name = objSet, Disable__c = false);
            triggerSet.add(trigSet);
        }       
        insert triggerSet;
    }
    public List<Case> setUpCaseList()
    {
        List<Case> oCaseList = new List<Case>();
        return oCaseList;
    }
   
    public static sObject sObj;
   
    public static sObject setUpData(sObject tempSObj){
        String sObjName = tempSObj.getSObjectType().getDescribe().getName();
        if('Account'.equalsIgnoreCase(sObjName))
        {
                Account accObj = new Account();
                accObj.PersonEmail = String.valueOf(tempSObj.get('PersonEmail'));
                accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                accObj.FirstName = String.valueOf(tempSObj.get('FirstName'));
                accObj.LastName = String.valueOf(tempSObj.get('LastName'));
                accObj.Account_Status__c = String.valueOf(tempSobj.get('Account_Status__c'));
                sObj = accObj;               
        }
        else if('Case'.equalsIgnoreCase(sObjName))
        {
            Case caseObj = new Case();
            caseObj.Type = String.valueOf(tempSObj.get('Type'));
            caseObj.Subject = String.valueOf(tempSObj.get('Subject'));
            caseObj.Description = 'Login Issue Desc';
            sObj = caseObj;
        }
        else if('Contact'.equalsIgnoreCase(sObjName))
        {
            Contact contactObj = new Contact();
            contactObj.LastName = String.valueOf(tempSObj.get('LastName'));
            sObj = contactObj;
        }
        else if('FAQs__kav'.equalsIgnoreCase(sObjName))
        {
            FAQs__kav ObjFAQ = new FAQs__kav();
            ObjFAQ.title= String.valueOf(tempSobj.get('title'));
            ObjFAQ.UrlName= String.valueOf(tempSobj.get('UrlName'));
            sObj = ObjFAQ;
        }
        else if('User'.equalsIgnoreCase(sObjName))
        {
            User userObj = new User();
            userObj.email=String.valueOf(tempSObj.get('email'));
            userObj.UserName=String.valueOf(tempSObj.get('UserName'));
            userObj.Alias =String.valueOf(tempSObj.get('Alias'));
            userObj.TimeZoneSidKey=String.valueOf(tempSObj.get('TimeZoneSidKey'));
            userObj.EmailEncodingKey=String.valueOf(tempSObj.get('EmailEncodingKey'));
            userObj.LocaleSidKey=String.valueOf(tempSObj.get('LocaleSidKey'));
            userObj.LanguageLocaleKey= String.valueOf(tempSObj.get('LanguageLocaleKey'));
            userObj.FirstName = String.valueOf(tempSObj.get('FirstName'));
            userObj.LastName = String.valueOf(tempSObj.get('LastName'));
            userObj.isActive= Boolean.valueOf(tempSObj.get('isActive'));
            userObj.Country= String.valueOf(tempSObj.get('Country'));
            userObj.ViewerId__c = String.valueOf(tempSObj.get('ViewerId__c'));
            sObj = userObj;
        }
        else if('Zuora__CustomerAccount__c'.equalsIgnoreCase(sObjName))
        {
            Zuora__CustomerAccount__c ZCustomerAcct = new Zuora__CustomerAccount__c();
            ZCustomerAcct.Name = String.valueOf(tempSObj.get('Name'));
            ZCustomerAcct.Zuora__Status__c = String.valueOf(tempSObj.get('Zuora__Status__c'));
            ZCustomerAcct.Zuora__AccountNumber__c = String.valueOf(tempSobj.get('Zuora__AccountNumber__c'));
            ZCustomerAcct.Zuora__BillToName__c = String.valueOf(tempSobj.get('Zuora__BillToName__c'));
            ZCustomerAcct.Zuora__BillToCountry__c = String.valueOf(tempSobj.get('Zuora__BillToCountry__c'));
            ZCustomerAcct.Zuora__SoldToName__c = String.valueOf(tempSobj.get('Zuora__SoldToName__c'));
            ZCustomerAcct.Zuora__DefaultPaymentMethod__c= String.valueOf(tempSobj.get('Zuora__DefaultPaymentMethod__c'));
            ZCustomerAcct.Zuora__Batch__c= String.valueOf(tempSobj.get('Zuora__Batch__c'));
            ZCustomerAcct.Zuora__Currency__c= String.valueOf(tempSobj.get('Zuora__Currency__c'));
            ZCustomerAcct.Zuora__BillCycleDay__c= String.valueOf(tempSobj.get('Zuora__BillCycleDay__c'));
            sObj = ZCustomerAcct;
        }
        else if('Zuora__PaymentMethod__c'.equalsIgnoreCase(sObjName)    )
        {
            Zuora__PaymentMethod__c zPayMethod = new Zuora__PaymentMethod__c();
            zPayMethod.Zuora__DefaultPaymentMethod__c =true;
            zPayMethod.Zuora__PaymentMethodStatus__c=String.valueOf(tempSObj.get('Zuora__PaymentMethodStatus__c'));
            zPayMethod.Zuora__Type__c=String.valueof(tempSObj.get('Zuora__Type__c'));
            zPayMethod.Zuora__CreditCardMaskNumber__c=String.valueof(tempSObj.get('Zuora__CreditCardMaskNumber__c'));
            zPayMethod.Zuora__CreditCardType__c=String.valueOf(tempSObj.get('Zuora__CreditCardType__c'));
            zPayMethod.Zuora__CreditCardHolderName__c=String.valueOf(tempSObj.get('Zuora__CreditCardHolderName__c'));
            zPayMethod.Zuora__CreditCardExpirationMonth__c=String.valueOf(tempSObj.get('Zuora__CreditCardExpirationMonth__c'));
            zPayMethod.Zuora__CreditCardExpirationYear__c=String.valueOf(tempSObj.get('Zuora__CreditCardExpirationYear__c'));
            zPayMethod.Zuora__BankIdentificationNumber__c=String.valueOf(tempSObj.get('Zuora__BankIdentificationNumber__c'));
            zPayMethod.Zuora__LastTransactionStatus__c=String.valueOf(tempSObj.get('Zuora__LastTransactionStatus__c'));
            zPayMethod.Zuora__BankTransferAccountNumber__c = '4111111111111111';
            zPayMethod.Zuora__LastTransactionDateTime__c=system.now();
            sObj = zPayMethod;
        }
        else if('User_Devices__c'.equalsIgnoreCase(sObjName)    )
        {
            User_Devices__c userDevice = new User_Devices__c();
            userDevice.Device_Name__c = String.valueOf(tempSObj.get('Device_Name__c'));
            userDevice.Date_Of_Registration__c = Date.valueOf(tempSObj.get('Date_Of_Registration__c'));
            userDevice.Type__c = String.valueOf(tempSObj.get('Type__c'));
            userDevice.Status__c = String.valueOf(tempSObj.get('Status__c'));
            sObj = userDevice;
        }
        else if('Zuora__ZInvoice__c'.equalsIgnoreCase(sObjName)    )
        {
            Zuora__ZInvoice__c invoice = new Zuora__ZInvoice__c();
            invoice.Zuora__External_Id__c ='1';
            sObj = invoice;
        }
        else if('Zuora__Payment__c'.equalsIgnoreCase(sObjName))
        {
            Zuora__Payment__c pay =new Zuora__Payment__c();
            pay.Zuora__External_Id__c='1';
            pay.Zuora__EXT_ID__c ='1';
            sObj = pay;
        }
        else if('Zuora__Subscription__c'.equalsIgnoreCase(sObjName)    )
        {
            Zuora__Subscription__c subscription = new Zuora__Subscription__c();
            subscription.Name = String.valueOf(tempSobj.get('Name'));
            subscription.Zuora__Status__c = String.valueOf(tempSobj.get('Zuora__Status__c'));
            subscription.Zuora__NextRenewalDate__c = system.today()-1;
            subscription.Zuora__SubscriptionEndDate__c = system.today();
            subscription.Zuora__NextChargeDate__c = system.today();
            subscription.Zuora__External_Id__c = '547896';
            subscription.Zuora__MRR__c = 100.00;
            sObj = subscription;
        }else if('Zuora__PaymentInvoice__c'.equalsIgnoreCase(sObjName)    )
        {
            Zuora__PaymentInvoice__c payInvoice = new Zuora__PaymentInvoice__c();
            payInvoice.Zuora__EXT_ID__c = '11';
            payInvoice.Zuora__ApplyAmount__c = 12;
            sObj = payInvoice;
        }else if('DAZNConfiguration__c'.equalsIgnoreCase(sObjName)  )
        {
           DAZNConfiguration__c dznConfig = new DAZNConfiguration__c();
           dznConfig.Name = String.valueOf(tempSobj.get('Name'));
           dznConfig.Value__c = String.valueOf(tempSobj.get('Value__c'));
           sObj = dznConfig;
        }else if('Zuora__Subscription__c'.equalsIgnoreCase(sObjName) )
        {
            Zuora__Refund__c refundOfZuora = new Zuora__Refund__c();        
            refundOfZuora.Zuora__Amount__c = 10.00;         
            sObj = refundOfZuora;
        }
        
        return sObj;
    }
    
    /*
     Description: This method is used to create Person Account.
    */
    public static Account createPersonAccount(String strFirstName, String strLastName, String strPersonEmail, String strAccountStatus){
       Account oAccount = new Account();
        oAccount.FirstName = strFirstName;
        oAccount.LastName = strLastName;
        oAccount.PersonEmail = strPersonEmail;
        oAccount.Account_Status__c = strAccountStatus;
        oAccount.All_Email_Preferences__c = false;
        oAccount.Disable_all_transactional_emails__c  = false;
        Account oPersonAccount = (Account)setUpData(oAccount);
        insert oPersonAccount;
        
        return oPersonAccount;
    }
   
    /*method to create account with country and language codes specified*/
    public static Account createPersonAccount(String countryCode, String languageCode, String strFirstName, String strLastName, String strPersonEmail, String strAccountStatus){
        Account oAccount = new Account();
        oAccount.FirstName = strFirstName;
        oAccount.LastName = strLastName;
        oAccount.PersonEmail = strPersonEmail;
        oAccount.Account_Status__c = strAccountStatus;
        oAccount.Notification_Country_Code__c = countryCode;
        oAccount.Notification_Language_Code__c = languageCode;
        Account oPersonAccount = (Account)setUpData(oAccount);
        insert oPersonAccount;
        
        return oPersonAccount;
    }

    /*
     Description: This method is used to create DfD Account.
    */
    public static Account createDfDAccount(String strFirstName, String strLastName, String strPersonEmail, String strAccountStatus, String partnerId, String type){
       Account oAccount = new Account();
        oAccount.FirstName = strFirstName;
        oAccount.LastName = strLastName;
        oAccount.PersonEmail = strPersonEmail;
        oAccount.Account_Status__c = strAccountStatus;
        oAccount.Partner_ID__c = partnerId;
        oAccount.Type = type;
        oAccount.Notification_Country_Code__c = 'DE';
        insert oAccount;
        
        return oAccount;
    }
    public static Account createDfDAccountWithoutCode(String strFirstName, String strLastName, String strPersonEmail, String strAccountStatus, String partnerId, String type){
       Account oAccount = new Account();
        oAccount.FirstName = strFirstName;
        oAccount.LastName = strLastName;
        oAccount.PersonEmail = strPersonEmail;
        oAccount.Account_Status__c = strAccountStatus;
        oAccount.Partner_ID__c = partnerId;
        oAccount.Type = type;
        insert oAccount;
        
        return oAccount;
    }

    /*
     Description: This method is used to create community user.
    */
    public static User createCommunityUser(Id sPersonAccountId, String stremail, String strUserName, String strAlias, String strTimeZoneSidKey, String strEmailEncodingKey, String strLocaleSidKey, String strLanguageLocaleKey, String strFirstName, String strLastName, Boolean bisActive){
        User oCommunityUser;
        User oCSUser;
        List<User> users = [SELECT Id, Username FROM User WHERE Username = 'testcsagent@email.com'];
        if (!users.isEmpty()) {
            oCSUser = users[0];
        } else {
            oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        }
        System.runAs(oCSUser) {
             Account oPersonAccountInfo =[SELECT PersonContactId, Owner.Name, owner.UserRoleId From Account Where Id=:sPersonAccountId];
        
            /* Get Profile ID */
            Profile oProfile = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
                  
            /* Create Community User*/
            User oUser = new User();
            oUser.email= stremail;
            oUser.UserName= strUserName;
            oUser.Alias = strAlias;
            oUser.TimeZoneSidKey= strTimeZoneSidKey;
            oUser.EmailEncodingKey= strEmailEncodingKey;
            oUser.LocaleSidKey= strLocaleSidKey;
            oUser.LanguageLocaleKey= strLanguageLocaleKey;
            oUser.FirstName = strFirstName;
            oUser.LastName = strLastName;
            oUser.isActive= bisActive;
            oCommunityUser = (User)setUpData(oUser);
            oCommunityUser.ContactId = oPersonAccountInfo.PersonContactId;
            oCommunityUser.profileid = oProfile.Id;
            insert oCommunityUser;
            
        }
        Id oUserid = oCommunityUser.id;
        oCommunityUser = [Select email,UserName,LocaleSidKey,accountId,LastName,FirstName,LanguageLocaleKey,CountryCode,Alias,TimeZoneSidKey,EmailEncodingKey,isActive,Country,ViewerId__c,ContactId   from User where Id = :oUserid];
        /* Get Person Contact information */
       return oCommunityUser;
    }

    public static User createCommunityUserDE(Id sPersonAccountId, String stremail, String strUserName, String strAlias, String strTimeZoneSidKey, String strEmailEncodingKey, String strLocaleSidKey, String strLanguageLocaleKey, String strFirstName, String strLastName, Boolean bisActive){
        User oCommunityUser;
        User oCSUser;
        List<User> users = [SELECT Id, Username FROM User WHERE Username = 'testcsagent@email.com'];
        if (!users.isEmpty()) {
            oCSUser = users[0];
        } else {
            oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','DE','DE','TestFNameCS','TestLNameCS',true);
        }
        System.runAs(oCSUser) {
             Account oPersonAccountInfo =[SELECT PersonContactId, Owner.Name, owner.UserRoleId From Account Where Id=:sPersonAccountId];
        
            /* Get Profile ID */
            Profile oProfile = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
                  
            /* Create Community User*/
            User oUser = new User();
            oUser.email= stremail;
            oUser.UserName= strUserName;
            oUser.Alias = strAlias;
            oUser.TimeZoneSidKey= strTimeZoneSidKey;
            oUser.EmailEncodingKey= strEmailEncodingKey;
            oUser.LocaleSidKey= strLocaleSidKey;
            oUser.LanguageLocaleKey= strLanguageLocaleKey;
            oUser.FirstName = strFirstName;
            oUser.LastName = strLastName;
            oUser.isActive= bisActive;
            oCommunityUser = (User)setUpData(oUser);
            oCommunityUser.ContactId = oPersonAccountInfo.PersonContactId;
            oCommunityUser.profileid = oProfile.Id;
            insert oCommunityUser;
            
        }
        /* Get Person Contact information */
       return oCommunityUser;
    }

    /*
     Description: This method is used to create community user.
    */
    public static User createCommunityUser(String notificationLanguageCode, String countryCode, Id sPersonAccountId, String stremail, String strUserName, String strAlias, String strTimeZoneSidKey, String strEmailEncodingKey, String strLocaleSidKey, String strLanguageLocaleKey, String strFirstName, String strLastName, Boolean bisActive){
             
        /* Get Person Contact information */
        Account oPersonAccountInfo =[SELECT PersonContactId, Owner.Name, owner.UserRoleId From Account Where Id=:sPersonAccountId];
        
        /* Get Profile ID */
        Profile oProfile = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
              
        /* Create Community User*/
        User oUser = new User();
        oUser.email= stremail;
        oUser.UserName= strUserName;
        oUser.Alias = strAlias;
        oUser.TimeZoneSidKey= strTimeZoneSidKey;
        oUser.EmailEncodingKey= strEmailEncodingKey;
        oUser.LocaleSidKey= strLocaleSidKey;
        oUser.LanguageLocaleKey= strLanguageLocaleKey;
        oUser.FirstName = strFirstName;
        oUser.LastName = strLastName;
        oUser.isActive= bisActive;
        oUser.Notification_Language_Code__c = notificationLanguageCode;
        oUser.CountryCode = countryCode;
        User oCommunityUser = (User)setUpData(oUser);
        oCommunityUser.ContactId = oPersonAccountInfo.PersonContactId;
        oCommunityUser.profileid = oProfile.Id;
        insert oCommunityUser;
        return oCommunityUser;
    }

    /*
     Description: This method is used to create community user.
    */
    public static User createCommunityUser(String viewerId, String notificationLanguageCode, String countryCode, Id sPersonAccountId, String stremail, String strUserName, String strAlias, String strTimeZoneSidKey, String strEmailEncodingKey, String strLocaleSidKey, String strLanguageLocaleKey, String strFirstName, String strLastName, Boolean bisActive){
             
        /* Get Person Contact information */
        Account oPersonAccountInfo =[SELECT PersonContactId, Owner.Name, owner.UserRoleId From Account Where Id=:sPersonAccountId];
        
        /* Get Profile ID */
        Profile oProfile = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
              
        /* Create Community User*/
        User oUser = new User();
        oUser.email= stremail;
        oUser.UserName= strUserName;
        oUser.Alias = strAlias;
        oUser.TimeZoneSidKey= strTimeZoneSidKey;
        oUser.EmailEncodingKey= strEmailEncodingKey;
        oUser.LocaleSidKey= strLocaleSidKey;
        oUser.LanguageLocaleKey= strLanguageLocaleKey;
        oUser.FirstName = strFirstName;
        oUser.LastName = strLastName;
        oUser.isActive= bisActive;
        oUser.Notification_Language_Code__c = notificationLanguageCode;
        oUser.CountryCode = countryCode;
        oUser.ViewerId__c = viewerId;
        User oCommunityUser = (User)setUpData(oUser);
        oCommunityUser.ContactId = oPersonAccountInfo.PersonContactId;
        oCommunityUser.profileid = oProfile.Id;
        insert oCommunityUser;
        return oCommunityUser;
    }
    
    /*
     Description: This method is used to create community user.
    */
    public static User createCommunityUser(Id sPersonAccountId, String stremail, String strUserName, String strAlias, String strTimeZoneSidKey, String strEmailEncodingKey, String strLocaleSidKey, String strLanguageLocaleKey, String strFirstName, String strLastName, Boolean bisActive, string sCountry){
             
        /* Get Person Contact information */
        Account oPersonAccountInfo =[SELECT PersonContactId, Owner.Name, owner.UserRoleId From Account Where Id=:sPersonAccountId];
        
        /* Get Profile ID */
        Profile oProfile = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
              
        /* Create Community User*/
        User oUser = new User();
        oUser.email= stremail;
        oUser.UserName= strUserName;
        oUser.Alias = strAlias;
        oUser.TimeZoneSidKey= strTimeZoneSidKey;
        oUser.EmailEncodingKey= strEmailEncodingKey;
        oUser.LocaleSidKey= strLocaleSidKey;
        oUser.LanguageLocaleKey= strLanguageLocaleKey;
        oUser.FirstName = strFirstName;
        oUser.LastName = strLastName;
        oUser.isActive= bisActive;
        oUser.Country = sCountry;
        User oCommunityUser = (User)setUpData(oUser);
        oCommunityUser.ContactId = oPersonAccountInfo.PersonContactId;
        oCommunityUser.profileid = oProfile.Id;
        insert oCommunityUser;
        return oCommunityUser;
    }
       
       /*
        Description: This method is used to create Billing Account.
      */
       public static Zuora__CustomerAccount__c createBillingAccount(Id sPersonAccountId, String strName, String strZuoraStatus, String strZuoraAccountNumber, String strZuoraBillToName, String strZuoraBillToCountry, String strZuoraSoldToName, String strZuoraDefaultPaymentMethod, String strZuoraBatch, String strZuoraCurrency, String strZuoraBillCycleDay){
            /*TriggerSetting__c triggerSet = new TriggerSetting__c(name ='BillingAccountTrigger', Disable__c = false);
            insert triggerSet;*/   
        
        Zuora__CustomerAccount__c oBillingAccount = new Zuora__CustomerAccount__c();
        oBillingAccount.Name = strName;
        oBillingAccount.Zuora__Status__c = strZuoraStatus;
        oBillingAccount.Zuora__AccountNumber__c = strZuoraAccountNumber;
        oBillingAccount.Zuora__BillToName__c = strZuoraBillToName;
        oBillingAccount.Zuora__BillToCountry__c = strZuoraBillToCountry;
        oBillingAccount.Zuora__SoldToName__c = strZuoraSoldToName;
        oBillingAccount.Zuora__DefaultPaymentMethod__c= strZuoraDefaultPaymentMethod;
        oBillingAccount.Zuora__Batch__c= strZuoraBatch;
        oBillingAccount.Zuora__Currency__c= strZuoraCurrency;
        oBillingAccount.Zuora__BillCycleDay__c= strZuoraBillCycleDay;
        Zuora__CustomerAccount__c oZBillingAccount = (Zuora__CustomerAccount__c)setUpData(oBillingAccount);
        oZBillingAccount.Zuora__Account__c = sPersonAccountId;
        insert oZBillingAccount;
            
        return oZBillingAccount;    
        }
    
    /*
        Description: This method is used to create Subscription.
      */
        public static Zuora__Subscription__c createZuoraSubscription(Id sPersonAccountId, Id sBillingAccountId, String strName, String strZuoraStatus, Date dSubscriptionStartDate, Date dNextChargeDate){
    
        /*Create Subscription*/
        Zuora__Subscription__c oSubscription = new Zuora__Subscription__c();
        oSubscription.Name = strName;
        oSubscription.Zuora__Status__c = strZuoraStatus;
        oSubscription.Zuora__SubscriptionStartDate__c = dSubscriptionStartDate;
        oSubscription.Zuora__NextChargeDate__c = dNextChargeDate;
        Zuora__Subscription__c oZSubscription = (Zuora__Subscription__c)setUpData(oSubscription);
        oZSubscription.Zuora__Account__c = sPersonAccountId;
        oZSubscription.Zuora__Zuora_Id__c = 'test';
        oZSubscription.Zuora__CustomerAccount__c = sBillingAccountId;
        insert oZSubscription;
            
        return oZSubscription;
        }
        
        /*
        Description: This method is used to create Subscription.
      */
        public static Zuora__Subscription__c createZuoraSubscription(Id sPersonAccountId, Id sBillingAccountId, String strName, String strZuoraStatus, Date dSubscriptionStartDate, Date dNextChargeDate, Date dZouraTermStartDate){
    
        /*Create Subscription*/
        Zuora__Subscription__c oSubscription = new Zuora__Subscription__c();
        oSubscription.Name = strName;
        oSubscription.Zuora__Status__c = strZuoraStatus;
        oSubscription.Zuora__SubscriptionStartDate__c = dSubscriptionStartDate;
        oSubscription.Zuora__NextChargeDate__c = dNextChargeDate;
        Zuora__Subscription__c oZSubscription = (Zuora__Subscription__c)setUpData(oSubscription);
        oZSubscription.Zuora__Account__c = sPersonAccountId;
        oZSubscription.Zuora__CustomerAccount__c = sBillingAccountId;
        oZSubscription.Zuora__TermStartDate__c = dZouraTermStartDate;
        insert oZSubscription;
            
        return oZSubscription;
        }

        public static Zuora__Subscription__c createSubscriptionWithGiftCode(Id sPersonAccountId, Id sBillingAccountId) {
            Zuora__Subscription__c oSubscription = new Zuora__Subscription__c();
            oSubscription.Name = 'test billing account subs';
            oSubscription.Zuora__Status__c = 'Active';
            oSubscription.Zuora__SubscriptionStartDate__c = Date.today().addDays(-35);
            oSubscription.Zuora__NextChargeDate__c = Date.today().addMonths(25);
            oSubscription.Zuora__Account__c = sPersonAccountId;
            oSubscription.Zuora__Zuora_Id__c = 'test';
            oSubscription.Zuora__CustomerAccount__c = sBillingAccountId;
            oSubscription.Zuora__TermSettingType__c = 'EVERGREEN';
            oSubscription.Giftcode__c = 'dfdfs';
            oSubscription.Gift_Code_End_Date__c = Date.today().addDays(-10);
            oSubscription.NumGiftPeriods__c = '1';
            oSubscription.Free_Trial_End_Date__c = Date.today().addDays(-5);
            insert oSubscription;
            return oSubscription;
        }
    
      /*
        Description: This method is used to create Payment Method.
      */
        public static Zuora__PaymentMethod__c createZuoraPaymentMethod(Id sBillingAccountId, String strZuoraPaymentMethodStatus, String strZuoraType, String strZuoraCreditCardMaskNumber, String strZuoraCreditCardType, String strZuoraCreditCardHolderName, String strZuoraCreditCardExpirationMonth, String strZuoraCreditCardExpirationYear, String strZuoraBankIdentificationNumber, String strZuoraLastTransactionStatus){
        
        Zuora__PaymentMethod__c oPaymethMethod = new Zuora__PaymentMethod__c();
        oPaymethMethod.Zuora__PaymentMethodStatus__c = strZuoraPaymentMethodStatus;
        oPaymethMethod.Zuora__Type__c = strZuoraType;
        oPaymethMethod.Zuora__CreditCardMaskNumber__c = strZuoraCreditCardMaskNumber;
        oPaymethMethod.Zuora__CreditCardType__c = strZuoraCreditCardType;
        oPaymethMethod.Zuora__CreditCardHolderName__c = strZuoraCreditCardHolderName;
        oPaymethMethod.Zuora__CreditCardExpirationMonth__c = strZuoraCreditCardExpirationMonth;
        oPaymethMethod.Zuora__CreditCardExpirationYear__c = strZuoraCreditCardExpirationYear;
        oPaymethMethod.Zuora__BankIdentificationNumber__c = strZuoraBankIdentificationNumber;
        oPaymethMethod.Zuora__LastTransactionStatus__c = strZuoraLastTransactionStatus;
        oPaymethMethod.Zuora__BankTransferAccountNumber__c = '4111111111111111';
        Zuora__PaymentMethod__c oZpaymentMethod = (Zuora__PaymentMethod__c)setUpData(oPaymethMethod);
        oZpaymentMethod.Zuora__BillingAccount__c = sBillingAccountId;
        insert oZpaymentMethod;        
        return oZpaymentMethod;
        }
    
       /*
        Description: This method is used to create Invoice.
      */
        public static Zuora__ZInvoice__c createZuoraInvoice(Id sPersonAccountId, Id sBillingAccountId, decimal dPaymentAmount){
        
        Zuora__ZInvoice__c oInvoice = new Zuora__ZInvoice__c();
        Zuora__ZInvoice__c oZInvoice = (Zuora__ZInvoice__c)setUpData(oInvoice);
        oZInvoice.Zuora__Account__c = sPersonAccountId;
        oZInvoice.Zuora__BillingAccount__c = sBillingAccountId;
        oZInvoice.Zuora__PaymentAmount__c = dPaymentAmount;
        oZInvoice.Zuora__InvoiceDate__c =  (Date.today()).addMonths(1);
        insert oZInvoice;
        
        return oZInvoice;  
        }
    /*
        Description: This method is used to create Invoice.
      */
        public static Zuora__ZInvoice__c createZuoraInvoice(Id sPersonAccountId, Id sBillingAccountId){
        
        Zuora__ZInvoice__c oInvoice = new Zuora__ZInvoice__c();
        Zuora__ZInvoice__c oZInvoice = (Zuora__ZInvoice__c)setUpData(oInvoice);
        oZInvoice.Zuora__Account__c = sPersonAccountId;
        oZInvoice.Zuora__BillingAccount__c = sBillingAccountId;
        
        oZInvoice.Zuora__InvoiceDate__c =  (Date.today()).addMonths(1);
        insert oZInvoice;
        
        return oZInvoice;  
        }
    
      /*
        Description: This method is used to create Payment.
      */
        public static Zuora__Payment__c createZuoraPayment(Id sPersonAccountId, Id sBillingAccountId, Id sInvoiceId, decimal dZuoraAmount){
        
        Zuora__Payment__c oPayment =new Zuora__Payment__c();
        Zuora__Payment__c oZPayment = (Zuora__Payment__c)setUpData(oPayment);
        oZPayment.Zuora__BillingAccount__c = sBillingAccountId;
        oZPayment.Zuora__Account__c = sPersonAccountId;
        oZPayment.Zuora__Invoice__c = sInvoiceId;
        oZPayment.Zuora__Amount__c = dZuoraAmount;
        insert oZPayment;
            
        return oZPayment;
        }

        public static void createZuoraInvoicesAndPayments(Id sPersonAccountId, Id sBillingAccountId, decimal dPaymentAmount, decimal dZuoraAmount){
        
            List<Zuora__Payment__c> payments = new List<Zuora__Payment__c>();
            List<Zuora__ZInvoice__c> invoices = new List<Zuora__ZInvoice__c>();
            for (Integer i = 0; i <= 3; i++) {
                Zuora__ZInvoice__c oInvoice = new Zuora__ZInvoice__c();
                oInvoice.Zuora__Account__c = sPersonAccountId;
                oInvoice.Zuora__BillingAccount__c = sBillingAccountId;
                oInvoice.Zuora__PaymentAmount__c = dPaymentAmount;
                invoices.add(oInvoice);
            }
            insert invoices;

            for (Zuora__ZInvoice__c item : invoices) {
                Zuora__Payment__c oPayment = new Zuora__Payment__c();
                oPayment.Zuora__BillingAccount__c = sBillingAccountId;
                oPayment.Zuora__Account__c = sPersonAccountId;
                oPayment.Zuora__Invoice__c = item.Id;
                oPayment.Zuora__Amount__c = dZuoraAmount;
                payments.add(oPayment);
            }
            insert payments; 
        }
    /*
        Description: This method is used to create Payment.
      */
        public static Zuora__Payment__c createZuoraPayment(Id sPersonAccountId, Id sBillingAccountId, Id sInvoiceId){
        
        Zuora__Payment__c oPayment =new Zuora__Payment__c();
        Zuora__Payment__c oZPayment = (Zuora__Payment__c)setUpData(oPayment);
        oZPayment.Zuora__BillingAccount__c = sBillingAccountId;
        oZPayment.Zuora__Account__c = sPersonAccountId;
        oZPayment.Zuora__Invoice__c = sInvoiceId;
        insert oZPayment;
            
        return oZPayment;
        }
       /*
        Description: This method is used to create Payment Invoice.
      */
        public static Zuora__PaymentInvoice__c createZuoraPaymentInvoice(Id sPaymentId, Id sInvoiceId){
        
       
        Zuora__PaymentInvoice__c oPaymentInvoice = new Zuora__PaymentInvoice__c();
        Zuora__PaymentInvoice__c oZPaymentInvoice = (Zuora__PaymentInvoice__c)setUpData(oPaymentInvoice);
        oZPaymentInvoice.Zuora__Payment__c = sPaymentId;
        oZPaymentInvoice.Zuora__Invoice__c = sInvoiceId;
        insert oZPaymentInvoice;
        
        return oZPaymentInvoice;
        }
    /*
        Description: This method is used to create Payment Invoice.
      */
        public static User_Devices__c createUserDevice(Id sPersonAccountId, String strname, Date sDateOfRegistration, String strType, String strStatus){
        /*Inserting User Device*/
        User_Devices__c oUserDevice = new User_Devices__c();
        oUserDevice.Device_Name__c = strname;
        oUserDevice.Date_Of_Registration__c = sDateOfRegistration;
        oUserDevice.Type__c = strType;
        oUserDevice.Status__c = strStatus;
        User_Devices__c oZUserDevice = (User_Devices__c)setUpData(oUserDevice);
        oZUserDevice.Account__c = sPersonAccountId;
        insert oZUserDevice;
        
        return oZUserDevice;
    }
   
    /*Returns list of Accounts*/
    public static list<Account> CreateAccounts(integer intCount){
        list<Account> lstAcc = new list<Account>();
        for(integer i=0; i< intCount ; i++){
            Account acc = new Account();
            acc.Name = 'Test Account'+i;
            lstAcc.add(acc);
        }
        return lstAcc;
    }
    
    /*Create DAZNConfiguration custom setting*/
    public static DAZNConfiguration__c testCreateDAZNConfiguration(String dzName, String dzValue)
    {   
        DAZNConfiguration__c dznConfig = new DAZNConfiguration__c();
        dznConfig.Name = dzName;
        dznConfig.Value__c = dzValue;
        DAZNConfiguration__c odznConfig = (DAZNConfiguration__c)setUpData(dznConfig);
        insert odznConfig;
        return odznConfig;
    }
    
    
    /*Create PaymentMethodConfigration Option custom setting
    public static PaymentMethodOptionConfig__c testCreatePaymentMethodOptionConfiguration(string sCountryName, string sCountryCode, boolean bCC, 
                                                                                  boolean bDD, boolean bPP, string sPPMerchatPwd, string sPPSignature,
                                                                                  string sPPMerchantUsername, string sPPGateway, string sZCCPageID,
                                                                                  string sZDDPageID, string sCardGateway, string sDefaultPaymentMethod,string sbilling )
    {   
        PaymentMethodOptionConfig__c pmoConfig = new PaymentMethodOptionConfig__c();
        pmoConfig.Name = sCountryName;
        pmoConfig.CountryCode__c = sCountryCode;
        pmoConfig.Credit_Card__c = bCC;
        pmoConfig.Direct_Debit__c = bDD;
        pmoConfig.Paypal__c = bPP;
        pmoConfig.PaypalMerchantPassword__c = sPPMerchatPwd;
        pmoConfig.PaypalMerchantSignature__c = sPPSignature;
        pmoConfig.PaypalMerchantUsername__c = sPPMerchantUsername;
        pmoConfig.PaypalPaymentGateway__c = sPPGateway;
        pmoConfig.ZuoraCreditCardPageId__c = sZCCPageID;
        pmoConfig.ZuoraDirectDebitPageId__c = sZDDPageID;
        pmoConfig.CardsPaymentGateway__c = sCardGateway;
        pmoConfig.DefaultPaymentMethod__c = sDefaultPaymentMethod;
        pmoConfig.Billing_Batch__c = sbilling;
      
        insert pmoConfig;
        return pmoConfig;
    }*/
    
    /*Create PaymentMethodConfigration Option custom setting*/
    public static PaymentMethodOptionConfig__c testCreatePaymentMethodOptionConfigForPause(string sCountryName, string sCountryCode, boolean bCC, 
                                                                                  boolean bDD, boolean bPP, string sPPMerchatPwd, string sPPSignature,
                                                                                  string sPPMerchantUsername, string sPPGateway, string sZCCPageID,
                                                                                  string sZDDPageID, string sCardGateway, string sDefaultPaymentMethod,string sbilling , string sCurrFormat)
    {   
        PaymentMethodOptionConfig__c pmoConfig = new PaymentMethodOptionConfig__c();
        pmoConfig.Name = sCountryName;
        pmoConfig.CountryCode__c = sCountryCode;
        pmoConfig.Credit_Card__c = bCC;
        pmoConfig.Direct_Debit__c = bDD;
        pmoConfig.Paypal__c = bPP;
        pmoConfig.PaypalMerchantPassword__c = sPPMerchatPwd;
        pmoConfig.PaypalMerchantSignature__c = sPPSignature;
        pmoConfig.PaypalMerchantUsername__c = sPPMerchantUsername;
        pmoConfig.PaypalPaymentGateway__c = sPPGateway;
        pmoConfig.ZuoraCreditCardPageId__c = sZCCPageID;
        pmoConfig.ZuoraDirectDebitPageId__c = sZDDPageID;
        pmoConfig.CardsPaymentGateway__c = sCardGateway;
        pmoConfig.DefaultPaymentMethod__c = sDefaultPaymentMethod;
        pmoConfig.Billing_Batch__c = sbilling;
        pmoConfig.Currency_Format__c= sCurrFormat;
        insert pmoConfig;
        return pmoConfig;
    }
    
    public static Case testCreateCase()
    {   
        Case oCase = new Case();
        oCase.Type = 'General Enquiry';
        oCase.Subject = 'Login Issue';
        oCase.Notification_Country_Code__c = 'DE';
        oCase.Notification_Language_Code__c = 'en';
        Case nCase = (Case)setUpData(oCase);
        insert nCase;
        return nCase;
    }
     /*Create CaseFor Rating*/
    public static Case createCaseForTest(String strType, String strSubject, String strStatus, String strDescription){
            Case TCase = new Case();
            TCase .Type = strType;
            TCase .Subject = strSubject;
            TCase .Status = 'Closed'; 
            TCase .Description='test' ;
            Case TnCase = (Case)setUpData(TCase );
        insert TnCase;
        return TnCase;
            }
    
    /*Create Contact
    public static Contact testCreateContact(){
        
        Contact oContact = new Contact();
        oContact.LastName = 'testCommunityContact';
        Contact nContact =(Contact)setUpData(oContact);
        insert nContact;
        return nContact;
    }*/
    
    /*Create public knowledge article*/    
    public static Id createKnowledgeArticles(String sArticleType,String sDataCategorySelection,String sTitle, String sUrlName,String sContentTypeDataCategory,String sRegionDataCategory){
        try{
            sObject oArticleType = Schema.getGlobalDescribe().get(sArticleType).newSObject() ;
            oArticleType.put('title',sTitle);
            oArticleType.put('UrlName',sUrlName);
            oArticleType.put('IsVisibleInPkb',true);
            oArticleType.put('IsVisibleInCsp',true);
            insert oArticleType;
            
            /*Getting the Knowledge Article ID*/
            String sQuery = 'SELECT KnowledgeArticleId,ID,MasterVersionId,ArticleType,Language,publishStatus FROM '+ sArticleType +' WHERE ID= \'' + oArticleType.get('ID')+'\'';
            List<sObject> oArticle = Database.Query(sQuery);
            
            /*Assigning DataCategories*/
            sObject oContentTypeDC = Schema.getGlobalDescribe().get(sDataCategorySelection).newSObject() ;
            oContentTypeDC.put('DataCategoryName',sContentTypeDataCategory);//'Getting_Started';
            oContentTypeDC.put('DataCategoryGroupName','Content_type');
            oContentTypeDC.put('ParentId',oArticle[0].get('Id'));
            Insert oContentTypeDC;
            
            sObject oRegionDC = Schema.getGlobalDescribe().get(sDataCategorySelection).newSObject() ;
            oRegionDC.put('DataCategoryName',sRegionDataCategory);//'GB';
            oRegionDC.put('DataCategoryGroupName','Region');
            oRegionDC.put('ParentId',oArticle[0].get('Id'));
            Insert oRegionDC;
            
            /*publishing the Knowledge Article*/
            KbManagement.PublishingService.publishArticle(string.valueOf(oArticle[0].get('KnowledgeArticleId')), true);
            
            return oArticle[0].Id; 
        }
        catch(Exception ex)
        {
            return null;
        }
    }
    /*Create Guest User*/
     
    public static User createGuestUser(Id sPersonAccountId, String stremail, String strUserName, String strAlias, String strTimeZoneSidKey, String strEmailEncodingKey, String strLocaleSidKey, String strLanguageLocaleKey, String strFirstName, String strLastName, Boolean bisActive){
         /* Get Person Contact information */
         Account oPersonAccountInfo =[SELECT PersonContactId, Owner.Name, owner.UserRoleId From Account Where Id=:sPersonAccountId];
        Profile oProfile = [SELECT Id, Name from Profile where Name = 'DAZN Profile'  limit 1];
        User oUser = new User();
        oUser.email= stremail;
        oUser.UserName= strUserName;
        oUser.Alias = strAlias;
        oUser.TimeZoneSidKey= strTimeZoneSidKey;
        oUser.EmailEncodingKey= strEmailEncodingKey;
        oUser.LocaleSidKey= strLocaleSidKey;
        oUser.LanguageLocaleKey= strLanguageLocaleKey;
        oUser.FirstName = strFirstName;
        oUser.LastName = strLastName;
        oUser.isActive= bisActive;
        User oGuestUser = (User)setUpData(oUser);
        oGuestUser.profileid = oProfile.Id;
        insert oGuestUser;
        return oGuestUser;
    }
   /*  public static User createComUserwithNotificationlang(Id sPersonAccountId, String stremail, String strUserName, String strAlias, String strTimeZoneSidKey, String strEmailEncodingKey, String strLocaleSidKey, String strLanguageLocaleKey, String strFirstName, String strLastName, Boolean bisActive, String StrNotificationLang ){
        
        Account oPersonAccountInfo =[SELECT PersonContactId, Owner.Name, owner.UserRoleId From Account Where Id=:sPersonAccountId];
        Profile oProfile = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
        User oUser = new User();
        oUser.email= stremail;
        oUser.UserName= strUserName;
        oUser.Alias = strAlias;
        oUser.TimeZoneSidKey= strTimeZoneSidKey;
        oUser.EmailEncodingKey= strEmailEncodingKey;
        oUser.LocaleSidKey= strLocaleSidKey;
        oUser.LanguageLocaleKey= strLanguageLocaleKey;
        oUser.FirstName = strFirstName;
        oUser.LastName = strLastName;
        oUser.isActive= bisActive;
        oUser.Notification_Language_Code__c = StrNotificationLang;
        User oStdUserWithNotLangCode = (User)setUpData(oUser);
        oStdUserWithNotLangCode.ContactId = oPersonAccountInfo.PersonContactId;
        oStdUserWithNotLangCode.profileid = oProfile.Id;
        insert oStdUserWithNotLangCode;
        return oStdUserWithNotLangCode;
        }*/
   
   /*  Description: This method is used to create Customer Service Team Management user.
    */
    public static User createCustomerServiceTeamManagementUser(Id sPersonAccountId, String stremail, String strUserName, String strAlias, String strTimeZoneSidKey, String strEmailEncodingKey, String strLocaleSidKey, String strLanguageLocaleKey, String strFirstName, String strLastName, Boolean bisActive){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];     
        System.runAs(thisUser)
        {
            UserRole oUserRole = [SELECT DeveloperName,Id FROM UserRole Where Name= 'Product Team' limit 1];
            
            /* Get Profile ID */
            Profile oProfile = [SELECT Id, Name from Profile where Name = 'System Administrator' limit 1];
            
            /* Create Customer Service Team Management User*/
            User oUser = new User();
            oUser.email= stremail;
            oUser.UserName= strUserName;
            oUser.Alias = strAlias;
            oUser.TimeZoneSidKey= strTimeZoneSidKey;
            oUser.EmailEncodingKey= strEmailEncodingKey;
            oUser.LocaleSidKey= strLocaleSidKey;
            oUser.LanguageLocaleKey= strLanguageLocaleKey;
            oUser.FirstName = strFirstName;
            oUser.LastName = strLastName;
            oUser.isActive= bisActive;
            User oCustomerServiceTeamManagementUser = (User)setUpData(oUser);
            oCustomerServiceTeamManagementUser.profileid = oProfile.Id;        
            oCustomerServiceTeamManagementUser.UserRoleId = oUserRole.Id;
            insert oCustomerServiceTeamManagementUser; 
            return oCustomerServiceTeamManagementUser;
        }      
        return null;        
    }
    /*
     Description: This method is used to create user with Role Customer Services Shift Leader Japan.
    */
    public static User createCustomerServicesShiftLeaderUser(Id sPersonAccountId, String stremail, String strUserName, String strAlias, String strTimeZoneSidKey, String strEmailEncodingKey, String strLocaleSidKey, String strLanguageLocaleKey, String strFirstName, String strLastName, Boolean bisActive){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];     
        System.runAs(thisUser)
        {
            UserRole oUserRole = [SELECT DeveloperName,Id FROM UserRole Where Name= 'Customer Services Shift Leader Japan' limit 1];
            
            /* Get Profile ID */
            Profile oProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
            
            /* Create Customer Service Team Management User*/
            User oUser = new User();
            oUser.email= stremail;
            oUser.UserName=strUserName;
            oUser.Alias = strAlias;
            oUser.TimeZoneSidKey= strTimeZoneSidKey;
            oUser.EmailEncodingKey= strEmailEncodingKey;
            oUser.LocaleSidKey= strLocaleSidKey;
            oUser.LanguageLocaleKey= strLanguageLocaleKey;
            oUser.FirstName = strFirstName;
            oUser.LastName = strLastName;
            oUser.isActive= bisActive;
            User oCustomerServiceTeamManagementUser = (User)setUpData(oUser);
            oCustomerServiceTeamManagementUser.profileid = oProfile.Id;        
            oCustomerServiceTeamManagementUser.UserRoleId = oUserRole.Id;
            insert oCustomerServiceTeamManagementUser; 
            return oCustomerServiceTeamManagementUser;
        }      
        return null;        
    }      
    public static User createLiveSportTeamMemberUser(Id sPersonAccountId, String stremail, String strUserName, String strAlias, String strTimeZoneSidKey, String strEmailEncodingKey, String strLocaleSidKey, String strLanguageLocaleKey, String strFirstName, String strLastName, Boolean bisActive){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];     
        System.runAs(thisUser)
        {
            UserRole oUserRole = [SELECT DeveloperName,Id FROM UserRole Where Name= 'Customer Services Shift Leader Japan' limit 1];
            
            /* Get Profile ID */
            Profile oProfile = [SELECT Id, Name from Profile where Name = 'LiveSport team member' limit 1];
            
            /* Create Customer Service Team Management User*/
            User oUser = new User();
            oUser.email= stremail;
            oUser.UserName=strUserName;
            oUser.Alias = strAlias;
            oUser.TimeZoneSidKey= strTimeZoneSidKey;
            oUser.EmailEncodingKey= strEmailEncodingKey;
            oUser.LocaleSidKey= strLocaleSidKey;
            oUser.LanguageLocaleKey= strLanguageLocaleKey;
            oUser.FirstName = strFirstName;
            oUser.LastName = strLastName;
            oUser.isActive= bisActive;
            User oCustomerServiceTeamManagementUser = (User)setUpData(oUser);
            oCustomerServiceTeamManagementUser.profileid = oProfile.Id;        
            oCustomerServiceTeamManagementUser.UserRoleId = oUserRole.Id;
            insert oCustomerServiceTeamManagementUser; 
            return oCustomerServiceTeamManagementUser;
        }      
        return null;        
    }
   
     /*
     Description: This method is used to create Person Account.
    */
    public static Account createPersonAccountWithCountryCode(String strFirstName, String strLastName, String strPersonEmail, String strAccountStatus, String countryCode){
           
        Account oAccount = new Account();
        oAccount.FirstName = strFirstName;
        oAccount.LastName = strLastName;
        oAccount.PersonEmail = strPersonEmail;
        oAccount.Account_Status__c = strAccountStatus;
        oAccount.Notification_Country_Code__c = countryCode;
        Account oPersonAccount = (Account)setUpData(oAccount);
        insert oPersonAccount;
        
        return oPersonAccount;
    }
    /*
        Description: This method is used to create Zuora Refund.
    */
    public static Zuora__Refund__c createZuoraRefund(Id sPersonAccountId, Id sCustAccountId, String strType, String ReasonCodeName,Decimal amount){
    
        /*Create Subscription*/
        Zuora__Refund__c oRefund = new Zuora__Refund__c();
        oRefund.Zuora__Type__c = strType;
        oRefund.Zuora__ReasonCodeName__c = ReasonCodeName;       
        oRefund.Zuora__Account__c = sPersonAccountId;
        oRefund.Zuora__BillingAccount__c = sCustAccountId;
        oRefund.Zuora__Amount__c = amount;
        insert oRefund;            
        return oRefund;       
    }
    /*
        Description: This method is used to create Zuora Refund.
    */
    public static Zuora__RefundInvoicePayment__c createZuoraRefundInvoicePayment(String oZuoraRefundId, String zPaymentInvoiceId, Decimal amount){
 
        Zuora__RefundInvoicePayment__c oZuoraRefundInvoicePayment = new Zuora__RefundInvoicePayment__c();
        oZuoraRefundInvoicePayment.Zuora__Refund__c = oZuoraRefundId;
        oZuoraRefundInvoicePayment.Zuora__InvoicePayment__c =  zPaymentInvoiceId;
        oZuoraRefundInvoicePayment.Zuora__RefundAmount__c = amount;    
        insert oZuoraRefundInvoicePayment;
        return oZuoraRefundInvoicePayment;       
    }

   //Email setup for system admin
    public static void emailCustsett(){        
        EmailNotification__c emailCustomSettings = new EmailNotification__c();
        emailCustomSettings.Name = 'TestName';
        emailCustomSettings.Email__c = 'Test@gmail.com';
        insert emailCustomSettings;
    }   
      
    
    /*Create Partner_Account_Configuration__c custom setting*/
    public static Partner_Account_Configuration__c testCreatePartnerAccountConfiguration(String pacName, String pacPageName, String pacPartnerType, String pacSubscriptionTypeHeadingText,
                                                                                         String pacSubscriptionTypeSubHeadingText, String pacPaymentHistoryURL, String pacChangePaymentMethodText, String pacChangePaymentMethodURL, 
                                                                                         String pacCancelSubscriptionURLSmall, String pacCancelSubscriptionURLMedium, String pacCancelSubscriptionURLLarge, String pacContactUsLink)
    {   
        Partner_Account_Configuration__c pacConfig = new Partner_Account_Configuration__c();
        pacConfig.Name = pacName;
        pacConfig.Page_Name__c = pacPageName;
        pacConfig.Partner_Type__c = pacPartnerType;
        pacConfig.Subscription_Type_Heading_Text__c = pacSubscriptionTypeHeadingText;
        pacConfig.Subscription_Type_Sub_Heading_Text__c = pacSubscriptionTypeSubHeadingText;
        pacConfig.Payment_History_URL__c = pacPaymentHistoryURL;
        pacConfig.Cancel_Subscription_URL_Small__c = pacCancelSubscriptionURLSmall;  
        pacConfig.Cancel_Subscription_URL_Medium__c = pacCancelSubscriptionURLMedium;
        pacConfig.Cancel_Subscription_URL_Large__c = pacCancelSubscriptionURLLarge;
        pacConfig.Double_opt_in_email__c = '123'; 
        pacConfig.Name_change_email__c = 'Test';
        pacConfig.Payment_failure_email__c = '123';
        pacConfig.Payment_success_email__c = '123';
        insert pacConfig;
        return pacConfig;
    }

    
    /*Create DAZN_Country_Currency_ISO_Code__c custom setting*/
    public static DAZN_Country_Currency_ISO_Code__c testCreateDAZNCountryCurrencyISOCode(String cccName, String cccSymbol)
    {   
        DAZN_Country_Currency_ISO_Code__c cccConfig = new DAZN_Country_Currency_ISO_Code__c();
        cccConfig.Name = cccName;
        cccConfig.CurrencySymbol__c = cccSymbol;            

        insert cccConfig;
        return cccConfig;
    }
    /*
     Description: This method is used to create Person  DFD Account.
    */
    
    public static Account createPersonAccountWithCountryCodeDFD(String strFirstName, String strLastName, String strPersonEmail, String strAccountStatus, String countryCode,Boolean strIsDouble,String strPartnerID,String sType,String strLanguageCode,Boolean strEmailPreferences,Boolean strIsReadyToSync,Boolean strClearMailingList){
           
        Account oAccount = new Account();
        oAccount.FirstName = strFirstName;
        oAccount.LastName = strLastName;
        oAccount.PersonEmail = strPersonEmail;
        oAccount.Account_Status__c = strAccountStatus;
        oAccount.Notification_Country_Code__c = countryCode;
        oAccount.Is_Double_OptIn__c = strIsDouble;
        oAccount.Partner_ID__c = strPartnerID;
        oAccount.Type = sType;
        oAccount.Notification_Language_Code__c = strLanguageCode;
        oAccount.All_Email_Preferences__c = strEmailPreferences;
        oAccount.IsReadyToSyncInCommunicator__c = strIsReadyToSync;
        //oAccount.ClearMailingListInCommunicator__c = strClearMailingList;
        Account oPersonAccount = (Account)setUpData(oAccount);
        insert oPersonAccount;
        
        return oPersonAccount;
    }

    public static void createDAZNConfigurations() {
        SetUpTestData.testCreateDAZNConfiguration('Zuora_Public_Key', 'Ybuvn16dUCbV6nyKms6blbKrF4MnfmMM5aCmrOm0GdaYFx9bPVTQXEP070mwpQw5fYlsQP+Zz2cf+ivijR+hTKSDdqoVE+wIDAQAB');
        SetUpTestData.testCreateDAZNConfiguration('Zuora_Public_Key_Second_Part', 'Ybuvn16dUCbV6nyKms6blbKrF4MnfmMM5aCmrOm0GdaYFx9bPVTQXEP070mwpQw5fYlsQP+Zz2cf+ivijR+hTKSDdqoVE+wIDAQAB');
        
        SetUpTestData.testCreateDAZNConfiguration('LS_UserName_Configuration', 'livesport.dev');
        SetUpTestData.testCreateDAZNConfiguration('Apple_SetEndpoint', 'https://docomoproxy.performgroup.com/lms.apl99.spmode.ne.jp/MailMagazine/xmlrpc');
        SetUpTestData.testCreateDAZNConfiguration('DFD_SetEndpoint_Docomo', 'https://docomoproxy.performgroup.com/lms.apl99.spmode.ne.jp/MailMagazine/xmlrpc');

        SetUpTestData.testCreateDAZNConfiguration('CustomerServiceTeamMemberJapanProfile', '00e26000000Hpw2');
        SetUpTestData.testCreateDAZNConfiguration('CustomerServiceTeamMemberProfileId', '00e24000000RqXA');
        SetUpTestData.testCreateDAZNConfiguration('DFD_BulkEndPoint', 'https://docomoproxy.performgroup.com/lms.apl01.spmode.ne.jp/DefMagazine');

        SetUpTestData.testCreateDAZNConfiguration('Record_Type_id_Person_Account', UpdateAccountTriggerHandler.getRecordTypeId('PersonAccount', 'Account'));
        SetUpTestData.testCreateDAZNConfiguration('Record_TypePerson_Account_For_Unblock', UpdateAccountTriggerHandler.getRecordTypeId('Person_Account_For_Unblock', 'Account'));
        SetUpTestData.testCreateDAZNConfiguration('CaseGeneralProcessRecordTypeId', UpdateAccountTriggerHandler.getRecordTypeId('General_Process', 'Case'));
        SetUpTestData.testCreateDAZNConfiguration('Record_Type_id_DFD_Customer', UpdateAccountTriggerHandler.getRecordTypeId('DFD_Customer', 'Account'));
    }

    public static Zuora__Refund__c createRefund (String accId, String billingAccId, String paymentId) {
        Zuora__Refund__c oZuoraRefund = new Zuora__Refund__c();
        oZuoraRefund.Zuora__Account__c = accId;
        oZuoraRefund.Zuora__BillingAccount__c = billingAccId;
        oZuoraRefund.Zuora__Payment__c = paymentId;
        oZuoraRefund.Zuora__Amount__c = 1000.00;    
        oZuoraRefund.Zuora__RefundDate__c = Date.today().addDays(-5);
        insert oZuoraRefund;

        return oZuoraRefund;
    }

    //Start part of PD-7838
    public static Case createCase(String strType, String strSubject, String strStatus, String strDescription, String email, String notificationCode) {
        Case cs = new Case();
        cs.Type = strType;
        cs.Subject = strSubject;
        cs.Status = strStatus; 
        cs.Description = strDescription;
        cs.SuppliedEmail = email;
        cs.Notification_Language_Code__c = notificationCode;
        insert cs;
        return cs;
    }

    public static Case createCase(String strType, String strSubject, String strStatus, String strDescription, String email, String notificationCode, String accountId) {
        Case cs = new Case();
        cs.Type = strType;
        cs.Subject = strSubject;
        cs.Status = strStatus; 
        cs.Description = strDescription;
        cs.SuppliedEmail = email;
        cs.Notification_Language_Code__c = notificationCode;
        cs.AccountId = accountId;
        insert cs;
        return cs;
    }

    public static void createEmailTemplate() {
        List<EmailTemplate> testTemplates = new List<EmailTemplate>();
        
        testTemplates.add(new EmailTemplate(isActive = true, Subject = 'test', Name = 'testTemplateEn', DeveloperName = 'testTemplateEn', TemplateType = 'Custom', FolderId = UserInfo.getUserId(),Body = '', HtmlValue = '<html></html>'));  
        testTemplates.add(new EmailTemplate(isActive = true, Subject = 'test', Name = 'testTemplateJA', DeveloperName = 'testTemplateJA', TemplateType = 'Custom', FolderId = UserInfo.getUserId(),Body = '', HtmlValue = '<html></html>'));  
        testTemplates.add(new EmailTemplate(isActive = true, Subject = 'test', Name = 'testTemplateFR', DeveloperName = 'testTemplateFR', TemplateType = 'Custom', FolderId = UserInfo.getUserId(),Body = '', HtmlValue = '<html></html>'));  
        testTemplates.add(new EmailTemplate(isActive = true, Subject = 'test', Name = 'testTemplateDE', DeveloperName = 'testTemplateDE', TemplateType = 'Custom', FolderId = UserInfo.getUserId(),Body = '', HtmlValue = '<html></html>'));  
        testTemplates.add(new EmailTemplate(isActive = true, Subject = 'test', Name = 'testFinish', DeveloperName = 'testFinish', TemplateType = 'Custom', FolderId = UserInfo.getUserId(),Body = '', HtmlValue = '<html></html>'));
        insert testTemplates;
    }
    //End part of PD-7838

    //Start part of PD-16570
    public static void createGiftCodeHistory(String accountId) {
        List<Gift_Code_History__c> historys = new List<Gift_Code_History__c>();
        for (Integer i = 0; i < 5; i++) {
            Gift_Code_History__c giftCodeHistory = new Gift_Code_History__c();
            giftCodeHistory.Account__c = accountId;
            giftCodeHistory.Applied_On__c = Date.today();
            giftCodeHistory.Campaign_Id__c = 'testCampaign' + String.valueOf(i);
            giftCodeHistory.Gift_Code_End_Date__c = Date.today().addDays(2 + i);
            giftCodeHistory.Gift_Code_Start_Date__c = Date.today().addDays(i);
            giftCodeHistory.Name = 'test' + String.valueOf(i);
            historys.add(giftCodeHistory);
        }
        
        insert historys;
    }
    //End part of PD-16570

    //Method for creating Gift Code
    public static void createGiftCode() {
        GiftCode_settings__c giftCode = new GiftCode_settings__c(
            Name = 'Scenario_1',
            Account_Status__c = 'Active Paid',
            Campaign_ID__c = 'IS blank',
            Heading_Label__c = 'LS_MYACC_EVERGREEN_FREE_TRIAL_NO_GF_HEADING',
            Sub_Heading_Label__c = 'LS_MYACC_EVERGREEN_FREE_TRIAL_NO_GF_SUBHEADING',
            Page_Name__c = 'MyAccount',
            Sub_Status__c = 'Active',
            Sub_Type__c = 'EVERGREEN',
            Unique_Identifier__c = 'Active PaidIS blankActiveEVERGREEN'
        );
        insert giftCode;
    }
    //Method is for creating MISL_Configuration
    public static void createMISLSetting() {
        List<MISL_Configuration__c> config = new List<MISL_Configuration__c>();
        config.add(new MISL_Configuration__c(
            Name = 'MISL_GetUserDevices_US',
            Value__c = 'https://test',
            Timeout__c = 3000,
            Enabled_Country_Codes__c = 'US'
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_GetUserDevices_DE',
            Value__c = 'https://test',
            Timeout__c = 3000,
            Enabled_Country_Codes__c = 'DE'
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_Username',
            Value__c = 't1'
            
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_Password',
            Value__c = EncodingUtil.base64Encode(Blob.valueOf('t2'))
           
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_ChangeUserPassword_US',
            Value__c = 'test',
            Timeout__c = 3000,
            Enabled_Country_Codes__c = 'US'
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_ChangeUserPassword_DE',
            Value__c = 'test',
            Timeout__c = 3000,
            Enabled_Country_Codes__c = 'DE'
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_ChangeUserPassword_JP',
            Value__c = 'test',
            Timeout__c = 3000,
            Enabled_Country_Codes__c = 'JP'
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_DeRegisterDevices',
            Value__c = 'test',
            Timeout__c = 3000,
            Enabled_Country_Codes__c = 'CA, DE, US, JP'
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_UpdateUserDetails_CA',
            Value__c = 'test',
            Timeout__c = 3000,
            Enabled_Country_Codes__c = 'CA'
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_UpdateUserDetails_DE',
            Value__c = 'test',
            Timeout__c = 3000,
            Enabled_Country_Codes__c = 'DE'
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_UpdateUserDetails_US',
            Value__c = 'test',
            Timeout__c = 3000,
            Enabled_Country_Codes__c = 'US'
        ));
        config.add(new MISL_Configuration__c(
            Name = 'MISL_UpdateUserDetails_JP',
            Value__c = 'test',
            Timeout__c = 3000,
            Enabled_Country_Codes__c = 'JP'
        ));
        insert config;
    }
    //Method is for creating DAZNCommunicatorConfig and DAZNConfiguration custom settings
    public static void createCommunicatorSeeting() {
        List<DAZNCommunicatorConfig__c> lstCustomSetting = new List<DAZNCommunicatorConfig__c>();
        List<DAZNConfiguration__c> lstConfig = new List<DAZNConfiguration__c>();
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_User_Cancel_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Updated_Name_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Updated_Password_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Forgotten_Password_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Partial_Welcome_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Free_Trial_Welcome_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Hard_Offer_Welcome_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Successful_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Failure_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Subscription_End_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_New_Device_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Updatation_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Expiry_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Contacts_Table_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='MailingList_Transactional_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SalesForceID_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Email_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='FirstName_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='LastName_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SubscriptionEndDate_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Currency_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SubscriptionAmount_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='PlanDetails_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='PaymentMethodType_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='FreeTrialEndDate_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='AccountStatus_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='NotificationLanguageCode_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='NotificationCountryCode_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='CountryLanguage_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='SignInLink_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Germany_Marketing_Mailing_List_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Marketing_Germany_JP_en_GB',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='UnsubscribeLanguage_Column_ID',Value__c=12345));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='CommunicatorAPITimeOutLimit',Value__c=60000));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Marketing_Mailing_List_ID',Value__c=60000)); 
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Inactive_Device_DE_en_GB',Value__c=60000)); 
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='Rebill_Date_ID',Value__c=60000)); 

        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Successful_en_GB',Value__c=12346)); 
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Successful_DE_de',Value__c=4603740));
        lstCustomSetting.add(new DAZNCommunicatorConfig__c(name='DispatchID_Payment_Successful_DE_en_GB',Value__c=4603609));

        lstConfig.add(new DAZNConfiguration__c(name='DoubleOptInCountries',Value__c='DE,AT'));
        insert lstCustomSetting;   
        insert lstConfig;
    }
    //Method is for creating Partner_Account_Configuration custom Setting
    public static void createPartnerAccountConfig() {
        Partner_Account_Configuration__c pac = new Partner_Account_Configuration__c(
            Name = 'Docomo',
            Partner_Type__c = 'Docomo',
            Page_Name__c = 'PartnerAccount.page',
            Subscription_Type_Heading_Text__c = 'Docomo',
            Subscription_Type_Sub_Heading_Text__c = 'Your subscription is managed through your d Account and is payable monthly via your contract with Docomo.',
            Payment_History_URL__c = 'https://www.google.com',
            Cancel_Subscription_URL_Small__c = 'https://www.google.com',
            Cancel_Subscription_URL_Medium__c = 'https://www.google.com',
            Cancel_Subscription_URL_Large__c = 'https://www.google.com'
        );
        insert pac;
    }

    //Method is for creating Devices for User
    public static List<User_Devices__c> createUserDevices(Id sPersonAccountId, String strname, Date sDateOfRegistration, String strStatus){
        List<User_Devices__c> userDevices = new List<User_Devices__c>();
        List<string> lstDeviceTypes = new List<string>{'Desktop','Laptop','Mobile','Tablet','TV'};
        for (String item : lstDeviceTypes) {
            User_Devices__c oUserDevice = new User_Devices__c();
            oUserDevice.Device_Name__c = strname;
            oUserDevice.Date_Of_Registration__c = sDateOfRegistration;
            oUserDevice.Type__c = item;
            oUserDevice.Status__c = strStatus;
            oUserDevice.Account__c = sPersonAccountId;
            userDevices.add(oUserDevice);
        }
        
        insert userDevices;
        
        return userDevices;
    }
    //Method is for creating GiftCode start and EndDate
    public static Account createPersonAccountWithGiftCodeDate(String strFirstName, String strLastName, String strPersonEmail, String strAccountStatus) {
        Account oAccount = new Account();
        oAccount.FirstName = strFirstName;
        oAccount.LastName = strLastName;
        oAccount.PersonEmail = strPersonEmail;
        oAccount.Account_Status__c = strAccountStatus;
        oAccount.All_Email_Preferences__c = false;
        oAccount.Disable_all_transactional_emails__c  = false;
        oAccount.Gift_Code_End_Date__c = Date.today();
        oAccount.Gift_Code_End_Date__c = Date.today() + 1;
        Account oPersonAccount = (Account)setUpData(oAccount);
        insert oPersonAccount;
        
        return oPersonAccount;
    }
    //Method is for creating CountryListForPauseFlow custom setting
    public static void createountryListForPause() {
        List<CountryListForPauseFlow__c> lstCustomSetting = new List<CountryListForPauseFlow__c>();
         
        lstCustomSetting.add(new CountryListForPauseFlow__c(name='AT',  IsPauseEnable__c= true));
        lstCustomSetting.add(new CountryListForPauseFlow__c(name='CH',  IsPauseEnable__c= true));
        lstCustomSetting.add(new CountryListForPauseFlow__c(name='DE',  IsPauseEnable__c= true));
        lstCustomSetting.add(new CountryListForPauseFlow__c(name='JP',  IsPauseEnable__c= true));
        lstCustomSetting.add(new CountryListForPauseFlow__c(name='US',  IsPauseEnable__c= true));
        
        insert lstCustomSetting;
    }

    public static Custom_Provider__c createCustomProvider(String providerName, String providerType, String countryCode, String languageCode) {
        Custom_Provider__c provider = new Custom_Provider__c(
            Name = providerName,
            Provider_Type__c = providerType,
            Country_Code__c = countryCode,
            Language__c = languageCode            
        );
        insert provider;
        return provider;
    }

    public static Email_Help_Option__c createEmailHelpOption(String ehoName, String ehoType, String providerType, String caseResolutionOwner, String countryCode, String languageCode) {
        Email_Help_Option__c emailHelpOption = new Email_Help_Option__c(
            Name = ehoName,
            Type__c = ehoType,
            Provider_Type__c = providerType,
            Case_Resolution_Owner__c = caseResolutionOwner,
            Country__c = countryCode,
            Language__c = languageCode            
        );
        insert emailHelpOption;
        return emailHelpOption;
    }




    
   /*
     Description: This method is used to create Person  DFD Account.
    
    public static Account createPersonAccountForBatch(String strFirstName, String strLastName, String strPersonEmail, String strAccountStatus, String countryCode,String sType,Boolean boolIsReadyToSync , Boolean emailPref ){
           
        Account oAccount = new Account();
        oAccount.FirstName = strFirstName;
        oAccount.LastName = strLastName;
        oAccount.PersonEmail = strPersonEmail;
        oAccount.Account_Status__c = strAccountStatus;
        oAccount.Notification_Country_Code__c = countryCode;
        oAccount.Type = sType;
        oAccount.IsReadyToSyncInCommunicator__c = boolIsReadyToSync;
        oAccount.All_Email_Preferences__c = emailPref ;
        
        insert oAccount;
        
        return oAccount;
      }  
  
     Description: This method is used to create test user.
    
    public static User createTestUser(Id profileId, String countryCode, String stremail, String strUserName, String strAlias, String strTimeZoneSidKey, String strEmailEncodingKey, String strLocaleSidKey, String strLanguageLocaleKey, String strFirstName, String strLastName, Boolean bisActive){
              
       
        User oUser = new User();
        oUser.email= stremail;
        oUser.UserName= strUserName;
        oUser.Alias = strAlias;
        oUser.TimeZoneSidKey= strTimeZoneSidKey;
        oUser.EmailEncodingKey= strEmailEncodingKey;
        oUser.LocaleSidKey= strLocaleSidKey;
        oUser.LanguageLocaleKey= strLanguageLocaleKey;
        oUser.FirstName = strFirstName;
        oUser.LastName = strLastName;
        oUser.isActive= bisActive;
        oUser.CountryCode = countryCode;
        oUser.profileid = profileId;
        insert oUser;
        return oUser;
    }*/

    public static User createCommunityUserSSO(Id sPersonAccountId, String stremail, String strUserName, String strAlias, String strTimeZoneSidKey, String strEmailEncodingKey, String strLocaleSidKey, String strLanguageLocaleKey, String strFirstName, String strLastName, Boolean bisActive){
        User oCommunityUser;
        User oCSUser;
        List<User> users = [SELECT Id, Username FROM User WHERE Username = 'testcsagent@email.com'];
        if (!users.isEmpty()) {
            oCSUser = users[0];
        } else {
            oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent@email.com', 'testcsagent@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        }
        System.runAs(oCSUser) {
             Account oPersonAccountInfo =[SELECT PersonContactId, Owner.Name, owner.UserRoleId From Account Where Id=:sPersonAccountId];
        
            /* Get Profile ID */
            Profile oProfile = [SELECT Id, Name from Profile where Name = 'Customer Community User SSO' limit 1];
                  
            /* Create Community User*/
            User oUser = new User();
            oUser.email= stremail;
            oUser.UserName= strUserName;
            oUser.Alias = strAlias;
            oUser.TimeZoneSidKey= strTimeZoneSidKey;
            oUser.EmailEncodingKey= strEmailEncodingKey;
            oUser.LocaleSidKey= strLocaleSidKey;
            oUser.LanguageLocaleKey= strLanguageLocaleKey;
            oUser.FirstName = strFirstName;
            oUser.LastName = strLastName;
            oUser.isActive= bisActive;
            oCommunityUser = (User)setUpData(oUser);
            oCommunityUser.ContactId = oPersonAccountInfo.PersonContactId;
            oCommunityUser.profileid = oProfile.Id;
            insert oCommunityUser;
            System.debug(oCommunityUser);
            
        }
        /* Get Person Contact information */
       return oCommunityUser;
    }
   
}