@isTest
public class TestActivateRuleSetController_V2 {
    
    public static testmethod Ruleset_Catalog__c setCatalogData(){
        Ruleset_Catalog__c catalog = new RuleSet_Catalog__c();
        catalog.Name__c = 'Test Catalog';
        catalog.Active_Class__c = 'TestClass';
        catalog.Active_Version__c = 'V-001';
        return catalog;
    }
    
    public static testmethod Ruleset__c setRulesetData(){
        Ruleset__c ruleset = new Ruleset__c();
        ruleset.RuleSet_Name__c = 'Not Available';
        ruleset.Class_Name__c = 'Not Available';
        ruleset.Status__c = 'Compiled';
        ruleset.Active__c = true;
        return ruleset;
    }
    
    public static testmethod Active_Rule__c setCustomSetting(){
        Active_Rule__c myrule = new Active_Rule__c();
        myrule.Name = 'Not Available';
        myrule.Class_Name__c = 'Not Available';
        return myrule;
    }
    
    public static testmethod void testActivateRuleNullsetting(){
        PageReference ref = Page.ActivateRule_V2;
        Test.setCurrentPage(ref);
        ActivateRuleSetController_V2 rcontroller = new ActivateRuleSetController_V2();
        ref = rcontroller.redirectActivatePage();
        Ruleset_Catalog__c catalog = setCatalogData();
        insert catalog;
        Ruleset__c ruleset = setRulesetData();
        ruleset.Catalog_ID__c = Catalog.id;
        insert ruleset;
        ApexPages.currentPage().getParameters().put('id', ruleset.Id);
        ApexPages.currentPage().getParameters().put('Catalogid', catalog.Id);
        ref= rcontroller.redirectActivatePage();
        ref = rcontroller.navigateToHome();
        ref = rcontroller.activateRuleSet(); // Check activating rule - Null custom setting
    }
    
    public static testmethod void testActivateRuleValidsetting(){
        PageReference ref = Page.ActivateRule_V2;
        Test.setCurrentPage(ref);
        ActivateRuleSetController_V2 rcontroller = new ActivateRuleSetController_V2();
        ref = rcontroller.redirectActivatePage();
        Ruleset_Catalog__c catalog = setCatalogData();
        insert catalog;
        Ruleset__c ruleset = setRulesetData();
        ruleset.Catalog_ID__c = Catalog.id;
        insert ruleset;
        Active_Rule__c myrule = setCustomSetting();
        myrule.Name = catalog.Name__c;
        insert myrule;
        ApexPages.currentPage().getParameters().put('id', ruleset.Id);
        ApexPages.currentPage().getParameters().put('Catalogid', catalog.Id);
        ref= rcontroller.redirectActivatePage();
        ref = rcontroller.activateRuleSet(); // Check activating rule - Null custom setting
    }
    
    public static testmethod void testDeActivateRule(){
        PageReference ref = Page.ActivateRule_V2;
        Test.setCurrentPage(ref);
        ActivateRuleSetController_V2 rcontroller = new ActivateRuleSetController_V2();
        ref = rcontroller.redirectActivatePage();
        Ruleset_Catalog__c catalog = setCatalogData();
        insert catalog;
        Ruleset__c ruleset = setRulesetData();
        ruleset.Catalog_ID__c = Catalog.id;
        ruleset.Active__c = False;
        ruleset.Status__c = 'Compiled';
        insert ruleset;
        Active_Rule__c myrule = setCustomSetting();
        myrule.Name = catalog.Name__c;
        insert myrule;
        ApexPages.currentPage().getParameters().put('id', ruleset.Id);
        ApexPages.currentPage().getParameters().put('Catalogid', catalog.Id);
        ref= rcontroller.redirectActivatePage();
        ref = rcontroller.activateRuleSet(); 
    }
    
    public static testmethod void testActivateRuleExistActive(){
        PageReference ref = Page.ActivateRule_V2;
        Test.setCurrentPage(ref);
        ActivateRuleSetController_V2 rcontroller = new ActivateRuleSetController_V2();
        ref = rcontroller.redirectActivatePage();
        Ruleset_Catalog__c catalog = setCatalogData();
        insert catalog;
        Ruleset__c ruleset = setRulesetData();
        ruleset.Catalog_ID__c = Catalog.id;
        ruleset.Active__c = False;
        ruleset.Status__c = 'Compiled';
        insert ruleset;
        Ruleset__c newruleset = setRulesetData();
        newruleset.Active__c = True;
        newruleset.Status__c = 'Compiled';
        newruleset.Catalog_ID__c = Catalog.id;
        insert newruleset;
        rcontroller.ruleset = ruleset;
        Active_Rule__c myrule = setCustomSetting();
        myrule.Name = catalog.Name__c;
        myrule.Class_Name__c = 'Some Class';
        insert myrule;
        ApexPages.currentPage().getParameters().put('id', ruleset.Id);
        ApexPages.currentPage().getParameters().put('Catalogid', catalog.Id);
        ref= rcontroller.redirectActivatePage();
        ref = rcontroller.activateRuleSet(); 
    }

}