/********************************************************************************************
* Name        : ICS_AVM_Live_Chat_Agent_Controller
* Test class  : ICS_AVM_Live_Chat_Agent_Controller_Test
* Author      : Nikhil patil - Popcornapps
* Date created: 23 - March - 2021
* Description :  Controller class that do a call to APIGEE API's on perticuler event call from live chat agent chat.
*               
*   Date              Created By                    User-Story  
* 23/3/2021           Popcornapps                   US959256
* ******************************************************************************************/
public class ICS_AVM_Live_Chat_Agent_Controller{  
    private static Boolean isAvaamoUser = false;
    private static String converstaionUUID;
    /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method     : onAgentSendCntr(String content, String recordId)
* ────────────────────────────────────────────────────────────────────────────────────────────────
* Description : This method is used to fetch the event details and send it to the APIGEE API call.  
*             : Containt logic to collect data and send it to the method to call API.
* @Param      : String content - message from live agent
*             : String recordId - id of LiveChatTranscript obect to get UUID by query 
* Return Type : Void
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    @AuraEnabled
    public static void onAgentSendCntr(String content, String recordId) {
        try{            
            system.debug('inside onAgentSendCntr ==> ');
            String finalString = '';
            String finalString1 = '';
            list<String> subString = content.split(' ');
            For(String str : subString){
                if(Pattern.matches('((https?):((\\/\\/)|(\\\\))+[\\w\\d:#@%\\/;$()~_?+\\--=\\\\.&]*)', str)){
                    str = '<a href=\\"'+str+'\\">'+str+'</a>';
                    finalString = finalString + str + ' ';
                }else{
                    finalString = finalString + str + ' ';
                }   
            }
            list<String> subString1 = finalString.split('\n');
            For(String str : subString1){
                finalString1 = finalString1 + str + '<br/>' ;
            }
            finalString1 = finalString1.trim();
            content = finalString1;
            LiveChatTranscript objLiveChatTranscript = [SELECT Id, ICS_AVM_ConversationUUID__c FROM LiveChatTranscript WHERE id =: recordId LIMIT 1];
            if(objLiveChatTranscript.ICS_AVM_ConversationUUID__c != null && objLiveChatTranscript.ICS_AVM_ConversationUUID__c != ''){
                String integrationEndPointURL = ICS_APIGEE_ConfigSettings__c.getInstance(System.Label.ICS_AVM_Avaamo).setEndPointURL__c;
               
                String avmAccessToken = System.Label.ICS_AVM_Live_Agent_Access_Token;
                String apigeeChatBody =  '{"message":{"conversation":{"uuid":"'+objLiveChatTranscript.ICS_AVM_ConversationUUID__c+'"},"content":"'+content+'","content_type":"text"}}';
               
                String apigeeEndPointURL = integrationEndPointURL+'?access_token='+avmAccessToken;
                
                ICS_AVM_ConsumingAvaamoData_Helper.postRequest_APIGEE(apigeeChatBody,apigeeEndPointURL); 
                                

            }
            
        }catch(Exception ex){
            Core_Log_Entry.logEntryWithException('ICS_AVM_Live_Chat_Agent_Controller',System.Label.ICS_WR_logging_Scope,'onAgentSendCntr','Critical',ex.getMessage(),'',ex);
        }
    }
    
    /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method     : onWorkAcceptedCntr(String content, String recordId)
* ────────────────────────────────────────────────────────────────────────────────────────────────
* Description : This method is used to fetch the Work Accepted event details and send it to the APIGEE API call.  
*             : Containt logic to collect data and send it to the method to call API.
* @Param      : String content - message from live agent
*             : String recordId - id of LiveChatTranscript obect to get UUID by query 
* Return Type : Void
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    @AuraEnabled
    public static void onWorkAcceptedCntr(String content, String recordId) {
        System.debug('test sai');
        String access_token = ICS_AVM_ConsumingAvaamoData_Helper.getToken_APIGEE(0);
        try{
            
            LiveChatTranscript objLiveChatTranscript = [SELECT Id,Email__c,ICS_AVM_Poll_Apigee_Token__c,ICS_AVM_ChatBot_Transcript__c, ICS_AVM_ConversationUUID__c ,ICS_AVM_AffinityToken__c, ICS_AVM_Key__c FROM LiveChatTranscript WHERE id =: recordId LIMIT 1];
            if(objLiveChatTranscript.ICS_AVM_ConversationUUID__c != null && objLiveChatTranscript.ICS_AVM_ConversationUUID__c != ''){
                
           
                system.debug('inside onWorkAcceptedCntr ==> ');
                //Priya
                 String apigeeEndPointURL1 = System.Label.ICS_AVM_APIGEE_Chat_Transcript_Url + objLiveChatTranscript.ICS_AVM_ConversationUUID__c;
                 getRequest_APIGEE(apigeeEndPointURL1, objLiveChatTranscript.ICS_AVM_ConversationUUID__c, objLiveChatTranscript.ICS_AVM_AffinityToken__c, objLiveChatTranscript.ICS_AVM_Key__c); 
                //Priya
                String integrationEndPointURL = ICS_APIGEE_ConfigSettings__c.getInstance(System.Label.ICS_AVM_Avaamo).setEndPointURL__c;
                String avmAccessToken = System.Label.ICS_AVM_Live_Agent_Access_Token;
                String apigeeChatBody =  '{"message":{"conversation":{"uuid":"'+objLiveChatTranscript.ICS_AVM_ConversationUUID__c+'"},"content":"'+content+'","content_type":"text"}}';
                String apigeeEndPointURL = integrationEndPointURL+'?access_token='+avmAccessToken+'&uuid='+objLiveChatTranscript.ICS_AVM_ConversationUUID__c;
                ICS_AVM_ConsumingAvaamoData_Helper.putRequest_APIGEE(apigeeChatBody,apigeeEndPointURL, objLiveChatTranscript.ICS_AVM_AffinityToken__c, objLiveChatTranscript.ICS_AVM_Key__c); 
                
                
                String HtmlInjStr = System.Label.ICS_AVM_Connected_To_An_Agent;
                String extendSessionUrl= System.Label.ICS_AVM_APIGEE_Extend_Session_Url;
                HtmlInjStr = HtmlInjStr.trim();
                String str = '<!DOCTYPE html><html> <img onload=\'CallApiFunc()\' style=\'visibility:hidden\' src=\'https://media.giphy.com/media/sSgvbe1m3n93G/giphy.gif\'  height=25 width=25/><script>var bearerToken =\''+access_token+'\';async function CallApiFunc(){var myHeaders = new Headers(); myHeaders.append(\'Authorization\', \'Bearer \'+bearerToken);const apiResponse = await fetch(\''+extendSessionUrl+objLiveChatTranscript.ICS_AVM_Poll_Apigee_Token__c+'\', {method:\'GET\',headers:myHeaders,redirect:\'follow\'});if(apiResponse.ok){var result = await apiResponse.json();console.log(result);if(result.statusCode==200 || result.statusCode==201 || result.statusCode==204)   {bearerToken = result.accessToken;await CallApiFunc();console.log(\'api success\');}else  {console.log(\'into failure code\');    }        }else   {console.log(\'api failure\'); }}</script></body></html>';
                ICS_AVM_Live_Chat_Agent_Controller.onAgentSendCntr(str, objLiveChatTranscript.Id); 
            }
        }catch(Exception ex){
            System.debug('test sai1');
            Core_Log_Entry.logEntryWithException('ICS_AVM_Live_Chat_Agent_Controller',System.Label.ICS_WR_logging_Scope,'onWorkAcceptedCntr','Critical',ex.getMessage(),'',ex);
        }
    }
    
    
    
  /*  @AuraEnabled
    public static void onWorkAcceptedCntr1(String content, String recordId) {
        //String access_token = ICS_AVM_ConsumingAvaamoData_Helper.getToken_APIGEE(0);
        try{
            system.debug('inside onWorkAcceptedCntr1 ==> ');
            LiveChatTranscript objLiveChatTranscript = [SELECT Id,Email__c,ICS_AVM_Poll_Apigee_Token__c, ICS_AVM_ConversationUUID__c ,ICS_AVM_AffinityToken__c, ICS_AVM_Key__c FROM LiveChatTranscript WHERE id =: recordId LIMIT 1];
            if(objLiveChatTranscript.ICS_AVM_ConversationUUID__c != null && objLiveChatTranscript.ICS_AVM_ConversationUUID__c != ''){
                
                //Priya
                String apigeeEndPointURL1 = System.Label.ICS_AVM_APIGEE_Chat_Transcript_Url + objLiveChatTranscript.ICS_AVM_ConversationUUID__c;
                getRequest_APIGEE(apigeeEndPointURL1, objLiveChatTranscript.ICS_AVM_ConversationUUID__c, objLiveChatTranscript.ICS_AVM_AffinityToken__c, objLiveChatTranscript.ICS_AVM_Key__c); 
                //Priya
            }
        }catch(Exception ex){
            Core_Log_Entry.logEntryWithException('ICS_AVM_Live_Chat_Agent_Controller',System.Label.ICS_WR_logging_Scope,'onWorkAcceptedCntr','Critical',ex.getMessage(),'',ex);
        }
    }*/
    
    
    /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method     : onChatEndedCntr(String content, String recordId)
* ────────────────────────────────────────────────────────────────────────────────────────────────
* Description : This method is used to fetch the Chat End event details and send it to the APIGEE API call.  
*             : Containt logic to collect data and send it to the method to call API.
* @Param      : String content - message from live agent
*             : String recordId - id of LiveChatTranscript obect to get UUID by query 
* Return Type : Void
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    @AuraEnabled
    public static void onChatEndedCntr(String content, String recordId) {
        try{
            LiveChatTranscript objLiveChatTranscript = [SELECT Id, ICS_AVM_ConversationUUID__c FROM LiveChatTranscript WHERE id =: recordId LIMIT 1];
            if(objLiveChatTranscript.ICS_AVM_ConversationUUID__c != null && objLiveChatTranscript.ICS_AVM_ConversationUUID__c != ''){
                String integrationEndPointURL = ICS_APIGEE_ConfigSettings__c.getInstance(System.Label.ICS_AVM_Avaamo).setEndPointURL__c;
                String avmAccessToken = System.Label.ICS_AVM_Live_Agent_Access_Token;
                String apigeeChatBody =  '{"message":{"conversation":{"uuid":"'+objLiveChatTranscript.ICS_AVM_ConversationUUID__c+'"},"content":"'+content+'","content_type":"text"}}';
                String apigeeEndPointURL = integrationEndPointURL+'?access_token='+avmAccessToken+'&uuid='+objLiveChatTranscript.ICS_AVM_ConversationUUID__c;
                ICS_AVM_ConsumingAvaamoData_Helper.deleteRequest_APIGEE(apigeeChatBody,apigeeEndPointURL);
               
            }
        }catch(Exception ex){
            Core_Log_Entry.logEntryWithException('ICS_AVM_Live_Chat_Agent_Controller',System.Label.ICS_WR_logging_Scope,'onChatEndedCntr','Critical',ex.getMessage(),'',ex);
        }
    }
    
    
   
    //Priya
   // @future(callout = true)
    public static void getRequest_APIGEE(String url, String conversationID, String affinityToken ,String key)
    {//16-07-2021 -- P-2 -- Nikhil Patil -- has Cyclomatic Complexity  -- To check the conditions from list kept if else conditions inside the for loop
        System.debug('IsFuture'+System.isFuture());
        system.debug('getRequest_APIGEE url ==> '+url);
        system.debug('getRequest_APIGEE conversationID ==> '+conversationID);
        system.debug('getRequest_APIGEE affinityToken ==> '+affinityToken);
        system.debug('getRequest_APIGEE key ==> '+key);
        String logEntryMsg = ''; 
        String chatBotTranscript='';
        try
        { 
            String str = '';
            String access_token = ICS_AVM_ConsumingAvaamoData_Helper.getToken_APIGEE(0);
            String access_token1 = Label.ICS_AVM_Agent_Access_Token; 
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(url);
            req.setHeader('content-type', 'application/json');
            
            //26-04-2021 -- P-2 -- Nikhil Patil -- AvoidHardCodedCredential -- To reuse the access token we have stored in org cache, not using named credentials
            req.setHeader('Access-Token', access_token1);
            req.setHeader('Authorization', 'Bearer '+access_token);
            Http http = new Http();  
            HttpResponse response = http.send(req);
            
            System.debug('BhavanachatBotTranscript  response@@@'+response);
            if(response?.getStatusCode() == 200){  
                system.debug('getRequest_APIGEE status code ==> '+response.getStatusCode());
                system.debug('getRequest_APIGEE body ==> '+response.getbody());
                ICS_AVM_RestAPIforLiveChat_Handler.fromJSON  rec = new ICS_AVM_RestAPIforLiveChat_Handler.fromJSON();
                rec = (ICS_AVM_RestAPIforLiveChat_Handler.fromJSON) System.JSON.deserialize(response.getbody(), ICS_AVM_RestAPIforLiveChat_Handler.fromJSON.class); 
                
                List<ICS_AVM_RestAPIforLiveChat_Handler.AvaamoMessagesData> avmMsgData = new  List<ICS_AVM_RestAPIforLiveChat_Handler.AvaamoMessagesData>();
                for(ICS_AVM_RestAPIforLiveChat_Handler.cls_entries entries :rec.entries){
                    system.debug('entries.content_type ==> '+entries.content_type);
                    system.debug('entries.content ==> '+entries.content);
                    ICS_AVM_RestAPIforLiveChat_Handler.AvaamoMessagesData avmMsgDataSub = new ICS_AVM_RestAPIforLiveChat_Handler.AvaamoMessagesData();
                    if(entries.content_type == System.Label.ICS_AVM_text){
                        if(entries.content.contains('<!DOCTYPE html>')){
                            avmMsgDataSub.content = '' ;
                           // avmMsgDataSub.content = 'Text : HTML content' ;
                        }else{
                            avmMsgDataSub.content = entries.content.stripHtmlTags();
                        }                       
                    }
                    else if(entries.content_type == System.Label.ICS_AVM_default_card){
                        ICS_AVM_RestAPIforLiveChat_Handler.cls_attachments att = entries.attachments[0];
                        ICS_AVM_RestAPIforLiveChat_Handler.cls_default_card defCard = att.default_card;
                        avmMsgDataSub.content = 'Default Card : '+ defCard.title ;
                    }
                    else if(entries.content_type == System.Label.ICS_AVM_list_view){
                        avmMsgDataSub.content = 'List View : '+  entries.content ;
                    }
                    else if(entries.content_type == System.Label.ICS_AVM_directive){
                        avmMsgDataSub.content = 'Directive : '+ entries.content ;
                    }
                    else if(entries.content_type == System.Label.ICS_AVM_command){
                        avmMsgDataSub.content = 'Command : '+ entries.content ;
                    }
                    else if(entries.content_type == System.Label.ICS_AVM_quick_reply){
                        avmMsgDataSub.content = 'Quick Reply : '+ entries.content ;
                    }
                    avmMsgDataSub.first_name = entries.user.first_name ;
                    avmMsgDataSub.layer_id =  entries.user.layer_id ;
                    String unixDatetime = entries.created_at.SubStringBefore('.');
                    
                    Long L1 = long.valueOf(unixDatetime);
                    avmMsgDataSub.created_at = datetime.newinstance(L1 * 1000);
                    avmMsgData.add(avmMsgDataSub);
                }
                 String sample = '';
                System.debug('avmMsgData ==> '+avmMsgData);
                for(ICS_AVM_RestAPIforLiveChat_Handler.AvaamoMessagesData avmMsgDataVar: avmMsgData){
                    system.debug('avmMsgDataVar ==> '+avmMsgDataVar);
                    if(avmMsgDataVar.content.contains('Please wait, a live agent is on the way. '))
                    {
                        break;
                    }else if(avmMsgDataVar.content.contains('Give me a moment to read your chat transcript.'))
                    {
                        break;
                    }else{
                         str = str +  avmMsgDataVar.content + ' ['+avmMsgDataVar.created_at+'] ' +'\n';
                    sample = avmMsgDataVar.content +  '\n' +sample ;
                    }
                   
                }
                System.debug('str'+str);
                System.debug('sample'+sample);
                if(sample.length() <  31999){
                    chatBotTranscript = sample; 
                }else{
                    chatBotTranscript = sample.SubString(0,31999);
                }
                String apigeeChatBody = '{"text":"'+sample+'"}';
                HttpRequest reqToPostMessage = new HttpRequest();
                reqToPostMessage.setMethod('POST');
                reqToPostMessage.setHeader('X-LIVEAGENT-AFFINITY', affinityToken);
                reqToPostMessage.setHeader('X-LIVEAGENT-API-VERSION', System.Label.ICS_AVM_APIVersion);
                reqToPostMessage.setHeader('X-LIVEAGENT-SESSION-KEY', key);
                reqToPostMessage.setEndpoint(System.Label.ICS_AVM_StandardAPIToSendMessageToLiveAgent);
                reqToPostMessage.setHeader('Accept', 'application/json'); 
                reqToPostMessage.setHeader('Content-Type', 'application/json');
                //26-04-2021 -- P-2 -- Nikhil Patil -- AvoidHardCodedCredential -- To reuse the access token we have stored in org cache, not using named credentials
                //reqToPostMessage.setHeader('Authorization', 'Bearer 00D7e00000JdOLV!AR8AQDXQjIYrXsRYrxI5Ia6AyqkF9uvtxs1l3TSO4ZDwHC41TFtVEfs3j8LTemyeD0lSiYBICExcF94gIuBWMdCKXchOYoMF');
                reqToPostMessage.setBody(apigeeChatBody);
                
                if(sample != ''){
                    Http http2 = new Http();  
                    HttpResponse response2 = http2.send(reqToPostMessage);
                     System.debug('reqToPostMessage status code ==> '+response2.getStatusCode());
                     System.debug('reqToPostMessage responce body ==> '+response2.getBody());
                 /*   if(){
                          System.debug('reqToPostMessage status code ==> '+reqToPostMessage.getStatusCode();
                          System.debug('reqToPostMessage responce body ==> '+reqToPostMessage.getBody());
                   // System.debug('response2'+response2);  
                    }*/
                   
                }
                
            }else{
                logEntryMsg += '\n An Exception Occurred in ICS_AVM_Live_Chat_Agent_Controller \n';
                String strInvocationID ='ICS_AVM_ConsumingAvaamoData_Helper '+'getRequest_APIGEE '+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS')
                    + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
                String StrDetails= logEntryMsg +'\n Trace Information : '+'STATUS:'+ response.getStatus() + + '\nSTATUS_CODE:' + response.getStatusCode() + '\n Message:' + response.toString()+'\n Response Body: '+response.getBody();
                String logId = Core_Log_Entry.logEntryWithDetails(strInvocationID,System.Label.ICS_WR_logging_Scope,'getRequest_APIGEE','Critical',response.toString(),StrDetails);
            }
            
        }Catch (Exception e){ 
            System.debug('Exception e'+e.getLineNumber()+e.getMessage());
            String strInvocationID ='ICS_AVM_ConsumingAvaamoData_Helper '+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS') + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
            Core_Log_Entry.logEntryWithException(strInvocationID,System.Label.ICS_WR_logging_Scope,'getRequest_APIGEE','Critical',e.getMessage(),'',e);
        } 
    }
    
}