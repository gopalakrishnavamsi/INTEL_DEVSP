/********************************************************************************************
* Name        : ICS_AVM_Live_Chat_Agent_Controller_Test 
* Author      : Nikhil Patil - Popcornapps
* Date created: 07 - July - 2021
* Description : Rest API to initiate agent live chat 
*                
* Date              Created By                    User-Story   
* 07/07/2021        Popcornapps                   
* ******************************************************************************************/
@isTest 
public class ICS_AVM_Live_Chat_Agent_Controller_Test {
    
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
    
    public class RestMockGetAccessTokenNegativeCase implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            
            String strBody='{"access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6ImppYk5ia0ZTU2JteFBZck45Q0ZxUms0SzRndyJ9.eyJhdWQiOiIwMDAzMWYxNC0wNzM1LTQ5MzktYTkyNS1mMjU1YjFjNTE3YjMiLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vNDZjOThkODgtZTM0NC00ZWQ0LTg0OTYtNGVkNzcxMmUyNTVkL3YyLjAiLCJpYXQiOjE1OTg4NTYwMzIsIm5iZiI6MTU5ODg1NjAzMiwiZXhwIjoxNTk4ODU5OTMyLCJhaW8iOiJFMkJnWUVoVW5TSVZmS0dSbDFWVGZxL1VwRlJWQUE9PSIsImF6cCI6IjAwMDMxZjE0LTA3MzUtNDkzOS1hOTI1LWYyNTViMWM1MTdiMyIsImF6cGFjciI6IjEiLCJvaWQiOiI0","token_type":"Bearer","expires_in":"3599","ext_expires_in":"3599"}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(strBody);
            res.setStatusCode(201);
            return res;
        }
    }
    
    public class RestMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String url = 'https://apis-stage.intel.com/m2r/live-agent/v1/messages?per_page=100&uuid=12345';
            String strBody='{"current_page":1,"per_page":100,"total_entries":1507,"total_pages":16,"time_token":1625461872.4074807,"entries":[{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"text","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"quick_reply","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"list_view","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"directive","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"command","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}},{"uuid":"43c589f1-d502-4936-b52d-8eac0ede17b1","content":"HI ","content_type":"Text","created_at":1625461872.3422961,"user":{"first_name":"Ask Intel","last_name":"","layer_id":"db4df5da-160a-4c59-8b21-267b50ef1a2f","email":null,"phone":null,"avatar":true,"avatar_updated_at":1607339920.0,"avaamo_id":2031156},"timetoken":1625461872330785,"external_source":null,"device_uuid":"8ec59c19-0eaf-444f-9ea3-a364649a801e","request_message_uuid":null,"sequence":null,"custom_properties":{"custom_live_agent":true},"agent_message_uuid":null,"conversation":{"uuid":"a7599855a6a55b06856da7e99add5a54","mode":false,"display_name":"Ask Intel,Nikhil","locale":null}}]}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            req.setEndpoint(url);
            res.setBody(strBody);
            res.setStatusCode(200);
            return res;
        }
    }
    
    public class RestMockPut implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            
            String strBody='{"message": {"uuid": "0db6e0db-1205-4243-98e4-151fea97189b","content": "Ok, Have a nice day. I am closing this. Anypoint of time, you can reach out by typing ", "content_type": "text","created_at": 1619450388.107976}}';
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
            HttpCalloutMock mock = requests.get(req.getEndpoint());
            if (mock != null) {
                return mock.respond(req);
            }
            return mock.respond(req);
        }
        
        public void addRequestMock(String url, HttpCalloutMock mock) {
            requests.put(url, mock);
        }
    }
    
    @isTest
    static void onWorkAcceptedCntr4()
    {
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chatTrans = new LiveChatTranscript();
        chatTrans.ICS_AVM_ConversationUUID__c ='12345';
        chatTrans.LiveChatVisitorId = visitor.Id;
        
        insert chatTrans;
        ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id); // to cover catch block 
        
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        
        RestMockGetAccessTokenPositiveCase res1 = new RestMockGetAccessTokenPositiveCase();
        RestMock res2 = new RestMock();
        
        Map<String, HttpCalloutMock> endpoint2TestResp =   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('https://apis-stage.intel.com/v1/auth/token',res1);
        endpoint2TestResp.put('https://apis-stage.intel.com/m2r/live-agent/v1/messages?per_page=100&uuid=12345',res2);
        
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        
        Test.setMock(HttpCalloutMock.class, multiCalloutMock); 
        ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id);
        
    }
    
    @isTest
    static void onWorkAcceptedCntr5()
    {
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chatTrans = new LiveChatTranscript();
        chatTrans.ICS_AVM_ConversationUUID__c ='12345';
        chatTrans.LiveChatVisitorId = visitor.Id;
        insert chatTrans;
        ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id); // to cover catch block 
        
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        
        RestMockGetAccessTokenPositiveCase res1 = new RestMockGetAccessTokenPositiveCase();
        RestMockPut res2 = new RestMockPut();
        
        Map<String, HttpCalloutMock> endpoint2TestResp =   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(System.Label.ICS_AVM_OAuthTokenUrl,res1);
        endpoint2TestResp.put(System.Label.ICS_AVM_APIGEE_Chat_Transcript_Url+'12345',res2);
        
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        
        Test.setMock(HttpCalloutMock.class, multiCalloutMock); 
        ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id);
        
        
    }
    
    @isTest
    static void onAgentSendCntr()
    {
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chatTrans = new LiveChatTranscript();
        chatTrans.ICS_AVM_ConversationUUID__c ='12345';
        chatTrans.LiveChatVisitorId = visitor.Id;
        insert chatTrans;
        ICS_AVM_Live_Chat_Agent_Controller.onAgentSendCntr('hi',chatTrans.Id); // to cover catch block 
        
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        
        Test.setMock(HttpCalloutMock.class, new RestMock()); 
        ICS_AVM_Live_Chat_Agent_Controller.onAgentSendCntr('hi',chatTrans.Id);
        
    }
    
    @isTest
    static void onAgentSendCntr1()
    {
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chatTrans = new LiveChatTranscript();
        chatTrans.ICS_AVM_ConversationUUID__c ='12345';
        chatTrans.LiveChatVisitorId = visitor.Id;
        insert chatTrans;
        ICS_AVM_Live_Chat_Agent_Controller.onAgentSendCntr('hi',chatTrans.Id); // to cover catch block 
        
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        Test.setMock(HttpCalloutMock.class, new RestMockGetAccessTokenPositiveCase()); 
        ICS_AVM_Live_Chat_Agent_Controller.onAgentSendCntr('hi',chatTrans.Id);
    }
    
    @isTest
    static void onWorkAcceptedCntr()
    {
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chatTrans = new LiveChatTranscript();
        chatTrans.ICS_AVM_ConversationUUID__c ='123456';
        chatTrans.LiveChatVisitorId = visitor.Id;
        //chatTrans.ICS_AVM_AffinityToken__c = System.Label.ICS_AVM_Live_Agent_Access_Token;
        //chatTrans.ICS_AVM_Key__c = 'trdywd';
        
        insert chatTrans;
        ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id); // to cover catch block 
        
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        
        Test.setMock(HttpCalloutMock.class, new RestMock()); 
        ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id);
        
    }
    
    @isTest
    static void onWorkAcceptedCntr1()
    {
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chatTrans = new LiveChatTranscript();
        chatTrans.ICS_AVM_ConversationUUID__c ='12345';
        chatTrans.LiveChatVisitorId = visitor.Id;
        insert chatTrans;
        ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id); // to cover catch block 
        
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        
        Test.setMock(HttpCalloutMock.class, new RestMockPut()); 
        ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id);
    }
    
    @isTest
    static void onWorkAcceptedCntr2()
    {
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chatTrans = new LiveChatTranscript();
        chatTrans.ICS_AVM_ConversationUUID__c ='12345';
        chatTrans.LiveChatVisitorId = visitor.Id;
        insert chatTrans;
        ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id); // to cover catch block 
        
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        
        Test.setMock(HttpCalloutMock.class, new RestMockGetAccessTokenPositiveCase()); 
        ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id);
    }
    
    @isTest
    static void onWorkAcceptedCntr3()
    {
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chatTrans = new LiveChatTranscript();
        chatTrans.ICS_AVM_ConversationUUID__c ='12345';
        chatTrans.LiveChatVisitorId = visitor.Id;
        insert chatTrans;
        ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id); // to cover catch block 
        
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        
        Test.setMock(HttpCalloutMock.class, new RestMockGetAccessTokenNegativeCase()); 
        ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id);
    }
    
    @isTest
    static void onChatEndedCntr()
    {
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chatTrans = new LiveChatTranscript();
        chatTrans.ICS_AVM_ConversationUUID__c ='12345';
        chatTrans.LiveChatVisitorId = visitor.Id;
        insert chatTrans;
        ICS_AVM_Live_Chat_Agent_Controller.onChatEndedCntr('hi',chatTrans.Id); // to cover catch block 
        
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        
        Test.setMock(HttpCalloutMock.class, new RestMock()); 
        ICS_AVM_Live_Chat_Agent_Controller.onChatEndedCntr('hi',chatTrans.Id);
        
    }
    
    @isTest
    static void onChatEndedCntr1()
    {
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chatTrans = new LiveChatTranscript();
        chatTrans.ICS_AVM_ConversationUUID__c ='12345';
        chatTrans.LiveChatVisitorId = visitor.Id;
        insert chatTrans;
        ICS_AVM_Live_Chat_Agent_Controller.onChatEndedCntr('hi',chatTrans.Id); // to cover catch block 
        
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        
        Test.setMock(HttpCalloutMock.class, new RestMockGetAccessTokenPositiveCase()); 
        ICS_AVM_Live_Chat_Agent_Controller.onChatEndedCntr('hi',chatTrans.Id);
    }
    //sai created new method
    @isTest
    static void onWorkAcceptedCntr6()
    {
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        LiveChatTranscript chatTrans = new LiveChatTranscript();
   
        //LiveChatTranscript  chatTrans1 = new LiveChatTranscript();
        chatTrans.ICS_AVM_ConversationUUID__c = '12345';
        chatTrans.LiveChatVisitorId = visitor.Id;
        chatTrans.ICS_AVM_AffinityToken__c = '';
        chatTrans.Email__c = '';
        chatTrans.ICS_AVM_Key__c = '';
        insert chatTrans;
        
		//Test.startTest();
 
        ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id); // to cover catch block 
       
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        
        Test.setMock(HttpCalloutMock.class, new RestMock()); 
        ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id);
        //ICS_AVM_Live_Chat_Agent_Controller.getRequest_APIGEE();
        //Test.stopTest();
        
    }
}