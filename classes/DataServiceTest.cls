/*
    Description: This is the test class for the WSDL class DataService
*/
@isTest
public class DataServiceTest{
    
    @isTest
    public static void testDataService(){
        //intantiate the classes
        DataService.GetMailingListResponse_element obj1              = new DataService.GetMailingListResponse_element();   
        DataService.MailingListFilter obj2                           = new DataService.MailingListFilter();   
        DataService.CreateMailingListExtract_element obj3            = new DataService.CreateMailingListExtract_element();   
        DataService.GetClientTableColumnsResponse_element obj4       = new DataService.GetClientTableColumnsResponse_element();   
        DataService.GetMailingListFromAddressesResponse_element obj5 = new DataService.GetMailingListFromAddressesResponse_element();   
        DataService.DeleteMailingListFilter_element obj6             = new DataService.DeleteMailingListFilter_element();  
        DataService.ClientTableColumn obj7                           = new DataService.ClientTableColumn(); 
        DataService.DeleteMailingListFilterResponse_element obj8     = new DataService.DeleteMailingListFilterResponse_element(); 
        DataService.DataImportControl_element obj9                   = new DataService.DataImportControl_element(); 
        DataService.GetContactSubscriptionsResponse_element obj10    = new DataService.GetContactSubscriptionsResponse_element();  
         
        DataService.ArrayOfExtractColumn obj11                       = new DataService.ArrayOfExtractColumn(); 
        DataService.UpdateContactSubscription_element obj12          = new DataService.UpdateContactSubscription_element(); 
        DataService.DataImportResponseDetail obj13                   = new DataService.DataImportResponseDetail(); 
        DataService.GetMailingListFilterOperators_element obj14      = new DataService.GetMailingListFilterOperators_element();       
        DataService.ArrayOfMailingListAnalyticsProviderParameter obj15 = new DataService.ArrayOfMailingListAnalyticsProviderParameter(); 
        DataService.CreateTableExtractResponse_element obj16         = new  DataService.CreateTableExtractResponse_element();
        DataService.GetMailingListExtractResponse_element obj17      = new DataService.GetMailingListExtractResponse_element();
        DataService.ArrayOfClientDataTable obj18                     = new DataService.ArrayOfClientDataTable();
        DataService.ClientDataTable obj19                             = new DataService.ClientDataTable();
        DataService.Subscription obj20                                 = new DataService.Subscription();
        
        DataService.ColumnMapping obj21 = new DataService.ColumnMapping();
        DataService.UpdateContactSubscriptionResponse_element obj22         = new DataService.UpdateContactSubscriptionResponse_element();
        DataService.GetMailingListAnalyticsProviders_element obj23         = new DataService.GetMailingListAnalyticsProviders_element();        
        DataService.GetMailingListRelationships_element obj24             = new DataService.GetMailingListRelationships_element();
        DataService.GetContactDataResponse_element obj25                     = new DataService.GetContactDataResponse_element();
        DataService.GetClientTablesResponse_element obj26                     = new DataService.GetClientTablesResponse_element();
        DataService.ArrayOfMailingListFilter obj27                         = new DataService.ArrayOfMailingListFilter();
        DataService.GetClientTableRelationships_element obj28                 = new DataService.GetClientTableRelationships_element();
        DataService.GetClientTableRelationships_element obj29                 = new DataService.GetClientTableRelationships_element();
        DataService.GetMailingList_element obj30                             = new DataService.GetMailingList_element();
        
        DataService.GetMailingList_element obj31 = new DataService.GetMailingList_element();
        DataService.GetClientTables_element obj32 = new DataService.GetClientTables_element();
        DataService.DataImporter_element obj33 = new DataService.DataImporter_element();
        DataService.GetMailingListAnalyticsProvidersResponse_element obj34 = new DataService.GetMailingListAnalyticsProvidersResponse_element();
        DataService.ArrayOfColumnMapping obj35 = new DataService.ArrayOfColumnMapping();
        DataService.GetMailingListFiltersResponse_element obj36 = new DataService.GetMailingListFiltersResponse_element();        
        DataService.CreateTableExtract_element obj37 = new DataService.CreateTableExtract_element();
        DataService.GetMailingLists_element obj38 = new DataService.GetMailingLists_element();
        DataService.GetClientTable_element obj39 = new DataService.GetClientTable_element();
        DataService.GetTableExtract_element obj40 = new DataService.GetTableExtract_element();
        
        DataService.DataImportSubscription obj41 = new DataService.DataImportSubscription();
        DataService.MailingList obj42 = new DataService.MailingList();
        DataService.ArrayOfMailingListAnalyticsProvider obj43 = new DataService.ArrayOfMailingListAnalyticsProvider();        
        DataService.TopLevelDetailItem obj44 = new DataService.TopLevelDetailItem();
        DataService.GetContactSubscriptions_element obj45 = new DataService.GetContactSubscriptions_element();
        DataService.GetClientTableRelationshipsResponse_element obj46 = new DataService.GetClientTableRelationshipsResponse_element();
        DataService.GetClientTableColumns_element obj47 = new DataService.GetClientTableColumns_element();
        DataService.FromAddress obj48 = new DataService.FromAddress();
        DataService.DataImporterViaFTPResponse_element obj49 = new DataService.DataImporterViaFTPResponse_element();        
        DataService.OperatorInfo obj50 = new DataService.OperatorInfo();
        
        DataService.GetMailingListColumnsResponse_element obj51 = new DataService.GetMailingListColumnsResponse_element();
        DataService.GetDataImportResponse_element obj52 = new DataService.GetDataImportResponse_element();
        DataService.CreateMailingListFilterResponse_element obj53 = new DataService.CreateMailingListFilterResponse_element();
        DataService.GetMailingListColumns_element obj54 = new DataService.GetMailingListColumns_element();
        DataService.CreateMailingListFilter_element obj55 = new DataService.CreateMailingListFilter_element();
        DataService.GetDataImport_element obj56 = new DataService.GetDataImport_element();
        DataService.GetClientTableResponse_element obj57 = new DataService.GetClientTableResponse_element();
        DataService.ArrayOfTopLevelDetailItem obj58 = new DataService.ArrayOfTopLevelDetailItem();
        DataService.DataImport obj59 = new DataService.DataImport();
        DataService.GetMailingListsForClientTable_element obj60 = new DataService.GetMailingListsForClientTable_element();
        
        DataService.CreateMailingList_element obj61 = new DataService.CreateMailingList_element();
        DataService.TableDataExtract obj62 = new DataService.TableDataExtract();
        DataService.UpdateMailingListFilter_element obj63 = new DataService.UpdateMailingListFilter_element();
        DataService.MailingListAnalyticsProvider obj64 = new DataService.MailingListAnalyticsProvider();
        DataService.ArrayOfDataImportResponseDetail obj65 = new DataService.ArrayOfDataImportResponseDetail();
        DataService.ArrayOfMailingList obj66 = new DataService.ArrayOfMailingList();
        DataService.SubscriptionInfo obj67 = new DataService.SubscriptionInfo();
        DataService.GetMailingListsResponse_element obj68 = new DataService.GetMailingListsResponse_element();
        DataService.ArrayOfClientTable obj69 = new DataService.ArrayOfClientTable();
        DataService.ArrayOfSubscription obj70 = new DataService.ArrayOfSubscription();
        
        DataService.CreateMailingListExtractResponse_element obj71 = new DataService.CreateMailingListExtractResponse_element();
        DataService.CommunicatorCredentials obj72 = new DataService.CommunicatorCredentials();
        DataService.DataImportControlResponse_element obj73 = new DataService.DataImportControlResponse_element();
        DataService.GetRelationships_element obj74 = new DataService.GetRelationships_element();
        DataService.DataImportResponseTopLevel obj75 = new DataService.DataImportResponseTopLevel();
        DataService.UpdateContactSubscriptions_element obj76 = new DataService.UpdateContactSubscriptions_element();
        DataService.ArrayOfSubscriptionInfo obj77 = new DataService.ArrayOfSubscriptionInfo();
        DataService.ArrayOfTriggeredDispatch obj78 = new DataService.ArrayOfTriggeredDispatch();
        DataService.DataImportBase obj79 = new DataService.DataImportBase();
        DataService.GetMailingListCount_element obj80 = new DataService.GetMailingListCount_element();
        
        DataService.GetMailingListFilters_element obj81 = new DataService.GetMailingListFilters_element();
        DataService.ArrayOfMailingListFilterItem obj82 = new DataService.ArrayOfMailingListFilterItem();
        DataService.UpdateMailingList_element obj83 = new DataService.UpdateMailingList_element();
        DataService.GetMailingListsForClientTableResponse_element obj84 = new DataService.GetMailingListsForClientTableResponse_element();
        DataService.ArrayOfFromAddress obj85 = new DataService.ArrayOfFromAddress();
        DataService.GetContactSubscription_element obj86 = new DataService.GetContactSubscription_element();
        DataService.ArrayOfClientTableRelationship obj87 = new DataService.ArrayOfClientTableRelationship();
        DataService.CreateMailingListResponse_element obj88 = new DataService.CreateMailingListResponse_element();
        DataService.ArrayOfDataRecord obj89 = new DataService.ArrayOfDataRecord();
        DataService.GetMailingListFilterCount_element obj90 = new DataService.GetMailingListFilterCount_element();
        
        DataService.FTPDataImport obj91 = new DataService.FTPDataImport();
        DataService.DataImporterResponse_element obj92 = new DataService.DataImporterResponse_element();
        DataService.GetRelationshipsResponse_element obj93 = new DataService.GetRelationshipsResponse_element();
        DataService.ClientTableRelationship obj94 = new DataService.ClientTableRelationship();
        DataService.UpdateMailingListResponse_element obj95 = new DataService.UpdateMailingListResponse_element();
        DataService.GetClientTablesForMailingList_element obj96 = new DataService.GetClientTablesForMailingList_element();
        DataService.ClientTable obj97 = new DataService.ClientTable();
        DataService.TriggeredDispatch obj98 = new DataService.TriggeredDispatch();
        DataService.ArrayOfOperatorInfo obj99 = new DataService.ArrayOfOperatorInfo();
        DataService.GetMailingListCountResponse_element obj100 = new DataService.GetMailingListCountResponse_element();
        
        DataService.GetMailingListFilterOperatorsResponse_element cls1 = new DataService.GetMailingListFilterOperatorsResponse_element();
        DataService.MailingListExtract cls2 = new DataService.MailingListExtract();
        DataService.Control cls3 = new DataService.Control();
        DataService.MailingListFilterItem cls4 = new DataService.MailingListFilterItem();
        DataService.ExtractBase cls5 = new DataService.ExtractBase();
        DataService.DataRecord cls6 = new DataService.DataRecord();
        DataService.ArrayOfDataImportSubscription cls7 = new DataService.ArrayOfDataImportSubscription();
        DataService.DataImporterViaFTP_element cls8 = new DataService.DataImporterViaFTP_element();
        DataService.GetMailingListFilter_element cls9 = new DataService.GetMailingListFilter_element();
        DataService.GetMailingListRelationshipsResponse_element cls10 = new DataService.GetMailingListRelationshipsResponse_element();
        
        DataService.ArrayOfClientTableColumn cls11 = new DataService.ArrayOfClientTableColumn();
        DataService.UpdateContactSubscriptionsResponse_element cls12 = new DataService.UpdateContactSubscriptionsResponse_element();
        DataService.GetContactData_element cls13 = new DataService.GetContactData_element();
        DataService.MailingListAnalyticsProviderParameter cls14 = new DataService.MailingListAnalyticsProviderParameter();
        DataService.GetMailingListFilterResponse_element cls15 = new DataService.GetMailingListFilterResponse_element();
        DataService.ExtractColumn cls16 = new DataService.ExtractColumn();
        DataService.GetClientTablesForMailingListResponse_element cls17 = new DataService.GetClientTablesForMailingListResponse_element();
        DataService.UpdateMailingListFilterResponse_element cls18 = new DataService.UpdateMailingListFilterResponse_element();
        DataService.ArrayOfString cls19 = new DataService.ArrayOfString();
        DataService.GetMailingListExtract_element cls20 = new DataService.GetMailingListExtract_element();
        
        DataService.GetContactSubscriptionResponse_element cls21 = new DataService.GetContactSubscriptionResponse_element();
        DataService.DataImportResponse cls22 = new DataService.DataImportResponse();
        DataService.GetMailingListFromAddresses_element cls23 = new DataService.GetMailingListFromAddresses_element();
        DataService.GetMailingListFilterCountResponse_element cls24 = new DataService.GetMailingListFilterCountResponse_element();
        DataService.GetTableExtractResponse_element cls25 = new DataService.GetTableExtractResponse_element();
        DataService.DataServiceSoap cls26 = new DataService.DataServiceSoap();
    }
}