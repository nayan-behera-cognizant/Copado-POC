<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Update Account Viewer Id Field</fullName>
        <active>false</active>
        <description>Update Account Viewer Id Field</description>
        <formula>Contact.Account.Notification_Country_Code__c  = &apos;CA&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
