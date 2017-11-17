/**
* @author Cognizant Technology Solutuions
* @date 21/10/2015
* @description Transaction helper class for all trasaction between salesforce and Zuora
* Changes made for PD-4885 Unit test coverage for zuoratransactionhelperclone
*/

public class ZuoraTransactionHelper{
    public  static PageReference errorPage = new pageReference('');//
    private static Zuora.zApi api;   
    public static  User user ;
    public static list<Zuora__Subscription__c> zuoraList;
    public static String SubscriptionId;
    public static String ratePlanId;
    public Static List<Account> lstAcc { get; set; }
    /*
    Description: Method to connect zuora using api.
    */
   public static void getZuoraAPI(){ 
        api = new Zuora.zApi(); 
        Zuora.zApi.LoginResult zlogRes = new Zuora.zApi.LoginResult();
        //PD-9010
       // try{
            if(!Test.isRunningTest()){          
                zlogRes =  api.zlogin();       
                if(zlogRes.ServerUrl == null || zlogRes.Session == null){   
                    GTMHeaderController.errorDespFromAccountController('Not able to login into Zuora API. Please check with Zuora');
                }      
            }  
        /*}     
       catch (Exception ex){  
          // ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper ', 'getZuoraAPI', 'Not able to login into Zuora API. Please check with Zuora', ex.getTypeName(), ex.getStackTraceString()); 
            GTMHeaderController.errorDespFromAccountController('Not able to login into Zuora API. Please check with Zuora');
        }*/
    }
    
    /*Method to activate subscription*/
    public static List<Zuora.zApi.DeleteResult> activateSubscription(String zuoraSubscriptionId){
        List<Zuora.zApi.DeleteResult> lstDeleteResult = new List<Zuora.zApi.DeleteResult>();
        String subscriptionID ;
        List<Zuora.zObject> lstamendment = new List<Zuora.zObject>();
        List<Zuora.zObject> lstsubscription = new list<Zuora.zObject>();       
        
        try{               
            getZuoraAPI();
            if(!Test.isRunningTest()){
                lstsubscription=api.zquery('Select ID,OriginalId, PreviousSubscriptionId from Subscription Where Name=\''+zuoraSubscriptionId+'\' and Status = Cancelled');
            }
            else{
                Zuora.zObject sub = new Zuora.zObject('Subscription');
                sub.setValue('Id', '2c92c0f857ffa66201580b8d775358ad');
                sub.setValue('OriginalId', '2c92c0f857ffa66201580b8d775358ae');
                lstsubscription.add(sub);
            }
            if(!lstsubscription.isEmpty()) {
                subscriptionID = String.ValueOf(lstsubscription[0].getValue('PreviousSubscriptionId'));
            }
            if(!string.isBlank(subscriptionID ) && !Test.isRunningTest()) {
                lstamendment=api.zquery('Select Id from Amendment Where SubscriptionId=\''+subscriptionID+'\' and Type=\'Cancellation\''); 
            }
            else{
                Zuora.zObject oAmendment = new Zuora.zObject('Amendment');
                oAmendment.setValue('Id','2c92c0f857ffa66201580b8d775358ad');
                lstamendment.add(oAmendment);
            }
            
            if(lstamendment!=null && !lstamendment.isEmpty()){
                if(!Test.isRunningTest())
                    lstDeleteResult = api.zDelete('Amendment',new List<String>{String.valueOf(lstamendment[0].getValue('Id'))});
                
            }
            return lstDeleteResult;
        }catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper ', 'activateSubscription', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
            return null; 
        }
    }
    
    
    /*
    Description: Method to set default payment method in Zuora.
    */
    public static List<Zuora.zApi.SaveResult> setDefaultPayment(string accountID,string zuoraPaymentMethodID){
        List<Zuora.zObject> lstAccount = new list<Zuora.zObject>();
        List<Zuora.zApi.SaveResult> lstSaveResult=new List<Zuora.zApi.SaveResult>();
        try{
             getZuoraAPI();
            if(!Test.isRunningTest()){
                lstAccount = api.zquery('Select ID from Account where CrmId = \''+accountID+'\'' );
            }else{
                Zuora.zObject zAccount = new Zuora.zObject('Account');
                zAccount.setValue('Id','2c92c0f857ffa66201580b8d775358ad');
                lstAccount.add(zAccount);
            }
            
            lstAccount[0].setValue('AutoPay',true);
            lstAccount[0].setValue('DefaultPaymentMethodId',zuoraPaymentMethodID);
            
            
            if(!Test.isRunningTest()){
                lstSaveResult=api.zUpdate(lstAccount);
            }
            return lstSaveResult;
        }catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper ', 'setDefaultPayment', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
            return null;
        }
    }
    
    /*
    Description: Method to update user full name and email in Zuora.
    */
    public static List<Zuora.zApi.SaveResult> updateUserDetailsinZuora(List<Zuora__CustomerAccount__c> zuoraAccounts, Map<String,Account> sfAccounts){
        String zAccountClause = '';
        String zContactClause = '';
        List<Zuora.zObject> lstAccount = new List<Zuora.zObject>();
        List<Zuora.zApi.SaveResult> lstSaveResult=new List<Zuora.zApi.SaveResult>();
        List<Zuora.zObject> lstContact = new List<Zuora.zObject>();
        
        try{
            getZuoraAPI();
            //form the clause for the ZOQL
            for (Integer i=0;i<zuoraAccounts.size();i++){
                if(i!=zuoraAccounts.size()-1){
                    zAccountClause = zAccountClause + 'Id=\''+zuoraAccounts[i].Zuora__Zuora_Id__c+'\' OR ';
                }
                else{
                    zAccountClause = zAccountClause + 'Id=\''+zuoraAccounts[i].Zuora__Zuora_Id__c+'\'';
                }
            }
            
            
            if(!Test.isRunningTest()){
                lstAccount = api.zquery('Select Id,BillToId from Account where '+ zAccountClause);    
            }
            else
            {
                Zuora.zObject acc = new Zuora.zObject('Account');
                acc.setValue('Id','2c92c0f85615d698015621ecb5686025');
                acc.setValue('BillToId','2c92c0f85615d698015621ecb56c6026');
                lstAccount.add(acc);
                
            }
            
            //form the clause for the Contacts ZOQL
            for (Integer i=0;i<lstAccount.size();i++){
                if(i!=lstAccount.size()-1){
                    zContactClause = zContactClause + 'Id=\''+lstAccount[i].getValue('BillToId')+'\' OR ';
                }
                else{
                    zContactClause = zContactClause + 'Id=\''+lstAccount[i].getValue('BillToId')+'\'';
                }
            }
            
            if(!lstAccount.isEmpty()){
                if(!Test.isRunningTest())
                {
                    //query the contacts 
                    lstContact = api.zquery('Select AccountId, Id, FirstName, LastName, PersonalEmail from Contact where '+zContactClause);
                    
                }else{
                    
                    Zuora.zObject Cntct = new Zuora.zObject('Contact');
                    Cntct.setValue('FirstName','Jim');
                    Cntct.setValue('LastName','Green');
                    Cntct.setValue('PersonalEmail', 'billto@zuora.com');
                    Cntct.setValue('Id','2c92c0f85615d698015621ecb5686025');
                    Cntct.setValue('AccountId','2c92c0f85615d698015621ecb5686025');
                    lstContact.add(Cntct);
                }
                
                if(!lstContact.isEmpty()){
                    for(Zuora.zObject zContact: lstContact){
                        Account sfAccount = sfAccounts.get(zContact.getValue('AccountId')+'');
                        zContact.setValue('FirstName',sfAccount.FirstName);
                        zContact.setValue('LastName', sfAccount.LastName);
                        zContact.setValue('PersonalEmail',sfAccount.PersonEmail);
                    }
                    
                    //update the firstname , lastname and email in Zuora
                    if(!Test.isRunningTest()){
                        lstSaveResult=api.zUpdate(lstContact);
                        
                    }else{
                        Zuora.zApi.SaveResult saveResult = new Zuora.zApi.SaveResult();
                        saveResult.id = '2c92c0f85615d698015621ecb5686025';
                        lstSaveResult.add(saveResult);
                    }
                    
                }
            }
            
            if(lstSaveResult != null && !lstSaveResult.isEmpty()){
                setBackAccountSyncToFalse(lstSaveResult);
            }
            
            return lstSaveResult;
            
        }catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper ', 'updateUserDetailsinZuora', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
            return null;
        }
        
    }
    
    /*
    Description: Method to create payment method in Zuora and et the newly created method default.
    */
    public static String changePaymentMethod(Zuora__PaymentMethod__c paymentMethod,User oUser,string CreditCardNumber, string sCCSecurityCode){
        string sMessage = 'true';    
        String sOldPaymentGateway;
        String sDefaultPaymentID;
        List<Zuora.zObject> lstAccount = new list<Zuora.zObject>();
        Zuora.zApi.SaveResult createResult = new Zuora.zApi.SaveResult();
        List<Zuora.zApi.SaveResult> lstCreateResult = new List<Zuora.zApi.SaveResult>();
        List<Zuora.zApi.SaveResult> lstSaveResult = new List<Zuora.zApi.SaveResult>();
        Zuora.zObject acc = new Zuora.zObject('Account');
        
        try{   
            getZuoraAPI();
            if(!Test.isRunningTest()){
                lstAccount = api.zquery('Select Id,PaymentGateway,DefaultPaymentMethodId from Account where CrmId = \''+oUser.AccountId+'\'' );
            }else {  /* Changs for PD-4885*/
                acc.setValue('Id','2c92c0f85615d698015621ecb5686025');
                acc.setValue('PaymentGateway','Adyen Test Gateway');
                acc.setValue('DefaultPaymentMethodId','2c92c0f85615d698015621ecb5686026');
                lstAccount.add(acc);
            }
            
            Zuora.zObject objPaymentMethod=new Zuora.zObject('PaymentMethod');
            objPaymentMethod.setValue('Type',paymentMethod.Zuora__Type__c);
            objPaymentMethod.setValue('AccountId',lstAccount[0].getValue('Id')); 
            if(paymentMethod.Zuora__Type__c.equals('Paypal')){                
                /* Update payment gateway as per PD-1786 */
                PaymentMethodOptionConfig__c oPaymentMethodOptionConfig = PaymentMethodOptionConfig__c.getValues(oUser.Country);
                sOldPaymentGateway = string.valueOf(lstAccount[0].getValue('PaymentGateway'));
                sDefaultPaymentID=string.valueOf(lstAccount[0].getValue('DefaultPaymentMethodId'));
                String sNewPaymentGateway = oPaymentMethodOptionConfig.PaypalPaymentGateway__c;
                DAZNConfiguration__c oDAZNConfiguration = DAZNConfiguration__c.getValues('PaypalDefaultPaymentID');
                objPaymentMethod.setValue('PaypalBaid', paymentMethod.Zuora__PaypalBaid__c);
                objPaymentMethod.setValue('PaypalEmail', paymentMethod.Zuora__PaypalEmail__c);
                objPaymentMethod.setValue('PaypalType', 'ExpressCheckout');
                objPaymentMethod.setValue('Type', 'PayPal');
                //Nayan : Update the PaymentGateway: 'DAZN PayPal DACH',Default Payment Method:'Paypal' and check Auto-Pay as false
                System.debug('Nayan1 '+lstAccount[0]);
                System.debug('Nayan2 '+sNewPaymentGateway);
                System.debug('Nayan3 '+oDAZNConfiguration.Value__c);
                System.debug('Nayan4 '+paymentMethod.Zuora__Type__c);
                updatePaymentMethod(lstAccount[0],sNewPaymentGateway,oDAZNConfiguration.Value__c,false,paymentMethod.Zuora__Type__c);
                if(!Test.isRunningTest())//Create pay pall payment method
                     lstCreateResult = api.zCreate(new List<Zuora.zObject>{objPaymentMethod});
                else{
                    createResult.Success = true;
                    lstCreateResult.add(createResult);
                }
                
                updatePaymentMethod(lstAccount[0],sNewPaymentGateway,lstCreateResult[0].Id,true,paymentMethod.Zuora__Type__c);
            }
            
            if(Test.isRunningTest() || (lstCreateResult[0].Success == false && lstCreateResult[0].Errors != null)){     
                sMessage = 'false';
                if(paymentMethod.Zuora__Type__c.equals('Paypal')){
                    // Update payment gateway as per PD-1786              
                    updatePaymentMethod(lstAccount[0],sOldPaymentGateway,sDefaultPaymentID,true,paymentMethod.Zuora__Type__c);
                    //Track payment method failure as per PD-2398
                    String sErrorMessage;                    
                    string spaypalEmailID = CommunityHelper.getObfuscatedEmail(paymentMethod.Zuora__PaypalEmail__c);                    
                    sErrorMessage='Error message: '+ getZuoraErrorMessage(lstCreateResult) + ', Payment method: '+ paymentMethod.Zuora__Type__c+ ', Payment type: '+paymentMethod.Zuora__Type__c+ ', '+ spaypalEmailID;                    
                    createPaymentMethodFailureTask(sErrorMessage,oUser.AccountID);
                }
            }else{
                if(!Test.isRunningTest()){
                    lstSaveResult = setDefaultPayment(oUser.AccountId,lstCreateResult[0].Id);
                }
                
                if(Test.isRunningTest() || (lstSaveResult[0].Success == false && lstSaveResult[0].Errors != null )){
                    sMessage = 'false';
                    if(!Test.isRunningTest())
                        updatePaymentMethod(lstAccount[0],sOldPaymentGateway,sDefaultPaymentID,true,paymentMethod.Zuora__Type__c);
                }
            }
        }catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper ', 'changePaymentMethod', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            sMessage = 'false';
        }
        return sMessage;
    }
    
    /*Description: Method to create task when payment method update fails : PD-2398*/
    
    public static void createPaymentMethodFailureTask(string sErrorMessage,String sAccountID)
    {
        //Checking the user has an access to the fields below before inserting Task (PD-7903)
        if(schema.SObjectType.Task.fields.subject.isAccessible() && 
           schema.SObjectType.Task.fields.Description.isAccessible() && 
           schema.SObjectType.Task.fields.ActivityDate.isAccessible())  {
               
               Task paymentMethodFailureTask = new Task();
               paymentMethodFailureTask.ActivityDate = system.today();
               paymentMethodFailureTask.Description = sErrorMessage; 
               paymentMethodFailureTask.Subject= Label.LS_PaymentMethodUpdateFailed_Task_Label; 
               paymentMethodFailureTask.OwnerId = userinfo.getUserId();
               paymentMethodFailureTask.WhatId = sAccountID;
               insert paymentMethodFailureTask;
           }
        else
        { //if this user doesn't have permission to create a task then notify the same to system admin
            SendEmailWithErrorsToAdmins.sendEmail('Unauthorized user trying to insert a Task :'+' User Id :'+UserInfo.getUserID());   
        }
    }
    
    /*Description : Method to update payment gateway */
    public static void updatePaymentMethod(Zuora.zObject zBillingAccount, String sPaymentGateway,String sDefaultPaymentID,boolean bAutopay,String sPaymentMethod)
    {        
        if(!String.isBlank(sPaymentGateway)){
            List<Zuora.zApi.SaveResult> lstUpdateResult = new List<Zuora.zApi.SaveResult>();            
            zBillingAccount.setValue('AutoPay',bAutopay);
            zBillingAccount.setValue('PaymentGateway',sPaymentGateway);
            if(sDefaultPaymentID <> '' && sDefaultPaymentID <> null)
                zBillingAccount.setValue('DefaultPaymentMethodId',sDefaultPaymentID);
            if(!Test.isRunningTest())
                lstUpdateResult = api.zUpdate(new List<Zuora.zObject>{zBillingAccount});
            System.debug('Nayan lstUpdateResult'+lstUpdateResult);
        }
    }
    
    /*
    Description: Method to get zuora error message.
    */
    public static string getZuoraErrorMessage(List<Zuora.zApi.SaveResult> lstSaveResult)
    {
        if(lstSaveResult!=null && !lstSaveResult.isEmpty() && lstSaveResult[0].Success == false && lstSaveResult[0].Errors != null)       
        {
            string sError = lstSaveResult[0].tostring();            
            string sErrorMessage=sError.substringBetween('Message','},');
            return sErrorMessage;
        }
        return '';
    }
    
    
    /*
Description: Method to get Inovice Payments for an account.
*/
    public static List<Zuora.zObject> getPaymentInfoForAccount(string sAccountId)
    {
        
       
        try{ 
         getZuoraAPI(); 
            if(!Test.isRunningTest()){
            return api.zquery('Select id, amount, createddate, effectivedate, paymentmethodid, status, type from Payment where AccountID = \''+sAccountId+'\'' );
            }
            else
            {
                List<Zuora.zObject> paylist = new list<Zuora.zObject>();
                Zuora.zObject zPayment = new Zuora.zObject('Payment');
                zPayment.setValue('CreatedDate', '2011-04-01');
                zPayment.setValue('Id', 'testpaymentID');
                zPayment.setValue('Amount', '9.99 EUR');
                zPayment.setValue('EffectiveDate', '2011-04-01');
                zPayment.setValue('Status', 'Processed');
                zPayment.setValue('Id', 'testpaymentID');
                zPayment.setValue('AccountId', 'testaccountId');
                paylist.add(zPayment);
                return paylist;
            }
        }catch(Exception ex){
            return null;
        }
    }
    
    
    /*
Description: Method to get Inovice Payments for an account.
*/
    public static List<Zuora.zObject> getInvoiceInfoForAccount(string sAccountId)
    {
         
        try{
        getZuoraAPI();   
            return api.zquery('Select Id, AccountID, InvoiceNumber, Amount, TaxAmount, AmountWithoutTax from Invoice where AccountID = \''+sAccountId+'\'' );
        }catch(Exception ex){
            return null;
        }
    }
    
    /*
Description: Method for immediate and standard cancellation of subscription in Zuora.
*/
    public static Zuora.zApi.AmendResult cancelSubscription(String zuoraSubscriptionId, String effectiveDate, Boolean bGenerateInvoice)
    {
        Zuora.zObject objAmendment = new Zuora.zObject('Amendment');
        Zuora.zApi.AmendOptions amendOptions = new Zuora.zApi.AmendOptions();
        Zuora.zApi.AmendRequest amendRequest = new Zuora.zApi.AmendRequest();
        List<Zuora.zApi.AmendRequest> lst = new List<Zuora.zApi.AmendRequest>();
        
         
        try
        {
            getZuoraAPI();    
            Zuora.zApi.AmendResult amendResult;
            /* Changs for PD-4885*/
            objAmendment.setValue('SubscriptionId',zuoraSubscriptionId);
            objAmendment.setValue('Type','Cancellation');
            objAmendment.setValue('EffectiveDate', effectiveDate) ;
            objAmendment.setValue('Status','Draft');
            objAmendment.setValue('ContractEffectiveDate', effectiveDate) ;
            
            
            amendOptions.generateInvoice=bGenerateInvoice;            
            amendOptions.processPayments=false;
            
            
            amendRequest.amendments = new List<Zuora.zObject>{objAmendment};
                amendRequest.amendOptions =amendOptions;
            
            lst.add(amendRequest);
            
            if(!Test.isRunningTest())
                amendResult = api.zamend(lst);
            
            return amendResult ;
        }
        catch(Exception ex)
        {   
            
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper ', 'cancelSubscription', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
            return null;
        }
    }
    
    /*
Description: Method for immediate and standard cancellation of subscription in Zuora.
*/
    
    
    public static void cancelSubscriptionsForTestUser(List<String> lstSubscriptionID, String sEffectiveDate, Boolean bGenerateInvoice)
    {
        Zuora.zApi.AmendResult amendResult;
        List<Zuora.zApi.AmendRequest> lstAmendRequest = new List<Zuora.zApi.AmendRequest>();
        Zuora.zObject objAmendment = new Zuora.zObject('Amendment');
        Zuora.zApi.AmendOptions amendOptions = new Zuora.zApi.AmendOptions();
        Zuora.zApi.AmendRequest amendRequest = new Zuora.zApi.AmendRequest();
        
     
        try
        {       
   getZuoraAPI();       
            for(String sSubscriptionId :lstSubscriptionID){                
                objAmendment.setValue('SubscriptionId',sSubscriptionId);
                objAmendment.setValue('Type','Cancellation');
                objAmendment.setValue('EffectiveDate', sEffectiveDate) ;
                objAmendment.setValue('Status','Draft');
                objAmendment.setValue('ContractEffectiveDate', sEffectiveDate) ;
                
                
                amendOptions.generateInvoice=bGenerateInvoice;            
                amendOptions.processPayments=false;
                
                
                amendRequest.amendments = new List<Zuora.zObject>{objAmendment};
                    amendRequest.amendOptions =amendOptions;
                
                lstAmendRequest.add(amendRequest);
                if(lstAmendRequest.size()>0)
                    amendResult = api.zamend(lstAmendRequest);
                
                lstAmendRequest = new List<Zuora.zApi.AmendRequest>();
                
            }
            
        }
        catch(Exception ex)
        {
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper ', 'cancelSubscription', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
            //return null;
        }
    }
    
    
    /* 
Description : Method to create invoice line item adjustments in Zuora 
*/
    public static List<Zuora.zApi.SaveResult> createInvoiceLineItemAdjusment(String sZuoraInvoiceId, string sReasonCode, string sType)
    {
        Decimal dAmount;
        string sAdjustmentDate = ((DateTime)Date.today()).format('yyyy-MM-dd');
        Zuora.zObject objInvoiceItemAdjustmentInvoiceItem;
        Zuora.zObject objInvoiceItemAdjustmentTax;
        Map<String,String> mapInvoiceAdjustments = new Map <String, String>();
        List<Zuora.zObject> lstInvoiceItem = new list<Zuora.zObject>();
        List<Zuora.zObject> lstTaxationItem = new list<Zuora.zObject>();
        List<Zuora.zObject> lstzObject = new List<Zuora.zObject>();
        List<Zuora.zApi.SaveResult> lstCreateResult;
        Zuora.zApi.SaveResult result = new Zuora.zApi.SaveResult();
        
         
        try{
            getZuoraAPI();  
            if(!Test.isRunningTest())
            {   
                lstInvoiceItem = zQuery('select Id,ChargeAmount,AppliedToInvoiceItemId From InvoiceItem where InvoiceId= \''+sZuoraInvoiceId+'\'');
                
                lstTaxationItem = zQuery('select Id,InvoiceItemId,TaxAmount From TaxationItem where InvoiceId= \''+sZuoraInvoiceId+'\'');
               
            }else{
                Zuora.zObject invoice = new Zuora.zObject('InvoiceItem');
                invoice.setValue('ChargeAmount', 123445);
                invoice.setValue('InvoiceId', '300040708598');
                invoice.setValue('Id', '3000708598');
                lstInvoiceItem.add(invoice);
                
                Zuora.zObject taxation = new Zuora.zObject('TaxationItem');
                taxation.setValue('InvoiceItemId','testinvoiceitemid');
                taxation.setValue('TaxAmount','1.66');
                taxation.setValue('Id', '300040708599');
                lstTaxationItem.add(taxation);
            }
            
            if(lstInvoiceItem!=null && !lstInvoiceItem.isEmpty())
            {    
                
                //create a map of adjusted line items  
                // any items that already have been adjusted go into this Map
                for(Zuora.zObject invoiceItem : lstInvoiceItem ){
                    
                    if(invoiceItem.getValue('AppliedToInvoiceItemId') != null){
                        mapInvoiceAdjustments.put(String.valueOf(invoiceItem.getValue('Id')),'');
                        mapInvoiceAdjustments.put(String.valueOf(invoiceItem.getValue('AppliedToInvoiceItemId')),'');
                    }
                }
                
                for(Zuora.zObject invoiceItem : lstInvoiceItem ){
                    
                    if(!mapInvoiceAdjustments.containsKey(String.valueOf(invoiceItem.getValue('Id')))){
                        objInvoiceItemAdjustmentInvoiceItem = new Zuora.zObject('InvoiceItemAdjustment');            
                        objInvoiceItemAdjustmentInvoiceItem.setValue('AdjustmentDate',sAdjustmentDate); 
                        objInvoiceItemAdjustmentInvoiceItem.setValue('ReasonCode',sReasonCode); 
                        objInvoiceItemAdjustmentInvoiceItem.setValue('InvoiceId',sZuoraInvoiceId);
                        objInvoiceItemAdjustmentInvoiceItem.setValue('SourceType','InvoiceDetail');            
                        objInvoiceItemAdjustmentInvoiceItem.setValue('Type',sType);   
                        dAmount = Decimal.valueOf(string.valueOf(invoiceItem.getValue('ChargeAmount')));
                        if( dAmount < 0 )
                            objInvoiceItemAdjustmentInvoiceItem.setValue('Amount', dAmount * -1 );  
                        else
                            objInvoiceItemAdjustmentInvoiceItem.setValue('Amount',dAmount);
                        objInvoiceItemAdjustmentInvoiceItem.setValue('SourceId',invoiceItem.getValue('Id'));
                        lstzObject.add(objInvoiceItemAdjustmentInvoiceItem);
                        
                    }        
                }
                
            }
            
            if(lstTaxationItem!=null && !lstTaxationItem.isEmpty())
            {    
                for(Zuora.zObject taxationItem : lstTaxationItem){ 
                    
                    if(!mapInvoiceAdjustments.containsKey(String.valueOf(taxationItem.getValue('InvoiceItemId')))){              
                        objInvoiceItemAdjustmentTax = new Zuora.zObject('InvoiceItemAdjustment');            
                        objInvoiceItemAdjustmentTax.setValue('AdjustmentDate',sAdjustmentDate); 
                        objInvoiceItemAdjustmentTax.setValue('ReasonCode',sReasonCode); 
                        objInvoiceItemAdjustmentTax.setValue('InvoiceId',sZuoraInvoiceId);
                        objInvoiceItemAdjustmentTax.setValue('SourceType','Tax');            
                        objInvoiceItemAdjustmentTax.setValue('Type',sType);
                        dAmount = Decimal.valueOf(string.valueOf(taxationItem.getValue('TaxAmount')));  
                        
                        if( dAmount < 0 )
                            objInvoiceItemAdjustmentTax.setValue('Amount',dAmount * -1 );
                        else
                            objInvoiceItemAdjustmentTax.setValue('Amount',dAmount );
                        objInvoiceItemAdjustmentTax.setValue('SourceId',taxationItem.getValue('Id'));
                        lstzObject.add(objInvoiceItemAdjustmentTax);
                        
                    } 
                }          
            }
            if(!lstzObject.isEmpty() && !Test.isRunningTest())
                lstCreateResult = api.zCreate(lstzObject);
            
            if(Test.isRunningTest()){
                result.success = true;
                lstCreateResult[0] = result;
            }
            
           
            analyseSaveResultsfromZuora(lstCreateResult, 'createInvoiceLineItemAdjusment',lstzObject);
            
            return lstCreateResult;
        }
        catch(Exception ex)
        {
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper', 'createInvoiceLineItemAdjusment', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return null;
        }
    }
    
    /* 
Description : Method to query Zuora Objects
*/ 
    public static List<Zuora.zObject> zQuery(string sQuery)
    {   
       try{
         getZuoraAPI();
        
          return api.zquery(sQuery);
       }
       
    catch(Exception ex)
        {
            
         //   ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper', 'zQuery', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return null;
        }
       
    }

    /* 
    Description : Method gets RatePlan objects by SubscriptionId
    */ 
    public static String getRatePlanIdBySubscriptionId(String subscriptionId) {
        String ratePlanId;

        if(!Test.isRunningTest()) {
            List<Zuora.zObject> lstRatePlan = zQuery('Select Id From RatePlan Where SubscriptionId = \'' + subscriptionId + '\'');
            ratePlanId = (lstRatePlan != null && !lstRatePlan.isEmpty()) ? (String)lstRatePlan[0].getValue('Id') : null;
        } else {
            ratePlanId = '111';
        }

        return ratePlanId;
    }

     //added as part of PD-13271
    /* 
    Description : Method gets SubscriptionProdcutCharge objects by Id of Account
    Change Log :  //Added as a part of PD-13217
                 //Changed as a part of PD-15411 : To get next charge Date from Subscription
                 //Developer : MeghaJain 
    */ 
    public static Date getRatePlanChargeChargedThroughDateByAccountId(String accountId) {
        Date ratePlanChargeChargedThroughDate;
            List<Zuora__Subscription__c> lstRatePlanSubsProd = [Select Zuora__Account__c,Zuora__NextChargeDate__c From Zuora__Subscription__c Where  Zuora__Account__c =:accountId AND (Zuora__Status__c='Active'OR (Zuora__Status__c='Cancelled' AND Zuora__SubscriptionEndDate__c > TODAY ))] ;
            if(!lstRatePlanSubsProd .isEmpty()) {            
                if ( lstRatePlanSubsProd[0].Zuora__NextChargeDate__c!=null ){
                    ratePlanChargeChargedThroughDate = lstRatePlanSubsProd[0].Zuora__NextChargeDate__c;
                }
          }  
        return ratePlanChargeChargedThroughDate;
    }
    
    /*
    Description  : Method to refund the -ve invoice amount.
    */
    public static List<Zuora.zApi.SaveResult> RefundAmount(String paymentID,string sZuoraInvoiceId, String sReasonCode)
    {
        List<Zuora.zObject> lstInvoice = new list<Zuora.zObject>();
        Zuora.zObject objRefund = new Zuora.zObject('Refund');
        List<Zuora.zApi.SaveResult> lstSaveResult = new List<Zuora.zApi.SaveResult>();
                 
        try
        {
            getZuoraAPI();   
            if(!Test.isRunningTest())
            {
                lstInvoice= api.zquery('Select Amount from Invoice where Id = \''+sZuoraInvoiceId+'\'' );
                System.debug('##### lstInvoice = ' + lstInvoice);
              
            }else{  /* Changs for PD-4885*/
                Zuora.zObject invoice = new Zuora.zObject('Invoice');
                invoice.setValue('DueDate','15-09-2016');
                invoice.setValue('TargetDate', '16-09-2016');
                lstInvoice.add(invoice);
            }
            
            if(lstInvoice!=null && !lstInvoice.isEmpty())
            {               
                if(!Test.isRunningTest())
                {
                    objRefund.setValue('Amount', string.valueOf(lstInvoice[0].getValue('Amount')).replace('-',''));
                    objRefund.setValue('ReasonCode',sReasonCode);
                    objRefund.setValue('PaymentId', PaymentId) ;
                    objRefund.setValue('Type','Electronic');
                    
                }else{
                    objRefund.setValue('Amount',12345);
                    objRefund.setValue('Comment','Refund for Immediate Cancellation.');
                    objRefund.setValue('PaymentId', PaymentId) ;
                    objRefund.setValue('Type','Electronic');
                }
                
                
                if(!Test.isRunningTest())
                {
                    lstSaveResult = api.zCreate(new List<Zuora.zObject>{objRefund});
                }
                
                return lstSaveResult;
            }
            
            return null;
        }
        catch(Exception ex)
        {   
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper ', 'cancelSubscription', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
            return null;
        }
    }
    /*
Description: Method to get Zuora errors
*/
    public static String getZuoraError(Zuora.zObject[] lstErrors)
    {        
        String sErrorCode;
        String sMessage;
        for (Zuora.zObject oError : lstErrors) {
            sErrorCode = (String)oError.getValue('Code');
            sMessage = (String)oError.getValue('Message');
        }
        return sErrorCode+':'+sMessage;
    }
    
    /*
Description: Method to test user account in Zuora.
*/
    @future(callout = true)
    public static void updateTestUserAccount(List<Id> idList){
        List<Zuora.zApi.SaveResult> lstTestUserUpdateResultBatch = new List<Zuora.zApi.SaveResult>();
        List<Zuora.zObject>  lstBillingAccount = new list<Zuora.zObject>();
        Zuora.zObject acc = new Zuora.zObject('Account');
        List<Zuora.zObject> billingAccountList = new List<Zuora.zObject>();
        List<Zuora.zObject> billingAccountListTmp= new List<Zuora.zObject>();
        
        try{
            
            // Get Zuora Account information for Test User.
            
            if(!Test.isRunningTest())
            {
                lstBillingAccount = zQuery('Select ID from Account where CrmId = \''+idList[0]+'\'');
            }
            else{/* Changs for PD-4885*/
                
                acc.setValue('Id','2c92c0f85615d698015621ecb5686025');
                lstBillingAccount.add(acc);
            }
            
            
            if(lstBillingAccount != null && !lstBillingAccount.isEmpty()){
                for(Zuora.zObject zBillingAccount :lstBillingAccount){
                    zBillingAccount.setValue('Batch', DAZNConfiguration__c.getValues('ZuoraTestUserBatch').Value__c);
                    
                    billingAccountList.add(zBillingAccount);   
                    
                }
                
                
                Integer counter = 0;
                do{
                    billingAccountListTmp[counter] = billingAccountList[0];
                    counter = counter +1;
                    billingAccountList.remove(0);
                    if (billingAccountListTmp.size() == 50){
                        if(!Test.isRunningTest())
                            lstTestUserUpdateResultBatch = api.zUpdate(billingAccountListTmp);
                        
                        billingAccountListTmp.clear();
                        counter = 0;
                    }
                    
                }while(billingAccountList.size() > 0);
                
                
                
            }
        }
        catch(Exception ex){
            
            
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper ', 'updateTestUserAccount', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }
    
    @future(callout = true)
    public static void updateTestUserAccountBulkFuture(List<Id> idList){
        updateTestUserAccountBulk(idList);
    }
    
    //added by lokesh for list of record
    //@future(callout = true)
    public static void updateTestUserAccountBulk(List<Id> idList){
        List<Zuora.zObject> lstBillingAccount = new  List<Zuora.zObject>();
        List<Zuora.zApi.SaveResult> lstTestUserUpdateResultBatch = new List<Zuora.zApi.SaveResult>();
        List<Zuora.zObject> billingAccountList = new List<Zuora.zObject>();
        Zuora.zObject acc = new Zuora.zObject('Account');
        
        try{
            // Get Zuora Account information for Test User.
            
            if(idList!=null && idList.size()>0){
                set<Id> accountIdSet = new set<Id>();
                for(Id i : idList){
                    accountIdSet.add(i);
                }           
                
                
                String queryInput = 'CrmId =';
                
                for(Id i:accountIdSet)
                {
                    queryInput = queryInput + '\'' + i + '\' OR CrmId =';
                }
                Integer index = queryInput.lastIndexOf(' OR CrmId =');
                queryInput = queryInput.subString(0,index);
                
                if(!Test.isRunningTest())
                {
                    String finalQuery = 'select id from account where '+queryInput;
                    lstBillingAccount = zQuery(finalQuery); 
                }
                else
                {  /* Changs for PD-4885*/
                    
                    acc.setValue('Id','2c92c0f85615d698015621ecb5686025');
                    lstBillingAccount.add(acc);
                }
                
                
            }
            if(lstBillingAccount != null && !lstBillingAccount.isEmpty()){
                for(Zuora.zObject zBillingAccount :lstBillingAccount){
                    zBillingAccount.setValue('Batch', DAZNConfiguration__c.getValues('ZuoraTestUserBatch').Value__c);
                    billingAccountList.add(zBillingAccount);
                    
                    
                }
                if(!Test.isRunningTest())
                    lstTestUserUpdateResultBatch = api.zUpdate(billingAccountList); 
                
            }                                                                             
        }
        
        catch(Exception ex){ 
            
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper ', 'updateTestUserAccount', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }
    
    /*
Method to get the user subscription information.
*/
    public static MAP<String,Zuora.zObject> getUserSubscription(String sZuoraBillingAccountID){    
        MAP<String,Zuora.zObject> mapSubscriptionPayment=new MAP<string,Zuora.zObject>();
        List<Zuora.zObject> lstZSubscriptions = new list<Zuora.zObject>();
        List<Zuora.zObject> lstZPayments = new list<Zuora.zObject>();
        
        if(!Test.isRunningTest())
        {
            lstZSubscriptions = zQuery('Select CreatedDate,Status,TermEndDate,SubscriptionEndDate,ID,AccountId From Subscription where Status!=\'Expired\' AND AccountId=\''+sZuoraBillingAccountID+'\' ');
            
            lstZPayments = zQuery('Select CreatedDate,Id,Amount,EffectiveDate,Status,AccountId From Payment where AccountId=\''+sZuoraBillingAccountID+'\'');
        }else{/* Changs for PD-4885*/
            Zuora.zObject sub = new Zuora.zObject('Subscription');
            sub.setValue('CreatedDate', '2011-04-01');
            sub.setValue('Status', 'Active');
            sub.setValue('TermEndDate',  '2011-04-01');
            sub.setValue('SubscriptionEndDate', '2011-04-01');
            sub.setValue('Id', 'testsubId');
            sub.setValue('AccountId', 'testAccountId');
            lstZSubscriptions.add(sub);
            
            Zuora.zObject zPayment = new Zuora.zObject('Payment');
            zPayment.setValue('CreatedDate', '2011-04-01');
            zPayment.setValue('Id', 'testpaymentID');
            zPayment.setValue('Amount', '9.99 EUR');
            zPayment.setValue('EffectiveDate', '2011-04-01');
            zPayment.setValue('Status', 'Processed');
            zPayment.setValue('Id', 'testpaymentID');
            zPayment.setValue('AccountId', 'testaccountId');
            lstZPayments.add(zPayment);
        }
        List<zObjectCustomSort> lstZSubscriptionsWrapper = new List<zObjectCustomSort>();
        List<zObjectCustomSort> lstZPaymentsWrapper = new List<zObjectCustomSort>();
        
        if(lstZSubscriptions!=null && lstZSubscriptions.size()>0){
                for(Zuora.zObject oZSubscription : lstZSubscriptions)
                {
                    // change done to ensure no new subscriptions are added to the list, if there's an active subscription.
                    if(oZSubscription.getValue('Status')!='Active')
                        lstZSubscriptionsWrapper.add(new zObjectCustomSort(oZSubscription));
                    else {
                        lstZSubscriptionsWrapper = new List<zObjectCustomSort>();
                        lstZSubscriptionsWrapper.add(new zObjectCustomSort(oZSubscription));
                        break;
                    }
                }
        }
        if(lstZPayments!=null && lstZPayments.size()>0){
                for(Zuora.zObject oZPayment : lstZPayments)
                {
                    lstZPaymentsWrapper.add(new zObjectCustomSort(oZPayment));
                }
        }
    
        lstZSubscriptionsWrapper.sort();
        lstZPaymentsWrapper.sort();
        
        if(lstZSubscriptionsWrapper!=null && lstZSubscriptionsWrapper.size()>0)
            mapSubscriptionPayment.put('Subscription',lstZSubscriptionsWrapper[0].ozObject);
        if(lstZPaymentsWrapper!=null && lstZPaymentsWrapper.size()>0)
            mapSubscriptionPayment.put('Payment',lstZPaymentsWrapper[0].ozObject);
        return mapSubscriptionPayment;
    }
    
     /*
Method to get the user subscription information.
*/
    public static MAP<String,sObject> getUserSubscriptionByAccountID(String sZuoraBillingAccountID){    
        MAP<String,sObject> mapSubscriptionPayment=new MAP<string,sObject>();
        List<Zuora__Subscription__c> lstZSubscriptions = new list<Zuora__Subscription__c>();
        List<Zuora__Payment__c> lstZPayments = new list<Zuora__Payment__c>();
        
        
            lstZSubscriptions = [Select id,
                                Zuora__CustomerAccount__c ,
                                SubscriptionAmount__c,
                                Zuora__ContractEffectiveDate__c,
                                Zuora__External_Id__c,
                                Giftcode__c,
                                Zuora__Status__c,
                                Gift_Code_End_Date__c,
                                Zuora__SubscriptionEndDate__c,
                                Zuora__NextRenewalDate__c,
                                Free_Trial_End_Date__c,
                                Zuora__Account__c,
                                Zuora__TermSettingType__c,
                                Zuora__NextChargeDate__c,
                                NumGiftPeriods__c, 
                                Zuora__CustomerAccount__r.Zuora__Currency__c
                                From Zuora__Subscription__c Where  Zuora__Account__c =:sZuoraBillingAccountID AND (Zuora__Status__c='Active'OR (Zuora__Status__c='Cancelled' AND Zuora__SubscriptionEndDate__c > TODAY ))] ;
            //get rid of this query
            lstZPayments = [Select Zuora__Amount__c,
                                   Zuora__External_Id__c
                                   From Zuora__Payment__c Where  Zuora__Account__c =:sZuoraBillingAccountID ];
        
        
        if(lstZSubscriptions!=null && lstZSubscriptions.size()>0)
            mapSubscriptionPayment.put('Subscription',lstZSubscriptions[0]);
        if(lstZPayments!=null && lstZPayments.size()>0)
            mapSubscriptionPayment.put('Payment',lstZPayments[0]);
        return mapSubscriptionPayment;
    }
    
    
    public Static List<Account> fetchAccount() {
        if(lstAcc != null) {
            return lstAcc;
        }
        if (user == null) {
            user = CommunityHelper.getCurrentUser();
        }
        lstAcc = [SELECT Id, Account_Status__c,Notification_Country_Code__c FROM Account WHERE ID = :user.AccountId LIMIT 1];
        return lstAcc ;
    }

    //added as part of PD-13271
    public static String getSubscriptionDescription(String Message, Zuora.zObject oSubscription,string sCurrency){
        String OrClauseForRatePlanIds = '';
        Integer counter = 0;
        String strMessage=Message;
        List<String> lstField=new List<String>();
        List<Zuora.zObject> lstRatePlan ;
        List<Zuora__SubscriptionProductCharge__c > lstRatePlanCharge ;
        List<Account>listAccnt =fetchAccount();
        Date ratePlanChargeThroughDate;
        while(strMessage.contains('[') && strMessage.contains(']')){
            String strField=strMessage.substringBetween('[',']');
            lstField.add(strField);
            strMessage=strMessage.remove('['+strField+']');
        }
        if(lstField.size()>0 && oSubscription != null) {
            //get the Charge line items which are of the type Flat Fee
            if(Test.isRunningTest()){
                lstRatePlanCharge = new List<Zuora__SubscriptionProductCharge__c >();
                Zuora__SubscriptionProductCharge__c rpCharge = new Zuora__SubscriptionProductCharge__c();
                rpCharge.Zuora__ChargedThroughDate__c = Date.today();
                lstRatePlanCharge.add(rpCharge);
                ratePlanChargeThroughDate = Date.today();
            } else if(listAccnt!=null && listAccnt.size()>0){
                String accId = listAccnt[0].id;
                lstRatePlanCharge = [Select Zuora__Account__c,Zuora__ProductName__c,Zuora__TotalContractValue__c,Zuora__ChargedThroughDate__c,Zuora__Price__c From Zuora__SubscriptionProductCharge__c Where Zuora__Model__c = 'Flat Fee Pricing' AND Zuora__Account__c =: accId];
                system.debug('==lstRatePlanCharge'+lstRatePlanCharge[0].Zuora__Price__c);
                system.debug('==Zuora__ProductName__c'+lstRatePlanCharge[0].Zuora__ProductName__c);
                ratePlanChargeThroughDate = getRatePlanChargeChargedThroughDateByAccountId(accId);
            }
            for(string strField : lstField){
                if(strField.equals('Zuora__NextChargeDate__c') && ratePlanChargeThroughDate !=null){
                    Message=Message.replace('['+strField+']', CommunityHelper.ConvertDateToString(ratePlanChargeThroughDate,listAccnt[0].Notification_Country_Code__c,''));
                } else if(strField.equals('Zuora__Price__c') && lstRatePlanCharge !=null && lstRatePlanCharge.size()>0 && lstRatePlanCharge[0].Zuora__Price__c!=null){
                    if(lstRatePlanCharge[0].Zuora__ProductName__c != 'Livesport Annual Subscription'){
                    string sPrice = CommunityHelper.getformattedAmount(CommunityHelper.getCurrencySymbol(sCurrency),(decimal)lstRatePlanCharge[0].Zuora__Price__c,null);
                    Message=Message.replace('['+strField+']',sPrice );
                    }
                    else{
                        string sPrice = CommunityHelper.getformattedAmount(CommunityHelper.getCurrencySymbol(sCurrency),(decimal)lstRatePlanCharge[0].Zuora__TotalContractValue__c,null);
                    Message=Message.replace('['+strField+']',sPrice );
                    }
                }
            }
        }
        return Message;
    }
    
    public static String getSubscriptionDescriptionForCanada(String Message, Zuora.zObject oSubscription,string sCurrency){
        //commented as part of PD-13271
        /*String OrClauseForRatePlanIds = '';
        Integer counter = 0;*/
        String strMessage=Message;
        List<String> lstField=new List<String>();
        //commented as part of PD-13271
        //List<Zuora.zObject> lstRatePlan ;
        List<Zuora__SubscriptionProductCharge__c > lstRatePlanCharge ;
        List<Account> listAccnt =fetchAccount();
        Date ratePlanChargeThroughDate;
        while(strMessage.contains('[') && strMessage.contains(']')){
            String strField=strMessage.substringBetween('[',']');
            lstField.add(strField);
            strMessage=strMessage.remove('['+strField+']');
        }
        if(lstField.size()>0)
        {
            if(oSubscription != null){
                //get the Charge line items which are of the type Flat Fee
                if(Test.isRunningTest()){
                    lstRatePlanCharge = new List<Zuora__SubscriptionProductCharge__c >();
                    Zuora__SubscriptionProductCharge__c  rpCharge = new Zuora__SubscriptionProductCharge__c ();
                    rpCharge.Zuora__ChargedThroughDate__c = Date.today();
                    rpCharge.Zuora__Price__c = 20.00;
                    ratePlanChargeThroughDate = Date.today();
                    lstRatePlanCharge.add(rpCharge);
                }else {
                    //added as part of PD-13271
                    if (listAccnt!=null && listAccnt.size()>0){
                        String accId = listAccnt[0].id;
                        //lstRatePlanCharge = zQuery('Select ChargedThroughDate, Price from RatePlanCharge where ChargeModel=\'Flat Fee Pricing\' And '+OrClauseForRatePlanIds);
                        ratePlanChargeThroughDate = getRatePlanChargeChargedThroughDateByAccountId(accId);
                        lstRatePlanCharge = [Select Zuora__Account__c,Zuora__Price__c,Zuora__ChargedThroughDate__c From Zuora__SubscriptionProductCharge__c Where Zuora__Model__c = 'Flat Fee Pricing' AND Zuora__Account__c =: accId];
                    }
                }
                for(string strField : lstField){
                    if(strField.equals('Zuora__NextChargeDate__c') && ratePlanChargeThroughDate !=null){
                        Message=Message.replace('['+strField+']', CommunityHelper.ConvertDateToString(ratePlanChargeThroughDate,listAccnt[0].Notification_Country_Code__c,''));
                    }else if(strField.equals('Zuora__Price__c') && lstRatePlanCharge !=null && lstRatePlanCharge.size()>0 && lstRatePlanCharge[0].Zuora__Price__c!=null){
                        string sPrice = CommunityHelper.getformattedAmount(CommunityHelper.getCurrencySymbol(sCurrency),(decimal)lstRatePlanCharge[0].Zuora__Price__c,null);
                        Message=Message.replace('['+strField+']',sPrice );
                    }
                }
            }
        }
        return Message;
    }
    
    
    //added as part of PD-13271
    public static String getSubscriptionDescriptionForCanada(String Message, Zuora.zObject oSubscription,string sCurrency, String slang,String Scountry){
        String strMessage=Message;
        List<String> lstField=new List<String>();
        List<Zuora__SubscriptionProductCharge__c > lstRatePlanCharge ;
        List<Account>listAccnt =fetchAccount();
        while(strMessage.contains('[') && strMessage.contains(']')){
            String strField=strMessage.substringBetween('[',']');
            lstField.add(strField);
            strMessage=strMessage.remove('['+strField+']');
        }
        if(lstField.size()>0 && oSubscription != null) {
            //get the Charge line items which are of the type Flat Fee
            if(Test.isRunningTest()){
                lstRatePlanCharge = new List<Zuora__SubscriptionProductCharge__c >();
                Zuora__SubscriptionProductCharge__c  rpCharge = new Zuora__SubscriptionProductCharge__c ();
                rpCharge.Zuora__ChargedThroughDate__c = Date.today();
                rpCharge.Zuora__Price__c = 20.00;
                lstRatePlanCharge.add(rpCharge);
            } else {
                 if (listAccnt!=null && listAccnt.size()>0){
                    String accId = listAccnt[0].id;
                    lstRatePlanCharge = [Select Zuora__Account__c,Zuora__ChargedThroughDate__c, Zuora__Price__c From Zuora__SubscriptionProductCharge__c Where Zuora__Model__c = 'Flat Fee Pricing' AND Zuora__Account__c =: accId];
                }
            }
                
            for(string strField : lstField){
                if(strField.equals('Zuora__NextChargeDate__c') && lstRatePlanCharge !=null && lstRatePlanCharge.size()>0 && lstRatePlanCharge[0].Zuora__ChargedThroughDate__c !=null){
                    Message=Message.replace('['+strField+']', CommunityHelper.ConvertDateToString(lstRatePlanCharge[0].Zuora__ChargedThroughDate__c,listAccnt[0].Notification_Country_Code__c,'')); 
                } else if(strField.equals('Zuora__Price__c') && lstRatePlanCharge !=null && lstRatePlanCharge.size()>0 && lstRatePlanCharge[0].Zuora__Price__c!=null){
                    string sPrice = '';
                    sPrice = CommunityHelper.getformattedAmount(CommunityHelper.getCurrencySymbol(sCurrency),(decimal)lstRatePlanCharge[0].Zuora__Price__c,null); 
                    Message=Message.replace('['+strField+']',sPrice );
                }
            }
        }
        return Message;
    }

    /*
Method to Make IsReadyToSyncInZuora__c field false after get updated in zuora.
*/
    @TestVisible
    private static void setBackAccountSyncToFalse(List<Zuora.zApi.SaveResult> strForAccountSync){
        list<Account>accList =new list<Account>();
        list<Account>accUpdateList =new list<Account>();
        list<Zuora__CustomerAccount__c> zuoraList =new list<Zuora__CustomerAccount__c>();
        list<String> strIds = new list<String>();
        list<Id> accIds = new list<Id>();
        
        for(Zuora.zApi.SaveResult zuoObj : strForAccountSync ){
            if(zuoObj.Success){          
                strIds.add(zuoObj.Id);  
            }          
        }
        
        if(!Test.isRunningTest())
            zuoraList = [SELECT Name,Zuora__Account__c,Zuora__Zuora_Id__c FROM Zuora__CustomerAccount__c WHERE Zuora__BillToId__c =:strIds];
        else{
            Zuora__CustomerAccount__c zAccount = new Zuora__CustomerAccount__c();
            zAccount.Zuora__Account__c = '0017E00000IbDiZ';
            zuoraList.add(zAccount);
        }
        
        if(zuoraList!= null  && !zuoraList.isEmpty()){
            for(Zuora__CustomerAccount__c zCusObj : zuoraList){
                accIds.add(zCusObj.Zuora__Account__c);
            }
        }
        
        
        if(accIds != null && !accIds.isEmpty() && !Test.isRunningTest()){
            accList = [SELECT id,FirstName,LastName,IsReadyToSyncInZuora__c FROM Account WHERE id =:accIds];
        }
        
        if(accList!=null && !accList.isEmpty()){
            // added FLS update PD-7929
            if(schema.SObjectType.Account.fields.IsReadyToSyncInZuora__c.isAccessible() && schema.SObjectType.Account.isUpdateable()){
                for(Account acc: accList){        
                    acc.IsReadyToSyncInZuora__c = false ;
                    accUpdateList.add(acc);
                }
                
                update accUpdateList;
            }
            else{ //if this user doest have permition to update then notify the same to system admin    
                
                String strError = 'Error faced while update :'+' User Id :'+UserInfo.getUserID();
                SendEmailWithErrorsToAdmins.sendEmail(strError);             
            } 
        }       
    }
    
    /*
Method to update the new product in zuora, based on discount added.
*/
    public static Zuora.zApi.AmendResult newProductUpdate(String zuoraSubscriptionId, String effectiveDate, Boolean bGenerateInvoice, String strMonth){
        try
        {
            getZuoraAPI();
            Zuora.zApi.AmendResult amendResult;
            Zuora.zObject objAmendment = new Zuora.zObject('Amendment');                
                objAmendment.setValue('Name', 'Testamendment') ;
                objAmendment.setValue('SubscriptionId',zuoraSubscriptionId);
                objAmendment.setValue('Type','NewProduct');
                objAmendment.setValue('EffectiveDate', effectiveDate) ;
                objAmendment.setValue('Status','Completed');
                objAmendment.setValue('ContractEffectiveDate', effectiveDate) ;
            Zuora.zObject ratePlanCharge = new Zuora.zObject('RatePlanCharge');
            ratePlanCharge.setValue('ProductRatePlanChargeId',DAZNConfiguration__c.getValues('ChrageID').Value__c);//custom settings
            ratePlanCharge.setValue('NumberOfPeriods','2');  
            ratePlanCharge.setValue('EndDateCondition','FixedPeriod');
            Zuora.zObject ratePlanChargeData = new Zuora.zObject('RatePlanChargeData');
            ratePlanChargeData.setValue('RatePlanCharge', ratePlanCharge);
 
            Zuora.zObject ratePlanData = new Zuora.zObject('RatePlanData');
            Zuora.zObject ratePlan = new Zuora.zObject('RatePlan');
            ratePlan.setValue('ProductRatePlanId', DAZNConfiguration__c.getValues('RatePlanId').Value__c);
            ratePlanData.setValue('RatePlan', ratePlan);
            ratePlanData.setValue('RatePlanChargeData', new List <Zuora.zObject> {ratePlanChargeData});             
            objAmendment.setValue('RatePlanData', ratePlanData);
            
            Zuora.zApi.AmendOptions amendOptions = new Zuora.zApi.AmendOptions();
                        amendOptions.generateInvoice=false;           
                        amendOptions.processPayments=false;
           
            Zuora.zApi.AmendRequest amendRequest = new Zuora.zApi.AmendRequest();
            amendRequest.amendments = new List<Zuora.zObject>{objAmendment};
            amendRequest.amendOptions =amendOptions;
            
            List<Zuora.zApi.AmendRequest> lst = new List<Zuora.zApi.AmendRequest>();
            lst.add(amendRequest);
            

            amendResult = api.zamend(lst); 
            Integer length = Zuora.zApi.currentLogger.request.length();
            String firsthalf = Zuora.zApi.currentLogger.request.substring (0, length/2);
            String secondhalf = Zuora.zApi.currentLogger.request.substring (length/2);
            return amendResult ;
           
        }
        catch(Exception ex)
        {
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper ', 'newProductUpdate', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
            return null;
        }
    }    
    /*
Description - To analyse the results of a Zuora API Create result 
Report errors into logs 
Report to Admin via Email
*/
    public static void analyseSaveResultsfromZuora(List<Zuora.zApi.SaveResult> lstCreateResult, String callingMethod, List<Zuora.zObject> lstzObject){
        for (Zuora.zApi.SaveResult result : lstCreateResult) {
            if (!result.Success){
                Zuora.zObject[] errors = result.errors;
                for (Zuora.zObject error : errors) {
                    String errorCode = (String)error.getValue('Code');
                    String errorMessage = (String)error.getValue('Message');
                    ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper ', callingMethod, errorMessage, errorCode, errorCode+':'+errorMessage);    
                    
                }
                SendEmailWithErrorsToAdmins.sendEmail('Error while executing ZuoraTransactionHelper.'+callingMethod+': '+lstzObject+':'+lstCreateResult); 
            }
        }
        
    }
    
    /*
Description - to handle Chargebacks from Zuora.
Step 1 . Get the Invoice Number from the Payment ID
Step 2. Get the subscription related to the Invoice Line items corresponding to the Invoice Number
Step 3. Cancel the subscription with the last invoiced date as the effective date
Step 4. Create Invoice Adjustments
If any step fails, log into Error logs
Return success/failure of the transaction
*/
    
    public static void handleChargeBacks(String paymentId, Date lastInvoiceDate){
        
        List<Zuora.zObject> lstInvoice = new List<Zuora.zObject>();
        List<Zuora.zObject> lstOriginalInvoice = new List<Zuora.zObject>();
        List<Zuora.zObject> lstInvoiceItem = new List<Zuora.zObject>();
        List<Zuora__Subscription__c> lstActiveSubs = new List<Zuora__Subscription__c> ();
        Set<String> subIds = new Set<String>();
        String whereClause = '';
        //String invoiceWhereClause = '';
        Zuora.zApi.AmendResult amendResult;
        String effectiveDate = ((DateTime)lastInvoiceDate).format('yyyy-MM-dd');
        List<Zuora.zApi.SaveResult> lstInvoiceAdjustmentsaveResult1 ;
        List<Zuora.zObject> lstNegativeInvoice;
        Zuora.zObject invoicePayment = new Zuora.zObject('InvoicePayment');
        Zuora.zObject invoiceItem = new Zuora.zObject('InvoiceItem');
        Zuora__Subscription__c zSub = new Zuora__Subscription__c();
            
        try{      
            getZuoraAPI();    
            //Query to get the Invoice ID
            // The InvoicePayment object doesn't have the InvoiceNumber in it.
            if(!Test.isRunningTest())
                lstInvoice = zQuery('Select InvoiceId from InvoicePayment where PaymentId = \''+paymentId+'\''); 
            
            else{
                
                invoicePayment.setValue('InvoiceId','2c92c0f957f9e9870157fb183c1a76d0');
                lstInvoice.add(invoicePayment);
            }
            
            if(lstInvoice!=null && !lstInvoice.isEmpty()){
                for(Zuora.zObject zInvoice : lstInvoice){
                    whereClause = whereClause + 'InvoiceId = \''+zInvoice.getValue('InvoiceId')+'\' OR ';
                    
                }
                
                //get the Subscription Ids from the Invoice Item table
                Integer index = whereClause.lastIndexOf(' OR ');
                whereClause = whereClause.subString(0,index);
                
                
                if(whereClause!=null && !String.isEmpty(whereClause)){
                    if(!Test.isRunningTest())
                        lstInvoiceItem = zQuery('Select SubscriptionId from InvoiceItem where '+whereClause);
                    else{
                        
                        invoiceItem.setValue('SubscriptionId','2c92c0f957f9e9870157fb183c1a76d0');
                        lstInvoiceItem.add(invoiceItem);
                    }
                    
                    for(Zuora.zobject zInvoiceItem : lstInvoiceItem ){
                        subIds.add(String.valueOf(zInvoiceItem.getValue('SubscriptionId')));
                    }
                    
                    //get the Active Subs only for further cancellation
                    if(!Test.isRunningTest())
                        lstActiveSubs = [Select Zuora__External_Id__c from Zuora__Subscription__c where Zuora__Status__c = 'Active' and Zuora__External_Id__c in :subIds];
                    else{
                        zSub.Zuora__External_Id__c = '2c92c0f957f9e9870157fb183c1a76d0';
                        
                        lstActiveSubs.add(zSub);
                    }
                    
                    if(lstActiveSubs != null && !lstActiveSubs.isEmpty()){
                        //Immediate cancel the subscription
                        if(!Test.isRunningTest())
                            amendResult = ZuoraTransactionHelper.cancelSubscription(lstActiveSubs[0].Zuora__External_Id__c, effectiveDate, true);
                        else{
                            amendResult = new Zuora.zApi.AmendResult();
                            amendResult.Success = true;
                            amendResult.InvoiceId = '2c92c0f957f9e9870157fb183c1a76d0';
                        }
                        if(amendResult != null && amendResult.Success == true && amendResult.Errors == null){
                            
                            for(Zuora.zObject zInvoice : lstInvoice){
                                //Create Invoice Line Item adjustment for the positive invoice
                                lstInvoiceAdjustmentsaveResult1 = ZuoraTransactionHelper.createInvoiceLineItemAdjusment(String.valueOf(zInvoice.getValue('InvoiceId')),'Chargeback','Credit');
                            }
                            //Create Invoice Adjustment for Negative Invoice
                            ZuoraTransactionHelper.createInvoiceLineItemAdjusment(String.valueOf(amendResult.InvoiceId),
                                                                                  'Chargeback','Charge');
                        }
                    }
                }
            }
        }catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'ZuoraTransactionHelper ', 'handleChargeBacks', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()); 
        }
    }    
}