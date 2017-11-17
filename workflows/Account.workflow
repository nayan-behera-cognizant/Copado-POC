<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_to_Anonymised_user_AT_DE</fullName>
        <description>Send Email to Anonymised user -AT-DE</description>
        <protected>false</protected>
        <recipients>
            <field>Cached_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dazn.support@performgroup.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AT_Templates/Anonymise_User_Notification_AT_DE</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Anonymised_user_AT_EN</fullName>
        <description>Send Email to Anonymised user -AT-EN</description>
        <protected>false</protected>
        <recipients>
            <field>Cached_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dazn.support@performgroup.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AT_Templates/Anonymise_User_Notification_AT_EN</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Anonymised_user_CA_EN</fullName>
        <description>Send Email to Anonymised user -CA-EN</description>
        <protected>false</protected>
        <recipients>
            <field>Cached_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dazn.support@performgroup.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CA_Templates/Anonymise_User_Notification_CA_EN</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Anonymised_user_CA_FR</fullName>
        <description>Send Email to Anonymised user -CA-FR</description>
        <protected>false</protected>
        <recipients>
            <field>Cached_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dazn.support@performgroup.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CA_Templates/Anonymise_User_Notification_CA_FR</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Anonymised_user_CH_DE</fullName>
        <description>Send Email to Anonymised user -CH-DE</description>
        <protected>false</protected>
        <recipients>
            <field>Cached_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dazn.support@performgroup.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CH_Templates/Anonymise_User_Notification_CH_DE</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Anonymised_user_CH_EN</fullName>
        <description>Send Email to Anonymised user -CH-EN</description>
        <protected>false</protected>
        <recipients>
            <field>Cached_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dazn.support@performgroup.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CH_Templates/Anonymise_User_Notification_CH_EN</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Anonymised_user_DE_DE</fullName>
        <description>Send Email to Anonymised user -DE-DE</description>
        <protected>false</protected>
        <recipients>
            <field>Cached_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dazn.support@performgroup.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DE_Templates/Anonymise_User_Notification_DE_DE</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Anonymised_user_DE_EN</fullName>
        <description>Send Email to Anonymised user -DE-EN</description>
        <protected>false</protected>
        <recipients>
            <field>Cached_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dazn.support@performgroup.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DE_Templates/Anonymise_User_Notification_DE_EN</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Anonymised_user_JP_EN</fullName>
        <description>Send Email to Anonymised user -JP-EN</description>
        <protected>false</protected>
        <recipients>
            <field>Cached_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dazn.support@performgroup.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>JP_Templates/Anonymise_User_Notification_JP_EN</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Anonymised_user_JP_JA</fullName>
        <description>Send Email to Anonymised user -JP-JA</description>
        <protected>false</protected>
        <recipients>
            <field>Cached_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dazn.support@performgroup.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>JP_Templates/Anonymise_User_Notification_JP_JA</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Status_Change_Executor</fullName>
        <field>Account_Status__c</field>
        <literalValue>Active Paid</literalValue>
        <name>Account Status Change Executor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Block_User_Button_Update_based_on_Status</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PersonAccount</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Block User Button Update based on Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Block_User_Button_Update_basedonParentID</fullName>
        <field>RecordTypeId</field>
        <lookupValue>DFD_Customer</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Block User Button Update basedonParentID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Block_User_Update_on_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Person_Account_For_Unblock</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Block User Update on RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Disabell_all_transactional_emails</fullName>
        <field>Disable_all_transactional_emails__c</field>
        <literalValue>1</literalValue>
        <name>Disabell all transactional emails</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetActivePaidStatus</fullName>
        <field>Account_Status__c</field>
        <literalValue>Active Paid</literalValue>
        <name>SetActivePaidStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetPause</fullName>
        <field>Account_Status__c</field>
        <literalValue>Paused</literalValue>
        <name>SetPause</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetPauseFromToNull</fullName>
        <field>Pause_From__c</field>
        <name>SetPauseFromToNull</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetPauseUntilToNull</fullName>
        <field>Pause_Until__c</field>
        <name>SetPauseUntilToNull</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AccountFreeTrialEndDateStatus</fullName>
        <active>false</active>
        <formula>AND(     NOT( ISNULL( Free_Trial_End_Date__c ) ),     NOT( ISNULL( Gift_Code_End_Date__c ) ),     Submitted_for_cancellation__c = false )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SetActivePaidStatus</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Free_Trial_End_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AccountSetPauseStatus</fullName>
        <active>true</active>
        <formula>IF(  ISNULL( Pause_Scheduled_Time__c ),  false,  ( Pause_Scheduled_Time__c &gt; NOW() )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SetPause</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Pause_Scheduled_Time__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Anonymise User Notification -AT-DE</fullName>
        <actions>
            <name>Send_Email_to_Anonymised_user_AT_DE</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>equals</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Language_Code__c</field>
            <operation>equals</operation>
            <value>de</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Country_Code__c</field>
            <operation>equals</operation>
            <value>AT</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Anonymise User Notification -AT-EN</fullName>
        <actions>
            <name>Send_Email_to_Anonymised_user_AT_EN</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>equals</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Language_Code__c</field>
            <operation>contains</operation>
            <value>en</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Country_Code__c</field>
            <operation>equals</operation>
            <value>AT</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Anonymise User Notification -CA-EN</fullName>
        <actions>
            <name>Send_Email_to_Anonymised_user_CA_EN</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>equals</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Language_Code__c</field>
            <operation>contains</operation>
            <value>en</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Country_Code__c</field>
            <operation>equals</operation>
            <value>CA</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Anonymise User Notification -CA-FR</fullName>
        <actions>
            <name>Send_Email_to_Anonymised_user_CA_FR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>equals</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Language_Code__c</field>
            <operation>equals</operation>
            <value>fr</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Country_Code__c</field>
            <operation>equals</operation>
            <value>CA</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Anonymise User Notification -CH-DE</fullName>
        <actions>
            <name>Send_Email_to_Anonymised_user_CH_DE</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>equals</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Language_Code__c</field>
            <operation>equals</operation>
            <value>de</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Country_Code__c</field>
            <operation>equals</operation>
            <value>CH</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Anonymise User Notification -CH-EN</fullName>
        <actions>
            <name>Send_Email_to_Anonymised_user_CH_EN</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>equals</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Language_Code__c</field>
            <operation>contains</operation>
            <value>en</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Country_Code__c</field>
            <operation>equals</operation>
            <value>CH</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Anonymise User Notification -DE-DE</fullName>
        <actions>
            <name>Send_Email_to_Anonymised_user_DE_DE</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>equals</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Language_Code__c</field>
            <operation>equals</operation>
            <value>de</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Country_Code__c</field>
            <operation>equals</operation>
            <value>DE</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Anonymise User Notification -DE-EN</fullName>
        <actions>
            <name>Send_Email_to_Anonymised_user_DE_EN</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>equals</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Language_Code__c</field>
            <operation>contains</operation>
            <value>en</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Country_Code__c</field>
            <operation>equals</operation>
            <value>DE</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Anonymise User Notification -JP-EN</fullName>
        <actions>
            <name>Send_Email_to_Anonymised_user_JP_EN</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>equals</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Language_Code__c</field>
            <operation>contains</operation>
            <value>en</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Country_Code__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Anonymise User Notification -JP-JA</fullName>
        <actions>
            <name>Send_Email_to_Anonymised_user_JP_JA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>equals</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Language_Code__c</field>
            <operation>equals</operation>
            <value>ja</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Notification_Country_Code__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Block User Button Update Block to Unblock</fullName>
        <actions>
            <name>Block_User_Update_on_RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>equals</operation>
            <value>Blocked</value>
        </criteriaItems>
        <description>This will Update the Button from Block to UnBlock</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Block User Button Update based on Status</fullName>
        <actions>
            <name>Block_User_Button_Update_based_on_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>notEqual</operation>
            <value>Blocked</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>notEqual</operation>
            <value>Frozen</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Partner_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Block User Button Update based on Status and ParentId</fullName>
        <actions>
            <name>Block_User_Button_Update_basedonParentID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>notEqual</operation>
            <value>Blocked</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>notEqual</operation>
            <value>Frozen</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Partner_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SetAccountActiveStatusOnPauseUntilDate</fullName>
        <active>true</active>
        <formula>ISPICKVAL(Account_Status__c, &apos;Paused&apos;) &amp;&amp; Pause_Until__c &gt; TODAY()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SetActivePaidStatus</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>SetPauseFromToNull</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>SetPauseUntilToNull</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Pause_Until__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SetAccountActiveStatusOnPauseUntilDateNull</fullName>
        <actions>
            <name>SetActivePaidStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SetPauseFromToNull</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SetPauseUntilToNull</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Account_Status__c, &apos;Paused&apos;) &amp;&amp; IF(ISNULL( Pause_Until__c), true, Pause_Until__c &lt;= TODAY())</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Disable all transactional emails</fullName>
        <actions>
            <name>Disabell_all_transactional_emails</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Docomo</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>