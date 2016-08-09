/************************************************************************
* Name   : ActivateRuleSetController_V2                                 *
* Author : Sujila R Nair                                                *
* Desc   : Controller for ActivateRule_V2 page                          *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila R Nair |  04/22/2016  |  Original Version                      *
*************************************************************************/
public class ActivateRuleSetController_V2 {
    public RuleSet__c ruleset {get;set;} 
    public Ruleset_Catalog__c Catalog;
    public Id Catalogid;
    public String Heading {get;set;}
    public Active_Rule__c myrule;
    
    public ActivateRuleSetController_V2(){
        ruleset = new RuleSet__c();
        Catalog = new Ruleset_Catalog__c();
        myrule =  new Active_Rule__c();
    }
    
    public PageReference redirectActivatePage(){
        if(ApexPages.currentPage().getParameters().get('id')!=null && ApexPages.currentPage().getParameters().get('Catalogid')!=null){
            Heading = 'Activate';
            Catalogid = ApexPages.currentPage().getParameters().get('Catalogid');
            Id rulesetId = ApexPages.currentPage().getParameters().get('id');
            String Fields = RulesUtilityClass.getFields(rulesetId);
            ruleset=Database.query('SELECT '+ fields+' FROM RuleSet__c WHERE Id=\''+rulesetId+'\'');
            Fields = RulesUtilityClass.getFields(Catalogid);
            Catalog = Database.query('SELECT '+ fields+' FROM Ruleset_Catalog__c WHERE Id=\''+Catalogid+'\'');
            myrule = Active_Rule__c.getValues(Catalog.Name__c);
            system.debug('Rule Set Object retrieved' + ruleset +' and myrule '+ myrule);
            if(ruleset.active__c)
                Heading = 'Deactivate';
            return null;
        }
        else
        {
            PageReference pr = new PageReference('/apex/RulesCatalogPage_V2');
            return pr;
        }
        
    }
    
    public PageReference navigateToHome(){
    	system.debug('I was called from navigateToHome');
        PageReference pr = new PageReference('/apex/RulesHomePage_V2?id='+Catalogid);
        return pr;
    }
    
    
    public Pagereference activateRuleSet(){
        system.debug('I was called from ActivateRule');
        String Fields = RulesUtilityClass.getFields(ruleset.Catalog_ID__c);
        Catalog = Database.query('SELECT '+ fields+' FROM RuleSet_Catalog__c WHERE Id=\''+ruleset.Catalog_ID__c+'\'');
        if(ruleset.Active__c){
            system.debug('Deactivating an exisitng rule');
            ruleset.Status__c = 'Compiled';
            ruleset.Active__c = false;
            Catalog.Active_Class__c = 'Not Available';
            Catalog.Active_Version__c = 'Not Available';
            Catalog.Effective_Start_Date__c = null;
            Catalog.Effective_End_Date__c = null;
            myrule = Active_Rule__c.getInstance(Catalog.Name__c);
            if(myrule != null){
                myrule.Class_Name__c = 'Not Available';
                upsert myrule;
            }
            else
            {
                System.debug('Myrule is null'+Catalog.Name);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">Not able to find correcponsing Custom Setting</font>'));
            }
            if(Ruleset != null) {
                upsert Ruleset;
            }
            if (Catalog != null){
                upsert Catalog;
            }
            
        }else if(ruleset.Status__c == 'Compiled'){
            system.debug('Checking for existing active Rule');
            List<RuleSet__c> tempRuleList = [Select Id,Catalog_ID__c,active__c from RuleSet__c where active__c=: true AND Catalog_ID__c=: ruleset.Catalog_ID__c];
            if(tempRuleList.size() > 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">Please deactivate the existing Rule to continue</font>'));
                return null;
            }
            system.debug('Activating rule');
            ruleset.Active__c = true;
            ruleset.Compile_Errors__c = '';
            Catalog.Active_Class__c = ruleset.Class_Name__c;
            Catalog.Active_Version__c = ruleset.Version__c; 
            Catalog.Effective_Start_Date__c = ruleset.Effective_Start_Date__c;
            Catalog.Effective_End_Date__c = ruleset.Effective_End_Date__c;
            myrule = Active_Rule__c.getInstance(Catalog.Name__c);
            if(myrule != null){
                myrule.Class_Name__c = ruleset.Class_Name__c;
                upsert myrule;
            }
            else
            {
                System.debug('Myrule is null'+ Catalog.Name);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">Not able to find correcponsing Custom Setting</font>'));
            }
            if(ruleset != null){
                upsert ruleset;
            }
            if(catalog != null){
                upsert catalog;
            }
            
        }
        Catalog = Database.query('SELECT '+ fields+' FROM RuleSet_Catalog__c WHERE Id=\''+ruleset.Catalog_ID__c+'\'');
        Fields = RulesUtilityClass.getFields(ruleset.id);
        ruleset = Database.query('SELECT '+ fields+' FROM RuleSet__c WHERE Id=\''+ruleset.id+'\'');
        return null;
    }
    

}