@isTest
public class StandardUserValidationTest {
    

    
		
    static testmethod void uservalidationGermany(){
	
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);

		List<user> standardProfileUsers = [select id,country,LanguageLocaleKey,usertype from user where profileId in:profileIds.Keyset() limit 1];
		
        standardProfileUsers[0].country = 'Germany';
         standardProfileUsers[0].LanguageLocaleKey = 'en_US';
        update  standardProfileUsers[0];
        list<id> userlist = new list<id>();
        userlist.add(standardProfileUsers[0].id);
      	System.assertEquals(standardProfileUsers[0].usertype,'Standard');
        StandardUserValidation.updateUser(userlist);                      
        
    }
        static testmethod void uservalidationAustria(){
	
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);

		List<user> standardProfileUsers = [select id,country,LanguageLocaleKey,usertype from user where profileId in:profileIds.Keyset() limit 1];
		
        standardProfileUsers[0].country = 'Austria';
         standardProfileUsers[0].LanguageLocaleKey = 'en_US';
        update  standardProfileUsers[0];
        list<id> userlist = new list<id>();
        userlist.add(standardProfileUsers[0].id);
      	System.assertEquals(standardProfileUsers[0].usertype,'Standard');
        StandardUserValidation.updateUser(userlist);                      
        
    }
        static testmethod void uservalidationSwitzerland(){
	
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);

		List<user> standardProfileUsers = [select id,country,LanguageLocaleKey,usertype from user where profileId in:profileIds.Keyset() limit 1];
		
        standardProfileUsers[0].country = 'Switzerland';
         standardProfileUsers[0].LanguageLocaleKey = 'en_US';
        update  standardProfileUsers[0];
        list<id> userlist = new list<id>();
        userlist.add(standardProfileUsers[0].id);
      	System.assertEquals(standardProfileUsers[0].usertype,'Standard');
        StandardUserValidation.updateUser(userlist);                      
        
    }
        static testmethod void uservalidationJapan(){
	
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);

		List<user> standardProfileUsers = [select id,country,LanguageLocaleKey,usertype from user where profileId in:profileIds.Keyset() limit 1];
		
        standardProfileUsers[0].country = 'Japan';
         standardProfileUsers[0].LanguageLocaleKey = 'en_US';
        update  standardProfileUsers[0];
        list<id> userlist = new list<id>();
        userlist.add(standardProfileUsers[0].id);
      	System.assertEquals(standardProfileUsers[0].usertype,'Standard');
        StandardUserValidation.updateUser(userlist);                      
        
    }
        static testmethod void uservalidationCanada(){
	
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);

		List<user> standardProfileUsers = [select id,country,LanguageLocaleKey,usertype from user where profileId in:profileIds.Keyset() limit 1];
		
        standardProfileUsers[0].country = 'Canada';
         standardProfileUsers[0].LanguageLocaleKey = 'en_GB';
        update  standardProfileUsers[0];
        list<id> userlist = new list<id>();
        userlist.add(standardProfileUsers[0].id);
      	System.assertEquals(standardProfileUsers[0].usertype,'Standard');
        StandardUserValidation.updateUser(userlist);                      
        
    }
        static testmethod void uservalidationotherCountries(){
	
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);

		List<user> standardProfileUsers = [select id,country,LanguageLocaleKey,usertype from user where profileId in:profileIds.Keyset() limit 1];
		
        standardProfileUsers[0].country = 'India';
         standardProfileUsers[0].LanguageLocaleKey = 'en_US';
        update  standardProfileUsers[0];
        list<id> userlist = new list<id>();
        userlist.add(standardProfileUsers[0].id);
      	System.assertEquals(standardProfileUsers[0].usertype,'Standard');
        StandardUserValidation.updateUser(userlist);                      
        
    }    
}