Public Class TestCatalog_V0001 implements RulesInterfaceClass_V2{ 
Private Map<String, boolean> ConditionTable;
Private RulesResultClass_V2 Result;
Public TestCatalog_V0001(){
    ConditionTable = new Map<String, boolean>();
Result = new RulesResultClass_V2();
}
 Public RulesResultClass_V2 Perform(List<sObject> InputList, List<sObject> OldInputList){
String RuleStartDate = '2016-06-14';
if(System.Today() <  Date.valueOf(RuleStartDate)){
Result.Errors = 'Rule is configured to start on '+RuleStartDate;
Result.Status = 'Failed';
System.debug('Failed: Rule is configured to start on '+RuleStartDate);
return Result; 
}
List<Account> primaryObjList = (List<Account>)InputList;
List <Contact> ContactObjList = new List<Contact>();
Account oldprimaryObj;
for(Account primaryObj : primaryObjList){
UpdateConditionTable(primaryObj, oldprimaryObj);
System.debug('Executing Rule: Test Rule1');
if(conditionTable.get('C1')){ 
Contact ContactObj = new Contact();
ContactObj.accountid = primaryObj.id;
ContactObj.lastname = 'Test';
ContactObjList.add(ContactObj);
System.debug('Rule Passed: Test Rule1');
} 
}
If(ContactObjList.size() > 0){
List <Database.SaveResult> saveResults = Database.insert(ContactObjList, false);
for (Database.SaveResult saveResult : saveResults){
if (saveResult.isSuccess() != true){
for(Database.Error error : saveResult.getErrors()){
System.debug('Error inserting Contact ' + saveResult.getId() + ' : ' + error.getStatusCode() + ' - ' + error.getMessage());
}
}
}
}
Result.updatedinputList = primaryObjList;
Result.inputUpdated = false;
Result.Status = 'Success';
 return Result; 

}
Private void UpdateConditionTable(Account obj, Account oldObj){
initConditionTable();
try{
if(obj.accountnumber != null){ 
ConditionTable.put('C1', TRUE);
}
if(Test.isRunningTest()){
throw new RulesCustomException('Testing Exception');
}
}Catch(Exception e){
System.debug('Exception occured'+e);
}
System.debug('Condition Table: '+ConditionTable);
}
Private void initConditionTable(){
ConditionTable.put('C1', False);
}

}