trigger CLQ_RoomOrGrpTrigger on CLQ_Room_Space__c (after insert, after update, before insert, before update) {
     Map<id,CLQ_Room_Space__c> NewRSMap = Trigger.newMap;
  Map<id,CLQ_Room_Space__c> OldRSMap = Trigger.oldMap;
    if(trigger.isafter){
    	system.debug('MMMMMM'+trigger.newmap);
       CLQ_RoomOrGrptgrHandler.updateformula(NewRSMap,OldRSMap);
   }
}