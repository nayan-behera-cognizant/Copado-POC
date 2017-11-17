/**
*  @author Megha Jain
*  @date March 26, 2017
*  @description PauseHelper
@Modification Log:        
------------------------------------------------------------------------------------        
Developer                Mod Number       Date                Description        
------------------------------------------------------------------------------------        
Megha Jain               -           26/03/2017           Initial version created.
*/
public class LS_PauseHelper {   
    
    
    /**
*  @author Megha Jain
*  @date March 26, 2017
*  @description : This method is used to get the local month as per the user language from custom setting
@Parameter : Month in interger 
*/
    public static String localMonthName(Integer month){
        
        String key;
        String sCountryCode;
        String strLangCode;
        String monthName;
        User user ; 
        if(user==null)
        {
            user = CommunityHelper.getCurrentUser();
        }
        
        
       
          
        List<String>countryList = new List<String>();
        Map<String,String>monthAndCountryMap = new Map<String,String>();
        string strLanguage = CommunityHelper.getLanguageCode();
        
        if(!String.isBlank(strLanguage)  && month !=null ){
            key = strLanguage +':'+month ;
            
            system.debug('$$$key'+ key); 
            
            List<DAZN_Country_Localized_Month__c> conRecords = [SELECT Month_In_Local_Lang__c , Month_In_Number__c , Language_Code__c FROM DAZN_Country_Localized_Month__c];
            
            
            for (DAZN_Country_Localized_Month__c localMonth :conRecords ){
                
                monthAndCountryMap.put(localMonth.Language_Code__c+':'+localMonth.Month_In_Number__c,localMonth.Month_In_Local_Lang__c);
                
                system.debug('$$$ monthAndCountryMap'+ monthAndCountryMap);
  
                if(monthAndCountryMap.containsKey(key) ){
                    monthName = monthAndCountryMap.get(key); 
                    system.debug('monthName'+ monthName);      
                }         
            }      
        }
        return monthName;
    }
    
    
     public static String localMonthNameForLanguageSwitch(Integer month){
        
        String key;
        String sCountryCode;
        String strLangCode;
        String monthName;
        User user ; 
        if(user==null)
        {
            user = CommunityHelper.getCurrentUser();
        }
        
            String pageParamCountry = ApexPages.currentPage().getParameters().get('Country');
            String pageParamLang = ApexPages.currentPage().getParameters().get('lang');
            sCountryCode = (String.isNotBlank(pageParamCountry)) ? pageParamCountry : user.CountryCode;
            strLangCode = ((String.isNotBlank(pageParamLang)) ? pageParamLang : CommunityHelper.getLanguageCode()).toLowerCase();
            if (strLangCode.equalsIgnoreCase('en')) {
                strLangCode = 'en_GB';
            }
        
        
          system.debug('$$$ sCountryCode '+ sCountryCode +strLangCode );
          
          
        List<String>countryList = new List<String>();
        Map<String,String>monthAndCountryMap = new Map<String,String>();
       
        
        if(!String.isBlank(strLangCode)  && month !=null ){
            key = strLangCode +':'+month ;
            
            system.debug('$$$key'+ key); 
            
            List<DAZN_Country_Localized_Month__c> conRecords = [SELECT Month_In_Local_Lang__c , Month_In_Number__c , Language_Code__c FROM DAZN_Country_Localized_Month__c];
            
            
            for (DAZN_Country_Localized_Month__c localMonth :conRecords ){
                
                monthAndCountryMap.put(localMonth.Language_Code__c+':'+localMonth.Month_In_Number__c,localMonth.Month_In_Local_Lang__c);
                
                system.debug('$$$ monthAndCountryMap'+ monthAndCountryMap);
  
                if(monthAndCountryMap.containsKey(key) ){
                    monthName = monthAndCountryMap.get(key); 
                    system.debug('$$$monthName'+ monthName);      
                }         
            }      
        }
        return monthName;
    }
    
    /**
*  @author Megha Jain
*  @date March 26, 2017
*  @description : This method is used to create the Localized  date  per the user language 
   @Parameter : Date 
*/
    public static string localFormattedDate (Date dt,String localLang){
        
        Integer month =dt.month();
        Integer year = dt.Year();
        Integer day= dt.day();
        
        
        system.debug('$$$ localLang'+ localLang );
       
        
        String strLocaleFormattedDate = null;
        string strLanguage = localLang;
        string locMonth = localMonthNameForLanguageSwitch(month);
        
        system.debug('$$$ localFormattedDate'+ month+'$$'+year+'$$'+day +locMonth +strLanguage  );
        
        
        
        if ( strLanguage.equalsIgnoreCase('ja')){
            
            if(dt != null){
                strLocaleFormattedDate = year+'/'+month +'/'+day;   
            }
                 
        }else if (strLanguage.equalsIgnoreCase('de')) {
            
            string nday = (day<10 ? string.valueof('0'+day):string.valueof(day));
            strLocaleFormattedDate = nday +'.'+locMonth+' '+year ;
            
        }else if (strLanguage.equalsIgnoreCase('en_GB')){
            
            strLocaleFormattedDate = day+' '+locMonth+' '+year;
            
        }
        return strLocaleFormattedDate ;
    }



 public static string localFormattedDate (Date dt){
        
        Integer month =dt.month();
        Integer year = dt.Year();
        Integer day= dt.day();
        
        system.debug('$$$ localFormattedDate'+ month+'$$'+year+'$$'+day);
        
        String strLocaleFormattedDate = null;
        string strLanguage = CommunityHelper.getLanguageCode();
        string locMonth = localMonthName(month);
        
        system.debug('$$$ localFormattedDate'+ month+'$$'+year+'$$'+day +locMonth +strLanguage  );
        
        if ( strLanguage.equalsIgnoreCase('ja')){
            
            if(dt != null){
                strLocaleFormattedDate = year+'/'+month +'/'+day;   
            }
                 
        }else if (strLanguage.equalsIgnoreCase('de')) {
            
            string nday = (day<10 ? string.valueof('0'+day):string.valueof(day));
            strLocaleFormattedDate = nday +'.'+locMonth+' '+year ;
            
        }else if (strLanguage.equalsIgnoreCase('en_GB')){
            
            strLocaleFormattedDate = day+' '+locMonth+' '+year;
            
        }
        return strLocaleFormattedDate ;
    }
}