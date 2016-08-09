@isTest
private class TestVisitInfo {
    static testMethod void mytest(){
        CLQ_Inspection__c objCLQIns = new CLQ_Inspection__c(CLQ_Approved_By__c = userinfo.getUserID());
        insert objCLQIns;
        Visit_Information__c objVisit = new Visit_Information__c(User__c = Userinfo.getUserId(),Name = 'Test Visit',Inspection__c = objCLQIns.id);
        insert objVisit;
        CLQ_Room_Space__c objRoom = new CLQ_Room_Space__c(CLQ_Inspection__c = objCLQIns.id,Name='TestRooms');
        insert objRoom;
        Visit_Information__c objVisit1 = new Visit_Information__c(User__c = Userinfo.getUserId(),Name = 'Test Visit',Inspection__c = objCLQIns.id);
        insert objVisit1;
    }

}