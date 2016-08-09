Public Class OpportunityTest_V0003 implements RulesInterfaceClass_V2
{
    Private Map < String, boolean > ConditionTable;
    Private RulesResultClass_V2 Result;
    Public OpportunityTest_V0003()
    {
        ConditionTable = new Map < String, boolean > ();
        Result = new RulesResultClass_V2();
    }
    Public RulesResultClass_V2 Perform(List < sObject > InputList, List < sObject > OldInputList)
    {
        String RuleStartDate = '2016-07-15';
        if (System.Today() < Date.valueOf(RuleStartDate))
        {
            Result.Errors = 'Rule is configured to start on ' + RuleStartDate;
            Result.Status = 'Failed';
            System.debug('Failed: Rule is configured to start on ' + RuleStartDate);
            return Result;
        }
        List < Opportunity > primaryObjList = (List < Opportunity > ) InputList;
        List < Task > TaskObjList = new List < Task > ();
        Opportunity oldprimaryObj;
        for (Opportunity primaryObj: primaryObjList)
        {
            UpdateConditionTable(primaryObj, oldprimaryObj);
        }
        If(TaskObjList.size() > 0)
        {
            List < Database.SaveResult > saveResults = Database.insert(TaskObjList, false);
            for (Database.SaveResult saveResult: saveResults)
            {
                if (saveResult.isSuccess() != true)
                {
                    for (Database.Error error: saveResult.getErrors())
                    {
                        System.debug('Error inserting Task ' + saveResult.getId() + ' : ' + error.getStatusCode() + ' - ' + error.getMessage());
                    }
                }
            }
        }
        Result.updatedinputList = primaryObjList;
        Result.inputUpdated = false;
        Result.Status = 'Success';
        return Result;

    }
    Private void UpdateConditionTable(Opportunity obj, Opportunity oldObj)
    {
        initConditionTable();
        System.debug('Condition Table: ' + ConditionTable);
    }
    Private void initConditionTable()
    {}

}