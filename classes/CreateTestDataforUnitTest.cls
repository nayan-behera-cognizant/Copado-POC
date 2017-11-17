@IsTest
public class CreateTestDataforUnitTest {
    /*Description: This method is used for enabling the triggers on the corresponding objects.*/
    @testSetup
    public static void triggerSettings(){
        List<TriggerSetting__c> triggerSet = new List<TriggerSetting__c>();
        List<string> objSettings = new List<string> {'BillingAccountTrigger','UserTrigger','SubscriptionTrigger','UpdateAccountTrigger','UserDeviceTrigger','ZuoraRefundTrigger'};
            for(string objSet : objSettings){
                TriggerSetting__c trigSet = new TriggerSetting__c(name = objSet, Disable__c = false);
                triggerSet.add(trigSet);
            }       
        insert triggerSet;
    }
    /* Description: This method is used to create community user recode.*/
    @testSetup
    public static void createTestAccounts(){
        User oCSUser = SetUpTestData.createCustomerServiceTeamManagementUser(null, 'testcsagent1@email.com', 'testcsagent1@email.com', 'tstals','Europe/London','ISO-8859-1','en_US','en_US','TestFNameCS','TestLNameCS',true);
        System.RunAs(oCSUser){
            String orgId = UserInfo.getOrganizationId();
            List<Account> accList = new List<Account>();
            for (Integer i = 0;i<7;i++){
                String uniqueName = orgId;
                uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
                uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
                Account oAccount = new Account();
                oAccount.FirstName = 'TestFirstName';
                oAccount.LastName = 'TestLastName'+i;
                oAccount.PersonEmail = 'email'+uniqueName+i+ '@testdomain.org';
                oAccount.Notification_Country_Code__c='DE';
                oAccount.All_Email_Preferences__c = true;
                if(i==0){
                    //Create Frozen Account
                    oAccount.Account_Status__c = 'Frozen';
                } else if(i==1){
                    //Create Active Paid Account
                    oAccount.Account_Status__c = 'Active Paid';
                    oAccount.Is_Double_OptIn__c = true;
                    oAccount.IsReadyToSyncInZuora__c=true;
                } else if(i==2){
                    //Create Free Trial Account
                    oAccount.Account_Status__c = 'Free Trial';
                    oAccount.Is_Double_OptIn__c = true;
                    //oAccount.Notification_Language_Code__c= 'de';
                } else if(i==3){
                    //Create Active Grace Account
                    oAccount.Account_Status__c = 'Active Grace';
                } else if(i==4){
                    //Create Expired Account
                    oAccount.Account_Status__c = 'Expired';
                } else if(i==5){
                    //Create Blocked Account
                    oAccount.Account_Status__c = 'Blocked';
                } else if(i==6){
                    //Create Partial Account
                    oAccount.Account_Status__c = 'Partial';
                } 
                accList.add(oAccount);
                
            } //end of for - Account data preparation
            Database.insert(accList,true);
        }
    }
    @testSetup
    public static void createTestAccountsDocomo(){
        String orgId = UserInfo.getOrganizationId();
        List<Account> accList = new List<Account>();
        for (Integer i = 0;i<7;i++){
            String uniqueName = orgId;
            uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
            Account oAccount = new Account();
            oAccount.FirstName = 'TestFirstName';
            oAccount.LastName = 'TestLastName'+i;
            oAccount.PersonEmail = 'email'+uniqueName+i+ '@testdomain.org';
            oAccount.Notification_Country_Code__c='DE';
            oAccount.Type = 'Docomo';
            oAccount.Partner_ID__c = '1' + String.valueOf(i);
            oAccount.All_Email_Preferences__c = true;
            if(i==0){
                //Create Frozen Account
                oAccount.Account_Status__c = 'Frozen';
            } else if(i==1){
                //Create Active Paid Account
                oAccount.Account_Status__c = 'Active Paid';
                oAccount.Is_Double_OptIn__c = true;
                oAccount.IsReadyToSyncInZuora__c=true;
            } else if(i==2){
                //Create Free Trial Account
                oAccount.Account_Status__c = 'Free Trial';
                oAccount.Is_Double_OptIn__c = true;
                //oAccount.Notification_Language_Code__c= 'de';
            } else if(i==3){
                //Create Active Grace Account
                oAccount.Account_Status__c = 'Active Grace';
            } else if(i==4){
                //Create Expired Account
                oAccount.Account_Status__c = 'Expired';
            } else if(i==5){
                //Create Blocked Account
                oAccount.Account_Status__c = 'Blocked';
            } else if(i==6){
                //Create Partial Account
                oAccount.Account_Status__c = 'Partial';
            } 
            accList.add(oAccount);
            
        } //end of for - Account data preparation
        Database.insert(accList,true);
        
    }
    
    @testSetup
    public static void createTestAccountsDocomoActiveGra(){
        String orgId = UserInfo.getOrganizationId();
        List<Account> accList = new List<Account>();
        for (Integer i = 0;i<7;i++){
            String uniqueName = orgId;
            uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
            Account oAccount = new Account();
            oAccount.FirstName = 'TestFirstName';
            oAccount.LastName = 'TestLastName'+i;
            oAccount.PersonEmail = 'email'+uniqueName+i+ '@testdomain.org';
            oAccount.Notification_Country_Code__c='DE';
            oAccount.Type = 'Docomo';
            oAccount.Partner_ID__c = '1' + String.valueOf(i);
            oAccount.All_Email_Preferences__c = true;
            
            oAccount.Account_Status__c = 'Active Grace';
            
            accList.add(oAccount);
            
        } //end of for - Account data preparation
        Database.insert(accList,true);
        
    }
    @testSetup
    public static void createTestCommunityUsers(){
        List<Account> getaccList = [Select Id,Name,PersonContactId, Owner.Name, owner.UserRoleId,PersonEmail from Account];
        List<User> userList = new List<User>();
        //Query Profile for community user 
        List<Profile> listOfProfiles = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
        if (listOfProfiles[0].Id !=null){
            Integer cnt = 11;
            for(Account acc : getaccList){
                User oUser = new User();
                oUser.email= acc.PersonEmail;
                oUser.UserName= acc.PersonEmail;
                oUser.Alias = 'LiveSp'+cnt;
                if(cnt == 11){
                    oUser.TimeZoneSidKey= 'Asia/Tokyo';
                    oUser.LocaleSidKey= 'ja_JP';
                    oUser.LanguageLocaleKey= 'ja';
                    oUser.Country= 'Japan';
                } else if(cnt == 12){
                    oUser.TimeZoneSidKey= 'Europe/Berlin';
                    oUser.LocaleSidKey= 'de_DE';
                    oUser.LanguageLocaleKey= 'de';
                    oUser.Country= 'Germany';
                } else if(cnt == 13){
                    oUser.TimeZoneSidKey= 'Europe/London';
                    oUser.LocaleSidKey= 'de_AT';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Austria';
                } else if(cnt == 14){
                    oUser.TimeZoneSidKey= 'Europe/Berlin';
                    oUser.LocaleSidKey= 'de_CH';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Switzerland';
                }else if(cnt == 15){
                    oUser.TimeZoneSidKey= 'Europe/Berlin';
                    oUser.LocaleSidKey= 'ja_JP';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'India';
                }else if(cnt == 16){
                    oUser.TimeZoneSidKey= 'Europe/London';
                    oUser.LocaleSidKey= 'de_DE';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Germany';
                }else if(cnt==17){
                    oUser.TimeZoneSidKey= 'Europe/London';
                    oUser.LocaleSidKey= 'de_DE';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Germany';
                }
                oUser.EmailEncodingKey= 'ISO-8859-1';
                oUser.FirstName = 'TestFName';
                oUser.LastName = 'TestLName'+cnt;
                oUser.isActive= true;
                oUser.ContactId = acc.PersonContactId;
                oUser.profileid = listOfProfiles[0].Id;
                userList.add(oUser) ; 
                cnt = cnt + 1;
            }//end of for loop 
            Database.insert(userList,true);
        } //end of if - profile id null check
    }
    public static void createTestUserDevices(){
        // User Devices
        List<Account> accList = [ Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c IN ('Active Paid','Free Trial','Active Grace') ];
        system.debug('accList' +accList);
        List<User_Devices__c> listofUserDevices = new list<User_Devices__c>();
        Integer devCout = 1 ;
        for(Account accls :accList){
            //User Devices 
            if(devCout==1){
                User_Devices__c oUrDevTablet = new User_Devices__c();
                oUrDevTablet.Account__c = accls.id;
                oUrDevTablet.Device_Name__c = 'DN-0000013345';
                oUrDevTablet.Date_Of_Registration__c = System.today();
                oUrDevTablet.Type__c = 'Tablet';
                oUrDevTablet.Status__c = 'Active';
                listofUserDevices.add(oUrDevTablet);
            } else if(DevCout==2){
                User_Devices__c oUrDevTablet = new User_Devices__c();
                oUrDevTablet.Account__c = accls.id;
                oUrDevTablet.Device_Name__c = 'DN-0000013345';
                oUrDevTablet.Date_Of_Registration__c = System.today();
                oUrDevTablet.Type__c = 'Tablet';
                oUrDevTablet.Status__c = 'Active';
                listofUserDevices.add(oUrDevTablet);
            }   else if(DevCout==3){
                User_Devices__c oUrDevMobile = new User_Devices__c();
                oUrDevMobile.Account__c = accls.id;
                oUrDevMobile.Device_Name__c = 'DN-0000013300';
                oUrDevMobile.Date_Of_Registration__c = System.today();
                oUrDevMobile.Type__c = 'Mobile';
                oUrDevMobile.Status__c = 'Active';
                listofUserDevices.add(oUrDevMobile);
            } else if(DevCout==4){
                User_Devices__c oUrDevDesktop = new User_Devices__c();
                oUrDevDesktop.Account__c = accls.id;
                oUrDevDesktop.Device_Name__c = 'DN-0000013300';
                oUrDevDesktop.Date_Of_Registration__c = System.today();
                oUrDevDesktop.Type__c = 'Desktop';
                oUrDevDesktop.Status__c = 'InActive';
                listofUserDevices.add(oUrDevDesktop);
            }
            DevCout = DevCout + 1;
        }//end Devices for loop            
        // inserting custom setting data for User Devices
        
        try{ 
            system.debug('listofUserDevices '+listofUserDevices.size());
            insert listofUserDevices;
        }catch(Exception e){
            system.debug('error ');
            system.debug('error '+e.getMessage());
        }
        
        system.debug(listofUserDevices);
        
    }
    //Use to create custom settings in all Test Class 
    public static void createTestcustomsetting(){
        // To generate unique name for the email settings
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId;
        uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
        //Use custom settings to create and manage custom data at test class
        list<DAZNConfiguration__c> listofDAZNConfig = new list<DAZNConfiguration__c>();
        
        DAZNConfiguration__c dznConfig = new DAZNConfiguration__c();
        dznConfig.Name = 'LoginPageURL';
        dznConfig.Value__c = '/LoginPageURL';
        listofDAZNConfig.add(dznConfig);
        
        DAZNConfiguration__c oDAZNPasswordurl = new DAZNConfiguration__c();
        oDAZNPasswordurl.Name = 'ForgotPasswordLink';
        oDAZNPasswordurl.Value__c = 'http://stag.dazn.com/account/forgot-password';
        listofDAZNConfig.add(oDAZNPasswordurl);
        
        DAZNConfiguration__c oDAZNHomeUrlBeta = new DAZNConfiguration__c();
        oDAZNHomeUrlBeta.Name = 'HomePageURLBeta';
        oDAZNHomeUrlBeta.Value__c = 'http://livesport-web.massiveinteractive.com';
        listofDAZNConfig.add(oDAZNHomeUrlBeta);
        
        DAZNConfiguration__c oDAZNHomeUrl = new DAZNConfiguration__c();
        oDAZNHomeUrl.Name = 'HomePageURL';
        oDAZNHomeUrl.Value__c = 'http://livesport-web.massiveinteractive.com/';
        listofDAZNConfig.add(oDAZNHomeUrl);
        
        DAZNConfiguration__c oDAZNPasswordBeta = new DAZNConfiguration__c();
        oDAZNPasswordBeta.Name = 'ForgotPasswordLinkBeta';
        oDAZNPasswordBeta.Value__c = 'http://stag.dazn.com/account/forgot-password';
        listofDAZNConfig.add(oDAZNPasswordBeta);
        
        DAZNConfiguration__c oDAZNMyAccountURL = new DAZNConfiguration__c();
        oDAZNMyAccountURL.Name = 'MyAccountURL';
        oDAZNMyAccountURL.Value__c = '/MyAccount';
        listofDAZNConfig.add(oDAZNMyAccountURL);
        
        // Added custom settings for PD-7807 Test class Subscription Cancellation
        DAZNConfiguration__c dznConfigFAQURL = new DAZNConfiguration__c();
        dznConfigFAQURL.Name = 'FAQURL';
        dznConfigFAQURL.Value__c = 'policypage?articleType=FAQ';
        listofDAZNConfig.add(dznConfigFAQURL);
        
        DAZNConfiguration__c dznConfigGetInContactURL = new DAZNConfiguration__c();
        dznConfigGetInContactURL.Name = 'GetInContactURL';
        dznConfigGetInContactURL.Value__c = '/ContactUs';
        listofDAZNConfig.add(dznConfigGetInContactURL);
        
        DAZNConfiguration__c dznConfigChangePaymentMethodURL = new DAZNConfiguration__c();
        dznConfigChangePaymentMethodURL.Name = 'CHANGEPAYMENTMETHODURL';
        dznConfigChangePaymentMethodURL.Value__c = 'ChangePaymentMethod';
        listofDAZNConfig.add(dznConfigChangePaymentMethodURL);
        
        DAZNConfiguration__c dznConfigHelpSectionURL = new DAZNConfiguration__c();
        dznConfigHelpSectionURL.Name = 'HelpSectionURL';
        dznConfigHelpSectionURL.Value__c = '/Help';
        listofDAZNConfig.add(dznConfigHelpSectionURL);
        // end PD-7807 

        /*Start PD-14478*/
        DAZNConfiguration__c dznConfigUserNameConf = new DAZNConfiguration__c();
        dznConfigUserNameConf.Name = 'LS_UserName_Configuration';
        dznConfigUserNameConf.Value__c = 'livesport.dev';
        listofDAZNConfig.add(dznConfigUserNameConf);
        /*End PD-14478*/

        listofDAZNConfig.add(new DAZNConfiguration__c(
            Name = 'ZuoraStandardPauseResumeScheduleUrl',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/9/run'
        ));
        listofDAZNConfig.add(new DAZNConfiguration__c(
            Name = 'ZuoraCancelPauseBeforeStartURL',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/151/run'
        ));
        listofDAZNConfig.add(new DAZNConfiguration__c(
            Name = 'ZuoraChangeResumeDatesWhileInPauseURL',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/150/run'
        ));
        listofDAZNConfig.add(new DAZNConfiguration__c(
            Name = 'ZuoraChangeResumeDatesBeforePauseURL',
            Value__c = 'https://workflow.apps.zuora.com/api/v1/workflows/285/run'
        ));
        listofDAZNConfig.add(new DAZNConfiguration__c(
            Name = 'ZuoraPauseUsername',
            Value__c = 'david.francesconi@dazn.com'
        ));
        listofDAZNConfig.add(new DAZNConfiguration__c(
            Name = 'ZuoraPausePassword',
            Value__c = '58c89e0f46f549eded0a140e8d9a842f'
        ));
        listofDAZNConfig.add(new DAZNConfiguration__c(
            Name = 'AmendPauseURL',
            Value__c = 'https://dev.dazn.com/'
        ));
        
        // inserting custom setting data for DAZNConfiguration
        insert listofDAZNConfig;
        
        // custom setting data for DAZNLanguageSetting
        list<DAZNLanguageSetting__c> lisofDAZNConfLan = new list<DAZNLanguageSetting__c>();
        
        DAZNLanguageSetting__c oDAZNLanguageDE = new DAZNLanguageSetting__c();
        oDAZNLanguageDE.Name = 'Germany';
        oDAZNLanguageDE.LanguageToDisplay__c = 'en_GB,DE';
        lisofDAZNConfLan.add(oDAZNLanguageDE);
        
        DAZNLanguageSetting__c oDAZNLanguageJP = new DAZNLanguageSetting__c();
        oDAZNLanguageJP.Name = 'Japan';
        oDAZNLanguageJP.LanguageToDisplay__c = 'en_GB,ja';
        lisofDAZNConfLan.add(oDAZNLanguageJP);
        insert lisofDAZNConfLan;
        
        // End of Use custom settings to create and manage custom data at test class 
        
        
        //Custom Settings for sending email to the admin ()
        EmailNotification__c emailCustomSettings = new EmailNotification__c();
        emailCustomSettings.Name = 'Ad'+orgId;
        emailCustomSettings.Email__c = 'Ad'+uniqueName+'@testdomain.org';
        insert emailCustomSettings;
        //End 
        
        
        //Custom Settings for beta country settings
        DAZNBetaConfiguration__c betaSettings = new DAZNBetaConfiguration__c();
        betaSettings.Name = 'Japan';
        betaSettings.Country__c = 'Japan';
        betaSettings.CountryCode__c ='JP';
        insert betaSettings;
        
        DAZNBetaConfiguration__c betaSettingsIndia = new DAZNBetaConfiguration__c();
        betaSettingsIndia.Name = 'India';
        betaSettingsIndia.Country__c = 'India';
        betaSettingsIndia.CountryCode__c ='IN';
        insert betaSettingsIndia;
        //End
        
        //Custom setting for getting currency symbol 
        DAZN_Country_Currency_ISO_Code__c currencysymbolCAD = new DAZN_Country_Currency_ISO_Code__c();
        currencysymbolCAD.Name = 'CAD'; 
        currencysymbolCAD.CurrencySymbol__c = '$';
        insert currencysymbolCAD;
        
        DAZN_Country_Currency_ISO_Code__c currencysymbolCHF = new DAZN_Country_Currency_ISO_Code__c();
        currencysymbolCHF.Name = 'CHF'; 
        currencysymbolCHF.CurrencySymbol__c = 'CHF';
        insert currencysymbolCHF;
        
        DAZN_Country_Currency_ISO_Code__c currencysymbolCNY = new DAZN_Country_Currency_ISO_Code__c();
        currencysymbolCNY.Name = 'CNY'; 
        currencysymbolCNY.CurrencySymbol__c = '元';
        insert currencysymbolCNY;
        
        DAZN_Country_Currency_ISO_Code__c currencysymbolEUR = new DAZN_Country_Currency_ISO_Code__c();
        currencysymbolEUR.Name = 'EUR'; 
        currencysymbolEUR.CurrencySymbol__c = '€';
        insert currencysymbolEUR;
        
        DAZN_Country_Currency_ISO_Code__c currencysymbolGBP = new DAZN_Country_Currency_ISO_Code__c();
        currencysymbolGBP.Name = 'GBP'; 
        currencysymbolGBP.CurrencySymbol__c = '£';
        insert currencysymbolGBP;
        
        DAZN_Country_Currency_ISO_Code__c currencysymbolJPY = new DAZN_Country_Currency_ISO_Code__c();
        currencysymbolJPY.Name = 'JPY'; 
        currencysymbolJPY.CurrencySymbol__c = '¥';
        insert currencysymbolJPY;
        
        DAZN_Country_Currency_ISO_Code__c currencysymbolUSD = new DAZN_Country_Currency_ISO_Code__c();
        currencysymbolUSD.Name = 'USD'; 
        currencysymbolUSD.CurrencySymbol__c = '$';
        insert currencysymbolUSD;
        
        //End
        
        
    }
    @testSetup
    /*This method is used to create Guest user as per PD-7938*/
    public static  void CreateGuestUser(){
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId;
        uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
        List<Profile> oProfile = [SELECT Id, Name from Profile where Name = 'DAZN Profile' limit 1];
        List<User> lstUser =new List<User>(); 
        User gUser = new User();
        gUser.email= 'TestMember'+uniqueName + '@test' +'.com';
        gUser.UserName=  'TestMember' + uniqueName+'@test'+ '.org';
        gUser.Alias = 'Member';
        gUser.TimeZoneSidKey= 'Asia/Tokyo';
        gUser.EmailEncodingKey= 'ISO-8859-1';
        gUser.LocaleSidKey= 'ja_JP';
        gUser.LanguageLocaleKey= 'en_GB';
        gUser.FirstName = 'TestFName';
        gUser.LastName = 'Member'+uniqueName;
        gUser.isActive= true;
        gUser.profileid = oProfile[0].Id;
        lstUser.add(gUser);
        Database.insert(lstUser,true);   
    }//end of PD-7938
    /* Description: This method is used to create community user recode.*/
    
    public static DAZNUserFeed__c createTestDFDUserFeedRecords(){
        DAZNUserFeed__c userdetails=new  DAZNUserFeed__c();
        userdetails.First_Name__c='firsttest';
        userdetails.Last_Name__c='lasttest';
        userdetails.Email__c='test2344@test.com';
        userdetails.BillingCountryCode__c='JP';
        userdetails.LanguageLocaleKey__c='ja';
        userdetails.Email_Preferences__c=true;
        userdetails.Secondary_Email__c='test222@test.com';
        userdetails.Alias__c = 'tt23';
        userdetails.TimeZoneSidKey__c = 'Asia/Tokyo';
        userdetails.LocaleSidKey__c = 'ja_JP';
        userdetails.Account_Status__c='Active Paid';
        userdetails.Partner_Registration_status__c='complete';
        userdetails.Partner_Id__c='asdghh243';
        userdetails.DAZN_Id__c = '2323223';
        userdetails.Auth_Key__c = system.now();
        userdetails.Account_Type__c = '2';
        userdetails.ViewerId__c = '222121223';
        userdetails.IP_address__c = '255.255.255.255';
        userdetails.User_Type__c = 'Docomo';
        userdetails.Subscription_Start_Date__c = Date.today();
        userdetails.Subscription_End_Date__c = Date.today()+30;
        return userdetails;
    }
    public static List<DAZNUserFeed__c> createTestDFDUserFeedRecordsBulk( integer sizeRecords){
        List<DAZNUserFeed__c> DFDUserFeedRecords = new List<DAZNUserFeed__c>(); 
        for(integer i=0; i<sizeRecords; i++){
            DAZNUserFeed__c userdetails=new  DAZNUserFeed__c();
            //userdetails.Name = 'Test1222'+i;
            userdetails.First_Name__c='firsttest'+i;
            userdetails.Last_Name__c='lasttest'+i;
            userdetails.Email__c='test2344'+i+'@test.com';
            userdetails.BillingCountryCode__c='JP';
            userdetails.LanguageLocaleKey__c='ja';
            userdetails.EmailEncodingKey__c='UTF-8';
            userdetails.Email_Preferences__c=true;
            userdetails.Secondary_Email__c='test222@test.com';
            userdetails.Alias__c = 'ttss'+i;
            userdetails.TimeZoneSidKey__c = 'Asia/Tokyo';
            userdetails.CommunityNickname__c= i+'test'+i+'Te';
            userdetails.LocaleSidKey__c = 'ja_JP';
            userdetails.Account_Status__c='Active Paid';
            userdetails.Partner_Registration_status__c='complete';
            userdetails.Partner_Id__c='asdghh2'+i;
            userdetails.Num_Retries__c = 0;
            userdetails.DAZN_Id__c = '232232323' +i;
            userdetails.Auth_Key__c = system.now();
            userdetails.ViewerId__c = 's1s2s121212w'+i;
            userdetails.IP_address__c = '255.255.255.255';
            userdetails.User_Type__c = 'Docomo';
            userdetails.Subscription_Start_Date__c = Date.today();
        userdetails.Subscription_End_Date__c = Date.today()+30;
            DFDUserFeedRecords.add(userdetails);
        }
        return DFDUserFeedRecords;
    } 
    /*Description: This method is used to create community user with notification language code as de as per PD-9770*/
    @testSetup
    public static void createTestDEAccounts(){
        String orgId = UserInfo.getOrganizationId();
        List<Account> accList = new List<Account>();
        for (Integer i = 0;i<7;i++){
            String uniqueName = orgId;
            uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
            Account oAccount = new Account();
            oAccount.FirstName = 'TestFirstName';
            oAccount.LastName = 'TestLastName'+i;
            oAccount.PersonEmail = 'email'+uniqueName+i+ '@testdomain.org';
            oAccount.Notification_Country_Code__c='DE';
            oAccount.Notification_Language_Code__c='de';
            oAccount.All_Email_Preferences__c = true;
            if(i==0){
                //Create Frozen Account
                oAccount.Account_Status__c = 'Frozen';
            } else if(i==1){
                //Create Active Paid Account
                oAccount.Account_Status__c = 'Active Paid';
                oAccount.Is_Double_OptIn__c = true;
                oAccount.IsReadyToSyncInZuora__c=true;
            } else if(i==2){
                //Create Free Trial Account
                oAccount.Account_Status__c = 'Free Trial';
                oAccount.Is_Double_OptIn__c = true;
                //oAccount.Notification_Language_Code__c= 'de';
            } else if(i==3){
                //Create Active Grace Account
                oAccount.Account_Status__c = 'Active Grace';
            } else if(i==4){
                //Create Expired Account
                oAccount.Account_Status__c = 'Expired';
            } else if(i==5){
                //Create Blocked Account
                oAccount.Account_Status__c = 'Blocked';
            } else if(i==6){
                //Create Partial Account
                oAccount.Account_Status__c = 'Partial';
            } 
            accList.add(oAccount);
            
        } //end of for - Account data preparation
        Database.insert(accList,true);
        
    }
    @testSetup
    public static void createTestDECommunityUsers(){
        List<Account> getaccList = [Select Id,Name,PersonContactId, Owner.Name, owner.UserRoleId,PersonEmail from Account];
        List<User> userList = new List<User>();
        //Query Profile for community user 
        List<Profile> listOfProfiles = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
        if (listOfProfiles[0].Id !=null){
            Integer cnt = 11;
            for(Account acc : getaccList){
                User oUser = new User();
                oUser.email= acc.PersonEmail;
                oUser.Notification_Language_Code__c='de';
                oUser.UserName= acc.PersonEmail;
                oUser.Alias = 'LiveSp'+cnt;
                if(cnt == 11){
                    oUser.TimeZoneSidKey= 'Asia/Tokyo';
                    oUser.LocaleSidKey= 'ja_JP';
                    oUser.LanguageLocaleKey= 'ja';
                    oUser.Country= 'Japan';
                } else if(cnt == 12){
                    oUser.TimeZoneSidKey= 'Europe/Berlin';
                    oUser.LocaleSidKey= 'de_DE';
                    oUser.LanguageLocaleKey= 'de';
                    oUser.Country= 'Germany';
                } else if(cnt == 13){
                    oUser.TimeZoneSidKey= 'Europe/London';
                    oUser.LocaleSidKey= 'de_AT';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Austria';
                } else if(cnt == 14){
                    oUser.TimeZoneSidKey= 'Europe/Berlin';
                    oUser.LocaleSidKey= 'de_CH';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Switzerland';
                }else if(cnt == 15){
                    oUser.TimeZoneSidKey= 'Europe/Berlin';
                    oUser.LocaleSidKey= 'ja_JP';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'India';
                }else if(cnt == 16){
                    oUser.TimeZoneSidKey= 'Europe/London';
                    oUser.LocaleSidKey= 'de_DE';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Germany';
                }else if(cnt==17){
                    oUser.TimeZoneSidKey= 'Europe/London';
                    oUser.LocaleSidKey= 'de_DE';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Germany';
                }
                oUser.EmailEncodingKey= 'ISO-8859-1';
                oUser.FirstName = 'TestFName';
                oUser.LastName = 'TestLName'+cnt;
                oUser.isActive= true;
                oUser.ContactId = acc.PersonContactId;
                oUser.profileid = listOfProfiles[0].Id;
                userList.add(oUser) ; 
                cnt = cnt + 1;
            }//end of for loop 
            Database.insert(userList,true);
        } //end of if - profile id null check
    }
    /*Description: This method is used to create community user with notification language code as ja as per PD-9770*/
    @testSetup
    public static void createTestJPAccounts(){
        String orgId = UserInfo.getOrganizationId();
        List<Account> accList = new List<Account>();
        for (Integer i = 0;i<7;i++){
            String uniqueName = orgId;
            uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
            Account oAccount = new Account();
            oAccount.FirstName = 'TestFirstName';
            oAccount.LastName = 'TestLastName'+i;
            oAccount.PersonEmail = 'email'+uniqueName+i+ '@testdomain.org';
            oAccount.Notification_Country_Code__c='DE';
            oAccount.Notification_Language_Code__c='ja';
            oAccount.All_Email_Preferences__c = true;
            if(i==0){
                //Create Frozen Account
                oAccount.Account_Status__c = 'Frozen';
            } else if(i==1){
                //Create Active Paid Account
                oAccount.Account_Status__c = 'Active Paid';
                oAccount.Is_Double_OptIn__c = true;
                oAccount.IsReadyToSyncInZuora__c=true;
            } else if(i==2){
                //Create Free Trial Account
                oAccount.Account_Status__c = 'Free Trial';
                oAccount.Is_Double_OptIn__c = true;
                //oAccount.Notification_Language_Code__c= 'de';
            } else if(i==3){
                //Create Active Grace Account
                oAccount.Account_Status__c = 'Active Grace';
            } else if(i==4){
                //Create Expired Account
                oAccount.Account_Status__c = 'Expired';
            } else if(i==5){
                //Create Blocked Account
                oAccount.Account_Status__c = 'Blocked';
            } else if(i==6){
                //Create Partial Account
                oAccount.Account_Status__c = 'Partial';
            } 
            accList.add(oAccount);
            
        } //end of for - Account data preparation
        Database.insert(accList,true);
        
    }
    @testSetup
    public static void createTestJPCommunityUsers(){
        List<Account> getaccList = [Select Id,Name,PersonContactId, Owner.Name, owner.UserRoleId,PersonEmail from Account];
        List<User> userList = new List<User>();
        //Query Profile for community user 
        List<Profile> listOfProfiles = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
        if (listOfProfiles[0].Id !=null){
            Integer cnt = 11;
            for(Account acc : getaccList){
                User oUser = new User();
                oUser.email= acc.PersonEmail;
                oUser.UserName= acc.PersonEmail;
                oUser.Alias = 'LiveSp'+cnt;
                if(cnt == 11){
                    oUser.TimeZoneSidKey= 'Asia/Tokyo';
                    oUser.LocaleSidKey= 'ja_JP';
                    oUser.LanguageLocaleKey= 'ja';
                    oUser.Country= 'Japan';
                } else if(cnt == 12){
                    oUser.TimeZoneSidKey= 'Europe/Berlin';
                    oUser.LocaleSidKey= 'de_DE';
                    oUser.LanguageLocaleKey= 'de';
                    oUser.Country= 'Germany';
                } else if(cnt == 13){
                    oUser.TimeZoneSidKey= 'Europe/London';
                    oUser.LocaleSidKey= 'de_AT';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Austria';
                } else if(cnt == 14){
                    oUser.TimeZoneSidKey= 'Europe/Berlin';
                    oUser.LocaleSidKey= 'de_CH';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Switzerland';
                }else if(cnt == 15){
                    oUser.TimeZoneSidKey= 'Europe/Berlin';
                    oUser.LocaleSidKey= 'ja_JP';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'India';
                }else if(cnt == 16){
                    oUser.TimeZoneSidKey= 'Europe/London';
                    oUser.LocaleSidKey= 'de_DE';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Germany';
                }else if(cnt==17){
                    oUser.TimeZoneSidKey= 'Europe/London';
                    oUser.LocaleSidKey= 'de_DE';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Germany';
                }
                oUser.EmailEncodingKey= 'ISO-8859-1';
                oUser.FirstName = 'TestFName';
                oUser.LastName = 'TestLName'+cnt;
                oUser.isActive= true;
                oUser.ContactId = acc.PersonContactId;
                oUser.profileid = listOfProfiles[0].Id;
                userList.add(oUser) ; 
                cnt = cnt + 1;
            }//end of for loop 
            Database.insert(userList,true);
        } //end of if - profile id null check
        
    }
    /*Description: This method is used to create community user with notification language code as en as per PD-9770*/
    @testSetup
    public static void createTestENAccounts(){
        String orgId = UserInfo.getOrganizationId();
        List<Account> accList = new List<Account>();
        for (Integer i = 0;i<7;i++){
            String uniqueName = orgId;
            uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
            Account oAccount = new Account();
            oAccount.FirstName = 'TestFirstName';
            oAccount.LastName = 'TestLastName'+i;
            oAccount.PersonEmail = 'email'+uniqueName+i+ '@testdomain.org';
            oAccount.Notification_Country_Code__c='DE';
            oAccount.Notification_Language_Code__c='en_GB';
            oAccount.All_Email_Preferences__c = true;
            if(i==0){
                //Create Frozen Account
                oAccount.Account_Status__c = 'Frozen';
            } else if(i==1){
                //Create Active Paid Account
                oAccount.Account_Status__c = 'Active Paid';
                oAccount.Is_Double_OptIn__c = true;
                oAccount.IsReadyToSyncInZuora__c=true;
            } else if(i==2){
                //Create Free Trial Account
                oAccount.Account_Status__c = 'Free Trial';
                oAccount.Is_Double_OptIn__c = true;
                //oAccount.Notification_Language_Code__c= 'de';
            } else if(i==3){
                //Create Active Grace Account
                oAccount.Account_Status__c = 'Active Grace';
            } else if(i==4){
                //Create Expired Account
                oAccount.Account_Status__c = 'Expired';
            } else if(i==5){
                //Create Blocked Account
                oAccount.Account_Status__c = 'Blocked';
            } else if(i==6){
                //Create Partial Account
                oAccount.Account_Status__c = 'Partial';
            } 
            accList.add(oAccount);
            
        } //end of for - Account data preparation
        Database.insert(accList,true);
        
    }
    @testSetup
    public static void createTestENCommunityUsers(){
        List<Account> getaccList = [Select Id,Name,PersonContactId, Owner.Name, owner.UserRoleId,PersonEmail from Account];
        List<User> userList = new List<User>();
        //Query Profile for community user 
        List<Profile> listOfProfiles = [SELECT Id, Name from Profile where Name = 'Customer Community User' limit 1];
        if (listOfProfiles[0].Id !=null){
            Integer cnt = 11;
            for(Account acc : getaccList){
                User oUser = new User();
                oUser.email= acc.PersonEmail;
                oUser.UserName= acc.PersonEmail;
                oUser.Alias = 'LiveSp'+cnt;
                if(cnt == 11){
                    oUser.TimeZoneSidKey= 'Asia/Tokyo';
                    oUser.LocaleSidKey= 'ja_JP';
                    oUser.LanguageLocaleKey= 'ja';
                    oUser.Country= 'Japan';
                } else if(cnt == 12){
                    oUser.TimeZoneSidKey= 'Europe/Berlin';
                    oUser.LocaleSidKey= 'de_DE';
                    oUser.LanguageLocaleKey= 'de';
                    oUser.Country= 'Germany';
                } else if(cnt == 13){
                    oUser.TimeZoneSidKey= 'Europe/London';
                    oUser.LocaleSidKey= 'de_AT';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Austria';
                } else if(cnt == 14){
                    oUser.TimeZoneSidKey= 'Europe/Berlin';
                    oUser.LocaleSidKey= 'de_CH';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Switzerland';
                }else if(cnt == 15){
                    oUser.TimeZoneSidKey= 'Europe/Berlin';
                    oUser.LocaleSidKey= 'ja_JP';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'India';
                }else if(cnt == 16){
                    oUser.TimeZoneSidKey= 'Europe/London';
                    oUser.LocaleSidKey= 'de_DE';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Germany';
                }else if(cnt==17){
                    oUser.TimeZoneSidKey= 'Europe/London';
                    oUser.LocaleSidKey= 'de_DE';
                    oUser.LanguageLocaleKey= 'en_GB';
                    oUser.Country= 'Germany';
                }
                oUser.EmailEncodingKey= 'ISO-8859-1';
                oUser.FirstName = 'TestFName';
                oUser.LastName = 'TestLName'+cnt;
                oUser.isActive= true;
                oUser.ContactId = acc.PersonContactId;
                oUser.profileid = listOfProfiles[0].Id;
                userList.add(oUser) ; 
                cnt = cnt + 1;
            }//end of for loop 
            Database.insert(userList,true);
        } //end of if - profile id null check
        
    } 
}