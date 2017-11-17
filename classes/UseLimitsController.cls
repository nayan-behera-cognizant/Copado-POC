public with sharing class UseLimitsController {
	
	public Datetime lastRefresh 									{ get; set; }
	public List<Info> inf 											{ get; set; }
	public LimitsInfo info;
	
	public void execute() {

		String endpointUrl = (DAZNConfiguration__c.getValues('useLimitsSF') != null) ? DAZNConfiguration__c.getValues('useLimitsSF').Value__c : null;
		if (endpointUrl.length() > 1) {
			HttpRequest request = new HttpRequest();
			request.setEndpoint(endpointUrl);
			request.setMethod('GET');
			request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
			Http http = new Http();
			HttpResponse response = http.send(request);
			if (response.getStatusCode() == 200) {
				LimitsInfo setPauseSuccessResponse = (LimitsInfo)JSON.deserialize(response.getBody(), LimitsInfo.class);
				info = setPauseSuccessResponse;
				lastRefresh = Datetime.now();
				inf = createListOfLimits(info);
			}
		}
	}

	public List<Info> createListOfLimits(LimitsInfo info) {
		List<Info> limits = new List<Info>();

		limits.add(new Info('ConcurrentAsyncGetReportInstances', info.ConcurrentAsyncGetReportInstances.Max, info.ConcurrentAsyncGetReportInstances.Remaining));
		limits.add(new Info('ConcurrentSyncReportRuns', info.ConcurrentSyncReportRuns.Max, info.ConcurrentSyncReportRuns.Remaining));
		limits.add(new Info('DailyApiRequests', info.DailyApiRequests.Max, info.DailyApiRequests.Remaining));
		limits.add(new Info('DailyAsyncApexExecutions', info.DailyAsyncApexExecutions.Max, info.DailyAsyncApexExecutions.Remaining));
		limits.add(new Info('DailyBulkApiRequests', info.DailyBulkApiRequests.Max, info.DailyBulkApiRequests.Remaining));
		limits.add(new Info('DailyDurableGenericStreamingApiEvents', info.DailyDurableGenericStreamingApiEvents.Max, info.DailyDurableGenericStreamingApiEvents.Remaining));
		limits.add(new Info('DailyDurableStreamingApiEvents', info.DailyDurableStreamingApiEvents.Max, info.DailyDurableStreamingApiEvents.Remaining));
		limits.add(new Info('DailyGenericStreamingApiEvents', info.DailyGenericStreamingApiEvents.Max, info.DailyGenericStreamingApiEvents.Remaining));
		limits.add(new Info('DailyStreamingApiEvents', info.DailyStreamingApiEvents.Max, info.DailyStreamingApiEvents.Remaining));
		limits.add(new Info('DailyWorkflowEmails', info.DailyWorkflowEmails.Max, info.DailyWorkflowEmails.Remaining));
		limits.add(new Info('DataStorageMB', info.DataStorageMB.Max,  info.DataStorageMB.Remaining));
		limits.add(new Info('DurableStreamingApiConcurrentClients', info.DurableStreamingApiConcurrentClients.Max,  info.DurableStreamingApiConcurrentClients.Remaining));
		limits.add(new Info('FileStorageMB', info.FileStorageMB.Max,  info.FileStorageMB.Remaining));
		limits.add(new Info('HourlyAsyncReportRuns', info.HourlyAsyncReportRuns.Max, info.HourlyAsyncReportRuns.Remaining));
		limits.add(new Info('HourlyDashboardRefreshes', info.HourlyDashboardRefreshes.Max, info.HourlyDashboardRefreshes.Remaining));
		limits.add(new Info('HourlyDashboardResults', info.HourlyDashboardResults.Max, info.HourlyDashboardResults.Remaining));
		limits.add(new Info('HourlyDashboardStatuses', info.HourlyDashboardStatuses.Max, info.HourlyDashboardStatuses.Remaining));
		limits.add(new Info('HourlyODataCallout', info.HourlyODataCallout.Max, info.HourlyODataCallout.Remaining));
		limits.add(new Info('HourlySyncReportRuns', info.HourlySyncReportRuns.Max, info.HourlySyncReportRuns.Remaining));
		limits.add(new Info('HourlyTimeBasedWorkflow', info.HourlyTimeBasedWorkflow.Max, info.HourlyTimeBasedWorkflow.Remaining));
		limits.add(new Info('MassEmail', info.MassEmail.Max, info.MassEmail.Remaining));
		limits.add(new Info('SingleEmail', info.SingleEmail.Max, info.SingleEmail.Remaining));
		limits.add(new Info('StreamingApiConcurrentClients', info.StreamingApiConcurrentClients.Max, info.StreamingApiConcurrentClients.Remaining));
		return limits;
	}


	public class LimitsInfo {
		public BodyResponse ConcurrentAsyncGetReportInstances;
		public BodyResponse ConcurrentSyncReportRuns;
		public BodyResponse DailyApiRequests;
		public BodyResponse DailyAsyncApexExecutions;
		public BodyResponse DailyBulkApiRequests;
		public BodyResponse DailyDurableGenericStreamingApiEvents;
		public BodyResponse DailyDurableStreamingApiEvents;
		public BodyResponse DailyGenericStreamingApiEvents;
		public BodyResponse DailyStreamingApiEvents;
		public BodyResponse DailyWorkflowEmails;
		public BodyResponse DataStorageMB;
		public BodyResponse DurableStreamingApiConcurrentClients;
		public BodyResponse FileStorageMB;
		public BodyResponse HourlyAsyncReportRuns;
		public BodyResponse HourlyDashboardRefreshes;
		public BodyResponse HourlyDashboardResults;
		public BodyResponse HourlyDashboardStatuses;
		public BodyResponse HourlyODataCallout;
		public BodyResponse HourlySyncReportRuns;
		public BodyResponse HourlyTimeBasedWorkflow;
		public BodyResponse MassEmail;
		public BodyResponse SingleEmail;
		public BodyResponse StreamingApiConcurrentClients;
	}

	public class BodyResponse {
		public Double Max;
		public Double Remaining;
	}

	public class Info {
		public String name 						{ get; set; }
		public Double max 						{ get; set; }
		public Double remaining 				{ get; set; }
		public Double percent 					{ get; set; }
		public Boolean isRed 					{ get; set; }
		public Boolean isGreen 					{ get; set; }
		public Boolean isYellow 				{ get; set; }
		
		public Info(String name, Double max, Double remaining) {
			this.name = name;
			this.max = max;
			this.remaining = remaining;
			this.percent = (remaining*100)/max;
			
			this.isRed = false;
			this.isGreen = false;
			this.isYellow = false;
			
			if (this.percent >= 70 && this.percent < 90) {
				this.isYellow = true;
			} else if (this.percent < 70) {
				this.isRed = true;
			} else if (this.percent >= 90) {
				this.isGreen = true;
			}
		}
	}

}