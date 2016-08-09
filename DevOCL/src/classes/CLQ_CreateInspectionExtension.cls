/* Name : CLQ_CreateInspectionExtension
* Description : This class/extension contains all detail logic/methods for CLQ_CreateInspection pages. 
**/
public with sharing class CLQ_CreateInspectionExtension {
    //variables
    public list<String> fieldlist;
    private Case caseRecord ;
    
    //constructor
    public CLQ_CreateInspectionExtension(ApexPages.StandardController controller) {
        fieldlist = new list<String>{'CLQ_Assigned_To__c','Ownerid','CLQ_Inspection__c','CLQ_No_Investigation_Required__c','CLQ_Program__c'}; //add fields to this list to query from database
        if(!Test.isRunningTest()){
            controller.addFields(fieldlist);
        }
        this.caseRecord = (Case)controller.getRecord();
    }

    //Method to complete all on-load logic
    //@param : none
    //@return : pagereference
    public pagereference onLoad(){
        //Check if inspection record is already associated or No investigation require is checked or not
        if(caseRecord.CLQ_No_Investigation_Required__c || caseRecord.CLQ_Inspection__c != null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not create inspection for this complaint'));
            return null;
        }else{
            //1. Create inspection record for given complaint
            CLQ_Inspection__c inspectionrecord = CLQ_UtilityClass.createInspectionrecord('Complaint', 'Partial', 'Pending Processing');
            inspectionrecord.CLQ_Program__c = caseRecord.CLQ_Program__c;
            insert inspectionrecord;   
            
            //2. Copy all Room/Space records to inspection
            list<CLQ_Room_Space__c> roomSpaceList = new list<CLQ_Room_Space__c>();
            if(caseRecord.CLQ_Program__c != null){
                roomSpaceList = CLQ_UtilityClass.queryRoomSpacefromProgram(caseRecord.CLQ_Program__c);
                if(roomSpaceList.size()>0){
                    list<CLQ_Room_Space_Inspection__c> roomSpaceInspectionList = CLQ_UtilityClass.createRoomSpaceInspection(roomSpaceList , inspectionrecord);
                    insert roomSpaceInspectionList;
                }                    
            }
            
            //3. Insert task record
            insert CLQ_UtilityClass.createTaskrecord(caseRecord.CLQ_Assigned_To__c, inspectionrecord.Id, (Date.today()).adddays(20), 'Complaint Inspection task', 'Complaint Inspection task');

            //4. Relate the Inspection record with case (and update other values of case if requires)
            update updateCaseDetail(caseRecord , inspectionrecord);


            return CLQ_UtilityClass.redirecttoPage('/'+inspectionrecord.Id);    
        } 

            
    }

    //Method to update case details
    //@param : case record,inspectionrecord
    //@return : caserecord
    public Case updateCaseDetail(Case caseRecord,CLQ_Inspection__c inspectionrecord){
        caseRecord.CLQ_Inspection__c = inspectionrecord.id;
        caseRecord.Status = 'Under Review';
        return caseRecord;    
    }
    /*
    //Create Room/Space Inspection object
    //@param : roomspace list , inspection record
    //@return : list of roomspace inspection
    public list<CLQ_Room_Space_Inspection__c> createRoomSpaceInspection(list<CLQ_Room_Space__c> roomSpaceList ,CLQ_Inspection__c inspectionrecord ){
        list<CLQ_Room_Space_Inspection__c> roomSpaceInspectionList = new list<CLQ_Room_Space_Inspection__c>();
        for(CLQ_Room_Space__c roompsacerecord : roomSpaceList){
                roomSpaceInspectionList.add(new CLQ_Room_Space_Inspection__c(CLQ_Inspection__c = inspectionrecord.id,CLQ_Room_Group_Information__c = roompsacerecord.id));
        }
        return roomSpaceInspectionList;
    }
    */
    //Method to redirect to Case detail page
    //@param : none
    //@return : Pagereference
    public pagereference onOK(){
        return CLQ_UtilityClass.redirecttoPage('/'+caseRecord.Id);
    }

}