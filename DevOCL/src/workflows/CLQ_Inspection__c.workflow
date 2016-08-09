<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CLQ_DayCamp_Audit_Email_Alert</fullName>
        <description>Day Camp Audit Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Program_s_Licensing_Specialist__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_Day_Camp_Audit_Email</template>
    </alerts>
    <alerts>
        <fullName>CLQ_Email_alert_to_owner_if_the_inspection_is_deleted</fullName>
        <description>Email alert to owner if the inspection is deleted</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Inspection_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_Internal_Email_Templates/CLQ_Inspection_Deleted</template>
    </alerts>
    <fieldUpdates>
        <fullName>CLQ_Inspection_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CLQ_Day_Camp_Audit</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CLQ_Inspection Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Program_s_Email</fullName>
        <field>CLQ_Program_s_Email_Address__c</field>
        <formula>CLQ_Program__r.CLQ_Program_Email__c</formula>
        <name>Update Program&apos;s Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Update_Licensing_Specialist</fullName>
        <field>CLQ_Program_s_Licensing_Specialist__c</field>
        <formula>CLQ_Program__r.CLQ_Licensing_Specialist__r.Email</formula>
        <name>Update Licensing Specialist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApproved</fullName>
        <field>IsApproved__c</field>
        <literalValue>1</literalValue>
        <name>UpdateApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CLQ Update Inspection Fields</fullName>
        <actions>
            <name>CLQ_Program_s_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLQ_Update_Licensing_Specialist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CLQ_Inspection__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CLQ_Update Inspection Record Type to Day Camp Audit</fullName>
        <actions>
            <name>CLQ_Inspection_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>CLQ_Program__r.CLQ_Create_Day_Camp_Audit__c = true &amp;&amp;  CLQ_Program__r.RecordType.Name = &apos;Day Camp&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Review_Onsite_Visit_Details</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please revise onsite visit information</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Review Onsite Visit Details</subject>
    </tasks>
</Workflow>
