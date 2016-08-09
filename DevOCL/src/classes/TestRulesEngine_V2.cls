/************************************************************************
* Name   : TestRulesEngine_V2                                           *
* Author : Sujila R Nair                                                *
* Desc   : Testing of RulesEngine_V2 Class                              *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila R Nair |  04/22/2016  |  Original Version                      *
*************************************************************************/
@isTest
public class TestRulesEngine_V2 {
    public static testmethod List<Account> setDataforInvoke(){
        List<Account> acctList = new List<Account>();
        Account acct1 = new Account();
        acct1.Name = 'TestAccount1';
        acctList.add(acct1);
        Account acct2 = new Account();
        acct2.Name = 'TestAccount2';
        acctList.add(acct2);
        return acctList;
    }
    public static testmethod void testInvoke(){
        //Custom setting - null
        List<Account> acctList = setDataforInvoke();
        RulesResultClass_V2 result = RulesEngine_V2.Invoke('Test Rule', acctList[0]);
        
        //Custom setting - valid
        Active_Rule__c myrule = new Active_Rule__c();
        myrule.Name = 'Test Rule';
        myrule.Class_Name__c = 'TestRulesPerform';
        insert myrule;
        acctList = setDataforInvoke();
        result = RulesEngine_V2.Invoke('Test Rule', acctList[0]);
        result = RulesEngine_V2.Invoke('Test Rule', acctList);
        result = RulesEngine_V2.Invoke('Test Rule', acctList[0], acctList[0]);
        result = RulesEngine_V2.Invoke('Test Rule', acctList,acctList);
        String Errors = result.getErrors();
        List<Account> resultAcct = result.getResult();
        String statuc = result.getStatus();
        
        //Test Error Conditions
        myrule.Class_Name__c = 'Not Available';
        update myrule;
        result = RulesEngine_V2.Invoke('Test Rule', acctList[0]);
        
        Account a = null;
        result = RulesEngine_V2.Invoke('Test Rule', a);
        acctList.clear();
        result = RulesEngine_V2.Invoke('Test Rule', acctList);
        result = RulesEngine_V2.Invoke('Test Rule', a, a);
        result = RulesEngine_V2.Invoke('Test Rule', acctList,acctList);
    }
}