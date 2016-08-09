@isTest
public class TestViewRuleSetController_V2 {

    public static testMethod void testViewRuleSetController(){
        PageReference ref = Page.ViewRuleSet_V2;
        Test.setCurrentPage(ref);
        
        RuleSet_Catalog__c catalog = new RuleSet_Catalog__c();
        catalog = new RuleSet_Catalog__c();
        catalog.Name__c = 'Test Catalog';
        catalog.Active_Class__c = 'Not Available';
        catalog.Active_Version__c = 'Not Available';
        insert catalog;
        
        RuleSet__c ruleset = new RuleSet__c();
        ruleset.RuleSet_Name__c = catalog.Name__c;
        ruleset.Catalog_ID__c = catalog.Id;
        ruleset.Status__c = 'Draft';
        ruleset.Effective_Start_Date__c = system.today();
        ruleset.Effective_End_Date__c = system.today().addyears(1);
        ruleset.Rule_Definition__c = '{"Rules":[{"Name":"Test Rule","ConditionMap":{"C1":true},"ActionOrder":{"A1":"1"},"ActionMap":{"A1":true}}],"Context":{"RuleVersion":"V-0129","RuleSetName":"Event Priority","RuleExecution":"All","returnType":"Void","RelatedObjectName":"Event_Request__c","InputObjects":[],"EffectiveStartDate":"2016-03-15","EffectiveEndDate":"2016-07-28"}}';
        ruleset.Condition_List__c = '[{"Value":"== 10","Status":null,"ParentFieldName":"None","Identifier":"C1","FieldName":"number_of_attendee__c","ConditionPretty":"number of attendee == 10"}]';
        ruleset.Action_List__c = '[{"Value":"somename","Type":"Add Record","resultObject":"Test_Action_Object__c","OrderNumber":null,"Identifier":"A1","Field":"name__c","ActionPretty":"somename"}]';
        insert ruleset;
        ApexPages.currentPage().getParameters().put('id', ruleset.Id);
        ViewRuleSetController_V2 rcontroller = new ViewRuleSetController_V2();
        
        PageReference pr = rcontroller.navigateToHome();
        PageReference expected = new PageReference('/apex/RulesHomePage_V2?id='+ruleset.Catalog_ID__c);
       // system.assertEquals(pr, expected);
        pr = rcontroller.navigateToConditionPanel();
        system.assertEquals(null, pr);
        pr = rcontroller.navigateToRulePanel();
        system.assertEquals(null, pr);
        pr = rcontroller.navigateToActionPanel();
        system.assertEquals(null, pr);
        pr = rcontroller.navigateToContextPage();
        system.assertEquals(null, pr);
        pr = rcontroller.navigateToConditionPage();
        system.assertEquals(null, pr);
        
        rcontroller.catalog = new List<RuleSet_Catalog__c>{catalog};
        ruleset.Rule_Definition__c = 'Not available';
        ruleset.Condition_List__c = 'Not available';
        ruleset.Action_List__c = 'Not available';
        update ruleset;
        rcontroller = new ViewRuleSetController_V2();
    }
}