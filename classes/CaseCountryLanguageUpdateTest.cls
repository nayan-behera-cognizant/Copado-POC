@IsTest
public class CaseCountryLanguageUpdateTest {
    
    @testSetup
    /*This method is used to create Customer Service user*/
    public static  void CreateCSUser(){
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId;
        uniqueName += String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        uniqueName += Integer.valueOf(math.rint(math.random()*1000000));
        List<Profile> oProfile = [SELECT Id, Name from Profile where Name = 'Customer Service Team Member' limit 1];
        system.assert(oProfile.size()>0);
        User csUser = new User();
        csUser.email= 'TestMember'+uniqueName + '@test' +'.com';
        csUser.UserName=  'TestMember' + uniqueName+'@test'+ '.org';
        csUser.Alias = 'Member';
        csUser.TimeZoneSidKey= 'Asia/Tokyo';
        csUser.EmailEncodingKey= 'ISO-8859-1';
        csUser.LocaleSidKey= 'ja_JP';
        csUser.LanguageLocaleKey= 'en_GB';
        csUser.FirstName = 'TestFName';
        csUser.LastName = 'Member'+uniqueName;
        csUser.isActive= true;
        csUser.profileid = oProfile[0].Id;
        insert csUser;
        system.assertNotEquals(csUser, null);
    }
    
    
    /*This method is to update the notification country and language code*/
    
    static testMethod void testCaseCountryLanguage() {
        CaseCountryLanguages__c caseCountLang = new CaseCountryLanguages__c();
        caseCountLang.Name = 'JP';
        caseCountLang.Language__c = 'ja,en';
        insert caseCountLang;
        
        List<Profile> profile=[select id, Name from profile where Name='Customer Service Team Member'limit 1 ]; 
        system.assert(profile.size()>0);
        User csUser=[select id,UserName from user where profileid= :profile[0].Id  AND IsActive = true limit 1]; 
        Test.startTest();
        Case caseobj=new Case();
            caseobj.Subject='testSubject';
            caseobj.Description='testdescription';
            caseobj.Type = 'General Enquiry';
            insert caseobj;
            
            system.assertEquals('testSubject', caseobj.Subject);
            
            CaseCountryLanguageUpdate caseCountryLanguage = new CaseCountryLanguageUpdate(new ApexPages.StandardController(caseobj));
            caseCountryLanguage.getCountry();
            caseCountryLanguage.SelectedCountryCode = 'JP';
            caseCountryLanguage.changeLang();
            caseCountryLanguage.SelectedLanguageCode = 'ja';
            caseCountryLanguage.saveAndReturn();
            caseCountryLanguage.cancelAction();
         Test.stopTest();
        
    }
    
    
    /*This method is to test the functionality when we save record without selecting country and language values*/
    
    static testMethod void testElseWithoutCountrycode() {
        List<Profile> profile=[select id, Name from profile where Name='Customer Service Team Member'limit 1 ]; 
        system.assert(profile.size()>0);
        User csUser=[select id,UserName from user where profileid= :profile[0].Id  AND IsActive = true limit 1]; 
        Test.startTest();
        Case caseobj=new Case();
            caseobj.Subject='testSubject';
            caseobj.Description='testdescription';
            caseobj.Type = 'General Enquiry';
            insert caseobj;
            
            system.assertEquals('testdescription', caseobj.Description);
            CaseCountryLanguageUpdate caseCountryLanguage = new CaseCountryLanguageUpdate(new ApexPages.StandardController(caseobj));
            caseCountryLanguage.saveAndReturn();
        Test.stopTest();
        
    }
    
    
    /*This method is to cover the catch exception scenario*/
    
    static testMethod void testException(){
        Case caseobj=new Case();
        caseobj.Subject='testSubject';
        caseobj.Description='testdescription';
        caseobj.Type = 'General Enquiry';
        insert caseobj;
        System.assertEquals('General Enquiry', caseobj.Type);
        
        CaseCountryLanguageUpdate caseCountryLanguage = new CaseCountryLanguageUpdate(new ApexPages.StandardController(caseobj));
        caseCountryLanguage.SelectedCountryCode = 'JP';
        caseCountryLanguage.SelectedLanguageCode = 'deendfdfdfgrbhjydsngdchfgbvh';
        caseCountryLanguage.saveAndReturn();
        
    }
    
}