/****************************************************************************************************
* @author Cognizant Technology Solutuions
* @date 11/02/2016
* @description CaseTriggerHandler class - helper class for the Case Trigger
History
================
Version     Date            Author                  Reason
-------     ----------      ------------------      ------------------
1.0         10/12/2016       CTS                     Initial version Ticket PD-8637   
******************************************************************************************************/
public class CaseTriggerHandler {
    /*************************************************************************************************
@Method Name: AddingAccountAndContactToCase
@Method Description: This method used to insert the cases with Account and Contact based on PersonEmail.
@Param: List<Case>    
**************************************************************************************************/
    /*PD-9519*/
    public static void AddingAccountAndContactToCase (List<Case> beaforeInsertCases){
        User currentUser = new User();
        if (!userInfo.getUserType().Equals('Guest')) {
            List<Account> lstAccount = new List<Account>();
            if(UserInfo.getUserId() != null){ // Added if condition  part of PD-11053
                currentUser = [
                    SELECT Id, AccountId
                    FROM User
                    WHERE Id =: UserInfo.getUserId()
                ];
            }
            if(currentUser != null){ // Added if condition  part of PD-11053
                lstAccount=[Select Id, PersonContactId, Notification_Language_Code__c, Notification_Country_Code__c From Account where ID =:currentUser.AccountId Limit 1];
            }
            if(lstAccount != null && lstAccount.size() == 1)
            {       
                Account account = lstAccount[0];
                for(Case caseobj : beaforeInsertCases) {
                    caseobj.accountId = account.Id;
                    caseObj.ContactId = account.PersonContactId;
                    caseobj.Notification_Country_Code__c = account.Notification_Country_Code__c;
                    //added as part of PD-15017 ticket
                    caseobj.Notification_Language_Code__c = (String.isNotBlank(account.Notification_Language_Code__c) &&
                                                             account.Notification_Language_Code__c.startsWithIgnoreCase('en')) ?
                        account.Notification_Language_Code__c.split('_')[0] : account.Notification_Language_Code__c;
                    //caseobj.Notification_Language_Code__c = account.Notification_Language_Code__c;
                }
            }
        }
    }
    
    /*Added as a part of PD-16510*/
    public static void emailToCaseLoopKiller(List<Case>newList){
        // Will not process new email if there is at least 1 email from
        // the same email address with the same subject and the previous email
        // was less than 5 minutes old.
        
        DateTime dt = System.now();
        //gets all cases created in the last 10 minutes only to compare against
        DateTime dateTimeRange = dt.addMinutes(-10), fullHour = dt.addMinutes(- dt.minute()).addSeconds(- dt.second());
        
        List<Case> latestCasesList = [select ID, CreatedDate, Subject, SuppliedEmail
                                      from Case
                                      where isclosed = false and SuppliedEmail <> null
                                      and CreatedDate > :dateTimeRange and CreatedDate < :system.now()
                                      order by CreatedDate desc LIMIT 100];
        
        //string will be the from email in this case to return a record to check
        Map<String, List<Case>> fromEmailToCaseMap = new Map<String, List<Case>>();
        
        for (Case cse: latestCasesList){
            if(fromEmailToCaseMap.containsKey(cse.SuppliedEmail)){
                List<Case> caseToAdd = fromEmailToCaseMap.get(cse.SuppliedEmail);
                caseToAdd.add(cse);
                fromEmailToCaseMap.put(cse.SuppliedEmail, caseToAdd);
            }
            else{
                fromEmailToCaseMap.put(cse.SuppliedEmail, new List<Case> { cse });
            }
        }
        for (Case cse: newList){
            if(cse.Subject != null) {  
                //We have a subject, proceed.
                if(cse.subject.contains(' ref:')){
                    //No Errors.  Email should be attached to the case.
                }
                else{
                    
                    List<Case> casesFromRecipientList = fromEmailToCaseMap.get(cse.SuppliedEmail);
                    if(casesFromRecipientList != null){
                        if(casesFromRecipientList.size() > 0){
                            Integer emailMatchCount = 0;
                            for (Case check: casesFromRecipientList){
                                if((check.createddate.addMinutes(5) > System.now()) && check.subject.contains(cse.subject)){
                                    emailMatchCount += 1;
                                }
                                else{
                                    //New Case should be created now!       
                                }
                            }
                            if (emailMatchCount > 0){
                                //Loop Was Killed.
                                cse.addError('Automatic email loop has been terminated from sender = ' + cse.SuppliedEmail + ' for subject = ' + cse.Subject);
                            }
                        }
                    }
                }
            }
            
        }
    }
    /*End of PD-16510*/
    
    
    //PD-7838 should be in 1.10
    /*public static void AddingCaseContactToCampaign(List<Case> afterInsertCases){
for(Case caseobj : afterInsertCases) {
if(caseobj.ContactId != null && caseobj.Campaign__c != null){
List<CampaignMember> lstCampaigns = [SELECT Campaign.id, Contact.id FROM CampaignMember WHERE Campaign.id =: caseobj.Campaign__c AND Contact.id =: caseobj.ContactId];

if(lstCampaigns.isEmpty())
{
try{

CampaignMember camp = new CampaignMember();
camp.CampaignId = caseobj.Campaign__c;
camp.ContactId = caseobj.ContactId;
camp.Status = 'Sent';

insert camp;   
}   
catch(Exception ex){
ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CaseTriggerHandler', 'AddingCaseContactToCampaign', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
}
}
}
else if(caseobj.Campaign__c != null && caseobj.SuppliedEmail != null){
try{
CampaignMember camp = new CampaignMember();
camp.CampaignId = caseobj.Campaign__c;
camp.Status = 'Sent';
List<Contact> lstExistCont = [SELECT id, Email From Contact WHERE Contact.Email =: caseobj.SuppliedEmail];
if (lstExistCont.isEmpty()){                        
Contact cont = new Contact();
cont.Email = caseobj.SuppliedEmail;
cont.LastName = 'Customer';
insert cont;

camp.ContactId = cont.id;
}
else{
camp.ContactId = lstExistCont[0].id;
}

insert camp;   
}  
catch(Exception ex){
ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'CaseTriggerHandler', 'AddingCaseContactToCampaign', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
}
}
}
}*/
    
    
    /*
private static void GuestUserBehaviour(List<Case> beaforeInsertCases)
{
Map<String,Case> caseMap = new Map<String,Case>();
Map<String,Account> accountDocomoMap = new Map<String,Account>();
Map<String,Account> accountDAZNMap = new Map<String,Account>();
if (beaforeInsertCases !=null && beaforeInsertCases.size() > 0){
for(Case newCase : beaforeInsertCases) {
if(String.isNotBlank(newCase.Provider_Type__c))
{
if(newCase.Provider_Type__c == 'DAZN' || newCase.Provider_Type__c == 'Docomo')
{
if(newCase.Contact_us_email__c != null)
{
caseMap.put(newCase.Contact_us_email__c,newCase);
}
}
}
}  
}
Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');

if (pac != null) {
String docomoUserType = pac.Partner_Type__c;
if(String.isNotBlank(docomoUserType))
{
List<Account> accountList= [SELECT Id, PersonContactId, PersonEmail, Secondary_Email__c, Type, Partner_ID__c, Notification_Language_Code__c, Notification_Country_Code__c FROM Account 
WHERE (PersonEmail IN :caseMap.keySet() OR Secondary_Email__c IN :caseMap.keySet()) LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())];
if(accountList!= null && accountList.size() > 0){

Set<String> accountDAZNDuplicateSet = new Set<String>();
Set<String> accountDocomoDuplicateSet = new Set<String>();
for(Account acc : accountList)
{
if(String.isNotBlank(acc.Type) && acc.Type.equals(docomoUserType) && String.isNotBlank(acc.Partner_ID__c))
{
if(accountDocomoMap.containsKey(acc.Secondary_Email__c)){
if(!accountDocomoDuplicateSet.contains(acc.Secondary_Email__c)){
accountDocomoDuplicateSet.add(acc.Secondary_Email__c);
}
}
else{
accountDocomoMap.put(acc.Secondary_Email__c, acc);
}
}
else
{
if(accountDAZNMap.containsKey(acc.PersonEmail)){
if(!accountDAZNDuplicateSet.contains(acc.PersonEmail)){
accountDAZNDuplicateSet.add(acc.PersonEmail);
}
}
else{
accountDAZNMap.put(acc.PersonEmail, acc);
}
}
}

for(case caseobj :caseMap.values()){
Account acc = null;
if(caseobj.Provider_Type__c == 'DAZN'){
if(accountDAZNMap.containsKey(caseobj.Contact_us_email__c) && !accountDAZNDuplicateSet.contains(caseobj.Contact_us_email__c)){
acc = accountDAZNMap.get(caseobj.Contact_us_email__c);
}
}
else{
if(caseobj.Provider_Type__c == 'Docomo'){
if(accountDocomoMap.containsKey(caseobj.Contact_us_email__c) && !accountDocomoDuplicateSet.contains(caseobj.Contact_us_email__c)){
acc = accountDocomoMap.get(caseobj.Contact_us_email__c);
}
}
}

if(acc != null){
caseobj.accountId = acc.id;
caseObj.ContactId = acc.PersonContactId;
caseobj.Notification_Country_Code__c = acc.Notification_Country_Code__c;
caseobj.Notification_Language_Code__c = acc.Notification_Language_Code__c;
}
}
}
}
}
}
*/
    
    /*  PD-8637 
Map<String,Case> caseMap = new Map<String,Case>();
Map<String,Account> accmap = new Map<String,Account>();
if (beaforeInsertCases !=null && beaforeInsertCases.size() > 0){
for(Case newCase : beaforeInsertCases) {
if(newCase.SuppliedEmail!=null){
caseMap.put(newCase.SuppliedEmail,newCase);
}
}  
}
List<Account>  accountList = new List<Account>();
accountList= [SELECT Id, PersonContactId, PersonEmail,  Notification_Language_Code__c, Notification_Country_Code__c FROM Account WHERE PersonEmail IN :caseMap.keySet() LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())];
if(accountList!= null && accountList.size()>0){
for(Account acc : accountList){
accmap.put(acc.PersonEmail, acc);
}

for(case caseobj :caseMap.values()){
if(accmap.containsKey(caseobj.SuppliedEmail)){
caseobj.accountId = accmap.get(caseobj.SuppliedEmail).id;
caseObj.ContactId = accmap.get(caseobj.SuppliedEmail).PersonContactId;
caseobj.Notification_Country_Code__c = accmap.get(caseobj.SuppliedEmail).Notification_Country_Code__c;
caseobj.Notification_Language_Code__c = accmap.get(caseobj.SuppliedEmail).Notification_Language_Code__c;
}
}
}
*/
}