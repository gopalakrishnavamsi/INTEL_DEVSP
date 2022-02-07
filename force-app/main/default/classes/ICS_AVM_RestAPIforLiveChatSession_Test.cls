/********************************************************************************************
* Name        : ICS_AVM_RestAPIforLiveChatSession_Test 
* Author      : Nikhil Patil - Popcornapps
* Date created: 2 - July - 2021
* Description : Rest API to extend the session 
*                
* Date              Created By                    User-Story   
* 22/04/2021        Popcornapps                   US951752
* ******************************************************************************************/
@isTest
public class ICS_AVM_RestAPIforLiveChatSession_Test {
    
    @TestSetup 
    static void setup() {
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chatTrans = new LiveChatTranscript();
        chatTrans.ICS_AVM_ConversationUUID__c ='12345';
        chatTrans.LiveChatVisitorId = visitor.Id;
        chatTrans.ICS_AVM_AffinityToken__c = 'ICSAVMAffinityTokenc';
        chatTrans.ICS_AVM_Key__c = 'ICSAVMKeyc';
        chatTrans.ICS_AVM_Poll_Apigee_Token__c = 'ICSAVMPollApigeeTokenc';
        chatTrans.status = 'InProgress';
        insert chatTrans;
        
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;    
    }
    
    public class RestMockGetAccessTokenPositiveCase implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            
            String strBody='{"access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6ImppYk5ia0ZTU2JteFBZck45Q0ZxUms0SzRndyJ9.eyJhdWQiOiIwMDAzMWYxNC0wNzM1LTQ5MzktYTkyNS1mMjU1YjFjNTE3YjMiLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vNDZjOThkODgtZTM0NC00ZWQ0LTg0OTYtNGVkNzcxMmUyNTVkL3YyLjAiLCJpYXQiOjE1OTg4NTYwMzIsIm5iZiI6MTU5ODg1NjAzMiwiZXhwIjoxNTk4ODU5OTMyLCJhaW8iOiJFMkJnWUVoVW5TSVZmS0dSbDFWVGZxL1VwRlJWQUE9PSIsImF6cCI6IjAwMDMxZjE0LTA3MzUtNDkzOS1hOTI1LWYyNTViMWM1MTdiMyIsImF6cGFjciI6IjEiLCJvaWQiOiI0","token_type":"Bearer","expires_in":"3599","ext_expires_in":"3599"}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(strBody);
            res.setStatusCode(200);
            return res;
        }
    }
    public class RestMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String strBody='{"current_page":1,"per_page":100,"total_entries":1507,"total_pages":16,"time_token":1625461872.4074807,"entries":[{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"text","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"quick_reply","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"list_view","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"directive","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"command","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"Text","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}}]}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(strBody);
            res.setStatusCode(500);
            return res;
        }
    }
    public class RestMockPost implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String strBody='{"current_page":1,"per_page":100,"total_entries":1507,"total_pages":16,"time_token":1625461872.4074807,"entries":[{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"text","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"quick_reply","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"list_view","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"directive","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"command","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"Text","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}}]}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(strBody);
            res.setStatusCode(201);
            return res;
        }
    }
    public class MultiRequestMock implements HttpCalloutMock {
        Map<String, HttpCalloutMock> requests;
        
        public MultiRequestMock(Map<String, HttpCalloutMock> requests) {
            this.requests = requests;
        }
        public HTTPResponse respond(HTTPRequest req) {
            system.debug('req.getEndpoint() ==> '+req.getEndpoint());
            HttpCalloutMock mock = requests.get(req.getEndpoint());
            if (mock != null) {
                return mock.respond(req);
            }
            return mock.respond(req);
           // return null;
        }        
        public void addRequestMock(String url, HttpCalloutMock mock) {
            requests.put(url, mock);
        }
    }
    
    @isTest
    static void onWorkAcceptedCntr4()
    {        
        Test.startTest();
     RestRequest request = new RestRequest();
     request.requestUri = System.Label.ICS_AVM_RestAPIforLiveChatSessionUrl + 'ICSAVMPollApigeeTokenc';
     request.httpMethod = 'GET';
     RestContext.request = request;
     
     RestMockGetAccessTokenPositiveCase res1 = new RestMockGetAccessTokenPositiveCase();
     RestMock res2 = new RestMock();
     RestMockPost res3 = new RestMockPost();
     
     Map<String, HttpCalloutMock> endpoint2TestResp =   new Map<String,HttpCalloutMock>();
     endpoint2TestResp.put(System.Label.ICS_AVM_OAuthTokenUrl,res1);
     endpoint2TestResp.put(System.Label.ICS_AVM_StandardAPIToExtendTheSession,res2);
     endpoint2TestResp.put(ICS_APIGEE_ConfigSettings__c.getInstance(System.Label.ICS_AVM_Avaamo).setEndPointURL__c+'?access_token%12345',res3);

     HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
     
     Test.setMock(HttpCalloutMock.class, multiCalloutMock); 
     ICS_AVM_RestRequestandResWrapper.SessionResponseWrapper res = ICS_AVM_RestAPIforLiveChatSess_Handler.callLiveAgentHandlerGet( RestContext.request);
     //  ICS_AVM_RestRequestandResWrapper.SessionResponseWrapper res = ICS_AVM_RestAPIforLiveChatSession_V1_0.callLiveAgent();
     
        Test.stopTest();
    }
    
    static testMethod void testLiveChatIniatiation(){
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chatTrans = new LiveChatTranscript();
        chatTrans.ICS_AVM_ConversationUUID__c ='12345';
        chatTrans.LiveChatVisitorId = visitor.Id;
        chatTrans.ICS_AVM_AffinityToken__c = 'ICSAVMAffinityTokenc';
        chatTrans.ICS_AVM_Key__c = 'ICSAVMKeyc';
        chatTrans.ICS_AVM_Poll_Apigee_Token__c = 'ICSAVMPollApigeeTokenc';
        chatTrans.status = 'InProgress';
        insert chatTrans;
        
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri =  System.Label.ICS_AVM_RestAPIforLiveChatSessionUrl + 'ICSAVMPollApigeeTokenc';
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        Test.setMock(HttpCalloutMock.class, new RestMockGetAccessTokenPositiveCase()); 
        ICS_AVM_RestRequestandResWrapper.SessionResponseWrapper res = ICS_AVM_RestAPIforLiveChatSession_V1_0.callLiveAgent();
        System.assertEquals(true, res.success);
        Test.stopTest();
    }
}