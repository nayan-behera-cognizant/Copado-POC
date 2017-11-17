/*
    *  @author Megha Jain
    *  @date August 22, 2017
    *  @description Batch class for data cleanup
       @Modification Log:        
    ------------------------------------------------------------------------------------        
    Developer                Mod Number       Date                Description        
    ------------------------------------------------------------------------------------        
    Megha Jain               -           August 22, 2017          Initial version created.
    */

global class DataStorageCleanUpBatch implements Database.Batchable<sObject>,Database.Stateful {
    
    global Integer countOfItems = 0;
    String query;
    Date dateForDelete;
    Database.DeleteResult[] drList;
    
    global DataStorageCleanUpBatch(String queryForExecute, Date dateForDelete) {
        this.query = queryForExecute;
        this.dateForDelete = dateForDelete;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(this.query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
            if(!scope.isEmpty()){
            delete scope ;
            Database.emptyRecycleBin(scope );

            }
            
            this.countOfItems += scope.size();
            
           }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}