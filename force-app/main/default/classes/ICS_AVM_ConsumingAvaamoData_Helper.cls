/********************************************************************************************
* Name        : ICS_AVM_ConsumingAvaamoData_Helper
* Test class  : ICS_AVM_Live_Chat_Agent_Controller_Test
* Author      : Nikhil patil - Popcornapps
* Date created: 16 - April - 2021
* Description :  Class is being used to get data from APIGEE for Avaamo api.
*               
* Date              Created By                    User-Story  
* 4/16/2021         Popcornapps                   US959256
* ******************************************************************************************/
public class ICS_AVM_ConsumingAvaamoData_Helper{
    public static String logEntryMsg = ''; 
    
    /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method     : getToken_APIGEE(integer calloutCount)
* ────────────────────────────────────────────────────────────────────────────────────────────────
* Description : This method is used for  getting  Access token from Avaamo via APIGEE. 
*             : Containt wrapper classes to store JSON body from responce
*             : Using Org Cache to store a Access token 
*             : If response is not sucess & Callout catch excpetion & return null value
* @Param      : Integer calloutCount - to call this method recursively (3 times)
* Return Type : String
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    public static String getToken_APIGEE(Integer calloutCount)
    {	
        String avmAccessToken = '';
        try{
            if(Cache.Org.contains(System.Label.ICS_AVM_AccessTokenCache)){
                avmAccessToken = (String)Cache.Org.get(System.Label.ICS_AVM_AccessTokenCache);
            }else{
                string integrationName = ICS_APIGEE_ConfigSettings__c.getInstance(System.Label.ICS_AVM_Avaamo).Name;
                String integrationClassName = ICS_APIGEE_ConfigSettings__c.getInstance(System.Label.ICS_AVM_Avaamo).Class_Name__c;
                if(calloutCount < 3){
                    avmAccessToken = ICS_Apigee_Utility_Class.generateAccessToken_APIGEE(integrationName,integrationClassName);
                    if(avmAccessToken == null){
                        calloutCount++;
                        ICS_AVM_ConsumingAvaamoData_Helper.getToken_APIGEE(calloutCount);
                    }else{
                        Cache.Org.put(System.Label.ICS_AVM_AccessTokenCache, avmAccessToken, Integer.valueOf(System.Label.ICS_AVM_SetTimeForOrgCache));
                    }
                }else{
                    logEntryMsg += System.Label.ICS_AVM_An_exception_occurred_while_generating_token;
                    
                    String strInvocationID =integrationClassName+'_APIGEE_TOKEN_GENERATION'+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS')
                        + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
                    
                    String StrDetails= logEntryMsg +'\n Trace Information : '+'Integration Setting Issue ->'+integrationName;
                    
                    String logId = Core_Log_Entry.logEntryWithDetails(strInvocationID,System.Label.ICS_WR_logging_Scope,'APIGEE_TOKEN_GENERATION','Critical','invalid Integration setting Name',StrDetails);
                }
            }
        }catch(Exception ex){
            String strLogEntryName ='ICS_AVM_ConsumingAvaamoData_Helper ' + 'Unable to Generate Token '+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS')
                + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
            Core_Log_Entry.logEntryWithException(strLogEntryName,System.Label.ICS_WR_logging_Scope,'WR_apigee_generate_token_issue','Critical',ex.getMessage(),'',ex);
            return null;     
        }
        return avmAccessToken;
    }
    
    /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method: postRequest_APIGEE(string bodyInput,string url)
* ────────────────────────────────────────────────────────────────────────────────────────────────
* Description : This method is used to do a POST request to Avaamo via APIGEE. 
*             : Using HTTP callout methods to call external system i.e  APIGEE
*             : passing two param body and url 
* @Param      : String bodyInput - JSON body to pass in setBod
*             : String url - URL to set end point   
* Return Type : void
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    @future(callout = true)
    public static void postRequest_APIGEE(string bodyInput,string url)
    {
        try
        {  system.debug('inside postRequest_APIGEE ==> ');
            String access_token = ICS_AVM_ConsumingAvaamoData_Helper.getToken_APIGEE(0);
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(url);
            req.setHeader('content-type', 'application/json');
            //26-04-2021 -- P-2 -- Nikhil Patil -- AvoidHardCodedCredential -- To reuse the access token we have stored in org cache, not using named credentials
            req.setHeader('Authorization', 'Bearer '+access_token);
            req.setBody(bodyInput);
            Http http = new Http();  
            HttpResponse response = http.send(req);
            if(response.getStatusCode() == 201){     
                system.debug('inside postRequest_APIGEE success ==> ');
                // logic on success
            }else if(response.getStatusCode() == 422){
                //ICS_AVM_RestAPIforLiveChat_Handler.endChat(affinityToken, key , 'Agent');
            }else{
                logEntryMsg += '\n An Exception Occurred While calling POST method \n';
                String strInvocationID ='ICS_AVM_ConsumingAvaamoData_Helper '+'postRequest_APIGEE '+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS')
                    + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
                String StrDetails= logEntryMsg +'\n Trace Information : '+'STATUS:'+ response.getStatus() + + '\nSTATUS_CODE:' + response.getStatusCode() + '\n Message:' + response.toString()+'\n Response Body: '+response.getBody();
                String logId = Core_Log_Entry.logEntryWithDetails(strInvocationID,System.Label.ICS_WR_logging_Scope,'postRequest_APIGEE','Critical',response.toString(),StrDetails);
            }
        }Catch(Exception e){ 
            String strInvocationID ='ICS_AVM_ConsumingAvaamoData_Helper '+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS') + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
            Core_Log_Entry.logEntryWithException(strInvocationID,System.Label.ICS_WR_logging_Scope,'postRequest_APIGEE','Critical',e.getMessage(),'',e);
        }
    }
    
    /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method     : putRequest_APIGEE(string bodyInput,string url)
* ────────────────────────────────────────────────────────────────────────────────────────────────
* Description : This method is used to do a PUT request to Avaamo via APIGEE. 
*             : Using HTTP callout methods to call external system i.e  APIGEE
*             : passing two param body and url 
* @Param      : String bodyInput - JSON body to pass in setBod
*             : String url - URL to set end point   
* Return Type : void
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
   @future(callout = true)
    public static void putRequest_APIGEE(string bodyInput,string url, String affinityToken , String key)
    { 
        try
        {  
            
            String access_token = ICS_AVM_ConsumingAvaamoData_Helper.getToken_APIGEE(0);
            HttpRequest req = new HttpRequest();
            req.setMethod('PUT');
            req.setEndpoint(url);
            req.setHeader('content-type', 'application/json');
            //26-04-2021 -- P-2 -- Nikhil Patil -- AvoidHardCodedCredential -- To reuse the access token we have stored in org cache, not using named credentials
            req.setHeader('Authorization', 'Bearer '+access_token);
            req.setBody(bodyInput);
            Http http = new Http();  
            HttpResponse response = http.send(req);
            if(response?.getStatusCode() == 200){ 
                // logic on success
               
                system.debug('inside put request success ==> ');
            }else if(response.getStatusCode() == 422){
               // ICS_AVM_RestAPIforLiveChat_Handler.endChat(affinityToken, key , 'Agent');
            }else{
                logEntryMsg += '\n An Exception Occurred While calling PUT method \n';
                String strInvocationID ='ICS_AVM_ConsumingAvaamoData_Helper '+'putRequest_APIGEE '+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS')
                    + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
                String StrDetails= logEntryMsg +'\n Trace Information : '+'STATUS:'+ response.getStatus() + + '\nSTATUS_CODE:' + response.getStatusCode() + '\n Message:' + response.toString()+'\n Response Body: '+response.getBody();
                String logId = Core_Log_Entry.logEntryWithDetails(strInvocationID,System.Label.ICS_WR_logging_Scope,'putRequest_APIGEE','Critical',response.toString(),StrDetails);
            }
        }Catch (Exception e){ 
            String strInvocationID ='ICS_AVM_ConsumingAvaamoData_Helper '+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS') + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
            Core_Log_Entry.logEntryWithException(strInvocationID,System.Label.ICS_WR_logging_Scope,'putRequest_APIGEE','Critical',e.getMessage(),'',e);
        }
    }
    
    /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method     : deleteRequest_APIGEE(string bodyInput,string url)
* ────────────────────────────────────────────────────────────────────────────────────────────────
* Description : This method is used to do a DELETE request to Avaamo via APIGEE. 
*             : Using HTTP callout methods to call external system i.e  APIGEE
*             : passing two param body and url 
* @Param      : String bodyInput - JSON body to pass in setBod
*             : String url - URL to set end point   
* Return Type : void
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    @future(callout = true)
    public static void deleteRequest_APIGEE(string bodyInput,string url)
    {system.debug('inside deleteRequest_APIGEE ==> ');
        try
        {  
            String access_token = ICS_AVM_ConsumingAvaamoData_Helper.getToken_APIGEE(0);
            HttpRequest req = new HttpRequest();
            req.setMethod('DELETE');
            req.setEndpoint(url);
            req.setHeader('content-type', 'application/json');
            //26-04-2021 -- P-2 -- Nikhil Patil -- AvoidHardCodedCredential -- To reuse the access token we have stored in org cache, not using named credentials
            req.setHeader('Authorization', 'Bearer '+access_token);
            req.setBody(bodyInput);
            Http http = new Http();  
            HttpResponse response = http.send(req);
            system.debug('===================================='+response);
            if(response?.getStatusCode() == 204){  
                // logic on success
                
            }else if(response.getStatusCode() == 422){
              //  ICS_AVM_RestAPIforLiveChat_Handler.endChat(affinityToken, key , 'Agent');
            }else{
                logEntryMsg += '\n An Exception Occurred While calling DELETE method \n';
                String strInvocationID ='ICS_AVM_ConsumingAvaamoData_Helper '+'deleteRequest_APIGEE '+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS')
                    + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
                String StrDetails= logEntryMsg +'\n Trace Information : '+'STATUS:'+ response.getStatus() + + '\nSTATUS_CODE:' + response.getStatusCode() + '\n Message:' + response.toString()+'\n Response Body: '+response.getBody();
                String logId = Core_Log_Entry.logEntryWithDetails(strInvocationID,System.Label.ICS_WR_logging_Scope,'deleteRequest_APIGEE','Critical',response.toString(),StrDetails);
            }
        }Catch (Exception e){ 
            String strInvocationID ='ICS_AVM_ConsumingAvaamoData_Helper '+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS') + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
            Core_Log_Entry.logEntryWithException(strInvocationID,System.Label.ICS_WR_logging_Scope,'deleteRequest_APIGEE','Critical',e.getMessage(),'',e);
        }
    }
    
    public class fromJSON{
        public Integer current_page;	
        public Integer per_page;	
        public Integer total_entries;	
        public Integer total_pages;	
        public Double time_token;	
        public cls_entries[] entries;
    }
    class cls_entries {
        public String uuid;	
        public String content;	
        public String content_type;	
        public String created_at;	
        public cls_user user;
        public String timetoken;	
        public String external_source;
        public String device_uuid;
        public String request_message_uuid;	
        public String sequence;	
        public cls_custom_properties  custom_properties;
        public String agent_message_uuid;
        public cls_conversation conversation;
        public cls_attachments[] attachments;
    }
    class cls_user {
        public String first_name;	
        public String last_name;	
        public String layer_id;	
        public String email;
        public String phone;
        public boolean avatar;
        public String avatar_updated_at;
        public Integer avaamo_id;	
    }
    
    class cls_custom_properties {
        public String channel_type;	
    }
    class cls_attachments {
        public cls_default_card default_card;
    }
    class cls_default_card {
        public String uuid;	
        public String title;	
        public String description;
        public String showcase_image_uuid;
        public String url;
        public String showcase_image_meta;
        public String locale;
        public String showcase_image_url;
        public String showcase_image;
        public cls_links[] links;
    }
    class cls_links {
        public String title;	
        public String link_type;	
        public Integer position;	
        public String type;	
        public String url;	
    }
    class cls_conversation {
        public String uuid;	
        public boolean mode;
        public String display_name;	
        public String locale;
    }
    
  /*  //Out Put structure of this class / return type
    public class AvaamoMessagesData
    {
        public String content{get;set;}
        public String first_name{get;set;}
        public String layer_id{get;set;}
        public datetime  created_at{get;set;}
    }*/
}