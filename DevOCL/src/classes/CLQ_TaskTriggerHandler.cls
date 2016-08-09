public class CLQ_TaskTriggerHandler extends CLQ_Trigger
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
	public CLQ_Tasktriggerhandler(list<sObject> newlistin, map<id,sObject> newMapin, list<sObject> oldlistin, map<id,sObject> oldMapin,
						boolean isExecutingin, boolean isInsertin, boolean isUpdatein,   boolean isDeletein, 
						boolean isBeforein,    boolean isAfterin,  boolean isUndeletein, integer sizein)
	{
		super(newlistin, newMapin, oldlistin, oldMapin,
						isExecutingin, isInsertin, isUpdatein,   isDeletein, 
						isBeforein,    isAfterin,  isUndeletein, sizein); 
		BypassInheritedTrigger = BypassTrigger;
	}
	////////////////////////////////     Boilerplate implementation  ////////////////////////////

	public override void AfterInsert()
	{
		//This Method executes instead of the base class empty method
		ProgramTransactionTaskUpdate((Map<Id,Task>) newMap, (Map<Id,Task>) OldMap);
	}

    public void ProgramTransactionTaskUpdate(Map < Id, Task > NewTasks, Map < Id, Task > OldTasks) {
        string Program_TransactionPrefix = CLQ_Program_Transaction__c.sObjectType.GetDescribe().getKeyPrefix();
        //system.debug('ProgramTransactionTaskUpdate: ' + NewTasks); 
        
        map <id,id> WhatOwnerMap = new map < id, id > ();
        for (Task task: NewTasks.Values()) {
            if (((string)task.WhatId).startswith(Program_TransactionPrefix))
            {
            	System.debug('ProgramTransactionTaskUpdate:WhatId:' + task.WhatId);
            	WhatOwnerMap.put(task.whatid,task.ownerid);
            }
        }
        
        //Quick exit if nothing to query
        if (WhatOwnerMap.size() == 0) return;

        list <CLQ_Program_Transaction__c> Program_Transactions = [Select id, name, CLQ_Transaction_Assigned_To__c 
        															FROM CLQ_Program_Transaction__c 
																	WHERE id IN: WhatOwnerMap.KeySet()];

        for (CLQ_Program_Transaction__c Program_Transaction : Program_Transactions) {
            system.debug('Program_Transaction was assigned to: ' + Program_Transaction.CLQ_Transaction_Assigned_To__c);
            Program_Transaction.CLQ_Transaction_Assigned_To__c = WhatOwnerMap.get(Program_Transaction.id);
            system.debug('Program_Transaction is now assigned to: ' + Program_Transaction.CLQ_Transaction_Assigned_To__c);
        }

        update Program_Transactions;
    }
}