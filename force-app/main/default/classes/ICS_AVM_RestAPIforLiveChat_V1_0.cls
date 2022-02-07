/********************************************************************************************
* Name        : ICS_AVM_RestAPIforLiveChat_V1_0
* Test class  : 
* Author      : Priyabhavana - Popcornapps
* Date created: 23 - April - 2021
* Description : Rest API to initiate agent live chat 
*                
* Date              Created By                    User-Story   
* 23/04/2021        Popcornapps                   US951752
* ******************************************************************************************/
@RestResource(urlMapping='/liveagent/v1.0/chat/connectliveagent/*')
global  with sharing class ICS_AVM_RestAPIforLiveChat_V1_0 {
    @HttpPost
    global static ICS_AVM_RestRequestandResWrapper.ResponseWrapper callLiveAgent() {
        RestRequest req = RestContext.request;
        return ICS_AVM_RestAPIforLiveChat_Handler.callLiveAgentHandler(req);
    }   
}