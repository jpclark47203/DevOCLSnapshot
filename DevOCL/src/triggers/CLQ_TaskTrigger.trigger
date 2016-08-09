trigger CLQ_TaskTrigger on Task (before insert,after insert,before update,after update,before delete,after delete) {
	CLQ_TaskTriggerHandler Handler = new CLQ_TaskTriggerHandler(
														trigger.new, trigger.newMap, trigger.old, trigger.oldMap,
														trigger.isExecuting, trigger.isInsert, trigger.isUpdate, trigger.isDelete, 
														trigger.isBefore, trigger.isAfter, trigger.isUndelete, trigger.size);
	Handler.ProcessTrigger();
}