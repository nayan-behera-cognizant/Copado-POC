/**
    *  @author Megha Jain
     * @date August 22, 2017
    *  @description Apex class to schedule the Batch for data cleanup 
    @Modification Log:        
    ------------------------------------------------------------------------------------        
    Developer                Mod Number       Date                Description        
    ------------------------------------------------------------------------------------        
    Megha Jain               -           August 22, 2017          Initial version created.
    */


global class DataStorageCleanUpScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :sc.getTriggerId()];
        startBatchs();
    }
    
    
    /**
        *  @author Megha Jain
        *  @date August 22, 2017
        *  @description :Description: Method to Pass Dynamic query to the Batch class 
            @Parameter : 
        */
    public static void startBatchs() {
        
        String ObjToDelete;
        Decimal monthLimit ;
        Integer intConvertedValue;
        String queryrecord;
        Date dateForDelete;
        
        //Get all data from Custom Setting 
        List<DataStorageCleanUpObjectandLimits__c> delObjCusSet = DataStorageCleanUpObjectandLimits__c.getall().values();
        try {
            for(DataStorageCleanUpObjectandLimits__c delObj : delObjCusSet ){
                ObjToDelete = delObj.Name;
                monthLimit = delObj.Number_Of_Months__c;
                intConvertedValue = monthLimit.intValue();
                
                dateForDelete = Date.today().addMonths(-(intConvertedValue));
                
                if (dateForDelete!= null && ObjToDelete !=null )
                    
                {
                    if (ObjToDelete =='Task'){
                        queryrecord = 'SELECT Id FROM  '+String.escapeSingleQuotes(ObjToDelete)+'';
                        queryrecord +=' ';
                        queryrecord += 'WHERE CreatedDate <=:dateForDelete AND Status = \'Completed\' ORDER BY CreatedDate DESC LIMIT 10000';
                        DataStorageCleanUpBatch batchCtrTask = new DataStorageCleanUpBatch(queryrecord , dateForDelete );
                        database.executebatch(batchCtrTask, 2000);
                        
                    }
                    else 
                    {
                        
                        queryrecord = 'SELECT Id FROM  '+String.escapeSingleQuotes(ObjToDelete)+'';
                        queryrecord +=' ';
                        queryrecord += 'WHERE CreatedDate <=:dateForDelete ORDER BY CreatedDate DESC LIMIT 10000';
                        DataStorageCleanUpBatch batchCtrTask = new DataStorageCleanUpBatch(queryrecord , dateForDelete );
                        database.executebatch(batchCtrTask, 2000);
                        
                    }
                    
                }
                
            }
            
        }
        catch(Exception ex){
            
            ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'DataStorageCleanUpScheduler ', 'startBatchs', ex.getMessage(), ex.getTypeName(), ex.getStackTraceString());
            
        }
    }
}