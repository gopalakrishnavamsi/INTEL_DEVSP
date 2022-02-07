/********************************************************************************************
* Name        : ICS_AVM_RestAPIforLiveChat_Handler
* Test class  : ICS_AVM_RestAPIforLiveChat_Test
* Author      : Priyabhavana - Popcornapps
* Date created: 19 - March - 2021
* Description : Rest API to initiate agent live chat 
*                
* Date              Created By                    User-Story   
* 19/03/2021        Popcornapps                   US574496/US951752
* ******************************************************************************************/

public with sharing class ICS_AVM_RestAPIforLiveChat_Handler {
    
    private static String buttonId;
    private static String deploymentId;
    private static String converstaionUUID;
    private static String chatBotTranscript;
    private static String email;
    private static Boolean isNewChatRequest = false;
    private static Boolean isAvaamoUser = false;
    private static Map<String,String> sessionIdFields = new Map<String,String>();
    
    /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method: callLiveAgent()
* ────────────────────────────────────────────────────────────────────────────────────────────────
* @ DESCRIPTION (get json body from http context, process data fields, initiate chat)
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    /*15-July 2021 -Static code voilation: The method 'callLiveAgentHandler' has a Cyclomatic Complexity of 14.
     * Cant be resolved because of multiple business logics need to be handled in same call*/
    public static ICS_AVM_RestRequestandResWrapper.ResponseWrapper callLiveAgentHandler(RestRequest request){
        Blob bodyFromApigee1 = request.requestBody;
        String jsonStringFromApigee1 = bodyFromApigee1.toString();
        List<LiveChatTranscript> objLiveChatTranscript = new List<LiveChatTranscript>();
        ICS_AVM_RestRequestandResWrapper.ResponseWrapper postResponse = new ICS_AVM_RestRequestandResWrapper.ResponseWrapper();
        try{
            if( bodyFromApigee1.size()>0 ){
                ICS_AVM_LiveAPIRequestWrapper liveChatRequestWrapper = new ICS_AVM_LiveAPIRequestWrapper();
                liveChatRequestWrapper = ICS_AVM_LiveAPIRequestWrapper.parse(jsonStringFromApigee1);
                converstaionUUID = liveChatRequestWrapper.Event.Conversation.uuid;
                isAvaamoUser = true;
                if(liveChatRequestWrapper.Event.event_type == 'user_message'){
                    system.debug('inside new message ==> ');
                    ICS_AVM_LiveAPIPutRequestWrapper SessionWrapper =  new ICS_AVM_LiveAPIPutRequestWrapper();
                    SessionWrapper = (ICS_AVM_LiveAPIPutRequestWrapper) System.JSON.deserialize(jsonStringFromApigee1, ICS_AVM_LiveAPIPutRequestWrapper.class);
                   objLiveChatTranscript = [SELECT Id, Name, Body, ICS_AVM_ConversationUUID__c, ICS_AVM_AffinityToken__c, ICS_AVM_Key__c FROM LiveChatTranscript WHERE status = 'InProgress' AND  ICS_AVM_ConversationUUID__c =: converstaionUUID ORDER BY CreatedDate DESC LIMIT 1];
                  if(objLiveChatTranscript.size() > 0 && String.isNotBlank(objLiveChatTranscript[0].ICS_AVM_AffinityToken__c) && String.isNotBlank(objLiveChatTranscript[0].ICS_AVM_Key__c)){
                       postResponse = inProgressChat(objLiveChatTranscript[0].ICS_AVM_AffinityToken__c ,objLiveChatTranscript[0].ICS_AVM_Key__c,SessionWrapper.event.message.content );
                    }else{
                         postMessandEndChatOnException(converstaionUUID);
                         postResponse = ICS_AVM_RestRequestandResWrapper.processErrorResponse('Chat Ended 403 ', '403');
                    }
                    
                }if(liveChatRequestWrapper.Event.event_type == 'chat_terminated'){
                    objLiveChatTranscript = [SELECT Id, Name, Body, ICS_AVM_ConversationUUID__c, ICS_AVM_AffinityToken__c, ICS_AVM_Key__c FROM LiveChatTranscript WHERE status = 'InProgress' AND  ICS_AVM_ConversationUUID__c =: converstaionUUID ORDER BY CreatedDate DESC LIMIT 1];
                    List<ICS_AVM_Chat_Session_Detail__c> det = [Select id, ICS_AVM_AffinityToken__c, ICS_AVM_Key__c from ICS_AVM_Chat_Session_Detail__c where ICS_AVM_ConversationUUID__c =: converstaionUUID order by CreatedDate  DESC limit 1];
                        
                    if(objLiveChatTranscript.size() > 0 && String.isNotBlank(objLiveChatTranscript[0].ICS_AVM_AffinityToken__c) && String.isNotBlank(objLiveChatTranscript[0].ICS_AVM_Key__c)){
                        postResponse =  endChat(objLiveChatTranscript[0].ICS_AVM_AffinityToken__c ,objLiveChatTranscript[0].ICS_AVM_Key__c,'agent' );
                        
                    }if(det.size() > 0){
                        postResponse =  endChat(det[0].ICS_AVM_AffinityToken__c , det[0].ICS_AVM_Key__c, 'agent' );
                    }
                    if(objLiveChatTranscript.size()== 0 && det.size() == 0){
                        postMessandEndChatOnException(converstaionUUID);
                        postResponse = ICS_AVM_RestRequestandResWrapper.processErrorResponse('Chat Ended 403 ', '403');
                    }  
                    
                }if(liveChatRequestWrapper.Event.event_type == System.Label.ICS_AVM_NewChatRequest){
                    system.debug('inside new req ==> ');
                    String restAPIURLToGetSession = System.Label.ICS_AVM_StandardAPIToGetLiveAgentSession;
                    HttpRequest httpRequest = new HttpRequest();
                    httpRequest.setMethod('GET');
                    httpRequest.setHeader('X-LIVEAGENT-AFFINITY', 'null');
                    httpRequest.setHeader('X-LIVEAGENT-API-VERSION', System.Label.ICS_AVM_APIVersion);
                    httpRequest.setEndpoint(restAPIURLToGetSession);
                    String response = '';
                    
                    Blob bodyFromApigee = request.requestBody;
                    String jsonStringFromApigee = bodyFromApigee.toString();
                    if( bodyFromApigee.size()>0 ){
                        processLiveAPIRequestWrapper(jsonStringFromApigee); 
                    }
                    Http httpToGetSession = new Http();
                    HttpResponse httpResponseOfSession = httpToGetSession.send(httpRequest);
                    if( httpResponseOfSession.getStatusCode() == 200 ){
                        system.debug('inside new message success  ');
                        response = JSON.serializePretty( JSON.deserializeUntyped(httpResponseOfSession.getBody()));
                    String apigeeEndPointURL1 = System.Label.ICS_AVM_APIGEE_Chat_Transcript_Url + converstaionUUID;
                    getRequest_APIGEE(apigeeEndPointURL1); 
                        getSessionDetails(response);
                        postResponse = ICS_AVM_RestRequestandResWrapper.processSucesssResponse(System.Label.ICS_AVM_SuccessMessageOnChatInitiation,'200');
                       
                    } else {
                        system.debug('inside new message exception ++> '+httpResponseOfSession.getBody());
                        throw new CalloutException( httpResponseOfSession.getBody() ); 
                    } 
                }
            }
        }catch(Exception ex){system.debug('inside new message exception==>   '+ex);
            if(isAvaamoUser == true){
                Core_Log_Entry.logEntryWithException('ICS_AVM_RestAPIforLiveChat_Handler',System.Label.ICS_WR_logging_Scope,'ICS_AVM_RestAPIforLiveChat_Handler.callLiveAgentHandler','Critical',ex.getMessage(),'',ex);
                postMessandEndChatOnException(converstaionUUID);
                postResponse = ICS_AVM_RestRequestandResWrapper.processErrorResponse(ex.getMessage(), '500');
            }
        }
        return postResponse;
    }
    
    
    /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method: processLiveAPIRequestWrapper(String jsonStringFromApigee)
* ────────────────────────────────────────────────────────────────────────────────────────────────
* @param    jsonStringFromApigee
* @return   --  DESCRIPTION (get json body from http context and process data fields)
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    static void processLiveAPIRequestWrapper(String jsonStringFromApigee){
        ICS_AVM_LiveAPIRequestWrapper liveChatRequestWrapper = new ICS_AVM_LiveAPIRequestWrapper();
        liveChatRequestWrapper = ICS_AVM_LiveAPIRequestWrapper.parse(jsonStringFromApigee);
        converstaionUUID = liveChatRequestWrapper.Event.Conversation.uuid;
        if(liveChatRequestWrapper.Event.event_type == System.Label.ICS_AVM_NewChatRequest){
            isNewChatRequest = true;   
            ICS_AVM_ChatButtonsUtil chatButtonUtil = new ICS_AVM_ChatButtonsUtil();
            ICS_AVM_ChatButtonsUtil.ChatandDeploymentIdWrapper chatandDepIdWrap = new ICS_AVM_ChatButtonsUtil.ChatandDeploymentIdWrapper();
            email = (liveChatRequestWrapper.event.user.custom_properties.email!=null && liveChatRequestWrapper.event.user.custom_properties.email!='') ? liveChatRequestWrapper.event.user.custom_properties.email : liveChatRequestWrapper.event.user.custom_properties.anon_email;
            chatandDepIdWrap = chatButtonUtil.processEPMIdAndLanguage(liveChatRequestWrapper.event.user.custom_properties.productCategoryId,liveChatRequestWrapper.event.user.custom_properties.locale);
            buttonId = chatandDepIdWrap.chatButtonId;
            deploymentId = chatandDepIdWrap.deploymentId;   
        }
    }
    
    /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method: getSessionDetails(String response)
* ────────────────────────────────────────────────────────────────────────────────────────────────
* @param    response
* @return   --  DESCRIPTION (get session details from response body of '/chat/rest/System/SessionId' api)
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    static void getSessionDetails(String response){
        try{
        if(isNewChatRequest == true && String.isNotBlank(response)){
            sessionIdFields = (Map<String,String>)JSON.deserialize(response, Map<String,String>.class);
        }
        if(String.isNotBlank(sessionIdFields.get('key')) && String.isNotBlank(sessionIdFields.get('id'))
           && String.isNotBlank(sessionIdFields.get('affinityToken'))){
               initiateChat();
                  ICS_AVM_Chat_Session_Detail__c endChatDetails = new ICS_AVM_Chat_Session_Detail__c();
               endChatDetails.ICS_AVM_AffinityToken__c = sessionIdFields.get('affinityToken');
                   endChatDetails.ICS_AVM_Key__c = sessionIdFields.get('key');
                   endChatDetails.ICS_AVM_ConversationUUID__c = converstaionUUID;
                   upsert endChatDetails ICS_AVM_ConversationUUID__c;
           }
        }catch(exception e){
            system.debug('inside exception e ==> '+e);
        }
    }
    
    /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method: initiateChat()
* ────────────────────────────────────────────────────────────────────────────────────────────────
* @param    --
* @return   --  DESCRIPTION (initiate chat by callig api )
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    static void initiateChat(){
        String restAPIURLToInitiateChat = System.Label.ICS_AVM_StandardAPIToInitiateLiveChat;
        HttpRequest reqToInitiateChat = new HttpRequest();
        HttpResponse chatInitiateResponse = new HttpResponse();
        Http httpToInitiateChat = new Http();
        String chatBody = prepareBody(sessionIdFields);
        reqToInitiateChat.setEndpoint(restAPIURLToInitiateChat);
        reqToInitiateChat.setMethod('POST');
        reqToInitiateChat.setHeader('X-LIVEAGENT-AFFINITY', sessionIdFields.get('affinityToken'));
        reqToInitiateChat.setHeader('X-LIVEAGENT-API-VERSION', System.Label.ICS_AVM_APIVersion);
        reqToInitiateChat.setHeader('Content-Type', 'application/json');
        reqToInitiateChat.setHeader('Content-Length', String.valueOf(chatBody.length()));
        reqToInitiateChat.setHeader('X-LIVEAGENT-SESSION-KEY', sessionIdFields.get('key'));
        reqToInitiateChat.setHeader('X-LIVEAGENT-SEQUENCE', '1');
        reqToInitiateChat.setBody(chatBody);
        chatInitiateResponse = httpToInitiateChat.send(reqToInitiateChat);
    }
    /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method: inProgressChat()
* ────────────────────────────────────────────────────────────────────────────────────────────────
* @param    --
* @return   --  DESCRIPTION (Send message to agent by callig api )
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    
    public static ICS_AVM_RestRequestandResWrapper.ResponseWrapper inProgressChat(String affinityToken ,String key, String content){
        ICS_AVM_RestRequestandResWrapper.ResponseWrapper postResponse = new  ICS_AVM_RestRequestandResWrapper.ResponseWrapper();
        String restAPIURLToInitiateChat = System.Label.ICS_AVM_StandardAPIToSendMessageToLiveAgent;
        HttpRequest reqToProcessChat = new HttpRequest();
        HttpResponse chatInProgressResponse = new HttpResponse();
        Try{
            Http httpToProcessChat = new Http();
            if(content == 'Testing US1017144'){
                throw new ICS_AVM_Exception('Exception from method:inProgressChat class:ICS_AVM_RestAPIforLiveChat_Handler'); 
            }
            String chatBody = '{"text":"'+content+ '"}';
            reqToProcessChat.setEndpoint(restAPIURLToInitiateChat);
            reqToProcessChat.setMethod('POST');
            reqToProcessChat.setHeader('X-LIVEAGENT-AFFINITY', affinityToken);
            reqToProcessChat.setHeader('X-LIVEAGENT-API-VERSION', System.Label.ICS_AVM_APIVersion);
            reqToProcessChat.setHeader('X-LIVEAGENT-SESSION-KEY', key);
            reqToProcessChat.setBody(chatBody);
            chatInProgressResponse = httpToProcessChat.send(reqToProcessChat);
             if(chatInProgressResponse.getStatusCode() == 200 ){
                postResponse = ICS_AVM_RestRequestandResWrapper.processSucesssResponse('Live chat message posted successfully ','200');
             }else{
                 postResponse = ICS_AVM_RestRequestandResWrapper.processSucesssResponse('Live chat ended successfully',String.valueOf(chatInProgressResponse.getStatusCode()));
             }
        }catch(Exception e ){
            System.debug('Exception e'+e.getLineNumber()+e.getMessage());
            throw new CalloutException( chatInProgressResponse.getBody() ); 
        }
        return postResponse;
    }
    /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method: endChat()
* ────────────────────────────────────────────────────────────────────────────────────────────────
* @param    --
* @return   --  DESCRIPTION (End chat by callig api )
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    
    public static ICS_AVM_RestRequestandResWrapper.ResponseWrapper endChat(String affinityToken ,String key, String content){
        ICS_AVM_RestRequestandResWrapper.ResponseWrapper postResponse = new  ICS_AVM_RestRequestandResWrapper.ResponseWrapper();
        HttpRequest reqToEndChat = new HttpRequest();
        HttpResponse chatEndResponse = new HttpResponse();
        try { 
            String restAPIURLToEndChat = System.Label.ICS_AVM_StandardAPIToEndChat;
            Http httpToEndChat = new Http();
            String chatBody = '{"reason": "client"}';
            reqToEndChat.setEndpoint(restAPIURLToEndChat);
            reqToEndChat.setMethod('POST');
            reqToEndChat.setHeader('Content-Type', 'application/json');
            reqToEndChat.setHeader('X-LIVEAGENT-AFFINITY', affinityToken);
            reqToEndChat.setHeader('X-LIVEAGENT-API-VERSION', System.Label.ICS_AVM_APIVersion);
            reqToEndChat.setHeader('X-LIVEAGENT-SESSION-KEY', key);
            reqToEndChat.setBody(chatBody);
            chatEndResponse = httpToEndChat.send(reqToEndChat);
            if(chatEndResponse.getStatusCode() == 200 ){
                postResponse = ICS_AVM_RestRequestandResWrapper.processSucesssResponse('Live chat ended successfully 200','200');
            }
        }catch(Exception e ){
            throw new CalloutException( chatEndResponse.getBody() ); 
        }
        return postResponse;
    }
    
     /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method     : getRequest_APIGEE(string url,string recordId)
* ────────────────────────────────────────────────────────────────────────────────────────────────
* Description : This method is used to do a get request to Avaamo to get pre chat via APIGEE. 
*             : Using HTTP callout methods to call external system i.e  APIGEE
*             : passing two param body and url 
* @Param      : String url - URL to set end point
*             : String recordId - LiveChatTranscript obect record id   
* Return Type : void
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    public static void getRequest_APIGEE(string url )
    {//16-07-2021 -- P-2 -- Nikhil Patil -- has Cyclomatic Complexity  -- To check the conditions from list kept if else conditions inside the for loop
      String logEntryMsg = ''; 
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
            String custName = '';
         if(response?.getStatusCode() == 200){  
             fromJSON  rec = new fromJSON();
             rec = (fromJSON) System.JSON.deserialize(response.getbody(), fromJSON.class); 
             
             List<AvaamoMessagesData> avmMsgData = new  List<AvaamoMessagesData>();
             for(cls_entries entries :rec.entries){
                 AvaamoMessagesData avmMsgDataSub = new AvaamoMessagesData();
                 
                 if(entries.content_type == System.Label.ICS_AVM_text){
                     if(entries.content.contains('<!DOCTYPE html>')){
                          avmMsgDataSub.content = 'Text : HTML content' ;
                     }else{
                        avmMsgDataSub.content = entries.content.stripHtmlTags();
                     }                       
                 }
                 else if(entries.content_type == System.Label.ICS_AVM_default_card){
                     cls_attachments att = entries.attachments[0];
                     cls_default_card defCard = att.default_card;
                     avmMsgDataSub.content = defCard.title;//'Default Card : '+ defCard.title ;
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
                 custName =  entries.user.first_name;
                 avmMsgDataSub.first_name = entries.user.first_name ;
                 avmMsgDataSub.layer_id =  entries.user.layer_id ;
                 String unixDatetime = entries.created_at.SubStringBefore('.');
                 
                 Long L1 = long.valueOf(unixDatetime);
                 avmMsgDataSub.created_at = datetime.newinstance(L1 * 1000);
                 avmMsgData.add(avmMsgDataSub);
             }
             str = str +'<span>';
             for(AvaamoMessagesData avmMsgDataVar: avmMsgData){
                 if(avmMsgDataVar.first_name == custName){
                     str = str + '<span style="color:blue;">'+avmMsgDataVar.first_name +'</span>'+ ' : ' + avmMsgDataVar.content + ' ['+avmMsgDataVar.created_at+'] ' +'<br/>';

                 }else{
                     str = str + '<span style="color:red;">'+avmMsgDataVar.first_name +'</span>'+ ' : ' + avmMsgDataVar.content + ' ['+avmMsgDataVar.created_at+'] ' +'<br/>';

                 }
                              }
             str = str +'</span>';
             if(str.length() <  31999){
                 chatBotTranscript = str; 
             }else{
                 chatBotTranscript = str.SubString(0,31999); 
             }
         }else{
             logEntryMsg += '\n An Exception Occurred While calling GET method \n';
             String strInvocationID ='ICS_AVM_ConsumingAvaamoData_Helper '+'getRequest_APIGEE '+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS')
                 + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
             String StrDetails= logEntryMsg +'\n Trace Information : '+'STATUS:'+ response.getStatus() + + '\nSTATUS_CODE:' + response.getStatusCode() + '\n Message:' + response.toString()+'\n Response Body: '+response.getBody();
             String logId = Core_Log_Entry.logEntryWithDetails(strInvocationID,System.Label.ICS_WR_logging_Scope,'getRequest_APIGEE','Critical',response.toString(),StrDetails);
         }
         
        }Catch (Exception e){ 
            String strInvocationID ='ICS_AVM_ConsumingAvaamoData_Helper '+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS') + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
            Core_Log_Entry.logEntryWithException(strInvocationID,System.Label.ICS_WR_logging_Scope,'getRequest_APIGEE','Critical',e.getMessage(),'',e);
        } 
    }
    
    
    /*───────────────────────────────────────────────────────────────────────────────────────────────┐
* @method: prepareBody(Map<String,String> sessionIdFields)
* ────────────────────────────────────────────────────────────────────────────────────────────────
* @param    Map<String,String> sessionIdFields   
* @return   String    DESCRIPTION (prepare request boby to call chasitor api )
* ───────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    static String prepareBody(Map<String,String> sessionIdFields){
        ChasitorInitWrapper bodyWrapper = new ChasitorInitWrapper();
        bodyWrapper.organizationId =  System.Label.ICS_Salesforce_Org_Id;
        bodyWrapper.deploymentId =  deploymentId;
        bodyWrapper.buttonId =  buttonId;
        bodyWrapper.sessionId =  sessionIdFields.get('id');
        bodyWrapper.userAgent =  'Lynx/2.8.8';
        bodyWrapper.language = 'en-US';
        bodyWrapper.screenResolution = '1900x1080';
        bodyWrapper.prechatDetails = new List<PrechatDetails>();
        PrechatDetails preChatDetail1 = new PrechatDetails();
        preChatDetail1.label = 'affinity';
        preChatDetail1.value = sessionIdFields.get('affinityToken');
        preChatDetail1.transcriptFields = new List<String>{'ICS_AVM_AffinityToken__c'};
        preChatDetail1.displayToAgent = false;
        bodyWrapper.prechatDetails.add(preChatDetail1);
        PrechatDetails preChatDetail2 = new PrechatDetails();
        preChatDetail2.label = 'conversationUUID';
        preChatDetail2.value = converstaionUUID;
        preChatDetail2.transcriptFields = new List<String>{'ICS_AVM_ConversationUUID__c'};
        preChatDetail2.displayToAgent = false;
        bodyWrapper.prechatDetails.add(preChatDetail2);
        PrechatDetails preChatDetail3 = new PrechatDetails();
        preChatDetail3.label = 'key';
        preChatDetail3.value = sessionIdFields.get('key');
        preChatDetail3.transcriptFields = new List<String>{'ICS_AVM_Key__c'};
        preChatDetail3.displayToAgent = false;
        bodyWrapper.prechatDetails.add(preChatDetail3);
        PrechatDetails preChatDetail4 = new PrechatDetails();
        preChatDetail4.label = 'pollToken';
        preChatDetail4.value = String.valueOf(Crypto.getRandomLong());
        preChatDetail4.transcriptFields = new List<String>{'ICS_AVM_Poll_Apigee_Token__c'};
        preChatDetail4.displayToAgent = false;
        bodyWrapper.prechatDetails.add(preChatDetail4);
        PrechatDetails preChatDetail5 = new PrechatDetails();
        preChatDetail5.label = 'email';
        preChatDetail5.value = email;
        preChatDetail5.transcriptFields = new List<String>{'Email__c'};
        preChatDetail5.displayToAgent = false;
        bodyWrapper.prechatDetails.add(preChatDetail5);
        
        PrechatDetails preChatDetail6 = new PrechatDetails();
        preChatDetail6.label = 'AVMChatBotTranscript';
        preChatDetail6.value = chatBotTranscript;
        preChatDetail6.transcriptFields = new List<String>{'ICS_AVM_ChatBot_Transcript__c'};
        preChatDetail6.displayToAgent = false;
        bodyWrapper.prechatDetails.add(preChatDetail6);
               
        bodyWrapper.prechatEntities = new List<PrechatDetails>();
        bodyWrapper.receiveQueueUpdates = true;
        bodyWrapper.isPost = true;
        return json.serialize(bodyWrapper);
    }
    
    
    static void postMessandEndChatOnException(String conversationUUID){
        String content = 'Something went wrong chat ends in few seconds';
        String integrationEndPointURL = ICS_APIGEE_ConfigSettings__c.getInstance(System.Label.ICS_AVM_Avaamo).setEndPointURL__c;
        String avmAccessToken = System.Label.ICS_AVM_Live_Agent_Access_Token;
        String apigeeChatBody =  '{"message":{"conversation":{"uuid":"'+conversationUUID+'"},"content":"'+content+'","content_type":"text"}}';
        String apigeeEndPointURL = integrationEndPointURL+'?access_token='+avmAccessToken;
        ICS_AVM_ConsumingAvaamoData_Helper.postRequest_APIGEE(apigeeChatBody,apigeeEndPointURL);   
        
        String integrationEndPointURLToEndChat = ICS_APIGEE_ConfigSettings__c.getInstance(System.Label.ICS_AVM_Avaamo).setEndPointURL__c;
        String apigeeChatBody2 =  '{"message":{"conversation":{"uuid":"'+conversationUUID+'"},"content":"'+content+'","content_type":"text"}}';
        String apigeeEndPointURL2 = integrationEndPointURLToEndChat+'?access_token='+avmAccessToken+'&uuid='+conversationUUID;
        ICS_AVM_ConsumingAvaamoData_Helper.deleteRequest_APIGEE(apigeeChatBody2,apigeeEndPointURL2);
    }
    
    public class ChasitorInitWrapper{
        public String organizationId;
        public String deploymentId;
        public String buttonId;
        public String sessionId;
        public String userAgent;
        public String language;
        public String screenResolution;
        public List<PrechatDetails> prechatDetails;
        public List<PrechatDetails> prechatEntities;
        public Boolean receiveQueueUpdates;
        public Boolean isPost;
    }
    
    public class PrechatDetails {
        public String label;
        public String value;
        public List<String> transcriptFields;
        public Boolean displayToAgent;
    }
    
    public class getSessionWrapper{
        public cls_messages[] messages;
        public Integer sequence;	
        public Integer offset;	
    }
    
    public class cls_messages {
        public String type;	
        public cls_message message;
    }
    class cls_message {
        public Integer connectionTimeout;	
        public Integer estimatedWaitTime;	
        public cls_sensitiveDataRules[] sensitiveDataRules;
        public boolean transcriptSaveEnabled;
        public String url;	//
        public Integer queuePosition;	
        public cls_customDetails[] customDetails;
        public String visitorId;	
        public cls_geoLocation geoLocation;
    }
    class cls_sensitiveDataRules {
    }
    class cls_customDetails {
    }
    class cls_geoLocation {
        public String organization;	
        public String region;	
        public String city;	
        public String countryName;	
        public Double latitude;
        public String countryCode;	
        public Double longitude;	
    }
    
    public class ICS_AVM_LiveAPIPutRequestWrapper{
        public cls_event event;
        
    }
    class cls_event {
        public String uuid;	
        public String event_type;	
        public Double created_at;	
        public cls_conversation conversation;
        public cls_message1 message;
    }
    class cls_conversation {
        public String uuid;	
        public String display_name;	
    }
    class cls_message1 {
        public String uuid;	
        public String content;	
        public String content_type;	
        public Double created_at;	
    }
    // JSone for caht transcript
        public class fromJSON{
        public Integer current_page;	
        public Integer per_page;	
        public Integer total_entries;	
        public Integer total_pages;	
        public Double time_token;	
        public cls_entries[] entries;
    }
    public class cls_entries {
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
        public cls_conversation1 conversation;
        public cls_attachments[] attachments;
    }
    public class cls_user {
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
    public class cls_attachments {
        public cls_default_card default_card;
    }
    public class cls_default_card {
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
    class cls_conversation1 {
        public String uuid;	
        public boolean mode;
        public String display_name;	
        public String locale;
    }
     public class AvaamoMessagesData
    {
        public String content{get;set;}
        public String first_name{get;set;}
        public String layer_id{get;set;}
        public datetime  created_at{get;set;}
    }
}