/************************************************************************
* Name   : ViewRuleSetController_V2                                     *
* Author : Sujila R Nair                                                *
* Desc   : Controller for ViewRuleSet_V2 page                           *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila R Nair |  04/22/2016  |  Original Version                      *
*************************************************************************/
public class ViewRuleSetController_V2 {
    public String selectedsObject {get;set;}
    public List<RuleSet_Catalog__c> catalog {get;set;}
    public RuleSet__c ruleset {get;set;}
    public List<RuleTemplate> ruleList {get;set;}
    public boolean  showCompilePanel {get;set;}
    public RuleTemplate Rule_Template;
    public RuleSetTemplate RuleSet_Template;
    public RuleSetContext RuleSet_Context {get;set;}
    public boolean showContextPanel {get;set;}
    public boolean showConditionActionPanel {get;set;}
    public boolean showRulesPanel {get;set;}
    public boolean showCompleteRuleSetPanel {get;set;}
    public boolean showConditionPanel {get;set;}
    public boolean showActionPanel {get;set;}
    public List<RuleConditions_V2> ConditionList {get;set;}
    public List<RuleActions> ActionList {get;set;}
    public Integer numberofRules {get;set;}
    public boolean noCondition {get;set;}
    public boolean noAction {get;set;}
    public String Fields;
    
    public ViewRuleSetController_V2(){
    	numberofRules = 0;
        if(ApexPages.currentPage().getParameters().get('id')!=null){
            Id rulesetId = ApexPages.currentPage().getParameters().get('id');
            Fields = RulesUtilityClass.getFields(rulesetId);
            ruleset = Database.query('SELECT '+ fields+' FROM RuleSet__c WHERE Id=\''+rulesetId+'\'');
            system.debug('Rule Set Object retrieved' + ruleset);
            
            if(ruleset.Rule_Definition__c != null){
                try{
                    RuleSet_Template = (RuleSetTemplate)JSON.deserialize(ruleset.Rule_Definition__c, RuleSetTemplate.class);
                    ruleList = RuleSet_Template.Rules;
                    RuleSet_Context = RuleSet_Template.Context;
                    selectedsObject = RuleSet_Context.RelatedObjectName;
                    //system.debug('RuleList '+ruleList);
                    if(ruleList.size()>0){
                    	numberofRules = ruleList.size();
                    }
                }catch(JSONException e){
                    system.debug('Exception in deserializing JSON Rule Definition' +e);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">'+e+'</font>'));
                }
            }
            if(ruleset.Condition_List__c != null){
                try{
                    ConditionList = (List<RuleConditions_V2>)JSON.deserialize(ruleset.Condition_List__c, List<RuleConditions_V2>.class);
                    if(ConditionList.size()>0)
                    	noCondition = false;
                }catch(JSONException e){
                    system.debug('Exception in deserializing JSON Condition List' +e);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">'+e+'</font>'));
                    noCondition = true;
                }
            }
            if(ruleset.Action_List__c != null){
                try{
                    ActionList = (List<RuleActions>)JSON.deserialize(ruleset.Action_List__c, List<RuleActions>.class);
                    if(ActionList.size()>0)
                    	noAction = false;
                }catch(JSONException e){
                    system.debug('Exception in deserializing JSON Action List' +e);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">'+e+'</font>'));
                    noAction = true;
                }
            }   
            showContextPanel = true;
            showCompilePanel = false;
            showConditionActionPanel = false;
            showCompleteRuleSetPanel = false;
            showRulesPanel = false;
            showConditionPanel = false;
            showActionPanel = false;
        }
    }
    
    
    public PageReference navigateToHome(){
        PageReference pr = new PageReference('/apex/RulesHomePage_V2?id='+ruleset.Catalog_ID__c);
        return pr;
    }
    
    public PageReference navigateToConditionPanel(){
        showRulesPanel = false;
        showContextPanel = false;
        showConditionPanel = true;
        return null;
    }
   
    public PageReference navigateToRulePanel(){
        showRulesPanel = true;
        showContextPanel = false;
        showConditionActionPanel = false;
        showCompleteRuleSetPanel = false;
        showActionPanel = false;
        return null;
    }
    
    public PageReference navigateToActionPanel(){
        showConditionPanel = false;
        showActionPanel = true;
        return null;
    }
    
    public PageReference navigateToContextPage(){
        showContextPanel = true;
        showRulesPanel = false;
        showConditionPanel = false;
        return null;
    }
    
    public PageReference navigateToConditionPage(){
        showContextPanel = false;
        showRulesPanel = false;
        showConditionPanel = true;
        showActionPanel = false;
        return null;
    }    
}