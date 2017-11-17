/*********************************************************************************************
 Created as Part of PD-13215, standard user language should be updated based on the default language
Owner: KothaSaiNagaSowmith, Cognizant Technology Solutions
**********************************************************************************************/
public class StandardUserValidation {
 
    //Metod to update standard users language  
    @InvocableMethod
    public static void updateUser(List<Id> userIds)
    {
        List<User> userListtoUpdate = [select id,usertype,LanguageLocaleKey,country  from User where id IN : userIds];      
 		list<User> updatedUsersList = new list<User>();
        //Delete if list is not empty
        if(userListtoUpdate!=null && userListtoUpdate.size() > 0){
            for(User usr:userListtoUpdate){
                if(usr!=null && usr.country == 'Germany' && usr.LanguageLocaleKey !='en_GB'&& usr.LanguageLocaleKey !='de' ){
                    usr.LanguageLocaleKey = 'en_GB';
                    updatedUsersList.add(usr);
                }else if(usr!=null  && usr.country == 'Switzerland' && usr.LanguageLocaleKey !='en_GB'&& usr.LanguageLocaleKey !='de'){
                    usr.LanguageLocaleKey = 'en_GB';
                    updatedUsersList.add(usr);
                }else if(usr!=null  && usr.country == 'Austria' && usr.LanguageLocaleKey !='en_GB'&& usr.LanguageLocaleKey !='de'){
                    usr.LanguageLocaleKey = 'en_GB';
                    updatedUsersList.add(usr);
                }else if(usr!=null  && usr.country == 'Japan' && usr.LanguageLocaleKey !='en_GB'&& usr.LanguageLocaleKey !='ja'){
                    usr.LanguageLocaleKey = 'ja';
                    updatedUsersList.add(usr);
                }else if(usr!=null  && usr.country == 'Canada' && usr.LanguageLocaleKey !='en_US'&& usr.LanguageLocaleKey !='fr_CA'){
                    usr.LanguageLocaleKey = 'en_US';
                    updatedUsersList.add(usr);
                }else if(usr!=null  && usr.country != 'Canada' && usr.country != 'Germany' && usr.country != 'Switzerland'&& usr.country != 'Austria'&& usr.country != 'Japan'){
                    usr.LanguageLocaleKey = 'en_GB';
                    updatedUsersList.add(usr);
                }
	      }
            if(updatedUsersList !=null && updatedUsersList.size()>0){
            update updatedUsersList;
            }
        }        
    }    
}