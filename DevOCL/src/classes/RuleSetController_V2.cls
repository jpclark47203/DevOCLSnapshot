/************************************************************************
* Name   : RuleSetController_V2                                         *
* Author : Sujila R Nair                                                *
* Desc   : Controller for  CreateRuleSet_V2 page                        *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila R Nair |  04/22/2016  |  Original Version                      *
* Sujila R Nair |  05/06/2016  |  Clearing Rule Mapping                 *
*************************************************************************/
public class RuleSetController_V2 {
    public boolean showContextPanel {get;set;}                      // Rendering ContextPanel
    public boolean newRuleset {get;set;}                            // Rendering InsertbuttonPanel
    public boolean showRulesPanel {get;set;}                        // Rendering RulePanel
    public boolean showCompleteRuleSetPanel {get;set;}              // Rendering CompleteRuleSetPanel
    public boolean showConditionPanel {get;set;}                    // Rendering ConditionPanel
    public boolean showActionPanel {get;set;}                       // Rendering ActionPanel
    public boolean showRulesTablePanel {get;set;}                   // Rendering RulesTablePanel
    public String selectedsObject {get;set;}                        // Selected Input sObject
    public RuleSet__c ruleset {get;set;}                            // RuleSet__c sObject instance. Used to capture ruleset data for DB 
    public List<RuleTemplate> ruleList {get;set;}                   // List of all rules. Format of RuleTemplate class
    public String Index {get;set;}                                  // Index to which rule the new action is being added
    public RuleSetContext RuleSet_Context {get;set;}                // Context information for a ruleset
    public List <RuleConditions_V2> ConditionList {get;set;}        // List of all conditions
    public List <RuleActions> ActionList {get;set;}                 // List of all actions
    public String conditionIndex {get;set;}                         // loop index for ConditionList for adding/removing
    public String actionIndex {get;set;}                            // loop index for ActionList for adding/removing
    public List<RuleSet_Catalog__c> catalog;                        // Rulset Catalog sObject instance
    public String Fields;                                           // General variable to get all Field Names for a given object
    public RuleSetTemplate RuleSet_Template;                        // Input to JSON Parser. It has all rule related info in RuleSetTemplate class format
    public String CompileButtonLabel {get;set;}
    public Active_Rule__c myrule;
    public Map<String,List<SelectOption>> parentFieldsMap {get;set;} //Condition Table Related Select Options
    public List<SelectOption> InputObjFields {get;set;}              //Condition Table Related Input Object Fields
    public Map<String, String> conditionFieldtoTypeMap {get;set;}    //Condition Table Related Field Type Information
    public Map<String, boolean> conditionFieldWritable;
    public List<SelectOption> allObjects {get;set;}                  // All Objects From the Schema
    public List<SelectOption> allCustomObjects {get;set;} 
    public List<String> allObjectsNames;
    public Map<String,List<SelectOption>> allFieldsMap {get;set;}    // All Fields from Schema, Key is Object API Name
    public Integer numberofRules {get;set;}
    public boolean customConditionField {get;set;}
    public boolean noCondition {get;set;}
    public boolean noAction {get;set;}
    public boolean showRefresh {get;set;}
    public boolean showTestRefresh {get;set;}
    public boolean showAllObjects {get;set;}
    public String tempValue {get;set;}
    
 /*************************************CONSTRUCTOR********************************/
    public RuleSetController_V2(){
        showContextPanel = true;
        showRulesPanel = false;
        showCompleteRuleSetPanel = false;
        showConditionPanel = false;
        showActionPanel = false;
        showRulesTablePanel = false;
        RuleSet_Template = new RuleSetTemplate();
        RuleSet_Context = new RuleSetContext();        
        ruleset = new RuleSet__c();
        ruleList = new List<RuleTemplate>();
        ConditionList = new List <RuleConditions_V2>();
        ActionList = new List <RuleActions>();
        conditionFieldtoTypeMap = new Map<String, String>{null => 'Not available', 'None' => 'Not available'};
        CompileButtonLabel = 'Compile RuleSet';
        parentFieldsMap = new Map<String,List<SelectOption>>();
        allFieldsMap = new Map<String,List<SelectOption>>();
        InputObjFields = new List<SelectOption>();
        numberofRules = 0;
        customConditionField = false;
        showRefresh = false;
        allObjectsNames = new List<String>();
        conditionFieldWritable= new Map<String, boolean>();
        showAllObjects = false;
    }
    
 /*********************************************************************************
  *                                redirectNewRuleset()                           *
  * This Method will be called on pageload. If this is called for a new Ruleset   *
  * Creation the CatalogId is expected otherwise RulesetID is expectecd to retrive*
  * all related information such as JSON data                                     *         
  *********************************************************************************/     
    public PageReference redirectNewRuleset(){
        if(ApexPages.currentPage().getParameters().get('Catalogid') == null && ApexPages.currentPage().getParameters().get('id') == null){
            PageReference pr = new Pagereference('/apex/RulesCatalogPage_V2');
            return pr;
        }
        if(ApexPages.currentPage().getParameters().get('Catalogid')!=null){
            Id CatalogId = ApexPages.currentPage().getParameters().get('Catalogid');
            Fields = RulesUtilityClass.getFields(CatalogId);
            Catalog = Database.query('SELECT '+ fields+' FROM RuleSet_Catalog__c WHERE Id=\''+CatalogId+'\'');
            newRuleset = true;
            showAllObjects = false;
            if(Catalog.size() > 0){
                ruleset.Catalog_ID__c = Catalog[0].Id;
                ruleset.RuleSet_Name__c = Catalog[0].Name__c;
                noCondition = true;
                noAction = true;
            }
        }
        if(ApexPages.currentPage().getParameters().get('id')!=null){
            Id rulesetId = ApexPages.currentPage().getParameters().get('id');
            Fields=RulesUtilityClass.getFields(rulesetId);
            ruleset=Database.query('SELECT '+ fields+' FROM RuleSet__c WHERE Id=\''+rulesetId+'\'');
            system.debug('Rule Set Object retrieved' + ruleset);
            showAllObjects = false;
            if(ruleset.Status__c == 'Queued'){
                showRefresh = true;
            }
            if(ruleset.Test_Class_Status__c == 'Queued'){
                showTestRefresh = true;
            }
            if(ruleset.Condition_List__c != null){
                try{
                    ConditionList = (List<RuleConditions_V2>)JSON.deserialize(ruleset.Condition_List__c, List<RuleConditions_V2>.class);
                    if(ConditionList.size() > 0)
                        noCondition = false;
                }catch(JSONException e){
                    system.debug('Exception in deserializing JSON Condition List' +e);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">'+e+'</font>'));
                }
            }
            else
                noCondition = true;
            if(ruleset.Action_List__c != null){
                try{
                    ActionList = (List<RuleActions>)JSON.deserialize(ruleset.Action_List__c, List<RuleActions>.class);
                    if(ActionList.size() > 0){
                        noAction = false;
                        for(RuleActions action: ActionList){
                            if(action.resultObject != null && action.resultObject != '')
                                findFields(action.resultObject);
                        }
                    }
                }catch(JSONException e){
                    system.debug('Exception in deserializing JSON Action List' +e);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">'+e+'</font>'));
                }
            }   
            else{
                noAction = true;
            }
            
            if(ruleset.Rule_Definition__c != null){
                try{
                    RuleSet_Template = (RuleSetTemplate)JSON.deserialize(ruleset.Rule_Definition__c, RuleSetTemplate.class);
                    ruleList = RuleSet_Template.Rules;
                    numberofRules = ruleList.size();
                    selectedsObject = RuleSet_Template.Context.RelatedObjectName;
                    for(RuleConditions_V2 condition: ConditionList){
                        for(RuleTemplate rule : ruleList){
                            //Check if all rule has entry against each condition, if not add one with 'False'
                            if(rule.ConditionMap.containsKey(condition.Identifier) == False){
                                rule.ConditionMap.put(condition.Identifier, False);
                                System.debug('Rule Updated with new Condition before cancelling');
                            }
                        }
                    }
                    for(RuleActions action: ActionList){
                        for(RuleTemplate rule : ruleList){
                            //Check if all rule has entry against each action, if not add one with 'False'
                            if(rule.ActionMap.containsKey(action.Identifier) == False){
                                rule.ActionMap.put(action.Identifier, False);
                                rule.ActionOrder.put(action.Identifier,'');
                                System.debug('Rule Updated with new Action before cancelling');
                            }
                        }
                    }
                }catch(JSONException e){
                    system.debug('Exception in deserializing JSON Rule Definition' +e);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">'+e+'</font>'));
                }
            }
            showRulesPanel = false;
            newRuleset = false;
            showCompleteRuleSetPanel = false;
        }
        //Get all Object Names from Schema Class
        updateallObjectList();
        List<SelectOption> allFieldsList = new List<SelectOption>();
        allFieldsList = new List<SelectOption>();
        allFieldsList.add(new SelectOption('Not Selected','Not Selected'));
        allFieldsMap.put('None', allFieldsList);
        allFieldsMap.put('', allFieldsList);
        allFieldsMap.put(Null, allFieldsList);
        return null;
    }
    
    /*********************************************************************************
*                                CreateOrUpdateRuleSet()                        *
* Method to insert or update Ruleset record. Invoked from ContextPanel when     *
* Save & Next button is clicked. If this is a new Ruleset, it will be attached  *
* to Catalog Id                                                                 *         
*********************************************************************************/   
    public Pagereference CreateOrUpdateRuleSet(){
        system.debug('I was called from CreateOrUpdateRuleSet with Newruleset Value:'+newRuleset);
        if(ruleset.RuleSet_Name__c == null || ruleset.Effective_Start_Date__c == null || selectedsObject == null || selectedsObject == 'None'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">Please Enter All the Required(*) Inputs </font>'));
            return null;
        }
        if(newRuleset){
            ruleset.Catalog_ID__c = catalog[0].Id;
            ruleset.Status__c = 'Draft';
        }
        RuleSet_Context.RuleSetName = ruleset.RuleSet_Name__c;
        RuleSet_Context.EffectiveStartDate = ruleset.Effective_Start_Date__c;
        RuleSet_Context.EffectiveEndDate = ruleset.Effective_End_Date__c;
        RuleSet_Context.RelatedObjectName = selectedsObject;
        RuleSet_Context.RuleExecution = ruleset.Rules_Execution__c;
        RuleSet_Template.Context = RuleSet_Context;
        String RuleDefinition_JSONString = JSON.serialize(RuleSet_Template);
        ruleset.Rule_Definition__c = RuleDefinition_JSONString;
        Upsert ruleset;
        Fields= RulesUtilityClass.getFields(ruleset.Id);
        ruleset=Database.query('SELECT '+ fields+' FROM RuleSet__c WHERE Id=\''+ruleset.Id+'\'');
        system.debug('CreateOrUpdateRuleSet: Rule Set Object Inserted' + ruleset);
        showRulesPanel = false;
        showContextPanel = false;
        showActionPanel = false;
        showConditionPanel = true;
        updateFieldsforConditions();    // Get all fields of Input Object and related Parent object Fields
        return null;
    }
    
    /*********************************************************************************
*                        Condition Table Related Methods                        *
*********************************************************************************/     
    public void AddCondition(){
        system.debug('I was called from AddCondition');
        RuleConditions_V2 rc = new RuleConditions_V2();
        ruleset.ConditionAutoNumber__c =  ruleset.ConditionAutoNumber__c+1;
        rc.Identifier = 'C' + ruleset.ConditionAutoNumber__c;
        ConditionList.add(rc);
        if(rulelist.size() > 0){
            for(RuleTemplate rule: ruleList){
                rule.ConditionMap.put(rc.Identifier, False);
            }
        }
        noCondition = false; 
    }
    public void DeleteCondition() {
        system.debug('I was called from DeleteCondition' + conditionIndex);
        String cIndex = conditionList[Integer.valueOf(conditionIndex)].Identifier;
        if(rulelist.size() > 0){
            for(RuleTemplate rule: ruleList){
                rule.ConditionMap.remove(cIndex);
            }
        }
        conditionList.remove(Integer.valueOf(conditionIndex));
        if(conditionList.size() == 0)
            noCondition = true;
    }     
    public Pagereference saveConditions(){
        system.debug('I was called from saveConditions');
        String FieldName;
        String Value;
        String FieldType;
        for(RuleConditions_V2 c: ConditionList){
            FieldType = conditionFieldtoTypeMap.get(c.FieldName);
            if(c.FieldName == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'<font color="red">Missing Condition Field(s)!</font>'));
                return null;
            }
            if(c.Value == null || c.Value == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'<font color="red"> Missing Condition Value(s)!</font>'));
                return null;
            }
        }
        if(ConditionList.size()>0){
            for(RuleConditions_V2 c: ConditionList){
                FieldName = c.FieldName.replaceAll('__c', '');
                FieldName = FieldName.replaceAll('_', ' ');
                Value = c.Value;
                if(c.ParentFieldName != 'None'){
                    String ParentField = c.ParentFieldName.replaceAll('__c', '');
                    ParentField = c.ParentFieldName.replaceAll('__r', '');
                    ParentField = ParentField.replaceAll('_', ' ');
                    c.ConditionPretty = ParentField+' '+Value;
                }else{
                    c.ConditionPretty = FieldName+' '+Value;
                }
                c.FieldType = conditionFieldtoTypeMap.get(c.FieldName);
                c.writableField = conditionFieldWritable.get(c.FieldName);
            }
            ruleset.Condition_List__c = JSON.serializePretty(ConditionList);
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">Please define Condition(s) to continue</font>'));
            return null;
        }
        upsert ruleset;
        showActionPanel = true;
        showConditionPanel = false;
        system.debug('saveConditions: Ruleset updated : '+ ruleset.Name);
        return null;
    }
    
 /*********************************************************************************
  *                        Action Table Related Methods                           *
  *********************************************************************************/       
    public void addAction() { 
        system.debug('I was called from addAction');
        RuleActions ra = new RuleActions();
        ruleset.ActionAutoNumber__c = ruleset.ActionAutoNumber__c+1;
        ra.Identifier = 'A' + ruleset.ActionAutoNumber__c;
        if(ActionList.size() > 0) {
            ra.resultObject = ActionList[ActionList.size()-1].resultObject;
            ra.Type = ActionList[ActionList.size()-1].Type;
            ra.Field = ActionList[ActionList.size()-1].Field;
        }
        ActionList.add(ra);
        if(rulelist.size() > 0){
            for(RuleTemplate rule: ruleList){
                rule.ActionMap.put(ra.Identifier, False);
                rule.ActionOrder.put(ra.Identifier,'');
            }
        } 
        noAction = false;
    }   
    public void deleteAction() { 
        system.debug('I was called from deleteAction:'+ actionIndex);
        String aIndex = ActionList[Integer.valueOf(actionIndex)].Identifier;
        if(rulelist.size() > 0){
            for(RuleTemplate rule: ruleList){
               rule.ActionMap.remove(aIndex);
               rule.ActionOrder.remove(aIndex); 
            }
        }        
        ActionList.remove(Integer.valueOf(actionIndex));    
        if(Integer.valueOf(actionIndex) > 0) actionIndex = String.valueOf(Integer.valueOf(actionIndex) - 1);
    	if(ActionList.size() == 0)
            noAction = true;
    } 
    public Pagereference saveActions(){
        system.debug('I was called from saveActions');
        for(RuleActions a: ActionList){
            if(a.Field == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'<font color="red">Missing Action Field(s)!</font>'));
                return null;
            }
            if(a.Value == '' || a.Value == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'<font color="red">Missing Action Value(s)!</font>'));
                return null;
            }
            if(a.resultObject == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'<font color="red">Missing Action Object(s)!</font>'));
                return null;
            }
            if(a.Type == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'<font color="red">Missing Action Type(s)!</font>'));
                return null;
            }
        }
        if(ActionList.size()>0){
            for(RuleActions a: ActionList){
                a.ActionPretty = a.Type+'\n'+a.resultObject+'\n'+a.Field+'\n'+a.Value;
            }
            ruleset.Action_List__c = JSON.serializePretty(ActionList);
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">Please define Action(s) to continue</font>'));
            return null;
        }
        upsert ruleset;
        system.debug('saveActions: Ruleset updated :'+ ruleset.Name);
        showRulesPanel = true;
        showActionPanel = false;
        return null;
    }

 /*********************************************************************************
  *                        Rule Table Related Methods                             *
  *********************************************************************************/       
    public Pagereference AddNewRule(){
        system.debug('I was called from AddNewRule with ConditionList size: '+ConditionList.size() );
        if(ConditionList.size() > 0){
            RuleTemplate newRule = new RuleTemplate();
            for(RuleConditions_V2 condition: ConditionList){
                newRule.ConditionMap.put(condition.Identifier, false);
            }
            for(RuleActions action: ActionList){
                newRule.ActionMap.put(action.Identifier, false);
                newRule.ActionOrder.put(action.Identifier, '');
            }
            system.debug('AddNewRule: MAP Updated: '+newRule);
            ruleList.add(newRule);
            showRulesTablePanel = true;
        }
        return null;
    }
    public Pagereference removeRule(){
        system.debug('I was called from removeRule '+ Index);
        Integer RuleIndex = Integer.valueOf(Index);
        ruleList.remove(RuleIndex);
        return null;
    }    
    public Pagereference clearRule(){
        system.debug('I was called from clearRule '+ Index);
        Integer RuleIndex = Integer.valueOf(Index);
        RuleTemplate newRule = ruleList[RuleIndex];
        for(RuleConditions_V2 condition: ConditionList){
            newRule.ConditionMap.put(condition.Identifier, false);
        }
        for(RuleActions action: ActionList){
            newRule.ActionMap.put(action.Identifier, false);
            newRule.ActionOrder.put(action.Identifier, '');
        }
        ruleList[RuleIndex] = newRule;
        return null;
    } 
    public PageReference  SaveRules(){
        system.debug('I was called from SaveRules');
        /* General Checking for Rules before converting to JSON ==> START*/
        boolean conditionmarked;
        boolean actionmarked;
        boolean orderpresent;
        boolean actionpresent;
        boolean actionisnumber;
        /******************* General Checking *************/
        for(RuleTemplate rule : ruleList){
            conditionmarked = false;
            actionmarked = false;
            orderpresent = true;
            actionpresent = true;
            actionisnumber = true;
            for(RuleConditions_V2 c: ConditionList){
                if(rule.ConditionMap.get(c.Identifier)){
                    conditionmarked = true;
                    break;
                }
            }
            for(RuleActions a: ActionList){
                if(rule.ActionMap.get(a.Identifier)){
                    actionmarked = true;
                    if(rule.ActionOrder.get(a.Identifier).isNumeric()){
                        actionisnumber = true;
                    }
                    else{
                        actionisnumber = false;
                        break;
                    }
                    
                    if(rule.ActionOrder.get(a.Identifier) == null || rule.ActionOrder.get(a.Identifier) ==''){
                        orderpresent = false;
                        break;
                    }
                    else
                        orderpresent = true;
                }
                if(rule.ActionOrder.get(a.Identifier) != '' && rule.ActionMap.get(a.Identifier) == false){
                    actionpresent = false;
                    break;
                }
            }
            if(conditionmarked == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">No Condition marked for Rule: '+rule.Name+'</font>'));
                return null;
            }
            if(actionmarked == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">No Action set for Rule: '+rule.Name+'</font>'));
                return null;
            } 
            if(orderpresent == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">Action marked but order number is not present for: '+rule.Name+'</font>'));
                return null;
            } 
            if(actionpresent == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">Action is not marked but order number is entered for Rule: '+rule.Name+'</font>'));
                return null;
            }
            if(actionisnumber == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">Order number mus be an Integer for Rule: '+rule.Name+'</font>'));
                return null;
            }
        }
        
        /******************* END of checking *************/

        RuleSet_Context.RuleSetName = ruleset.RuleSet_Name__c;
        RuleSet_Context.EffectiveStartDate = ruleset.Effective_Start_Date__c;
        RuleSet_Context.EffectiveEndDate = ruleset.Effective_End_Date__c;
        RuleSet_Context.RelatedObjectName = selectedsObject;
        RuleSet_Context.RuleExecution = ruleset.Rules_Execution__c;
        RuleSet_Context.RuleVersion = ruleset.Version__c;
        RuleSet_Template.Context = RuleSet_Context;
        RuleSet_Template.Rules = ruleList;
        
        //Convert it to JSON
        String RuleAllConditions_JSONString  = JSON.serialize(ConditionList);
        String RuleAllActions_JSONString  = JSON.serialize(ActionList);
        String RuleDefinition_JSONString = JSON.serialize(RuleSet_Template);
        
        //Update Ruleset record in DB
        ruleset.Rule_Definition__c = RuleDefinition_JSONString;
        ruleset.Action_List__c = RuleAllActions_JSONString;
        ruleset.Condition_List__c = RuleAllConditions_JSONString;
        upsert ruleset;
        
        Fields= RulesUtilityClass.getFields(ruleset.Id);
        ruleset=Database.query('SELECT '+ fields+' FROM RuleSet__c WHERE Id=\''+ruleset.Id+'\'');        
        showRulesPanel  = false;
        showContextPanel = false;
        showRulesTablePanel = false;
        showConditionPanel = false;
        showActionPanel = false;
        showCompleteRuleSetPanel = true;
        numberofRules = ruleList.size();
        return null;
    }
    
  /*********************************************************************************
  *                        Compilation Related Methods                             *
  *********************************************************************************/ 
    public PageReference CompileRuleSet(){
        system.debug('Ruleset Id from CompileRuleSet'+ ruleset.Id);
        boolean result = RuleSetJSONParserClass_V2.compileClass(ruleset.Id);
        Fields= RulesUtilityClass.getFields(ruleset.Id);
        ruleset = Database.query('SELECT '+ fields+' FROM RuleSet__c WHERE Id=\''+ruleset.Id+'\'');
        if (result){
            System.debug('Compile Success');
            showCompleteRuleSetPanel = true;
            if(ruleset.Status__c == 'Queued')
                showRefresh = true;
        }
        else{
            System.debug('Compile Failed');
            System.debug('ErrorMessage' + RuleSetJSONParserClass_V2.ErrorMessage);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'<font color="red">'+RuleSetJSONParserClass_V2.ErrorMessage+' </font>'));
        }
        return null;
    }
    
  /*********************************************************************************
  *                        Ruleset Activation Related Methods                      *
  **********************************************************************************/     
    public Pagereference ActivateRule(){
        system.debug('I was called from ActivateRule');
        Fields = RulesUtilityClass.getFields(ruleset.Catalog_ID__c);
        catalog = Database.query('SELECT '+ fields+' FROM RuleSet_Catalog__c WHERE Id=\''+ruleset.Catalog_ID__c+'\'');
        if(ruleset.Active__c){
            system.debug('Deactivating an exisitng rule');
            ruleset.Status__c = 'Compiled';
            ruleset.Active__c = false;
            catalog[0].Active_Class__c = 'Not Available';
            catalog[0].Active_Version__c = 'Not Available';
            catalog[0].Effective_Start_Date__c = null;
            catalog[0].Effective_End_Date__c = null;
            myrule = Active_Rule__c.getInstance(catalog[0].Name__c);
            if(myrule != null){
                myrule.Class_Name__c = 'Not Available';
                upsert myrule;
            }
            else
            {
                System.debug('Myrule is null'+ Catalog[0].Name);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">Not able to find correcponsing Custom Setting</font>'));
            }
            upsert ruleset;
            upsert catalog;
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
            catalog[0].Active_Class__c = ruleset.Class_Name__c;
            catalog[0].Active_Version__c = ruleset.Version__c; 
            catalog[0].Effective_Start_Date__c = ruleset.Effective_Start_Date__c;
            catalog[0].Effective_End_Date__c = ruleset.Effective_End_Date__c;
            myrule = Active_Rule__c.getInstance(catalog[0].Name__c);
            if(myrule != null){
                myrule.Class_Name__c = ruleset.Class_Name__c;
                upsert myrule;
            }
            else
            {
                System.debug('Myrule is null'+ Catalog[0].Name);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<font color="red">Not able to find correcponsing Custom Setting</font>'));
            }
            upsert ruleset;
            upsert catalog;
        }
        catalog = Database.query('SELECT '+ fields+' FROM RuleSet_Catalog__c WHERE Id=\''+ruleset.Catalog_ID__c+'\'');
        return null;
    }
    
    public Pagereference updateClassStatus(){
        System.debug('I was called from updateClassStatus');
        showRefresh = true;
        Fields= RulesUtilityClass.getFields(ruleset.Id);
        ruleset = Database.query('SELECT '+ fields+' FROM RuleSet__c WHERE Id=\''+ruleset.Id+'\'');
        ruleset = RuleSetJSONParserClass_V2.getAsyncStatus(ruleset);
        if(ruleset.Status__c == 'Compiled' || ruleset.Status__c == 'Compile-Failed'){
            showRefresh = false;
            if(ruleset.Status__c == 'Compile-Failed'){
                System.debug('Compile Failed from updateClassStatus');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'<font color="red">'+ruleset.Compile_Errors__c+' </font>'));
            }
        }
        if(ruleset.Test_Class_Status__c == 'Queued'){
            showTestRefresh = true;
        }
        Upsert ruleset;
        ruleset = Database.query('SELECT '+ fields+' FROM RuleSet__c WHERE Id=\''+ruleset.Id+'\'');
        return null;
    }
    public Pagereference updateTestClassStatus(){
        showTestRefresh = true;
        Fields= RulesUtilityClass.getFields(ruleset.Id);
        ruleset = RuleSetJSONParserClass_V2.getTestClassAsyncStatus(ruleset);
        if(ruleset.Test_Class_Status__c == 'Compiled' || ruleset.Test_Class_Status__c == 'Compile-Failed'){
            showTestRefresh = false;
        }
        Upsert ruleset;
        ruleset = Database.query('SELECT '+ fields+' FROM RuleSet__c WHERE Id=\''+ruleset.Id+'\'');
        return null;
    }

 /*********************************************************************************
  *                               Page Navigation Related Methods                 * 
  *********************************************************************************/     
    public PageReference navigateToHome(){
        PageReference pr = new PageReference('/apex/RulesHomePage_V2?id='+ruleset.Catalog_ID__c);
        return pr;
    }
    public PageReference navigateToConditionPage(){
        showContextPanel = false;
        showRulesPanel = false;
        newRuleset = false;
        showConditionPanel = true;
        showActionPanel = false;
        return null;
    }
    public PageReference navigateToActionPage(){
        showContextPanel = false;
        showRulesPanel = false;
        newRuleset = false;
        showConditionPanel = false;
        showActionPanel = true;
        return null;
    }    
    public PageReference navigateToRulePanel(){
        showRulesPanel = true;
        showContextPanel = false;
        showActionPanel = false;
        showCompleteRuleSetPanel = false;
        return null;
    }
    public PageReference navigateToRulePanelBack(){
        showRulesPanel = true;
        showContextPanel = false;
        showConditionPanel = false;
        showActionPanel = false;
        showCompleteRuleSetPanel = false;
        return null;
    }    
    public PageReference navigateToContextPage(){
        showContextPanel = true;
        showRulesPanel = false;
        newRuleset = false;
        showConditionPanel = false;
        return null;
    }
    
 /*********************************************************************************
  *                               UTILITY METHODS                                * 
  *********************************************************************************/ 
   public void updateallObjectList(){
	   allObjects = new List<SelectOption>();
       allCustomObjects = new List<SelectOption>();
	   allObjects.add(new SelectOption('None','Not Selected'));
	   String name;
       List<Schema.SObjectType> SchemaObjects = Schema.getGlobalDescribe().Values(); 
       for(Schema.SObjectType objName : SchemaObjects){
           	 name = objName.getDescribe().getName();
           	 if(!name.containsignorecase('history') && !name.containsignorecase('tag') &&  !name.containsignorecase('WorkPerformanceCycle') && !name.containsignorecase('WorkCoaching') &&      
               !name.containsignorecase('share') && !name.containsignorecase('Apex') && 
               !name.containsignorecase('Auth') && !name.containsignorecase('Campaign') &&
               !name.containsignorecase('share') && !name.containsignorecase('feed')){
                   allObjects.add(new SelectOption(objName.getDescribe().getName(),objName.getDescribe().getName()));
                   allObjectsNames.add(objName.getDescribe().getName());
                   if(name.containsignorecase('__c')){
                       allCustomObjects.add(new SelectOption(objName.getDescribe().getName(),objName.getDescribe().getName()));
                   }
               }
       }
       allObjects.sort();
       allCustomObjects.sort();
   }
   public void updateFieldsforConditions(){
        List<SelectOption> parentFields = new List<SelectOption>();
        parentFields.add(new SelectOption('None','None'));
        if(selectedsObject != null){
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(selectedsObject);
            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            for (String fieldName: fieldMap.keySet()) {
                InputObjFields.add(new SelectOption(FieldName,FieldName)); //Child Fields
                if(fieldMap.get(fieldName).getDescribe().getType() == Schema.DisplayType.REFERENCE){
                    parentFields = new List<SelectOption>(); 
                    conditionFieldtoTypeMap.put(fieldName, 'REFERENCE '+fieldMap.get(fieldName).getDescribe().getReferenceTo());    //to display field type to user
                    Schema.SObjectType parentSchema = fieldMap.get(fieldName).getDescribe().getReferenceTo().get(0);
                    Map<String, Schema.SObjectField> parentFieldMap = parentSchema.getDescribe().fields.getMap();
                    String relationField = fieldName.replaceAll('__c','__r');
                    for(String parentField : parentFieldMap.keySet()){
                        parentFields.add(new SelectOption(relationField+'.'+parentField, relationField+'.'+parentField));
                    }
                    parentFieldsMap.put(fieldName, parentFields);
                }
                else{
                    parentFields = new List<SelectOption>();
                    parentFields.add(new SelectOption('None','None'));
                    parentFieldsMap.put(fieldName, parentFields);
                    conditionFieldtoTypeMap.put(fieldName, String.valueOf(fieldMap.get(fieldName).getDescribe().getType()));
                }
                if(fieldMap.get(fieldName).getDescribe().isUpdateable())
                    conditionFieldWritable.put(fieldName, True);
                else
                    conditionFieldWritable.put(fieldName, False);
            }
            parentFields = new List<SelectOption>();
            parentFields.add(new SelectOption('None','None'));
            parentFieldsMap.put('None', parentFields);
            parentFieldsMap.put(null, parentFields);
            system.debug(parentFieldsMap);
            InputObjFields.sort();
        }
    }
    
    public void updateFieldMap(){
        System.debug('I was called from updateFieldMap with ActionIndex:'+ actionIndex);
         if(actionIndex != null && actionIndex != ''){
             Integer aIndex = Integer.valueOf(actionIndex);
             String actionObject = ActionList[aIndex].ResultObject;
             if(allFieldsMap.containsKey(actionObject)){
                 System.debug('Map has fields for :'+ actionObject);
             }
             else{
                 if(actionObject != null){
                    findFields(actionObject);
                 }
             }
         }
        List<SelectOption> allFieldsList = new List<SelectOption>();
        allFieldsList = new List<SelectOption>();
        allFieldsList.add(new SelectOption('None','None'));
        allFieldsMap.put('None', allFieldsList);
        allFieldsMap.put(Null, allFieldsList);
    }
    public void findFields (String ObjectName){
        List<SelectOption> allFieldsList = new List<SelectOption>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(ObjectName);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()){
            allFieldsList.add(new SelectOption(FieldName,FieldName));
        }
        allFieldsMap.put(ObjectName, allFieldsList);
    }
}