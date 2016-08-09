/*Class Name : CLQ_CaseTriggerTest
* Description : This test class contains all test logic logic/methods for Case object's trigger event.
*/
@isTest 
private class CLQ_CaseTriggerTest{
    static testMethod void testinsertRoleonContact(){
        //insert configuration record
        CLQ_OCLQS_Configuration__c configRecord = new CLQ_OCLQS_Configuration__c(Name = 'FCC - Type B Home');
        insert configRecord; 
        
        //Create account record
        Account accountrecord = new Account(Name='Test Account',CLQ_DIRN__c = '1234'); 
        insert accountrecord ;
        
        //Insert contact
        Contact contactrecord = new Contact(Firstname='test', lastName = 'Test',Accountid = accountrecord.id );
        insert contactrecord ;
        
        //Create a program record
        CLQ_Program__c programRecord = new CLQ_Program__c();
        programRecord.Name = 'Test';
        programRecord.CLQ_Associated_Organization__c = accountrecord.id;
        programRecord.CLQ_Street_Address_1__c = 'test';
        programRecord.recordTypeid = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get('FCC - Type B Home').getRecordTypeId();
        programRecord.CLQ_Licensing_Specialist__c = UserInfo.getUserid();
        insert programRecord ;
        
        //Insert case for program
        Case caseRecord = new Case();
        caseRecord.recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();
        caseRecord.ContactId = contactrecord.id;
        caseRecord.CLQ_Program__c = programRecord.id;
        caseRecord.CLQ_Approver_s_Email__c = 'test@CLQ.com';
        caseRecord.CLQ_Assigned_to_Email__c = 'test@CLQ.com';
        caseRecord.CLQ_Assigned_To__c = UserInfo.getUserid();
        insert caseRecord;
        
    }    
}