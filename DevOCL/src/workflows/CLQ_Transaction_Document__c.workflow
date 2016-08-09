<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CLQ_Transaction_Document_re_Submitted</fullName>
        <description>Transaction Document re-Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_User_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_Internal_Email_Templates/CLQ_Documents_Re_Submitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>CLQ_Set_Assigned_User_Email_on_Trans_Doc</fullName>
        <field>CLQ_Assigned_User_Email__c</field>
        <formula>CLQ_Assigned_to_email__c</formula>
        <name>Set Assigned User Email on Trans Doc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CLQ Update Assigned To Email</fullName>
        <actions>
            <name>CLQ_Set_Assigned_User_Email_on_Trans_Doc</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CLQ_Transaction_Document__c.CLQ_Assigned_to_email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
