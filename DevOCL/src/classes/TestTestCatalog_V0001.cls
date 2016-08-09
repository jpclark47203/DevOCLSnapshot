@isTest
Public Class TestTestCatalog_V0001{
Public static testMethod Account setDummyValues(){
Account primaryObj = new Account();
primaryObj.name = 'Test';
return primaryObj; 
}
Public static testMethod Active_Rule__c setCustomSetting(){
Active_Rule__c myrule = new Active_Rule__c();
myrule.Name = 'Test Catalog';
myrule.Class_Name__c = 'TestCatalog_V0001';
insert myrule;
return myrule; 
}
Public static testMethod void TestRule1(){
Active_Rule__c myrule = setCustomSetting();
Account primaryObj = setDummyValues();
Account oldprimaryObj = setDummyValues();
try{
insert primaryObj;
}
catch(Exception e){
System.debug('Exception executing TestRule1'+ e);
}
oldprimaryObj.id = primaryObj.id;
RulesResultClass_V2 result = RulesEngine_V2.Invoke(myrule.name, primaryObj, oldprimaryObj);
}
}