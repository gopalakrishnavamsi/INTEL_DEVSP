/********************************************************************************************
* Name        : ICS_AVM_RestRequestandResWrapper
* Test class  : 
* Author      : Priyabhavana - Popcornapps
* Date created: 23 - April - 2021
* Description : Rest API to initiate agent live chat 
*                
* Date              Created By                    User-Story   
* 23/04/2021        Popcornapps                   US951752
* ******************************************************************************************/
global with sharing class ICS_AVM_RestRequestandResWrapper {

     /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Returns default error response
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    errorMessage   
    * @return   ResponseWrapper    DESCRIPTION (modular method to create error ResponseWrapper )
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static ResponseWrapper processErrorResponse(String errorMessage, String statusCode){
       ResponseWrapper responseWrapper = new ResponseWrapper(); 
        responseWrapper.success = false;
        responseWrapper.data = '';
        responseWrapper.error = errorMessage;
        responseWrapper.statusCode = statusCode;
        return responseWrapper;
    }
    
     /**
      * ───────────────────────────────────────────────────────────────────────────────────────────────┐
      * Returns default success response
      * ────────────────────────────────────────────────────────────────────────────────────────────────
      * @param    -- 
      * @return   ResponseWrapper    DESCRIPTION (modular method to create success ResponseWrapper )
      * ───────────────────────────────────────────────────────────────────────────────────────────────┘
      */
    public static ResponseWrapper processSucesssResponse(String objData, String statusCode){
        ResponseWrapper responseWrapper = new ResponseWrapper(); 
        responseWrapper.success = true;
        responseWrapper.data = objData;
        responseWrapper.error = null;
        responseWrapper.statusCode = statusCode;
        return responseWrapper;
    }
    
    global class ResponseWrapper{
        public Boolean success;
        public String error;
        public String data;
        public String statusCode;
    }
     /**
      * ───────────────────────────────────────────────────────────────────────────────────────────────┐
      * Returns default success response
      * ────────────────────────────────────────────────────────────────────────────────────────────────
      * @param    -- 
      * @return   ResponseWrapper    DESCRIPTION (modular method to create success ResponseWrapper )
      * ───────────────────────────────────────────────────────────────────────────────────────────────┘
      */
    public static SessionResponseWrapper processSessionSucesssResponse(String objData, String statusCode, String accessToken){
        SessionResponseWrapper responseWrapper = new SessionResponseWrapper(); 
        responseWrapper.success = true;
        responseWrapper.data = objData;
        responseWrapper.error = null;
        responseWrapper.statusCode = statusCode;
        responseWrapper.accessToken = accessToken;
        return responseWrapper;
    }
    
    global class SessionResponseWrapper{
        public Boolean success;
        public String error;
        public String data;
        public String statusCode;
        public String accessToken;
    }
}