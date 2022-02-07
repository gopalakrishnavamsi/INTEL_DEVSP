/******************************************************************************************************************************************
Class Name  : ICS_Apigee_Utility_Class
Version     : 1.0
Created Date:  23/3/2021
Description : This class has all the common methods needed for Apigee purposes
Modification Log :
* Developer                 Date                    Description             User Story
* --------------------------------------------------------------------------------------------
* Aparna                  23/3/2021                   Modified               US943434
***********************************************************************************************/
public class ICS_Apigee_Utility_Class{

    public static String logEntryMsg = '';
    public static string  accessToken = '';
    
    /*
     * Description : APIGEE Integration to check Products Warranty info so far till 2021 it is IPASS now Middle layer got changed.
     *               APIGEE Access token valid only 3599 mS
     *               APIGEE auth Type Bearer+Token
     *               APIGEE accepts the serial number as data param so not sending any body
     *               In APIGEE Portal , Need to configure an app and SUbscribe for the Integration system once it is approved will be able access 
     *               the data from APIGEE as a consumer.
     * Param 1 : integrationName as a string - this gives specific Integration setting from 'ICS_APIGEE_ConfigSettings__c' 
     * Param 2 : integrationClassName as a String - this gives specific Integration Consumer class from 'ICS_APIGEE_ConfigSettings__c'.
     * return : Access Token as a String.
     **/  
    public static string generateAccessToken_APIGEE(String integrationName,String integrationClassName ){
        /*get the exact values by parsing the integration Name 
          So here we will get only the Specific Custom Setting..
          based on integrationName- for example pass IBASE,CattsTCA - will get related details*/
        try{
        ICS_APIGEE_ConfigSettings__c integrationSetting = ICS_APIGEE_ConfigSettings__c.getValues(integrationName);
        String accessTokenURL = integrationSetting?.TokenEndPointURL__c ;//Safe Navigation Operator to Avoid Null Pointer Exceptions
        String clientId = integrationSetting?.ClientId__c ;
        String clientSecret = integrationSetting?.Client_Secret__c ;
        String grantType = integrationSetting?.GrantType__c;
          
        /* 
         * accessTokenURL or clientId or clientSecret can be null incase no custom setting record has created with integrationName 
         * */
        if(String.isBlank(accessTokenURL) || String.isBlank(clientId)|| String.isBlank(clientSecret)){

               
            logEntryMsg += '\n An Exception Occurred While generating token \n';
           
            String strInvocationID =integrationClassName+'  _APIGEE_TOKEN_GENERATION '+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS')
                + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
            
            String StrDetails= logEntryMsg +'\n Trace Information : '+'Integration Setting Issue -> '+integrationName;
            
            String logId = Core_Log_Entry.logEntryWithDetails(strInvocationID,System.Label.ICS_WR_logging_Scope,'APIGEE_TOKEN_GENERATION','Critical','Invalid Integration setting Name',StrDetails);
               
            return null;
        }
        //Now with Client Id, Client Secret , AuthToken URL We will send req to APIGEE..
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(accessTokenURL);
        request.setMethod('POST');
        request.setBody('grant_type='+grantType+'&client_id='+clientId+'&client_secret='+clientSecret); 
        request.setTimeout(120000);
        HttpResponse response = http.send(request);
      
        if(response?.getStatusCode() == 200)  //If Reponse successful..
        {
            ICS_QualityBuilderTokenParser parsedResponse = ICS_QualityBuilderTokenParser.parse(response.getBody());//Response body have accessToken..
            accessToken = parsedResponse?.access_token;  
            return accessToken;
        }
        else  //if reponse fails 
        {   
            accessToken =  'Error_Response Code: '+response.getStatusCode()+' Response Body: '+response.getBody();
            
            logEntryMsg += '\n An Exception Occurred While generating token \n';
           
            String strInvocationID =integrationClassName+' _APIGEE_TOKEN_GENERATION '+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS')
                + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
            
            String StrDetails= logEntryMsg +'\n Trace Information : '+'STATUS:'+ response.getStatus() + + '\nSTATUS_CODE:' + response.getStatusCode() + '\n Message:' + response.toString()+'\n Response Body: '+response.getBody();
            
            String logId = Core_Log_Entry.logEntryWithDetails(strInvocationID,System.Label.ICS_WR_logging_Scope,'APIGEE_TOKEN_GENERATION','Critical',response.toString(),StrDetails);

           return null;
        }
        }
        catch(System.CalloutException ex){
            String strInvocationID =integrationClassName + 'APIGEE_Unable to Generate Token '+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS')
                                                + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
             Core_Log_Entry.logEntryWithException(strInvocationID,System.Label.ICS_WR_logging_Scope,'APIGEE_generate_token_issue','Critical',ex.getMessage(),logEntryMsg,ex);
             return null;
        }
    }
    /*
     * Description : this method is used for Preparing http GET Request
     * Param 1 : string authorizationHeader - Bearer + AccessToken
     * Param 2 : string url - End Point Url to get the warranty info
     * Return : HttpRequest - will use in Consumer class
     * */
    public static HttpRequest getRequest_APIGEE(String authorizationHeader,string url){
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(url);
        req.setHeader('content-type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', authorizationHeader);
        req.setTimeout(120000);
        return req;
    }
    
   /* Method :  for making a post call with serial number as a body  
   * Author  : popcornapps  - vamsi
   * Date  :  30/07/2021
   * US number : US1075760
    */ 
      public static HttpRequest postRequest_SNtrace_SSD_APIGEE(String authorizationHeader,string body,string url){
          HttpRequest req = new HttpRequest();
          req.setMethod('POST');
          req.setEndpoint(url);
          req.setHeader('content-type', 'application/json');
          req.setHeader('Accept', 'application/json');
          req.setHeader('Authorization', authorizationHeader);
          req.setBody(body);
          req.setTimeout(12000);
          return req;
    }
    
    
    

}