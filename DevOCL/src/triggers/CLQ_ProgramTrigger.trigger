/*Class Name : CLQ_ProgramTrigger
* Description : This trigger contains all logic/methods for CLQ_Program__c object's trigger event. Details methods can be found in handler class
*/
trigger CLQ_ProgramTrigger on CLQ_Program__c (before insert,before update) {
    Map<id,CLQ_Program__c> NewPrMap = Trigger.newMap;
    Map<id,CLQ_Program__c> OldPrMap = Trigger.oldMap;
    //before insert block
    if(trigger.isinsert && trigger.isbefore){
        //call the before insert logic of the handler class
        CLQ_ProgramTriggerHandler.beforeinsert(trigger.new, trigger.newmap);
    }
    
    
}//EoF