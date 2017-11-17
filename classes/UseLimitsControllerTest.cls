@isTest
public with sharing class UseLimitsControllerTest {
	public class MockSetLimitResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '{ "ConcurrentAsyncGetReportInstances" : { "Max" : 200, "Remaining" : 200 }, "ConcurrentSyncReportRuns" : { "Max" : 20, "Remaining" : 20 }, "DailyApiRequests" : { "Max" : 15000, "Remaining" : 14998 }, "DailyAsyncApexExecutions" : { "Max" : 250000, "Remaining" : 250000 }, "DailyBulkApiRequests" : { "Max" : 5000, "Remaining" : 5000 }, "DailyDurableGenericStreamingApiEvents" : { "Max" : 10000, "Remaining" : 10000 }, "DailyDurableStreamingApiEvents" : { "Max" : 10000, "Remaining" : 10000 }, "DailyGenericStreamingApiEvents" : { "Max" : 10000, "Remaining" : 10000 }, "DailyStreamingApiEvents" : { "Max" : 10000, "Remaining" : 10000 }, "DailyWorkflowEmails" : { "Max" : 390, "Remaining" : 390 }, "DataStorageMB" : { "Max" : 5, "Remaining" : 5 }, "DurableStreamingApiConcurrentClients" : { "Max" : 20, "Remaining" : 20 }, "FileStorageMB" : { "Max" : 20, "Remaining" : 20 }, "HourlyAsyncReportRuns" : { "Max" : 1200, "Remaining" : 1200 }, "HourlyDashboardRefreshes" : { "Max" : 200, "Remaining" : 200 }, "HourlyDashboardResults" : { "Max" : 5000, "Remaining" : 5000 }, "HourlyDashboardStatuses" : { "Max" : 999999999, "Remaining" : 999999999 }, "HourlyODataCallout" : { "Remaining" : 9999, "Max" : 10000 }, "HourlySyncReportRuns" : { "Max" : 500, "Remaining" : 500 }, "HourlyTimeBasedWorkflow" : { "Max" : 50, "Remaining" : 50 }, "MassEmail" : { "Max" : 10, "Remaining" : 10 }, "SingleEmail" : { "Max" : 15, "Remaining" : 15 }, "StreamingApiConcurrentClients" : { "Max" : 20, "Remaining" : 20 }}'
            );
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testExecute() {
        insert new DAZNConfiguration__c(
            Name = 'useLimitsSF',
            Value__c = 'https://cs81.salesforce.com/services/data/v37.0/limits/'
        );
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSetLimitResponse());
        UseLimitsController ctr = new UseLimitsController();
        ctr.execute();
        Test.stopTest();
    }
}