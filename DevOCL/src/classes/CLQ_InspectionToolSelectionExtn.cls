public with sharing class CLQ_InspectionToolSelectionExtn {
	//Variables
	public list<String> fieldlist;
    public CLQ_Inspection__c inspectionRecord {get;set;}
    public list<innerInspectionToolClass> innerInspectionToolList{get;set;}
	//Constructor
	public CLQ_InspectionToolSelectionExtn(ApexPages.StandardController controller){
		inspectionRecord = new CLQ_Inspection__c();
		innerInspectionToolList = new list<innerInspectionToolClass>();
		fieldlist = new list<String>{'CLQ_Use_Rules_Effective_On__c','CLQ_Reason_for_Inspection_Tool_Selection__c','CLQ_Scope__c','CLQ_Program__c','CLQ_Program__r.RecordType.Name','CLQ_Program_Transaction__c','CLQ_Program_Transaction__r.CLQ_Program__r.RecordType.Name'};
		if(!Test.isRunningTest()){
            controller.addFields(fieldlist);
        }
        this.inspectionRecord = (CLQ_Inspection__c)controller.getRecord();	
	}

	//Method to get rules associated with the inspection tool
	//@param : inspection rule ID, validity Date
	//@return : list CLQ_Tools_Rules__c
	public list<CLQ_Tools_Rules__c> retriveToolRules(ID insepctionRule, Date validityDate){
		list<CLQ_Tools_Rules__c> toolRuleList = new list<CLQ_Tools_Rules__c>(); 
		toolRuleList = Database.query(CLQ_UtilityClass.createSOQLQuery('CLQ_Tools_Rules__c', ' CLQ_Inspection_Tools__c ='+'\''+insepctionRule+'\' AND CLQ_Domain_Rule__r.CLQ_Rule_Effective_Date__c<='+String.valueOf(validityDate)+' AND CLQ_Domain_Rule__r.CLQ_Rule_Expiration_Date__c>='+String.valueOf(validityDate)+'  AND CLQ_Domain_Rule__r.CLQ_Rule_Expiration_Date__c!= null', null));
		return 	toolRuleList;
	}

	//Method to get recommended inspection tool for given inspection
	//@param: inspection record
	//@return : list of inspection tools 
	public list<CLQ_Inspection_Tools__c> retriveInspectionTools(CLQ_Inspection__c inspectionRecord){
		list<CLQ_Inspection_Tools__c> inspectionToolList = new list<CLQ_Inspection_Tools__c>();
		inspectionToolList = [SELECT ID
								,CLQ_Applicable_To__c
								,CLQ_Description__c
								,CLQ_Active__c
								,Name
							FROM CLQ_Inspection_Tools__c
							];
							
		return inspectionToolList;
	}

	//Method to perform OnLoad logic
	//@param:
	//@return:
	public PageReference onLoad(){
		for(CLQ_Inspection_Tools__c inspectionToolrecord : retriveInspectionTools(inspectionRecord)){
			innerInspectionToolClass innerRecord = new innerInspectionToolClass(inspectionToolrecord);
			system.debug('====='+inspectionToolrecord.CLQ_Applicable_To__c)	;
			system.debug('====='+inspectionrecord.CLQ_Program__r.RecordType.Name);
			system.debug('====='+inspectionrecord.CLQ_Scope__c);
			if(inspectionToolrecord.CLQ_Applicable_To__c !=null 
				&& (inspectionToolrecord.CLQ_Applicable_To__c).contains(inspectionrecord.CLQ_Program__r.RecordType.Name)
				&& (inspectionToolrecord.Name).contains(inspectionrecord.CLQ_Scope__c)){
				innerRecord.isRecommended = true;
				innerRecord.isSelected = true;
				innerInspectionToolList.add(innerRecord);
			}else if(inspectionToolrecord.CLQ_Applicable_To__c !=null 
				&& (inspectionToolrecord.CLQ_Applicable_To__c).contains(inspectionrecord.CLQ_Program__r.RecordType.Name)
				&& !(inspectionToolrecord.Name).contains(inspectionrecord.CLQ_Scope__c)
				){
				innerInspectionToolList.add(innerRecord);
			}
			
		}
		return null;
	}

	//Wrapper class to show the table of Inspection tool 
	public class innerInspectionToolClass{
		public boolean isSelected{get;set;}
		public boolean isRecommended{get;set;}
		public CLQ_Inspection_Tools__c inspectionToolrecord {get; set;} 
		public String recommended{get;set;}

		public innerInspectionToolClass(CLQ_Inspection_Tools__c iTRecord){
			isSelected = false;
			isRecommended = false;
			recommended = 'Recommended';
			inspectionToolrecord = iTRecord;
		}
	}

	//Method to perform save method
	//@param:
	//@return :
	public PageReference onSave(){
		list<CLQ_Rules_Inspected__c> ruleInspectedList = new list<CLQ_Rules_Inspected__c>();
		for(innerInspectionToolClass innerRecord : innerInspectionToolList){
			if(innerRecord.isSelected == true){
				inspectionRecord.CLQ_Inspection_Tool__c = innerRecord.inspectionToolrecord.id;
			}
			if(innerRecord.isRecommended == true){
				inspectionRecord.CLQ_Recommended_Inspection_Tool__c = innerRecord.inspectionToolrecord.id;
			}
		}
		if((inspectionRecord.CLQ_Inspection_Tool__c != inspectionRecord.CLQ_Recommended_Inspection_Tool__c) 
			&& (inspectionRecord.CLQ_Reason_for_Inspection_Tool_Selection__c == '' 
			|| inspectionRecord.CLQ_Reason_for_Inspection_Tool_Selection__c == null)){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide reason for selecting non-recommended tool'));
			return null;
			
		}else{
			update inspectionRecord;

			//Copy all rule associated with the selected inspection to inspection record
			for(CLQ_Tools_Rules__c toolRule : retriveToolRules(inspectionRecord.CLQ_Inspection_Tool__c,inspectionRecord.CLQ_Use_Rules_Effective_On__c)){
				ruleInspectedList.add(new CLQ_Rules_Inspected__c(CLQ_Inspection_No__c=inspectionRecord.id,CLQ_Domain_Rule__c =toolRule.CLQ_Domain_Rule__c));	
			}
			if(ruleInspectedList.size()>0){
				insert ruleInspectedList;
			}

			//Return to the inspection page
			return CLQ_UtilityClass.redirecttoPage('/'+inspectionRecord.Id);
			}
		
	}

	//Method to return to inspection detail page
	//@param:
	//@return:
	public PageReference onReturn(){
		//Return to the inspection page
		return CLQ_UtilityClass.redirecttoPage('/'+inspectionRecord.Id);
	}

}