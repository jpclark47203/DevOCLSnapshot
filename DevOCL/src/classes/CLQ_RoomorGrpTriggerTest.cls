@isTest 
private class CLQ_RoomorGrpTriggerTest{
    static testMethod void testRoomgrptest() {
        //insert configuration record
        CLQ_OCLQS_Configuration__c configRecord = new CLQ_OCLQS_Configuration__c(Name = 'FCC - Type B Home');
        insert configRecord; 
    
        //Create account recordd
        Account accountrecord = new Account(Name='Test Account',CLQ_DIRN__c = '1234'); 
        insert accountrecord ;
        
        //Create a program record
        CLQ_Program__c programRecord = new CLQ_Program__c();
        programRecord.Name = 'Test';
        programRecord.CLQ_Associated_Organization__c = accountrecord.id;
        programRecord.CLQ_Street_Address_1__c = 'test';
        programRecord.recordTypeid = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get('FCC - Type B Home').getRecordTypeId();
        insert programRecord ;
        CLQ_Room_Space__c RorGrecord = new CLQ_Room_Space__c(CLQ_Length_Feet__c = 30,CLQ_Width_Feet__c = 30,CLQ_Approved_Room_Space__c = true, CLQ_Number_of_Children_Under_2__c = 2,CLQ_Used_By_Under_or_Over_2__c = 'Over',name='dining area', CLQ_Room_Space_Type__c='Primary Space', CLQ_Program__c= programrecord.id);
        insert RorGrecord;

        //insert configuration record
        CLQ_OCLQS_Configuration__c configRecord2 = new CLQ_OCLQS_Configuration__c(Name = 'FCC - Type A Home');
        insert configRecord2; 
                
 		//Create account record
        Account accountrecord2 = new Account(Name='Test Account2',CLQ_DIRN__c = '2345'); 
        insert accountrecord2 ;   
            
        CLQ_Program__c programRecord2 = new CLQ_Program__c();
        programRecord2.Name = 'Test2';
        programRecord2.CLQ_Associated_Organization__c = accountrecord2.id;
        programRecord2.CLQ_Street_Address_1__c = 'test2';
        programRecord2.recordTypeid = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get('FCC - Type A Home').getRecordTypeId();
        insert programRecord2 ;        
        CLQ_Room_Space__c RorGrecord2 = new CLQ_Room_Space__c(CLQ_Length_Feet__c = 35,CLQ_Width_Feet__c = 35,CLQ_Approved_Room_Space__c = true, CLQ_Number_of_Children_Under_2__c = 2,CLQ_Used_By_Under_or_Over_2__c = 'Both',name='dining area', CLQ_Room_Space_Type__c='Primary Space', CLQ_Program__c= programrecord2.id);
        insert RorGrecord2; 
        CLQ_Room_Space__c RorGrecord2a = new CLQ_Room_Space__c(CLQ_Length_Feet__c = 30,CLQ_Width_Feet__c = 30,CLQ_Approved_Room_Space__c = true, CLQ_Number_of_Children_Under_2__c = 2,CLQ_Used_By_Under_or_Over_2__c = 'Over',name='dining area', CLQ_Room_Space_Type__c='Primary Space', CLQ_Program__c= programrecord2.id);
        insert RorGrecord2a;      
        
        //insert configuration record
        CLQ_OCLQS_Configuration__c configRecord3 = new CLQ_OCLQS_Configuration__c(Name = 'Pre School');
        insert configRecord3; 
                
 		//Create account record
        Account accountrecord3 = new Account(Name='Test Account2',CLQ_DIRN__c = '3456'); 
        insert accountrecord3 ;   
            
        CLQ_Program__c programRecord3 = new CLQ_Program__c();
        programRecord3.Name = 'Test3';
        programRecord3.CLQ_Associated_Organization__c = accountrecord3.id;
        programRecord3.CLQ_Street_Address_1__c = 'test3';
        programRecord3.recordTypeid = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get('Pre School').getRecordTypeId();
        insert programRecord3 ;        
        CLQ_Room_Space__c RorGrecord3 = new CLQ_Room_Space__c(CLQ_Number_of_Children_Under_2_5__c =5,CLQ_Length_Feet__c = 35,CLQ_Width_Feet__c = 35,CLQ_Approved_Room_Space__c = true, CLQ_Used_by_Under_or_Over_2_1_2__c = 'Both',name='dining area', CLQ_Room_Space_Type__c='Primary Space', CLQ_Program__c= programrecord3.id);
        insert RorGrecord3;        
    }
}