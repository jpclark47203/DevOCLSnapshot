trigger ValidateProgramRating on CLQ_Program_Transaction__c (before insert, before update,after update)
{
if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
	 Set<Id> cpIdLst = new Set<Id>();
	 for(CLQ_Program_Transaction__c cpt : Trigger.new){
	 	system.debug('CLQ_Transaction_Status__c --->'+cpt.CLQ_Transaction_Status__c);
	  cpIdLst.add(cpt.CLQ_Program__c);
	 }
	  Map<id,CLQ_Program__c> cpMap = new Map<id,CLQ_Program__c>([select id,Program_Rating__c from CLQ_Program__c where id=:cpIdLst]);
	  for(CLQ_Program_Transaction__c cpt : Trigger.new)
	  {
	    if(cpMap != null && cpMap.containsKey(cpt.CLQ_Program__c))
	 {
	    CLQ_Program__c cp = cpMap.get(cpt.CLQ_Program__c);
	    if(cp.Program_Rating__c != null && cp.Program_Rating__c != '' && cpt.Recommended_Annual_Report_Rating__c != null && cpt.Recommended_Annual_Report_Rating__c != '')
	    {
	      integer reportRating = integer.valueOf(cpt.Recommended_Annual_Report_Rating__c);
	   integer prgRating = integer.valueOf(cp.Program_Rating__c);
	   
	   if(reportRating > prgRating)
	     cpt.addError('Annual report rating exceeds program rating');
	    
	    }
	 
	 	}
	  }
	  if(Trigger.isUpdate){
	  	map<string,Id> mapQueueIds = new map<string,Id>();
	  	
	  	Id objPreSchoolId = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get('Pre School').getRecordTypeId();
	  	Id objSchoolAge = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get('School Age Child Care').getRecordTypeId();
	  	Id objFCCA = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get('FCC - Type A Home').getRecordTypeId();
	  	Id objFCCB = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get('FCC - Type B Home').getRecordTypeId();
	  	Id objChildCare = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get('Child Care Center').getRecordTypeId();
	  	
	  	for(Group objg:[Select Type, Name, Id, DeveloperName From Group WHERE Type='Queue']){
	  		mapQueueIds.put(objg.DeveloperName,objg.id);
	  	}
	  		set<Id> setProgramIDs = new set<Id>();
	  		for(CLQ_Program_Transaction__c objt: trigger.new){
	  			if(objt.CLQ_Transaction_Status__c != null && objt.CLQ_Transaction_Status__c == 'Submitted'){
	  				setProgramIDs.add(objt.CLQ_Program__c);
	  			}
	  		}
  		for(CLQ_Program__c  objprg:[Select Program_Rating__c,RecordTypeId,RecordType.Name,CLQ_County__c,
	        CLQ_County__r.Area_Region__c,CLQ_County__r.CCC_Field_Officers__c,CLQ_County__r.FCC_Field_officers__c ,
	        (Select Recommended_Annual_Report_Rating__c,OwnerID From Program_Transactions__r WHERE Id In :trigger.new) 
	       From CLQ_Program__c WHERE id IN : setProgramIDs]){
	       	for(CLQ_Program_Transaction__c objTran:objprg.Program_Transactions__r){
	       		if(objprg.CLQ_County__c != null){
	       			if(objprg.RecordTypeId ==  objPreSchoolId || objprg.RecordTypeID == objSchoolAge ){
	       				if(objprg.CLQ_County__r.Area_Region__c != null){
	       					if(objprg.CLQ_County__r.Area_Region__c == 'NW'){
		       					objTran.OwnerId = mapQueueIds.get('ODE_NW');
		       				}
		       				if(objprg.CLQ_County__r.Area_Region__c == 'NE'){
		       					objTran.OwnerId = mapQueueIds.get('ODE_NE');
		       				}
		       				if(objprg.CLQ_County__r.Area_Region__c == 'SE'){
		       					objTran.OwnerId = mapQueueIds.get('ODE_SE');
		       				}
		       				if(objprg.CLQ_County__r.Area_Region__c == 'C'){
		       					objTran.OwnerId = mapQueueIds.get('ODE_C');
		       				}
		       				if(objprg.CLQ_County__r.Area_Region__c == 'SW'){
		       					objTran.OwnerId = mapQueueIds.get('ODE_SW');
		       				}
	       				}
	       			}
	       			if(objprg.RecordTypeId ==  objFCCA || objprg.RecordTypeID == objFCCB ){
	       				if(objprg.CLQ_County__r.FCC_Field_officers__c != null){
	       					if(objprg.CLQ_County__r.FCC_Field_officers__c == 'Toledo'){
		       					objTran.OwnerId = mapQueueIds.get('JFS_FCC_Toledo');
		       				}
		       				if(objprg.CLQ_County__r.FCC_Field_officers__c == 'Cleveland'){
		       					objTran.OwnerId = mapQueueIds.get('JFS_FCC_Clevelad');
		       				}
		       				if(objprg.CLQ_County__r.FCC_Field_officers__c == 'Columbus'){
		       					objTran.OwnerId = mapQueueIds.get('JFS_FCC_Columbus	');
		       				}
		       				if(objprg.CLQ_County__r.FCC_Field_officers__c == 'Akron'){
		       					objTran.OwnerId = mapQueueIds.get('JFS_FCC_Akron');
		       				}
		       				if(objprg.CLQ_County__r.FCC_Field_officers__c == 'Dayton'){
		       					objTran.OwnerId = mapQueueIds.get('JFS_FCC_Dayton');
		       				}
	       				}
	       			}
       				if(objprg.RecordTypeId ==  objChildCare){
	       				if(objprg.CLQ_County__r.CCC_Field_Officers__c != null){
	       					if(objprg.CLQ_County__r.CCC_Field_Officers__c == 'Toledo'){
		       					objTran.OwnerId = mapQueueIds.get('JFS_CCC_Toledo');
		       				}
		       				if(objprg.CLQ_County__r.CCC_Field_Officers__c == 'Cleveland'){
		       					objTran.OwnerId = mapQueueIds.get('JFS_CCC_Clevelad');
		       				}
		       				if(objprg.CLQ_County__r.CCC_Field_Officers__c == 'Columbus'){
		       					objTran.OwnerId = mapQueueIds.get('JFS_CCC_Columbus	');
		       				}
		       				if(objprg.CLQ_County__r.CCC_Field_Officers__c == 'Akron'){
		       					objTran.OwnerId = mapQueueIds.get('JFS_CCC_Akron');
		       				}
		       				if(objprg.CLQ_County__r.CCC_Field_Officers__c == 'Dayton'){
		       					objTran.OwnerId = mapQueueIds.get('JFS_CCC_Dayton');
		       				}
	       				}
	       			}
       			}
	       	}
       }
	  }
  }
  
  if(trigger.isAfter && trigger.isUpdate){
  list<CLQ_Program__c > lstProgUpdate = new list<CLQ_Program__c >();
  set<Id> setTranids = new set<Id>();
  
      for(CLQ_Program_Transaction__c objtr:trigger.new){
          if(objtr.IsApproved_PrgTran__c){
              setTranids.add(objtr.CLQ_Program__c); 
          }
      }
      
      for(CLQ_Program__c  objprg:[Select Program_Rating__c,RecordTypeId,RecordType.Name,CLQ_County__c,
        CLQ_County__r.Area_Region__c,CLQ_County__r.CCC_Field_Officers__c,CLQ_County__r.FCC_Field_officers__c,
       (Select Recommended_Annual_Report_Rating__c From Program_Transactions__r WHERE Id In :trigger.new) 
       From CLQ_Program__c WHERE id IN : setTranids]){
      for(CLQ_Program_Transaction__c objtran: objprg.Program_Transactions__r ){
          if(objtran.Recommended_Annual_Report_Rating__c  != null){
              objprg.Program_Rating__c = objtran.Recommended_Annual_Report_Rating__c ;
             lstProgUpdate.add(objprg);
  
          }
      }
      // Code for Assigning 
      
  }
    if(!lstProgUpdate.isEmpty()){update lstProgUpdate;}  
}
}