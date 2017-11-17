public with sharing class MISLCalloutHelper {
    
    public static final String MISL_GET_USER_DEVICES = 'MISL_GetUserDevices';
    public static final String MISL_UPDATE_USER_DETAILS = 'MISL_UpdateUserDetails';
    public static final String MISL_DE_REGISTER_DEVICES = 'MISL_DeRegisterDevices';
    
    public class UpdateUserDetailsUnauthorized {
        public Error error;
    }
    // Wrappers For Get User Devices
    public class GetUserDevicesSuccessResponse {
        public List<MISLDevices> Devices;
    }
    public class MISLDevices {
        public String Id;
        public String RegistrationDate;
        public String Type;
    }
    public class GetUserDevicesUnauthorized {
        public Error error;
    }
    public class GetUserDevicesNotFound {
        public Error error;
    }
    public class GetUserDevicesInternalServerError {
        public Error error;
    }
    public class Error {
        public String code;
        public Message message;
    }
    public class Message {
        public String lang;
        public String value;
    }

    // Wrappers For De Register Devices
    public class DeRegisterDevicesBadRequest {
        public DeRegisterDevicesError error;
    }
    public class DeRegisterDevicesError {
        public Integer code;
        public Message message;
        public List<ValidationErrors> validationErrors;
    }
    public class ValidationErrors {
        public String Property;
        public String Rule;
    }
    public class DeRegisterDevicesUnauthorized {
        public Error error;
    }
    public class DeRegisterDevicesNotFound {
        public Error error;
    }
    public class DeRegisterDevicesInternalServerError {
        public Error error;
    }

    public static HttpResponse sendRequestToMISL(String endpointUrl, String method, String contentType, String authorization, String body, Integer timeout) {
        HttpRequest request = new HttpRequest();

        request.setEndpoint(endpointUrl);
        request.setMethod(method);
        request.setHeader('content-type', contentType);
        request.setHeader('Authorization', authorization);
        request.setTimeout(timeout);

        if (String.isNotBlank(body)) {
            request.setBody(body);
        }
        Http http = new Http();
        HttpResponse response = http.send(request);
        return response;
    }
    
    /*
    Description: Method gets an instance of MISL_Configuration__c if setting for specific country exists.
    */
    public static MISL_Configuration__c getMISLConfiguration(String configName, String accountCountryCode) {
        MISL_Configuration__c mislConfiguration;
        configName = String.escapeSingleQuotes(configName);
        List<MISL_Configuration__c> mislConfigurations = [
            SELECT Id, Enabled_Country_Codes__c, Value__c, Timeout__c
            FROM MISL_Configuration__c
            WHERE Name LIKE :configName + '%'
        ];
        if (String.isNotBlank(configName) && String.isNotBlank(accountCountryCode)) {
            accountCountryCode = accountCountryCode.toLowerCase().trim();
            for (MISL_Configuration__c mislConfig : mislConfigurations) {
                if (String.isNotBlank(mislConfig.Enabled_Country_Codes__c) && accountCountryCode == mislConfig.Enabled_Country_Codes__c.toLowerCase().trim()) {
                    mislConfiguration = mislConfig;
                }
            }
        }
        return mislConfiguration;
    }
    
    /*
    Description: Method updates some of the details for a particular user in MISL.
    */
    public static Map<String, String> updateUserDetails(Map<String, Object> payload, String accountId, String countryCode, Boolean enableAPILogCreation) {
        Map<String, String> result;
        String statusStr;
        Boolean isLogToAPI = true;
        Integer responseStatusCode;
        String requestStr;
        String responseStr;
        String endpointUrl;
        
        try {
            MISL_Configuration__c updateUserDetailsConfig = getMISLConfiguration(MISL_UPDATE_USER_DETAILS, countryCode);

            if (updateUserDetailsConfig == null) { // this means that feature is disabled
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => 'UpdateUserDetails endpoint is disabled'
                };
                isLogToAPI = false;
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'MISLCalloutHelper', 'updateUserDetails', 'Data Issue', 'Data Issue', result.get('message'));
                return result;
            }
            
            endpointUrl = (updateUserDetailsConfig != null) ? updateUserDetailsConfig.Value__c : null;
            Decimal timeout = (updateUserDetailsConfig != null) ? updateUserDetailsConfig.Timeout__c : null;
            
            String authorization = getMISLAuthorizationStr();
            
            Boolean isEmptyCalloutParameters = String.isBlank(endpointUrl) || String.isBlank(authorization) || (timeout == null || timeout <= 0);
            if (isEmptyCalloutParameters) {
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => 'Custom settings are missed: UpdateUserDetails URL/Username/Password/Timeout'
                };
                isLogToAPI = false;
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'MISLCalloutHelper', 'updateUserDetails', 'Data Issue', 'Data Issue', result.get('message'));
                return result;
            }
            
            requestStr = JSON.serialize(payload);
            HttpResponse response = MISLCalloutHelper.sendRequestToMISL(
                endpointUrl,
                'POST',
                'application/json',
                authorization,
                requestStr,
                (Integer)timeout
            );

            responseStatusCode = response.getStatusCode();
            responseStr = response.getbody();
            if (responseStatusCode == 200) {
                result = new Map<String, String> {
                    'success' => 'true',
                    'message' => response.getbody()
                };
                statusStr = 'Success';
            } else if (responseStatusCode == 401) {
                MISLCalloutHelper.UpdateUserDetailsUnauthorized updateUserDetailsUnauthorized = (MISLCalloutHelper.UpdateUserDetailsUnauthorized)JSON.deserialize(responseStr, MISLCalloutHelper.UpdateUserDetailsUnauthorized.class);
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => String.valueOf(responseStatusCode) + ' - ' + updateUserDetailsUnauthorized.error.message.value
                };
                statusStr = 'Failed with errors';
            } else {
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => String.valueOf(responseStatusCode) + ' - ' + response.getBody()
                };
                statusStr = 'Failed with errors';
            }
        } catch (Exception e) {
           result = new Map<String, String>{
                'success' => 'false',
                'message' => e.getMessage()
            };
            statusStr = (e.getTypeName().containsIgnoreCase('CalloutException')) ? 'Failed with time out' : 'Failed with errors';
            isLogToAPI = e.getTypeName().containsIgnoreCase('CalloutException');
            if (!isLogToAPI) {
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'MISLCalloutHelper', 'updateUserDetails', e.getMessage(), e.getTypeName(), e.getStackTraceString());
            }
        } finally {
            if (isLogToAPI) {
                if (enableAPILogCreation) {
                    APILogger.CreateAPILogs(
                        accountId,
                        endpointUrl,
                        'Outbound',
                        null,
                        requestStr,
                        responseStr,
                        String.valueOf(responseStatusCode),
                        statusStr
                    );
                } else {
                    result.put('API_Log_Account_Id', accountId);
                    result.put('API_Log_Endpoint', endpointUrl);
                    result.put('API_Log_Request_String', (String.isNotBlank(requestStr) && requestStr.length() > 131071) ? requestStr.substring(0,131071) : requestStr);
                    result.put('API_Log_Response_String', (String.isNotBlank(responseStr) && responseStr.length() > 131071) ? responseStr.substring(0,131071) : responseStr);
                    result.put('API_Log_Response_Status_Code', String.valueOf(responseStatusCode));
                    result.put('API_Log_Status', statusStr);
                }
            }
        }
        return result;
    }
    
    /*
    Description: Method gets a list of registered devices for the user.
    */
    public static Map<String, String> getUserDevices(String accountId, String countryCode) {
        Map<String, String> result;
        String endpointUrl;
        String statusStr;
        try {
            if (String.isBlank(accountId)) {
                result = new Map<String, String> {'success' => 'false', 'message' => 'AccountId is blank'};
                return result;
            }
            
            MISL_Configuration__c getUserDevicesConfig = getMISLConfiguration(MISL_GET_USER_DEVICES, countryCode);
            if (getUserDevicesConfig == null) { // this means that feature is disabled
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => 'GetUserDevices is disabled'
                };
                return result;
            }
            endpointUrl = (getUserDevicesConfig != null) ? getUserDevicesConfig.Value__c : null;
            Decimal timeout = (getUserDevicesConfig != null) ? getUserDevicesConfig.Timeout__c : null;
            
            String authorization = getMISLAuthorizationStr();
            
            Boolean isEmptyCalloutParameters = String.isBlank(endpointUrl) || String.isBlank(authorization) || (timeout == null || timeout <= 0);
            if (isEmptyCalloutParameters) {
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => 'Custom settings are missed: GetUserDevices URL/Username/Password/Timeout'
                };
                return result;
            }
            
            HttpResponse response = MISLCalloutHelper.sendRequestToMISL(
                endpointUrl + accountId,
                'GET',
                'application/json',
                authorization,
                null,
                (Integer)timeout
            );

            
            Integer responseStatusCode = response.getStatusCode();
            String responseBody = response.getbody();
            if (responseStatusCode == 200) {
                MISLCalloutHelper.GetUserDevicesSuccessResponse getUserDevicesSuccessResponse = (MISLCalloutHelper.GetUserDevicesSuccessResponse)JSON.deserialize(responseBody, MISLCalloutHelper.GetUserDevicesSuccessResponse.class);
                result = new Map<String, String> {
                    'success' => 'true',
                    'message' => response.getbody()
                };
                statusStr = 'Success';
            } else if (responseStatusCode == 401) {
                MISLCalloutHelper.GetUserDevicesUnauthorized getUserDevicesUnauthorized = (MISLCalloutHelper.GetUserDevicesUnauthorized)JSON.deserialize(responseBody, MISLCalloutHelper.GetUserDevicesUnauthorized.class);
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => String.valueOf(responseStatusCode) + ' - ' + getUserDevicesUnauthorized.error.message.value
                };
                statusStr = 'Failed with errors';
            } else if (responseStatusCode == 404) {
                MISLCalloutHelper.GetUserDevicesNotFound getUserDevicesNotFound = (MISLCalloutHelper.GetUserDevicesNotFound)JSON.deserialize(responseBody, MISLCalloutHelper.GetUserDevicesNotFound.class);
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => String.valueOf(responseStatusCode) + ' - ' + getUserDevicesNotFound.error.message.value
                };
                statusStr = 'Failed with errors';
            } else if (responseStatusCode == 500) {
                MISLCalloutHelper.GetUserDevicesInternalServerError getUserDevicesInternalServerError = (MISLCalloutHelper.GetUserDevicesInternalServerError)JSON.deserialize(responseBody, MISLCalloutHelper.GetUserDevicesInternalServerError.class);
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => String.valueOf(responseStatusCode) + ' - ' + getUserDevicesInternalServerError.error.message.value
                };
                statusStr = 'Failed with errors';
            } else {
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => String.valueOf(responseStatusCode) + ' - ' + response.getBody()
                };
                statusStr = 'Failed with errors';
            }
        } catch (Exception e) {
            String errorMsg = (e.getTypeName().containsIgnoreCase('CalloutException')) ? 'Failed with time out' : e.getMessage();
            result = new Map<String, String> {'success' => 'false', 'message' => errorMsg};
        }
        return result;
    }
    
    public static String getMISLAuthorizationStr() {
        String auth;
        String username = (MISL_Configuration__c.getValues('MISL_Username') != null) ? MISL_Configuration__c.getValues('MISL_Username').Value__c : null;
        String password = (MISL_Configuration__c.getValues('MISL_Password') != null) ? MISL_Configuration__c.getValues('MISL_Password').Value__c : null;
        if (String.isBlank(username) || String.isBlank(password)) {
            return null;
        }
        Blob authBlob = Blob.valueOf(username + ':' + EncodingUtil.base64Decode(password).toString());
        auth = EncodingUtil.base64Encode(authBlob);
        return 'Basic ' + auth;
    }

    /*
    Description: Method is used to either de-register a single user device OR to de-register all devices for a user.
    */
    public static Map<String, String> deRegisterDevices(Map<String, Object> payload, String accountId, String countryCode) {
        Map<String, String> result;
        String endpointUrl;
        Integer responseStatusCode = 0;
        String statusStr;
        String requestStr;
        String responseStr;
        Boolean isLogToAPI = true;
        try {
            MISL_Configuration__c deRegisterDevicesConfig = getMISLConfiguration(MISL_DE_REGISTER_DEVICES, countryCode);
            if (deRegisterDevicesConfig == null) { // this means that feature is disabled
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => 'DeRegisterDevices endpoint is disabled'
                };
                isLogToAPI = false;
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'MISLCalloutHelper', 'deRegisterDevices', 'Data Issue', 'Data Issue', result.get('message'));
                return result;
            }
            
            endpointUrl = (deRegisterDevicesConfig != null) ? deRegisterDevicesConfig.Value__c : null;
            Decimal timeout = (deRegisterDevicesConfig != null) ? deRegisterDevicesConfig.Timeout__c : null;
            
            String authorization = getMISLAuthorizationStr();
            
            Boolean isEmptyCalloutParameters = String.isBlank(endpointUrl) || String.isBlank(authorization) || (timeout == null || timeout <= 0);
            if (isEmptyCalloutParameters) {
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => 'Custom settings are missed: DeRegisterDevices URL/Username/Password/Timeout'
                };
                isLogToAPI = false;
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'MISLCalloutHelper', 'deRegisterDevices', 'Data Issue', 'Data Issue', result.get('message'));
                return result;
            }
            
            requestStr = JSON.serialize(payload);
            HttpResponse response = MISLCalloutHelper.sendRequestToMISL(
                endpointUrl,
                'POST',
                'application/json',
                authorization,
                requestStr,
                (Integer)timeout
            );
            
            responseStatusCode = response.getStatusCode();
            responseStr = response.getbody();
            if (responseStatusCode == 204) {
                result = new Map<String, String> {
                    'success' => 'true',
                    'message' => response.getbody()
                };
                statusStr = 'Success';
            } else if (responseStatusCode == 400) {
                MISLCalloutHelper.DeRegisterDevicesBadRequest deRegisterDevicesBadRequest = (MISLCalloutHelper.DeRegisterDevicesBadRequest)JSON.deserialize(responseStr, MISLCalloutHelper.DeRegisterDevicesBadRequest.class);
                String errorMsg = '';
                for (MISLCalloutHelper.ValidationErrors error : deRegisterDevicesBadRequest.error.ValidationErrors) {
                    errorMsg += error.Rule + '\n';
                }
                errorMsg = errorMsg.substring(0, errorMsg.length() - 2);
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => String.valueOf(responseStatusCode) + ' - ' + errorMsg
                };
                statusStr = 'Failed with errors';
            } else if (responseStatusCode == 401) {
                MISLCalloutHelper.DeRegisterDevicesUnauthorized deRegisterDevicesUnauthorized = (MISLCalloutHelper.DeRegisterDevicesUnauthorized)JSON.deserialize(responseStr, MISLCalloutHelper.DeRegisterDevicesUnauthorized.class);
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => String.valueOf(responseStatusCode) + ' - ' + deRegisterDevicesUnauthorized.error.message.value
                };
                statusStr = 'Failed with errors';
            } else if (responseStatusCode == 404) {
                MISLCalloutHelper.DeRegisterDevicesNotFound deRegisterDevicesNotFound = (MISLCalloutHelper.DeRegisterDevicesNotFound)JSON.deserialize(responseStr, MISLCalloutHelper.DeRegisterDevicesNotFound.class);
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => String.valueOf(responseStatusCode) + ' - ' + deRegisterDevicesNotFound.error.message.value
                };
                statusStr = 'Failed with errors';
            } else if (responseStatusCode == 500) {
                MISLCalloutHelper.DeRegisterDevicesInternalServerError deRegisterDevicesInternalServerError = (MISLCalloutHelper.DeRegisterDevicesInternalServerError)JSON.deserialize(responseStr, MISLCalloutHelper.DeRegisterDevicesInternalServerError.class);
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => String.valueOf(responseStatusCode) + ' - ' + deRegisterDevicesInternalServerError.error.message.value
                };
                statusStr = 'Failed with errors';
            } else {
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => String.valueOf(responseStatusCode) + ' - ' + response.getBody()
                };
                statusStr = 'Failed with errors';
            }
        } catch (Exception e) {
            result = new Map<String, String> {
                'success' => 'false',
                'message' => e.getMessage()
            };
            statusStr = (e.getTypeName().containsIgnoreCase('CalloutException')) ? 'Failed with time out' : 'Failed with errors';
            isLogToAPI = e.getTypeName().containsIgnoreCase('CalloutException');
            if (!isLogToAPI) {
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'MISLCalloutHelper', 'changePassword', e.getMessage(), e.getTypeName(), e.getStackTraceString());
            }
        } finally {
            if (isLogToAPI) {
                APILogger.CreateAPILogs(
                    accountId,
                    endpointUrl,
                    'Outbound',
                    null,
                    requestStr,
                    responseStr,
                    String.valueOf(responseStatusCode),
                    statusStr
                );
            }
        }
        return result;
    }

    /*Description: Method is used to sync the Account Password in MISL  .*/
    public static Map<String, String> changePassword(Map<String, Object> payload, String countryCode, String accountId) {
        Map<String, String> result;
        String endpointUrl;
        Integer responseStatusCode = 0;
        String statusStr;
        String requestStr;
        String responseStr;
        Boolean isLogToAPI = true;

        try {
            MISL_Configuration__c changePassConfig = getMISLConfiguration('MISL_ChangeUserPassword', countryCode);
            if (changePassConfig == null) {
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => 'ChangeUserPassword endpoint is disabled'
                };
                isLogToAPI = false;
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'MISLCalloutHelper', 'changePassword', 'Data Issue', 'Data Issue', result.get('message'));
                return result;
            }

            endpointUrl = (changePassConfig != null) ? changePassConfig.Value__c : null;
            Decimal timeout = (changePassConfig != null) ? changePassConfig.Timeout__c : null;

            String authorization = getMISLAuthorizationStr();

            Boolean isEmptyCalloutParameters = String.isBlank(endpointUrl) || String.isBlank(authorization) || (timeout == null || timeout <= 0);
            if (isEmptyCalloutParameters) {
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => 'Custom settings are missed: DeRegisterDevices URL/Username/Password/Timeout'
                };
                isLogToAPI = false;
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'MISLCalloutHelper', 'changePassword', 'Data Issue', 'Data Issue', result.get('message'));
                return result;
            }

            requestStr = JSON.serialize(payload);
            HttpResponse response = MISLCalloutHelper.sendRequestToMISL(
                endpointUrl,
                'POST',
                'application/json',
                authorization,
                requestStr,
                (Integer)timeout
            );

            responseStatusCode = response.getStatusCode();
            responseStr = response.getbody();
            if (responseStatusCode == 200) {
                result = new Map<String, String> {
                    'success' => 'true',
                    'message' => response.getBody()
                };
                statusStr = 'Success';
            } else {
                result = new Map<String, String> {
                    'success' => 'false',
                    'message' => String.valueOf(responseStatusCode) + ' - ' + response.getBody()
                };
                statusStr = 'Failed with errors';
                System.debug('>>> response.getBody() = ' + response.getBody());
            }
        } catch (Exception e) {
            result = new Map<String, String>{
                'success' => 'false',
                'message' => e.getMessage()
            };
            statusStr = (e.getTypeName().containsIgnoreCase('CalloutException')) ? 'Failed with time out' : 'Failed with errors';
            isLogToAPI = e.getTypeName().containsIgnoreCase('CalloutException');
            if (!isLogToAPI) {
                ExceptionLoggerHelper.createExceptionLog(UserInfo.getUserId(), 'MISLCalloutHelper', 'changePassword', e.getMessage(), e.getTypeName(), e.getStackTraceString());
            }
        } finally {
            if (isLogToAPI) {
                APILogger.CreateAPILogs(
                    accountId,
                    endpointUrl,
                    'Outbound',
                    null,
                    requestStr,
                    responseStr,
                    String.valueOf(responseStatusCode),
                    statusStr
                );
            }
        }
        return result;
    }
}