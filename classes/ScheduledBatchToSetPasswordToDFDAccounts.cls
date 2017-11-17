/* @author Cognizant Technology Solutuions
* @date 01/10/2017
* Description : Schedule class to run BatchToSetPasswordToDFDAccounts
*/

global class ScheduledBatchToSetPasswordToDFDAccounts implements Schedulable
 {
     global void execute(SchedulableContext sc){
         BatchToSetPasswordToDFDAccounts usrDFDBatch = new BatchToSetPasswordToDFDAccounts();
         database.executebatch(usrDFDBatch,40);

     }

}