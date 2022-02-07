/************************************************************************************************
* Name               : ICS_Support_WRProductSearch_Handler
* Description        : Handler class to get product information for warranty
* Developer          : Omni CX Orion
* Version History   : V1.0 - April 2018- Created 
************************************************************************************************/

global with sharing class ICS_Support_WRProductSearch_Handler {
    public static long startTimeLong = System.currentTimeMillis();
    private static String clientId;
    public static String notes = '';
    private static String contactId;
    private static String accountId;
    private static final String HDSTP_1001 = 'HDSTP_1001';  //Dependent system is down
    private static final String HDSTP_1002 = 'HDSTP_1002';  //No results found in the Dependentsystem
    private static final String HDSTP_1003 = 'HDSTP_1003';  //Prod not returnable over web
    private static final String HDSTP_1004 = 'HDSTP_1004';  //check for Tray Processors
    private static final String HDSTP_1005 = 'HDSTP_1005';  //exceeding limit of number of SRR during time frame
    private static final String HDSTP_1006 = 'HDSTP_1006';  //returntype not supported by the depot
    private static final String HDSTP_1007 = 'HDSTP_1007';  //isSRREligible
    public static List<ICS_Support_Warranty_Util.ProductWrapper> productsFromSearch;
    
/**this method would return the response wrapper with searched products**/
global ResponseWrapper getWarrantyProducts(RestRequest req){
        
        String reqParam = System.JSON.serialize(req);
        clientId = req.headers.get('client_id');
        
        String productType = req.params.get('type');
        String fpoStockingInput = req.params.get('input1');
        String atpoSerialInput = req.params.get('input2');
        String warrantyType = req.params.get('returntype');
        String mode = req.params.get('mode');
        Set<String> validWarrantyType = new Set<String>{'AWR', 'SWR', 'SRR', 'FUL'};
       
        //Uncomment for dev & devint testing only
        /**String strLoggingUser = req.params.get('oauth');
        if(String.isBlank(strLoggingUser)){
          strLoggingUser = UserInfo.getUserId(); 
        }**/
        String strLoggingUser = UserInfo.getUserId();
        SuccessContent success;
        ResponseWrapper response;
        List<WarrantyProductWrapper> wtyProductWrapperList;
        
        //This wrapper list contains all the searched results from search controller
        List<ICS_Support_Warranty_Util.ProductWrapper> prdWrapperLists;  
        ICS_Support_Warranty_Util searchUtil = new ICS_Support_Warranty_Util();
        //Changed variable type for common hardstopMessages
        Set<String> hardStopMessages;
        String strHardStop = '';
        Boolean isEligible = true;
        // Boolean to display if its Box/Tray product                                      
        Boolean isTrayProcessor = false;                                                                             
        String depotId = '';
        Boolean isATPOSearch = false;
        Boolean isProductNotSupported = false;
        Boolean isSRREligible;
        Integer entitlementTimeLimit=0;
        Integer calTimeBasedVal;
        Map<String,String>  EntiltementInfo;
        //This is to hold product type for b.logic
        String strProductType='';
        //Below set holds all the valid userprofiles
        Set<String> validProfiles = new Set<String>{'ICS Customer Community Web Portal', 'Anonymous API Profile'};
        String userProfile = '';
        
     try{
         notes+='Initialization took: '+(System.currentTimeMillis() - startTimeLong)+' ms \n';
         long funcStartTime = System.currentTimeMillis();
         
         List<User> loggedUser = [SELECT Id, Name, ContactId, AccountId, Profile.Name FROM User WHERE Id =:strLoggingUser LIMIT 1];
         notes+='Get User details took: '+(system.currentTimeMillis() - funcStartTime)+' ms \n';
          
         //Validate oauth details if entered incorrectly
         if(!String.isBlank(strLoggingUser) && (loggedUser == NULL || loggedUser.size()<1)){
            throw new InvalidUserException();
         }
        
         contactId = loggedUser[0].ContactId;
         accountId = loggedUser[0].AccountId;
         userProfile = loggedUser[0].Profile.Name;
         
         //Validation for User profile -- Only Users with valid profiles are allowed to access this API
         if(!validProfiles.contains(userProfile)) {
            throw new InvalidUserException();
         //Validate loggedInUser if mode is create
         }else if(mode == 'create' && userProfile != 'ICS Customer Community Web Portal'){
            throw new SiteUserLoginException(); 
         }
         
         //Validate required input parameters
         if(String.isEmpty(mode)){
            throw new RequiredFieldException();
         }
         
         if(String.isBlank(productType)){
            throw new RequiredFieldException();
         }
         //Validate product type values
         Set<String> productTypeValues = new Set<String>{'Processor', 'Memory', 'Board', 'MiniPC', 'Other'};
         if(!String.isBlank(productType) && !productTypeValues.contains(productType)){
            throw new InvalidInputException();
         }
         //Validate Mode
         Set<String> validModes = new Set<String>{'check', 'create'};
         if(!String.isBlank(mode) && !validModes.contains(mode)){
            throw new InvalidInputException();
         }
        
         //if(mode =='create' && String.IsEmpty(warrantyType)){
         if(mode =='create'){
             //Check for returntype mandatory if mode = create
             if(String.IsEmpty(warrantyType)){
                 throw new RequiredFieldException();   
             }
             //Validate returntype
             else if(!String.IsBlank(warrantyType) && !validWarrantyType.contains(warrantyType)){
                 throw new InvalidInputException();
             }
         }
         //Validate product type for FUL & create scenario
         if(mode=='create' && warrantyType == 'FUL'){
            if(productType != 'Other'){
            throw new InvalidInputException();
          }
        }
        
        //Setting proper product type values based from input param value
        if(productType == 'Processor'){
            strProductType = 'Processor';
        }
        else if(productType == 'Memory'){
            strProductType = 'SSD';
        }else if(productType == 'Board'){
            strProductType = 'Non-Processor';
        }else if(productType == 'MiniPC'){
            strProductType = 'Non-Processor';
        }else{
            strProductType = 'Non-Processor';
        }
         //Mode- check & Non-processor - BOTH mandatory
        if(mode == 'check'){
            if(strProductType == 'Non-Processor'){
                if(String.isBlank(fpoStockingInput) || String.isBlank(atpoSerialInput)){
                        throw new RequiredFieldException();                 
                }
            }//Mode -check & Memory - Any 1 input mandatory
            else if(strProductType == 'SSD'){
                if(String.isBlank(fpoStockingInput) && String.isBlank(atpoSerialInput)){
                        throw new RequiredFieldException();                 
                }
            }
            //Mode- check & Processors -FPO is mandatory
            else{
                if(String.isBlank(fpoStockingInput)){
                        throw new RequiredFieldException();                 
                }
            }       
        }
        //Mode- create- BOTH mandatory except in case of FUL warrantyType
         if(mode == 'create'){
            if(warrantyType == 'FUL' && String.isBlank(fpoStockingInput)){
                throw new RequiredFieldException();                 
            } 
            else if(warrantyType != 'FUL' && (String.isBlank(fpoStockingInput) || String.isBlank(atpoSerialInput))){
                throw new RequiredFieldException();                 
            }
        }
        notes+='All Exception scenario check took: '+(system.currentTimeMillis() - funcStartTime)+' ms \n';
        
        //Fetch Depotid
        depotId = ICS_Support_Warranty_Util.getDepotId(loggedUser[0].id);
        
        if(strProductType =='Processor'){
            //If ATPO is entered then search based on ATPO
            if(!String.isBlank(atpoSerialInput)){
                ICS_Support_Warranty_Util.inputFPO = fpoStockingInput;
                ICS_Support_Warranty_Util.inputVal = atpoSerialInput;
                isATPOSearch = true;
            }else{
                ICS_Support_Warranty_Util.inputVal = fpoStockingInput;
                ICS_Support_Warranty_Util.inputATPOVal = '';  //Passing blank to avoid null entry
            }
        
        //Setting inputs to be passed to utility class
        }else if(strProductType=='Non-Processor'){
            ICS_Support_Warranty_Util.inputVal  = atpoSerialInput;
            ICS_Support_Warranty_Util.inputPartNumVal  = fpoStockingInput;
        
        //Setting inputs for SSD type in check & create mode    
        }else if(strProductType =='SSD'){
            if(mode=='check'){
                if(!String.isEmpty(fpoStockingInput)){
                    ICS_Support_Warranty_Util.inputVal  = fpoStockingInput;
                }else{
                    ICS_Support_Warranty_Util.inputVal  = atpoSerialInput;
                }
            }//calling common SNtrax in create mode
            else if(mode=='create'){
                ICS_Support_Warranty_Util.inputVal  = atpoSerialInput;
                ICS_Support_Warranty_Util.inputPartNumVal  = fpoStockingInput;
            }
            
        }
        
        hardStopMessages = new Set<String>();
        //hardstop - If product is not SRR ELigible; timebasedSRRVal scenario
        if(mode == 'create' && warrantyType =='SRR'){
            isSRREligible = ICS_Support_Warranty_Util.checkSRREligibilty(loggedUser[0].id);
            //Start--US771556--Popcornapps--Commenting Entitlement info & Time based SRR logic as the time based SRR is not in use as part of IPA changes--17/9/2020
         /*   EntiltementInfo = ICS_WR_Warranty_Util_Agent.getAllEntitlements(contactId);
            ICS_WR_Entitlement_Configuration__c objEntiCon = (ICS_WR_Entitlement_Configuration__c)JSON.deserialize(EntiltementInfo.get('globalEntitlementValues'), ICS_WR_Entitlement_Configuration__c.class);
            calTimeBasedVal = Integer.valueOf(ICS_WR_Warranty_Util_Agent.checkNull(objEntiCon.ICS_WR_Time_Based_SRR_Default_Number__c)+Decimal.ValueOf(EntiltementInfo.get('AdditionalTimeSRRR')) - Decimal.ValueOf(EntiltementInfo.get('TotalTimeSRRVal')));
            entitlementTimeLimit=0;
            entitlementTimeLimit = Integer.valueOf(calTimeBasedVal);
            if(entitlementTimeLimit ==null){
                entitlementTimeLimit =0;
                calTimeBasedVal =0;
            }
            entitlementTimeLimit--;
            calTimeBasedVal = entitlementTimeLimit;
            System.debug('calTimeBasedVal ='+calTimeBasedVal);
            
            if(Integer.valueOf(calTimeBasedVal)<0){
                hardStopMessages.add(HDSTP_1005);
            } */
            //End--US771556--Popcornapps--17/9/2020
            if(!isSRREligible){
                hardStopMessages.add(HDSTP_1007);
            }
            
        }
        
         
        //call search 
        productsFromSearch =  ICS_Support_Warranty_Util.getSearchedProducts(strProductType, warrantyType, depotId, mode, 'Support');
        notes+='Product Search from TCA/Sntrax took: '+(system.currentTimeMillis() - funcStartTime)+' ms \n';
        //Get Hard stops from utility search
        hardStopMessages.add(ICS_Support_Warranty_Util.errorMessages);
        
        //Prepare hard stop message for tray processors
        isTrayProcessor = ICS_Support_Warranty_Util.blnTryMessage;
        if(isTrayProcessor){
            hardStopMessages.add(HDSTP_1004);
        }
                       
        //Fetch the product wrapper list
         Map<Id,ICS_Support_Warranty_Util.ProductWrapper> mapFilter = new  Map<Id,ICS_Support_Warranty_Util.ProductWrapper>();
         List<ICS_Support_Warranty_Util.ProductWrapper> prePrdWrapperLists = new List<ICS_Support_Warranty_Util.ProductWrapper>(); 
         
         for(ICS_Support_Warranty_Util.ProductWrapper objProductWrapper :productsFromSearch){
                mapFilter.put(objProductWrapper.mmRecord.MMID__c,objProductWrapper);
         }
         for(Id mmidRef : mapFilter.keySet()){
                prePrdWrapperLists.add(mapFilter.get(mmidRef)); 
         }
         
        if(strProductType =='Processor'){
            prdWrapperLists = prePrdWrapperLists;
        } else{
            prdWrapperLists = productsFromSearch;
        }
        
        //Creating final response Warranty Product Wrapper
        wtyProductWrapperList = new List<WarrantyProductWrapper>();
        if(prdWrapperLists!=null && prdWrapperLists.size()>0 && !isTrayProcessor){
              for(ICS_Support_Warranty_Util.ProductWrapper objProductWrapper : prdWrapperLists){
                    if(!String.IsEmpty(objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.Id)){
                        
                        //Prepare a new set & reinitialize isEligible boolean
                        Set<String> uniqueHardStops = new Set<String>();
                        isEligible = true;
                        
                        //Hard Stops at product level in Create mode
                        if(mode=='create' || mode == 'check'){
                            //hardstp - if warrantytype is not supported based on depotstock servicetype
                            if(!String.IsEmpty(warrantyType) && objProductWrapper.blnSupportType == false){
                                uniqueHardStops.add(HDSTP_1006);
                            }
                            //hardstp - if product is not returnable over web
                            if(objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.ICS_WR_Returnable_Over_Web__c == false){
                                uniqueHardStops.add(HDSTP_1003);
                            //TWC745-787 - Shobhit Srivastav - Popcornapps - 16/12/2021 is Locked field value will be true.
                                objProductWrapper.isLocked = true;
                            }
                            //hardstp - if product is in locked state - based on depotstock locked yes/no boolean
                            String productLocked = ICS_Support_Warranty_Util.mapLocked.get(objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__c+'_'+objProductWrapper.mmRecord.ICS_WR_Stocking__r.Name);
                            if (productLocked == 'true') {
                                uniqueHardStops.add(HDSTP_1003);
                                objProductWrapper.isLocked = true;
                                //TWC745-787 - Shobhit Srivastav - Popcornapps - 16/12/2021 END
                             }
                        }
                        if(uniqueHardStops!=null && uniqueHardStops.size()>0){
                             isEligible = false;                                 
                        }
                         
                        if(objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.Support_Life_Cycle_Status__c == Label.ICS_CX_EOIS){
                            isProductNotSupported = true;
                        }
                        
                        //Converting Set of hardStopMessages associated to each prod to a String
                        String strHardStopMessage = '';
                        for(String hardstops : uniqueHardStops){
                            strHardStopMessage+= hardstops + ' ';
                        }
                        if(strHardStopMessage.length()>0){
                            strHardStopMessage = strHardStopMessage.substring(0, strHardStopMessage.length()-1);
                        }
                        
                        //Creating warranty productSelection wrapper to hold appropriate product information
                        if(strProductType =='Processor'){
                           wtyProductWrapperList.add(new WarrantyProductWrapper(objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.Name, objProductWrapper.fpoNumber, objProductWrapper.atpoNumber, '',
                                                                                objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.Id, objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.EPM_ID__c, objProductWrapper.mmRecord.MMID__r.Name,
                                                                                objProductWrapper.mmRecord.ICS_WR_Stocking__r.Name,  isProductNotSupported , isEligible, strHardStopMessage,objProductWrapper.isLocked));
                         
                         } 
                        if(strProductType =='Non-Processor' || (mode == 'create' && strProductType =='SSD')){
                           wtyProductWrapperList.add(new WarrantyProductWrapper(objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.Name, '', '', objProductWrapper.atpoNumber, objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.Id, 
                                                                                objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.EPM_ID__c, objProductWrapper.mmRecord.MMID__r.Name, objProductWrapper.mmRecord.ICS_WR_Stocking__r.Name, 
                                                                                isProductNotSupported, isEligible, strHardStopMessage,objProductWrapper.isLocked));
                        }
                        //Commenting out this condition for FUL check as we are displaying product name for all warranty types
                        //if (warrantyType == 'FUL') {
                        //Tchauhan--Replaced productname with stockingid.desc
                        //    wtyProductWrapperList.add(new WarrantyProductWrapper(objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.Name, '', '', objProductWrapper.atpoNumber, objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.Id, 
                        //                                                        objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.EPM_ID__c, objProductWrapper.mmRecord.MMID__r.Name, objProductWrapper.mmRecord.ICS_WR_Stocking__r.Name, 
                        //                                                        isProductNotSupported, isEligible, strHardStopMessage));
                        //}
                        //Setting serialnumber values based on diff SNtrax responses in diff modes
                        if(strProductType =='SSD' && mode=='check'){
                            wtyProductWrapperList.add(new WarrantyProductWrapper(objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.Name, '', '', objProductWrapper.fpoNumber, objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.Id,
                                                                                objProductWrapper.mmRecord.MMID__r.ICS_WR_Product__r.EPM_ID__c, objProductWrapper.mmRecord.MMID__r.Name, objProductWrapper.mmRecord.ICS_WR_Stocking__r.Name,
                                                                                isProductNotSupported, isEligible, strHardStopMessage,objProductWrapper.isLocked));
                        } 

                    }
                 
                    if(strProductType=='Non-Processor' && warrantyType == 'FUL'){
                            break;
                    }
                    
                }           
                //US101498: Updated output json---TChauhan---21052018
                if(strProductType =='Processor'){
                    success = new successContent(productType, fpoStockingInput, atpoSerialInput, '', '', wtyProductWrapperList);
                }else{
                    success = new successContent(productType, '', '', fpoStockingInput, atpoSerialInput, wtyProductWrapperList);
                }
        }
        //Below condition will be executed if NO PRODUCTS returned from TCA/SNTRAX along with hardstop messages
        else if((Null== prdWrapperLists || prdWrapperLists.size()<1) && hardStopMessages.size()>0){
            for(String hardstops : hardStopMessages){
                strHardStop += hardstops + ' ';
            }
            if(strHardStop.length()>0){
                strHardStop = strHardStop.substring(0, strHardStop.length()-1);
            }
            isEligible = false;                                 
            wtyProductWrapperList.add(new WarrantyProductWrapper('','','','','','','','', isProductNotSupported , isEligible , strHardStop,false));
            //US101498: Updated output json---TChauhan---21052018
            if(strProductType=='Processor'){
                success = new successContent(productType, fpoStockingInput, atpoSerialInput, '', '', wtyProductWrapperList);
            }else{
                success = new successContent(productType, '', '', fpoStockingInput, atpoSerialInput, wtyProductWrapperList);
            }
        }
        else{
            throw new NoDataException();
        }
     
     } 
        catch (RequiredFieldException ex){
            return(callExceptionUtility(reqParam,'ICS_Support_WRProductSearch_Handler.getWarrantyProducts','RequiredFieldException',null));
        }
        catch (NoDataException ex){
            return(callExceptionUtility(reqParam,'ICS_Support_WRProductSearch_Handler.getWarrantyProducts','NoDataException',null));
        } 
        catch (InvalidInputException ex){
            return(callExceptionUtility(reqParam,'ICS_Support_WRProductSearch_Handler.getWarrantyProducts','InvalidInputException',null));
        }
        catch (SiteUserLoginException ex){
            return(callExceptionUtility(reqParam,'ICS_Support_WRProductSearch_Handler.getWarrantyProducts','SiteUserLoginException',null));
        }
        catch(InvalidUserException ex){
            return(callExceptionUtility(reqParam,'ICS_Support_WRProductSearch_Handler.getWarrantyProducts','InvalidUserException',null));
        }
        catch (exception e){
          system.debug('Error !! '+e.getMessage());
          return(callExceptionUtility(reqParam,'ICS_Support_WRProductSearch_Handler.getWarrantyProducts','',e));
        }
        
        response = new ResponseWrapper(200,true,success,null);
        String dummy = ICS_Support_API_Utility.logTransaction('WRProductSearch',System.JSON.serialize(response),startTimeLong,ContactId,AccountID,false,notes,null);
        return response;
}
// This method calls ExceptionUtility class to log the error
    private static ResponseWrapper callExceptionUtility(String RestInput, String callingMethod, String UserDefinedException,Exception e) {
        ResponseWrapper WRProductWrapper;
        ICS_Support_ExceptionUtility exUtility = new ICS_Support_ExceptionUtility();
        ICS_Support_ExceptionUtility.exceptionWrapper exWrapper = new ICS_Support_ExceptionUtility.exceptionWrapper();
        if(!String.isEmpty(UserDefinedException)) {
            exWrapper = exUtility.getExceptionDetails(RestInput,clientId,'WRProductSearch',callingMethod,UserDefinedException,null);
            system.debug('***exWrapper: '+exWrapper);
        } else {
            exWrapper = exUtility.getExceptionDetails(RestInput,clientId,'WRProductSearch',callingMethod,'',e);
        }
        
        ExceptionWrapper ew1 = new ExceptionWrapper(exWrapper.errorMessage,  exWrapper.TraceID);
        WRProductWrapper = new ResponseWrapper(integer.valueof(exWrapper.code),false,null,ew1); // Initialize main Wrapper
        String dummy = ICS_Support_API_Utility.logTransaction('WRProductSearch',System.JSON.serialize(WRProductWrapper),startTimeLong,ContactId,AccountID,true,notes,null);
        return WRProductWrapper; 
    }
    
    //Product details wrapper
    global class WarrantyProductWrapper{
        global String ProductName;
        global String SystemFPONumber;
        global String SystemATPONumber;
        global String SystemSerialNumber;
        global String ProductId;
        global String EPMId;
        global String MMId;
        global String SystemStockingId;
        global Boolean isNotSupported;
        global Boolean isEligibleForWarrantyCheck;
        global String HardStopMessage;
         global Boolean isLocked;
        global WarrantyProductWrapper(String prodName,String sysFPO, String sysATPO, String serial, String prodId, String EPMId, String MMId, String stocking, Boolean isNotSupported, Boolean isEligible, String hardStopMsg,Boolean isLocked){
            this.ProductName = prodName;
            this.SystemFPONumber = sysFPO;
            this.SystemATPONumber = sysATPO;
            this.SystemSerialNumber = serial;
            this.ProductId = prodId;
            this.EPMId= EPMId;
            this.MMId=MMId;
            this.SystemStockingId = stocking;
            this.isNotSupported= isNotSupported;
            this.isEligibleForWarrantyCheck = isEligible;
            this.HardStopMessage = hardStopMsg;
            this.isLocked = isLocked;
        }
    
    }

    //US101498: Updated output json---TChauhan---21052018
    //Success Wrapper  
    global class SuccessContent{
        global String ProductType;
        global String FPONumber;
        global String ATPONumber;
        global String StockingId;
        global String SerialNumber;
        global List<WarrantyProductWrapper> Products;
        global SuccessContent(String productType, String fpoNum, String atpoNum, String stockingid, String serialNum, List<WarrantyProductWrapper> listOfproducts){
            this.ProductType = productType;
            this.FPONumber = fpoNum;
            this.ATPONumber = atpoNum;
            this.StockingId = stockingid;
            this.SerialNumber = serialNum;
            this.Products = listOfproducts;
        }
    } 
    
  //Final Response Wrapper
    global class ResponseWrapper{
        global Decimal Code;
        global Boolean isSuccess; 
        global SuccessContent SuccessContent;
        global ExceptionWrapper ErrorContent;
        global ResponseWrapper(Decimal Code, Boolean isSuccess, SuccessContent SuccessContent, ExceptionWrapper ErrorContent){
            this.Code = Code;
            this.isSuccess = isSuccess;
            this.SuccessContent = SuccessContent;
            this.ErrorContent = ErrorContent;
        }      
    }
    
    global class ExceptionWrapper{
        global string ErrorMessage;
        global ID TraceId;
        global ExceptionWrapper(string ErrorMessage, ID TraceId){
            this.ErrorMessage = ErrorMessage;
            this.TraceId = TraceId;
        }
    }
    private class RequiredFieldException extends Exception {}
    private class NoDataException extends Exception {} 
    private class InvalidInputException extends Exception{}
    private class SiteUserLoginException extends Exception{}
    private class InvalidUserException extends Exception{}
    

}