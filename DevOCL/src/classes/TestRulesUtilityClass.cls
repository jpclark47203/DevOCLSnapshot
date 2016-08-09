@isTest
public class TestRulesUtilityClass {
    public Static string getFieldsbyObject(String objName){
        SObjectType objectType = Schema.getGlobalDescribe().get(objName);
        Map<String,Schema.SObjectField> mfields = objectType.getDescribe().fields.getMap();        
        List<String> fns=new List<String>();
        fns.addAll(mfields.keyset());
        String fn_s=String.join(fns, ',');
        //System.debug('fields '+fn_s); 
        return fn_s;        
    }
    
    //Get fields details from any SOBject. General function 
    public static string getFields(Id objId){
        SObjectType objectType = Schema.getGlobalDescribe().get(objId.getSObjectType().getDescribe().getName());
        Map<String,Schema.SObjectField> mfields = objectType.getDescribe().fields.getMap();        
        List<String> fns=new List<String>();
        fns.addAll(mfields.keyset());
        String fn_s=String.join(fns, ',');
        //System.debug('fields '+fn_s); 
        return fn_s;        
    }

    public static SObject updateRequiredFields(String objName, SObject inputObj){
        Map<String, String> ReqFieldsTypes =  new Map<String, String>();		//Maps Required fields of any object to its type
        
        //Get all the required fields for this object from Schema
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objName);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        Schema.SObjectField field;
        Schema.DescribeFieldResult F;
        for (String fieldName: fieldMap.keySet()) {
            field = fieldMap.get(fieldName);
            F = field.getDescribe();
            if(F.isNillable() == False){
                //required field - get type of field
                if(!fieldName.containsIgnoreCase('id') && !fieldName.containsIgnoreCase('ownerid') &&  !fieldName.containsIgnoreCase('isdeleted') &&
                   !fieldName.containsIgnoreCase('name') && !fieldName.containsIgnoreCase('createddate') &&  !fieldName.containsIgnoreCase('createdbyid') &&
                   !fieldName.containsIgnoreCase('lastmodifieddate') && !fieldName.containsIgnoreCase('lastmodifiedbyid') && !fieldName.containsIgnoreCase('systemmodstamp')){
                       ReqFieldsTypes.put(fieldName, String.valueOf(F.getType()));
                   }
            }
        }
        if(ReqFieldsTypes.size()>0){
            for(String fieldName: ReqFieldsTypes.keySet()){
                if(ReqFieldsTypes.get(fieldName).containsIgnoreCase('Boolean')){
                }
                else 
                    if(ReqFieldsTypes.get(fieldName).containsIgnoreCase('String') || ReqFieldsTypes.get(fieldName).containsIgnoreCase('TextArea') ||
                       ReqFieldsTypes.get(fieldName).containsIgnoreCase('Picklist') || ReqFieldsTypes.get(fieldName).containsIgnoreCase('MultiPicklist')){
                       }
                else 
                    if(ReqFieldsTypes.get(fieldName).containsIgnoreCase('Integer') || ReqFieldsTypes.get(fieldName).containsIgnoreCase('Double') ||
                       ReqFieldsTypes.get(fieldName).containsIgnoreCase('Currency') || ReqFieldsTypes.get(fieldName).containsIgnoreCase('Percent')){
                       }
                else
                    if(ReqFieldsTypes.get(fieldName).containsIgnoreCase('Date')){
                    }
                else
                    if(ReqFieldsTypes.get(fieldName).containsIgnoreCase('DateTime')){
                    }
            }
            Return inputObj;
        }
        else{
            // No required fields. Return the input Object
            Return inputObj;
        }
    }
}