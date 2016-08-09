trigger TrgRoomshare on CLQ_Room_Space__c (After insert) {
/*set<Id> setInv = new set<Id>();
    map<Id,list<Id>> mapExestingUser = new map<Id,list<Id>>();
    map<Id,Id> mapOwnerids = new map<Id,Id>();
    list<CLQ_Room_Space__Share> lstInsertRoom = new list<CLQ_Room_Space__Share>();
    for(CLQ_Room_Space__c objRoom:trigger.new){
        if(objRoom.CLQ_Inspection__c != null){
            setInv.add(objRoom.CLQ_Inspection__c);
            mapOwnerids.put(objRoom.OwnerId,objRoom.OwnerId);
        }
    }
    
    if(setInv != null){
        for(Clq_Inspection__c objins : [select id,Name, OwnerId,(Select Id, OwnerId, User__c, Inspection__c 
            From Visit_Information__r) from Clq_Inspection__c WHERE ID IN:setInv]){
                for(Visit_Information__c objv:objins.Visit_Information__r){
                    //mapExestingUser.put(objins.Id,objv.User__c);
                    if(mapExestingUser.get(objins.Id) == null){
                        mapExestingUser.put(objins.Id,new list<Id>{objv.User__c});
                    }
                    else{
                        mapExestingUser.get(objins.Id).add(objv.User__c);
                    }
                }
        }
    }
     
    for(CLQ_Room_Space__c obj:trigger.new){
        for(Id objuser:mapExestingUser.get(obj.CLQ_Inspection__c)){
            if(!mapOwnerids.containsKey(objuser)){
                CLQ_Room_Space__Share objroom = new CLQ_Room_Space__Share(UserOrGroupId = objuser,RowCause = 'Manual',
                ParentId = obj.id,AccessLevel  = 'Edit');
                lstInsertRoom.add(objroom);
            }
        }
    }
    
    if(!lstInsertRoom.isEmpty()){
        insert lstInsertRoom;
    }
*/
}