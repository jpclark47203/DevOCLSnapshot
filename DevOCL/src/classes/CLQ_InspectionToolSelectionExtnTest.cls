@isTest
private class CLQ_InspectionToolSelectionExtnTest {
	
	@isTest static void testAllMethods() {
		CLQ_OCLQS_Configuration__c configRecord = new CLQ_OCLQS_Configuration__c(Name = 'Child Care Center');
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
        programRecord.recordTypeid = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get('Child Care Center').getRecordTypeId();
        programRecord.CLQ_Licensing_Specialist__c = UserInfo.getUserid();
        insert programRecord ;
        
       

        //Insert CLQ_Inspection__c 
        CLQ_Inspection__c inspectionrecord = CLQ_UtilityClass.createInspectionrecord('Pre-license', 'Full', 'Pending Processing');
        inspectionrecord.CLQ_Program__c = programRecord.id;
        inspectionrecord.CLQ_Use_Rules_Effective_On__c = Date.today();
        insert inspectionrecord;

        //Create Rules
        CLQ_Rule__c rule1 = new CLQ_Rule__c(Name='Rule1',CLQ_Rule_Effective_Date__c = (Date.today()).addDays(-10),CLQ_Rule_Expiration_Date__c = (Date.today()).adddays(10),CLQ_Description__c='test');
        insert rule1;

        //Create inspection  tool
        CLQ_Inspection_Tools__c inspectionTool = new CLQ_Inspection_Tools__c(name='Full',CLQ_Active__c = true,CLQ_Applicable_To__c='Child Care Center');
        insert inspectionTool;

        //Create tool rules
        CLQ_Tools_Rules__c toolRule = new CLQ_Tools_Rules__c(CLQ_Rules__c = rule1.id,CLQ_Inspection_Tools__c=inspectionTool.id);
        insert toolRule;

        Test.startTest();
        PageReference pageRef = Page.CLQ_InspectionToolSelection;
        pageRef.getParameters().put('id',inspectionrecord.id); 

        //Set the current page
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(inspectionrecord);
        CLQ_InspectionToolSelectionExtn extensionObject = new CLQ_InspectionToolSelectionExtn(controller);
        //
        extensionObject.inspectionRecord = [SELECT id
        									,CLQ_Use_Rules_Effective_On__c
        									,CLQ_Reason_for_Inspection_Tool_Selection__c
        									,CLQ_Scope__c
        									,CLQ_Program__c
        									,CLQ_Program__r.RecordType.Name
        									,CLQ_Program_Transaction__c
        									,CLQ_Program_Transaction__r.CLQ_Program__r.RecordType.Name
        									
        									FROM CLQ_Inspection__c WHERE id = :inspectionrecord.id];
        extensionObject.onLoad();									
        extensionObject.onSave();
        extensionObject.onReturn();
        Test.stopTest();
	}
	
	
	
}