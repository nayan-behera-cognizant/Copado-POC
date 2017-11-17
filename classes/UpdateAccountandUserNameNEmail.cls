/*******This class is Introduced as part of PD-11813 *******
***A Button is created in the Account pagelayout to update Account FirstName,LastName and Email****
***This is useful for the CSAgent to edit the Acccount Details when the button is clicked on Account pagelayout**
*/
public class UpdateAccountandUserNameNEmail {
    
    public String FirstName{get;set;}
    public String LastName{get;set;}
    public String Email{get;set;}
    public  list<Account> listOfAccounts;
    public  list<User> listOfUsers;
    public string sAccountid;
    public UpdateAccountandUserNameNEmail(ApexPages.StandardController stdcontroller){
        sAccountid = stdController.getId();
        listOfAccounts =new list<Account>();
        listOfUsers =new list<User>();
        populateValues();
    }
    public void populateValues(){
        if(sAccountid !=null){
            listofAccounts =[select id,FirstName,LastName,PersonEmail,Type,Partner_ID__c,DFD_First_Name__c,DFD_Last_Name__c from Account where id=:sAccountid ];
        }
        if(listofAccounts !=null && listofAccounts.size()>0 ){
            if(listofAccounts[0].Type != 'Docomo' && listofAccounts[0].Partner_ID__c == null){
                    FirstName =listofAccounts[0].FirstName;
                    LastName = listofAccounts[0].LastName ;
                    Email =listofAccounts[0].PersonEmail;
            }
            else{
                    FirstName = listofAccounts[0].DFD_First_Name__c ;
                    LastName = listofAccounts[0].DFD_Last_Name__c;
                    Email = listofAccounts[0].PersonEmail;
                
            }
        }
    }
    public pagereference SaveRecord(){
        try{
            
            if(listofAccounts[0].Type != 'Docomo' && listofAccounts[0].Partner_ID__c == null){
                if(listofAccounts !=null && listofAccounts.size()>0 ){
                listofAccounts[0].FirstName = FirstName;
                listofAccounts[0].LastName = LastName;
                listofAccounts[0].PersonEmail = Email;
                }
            }
            else{
                if(listofAccounts !=null && listofAccounts.size()>0 ){
				listofAccounts[0].DFD_First_Name__c = FirstName;
                listofAccounts[0].DFD_Last_Name__c = LastName;
                listofAccounts[0].PersonEmail = Email;
                 
                }
            }
            if(String.isBlank(FirstName) || (Pattern.compile('([~,`,!,@,#,$,%,^,&,*,(,),_,+,{,},|,:,;,",<,>,?,*,-,+,£])').matcher(FirstName)).find() || !(Pattern.compile('^([^0-9]*)$').matcher(FirstName)).find()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.LS_MyAccount_ErrMsg_Valid_Firstname));
                return null;
            }
            else if(String.isBlank(LastName) || (Pattern.compile('([~,`,!,@,#,$,%,^,&,*,(,),_,+,{,},|,:,;,",<,>,?,*,-,+,£])').matcher(LastName)).find() || !(Pattern.compile('^([^0-9]*)$').matcher(LastName)).find()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.LS_MyAccount_ErrMsg_Valid_Surname));
                return null;
            } 
            if(listofAccounts !=null && listofAccounts.size()>0 ){
				  update listofAccounts;
            }
            
           
            pagereference pg =new pagereference('/'+sAccountid);
            pg.setRedirect(true);
            return pg;
        }
        catch(Exception ex){
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'UpdateAccountandUserNameNEmail', 'Save', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            return null;
        }
    }
    
    public PageReference cancelAction(){
        return new pageReference('/'+sAccountid);
    }
}