/************************************************************************************************
 * Name             : ICS_Support_WRcheck_Handler
 * Description      : RestAPI class for fecthing Warranty Check Information.
 * Developer        : Omni CX Orion
 * Version History  : V1.0 - April 2018 - Created 
 * User Storty      : US101496
 * @Author          : Satish M 
 ************************************************************************************************/
global with sharing class ICS_Support_WRcheck_Handler {
   private static String clientId;
    private static long startTimeLong = system.currentTimeMillis();
    private static String notes = '';
    private static Set <String> setFraudvalues = null;
    private static Set <String> lstSet = null;
    private static List <String> lstStrings = null;
    private static  String productCategory = '';
    /*Function for fectching warranty info based on product search results*/
    global static ResponseWrapper getWarrantyCheckData(RestRequest req, String ProductType, String FPOStockingNumber, String ATPOSerialNumber, String ProductId, String MMId, String StockingId) {

        clientId = req.headers.get('client_id');
        String strloggedId = req.params.get('oauth');
        System.debug('clientId: ' + clientId);
        DateTime strStartDate = null;
        String strWarrantyCheck = '';
        String strDeterminationType = '';
        String strUserId = '';
        String strContactId = '';
        String strDepotId = '';
        DateTime strWarrantyExpDateTime = null;
        String shipCountryCode = '';
        String shipGeoCode = '';
        String strRMAType = '';
        FraudCheckWrapper frw = null;
        List < String > lstFraudExceptions = null;
        //US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
        //ICS_WR_Warranty_Util_Agent.fraudCheckResponse fraudCheckErrMsgs = null;
		ICS_WR_Warranty_Util_Agent_LEX.fraudCheckResponse fraudCheckErrMsgs = null;
        List < User > userDetails = null;
        List < Product2 > lstProducts = null;
        String strSerialNumber = '';
        String strFPONumber = '';
        String strATPONumber = '';
        Map < String, String > mapQryParameter = null;
        ICS_WR_ConsumingSNtrax_SSD.SSDResult SSDresponse = null;
        List < ICS_Support_Warranty_Util.ProductWrapper > prdWrapperList = null;
        List<String> lstWarrantyValidationMsgs =  new List<String>();
        Boolean isStrFraudCheck = false;
        List<string> finalResponse;
        String warrantyType = req.params.get('returntype');
        String warrantyMode = req.params.get('mode');
        try{
            //Uncomment for dev & devint testing only
            /**if (!String.isEmpty(strloggedId)) {
               strUserId = strloggedId;
            } else {
                strUserId = UserInfo.getUserId();
            }**/
            strUserId = UserInfo.getUserId();
        
            //Fectching user deatils based on logged userId
            userDetails = [Select Id, Name,Profile.Name,ContactId, LanguageLocaleKey, Account.Core_Account_Geo__c,Account.ICS_WR_Hold_Indicator__c, Account.ShippingCountry From User Where Id =: strUserId Limit 1];
            if (!String.isBlank(strUserId) && (userDetails == NULL || userDetails.size() < 1)) {
                throw new InvalidUserException();
            }
           
            //Condition for customer profile and Anonymous profile 
            if((userDetails[0].Profile.Name != 'ICS Customer Community Web Portal') && (userDetails[0].Profile.Name != 'Anonymous API Profile')) {
               throw new InvalidUserException();
            }else if(warrantyMode == 'create' && userDetails[0].Profile.Name != 'ICS Customer Community Web Portal'){
                throw new SiteUserLoginException();
            }
            
         //Setting parameters for calling docheck and fraud check validations.
         if(userDetails != null && !String.isEmpty(userDetails[0].ContactId)) {  
                strContactId = userDetails[0].ContactId;
                shipCountryCode = userDetails[0].Account.ShippingCountry;
                shipGeoCode = userDetails[0].Account.Core_Account_Geo__c;
                strDepotId = ICS_Support_Warranty_Util.getDepotId(strUserId); //fetching depot based on user details
                System.debug('strDepotId->:' + strDepotId);
          } 
          
        //Checking condition for required fields
         if(String.isBlank(warrantyMode) ||String.isBlank(ProductType) || String.isBlank(ProductId) ||String.isBlank(MMId)){
            throw new RequiredFieldException();   
         }
       
         //Checking mode based on input value
          if (warrantyMode == 'create' || warrantyMode == 'check'){ 
            if(warrantyMode == 'create'){
               if(String.isEmpty(warrantyType)|| String.isEmpty(StockingId) || (ProductType == 'Processor' && (String.isBlank(FPOStockingNumber) || String.isBlank(ATPOSerialNumber)))){
                throw new RequiredFieldException();
              }
            }
          }else{
              throw new InvalidInputException();
          } 
            
       //Differentiating Non Processor product type
        if(ProductType == 'Board' || ProductType == 'MiniPC' || ProductType == 'Other') {
           productCategory = 'Non-Processor';
           strSerialNumber = ATPOSerialNumber;
           if (String.isEmpty(ATPOSerialNumber) || String.isEmpty(ProductId) || String.isEmpty(MMId) || String.isEmpty(StockingId) || String.isEmpty(ProductType)) {
            throw new RequiredFieldException();
          }
         if(warrantyType == 'FUL' && warrantyMode == 'create') { //Identifying warranty type for other intel product with Fulfilment
            if (ProductType != 'Other') {
             throw new InvalidInputException();
           }
         }
        } else if (ProductType == 'Memory') { //Setting product type is SSD when product type is Memory
          productCategory = 'SSD';
          strSerialNumber = ATPOSerialNumber;
          if (String.isEmpty(ATPOSerialNumber) || String.isEmpty(ProductId) || String.isEmpty(MMId) || String.isEmpty(ProductType)) {
            throw new RequiredFieldException();
          }
        }      
            
        // Product Id validation
        if(!String.isBlank(ProductId)){    
          lstProducts = [Select Name From Product2 Where Id =: ProductId Limit 1];
          if (lstProducts == null || lstProducts.size() == 0) {
           throw new NoDataException();
          }
        } 
        
      //Warranty Check Mode Excecution for Processor and Non - Processor product types
      if (warrantyMode == 'check') { 
            if (ProductType == 'Processor') {
                 productCategory = 'Processor';
                 if (String.isEmpty(FPOStockingNumber)) {//Check mode ATPO Number is optional
                       throw new RequiredFieldException();
                    } else {
                        strFPONumber = FPOStockingNumber;
                        strATPONumber = ATPOSerialNumber;
                    }
                    
                 //DE40697---To check Invalid ATPO value & return expiry date based on VALID FPO---TChauhan
                 if(!Pattern.matches('^[a-zA-Z0-9]+$',strATPONumber.trim()) ||(strATPONumber.trim().length() !=18 && strATPONumber.trim().length() >14)) {
                    finalResponse =  ICS_Support_WRcheck_Handler.doActionCall(req,ProductType,FPOStockingNumber,'',ProductId,MMId,StockingId,warrantyMode,strRMAType,strContactId,shipCountryCode,shipGeoCode,strDepotId);
                 }
                 else{
                    finalResponse =  ICS_Support_WRcheck_Handler.doActionCall(req,ProductType,FPOStockingNumber,ATPOSerialNumber,ProductId,MMId,StockingId,warrantyMode,strRMAType,strContactId,shipCountryCode,shipGeoCode,strDepotId);
                 }
                 System.debug('FinalProcessorResponse:'+finalResponse);
            
            }else if(productCategory == 'Non-Processor'){
                 finalResponse =  ICS_Support_WRcheck_Handler.doActionCall(req,ProductType,FPOStockingNumber,ATPOSerialNumber,ProductId,MMId,StockingId,warrantyMode,strRMAType,strContactId,shipCountryCode,shipGeoCode,strDepotId);
                 System.debug('Non - ProcessorResponse:'+finalResponse);
                
            }else if(productCategory == 'SSD'){
                    strSerialNumber = ATPOSerialNumber;
                    system.debug('SSD inputVal----->:' + ATPOSerialNumber);
                    mapQryParameter = new Map < String, String > ();
                    mapQryParameter.put('sno', ATPOSerialNumber);
                    long funcStartTime2 = system.currentTimeMillis();
                    SSDresponse = ICS_WR_ConsumingSNtrax_SSD.get_SNtrax_Validate_SSD(mapQryParameter);
                    notes += 'Warranty Non-Processor SSD response in warranty check mode: ' + (system.currentTimeMillis() - funcStartTime2) + ' ms \n';
                    System.debug('SSDresponse---->:' + SSDresponse);

                    //Down time message for SSD System
                    if (ICS_WR_ConsumingSNtrax_SSD.isError) {
                        return (callExceptionUtility(req.toString(), 'ICS_Support_WRcheck_Handler.getWarrantyCheckData', 'SystemDownTimeException', null));
                    }
                    if (!String.isBlank(SSDresponse.ShippingDate)) {
                        //UserLocale--Date formatting issue fix--TChauhan
                        strStartDate = ICS_Support_Warranty_Util.getGMTFormattedDate(SSDresponse.ShippingDate);
                        System.debug('***strStartDate after parse==>'+strStartDate);
                    }
                    ICS_Support_Warranty_Util.inputVal = ATPOSerialNumber;
                    long funcStartTime3 = system.currentTimeMillis();
                    
                    //UserLocale--Date formatting issue--TChauhan
                    strWarrantyExpDateTime = ICS_Support_Warranty_Util.processSSDResponseDate(SSDresponse);
                    notes += 'Warranty Non-Processor SSD validation in warranty check mode: ' + (system.currentTimeMillis() - funcStartTime3) + ' ms \n';
                    System.debug('***strWarrantyExpDateTime--->' + strWarrantyExpDateTime);
                    if (strWarrantyExpDateTime == Null) {
                       return (callExceptionUtility(req.toString(), 'ICS_Support_WRcheck_Handler.getWarrantyCheckData', 'NoDataException', null));
                    }
                    SuccessWrapper successWrapSSD = new SuccessWrapper(ProductType, strATPONumber, lstProducts[0].Name, strFPONumber, strStartDate, strWarrantyExpDateTime, strWarrantyExpDateTime, strDeterminationType, strWarrantyCheck, frw, StockingId, MMId, strSerialNumber, ProductId,lstWarrantyValidationMsgs,isStrFraudCheck);
                    ResponseWrapper finalResponseSsD = new ResponseWrapper(200, true, successWrapSSD, null);

                    String dummyssd = ICS_Support_API_Utility.logTransaction('WarrantyCheck', System.JSON.serialize(finalResponseSsD), startTimeLong, null, null, true, notes, null);
                    System.debug('dummyssd:' + dummyssd);
                    return finalResponseSsD;
            }else{
                throw new InvalidInputException();
            }   
         lstWarrantyValidationMsgs = null;   
      
      //Warranty create logic execution   
      }else{
          Set <String> validWarrantyType = new Set <String> {'AWR','SWR','SRR','FUL'};
                if (validWarrantyType.contains(warrantyType)) //Checking warranty return type
                {
                    if (warrantyType == 'AWR') {
                        strRMAType = 'Advanced Warranty Return';
                    } else if (warrantyType == 'SWR') {
                        strRMAType = 'Standard Warranty Return';
                    } else if (warrantyType == 'SRR') {
                        strRMAType = 'Self Recycling Return';
                    } else if (warrantyType == 'FUL') {
                        if (ProductType != 'Other') {
                            throw new InvalidInputException();
                        }
                        strRMAType = 'Fulfilment';
                    }
                } else {
                    throw new InvalidInputException();
                }
           if (ProductType == 'Processor') {
                 productCategory = 'Processor';
                if(String.isEmpty(FPOStockingNumber) || String.isEmpty(ATPOSerialNumber)) {//Create mode FPO & ATPO numbers are mandatory
                      throw new RequiredFieldException();
                    } else {
                        strFPONumber = FPOStockingNumber;
                        strATPONumber = ATPOSerialNumber;
                  }
                //DE40697---To check Invalid ATPO value & return expiry date based on VALID FPO---TChauhan
                if(!Pattern.matches('^[a-zA-Z0-9]+$',strATPONumber.trim()) ||(strATPONumber.trim().length() !=18 && strATPONumber.trim().length() >14)) {
                    finalResponse =  ICS_Support_WRcheck_Handler.doActionCall(req,ProductType,FPOStockingNumber,'',ProductId,MMId,StockingId,warrantyMode,strRMAType,strContactId,shipCountryCode,shipGeoCode,strDepotId);
                }else{
                    finalResponse =  ICS_Support_WRcheck_Handler.doActionCall(req,ProductType,FPOStockingNumber,ATPOSerialNumber,ProductId,MMId,StockingId,warrantyMode,strRMAType,strContactId,shipCountryCode,shipGeoCode,strDepotId);
                }
                System.debug('FinalProcessorResponse:'+finalResponse);
              }else if(productCategory == 'Non-Processor' || productCategory == 'SSD'){
                productCategory = 'Non-Processor';
                finalResponse =  ICS_Support_WRcheck_Handler.doActionCall(req,ProductType,FPOStockingNumber,ATPOSerialNumber,ProductId,MMId,StockingId,warrantyMode,strRMAType,strContactId,shipCountryCode,shipGeoCode,strDepotId);
                System.debug('Non - ProcessorResponse:'+finalResponse);
             }else{
              throw new InvalidInputException();  
            }   
      }
          //While running test class it is setting response for code coverage
            if (test.isRunningTest()) {
              finalResponse = ICS_Support_WRTestdatasetupUtility.systemResponseGenerator();
             }
                if (finalResponse != null && finalResponse.size() > 0) { 
                    for (String objValidateData: finalResponse) {
                        if (objValidateData.containsIgnoreCase('WarrantyCheck')) {
                            List < String > lstWarrantyCheck = objValidateData.split(':');
                            strWarrantyCheck = lstWarrantyCheck[1];
                        } else if (objValidateData.containsIgnoreCase('StartCXDate')) {
                            List < String > lstStartDate = objValidateData.split(':');
                            if(lstStartDate!=null && lstStartDate.size()>0 && lstStartDate[1]!='null'){
                                strStartDate = ICS_Support_Warranty_Util.getGMTFormattedDate(lstStartDate[1]);
                                System.debug('***strStartDate===>' + strStartDate);
                            } 
                        } else if (objValidateData.containsIgnoreCase('EndCXDate')) {
                            List < String > lstEndDate = objValidateData.split(':');
                            if(lstEndDate!=null && lstEndDate.size()>0 && lstEndDate[1]!='null'){
                                strWarrantyExpDateTime = ICS_Support_Warranty_Util.getGMTFormattedDate(lstEndDate[1]);
                                System.debug('***strWarrantyExpDateTime===>' + strWarrantyExpDateTime);
                          }
                        } else if (objValidateData.containsIgnoreCase('DeterminationType')) {
                            List < String > lstDeterminationType = objValidateData.split(':');
                            strDeterminationType = lstDeterminationType[1];
                            System.debug('***strDeterminationType='+strDeterminationType);
                        } else if (objValidateData.containsIgnoreCase('Error')) {
                            List<String> lstError = objValidateData.split(':');
                             if(lstError[0] == 'Error' && lstError[1] != null){
                                if(lstError[1]==Label.ICS_Support_SerialNumber_Error){
                                 throw new InvalidInputException(); 
                                }
                                if(warrantyMode == 'create'){   
                                  lstWarrantyValidationMsgs.add(lstError[1]);
                                }    
                            }
                        }
                        if (objValidateData.contains('lineItemDetail')) {
                            //Start--US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
                            //fraudCheckErrMsgs = (ICS_WR_Warranty_Util_Agent.fraudCheckResponse) JSON.deserialize(objValidateData, ICS_WR_Warranty_Util_Agent.fraudCheckResponse.class);
                            fraudCheckErrMsgs = (ICS_WR_Warranty_Util_Agent_LEX.fraudCheckResponse) JSON.deserialize(objValidateData, ICS_WR_Warranty_Util_Agent_LEX.fraudCheckResponse.class);
                            lstFraudExceptions = new List < String > ();
                            isStrFraudCheck = false;
                            if (fraudCheckErrMsgs.fraudErrs.get('Error') != null) {
                                lstFraudExceptions.addAll(fraudCheckErrMsgs.fraudErrs.get('Error'));
                            }
                            if(userDetails[0].Account.ICS_WR_Hold_Indicator__c == true)
                            {
                              lstFraudExceptions.add(Label.ICS_Support_Line_Item_Number+':'+Label.ICS_WR_Account_Is_in_Hold_Warning);
                            }
                            if (lstFraudExceptions.size() > 0 && lstFraudExceptions != null) {
                                isStrFraudCheck = true;
                            }
                            frw = new FraudCheckWrapper(fraudCheckErrMsgs.lineItemDetail.ICS_WR_Valid_FPO_Number__c, fraudCheckErrMsgs.lineItemDetail.ICS_WR_Valid_ATPO_Number__c, fraudCheckErrMsgs.lineItemDetail.ICS_WR_FPO_Frequency__c, fraudCheckErrMsgs.lineItemDetail.ICS_WR_ATPO_Frequency__c, fraudCheckErrMsgs.lineItemDetail.ICS_WR_Stolen_Product__c, fraudCheckErrMsgs.lineItemDetail.ICS_WR_SRR_Fraud__c, fraudCheckErrMsgs.lineItemDetail.ICS_WR_ATPO_FPO_Match__c, fraudCheckErrMsgs.lineItemDetail.ICS_WR_Shipped_To_Country__c, fraudCheckErrMsgs.lineItemDetail.ICS_WR_APE_GEO_Check_Successful__c, fraudCheckErrMsgs.lineItemDetail.ICS_WR_RMA_List__c, fraudCheckErrMsgs.lineItemDetail.ICS_WR_Box_Tray_Indicator__c, lstFraudExceptions,fraudCheckErrMsgs.lineItemDetail.ICS_WR_Valid_Serial_Number__c, fraudCheckErrMsgs.lineItemDetail.ICS_WR_SNO_Replacement_Frequency__c, fraudCheckErrMsgs.lineItemDetail.ICS_WR_SNO_Return_Frequency__c, fraudCheckErrMsgs.lineItemDetail.ICS_WR_SNO_Validated_By__c);
                            System.debug('***FraudCheckWrapper frw:' + frw);
                        }
                    }
                } else {
                     throw new NoDataException(); 
                }
          
            //Preparing success response wrapper 
            SuccessWrapper successWrap = new SuccessWrapper(ProductType, strATPONumber, lstProducts[0].Name, strFPONumber, strStartDate, strWarrantyExpDateTime, strWarrantyExpDateTime, strDeterminationType, strWarrantyCheck, frw, StockingId, MMId, strSerialNumber, ProductId,lstWarrantyValidationMsgs,isStrFraudCheck);
            ResponseWrapper finalSuccessResponse = new ResponseWrapper(200, true, successWrap, null);

            String dummy = ICS_Support_API_Utility.logTransaction('WarrantyCheck', System.JSON.serialize(finalSuccessResponse), startTimeLong, null, null, true, notes, null);
            System.debug('dummy:' + dummy);
             return finalSuccessResponse; 
    
     }catch (RequiredFieldException ex){
            return(callExceptionUtility(req.toString(),'ICS_Support_WRProductSearch_Handler.getWarrantyProducts','RequiredFieldException',null));
        }
        catch (NoDataException ex){
            return(callExceptionUtility(req.toString(),'ICS_Support_WRProductSearch_Handler.getWarrantyProducts','NoDataException',null));
        } 
        catch (InvalidInputException ex){
            return(callExceptionUtility(req.toString(),'ICS_Support_WRProductSearch_Handler.getWarrantyProducts','InvalidInputException',null));
        }
        catch (SiteUserLoginException ex){
            return(callExceptionUtility(req.toString(),'ICS_Support_WRProductSearch_Handler.getWarrantyProducts','SiteUserLoginException',null));
        }
        catch(InvalidUserException ex){
            return(callExceptionUtility(req.toString(),'ICS_Support_WRProductSearch_Handler.getWarrantyProducts','InvalidUserException',null));
        }catch(TrayProcessorException ex){
            return(callExceptionUtility(req.toString(),'ICS_Support_WRProductSearch_Handler.getWarrantyProducts','TrayProcessorException',null));
        }
        catch(SystemDownTimeException ex){
           return(callExceptionUtility(req.toString(),'ICS_Support_WRProductSearch_Handler.getWarrantyProducts','SystemDownTimeException',null)); 
        }
        catch (exception e){
          system.debug('Error !! '+e.getMessage());
          return(callExceptionUtility(req.toString(),'ICS_Support_WRProductSearch_Handler.getWarrantyProducts','',e));
        }
    }
    
 //Common logic for check and create   
 private static List<String> doActionCall(RestRequest req, String ProductType, String FPOStockingNumber, String ATPOSerialNumber, String ProductId, String MMId, String StockingId,String strmode,String strRMAType,String strContactId,String shipCountryCode,String shipGeoCode,string strDepotId){
       
          String validateJson = Json.serialize(new WarrantyLineItemWarapper(ProductId, Label.ICS_Support_Line_Item_Number, productCategory, FPOStockingNumber, ATPOSerialNumber, MMId));
          System.debug('validserilize:' + validateJson);
          notes += 'Initialization took: ' + (system.currentTimeMillis() - startTimeLong) + ' ms \n';
          long funcStartTime = system.currentTimeMillis();
         //Condition for product types
         if(ProductType == 'Processor'){
            //Calling TCA System
            ICS_WR_ProcessorInfo_Util.ValidateProcessorResult cattsTcaResponse = (ICS_WR_ProcessorInfo_Util.ValidateProcessorResult) ICS_Support_Warranty_Util.callCattsTCASystem(validateJson);
            notes += 'Catts tca response in warranty check mode : ' + (system.currentTimeMillis() - funcStartTime) + ' ms \n';
            System.debug('cattsTcaResponse----->:' + cattsTcaResponse);
            
            //Down time message for tca system
            if (cattsTcaResponse == null && cattsTcaResponse.Error == 'true') {
              throw new SystemDownTimeException();   
            }
          
            if(cattsTcaResponse != null && cattsTcaResponse.BoxTrayIndicator == 'Tray') { //Checking Tray processor condition for hard stop
              throw new TrayProcessorException(); 
            }
            String jsondata = Json.serialize(cattsTcaResponse);
            System.debug('jsondata:' + jsondata);
            
            if(strmode == 'create'){
                long funcStartTime3 = system.currentTimeMillis();
                Map < String, Set < String >> fraudCheckResponse = (Map < String, Set < String >> ) ICS_Support_Warranty_Util.ValidateFraudCheckProcessor(jsondata, validateJson, MMId, StockingId, strRMAType, strContactId, true, shipCountryCode, shipGeoCode);
                notes += 'Fraud check validation in warranty create mode: ' + (system.currentTimeMillis() - funcStartTime3) + ' ms \n';
                system.debug('fraudCheckResponse' + fraudCheckResponse);
                setFraudvalues = fraudCheckResponse.get(Label.ICS_Support_Line_Item_Number);
            }
            
            long funcStartTime2 = system.currentTimeMillis();
            Map < String, Set < String >> processorValidateData = ICS_Support_Warranty_Util.doWarrantyCheckProccesorValidation(jsondata, validateJson, MMId, StockingId, strContactId, strDepotId, false);
            notes += 'Warranty processor validation in warranty check mode: ' + (system.currentTimeMillis() - funcStartTime2) + ' ms \n';
            System.debug('processorValidateData:' + processorValidateData);
            
            lstSet = processorValidateData.get(Label.ICS_Support_Line_Item_Number);
            
            if (setFraudvalues != null && setFraudvalues.size() > 0) {//Appending fraud check response to processor validation response
              lstSet.addAll(setFraudvalues);
            }
            System.debug('lstSetFraud Values:' + lstSet);
            if (lstSet != null && lstSet.size() > 0) {
              lstStrings = new List < String > ();
              lstStrings.addAll(lstSet);
            } else {
                throw new NoDataException();
            }
          }else if(productCategory == 'Non-Processor')
           {
            long funcStartTime1 = system.currentTimeMillis();
            //Call for Syntrax System
            ICS_WR_ConsumingSNtraxDATA.SerialNoResult syntraxResults = (ICS_WR_ConsumingSNtraxDATA.SerialNoResult) ICS_Support_Warranty_Util.callSyntraxSystem(validateJson);
            notes += 'Syntrax response in warranty create mode: ' + (system.currentTimeMillis() - funcStartTime1) + ' ms \n';
            System.debug('syntraxResults----->:' + syntraxResults);
            
            //Down time message for Syntrax System
            if (ICS_WR_ConsumingSNtraxDATA.isError) {
              throw new SystemDownTimeException(); 
            }
            String syntraxdata = Json.serialize(syntraxResults);
            
            if(strmode == 'create'){
            long funcStartTime3 = system.currentTimeMillis();
            //Call for Fraud Check Validation
            Map < String, Set < String >> fraudNonProRes = (Map < String, Set < String >> ) ICS_Support_Warranty_Util.ValidateFraudCheckNonProcessor(syntraxdata, validateJson, MMId, StockingId, strRMAType, strContactId, true, shipCountryCode, shipGeoCode);
            notes += 'Fraud check Non-Processor validation in warranty create mode: ' + (system.currentTimeMillis() - funcStartTime3) + ' ms \n';
            system.debug('fraudNonProRes:' + fraudNonProRes);
            setFraudvalues = fraudNonProRes.get(Label.ICS_Support_Line_Item_Number);
            }
            
            long funcStartTime4 = system.currentTimeMillis();
            //Call for Non - Processor validation
            Map < String, Set < String >> NonprocessorValidateData = ICS_Support_Warranty_Util.doWarrantyCheckNonProcessorValidation(syntraxdata, validateJson, MMId, StockingId, strContactId, strDepotId, false);
            notes += 'Warranty Non-Processor validation in warranty create mode: ' + (system.currentTimeMillis() - funcStartTime4) + ' ms \n';
            System.debug('NonprocessorValidateData------>:' + NonprocessorValidateData);
            
            lstSet = NonprocessorValidateData.get(Label.ICS_Support_Line_Item_Number);
            if (setFraudvalues != null && setFraudvalues.size() > 0) {
            lstSet.addAll(setFraudvalues);
            }
            System.debug('lstSetFraud Values:' + lstSet);
            if (lstSet != null && lstSet.size() > 0) {
            lstStrings = new List < String > ();
            lstStrings.addAll(lstSet);
            } else {
              throw new NoDataException();
            }
         }
         return lstStrings;
    }
    
    
    //Feteching exceptions from utility class
    private static ResponseWrapper callExceptionUtility(String RestInput, String callingMethod, String UserDefinedException, Exception e) {
        ICS_Support_ExceptionUtility exUtility = new ICS_Support_ExceptionUtility();
        ICS_Support_ExceptionUtility.exceptionWrapper ew = new ICS_Support_ExceptionUtility.exceptionWrapper();
        if (!String.isEmpty(UserDefinedException)) {
            ew = exUtility.getExceptionDetails(RestInput, clientId, 'ICS_Support_WRcheck', callingMethod, UserDefinedException, null);
        } else {
            ew = exUtility.getExceptionDetails(RestInput, clientId, 'ICS_Support_WRcheck', callingMethod, '', e);
        }
        exceptionWrapper ew1 = new exceptionWrapper(ew.errorMessage, ew.TraceID);
        String dummy = ICS_Support_API_Utility.logTransaction('WarrantyCheck', System.JSON.serialize(new ResponseWrapper(ew.Code, false, null, ew1)), startTimeLong, null, null, true, notes, null);
        System.debug('dummy:' + dummy);
        return (new ResponseWrapper(ew.Code, false, null, ew1));
    }
   
    /*Wrapper classes section*/
    public class WarrantyLineItemWarapper {
        public String validateProductId {
            get;
            set;
        }
        public String validateMainLineItem {
            get;
            set;
        }
        public String validateProductType {
            get;
            set;
        }
        public String strFpoNumber {
            get;
            set;
        }
        public String strAtpoNumber {
            get;
            set;
        }
        public String strPacNumber {
            get;
            set;
        }
        public String mmid {
            get;
            set;
        }
        public WarrantyLineItemWarapper(String validateProductId, String validateMainLineItem, String validateProductType, String strFpoNumber, String strAtpoNumber, String mmid) {
            this.validateMainLineItem = validateMainLineItem;
            this.validateProductId = validateProductId;
            this.validateProductType = validateProductType;
            this.strFpoNumber = strFpoNumber;
            this.strAtpoNumber = strAtpoNumber;
            this.mmid = mmid;
        }
    }
    public class FraudCheckWrapper {
        public String isValidFPONumber;
        public String isValidATPONumber;
        public Decimal FPOFrequency;
        public Decimal ATPOFrequency;
        public String StolenProduct;
        public String isSRRFraud;
        public String ATPOFPOMatch;
        public String ShippedToCountry;
        public String isAPEGEOCheck;
        public String RMAList;
        public String BoxTrayIndicator;
        public List < String > FraudExceptionDetails;
        public String isValidSerialNumber;
        public Decimal SNOReplacementFrequency;
        public Decimal SNOReturnFrequency;
        public String SNOValidatedBy;
        public FraudCheckWrapper(String isValidFPONumber, String isValidATPONumber, Decimal FPOFrequency, Decimal ATPOFrequency, String StolenProduct, String isSRRFraud, String ATPOFPOMatch, String ShippedToCountry, String isAPEGEOCheck, String RMAList, String BoxTrayIndicator, List < String > FraudExceptionDetails,String isValidSerialNumber, Decimal SNOReplacementFrequency, Decimal SNOReturnFrequency, String SNOValidatedBy) {
            this.isValidFPONumber = isValidFPONumber;
            this.isValidATPONumber = isValidATPONumber;
            this.FPOFrequency = FPOFrequency;
            this.ATPOFrequency = ATPOFrequency;
            this.StolenProduct = StolenProduct;
            this.isSRRFraud = isSRRFraud;
            this.ATPOFPOMatch = ATPOFPOMatch;
            this.ShippedToCountry = ShippedToCountry;
            this.isAPEGEOCheck = isAPEGEOCheck;
            this.RMAList = RMAList;
            this.BoxTrayIndicator = BoxTrayIndicator;
            this.FraudExceptionDetails = FraudExceptionDetails;
            this.isValidSerialNumber = isValidSerialNumber;
            this.SNOReplacementFrequency = SNOReplacementFrequency;
            this.SNOReturnFrequency = SNOReturnFrequency;
            this.SNOValidatedBy = SNOValidatedBy;
        }

    }
    global class ResponseWrapper {
        public Decimal Code;
        public Boolean isSuccess;
        public SuccessWrapper SuccessContent;
        public ExceptionWrapper ErrorContent;
        public ResponseWrapper(Decimal code, Boolean isSuccess, SuccessWrapper SuccessContent, ExceptionWrapper ErrorContent) {
            this.Code = Code;
            this.isSuccess = isSuccess;
            this.SuccessContent = SuccessContent;
            this.ErrorContent = ErrorContent;
        }
    }
    global class SuccessWrapper {
        public String ProductType;
        public String ATPONumber;
        public String ProductName;
        public String FPONumber;
        public DateTime StartDate;
        public DateTime EndDate;
        public DateTime WarrantyExpiryDate;
        public String DeterminationType;
        public String WarrantyCheck;
        public FraudCheckWrapper FraudCheckResponse;
        public String StockingId;
        public String MMId;
        public String SerialNumber;
        public String ProductId; 
        public List<String> WarrantyCheckMessages;
        public Boolean isFraud;
        public SuccessWrapper(String ProductType, String ATPONumber, String ProductName, String FPONumber, DateTime StartDate, DateTime EndDate, DateTime WarrantyExpiryDate, String DeterminationType, String WarrantyCheck, FraudCheckWrapper FraudCheckResponse, String StockingId, String MMId, String SerialNumber, String ProductId,List<String> WarrantyCheckMessages,Boolean isFraud) {
            this.ProductType = ProductType;
            this.ATPONumber = ATPONumber;
            this.ProductName = ProductName;
            this.FPONumber = FPONumber;
            this.StartDate = StartDate;
            this.EndDate = EndDate;
            this.WarrantyExpiryDate = WarrantyExpiryDate;
            this.DeterminationType = DeterminationType;
            this.WarrantyCheck = WarrantyCheck;
            this.FraudCheckResponse = FraudCheckResponse;
            this.StockingId = StockingId;
            this.MMId = MMId;
            this.SerialNumber = SerialNumber;
            this.ProductId = ProductId;
            this.WarrantyCheckMessages = WarrantyCheckMessages;
            this.isFraud = isFraud;
        }
    }
    global class ExceptionWrapper {
        public string ErrorMessage;
        public ID TraceId;
        public ExceptionWrapper(string ErrorMessage, ID TraceId) {
            this.ErrorMessage = ErrorMessage;
            this.TraceId = TraceId;
        }
    }
    private class RequiredFieldException extends Exception {}
    private class NoDataException extends Exception {} 
    private class InvalidInputException extends Exception{}
    private class SiteUserLoginException extends Exception{}
    private class InvalidUserException extends Exception{} 
    private class SystemDownTimeException extends Exception{} 
    private class TrayProcessorException extends Exception{}
}