/************************************************************************
* Name   : RuleConditions_V2                                            *
* Author : Sujila R Nair                                                *
* Desc   : Wrapper Class to capture each condition                      *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila R Nair |  04/22/2016  |  Original Version                      *
*************************************************************************/
public class RuleConditions_V2 {
	public String 	Identifier {get;set;}
    Public String 	FieldName {get;set;}
    Public String 	ConditionOperator {get;set;}
    Public String 	ParentFieldName {get;set;}
    Public String 	Value {get;set;}
    public boolean 	Status {get;set;}  			// Condition passed or not at run time
    public String 	ConditionPretty {get;set;}
    public boolean  multiParentField {get;set;}
    public String   FieldType;
    public boolean  writableField;
}