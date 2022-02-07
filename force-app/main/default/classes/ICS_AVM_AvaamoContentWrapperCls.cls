/********************************************************************************************
* Name        : ICS_AVM_AvaamoContentWrapperCls
* Test class  : ICS_AVM_AvaamoContentWrapperCls_Test
* Author      : Murali - Popcornapps
* Date created: 27 - May - 2021
* Description : Wrapper class for ICS_AVM_RestAPIForContentIngestion Response
*                
* Date              Created By                    User-Story   
* 27/05/2021        Popcornapps                   
* ******************************************************************************************/
public class ICS_AVM_AvaamoContentWrapperCls {

        public Integer document_group_id;
        public String api_server;
        public Document document;
       
    
        public class Document {
            public String content;
            public String name;
            public String type;
            public String preview_url;
            public String language;
            public String attributes = '';
            
        }
    
        
        public static ICS_AVM_AvaamoContentWrapperCls parse(String json) {
            return (ICS_AVM_AvaamoContentWrapperCls) System.JSON.deserialize(json, ICS_AVM_AvaamoContentWrapperCls.class);
        }
    }