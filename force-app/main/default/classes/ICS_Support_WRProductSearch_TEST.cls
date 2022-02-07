/************************************************************************************************
 * Name             : ICS_Support_WRProductSearch_TEST
 * Description      : Test class for Warranty ProductSearch API
 * Developer        : Omni CX Orion
 * Version History  : V1.0 - April 2018 - Created 
 ************************************************************************************************/
@isTest
private class ICS_Support_WRProductSearch_TEST {
  //testTCAResponse: Valid tca response
  //Test 1: Positive Processor Search - Check mode
  //Test 2: Positive Processor Search - Create mode
  //Test 3: Invalid Producttype
  //Test 4: Required inputs missing - Processor -Returntype
  //Test 5: Required inputs missing - Product type
  //Test 6: Positive Non-Processor Search - Board- Check mode
  //Test 7: Positive Non-Processor Search - Other -Create mode
  //Test 8 : Positive Search SSDs - checkmode
  //Test 9 : Site user access InvalidUserException
  //Test 10 : No data returned for a search- No result found
  //Test 11 : Required input missing -FPO NOT Entered for Processors-check mode
  //Test 12 : Invalid return type
  //Test 13 : Invalid mode
  //Test 14 : Only FPO search
  //Test 15 : Mini PC- check mode
  //Test 16 : Missing inputs for SSD Search in check mode
  //Test 17 : Invalid prod type for FUL search in createmode is entered
  //Test 18 : Required check for mode
  //Test 19 : Create SRR type of return
  //Test 20 : SSD - Check mode Only Stocking number provided..missing serial no
  //Test 21 : FUL return type in create mode -- Only with Other 
  //Test 22 : Anonymous user -create mode excetption to signin
  //Test 23 : SSD Create mode
  //Test 24 : Invalid ATPO, Valid FPO 
  //Test 25 : Partial ATPO Processor search
  //Test 26 : TRAY Processor hardstop check
  //Test 27 : Depot determination snippet 
  //Test 28 : Depot determination snippet with CIP
  
  
private static testMethod void testTCAResponse(){
     try{
       User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
       System.runAs(testUser){
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            req.httpMethod = 'GET';
            req.addHeader('client_id', '123456789');
            req.params.put('type','Processor');
            req.params.put('input1','L626F718');
            req.params.put('input2','M6017LR800105');
            req.params.put('mode','check');
            RestContext.request = req;
            RestContext.response = res;
            ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"CattsTcaOutputDataSet":{"Batch_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L               ","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SPEC_TYPE":"S","DN_TYPE":"WO_CUST","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SPEC_CODE":"R2R7","SKU":"BX80660E52630V4","SLD_CUST_COUNTRY_CD":"IT","SHP_CUST_GEO_CD":"EMEA"}],"Input_x0020_Report":[{"MTRL_ID":"948660","TRACE_RESULT":"CONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"92908","VALIDATION_STATUS":"PASSED","BATCH":"L069117020","SPEC_CODE":"R2R7","FINISH_DATE":"2016-08-02T23:27:32-07:00","FPO_LOT":"L626F718","BOX_ID":"KN1DSC73","BOX_TYPE":"TRAY","VISUAL_ID":"M6017LR800105","DN":"803712538","SN":"M6017LR800105","RTL_BOX_EPM_ID":"949500","RTL_BOX_MTRL_ID":"949500","RTL_BOX_SITE_ID":"CS75","RTL_BOX_SKU":"BX80660E52630V4","RTL_BOX_MANUFACTURE_DT":"2016-08-19T00:00:00-07:00","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Box_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L               ","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SHP_CUST_GEO_CD":"EMEA","DN_TYPE":"WO_CUST","SHP_BOX_ID":"","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SKU":"BX80660E52630V4","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"IT"}],"Unit_x0020_Trace":[]}}}', null);
                
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
                
            Test.startTest();
                 ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts(); 
            Test.stopTest();
            System.assertEquals(200, successResponse.Code);
            System.assertEquals(true,successResponse.IsSuccess);
           
       }
   }catch(Exception ex){
        System.debug('*** testTCAResponse' +ex.getMessage()); 
   }
 }
 // Processor - Check
 private static testMethod void testCaseOne() {
      try{
        User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
        ICS_WR_MM_Stocking__c mmstock = [SELECT Id, Name FROM ICS_WR_MM_Stocking__c WHERE MMID__r.Name = '948660' LIMIT 1];
        System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Processor');
            request1.params.put('input1','L626F718');
            request1.params.put('input2','M6017LR800105');
            request1.params.put('mode','check');
            RestContext.request = request1;
            RestContext.response = res;
        
            Test.startTest();
                ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"CattsTcaOutputDataSet":{"Batch_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L               ","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SPEC_TYPE":"S","DN_TYPE":"WO_CUST","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SPEC_CODE":"R2R7","SKU":"BX80660E52630V4","SLD_CUST_COUNTRY_CD":"IT","SHP_CUST_GEO_CD":"EMEA"}],"Input_x0020_Report":[{"MTRL_ID":"948660","TRACE_RESULT":"CONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"92908","VALIDATION_STATUS":"PASSED","BATCH":"L069117020","SPEC_CODE":"R2R7","FINISH_DATE":"2016-08-02T23:27:32-07:00","FPO_LOT":"L626F718","BOX_ID":"KN1DSC73","BOX_TYPE":"TRAY","VISUAL_ID":"M6017LR800105","DN":"803712538","SN":"M6017LR800105","RTL_BOX_EPM_ID":"949500","RTL_BOX_MTRL_ID":"949500","RTL_BOX_SITE_ID":"CS75","RTL_BOX_SKU":"BX80660E52630V4","RTL_BOX_MANUFACTURE_DT":"2016-08-19T00:00:00-07:00","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Box_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L               ","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SHP_CUST_GEO_CD":"EMEA","DN_TYPE":"WO_CUST","SHP_BOX_ID":"","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SKU":"BX80660E52630V4","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"IT"}],"Unit_x0020_Trace":[]}}}', null);
                
                Test.setMock(HttpCalloutMock.class, fakeResponse); 
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();    
                System.assertEquals(200, successResponse.Code);
                System.assertEquals(true,successResponse.IsSuccess);
            }
      }catch(Exception e){
          System.debug('*** testCaseOne' +e.getMessage());
      } 
    }    
  
  // Processor -Create
 private static testMethod void testCaseTwo() {
      try{
       User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
       System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Processor');
            request1.params.put('input1','X450B519');
            request1.params.put('input2','A0868');
            request1.params.put('mode','create');
            request1.params.put('returntype', 'AWR');
            RestContext.request = request1;
            RestContext.response = res;
            ICS_Support_Log_Transactions__c instrumentation = new ICS_Support_Log_Transactions__c(Name = 'WRProductSearch', Log__c = true);
            Database.insert(instrumentation);
            ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"CattsTcaOutputDataSet":{"Batch_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L               ","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SPEC_TYPE":"S","DN_TYPE":"WO_CUST","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SPEC_CODE":"R2R7","SKU":"BX80660E52630V4","SLD_CUST_COUNTRY_CD":"IT","SHP_CUST_GEO_CD":"EMEA"}],"Input_x0020_Report":[{"MTRL_ID":"948660","TRACE_RESULT":"CONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"92908","VALIDATION_STATUS":"PASSED","BATCH":"L069117020","SPEC_CODE":"R2R7","FINISH_DATE":"2016-08-02T23:27:32-07:00","FPO_LOT":"L626F718","BOX_ID":"KN1DSC73","BOX_TYPE":"TRAY","VISUAL_ID":"M6017LR800105","DN":"803712538","SN":"M6017LR800105","RTL_BOX_EPM_ID":"949500","RTL_BOX_MTRL_ID":"949500","RTL_BOX_SITE_ID":"CS75","RTL_BOX_SKU":"BX80660E52630V4","RTL_BOX_MANUFACTURE_DT":"2016-08-19T00:00:00-07:00","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Box_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L               ","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SHP_CUST_GEO_CD":"EMEA","DN_TYPE":"WO_CUST","SHP_BOX_ID":"","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SKU":"BX80660E52630V4","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"IT"}],"Unit_x0020_Trace":[]}}}', null);
                
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(200, successResponse.Code);
            System.assertEquals(true,successResponse.IsSuccess);
            }
      }catch(Exception e){
          System.debug('*** testCaseTwo' +e.getMessage());
      } 
    }    
    
    //Invalid prod type
    private static testMethod void testCaseThree() {
      try{
       User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
       System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.params.put('type','XXXX');
            request1.params.put('input1','X450B519');
            request1.params.put('input2','3E447120A0868');
            request1.params.put('mode','check');
            RestContext.request = request1;
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(9014, successResponse.Code);
            System.assertEquals(false,successResponse.IsSuccess);
       }
      }catch(Exception e){
          System.debug('*** testCaseThree' +e.getMessage());
      } 
    }    

    // Missing returntype for Create
 private static testMethod void testCaseFour() {
      try{
       User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
       System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.params.put('type','Processor');
            request1.params.put('input1','X450B519');
            request1.params.put('input2','3E447120A0868');
            request1.params.put('mode','create');
            RestContext.request = request1;
            Test.startTest();
               ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(9002, successResponse.Code);
            System.assertEquals(false,successResponse.IsSuccess);
            }
      }catch(Exception e){
          System.debug('*** testCaseFour' +e.getMessage());
      } 
    }  
    
    //Missing productype for -Check
 private static testMethod void testCaseFive() {
      try{
       User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
       System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','');
            request1.params.put('input2','M6017LR800105');
            request1.params.put('mode','check');
            RestContext.request = request1;
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(9002, successResponse.Code);
            System.assertEquals(false,successResponse.IsSuccess);
            }
      }catch(Exception e){
          System.debug('*** testCaseFive' +e.getMessage());
      } 
    }  
    
  //Non processor Board -Check
   private static testMethod void testCaseSix() {
      try{
       User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
       System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Board');
            request1.params.put('input1','H60945-201');
            request1.params.put('input2','G6SY548003MK');
            request1.params.put('mode','check');
            ICS_Support_Log_Transactions__c instrumentation = new ICS_Support_Log_Transactions__c(Name ='ProductSearch',Log__c = true);
            Insert instrumentation;
            RestContext.request = request1;
         Test.startTest();
            ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
         Test.stoptest();
         System.assertEquals(200, successResponse.Code);
         System.assertEquals(true,successResponse.IsSuccess);
       }
      }catch(Exception e){
          System.debug('testCaseSix'+e.getMessage());
      } 
    }

    //Non-Processor Other- Create
 private static testMethod void testCaseSeven() {
      try{
       User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
            System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Other');
            request1.params.put('input1','H60945-201');
            request1.params.put('input2','G6SY548003MK');
            request1.params.put('mode','create');
            request1.params.put('returntype', 'SWR');
            request1.params.put('oauth', testUser.id);
            RestContext.request = request1;
            ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"SerialNumber":"G6SY548003MK","PartNumberList":["H87090-502     ","943207"],"ReplacementFrequency":"0","ProcessCode":"0","ShipDate":"01/14/2016 12:00:00 AM","CountryCode":"NL","StolenProduct":"N","ReturnFrequency":"0"}', null);
                
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
                
            Test.stopTest();
            System.assertEquals(200, successResponse.Code);
            System.assertEquals(true,successResponse.IsSuccess);
            }
         
 /*---------------------09/11/21-------------------------------------------*/         
          Set<String> inputLists = new Set<String>();
      inputLists.add('AWR');
      inputLists.add('SRR');
      inputLists.add('SWR');
      ICS_Support_Warranty_Util.trimSet(inputLists);
         
        Set<String> lstMMId = new Set<String>{'801233'};
        Set<String> lstStockingId = new Set<String>{'CM8063701445001'};
        //Start--US77886---02-15-2018---Popcornapps
            Set<String> lstMMId1 = new Set<String>{'123456'};
            Set<String> lstStockingId1 = new Set<String>{'CM8063701445045'};
        //End--US77886---02-15-2018---Popcornapps
            String strProcessorType = Label.ICS_WR_Processor_Product_Type;
            List<String> lstProcessorType  = strProcessorType.split(';');
        List<String> lstString1 = new List<String>();
        lstString1.add('L233C405');
        map<String,List<String>> mapStockingIdATPO1 = new map<String,List<String>>();
        mapStockingIdATPO1.put('CM8063701445001',lstString1);
        map<String,List<String>> mapStockingIdATPO2 = new map<String,List<String>>();
        String productType = 'Non-Processor';
        String portalType='Agent';
        ICS_Support_Warranty_Util.addMMToProductWrapper(lstMMId, lstStockingId, lstProcessorType,mapStockingIdATPO1, productType, portalType);
        ICS_Support_Warranty_Util.addMMToProductWrapper(lstMMId, lstStockingId, lstProcessorType,mapStockingIdATPO2, productType, portalType);
          
        String SSDResp = '{"FERT":"801233","CustomerRegion":"US","ProductCode":"CM8063701445001","WarrantyExpire":"03/16/2021","ShippingDate":"03/17/2016","CustomerID":"0002022416 ","CustomerName":"ASI Computer Technologies","RecordFound":"1"}';            
        ICS_WR_ConsumingSNtrax_SSD.SSDResult SSDresponse = (ICS_WR_ConsumingSNtrax_SSD.SSDResult) JSON.deserialize(SSDResp,ICS_WR_ConsumingSNtrax_SSD.SSDResult.class);
        ICS_Support_Warranty_Util.processSSDResponse(SSDresponse, productType);
        ICS_Support_Warranty_Util.getGMTFormattedDate(SSDresponse.ShippingDate);
          
           Product2 prod = ICS_Support_TestdatasetupUtility.createProductForSearch();
            ICS_WR_MMID_BU_Hierarchy__c mmbuHierarchy = ICS_Support_WRTestdatasetupUtility.createMMBUHeirarchy(prod.id,'801233', '');
        ICS_Support_Warranty_Util.processSSDResponseDate(SSDresponse);
          
          String strLoggingUser = UserInfo.getUserId();
          List<User> loggedUser = [SELECT Id, Name, ContactId, AccountId, Profile.Name FROM User WHERE Id =:strLoggingUser LIMIT 1];
          ICS_Support_Warranty_Util.checkSRREligibilty(loggedUser[0].id);
          String productCategory = 'Processor';
          String ProductId = '';
          String FPOStockingNumber = '';
          String ATPOSerialNumber = '';
          String MMId = '';
          String validateJson = Json.serialize(new ICS_Support_WRcheck_Handler.WarrantyLineItemWarapper(ProductId, Label.ICS_Support_Line_Item_Number, productCategory, FPOStockingNumber, ATPOSerialNumber, MMId));
          ICS_WR_ConsumingSNtraxDATA.SerialNoResult syntraxResults = (ICS_WR_ConsumingSNtraxDATA.SerialNoResult) ICS_Support_Warranty_Util.callSyntraxSystem(validateJson);
          ICS_WR_ProcessorInfo_Util.ValidateProcessorResult cattsTcaResponse = (ICS_WR_ProcessorInfo_Util.ValidateProcessorResult) ICS_Support_Warranty_Util.callCattsTCASystem(validateJson);
          String jsondata = Json.serialize(cattsTcaResponse);
          String StockingId='';
          String strRMAType='';
          String strContactId='';
          String shipCountryCode='';
          String shipGeoCode='';
          String Syntxdata ='';
          String StrDepotId='';
          Boolean blnFraudCheck;
          String strSNTRAXResponses='';
          ICS_Support_Warranty_Util.doWarrantyCheckNonProcessorValidation(strSNTRAXResponses, validateJson, MMId, StockingId, strContactId, strDepotId, false);
          ICS_Support_Warranty_Util.ValidateFraudCheckNonProcessor(Syntxdata, validateJson, MMId, StockingId, strRMAType, strContactId, true, shipCountryCode, shipGeoCode);
          ICS_Support_Warranty_Util.ValidateFraudCheckProcessor(jsondata, validateJson, MMId, StockingId, strRMAType, strContactId, true, shipCountryCode, shipGeoCode);
        
/*-----------------------------------end----------9/11/21---------------------------------*/          
      }catch(Exception e){
          System.debug('*** testCaseSeven' +e.getMessage());
      } 
    }  
    
 //SSD- CHECK
 private static testMethod void testCaseEight() {
      try{
           User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
       System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Memory');
            request1.params.put('input1','');
            request1.params.put('input2','G6SY548003MK');
            request1.params.put('mode','check');
            RestContext.request = request1;
            ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"FERT":"943207","CustomerRegion":"NL","ProductCode":"BOXNUC6I5SYH   ","WarrantyExpire":"04/13/2019","ShippingDate":"01/14/2016","CustomerID":"6000129551          ","CustomerName":"Arrow Central Europe / Microtronica","RecordFound":"1"}', null);
                
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
            Test.startTest();
                 ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(200, successResponse.Code);
            System.assertEquals(true,successResponse.IsSuccess);
       }
      }catch(Exception e){
          System.debug('*** testCaseEight' +e.getMessage());
      } 
    }  
    
    //InvalidUserException
     private static testMethod void testCaseNine() {
      try{
        ID testProfile = ICS_Support_TestdatasetupUtility.fetchProfileId('Test User');
        //Invalid portal User
        User invalidUser = ICS_Support_TestdatasetupUtility.createUser(testProfile, null, 'testUser@abc.com', 'Invalid User', 'testUser@abc.com');
       System.runAs(invalidUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.params.put('type','Memory');
            request1.params.put('input1','H60945-201');
            request1.params.put('input2','G6SY548003MK');
            request1.params.put('mode','create');
            request1.params.put('returntype', 'SWR');
            RestContext.request = request1;
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(9004, successResponse.Code);
            System.assertEquals(false,successResponse.IsSuccess);
       }
      }catch(Exception e){
          System.debug('*** testCaseNine' +e.getMessage());
      } 
    }
    
    //No data returned for a search- No result found
     private static testMethod void testCaseTen() {
      try{
          User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
       System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Processor');
            request1.params.put('input1','3332B762');
            request1.params.put('input2','');
            request1.params.put('mode','create');
            request1.params.put('returntype','SWR');
            RestContext.request = request1;
            RestContext.response = res;
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(200, successResponse.Code);
            System.assertEquals(true,successResponse.IsSuccess);
       }
      }catch(Exception e){
          System.debug('*** testCaseTen' +e.getMessage());
      } 
    }  
    
    //fpo NOT Entered for processor search in check mode
     private static testMethod void testCaseEleven() {
      try{
          User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
      System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Processor');
            request1.params.put('input1','');
            request1.params.put('input2','2L314033A0637');
            request1.params.put('mode','check');
            RestContext.request = request1;
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(200, successResponse.Code);
            System.assertEquals(true,successResponse.IsSuccess);
       }
      }catch(Exception e){
          System.debug('*** testCaseEleven' +e.getMessage());
      } 
    }  
    
  //Invalid returntype
     private static testMethod void testCaseTwelve() {
      try{
      User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
      System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Processor');
            request1.params.put('input1','L316B433');
            request1.params.put('input2','A0637');
            request1.params.put('mode','create');
            request1.params.put('returntype','XXX');
            RestContext.request = request1;
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(9014, successResponse.Code);
            System.assertEquals(false,successResponse.IsSuccess);
        }
      }catch(Exception e){
          System.debug('*** testCaseTwelve' +e.getMessage());
      } 
    }
   //Invalid mode 
   private static testMethod void testCaseThirteen() {
      try{
           User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
      System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Processor');
            request1.params.put('input1','L316B433');
            request1.params.put('input2','A0637');
            request1.params.put('mode','xxx');
            RestContext.request = request1;
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(9014, successResponse.Code);
            System.assertEquals(false,successResponse.IsSuccess);
       }
      }catch(Exception e){
          System.debug('*** testCaseThirteen' +e.getMessage());
      } 
    }
    
  //only FPO processor 
   private static testMethod void testCaseFourteen() {
      try{
          User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
      System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Processor');
            request1.params.put('input1','L626F718');
            request1.params.put('input2', '');
            request1.params.put('mode','check');
            RestContext.request = request1;
            RestContext.response = res;
            
            ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"CattsTcaOutputDataSet":{"Batch_x0020_Report":[{"SHP_CUST_NM":"FLEXTRONICS AMERICA LLC            ","SHP_CUST_ID":"6038573740","SHP_CUST_COUNTRY_NM":"United States","MTRL_ID":"948660","SHP_CUST_COUNTRY_CD":"US","SHP_MEDIA_TYPE":"TRAY","DN":"803452235","SHP_CUST_GEO_CD":"ASMO-NA","DN_TYPE":"WO_CUST","SHP_BOX_ID":"DMX96541","AGID_DATE":"2016-08-05T23:18:27-07:00","BATCH":"L626F718","SKU":"CM8066002032301","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"US"},"Input_x0020_Report":[{"MTRL_ID":"948660","TRACE_RESULT":"INCONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"92908","VALIDATION_STATUS":"PASSED","BATCH":"L626F718","SPEC_CODE":"R2R7","FINISH_DATE":"2016-08-02T23:27:32-07:00","FPO_LOT":"NA","BOX_ID":"","BOX_TYPE":"","VISUAL_ID":"","DN":"","SN":"","RTL_BOX_EPM_ID":"","RTL_BOX_MTRL_ID":"","RTL_BOX_SITE_ID":"","RTL_BOX_SKU":"","RTL_BOX_MANUFACTURE_DT":"","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Unit_x0020_Trace":[]}}}', null);
                
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(200, successResponse.Code);
            System.assertEquals(true,successResponse.IsSuccess);
       }
      }catch(Exception e){
          System.debug('*** testCaseThirteen' +e.getMessage());
      } 
    }
    
 //MiniPC- Search in check mode
 private static testMethod void testCaseFifteen() {
      try{
          User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
      System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','MiniPC');
            request1.params.put('input1','G6SY548003MK');
            request1.params.put('mode','check');
            RestContext.request = request1;
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(200, successResponse.Code);
            System.assertEquals(true,successResponse.IsSuccess);
       }
      }catch(Exception e){
          System.debug('*** testCaseFifteen' +e.getMessage());
      } 
    } 
    //Missing inputs for SSD Search in check mode
    private static testMethod void testCaseSixteen() {
      try{
          User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
      System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Memory');
            //request1.params.put('input1', );
            request1.params.put('mode','check');
            RestContext.request = request1;
            Test.startTest();
                 ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(9002, successResponse.Code);
            System.assertEquals(false,successResponse.IsSuccess);
       }
      }catch(Exception e){
          System.debug('*** testCaseSixteen' +e.getMessage());
      } 
    }  
    
    //Invalid prod type for FUL search in create mode
    private static testMethod void testCaseSeventeen() {
      try{
      User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
      System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Processor');
            request1.params.put('input1','X450B519');
            request1.params.put('input2','A0868');
            request1.params.put('mode','create');
            request1.params.put('returntype', 'FUL');
            RestContext.request = request1;
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(9014, successResponse.Code);
            System.assertEquals(false,successResponse.IsSuccess);
        }
      }catch(Exception e){
          System.debug('*** testCaseSeventeen' +e.getMessage());
      } 
    }  
    
    //Required check for mode
    private static testMethod void testCaseEighteen() {
      try{
          User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
          System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Processor');
            request1.params.put('input1','X450B519');
            request1.params.put('input2','A0868');
            RestContext.request = request1;
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
                ICS_Support_WRProductSearch_Handler handler = new ICS_Support_WRProductSearch_Handler();
                
            Test.stopTest();
            System.assertEquals(9002, successResponse.Code);
            System.assertEquals(false,successResponse.IsSuccess);
          }    
      }catch(Exception e){
          System.debug('*** testCaseEighteen' +e.getMessage());
      } 
    }
    
    //Create returntype = SRR
    private static testMethod void testCaseNineteen() {
      try{
      User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
      System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','MiniPC');
            request1.params.put('input1','H60945-201');
            request1.params.put('input2','G6SY548003MK');
            request1.params.put('mode','create');
            request1.params.put('returntype','SRR');
            request1.params.put('oauth', testUser.id);
            RestContext.request = request1;
            RestContext.response = res;
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(200, successResponse.Code);
            System.assertEquals(true,successResponse.IsSuccess);
        }
      }catch(Exception e){
          System.debug('*** testCaseNineteen' +e.getMessage());
      } 
    }  
     
    //Create returntype = SRR
    private static testMethod void testCaseNineteen1() {
      try{
         
         User testUser = [SELECT Id FROM User WHERE  UserName='lalithageouser@abc.com'LIMIT 1];
        System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','MiniPC');
            request1.params.put('input1','H60945-201');
            request1.params.put('input2','G6SY548003MK');
            request1.params.put('mode','create');
            request1.params.put('returntype','SRR');
            request1.params.put('oauth', testUser.id);
            RestContext.request = request1;
            RestContext.response = res;
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(200, successResponse.Code);
            System.assertEquals(true,successResponse.IsSuccess);
        }
      }catch(Exception e){
          System.debug('*** testCaseNineteen' +e.getMessage());
      } 
    }  
     
    //SSD - Check mode Only Stocking number provided..missing serial no
    private static testMethod void testCaseTwenty() {
      try{
          User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
      System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Memory');
            request1.params.put('input1','H60945-201');
            request1.params.put('input2','');
            request1.params.put('mode','check');
            RestContext.request = request1;
            RestContext.response = res;
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(200, successResponse.Code);
            System.assertEquals(true,successResponse.IsSuccess);
       } 
      }catch(Exception e){
          System.debug('*** testCaseTwenty' +e.getMessage());
      } 
    } 
    //Create mode - Non-Processor & FUL type of warranty 
     private static testMethod void testCaseTwentyOne() {
      try{
      User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
      System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Other');
            request1.params.put('input1','H60945-201');
            request1.params.put('input2','G6SY548003MK');
            request1.params.put('mode','create');
            request1.params.put('returntype','FUL');
            RestContext.request = request1;
            RestContext.response = res;
            ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"FERT":"943207","CustomerRegion":"NL","ProductCode":"BOXNUC6I5SYH   ","WarrantyExpire":"04/13/2019","ShippingDate":"01/14/2016","CustomerID":"6000129551          ","CustomerName":"Arrow Central Europe / Microtronica","RecordFound":"1"}', null);
                
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
            Test.startTest();
                 ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(200, successResponse.Code);
            System.assertEquals(true,successResponse.IsSuccess);
        }
      }catch(Exception e){
          System.debug('*** testCaseTwentyOne' +e.getMessage());
      } 
    } 
  
      //SiteUserLoginException scenario
     private static testMethod void testCaseTwenty2() {
      try{
      ID anonymousProfile = ICS_Support_TestdatasetupUtility.fetchProfileId('Anonymous API Profile');
      //Anonymous User
      User anonymousUser = ICS_Support_TestdatasetupUtility.createUser(anonymousProfile, null, 'anonymous@abc.com', 'Anonymous_Community User', 'anonymous@abc.com');
      System.runAs(anonymousUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.params.put('type','Other');
            request1.params.put('input1','H60945-201');
            request1.params.put('input2','G6SY548003MK');
            request1.params.put('mode','create');
            request1.params.put('returntype','FUL');
            RestContext.request = request1;
            RestContext.response = res;
            ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"FERT":"943207","CustomerRegion":"NL","ProductCode":"BOXNUC6I5SYH   ","WarrantyExpire":"04/13/2019","ShippingDate":"01/14/2016","CustomerID":"6000129551          ","CustomerName":"Arrow Central Europe / Microtronica","RecordFound":"1"}', null);
                
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
            Test.startTest();
                 ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(9010, successResponse.Code);
            System.assertEquals(false,successResponse.IsSuccess);
        }
      }catch(Exception e){
          System.debug('*** testCaseTwenty2' +e.getMessage());
      } 
    } 
    
 //SSD- CREATE
 private static testMethod void testCaseTwenty3() {
      try{
          User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
       System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Memory');
            request1.params.put('input1','H74562-402');
            request1.params.put('input2','G6SY548003MK');
            request1.params.put('mode','create');
            request1.params.put('returntype','AWR');
            RestContext.request = request1;
            ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"SerialNumber":"G6SY548003MK","PartNumberList":["H87090-502     ","943207"],"ReplacementFrequency":"0","ProcessCode":"0","ShipDate":"01/14/2016 12:00:00 AM","CountryCode":"NL","StolenProduct":"N","ReturnFrequency":"0"}',null);
                
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
            Test.startTest();
                 ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();
            System.assertEquals(200, successResponse.Code);
            System.assertEquals(true,successResponse.IsSuccess);
       }
      }catch(Exception e){
          System.debug('*** testCaseTwenty3' +e.getMessage());
      } 
    }  
    
 // Processor - Check - Invalid ATPO
 private static testMethod void testCaseTwenty4() {
      try{
        User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
        System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Processor');
            request1.params.put('input1','L626F718');
            request1.params.put('input2','&&&&&&TESTATPOINVALID');
            request1.params.put('mode','check');
            RestContext.request = request1;
            RestContext.response = res;
            ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"CattsTcaOutputDataSet":{"Batch_x0020_Report":[{"SHP_CUST_NM":"FLEXTRONICS AMERICA LLC            ","SHP_CUST_ID":"6038573740","SHP_CUST_COUNTRY_NM":"United States","MTRL_ID":"948660","SHP_CUST_COUNTRY_CD":"US","SHP_MEDIA_TYPE":"TRAY","DN":"803452235","SHP_CUST_GEO_CD":"ASMO-NA","DN_TYPE":"WO_CUST","SHP_BOX_ID":"DMX96541","AGID_DATE":"2016-08-05T23:18:27-07:00","BATCH":"L626F718","SKU":"CM8066002032301","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"US"}],"Input_x0020_Report":[{"MTRL_ID":"948660","TRACE_RESULT":"INCONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"92908","VALIDATION_STATUS":"PASSED","BATCH":"L626F718","SPEC_CODE":"R2R7","FINISH_DATE":"2016-08-02T23:27:32-07:00","FPO_LOT":"NA","BOX_ID":"","BOX_TYPE":"BOX","VISUAL_ID":"","DN":"","SN":"","RTL_BOX_EPM_ID":"","RTL_BOX_MTRL_ID":"","RTL_BOX_SITE_ID":"","RTL_BOX_SKU":"","RTL_BOX_MANUFACTURE_DT":"","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Unit_x0020_Trace":[]}}}', null);
                
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();    
            System.assertEquals(200, successResponse.Code);
            System.assertEquals(true,successResponse.IsSuccess);
        }
       }catch(Exception e){
          System.debug('*** testCaseTwenty4' +e.getMessage());
      } 
    } 
    
 // Processor - Partial ATPO Search
 private static testMethod void testCaseTwenty5() {
      try{
        User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
        System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Processor');
            request1.params.put('input1','L626F718');
            request1.params.put('input2','00105');
            request1.params.put('mode','check');
            RestContext.request = request1;
            RestContext.response = res;
            
            ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"CattsTcaOutputDataSet":{"Batch_x0020_Report":[{"SHP_CUST_NM":"ARROW CENTRAL EUROPE / MICROTRONICA","SHP_CUST_ID":"6000129551","SHP_CUST_COUNTRY_NM":"Netherlands","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"NL","SHP_MEDIA_TYPE":"BOX","DN":"803553286","SHP_CUST_GEO_CD":"EMEA","DN_TYPE":"WO_CUST","SHP_BOX_ID":"","AGID_DATE":"2016-09-06T03:33:17-07:00","BATCH":"L626F718","SKU":"BX80660E52630V4","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"DE"}],"Input_x0020_Report":[{"MTRL_ID":"948660","TRACE_RESULT":"INCONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"92908","VALIDATION_STATUS":"PASSED","BATCH":"L626F718","SPEC_CODE":"R2R7","FINISHDATE":"2016-08-02T23:27:32-07:00","FPO_LOT":"NA","BOX_ID":"","BOX_TYPE":"","VISUAL_ID":"","DN":"","SN":"","RTL_BOX_EPM_ID":"","RTL_BOX_MTRL_ID":"","RTL_BOX_SITE_ID":"","RTL_BOX_SKU":"","RTL_BOX_MANUFACTURE_DT":"","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Unit_x0020_Trace":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L               ","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","VISUAL_ID":"M6017LR800105","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SPEC_TYPE":"S","DN_TYPE":"WO_CUST","SHP_BOX_ID":"","AGID_DATE":"2016-10-29T02:09:05-07:00","EPM_ID":"93063","BATCH":"L626F718","SPEC_CODE":"R2R7","SKU":"BX80660E52630V4","FPO_BATCH":"","SHP_CUST_GEO_CD":"EMEA","SLD_CUST_COUNTRY_CD":"IT"}]}}}', null);
                
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
                List<ICS_Support_Warranty_Util.ProductWrapper> productsFromSearch = ICS_Support_Warranty_Util.getSearchedProducts('Processor','',null,'check','Support');
            Test.stopTest();    
                System.assertEquals(200, successResponse.Code);
                System.assertEquals(true,successResponse.IsSuccess);
            }
      }catch(Exception e){
          System.debug('*** testCaseTwenty5' +e.getMessage());
      } 
    }
    
// Processor - TRAY PROCESSOR
 private static testMethod void testCaseTwenty6() {
      try{
        User testUser = [SELECT Id FROM User WHERE UserName='tchauhanItp@abc.com' LIMIT 1];
        System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Processor');
            request1.params.put('input1','3332B762');
            request1.params.put('input2','2L342249A3352');
            request1.params.put('mode','check');
            RestContext.request = request1;
            RestContext.response = res;
            
            ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"CattsTcaOutputDataSet":{"Box_x0020_Report":[{"SHP_CUST_NM":"T31/T33/T38/VMI/FG-CC100           ","SHP_CUST_ID":"FG01MYA5","SHP_CUST_COUNTRY_NM":"Malaysia","MTRL_ID":"927928","SHP_CUST_COUNTRY_CD":"MY","SHP_MEDIA_TYPE":"TRAY","DN":"800402170","SHP_CUST_GEO_CD":"APAC","DN_TYPE":"WO_VMI","SHP_BOX_ID":"XQ18Y363","AGID_DATE":"2013-11-19T20:52:04-07:00","BATCH":"3332B762","SKU":"CM8064601464303","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"US"}],"Input_x0020_Report":[{"MTRL_ID":"927928","TRACE_RESULT":"CONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"72290","VALIDATION_STATUS":"PASSED","BATCH":"3332B762","SPEC_CODE":"R149","FINISH_DATE":"2013-11-18T08:30:38-07:00","FPO_LOT":"3332B762","BOX_ID":"XQ18Y363","BOX_TYPE":"TRAY","VISUAL_ID":"2L342249A3352","DN":"","SN":"","RTL_BOX_EPM_ID":"","RTL_BOX_MTRL_ID":"","RTL_BOX_SITE_ID":"","RTL_BOX_SKU":"","RTL_BOX_MANUFACTURE_DT":"","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Unit_x0020_Trace":[{"SHP_CUST_NM":"DELL (XIAMEN) COMPANY LIMITED      ","SHP_CUST_ID":"6000140277","SHP_CUST_COUNTRY_NM":"China","VISUAL_ID":"2L342249A3352","MTRL_ID":"927928","SHP_CUST_COUNTRY_CD":"CN","SHP_MEDIA_TYPE":"TRAY","DN":"800433527","SPEC_TYPE":"S","DN_TYPE":"WO_CUST","SHP_BOX_ID":"XQ18Y363","AGID_DATE":"2013-11-28T01:56:28-07:00","EPM_ID":"72290","BATCH":"3332B762","SPEC_CODE":"R149","SKU":"CM8064601464303","FPO_BATCH":"","SHP_CUST_GEO_CD":"PROC","SLD_CUST_COUNTRY_CD":"CN"}]}}}', null);
                
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();    
                System.assertEquals(200, successResponse.Code);
                System.assertEquals(true,successResponse.IsSuccess);
            }
      }catch(Exception e){
          System.debug('*** testCaseTwenty6' +e.getMessage());
      } 
    }
    //Test method to cover depot determination snippet for contact with Mailing country
    private static testMethod void testCaseTwenty7() {
      
        User testUser = [SELECT Id FROM User WHERE UserName='lalithamailcon@abc.com' LIMIT 1];
        System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Processor');
            request1.params.put('input1','3332B762');
            request1.params.put('input2','2L342249A3352');
            request1.params.put('mode','check');
            RestContext.request = request1;
            RestContext.response = res;
            
            ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"CattsTcaOutputDataSet":{"Box_x0020_Report":[{"SHP_CUST_NM":"T31/T33/T38/VMI/FG-CC100           ","SHP_CUST_ID":"FG01MYA5","SHP_CUST_COUNTRY_NM":"Malaysia","MTRL_ID":"927928","SHP_CUST_COUNTRY_CD":"MY","SHP_MEDIA_TYPE":"TRAY","DN":"800402170","SHP_CUST_GEO_CD":"APAC","DN_TYPE":"WO_VMI","SHP_BOX_ID":"XQ18Y363","AGID_DATE":"2013-11-19T20:52:04-07:00","BATCH":"3332B762","SKU":"CM8064601464303","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"US"}],"Input_x0020_Report":[{"MTRL_ID":"927928","TRACE_RESULT":"CONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"72290","VALIDATION_STATUS":"PASSED","BATCH":"3332B762","SPEC_CODE":"R149","FINISH_DATE":"2013-11-18T08:30:38-07:00","FPO_LOT":"3332B762","BOX_ID":"XQ18Y363","BOX_TYPE":"TRAY","VISUAL_ID":"2L342249A3352","DN":"","SN":"","RTL_BOX_EPM_ID":"","RTL_BOX_MTRL_ID":"","RTL_BOX_SITE_ID":"","RTL_BOX_SKU":"","RTL_BOX_MANUFACTURE_DT":"","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Unit_x0020_Trace":[{"SHP_CUST_NM":"DELL (XIAMEN) COMPANY LIMITED      ","SHP_CUST_ID":"6000140277","SHP_CUST_COUNTRY_NM":"China","VISUAL_ID":"2L342249A3352","MTRL_ID":"927928","SHP_CUST_COUNTRY_CD":"CN","SHP_MEDIA_TYPE":"TRAY","DN":"800433527","SPEC_TYPE":"S","DN_TYPE":"WO_CUST","SHP_BOX_ID":"XQ18Y363","AGID_DATE":"2013-11-28T01:56:28-07:00","EPM_ID":"72290","BATCH":"3332B762","SPEC_CODE":"R149","SKU":"CM8064601464303","FPO_BATCH":"","SHP_CUST_GEO_CD":"PROC","SLD_CUST_COUNTRY_CD":"CN"}]}}}', null);
                
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();    
                System.assertEquals(200, successResponse.Code);
                System.assertEquals(true,successResponse.IsSuccess);
            }
      
    }
    //Test method to cover depot determination snippet (cip changes)
    private static testMethod void testCaseTwenty8() {
      
        User testUser = [SELECT Id FROM User WHERE UserName='lalithageouser@abc.com' LIMIT 1];
        System.runAs(testUser){
            RestRequest request1 = new RestRequest();
            RestResponse res = new RestResponse();
            request1.requestUri ='/services/apexrest/support/v1.0/warranty/products/search/'; 
            request1.httpMethod = 'GET';
            request1.addHeader('client_id', '123456789');
            request1.params.put('type','Processor');
            request1.params.put('input1','3332B762');
            request1.params.put('input2','2L342249A3352');
            request1.params.put('mode','check');
            RestContext.request = request1;
            RestContext.response = res;
            
            ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"CattsTcaOutputDataSet":{"Box_x0020_Report":[{"SHP_CUST_NM":"T31/T33/T38/VMI/FG-CC100           ","SHP_CUST_ID":"FG01MYA5","SHP_CUST_COUNTRY_NM":"Malaysia","MTRL_ID":"927928","SHP_CUST_COUNTRY_CD":"MY","SHP_MEDIA_TYPE":"TRAY","DN":"800402170","SHP_CUST_GEO_CD":"APAC","DN_TYPE":"WO_VMI","SHP_BOX_ID":"XQ18Y363","AGID_DATE":"2013-11-19T20:52:04-07:00","BATCH":"3332B762","SKU":"CM8064601464303","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"US"}],"Input_x0020_Report":[{"MTRL_ID":"927928","TRACE_RESULT":"CONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"72290","VALIDATION_STATUS":"PASSED","BATCH":"3332B762","SPEC_CODE":"R149","FINISH_DATE":"2013-11-18T08:30:38-07:00","FPO_LOT":"3332B762","BOX_ID":"XQ18Y363","BOX_TYPE":"TRAY","VISUAL_ID":"2L342249A3352","DN":"","SN":"","RTL_BOX_EPM_ID":"","RTL_BOX_MTRL_ID":"","RTL_BOX_SITE_ID":"","RTL_BOX_SKU":"","RTL_BOX_MANUFACTURE_DT":"","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Unit_x0020_Trace":[{"SHP_CUST_NM":"DELL (XIAMEN) COMPANY LIMITED      ","SHP_CUST_ID":"6000140277","SHP_CUST_COUNTRY_NM":"China","VISUAL_ID":"2L342249A3352","MTRL_ID":"927928","SHP_CUST_COUNTRY_CD":"CN","SHP_MEDIA_TYPE":"TRAY","DN":"800433527","SPEC_TYPE":"S","DN_TYPE":"WO_CUST","SHP_BOX_ID":"XQ18Y363","AGID_DATE":"2013-11-28T01:56:28-07:00","EPM_ID":"72290","BATCH":"3332B762","SPEC_CODE":"R149","SKU":"CM8064601464303","FPO_BATCH":"","SHP_CUST_GEO_CD":"PROC","SLD_CUST_COUNTRY_CD":"CN"}]}}}', null);
                
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
            Test.startTest();
                ICS_Support_WRProductSearch_Handler.ResponseWrapper successResponse = ICS_Support_WRProductSearch.getWarrantyProducts();
            Test.stopTest();    
                System.assertEquals(200, successResponse.Code);
                System.assertEquals(true,successResponse.IsSuccess);
            }
      
    }
    
 @testSetup 
 static void setup() {
  try{
      
      
      	ICS_IPA_TestDataSetupUtility.createIPACustomSettingData();
       	ICS_IPA_TestDataSetupUtility.createeRPMCustomSettingData();
      	
      	list<ICS_APIGEE_ConfigSettings__c> custSetting = new list<ICS_APIGEE_ConfigSettings__c>();
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='Sntrax',ClientId__c='7e3eb6a4-f29f-4d59-bcd1-e2cc77458f1e',Client_Secret__c='i9mYqkVDV38Gwc1oJ~Pc~UG_eh05-~89.y',Class_Name__c='WR_APIGEE_SNtrax',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/warranty/v1/sntrax?serialNumber=',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
    
        custSetting.add(new ICS_APIGEE_ConfigSettings__c(Name='CattsTCA',ClientId__c='7e3eb6a4-f29f-4d59-bcd1-e2cc77458f1e',Client_Secret__c='i9mYqkVDV38Gwc1oJ~Pc~UG_eh05-~89.y',Class_Name__c='ICS_WR_Consuming_CATTS_TCA_Data',GrantType__c='client_credentials',setEndPointURL__c='https://apis-stage.intel.com/m2r/warranty/v1/catts-tca/ship/processors?',TokenEndPointURL__c='https://apis-stage.intel.com/v1/auth/token'));
    insert custSetting;

      	
        ID userProfile = ICS_Support_TestdatasetupUtility.fetchProfileId('ICS Customer Community Web Portal'); 
        //ITP User  
        ID accRecordTypeId  = ICS_Support_TestdatasetupUtility.fetchRecordTypeId('Account','Non_Editable_Accounts');
        ID conRecordTypeId  = ICS_Support_TestdatasetupUtility.fetchRecordTypeId('Contact','Non_Editable_Contacts');
        
        Account acc = ICS_Support_WRTestdatasetupUtility.createEntAccount(accRecordTypeId,'ITPCustomer','GOLD');
        Contact con = ICS_Support_TestdatasetupUtility.createAdvancedContact(conRecordTypeId, acc.Id,'testITPContact','tchauhanItp@abc.com'); 
      	con.ICS_IPA_Warranty_Requestor__c=true;
      	update con;
      
        User testUser = ICS_Support_TestdatasetupUtility.createUser(userProfile, con.id, 'tchauhanItp@abc.com', 'SupportApp_Community User', 'tchauhanItp@abc.com');
        
        Account accCIP = ICS_Support_WRTestdatasetupUtility.createCIPAccount(accRecordTypeId,'ITPCustomerGEO','GOLD','NEW');
        
        Contact conCIP = ICS_Support_TestdatasetupUtility.createAdvancedContact(conRecordTypeId, accCIP.Id,'ITPContactGeo','lalithageouser@abc.com'); 
        
        User testUser1 = ICS_Support_TestdatasetupUtility.createUser(userProfile, conCIP.id, 'lalithageouser@abc.com', 'SupportApp_Community User', 'lalithageouser@abc.com');
        
        contact conMailC = new contact();
        conMailC.LastName='Mailing Con';
        conMailC.RecordTypeId=conRecordTypeId;
        conMailC.AccountId=acc.Id;
        conMailC.Core_Language__c='English';
        conMailC.Email='lalithamailcon@abc.com';
        conMailC.Core_Is_Consumer__c=false;
        conMailC.Core_Web_Ticketing_User__c=true;
        conMailC.MailingCountry = 'USA';
        Database.insert(conMailC);
        
        User testUser2 = ICS_Support_TestdatasetupUtility.createUser(userProfile, conMailC.id, 'lalithamailcon@abc.com', 'SupportApp_Community User', 'lalithamailcon@abc.com');
        
        ICS_WR_Entitlement_Configuration__c entitlementInfo = ICS_Support_WRTestdatasetupUtility.createEntConfig('GOLD');
        
        Product2 prod = ICS_Support_TestdatasetupUtility.createProductForSearch();
        Product2 prod1 = ICS_Support_TestdatasetupUtility.createProductForSearch('Boxed Intel® Celeron® Processor G1610 (2M Cache, 2.60 GHz) FC-LGA12C', true, true, true, null);
      //  Product_Hierarchy__c prodHierarchy = ICS_Support_TestdatasetupUtility.createProductHierarchyForTextSearch(prod.Id,'5500');
        Product_Hierarchy__c hierarchy2 = ICS_Support_TestdatasetupUtility.createProductHierarchy('', '', '7718', '50544', '7719', '50545', prod1.id, true);
        
        System.debug('*** prod inserted ***' + prod);
       // System.debug('*** setup prodHierarchy ***'+prodHierarchy);
        List<ICS_WR_Processor_Validation_Codes__c> lstpacs = new List<ICS_WR_Processor_Validation_Codes__c>();
    
        ICS_WR_Processor_Validation_Codes__c paccs3 = new ICS_WR_Processor_Validation_Codes__c();
        paccs3.Name = '14';
        paccs3.ICS_WR_Validation_Code__c = 'PMFT-014';
       
        ICS_WR_Processor_Validation_Codes__c paccs4 = new ICS_WR_Processor_Validation_Codes__c();
        paccs4.Name = '15';
        paccs4.ICS_WR_Validation_Code__c = 'PMFT-015';
       
        ICS_WR_Processor_Validation_Codes__c paccs5 = new ICS_WR_Processor_Validation_Codes__c();
        paccs5.Name = '35';
        paccs5.ICS_WR_Validation_Code__c = 'PMFT-035';
       
        ICS_WR_Processor_Validation_Codes__c paccs6 = new ICS_WR_Processor_Validation_Codes__c();
        paccs6.Name = '34';
        paccs6.ICS_WR_Validation_Code__c = 'PMFT-034';
       
        ICS_WR_Processor_Validation_Codes__c paccs7 = new ICS_WR_Processor_Validation_Codes__c();
        paccs7.Name = '19';
        paccs7.ICS_WR_Validation_Code__c = 'PMFT-019';
       
        lstpacs.add(paccs3);
        lstpacs.add(paccs4);
        lstpacs.add(paccs5);
        lstpacs.add(paccs6);
        lstpacs.add(paccs7);
    
        Database.insert(lstpacs);
       
        List<ICS_WR_Processor_Return_Frequency__c> lstFrequencyData = new List<ICS_WR_Processor_Return_Frequency__c>();
        ICS_WR_Processor_Return_Frequency__c objFrequency = new ICS_WR_Processor_Return_Frequency__c();
        objFrequency.ICS_WR_FPO_ATPO__c = 'L626F718';
        objFrequency.ICS_WR_Frequency__c = 4;
       
        ICS_WR_Processor_Return_Frequency__c objFrequency1 = new ICS_WR_Processor_Return_Frequency__c();
        objFrequency1.ICS_WR_FPO_ATPO__c = 'M6017LR800105';
        objFrequency1.ICS_WR_Frequency__c = 4;
       
        lstFrequencyData.add(objFrequency);
        lstFrequencyData.add(objFrequency1);
        Database.insert(lstFrequencyData);
       
        List<ICS_WR_Processor_Return_Hotlist__c> lstHotlistData = new List<ICS_WR_Processor_Return_Hotlist__c>();
        ICS_WR_Processor_Return_Hotlist__c objHotlist = new ICS_WR_Processor_Return_Hotlist__c();
        objHotlist.ICS_WR_FPO_ATPO__c = 'L626F718';
        objHotlist.ICS_WR_Hotlist_Reason_ID__c = 2;
        ICS_WR_Processor_Return_Hotlist__c objHotlist1 = new ICS_WR_Processor_Return_Hotlist__c();
        objHotlist1.ICS_WR_FPO_ATPO__c = 'M6017LR800105';
        objHotlist1.ICS_WR_Hotlist_Reason_ID__c = 4;
        lstHotlistData.add(objHotlist);
        lstHotlistData.add(objHotlist1);
        Database.insert(lstHotlistData);
       
        List<ICS_WR_Processor_Plan_Activation_Code__c> listPAC=new List<ICS_WR_Processor_Plan_Activation_Code__c> ();
        ICS_WR_Processor_Plan_Activation_Code__c objPAC= new ICS_WR_Processor_Plan_Activation_Code__c(ICS_WR_Plan_Activation_Code__c ='0092IVR4',ICS_WR_Plan_Refunded__c=false,ICS_WR_Plan_Status_Code__c='Claimed',ICS_WR_SKU__c='CM8066002032301');
        listPAC.add(objPAC);
        Database.insert(listPAC);
        //Stocking
        ICS_WR_Stocking__c stocking = ICS_Support_WRTestdatasetupUtility.createStocking('BX80660E52630V4', 'BX80660E52630V4'); //PROCESSOR SEARCH
        //NON-PROCESSOR
        ICS_WR_Stocking__c stocking2 = new ICS_WR_Stocking__c(); 
        stocking2.Name = 'H60945-201'; 
        stocking2.ICS_WR_iPaas_External_ID__c = 'H60945-201'; 
        stocking2.ICS_WR_Active__c = true; 
        stocking2.ICS_WR_Category_ID__c = 'BOARD';
        Database.insert(stocking2); 
                 
        //MMBUhierarchy
        ICS_WR_MMID_BU_Hierarchy__c mmbuHierarchy = ICS_Support_WRTestdatasetupUtility.createMMBUHeirarchy(prod.id,'949500', '');
        ICS_WR_MMID_BU_Hierarchy__c mmbuHierarchy2 = ICS_Support_WRTestdatasetupUtility.createMMBUHeirarchy(prod.id,'943207', 'NZ');
        
        
        //MMStock
        ICS_WR_MM_Stocking__c mmstock1 = ICS_Support_WRTestdatasetupUtility.createMMStocking(stocking.id, mmbuHierarchy.id);
        ICS_WR_MM_Stocking__c mmstock2 = ICS_Support_WRTestdatasetupUtility.createMMStocking(stocking2.id, mmbuHierarchy2.id);
        
        //Depotid
        ICS_WR_Depot__c depot = ICS_Support_WRTestdatasetupUtility.createDepot('India DEPOT', 'India');
        ICS_WR_Depot__c depot2 = ICS_Support_WRTestdatasetupUtility.createDepot('Louisville Depot', 'US');
        //Depotstock
        ICS_WR_Depot_Stock__c depotStock = ICS_Support_WRTestdatasetupUtility.createDepotStock(depot.id,stocking.id,'AWR',false,'12345');
        ICS_WR_Depot_Stock__c depotStock2 = ICS_Support_WRTestdatasetupUtility.createDepotStock(depot2.id,stocking2.id,'SWR',true,'67890');
        
        System.debug('***Stocking===' + stocking +stocking2);
        System.debug('***MMBU==='+mmbuHierarchy);
        System.debug('***MMStock==='+mmstock1);
        System.debug('***Depot==='+depot + depot2);
        System.debug('***Depotstock==='+depotStock + depotStock2);
       
           
        List<ICS_WR_Warranty_Transaction_Types__c> listOfTransactionTypes = new List<ICS_WR_Warranty_Transaction_Types__c>();
        ICS_WR_Warranty_Transaction_Types__c   trantypeAWR = new ICS_WR_Warranty_Transaction_Types__c(Name='Advanced Warranty Return',ICS_WR_Warranty_Code__c  ='YIST',ICS_WR_Item_Type__c ='Return Request;Return;Replacement',ICS_WR_Item_Code__c='YRR;YRET;YREP',ICS_WR_Service_Type__c ='AWR;SRR',ICS_WR_Exception_Service_Type__c='SWR;');
        ICS_WR_Warranty_Transaction_Types__c   trantypeSWR = new ICS_WR_Warranty_Transaction_Types__c(Name='Standard Warranty Return',ICS_WR_Warranty_Code__c  ='YISW',ICS_WR_Item_Type__c ='Return Request;Return;Replacement',ICS_WR_Item_Code__c='YRR;YRET;YREP',ICS_WR_Service_Type__c ='SRR;AWR;SWR',ICS_WR_Exception_Service_Type__c='');
        ICS_WR_Warranty_Transaction_Types__c   trantypeSRR = new ICS_WR_Warranty_Transaction_Types__c(Name='Self Recycling Return',ICS_WR_Warranty_Code__c  ='YIST',ICS_WR_Item_Type__c ='Other Request;Replacement',ICS_WR_Item_Code__c='YST;YOWY',ICS_WR_Service_Type__c ='SRR',ICS_WR_Exception_Service_Type__c='');
        ICS_WR_Warranty_Transaction_Types__c   trantypeFUL = new ICS_WR_Warranty_Transaction_Types__c(Name='Fulfillment',ICS_WR_Warranty_Code__c  ='YIST',ICS_WR_Item_Type__c ='Other Request;Replacementt',ICS_WR_Item_Code__c='YST;YFUL',ICS_WR_Service_Type__c ='FUL',ICS_WR_Exception_Service_Type__c='');
        listOfTransactionTypes.add(trantypeAWR);
        listOfTransactionTypes.add(trantypeSWR);
        listOfTransactionTypes.add(trantypeSRR);
        listOfTransactionTypes.add(trantypeFUL);
        Database.insert(listOfTransactionTypes);
        
        Core_Country_Reference__c countryRefSettings = new Core_Country_Reference__c(Name = 'United States',ICS_WR_Country_Name__c='United States', Core_Geo__c='ASMO', Core_ISO_Code__c='USA', Core_Sub_Geo__c='NAR', ICS_WR_ISO_Code_Two__c='US' );
        Database.insert(countryRefSettings);
    }catch(Exception e){
    System.debug('e'+e.getMessage());
    }
  }
}