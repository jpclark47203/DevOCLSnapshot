/* Name : CLQ_CreateProgramInspectionExtn
* Developer Name : Vrajesh Sheth
* Date : 07/19/2016
* Email : vsheth@incapsulate.com
* Description : This class/extension contains all detail logic/methods for CLQ_CreateProgramInspection pages. 
*			It will create a new inspection record from program record 
* V1 - Date: 07/19/2016 - Started development
**/
public with sharing class CLQ_CreateProgramInspectionExtn {
	//variables
    public list<String> fieldlist;
    public CLQ_Program__c programRecord;

    //Constructor
	public CLQ_CreateProgramInspectionExtn(ApexPages.StandardController controller) {
		fieldlist = new list<String>{'CLQ_Assigned_Reviewer__c','CLQ_License_Registration_Status__c','CLQ_Program_Status__c','CLQ_License_Type__c'};
		if(!Test.isRunningTest()){
            controller.addFields(fieldlist);
        }
        this.programRecord = (CLQ_Program__c)controller.getRecord();
	}

	//Method to create inspection record onload 
	//@param: none
	//@return: pageReference 
	public pageReference onLoad(){
		//1. Create inspection record for given complaint
		CLQ_Inspection__c inspectionrecord = new CLQ_Inspection__c();
		if(programRecord.CLQ_License_Registration_Status__c == 'Licensed' 
			&& programRecord.CLQ_Program_Status__c == 'Open'){
			if(programRecord.CLQ_License_Type__c == 'Continuous'){
				inspectionrecord = CLQ_UtilityClass.createInspectionrecord('Annual', 'Full', 'Pending Processing');	
			}
			if(programRecord.CLQ_License_Type__c == 'Provisional'){
				inspectionrecord = CLQ_UtilityClass.createInspectionrecord('Provisional', 'Full', 'Pending Processing');
			}
		}
		
		
        inspectionrecord.CLQ_Program__c = programRecord.id;
        inspectionrecord.CLQ_Inspection_Owner__c = UserInfo.getUserId();
        insert inspectionrecord;
		
        //2. Copy all Room/Space records to inspection
        list<CLQ_Room_Space__c> roomSpaceList = new list<CLQ_Room_Space__c>();
        if(programRecord.id != null){
        	roomSpaceList = CLQ_UtilityClass.queryRoomSpacefromProgram(programRecord.id);
           	if(roomSpaceList.size()>0){
           		list<CLQ_Room_Space_Inspection__c> roomSpaceInspectionList = CLQ_UtilityClass.createRoomSpaceInspection(roomSpaceList , inspectionrecord);
                insert roomSpaceInspectionList;
            }                    
        }

        //3. Insert task record
        insert CLQ_UtilityClass.createTaskrecord(programRecord.CLQ_Assigned_Reviewer__c, inspectionrecord.Id, (Date.today()).adddays(20), 'Inspection Review task', 'Inspection Review task');
    
		return CLQ_UtilityClass.redirecttoPage('/'+inspectionrecord.Id);
	}

	//Method to redirect to Case detail page
    //@param : none
    //@return : Pagereference
    public pagereference onOK(){
        return CLQ_UtilityClass.redirecttoPage('/'+programRecord.Id);
    }
}