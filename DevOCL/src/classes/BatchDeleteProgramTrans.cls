global class BatchDeleteProgramTrans implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
    	//date noOfDays = 120;
    	
    	date todaysDate = system.today().adddays(-120);
    	string objq = 'select id,Name ,CreatedDate,CLQ_Transaction_Status__c,CLQ_Submission_Date__c from CLQ_Program_Transaction__c';
    	objq += ' WHERE CLQ_Submission_Date__c <=: todaysDate  and (CLQ_Transaction_Status__c=\'Not Submitted\' or CLQ_Transaction_Status__c=\'Not Complete\')';
    	system.debug('objq --->'+objq);
    	return Database.getQueryLocator(objq);
    }
    
    global void execute (Database.BatchableContext Bc,list<CLQ_Program_Transaction__c> lstTrans){
    	system.debug('lstTrans --->'+lstTrans);
    	if(!lstTrans.isEmpty()){
    		delete lstTrans;
    	}
    } 
    
    global void finish(Database.BatchableContext Bc){
    	
    }
}