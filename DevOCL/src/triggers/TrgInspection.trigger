trigger TrgInspection on CLQ_Inspection__c (after update) {
    set<Id> setInspectionIds = new set<Id>();
    set<Id> setProgramids = new set<id>();
    list<CLQ_Program__c> lstUpdateProgram = new list<CLQ_Program__c>();
    date objvisitdate;
    datetime obj;
    integer datecount = 0;
    for(CLQ_Inspection__c objI:trigger.new){
        if(objI.isApproved__c){
            setInspectionIds.add(objI.id);
        }
    }
    
    for(CLQ_Inspection__c objI:[Select IsApproved__c, Id, CLQ_Program__c, CLQ_Program__r.CLQ_License_Type__c,CLQ_Program__r.CLQ_License_Issue_Date__c,
    (Select Id, Name, Visit_Date__c From Visit_Information__r order by Visit_Date__c desc limit 1) From CLQ_Inspection__c 
    WHERE Id IN:setInspectionIds ]){//and  = 'Continous'
        setProgramids.add(objI.CLQ_Program__c);
        for(Visit_Information__c objv:objI.Visit_Information__r){
            if(objI.CLQ_Program__r.CLQ_License_Type__c == 'Continous' && objv.Visit_Date__c != null){
                objvisitdate = objv.Visit_Date__c.adddays(30);
            }else if(objI.CLQ_Program__r.CLQ_License_Type__c == 'Provisional' && objI.CLQ_Program__r.CLQ_License_Issue_Date__c != null){
                if(objv.Visit_Date__c <= objI.CLQ_Program__r.CLQ_License_Issue_Date__c.addMonths(11)){
                    objvisitdate = objI.CLQ_Program__r.CLQ_License_Issue_Date__c.addyears(1);
                }else{
                    objvisitdate = objI.CLQ_Program__r.CLQ_License_Issue_Date__c.adddays(30);
                }
            }
            
        }
    }
    datetime objtime = objvisitdate;
    datetime finalVisitDate =  objvisitdate;
    if(objvisitdate != null){
        //obj = datetime.newinstance(objvisitdate.year(),objvisitdate.month(),objvisitdate.day());
        
        if(objtime.format('EEEE') != 'Sunday'){
            for(integer i=0;i<6;i++){
                objtime = objvisitdate.adddays(i);
                system.debug('objtime --->'+objtime+'---objtime.format'+objtime.format('EEEE'));
                if(objtime.format('EEEE') == 'Sunday'){
                    //datecount = i;
                    finalVisitDate = objtime;
                    break;
                }
                
            }
        }
    }
        
    for(CLQ_Program__c objprg:[select id,Rating_Effective_Date__c,Program_Rating__c,Rating_Expiration_Date__c from CLQ_Program__c WHERE ID IN:setProgramids]){
        system.debug('finalVisitDate --->'+finalVisitDate+'--datecount -->'+datecount);
        if(finalVisitDate != null){
            objprg.Rating_Effective_Date__c = date.newinstance(finalVisitDate.year(),finalVisitDate.month(),finalVisitDate.day());//objvisitdate.adddays(datecount);
            if(objprg.Rating_Effective_Date__c != null && objprg.Program_Rating__c != null && (objprg.Program_Rating__c == '1' || objprg.Program_Rating__c == '2')){
                objprg.Rating_Expiration_Date__c = objprg.Rating_Effective_Date__c.addYears(1).adddays(-1);
                system.debug('Date'+ objprg.Rating_Expiration_Date__c);
            }else if(objprg.Rating_Effective_Date__c != null && objprg.Program_Rating__c != null && objprg.Program_Rating__c == '3'){
                objprg.Rating_Expiration_Date__c = objprg.Rating_Effective_Date__c.addYears(2).adddays(-1);
            }else if(objprg.Rating_Effective_Date__c != null && objprg.Program_Rating__c != null && (objprg.Program_Rating__c == '4' || objprg.Program_Rating__c == '5')){
                objprg.Rating_Expiration_Date__c = objprg.Rating_Effective_Date__c.addYears(3).adddays(-1);
            }
            system.debug('objprg'+objprg);
            lstUpdateProgram.add(objprg);
        }
            
    }
    system.debug('lstUpdateProgram ---'+lstUpdateProgram);
    if(!lstUpdateProgram.isEmpty()){
        update lstUpdateProgram;
    }
}