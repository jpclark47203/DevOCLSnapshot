/************************************************************************
* Name   : RuleSetJSONParserClass_V2                                    *
* Author : Sujila R Nair                                                *
* Desc   : Class and Test Clss generating/updating code                 *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila R Nair |  04/22/2016  |  Original Version                      *
* Sujila R Nair | 06/27/2016   |  Updated Code from Ohio Dev            *
*************************************************************************/
public class RuleSetJSONParserClass_V2 {
    public  static String ErrorMessage;
    private static List<Ruleset__c> rulesetList = new List<Ruleset__c>();
    private static Ruleset__c ruleset = new Ruleset__c();
    private static List<Ruleset_Catalog__c> Catalog = new List<Ruleset_Catalog__c>();
    private static RuleSetTemplate RSTemplate = new RuleSetTemplate(); 
    private static List<RuleConditions_V2> ConditionList = new List<RuleConditions_V2>();
    private static List<RuleActions> ActionList = new List<RuleActions>();
    private static String className;
    private static String classBody;
    private static String testClassName;
    private static String testClassBody;
    private static RuleSetContext Context = new RuleSetContext();
    private static List<RuleTemplate> ruleList = new List<RuleTemplate>();
    private static Map<String, String> actionObjects = new Map<String, String>();
    private static Map<Integer, List<String>> testRuleCondtions = new Map<Integer, List<String>>();	// Mapping rule to checking conditions. Used in writing test class
    private static Map<String, boolean> TestConditionFields =  new Map<String, boolean>();	// Field list used to generate dummy Test data
    private static Integer recurCount = 0;
    
    /*********************************************************************************
*                           Class Compiling Managing Method                      * 
*********************************************************************************/     
    public Static boolean compileClass(Id rulesetId){
        system.debug('I was called from compileClass');
        if (rulesetId == null){
            ErrorMessage = 'RuleSet Id is null';
            return false;
        }
        String fields = RulesUtilityClass.getFields(rulesetId);
        rulesetList = Database.query('SELECT '+ fields+' FROM RuleSet__c WHERE Id=\''+rulesetId+'\'');
        if(rulesetList.size() == 0){
            ErrorMessage = 'No Ruleset found with ID: '+rulesetId;
            return false;
        }
        Catalog = [Select Id, Name, Name__c from Ruleset_Catalog__c where ID =: rulesetList[0].Catalog_ID__c];
        if(Catalog.size() == 0){
            System.debug('Not able to find Catalog');
        }
        ruleset = rulesetList[0];
        actionObjects = new Map<String, String>();
        String version = ruleset.Version__c;
        version = version.replaceAll('[-]', '');
        className = (ruleset.RuleSet_Name__c).deleteWhitespace()+'_'+version;
        testClassName = 'Test'+className;
        system.debug('Classname: '+className );
        system.debug('Test Classname: '+ testClassName);
        String RuleDefinition_JSON = ruleset.Rule_Definition__c;
        String RuleConditions_JSON = ruleset.Condition_List__c;
        String RuleActions_JSON = ruleset.Action_List__c; 
        if(RuleDefinition_JSON != null){
            try{
                RSTemplate = (RuleSetTemplate)JSON.deserialize(RuleDefinition_JSON, RuleSetTemplate.class);
            }
            catch(JSONException e){
                ErrorMessage = 'Error in Deserializing Rule Definition: '+e;
                return false;
            }
        }
        else{
            ErrorMessage = 'No Rule Definition Found in: '+rulesetId;
            return false;
        }
        if(RuleConditions_JSON != null){
            try{
                ConditionList = (List<RuleConditions_V2>)JSON.deserialize(RuleConditions_JSON, List<RuleConditions_V2>.class);
            }
            catch(JSONException e){
                ErrorMessage = 'Error in Deserializing Condition List: '+e;
                return false;
            }
        }
        else{
            ErrorMessage = 'No Conditions Found in: '+rulesetId;
            return false;
        }
        if(RuleActions_JSON != null){
            try{
                ActionList = (List<RuleActions>)JSON.deserialize(RuleActions_JSON, List<RuleActions>.class);
                for(RuleActions action: ActionList){
                    actionObjects.put(action.resultObject, action.resultObject);
                }
            }
            catch(JSONException e){
                ErrorMessage = 'Error in Deserializing Action List: '+e;
                return false;
            }
        }
        else{
            ErrorMessage = 'No Actions Found in: '+rulesetId;
            return false;
        } 
        
        system.debug('compileClass:- Deserialization Complete');
        Context = RSTemplate.Context;
        ruleList = RSTemplate.Rules;                
        if(createClassBody()){
            if(ruleset.status__c == 'Compiled' || (ruleset.status__c == 'Compile-Failed' && ruleset.Class_Name__c != 'Not Available')){   //Class already present
                if(updateClass()){
                    ruleset.Compile_Errors__c = 'None';
                    createTestClassBody();	// Update Test Class
                    if(ruleset.Status__c == 'Compiled'){
                        ruleset = updateTestClass(ruleset);
                    }
                    else{
                        ruleset.Test_Class_Body__c = testClassBody; 
                        ruleset.Test_Class_Status__c = 'Pending';
                    }
                }
                else{
                    ruleset.Status__c = 'Compile-Failed';
                    ruleset.Compile_Errors__c = ErrorMessage;
                    return false;
                }
            }
            else {
                if(insertClass()){		//Create new class for this Ruleset
                    ruleset.Class_Name__c = className;
                    ruleset.Status__c = 'Compiled';
                    ruleset.Compile_Errors__c = 'None';
                    createTestClassBody();
                    if(insertTestClass()){
                        ruleset.Test_Class_Name__c = testclassName;
                        ruleset.Test_Class_Status__c = 'Compiled';
                    }
                    else{
                        ruleset.Test_Class_Name__c = 'Not Available';
                        ruleset.Test_Class_Status__c = 'Compile-Failed';
                    }
                }
                else{
                    ruleset.Status__c = 'Compile-Failed';
                    ruleset.Compile_Errors__c = ErrorMessage;
                }
            }
            upsert (ruleset);
        }
        else{
            system.debug('compileClass :- createClassBody failed');
        }
        if(ruleset.Status__c == 'Compiled' || ruleset.Status__c == 'Queued')
            return true;
        else
            return false;
    }
    
    /*********************************************************************************
*                           Createing Class Body Method                         * 
*********************************************************************************/     
    private Static boolean createClassBody(){
        system.debug('I was called from createClassBody');
        String InputParam;
        Integer numberofConditions = 0; 
        Integer ruleIndex = 0; 
        boolean inputUpdated = false;
        boolean includeOldobjCheck = false;
        Map<String, Boolean> actionobjCreated = new Map<String, Boolean>();	// To check if a new obj variable is created for each action result object
        Set<String> conditionsUsed = new Set<String>();	// Set of all the conditions used in this Ruleset regardless of how many configured
        
        List<String> ConditionsPerRule = new List<String>();
        //Loop through Condition list to check if input is compared to old-input in any condition
        for(RuleConditions_V2 condition: conditionList){
            if (condition.Value.containsIgnoreCase('ISCHANGED')){
                includeOldobjCheck = true;
            }
        }
        //Class Start =>
        classbody = 'Public Class '+className+' implements RulesInterfaceClass_V2{ \\n'; 
        
        //Variable declarations
        classbody = classbody + 'Private Map<String, boolean> ConditionTable;\\n';
        classbody = classbody + 'Private RulesResultClass_V2 Result;\\n';
        if(includeOldobjCheck){
            classbody = classbody + 'Private Map<Id,'+Context.RelatedObjectName+'> OldInputMap;\\n';
        }
        
        // Class Constructor
        classbody = classbody + 'Public '+className+'(){\\n    ConditionTable = new Map<String, boolean>();\\n';
        if(includeOldobjCheck){
            classbody = classbody + 'OldInputMap =  new Map<Id,'+Context.RelatedObjectName+'>();\\n';
        }
        classbody = classbody + 'Result = new RulesResultClass_V2();\\n}';
        
        // Perform Method.
        classbody = classbody + '\\n Public RulesResultClass_V2 Perform(List<sObject> InputList, List<sObject> OldInputList){\\n';
        classbody = classbody + 'String RuleStartDate = \''+String.valueOf(context.EffectiveStartDate)+'\';\\n';
        classbody = classbody + 'if(System.Today() <  Date.valueOf(RuleStartDate)){\\n';
        classbody = classbody + 'Result.Errors = \'Rule is configured to start on \'+RuleStartDate;\\n';
        classbody = classbody + 'Result.Status = \'Failed\';\\n';
        classbody = classbody + 'System.debug(\'Failed: Rule is configured to start on \'+RuleStartDate);\\n';
        classbody = classbody + 'return Result; \\n';
        classbody = classbody +'}\\n';
        classbody = classbody + 'List<'+Context.RelatedObjectName+'> primaryObjList = (List<'+Context.RelatedObjectName+'>)InputList;\\n';
        
        if(includeOldobjCheck){
            classbody = classbody + 'List<'+Context.RelatedObjectName+'> oldprimaryObjList;\\n';
        } 
        if(includeOldobjCheck){
            classbody = classbody + 'If(OldInputList != null){\\n oldprimaryObjList = (List<'+Context.RelatedObjectName+'>)OldInputList;\\n}\\n';
        }    
        Set<String> actionObjSet = actionObjects.keySet();
        for(String objName: actionObjSet){
            if(objName != context.RelatedObjectName){
                classbody = classbody +'List <'+objName+'> '+objName.replaceAll('_', '')+'ObjList = new List<'+objName+'>();\\n';
            }
        }
        if(includeOldobjCheck){
            classbody = classbody + 'If(oldprimaryObjList != null){\\n';
            classbody = classbody + 'for('+Context.RelatedObjectName+' oldprimaryObj: oldprimaryObjList){\\n';
            classbody = classbody + 'OldInputMap.put(oldprimaryObj.Id, oldprimaryObj);\\n}\\n}\\n';
            //classbody = classbody + 'If(!UpdateConditionTable(primaryObj, oldprimaryObj)){\\nResult.Status = \'Error in Updating Condition Table\';\\n Return Result;}\\n';
        }
        classbody = classbody + Context.RelatedObjectName +' oldprimaryObj;\\n';
        classbody = classbody + 'for('+Context.RelatedObjectName+ ' primaryObj : primaryObjList){\\n';
        if(includeOldobjCheck){
            classbody = classbody + 'if(OldInputMap.containsKey(primaryObj.Id)){\\n oldprimaryObj = OldInputMap.get(primaryObj.Id);\\n}\\n';
        }
        classbody = classbody + 'UpdateConditionTable(primaryObj, oldprimaryObj);\\n';
        boolean firstcondition = true;
        for(RuleTemplate rule: ruleList){
            actionobjCreated.clear();
            firstcondition = true;
            classbody = classbody + 'System.debug(\'Executing Rule: '+rule.Name+'\');\\n';
            classbody = classbody + 'if(';
            for(String conditionId: rule.ConditionMap.KeySet()){
                if(rule.ConditionMap.get(conditionId)){
                    if(!firstcondition) classbody = classbody + ' && ';
                    classbody = classbody + 'conditionTable.get(\''+conditionId+'\')';
                    firstcondition = false;
                    ConditionsPerRule.add(conditionId);
                    conditionsUsed.add(conditionId);
                }
            }
            classbody = classbody + ')'; // End of IF statement for Rule Conditions TEST
            classbody = classbody + '{ \\n';
            
            //Perform Actions
            List<RuleActions> actionsforthisrule =  new List<RuleActions>();
            /* Getting actions defined for this rule from All ActionList for the ruleset*/
            for(String actionId: rule.ActionMap.KeySet()){
                if(rule.ActionMap.get(actionId)){
                    for(RuleActions action: ActionList){
                        if (action.Identifier == actionId){
                            action.OrderNumber = rule.ActionOrder.get(actionId);
                            actionsforthisrule.add(action);
                            //system.debug('ACTIONS FOR THIS RULE: '+ actionsforthisrule);
                        }
                    }
                }
            }
            if(actionsforthisrule.size() == 0){
                ErrorMessage = 'No action defined for the rule';
                return false;
            }
            actionsforthisrule.sort();      // Sort by order number is implemented in RuleActions class
            system.debug('ACTIONS FOR THIS RULE: '+ actionsforthisrule);
            
            //Execute Actions in the action order enetered by user
            Integer actionIndex = 1;
            for(RuleActions ruleaction: actionsforthisrule){
                String actionObj = ruleaction.resultObject.remove('_') + 'Obj';
                if((ruleaction.Type == 'Update Input') && (ruleaction.resultObject ==  context.RelatedObjectName)){
                    //Updating the parent result object and returning it to it to the application
                    classbody = classbody + 'primaryObj.'+ruleaction.Field+' = '+ruleaction.Value+';\\n';
                    inputUpdated = true;
                }
                else{
                    //Creating a new Result record and updating it
                    if(ruleaction.Type == 'Add Record'){
                        if(ruleaction.Field != null && ruleaction.Value !=null){
                            if(ruleaction.Value.containsignorecase('CONTEXT')){ 
                                ruleaction.Value = 'primaryObj'+ruleaction.Value.substringAfter('}');
                                TestConditionFields.put(ruleaction.Value.substringAfter('.'), True);
                                system.debug('Test Condition 1:'+ TestConditionFields);
                            }
                            if(actionobjCreated.containsKey(ruleaction.resultObject)){
                                classbody = classbody + actionObj+ ' = new '+ ruleaction.resultObject+'();\\n';
                                system.debug('I am here 1'+ actionobjCreated);
                            }
                            else{
                                classbody = classbody + ruleaction.resultObject +' '+actionObj+ ' = new '+ ruleaction.resultObject+'();\\n';
                                actionobjCreated.put(ruleaction.resultObject, true);
                            }
                            
                            classbody = classbody +actionObj+'.'+ruleaction.Field+' = '+ruleaction.Value+';\\n';
                        }
                    }
                    if(ruleaction.Type == 'Update Field'){
                        if(ruleaction.Value.containsignorecase('CONTEXT')){     // Action Value context{somevalue}.fieldname
                            ruleaction.Value = 'primaryObj'+ruleaction.Value.substringAfter('}');
                            TestConditionFields.put(ruleaction.Value.substringAfter('.'), True);
                            system.debug('Test Condition 2:'+ TestConditionFields);
                        }
                        if(actionObj != null)
                            classbody = classbody + actionObj+'.'+ruleaction.Field+' = '+ruleaction.Value+';\\n';   //updating the fields in Result object
                    }
                    
                    if(actionIndex != actionsforthisrule.size()){
                        if(actionsforthisrule[actionIndex].Type == 'Add Record'){
                            classbody = classbody + actionObj+'List.add('+actionObj+');\\n';    //To implement multiple record creation in a single rule
                            classbody = classbody + actionObj+' = new '+ ruleaction.resultObject+'();\\n';
                        }
                    }
                    
                    if(actionIndex == actionsforthisrule.size()){
                        classbody = classbody + actionObj+'List.add('+actionObj+');\\n';
                    }   
                    actionIndex += 1;
                }
            }
            classbody = classbody + 'System.debug(\'Rule Passed: '+rule.Name+'\');\\n';
            classbody = classbody + '} \\n';  // End of action execution for this rule
            
            if(Context.RuleExecution != 'All') 
                break;
            
            testRuleCondtions.put(ruleIndex, conditionsPerRule);
            //System.debug('Conditions for Rule Index '+ruleIndex+' are: '+testRuleCondtions.get(ruleIndex));
            conditionsPerRule = new List<String>();			// re-initialize the list for next rule
            ruleIndex =  ruleIndex + 1;
        } // End of rule
        System.debug('Total Number of Rules ' + ruleIndex);
        
        classbody = classbody + '}\\n'; //End of loop for Input Object List
        for(String objName: actionObjSet){
            if(objName != context.RelatedObjectName){
                classbody = classbody + 'If('+ objName.replaceAll('_', '')+'ObjList.size() > 0){\\n';
                classbody = classbody + 'List <Database.SaveResult> saveResults = Database.insert('+objName.replaceAll('_', '')+'ObjList, false);\\n';
                classbody = classbody + 'for (Database.SaveResult saveResult : saveResults){\\n';
                classbody = classbody + 'if (saveResult.isSuccess() != true){\\n';
                classbody = classbody + 'for(Database.Error error : saveResult.getErrors()){\\n';
                classbody = classbody + 'System.debug(\'Error inserting '+objName+' \' + saveResult.getId() + \' : \' + error.getStatusCode() + \' - \' + error.getMessage());\\n';
                classbody = classbody + '}\\n}\\n}\\n}\\n';
            }
        }
        classBody =  classBody + 'Result.updatedinputList = primaryObjList;\\n';
        classBody =  classBody + 'Result.inputUpdated = '+inputUpdated+';\\n';
        classBody =  classBody + 'Result.Status = \'Success\';\\n return Result; \\n';
        classBody =  classBody +'\\n}\\n'; // End of Perform method
        
        //Condition table code
        Integer cIndex = 0;
        classBody = classbody + 'Private void UpdateConditionTable('+Context.RelatedObjectName+' obj, '+Context.RelatedObjectName+' oldObj){\\n';
        classBody = classbody + 'initConditionTable();\\n';
        for(RuleConditions_V2 condition: ConditionList){
            if(conditionsUsed.contains(condition.Identifier)){
                if(condition.Value.deleteWhitespace().containsIgnoreCase('ISCHANGED')){
                    if(condition.Value.containsAny('{:}')){
                        //CONDITION FORMAT - ISCHANGED{FROMVALUE:TOVALUE}
                        String source = condition.Value.substringBetween('{',':');
                        String target = condition.Value.substringBetween(':','}');
                        classBody = classbody + 'try{\\nIf ((oldObj  != null) && (oldObj.'+condition.FieldName+' == '+source+' && obj.'+condition.FieldName+' == '+target+')){\\n';
                        classBody = classbody + 'ConditionTable.put(\''+condition.Identifier+'\', TRUE);\\n}\\n';
                        classBody = classbody + 'if(Test.isRunningTest()){\\nthrow new RulesCustomException(\'Testing Exception\');\\n}\\n';
                        classbody = classbody + '}Catch(Exception e){\\n';
                        classbody = classbody + 'System.debug(\'Exception occured\'+e);\\n}\\n'; 
                    }
                    else{
                        //CONDITION FORMAT - ISCHANGED
                        classBody = classbody + 'try{\\nIf ((oldObj  != null) && (obj.'+condition.FieldName+' != oldObj.'+condition.FieldName+')){\\n';
                        classBody = classbody + 'ConditionTable.put(\''+condition.Identifier+'\', TRUE);}\\n';
                        classBody = classbody + 'if(Test.isRunningTest()){\\nthrow new RulesCustomException(\'Testing Exception\');\\n}\\n';
                        classbody = classbody + '}Catch(Exception e){\\n';
                        classbody = classbody + 'System.debug(\'Exception occured\'+e);\\n}\\n'; 
                    }
                }
                else if(condition.Value.deleteWhitespace().containsIgnoreCase('NOTCHANGED')){ 
                    //CONDITION FORMAT - NOTCHANGED
                    classBody = classbody + 'try{\\nIf ((oldObj  != null) && (obj.'+condition.FieldName+' == oldObj.'+condition.FieldName+')){\\n';
                    classBody = classbody + 'ConditionTable.put(\''+condition.Identifier+'\', TRUE);\\n}\\n';
                    classBody = classbody + 'if(Test.isRunningTest()){\\nthrow new RulesCustomException(\'Testing Exception\');\\n}\\n';
                    classbody = classbody + '}Catch(Exception e){\\n';
                    classbody = classbody + 'System.debug(\'Exception occured\'+e);\\n}\\n'; 
                }
                else if(condition.Value.containsIgnoreCase('CONTAINS')){
                    //CONDITION FORMAT - CONTAINS(VALUE) or CONTAINS(VALUE1;VALUE2;VALUE3)
                    classBody = classbody + 'try{\\nif(obj.'+condition.FieldName+'.'+condition.Value+'){\\n';
                    classBody = classbody + 'ConditionTable.put(\''+condition.Identifier+'\', TRUE);\\n}\\n';
                    classBody = classbody + 'if(Test.isRunningTest()){\\nthrow new RulesCustomException(\'Testing Exception\');\\n}\\n';
                    classbody = classbody + '}Catch(Exception e){\\n';
                    classbody = classbody + 'System.debug(\'Exception occured \'+e);\\n}\\n'; 
                }
                else if(condition.ParentFieldName != 'None'){
                    //CONDITION is referring to Parent field 
                    classBody = classbody + 'try{\\nif(obj.'+condition.ParentFieldName+' '+condition.Value+'){\\n';
                    classBody = classbody + 'ConditionTable.put(\''+condition.Identifier+'\', TRUE);\\n}\\n';
                    classBody = classbody + 'if(Test.isRunningTest()){\\nthrow new RulesCustomException(\'Testing Exception\');\\n}\\n';
                    classbody = classbody + '}Catch(Exception e){\\n';
                    classbody = classbody + 'System.debug(\'Exception occured\'+e);\\n}\\n'; 
                }
                else{
                    //CONDITION FORMAT - == VALUE or != VALUE or > VALUE (Works for any valid Apex operator)
                    classBody = classbody + 'try{\\nif(obj.'+condition.FieldName+' '+condition.Value+'){ \\n';
                    classBody = classbody + 'ConditionTable.put(\''+condition.Identifier+'\', TRUE);\\n}\\n';
                    classBody = classbody + 'if(Test.isRunningTest()){\\nthrow new RulesCustomException(\'Testing Exception\');\\n}\\n';
                    classbody = classbody + '}Catch(Exception e){\\n';
                    classbody = classbody + 'System.debug(\'Exception occured\'+e);\\n}\\n'; 
                }
            }
            Else{
                System.debug('Condition is not used in this ruleset: '+condition);
            }
        }
        classbody =  classbody +'System.debug(\'Condition Table: \'+ConditionTable);\\n}\\n'; // end of updateConditionTable method
        
        // Init Condition table code
        classBody = classbody + 'Private void initConditionTable(){\\n';
        //system.debug('Condition List for init Table '+ ConditionList);
        for(RuleConditions_V2 condition: ConditionList){
            if(conditionsUsed.contains(condition.Identifier)){
                classbody = classbody + 'ConditionTable.put(\''+condition.Identifier+'\', False);\\n';
            }
        }
        classBody = classbody + '}\\n';	//End of initConditionTable
        
        classbody =  classbody +'\\n}';   //End of class
        system.debug('Class Format===> '+classbody);
        
        // Get all the Input Object Fields used in defininf various actions
        if(TestConditionFields.size()>0){
            Map<String, Schema.SObjectType> myschemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType mySchema = myschemaMap.get(context.RelatedObjectName);
            Map<String, Schema.SObjectField> fieldMap = mySchema.getDescribe().fields.getMap();
            for(String fieldName: fieldMap.keySet()) {
                for(String field: TestConditionFields.keySet()){
                    if(field.containsIgnoreCase(fieldName)){
                        TestConditionFields.put(fieldName, TestConditionFields.get(field));
                        TestConditionFields.remove(field);
                        break;
                    }
                }
            }
        }
        System.debug('TestConditionFields:' + TestConditionFields);
        return true;
    }
    
    /*********************************************************************************
*                      Createing  Test Class Body Method                        * 
*********************************************************************************/     
    private Static void createTestClassBody(){
        system.debug('I was called from createTestClassBody');
        boolean firstcondition = true;				// used for inserting comma in query fields
        boolean parentused = false;			// used to check if SOQL neeeded or not
        String SOQLFields = '';		// Used to construct a query to retrive all fields for input object
        
        //Test Clas Start =>
        testClassBody =  '@isTest\\n';
        testClassBody = testClassBody + 'Public Class '+ testClassName +'{\\n';		//Test Class Start
        
        testClassBody = testClassBody + 'Public static testMethod '+Context.RelatedObjectName+' setDummyValues(){\\n';		// Setting Dummy Values
        testClassBody = testClassBody + SetRequiredFieldValues('primaryObj', Context.RelatedObjectName); //Set all the required fields from Schema
        testClassBody = testClassBody + 'return primaryObj; \\n}\\n';
        
        testClassBody = testClassBody + 'Public static testMethod Active_Rule__c setCustomSetting(){\\n';	//Custom Setting values
        testClassBody = testClassBody + 'Active_Rule__c myrule = new Active_Rule__c();\\n';
        testClassBody = testClassBody + 'myrule.Name = \''+Catalog[0].Name__c+'\';\\n';
        testClassBody = testClassBody + 'myrule.Class_Name__c = \''+className+'\';\\n';
        testClassBody = testClassBody + 'insert myrule;\\n';
        testClassBody = testClassBody + 'return myrule; \\n}\\n';
        
        // Create test method for each rule 
        for(integer rID=0; rId<ruleList.size(); rID++){
            firstcondition = true; 
            SOQLFields = '';	
            testClassBody = testClassBody +'Public static testMethod void TestRule'+(rID+1)+'(){\\n';
            testClassBody = testClassBody + 'Active_Rule__c myrule = setCustomSetting();\\n';
            testClassBody = testClassBody + Context.RelatedObjectName+' primaryObj = setDummyValues();\\n';
            testClassBody = testClassBody + Context.RelatedObjectName+' oldprimaryObj = setDummyValues();\\n';
            List<String> rConditions = testRuleCondtions.get(rID);
            for(String rCid: rConditions){
                for(RuleConditions_V2 condition: conditionList){
                    if(rcID == condition.Identifier){
                        //Check if the field is system fields. Do not write if the fields are System related
                        if(!condition.writableField){
                            break;//Do nothing
                        }
                        if(condition.Value.containsIgnoreCase('ISCHANGED')){
                            //Dont know how to do testing
                            if(condition.Value.containsAny('{:}')){		//CONDITION FORMAT - ISCHANGED{FROMVALUE:TOVALUE}
                                testClassBody = testClassBody + 'oldprimaryObj.'+condition.FieldName+' = '+condition.Value.substringBetween('{',':')+';\\n';
                                testClassBody = testClassBody + 'primaryObj.'+condition.FieldName+' = '+condition.Value.substringBetween(':','}')+';\\n';
                            }
                            else{
                                String NewcValue = getDummyFieldValues(context.RelatedObjectName, condition.FieldName, condition.FieldType, False);
                                String OldcValue = getDummyFieldValues(context.RelatedObjectName, condition.FieldName, condition.FieldType, True);
                                testClassBody = testClassBody + 'primaryObj.'+NewcValue;
                                testClassBody = testClassBody + 'oldprimaryObj.'+OldcValue;
                            }
                        }
                        else if (condition.Value.containsIgnoreCase('NOTCHANGED')){
                            String NewcValue = getDummyFieldValues(context.RelatedObjectName, condition.FieldName, condition.FieldType, False);
                            testClassBody = testClassBody + 'primaryObj.'+NewcValue+'\\n';
                            testClassBody = testClassBody + 'oldprimaryObj.'+NewcValue+'\\n';
                        }
                        else if(condition.Value.containsIgnoreCase('CONTAINS')){
                            if(!condition.Value.substringAfter('CONTAINS').contains(';')){
                                // Not  a multipicklist contains
                                testClassBody = testClassBody + 'primaryObj.'+condition.FieldName+' = '+condition.Value.substringBetween('(',')')+';\\n';
                            }
                            else{
                                testClassBody = testClassBody + 'primaryObj.'+condition.FieldName+' = '+condition.Value.substringBetween('(',';')+';\\n';
                            }
                        }
                        else if(condition.ParentFieldName != 'None'){
                            if(condition.multiParentField == false){
                                String parent = condition.FieldType.substringbetween('(',')');
                                System.debug('Parent Object inside TestClass Rule' + parent);
                                testClassBody = testClassBody + SetRequiredFieldValues('Parent', parent);	// Get the required fields for parent object
                                testClassBody = testClassBody +' Parent'+condition.ParentFieldName.substringAfter('__r')+' = '+getConditionValue(condition.Value)+';\\n';
                                testClassBody = testClassBody +'try{\\n';
                                testClassBody = testClassBody +'Insert Parent;\\n';	
                                testClassBody = testClassBody + 'primaryObj.'+condition.FieldName+' = Parent.Id;\\n';
                                testClassBody = testClassBody + '}\\ncatch(Exception e){\\n';
                                testClassBody = testClassBody + 'System.debug(e);\\n}\\n';
                                SOQLFields = SOQLFields+','+condition.ParentFieldName;
                                parentused = true;
                            }
                        }
                        else{
                            // Expecting condition Values with Normal operators
                            testClassBody = testClassBody + 'primaryObj.'+condition.FieldName+' = '+ getConditionValue(condition.Value) + ';\\n';
                        }
                    }
                }
            }
            testClassBody = testClassBody +'try{\\n';
            testClassBody = testClassBody +'insert primaryObj;\\n';
            if(parentused){
                testClassBody = testClassBody +'String objID = String.valueOf(primaryObj.Id);\\n';
                testClassBody = testClassBody +'String Fields = TestRulesUtilityClass.getFields(primaryObj.id);\\n';
                testClassBody = testClassBody + 'primaryObj = Database.query(\' Select \'+Fields+\''+SOQLFields+' FROM '+context.RelatedObjectName+' Where Id =: objID\');\\n';
            }
            testClassBody = testClassBody + '}\\ncatch(Exception e){\\n';
            testClassBody = testClassBody + 'System.debug(\'Exception executing TestRule'+(rID+1)+'\'+ e);\\n}\\n';
            testClassBody = testClassBody +'oldprimaryObj.id = primaryObj.id;\\n';
            testClassBody = testClassBody +'RulesResultClass_V2 result = RulesEngine_V2.Invoke(myrule.name, primaryObj, oldprimaryObj);\\n';
            testClassBody = testClassBody + '}\\n';
        }
        testClassBody = testClassBody + '}'; // End of test class
        system.debug('Test Class Format===> '+testclassbody);
    }
    
    /*********************************************************************************
*                           Class Compilation Method                            * 
*********************************************************************************/  
    private static boolean insertClass(){
        system.debug('I was called from insertClass');
        String JSON = '{ "Name" : "'+className+'", "Body" : "'+classBody+'" }'; 
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v36.0/sobjects/ApexClass');
        req.setMethod('POST');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON);
        Http h = new Http();
        HttpResponse res = h.send(req);
        if (res.getStatusCode() != 201) {
            ErrorMessage = 'Following Errors occured while Compiling Apex Class: Status Code = '+res.getStatusCode()+' :'+
                'Status = '+res.getBody();
            system.debug('ErrorMessage from InsertClass: ' + ErrorMessage);
            return false;
        }
        return true;
    }
    
    /*********************************************************************************
*                         Test Class Compilation Method                         * 
*********************************************************************************/  
    private static boolean insertTestClass(){
        system.debug('I was called from insertTestClass');
        String JSON = '{ "Name" : "'+testclassName+'", "Body" : "'+testclassBody+'" }'; 
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v36.0/sobjects/ApexClass');
        req.setMethod('POST');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON);
        Http h = new Http();
        HttpResponse res = h.send(req);
        // Response to a create should be 201
        if (res.getStatusCode() != 201) {
            System.debug(res.getBody());
            System.debug(res.toString());
            System.debug('STATUS_CODE:'+res.getStatusCode());
            System.debug('STATUS:'+res.getStatus());
            //throw new MyException(res.getStatus());
            ErrorMessage = 'Following Errors occured while Compiling Apex Test Class: Status Code = '+res.getStatusCode()+' :'+
                'Status = '+res.getBody();
            system.debug('ErrorMessage from insertTestClass' + ErrorMessage);
            return false;
        }
        return true;
    }    
    /*********************************************************************************
*                           Class Re-Compilation Methods                        * 
*********************************************************************************/    
    private static boolean updateClass(){
        system.debug('I was called from updateClass');
        HttpResponse response;
        HTTPRequest req;
        String resBody;
        String containerId;
        if(ruleset.Class_Name__c != 'Not Available' || ruleset.Class_Name__c != null){
            List<apexclass> classes = [Select Id, name from ApexClass where Name=: ruleset.Class_Name__c limit 1];
            if(classes.size() == 0){
                ErrorMessage = 'No class found with Name: '+ruleset.Class_Name__c;
                return false;
            }
            // 1) Create a New Metadatacontainer object
            ruleset.Metadata_Container_UniqueId__c += 1;
            String MetadataContainerName = 'NewMetadataContainer'+ruleset.Version__c.remove('-')+ruleset.Metadata_Container_UniqueId__c;
            req = createHttpRequest('/sobjects/data/v36.0/tooling/query/?q=Select+id,Name+from+MetadataContainer+Where+ID=\''+MetadataContainerName+'\'','GET');
            response = getResponse(req);
            if(response.getStatus() == 'FOUND'){
                ruleset.Metadata_Container_UniqueId__c += 1;
                MetadataContainerName = 'NewMetadataContainer'+ruleset.Version__c.remove('-')+ruleset.Metadata_Container_UniqueId__c;
            }
            ruleset.Metadata_Container_Id__c = MetadataContainerName;
            req = createHttpRequest('/services/data/v36.0/tooling/sobjects/MetadataContainer/', 'POST');
            req.setBody('{"Name":"'+MetadataContainerName+'"}');
            response = getResponse(req);
            if (response.getStatusCode() != 201){
                ErrorMessage = ('updateClass failed from Metadatacontainer '+response.getBody());
                return false;
            }
            resBody = response.getBody();
            Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(resBody);
            containerid = (String)rmp.get('id');
            
            // 2) Create ApexClassMember object to update Apex Class
            req = createHttpRequest('/services/data/v36.0/tooling/sobjects/ApexClassMember/', 'POST');
            req.setBody('{"MetadataContainerId" : "'+containerid+'", "ContentEntityId" : "'+classes[0].id+'", "Body": "'+classbody+'"}');
            response = getResponse(req);
            if (response.getStatusCode() != 201){
                ErrorMessage = 'updateClass failed from ApexClassMember '+response.getbody();
                return false;
            }
            resBody = response.getBody();
            rmp = (Map<String,Object>)JSON.deserializeuntyped(resBody);
            String apmid = (String)rmp.get('id');           // Store ApexClassMember Id
            
            // 3) To update a class ContainerAsyncRequest object is used. It compile and deploy the code and provide status of code
            req = createHttpRequest('/services/data/v36.0/tooling/sobjects/containerAsyncRequest/', 'POST');
            req.setBody('{"MetadataContainerId" : "'+containerid+'", "isCheckOnly": "false"}');
            response = getResponse(req);
            if (response.getStatusCode() != 201){
                ErrorMessage = 'updateClass failed from containerAsyncRequest'+response.getBody();
                return false;
            }
            resBody = response.getBody(); 
            rmp = (Map<String,Object>)JSON.deserializeuntyped(resBody);
            String carid = (String)rmp.get('id');
            
            // 4) Get the status of Deployed code
            req = createHttpRequest('/services/data/v36.0/tooling/sobjects/containerAsyncRequest/'+carid, 'GET');
            response = getResponse(req);
            //system.debug('Response' + response.getBody());
            resBody = response.getBody(); 
            rmp = (Map<String,Object>)JSON.deserializeuntyped(resBody);
            // For(String hkey: rmp.keySet()){
            //     System.debug('Key: '+hkey+ 'value: '+rmp.get(hkey));
            // }
            //System.debug('DeployDetails:' + rmp.get('DeployDetails'));
            String State = (String)rmp.get('State');
            ruleset.AsyncRequestID__c = (String)rmp.get('Id');
            if(State == 'Completed'){
                ruleset.status__c = 'Compiled';
            }
            else
                if(State == 'Failed'){
                    ruleset.status__c = 'Compile-Failed';
                    ErrorMessage = 'Class Recompilation Failed: '+ (String)rmp.get('ErrorMsg');
                    System.debug('ErrorMessage'+ ErrorMessage);
                    ruleset.Compile_Errors__c = ErrorMessage;
                }
            else
                ruleset.status__c = State;
            return true;
        }
        else{
            ErrorMessage = 'Class Name not available for re-compilation';
            return false;
        }
    }
    public static Ruleset__c updateTestClass(Ruleset__c tempruleset){
        system.debug('I was called from updateTestClass' + tempruleset.Catalog_ID__c);
        HttpResponse response;
        HTTPRequest req;
        String resBody;
        String containerId;
        if(tempruleset.Test_Class_Body__c != '' || tempruleset.Test_Class_Body__c != null){
            testClassBody = tempruleset.Test_Class_Body__c;
        }
        if(tempruleset.Test_Class_Name__c != 'Not Available' || tempruleset.Test_Class_Name__c != null){
            List<apexclass> classes = [Select Id, name from ApexClass where Name=: tempruleset.Test_Class_Name__c limit 1];
            if(classes.size() == 0){
                ErrorMessage = 'No class found with Name: '+tempruleset.Test_Class_Name__c;
                if('Pending'.equalsignoreCase(tempruleset.Test_Class_Status__c) && 'Not Available'.equalsignoreCase(tempruleset.Test_Class_Name__c) && tempruleset.Test_Class_Body__c != null){
                    system.debug('Attempting to write Test Class'); 
                    testclassname = 'Test'+tempruleset.Class_Name__c;
                    testclassbody = tempruleset.Test_Class_Body__c;
                    if(!insertTestClass()){
                        tempruleset.Test_Class_Status__c = 'Compile-Failed';
                    }
                    else
                        tempruleset.Test_Class_Status__c = 'Compiled';
                }
                return tempruleset;
            }
            // 1) Create a New Metadatacontainer object
            tempruleset.Metadata_Container_UniqueId__c += 1;
            String MetadataContainerName = 'NewMetadataContainer'+tempruleset.Version__c+tempruleset.Metadata_Container_UniqueId__c;
            tempruleset.Metadata_Container_Id__c = MetadataContainerName;
            req = createHttpRequest('/services/data/v36.0/tooling/sobjects/MetadataContainer/', 'POST');
            req.setBody('{"Name":"'+MetadataContainerName+'"}');
            response = getResponse(req);
            if (response.getStatusCode() != 201){
                ErrorMessage = ('updateClass failed from Metadatacontainer '+response.getBody());
                tempruleset.Test_Class_Status__c = 'Compile-Failed';
                system.debug('Test:updateClass failed from Metadatacontainer '+response.getBody());
                return tempruleset;
            }
            resBody = response.getBody();
            Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(resBody);
            containerid = (String)rmp.get('id');
            
            // 2) Create ApexClassMember object to update Apex Class
            req = createHttpRequest('/services/data/v36.0/tooling/sobjects/ApexClassMember/', 'POST');
            req.setBody('{"MetadataContainerId" : "'+containerid+'", "ContentEntityId" : "'+classes[0].id+'", "Body": "'+testclassbody+'"}');
            response = getResponse(req);
            if (response.getStatusCode() != 201){
                ErrorMessage = 'updateClass failed from ApexClassMember '+response.getbody();
                tempruleset.Test_Class_Status__c = 'Compile-Failed';
                System.debug('Test Class update failed1');
                return tempruleset;
            }
            resBody = response.getBody();
            rmp = (Map<String,Object>)JSON.deserializeuntyped(resBody);
            String apmid = (String)rmp.get('id');           // Store ApexClassMember Id
            
            // 3) To update a class ContainerAsyncRequest object is used. It compile and deploy the code and provide status of code
            req = createHttpRequest('/services/data/v36.0/tooling/sobjects/containerAsyncRequest/', 'POST');
            req.setBody('{"MetadataContainerId" : "'+containerid+'", "isCheckOnly": "false"}');
            response = getResponse(req);
            if (response.getStatusCode() != 201){
                ErrorMessage = 'updateClass failed from containerAsyncRequest'+response.getBody();
                tempruleset.Test_Class_Status__c = 'Compile-Failed';
                System.debug('Test Class update failed2');
                return tempruleset;
            }
            resBody = response.getBody(); 
            rmp = (Map<String,Object>)JSON.deserializeuntyped(resBody);
            String carid = (String)rmp.get('id');
            
            // 4) Get the status of Deployed code
            req = createHttpRequest('/services/data/v36.0/tooling/sobjects/containerAsyncRequest/'+carid, 'GET');
            response = getResponse(req);
            //system.debug('Response' + response.getBody());
            resBody = response.getBody(); 
            rmp = (Map<String,Object>)JSON.deserializeuntyped(resBody);
            String State = (String)rmp.get('State');
            tempruleset.TestClassAsyncRequestID__c = (String)rmp.get('Id');
            if(State == 'Completed'){
                tempruleset.Test_Class_Status__c = 'Compiled';
                tempruleset.Compile_Errors__c = 'None';
                tempruleset.Test_Class_Body__c = '';
            }
            else
                if(State == 'Failed'){
                    tempruleset.Test_Class_Status__c = 'Compile-Failed';
                    tempruleset.Test_Class_Body__c = '';
                }
            else{
                tempruleset.Test_Class_Status__c = State;
                tempruleset.Test_Class_Body__c = '';
            }
            System.debug('Test Class State '+ State);
        }
        else{
            ErrorMessage = 'Class Name not available for re-compilation';
        }
        System.debug('Test Class final retrun :' +tempruleset.Catalog_ID__c);
        return tempruleset;
    }
    public static Ruleset__c getAsyncStatus(Ruleset__c tempruleset){ 
        System.debug('I was called from getAsyncStatus');
        if(tempruleset.AsyncRequestID__c != Null){
            HttpRequest req = new HttpRequest();
            req = createHttpRequest('/services/data/v36.0/tooling/sobjects/containerAsyncRequest/'+tempruleset.AsyncRequestID__c, 'GET');
            HTTPResponse response = getResponse(req);
            String resBody = response.getBody(); 
            Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(resBody);
            
            // system.debug('Response' + rmp);
            String State = (String)rmp.get('State');
            System.debug('State from getAsyncStatus: '+State);
            //  For(String hkey: rmp.keySet()){
            //  System.debug('Key: '+hkey+ 'value: '+rmp.get(hkey));
            // }
            // System.debug('DeployDetails:' + rmp.get('DeployDetails'));
            tempruleset.AsyncRequestID__c = (String)rmp.get('Id');
            if(State == 'Completed'){
                tempruleset.status__c = 'Compiled'; 
                System.debug('Before getAsyncStatus State Completed:' + tempruleset.Catalog_ID__c);
                tempruleset = updateTestClass(tempruleset);
                System.debug('getAsyncStatus State Completed:' + tempruleset.Catalog_ID__c);
            }
            else
                if(State == 'Failed'){
                    System.debug('Compile failed from getAsyncStatus');
                    tempruleset.status__c = 'Compile-Failed';
                    ErrorMessage = 'Class Recompilation Failed: '+(String)rmp.get('ErrorMsg');
                    tempruleset.Compile_Errors__c = ErrorMessage;
                    System.debug('Error message from getAsyncStatus: '+ ErrorMessage);
                }
            else{
                tempruleset.status__c = State;
            }
            System.debug('Ruleset Class State '+ State);
        }
        system.debug('TempRuleset from getAsyncStatus'+ tempruleset.Catalog_ID__c);
        return tempruleset;
    }
    public static Ruleset__c getTestClassAsyncStatus(Ruleset__c tempruleset){ 
        System.debug('I was called from getTestClassAsyncStatus');
        if(tempruleset.TestClassAsyncRequestID__c != Null){
            HttpRequest req = new HttpRequest();
            req = createHttpRequest('/services/data/v36.0/tooling/sobjects/containerAsyncRequest/'+tempruleset.TestClassAsyncRequestID__c, 'GET');
            HTTPResponse response = getResponse(req);
            String resBody = response.getBody(); 
            Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(resBody);
            system.debug('Response' + rmp);
            String State = (String)rmp.get('State');
            tempruleset.TestClassAsyncRequestID__c = (String)rmp.get('Id');
            if(State == 'Completed'){
                tempruleset.Test_Class_Status__c = 'Compiled'; 
            }
            else if(State == 'Failed'){
                tempruleset.Test_Class_Status__c = 'Compile-Failed';
                ErrorMessage = 'Test Class Recompilation Failed: '+(String)rmp.get('ErrorMsg');
            }
            else{
                tempruleset.Test_Class_Status__c = State;
            }
            System.debug('Test Class State '+ State);
        }
        return tempruleset;
    }    
    
    /*********************************************************************************
*                               HTTP Related Methods                            * 
*********************************************************************************/   
    public static HttpRequest createHttpRequest(String endpoint, String method){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + endpoint);
        req.setMethod(method);
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        return req;
    }
    public static HttpResponse getResponse(HttpRequest req){
        Http httpreq = new Http();
        HttpResponse res = httpreq.send(req);
        return res;
        
    }
    
    /*********************************************************************************
*                         General Utility Methods                               * 
*********************************************************************************/
    public static String getConditionValue(String Value){
        String formattedValue = 'None';
        if(Value.deleteWhitespace().startsWith('=='))
            formattedValue =  Value.remove('==');
        if(Value.deleteWhitespace().startsWith('!='))
            formattedValue = Value.remove('!=');
        if(Value.deleteWhitespace().startsWith('>')){
            if(Value.deleteWhitespace().startsWith('>='))
                formattedValue = Value.remove('>=')+'+1';
            else
                formattedValue = Value.remove('>')+'+1';  
        }
        if(Value.deleteWhitespace().startsWith('<')){
            if(Value.deleteWhitespace().startsWith('<='))
                formattedValue = Value.remove('<=')+'-1';
            else
                formattedValue = Value.remove('<')+'-1';
        }
        return formattedValue;
    }
    
    public static String getDummyFieldValues(String ObjectName, String FieldName, String FieldType, boolean forOld){
        String result;
        if(FieldType.containsIgnoreCase('Boolean')){
            result = FieldName+' = '+'False;\\n';
            if(forOld)
                result = FieldName+' = '+'True;\\n';
        }
        else if(FieldType.containsIgnoreCase('String') || FieldType.containsIgnoreCase('TextArea') ||
                FieldType.containsIgnoreCase('Picklist') || FieldType.containsIgnoreCase('MultiPicklist')){
                    result = FieldName+' = '+' \'TEST\';\\n';
                    if(FieldType.containsIgnoreCase('Picklist') || FieldType.containsIgnoreCase('MultiPicklist')){
                        String pvalue = FindPicklistFieldValues(ObjectName,FieldName);
                        if(pvalue != 'none_found'){
                            result = FieldName+' = '+'\''+pvalue+'\';\\n';
                        }
                    }
                    if(forOld)
                        result = FieldName+' = '+' \'OLD\';\\n';
                }
        else if(FieldType.containsIgnoreCase('Integer') || FieldType.containsIgnoreCase('Double') ||
                FieldType.containsIgnoreCase('Currency') || FieldType.containsIgnoreCase('Percent')){
                    result = FieldName+' = '+' 0;\\n';
                    if(forOld)
                        result = FieldName+' = '+' 1;\\n';
                }
        else if(FieldType.containsIgnoreCase('Date')){
            result = FieldName+' = '+' System.Today();\\n';
            if(forOld)
                result = FieldName+' = '+' System.Today()-10;\\n';
        }
        else if(FieldType.containsIgnoreCase('DateTime')){
            result = FieldName+' = '+' System.Now();\\n';
            if(forOld)
                result = FieldName+' = '+' System.Now()-10;\\n';
        }
        else
            result = FieldName+' = '+' null;\\n';	
        return result;
    }
    
    public static String FindPicklistFieldValues(String ObjectName, String FieldName){
        String result = 'Test';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType mySchema = schemaMap.get(ObjectName);
        Map<String, Schema.SObjectField> fieldMap = mySchema.getDescribe().fields.getMap();
        List<Schema.PicklistEntry> picklist_values = fieldMap.get(fieldName).getDescribe().getPicklistValues();
        if(picklist_values.size() > 0){
            result = String.valueOf(picklist_values[0].getValue()); 
        }
        return result;
    }
    
    public static String SetRequiredFieldValues(String objAlias, String ObjName){
        System.debug('I was called from SetRequiredFieldValues for '+ ObjName);
        //This method will set all the required fields of any given object
        Map<String, String> reqFields =  new Map<String, String>();
        String codeSnippet = '';
        Map<String, Schema.SObjectType> myschemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType mySchema = myschemaMap.get(ObjName);
        Map<String, Schema.SObjectField> fieldMap = mySchema.getDescribe().fields.getMap();
        for(String fieldName: fieldMap.keySet()) {
            Schema.SObjectField field = fieldMap.get(fieldName);
            Schema.DescribeFieldResult F = field.getDescribe();
            if(F.isNillable() == False || ((TestConditionFields.size()>0 && ObjName == Context.RelatedObjectName && TestConditionFields.containsKey(fieldName)) && TestConditionFields.get(fieldName))){
                if(F.getType() != Schema.DisplayType.BOOLEAN){
                    if(!fieldName.containsIgnoreCase('id') && !fieldName.containsIgnoreCase('ownerid') &&  !fieldName.containsIgnoreCase('isdeleted') &&
                       !fieldName.containsIgnoreCase('createddate') &&  !fieldName.containsIgnoreCase('createdbyid') &&
                       !fieldName.containsIgnoreCase('lastmodifieddate') && !fieldName.containsIgnoreCase('lastmodifiedbyid') && !fieldName.containsIgnoreCase('systemmodstamp')){
                           if(F.isUpdateable()){
                               if(F.getType() == Schema.DisplayType.REFERENCE )
                                   reqFields.put(fieldName, String.valueOf('REFERENCE '+fieldMap.get(fieldName).getDescribe().getReferenceTo()));
                               else
                                   reqFields.put(fieldName, String.valueOf(F.getType()));
                               if(TestConditionFields.containsKey(fieldName)){
                                   TestConditionFields.put(fieldName, False);
                                   System.debug('TestConditionFields3'+ TestConditionFields+':'+fieldName);
                               }
                           }
                       }
                    else{
                        if(TestConditionFields.containsKey(fieldName)){
                            TestConditionFields.put(fieldName, False);
                        } 
                    }
                }
            }
        }
        System.debug('Required Fields for: '+ObjName+' are:'+reqFields);
        codeSnippet = codeSnippet + ObjName+' '+objAlias+' = new '+ObjName+'();\\n';		//Init the given Object
        if(reqFields.size() > 0){
            for(String fieldName: reqFields.keySet()){
                if(reqFields.get(fieldName).containsIgnoreCase('Boolean')){
                    // codeSnippet = codeSnippet + objAlias+'.'+fieldName+' = False;\\n';
                }
                else 
                    if(reqFields.get(fieldName).containsIgnoreCase('String') || reqFields.get(fieldName).containsIgnoreCase('TextArea') ||
                       reqFields.get(fieldName).containsIgnoreCase('Picklist') || reqFields.get(fieldName).containsIgnoreCase('MultiPicklist')){
                           if(reqFields.get(fieldName).containsIgnoreCase('Picklist') || reqFields.get(fieldName).containsIgnoreCase('MultiPicklist')){
                               codeSnippet = codeSnippet + objAlias+'.'+fieldName+' = \''+FindPicklistFieldValues(ObjName, fieldName)+'\';\\n';
                           }
                           else
                               codeSnippet = codeSnippet + objAlias+'.'+fieldName+' = \'Test\';\\n';
                       }
                else 
                    if(reqFields.get(fieldName).containsIgnoreCase('Integer') || reqFields.get(fieldName).containsIgnoreCase('Double') ||
                       reqFields.get(fieldName).containsIgnoreCase('Currency') || reqFields.get(fieldName).containsIgnoreCase('Percent')){
                           codeSnippet = codeSnippet + objAlias+'.'+fieldName+' = 1;\\n';
                       }
                else
                    if(reqFields.get(fieldName).containsIgnoreCase('Date')){
                        codeSnippet = codeSnippet + objAlias+'.'+fieldName+' = System.Today();\\n';
                    }
                else
                    if(reqFields.get(fieldName).containsIgnoreCase('DateTime')){
                        codeSnippet = codeSnippet + objAlias+'.'+fieldName+' = System.Now();\\n';
                    }
                else
                    if(reqFields.get(fieldName).containsIgnoreCase('Email')){
                        codeSnippet = codeSnippet + objAlias+'.'+fieldName+' = \'test@sfdc.com\';\\n';
                    }
                else
                    if(reqFields.get(fieldName).containsIgnoreCase('Phone')){
                        codeSnippet = codeSnippet + objAlias+'.'+fieldName+' = \'1234567890\';\\n';
                    }
                else
                    if(reqFields.get(fieldName).containsIgnoreCase('Reference')){
                        String rObjName = reqFields.get(fieldName).substringBetween('(',')');		// Related Object Name
                        System.debug('rObjName:' + rObjName);
                        String rObjAlias = rObjName.remove('_')+'Obj';
                        codeSnippet = codeSnippet + SetRequiredFieldValues(rObjAlias,rObjName);		//Recursive Call
                        codeSnippet = codeSnippet +'insert '+rObjAlias+';\\n';
                        codeSnippet = codeSnippet + objAlias + '.'+fieldName+' = '+rObjAlias+'.id;\\n';
                    }
                else
                    codeSnippet = codeSnippet + objAlias+'.'+fieldName+' = null;\\n';		
            }
        }
        system.debug('Code Snippet' + codeSnippet);
        return codeSnippet;
    }
}