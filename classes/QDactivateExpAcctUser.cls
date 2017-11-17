public class QDactivateExpAcctUser implements Queueable {
    Set<Id> recordids;
    public QDactivateExpAcctUser(Set<Id> recordIds) {
        this.recordIds = recordIds;
    }
    public void execute(QueueableContext context) { 
        list<User> lstUser = new list<User>();
        integer i = 0;
        lstUser = [Select Email From User Where Email Like: 'anonymous%' and Email Like: '%@livesport.com'];
        if(lstUser != null && lstUser.size()>0){
            i = lstUser.size();
        }
        lstUser = new list<User>();
        for(User usr : [Select Id,Email,isActive From User Where AccountId IN: recordIds and isActive =: true]){
            i++;
            usr.Email = 'anonymous'+i+'@livesport.com';
            usr.isActive = false;
            lstUser.add(usr);
        }
        
        if(lstUser != null && lstUser.size()>0 && !Test.isRunningTest()){
            update lstUser;   
        }  
    }
}