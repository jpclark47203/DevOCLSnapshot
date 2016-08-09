/************************************************************************
* Name   : RuleSetTemplate                                              *
* Author : Sujila R Nair                                                *
* Desc   : Wrapper Class to generate Rules class run time               *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila R Nair |  03/17/2016  |  Original Version                      *
*************************************************************************/
public class RuleSetTemplate {
    public  List<RuleTemplate> Rules {get; set;}
    public RuleSetContext Context {get; set;}
    public RuleSetTemplate(){
        Rules = new List<RuleTemplate>();
        Context = new RuleSetContext();
    }
}