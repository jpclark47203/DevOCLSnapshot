/************************************************************************
* Name   : RulesResultClass_V2                                          *
* Author : Sujila R Nair                                                *
* Desc   : Result Class for Rules Engine                                *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila R Nair |  04/22/2016  |  Original Version                      *
* Sujila R Nair |  05/06/2016  |  Returning of Duplicate Result Records *   
*************************************************************************/
public class RulesResultClass_V2 {
  public String Status;
    public String Errors;
    public List<SObject> updatedinputList;
    public List<SObject> duplicateRecordList;
    public  boolean inputUpdated;
    
    public String getStatus(){
        return status;
    }
    public String getErrors(){
        return Errors;
    }
    public List<SObject> getResult(){
        return updatedinputList;
    }
    
    public List<SObject> getDuplicates(){
        return duplicateRecordList;
    }
}