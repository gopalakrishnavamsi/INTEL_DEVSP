/********************************************************************************************
* Name        : ICS_AVM_RestAPIForContentIngestion_Test 
* Author      : Nikhil Patil - Popcornapps
* Date created: 07 - July - 2021
* Description : Rest API to initiate agent live chat 
*                
* Date              Created By                    User-Story   
* 07/07/2021        Popcornapps                   
* ******************************************************************************************/
@isTest 
public class ICS_AVM_RestAPIForContentIngestion_Test {
    
    private class RestMockGetAccessTokenPositiveCase implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            
            String strBody='{"access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6ImppYk5ia0ZTU2JteFBZck45Q0ZxUms0SzRndyJ9.eyJhdWQiOiIwMDAzMWYxNC0wNzM1LTQ5MzktYTkyNS1mMjU1YjFjNTE3YjMiLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vNDZjOThkODgtZTM0NC00ZWQ0LTg0OTYtNGVkNzcxMmUyNTVkL3YyLjAiLCJpYXQiOjE1OTg4NTYwMzIsIm5iZiI6MTU5ODg1NjAzMiwiZXhwIjoxNTk4ODU5OTMyLCJhaW8iOiJFMkJnWUVoVW5TSVZmS0dSbDFWVGZxL1VwRlJWQUE9PSIsImF6cCI6IjAwMDMxZjE0LTA3MzUtNDkzOS1hOTI1LWYyNTViMWM1MTdiMyIsImF6cGFjciI6IjEiLCJvaWQiOiI0","token_type":"Bearer","expires_in":"3599","ext_expires_in":"3599"}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(strBody);
            res.setStatusCode(200);
            return res;
        }
    }
    
    public static testMethod  void getArticlesNegitive(){
        RestRequest req = new RestRequest();
        req.params.put('language', '');
        req.params.put('article_ids', 'In correct ID');	
        RestContext.request = req;
        Test.setMock(HttpCalloutMock.class, new RestMockGetAccessTokenPositiveCase()); 
        ICS_AVM_RestAPIForContentIngestion.ResponseWrapper responseWrapp = ICS_AVM_RestAPIForContentIngestion.getArticles();
        System.assertEquals(responseWrapp.status,'ERROR' );
    }
    
    public static testMethod  void getArticlesPSG()
    {
        String recordTypeId = '';
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get('Knowledge__kav').getDescribe();
        if(sobjectResult!=null){
            //get available object record types
            List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
            for(Schema.RecordTypeInfo info : recordTypeInfo){
                
                if(info.getDeveloperName()=='ICS_PSG_Article'){
                    recordTypeId = info.getRecordTypeId();
                }
            }    
        }
        
        Product2 prod_1=ICS_KM_LEX_TestUtils.createProduct2(true,'arria-10');
        Product2 prod_2=ICS_KM_LEX_TestUtils.createProduct2(true,'quartus-prime-pro');
        
        Product_Hierarchy__c prod1=ICS_KM_LEX_TestUtils.createProduct(false,'arria-10','1','1');
        prod1.ISVC_KM_PSG_Tag__c='altera:all-plds/arria-series/arria-10';
        prod1.Product__c=prod_1.id;
        prod1.ISVC_KM_Category_Display__c=true;
        insert prod1;
        
        Product_Hierarchy__c prod2=ICS_KM_LEX_TestUtils.createProduct(false,'quartus-prime-pro','2','2');
        prod2.ISVC_KM_PSG_Tag__c='altera:development-software/quartus-prime/quartus-prime-pro';
        prod2.Product__c=prod_2.id;
        prod2.Node_ID__c = '129982';
        prod2.Child_EPM_Term_Name__c = 'test term';
        prod2.Child_EPM_ID__c = '92';
        prod2.path__c = '129982|2456';
        prod2.ISVC_KM_App_Flag__c = true;
        prod2.ISVC_KM_Category_Display__c = true;
        prod2.Hierarchy_ID__c = '95';
        insert prod2;
        
        Knowledge__kav article=ICS_KM_LEX_TestUtils.createPSGKnowArticle(false, 'publicarticle','public');
        article.RecordTypeId = recordTypeId;
        article.Product_Family_Name__c = 'c_129982_92';
        insert article;
        ICS_KM_Product_Article_Link__c productAttach=new ICS_KM_Product_Article_Link__c();
        productAttach.Knowledge__c=article.Id;
        productAttach.Product_Hierarchy__c=prod1.Id;
        insert productAttach;
        
        ICS_KM_Product_Article_Link__c productAttach2=new ICS_KM_Product_Article_Link__c();
        productAttach2.Knowledge__c=article.Id;
        productAttach2.Product_Hierarchy__c=prod2.Id;
        insert productAttach2;
        
        article.isVisibleinPKB=true;
        //article.ValidationStatus='Approved';
        update article;
        RestRequest req = new RestRequest();
        req.params.put('language', 'en_US');
        req.params.put('article_ids', article.Id);	
        RestContext.request = req;
        Test.setMock(HttpCalloutMock.class, new RestMockGetAccessTokenPositiveCase()); 
        ICS_AVM_RestAPIForContentIngestion.ResponseWrapper responseWrapp = ICS_AVM_RestAPIForContentIngestion.getArticles();
        
    }
    @isTest
    static void getArticlesPositive()
    {
        String recordTypeId = '';
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get('Knowledge__kav').getDescribe();
        if(sobjectResult!=null){
            //get available object record types
            List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
            for(Schema.RecordTypeInfo info : recordTypeInfo){
                if(info.getDeveloperName()=='Reactive_template'){
                    recordTypeId = info.getRecordTypeId();
                }
                if(info.getDeveloperName()=='ICS_General_Article'){
                    recordTypeId = info.getRecordTypeId();
                }
                if(info.getDeveloperName()=='ICS_PSG_Article'){
                    recordTypeId = info.getRecordTypeId();
                }
            }    
        }
        
        Knowledge__kav icsGeneralArticle1 =ICS_KM_LEX_TestUtils.createKnowArticle(false,'ka General1','ka-General1',false);
        icsGeneralArticle1.Language = 'en_US';
        icsGeneralArticle1.Issue_Encountered__c = 'Issue';
        icsGeneralArticle1.Resolution__c = 'Resolution';
        icsGeneralArticle1.Title = 'test article';
        icsGeneralArticle1.UrlName ='ICS-KM-Article-View-Test-test-2ndArticle';
        icsGeneralArticle1.Short_Title__c = 'test article summary';
        icsGeneralArticle1.Summary = 'test article summary';
        String information='';
        for(integer index = 0;index<6553;index++)
            information = information + '<br/><br/>';
        icsGeneralArticle1.Information_Source__c = information;
        icsGeneralArticle1.sfdcTranslationStatus__c = 'HT';
        icsGeneralArticle1.Product_Family_Name__c = 'c_6957_78586';
        icsGeneralArticle1.Level_2_Product_Family_Name__c = 'None';
        icsGeneralArticle1.SEO_Primary_Keyword__c = 'c_';
        icsGeneralArticle1.IsVisibleInPkb = true;
        icsGeneralArticle1.Article_content_type__c = 'Article_content_type__c';
        icsGeneralArticle1.RecordTypeId = recordTypeId;
        insert icsGeneralArticle1;
        RestRequest req = new RestRequest();
        req.params.put('language', 'en_US');
        req.params.put('article_ids', icsGeneralArticle1.Id);	
        RestContext.request = req;
        
        Test.setMock(HttpCalloutMock.class, new RestMockGetAccessTokenPositiveCase()); 
        ICS_AVM_RestAPIForContentIngestion.getArticles();
        
    }
    public static testMethod void retrieveArticlesStatusonDraft() {
        String recordTypeId = '';
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get('Knowledge__kav').getDescribe();
        if(sobjectResult!=null){
            //get available object record types
            List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
            for(Schema.RecordTypeInfo info : recordTypeInfo){
                if(info.getDeveloperName()=='Reactive_template'){
                    recordTypeId = info.getRecordTypeId();
                }
                if(info.getDeveloperName()=='ICS_General_Article'){
                    recordTypeId = info.getRecordTypeId();
                }
            }    
        }
        
        Knowledge__kav icsGeneralArticle1 =ICS_KM_LEX_TestUtils.createKnowArticle(false,'ka General1','ka-General1',false);
        icsGeneralArticle1.Language = 'en_US';
        icsGeneralArticle1.Issue_Encountered__c = 'Issue';
        icsGeneralArticle1.Resolution__c = 'Resolution';
        icsGeneralArticle1.Title = 'test article';
        icsGeneralArticle1.UrlName ='ICS-KM-Article-View-Test-test-2ndArticle';
        icsGeneralArticle1.Short_Title__c = 'test article summary';
        icsGeneralArticle1.Summary = 'test article summary';
        String information='';
        for(integer index = 0;index<6553;index++)
            information = information + '<br/><br/>';
        icsGeneralArticle1.Information_Source__c = information; 
        icsGeneralArticle1.sfdcTranslationStatus__c = 'HT';
        icsGeneralArticle1.Product_Family_Name__c = 'c_6957_78586';
        icsGeneralArticle1.Level_2_Product_Family_Name__c = 'None';
        icsGeneralArticle1.SEO_Primary_Keyword__c = 'c_';
        icsGeneralArticle1.IsVisibleInPkb = true;
        icsGeneralArticle1.Article_content_type__c = 'Article_content_type__c';
        icsGeneralArticle1.RecordTypeId = recordTypeId;
        insert icsGeneralArticle1;
        
        //  Knowledge__kav icsPSGarticle = ICS_KM_LEX_TestUtils.createPSGKnowArticle(false,'ka psgone','ka-psgone');
        
        Knowledge__kav knowArticleTest = [SELECT Id,IsVisibleInPkb,SEO_Primary_Keyword__c,Level_2_Product_Family_Name__c,Product_Family_Name__c,sfdcTranslationStatus__c,Information_Source__c,Summary,Short_Title__c,RecordType.Name,Title,Article_Static_Link__c,Article_content_type__c,ArticleTotalViewCount,UrlName,ArticleNumber,Language,KnowledgeArticleId,publishStatus from Knowledge__kav WHERE Id =: icsGeneralArticle1.Id];
        
        
        Knowledge__kav knowArticle = [SELECT Id,RecordType.Name,Title,Article_Static_Link__c,Article_content_type__c,ArticleTotalViewCount,UrlName,ArticleNumber,Language,KnowledgeArticleId,publishStatus from Knowledge__kav where Id =: knowArticleTest.Id];//publishStatus='Online' AND
        
        Knowledge__DataCategorySelection knowledge_DataCategory = new Knowledge__DataCategorySelection();
        knowledge_DataCategory.DataCategoryGroupName = System.Label.ICS_KM_Article_Content_Type;
        knowledge_DataCategory.DataCategoryName = 'All';
        knowledge_DataCategory.ParentId = knowArticle.Id;
        insert knowledge_DataCategory;
        
        Product_Hierarchy__c prod_hierarchy = new Product_Hierarchy__c();
        prod_hierarchy.Node_ID__c = '6957';
        prod_hierarchy.Child_EPM_Term_Name__c = 'test term';
        prod_hierarchy.Child_EPM_ID__c = '78586';
        prod_hierarchy.path__c = '129982|2456';
        prod_hierarchy.ISVC_KM_App_Flag__c = true;
        prod_hierarchy.ISVC_KM_Category_Display__c = true;
        prod_hierarchy.Hierarchy_ID__c = '95';
        insert prod_hierarchy;
        
        ICS_KM_Product_Article_Link__c prodArtLink = new ICS_KM_Product_Article_Link__c(Name = 'test productName',Version_Number__c = '1');
        prodArtLink.Product_Hierarchy__c = prod_hierarchy.id;
        prodArtLink.Knowledge__c = knowArticle.id;
        prodArtLink.Knowledge_Article_Id__c = knowArticle.KnowledgeArticleId;
        insert prodArtLink;
        
        RestRequest req = new RestRequest();
        req.params.put('language', 'en_US');
        req.params.put('article_ids', icsGeneralArticle1.Id);	
        RestContext.request = req;
        
        Test.setMock(HttpCalloutMock.class, new RestMockGetAccessTokenPositiveCase()); 
        ICS_AVM_RestAPIForContentIngestion.ResponseWrapper responseWrapp = ICS_AVM_RestAPIForContentIngestion.getArticles();
        System.debug(responseWrapp);
    }
    
    public static testMethod void retrieveArticlesStatusonArchive() {
        User u=[SELECT id FROM User WHERE Email = 'publisharchive@test1.com'];
        System.runAs(u){
            String recordTypeId = '';
            Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get('Knowledge__kav').getDescribe();
            if(sobjectResult!=null){
                //get available object record types
                List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
                for(Schema.RecordTypeInfo info : recordTypeInfo){
                    if(info.getDeveloperName()=='Reactive_template'){
                        recordTypeId = info.getRecordTypeId();
                    }
                    if(info.getDeveloperName()=='ICS_General_Article'){
                        recordTypeId = info.getRecordTypeId();
                    }
                }    
            }
            
            Knowledge__kav icsGeneralArticle1 =ICS_KM_LEX_TestUtils.createKnowArticle(false,'ka General1','ka-General1',false);
            icsGeneralArticle1.Language = 'en_US';
            icsGeneralArticle1.Issue_Encountered__c = 'Issue';
            icsGeneralArticle1.Resolution__c = 'Resolution';
            icsGeneralArticle1.Title = 'test article';
            icsGeneralArticle1.UrlName ='ICS-KM-Article-View-Test-test-2ndArticle';
            icsGeneralArticle1.Short_Title__c = 'test article summary';
            icsGeneralArticle1.Summary = 'test article summary';
            String information='';
            for(integer index = 0;index<6553;index++)
                information = information + '<br/><br/>';
            icsGeneralArticle1.Information_Source__c = information; 
            icsGeneralArticle1.sfdcTranslationStatus__c = 'HT';
            icsGeneralArticle1.Product_Family_Name__c = 'c_6957_78586';
            icsGeneralArticle1.Level_2_Product_Family_Name__c = 'None';
            icsGeneralArticle1.SEO_Primary_Keyword__c = 'c_';
            icsGeneralArticle1.IsVisibleInPkb = true;
            icsGeneralArticle1.Article_content_type__c = 'Article_content_type__c';
            icsGeneralArticle1.RecordTypeId = recordTypeId;
            insert icsGeneralArticle1;
            
            //  Knowledge__kav icsPSGarticle = ICS_KM_LEX_TestUtils.createPSGKnowArticle(false,'ka psgone','ka-psgone');
            
            Knowledge__kav knowArticleTest = [SELECT Id,IsVisibleInPkb,SEO_Primary_Keyword__c,Level_2_Product_Family_Name__c,Product_Family_Name__c,sfdcTranslationStatus__c,Information_Source__c,Summary,Short_Title__c,RecordType.Name,Title,Article_Static_Link__c,Article_content_type__c,ArticleTotalViewCount,UrlName,ArticleNumber,Language,KnowledgeArticleId,publishStatus from Knowledge__kav WHERE Id =: icsGeneralArticle1.Id];
            
            KbManagement.PublishingService.publishArticle(knowArticleTest.KnowledgeArticleId,true);
            Knowledge__kav knowArticle = [SELECT Id,RecordType.Name,Title,Article_Static_Link__c,Article_content_type__c,ArticleTotalViewCount,UrlName,ArticleNumber,Language,KnowledgeArticleId,publishStatus from Knowledge__kav where  publishStatus='Online' AND Id =: knowArticleTest.Id];//
            KbManagement.PublishingService.archiveOnlineArticle(knowArticleTest.KnowledgeArticleId, null);   
            Knowledge__DataCategorySelection knowledge_DataCategory = new Knowledge__DataCategorySelection();
            knowledge_DataCategory.DataCategoryGroupName = System.Label.ICS_KM_Article_Content_Type;
            knowledge_DataCategory.DataCategoryName = 'All';
            knowledge_DataCategory.ParentId = knowArticle.Id;
            insert knowledge_DataCategory;
            
            Product_Hierarchy__c prod_hierarchy = new Product_Hierarchy__c();
            prod_hierarchy.Node_ID__c = '6957';
            prod_hierarchy.Child_EPM_Term_Name__c = 'test term';
            prod_hierarchy.Child_EPM_ID__c = '78586';
            prod_hierarchy.path__c = '129982|2456';
            prod_hierarchy.ISVC_KM_App_Flag__c = true;
            prod_hierarchy.ISVC_KM_Category_Display__c = true;
            prod_hierarchy.Hierarchy_ID__c = '95';
            insert prod_hierarchy;
            
            ICS_KM_Product_Article_Link__c prodArtLink = new ICS_KM_Product_Article_Link__c(Name = 'test productName',Version_Number__c = '1');
            prodArtLink.Product_Hierarchy__c = prod_hierarchy.id;
            prodArtLink.Knowledge__c = knowArticle.id;
            prodArtLink.Knowledge_Article_Id__c = knowArticle.KnowledgeArticleId;
            insert prodArtLink;
            
            RestRequest req = new RestRequest();
            req.params.put('language', 'en_US');
            req.params.put('article_ids', icsGeneralArticle1.Id);	
            RestContext.request = req;
            
            Test.setMock(HttpCalloutMock.class, new RestMockGetAccessTokenPositiveCase()); 
            ICS_AVM_RestAPIForContentIngestion.ResponseWrapper responseWrapp = ICS_AVM_RestAPIForContentIngestion.getArticles();
            System.assertEquals(recordTypeId != null, true);
        }
    }
    
    @testSetup
    static void testSetup(){
        
        Profile sysAdmin = [SELECT Id FROM Profile WHERE Name='System Administrator' ];
        User userInfo = new User(FirstName = 'Agent11',LastName = 'User1',Email = 'publisharchive@test1.com');
        userInfo.ProfileId = sysAdmin.id; 
        userInfo.Username = 'john123@test1.com';
        userInfo.UserPermissionsKnowledgeUser=true;
        userInfo.Alias = 'jhndoe3'; 
        userInfo.CommunityNickname = 'j0hndoe31';  
        userInfo.TimeZoneSidKey = 'America/Los_Angeles';
        userInfo.LocaleSidKey = 'en_US';  
        userInfo.EmailEncodingKey = 'UTF-8';
        userInfo.LanguageLocaleKey = 'en_US';
        insert userInfo;
    }
}