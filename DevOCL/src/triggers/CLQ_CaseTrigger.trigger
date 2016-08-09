/* Name : CLQ_CaseTrigger
* Description : This trigger contains all logic/methods for Case object's trigger event. Details methods can be found in handler class
*
*/
trigger CLQ_CaseTrigger on Case (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

    CLQ_CaseTriggerHandler Handler = new CLQ_CaseTriggerHandler(
                                                        trigger.new, trigger.newMap, trigger.old, trigger.oldMap,
                                                        trigger.isExecuting, trigger.isInsert, trigger.isUpdate, trigger.isDelete, 
                                                        trigger.isBefore, trigger.isAfter, trigger.isUndelete, trigger.size);
    Handler.ProcessTrigger(); 
}