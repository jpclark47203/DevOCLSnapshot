/*
 * @Author - Sujila Nair
 * Version - 2
*/
public class RulesEngine_V2 {
    private static RulesResultClass_V2 result = new RulesResultClass_V2();
    private static Active_Rule__c myrule;
    private static Type classtype ;

    private static boolean findClassName(String RuleName){
        myrule = Active_Rule__c.getValues(RuleName);	//Custom Settings
        if(myrule == null){
            result.Errors = 'Custom Settings with Name '+RuleName+' not found';
            result.Status = 'Failed';
            return false;
        }
        if(myrule.Class_Name__c != 'Not Available'){
            classtype = Type.forName('',myrule.Class_Name__c);
            return true;
        }
        else{
            result.Errors = 'No active class found for '+RuleName;
            result.Status = 'Failed';
            return false;
        }
    }
    public static RulesResultClass_V2 Invoke(String RuleName, List<sObject> InputList){
        system.debug('I was called from InputList');
        If(InputList.size() == 0 || InputList == null){
            result.Errors = 'No Valid Inputs to run the Rule';
            result.Status = 'Failed';
            return result;
        }
        if(findClassName(RuleName)){
            RulesInterfaceClass_V2 rule = (RulesInterfaceClass_V2)classtype.newInstance();
            result = rule.Perform(InputList, null);
        }
        return result;
    }
    public static RulesResultClass_V2 Invoke(String RuleName, List<sObject> InputList, List<sObject> OldInputList){
        system.debug('I was called from InputList,OldInputList');
        If(InputList.size() == 0 || InputList == null){
            result.Errors = 'No Valid Inputs to run the Rule';
            result.Status = 'Failed';
            return result;
        }
        if(findClassName(RuleName)){
            RulesInterfaceClass_V2 rule = (RulesInterfaceClass_V2)classtype.newInstance();
            result = rule.Perform(InputList, OldInputList);
        }
        return result;
    }
    public static RulesResultClass_V2 Invoke(String RuleName, sObject singleInput){
        system.debug('I was called from singleInput');
        If(singleInput == null){
            result.Errors = 'No Valid Inputs to run the Rule';
            result.Status = 'Failed';
            return result;
        }        
        if(findClassName(RuleName)){
            RulesInterfaceClass_V2 rule = (RulesInterfaceClass_V2)classtype.newInstance();
            result = rule.Perform(new List<SObject>{singleInput}, null);
        }
        return result;
    }
    public static RulesResultClass_V2 Invoke(String RuleName, sObject singleInput, sObject singleOldInput){
        system.debug('I was called from singleOldInput');
        If(singleInput == null){
            result.Errors = 'No Valid Inputs to run the Rule';
            result.Status = 'Failed';
            return result;
        }        
        if(findClassName(RuleName)){
            RulesInterfaceClass_V2 rule = (RulesInterfaceClass_V2)classtype.newInstance();
            result = rule.Perform(new List<SObject>{singleInput}, new List<SObject>{singleOldInput});
        }
        return result;
    }    
}