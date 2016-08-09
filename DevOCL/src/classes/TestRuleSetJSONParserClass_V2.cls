@isTest
public class TestRuleSetJSONParserClass_V2 {
        public static RuleSet_Catalog__c setCatalogData(){
        RuleSet_Catalog__c catalog = new RuleSet_Catalog__c();
        catalog.Name__c = 'Test Catalog';
        catalog.Active_Class__c = 'Not Available';
        catalog.Active_Version__c = 'Not Available';
        insert catalog;
        return catalog;
    }
    public static Active_Rule__c setCustomSetting(){
        Active_Rule__c myrule = new Active_Rule__c();
        myrule.Class_Name__c = 'Not Available';
        myrule.Name = 'Test Catalog';
        insert myrule;
        return myrule;
    }
    
    public static List<RuleConditions_V2> setConditions(){
        RuleConditions_V2 singleCondition = new RuleConditions_V2();
        singleCondition.writableField = true;
        singleCondition.Status = null;
        singleCondition.ParentFieldName = 'None';
        singleCondition.multiParentField = False;
        singleCondition.Identifier = 'C1';
        singleCondition.FieldType = 'INTEGER';
        singleCondition.Value = '> 10';
        singleCondition.FieldName = 'numberofemployees';
        singleCondition.ConditionPretty = 'numberofemployees > 10';
        singleCondition.ConditionOperator = null;
        return new List<RuleConditions_V2>{singleCondition};
    }
    
    public static List<RuleConditions_V2> setComplicatedConditions(){
        List<RuleConditions_V2> conditionList = new List <RuleConditions_V2>();
        RuleConditions_V2 singleCondition = new RuleConditions_V2();
        singleCondition.writableField = true;
        singleCondition.Status = null;
        singleCondition.ParentFieldName = 'None';
        singleCondition.multiParentField = False;
        singleCondition.Identifier = 'C1';
        singleCondition.FieldType = 'STRING';
        singleCondition.Value = 'ISCHANGED{\'Pending\':\'Generate Fee\'}';
        singleCondition.FieldName = 'AccountNumber';
        conditionList.add(singleCondition);
        singleCondition = new RuleConditions_V2();
        singleCondition.writableField = true;
        singleCondition.Status = null;
        singleCondition.ParentFieldName = 'None';
        singleCondition.multiParentField = False;
        singleCondition.Identifier = 'C2';
        singleCondition.FieldType = 'STRING';
        singleCondition.Value = 'ISCHANGED';
        singleCondition.FieldName = 'AccountNumber';
        conditionList.add(singleCondition);
        singleCondition = new RuleConditions_V2();
        singleCondition.writableField = true;
        singleCondition.Status = null;
        singleCondition.ParentFieldName = 'None';
        singleCondition.multiParentField = False;
        singleCondition.Identifier = 'C3';
        singleCondition.FieldType = 'STRING';
        singleCondition.Value = 'NOTCHANGED';
        singleCondition.FieldName = 'AccountNumber';
        conditionList.add(singleCondition);
        singleCondition = new RuleConditions_V2();
        singleCondition.writableField = true;
        singleCondition.Status = null;
        singleCondition.ParentFieldName = 'None';
        singleCondition.multiParentField = False;
        singleCondition.Identifier = 'C4';
        singleCondition.FieldType = 'STRING';
        singleCondition.Value = 'CONTAINS(\'VALUE\')';
        singleCondition.FieldName = 'AccountNumber';
        conditionList.add(singleCondition);
        return conditionList;
    }
    
    public static List<RuleActions> setActions(){
        RuleActions action1 = new RuleActions();
        action1.Value = 'System.today()';
        action1.Type = 'Add Record';
        action1.resultObject = 'RuleSet_Catalog__c';
        action1.OrderNumber = null;
        action1.Identifier = 'A1';
        action1.Field = 'effective_start_date__c';
        action1.ActionPretty = 'Add Record\nRuleSet_Catalog__c\neffective_start_date__c\nSystem.today()';
        RuleActions action2 = new RuleActions();
        action2.Value = 'System.today()+1';
        action2.Type = 'Add Record';
        action2.resultObject = 'RuleSet_Catalog__c';
        action2.OrderNumber = null;
        action2.Identifier = 'A2';
        action2.Field = 'effective_start_date__c';
        action2.ActionPretty = 'Add Record\nRuleSet_Catalog__c\neffective_start_date__c\nSystem.today()+1';
        return new List<RuleActions>{action1,action2};
    }
    public static RuleSetTemplate setRules(){
        RuleTemplate rule1 = new RuleTemplate();
        rule1.Name = 'TestRule1';
        rule1.ConditionMap.put('C1', True);
        rule1.ActionOrder.put('A1','1');
        rule1.ActionOrder.put('A2','');
        rule1.ActionMap.put('A1', true);
        rule1.ActionMap.put('A2', false);
        RuleTemplate rule2 = new RuleTemplate();
        rule2.Name = 'TestRule2';
        rule2.ConditionMap.put('C1', True);
        rule2.ActionOrder.put('A2','1');
        rule2.ActionOrder.put('A1','');
        rule2.ActionMap.put('A2', true);
        rule2.ActionMap.put('A1', false);
        RulesetContext RuleSet_Context = new RulesetContext();
        RuleSet_Context.RuleSetName = 'Test Catalog';
        RuleSet_Context.EffectiveStartDate = System.today();
        RuleSet_Context.EffectiveEndDate = System.today()+2;
        RuleSet_Context.RelatedObjectName = 'Account';
        RuleSet_Context.RuleExecution = 'All';
        RuleSet_Context.RuleVersion = 'V001';
        RuleSetTemplate RuleSet_Template = new RuleSetTemplate();
        RuleSet_Template.Context = RuleSet_Context;
        RuleSet_Template.Rules = new List<RuleTemplate>{rule1,rule2};
        return RuleSet_Template;
    }
    public static testMethod void testRuleSetJSONParserCompile(){
        RuleSet_Catalog__c Catalog = setCatalogData();
        RuleSet__c ruleset = new RuleSet__c();
        ruleset.RuleSet_Name__c = Catalog.Name__c;
        ruleset.Effective_Start_Date__c = System.today();
        ruleset.Effective_End_Date__c = System.today().addYears(1);
        ruleset.Catalog_ID__c = Catalog.Id;
        ruleset.Rules_Execution__c = 'All';
        ruleset.Condition_List__c = JSON.serialize(setConditions());
        ruleset.Action_List__c = JSON.serialize(setActions());
        ruleset.Rule_Definition__c = JSON.serialize(setRules());
        insert ruleset;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RulesMockHTTPResponseGenerator_JSON());
        Boolean status = RuleSetJSONParserClass_V2.compileClass(null);  // Null Ruleset
       	status = RuleSetJSONParserClass_V2.compileClass(ruleset.Id);
        ruleset.Status__c = 'Compiled';
        ruleset.Class_Name__c = 'TestRuleSetJSONParserClass_V2';
        ruleset.Test_Class_Name__c = 'TestRuleSetJSONParserClass_V2';
        Test.setMock(HttpCalloutMock.class, new RulesMockHTTPResponseGenerator_JSON());
       	status = RuleSetJSONParserClass_V2.compileClass(ruleset.Id);
        Test.stopTest();
    }
    public static testMethod void testRuleSetJSONParserReCompile(){
        RuleSet_Catalog__c Catalog = setCatalogData();
        RuleSet__c ruleset = new RuleSet__c();
        ruleset.RuleSet_Name__c = Catalog.Name__c;
        ruleset.Effective_Start_Date__c = System.today();
        ruleset.Effective_End_Date__c = System.today().addYears(1);
        ruleset.Catalog_ID__c = Catalog.Id;
        ruleset.Rules_Execution__c = 'All';
        ruleset.Condition_List__c = JSON.serialize(setConditions());
        ruleset.Action_List__c = JSON.serialize(setActions());
        ruleset.Rule_Definition__c = JSON.serialize(setRules());
        ruleset.Status__c = 'Compiled';
        ruleset.Class_Name__c = 'TestRuleSetJSONParserClass_V2';
        ruleset.Test_Class_Name__c = 'TestRuleSetJSONParserClass_V2';
        insert ruleset;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RulesMockHTTPResponseGenerator_JSON());
        Boolean status = RuleSetJSONParserClass_V2.compileClass(ruleset.Id);
        Test.stopTest();
    }
    
    public static testMethod void testgetDummyFieldValues(){
        RuleSet__c testObj = new RuleSet__c();
        String result = RuleSetJSONParserClass_V2.getDummyFieldValues('RuleSet__c', 'Active__c', 'Boolean', false); // Boolean
        result = RuleSetJSONParserClass_V2.getDummyFieldValues('RuleSet__c', 'Active__c', 'Boolean', true); 
        result = RuleSetJSONParserClass_V2.getDummyFieldValues('RuleSet__c', 'Status__c', 'Picklist', false); // Picklist
        result = RuleSetJSONParserClass_V2.getDummyFieldValues('RuleSet__c', 'Status__c', 'Picklist', true); 
        result = RuleSetJSONParserClass_V2.getDummyFieldValues('RuleSet__c', 'Metadata_Container_UniqueId__c', 'Integer', false); // Picklist
        result = RuleSetJSONParserClass_V2.getDummyFieldValues('RuleSet__c', 'Metadata_Container_UniqueId__c', 'Integer', true);
        result = RuleSetJSONParserClass_V2.getDummyFieldValues('RuleSet__c', 'Effective_End_Date__c', 'Date', false); // Date
        result = RuleSetJSONParserClass_V2.getDummyFieldValues('RuleSet__c', 'Effective_End_Date__c', 'Date', true); 
        result = RuleSetJSONParserClass_V2.getDummyFieldValues('RuleSet__c', 'Effective_End_Date__c', 'DateTime', false); // DateTime
        result = RuleSetJSONParserClass_V2.getDummyFieldValues('RuleSet__c', 'Effective_End_Date__c', 'DateTime', true); 
        result = RuleSetJSONParserClass_V2.getDummyFieldValues('RuleSet__c', 'Effective_End_Date__c', 'Dummy', false);
    }
    
    public static testMethod void testUpdateTestClass(){
        RuleSet_Catalog__c Catalog = setCatalogData();
        RuleSet__c ruleset = new RuleSet__c();
        ruleset.RuleSet_Name__c = Catalog.Name__c;
        ruleset.Effective_Start_Date__c = System.today();
        ruleset.Effective_End_Date__c = System.today().addYears(1);
        ruleset.Catalog_ID__c = Catalog.Id;
        ruleset.Rules_Execution__c = 'All';
        ruleset.Condition_List__c = JSON.serialize(setConditions());
        ruleset.Action_List__c = JSON.serialize(setActions());
        ruleset.Rule_Definition__c = JSON.serialize(setRules());
        insert ruleset;
        ruleset.Test_Class_Body__c = 'public class mytestclass{}';
        ruleset.Test_Class_Name__c = 'TestRuleSetJSONParserClass_V2';
        ruleset.Metadata_Container_UniqueId__c = 0;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RulesMockHTTPResponseGenerator_JSON());
        ruleset = RuleSetJSONParserClass_V2.updateTestClass(ruleset);
        Test.stopTest();
    }
    public static testMethod void testAsyncStatus(){
        RuleSet__c testObj = new RuleSet__c();
        testObj.AsyncRequestID__c = '1dr350000007vuPAAQ';
        testObj.TestClassAsyncRequestID__c = '1dr350000007vuPAAQ';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RulesMockHTTPResponseGenerator_JSON());
        testObj = RuleSetJSONParserClass_V2.getAsyncStatus(testObj);
        testObj = RuleSetJSONParserClass_V2.getTestClassAsyncStatus(testObj);
        Test.stopTest();
    }
    public static testMethod void testRuleSetJSONParserComplexCompile(){
        RuleSet_Catalog__c Catalog = setCatalogData();
        RuleSet__c ruleset = new RuleSet__c();
        ruleset.RuleSet_Name__c = Catalog.Name__c;
        ruleset.Effective_Start_Date__c = System.today();
        ruleset.Effective_End_Date__c = System.today().addYears(1);
        ruleset.Catalog_ID__c = Catalog.Id;
        ruleset.Rules_Execution__c = 'All';
        ruleset.Condition_List__c = JSON.serialize(setComplicatedConditions());
        ruleset.Action_List__c = JSON.serialize(setActions());
        ruleset.Rule_Definition__c = JSON.serialize(setRules());
        insert ruleset;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RulesMockHTTPResponseGenerator_JSON());
        Boolean status = RuleSetJSONParserClass_V2.compileClass(null);  // Null Ruleset
       	status = RuleSetJSONParserClass_V2.compileClass(ruleset.Id);
        ruleset.Status__c = 'Compiled';
        ruleset.Class_Name__c = 'TestRuleSetJSONParserClass_V2';
        ruleset.Test_Class_Name__c = 'TestRuleSetJSONParserClass_V2';
        Test.setMock(HttpCalloutMock.class, new RulesMockHTTPResponseGenerator_JSON());
       	status = RuleSetJSONParserClass_V2.compileClass(ruleset.Id);
        Test.stopTest();
    }
    public static testMethod void testgetConditionValue(){
        String result = RuleSetJSONParserClass_V2.getConditionValue('==');
        result = RuleSetJSONParserClass_V2.getConditionValue('!=');
        result = RuleSetJSONParserClass_V2.getConditionValue('>=');
        result = RuleSetJSONParserClass_V2.getConditionValue('<=');
        result = RuleSetJSONParserClass_V2.getConditionValue('>');
        result = RuleSetJSONParserClass_V2.getConditionValue('<');
    }
    
    public static testMethod void testcompileClassErrors(){
        RuleSet_Catalog__c Catalog = setCatalogData();
        RuleSet__c ruleset = new RuleSet__c();
        ruleset.RuleSet_Name__c = Catalog.Name__c;
        ruleset.Effective_Start_Date__c = System.today();
        ruleset.Effective_End_Date__c = System.today().addYears(1);
        ruleset.Catalog_ID__c = Catalog.Id;
        ruleset.Rules_Execution__c = 'All';
        ruleset.Condition_List__c = JSON.serialize(setComplicatedConditions());
        ruleset.Action_List__c = JSON.serialize(setActions());
        ruleset.Rule_Definition__c = 'JSON.serialize(setRules())';
        insert ruleset;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RulesMockHTTPResponseGenerator_JSON());
       	Boolean status = RuleSetJSONParserClass_V2.compileClass(ruleset.Id);
        ruleset.Rule_Definition__c = null;
        upsert ruleset;
        status = RuleSetJSONParserClass_V2.compileClass(ruleset.Id);
        ruleset.Rule_Definition__c = JSON.serialize(setRules());
        ruleset.Condition_List__c = 'JSON.serialize(setComplicatedConditions())';
        upsert ruleset;
        status = RuleSetJSONParserClass_V2.compileClass(ruleset.Id);
        ruleset.Condition_List__c = null;
        upsert ruleset;
        status = RuleSetJSONParserClass_V2.compileClass(ruleset.Id);
        
        ruleset.Condition_List__c = JSON.serialize(setComplicatedConditions());
        ruleset.Action_List__c = 'JSON.serialize(setActions())';
        upsert ruleset;
        status = RuleSetJSONParserClass_V2.compileClass(ruleset.Id);
        ruleset.Action_List__c = null;
        upsert ruleset;
        status = RuleSetJSONParserClass_V2.compileClass(ruleset.Id);
        Test.stopTest();
    }
}