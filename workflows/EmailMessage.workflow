<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Email_Message_Status</fullName>
        <field>Emails_Sent__c</field>
        <formula>IF(ISBLANK( Parent.Emails_Sent__c ), 1, Parent.Emails_Sent__c +1)</formula>
        <name>Email Message Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Number_of_Messages_Received</fullName>
        <field>Emails_Received__c</field>
        <formula>IF(ISBLANK( Parent.Emails_Received__c ), 1, Parent.Emails_Received__c +1)</formula>
        <name>Number of Messages Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Put_case_back_to_in_progress</fullName>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>Put case back to in progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Put_case_back_to_waiting_for_support</fullName>
        <field>Status</field>
        <literalValue>Waiting for Support</literalValue>
        <name>Put case back to in waiting_for_support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CaseFirstResponse_From_EmailMsg</fullName>
        <field>Case_First_Response_Time__c</field>
        <formula>Now()</formula>
        <name>Update CaseFirstResponse From EmailMsg</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_status_in_progress</fullName>
        <field>Status</field>
        <literalValue>Waiting for Customer</literalValue>
        <name>Update Case status in progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_Waiting_for_Customer</fullName>
        <field>Status</field>
        <literalValue>Waiting for Customer</literalValue>
        <name>Update status to Waiting for Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Agent replies to Case - auto change in status</fullName>
        <actions>
            <name>Update_status_to_Waiting_for_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Customer replies to Case - auto change in status</fullName>
        <actions>
            <name>Put_case_back_to_waiting_for_support</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed,Resolved,Waiting for Customer,Escalated,On-Hold</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Emails Sent</fullName>
        <actions>
            <name>Email_Message_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Emails received</fullName>
        <actions>
            <name>Number_of_Messages_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pouplate Case Response time From EmailMessage</fullName>
        <actions>
            <name>Update_CaseFirstResponse_From_EmailMsg</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISBLANK(Parent.Case_First_Response_Time__c)  ||  ISNULL(Parent.Case_First_Response_Time__c)) &amp;&amp; ISPICKVAL(Parent.Status ,&apos;In Progress&apos;) &amp;&amp; (FromName  =  Parent.Owner:User.FirstName  &amp; &quot; &quot;  &amp;  Parent.Owner:User.LastName )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
