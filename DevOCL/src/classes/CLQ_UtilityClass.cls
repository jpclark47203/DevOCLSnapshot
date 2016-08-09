/* Name : CLQ_UtilityClass
* Description : This class contains all untility logic/methods for OCLQS project. 
**/

public with sharing class CLQ_UtilityClass {
    //Method to create inspection record
    //@param : String Inspectiontype String inspcetionscope, String inspectionStatus
    //@return : CLQ_Inspection__c 
    public static CLQ_Inspection__c createInspectionrecord(String incpsectionType,String inspcetionscope, String inspectionStatus){
        CLQ_Inspection__c inspectionrecord = new CLQ_Inspection__c();
        inspectionrecord.CLQ_Inspection_Type__c = incpsectionType;
        inspectionrecord.CLQ_Scope__c = inspcetionscope;
        //inspectionrecord.CLQ_Program__c = programID;
        //inspectionrecord.CLQ_Inspection_Owner__c = ;
        inspectionrecord.CLQ_Inspection_Status__c = inspectionStatus;
        return inspectionrecord;
    }

    //Method to redirect the system to new page
    //@param: pagename , ret url (either one should be available)
    //@return: pagereference
    public static pageReference redirecttoPage(String urlvalue){
        pageReference pageRef = new pageReference(urlvalue);
        pageRef.setRedirect(true);  
        return pageRef;
    }

    //Method to create a task record
    //@param : taskownerid , whatid,Subject,Desctiption
    //@return : Task
    public static Task createTaskrecord(ID taskAssignTo,ID whatidfortask ,Date taskDate,String subject,String description){
        Task taskrecord = new Task();
        taskrecord.Description = description;
        taskrecord.Subject = subject;
        taskrecord.ActivityDate = taskDate;
        taskrecord.WhatId = whatidfortask;
        return taskrecord;
    }

    //Method to get Room/Space information associated with any program
    //@param: programID
    //@return: list of Room Space information object
    public static list<CLQ_Room_Space__c> queryRoomSpacefromProgram(ID programID){
        list<CLQ_Room_Space__c> roomSpaceList = new list<CLQ_Room_Space__c>();
        roomSpaceList = Database.query(createSOQLQuery('CLQ_Room_Space__c','CLQ_Program__c='+'\''+programID+'\'',null));
        return roomSpaceList;     
    }

    //Create Room/Space Inspection object
    //@param : roomspace list , inspection record
    //@return : list of roomspace inspection
    public static list<CLQ_Room_Space_Inspection__c> createRoomSpaceInspection(list<CLQ_Room_Space__c> roomSpaceList ,CLQ_Inspection__c inspectionrecord ){
        list<CLQ_Room_Space_Inspection__c> roomSpaceInspectionList = new list<CLQ_Room_Space_Inspection__c>();
        for(CLQ_Room_Space__c roompsacerecord : roomSpaceList){
                CLQ_Room_Space_Inspection__c newrecord = (CLQ_Room_Space_Inspection__c)cloneFromOneObjectToanother(roompsacerecord,'CLQ_Room_Space_Inspection__c');
                newrecord.CLQ_Inspection__c = inspectionrecord.id;
                newrecord.CLQ_Room_Group_Information__c = roompsacerecord.id;
                newrecord.CLQ_Program__c = null;
                newrecord.CLQ_Program_Transaction__c = null;
                roomSpaceInspectionList.add(newrecord);
        }
        return roomSpaceInspectionList;
    }

    //Method to copy all fields of Room Space informaiton object to Room/Space inspection
    //@param: Sobject source record , String api name of object to which you want to copy
    //@return: Sobject
    public static sObject cloneFromOneObjectToanother(SObject fromRecord,String toObjectName){
        //Get fromSobject 
        Schema.SObjectType fromsobjectType = (fromRecord.id).getSObjectType();
        String fromObjectName = fromsobjectType.getDescribe().getName();

        SObjectType fromobjToken = Schema.getGlobalDescribe().get(fromObjectName);
        SObjectType toobjToken = Schema.getGlobalDescribe().get(toObjectName);

        //Create a cloned record
        sObject clonedRecord = Schema.getGlobalDescribe().get(toObjectName).newSObject() ;

        //Get list of fields from FromSobject
        Map<String,Schema.SObjectField> mapFromSObjFieldList = fromobjToken.getDescribe().fields.getMap();
        //Get list of fields from ToSobject
        Map<String,Schema.SObjectField> mapToSObjFieldList = toobjToken.getDescribe().fields.getMap();
        for(String field : mapFromSObjFieldList.keySet()){
            
            if(mapToSObjFieldList.get(field) != null && mapToSObjFieldList.get(field).getDescribe().isUpdateable()) 
            {
                clonedRecord.put(field , fromRecord.get(field)) ;
            }
        }
        return clonedRecord;
    }

    //Method to get query all the fields for any sObject
    //@param: objectapiname
    //@return: set of field api name
    public static set<String> getAllfieldsforSObject(String objectAPIName){
        SObjectType objToken = Schema.getGlobalDescribe().get(objectAPIName);
        Map<String,Schema.SObjectField> mapSObjFieldList = objToken.getDescribe().fields.getMap();
        return mapSObjFieldList.keySet();     
    }

    //Method to create query string with all fields of the object
    //@param: ObjectAPIName, WhereClausestring, string list of extrafields
    //@return: soql string
    public static string createSOQLQuery(String sObjectAPIName,String whereClause,list<String> extraFieldsList){
        list<String> fieldNames =  new List<String>(getAllfieldsforSObject(sObjectAPIName));
        String soqlquery = 'SELECT '+ String.join( fieldNames, ',' );
        //Add extra fields if needed
        if(extraFieldsList != null && extraFieldsList.size()>0 ){
            soqlquery = soqlquery+',';
            soqlquery = soqlquery+ String.join( extraFieldsList, ',' );
        }
        //Complete the query
        soqlquery = soqlquery+' FROM '+sObjectAPIName+' WHERE '+whereClause;
        system.debug('====>'+soqlquery);
        return soqlquery;
    }

}