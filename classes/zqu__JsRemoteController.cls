/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class JsRemoteController {
    global JsRemoteController(zqu.CreateQuoteCompController ctrl) {

    }
    global JsRemoteController(zqu.GuidedProductSelectorConfigController ctrl) {

    }
    global JsRemoteController(zqu.QuickListController ctrl) {

    }
    global JsRemoteController(zqu.QuoteDetailController ctrl) {

    }
    global JsRemoteController(zqu.ResourceJSController ctrl) {

    }
    global JsRemoteController(zqu.SelectBillingAccountController ctrl) {

    }
    global JsRemoteController(zqu.SelectProductController ctrl) {

    }
    @RemoteAction
    global static zqu.JsRemoteController.SObjectCollection addStepsToFlow(List<String> stepIds, String flowId) {
        return null;
    }
    @RemoteAction
    global static zqu.JsRemoteController.JsRemoteResponse deleteGuidedSellingFlow(String flowId) {
        return null;
    }
    @RemoteAction
    global static zqu.JsRemoteController.JsRemoteResponse deleteGuidedSellingStep(String guidedSellingStepJson, Boolean hardDelete) {
        return null;
    }
    @RemoteAction
    global static zqu.JsRemoteController.SObjectCollection getAvailableSteps(String flowId) {
        return null;
    }
    @RemoteAction
    global static zqu.JsRemoteController.ListData getBillingAccounts(String accountSfdcId) {
        return null;
    }
    @ReadOnly
    @RemoteAction
    global static zqu.JsRemoteController.ColumnRefsData getQuickListColumnRefs(String listName) {
        return null;
    }
    @ReadOnly
    @RemoteAction
    global static zqu.JsRemoteController.ObjectListData getQuickListObjectData(String listName, Map<Object,Object> contextIds, String relationshipFieldName, List<Map<String,Object>> request, Map<String,List<String>> fragments) {
        return null;
    }
    @ReadOnly
    @RemoteAction
    global static zqu.JsRemoteController.ListData getQuickListRecords(String listName, Map<Object,Object> contextIds, String relationshipFieldName, Map<String,List<String>> soqlFragments) {
        return null;
    }
    @RemoteAction
    global static zqu.JsRemoteController.ListData getSfdcObjects(String metadataSourceName, Map<String,String> metadataParams, String dataSourceName, Map<String,String> dataSourceParams) {
        return null;
    }
    @RemoteAction
    global static zqu.JsRemoteController.ListData getSubscriptionCharges(String subscriptionId) {
        return null;
    }
    @RemoteAction
    global static zqu.JsRemoteController.ListData getSubscriptions(String selectedAccountId, String selectedSubscriptionType) {
        return null;
    }
    @RemoteAction
    global static String recalculateTermEndDate(String termStartDateString, String initialTermString) {
        return null;
    }
    @RemoteAction
    global static zqu.RatePlanComponentRemoter.UpdateResult updateDiscountCharge(Id chargeId, Decimal effectivePrice, Integer upToPeriods, String level) {
        return null;
    }
    @RemoteAction
    global static zqu.JsRemoteController.JsRemoteResponse upsertGuidedSellingFlow(String flowId, String flowName, Boolean includeInProductSelector) {
        return null;
    }
global class ColumnRefsData extends zqu.JsRemoteController.JsRemoteResponse {
    global List<zqu.JsRemoteController.ListColumnMetadata> columnDefs {
        get;
        set;
    }
    global ColumnRefsData() {

    }
}
global virtual class FieldMetadata {
    global String fieldType {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global String styleCls {
        get;
        set;
    }
    global String title {
        get;
        set;
    }
    global String width {
        get;
        set;
    }
    global FieldMetadata(String name, String title, Schema.DisplayType fieldType) {

    }
    global FieldMetadata(String name, String title, String fieldType) {

    }
    global virtual Boolean equals(Object obj) {
        return null;
    }
    global virtual Integer hashCode() {
        return null;
    }
}
global virtual class JsRemoteResponse {
    global String message {
        get;
        set;
    }
    global Boolean success {
        get;
        set;
    }
    global JsRemoteResponse() {

    }
}
global class ListColumnMetadata extends zqu.JsRemoteController.FieldMetadata {
    global Boolean bSortable {
        get;
        set;
    }
    global Boolean bVisible {
        get;
        set;
    }
    global String dbFieldType {
        get;
        set;
    }
    global Integer sorder {
        get;
        set;
    }
    global String sortType {
        get;
        set;
    }
    global ListColumnMetadata(String name, String title, Schema.DisplayType fieldType, Integer sorder) {

    }
    global ListColumnMetadata(String name, String title, String fieldType, Integer sorder) {

    }
    global ListColumnMetadata(String name, String title, Schema.DisplayType fieldType, Integer sorder, Boolean bVisible) {

    }
    global ListColumnMetadata(String name, String title, String fieldType, Integer sorder, Boolean bVisible) {

    }
    global override Boolean equals(Object obj) {
        return null;
    }
    global override Integer hashCode() {
        return null;
    }
}
global class ListData extends zqu.JsRemoteController.JsRemoteResponse {
    global List<zqu.JsRemoteController.ListColumnMetadata> columnDefs {
        get;
        set;
    }
    global List<Map<String,Object>> dataObjects {
        get;
        set;
    }
    global ListData() {

    }
}
global class ObjectListData extends zqu.JsRemoteController.JsRemoteResponse {
    global List<zqu.JsRemoteController.ListColumnMetadata> columnDefs {
        get;
        set;
    }
    global List<Map<String,Object>> dataObjects {
        get;
        set;
    }
    global Integer iTotalDisplayRecords {
        get;
        set;
    }
    global Integer iTotalRecords {
        get;
        set;
    }
    global Integer sEcho {
        get;
        set;
    }
    global ObjectListData() {

    }
}
global class SObjectCollection extends zqu.JsRemoteController.JsRemoteResponse {
    global List<SObject> sObjects {
        get;
        set;
    }
    global SObjectCollection() {

    }
}
}
