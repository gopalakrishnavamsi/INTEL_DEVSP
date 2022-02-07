/********************************************************************************************
* Name        : ICS_AVM_RestAPIForKnowledgeSearch_Test 
* Author      : Nikhil Patil - Popcornapps
* Date created: 07 - July - 2021
* Description : Rest API to initiate agent live chat 
*                
* Date              Created By                    User-Story   
* 07/07/2021        Popcornapps                   
* ******************************************************************************************/
@isTest 
public class ICS_AVM_RestAPIForKnowledgeSearch_Test {
    
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
    
    @isTest
    static void getArticlesStatusOnline()
    {
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
            
            
            Knowledge__kav knowArticleTest = [SELECT Id,IsVisibleInPkb,SEO_Primary_Keyword__c,Level_2_Product_Family_Name__c,Product_Family_Name__c,sfdcTranslationStatus__c,Information_Source__c,Summary,Short_Title__c,RecordType.Name,Title,Article_Static_Link__c,Article_content_type__c,ArticleTotalViewCount,UrlName,ArticleNumber,Language,KnowledgeArticleId,publishStatus from Knowledge__kav WHERE Id =: icsGeneralArticle1.Id];
            
            KbManagement.PublishingService.publishArticle(knowArticleTest.KnowledgeArticleId,true);
            Knowledge__kav knowArticle = [SELECT Id,RecordType.Name,Title,Article_Static_Link__c,Article_content_type__c,ArticleTotalViewCount,UrlName,ArticleNumber,Language,KnowledgeArticleId,publishStatus from Knowledge__kav where publishStatus='Online' AND Id =: knowArticleTest.Id];// 
            //KbManagement.PublishingService.archiveOnlineArticle(knowArticleTest.KnowledgeArticleId, null);    
            Knowledge__DataCategorySelection knowledge_DataCategory = new Knowledge__DataCategorySelection();
            knowledge_DataCategory.DataCategoryGroupName = System.Label.ICS_KM_Article_Content_Type;
            knowledge_DataCategory.DataCategoryName = 'installandsetup';
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
            req.params.put('epmid', '78586');
            req.params.put('date_filter', String.valueOf(Datetime.now()));	
            RestContext.request = req;
            
            Test.setMock(HttpCalloutMock.class, new RestMockGetAccessTokenPositiveCase()); 
            ICS_AVM_RestAPIForKnowledgeSearch.getArticles();
        }
        
    }
   
    @isTest
    static void getArticlesNegative()
    {
        
        RestRequest req = new RestRequest();
        req.params.put('language', 'EN-US');
        req.params.put('epmid', '12345');
        req.params.put('date_filter', 'In Correct');	
        RestContext.request = req;
        
        Test.setMock(HttpCalloutMock.class, new RestMockGetAccessTokenPositiveCase()); 
        ICS_AVM_RestAPIForKnowledgeSearch.getArticles();
        
    }
    
    @isTest
    static void getArticlesNegativeParameters() {
        
        RestRequest req = new RestRequest();
        req.params.put('language', '');
        req.params.put('epmid', '12345');
        req.params.put('date_filter', '2021-07-02 10:58:36');	
        RestContext.request = req;
        
        Test.setMock(HttpCalloutMock.class, new RestMockGetAccessTokenPositiveCase()); 
        ICS_AVM_RestAPIForKnowledgeSearch.getArticles();
        
    }
    
    
    
    public static testMethod void retrieveArticleDataTest() {
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
            
            
            Knowledge__kav knowArticleTest = [SELECT Id,IsVisibleInPkb,SEO_Primary_Keyword__c,Level_2_Product_Family_Name__c,Product_Family_Name__c,sfdcTranslationStatus__c,Information_Source__c,Summary,Short_Title__c,RecordType.Name,Title,Article_Static_Link__c,Article_content_type__c,ArticleTotalViewCount,UrlName,ArticleNumber,Language,KnowledgeArticleId,publishStatus from Knowledge__kav WHERE Id =: icsGeneralArticle1.Id];
            
            KbManagement.PublishingService.publishArticle(knowArticleTest.KnowledgeArticleId,true);
            Knowledge__kav knowArticle = [SELECT Id,RecordType.Name,Title,Article_Static_Link__c,Article_content_type__c,ArticleTotalViewCount,UrlName,ArticleNumber,Language,KnowledgeArticleId,publishStatus from Knowledge__kav where Id =: knowArticleTest.Id];// publishStatus='Online' AND
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
            req.params.put('epmid', '78586');
            req.params.put('date_filter', String.valueOf(Datetime.now()));	
            RestContext.request = req;
            
            Test.setMock(HttpCalloutMock.class, new RestMockGetAccessTokenPositiveCase()); 
            ICS_AVM_RestAPIForKnowledgeSearch.getArticles();
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