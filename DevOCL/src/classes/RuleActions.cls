/************************************************************************
* Name   : RuleActions                                                  *
* Author : Sujila R Nair                                                *
* Desc   : Wrapper Class to capture each action                         *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila R Nair |  03/17/2016  |  Original Version                      *
*************************************************************************/
public class RuleActions implements Comparable  {
    public String   Identifier {get;set;}
    public String   OrderNumber {get;set;}
    Public String   Type {get;set;}
    Public String   resultObject {get;set;}    
    Public String   Field {get;set;}
    Public String   Value {get;set;}
    Public String   ActionPretty {get;set;}
    
    public Integer compareTo(Object objToCompare){
        //subtraction between this and order to return the negative, zero or positive value
        Integer order = objToCompare != null ? Integer.valueOf(((RuleActions)objToCompare).OrderNumber) : 0;
        return Integer.valueOf(this.OrderNumber) - order;
    }
}