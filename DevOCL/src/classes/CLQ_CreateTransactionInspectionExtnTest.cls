/* Name : CLQ_CreateTransactionInspectionExtnTest
* Description : This class/extension contains all test methods for CLQ_CreateTransactionInspectionExtn class. 
**/
@isTest
private class CLQ_CreateTransactionInspectionExtnTest {
	
	@isTest static void test_method_one() {
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
                
        //Create Room Space record
        CLQ_Room_Space__c roomSpace = new CLQ_Room_Space__c();
        roomSpace.CLQ_Program__c = programRecord.id;
        roomSpace.CLQ_Number_of_Children_Under_2__c = 2;
        roomSpace.CLQ_Used_By_Under_or_Over_2__c = 'Both';
        insert roomSpace;

        //Create Program Transaction record
        CLQ_Program_Transaction__c txRecord = new CLQ_Program_Transaction__c();
        txRecord.CLQ_Program__c = programRecord.id;
        txRecord.RecordTypeid = Schema.SObjectType.CLQ_Program_Transaction__c.getRecordTypeInfosByName().get('Amendment - Change of Capacity / Space').getRecordTypeId();
        txRecord.CLQ_Transaction_Assigned_To__c = UserInfo.getUserId();
        insert txRecord;

        Test.startTest();
        PageReference pageRef = Page.CLQ_CreateTransactionInspection;
        pageRef.getParameters().put('id',txRecord.id);

        //Set the current page
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(txRecord);
        CLQ_CreateTransactionInspectionExtn extensionObject = new CLQ_CreateTransactionInspectionExtn(controller);
        extensionObject.programTransactionRecord = [SELECT id
                                                        ,CLQ_Program__r.Recordtypeid
                                                        ,CLQ_Transaction_Assigned_To__c
                                                        ,CLQ_Program__r.Id
                                                        ,CLQ_Program_Transaction__c.RecordTypeId
                                                FROM CLQ_Program_Transaction__c
                                                WHERE id = :txRecord.id];
        extensionObject.onLoad();
        extensionObject.onOK();
        Test.stopTest();
	}
	
}