/**
* @author Cognizant Technology Solutuions
* @date 04/26/2016
* @description Test class for double optin page.
*/

@istest
public class DoubleOptInControllerTest {
    
    /* 
Description: Method to test double optin page funcationality.
*/
    //changes As per PD-7818
    @testSetup
    public static void testUser(){
        CreateTestDataforUnitTest.triggerSettings();
        CreateTestDataforUnitTest.createTestAccounts();
        CreateTestDataforUnitTest.createTestCommunityUsers();
        CreateTestDataforUnitTest.CreateGuestUser();//As per PD-7938
        SetUpTestData.emailCustsett();
		//Modified as part of PD-15349
        List<DAZNConfiguration__c> dhr = new List<DAZNConfiguration__c>();
        dhr.add(new DAZNConfiguration__c(
            Name = 'Geo IP timeout',
            Value__c ='4999'
        ));
        
        dhr.add(new DAZNConfiguration__c(
            Name = 'IPADDRESSFINDER',
            Value__c ='http://geoip.nekudo.com/api/'
        ));
        insert dhr;
		//End of PD-15349
        List<DAZNConfiguration__c> dc = new List<DAZNConfiguration__c>();
        dc.add(new DAZNConfiguration__c(
            Name = 'HomePageURL',
            Value__c = '3'
        ));
        dc.add(new DAZNConfiguration__c(
            Name = 'HomePageURLBeta',
            Value__c = '33'
        ));
        insert dc;
    }
    
    //for guest user
    static testMethod void testDoubleOptInFunctionality(){
         List<Profile> profile=[select id, Name from profile where Name='DAZN Profile'limit 1 ]; //As per PD-7938
        List <User> gUser=[select id,UserName from user where profileid= :profile[0].Id  AND IsActive = true limit 1]; //As per PD-7938
        system.assertEquals(1,gUser.size()); //As per PD-7938
        System.RunAs(gUser[0]){
            Test.StartTest();
            map<string,object> mapOfresObj = (Map<String, Object>)JSON.deserializeUntyped('{"city":false,"country":{"name":"Germany","code":"en"},"location":{"latitude":20,"longitude":77,"time_zone":"AsiaKolkata"}}');
            string strREs = (string)JSON.serialize(mapOfresObj);  
            SingleRequestMock fakeResponse = new SingleRequestMock(200,'Success',strREs,null);//as per PD-7818
            system.assertNotEquals(null,fakeResponse);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            PageReference pageRef = Page.DoubleOptIn;
            Test.setCurrentPage(pageRef);
            DoubleOptInController objCntrl = new DoubleOptInController();
            objCntrl.setDoubleOptIn();
            Test.stopTest();
        }    
    }
    
    //for community user as per PD-7818
    static testMethod void testDoubleOptIn(){
        List<Account> acclist=[Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Paid' limit 1];
        system.assertEquals(1, acclist.size());
        List<Id> contactIdList = new List<Id>();
        for(Account acc : accList){
            contactIdList.add(acc.PersonContactId);
        } 
       List<User> oUser = [Select Id,FirstName,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        System.RunAs(oUser[0]){
            Test.StartTest();
            Pagereference pagerefer=Page.DoubleOptIn;
            system.assertEquals('/apex/doubleoptin', pagerefer.getUrl());
            Test.setCurrentPage(pagerefer);
            pagerefer.getParameters().put('lang','en');
            //to set double optIn flag for an account
            pagerefer.getParameters().put('id','UID'+acclist[0].id);
            DoubleOptInController objectcon = new DoubleOptInController();
            objectcon.setDoubleOptIn();
            Test.stopTest();
        }
    }

    static testMethod void testDoubleOptInException() {
        List<Account> acclist = [Select Id, Name, PersonEmail,PersonContactId from Account where Account_Status__c = 'Active Paid' limit 1];
        system.assertEquals(1, acclist.size());
        List<Id> contactIdList = new List<Id>();
        for (Account acc : accList) {
            contactIdList.add(acc.PersonContactId);
        } 
        List<User> oUser = [Select Id,FirstName,LastName,UserName,Alias,Country,LanguageLocaleKey from User where ContactId In : contactIdList];
        System.RunAs(oUser[0]) {
            Test.StartTest();
            Pagereference pagerefer = Page.DoubleOptIn;
            system.assertEquals('/apex/doubleoptin', pagerefer.getUrl());
            Test.setCurrentPage(pagerefer);
            pagerefer.getParameters().put('id', 'UID' + 'test');
            DoubleOptInController objectcon = new DoubleOptInController();
            Pagereference pr = objectcon.setDoubleOptIn();
            System.assertNotEquals(null, pr);
            Test.stopTest();
        }
    }

    static testMethod void testRedirectToHomePage() {
        DoubleOptInController doic = new DoubleOptInController();
        PageReference pr = doic.redirectToHomePage();
        System.assertNotEquals(null, pr);
    }
    
}