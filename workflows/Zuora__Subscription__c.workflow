<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_User_Email_on_Subscription</fullName>
        <field>Notification_Email__c</field>
        <formula>Zuora__Account__r.Notification_Email__c</formula>
        <name>Populate User Email on Subscription</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate User Email on Subscription</fullName>
        <actions>
            <name>Populate_User_Email_on_Subscription</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Zuora__Subscription__c.Zuora__Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>Workflow to populate user email on subscription object to send cancel subscription email to user.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SubscriptionFreeTrialEndDateStatus</fullName>
        <active>false</active>
        <formula>AND( NOT( ISNULL( Free_Trial_End_Date__c ) ), NOT( ISNULL( Gift_Code_End_Date__c ) ),  Zuora__Account__r.Submitted_for_cancellation__c = false )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Populate_User_Email_on_Subscription</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Zuora__Subscription__c.Free_Trial_End_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
