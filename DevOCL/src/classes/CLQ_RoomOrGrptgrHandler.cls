public with sharing class CLQ_RoomOrGrptgrHandler {
	public static void updateformula(Map<Id,CLQ_Room_Space__c> NewRS, Map<Id,CLQ_Room_Space__c> OldRS) {
         set<id> RGSet = new set<id>();
		 Decimal foot = 0;
		 Decimal footage=0;
		 Decimal Nofc =0;
		 map<id,string> RTmap = new map <id,string>();
		 list<recordtype> RTlist = new list <recordtype>([select id,name from recordtype where sobjecttype = 'CLQ_Program__c']);
		 for(Recordtype R :RTlist){
		  RTmap.put(R.id,R.name);
		 }
		 for(CLQ_Room_Space__c RG : NewRS.values()){ 
		  RGset.add(RG.CLQ_Program__c);
		 }
		 list<CLQ_Program__c> updatelist = new list <CLQ_Program__c>();
		 list<CLQ_Program__c> Pgrlist = new list <CLQ_Program__c>([select id,name,recordtypeid from CLQ_Program__c where id IN: RGset]);
		 list<CLQ_Room_Space__c> RSListODE=new list<CLQ_Room_Space__c>([select id,name,recordtype.name,CLQ_Approved_Room_Space__c,CLQ_Square_Footage__c,CLQ_Room_Space_Type__c,CLQ_Used_by_Under_or_Over_2_1_2__c,CLQ_Used_By_Under_or_Over_2__c,CLQ_Program__c,CLQ_Program__r.recordtypeid from CLQ_Room_Space__c where recordtype.name =: 'Indoor Room/Space' and 
		                                  CLQ_Approved_Room_Space__c =: true and CLQ_Room_Space_Type__c=:'Primary Space' and (CLQ_Used_by_Under_or_Over_2_1_2__c =: 'Over' or CLQ_Used_By_Under_or_Over_2__c =:'Over')and CLQ_Program__c IN:RGset]);
		 list<CLQ_Room_Space__c> RSListbothODE=new list<CLQ_Room_Space__c>([select id,name,recordtype.name,CLQ_Calc_Nb_of_Child_Allowed_Indoor__c,CLQ_Approved_Room_Space__c,CLQ_Used_By_Under_or_Over_2__c,CLQ_Square_Footage__c,CLQ_Room_Space_Type__c,CLQ_Program__r.recordtypeid,CLQ_Used_by_Under_or_Over_2_1_2__c,CLQ_Program__c from CLQ_Room_Space__c where recordtype.name =: 'Indoor Room/Space' and 
		                                  CLQ_Approved_Room_Space__c =: true and CLQ_Room_Space_Type__c=:'Primary Space' and( (CLQ_Used_by_Under_or_Over_2_1_2__c =: 'Under' or CLQ_Used_by_Under_or_Over_2_1_2__c =: 'Both')or(CLQ_Used_By_Under_or_Over_2__c =: 'Under' or CLQ_Used_By_Under_or_Over_2__c =: 'Both'))and CLQ_Program__c IN:RGset]);
		 system.debug('Room Space ODE array size'+RSlistODE.size());
		 for(integer i=0;i<RSlistODE.size();i++){
		  
		  system.debug('RS count'+i);
		  foot = foot+RSlistODE[i].CLQ_Square_Footage__c;
		  system.debug('square footage'+foot);
		  } 
		 
		 for(integer i=0;i<RSlistbothODE.size();i++){
		 
		  NofC= Nofc+RSlistbothODE[i].CLQ_Calc_Nb_of_Child_Allowed_Indoor__c;
		  system.debug('both ODE child allowed indoor '+NofC);
		 }
		 
		 for(CLQ_Program__c pr:Pgrlist){
		 	if(RTmap.get(Pr.recordtypeid).contains('Type A')){
		 		system.debug('square footage type A'+foot);
		  		if(foot/35 > 12){
				   footage =12;
				   system.debug('footage for Type A'+footage);
		         }
		    }
		    else if(RTmap.get(Pr.recordtypeid).contains('Type B')){ 
		 	     system.debug('square footage type B'+footage);
		         if(foot/35 > 6){
		            footage =6;
		            system.debug('footage for Type B'+footage);
		          }
		    }
		    if(RSlistODE.size()>0){
		       pr.CLQ_Calculated_Max_Capacity__c=footage+NofC;
		    }
		   else{
		       pr.CLQ_Calculated_Max_Capacity__c=NofC;
		    }
		  
		   if(RTmap.get(Pr.recordtypeid).contains('FCC')){
		          pr.CLQ_Max_Capacity_Under_2_Years__c=NofC;
		          system.debug('CLQ_Max_Capacity_Under_2_Years__c'+pr.CLQ_Max_Capacity_Under_2_Years__c);
		 	}
		 	else if(RTmap.get(Pr.recordtypeid).contains('School')||RTmap.get(Pr.recordtypeid).contains('Child Care')){
		         pr.CLQ_Max_Capacity_Under_2_5_Years__c=NofC;
		     }
		 
		   
		 system.debug('CLQ_Calculated_Max_Capacity__c'+Pr.CLQ_Calculated_Max_Capacity__c);
		 updatelist.add(pr);
	   } //end program loop
		 
	   if(updatelist.size()>0){
		  update updatelist;
	   }
    }  
    
}