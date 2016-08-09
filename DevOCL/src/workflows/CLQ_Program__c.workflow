<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CLQ_Update_Program_Status</fullName>
        <field>CLQ_Program_Status__c</field>
        <literalValue>Closed by System</literalValue>
        <name>CLQ_Update Program Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Update_Registration_Status</fullName>
        <field>CLQ_Registration_Status__c</field>
        <literalValue>Not Registered</literalValue>
        <name>CLQ_Update Registration Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CLQ_Close Day Camp if it is not renewed</fullName>
        <actions>
            <name>CLQ_Update_Program_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLQ_Update_Registration_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Automatically close a day camp if it has not renewed 2 years after expiration date</description>
        <formula>NOT( ISNULL(CLQ_License_Expiration_Date__c) ) &amp;&amp; (YEAR(CLQ_License_Expiration_Date__c) =   YEAR(TODAY()) -2) &amp;&amp;  RecordType.Name  = &apos;Day Camp&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CLQ_Complete Continuous License Recommendation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>CLQ_Program__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Child Care Center,FCC - Type B Home,Pre School,School Age Child Care,FCC - Type A Home</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program__c.CLQ_License_Type__c</field>
            <operation>equals</operation>
            <value>Provisional</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program__c.CLQ_Continuous_License_Status__c</field>
            <operation>equals</operation>
            <value>Initiated</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>CLQ_Program__c.CLQ_Provisional_License_Expiration_Date__c</offsetFromField>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
