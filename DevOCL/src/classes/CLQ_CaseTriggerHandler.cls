/* Name : CLQ_CaseTriggerHandler
 * Description : This class contains all detail logic/methods for Case object's trigger. Methods are being called from CLQ_CaseTrigger 
 */
public class CLQ_CaseTriggerHandler extends CLQ_Trigger {

    ////////////////////////////////     Boilerplate implementation  ////////////////////////////
    //Allows only this trigger to be bypassed. Useful in Unit Test data setup and some bulk data loads.
    public static boolean BypassTrigger {
        get {
            if (BypassTrigger == null) BypassTrigger = false;
            return BypassTrigger;
        }
        set;
    }

    //Calls the Base class Constructor
    public CLQ_CaseTriggerHandler(list < sObject > newlistin, map < id, sObject > newMapin, list < sObject > oldlistin,map < id, sObject > oldMapin,
            boolean isExecutingin, boolean isInsertin, boolean isUpdatein, boolean isDeletein,
            boolean isBeforein, boolean isAfterin, boolean isUndeletein, integer sizein) {
            super(newlistin, newMapin, oldlistin, oldMapin,
                isExecutingin, isInsertin, isUpdatein, isDeletein,
                isBeforein, isAfterin, isUndeletein, sizein);
            BypassInheritedTrigger = BypassTrigger;
        }
        ////////////////////////////////     Boilerplate implementation  ////////////////////////////

    //Before insert logic method
    //@param : triggernew, triggernewmap
    //@return : null
    public override void beforeinsert() {
        populateAssigntoonComplaint((list < Case > ) newlist, (map < id, Case > ) newMap);
    }

    //After insert logic method
    //@param : triggerold, triggeroldmap,triggernew, triggernewmap
    //@return : null
    public override void afterinsert() {
        insertRoleonContact((list < Case > ) newlist, (map < id, Case > ) newMap);
    }

    //Method to insert role  for selected contact on Case
    //@param : 
    //@return :
    public void insertRoleonContact(list < Case > triggernew, map < id, Case > triggernewmap) {
        list < CLQ_Role__c > roleList = new list < CLQ_Role__c > (); //role list 
        map < string, CLQ_Role__c > uniqueKeyRoleMap = new map < string, CLQ_Role__c > ();
        set < id > contactIDset = new set < id > ();
        //list < Task > taskListtoinsert = new list < Task > ();
        
        //Check the below conditions to create complainant role record for contact
        //1. record type = 'Complaint'
        //2. CLQ_Anonymous_Complainant__c = false
        //3. Contact is populated
        for (Case caseRecord: triggernew) {

            if (caseRecord.recordTypeID == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId() &&
                !caseRecord.CLQ_Anonymous_Complainant__c &&
                caseRecord.ContactId != null) {
                CLQ_Role__c contactRole = new CLQ_Role__c();
                contactRole.CLQ_Program__c = caseRecord.CLQ_Program__c;
                contactRole.CLQ_Contact__c = caseRecord.ContactId;
                contactRole.RecordTypeID = Schema.SObjectType.CLQ_Role__c.getRecordTypeInfosByName().get(
                    'Program Role').getRecordTypeId();
                contactRole.CLQ_Role__c = 'Complainant';
                contactIDset.add(caseRecord.ContactId);
                uniqueKeyRoleMap.put(String.valueOf(contactRole.CLQ_Program__c) + String.valueOf(contactRole.RecordTypeID) +
                    String.valueof(contactRole.CLQ_Role__c) + String.valueof(contactRole.CLQ_Contact__c),
                    contactRole);

                //roleList.add(contactRole);
            }
            /*if (caseRecord.recordTypeID == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId()) {
                taskListtoinsert.add(new Task(Subject = 'Review Complaint report',
                OwnerID = caseRecord.CLQ_Assigned_To__c, Whatid = caseRecord.id)); 

            }*/
        }

        //block to ckeck if the role record already created or not
        for (CLQ_Role__c roleRecord: [SELECT id, CLQ_Program__c, CLQ_Contact__c, CLQ_Role__c, RecordTypeID
                                        FROM CLQ_Role__c
                                        WHERE CLQ_Contact__c in: contactIDset]) {
            if (uniqueKeyRoleMap.get(String.valueof(roleRecord.CLQ_Program__c) + String.valueof(roleRecord.RecordTypeID) +
                    String.valueof(roleRecord.CLQ_Role__c) + String.valueof(roleRecord.CLQ_Contact__c)) != null) {
                uniqueKeyRoleMap.remove(String.valueof(roleRecord.CLQ_Program__c) + String.valueof(roleRecord.RecordTypeID) +
                    String.valueof(roleRecord.CLQ_Role__c) + String.valueof(roleRecord.CLQ_Contact__c));
            }
        }

        //insert the role record
        insert uniqueKeyRoleMap.values();

        //insert task for assign to user
        //insert taskListtoinsert;

    }

    //Method to populate Assign to as reviewer specialist
    //@param: trigger new and newmap
    //Return : updated triggernew
    public list < Case > populateAssigntoonComplaint(list < Case > triggernew, map < id, Case > triggernewmap) {
        set < id > programIDSet = new set < id > ();
        list < Task > taskListtoinsert = new list < Task > ();
        
        //Fetching the assignment rules on case
        //AssignmentRule AR = new AssignmentRule();
        //AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];

        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        //Database.DMLOptions dmlOpts = new Database.DMLOptions();
        //dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;

        list < CLQ_Program__c > programList = new list < CLQ_Program__c > ();
        for (Case caseRecord: triggernew) {
            if (caseRecord.recordTypeID == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId() &&
                caseRecord.CLQ_Program__c != null) {
                programIDSet.add(caseRecord.CLQ_Program__c);
            }
        }

        /*map < id, CLQ_Program__c > programmap = new map < id, CLQ_Program__c > ([SELECT id,
            CLQ_Licensing_Specialist__c FROM CLQ_Program__c WHERE id in: programIDSet]);
        for (Case caseRecord: triggernew) {
            if (caseRecord.CLQ_Assigned_To__c == null && programmap.get(caseRecord.CLQ_Program__c) != null) {
                caseRecord.CLQ_Assigned_To__c = programmap.get(caseRecord.CLQ_Program__c).CLQ_Licensing_Specialist__c;
            }

            if (caseRecord.CLQ_Assigned_To__c == null) {
                caseRecord.setOptions(dmlOpts);
            }

        }*/

        return triggernew;
    }
}