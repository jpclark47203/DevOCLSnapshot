/*Class to cover all methods used in CLQ_TaskTrigger
 */
@isTest
private class CLQ_TaskTriggerTest {
	
    static testMethod void ProgramTransactionUpdateTest() { 
        //insert configuration record
        CLQ_OCLQS_Configuration__c configRecord = new CLQ_OCLQS_Configuration__c(Name = 'FCC - Type B Home');
        insert configRecord;

        //Create account record
        Account accountrecord = new Account(Name = 'Test Account', CLQ_DIRN__c = '1234');
        insert accountrecord;

        //Create a program record
        CLQ_Program__c programRecord = new CLQ_Program__c();
        programRecord.Name = 'Test';
        programRecord.CLQ_Associated_Organization__c = accountrecord.id;
        programRecord.CLQ_Street_Address_1__c = 'test';
        programRecord.recordTypeid = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get(
            'FCC - Type B Home').getRecordTypeId();
        insert programRecord;

        CLQ_Program_Transaction__c PTrecord = new CLQ_Program_Transaction__c(CLQ_Transaction_Assigned_To__c =
            UserInfo.getUserid(),
            CLQ_Program__c = programrecord.id);
        insert PTrecord;

        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User usr = new User(LastName = 'LIVESTON',
            FirstName = 'JASON',
            Alias = 'jliv',
            Email = 'jason.liveston@asdf.com',
            Username = 'jason.liveston@abcdefg8395023.com',
            ProfileId = profileId.id,
            TimeZoneSidKey = 'GMT',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'en_US'
        );
        insert usr;

        Task task = new Task(status = 'In Progress', whatid = PTrecord.id, ownerId = usr.Id);
        insert task;

        //Now verify that the Program Transaction assigned to has been changed

        CLQ_Program_Transaction__c UpdatedPTrecord = [SELECT CLQ_Transaction_Assigned_To__c
            FROM CLQ_Program_Transaction__c WHERE Id =: PTrecord.Id];
        system.AssertEquals(Usr.Id, UpdatedPTrecord.CLQ_Transaction_Assigned_To__c);

    }
    
    static testMethod void TriggerBypassTest() {
    	/////////////////////////////////Same setup as above /////////////////
        //insert configuration record
        CLQ_OCLQS_Configuration__c configRecord = new CLQ_OCLQS_Configuration__c(Name = 'FCC - Type B Home');
        insert configRecord;

        //Create account record
        Account accountrecord = new Account(Name = 'Test Account', CLQ_DIRN__c = '1234');
        insert accountrecord;

        //Create a program record
        CLQ_Program__c programRecord = new CLQ_Program__c();
        programRecord.Name = 'Test';
        programRecord.CLQ_Associated_Organization__c = accountrecord.id;
        programRecord.CLQ_Street_Address_1__c = 'test';
        programRecord.recordTypeid = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get(
            'FCC - Type B Home').getRecordTypeId();
        insert programRecord;

        CLQ_Program_Transaction__c PTrecord = new CLQ_Program_Transaction__c(CLQ_Transaction_Assigned_To__c =
            UserInfo.getUserid(),
            CLQ_Program__c = programrecord.id);
        insert PTrecord;

        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User usr = new User(LastName = 'LIVESTON',
            FirstName = 'JASON',
            Alias = 'jliv',
            Email = 'jason.liveston@asdf.com',
            Username = 'jason.liveston@abcdefg09823420980.com',
            ProfileId = profileId.id,
            TimeZoneSidKey = 'GMT',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'en_US'
        );
        insert usr;

        Task task = new Task(status = 'In Progress', whatid = PTrecord.id, ownerId = usr.Id);
        
        //Bypass the trigger
        CLQ_Tasktriggerhandler.BypassTrigger = true;
        
        insert task;

        //Now verify that the Program Transaction assigned to has NOT been changed

        CLQ_Program_Transaction__c UpdatedPTrecord = [SELECT CLQ_Transaction_Assigned_To__c
            FROM CLQ_Program_Transaction__c WHERE Id =: PTrecord.Id];
        system.AssertEquals(UserInfo.getUserid(), UpdatedPTrecord.CLQ_Transaction_Assigned_To__c);

    }

}