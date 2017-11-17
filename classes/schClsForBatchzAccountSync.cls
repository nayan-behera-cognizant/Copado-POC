global class schClsForBatchzAccountSync implements schedulable
{
    global void execute(SchedulableContext sc)
    {
    ZAccountsSynchroniser zAcctSync = new ZAccountsSynchroniser(); 
      ID batchprocessid = Database.executeBatch(zAcctSync,50);  
    }
}