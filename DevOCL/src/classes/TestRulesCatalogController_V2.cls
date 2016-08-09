@isTest
public class TestRulesCatalogController_V2 {
    public static  testmethod void TestRulesCatalogController (){
        RuleSet_Catalog__c Catalog = new RuleSet_Catalog__c();
        Catalog.Name__c = 'Test Catalog 1';
        insert Catalog;
        PageReference ref = Page.RulesCatalogPage_V2;
        Test.setCurrentPage(ref);
        RulesCatalogController_V2 rcontroller = new RulesCatalogController_V2();
        
        Catalog = new RuleSet_Catalog__c();
        Catalog.Name__c = 'Test Catalog 2';
        rcontroller.Catalog = Catalog;
        ref = rcontroller.saveNewCatalog();
        
        Catalog = new RuleSet_Catalog__c();
        Catalog.Name__c = 'Test Catalog 3';
        insert Catalog;
        Active_Rule__c myrule = new Active_Rule__c();
        myrule.Name = Catalog.Name__c;
        insert myrule;
        rcontroller.catalogidToDel = Catalog.Id;
        ref = rcontroller.deleteCatalog();
        
        Catalog = new RuleSet_Catalog__c();
        Catalog.Name__c = 'Test Catalog 4';
        insert Catalog;
        myrule = new Active_Rule__c();
        myrule.Name = Catalog.Name__c;
        insert myrule;
        Ruleset__c  ruleset = new Ruleset__c();
        ruleset.RuleSet_Name__c = 'Child Ruleset';
        ruleset.Catalog_ID__c = catalog.Id;
        ruleset.Active__c = true;
        insert ruleset;
        rcontroller.catalogidToDel = Catalog.Id;
        ref = rcontroller.deleteCatalog();
        
        Catalog = new RuleSet_Catalog__c();
        rcontroller.Catalog = Catalog;
        ref = rcontroller.saveNewCatalog();
    }
}