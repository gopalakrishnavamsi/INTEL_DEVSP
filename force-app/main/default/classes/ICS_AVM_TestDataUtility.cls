/********************************************************************************************
* Name        : ICS_AVM_TestDataUtility
* Author      : Priyabhavana - Popcornapps
* Date created: 22 - April - 202
* Description : This is test data set up for all AVM related classes
*                
* Date              Created By                    User-Story   
* 22/04/2021        Popcornapps                   
* ******************************************************************************************/
@isTest
public class ICS_AVM_TestDataUtility {
    
    public static void createAVMCustomSettings(){
        List<ICS_AVM_ChatButtonToEPMAndLanguageMap__c> avmconfigList = new List<ICS_AVM_ChatButtonToEPMAndLanguageMap__c>();
        avmconfigList.add(new ICS_AVM_ChatButtonToEPMAndLanguageMap__c(Name='Live Agent Cynthia',Chat_Button_Id__c='573c00000004Cqk',Deployment_Id__c='572c00000004CZQ',EPM_Id__c='98414',Language__c='ENG',Is_Default__c=false));
        avmconfigList.add(new ICS_AVM_ChatButtonToEPMAndLanguageMap__c(Name='Live Agent Nikhil',Chat_Button_Id__c='573c00000004CXE',Deployment_Id__c='572U0000000CgOI',EPM_Id__c='98415',Language__c='ENG',Is_Default__c=true));
        insert avmconfigList;
    }
    
    public static String createJSONBody(){
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
        return json;
    }
    
    public static void createApigeeCustomSettings(){
        ICS_APIGEE_ConfigSettings__c AttApigee= new ICS_APIGEE_ConfigSettings__c();
        AttApigee.Name = 'Avaamo';
        AttApigee.ClientId__c = '289e267c-5fa8-4381-827f-1277715081f2';
        AttApigee.Client_Secret__c = 'bE67r0ts.t_rqbSD-3XJOdu.1d~1a9YFXR';
        AttApigee.Class_Name__c = 'ICS_APIGEE_ISVCToIPS';
        AttApigee.GrantType__c = 'client_credentials';
        AttApigee.setEndPointURL__c = 'https://apis-stage.intel.com/m2r/v1/isvc/cases/attachment';
        AttApigee.TokenEndPointURL__c = 'https://apis-stage.intel.com/v1/auth/token';
        insert AttApigee;
    }
    
    public static LiveChatTranscript createChatTranscript(){
        LiveChatTranscript chatTranscript = new LiveChatTranscript();
        LiveChatVisitor visitor = new LiveChatVisitor();
        //visitor.SessionKey = '370697cc-86e0-4020-8085-b51e17cfaf83';
        insert visitor;
        chatTranscript.ICS_AVM_File_Upload_OTP__c = '12345';
        chatTranscript.ICS_AVM_Token_Generated_Time__c = Datetime.now();
        chatTranscript.ICS_AVM_Apigee_Token__c = 'accessTokenApigee';
        chatTranscript.ICS_AVM_ConversationUUID__c = '12326f2ef1ffca9b8903c446a114';
        chatTranscript.ICS_AVM_AffinityToken__c = 'a82a1f8g';
        chatTranscript.ICS_AVM_Key__c = 'hghfgftyftytydtyid'; 
        chatTranscript.status = 'InProgress';
        chatTranscript.LiveChatVisitorId = visitor.Id;
        insert chatTranscript;
        return chatTranscript;
    }
}