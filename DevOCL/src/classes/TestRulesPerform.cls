@isTest
public class TestRulesPerform implements RulesInterfaceClass_V2{
    Public RulesResultClass_V2 Perform(List<sObject> InputList, List<sObject> OldInputList){
        RulesResultClass_V2 result =  new RulesResultClass_V2();
        result.Status = 'Success';
        result.updatedinputList = InputList;
        return result;
    }
}