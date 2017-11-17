@isTest
global class ComunicatorMockImpl implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
           
        DataService.DataImporterResponse_element responseActual = new DataService.DataImporterResponse_element();
        DataService.DataImportResponse respElement = new DataService.DataImportResponse();
        DataService.ArrayOfDataImportResponseDetail ImportDetailsArr = new DataService.ArrayOfDataImportResponseDetail();
        
        DataService.DataImportResponseDetail detail = new DataService.DataImportResponseDetail();
        List<DataService.DataImportResponseDetail> lstDetail = new List<DataService.DataImportResponseDetail>();
        detail.Row      = 1;
        detail.Result   ='SuccessUpdating';
        detail.Response ='Mock response';
        
        lstDetail.add(detail);
        ImportDetailsArr.DataImportResponseDetail = lstDetail;
        respElement.ImportDetails = ImportDetailsArr;
        responseActual.DataImporterResult = respElement;
       
       response.put('response_x', responseActual); 
   }
}