trigger VisitorAuthorization on Visit_Information__c(after insert,after update,after delete)
{
  Set<id> delInsIdLst = new Set<id>();
  Set<id> delUsrIdLst = new Set<id>();
  List<CLQ_Inspection__Share> shrLst = new List<CLQ_Inspection__Share>();
  if(trigger.isInsert)
  {
     for(Visit_Information__c vi : Trigger.new)
	 {
           CLQ_Inspection__Share shr = new CLQ_Inspection__Share();
	   shr.ParentId = vi.Inspection__c;
	   shr.UserOrGroupId = vi.User__c;
	   shr.AccessLevel = 'edit';
	   shrLst.add(shr);

     }	 
   
  }
  else if(trigger.isUpdate)
  {
    for(Visit_Information__c vi : Trigger.new)
	{
	  Visit_Information__c oldvi = Trigger.oldMap.get(vi.id);
	  
	  if(vi.User__c != null && oldvi.User__c != vi.User__c)
      {
         CLQ_Inspection__Share shr = new CLQ_Inspection__Share();
	     shr.ParentId = vi.Inspection__c;
	     shr.UserOrGroupId = vi.User__c;
	     shr.AccessLevel = 'edit';
	     shrLst.add(shr);
             delInsIdLst.add(oldvi.Inspection__c);
             delUsrIdLst.add(oldvi.User__c);
     }	  
	
	
	}
  
  
  }
  else if(trigger.isdelete)
  {
  
     for(Visit_Information__c vi : TRigger.old)
	 {
	     delInsIdLst.add(vi.Inspection__c);
		 delUsrIdLst.add(vi.User__c);
     }
  
  }
  
  if(delUsrIdLst != null && !delUsrIdLst.isEmpty())
  {
      List<CLQ_Inspection__Share> delShrLst = [select id from CLQ_Inspection__Share where ParentId=:delInsIdLst and UserOrGroupId=:delUsrIdLst];
      delete delShrLst;
  }  

   if(shrLst !=  null && !shrLst.isEmpty())
     insert shrLst;
}