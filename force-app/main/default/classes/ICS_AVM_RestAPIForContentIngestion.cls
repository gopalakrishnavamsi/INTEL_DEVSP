/********************************************************************************************
* Name        : ICS_AVM_RestAPIForContentIngestion
* Test class  : ICS_AVM_RestAPIForContentIngestion_Test
* Author      : Murali - Popcornapps
* Date created: 27 - May - 2021
* Description : Rest API to fetch Delta Knowledge Articles for the requested Article Ids
*                
* Date              Created By                    User-Story   
* 27/05/2021        Popcornapps                   
* ******************************************************************************************/
@RestResource(urlMapping='/contentingestion/v1.0/articles/content')
global with sharing class ICS_AVM_RestAPIForContentIngestion {
    //16-07-2021 -- P-2 -- Nikhil Patil -- has Cyclomatic Complexity  -- To check the conditions from list kept if else conditions inside the for loop
    @HttpGet
    global static ResponseWrapper getArticles(){
        ResponseWrapper postResponse = new ResponseWrapper();
        String articleIdsReq='';
        try{
            String language = RestContext.request.params.get('language');
            articleIdsReq = RestContext.request.params.get('article_ids');
            List<String> articleIdList = articleIdsReq.split(',');
            List<Knowledge__kav> articleList = new List<Knowledge__kav>();


            String query = 
                'SELECT ' +
                'Id, AEM_URL_new__c,AEM_PSG_Url__c, AEMURL__c, Title, RecordType.DeveloperName, PublishStatus,Content_Program__c,Level_2_Product_Family_Name__c,ArticleNumber,Product_Family_Name__c,language,' +
                'Information_Source__c, '+
                'Summary, Issue_Encountered__c, Resolution__c, Information__c,Facts_Environment__c,Display_Publish_Date__c,VersionNumber,Keywords__c,PSG_KDB_Area__c,Bug_ID__c,Documentation_ID__c,Doc_Version_Found__c,Doc_Version_Fixed__c,Quartus_Version_Found__r.Name,Quartus_Version_Target__r.Name,Quartus_Version_Fixed__r.Name,IP_Version_Found__c,IP_Version_Fixed__c,IP_Version_Target__c '+
                'FROM ' +
                'Knowledge__kav '+
                'WHERE';

                if(language!=null && language!='')
                query = query + ' language=\''+language+'\' AND Id IN (\''+String.join(articleIdList,'\',\'')+'\')';
            else
                query = query + ' Id IN (\''+String.join(articleIdList,'\',\'')+'\')';
            articleList = Database.query(query);

            List<String> epmids = new List<String>();
            for(Knowledge__kav kav : articleList){
                epmids.add(kav.Product_Family_Name__c);
            }
            List<Product_Hierarchy__c> products = new List<Product_Hierarchy__c>();
            products = [SELECT Id, Child_EPM_ID__c, Child_EPM_Term_Name__c FROM Product_Hierarchy__c WHERE Category_ID__c IN :epmids];
            Map<String,String> productNamesMap = new Map<String,String>();
            if(products.size()>0){
                for(Product_Hierarchy__c p:products){
                    productNamesMap.put(p.Child_EPM_ID__c,p.Child_EPM_Term_Name__c);
                }
            }

            //organizing article content type and operating system data
            List<Knowledge__DataCategorySelection> dataCategories = [SELECT DataCategoryGroupName, DataCategoryName, ParentId FROM Knowledge__DataCategorySelection WHERE ParentId IN: articleIdList];
            Map<Id, List<String>> articleContentMap = new Map<Id, List<String>>();
            Map<Id, List<String>> operatingSystemMap = new Map<Id, List<String>>();
            for (Knowledge__DataCategorySelection category : dataCategories) {
                if (category.DataCategoryGroupName == 'Article_Content_Type') 
                {
                    if (articleContentMap.get(category.ParentId) == null)
                    {
                        articleContentMap.put(category.ParentId, new List<String>());
                    }
                    articleContentMap.get(category.ParentId).add(category.DataCategoryName);
                }
                else if (category.DataCategoryGroupName == 'Operating_Systems') 
                {
                    if (operatingSystemMap.get(category.ParentId) == null) 
                    {
                        operatingSystemMap.put(category.ParentId, new List<String>());
                    }
                    operatingSystemMap.get(category.ParentId).add(category.DataCategoryName);
                }
            }
            List<ICS_AVM_AvaamoContentWrapperCls> avaamoArticles = new List<ICS_AVM_AvaamoContentWrapperCls>();
            List<ICS_AVM_AvaamoArchivedContentWrapperCls> avaamoArchivedArticles = new List<ICS_AVM_AvaamoArchivedContentWrapperCls>();
            if(articleList.size()>0){
                for(Knowledge__kav kav : articleList){   
                    String preview_url = kav.AEM_URL_new__c;
                    if(kav.RecordType.DeveloperName=='ICS_PSG_Article')
                    {
                         preview_url = kav.AEM_PSG_Url__c;
                    }
                    preview_url = preview_url.substring(preview_url.IndexOf('>')+1,preview_url.IndexOf('</')); 
                    if(kav.PublishStatus=='Archived'){
                        ICS_AVM_AvaamoArchivedContentWrapperCls avaamoArticle = new ICS_AVM_AvaamoArchivedContentWrapperCls();
                        // avaamoArticle.document_group_id = Integer.valueOf(System.Label.ICS_AVM_Avaamo_Document_Group_Id);
                        List<ICS_AVM_Mapping__mdt> bot=[Select Key__c,Value__c,QualifiedApiName from ICS_AVM_Mapping__mdt where Group__c='Avaamo_Bot'];
                        for(ICS_AVM_Mapping__mdt str: bot){
                            if(bot!=null){
                                if(str.QualifiedApiName=='General_Article' && kav.RecordType.DeveloperName == 'ICS_General_Article'){
                                    avaamoArticle.document_group_id = Integer.valueOf(str.Value__c);
                                }
                                if(str.QualifiedApiName=='Reactive_Article' && kav.RecordType.DeveloperName == 'Reactive_template'){
                                    avaamoArticle.document_group_id= Integer.valueOf(str.Value__c);
                                }
                                if(str.QualifiedApiName=='PSG_Article' && kav.RecordType.DeveloperName == 'ICS_PSG_Article'){
                                    avaamoArticle.document_group_id= Integer.valueOf(str.Value__c);
                                }
                            }
                        }
                        //  avaamoArticle.document_group_id = System.Label.ICS_AVM_Avaamo_Document_Group_Id;
                        avaamoArticle.api_server = System.Label.ICS_AVM_Avaamo_API_Server;
                        avaamoArticle.preview_url = preview_url;
                        avaamoArchivedArticles.add(avaamoArticle);
                    } else{
                        ICS_AVM_AvaamoContentWrapperCls avaamoArticle = new ICS_AVM_AvaamoContentWrapperCls();
                        List<ICS_AVM_Mapping__mdt> bot=[Select Key__c,Value__c,QualifiedApiName from ICS_AVM_Mapping__mdt where Group__c='Avaamo_Bot'];
                        for(ICS_AVM_Mapping__mdt str: bot)
                        {
                            if(bot!=null)
                            {
                                if(str.QualifiedApiName=='General_Article' && kav.RecordType.DeveloperName == 'ICS_General_Article')
                                {
                                    avaamoArticle.document_group_id= Integer.valueOf(str.Value__c);
                                    
                                }
                                if(str.QualifiedApiName=='Reactive_Article' && kav.RecordType.DeveloperName == 'Reactive_template')
                                {
                                    avaamoArticle.document_group_id= Integer.valueOf(str.Value__c);
                                    
                                }
                                if(str.QualifiedApiName=='PSG_Article' && kav.RecordType.DeveloperName == 'ICS_PSG_Article')
                                {
                                    avaamoArticle.document_group_id= Integer.valueOf(str.Value__c);
                                    
                                }
                            }
                        }
                        
                        //  avaamoArticle.document_group_id = Integer.valueOf(System.Label.ICS_AVM_Avaamo_Document_Group_Id);//19;
                        avaamoArticle.api_server = System.Label.ICS_AVM_Avaamo_API_Server;//'https://m0.avaamo.com';
                        avaamoArticle.document = new ICS_AVM_AvaamoContentWrapperCls.Document();
                        
                        String prodId = kav.Product_Family_Name__c;
                        String ProdId2 = kav.Level_2_Product_Family_Name__c;
                        String productCategoryId = '';
                        String productCategoryId2 = '';
                        if(prodId!=null)
                            productCategoryId = prodId.substring(prodId.lastIndexOf('_')+1,prodId.length());
                        
                        if(ProdId2!=null)
                            productCategoryId2 = ProdId2.substring(ProdId2.lastIndexOf('_')+1,ProdId2.length());
                        
                        String locale = kav.language.replace('_','-');

                        List<String> attributeList = new List<String>();
                        String template = System.Label.ICS_AVM_Avaamo_Content_Attributes;
                        List<String> attributes = new List<String>();
                        attributes.add('productCategoryId');
                        attributes.add(productCategoryId);
                        attributes.add('0');
                        attributeList.add(String.format(template, attributes));
                        
                        attributes.clear();
                        attributes.add('productCategoryName');
                        attributes.add(productNamesMap.get(productCategoryId));
                        attributes.add('1');
                        attributeList.add(String.format(template, attributes));
                       
                        
                        attributes.clear();
                        attributes.add('level2ProductFamilyName');
                        attributes.add(productCategoryId2);
                        attributes.add('2');
                        attributeList.add(String.format(template, attributes));
                       
                        
                        attributes.clear();
                        attributes.add('keywords');
                        attributes.add(kav.Keywords__c);
                        attributes.add('3');
                        attributeList.add(String.format(template, attributes));
                       
                        
                        attributes.clear();
                        attributes.add('versionNumber');
                        attributes.add(String.valueOf(kav.VersionNumber));
                        attributes.add('4');
                        attributeList.add(String.format(template, attributes));
                        
                        
                        attributes.clear();
                        attributes.add('displayDate');
                        attributes.add(String.valueOf(kav.Display_Publish_Date__c));
                        attributes.add('5');
                        attributeList.add(String.format(template, attributes));
                       
                        
                                             
                        attributes.clear();
                        attributes.add('locale');
                        attributes.add(locale);
                        attributes.add('6');
                        attributeList.add(String.format(template, attributes));
                        
                        
                        attributes.clear();
                        attributes.add('articleNumber');
                        attributes.add(kav.ArticleNumber);
                        attributes.add('7');
                        attributeList.add(String.format(template, attributes));
                        

                        attributes.clear();
                        attributes.add('articleContentType');
                        attributes.add((articleContentMap.get(kav.Id) != null)?String.join(articleContentMap.get(kav.Id), ','):'');
                        attributes.add('8');
                        attributeList.add(String.format(template, attributes));

                        String osTemplate = System.Label.ICS_AVM_Avaamo_Content_Attributes_OS;
                        attributes.clear();
                        attributes.add('operating_system');
                        attributes.add((operatingSystemMap.get(kav.Id) != null)?'[\'' + String.join(operatingSystemMap.get(kav.Id), '\',\'') + '\']':'\'\'');
                        attributes.add('9');
                        attributeList.add(String.format(osTemplate, attributes));
                        
                        
                       
                        
                        if(kav.RecordType.DeveloperName == 'ICS_PSG_Article' || kav.RecordType.DeveloperName == 'Reactive_template')
                        {
                            
                        
                        	attributes.clear();
                        	attributes.add('environment');
                        	attributes.add(kav.Facts_Environment__c);
                        	attributes.add('10');
                        	attributeList.add(String.format(template, attributes));
                        	
                            
                        }
                        //changes by padala nikhil for psg attributes.   
                       
                      
                      if(kav.RecordType.DeveloperName == 'ICS_PSG_Article')
                      {
                        	
                        	attributes.clear();
                        	attributes.add('kdbArea');
                        	attributes.add(kav.PSG_KDB_Area__c);
                        	attributes.add('11');
                        	attributeList.add(String.format(template, attributes));
                        	
                        
                        	attributes.clear();
                        	attributes.add('bugid');
                        	attributes.add(kav.Bug_ID__c);
                        	attributes.add('12');
                        	attributeList.add(String.format(template, attributes));
                        	
                        
                        	attributes.clear();
                        	attributes.add('documentationid');
                        	attributes.add(kav.Documentation_ID__c);
                        	attributes.add('13');
                        	attributeList.add(String.format(template, attributes));
                        	
                        
                        	attributes.clear();
                        	attributes.add('documentationVersionFound');
                        	String docFound=String.valueOf(kav.Doc_Version_Found__c);
                        	attributes.add(docFound);
                        	attributes.add('14');
                        	attributeList.add(String.format(template, attributes));
                        	
                        
                        	attributes.clear();
                        	attributes.add('documentationVersionFixed');
                        	String docFixed=String.valueOf(kav.Doc_Version_Fixed__c);
                        	attributes.add(docFixed);
                        	attributes.add('15');
                        	attributeList.add(String.format(template, attributes));
                        	
                        
                        	attributes.clear();
                        	attributes.add('quartusVersionFound');
                        	attributes.add(kav.Quartus_Version_Found__r.Name);
                        	attributes.add('16');
                        	attributeList.add(String.format(template, attributes));
                        	
                        
                        	attributes.clear();
                        	attributes.add('quartusVersionTarget');
                        	attributes.add(kav.Quartus_Version_Target__r.Name);
                        	attributes.add('17');
                        	attributeList.add(String.format(template, attributes));
                        	
                        
                        	attributes.clear();
                        	attributes.add('quartusVersionFixed');
                        	attributes.add(kav.Quartus_Version_Fixed__r.Name);
                        	attributes.add('18');
                        	attributeList.add(String.format(template, attributes));
                        	
                        
                        	attributes.clear();
                        	attributes.add('ipVersionFound');
                        	attributes.add(kav.IP_Version_Found__c);
                        	attributes.add('19');
                        	attributeList.add(String.format(template, attributes));
                        	
                        
                        	attributes.clear();
                        	attributes.add('ipVersionFixed');
                        	attributes.add(kav.IP_Version_Fixed__c);
                        	attributes.add('20');
                        	attributeList.add(String.format(template, attributes));
                        	
                        
                        	attributes.clear();
                        	attributes.add('ipVersionTarget');
                        	attributes.add(kav.IP_Version_Target__c);
                        	attributes.add('21');
                        	attributeList.add(String.format(template, attributes));
                        	
                        
                      }
                        //changes by padala nikhil for attributes.
                       	String attr = '{';
                       	attr += String.join(attributeList, ',');
                        attr += '}';
                        avaamoArticle.document.attributes = attr.replace('#*#','');

                        if(kav.RecordType.DeveloperName == 'Reactive_template'){
                            avaamoArticle.document.content = getReactiveContent(kav);
                           
                        }

                        if(kav.RecordType.DeveloperName == 'ICS_General_Article'){
                            avaamoArticle.document.content = kav.Information_Source__c;
                           
                        }
                        //changes by padala nikhil for psg articles ingestion
                        if(kav.RecordType.DeveloperName == 'ICS_PSG_Article'){
                            avaamoArticle.document.content = getPsgContent(kav);
                           
                        }
                        
                        /*
                        * To Wrap the content with Body and Title 
                        **/
                        
                        template = System.Label.ICS_AVM_Avaamo_Content_HTML;

                        attributes.clear();
                        attributes.add(kav.Title);
                        attributes.add(avaamoArticle.document.content);
                        avaamoArticle.document.content = String.format(template, attributes);



                        avaamoArticle.document.name = kav.Title;
                        avaamoArticle.document.type = 'html';
                        avaamoArticle.document.preview_url = preview_url;
                        avaamoArticle.document.language = language;

                        avaamoArticles.add(avaamoArticle);
                    }
                    
                }
            }
            List<ICS_AVM_Content_Ingestion_Status__c> statuses = [SELECT Article_Status__c, ICS_AVM_Attempts__c FROM ICS_AVM_Content_Ingestion_Status__c WHERE ICS_AVM_Knowledge_Article__c IN :articleIdList];
            for(ICS_AVM_Content_Ingestion_Status__c status : statuses){
                status.Article_Status__c = 'In Progress';
                status.ICS_AVM_Attempts__c++;
            }
            update statuses;
            postResponse = processSucesssResponse(avaamoArticles,avaamoArchivedArticles);
            
        } catch(Exception ex){
            postResponse = processErrorResponse(ex.getMessage());
            Core_Log_Entry.logEntryWithException('ICS_AVM_RestAPIForContentIngestion',System.Label.ICS_WR_logging_Scope,'ICS_AVM_RestAPIForContentIngestion.getArticles','Critical',ex.getMessage(),'',ex);
            System.debug('Exception'+ex.getLineNumber()+ex.getMessage());
        }
        return postResponse; 
    }
    
    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Returns default error response
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    errorMessage   
    * @return   ResponseWrapper    DESCRIPTION (modular method to create error ResponseWrapper )
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    private static ResponseWrapper processErrorResponse(String errorMessage){
        ResponseWrapper responseWrapper = new ResponseWrapper(); 
        responseWrapper.statusCode = 400;
        responseWrapper.status = 'ERROR';
        responseWrapper.errorMessage = errorMessage;
        return responseWrapper;
    }
    
    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Returns default success response
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    recordId   
    * @return   ResponseWrapper    DESCRIPTION (modular method to create success ResponseWrapper )
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    private static ResponseWrapper processSucesssResponse(List<ICS_AVM_AvaamoContentWrapperCls> articles,
                                                          List<ICS_AVM_AvaamoArchivedContentWrapperCls> archivedArticles){
                                                              ResponseWrapper responseWrapper = new ResponseWrapper(); 
                                                              responseWrapper.statusCode = 200;
                                                              responseWrapper.status = 'SUCCESS';
                                                              responseWrapper.errorMessage = null;
                                                              responseWrapper.data = articles;
                                                              responseWrapper.archived_data = archivedArticles;
                                                              return responseWrapper;
                                                          }
    
    global class ResponseWrapper{
        public List<ICS_AVM_AvaamoContentWrapperCls> data;
        public List<ICS_AVM_AvaamoArchivedContentWrapperCls> archived_data;
        public String status;
        public Integer statusCode;
        public String errorMessage;
    }
    
    public class ICS_AVM_AvaamoArchivedContentWrapperCls{
        public Integer document_group_id;
        public String api_server;
        public String preview_url;
    }
    
    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Returns content for Reactive article
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    Knowledge__kav article   
    * @return   String    DESCRIPTION (modular method to create content for Reactive article )
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    
    private static String getReactiveContent(Knowledge__kav article){
        
        String content = '';
        String template = System.Label.ICS_AVM_Avaamo_Content_Header;
        List<String> attributes = new List<String>();
        attributes.add('Summary');
        attributes.add(article.summary);
        content = 	String.format(template, attributes);
        
        attributes.clear();
        attributes.add('Description:');
        attributes.add(article.Issue_Encountered__c);
        content+= 	String.format(template, attributes);
        
        attributes.clear();
        attributes.add('Resolution:');
        attributes.add(article.Resolution__c);
        content+= 	String.format(template, attributes);
        
        attributes.clear();
        attributes.add('Additional Information:');
        attributes.add(article.Information__c);
        content+= 	String.format(template, attributes);
        
        return content;
    }
    
    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Returns content for PSG article
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    Knowledge__kav article   
    * @return   String    DESCRIPTION (modular method to create content for PSG article )
    * @changes by padala nikhil
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    private static String getPsgContent(Knowledge__kav article){
        
        String content = '';
        String template = System.Label.ICS_AVM_Avaamo_Content_Header;
        List<String> attributes = new List<String>();
        attributes.add('Summary');
        attributes.add(article.summary);
        content = 	String.format(template, attributes);
        
        attributes.clear();
        attributes.add('Description:');
        attributes.add(article.Issue_Encountered__c);
        content+= 	String.format(template, attributes);
        
        attributes.clear();
        attributes.add('Resolution:');
        attributes.add(article.Resolution__c);
        content+= 	String.format(template, attributes);
        
        attributes.clear();
        attributes.add('Additional Information:');
        attributes.add(article.Information__c);
        content+= 	String.format(template, attributes);
        
        return content;
    }
}