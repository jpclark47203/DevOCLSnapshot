public with sharing class CLQ_VisitModeController {
    //Variables
    public list<String> fieldlist;
    public CLQ_Inspection__c inspectionRecord {get;set;}
    //public list<visitRulewrapper> wrapperClasslist{get;set;}
    public list<domainwithRuleList>domainRuleWrapperList{get;set;}
    public Boolean showPopup{get;set;}
    public list<popupWrapper> popupWrapperList{get;set;}
    public String selectedRule{get;set;}
    public String selectedInspectedRule{get;set;}
    public String resultselected{get;set;}
    public String filtervalue{get;set;}
    public String domainfiltervalue{get;set;}
    public List<SelectOption> filterOptions{get;set;}
    public List<SelectOption> domainOptions{get;set;}
    Boolean showError = false;
    private list<CLQ_Rules_Inspected__c> rulesTobeUpdated = new list<CLQ_Rules_Inspected__c>();
    
    //popup realted variables
    list<CLQ_Standard_Findings__c> standardFindingList = new list<CLQ_Standard_Findings__c>();
    list<CLQ_Findings__c> findinglist = new list<CLQ_Findings__c>();
    map<id,CLQ_Findings__c> existingStandardFindingIdMap = new map<id,CLQ_Findings__c>();
    
    //Constructor
    public CLQ_VisitModeController(ApexPages.StandardController controller) {
        inspectionRecord = new CLQ_Inspection__c();
        fieldlist = new list<String>{'Name'}; //Add fields as per need
        if(!Test.isRunningTest()){
            controller.addFields(fieldlist);
        }
        this.inspectionRecord = (CLQ_Inspection__c)controller.getRecord();
        //wrapperClasslist = new list<visitRulewrapper>();
        domainRuleWrapperList = new list<domainwithRuleList>();
        showPopup = false;
        filtervalue = 'All';
        domainfiltervalue = 'All';
        //filterOptions = new list<SelectOption>();
    }

    /*************************************Methods ******************************************************************/
    //Method to add select option in filter drop-down on load
    public list<SelectOption> populateRuleFilter(){
        filterOptions = new list<SelectOption>();
        filterOptions.add(new SelectOption('All','All'));
        filterOptions.add(new SelectOption('Not Assessed','Not Assessed'));
        Schema.DescribeFieldResult fieldResult = CLQ_Rules_Inspected__c.CLQ_Result__c.getDescribe();
        
        for( Schema.PicklistEntry f : fieldResult.getPicklistValues()){
            filterOptions.add(new SelectOption(f.getLabel(),f.getValue()));
        }
        return filterOptions;
    }

    //Method to do on load logic
    //@param: none
    //@return: none
    public PageReference onLoad(){
        //String domainName = '';
        set<id> standardFindingRuleIDSet = new set<id>(); //variable to store all standard findings id
        set<String> domainNameSet = new set<String>(); //store unique domain names
        map<id,String> ruleInspectedFindingCodeMap = new map<id,String>(); //Map all rule inspected with its code
        map<id,String> ruleInspectedDescriptionMap = new map<id,String>(); //Map all rule inspected with its description
        set<id> domainRuleIDSet = new set<id>();

        //Get all rule inspected for given insepection
        list<CLQ_Rules_Inspected__c> ruleinspectedlist = pullRuleInspectedforInspection(inspectionRecord.id);
        domainOptions = new list<SelectOption>();
        domainOptions.add(new SelectOption('All','All'));
        //Populate rule filter drop-down with pre-defined values
        populateRuleFilter();

        //Prepare the data map for rule code and rule description
        for(CLQ_Rules_Inspected__c ruleInspected : ruleinspectedlist){
            standardFindingRuleIDSet.add(ruleInspected.CLQ_Domain_Rule__r.CLQ_Rule__c);
            domainNameSet.add(ruleInspected.CLQ_Domain_Rule__r.CLQ_Domain__r.Name);
            domainRuleIDSet.add(ruleInspected.CLQ_Domain_Rule__c);
            String selectedFindings = '';
            String selectedFindingsDescriptions = '';
            if(ruleInspected.Findings__r != null){
                for(CLQ_Findings__c findingRecord : ruleInspected.Findings__r){
                    if(findingRecord.CLQ_Standard_Finding__r.CLQ_Finding_Code__c != null && findingRecord.CLQ_Standard_Finding__r.CLQ_Finding_Code__c != ''){
                        selectedFindings ='> '+findingRecord.CLQ_Standard_Finding__r.CLQ_Finding_Code__c+'<br>'+selectedFindings;
                    }
                    if(findingRecord.CLQ_Description__c != null && findingRecord.CLQ_Description__c != ''){
                        selectedFindingsDescriptions ='> '+findingRecord.CLQ_Standard_Finding__r.CLQ_Finding_Code__c+': '+findingRecord.CLQ_Description__c+'<br>'+selectedFindingsDescriptions;
                    }
                }
                
                selectedFindings.removeEnd('<br>');
                selectedFindingsDescriptions.removeEnd('<br>');
            }
            ruleInspectedFindingCodeMap.put(ruleInspected.id,selectedFindings);
            ruleInspectedDescriptionMap.put(ruleInspected.id,selectedFindingsDescriptions);
        }

        //Get the Domain Rules 
        map<id,CLQ_Domain_Rule__c> mapIDDomainRule = new map<id,CLQ_Domain_Rule__c>([SELECT id
                                                                                    ,(SELECT id 
                                                                                            ,Name
                                                                                            ,CLQ_Regulation__r.CLQ_Reg_key__c
                                                                                        FROM Rule_Regulations__r)
                                                                                    FROM CLQ_Domain_Rule__c
                                                                                    WHERE id in :domainRuleIDSet]);

        //Get all Rules and its related Standard Findings
        list<CLQ_Rule__c> rulelist = [Select ID
                                            ,CLQ_Domain__c
                                            ,(SELECT id
                                            ,Name
                                            FROM Standard_Findings__r)
                                    FROM CLQ_Rule__c
                                    WHERE id in :standardFindingRuleIDSet];
        map<id,String> inspectedRuleRegulationMap = new map<id,String>();

        //Prepare data to show Regulation
        for(CLQ_Domain_Rule__c domainRuleRecord : mapIDDomainRule.values()){
            String regulation = '';
            if(mapIDDomainRule.get(domainRuleRecord.id) != null 
                && mapIDDomainRule.get(domainRuleRecord.id).Rule_Regulations__r != null){
               for(CLQ_Junction_RuleRegs__c regulationrecord : mapIDDomainRule.get(domainRuleRecord.id).Rule_Regulations__r){
                    regulation =regulation+','+ regulationrecord.Name;
                }
                regulation.removeEnd(',');
                inspectedRuleRegulationMap.put(domainRuleRecord.id,regulation); 
            }
        }


        //Now store the data in wrapper class structure so that we can display that in VF page
        for(String domainName : domainNameSet){
            //populate the domain option
            domainOptions.add(new SelectOption(domainName,domainName));
            list<rulewithFinding> rulewithFindingList = new list<rulewithFinding>();
            for(CLQ_Rules_Inspected__c ruleInspected : ruleinspectedlist){
                String regulation = '';
                if(domainName == ruleInspected.CLQ_Domain_Rule__r.CLQ_Domain__r.Name){
                    
                    if(inspectedRuleRegulationMap.get(ruleInspected.CLQ_Domain_Rule__c)!= null){
                        regulation = inspectedRuleRegulationMap.get(ruleInspected.CLQ_Domain_Rule__c);
                    }
                    rulewithFindingList.add(new rulewithFinding(ruleInspected,ruleInspectedFindingCodeMap.get(ruleInspected.id),ruleInspectedDescriptionMap.get(ruleInspected.id),regulation));
                }

            }
            domainwithRuleList wrapperRecord = new domainwithRuleList(domainName,rulewithFindingList);
            domainRuleWrapperList.add(wrapperRecord);   
        }
        //domainRuleWrapperListbeforeSave = domainRuleWrapperList;
        return null;
    }
    
    public pageReference onSearch(){
        //filtervalue = 'All';
        //domainfiltervalue = 'All';
        system.debug('===>'+domainfiltervalue);
        for(domainwithRuleList wrapperRecord : domainRuleWrapperList){
            wrapperRecord.showDomain = false;
            if(domainfiltervalue != 'All' && domainfiltervalue == wrapperRecord.domainName){
                wrapperRecord.showDomain = true;
            }else if(domainfiltervalue == 'All'){
                wrapperRecord.showDomain = true;
            }
            system.debug('===>'+wrapperRecord.domainName);
            system.debug('===>'+wrapperRecord.showDomain);
            for(rulewithFinding childWrapperRecord : wrapperRecord.rulelist){
                childWrapperRecord.showRule = false;
                if(wrapperRecord.showDomain == false){
                    childWrapperRecord.showRule = false;
                }else if(filtervalue == 'Not Assessed' 
                    && wrapperRecord.showDomain 
                    && (childWrapperRecord.ruleRecord.CLQ_Result__c == '' || childWrapperRecord.ruleRecord.CLQ_Result__c == null)){
                    childWrapperRecord.showRule = true;
                }else if(filtervalue == 'All' 
                    && wrapperRecord.showDomain 
                    ){
                    childWrapperRecord.showRule = true;
                }else if(filtervalue == childWrapperRecord.ruleRecord.CLQ_Result__c 
                    && wrapperRecord.showDomain 
                    ){
                    childWrapperRecord.showRule = true;
                }else{
                    childWrapperRecord.showRule = false;
                }
                system.debug('==rule==>'+childWrapperRecord.showRule);
            }
        }
        return null;
    }

    //Method to query all rule inspected for the inspection
    //@param: inspection record id
    //@return: list of rule inspected
    public list<CLQ_Rules_Inspected__c> pullRuleInspectedforInspection(ID inspectionid){
        //add related object CLQ_Finind__c
        String relationQuery = '(SELECT id,CLQ_Standard_Finding__r.CLQ_Finding_Code__c ,CLQ_Description__c FROM  Findings__r)';
        //add extra fields as needed
        list<String> extraFieldsList = new list<String>{'CLQ_Domain_Rule__r.CLQ_Rule__c','CLQ_Domain_Rule__r.CLQ_Rule__r.Name','CLQ_Domain_Rule__r.CLQ_Rule__r.CLQ_Description__c','CLQ_Domain_Rule__r.CLQ_Domain__r.Name','CLQ_Domain_Rule__r.CLQ_Rule__r.CLQ_Short_Name__c','CLQ_Domain_Rule__r.CLQ_Rule__r.CLQ_Long_Name__c'};
        extraFieldsList.add(relationQuery);
        //get soql string
        String soqlQuery = CLQ_UtilityClass.createSOQLQuery('CLQ_Rules_Inspected__c', ' CLQ_Inspection_No__c ='+'\''+inspectionid+'\'', extraFieldsList);   
        soqlQuery = soqlQuery + ' ORDER by CLQ_Domain_Rule__r.CLQ_Domain__r.Name';
        //query database
        return Database.query(soqlQuery);
    }

    //Method to redirect to Inspection page
    //@return: pageReference
    //@param : none
    public PageReference onCancel(){
        //return to inspection record
        return CLQ_UtilityClass.redirecttoPage('/'+inspectionRecord.Id);
    }

    //Method to save the records in database
    //@return: pageReference
    //@param : none
    public PageReference onSave(){
        //get all the rule inspected from the wrapper list
            
            list<CLQ_Rules_Inspected__c> ruleInspectedlist = new list<CLQ_Rules_Inspected__c>();
            for(domainwithRuleList wrapperrecord : domainRuleWrapperList){
                for(rulewithFinding childWrapper : wrapperrecord.rulelist){
                    if(childWrapper.sfindingCode == '' 
                        && (childWrapper.ruleRecord.CLQ_Result__c == 'Compliant' 
                        || childWrapper.ruleRecord.CLQ_Result__c == 'Non-Compliant' )){
                        showError = true;
                    }
                    ruleInspectedlist.add(childWrapper.ruleRecord);
                }
                
            }
            //update the rule inspected record
            if(!showError){
                update ruleInspectedlist;
                }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Select at-least one finding for all Compliant/Non-Compliant rules'));        
                }
            return null;

        
    }

    //Method to save the records in database
    //@return: pageReference
    //@param : none
    public PageReference onSaveandClose(){
        //first save and perform cancel
        onSave();
        return onCancel();
    }

    //Update the description of given row
    //@param: 
    //@return:
    public pageReference updateFindingDescription(){
        return null;
    }

    //prepare Popup data
    //@param: none  
    //@none: Pagereference
    public PageReference popupOnLoad(){

        showPopup = true; //variable to define if pop-up needs to be shown or not
        popupWrapperList = new list<popupWrapper>(); //list to show the table in pop-up
        selectedRule = ApexPages.currentPage().getParameters().get('selectedRule');
        selectedInspectedRule = ApexPages.currentPage().getParameters().get('selectedInspectedRule');
        resultselected = ApexPages.currentPage().getParameters().get('resultselected');
        system.debug('====selectedRule===>'+selectedRule);
        system.debug('====selectedInspectedRule===>'+selectedInspectedRule);
        
        for(domainwithRuleList wrapperRecord : domainRuleWrapperList){
            for(rulewithFinding c : wrapperRecord.rulelist){
                if(selectedInspectedRule == c.ruleRecord.id){
                    resultselected = c.ruleRecord.CLQ_Result__c;
                }
            } 
        }
        String rulesToShow = '';
        standardFindingList = new list<CLQ_Standard_Findings__c>();
        findinglist = new list<CLQ_Findings__c>();
        existingStandardFindingIdMap = new map<id,CLQ_Findings__c>();
        
        if(resultselected != '' && resultselected == 'Compliant'){ 
            rulesToShow = 'Documenting Statement';
        }

        //Get all the Findings stored for the rule
        findinglist = Database.query(CLQ_UtilityClass.createSOQLQuery('CLQ_Findings__c', ' CLQ_Rules_Inspected__c ='+'\''+selectedInspectedRule+'\'', null));
        //Get all the standard findings for given rule
        
        if(rulesToShow != ''){
            standardFindingList = Database.query(CLQ_UtilityClass.createSOQLQuery('CLQ_Standard_Findings__c', ' CLQ_Domain_Rule__c ='+'\''+selectedRule+'\' AND CLQ_Finding_Type__c = \''+rulesToShow+'\'', null));
            }else{
                standardFindingList = Database.query(CLQ_UtilityClass.createSOQLQuery('CLQ_Standard_Findings__c', ' CLQ_Domain_Rule__c ='+'\''+selectedRule+'\'', null)); 
            }

        //add findings
        for(CLQ_Findings__c finding : findinglist){
            existingStandardFindingIdMap.put(finding.CLQ_Standard_Finding__c,finding);
        }

        //add standard finding in wrapper if it is not already in the list
        for(CLQ_Standard_Findings__c sFinding : standardFindingList){
            if(existingStandardFindingIdMap.get(sFinding.id) != null){
                popupWrapper wrapperRecord = new popupWrapper(true,existingStandardFindingIdMap.get(sFinding.id),sFinding.CLQ_Finding_Code__c,sFinding.CLQ_Risk_Level__c);
                popupWrapperList.add(wrapperRecord);
            }else{
                CLQ_Findings__c newFinding = new CLQ_Findings__c(CLQ_Rules_Inspected__c=selectedInspectedRule
                                                                ,CLQ_Standard_Finding__c = sFinding.id
                                                                ,CLQ_Description__c = sFinding.CLQ_Description__c
                                                                
                                                                );
                popupWrapper wrapperRecord = new popupWrapper(false,newFinding,sFinding.CLQ_Finding_Code__c,sFinding.CLQ_Risk_Level__c);
                popupWrapperList.add(wrapperRecord);
                
            }
        }

        system.debug('====>'+popupWrapperList.size());
        return null;
    }

    //on close Popup button
    //@param:
    //@none:
    public PageReference closePopUp(){
        showPopup = false;
        return null;
    }

    //on save Popup button
    //@param: none
    //@return: pagereference
    public PageReference savePopUp(){
        showPopup = false;
        String newsFindingCode = '';
        String newsDescription = '';
        list<CLQ_Findings__c> findinglisttoInsert = new list<CLQ_Findings__c>();
        list<CLQ_Findings__c> findinglisttoDelete = new list<CLQ_Findings__c>();
        //Loop to check with record is selected or not
        for(popupWrapper findingWrapper: popupWrapperList){
            if(findingWrapper.isSelected == true){
                findinglisttoInsert.add(findingWrapper.finding);
                if(findingWrapper.sFindingCode != null && findingWrapper.sFindingCode != ''){
                    //updated the finding code for inspected rule
                    newsFindingCode ='> '+findingWrapper.sFindingCode+'<br>'+newsFindingCode;
                }
                if(findingWrapper.finding.CLQ_Description__c != null && findingWrapper.finding.CLQ_Description__c  != ''){
                    //updated the description for inspected rule
                    newsDescription ='> '+findingWrapper.sFindingCode+': '+findingWrapper.finding.CLQ_Description__c+'<br>'+newsDescription;
                }
            }
            if(findingWrapper.isSelected == false && existingStandardFindingIdMap.get(findingWrapper.finding.CLQ_Standard_Finding__c) != null){
                //prepare the list to delete
                findinglisttoDelete.add(findingWrapper.finding);
            }
        }
        newsFindingCode.removeEnd('<br>');
        newsDescription.removeEnd('<br>');
        //update the wrapper class with new code and description before completing the method
        for(domainwithRuleList parentWrapper : domainRuleWrapperList){
            for(rulewithFinding childWrapper : parentWrapper.rulelist){
                if(childWrapper.ruleRecord.id == selectedInspectedRule){
                    childWrapper.sfindingCode = newsFindingCode;
                    childWrapper.sfindingDescription = newsDescription;
                }
            }
        }
        //insert new findings
        if(findinglisttoInsert.size()>0){
            upsert findinglisttoInsert;
        }
        //remove unselected findings
        if(findinglisttoDelete.size()>0){
            delete findinglisttoDelete;
        }
        return null;
    }

    //Method to mark all rule as compliant
    //@param: none
    //@return: pagereference
    public PageReference markAllCompliant(){
        
        for(domainwithRuleList domainwithRuleRecord : domainRuleWrapperList){
            if(domainwithRuleRecord.showDomain){
                for(rulewithFinding childWrapper : domainwithRuleRecord.rulelist){
                    if((childWrapper.ruleRecord.CLQ_Result__c == '' || childWrapper.ruleRecord.CLQ_Result__c == null) && childWrapper.showRule){
                        childWrapper.ruleRecord.CLQ_Result__c = 'Compliant';
                    }
                    
                }
            }
        }
        return null;
    }
    
    /**************************************Wrapper Class section begins *********************************************/
    //child Wrapper
    public class rulewithFinding{
        public CLQ_Rules_Inspected__c ruleRecord{get;set;}
        public String sfindingCode{get;set;}
        public String sfindingDescription{get;set;}
        public Boolean showRule{get;set;}
        public String regulation{get;set;}
        public rulewithFinding(CLQ_Rules_Inspected__c ruleRecord,String sfindingCode,String sfindingDescription,String regulation){
            this.ruleRecord = ruleRecord;
            this.sfindingCode = sfindingCode;
            this.sfindingDescription = sfindingDescription;
            this.regulation = regulation;
            showRule = true;
        }
        
    }

    //parent wrapper
    public class domainwithRuleList{
        public String domainName{get;set;}
        public list<rulewithFinding> rulelist{get;set;}
        public Boolean showDomain{get;set;}
        public domainwithRuleList(String dname , list<rulewithFinding> rulewithFindingList){
            this.domainName = dname;
            this.rulelist = rulewithFindingList;
            showDomain = true;
        }
    }

    //wrapper for pop up
    public class popupWrapper{
        public Boolean isSelected{get;set;}
        public CLQ_Findings__c finding{get;set;}
        public String sFindingCode{get;set;}
        public String riskLevel{get;set;}
        public popupWrapper(Boolean isSelected,CLQ_Findings__c sfinding,String sFindingCode,String riskLevel){
            this.isSelected = isSelected;
            this.finding = sfinding;
            this.sFindingCode = sFindingCode;
            this.riskLevel = riskLevel;
        }
    }
    /**************************************Wrapper Class section ends *********************************************/

}