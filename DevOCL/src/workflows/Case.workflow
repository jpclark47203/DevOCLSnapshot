<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CLQ_Center_JFS_Email_Notification</fullName>
        <description>Center JFS Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Approver_s_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Assigned_to_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_Notification_on_initial_submission_of_complaint_report</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_Center_Email_Notification</fullName>
        <description>JFS Center Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Approver_s_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Assigned_to_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_Notice_on_initial_submission_of_complaint</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_Complaint_Alert_to_Approver</fullName>
        <description>CLQ JFS Complaint Alert to Approver</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Approver_s_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Assigned_to_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_Notification_on_initial_submission_of_complaint_report</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_Complaint_Notification_Under_Review</fullName>
        <description>JFS-Complaint Notification - Under Review</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Approver_s_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Assigned_to_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_Notice_on_initial_submission_of_complaint</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_Complaint_Notification_on_initial_submission_of_complaint_report</fullName>
        <description>JFS-Complaint Notification on initial submission of complaint report</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Approver_s_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Assigned_to_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_Notification_on_initial_submission_of_complaint_report</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_Notification_Email_Alert_for_type_A_and_B</fullName>
        <description>JFS Notification Email Alert for type A and B</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_Specialist_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_Notification_on_initial_submission_of_complaint_report</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_Types_Complaint_Email_Notification</fullName>
        <description>JFS Types Complaint Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Approver_s_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_Notice_on_initial_submission_of_complaint</template>
    </alerts>
    <alerts>
        <fullName>CLQ_ODE_Complaint_Email_Alert_to_Approver</fullName>
        <description>CLQ ODE Complaint Email Alert to Approver</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Approver_s_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Assigned_to_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_ODE_Notification_on_initial_submission_of_complaint_report</template>
    </alerts>
    <alerts>
        <fullName>CLQ_ODE_Complaint_Notification_Under_Review</fullName>
        <description>ODE-Complaint Notification Under Review</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Approver_s_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Assigned_to_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_ODE_Notice_on_initial_submission_of_complaint</template>
    </alerts>
    <alerts>
        <fullName>CLQ_ODE_Complaint_Notification_on_initial_submission_of_complaint_report</fullName>
        <description>ODE-Complaint Notification on initial submission of complaint report</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Approver_s_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Assigned_to_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_ODE_Notification_on_initial_submission_of_complaint_report</template>
    </alerts>
    <fieldUpdates>
        <fullName>CLQ_Approval_Start_False</fullName>
        <field>CLQ_Start_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Approval Start False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Approved_Status</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Approved Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Check_Approved_by_Manager_field</fullName>
        <field>CLQ_Approved_by_Manager__c</field>
        <literalValue>1</literalValue>
        <name>Check Approved by Manager field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Complaint_Submitted_RT</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CLQ_Complaint_Submitted</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Complaint Submitted RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Pending_Approval</fullName>
        <field>Status</field>
        <literalValue>Pending Approval</literalValue>
        <name>Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Returned_For_Reviewer</fullName>
        <field>Status</field>
        <literalValue>Return to Specialist/Reviewer</literalValue>
        <name>Returned For Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Start_Approval_False</fullName>
        <field>CLQ_Start_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Start Approval False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Status_Approval</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Status Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Status_Return_to_Reviewer</fullName>
        <field>Status</field>
        <literalValue>Return to Specialist/Reviewer</literalValue>
        <name>Status Return to Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Status_Update_Approval</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Status Update Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Status_Update_Return_to_Reviewer</fullName>
        <field>Status</field>
        <literalValue>Return to Specialist/Reviewer</literalValue>
        <name>Status Update Return to Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Uncheck_Approval_status_field</fullName>
        <field>CLQ_Approved_by_Manager__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Approval status field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Uncheck_Approved_by_Manager_field</fullName>
        <field>CLQ_Approved_by_Manager__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Approved by Manager field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Update_Approver_Email</fullName>
        <description>Update User&apos;s Manager&apos;s Email address</description>
        <field>CLQ_Approver_s_Email__c</field>
        <formula>CLQ_Assigned_To__r.Manager.Email</formula>
        <name>CLQ - Update Approver Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Update_Assigned_to_Email_Case</fullName>
        <field>CLQ_Assigned_to_Email__c</field>
        <formula>CLQ_Assigned_To__r.Email</formula>
        <name>CLQ Update Assigned to Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Update_Status_Date</fullName>
        <description>Update Status Date</description>
        <field>CLQ_Status_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Status Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CLQ Center JFS Complaint Email Alert to Approver</fullName>
        <actions>
            <name>CLQ_Center_JFS_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>Child Care Center</value>
        </criteriaItems>
        <description>If it is a Center , the notification will be sent to the specific field office for ODJFS
Transaction Status = Submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLQ Check for Change of Status</fullName>
        <actions>
            <name>CLQ_Update_Status_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Status Date when status is changed</description>
        <formula>TEXT(PRIORVALUE(Status)) &lt;&gt; TEXT(Status)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CLQ JFS Complaint Email Alert to Approver</fullName>
        <actions>
            <name>CLQ_JFS_Complaint_Alert_to_Approver</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>Child Care Center</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Complaint</value>
        </criteriaItems>
        <description>JFS Complaint Email Alert to Approver for Case Status = Under Review and CC Center Program</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CLQ ODE Complaint Email Alert to Approver</fullName>
        <actions>
            <name>CLQ_ODE_Complaint_Email_Alert_to_Approver</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Under Review,Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>Pre School</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>School Age Child Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Complaint</value>
        </criteriaItems>
        <description>ODE Complaint Email Alert to Approver for Case Status = Under Review and Submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLQ Types JFS Complaint Email Alert to Approver</fullName>
        <actions>
            <name>CLQ_JFS_Notification_Email_Alert_for_type_A_and_B</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>FCC - Type A Home</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>FCC - Type B Home</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Complaint</value>
        </criteriaItems>
        <description>If it is a Center , the notification will be sent to the specific field office for ODJFS. Transaction Status = Submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLQ Update Approver Email</fullName>
        <actions>
            <name>CLQ_Update_Approver_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Rule to update User&apos;s Manager&apos;s Email address</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CLQ Update Assigned to Email on Case</fullName>
        <actions>
            <name>CLQ_Update_Assigned_to_Email_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Assigned to Email on Case</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CLQ_Complaint Submitted</fullName>
        <actions>
            <name>CLQ_Complaint_Submitted_RT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CLQ_Complaint_Submitted__c</field>
            <operation>equals</operation>
            <value>Complaint Submitted</value>
        </criteriaItems>
        <description>Change the record type to complaint submitted.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>CLQ_Review_Complaint_Approval</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Review Complaint Approval</subject>
    </tasks>
    <tasks>
        <fullName>CLQ_Revise_Complaint_Report</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Revise Complaint Report</subject>
    </tasks>
</Workflow>
