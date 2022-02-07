/********************************************************************************************
* Name        : ICS_AVM_RestAPIforLiveChatSession_V1_0
* Test class  : 
* Author      : NikhilPatil - Popcornapps
* Date created: 31 - May - 2021
* Description : Rest API to initiate agent live chat 
*                
* Date              Created By                    User-Story   
* 31/05/2021        Popcornapps                   US951752
* ******************************************************************************************/
@RestResource(urlMapping='/liveagent/v1.0/status/*')
global with sharing class ICS_AVM_RestAPIforLiveChatSession_V1_0 {
    
    @HttpGet
    global static ICS_AVM_RestRequestandResWrapper.SessionResponseWrapper callLiveAgent(){
        RestRequest req = RestContext.request;
        return ICS_AVM_RestAPIforLiveChatSess_Handler.callLiveAgentHandlerGet(req);
    }  
}