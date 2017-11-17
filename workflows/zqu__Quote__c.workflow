<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>zqu__UpdateSubTermDefault</fullName>
        <field>zqu__Subscription_Term_Type__c</field>
        <literalValue>Termed</literalValue>
        <name>UpdateSubTermDefault</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>zqu__ZQUpdateTermData_AutoRenew</fullName>
        <field>zqu__AutoRenew__c</field>
        <literalValue>0</literalValue>
        <name>ZQUpdateTermData_AutoRenew</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>zqu__ZQUpdateTermData_InitialTerm</fullName>
        <field>zqu__InitialTerm__c</field>
        <formula>0</formula>
        <name>ZQUpdateTermData_InitialTerm</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>zqu__ZQUpdateTermData_RenewalTerm</fullName>
        <field>zqu__RenewalTerm__c</field>
        <formula>0</formula>
        <name>ZQUpdateTermData_RenewalTerm</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>zqu__ZQSubTermTypeAction</fullName>
        <actions>
            <name>zqu__ZQUpdateTermData_AutoRenew</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>zqu__ZQUpdateTermData_InitialTerm</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>zqu__ZQUpdateTermData_RenewalTerm</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>zqu__Quote__c.zqu__Subscription_Term_Type__c</field>
            <operation>equals</operation>
            <value>Evergreen</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zqu__ZQSubTermTypeDefaultAction</fullName>
        <actions>
            <name>zqu__UpdateSubTermDefault</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>zqu__Quote__c.zqu__Subscription_Term_Type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update the Subscription Term Type to Termed, if it is left blank.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
