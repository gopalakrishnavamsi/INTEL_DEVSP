/********************************************************************************************
* Name        : ICS_AVM_APItoCheckAgentAvail_V1_0
* Test class  : ICS_AVM_APItoCheckAgentAvail_Test
* Author      : Priyabhavana - Popcornapps
* Date created: 23 - April - 2021
* Description : Rest API to initiate agent live chat 
*                
* Date              Created By                    User-Story   
* 23/04/2021        Popcornapps                   US951697
* ******************************************************************************************/

@RestResource(urlMapping='/liveagent/v1.0/chat/*/*/checkagentavailability')
global with sharing class ICS_AVM_APItoCheckAgentAvail_V1_0 {
    @HttpGet
    global static ICS_AVM_APItoCheckAgentAvail_Handler.ResponseWrapper checkAgentAvailability() {
        RestRequest req = RestContext.request;
        return ICS_AVM_APItoCheckAgentAvail_Handler.checkLiveAgentAvailabilityHandler(req);
    }   
}