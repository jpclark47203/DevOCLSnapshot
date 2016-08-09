@isTest
public class TestRuleSetController_V2 {
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
    public static List<RuleTemplate> setRules(){
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
        return new List<RuleTemplate>{rule1,rule2};
    }    

    public static testMethod void TestNewRulesetFlow(){
        PageReference ref = Page.CreateRuleSet_V2;
        Test.setCurrentPage(ref);
        RuleSetController_V2 rcontroller = new RuleSetController_V2();		// Create Controller Instance
        // Invoke without setting any params
        Pagereference pr = rcontroller.redirectNewRuleset();
        PageReference actual = new Pagereference('/apex/RulesCatalogPage_V2');
        System.assertEquals(pr.getUrl(), actual.getUrl());
        // Invoke with Catalog ID Set - This is equal to creating a new Ruleset version in a Catalog 
        RuleSet_Catalog__c catalog = setCatalogData();
        Active_Rule__c myrule = setCustomSetting();
        String Fields = TestRulesUtilityClass.getFields(catalog.Id);
        catalog = Database.query('SELECT '+ fields+' FROM RuleSet_Catalog__c WHERE Id=\''+Catalog.Id+'\'');
        ApexPages.currentPage().getParameters().put('Catalogid', catalog.Id);
        rcontroller = new RuleSetController_V2();
        rcontroller.redirectNewRuleset();
        rcontroller.ruleset.Catalog_ID__c = catalog.Id;
        rcontroller.ruleset.RuleSet_Name__c = catalog.Name__c;
        rcontroller.ruleset.Effective_Start_Date__c = system.today();
        rcontroller.ruleset.Effective_End_Date__c = system.today().addyears(1);
        //First Check error condition for required fields - Input Oject is not set
        rcontroller.CreateOrUpdateRuleSet();
        rcontroller.selectedsObject = 'Account';
        // Now check the Valid condition for inserting a new ruleset
        rcontroller.CreateOrUpdateRuleSet();
        // Add 2  empty Rule conditions
        rcontroller.AddCondition();
        rcontroller.AddCondition();
        System.assertEquals(2, rcontroller.conditionList.size());
        // Now delete the first condition
        rcontroller.conditionIndex = '0';
        rcontroller.DeleteCondition();
        System.assertEquals(1, rcontroller.conditionList.size());
        //Before trying to save conditions configure some real condition 
        rcontroller.ConditionList =  setConditions();
        rcontroller.saveConditions();
        System.assertEquals(1, rcontroller.conditionList.size());
        // Add 2 empty Rule Actions
        rcontroller.AddAction();
        rcontroller.AddAction();
        System.assertEquals(2, rcontroller.actionList.size());
        // Now delete the first action
        rcontroller.actionIndex = '0';
        rcontroller.DeleteAction();
        System.assertEquals(1, rcontroller.actionList.size());
        //Before trying to save actions configure some real action
        rcontroller.actionList =  setActions();
        rcontroller.saveActions();
        System.assertEquals(2, rcontroller.actionList.size());
        //Add 2 new empty Rules
        rcontroller.AddNewRule();
        rcontroller.AddNewRule();
        System.assertEquals(2, rcontroller.ruleList.size());
        //Now delete one rule
        rcontroller.Index = '0';
        rcontroller.removeRule();
        System.assertEquals(1, rcontroller.ruleList.size());
        //Configure 2 working rules for testing 
        rcontroller.ruleList = setRules();
        rcontroller.SaveRules();
        System.assertEquals(2, rcontroller.ruleList.size());
        //Test Compile part 
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new RulesMockHTTPResponseGenerator());
       	rcontroller.CompileRuleSet();
        rcontroller.updateClassStatus();
        rcontroller.updateTestClassStatus();
        Test.stopTest();
        //Activate the rule - Change the status so that it will look like the class is really compiled
        rcontroller.ruleset.Status__c = 'Compiled';
        rcontroller.ruleset.Class_Name__c = Catalog.Name__c;
        rcontroller.ActivateRule();
        //Now try to de-activate the ruleset
        rcontroller.ActivateRule();
    }
    
    public static testMethod void TestEditRulesetFlow(){
        PageReference ref = Page.CreateRuleSet_V2;
        Test.setCurrentPage(ref);
        RuleSet_Catalog__c catalog = setCatalogData();
        Active_Rule__c myrule = setCustomSetting();
        String Fields = TestRulesUtilityClass.getFields(catalog.Id);
        catalog = Database.query('SELECT '+ fields+' FROM RuleSet_Catalog__c WHERE Id=\''+Catalog.Id+'\'');
        Ruleset__c ruleset =  new Ruleset__c();
        ruleset.RuleSet_Name__c = Catalog.Name__c;
        ruleset.Catalog_ID__c = Catalog.id;
        ruleset.Condition_List__c = JSON.serialize(setConditions());
        ruleset.Action_List__c = JSON.serialize(setActions());
        RulesetContext RuleSet_Context = new RulesetContext();
        RuleSet_Context.RuleSetName = ruleset.RuleSet_Name__c;
        RuleSet_Context.EffectiveStartDate = System.today();
        RuleSet_Context.EffectiveEndDate = System.today()+2;
        RuleSet_Context.RelatedObjectName = 'Account';
        RuleSet_Context.RuleExecution = ruleset.Rules_Execution__c;
        RuleSet_Context.RuleVersion = ruleset.Version__c;
        RuleSetTemplate RuleSet_Template = new RuleSetTemplate();
        RuleSet_Template.Context = RuleSet_Context;
        RuleSet_Template.Rules = setRules();
        ruleset.Rule_Definition__c = JSON.serialize(RuleSet_Template);
        insert ruleset;
        ApexPages.currentPage().getParameters().put('Id', ruleset.Id);
        RuleSetController_V2 rcontroller = new RuleSetController_V2();
        Pagereference pr = rcontroller.redirectNewRuleset();
    }
    
    public static testMethod void TestNavigationFlow(){
        PageReference ref = Page.CreateRuleSet_V2;
        Test.setCurrentPage(ref);
        RuleSetController_V2 rcontroller = new RuleSetController_V2();
        PageReference expected;
        PageReference actual;
        RuleSet_Catalog__c catalog = setCatalogData();
        RuleSet__c ruleset = new RuleSet__c();
        ruleset.Catalog_ID__c = catalog.id;
        insert ruleset;
        rcontroller.ruleset = ruleset;
        actual = new PageReference('/apex/RulesHomePage_V2?id='+ruleset.Catalog_ID__c);
        expected = rcontroller.navigateToHome();
        System.assertEquals(expected.getUrl(), actual.getUrl());
        expected = rcontroller.navigateToConditionPage();
        System.assertEquals(expected, null);
        expected = rcontroller.navigateToActionPage();
        System.assertEquals(expected, null);
        expected = rcontroller.navigateToRulePanel();
        System.assertEquals(expected, null);
        expected = rcontroller.navigateToRulePanelBack();
        System.assertEquals(expected, null);
        expected = rcontroller.navigateToContextPage();
        System.assertEquals(expected, null);     
    }
    
    public static testMethod void testRulesetController4(){
        Ruleset_catalog__c catalog = setCatalogData();
        Ruleset__c ruleset = new Ruleset__c();
        ruleset.Catalog_ID__c = catalog.Id;
        ruleset.Status__c = 'Draft';
        ruleset.Condition_List__c = 'Not Available';
        ruleset.Action_List__c = 'Not Available';
        ruleset.Rule_Definition__c = 'Not Available';
        insert ruleset;
        ApexPages.currentPage().getParameters().put('id', ruleset.Id);
        RuleSetController_V2 rcontroller = new RuleSetController_V2();
        rcontroller.redirectNewRuleset();
    }
    
    public static testMethod void testRuleActions(){
        List<RuleActions> actionList = new List<RuleActions>();
        RuleActions action = new RuleActions();
        action.Identifier = 'A1';
        action.OrderNumber = '11';
        actionList.add(action);
        action = new RuleActions();
        action.Identifier = 'A2';
        action.OrderNumber = '1';
        actionList.add(action);
        actionList.sort();
        System.assertEquals('1', actionList[0].OrderNumber);
    }

}