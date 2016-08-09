/************************************************************************
* Name   : RuleSetContext                                               *
* Author : Sujila R Nair                                                *
* Desc   : Wrapper Class to capture basic information                   *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila R Nair |  03/17/2016  |  Original Version                      *
*************************************************************************/
public class RuleSetContext {
    public string RuleSetName;
    public Date EffectiveStartDate;
    public Date EffectiveEndDate;
    public string RuleVersion;
    public string RelatedObjectName {get;set;}
    public List<String> InputObjects {get;set;}
    public String RuleExecution;
    public string returnType {get;set;}
    			
    public RuleSetContext(){
        InputObjects = new List<String>();
        returnType = 'Void';
    }
}