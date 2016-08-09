@isTest
public class TestRuleSetHomeController_V2 {
    public static testmethod void testRuleSetHomeController(){
        PageReference ref = Page.RulesHomePage_V2;
        Test.setCurrentPage(ref);
        RuleSetHomeController_V2 rcontroller = new RuleSetHomeController_V2();
        ref = rcontroller.redirectCatalog();
        
        Ruleset_Catalog__c catalog = new RuleSet_Catalog__c();
        catalog.Name__c = 'Test Catalog';
        catalog.Active_Class__c = 'Not Available';
        catalog.Active_Version__c = 'Not Available';
        insert catalog;
        Ruleset__c ruleset = new Ruleset__c();
        ruleset.Catalog_ID__c = Catalog.id;
        ruleset.RuleSet_Name__c = catalog.Name__c;
        insert ruleset;
        Active_Rule__c myrule = new Active_Rule__c();
        myrule.Name = Catalog.Name__c;
        insert myrule;
        
        ApexPages.currentPage().getParameters().put('id', catalog.Id);
        ref = rcontroller.redirectCatalog();
        
        ref = rcontroller.updateCatalog();
        
        rcontroller.rsidToDel = ruleset.Id;
        ref = rcontroller.cloneRuleSet();
        ruleset.Class_Name__c =  'TestRuleSetHomeController_V2';
        update ruleset;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RulesMockHTTPResponseGenerator());
        Test.stopTest();
        ref = rcontroller.deleteRuleSet();
        
        ref = rcontroller.navigateToHome();
        
        ruleset = new Ruleset__c();
        ruleset.Catalog_ID__c = Catalog.id;
        ruleset.RuleSet_Name__c = catalog.Name__c;
        ruleset.Active__c = true;
        insert ruleset;
        rcontroller.rsidToDel = ruleset.Id;
        ref = rcontroller.deleteRuleSet();
        
        rcontroller.rsidToDel = null;
        ref = rcontroller.deleteRuleSet();
        
        ruleset = new Ruleset__c();
        ruleset.Class_Name__c = 'Not Available';
        ruleset.Catalog_ID__c = catalog.id;
        insert ruleset;
        Test.setMock(HttpCalloutMock.class, new RulesMockHTTPResponseGenerator());
        rcontroller.rsidToDel = ruleset.Id;
        ref = rcontroller.deleteRuleSet();
    }
}