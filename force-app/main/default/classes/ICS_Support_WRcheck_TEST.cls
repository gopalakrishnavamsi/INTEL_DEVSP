@isTest
public class ICS_Support_WRcheck_TEST {
     // Test Case 1: [Positive] - POST request -Processor Check Mode
    static testmethod void testwarrantyProcessorCheck(){
        try{ 
                User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','check');
                    RestContext.request = req;
                    RestContext.response= res;
                    ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"CattsTcaOutputDataSet":{"Batch_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SPEC_TYPE":"S","DN_TYPE":"WO_CUST","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SPEC_CODE":"R2R7","SKU":"BX80660E52630V4","SLD_CUST_COUNTRY_CD":"IT","SHP_CUST_GEO_CD":"EMEA"}],"Input_x0020_Report":[{"MTRL_ID":"948660","TRACE_RESULT":"CONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"92908","VALIDATION_STATUS":"PASSED","BATCH":"L069117020","SPEC_CODE":"R2R7","FINISH_DATE":"2016-08-02T23:27:32-07:00","FPO_LOT":"L626F718","BOX_ID":"KN1DSC73","BOX_TYPE":"TRAY","VISUAL_ID":"M6017LR800105","DN":"803712538","SN":"M6017LR800105","RTL_BOX_EPM_ID":"949500","RTL_BOX_MTRL_ID":"949500","RTL_BOX_SITE_ID":"CS75","RTL_BOX_SKU":"BX80660E52630V4","RTL_BOX_MANUFACTURE_DT":"2016-08-19T00:00:00-07:00","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Box_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SHP_CUST_GEO_CD":"EMEA","DN_TYPE":"WO_CUST","SHP_BOX_ID":"","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SKU":"BX80660E52630V4","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"IT"}],"Unit_x0020_Trace":[]}}}', null);
                
                    Test.setMock(HttpCalloutMock.class, fakeResponse); 
                    // ICS_SingleRequestMock fakeResponse1 = new ICS_SingleRequestMock(200,'Complete',
                    //                                            '{"1000":["StartDate:10/28/2016","EndDate:01/26/2020","StartCXDate:10/28/2016","EndCXDate:01/26/2020","WarrantyCheck:true","DeterminationType:Standard","Success:Selected product is valid. (Warranty Start Date = 10/28/2016 - Warranty End Date = 01/26/2020 - Warranty Determination Type = Standard)",""]}', null);
                    //Test.setMock(HttpCalloutMock.class, fakeResponse1);
                    Test.startTest();
                    ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Processor','L069117020','M6017LR800105',prod.id,'948660','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
          }
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }  
     static testmethod void testwarrantyProcessorCheck1(){
        try{ 
                User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','');
                    RestContext.request = req;
                    RestContext.response= res;
                    ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"CattsTcaOutputDataSet":{"Batch_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SPEC_TYPE":"S","DN_TYPE":"WO_CUST","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SPEC_CODE":"R2R7","SKU":"BX80660E52630V4","SLD_CUST_COUNTRY_CD":"IT","SHP_CUST_GEO_CD":"EMEA"}],"Input_x0020_Report":[{"MTRL_ID":"948660","TRACE_RESULT":"CONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"92908","VALIDATION_STATUS":"PASSED","BATCH":"L069117020","SPEC_CODE":"R2R7","FINISH_DATE":"2016-08-02T23:27:32-07:00","FPO_LOT":"L626F718","BOX_ID":"KN1DSC73","BOX_TYPE":"TRAY","VISUAL_ID":"M6017LR800105","DN":"803712538","SN":"M6017LR800105","RTL_BOX_EPM_ID":"949500","RTL_BOX_MTRL_ID":"949500","RTL_BOX_SITE_ID":"CS75","RTL_BOX_SKU":"BX80660E52630V4","RTL_BOX_MANUFACTURE_DT":"2016-08-19T00:00:00-07:00","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Box_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SHP_CUST_GEO_CD":"EMEA","DN_TYPE":"WO_CUST","SHP_BOX_ID":"","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SKU":"BX80660E52630V4","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"IT"}],"Unit_x0020_Trace":[]}}}', null);
                
                    Test.setMock(HttpCalloutMock.class, fakeResponse); 
                     ICS_SingleRequestMock fakeResponse1 = new ICS_SingleRequestMock(200,'Complete',
                                                                '{"1000":["StartCXDate:1/6/2014","EndCXDate:4/5/2017","DeterminationType:Standard","WarrantyCheck:false","Error:Selected product is not valid.  Select valid product for this return. (Warranty Start Date = 1/6/2014 - Warranty End Date = 4/5/2017 - Warranty Determination Type = Standard)', null);
                
                    Test.setMock(HttpCalloutMock.class, fakeResponse1);
                     
                    System.debug('executing tests');
                    Test.startTest();
                    ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Processor','L069117020','M6017LR800105',prod.id,'948660','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
          }
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
     static testmethod void testwarrantyProcessorCheck2(){
        try{ 
                User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','create');
                    RestContext.request = req;
                    RestContext.response= res;
                    ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"CattsTcaOutputDataSet":{"Batch_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SPEC_TYPE":"S","DN_TYPE":"WO_CUST","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SPEC_CODE":"R2R7","SKU":"BX80660E52630V4","SLD_CUST_COUNTRY_CD":"IT","SHP_CUST_GEO_CD":"EMEA"}],"Input_x0020_Report":[{"MTRL_ID":"948660","TRACE_RESULT":"CONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"92908","VALIDATION_STATUS":"PASSED","BATCH":"L069117020","SPEC_CODE":"R2R7","FINISH_DATE":"2016-08-02T23:27:32-07:00","FPO_LOT":"L626F718","BOX_ID":"KN1DSC73","BOX_TYPE":"TRAY","VISUAL_ID":"M6017LR800105","DN":"803712538","SN":"M6017LR800105","RTL_BOX_EPM_ID":"949500","RTL_BOX_MTRL_ID":"949500","RTL_BOX_SITE_ID":"CS75","RTL_BOX_SKU":"BX80660E52630V4","RTL_BOX_MANUFACTURE_DT":"2016-08-19T00:00:00-07:00","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Box_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SHP_CUST_GEO_CD":"EMEA","DN_TYPE":"WO_CUST","SHP_BOX_ID":"","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SKU":"BX80660E52630V4","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"IT"}],"Unit_x0020_Trace":[]}}}', null);
                
                    Test.setMock(HttpCalloutMock.class, fakeResponse); 
                     ICS_SingleRequestMock fakeResponse1 = new ICS_SingleRequestMock(200,'Complete',
                                                                '{"1000":["StartCXDate:1/6/2014","EndCXDate:4/5/2017","DeterminationType:Standard","WarrantyCheck:false","Error:Selected product is not valid.  Select valid product for this return. (Warranty Start Date = 1/6/2014 - Warranty End Date = 4/5/2017 - Warranty Determination Type = Standard)', null);
                
                    Test.setMock(HttpCalloutMock.class, fakeResponse1);
                    Test.startTest();
                    ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Processor','L069117020','M6017LR800105',prod.id,'948660','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
          }
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
    
 // Test Case 1: [Positive] - POST request -Processor Check Mode
 static testmethod void testwarrantyProcessorCreate(){ 
         try{ 
                User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','create');
                    req.params.put('returntype','AWR');
                    RestContext.request = req;
                    RestContext.response= res;
                    ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"CattsTcaOutputDataSet":{"Batch_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SPEC_TYPE":"S","DN_TYPE":"WO_CUST","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SPEC_CODE":"R2R7","SKU":"BX80660E52630V4","SLD_CUST_COUNTRY_CD":"IT","SHP_CUST_GEO_CD":"EMEA"}],"Input_x0020_Report":[{"MTRL_ID":"948660","TRACE_RESULT":"CONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"92908","VALIDATION_STATUS":"PASSED","BATCH":"L069117020","SPEC_CODE":"R2R7","FINISH_DATE":"2016-08-02T23:27:32-07:00","FPO_LOT":"L626F718","BOX_ID":"KN1DSC73","BOX_TYPE":"TRAY","VISUAL_ID":"M6017LR800105","DN":"803712538","SN":"M6017LR800105","RTL_BOX_EPM_ID":"949500","RTL_BOX_MTRL_ID":"949500","RTL_BOX_SITE_ID":"CS75","RTL_BOX_SKU":"BX80660E52630V4","RTL_BOX_MANUFACTURE_DT":"2016-08-19T00:00:00-07:00","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Box_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SHP_CUST_GEO_CD":"EMEA","DN_TYPE":"WO_CUST","SHP_BOX_ID":"","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SKU":"BX80660E52630V4","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"IT"}],"Unit_x0020_Trace":[]}}}', null);
                
                    Test.setMock(HttpCalloutMock.class, fakeResponse); 
                    
                    ICS_SingleRequestMock fakeResponseFraud = new ICS_SingleRequestMock(200,'Complete',
                                                                '{"lineItemDetail":{"attributes":{"type":"ICS_WR_Warranty_Return_LineItem_Detail__c"},"ICS_WR_Line_Item_Number__c":1000,"ICS_WR_Valid_FPO_Number__c":"Yes","ICS_WR_Valid_ATPO_Number__c":"Yes","ICS_WR_ATPO_FPO_Match__c":"Yes","ICS_WR_ATPO_Frequency__c":0,"ICS_WR_Stolen_Product__c":"No","ICS_WR_FPO_Frequency__c":0,"ICS_WR_APE_GEO_Check_Successful__c":"Yes","RecordTypeId":"012m00000000fwAAAQ","ICS_WR_Box_Tray_Indicator__c":"BOX","ICS_WR_RMA_List__c":"00462057,00440550,00436498,00436497,00436495,00436492,00436486,00433931,00433421","ICS_WR_Shipped_To_Country__c":"Italy","ICS_WR_SRR_Fraud__c":"Yes"},"fraudErrs":{"Error":["SRR Fraud"]}}', null);
                
                    Test.setMock(HttpCalloutMock.class, fakeResponseFraud);
                    
                    ICS_SingleRequestMock fakeResponse1 = new ICS_SingleRequestMock(200,'Complete',
                                                                '{"1000":["StartCXDate:1/6/2014","EndCXDate:4/5/2017","DeterminationType:Standard","WarrantyCheck:false","Error:Selected product is not valid.  Select valid product for this return. (Warranty Start Date = 1/6/2014 - Warranty End Date = 4/5/2017 - Warranty Determination Type = Standard)', null);
                
                    Test.setMock(HttpCalloutMock.class, fakeResponse1);
                    Test.startTest();
                        ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Processor','L069117020','M6017LR800105',prod.id,'948660','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
          }
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    } 
   
    static testmethod void testwarrantySWR(){ 
         try{
                User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','create');
                    req.params.put('returntype','SWR');
                    RestContext.request = req;
                    RestContext.response= res;
                    Test.startTest();
                        ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Processor','L069117020','M6017LR800105',prod.id,'948660','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
                 }        
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
     static testmethod void testwarrantyProductEmpty(){ 
         try{
                User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','create');
                    req.params.put('returntype','SWR');
                    RestContext.request = req;
                    RestContext.response= res;
                    Test.startTest();
                        ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Processor','L069117020','M6017LR800105','1234','948660','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
                 }        
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
      static testmethod void testwarrantyFulfilment(){ 
         try{
             
             User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','create');
                    req.params.put('returntype','FUL');
                    RestContext.request = req;
                    RestContext.response= res;
                    Test.startTest();
                        ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Other','L069117020','M6017LR800105',prod.id,'948660','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
                 }        
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
     static testmethod void testwarrantyFulfilmentProcessor(){ 
         try{
             
             User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','create');
                    req.params.put('returntype','FUL');
                    RestContext.request = req;
                    RestContext.response= res;
                    Test.startTest();
                        ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Processor','L069117020','M6017LR800105',prod.id,'948660','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
                 }        
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
     static testmethod void testwarrantyRequired(){ 
         try{
             User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','create');
                    req.params.put('returntype','SWR');
                    RestContext.request = req;
                    RestContext.response= res;
                    
                    Test.startTest();
                    try{
                     req.params.put('returntype','FUL');    
                     ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Board','L069117020','L069117020',prod.id,'948660','BX80660E52630V4');
                    }catch(Exception es){
                     System.debug('exception'+es.getMessage());   
                    }
                     try{
                     req.params.put('returntype','AWR');    
                     ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Memory','L069117020','',prod.id,'948660','BX80660E52630V4');
                    }catch(Exception es){
                     System.debug('exception'+es.getMessage());   
                    }
                    RestContext.request = req;
                    RestContext.response= res;
                    ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Board','','',prod.id,'948660','BX80660E52630V4');
                   
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
                 }        
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
      static testmethod void testwarrantySRR(){ 
         try{
              User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','create');
                    req.params.put('returntype','SRR');
                    RestContext.request = req;
                    RestContext.response= res;
                    Test.startTest();
                        ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Memory','','G6YK441001TJ',prod.id,'948660','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
                 }        
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
     static testmethod void testwarrantySRR1(){ 
         try{
             User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','create');
                    req.params.put('returntype','SRR');
                    RestContext.request = req;
                    RestContext.response= res;
                    Test.startTest();
                        ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Memory','G6YK441001TJ','H26245-103',prod.id,'948660','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
                 }        
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
    static testmethod void testwarrantyNonProcessor(){ 
         try{
             User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','create');
                    req.params.put('returntype','SRR');
                    RestContext.request = req;
                    RestContext.response= res;
                     ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"SerialNumber":"G6SY548003MK","PartNumberList":["H87090-502     ","943207"],"ReplacementFrequency":"0","ProcessCode":"0","ShipDate":"01/14/2016 12:00:00 AM","CountryCode":"NL","StolenProduct":"N","ReturnFrequency":"0"}', null);
                    Test.setMock(HttpCalloutMock.class, fakeResponse); 
                    Test.startTest();
                    ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Board','','G6YK441001TJ',prod.id,'943207','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
                 }        
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }    
     static testmethod void testwarrantyFUL(){ 
         try{
             User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','create');
                    req.params.put('returntype','FUL');
                    RestContext.request = req;
                    RestContext.response= res;
                    Test.startTest();
                        ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Processor','','',prod.id,'948660','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
                 }        
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    } 
     static testmethod void testwarranty(){ 
         try{
             User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','create');
                    req.params.put('returntype','');
                    RestContext.request = req;
                    RestContext.response= res;
                    Test.startTest();
                        ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Processor','','',prod.id,'948660','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
                 }        
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    } 
       static testmethod void testwarrantyBoardCheck(){
          try{ 
                User U1 = [Select ID from User Limit 1]; 
                Product2 prod = [Select Id from Product2 limit 1];
                
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.params.put('mode','check');
                    RestContext.request = req;
                    RestContext.response= res;
                    
                    Test.startTest();
                       ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"SerialNumber":"G6SY548003MK","PartNumberList":["H87090-502","949500"],"ReplacementFrequency":"0","ProcessCode":"0","ShipDate":"01/14/2016 12:00:00 AM","CountryCode":"NL","StolenProduct":"N","ReturnFrequency":"0"}', null);
                
                    Test.setMock(HttpCalloutMock.class, fakeResponse); 
                    ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Board','','G6SY548003MK',prod.id,'949500','H87090-502');
                    Test.StopTest();
                   
                   System.assertEquals(200, results.Code);
                   System.assertEquals(true, results.isSuccess);
     
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
   } 
    
    static testmethod void testwarrantyMemoryCheck(){
         try{
                User U1 = [Select ID from User Limit 1]; 
                Product2 prod = [Select Id from Product2 limit 1];
                
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.params.put('mode','check');
                    RestContext.request = req;
                    RestContext.response= res;
                    Test.startTest();
                    ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Memory','','G6YK441001TJ',prod.id,'926196','H26245-103');
                    Test.StopTest();
     } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
    static testmethod void testwarrantyMemoryCheck1(){
         try{
                User U1 = [Select ID from User Limit 1]; 
                Product2 prod = [Select Id from Product2 limit 1];
                
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=create';
                    req.httpMethod = 'POST';
                    req.params.put('mode','create');
                    RestContext.request = req;
                    RestContext.response= res;
                    
             
                    Test.startTest();
                     ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                       'Complete',
                                                                       '{"FERT": "926196", "CustomerRegion": "DE","ProductCode": "BOXDH67BLB3","WarrantyExpire": "02/07/2015","ShippingDate": "11/10/2011","CustomerID": "6006599303","CustomerName": "ALSO Deutschland GmbH","RecordFound": "1"}',
                 null);
         Test.setMock(HttpCalloutMock.class, fakeResponse); 
         Map<String,string> qryString = new Map<String,string>();
         qryString.put('sno', 'G6YK441001TJ');
         
        ICS_WR_ConsumingSNtrax_SSD.SSDResult SSDResult=new ICS_WR_ConsumingSNtrax_SSD.SSDResult();
        SSDResult=ICS_WR_ConsumingSNtrax_SSD.get_SNtrax_Validate_SSD(qryString);
        system.debug('serialNoResultTest###'+SSDResult);
        SSDResult.FERT='915087';
        SSDResult.CustomerRegion='3';
        SSDResult.ProductCode='n';
        SSDResult.WarrantyExpire='02/07/2015';
        SSDResult.ShippingDate='0';
        SSDResult.RecordFound='test';
        system.assert(SSDResult!=null, 'Deserialized Response data');
        ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Memory','','G6YK441001TJ',prod.id,'926196','H26245-103');
        Test.StopTest();
          
    } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
 
 static testmethod void testwarrantySSDCheck(){
        try{ 
                User U1 = [Select ID from User  Limit 1]; 
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(U1) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.params.put('mode','check');
                    RestContext.request = req;
                    RestContext.response= res;
                   
                    Test.startTest();
                
                    ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Memory','','G6YK441001TJ',prod.id,'926196','H26245-103');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                   System.assertEquals(200, results.Code);
                   System.assertEquals(true, results.isSuccess);
          }
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }    
    static testmethod void testwarrantySSDCreate(){
        try{ 
                User U1 = [Select ID from User Limit 1]; 
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(U1) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.params.put('mode','create');
                    req.params.put('returntype','AWR');
                    req.params.put('oauth',U1.Id);
                    RestContext.request = req;
                    RestContext.response= res;
                   
                    Test.startTest();
                
                    ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Memory','','G6YK441001TJ',prod.id,'926196','H26245-103');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
          }
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }     
  
   static testmethod void testwarrantyMemoryCheckResponse(){
          try{ 
                User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','create');
                    req.params.put('returntype','SRR');
                    RestContext.request = req;
                    RestContext.response= res;
                    ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                       'Complete',
                                                                       '{"FERT": "915087", "CustomerRegion": "DE","ProductCode": "BOXDH67BLB3","WarrantyExpire": "02/07/2015","ShippingDate": "11/10/2011","CustomerID": "6006599303","CustomerName": "ALSO Deutschland GmbH","RecordFound": "1"}',
                 null);
         Test.setMock(HttpCalloutMock.class, fakeResponse);
                    Test.startTest();
                        ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Memory','G6YK441001TJ','H26245-103',prod.id,'948660','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
            }
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
       
    } 
     static testmethod void testwarrantyOtherCheck(){
        try{ 
                User U1 = [Select ID from User Limit 1]; 
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(U1) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.params.put('mode','check');
                    RestContext.request = req;
                    RestContext.response= res;
                    Test.startTest();
                        ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Other','','G6YK441001TJ',prod.id,'926196','H26245-103');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                   System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
          }
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }     
     static testmethod void testwarrantyOtherCreate(){
        try{ 
                User U1 = [Select ID from User Limit 1]; 
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(U1) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.params.put('mode','create');
                    req.params.put('returntype','FUL');
                    req.params.put('oauth',U1.Id);
                    RestContext.request = req;
                    RestContext.response= res;
                   
                    Test.startTest();
                        ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Other','','G6YK441001TJ',prod.id,'926196','H26245-103');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                          
                        System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
          }
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }     
 //RequiredFieldException      
 private static testMethod void requiredFieldException(){ 
    try{    
                User U1 = [Select ID from User Limit 1]; 
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(U1) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.params.put('mode','create');
                    req.params.put('returntype','AWR');
                    req.params.put('oauth',U1.Id);
                    RestContext.request = req;
                    RestContext.response= res;
        ICS_Support_Connected_App_Identifier__c ConnectedAPPIdentifier = ICS_Support_TestdatasetupUtility.createconAppIdentifier('SupportApp','3MVG9RHx1QGZ7OsjHe85Yz6jl4k6p1hRmx0se_eYOg67ten7I_m1kpLyvYLdk_mGtpkpWsyugGHXypG3qytu1');
        ICS_Support_Error_Details__c errorDetails = ICS_Support_TestdatasetupUtility.createErrorDetailsRecord('RequiredFieldException',9002,'Required Field Missing','Info',true,400);
        ICS_Support_Error_Details__c errorDetails2 = ICS_Support_TestdatasetupUtility.createErrorDetailsRecord('ApexException',9999,'Unknown exception has occurred','Error',true,500);
         
        Test.startTest();
        ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Processor','','',prod.id,'926196','H26245-103');

        Test.stopTest();
                 
        System.assertEquals(false,results.IsSuccess);
           }   
     }catch(Exception e){
       System.debug('ex:'+e.getMessage());
    } 
  }   
 private static testMethod void requiredFieldExceptionProcess(){ 
    try{    
                User U1 = [Select ID from User Limit 1]; 
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(U1) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.params.put('mode','create');
                    req.params.put('returntype','AWR');
                    req.params.put('oauth',U1.Id);
                    RestContext.request = req;
                    RestContext.response= res;
        Test.startTest();
            ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Non-Processor','','',prod.id,'926196','H26245-103');
        Test.stopTest();
        System.assertEquals(false,results.IsSuccess);
        }   
     }catch(Exception e){
       System.debug('ex:'+e.getMessage());
    } 
  } 
  
  private static testMethod void requiredFieldExceptionNonProcess(){ 
    try{    
        
                User U1 = [Select ID from User Limit 1]; 
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(U1) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.params.put('mode','create');
                    req.params.put('returntype','AWR');
                    req.params.put('oauth',U1.Id);
                    RestContext.request = req;
                    RestContext.response= res;
        Test.startTest();
            ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Other','','1234',prod.id,'926196','H26245-103');
        Test.stopTest();
        System.assertEquals(false,results.IsSuccess);
        }   
     }catch(Exception e){
       System.debug('ex:'+e.getMessage());
    } 
  } 
   private static testMethod void requiredFieldExceptionMemory(){ 
    try{    
                User U1 = [Select ID from User Limit 1]; 
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(U1) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.params.put('mode','create');
                    req.params.put('returntype','AWR');
                    req.params.put('oauth',U1.Id);
                    RestContext.request = req;
                    RestContext.response= res;
        Test.startTest();
            ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck.getWarrantyInfo('Memory','','','',prod.id,'','H26245-103');
        Test.stopTest();
        System.assertEquals(false,results.IsSuccess);
        }   
     }catch(Exception e){
       System.debug('ex:'+e.getMessage());
    } 
  } 
  private static testMethod void requiredFieldProcess(){ 
    try{    
                User U1 = [Select ID from User Limit 1]; 
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(U1) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.params.put('mode','create');
                    req.params.put('returntype','AWR');
                    req.params.put('oauth',U1.Id);
                    RestContext.request = req;
                    RestContext.response= res;
        Test.startTest();
            ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck.getWarrantyInfo('Processor','','','',prod.id,'','H26245-103');
        Test.stopTest();
        System.assertEquals(false,results.IsSuccess);
        }   
     }catch(Exception e){
       System.debug('ex:'+e.getMessage());
    } 
  } 
 static testmethod void testwarrantyNonProcessorBoard(){
        try{ 
                User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','check');
                    RestContext.request = req;
                    RestContext.response= res;
                    ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"SerialNumber":"G6SY548003MK","PartNumberList":["H87090-502     ","943207"],"ReplacementFrequency":"0","ProcessCode":"0","ShipDate":"01/14/2016 12:00:00 AM","CountryCode":"NL","StolenProduct":"N","ReturnFrequency":"0"}', null);
                
                    Test.setMock(HttpCalloutMock.class, fakeResponse); 
                    Test.startTest();
                    ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Board','','G6SY548003MK',prod.id,'943207','H60945-201');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
          }
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
    static testmethod void testwarrantyNonProcessorBoard1(){
        try{ 
                User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','check');
                    RestContext.request = req;
                    RestContext.response= res;
                    ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"SerialNumber":"G6SY548003MK","PartNumberList":["H87090-502     ","943207"],"ReplacementFrequency":"0","ProcessCode":"0","ShipDate":"01/14/2016 12:00:00 AM","CountryCode":"NL","StolenProduct":"N","ReturnFrequency":"0"}', null);
                
                    Test.setMock(HttpCalloutMock.class, fakeResponse); 
                    Test.startTest();
                    ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Board','','G6SY548003MK','','943207','H60945-201');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
          }
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
    static testmethod void testwarrantyNonProcessorSSD(){
        try{ 
                User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','check');
                    RestContext.request = req;
                    RestContext.response= res;
                    ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"FERT":"943207","CustomerRegion":"NL","ProductCode":"BOXNUC6I5SYH   ","WarrantyExpire":"04/13/2019","ShippingDate":"01/14/2016","CustomerID":"6000129551          ","CustomerName":"Arrow Central Europe / Microtronica","RecordFound":"1"}', null);
                
                    Test.setMock(HttpCalloutMock.class, fakeResponse); 
                    Test.startTest();
                    ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Memory','','G6SY548003MK',prod.id,'943207','H60945-201');
                    Test.StopTest();
                    System.debug('Check Mode Processor result: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
          }
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
    
    //Added TChauhan
    static testmethod void testProcessorInvalidATPO(){ 
         try{
             
             User testUser = [SELECT Id FROM User WHERE UserName='testDataSetup@abc.com' LIMIT 1];
                Product2 prod = [Select Id from Product2 limit 1];
                 System.runAs(testUser) {
                    RestRequest req = new RestRequest();
                    RestResponse res = new RestResponse();
                    req.requestURI = '/services/apexrest/support/v1.0/warranty/warrantyinfo?mode=check';
                    req.httpMethod = 'POST';
                    req.addHeader('client_id', '123456789');
                    req.params.put('mode','check');
                    req.params.put('returntype','SWR');
                    RestContext.request = req;
                    RestContext.response= res;
                    ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                                                'Complete',
                                                                '{"CattsTcaOutputDataSet":{"Batch_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SPEC_TYPE":"S","DN_TYPE":"WO_CUST","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SPEC_CODE":"R2R7","SKU":"BX80660E52630V4","SLD_CUST_COUNTRY_CD":"IT","SHP_CUST_GEO_CD":"EMEA"}],"Input_x0020_Report":[{"MTRL_ID":"948660","TRACE_RESULT":"CONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"92908","VALIDATION_STATUS":"PASSED","BATCH":"L069117020","SPEC_CODE":"R2R7","FINISH_DATE":"2016-08-02T23:27:32-07:00","FPO_LOT":"L626F718","BOX_ID":"KN1DSC73","BOX_TYPE":"TRAY","VISUAL_ID":"M6017LR800105","DN":"803712538","SN":"M6017LR800105","RTL_BOX_EPM_ID":"949500","RTL_BOX_MTRL_ID":"949500","RTL_BOX_SITE_ID":"CS75","RTL_BOX_SKU":"BX80660E52630V4","RTL_BOX_MANUFACTURE_DT":"2016-08-19T00:00:00-07:00","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Box_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SHP_CUST_GEO_CD":"EMEA","DN_TYPE":"WO_CUST","SHP_BOX_ID":"","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SKU":"BX80660E52630V4","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"IT"}],"Unit_x0020_Trace":[]}}}', null);
                
                    Test.setMock(HttpCalloutMock.class, fakeResponse); 
                     
                    ICS_SingleRequestMock fakeResponse1 = new ICS_SingleRequestMock(200,'Complete',
                                                                '{"1000":["StartCXDate:1/6/2014","EndCXDate:4/5/2017","DeterminationType:Standard","WarrantyCheck:false","Error:Selected product is not valid.  Select valid product for this return. (Warranty Start Date = 1/6/2014 - Warranty End Date = 4/5/2017 - Warranty Determination Type = Standard)', null);
                    Test.setMock(HttpCalloutMock.class, fakeResponse1); 
                    
                    Test.startTest();
                    ICS_Support_WRcheck_Handler.ResponseWrapper results = ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,'Processor','L069117020','XXXWWWWWwwwwwww','1234','943207','BX80660E52630V4');
                    Test.StopTest();
                    System.debug('Check Mode Processor result Invalid ATPO: '+results);
                    System.assertEquals(200, results.Code);
                    System.assertEquals(true, results.isSuccess);
                 }        
        } catch (exception ex){
            system.debug(ex.getMessage());
        }
    }
    
  @testSetup 
 static void setup() {
   		ICS_IPA_TestDataSetupUtility.createIPACustomSettingData();
       	ICS_IPA_TestDataSetupUtility.createeRPMCustomSettingData();
      	
   		ID userProfile = ICS_Support_TestdatasetupUtility.fetchProfileId('ICS Customer Community Web Portal');
  
        //ITP User  
        ID accRecordTypeId  = ICS_Support_TestdatasetupUtility.fetchRecordTypeId('Account','Non_Editable_Accounts');
        ID conRecordTypeId  = ICS_Support_TestdatasetupUtility.fetchRecordTypeId('Contact','Non_Editable_Contacts');
        Account acc = ICS_Support_TestdatasetupUtility.createAccount(accRecordTypeId,'ITPCustomer','GOLD');
        Contact con = ICS_Support_TestdatasetupUtility.createAdvancedContact(conRecordTypeId, acc.Id,'testITPContact','tchauhanItp@abc.com');        
        User testUser = ICS_Support_TestdatasetupUtility.createUser(userProfile, con.id, 'testDataSetup@abc.com', 'SupportApp_Community User', 'tchauhanItp@abc.com');

        Product2 prod = ICS_Support_TestdatasetupUtility.createProductForSearch();
        Product2 prod1 = ICS_Support_TestdatasetupUtility.createProductForSearch('Boxed Intel® Celeron® Processor G1610 (2M Cache, 2.60 GHz) FC-LGA12C', true, true, true, null);
       // Product_Hierarchy__c prodHierarchy = ICS_Support_TestdatasetupUtility.createProductHierarchyForTextSearch(prod.Id,'5500');
        Product_Hierarchy__c hierarchy2 = ICS_Support_TestdatasetupUtility.createProductHierarchy('', '', '7718', '50544', '7719', '50545', prod1.id, true);
        
     List<string> systemresponse = ICS_Support_WRTestdatasetupUtility.systemResponseGeneratorcheck();
        System.debug('*** prod inserted ***' + prod);
     //   System.debug('*** setup prodHierarchy ***'+prodHierarchy);
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
        
        Core_Country_Reference__c countryRefSettings = new Core_Country_Reference__c(Name = 'United States',ICS_WR_Country_Name__c='United States', Core_Geo__c='ASMO', Core_ISO_Code__c='USA', Core_Sub_Geo__c='NAR', ICS_WR_ISO_Code_Two__c='US');
        Database.insert(countryRefSettings);
       
        ICS_SingleRequestMock fakeResponse = new ICS_SingleRequestMock(200,
                                            'Complete',
                                            '{"CattsTcaOutputDataSet":{"Batch_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SPEC_TYPE":"S","DN_TYPE":"WO_CUST","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SPEC_CODE":"R2R7","SKU":"BX80660E52630V4","SLD_CUST_COUNTRY_CD":"IT","SHP_CUST_GEO_CD":"EMEA"}],"Input_x0020_Report":[{"MTRL_ID":"948660","TRACE_RESULT":"CONCLUSIVE","SPEC_TYPE":"S","EPM_ID":"92908","VALIDATION_STATUS":"PASSED","BATCH":"L069117020","SPEC_CODE":"R2R7","FINISH_DATE":"2016-08-02T23:27:32-07:00","FPO_LOT":"L626F718","BOX_ID":"KN1DSC73","BOX_TYPE":"TRAY","VISUAL_ID":"M6017LR800105","DN":"803712538","SN":"M6017LR800105","RTL_BOX_EPM_ID":"949500","RTL_BOX_MTRL_ID":"949500","RTL_BOX_SITE_ID":"CS75","RTL_BOX_SKU":"BX80660E52630V4","RTL_BOX_MANUFACTURE_DT":"2016-08-19T00:00:00-07:00","INPUT_IMPRESSION":""}],"Transaction_x0020_Details":{"ErrorMessage":"","IsTransactionSuccess":"true"},"Box_x0020_Report":[{"SHP_CUST_NM":"LOGICOM ITALIA S.R.L","SHP_CUST_ID":"0002027924","SHP_CUST_COUNTRY_NM":"Italy","MTRL_ID":"949500","SHP_CUST_COUNTRY_CD":"IT","SHP_MEDIA_TYPE":"BOX","DN":"803712538","SHP_CUST_GEO_CD":"EMEA","DN_TYPE":"WO_CUST","SHP_BOX_ID":"","AGID_DATE":"2016-10-29T02:09:05-07:00","BATCH":"L069117020","SKU":"BX80660E52630V4","FPO_BATCH":"","SLD_CUST_COUNTRY_CD":"IT"}],"Unit_x0020_Trace":[]}}}', null);
        
        Test.setMock(HttpCalloutMock.class, fakeResponse); 
        
        ICS_SingleRequestMock fakeResponseFraud = new ICS_SingleRequestMock(200,'Complete',
                                            '{"lineItemDetail":{"attributes":{"type":"ICS_WR_Warranty_Return_LineItem_Detail__c"},"ICS_WR_Line_Item_Number__c":1000,"ICS_WR_Valid_FPO_Number__c":"Yes","ICS_WR_Valid_ATPO_Number__c":"Yes","ICS_WR_ATPO_FPO_Match__c":"Yes","ICS_WR_ATPO_Frequency__c":0,"ICS_WR_Stolen_Product__c":"No","ICS_WR_FPO_Frequency__c":0,"ICS_WR_APE_GEO_Check_Successful__c":"Yes","RecordTypeId":"012m00000000fwAAAQ","ICS_WR_Box_Tray_Indicator__c":"BOX","ICS_WR_RMA_List__c":"00462057,00440550,00436498,00436497,00436495,00436492,00436486,00433931,00433421","ICS_WR_Shipped_To_Country__c":"Italy","ICS_WR_SRR_Fraud__c":"Yes"},"fraudErrs":{"Error":["SRR Fraud"]}}', null);
        
        Test.setMock(HttpCalloutMock.class, fakeResponseFraud);
        
        ICS_SingleRequestMock fakeResponse1 = new ICS_SingleRequestMock(200,'Complete',
                                            '{"1000":["StartCXDate:1/6/2014","EndCXDate:4/5/2017","DeterminationType:Standard","WarrantyCheck:false","Error:Selected product is not valid.  Select valid product for this return. (Warranty Start Date = 1/6/2014 - Warranty End Date = 4/5/2017 - Warranty Determination Type = Standard)', null);
        
        Test.setMock(HttpCalloutMock.class, fakeResponse1);
        System.debug('executing tests');
     
   }
}