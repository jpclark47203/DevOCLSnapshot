/* Name : CLQ_CreateProgramInspectionExtnTest
* Developer Name : Vrajesh Sheth
* Date : 07/19/2016
* Email : vsheth@incapsulate.com
* Description : This class/extension contains all test methods for CLQ_CreateProgramInspectionExtn class. 
* V1 - Date: 07/19/2016 - Started development

**/
@isTest
private class CLQ_CreateProgramInspectionExtnTest {
	
	@isTest static void testAllMethods() {
		// Implement test code
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
        programRecord.CLQ_Program_Status__c = 'Open';
        programRecord.CLQ_License_Registration_Status__c = 'Licensed';
        programRecord.CLQ_License_Type__c = 'Continuous';
        programRecord.CLQ_License_Issue_Date__c = Date.today();
        programRecord.CLQ_First_Inspection_Due__c = Date.today().adddays(20);
        insert programRecord ;

        //Create Room Space record
        CLQ_Room_Space__c roomSpace = new CLQ_Room_Space__c();
        roomSpace.CLQ_Program__c = programRecord.id;
        roomSpace.CLQ_Number_of_Children_Under_2__c = 2;
        roomSpace.CLQ_Used_By_Under_or_Over_2__c = 'Both';
        insert roomSpace;

        Test.startTest();
        PageReference pageRef = Page.CLQ_CreateProgramInspection;
        pageRef.getParameters().put('id',programRecord.id);

        //Set the current page
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(programRecord);
        CLQ_CreateProgramInspectionExtn extensionObject = new CLQ_CreateProgramInspectionExtn(controller);
        extensionObject.programRecord = [SELECT id
        								,CLQ_Assigned_Reviewer__c
        								,CLQ_License_Registration_Status__c
        								,CLQ_Program_Status__c
        								,CLQ_License_Type__c
        								FROM CLQ_Program__c
        								WHERE id =:programRecord.id];

        extensionObject.onLoad();
        extensionObject.onOK();
        Test.stopTest();
	}
	
	
}