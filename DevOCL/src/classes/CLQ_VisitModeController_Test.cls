@isTest
private class CLQ_VisitModeController_Test {
	
	@isTest static void test_method_one() {
	
        CLQ_Inspection__c inspectionrecord = prepareData();
        CLQ_Rules_Inspected__c ruleInspected = [SELECT id,CLQ_Rule__c FROM CLQ_Rules_Inspected__c Limit 1];
        Test.startTest();
        PageReference pageRef = Page.CLQ_VisitMode;
        pageRef.getParameters().put('id',inspectionrecord.id); 
        pageRef.getParameters().put('selectedInspectedRule',ruleInspected.id); 
        pageRef.getParameters().put('selectedRule',ruleInspected.CLQ_Rule__c); 
        //Set the current page
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(inspectionrecord);
        CLQ_VisitModeController extensionObject = new CLQ_VisitModeController(controller);
        
        extensionObject.onLoad();
        extensionObject.onSearch();
        extensionObject.domainfiltervalue = 'Staff Files (FT)';	
        extensionObject.filtervalue = 'Not Assessed';								
        extensionObject.onSearch();

        extensionObject.onCancel();
        extensionObject.updateFindingDescription();
        
        extensionObject.popupOnLoad();
        extensionObject.closePopUp();
        extensionObject.savePopUp();
        extensionObject.onSaveandClose();
        Test.stopTest();
	}

        @isTest static void test_markAllCompliant() {
        
        CLQ_Inspection__c inspectionrecord = prepareData();
        CLQ_Rules_Inspected__c ruleInspected = [SELECT id,CLQ_Rule__c FROM CLQ_Rules_Inspected__c Limit 1];
        Test.startTest();
        PageReference pageRef = Page.CLQ_VisitMode;
        pageRef.getParameters().put('id',inspectionrecord.id); 
        pageRef.getParameters().put('selectedInspectedRule',ruleInspected.id); 
        pageRef.getParameters().put('selectedRule',ruleInspected.CLQ_Rule__c); 
        //Set the current page
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(inspectionrecord);
        CLQ_VisitModeController extensionObject = new CLQ_VisitModeController(controller);
        
        extensionObject.onLoad();
        extensionObject.onSearch();
        extensionObject.domainfiltervalue = 'Staff Files (FT)'; 
        extensionObject.filtervalue = 'Not Assessed';                                                           
        extensionObject.markAllCompliant();

        extensionObject.onCancel();
        extensionObject.updateFindingDescription();
        
        extensionObject.popupOnLoad();
        extensionObject.closePopUp();
        extensionObject.savePopUp();
        extensionObject.onSaveandClose();
        Test.stopTest();
        }
	
	public static CLQ_Inspection__c prepareData(){
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
        list<CLQ_Rule__c> ruleList = new list<CLQ_Rule__c>();
        CLQ_Rule__c rule1 = new CLQ_Rule__c(Name='Rule1',CLQ_Domain__c='Staff Files (FT)',CLQ_Rule_Effective_Date__c = (Date.today()).addDays(-10),CLQ_Rule_Expiration_Date__c = (Date.today()).adddays(10),CLQ_Description__c='test');
        ruleList.add(rule1);

        CLQ_Rule__c rule2 = new CLQ_Rule__c(Name='Rule2',CLQ_Domain__c='Staff Files (FT)',CLQ_Rule_Effective_Date__c = (Date.today()).addDays(-10),CLQ_Rule_Expiration_Date__c = (Date.today()).adddays(10),CLQ_Description__c='test');
        ruleList.add(rule2);

        insert ruleList;

        //Create Standard Findings
        list<CLQ_Standard_Findings__c> sfindingList = new list<CLQ_Standard_Findings__c>();
        CLQ_Standard_Findings__c sfinding = new CLQ_Standard_Findings__c(CLQ_Rules__c=rule1.id,Name='test',CLQ_Description__c='test',CLQ_Finding_Code__c='test',CLQ_Risk_Level__c='Serious');
        sfindingList.add(sfinding);
        CLQ_Standard_Findings__c sfinding2 = new CLQ_Standard_Findings__c(CLQ_Rules__c=rule2.id,Name='test2',CLQ_Description__c='test',CLQ_Finding_Code__c='test',CLQ_Risk_Level__c='Serious');
        sfindingList.add(sfinding2);
        insert sfindingList;

        //Create inspection  tool
        CLQ_Inspection_Tools__c inspectionTool = new CLQ_Inspection_Tools__c(name='Full',CLQ_Active__c = true,CLQ_Applicable_To__c='Child Care Center');
        insert inspectionTool;

        //Create tool rules

        CLQ_Tools_Rules__c toolRule = new CLQ_Tools_Rules__c(CLQ_Rules__c = rule1.id,CLQ_Inspection_Tools__c=inspectionTool.id);
        insert toolRule;

        CLQ_Rules_Inspected__c ruleInspected = new CLQ_Rules_Inspected__c(CLQ_Inspection_No__c=inspectionrecord.id,CLQ_Rule__c = rule1.id);
        insert ruleInspected ;

        CLQ_Findings__c finding = new CLQ_Findings__c(CLQ_Rules_Inspected__c=ruleInspected.id,CLQ_Standard_Finding__c=sfinding.id,CLQ_Description__c = 'test');
        insert finding;
        return inspectionrecord;
        }
	
}