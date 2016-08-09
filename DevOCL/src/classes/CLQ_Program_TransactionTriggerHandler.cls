/* Name : CLQ_Program_TransactionTriggerHandler
* Description : This is an Example TriggerHandler Class.
*
*	CLQ_Program_TransactionTriggerHandler Handler = new CLQ_Program_TransactionTriggerHandler(trigger.new, trigger.newMap, trigger.old, trigger.oldMap,
*								trigger.isExecuting, trigger.isInsert, trigger.isUpdate, trigger.isDelete, 
*								trigger.isBefore, trigger.isAfter, trigger.isUndelete, trigger.size);
*	Handler.ProcessTrigger();
*/
public class CLQ_Program_TransactionTriggerHandler extends CLQ_Trigger
{
	////////////////////////////////     Boilerplate implementation  ////////////////////////////
	//Allows only this trigger to be bypassed. Useful in Unit Test data setup and some bulk data loads.
	public static boolean BypassTrigger
	{
		get
		{
			if (BypassTrigger == null) BypassTrigger = false;
			return BypassTrigger;
		}
		set;
	}
	
	//Calls the Base class Constructor
	public CLQ_Program_TransactionTriggerHandler(list<sObject> newlistin, map<id,sObject> newMapin, list<sObject> oldlistin, map<id,sObject> oldMapin,
						boolean isExecutingin, boolean isInsertin, boolean isUpdatein,   boolean isDeletein, 
						boolean isBeforein,    boolean isAfterin,  boolean isUndeletein, integer sizein)
	{
		super(newlistin, newMapin, oldlistin, oldMapin,
						isExecutingin, isInsertin, isUpdatein,   isDeletein, 
						isBeforein,    isAfterin,  isUndeletein, sizein); 
		BypassInheritedTrigger = BypassTrigger;
	}
	////////////////////////////////     Boilerplate implementation  ////////////////////////////
	
	public override void BeforeInsert()
	{
		Validation((list<CLQ_Program_Transaction__c>)newList);
	}
	public override void BeforeUpdate()
	{
		Validation((list<CLQ_Program_Transaction__c>)newList);
	}
	public override void AfterUpdate()
	{
		//get a map of all the potential programs for the prog trans to be updated in one transaction
		map<id, CLQ_Program__c> programsMap = new map<id, CLQ_Program__c>();
		set<id> allPrograms = new set<id>();
		for(CLQ_Program_Transaction__c trans : (list < CLQ_Program_Transaction__c > ) newlist){
			allPrograms.add(trans.CLQ_Program__c);
			system.debug('program added to list ' + trans.CLQ_Program__c);
		}
		list<CLQ_Program__c> programsList = [select id, CLQ_Continuous_License_Status__c from CLQ_Program__c where id in :allPrograms];
		for (CLQ_Program__c p : programsList){
			programsMap.put(p.id,p);
		}	
		//loop through the incoming program transactions and set the cont lic status to approved if the transaction is approved and is a cont lic type
		for(CLQ_Program_Transaction__c trans : (list < CLQ_Program_Transaction__c > ) newlist){
			if(trans.recordTypeid == Schema.SObjectType.CLQ_Program_Transaction__c.getRecordTypeInfosByName().get('Continuous License').getRecordTypeId() && trans.CLQ_Transaction_Status__c == 'Approved'){
				CLQ_Program__c programRecord = programsMap.get(trans.CLQ_Program__c);
				programRecord.CLQ_Continuous_License_Status__c = 'Approved';
				programsMap.put(trans.CLQ_Program__c,programRecord);
			}
		}
		//update all the programs at once
		update programsMap.values();
	}	
	public override void AfterInsert()
	{
		//get a map of all the potential programs for the prog trans to be updated in one transaction
		map<id, CLQ_Program__c> programsMap = new map<id, CLQ_Program__c>();
		set<id> allPrograms = new set<id>();
		for(CLQ_Program_Transaction__c trans : (list < CLQ_Program_Transaction__c > ) newlist){
			allPrograms.add(trans.CLQ_Program__c);
			system.debug('program added to list ' + trans.CLQ_Program__c);
		}
		list<CLQ_Program__c> programsList = [select id, CLQ_Continuous_License_Status__c from CLQ_Program__c where id in :allPrograms];
		for (CLQ_Program__c p : programsList){
			programsMap.put(p.id,p);
		}
		//loop through the incoming program transactions and set the cont lic status to initiated
		for(CLQ_Program_Transaction__c trans : (list < CLQ_Program_Transaction__c > ) newlist){
			if(trans.recordTypeid == Schema.SObjectType.CLQ_Program_Transaction__c.getRecordTypeInfosByName().get('Continuous License').getRecordTypeId()){
				CLQ_Program__c programRecord = programsMap.get(trans.CLQ_Program__c);
				programRecord.CLQ_Continuous_License_Status__c = 'Initiated';
				programsMap.put(trans.CLQ_Program__c,programRecord);
			}
		}
		//update all the programs at once
		update programsMap.values();
		
	}	
	public void Validation(list<CLQ_Program_Transaction__c> newList)
	{
		for(CLQ_Program_Transaction__c trans : newList)
		{
			if (trans.CLQ_Program__c == null)
				trans.CLQ_Program__c.AddError('The Program is a required field for a Program Tranaction');
		}
	}
}