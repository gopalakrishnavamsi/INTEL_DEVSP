/********************************************************************************************
* Name        : ICS_AVM_RestAPIForKnowledgeSearch
* Test class  : ICS_AVM_RestAPIForKnowledgeSearch_Test
* Author      : Murali - Popcornapps
* Date created: 27 - May - 2021
* Description : Rest API to fetch Ids of Delta Knowledge Articles filtered by a Date
*                
* Date              Created By                    User-Story   
* 27/05/2021        Popcornapps                   
* ******************************************************************************************/
@RestResource(urlMapping='/contentingestion/v1.0/articles/search')
global with sharing class ICS_AVM_RestAPIForKnowledgeSearch {
    
    @HttpGet
    global static ResponseWrapper getArticles(){
        ResponseWrapper postResponse = new ResponseWrapper();
        String articleIdsReq='';
        
        try{
            String language = RestContext.request.params.get('language');
            String epmid = RestContext.request.params.get('epmid');
 
            DateTime deltaDate = DateTime.valueof(RestContext.request.params.get('date_filter'));
            String deltaDateStr = '';
            if(deltaDate!=null){
                deltaDateStr = String.valueOf(deltaDate);
                deltaDateStr = deltaDateStr.replace(' ', 'T');
                deltaDateStr = deltaDateStr+'Z';
            }
            String strRecordTypes = System.Label.ICS_AVM_Knowledge_Articles_Record_types;
            List<String> lstRecordTypes = new List<String>();
            for(String str : strRecordTypes.split(',')){
                str = '\''+str+'\'';
                lstRecordTypes.add(str);
            }
            //changes by padala nikhil to store the query in custom label
             String PSGrecord='\'ICS_PSG_Article\'';
             String str=String.join(lstRecordTypes, ',');
             List<String> parameters = new List<String>();
             List<String> parametersPSG = new List<String>();
             parameters.add(str);
             parametersPSG.add(PSGrecord);
             String attr = System.Label.ICS_AVM_QueryforKnowledgeSearch;
             String GCSvalue = String.format(attr, parameters);
             String PSGvalue=String.format(attr, parametersPSG);
            //changes by padala nikhil
             List<Knowledge__kav> articleList = new List<Knowledge__kav>();
             List<Knowledge__kav> articleListPSG = new List<Knowledge__kav>();
                 String queryGCS = 
                'SELECT ' + 
                'Id, KnowledgeArticleId, PublishStatus ' +
                'FROM ' +
                'Knowledge__kav ' + 
                  GCSvalue; 
            
            //changes by padala nikhil for psg where article content type is install and setup
             	String queryPSG = 
                'SELECT ' + 
                'Id, KnowledgeArticleId, PublishStatus ' +
                'FROM ' +
                'Knowledge__kav ' +
                 PSGvalue;
                
             
            if(language!=null && language!='')
                queryGCS = queryGCS + ' AND language=\''+language+'\' AND LastModifiedDate > '+deltaDateStr;
            else
                queryGCS = queryGCS + ' AND LastModifiedDate > '+deltaDateStr;
            
            if(language!=null && language!='')
                queryPSG = queryPSG + ' AND language=\''+language+'\' AND LastModifiedDate > '+deltaDateStr;
            else
                queryPSG = queryPSG + ' AND LastModifiedDate > '+deltaDateStr;
            
            
            queryPSG=queryPSG + ' WITH DATA CATEGORY Article_Content_Type__c AT (installandsetup__c) ';

            articleList = Database.query(queryGCS);
            articleListPSG=Database.query(queryPSG);
            articleList.addAll(articleListPSG);
            List<String> articleIds = new List<String>();
            List<String> archivedArticleIds = new List<String>();
           if(articleList.size()>0){
              
                for(Knowledge__kav kav : articleList){
                    if(kav.PublishStatus=='Archived'){
                       archivedArticleIds.add(kav.Id); 
                    }
                    else{ 
                       articleIds.add(kav.Id);
                    }
                   
                }
           }
            
            addErrorRecords(articleIds,archivedArticleIds);
            
            postResponse = processSucesssResponse(articleIds,archivedArticleIds);
            
               
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

    private static ResponseWrapper processSucesssResponse(List<String> articleIds,List<String> archivedArticleIds){
        ResponseWrapper responseWrapper = new ResponseWrapper(); 
        responseWrapper.statusCode = 200;
        responseWrapper.status = 'SUCCESS';
        responseWrapper.errorMessage = null;
        responseWrapper.data = articleIds;
        responseWrapper.archivedData = archivedArticleIds;
        return responseWrapper;
    }
    
    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Returns void
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    articleIds, archivedArticleIds, deltaDate
    * @return   void    DESCRIPTION (modular method to add the articles that failed previously )
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    private static void addErrorRecords(List<String> articleIds,List<String> archivedArticleIds){
        Integer maxWindow = Integer.valueOf(SYSTEM.Label.ICS_AVM_Content_Ingestion_Max_Window);
        List<ICS_AVM_Content_Ingestion_Status__c> errorRecords = [	SELECT 
                                                                  	Id,
                                                                  	ICS_AVM_Knowledge_Article__r.PublishStatus 
                                                                  	FROM ICS_AVM_Content_Ingestion_Status__c 
                                                                  	WHERE ICS_AVM_Attempts__c < :maxWindow  
                                                                  	AND Article_Status__c = 'Failure'];
        if(errorRecords.size()>0){
            for(ICS_AVM_Content_Ingestion_Status__c status : errorRecords){
                if(status.ICS_AVM_Knowledge_Article__r.PublishStatus=='Archived'){
                    archivedArticleIds.add(status.ICS_AVM_Knowledge_Article__c); 
                }
                else{ 
                    articleIds.add(status.ICS_AVM_Knowledge_Article__c);
                }
                
            }
        }
    }
    
    global class ResponseWrapper{
        public List<String> data;
        public List<String> archivedData;
        public String status;
        public Integer statusCode;
        public String errorMessage;
    }
   

}