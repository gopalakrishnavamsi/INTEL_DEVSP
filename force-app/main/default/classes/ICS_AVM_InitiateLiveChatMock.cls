/********************************************************************************************
* Name        : ICS_AVM_InitiateLiveChatMock 
* Author      : Priyabhavana - Popcornapps
* Date created: 27 - April - 2021
* Description : Mock call to hit API in ICS_AVM_RestAPIforLiveChat_Handler 
*                
* Date              Created By                    User-Story   
* 27/04/2021        Popcornapps                   US951752
* ******************************************************************************************/
@isTest
global class ICS_AVM_InitiateLiveChatMock implements HttpCalloutMock{
    global HttpResponse respond(HTTPRequest req){
      String json = '{'+
                   '\"key\":\"596ff0f6-96cd-4aad-9184-38a5d3\",'+
                   '\"id\":\"596ff0f6-96cd-4aad-9184-38a5d3\",'+
                   '\"clientPollTimeout\":40,'+
                   '\"affinityToken\":\"JohnDoe\"'+
                   '}'; 
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    res.setHeader('Content-Type', 'application/json');
    res.setBody(json);
    return res;
  } 
}