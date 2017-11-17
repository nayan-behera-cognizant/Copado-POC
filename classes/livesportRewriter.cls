global class livesportRewriter implements Site.UrlRewriter {
    
    global pageReference mapRequestUrl(pageReference userFriendlyUrl){
        /*PD-9104*/
        DocomoConfiguration__c docomoConfiguration = DocomoConfiguration__c.getValues('ReturnUrl');
        if (docomoConfiguration != null) {
            if (userFriendlyUrl.getUrl().startsWithIgnoreCase(docomoConfiguration.Value__c)&& userFriendlyUrl.getParameters().get('code') != null && userFriendlyUrl.getParameters().get('state') != null) {
                String docomoCode = userFriendlyUrl.getParameters().get('code');
                String docomoState = userFriendlyUrl.getParameters().get('state');
                PageReference docomoSignIn = System.Page.DocomoSignIn;
                docomoSignIn.getParameters().put('code', docomoCode);
                docomoSignIn.getParameters().put('state', docomoState);
                docomoSignIn.getParameters().put('auth', 'true');
                docomoSignIn.setRedirect(true);
                return docomoSignIn;
            }
        }

        string url = userFriendlyUrl.getUrl();

        string sTrakingParam;
        url = url.replace('/?','?');
        if (url.contains('?')) {
            sTrakingParam = url.substring(url.indexOf('?'));
            url = url.substring(0, url.indexOf('?'));
        }
      
        String urlSubString = url.substringBetween('/','/');
        if (accepted_urls__c.getInstance(urlSubString) == null) {
            PageReference errorPage = Page.mylogin;
            errorPage.setRedirect(true);
            return errorPage;
        }

        //start device redirect
        String [] Urlsplit = url.split('/');
        String Countrycode;
        String languagecode;
        String shorturl;
        
        Map<String, Help_Short_URLs__c> HelpShortUrlsMap = Help_Short_URLs__c.getall(); 
        Map<String, Help_Short_URLs__c> MapOfShortNLongURLs = new Map<String, Help_Short_URLs__c>();
        Set<String> setofShortUrls = new set<String>();

        for (Help_Short_URLs__c hs : HelpShortUrlsMap.values()) {
            setofShortUrls.add(hs.Short_URL_Name__c);
        }
        if (setofShortUrls != null && setofShortUrls.size() > 0 && Urlsplit != null && Urlsplit.size() == 2 && setofShortUrls.contains('/' + Urlsplit[1])) {
            PageReference pgr = Page.proxyredirect;
            pgr.getParameters().put('shortUrl', Urlsplit[1]);
            return pgr;
        }
        if (Urlsplit.size() == 3) {
            List<String> paramlists = Urlsplit[2].split('-');
            if (paramlists.size() == Integer.valueOf(System.label.HelpPageCountryParameters)) {
                Countrycode = Urlsplit[2].split('-')[0];
                languagecode = Urlsplit[2].split('-')[1]; 
            }
        }
        if (String.isNotBlank(Countrycode) && String.isNotBlank(languagecode)) {
            if ((HelpShortUrlsMap != null && HelpShortUrlsMap.size() > 0)) {
                for (Help_Short_URLs__c HelpShortUrl : HelpShortUrlsMap.values()) {
                    if (userFriendlyUrl.getUrl().startsWithIgnoreCase(HelpShortUrl.Short_URL_Name__c) && HelpShortUrl.Country_code__c.equals(Countrycode) && HelpShortUrl.Language_code__c.equals(languagecode)) {
                        if (HelpShortUrl.Short_URL_Name__c != null && HelpShortUrl.Long_URL__c != null) {
                            MapOfShortNLongURLs.put(HelpShortUrl.Short_URL_Name__c,HelpShortUrl);
                            shorturl = HelpShortUrl.Short_URL_Name__c;
                        }
                    }
                }
                if (MapOfShortNLongURLs != null && MapOfShortNLongURLs.size() > 0 && shorturl != null) {
                    url = MapOfShortNLongURLs.get(shorturl).Long_URL__c;
                }
            }
        }
        //end device redirect

        if(url.startsWithIgnoreCase('/testwillbedeleted/')){
        
            PageReference prHelp= Page.testwillbedeleted;
            string[] arrParam = url.split('/');            
            if(arrParam.size() == 3){
                // Start of PD-7850 & 7851                                         
                list<String> paramlist = arrParam[2].split('-');                    
                if(paramlist.size() == Integer.valueOf(System.label.HelpPageCountryParameters)){
                    prHelp.getParameters().put('Country',arrParam[2].split('-')[0]);
                    prHelp.getParameters().put('lang',arrParam[2].split('-')[1]);                    
                }
                else{                        
                    PageReference errorPage= Page.InternalServerError;
                    errorPage.setRedirect(true);
                    return errorPage;
                }//End of PD-7850 & 7851
            }            
            else if(arrParam.size()==4){  
                String arraypaaram1 = arrParam[2].substringBefore('-');
                String arraypaaram2 = arrParam[2].substringAfter('-');
                boolean boolCountry = false;
                boolean boolLanguage = false;
                Map<String,DAZN_Help_Redirect__c> HelpRedirectMap = DAZN_Help_Redirect__c.getall();  
                 if((arraypaaram1 !='' && arraypaaram2 !='') ){              
                    for(DAZN_Help_Redirect__c DAZNHelpRe : HelpRedirectMap.values()){                    
                        if((arraypaaram1==DAZNHelpRe.CountryISOCode__c)){                       
                            boolCountry = true;
                        }
                        if((arraypaaram2==DAZNHelpRe.Language__c)){
                            boolLanguage = true;
                        }    
                    }
                    
                    if(boolCountry==false || boolLanguage==false){
                        PageReference errorPage= Page.InternalServerError;
                        errorPage.setRedirect(true);
                        return errorPage;
                    }
                    else{
                        prHelp.getParameters().put('Country',arrParam[2].split('-')[0]);    
                        prHelp.getParameters().put('lang',arrParam[2].split('-')[1]);           
                        prHelp.getParameters().put('title',arrParam[3]);  
                    }       
                 
                 } 
                else {

                    if(arraypaaram1 =='' || arraypaaram2 ==''){
                        PageReference errorPage= Page.InternalServerError;
                        errorPage.setRedirect(true);
                        return errorPage;
                    }
                     else{
                        prHelp.getParameters().put('Country',arrParam[2].split('-')[0]);    
                        prHelp.getParameters().put('lang',arrParam[2].split('-')[1]);           
                        prHelp.getParameters().put('title',arrParam[3]);  
                    }               
                      
                }   
               
             }  
            else if(arrParam.size()==5){               
                prHelp.getParameters().put('Country',arrParam[2].split('-')[0]);
                prHelp.getParameters().put('lang',arrParam[2].split('-')[1]);
                prHelp.getParameters().put('searchText',arrParam[4]);
            }
            if(!string.isBlank(sTrakingParam))
                prHelp.getParameters().put('TrakingParams',sTrakingParam);
                prHelp.setRedirect(true);
                return prHelp;
        }
       
        //if (url.startsWithIgnoreCase('/help/')) {
        //    PageReference prHelp= Page.Help;
        //    String[] arrParam = url.split('/');
        //    if (arrParam.size() >= 3) {
        //        prHelp.getParameters().put('title', arrParam[2]);
        //    }
        //    if (arrParam.size() >= 4) {
        //        prHelp.getParameters().put('searchText', arrParam[3]);
        //    }
        //    if (String.isNotBlank(sTrakingParam)) {
        //        prHelp.getParameters().put('TrakingParams', sTrakingParam);
        //    }
        //    prHelp.setRedirect(true);
        //    return prHelp;
        //}
        if(url.startsWithIgnoreCase('/help/')){
        
            PageReference prHelp= Page.Help;
            string[] arrParam = url.split('/');            
            if(arrParam.size() == 3){
                // Start of PD-7850 & 7851                                         
                list<String> paramlist = arrParam[2].split('-');                    
                if(paramlist.size() == Integer.valueOf(System.label.HelpPageCountryParameters)){
                    prHelp.getParameters().put('Country',arrParam[2].split('-')[0]);
                    prHelp.getParameters().put('lang',arrParam[2].split('-')[1]);                    
                }
                else{                        
                    PageReference errorPage= Page.InternalServerError;
                    errorPage.setRedirect(true);
                    return errorPage;
                }//End of PD-7850 & 7851
            }            
            else if(arrParam.size()==4){  
                String arraypaaram1 = arrParam[2].substringBefore('-');
                String arraypaaram2 = arrParam[2].substringAfter('-');
                boolean boolCountry = false;
                boolean boolLanguage = false;
                Map<String,DAZN_Help_Redirect__c> HelpRedirectMap = DAZN_Help_Redirect__c.getall();  
                 if((arraypaaram1 !='' && arraypaaram2 !='') ){              
                    for(DAZN_Help_Redirect__c DAZNHelpRe : HelpRedirectMap.values()){                    
                        if((arraypaaram1==DAZNHelpRe.CountryISOCode__c)){                       
                            boolCountry = true;
                        }
                        if((arraypaaram2==DAZNHelpRe.Language__c)){
                            boolLanguage = true;
                        }    
                    }
                    
                    if(boolCountry==false || boolLanguage==false){
                        PageReference errorPage= Page.InternalServerError;
                        errorPage.setRedirect(true);
                        return errorPage;
                    }
                    else{
                        prHelp.getParameters().put('Country',arrParam[2].split('-')[0]);    
                        prHelp.getParameters().put('lang',arrParam[2].split('-')[1]);           
                        prHelp.getParameters().put('title',arrParam[3]);  
                    }       
                 
                 } 
                else {

                    if(arraypaaram1 =='' || arraypaaram2 ==''){
                        PageReference errorPage= Page.InternalServerError;
                        errorPage.setRedirect(true);
                        return errorPage;
                    }
                     else{
                        prHelp.getParameters().put('Country',arrParam[2].split('-')[0]);    
                        prHelp.getParameters().put('lang',arrParam[2].split('-')[1]);           
                        prHelp.getParameters().put('title',arrParam[3]);  
                    }               
                      
                }   
               
             }  
            else if(arrParam.size()==5){               
                prHelp.getParameters().put('Country',arrParam[2].split('-')[0]);
                prHelp.getParameters().put('lang',arrParam[2].split('-')[1]);
                prHelp.getParameters().put('searchText',arrParam[4]);
            }
            if(!string.isBlank(sTrakingParam))
                prHelp.getParameters().put('TrakingParams',sTrakingParam);
                prHelp.setRedirect(true);
                return prHelp;
        }
        else if (url.startsWithIgnoreCase('/ContactUs/')) {
            PageReference prContactUs= Page.ContactUs;
            String[] arrParam = url.split('/');

            if (arrParam.size() >= 3) {
                prContactUs.getParameters().put('type', arrParam[2]);
            }
            if (String.isNotBlank(sTrakingParam)) {
                prContactUs.getParameters().put('TrakingParams', sTrakingParam);
            }
            prContactUs.setRedirect(true);
            return prContactUs;
        } else if (url.startsWithIgnoreCase('/myLogin/')) {
            PageReference prMyLoginPage = Page.myLogin;
            string[] arrParam = url.split('/');
            if (arrParam.size() >= 3) {
                prMyLoginPage.getParameters().put('retUrl', arrParam[2]);
            }
            if (arrParam.size() >= 4) {
                prMyLoginPage.getParameters().put('flow', arrParam[3]);
            }
            prMyLoginPage.setRedirect(true);
            return prMyLoginPage;
        } else if (url.startsWithIgnoreCase('/signin/')) {
            PageReference prSignInPage = Page.signIn;
            string[] arrParam = url.split('/');
            if (arrParam.size() >= 3) {
                prSignInPage.getParameters().put('retUrl', arrParam[2]);
            }
            if (arrParam.size() >= 4) {
                prSignInPage.getParameters().put('flow', arrParam[3]);
            }
            prSignInPage.setRedirect(true);
            return prSignInPage;
        } else if (url.startsWithIgnoreCase('/EmailPreferences/')) {
            PageReference prEmailPreferencePage= Page.EmailPreferences;
            string[] arrParam = url.split('/');
            if (arrParam.size() >= 3) {
                prEmailPreferencePage.getParameters().put('UserId', arrParam[2]);
            }
            prEmailPreferencePage.setRedirect(true);
            return prEmailPreferencePage;
        } else if(url.startsWithIgnoreCase('/ChangePassword/')) {
            PageReference prChangePasswordPage= Page.ChangePassword;
            string[] arrParam = url.split('/');
            /*start PD-10979*/
            if (checkCountryAndLang(arrParam)) {
                PageReference errorPage= Page.InternalServerError;
                errorPage.setRedirect(true);
                return errorPage;
            }
            /*end PD-10979*/
            if(arrParam.size()==3){
                prChangePasswordPage.getParameters().put('Country',arrParam[2].split('-')[0]);
                prChangePasswordPage.getParameters().put('lang',arrParam[2].split('-')[1]);
            }
            prChangePasswordPage.setRedirect(true);
            return prChangePasswordPage;
        } else if (url.startsWithIgnoreCase('/pause-or-cancel')) {
            PageReference prPauseUpsell = Page.PauseUpsell;
            string[] arrParam = url.split('/');
            if (arrParam.size() >= 3) {
                prPauseUpsell.getParameters().put('pauseAction', arrParam[2]);
            }
            prPauseUpsell.setRedirect(true);
            return prPauseUpsell;
        } else if (url.startsWithIgnoreCase('/setpause/')) {
            PageReference prSetPause = Page.SetPause;
            string[] arrParam = url.split('/');
            if (arrParam.size() >= 3) {
                prSetPause.getParameters().put('pauseAction', arrParam[2]);
            }
            prSetPause.setRedirect(true);
            return prSetPause;
        } else if (url.startsWithIgnoreCase('/paymenthistory/')) {
            PageReference prPaymentHistory = Page.PaymentHistory;
            string[] arrParam = url.split('/');
            if (arrParam.size() >= 3) {
                prPaymentHistory.getParameters().put('dowloaderror', arrParam[2]);
            }
            prPaymentHistory.setRedirect(true);
            return prPaymentHistory;
        } else if (url.startsWithIgnoreCase('/keepintouch/')) {
            PageReference prKeepInTouch = Page.KeepInTouch;
            string[] arrParam = url.split('/');
            if (arrParam.size() >= 3) {
                prKeepInTouch.getParameters().put('pauseAction', arrParam[2]);
            }
            prKeepInTouch.setRedirect(true);
            return prKeepInTouch;
        }

        if (userFriendlyUrl.getUrl().contains('/?')) {
            userFriendlyUrl= new PageReference(userFriendlyUrl.getUrl().replace('/?','?')); 
        }
        return userFriendlyUrl;
    }

   
    global pageReference[] generateUrlFor(pageReference[] userFriendlyUrls) {
        return null;
    }

    /*start PD-10979*/
    public Boolean checkCountryAndLang(String[] arrayParams) {
        Boolean result = false;
        String arraypaaram1 = arrayParams[2].substringBefore('-');
        String arraypaaram2 = arrayParams[2].substringAfter('-');
        if (arraypaaram1 == '' || arraypaaram2 == '') {
            PageReference errorPage = Page.InternalServerError;
            errorPage.setRedirect(true);
            result = true;
        }
        return result;
    }
    /*end PD-10979*/
}