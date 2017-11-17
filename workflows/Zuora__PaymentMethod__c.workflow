<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_User_Email_On_PaymentMethod</fullName>
        <description>This field update populate user email address on payment method object on payment method change (new payment record creation)</description>
        <field>User_Email__c</field>
        <formula>Zuora__BillingAccount__r.Zuora__Account__r.PersonContact.Email</formula>
        <name>Populate User Email On PaymentMethod</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate_User_Email_On_PaymentMethod</fullName>
        <actions>
            <name>Populate_User_Email_On_PaymentMethod</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Zuora__PaymentMethod__c.Zuora__DefaultPaymentMethod__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This workflow rule is used to populate user email address on payment method object, this is required to send email to user on payment method change.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
