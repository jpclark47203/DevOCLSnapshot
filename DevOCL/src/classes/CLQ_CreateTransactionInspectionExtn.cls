/* Name : CLQ_CreateTransactionInspectionExtn
* Description : This class/extension contains all detail logic/methods for CLQ_CreateTransactionInspection pages. 
*			It will create a new inspection record from program transaction 
**/
public with sharing class CLQ_CreateTransactionInspectionExtn {
	//variables
    public list<String> fieldlist;
    public CLQ_Program_Transaction__c programTransactionRecord;

	public CLQ_CreateTransactionInspectionExtn(ApexPages.StandardController controller) {
		fieldlist = new list<String>{'CLQ_Program__r.Recordtypeid','CLQ_Transaction_Assigned_To__c','CLQ_Program__r.Id'}; //add fields to this list to query from database
        if(!Test.isRunningTest()){
            controller.addFields(fieldlist);
        }
		this.programTransactionRecord = (CLQ_Program_Transaction__c)controller.getRecord();
	}

	//Method to complete all on-load logic
    //@param : none
    //@return : pagereference
    public pagereference onLoad(){
    	//1. Create inspection record for given Program Transaction
    	CLQ_Inspection__c inspectionrecord = CLQ_UtilityClass.createInspectionrecord('Pre-license', 'Full', 'Pending Processing');
        inspectionrecord.CLQ_Program_Transaction__c = programTransactionRecord.Id;
        inspectionrecord.CLQ_Program__c = programTransactionRecord.CLQ_Program__r.Id;
        inspectionrecord.OwnerID = programTransactionRecord.CLQ_Transaction_Assigned_To__c; 
        inspectionrecord.CLQ_Inspection_Owner__c = programTransactionRecord.CLQ_Transaction_Assigned_To__c; 
        inspectionrecord = updateInspectionDetail(inspectionrecord,programTransactionRecord);
        
        insert inspectionrecord; 

        //2. Copy all Room/Space records to inspection
        list<CLQ_Room_Space__c> roomSpaceList = new list<CLQ_Room_Space__c>();
        roomSpaceList = CLQ_UtilityClass.queryRoomSpacefromProgram(programTransactionRecord.CLQ_Program__c);
        if(roomSpaceList.size()>0){
        	list<CLQ_Room_Space_Inspection__c> roomSpaceInspectionList = CLQ_UtilityClass.createRoomSpaceInspection(roomSpaceList , inspectionrecord);
            insert roomSpaceInspectionList;
        }
        
        //3. Insert task record
        insert CLQ_UtilityClass.createTaskrecord(programTransactionRecord.CLQ_Transaction_Assigned_To__c, inspectionrecord.Id, (Date.today()).adddays(20), 'Review Transaction Inspection task', 'Review Transaction Inspection task');

    	return CLQ_UtilityClass.redirecttoPage('/'+inspectionrecord.Id);
    }


	//Method to redirect to Program Transaction detail page
    //@param : none
    //@return : Pagereference
    public pagereference onOK(){
        //return CLQ_UtilityClass.redirecttoPage('/'+caseRecord.Id);
        return null;
    }

    //Method to update inspection details based on program and programTransaction 
    //@param : inspectionrecord
    //@return : inspectionrecord
    public CLQ_Inspection__c updateInspectionDetail(CLQ_Inspection__c inspectionrecord , CLQ_Program_Transaction__c programTransactionRecord){
        //get all Program transaction record type info
        Map<ID,Schema.RecordTypeInfo> transactionRd_Map = CLQ_Program_Transaction__c.sObjectType.getDescribe().getRecordTypeInfosById();
        Map<ID,Schema.RecordTypeInfo> programRd_Map = CLQ_Program__c.sObjectType.getDescribe().getRecordTypeInfosById();
        
        if(programRd_Map.get(programTransactionRecord.CLQ_Program__r.Recordtypeid) != null && 
            (programRd_Map.get(programTransactionRecord.CLQ_Program__r.Recordtypeid).getName() == 'FCC - Type A Home'
        	|| programRd_Map.get(programTransactionRecord.CLQ_Program__r.Recordtypeid).getName() == 'FCC - Type B Home'
        	|| programRd_Map.get(programTransactionRecord.CLQ_Program__r.Recordtypeid).getName() == 'Child Care Center'
        	|| programRd_Map.get(programTransactionRecord.CLQ_Program__r.Recordtypeid).getName() == 'Pre School')){
        	//For new applications
        	if(transactionRd_Map.get(programTransactionRecord.Recordtypeid).getName().contains('Application')){
        		inspectionrecord.CLQ_Inspection_Type__c = 'Pre-license';
        	}else if(transactionRd_Map.get(programTransactionRecord.Recordtypeid).getName().contains('Amendment') 
        		&& transactionRd_Map.get(programTransactionRecord.Recordtypeid).getName().contains('Change of Location')){
        		inspectionrecord.CLQ_Inspection_Type__c = 'Amendment - change of location';
        	}else if(transactionRd_Map.get(programTransactionRecord.Recordtypeid).getName().contains('Amendment') 
        		&& transactionRd_Map.get(programTransactionRecord.Recordtypeid).getName().contains('Change of Capacity / Space')){
        		inspectionrecord.CLQ_Inspection_Type__c = 'Amendment - change of capacity';
        	}
        }

        return inspectionrecord;    
    }

}