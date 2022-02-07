/********************************************************************************************
* Name        : ICS_AVM_RestAPIforLiveChat_Test 
* Author      : Priyabhavana - Popcornapps
* Date created: 22 - April - 2021
* Description : Rest API to initiate agent live chat 
*                
* Date              Created By                    User-Story   
* 22/04/2021        Popcornapps                   US951752
* ******************************************************************************************/
@isTest
public class ICS_AVM_RestAPIforLiveChat_Test {
    
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
    
    public class MultiRequestMock1 implements HttpCalloutMock {
        Map<String, HttpCalloutMock> requests;
        
        public MultiRequestMock1(Map<String, HttpCalloutMock> requests) {
            this.requests = requests;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            system.debug('req.getEndpoint() ==> '+req.getEndpoint());
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
    
    static testMethod void testLiveChatIniatiation(){
        ICS_AVM_TestDataUtility.createAVMCustomSettings();
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        String json = '{'+
            '   \"event\":{'+
            '   \"uuid\":\"priya-0a76-4fae-a83f-67e7e221dd6b\",'+
            '   \"event_type\":\"new_chat_request\",'+
            '   \"chat_request\":{'+
            '   \"uuid\":\"priya-0a76-4fae-a83f-67e7e221dd6b\"'+
            '    },'+
            '   \"conversation\":{'+
            '   \"uuid\":\"12326f2ef1ffca9b8903c446a114\",'+
            '   \"display_name\":\"Test - Live Agent,hayata\"'+
            '   },'+
            '   \"bot\":{'+
            '    \"uuid\":\"a13cc8f5-df9c-4a55-96df-972554a27363\",'+
            '    \"display_name\":\"Test - Live Agent\",'+
            '    \"description\":\"Testing Live Agent\"'+
            '    },'+
            '   \"user\":{'+
            '\"first_name\":\"hayata\",'+
            '\"last_name\":null,'+
            '\"email\":null,'+
            '\"custom_properties\":{'+
            '\"meta\":\"John Doe\",'+
            '\"meta1\":\"JohnDoe\",'+
            '\"meta2\":\"JohnDoe\",'+
            '\"authorName\":\"John_Doe\",'+
            '\"locale\":\"en-US\",'+
            '\"productCategoryId\":\"98414\",'+
            '\"desc\":\"processors\",'+
            '\"productnumber\":\"111\"'+
            '},'+
            '\"display_name\":\"hayata \",'+
            '\"layer_id\":\"dashboard_admin_test_user_1583\",'+
            '\"meta\":\"John Doe\",'+
            '\"meta1\":\"JohnDoe\",'+
            '\"meta2\":\"JohnDoe\",'+
            '\"authorName\":\"John_Doe\",'+
            '\"locale\":\"en-us\",'+
            '\"productCategoryId\":\"873\",'+
            '\"desc\":\"processors\",'+
            '\"productnumber\":\"111\",'+
            '\"device\":{'+
            '\"device_uuid\":\"fb8c3f13-28e0-427e-9382-65de6a0283e5\",'+
            '\"channel_name\":\"web\",'+
            '\"last_visited_page\":\"https://www.w3schools.com/\"'+
            '}'+
            '}'+
            '}'+
            '}';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ICS_AVM_InitiateLiveChatMock());
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        ICS_AVM_RestRequestandResWrapper.ResponseWrapper res = ICS_AVM_RestAPIforLiveChat_V1_0.callLiveAgent();
        //System.assertEquals(true, res.success);
        Test.stopTest();
    }
    
    static testMethod void testResponseForMessaging(){
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        ICS_AVM_TestDataUtility.createAVMCustomSettings();
        String json = '{'+
            '   \"event\":{'+
            '   \"uuid\":\"priya-0a76-4fae-a83f-67e7e221dd6b\",'+
            '   \"event_type\":\"user_message\",'+
            '   \"chat_request\":{'+
            '   \"uuid\":\"priya-0a76-4fae-a83f-67e7e221dd6b\"'+
            '    },'+
            '   \"conversation\":{'+
            '   \"uuid\":\"12326f2ef1ffca9b8903c446a114\",'+
            '   \"display_name\":\"Test - Live Agent,hayata\"'+
            '   },'+
            '   \"message\":{'+
            '   \"content\":\"12326f2ef1ffca9b8903c446a114\"'+
            '   },'+
            '   \"bot\":{'+
            '    \"uuid\":\"a13cc8f5-df9c-4a55-96df-972554a27363\",'+
            '    \"display_name\":\"Test - Live Agent\",'+
            '    \"description\":\"Testing Live Agent\"'+
            '    },'+
            '   \"user\":{'+
            '\"first_name\":\"hayata\",'+
            '\"last_name\":null,'+
            '\"email\":null,'+
            '\"custom_properties\":{'+
            '\"meta\":\"John Doe\",'+
            '\"meta1\":\"JohnDoe\",'+
            '\"meta2\":\"JohnDoe\",'+
            '\"authorName\":\"John_Doe\",'+
            '\"locale\":\"en-US\",'+
            '\"productCategoryId\":\"98414\",'+
            '\"desc\":\"processors\",'+
            '\"productnumber\":\"111\"'+
            '},'+
            '\"display_name\":\"hayata \",'+
            '\"layer_id\":\"dashboard_admin_test_user_1583\",'+
            '\"meta\":\"John Doe\",'+
            '\"meta1\":\"JohnDoe\",'+
            '\"meta2\":\"JohnDoe\",'+
            '\"authorName\":\"John_Doe\",'+
            '\"locale\":\"en-us\",'+
            '\"productCategoryId\":\"873\",'+
            '\"desc\":\"processors\",'+
            '\"productnumber\":\"111\",'+
            '\"device\":{'+
            '\"device_uuid\":\"fb8c3f13-28e0-427e-9382-65de6a0283e5\",'+
            '\"channel_name\":\"web\",'+
            '\"last_visited_page\":\"https://www.w3schools.com/\"'+
            '}'+
            '}'+
            '}'+
            '}'; 
        LiveChatTranscript chatTranscript = ICS_AVM_TestDataUtility.createChatTranscript();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ICS_AVM_InitiateLiveChatMock());
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        ICS_AVM_RestRequestandResWrapper.ResponseWrapper res = ICS_AVM_RestAPIforLiveChat_V1_0.callLiveAgent();
        // System.assertEquals(true, res.success);
        Test.stopTest();
    }
    
    static testMethod void testResponseEndChat(){
        ICS_AVM_TestDataUtility.createAVMCustomSettings();
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        String json = '{'+
            '   \"event\":{'+
            '   \"uuid\":\"priya-0a76-4fae-a83f-67e7e221dd6b\",'+
            '   \"event_type\":\"chat_terminated\",'+
            '   \"chat_request\":{'+
            '   \"uuid\":\"priya-0a76-4fae-a83f-67e7e221dd6b\"'+
            '    },'+
            '   \"conversation\":{'+
            '   \"uuid\":\"12326f2ef1ffca9b8903c446a114\",'+
            '   \"display_name\":\"Test - Live Agent,hayata\"'+
            '   },'+
            '   \"message\":{'+
            '   \"content\":\"12326f2ef1ffca9b8903c446a114\"'+
            '   },'+
            '   \"bot\":{'+
            '    \"uuid\":\"a13cc8f5-df9c-4a55-96df-972554a27363\",'+
            '    \"display_name\":\"Test - Live Agent\",'+
            '    \"description\":\"Testing Live Agent\"'+
            '    },'+
            '   \"user\":{'+
            '\"first_name\":\"hayata\",'+
            '\"last_name\":null,'+
            '\"email\":null,'+
            '\"custom_properties\":{'+
            '\"meta\":\"John Doe\",'+
            '\"meta1\":\"JohnDoe\",'+
            '\"meta2\":\"JohnDoe\",'+
            '\"authorName\":\"John_Doe\",'+
            '\"locale\":\"en-US\",'+
            '\"productCategoryId\":\"98414\",'+
            '\"desc\":\"processors\",'+
            '\"productnumber\":\"111\"'+
            '},'+
            '\"display_name\":\"hayata \",'+
            '\"layer_id\":\"dashboard_admin_test_user_1583\",'+
            '\"meta\":\"John Doe\",'+
            '\"meta1\":\"JohnDoe\",'+
            '\"meta2\":\"JohnDoe\",'+
            '\"authorName\":\"John_Doe\",'+
            '\"locale\":\"en-us\",'+
            '\"productCategoryId\":\"873\",'+
            '\"desc\":\"processors\",'+
            '\"productnumber\":\"111\",'+
            '\"device\":{'+
            '\"device_uuid\":\"fb8c3f13-28e0-427e-9382-65de6a0283e5\",'+
            '\"channel_name\":\"web\",'+
            '\"last_visited_page\":\"https://www.w3schools.com/\"'+
            '}'+
            '}'+
            '}'+
            '}'; 
        LiveChatTranscript chatTranscript = ICS_AVM_TestDataUtility.createChatTranscript();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ICS_AVM_InitiateLiveChatMock());
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        ICS_AVM_RestRequestandResWrapper.ResponseWrapper res = ICS_AVM_RestAPIforLiveChat_V1_0.callLiveAgent();
        // System.assertEquals(true, res.success);
        Test.stopTest();
    }
    
    static testMethod void testResponseException(){
        ICS_AVM_TestDataUtility.createAVMCustomSettings();
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        ICS_AVM_TestDataUtility.createApigeeCustomSettings();
        String json = '{'+
            '   \"event\":{'+
            '   \"uuid\":\"priya-0a76-4fae-a83f-67e7e221dd6b\",'+
            '   \"event_type\":\"user_message\",'+
            '   \"chat_request\":{'+
            '   \"uuid\":\"priya-0a76-4fae-a83f-67e7e221dd6b\"'+
            '    },'+
            '   \"conversation\":{'+
            '   \"uuid\":\"12326f2ef1ffca9b8903c446a114\",'+
            '   \"display_name\":\"Test - Live Agent,hayata\"'+
            '   },'+
            '   \"message\":{'+
            '   \"content\":\"Testing US1017144\"'+
            '   },'+
            '   \"bot\":{'+
            '    \"uuid\":\"a13cc8f5-df9c-4a55-96df-972554a27363\",'+
            '    \"display_name\":\"Test - Live Agent\",'+
            '    \"description\":\"Testing Live Agent\"'+
            '    },'+
            '   \"user\":{'+
            '\"first_name\":\"hayata\",'+
            '\"last_name\":null,'+
            '\"email\":null,'+
            '\"custom_properties\":{'+
            '\"meta\":\"John Doe\",'+
            '\"meta1\":\"JohnDoe\",'+
            '\"meta2\":\"JohnDoe\",'+
            '\"authorName\":\"John_Doe\",'+
            '\"locale\":\"en-US\",'+
            '\"productCategoryId\":\"98414\",'+
            '\"desc\":\"processors\",'+
            '\"productnumber\":\"111\"'+
            '},'+
            '\"display_name\":\"hayata \",'+
            '\"layer_id\":\"dashboard_admin_test_user_1583\",'+
            '\"meta\":\"John Doe\",'+
            '\"meta1\":\"JohnDoe\",'+
            '\"meta2\":\"JohnDoe\",'+
            '\"authorName\":\"John_Doe\",'+
            '\"locale\":\"en-us\",'+
            '\"productCategoryId\":\"873\",'+
            '\"desc\":\"processors\",'+
            '\"productnumber\":\"111\",'+
            '\"device\":{'+
            '\"device_uuid\":\"fb8c3f13-28e0-427e-9382-65de6a0283e5\",'+
            '\"channel_name\":\"web\",'+
            '\"last_visited_page\":\"https://www.w3schools.com/\"'+
            '}'+
            '}'+
            '}'+
            '}'; 
        LiveChatTranscript chatTranscript = ICS_AVM_TestDataUtility.createChatTranscript();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ICS_AVM_InitiateLiveChatMock());
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        ICS_AVM_RestRequestandResWrapper.ResponseWrapper res = ICS_AVM_RestAPIforLiveChat_V1_0.callLiveAgent();
        // System.assertEquals(true, res.success);
        Test.stopTest();
    }
    
    @isTest
    static void onWorkAcceptedCntr4()
    {
        list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Avaamo',ClientId__c='fbaeade8-b1ed-4f81-a210-6b010e72861d',Client_Secret__c='2U-XP-2BR9d-OXq--00PT-21UnuO-g967s',Class_Name__c='ICS_AVM_Live_Chat_Agent_Controller',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/live-agent/v1/conversations',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
        insert custSetting;
        
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chatTrans = new LiveChatTranscript();
        chatTrans.ICS_AVM_ConversationUUID__c ='12345';
        chatTrans.LiveChatVisitorId = visitor.Id;
        insert chatTrans;
        // ICS_AVM_Live_Chat_Agent_Controller.onWorkAcceptedCntr('hi',chatTrans.Id); // to cover catch block 
        
        Test.startTest();
        
        RestMockGetAccessTokenPositiveCase res1 = new RestMockGetAccessTokenPositiveCase();
        RestMock res2 = new RestMock();
        
        Map<String, HttpCalloutMock> endpoint2TestResp =   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('https://apis-stage.intel.com/v1/auth/token',res1);
        endpoint2TestResp.put('https://apis-stage.intel.com/m2r/live-agent/v1/messages?per_page=100&uuid=12345',res2);
        
        HttpCalloutMock multiCalloutMock = new MultiRequestMock1(endpoint2TestResp);
        
        String apigeeEndPointURL1 = System.Label.ICS_AVM_APIGEE_Chat_Transcript_Url + '12345';
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);    
        ICS_AVM_RestAPIforLiveChat_Handler.getRequest_APIGEE(apigeeEndPointURL1);
        
        Test.stopTest();
    }
    
    
}