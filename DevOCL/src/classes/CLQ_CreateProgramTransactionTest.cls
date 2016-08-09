/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 */
@isTest
private class CLQ_CreateProgramTransactionTest {

    static testMethod void BasicCreationTest() {

        CLQ_OCLQS_Configuration__c configRecord = new CLQ_OCLQS_Configuration__c(Name = 'FCC - Type B Home');
        insert configRecord;

        //Create account record
        Account accountrecord = new Account(Name = 'Test Account', CLQ_DIRN__c = '1234');
        insert accountrecord;

        //Insert contact
        Contact contactrecord = new Contact(Firstname = 'test', lastName = 'Test', Accountid = accountrecord.id);
        insert contactrecord;

        //Create a program record
        CLQ_Program__c programRecord = new CLQ_Program__c();
        programRecord.Name = 'Test';
        programRecord.CLQ_Associated_Organization__c = accountrecord.id;
        programRecord.CLQ_Street_Address_1__c = 'test';
        programRecord.recordTypeid = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get(
            'FCC - Type B Home').getRecordTypeId();
        programRecord.CLQ_Licensing_Specialist__c = UserInfo.getUserid();
        insert programRecord;

        //Create Room Space record
        CLQ_Room_Space__c roomSpace = new CLQ_Room_Space__c();
        roomSpace.CLQ_Program__c = programRecord.id;
        roomSpace.CLQ_Number_of_Children_Under_2__c = 2;
        roomSpace.CLQ_Used_By_Under_or_Over_2__c = 'Both';
        insert roomSpace;

        //Create Program Transaction record
        CLQ_Program_Transaction__c ProgramTransaction = new CLQ_Program_Transaction__c();
        ProgramTransaction.RecordTypeid = Schema.SObjectType.CLQ_Program_Transaction__c.getRecordTypeInfosByName().get(
            'Amendment - Change of Capacity / Space').getRecordTypeId();
        ProgramTransaction.CLQ_Transaction_Assigned_To__c = UserInfo.getUserId();

        try {
            insert ProgramTransaction;
            System.Assert(false, 'An Exception should have occurred for a missing Program Value');
        } catch (Exception exc) {
        	system.debug('Expected exception: ' + exc.getMessage());
            System.Assert(true, 'An Exception should have occurred for a missing Program Value');
        }
        ProgramTransaction.CLQ_Program__c = programRecord.id;

        ProgramTransaction.CLQ_Transaction_Assigned_To__c = null;

        insert ProgramTransaction;

        string query = CLQ_UtilityClass.createSOQLQuery('CLQ_Program_Transaction__c', ' ID = \'' +
            ProgramTransaction.Id + '\'', null);

        list < CLQ_Program_Transaction__c > Transactions = Database.query(query);
        CLQ_Program_Transaction__c Trans = Transactions[0];
        system.debug('Resulting Program Transaction: ' + Trans);

    }
}