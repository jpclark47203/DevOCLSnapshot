/************************************************************************
* Name   : RuleSetHomeController_V2                                     *
* Author : Sujila R Nair                                                *
* Desc   : Controller for RulesHomePage_V2 page                         *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila R Nair |  04/22/2016  |  Original Version                      *
*************************************************************************/
public class RuleSetHomeController_V2 {
    public List<RuleSet__c> RulesetList {get;set;}
    public String rsidToDel {get;set;}                  
    public boolean showRulesetPanel {get;set;}
    public boolean showContextPanel {get;set;}
    public RuleSet_Catalog__c Catalog {get;set;}
    public String Fields;
    public String catalogName;
    
    public RuleSetHomeController_V2(){
        catalog = new RuleSet_Catalog__c();
        RulesetList = new List<RuleSet__c>();
        
    }
    
    public PageReference redirectCatalog(){
        if(ApexPages.currentPage().getParameters().get('id') !=null){
            Id catID = ApexPages.currentPage().getParameters().get('id');
            Fields = RulesUtilityClass.getFields(catID);
            catalog = Database.query('SELECT '+ fields+' FROM RuleSet_Catalog__c WHERE Id=\''+catID+'\'');
            catalogName = catalog.Name__c;
            Fields = RulesUtilityClass.getFieldsbyObject('Ruleset__c');
            RulesetList= Database.query('SELECT '+ fields+' FROM RuleSet__c WHERE Catalog_ID__c =\''+catalog.id+'\'');
            showRulesetPanel = true;
            showContextPanel = true;
            return null; 
        }
        else{
            PageReference pr = new Pagereference('/apex/RulesCatalogPage_V2');
            return pr;
        }
    }
    public Pagereference deleteRuleSet(){
        system.debug('I was called from deleteRuleSet with rsidToDel:' + rsidToDel);
        boolean deletedClass = false;
        if(rsidToDel != null){
            Id rid = id.valueOf(rsidToDel);
            List<RuleSet__c> TempRulesetList = [select id,active__c,Class_Name__c, Test_Class_Name__c from RuleSet__c where id =:rid ];
            if (TempRulesetList.size() > 0){
                if(TempRulesetList[0].active__c){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'<font color="red">Active Ruleset Can no be deleted</font>'));
                    return null;
                }else{
                    if(TempRulesetList[0].Class_Name__c != 'Not Available' || TempRulesetList[0].Class_Name__c != null){
                        deletedClass = deleteClassFile(TempRulesetList[0].Class_Name__c);
                        if(TempRulesetList[0].Test_Class_Name__c != 'Not Available')
                           deleteClassFile(TempRulesetList[0].Test_Class_Name__c);
                    }
                    system.debug('deletedClass'+deletedClass);
                    delete TempRulesetList[0];
                    system.debug('Ruleset deleted' + TempRulesetList[0]);
                    for(integer i=0; i< RulesetList.size();i ++){
                        if (RulesetList[i].id == TempRulesetList[0].id){
                            RulesetList.remove(i);
                            break;
                        }
                    }
                }
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'<font color="red">Error in deleting Ruleset </font>'));
        }
        return null;
    }
    
    public Pagereference cloneRuleSet(){
        system.debug('I was called from cloneRuleSet with rsidToDel:' + rsidToDel);
        if(rsidToDel != null){
            Id rid = id.valueOf(rsidToDel);
            Fields = RulesUtilityClass.getFields(rid);
            Ruleset__c TempRuleset = Database.query('SELECT '+ fields+',Catalog_ID__r.Name__c FROM Ruleset__c WHERE Id=\''+rid+'\''); 
            Ruleset__c newRuleset = TempRuleset.clone(false,true,false,false);
            newRuleset.active__c = False;
            newRuleset.Class_Name__c = 'Not Available';
            newRuleset.Test_Class_Name__c = 'Not Available';
            newRuleset.Status__c = 'Draft';
            newRuleset.Compile_Errors__c = 'None';
            newRuleset.Compile_Errors__c = '';
            newRuleSet.Metadata_Container_Id__c = '';
            newRuleset.Metadata_Container_UniqueId__c = 0;
            newRuleset.AsyncRequestID__c = '';
            newRuleSet.RuleSet_Name__c = TempRuleset.Catalog_ID__r.Name__c;
            newRuleSet.Test_Class_Status__c = 'Draft';
            newRuleSet.Test_Class_Body__c = '';
            newRuleSet.TestClassAsyncRequestID__c = '';
            upsert newRuleset;
            Fields = RulesUtilityClass.getFieldsbyObject('Ruleset__c');
            RulesetList= Database.query('SELECT '+ fields+' FROM RuleSet__c WHERE Catalog_ID__c =\''+catalog.id+'\'');
        }
        return null;
    }
    
    public Pagereference navigateToHome(){
        Pagereference pr = new Pagereference('/apex/RulesCatalogPage_V2');
        return pr;
    }
    
    public Pagereference updateCatalog(){
        if(catalog.Id != null){
            upsert catalog;
            Active_Rule__c myrule = Active_Rule__c.getInstance(catalogName);
            if(myrule != null){
                myrule.Name = catalog.Name__c;
                update myrule;
                catalogName = catalog.Name__c;
            }
        }
        Fields = RulesUtilityClass.getFields(catalog.id);
        catalog = Database.query('SELECT '+ fields+' FROM RuleSet_Catalog__c WHERE Id=\''+catalog.id+'\'');
        return null;
    }
    
    private boolean deleteClassFile(String classname){
        List<apexclass> classes = [Select Id, name from ApexClass where Name=: classname limit 1];
        if(classes.size() > 0){
            HttpRequest req = new HttpRequest();
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v36.0/sobjects/ApexClass/'+classes[0].id);
            req.setMethod('DELETE');
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json');
            Http httpreq = new Http();
            HttpResponse httpres = httpreq.send(req);
            if (httpres.getStatusCode() != 204) {
                System.debug(httpres.getBody());
                System.debug(httpres.toString());
                System.debug('STATUS_CODE:'+httpres.getStatusCode());
                System.debug('STATUS:'+httpres.getStatus());
                return false;
            }
        }
        return true;
    }
}