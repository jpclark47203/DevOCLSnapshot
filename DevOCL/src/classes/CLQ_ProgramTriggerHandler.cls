/*Class Name : CLQ_ProgramTriggerHandler
* Description : This class contains all logic/methods used in CLQ_ProgramTrigger on CLQ_Program__c object
*/
public class CLQ_ProgramTriggerHandler{
    
    //Method to hold the logic for before insert on CLQ_Program__c object
    //@param : list<CLQ_Program__c> , map<id,CLQ_Program__c>
    //@return : none
    public static void beforeinsert(list<CLQ_Program__c> triggernew, map<id,CLQ_Program__c> triggernewMap){
        triggernew = populateConfigurationOnProgram(triggernew);
    }
    
    //Method to populate configuration record on Program while inserting
    //@param: list<CLQ_Program__c> new program record list
    //@return: list<CLQ_Program__c> updated program record list
    public static list<CLQ_Program__c> populateConfigurationOnProgram(list<CLQ_Program__c> triggernew){
        list<string> recordTypeNameList = new list<string>(); //list of record type name for all program record
        map<string,CLQ_OCLQS_Configuration__c> configurationnameRecordMap = new map<string,CLQ_OCLQS_Configuration__c>(); //map of all applicable configuration records with name as key  
        Map<ID,Schema.RecordTypeInfo> rt_Map = CLQ_Program__c.sObjectType.getDescribe().getRecordTypeInfosById(); //map to hold all the record type info for Program object

        //Store record type name value in recordTypeNameList
        for(CLQ_Program__c programRecord : triggernew){
            recordTypeNameList.add(rt_map.get(programRecord.recordTypeID).getName()); 
        }
        
        if(recordTypeNameList.size()>0){    
            //query the configuration records
            for(CLQ_OCLQS_Configuration__c configrecord : [SELECT id
                                                                , Name 
                                                           FROM CLQ_OCLQS_Configuration__c 
                                                           WHERE name IN :recordTypeNameList]){
                configurationnameRecordMap.put(configrecord.Name, configrecord);  //populate the map                                                  
            }
            
            
            for(CLQ_Program__c programRecord : triggernew){
                programRecord.CLQ_OCLQS_Configuration__c = (configurationnameRecordMap.get(rt_map.get(programRecord.recordTypeID).getName())).id; //populate the configuration record reference on program record
            }
        }
         return triggernew; // return the updated list 
    }
 
}