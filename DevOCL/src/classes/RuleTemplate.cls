/************************************************************************
* Name   : RuleTemplate                                                 *
* Author : Sujila R Nair                                                *
* Desc   : Wrapper Class to capture each rule                           *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila R Nair |  03/17/2016  |  Original Version                      *
*************************************************************************/
public class RuleTemplate {
    public String Name {get;set;}
    public Map<String, boolean> ConditionMap {get;set;}	// Condition Identifier, Condition selected or not
    public Map<String, boolean> ActionMap {get;set;}	// Action Identifier, Action selected or not
    public Map<String, String> ActionOrder {get;set;}	// Action Identifier, Action Order Number
    
    public RuleTemplate(){
        ConditionMap = new Map<String, boolean>();
        ActionMap = new Map<String, boolean>();
        ActionOrder = new Map<String, String>();
    }
}