trigger VisitInfoAuthorization on Visit_Information__c (After insert) {
/*list<CLQ_Inspection__Share> lstInspection = new list<CLQ_Inspection__Share>();
    list<CLQ_Inspection__Share> lstDeleteIns = new list<CLQ_Inspection__Share>();
    list<Visit_Information__Share > lstDeleteVisit = new list<Visit_Information__Share>(); 
    list<CLQ_Room_Space__Share> lstInsertRoom = new list<CLQ_Room_Space__Share>();
    list<Visit_Information__Share> lstVisitShare= new list<Visit_Information__Share>();
    list<CLQ_Room_Space__Share> lstRoomShare = new list<CLQ_Room_Space__Share>();

    set<Id> setRoomInfo = new set<Id>();//Room Info ids.
    set<Id> setVisitInfo = new set<Id>(); //VisitInfo details.
    set<Id> setInsids = new set<Id>();
    
    map<Id,Id> mapOwnerVisit = new map<Id,Id>();
    map<Id,Id> mapOwnerRoom = new map<Id,Id>();
    map<Id,list<id>> mapinspectionsUsers = new map<id,list<Id>>();
    
    Id InspectionOwnerId;
    if(trigger.isInsert){
        for(Visit_Information__c obj:trigger.new){
            InspectionOwnerId = obj.OwnerId;
            if(obj.Inspection__c != null){
                CLQ_Inspection__Share objins = new CLQ_Inspection__Share(UserOrGroupId = obj.User__c,RowCause = 'Manual',
                    ParentId = obj.Inspection__c,AccessLevel  = 'Edit');
                system.debug('obj.Inspection__c --->'+obj.Inspection__c);
                system.debug('obj.objins --->'+objins);
                lstInspection.add(objins);
                setInsids.add(obj.Inspection__c);
            }
        }
        
        
        for(Clq_Inspection__c objins : [select id,Name, OwnerId,(Select Id, OwnerId, User__c, Inspection__c 
        From Visit_Information__r), (Select Id, OwnerId, CLQ_Inspection__c From Rooms_Spaces__r) 
        from clq_Inspection__c WHERE ID IN:setInsids]){
            //Select i.UserOrGroupId, i.RowCause, i.ParentId, i.Id, i.AccessLevel From CLQ_Inspection__Share i
            for(Visit_Information__c objVisit : objins.Visit_Information__r){
                
                setVisitInfo.add(objVisit.id);
                if(mapinspectionsUsers.get(objVisit.Inspection__c) == null){
                    mapinspectionsUsers.put(objVisit.Inspection__c,new list<Id>{objVisit.User__c});
                }
                else{
                    mapinspectionsUsers.get(objVisit.Inspection__c).add(objVisit.User__c);
                }
            }
            
            for(CLQ_Room_Space__c objChild:objins.Rooms_Spaces__r){
                setRoomInfo.add(objChild.id);
            }
        }
        
        for(Visit_Information__Share objinfo:[Select UserOrGroupId, ParentId,RowCause, Id From Visit_Information__Share WHERE ParentId IN:setVisitInfo]){
            if(objinfo.RowCause != 'Owner'){
                lstDeleteVisit.add(objinfo);                
            }else{
                mapOwnerVisit.put(objinfo.UserOrGroupId,objinfo.UserOrGroupId);
            }
        }
        
        for(CLQ_Room_Space__Share objshare:[Select UserOrGroupId,RowCause, ParentId, Id, AccessLevel From CLQ_Room_Space__Share where ParentId IN:setRoomInfo]){
            if(objshare.RowCause != 'Owner'){
                lstRoomShare.add(objShare);
            }else{
                mapOwnerRoom.put(objshare.UserOrGroupId,objshare.UserOrGroupId);
            }
        }
        
        if(!lstDeleteVisit.isEmpty()){
            delete lstDeleteVisit;
        }
        if(!lstRoomShare.isEmpty()){
            delete lstRoomShare;
        }
        for(clq_Inspection__c objins : [select id,Name, OwnerId,(Select Id, OwnerId, User__c, Inspection__c 
        From Visit_Information__r), (Select Id, OwnerId, CLQ_Inspection__c From Rooms_Spaces__r) 
        from clq_Inspection__c WHERE ID IN:setInsids]){
            
            for(Visit_Information__c objVisit : objins.Visit_Information__r){
                for(Id objUserID : mapinspectionsUsers.get(objVisit.Inspection__c)){
                    if(!mapOwnerVisit.containsKey(objUserID)){
                        Visit_Information__Share objSh = new Visit_Information__Share(UserOrGroupId = objVisit.User__c,RowCause = 'Manual',
                        ParentId = objVisit.id,AccessLevel  = 'Edit');
                        lstVisitShare.add(objSh);
                    }
                }
            }
            
            for(CLQ_Room_Space__c objChild:objins.Rooms_Spaces__r){
                for(Id objUserID : mapinspectionsUsers.get(objChild.CLQ_Inspection__c)){
                    if(!mapOwnerRoom.containsKey(objUserID)){
                        CLQ_Room_Space__Share objroom = new CLQ_Room_Space__Share(UserOrGroupId = objUserID,RowCause = 'Manual',
                        ParentId = objChild.id,AccessLevel  = 'Edit');
                        lstInsertRoom.add(objroom);
                    }
                }
            }
        }
        
        if(!lstInspection.isEmpty() && !test.isRunningTest()){
            insert lstInspection;
        }
        
        if(!lstInsertRoom.isEmpty()){
            insert lstInsertRoom;
        }
        
        if(!lstVisitShare.isEmpty()){
            insert lstVisitShare;
        }
    }
    
    
*/

}