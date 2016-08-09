/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 */
@isTest
private class CLQ_TriggerTest 
{

    static testMethod void ConstructorTest() 
    {
    	list<CLQ_Program__c>  OldList = new list<CLQ_Program__c>();
    	OldList.Add(new CLQ_Program__c());
    	list<CLQ_Program__c>  NewList = new list<CLQ_Program__c>(OldList);
    	
    	//Before Insert
    	CLQ_Trigger trig = new CLQ_Trigger(NewList, null, OldList, null,
						true, true, false, false, 
						true, false, false, 1);
		system.AssertEquals('BeforeInsert', trig.TriggerExecutionType);
		trig.ProcessTrigger(); 

    	//After Insert
    	trig = new CLQ_Trigger(NewList, null, OldList, null,
						true, true, false, false, 
						false, true, false, 1);
		system.AssertEquals('AfterInsert', trig.TriggerExecutionType);
		trig.ProcessTrigger();

    	//Before Update
    	trig = new CLQ_Trigger(NewList, null, OldList, null,
						true, false, true, false, 
						true, false, false, 1);
		system.AssertEquals('BeforeUpdate', trig.TriggerExecutionType);
		trig.ProcessTrigger();

    	//After Update
    	trig = new CLQ_Trigger(NewList, null, OldList, null,
						true, false, true, false, 
						false, true, false, 1);
		system.AssertEquals('AfterUpdate', trig.TriggerExecutionType);
		trig.ProcessTrigger();

    	//Before Delete
    	trig = new CLQ_Trigger(NewList, null, OldList, null,
						true, false, false, true, 
						true, false, false, 1);
		system.AssertEquals('BeforeDelete', trig.TriggerExecutionType);
		trig.ProcessTrigger();

    	//After Delete
    	trig = new CLQ_Trigger(NewList, null, OldList, null,
						true, false, false, true, 
						false, true, false, 1);
		system.AssertEquals('AfterDelete', trig.TriggerExecutionType);
		trig.ProcessTrigger();

    	//Before UnDelete
    	trig = new CLQ_Trigger(NewList, null, OldList, null,
						true, false, false, false, 
						true, false, true, 1);
		system.AssertEquals('BeforeUndelete', trig.TriggerExecutionType);
		trig.ProcessTrigger();

    	//After UnDelete
    	trig = new CLQ_Trigger(NewList, null, OldList, null,
						true, false, false, false, 
						false, true, true, 1);
		system.AssertEquals('AfterUndelete', trig.TriggerExecutionType);
		trig.ProcessTrigger();

    	//Bypass Trigger
    	CLQ_Trigger.BypassAllTriggers = true;
		trig.ProcessTrigger();
    	CLQ_Trigger.BypassAllTriggers = false;
    	
    	CLQ_Program_TransactionTriggerHandler trig2 = new CLQ_Program_TransactionTriggerHandler(NewList, null, OldList, null,
						true, true, false, false, 
						true, false, false, 1);
    	CLQ_Program_TransactionTriggerHandler.BypassTrigger = true; 
		trig2.ProcessTrigger();
    }

}