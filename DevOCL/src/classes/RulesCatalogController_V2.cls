/************************************************************************
* Name   : RulesCatalogController_V2                                    *
* Author : Sujila R Nair                                                *
* Desc   : Controller for  RulesCatalogPage_V2 Page                     *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila R Nair |  04/22/2016  |  Original Version                      *
*************************************************************************/
public class RulesCatalogController_V2 {
    public String catalogidToDel {get;set;}
    public List<RuleSet_Catalog__c> allRulesCatalog {get;set;}
    public RuleSet_Catalog__c Catalog {get;set;}
    public String Fields;
 
    public RulesCatalogController_V2(){
        Fields = RulesUtilityClass.getFieldsbyObject('RuleSet_Catalog__c');
        allRulesCatalog = Database.query('SELECT '+ fields+' FROM RuleSet_Catalog__c');
        Catalog = new RuleSet_Catalog__c();
    }
    public Pagereference deleteCatalog(){
        system.debug('I was called from deleteCatalog' +catalogidToDel);
        if (catalogidToDel != null){
            List<Ruleset__c> childRulesets = [Select Id, Catalog_ID__c, Active__c 
                                              FROM  Ruleset__c 
                                              WHERE Catalog_ID__c =: Id.valueOf(catalogidToDel) AND Active__c =: true];
            if(childRulesets.size() == 0){
                RuleSet_Catalog__c catalog = [select id, name__c from  RuleSet_Catalog__c where id =: Id.valueOf(catalogidToDel)];
                Active_Rule__c myrule = Active_Rule__c.getInstance(catalog.Name__c);
                if(myrule != null){
                    delete myrule;
                }
                Database.delete(Id.valueOf(catalogidToDel));
                system.debug('Catalog Deleted');
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'<font color="red">Catalog has an active rule. Deactivate the rule before deleting</font>'));
                return null;
            }
           
        }
        Fields = RulesUtilityClass.getFieldsbyObject('RuleSet_Catalog__c');
        allRulesCatalog = Database.query('SELECT '+ fields+' FROM RuleSet_Catalog__c');
        return null;
    }
    
    public Pagereference saveNewCatalog(){
        system.debug('I was called from saveNewCatalog'+ Catalog);
        Active_Rule__c myrule = new Active_Rule__c(); //Custom Setting
        if(catalog.Name__c != null){
            upsert Catalog;
            myrule.Name = catalog.Name__c;
            system.debug('MYRULE '+ myrule);
            upsert myrule;
            Pagereference pr = new Pagereference('/apex/RulesHomePage_V2?id='+catalog.Id);
            return pr;
        } 
        return null;
    }
}