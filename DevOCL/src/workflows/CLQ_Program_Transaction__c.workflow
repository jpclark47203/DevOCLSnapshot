<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CLQ_Email_Alert_ODE_Initial_License_Application_Approved</fullName>
        <description>Email Alert - ODE Initial License Application Approved</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_ODE_Initial_License_Application_Approved_for_Provisional_License</template>
    </alerts>
    <alerts>
        <fullName>CLQ_Email_alert_JFS_License_Application_Approved</fullName>
        <description>Email alert - JFS License Application Approved</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_Initial_License_Application_Approved_for_Provisional_License</template>
    </alerts>
    <alerts>
        <fullName>CLQ_Email_alert_for_reviewer_to</fullName>
        <description>Email alert for reviewer to review the application</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_Internal_Email_Templates/CLQ_Application_ready_for_review</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_Application_Update_Submitted</fullName>
        <description>JFS - Application Update Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Program_s_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_ODJFS_Application_Update_Submitted</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_Application_Withdrawn</fullName>
        <description>JFS Application Withdrawn</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Program_s_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_Application_Withdrawn</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_Application_at_Risk_Email_Alert</fullName>
        <description>JFS Application at Risk Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_Application_is_at_Risk</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_Application_is_Closed</fullName>
        <description>JFS Application is Closed</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_Application_Closed</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_COA_Amendment_Request_Decision_Approved</fullName>
        <description>JFS - COA Amendment Request Decision Approved</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_COA_Amendment_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_COA_Amendment_Request_Decision_Denied</fullName>
        <description>JFS - COA Amendment Request Decision Denied</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_COA_Amendment_Request_Denied</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_COA_Amendment_Request_Decision_Submitted</fullName>
        <description>JFS - COA Amendment Request Decision Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_COA_Amendment_Request_Submitted</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_COA_Amendment_Request_Decision_Withdrawn</fullName>
        <description>JFS - COA Amendment Request Decision Withdrawn</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_COA_Amendment_Request_Withdrawn</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_COC_Amendment_Request_Decision_Approved</fullName>
        <description>JFS - COC Amendment Request Decision Approved</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_COC_Amendment_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_COC_Amendment_Request_Decision_Submitted</fullName>
        <description>JFS - COC Amendment Request Decision Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_COC_Amendment_Request_Submitted</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_COC_Amendment_Request_Decision_Withdrawn</fullName>
        <description>JFS - COC Amendment Request Decision Withdrawn</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_COC_Amendment_Request_Withdrawn</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_COL_Amendment_Request_Decision_Approved</fullName>
        <description>JFS - COL Amendment Request Decision Approved</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_COL_Request_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_COL_Amendment_Request_Decision_Submitted</fullName>
        <description>JFS - COL Amendment Request Decision Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_COL_Request_Request_Submitted</template>
    </alerts>
    <alerts>
        <fullName>CLQ_JFS_COL_Amendment_Request_Decision_Withdrawn</fullName>
        <description>JFS - COL Amendment Request Decision Withdrawn</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_JFS_COL_Request_Request_Withdrawn</template>
    </alerts>
    <alerts>
        <fullName>CLQ_ODE_Application_Update_Submitted</fullName>
        <description>ODE- Application Update Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Program_s_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_ODE_Application_Update_Submitted</template>
    </alerts>
    <alerts>
        <fullName>CLQ_ODE_Application_needs_Recommendation_at_risk</fullName>
        <description>ODE Application needs Recommendation (at risk)</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_ODE_Application_is_at_Risk</template>
    </alerts>
    <alerts>
        <fullName>CLQ_ODE_COC_Amendment_Request_Decision_Approved</fullName>
        <description>ODE - COC Amendment Request Decision Approved</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_ODE_COC_Amendment_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>CLQ_ODE_COC_Amendment_Request_Decision_Submitted</fullName>
        <description>ODE - COC Amendment Request Decision Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_ODE_COC_Amendment_Request_Submitted</template>
    </alerts>
    <alerts>
        <fullName>CLQ_ODE_COC_Amendment_Request_Decision_Withdrawn</fullName>
        <description>ODE - COC Amendment Request Decision Withdrawn</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_ODE_COC_Amendment_Request_Withdrawn</template>
    </alerts>
    <alerts>
        <fullName>CLQ_ODE_COL_Amendment_Request_Decision_Approved</fullName>
        <description>ODE - COL Amendment Request Decision Approved</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_ODE_COL_Request_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>CLQ_ODE_COL_Amendment_Request_Decision_Submitted</fullName>
        <description>ODE - COL Amendment Request Decision Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_ODE_COL_Request_Request_Submitted</template>
    </alerts>
    <alerts>
        <fullName>CLQ_ODE_COL_Amendment_Request_Decision_Withdrawn</fullName>
        <description>ODE - COL Amendment Request Decision Withdrawn</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_ODE_COL_Request_Request_Withdrawn</template>
    </alerts>
    <alerts>
        <fullName>CLQ_ODE_Notification_Amendment_Request_Decision_Approved</fullName>
        <description>ODE - Notification - Amendment Request Decision Approved</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_COA_Amendment_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>CLQ_ODE_Notification_Amendment_Request_Decision_Denied</fullName>
        <description>Notification - Amendment Request Decision Denied</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CLQ_Transaction_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_COA_Amendment_Request_Denied</template>
    </alerts>
    <alerts>
        <fullName>CLQ_ODS_Application_Withdrawn</fullName>
        <description>IDS Application Withdrawn</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Program_s_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_ODS_Application_Withdrawn</template>
    </alerts>
    <alerts>
        <fullName>CLQ_Program_Inactive_after_335_days_of_Creation</fullName>
        <description>Program Inactive after 335 days of Creation</description>
        <protected>false</protected>
        <recipients>
            <field>CLQ_Assigned_To_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CLQ_External_Email_Templates/CLQ_Program_Inactive_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>CLQ_Assign_to_Application_Unit_1_queue</fullName>
        <description>On Registration - Day Camp Transaction When Transaction Status = Submitted AND ACA Accredited Checkbox= True then Assign to &quot;Application Unit 1&quot; Queue.</description>
        <field>OwnerId</field>
        <lookupValue>CLQ_Application_Unit_1</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CLQ-Assign to Application Unit 1 queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Change_Status_To_Review_In_Progress</fullName>
        <field>CLQ_Transaction_Status__c</field>
        <literalValue>Review In Progress</literalValue>
        <name>Change Status to &quot;Review In Progress&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Flag_Rejected_By_Manager</fullName>
        <field>CLQ_Rejected_By_Manager__c</field>
        <literalValue>1</literalValue>
        <name>Flag &quot;Rejected By Manager&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Reset_Approved_by_Manager_Flag</fullName>
        <field>CLQ_Approved_by_Manager__c</field>
        <literalValue>0</literalValue>
        <name>Reset Approved by Manager Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Reset_Start_Approval</fullName>
        <field>CLQ_Start_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Reset Start Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Set_Approved_by_Manager_to_FALSE</fullName>
        <field>CLQ_Approved_by_Manager__c</field>
        <literalValue>0</literalValue>
        <name>Set &quot;Approved by Manager&quot; to FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Set_Approved_by_Manager_to_True</fullName>
        <field>CLQ_Approved_by_Manager__c</field>
        <literalValue>1</literalValue>
        <name>Set Approved by Manager to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Set_Trans_Status_To_Denied</fullName>
        <field>CLQ_Transaction_Status__c</field>
        <literalValue>Denied</literalValue>
        <name>Set Trans. Status To Denied</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Set_Trans_Status_To_Review_In_Prog</fullName>
        <field>CLQ_Transaction_Status__c</field>
        <literalValue>Review In Progress</literalValue>
        <name>Set Trans. Status To Review In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Set_Transaction_Status_To_Approved</fullName>
        <field>CLQ_Transaction_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set Transaction_Status_To_Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Transaction_Status_to_Review</fullName>
        <field>CLQ_Transaction_Status__c</field>
        <literalValue>Review In Progress</literalValue>
        <name>Transaction Status to Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_UnFlag_Rejected_By_Manager</fullName>
        <field>CLQ_Rejected_By_Manager__c</field>
        <literalValue>0</literalValue>
        <name>UnFlag Rejected By Manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Update_Assigned_To_Email</fullName>
        <field>CLQ_Assigned_To_Email__c</field>
        <formula>CLQ_Transaction_Assigned_To__r.Email</formula>
        <name>Update Assigned To Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Update_Closure_Status</fullName>
        <field>CLQ_Closure_Status__c</field>
        <literalValue>Pending Processing</literalValue>
        <name>Update Closure Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Update_Effective_Day_of_Closure</fullName>
        <field>CLQ_Effective_Date_of_Closure__c</field>
        <formula>CLQ_Last_Day_of_Operation__c</formula>
        <name>Update Effective Day of Closure</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Update_Effective_date_of_closure</fullName>
        <field>CLQ_Effective_Date_of_Closure__c</field>
        <formula>TODAY() +1</formula>
        <name>Update Effective date of closure</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Update_Program_s_Email_address</fullName>
        <field>CLQ_Program_s_Email__c</field>
        <formula>CLQ_Program__r.CLQ_Program_Email__c</formula>
        <name>Update Program&apos;s Email address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Update_Registration_Status</fullName>
        <field>CLQ_Registration_Status__c</field>
        <literalValue>Closed by System</literalValue>
        <name>Update Registration Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Update_Status_to_Approved_by_Manager</fullName>
        <description>Update Status to &quot;Approved&quot;</description>
        <field>CLQ_Transaction_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Status to &quot;Approved by Manager&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Update_Transaction</fullName>
        <field>CLQ_Transaction_Status__c</field>
        <literalValue>Closed at Applicant’s Request</literalValue>
        <name>CLQ Update Transaction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLQ_Update_Transaction_Status</fullName>
        <field>CLQ_Transaction_Status__c</field>
        <literalValue>Closed by System</literalValue>
        <name>Update Transaction Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Transaction_Status</fullName>
        <description>Change Transaction Status to &quot;Approver Review In Progress&quot;</description>
        <field>CLQ_Transaction_Status__c</field>
        <literalValue>Approver Review In Progress</literalValue>
        <name>Change Transaction Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateIsApproved</fullName>
        <description>As soon as program transaction - annual report gets approved</description>
        <field>IsApproved_PrgTran__c</field>
        <literalValue>1</literalValue>
        <name>UpdateIsApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CLQ - Licensing Closure Updates %3C%3D Today</fullName>
        <actions>
            <name>CLQ_Update_Effective_date_of_closure</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the Last Day of Operation is in a past date or today’s date, the Effective Date of Closure will display as (system date + 1 day)</description>
        <formula>CLQ_Last_Day_of_Operation__c   &lt;=   TODAY()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CLQ - Licensing Closure Updates %3E Today</fullName>
        <actions>
            <name>CLQ_Update_Effective_Day_of_Closure</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the Last Day of Operation is tomorrow or later, the Effective Date of Closure will display the same value as the Last Day of Operation.</description>
        <formula>CLQ_Last_Day_of_Operation__c  &gt;  TODAY()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CLQ Close Transactions if it is not submitted after 120 days</fullName>
        <active>true</active>
        <description>Close the Transactions if it has not been successfully submitted after 120 days (note: API is not the same)</description>
        <formula>OR(TEXT(CLQ_Registration_Status__c) = &quot;Not Submitted&quot;, TEXT(CLQ_Transaction_Status__c) = &quot;Not Submitted&quot;  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CLQ_Update_Registration_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CLQ_Program_Transaction__c.CreatedDate</offsetFromField>
            <timeLength>120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CLQ JFS Application at Risk</fullName>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND (3 OR 4 OR 5 OR 7 OR 8 OR 9) AND 6</booleanFilter>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Transaction_Status__c</field>
            <operation>notEqual</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Transaction_Status__c</field>
            <operation>notEqual</operation>
            <value>Denied</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>Child Care Center</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>FCC - Type A Home</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>FCC - Type B Home</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Application - CC Center,Application - FCC,Application - ODE Program,Registration - Day Camp,Registration - Out of State,Registration - In-Home Aid</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>Day Camp</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>In-Home Aide</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>Out of State Registration</value>
        </criteriaItems>
        <description>JFS Application a risk - 335 days of submission</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CLQ_JFS_Application_at_Risk_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CLQ_Program_Transaction__c.CLQ_Submission_Date__c</offsetFromField>
            <timeLength>335</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CLQ JFS Close the Application</fullName>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND (3 OR 4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Transaction_Status__c</field>
            <operation>notEqual</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Transaction_Status__c</field>
            <operation>notEqual</operation>
            <value>Denied</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>Child Care Center</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>FCC - Type A Home</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>FCC - Type B Home</value>
        </criteriaItems>
        <description>JFS Close the Application - 395 days after submission if it isn&apos;t approved or denied</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CLQ_JFS_Application_is_Closed</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>CLQ_Update_Transaction_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CLQ_Program_Transaction__c.CLQ_Submission_Date__c</offsetFromField>
            <timeLength>395</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CLQ ODE Application at Risk</fullName>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND (3 OR 4) AND 5</booleanFilter>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Transaction_Status__c</field>
            <operation>notEqual</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Transaction_Status__c</field>
            <operation>notEqual</operation>
            <value>Denied</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>School Age Child Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Program_Record_Type__c</field>
            <operation>equals</operation>
            <value>Pre School</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Application - ODE Program</value>
        </criteriaItems>
        <description>ODE Application a risk - 335 days of submission</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CLQ_ODE_Application_needs_Recommendation_at_risk</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CLQ_Program_Transaction__c.CLQ_Submission_Date__c</offsetFromField>
            <timeLength>335</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CLQ Temporary Closure of License Update fields</fullName>
        <actions>
            <name>CLQ_Update_Closure_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Closure_Type__c</field>
            <operation>equals</operation>
            <value>Temporary</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Program_Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <description>Update Closure Status to &apos;Pending processing&apos; if closure is Temporary</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLQ Transaction Status</fullName>
        <actions>
            <name>CLQ_Update_Transaction</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Recommendation__c</field>
            <operation>equals</operation>
            <value>Withdraw</value>
        </criteriaItems>
        <description>When the recommendation changes to withdraw, change the transaction status to &apos;Closed at Applicant&apos;s request&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLQ Update Assigned To Email</fullName>
        <actions>
            <name>CLQ_Update_Assigned_To_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Transaction_Assigned_To__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CLQ Update Transaction Status when Approved</fullName>
        <actions>
            <name>CLQ_Set_Transaction_Status_To_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Approved_by_Manager__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Recommendation__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Recommendation__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLQ Update Transaction Status when Denied</fullName>
        <actions>
            <name>CLQ_Set_Trans_Status_To_Denied</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Approved_by_Manager__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Recommendation__c</field>
            <operation>equals</operation>
            <value>Denied</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLQ-Rule to Update Program after 335 days of Inactive status</fullName>
        <active>true</active>
        <description>Notify the assigned internal user and the internal supervisor/approver when a program has been continuously inactive for 335 days</description>
        <formula>ISPICKVAL(CLQ_Closure_Status__c , &apos;Processed&apos;)  &amp;&amp;  ISPICKVAL(CLQ_Program__r.CLQ_Program_Status__c  , &apos;Inactive&apos;) &amp;&amp;  NOT(ISBLANK(CLQ_Transaction_Assigned_To__c  ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CLQ_Program_Inactive_after_335_days_of_Creation</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CLQ_Program_Transaction__c.CreatedDate</offsetFromField>
            <timeLength>335</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CLQ_JFS Application Update Submitted email</fullName>
        <actions>
            <name>CLQ_JFS_Application_Update_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Portal_Application_Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Application - CC Center,Application - FCC</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLQ_ODE Application Update Submitted email</fullName>
        <actions>
            <name>CLQ_ODE_Application_Update_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Portal_Application_Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Application - ODE Program</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLQ_Registration - Day Camp Transaction ACA True</fullName>
        <actions>
            <name>CLQ_Assign_to_Application_Unit_1_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_ACA_Accredited__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.CLQ_Transaction_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>CLQ_Program_Transaction__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Registration - Day Camp</value>
        </criteriaItems>
        <description>On Registration - Day Camp Transaction When Transaction Status = Submitted AND ACA Accredited Checkbox= True then Assign to &quot;Application Unit 1&quot; Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLQ_Update Program%27s Email address</fullName>
        <actions>
            <name>CLQ_Update_Program_s_Email_address</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update email address of the Program</description>
        <formula>NOT(ISBLANK(CLQ_Program__c)) &amp;&amp;  NOT( ISBLANK( CreatedDate ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification to the record owner</fullName>
        <actions>
            <name>Please_review_new_registration</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED (OwnerId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>CLQ_Transaction_Approved</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Transaction Approved</subject>
    </tasks>
    <tasks>
        <fullName>CLQ_Transaction_Rejected</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Transaction Rejected</subject>
    </tasks>
    <tasks>
        <fullName>Please_review_new_registration</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please review the new SUTQ registration you have been assigned</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Please review new registration</subject>
    </tasks>
    <tasks>
        <fullName>Revise_Annual_Report_Details</fullName>
        <assignedToType>owner</assignedToType>
        <description>Revise Annual Report Details</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Revise Annual Report Details</subject>
    </tasks>
    <tasks>
        <fullName>Revise_Desk_Review</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please revise desk review</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Revise Desk Review</subject>
    </tasks>
</Workflow>
