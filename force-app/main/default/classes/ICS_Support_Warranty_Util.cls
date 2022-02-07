/************************************************************************************************
 * Name             : ICS_Support_Warranty_Util
 * Description      : API Utility Class for calling reusable methods like WR remote methods that calls CAATS TCA/Syntrax/iBase systems
 * Developer        : Omni CX Orion
 * Version History  : V1.0 - April 2018 - Created 
 ************************************************************************************************/

public with sharing class ICS_Support_Warranty_Util {
public static Boolean blnsyntraxError;
public static Boolean blnTryMessage;
public static Boolean blnATPORender;
public static String FPOBufferCX;
public static String inputVal;
public static String inputFPO;
public static String inputATPOVal;
public static String inputPartNumVal;
public static String errorMessages;
public static List<ProductWrapper>  prdWrapperList;
public static List<ICS_WR_MM_Stocking__c> lstMMStock ;
public static Set<String> lstMMId;
public static Set<String> lstStockingId ;
public static Map<String, String> mapQryParameter;
public static Map<String, String> mapStockingIdFPO ;
public static Map<String,String> mapLocked;
public static ICS_WR_ConsumingSNtraxDATA.SerialNoResult response;
public static ICS_WR_ConsumingSNtrax_SSD.SSDResult SSDresponse;
//US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
//public static ICS_WR_ProcessorInfo_Util.MMIDListResult TCAResponse;
public static ICS_WR_ProcessorInfo_Util_LEX.MMIDListResult TCAResponse;
public static List<ProductWrapper> lstglobalProductwrapper;
public static List<String> lststocking ;
public static Set<String> setstocking ;
private static final String PRODUCT_TYPE_PROCESSOR = Label.ICS_WR_Processor;
private static final String PRODUCT_TYPE_NON_PROCESSOR = Label.ICS_WR_Non_Processor;
//private static Boolean flag;

private static final String HDSTP_1001 = 'HDSTP_1001';
private static final String HDSTP_1002 = 'HDSTP_1002';
private static final String HDSTP_1003 = 'HDSTP_1003';
private static final String HDSTP_1004 = 'HDSTP_1004';
private static final String HDSTP_1005 = 'HDSTP_1005';
private static final String HDSTP_1006 = 'HDSTP_1006';

public static Set<String> allHardStopMessages;

//Constructor       
public ICS_Support_Warranty_Util(){
     inputVal ='';
     inputFPO='';
     blnsyntraxError =false;
     blnTryMessage =false;
     inputATPOVal='';
     inputPartNumVal='';
    // prdWrapperList = new list<ProductWrapper>();
     FPOBufferCX = '';
     errorMessages='';
     blnATPORender =false;
    
}

/***********************************************************************
    * @author Tanvi
    * @date 04/07/2018
    * @description Fetch Depot ID 
    * @param SobjectType  : Logged User
    * @return ID of Depot 
************************************************************************/
public static String getDepotId(String loggedUserId){
    String depotId='';
    String countryName='';
    if(!String.isEmpty(loggedUserId)){
        //US771538--Popcornapps--harsha--3/9/2020--Commented IF Condition containing ITP and CIP membership references as part of IPA changes
		//Commented ITP and CIP fields in soql as part of IPA changes
        //US707553--PopcornApps--2/7/2020--Adding Account record type and contact warranty requestor fields to soql
    User contactUser = [SELECT Id, ContactId, AccountId, Account.BillingCountry, Account.ShippingCountry,Account.Recordtype.DeveloperName,Contact.ICS_IPA_Warranty_Requestor__c, Account.Core_Account_Geo__c,Contact.Core_Language__c,Account.Core_Account_Sub_Geo__c,
                               Contact.MailingCountryCode,Contact.ICS_Contact_Sub_Geo__c, Contact.ICS_Contact_Geo__c,Contact.MailingStateCode, Contact.MailingCountry, Account.ICS_WR_Hold_Indicator__c
                               FROM User WHERE id=:loggedUserId LIMIT 1];
    /*String itpMembershipStatus = contactUser.Account.Core_ITP_Program_Membership__c;	
    String cipMembershipStatus = contactUser.Account.Core_CIP_Program_Membership__c;	
    System.debug('Core_ITP_Program_Membership__c----'+itpMembershipStatus); 	
    System.debug('Core_CIP_Program_Membership__c----'+cipMembershipStatus); */                                    
    List<Core_Country_Reference__c> listCountryRefs = Core_Country_Reference__c.getAll().Values();
        //Start--US707553--PopcornApps--2/7/2020--Commented if condition replacing condition from itp to ipa 
        for(Core_Country_Reference__c CountryRefs : listCountryRefs ) {
             // if(contactUser.Account.ShippingCountry != NULL && ((String.isNotBlank(itpMembershipStatus) && itpMembershipStatus != 'NON ITP') || (String.isNotBlank(cipMembershipStatus) && cipMembershipStatus != 'UNDETERMND'))){
             if(contactUser.Account.ShippingCountry != NULL && (contactUser.Account.Recordtype.DeveloperName == 'Non_Editable_Accounts' && contactUser.Contact.ICS_IPA_Warranty_Requestor__c == true)){
                if(CountryRefs.Core_ISO_Code__c==contactUser.Account.ShippingCountry){
                    countryName=CountryRefs.Name;
                    break;
                }
            }else{
                if(CountryRefs.Core_ISO_Code__c==contactUser.Account.BillingCountry){
                    countryName=CountryRefs.Name;
                    break;
                }else if(CountryRefs.Core_ISO_Code__c== contactUser.Contact.MailingCountry){//Added this condition for checking contact contry for setting depot
                    countryName=CountryRefs.Name;
                    break;
                }
            }
        }
        //End---US707553---PopcornApps
        System.debug('countryName============='+countryName);
        System.debug('Geo====='+contactUser.Account.Core_Account_Geo__c);
        System.debug('Sub Geo====='+contactUser.Account.Core_Account_Sub_Geo__c);           
		//Start--US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
        if((contactUser.Account.Core_Account_Geo__c != NULL) && (contactUser.Account.Core_Account_Sub_Geo__c != NULL) && (String.isNotEmpty(countryName))){
          //DepotId=ICS_WR_Warranty_Util_Agent.getWarrantyReturnReplacementDepot(contactUser.Account.Core_Account_Geo__c,contactUser.Account.Core_Account_Sub_Geo__c,countryName,'CX');
          DepotId=ICS_WR_Warranty_Util_Agent_LEX.getWarrantyReturnReplacementDepot(contactUser.Account.Core_Account_Geo__c,contactUser.Account.Core_Account_Sub_Geo__c,countryName,'CX');
        }else{
          //DepotId=ICS_WR_Warranty_Util_Agent.getWarrantyReturnReplacementDepot(contactUser.Contact.ICS_Contact_Geo__c,contactUser.Contact.ICS_Contact_Sub_Geo__c,countryName,'CX');
          DepotId=ICS_WR_Warranty_Util_Agent_LEX.getWarrantyReturnReplacementDepot(contactUser.Contact.ICS_Contact_Geo__c,contactUser.Contact.ICS_Contact_Sub_Geo__c,countryName,'CX');
        }
        //End--US789395--Popcornapps--5/10/2020
        System.debug('***DepotId='+depotId);
                
        }else{
            depotId = '';
        }   
        return depotId;
}
/***********************************************************************
    * @author Tanvi
    * @date 04/18/2018
    * @description To check if Is_SRR_Eligible
    * @param SobjectType  : Logged User
    * @return Boolean isSRREligible 
************************************************************************/
public static Boolean checkSRREligibilty(String loggedUserId){
    Decimal srrEligible;
    Boolean isSRREligible = false;
    if(!String.isEmpty(loggedUserId)){
         //US771538--Popcornapps--harsha--3/9/2020--Commented IF Condition containing ITP and CIP membership references as part of IPA changes
		//removed ITP and CIP fields in soql as part of IPA changes
        //US707553--PopcornApps--2/7/2020--Adding Account record type and contact warranty requestor fields in SOQL 
         User contactUser = [SELECT Id,  ContactId, AccountId, Account.BillingCountry, Account.ShippingCountry,Account.Recordtype.DeveloperName,Contact.ICS_IPA_Warranty_Requestor__c, Account.Core_Account_Geo__c,Contact.Core_Language__c,Account.Core_Account_Sub_Geo__c,
                               Contact.MailingCountryCode,Contact.ICS_Contact_Sub_Geo__c, Contact.ICS_Contact_Geo__c,Contact.MailingStateCode, Contact.MailingCountry, Account.ICS_WR_Hold_Indicator__c
                               FROM User WHERE id=:loggedUserId LIMIT 1];
        System.debug('***contactUser==='+contactUser);
       /* String itpMembershipStatus = contactUser.Account.Core_ITP_Program_Membership__c;	
        String cipMembershipStatus = contactUser.Account.Core_CIP_Program_Membership__c;*/
        //US707553--PopcornApps--2/7/2020--Commented conditions for itpMembershipStatus replacing it with IPA 
        //if(contactUser.Account.ShippingCountry != NULL && ((String.isNotBlank(itpMembershipStatus) && itpMembershipStatus != 'NON ITP') || (String.isNotBlank(cipMembershipStatus) && cipMembershipStatus != 'UNDETERMND'))){
		if(contactUser.Account.Recordtype.DeveloperName == 'Non_Editable_Accounts' && contactUser.Contact.ICS_IPA_Warranty_Requestor__c == true){
			//US707554--7/8/2020--PopcornApps--Commented ITP membership,Geo,SubGeo,Country fields are no longer in use for SRR eligibility as part of IPA changes
            //Start--US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
            //srrEligible = ICS_WR_Warranty_Util_Agent.getCheckSRREligibility(contactUser.AccountId);
            srrEligible = ICS_WR_Warranty_Util_Agent_LEX.getCheckSRREligibility(contactUser.AccountId);
             //srrEligible = ICS_WR_Warranty_Util_Agent.getCheckSRREligibility(contactUser.AccountId ,contactUser.Account.ShippingCountry,contactUser.Account.Core_Account_Geo__c,contactUser.Account.Core_Account_Sub_Geo__c ,contactUser.Account.Core_ITP_Program_Membership__c);
        }else{
        	//US707554--7/8/2020--PopcornApps--Commented ITP membership,Geo,SubGeo,Country fields are no longer in use for SRR eligibility as part of IPA changes
            //srrEligible = ICS_WR_Warranty_Util_Agent.getCheckSRREligibility(contactUser.ContactId);
            srrEligible = ICS_WR_Warranty_Util_Agent_LEX.getCheckSRREligibility(contactUser.ContactId);
            //srrEligible = ICS_WR_Warranty_Util_Agent.getCheckSRREligibility(contactUser.ContactId ,contactUser.Contact.MailingCountry,contactUser.Contact.ICS_Contact_Geo__c,contactUser.Contact.ICS_Contact_Sub_Geo__c ,'');
            //End--US789395--Popcornapps--5/10/2020
        }
        if(srrEligible == 1){ 
            isSRREligible = true;
        }
        System.debug('***isSRREligible ===>'+isSRREligible);
  }
  return isSRREligible; 
}
    
/***********************************************************************
    * @author      : Popcorn Apps
    * @date        : 22/05/2018
    * @description : Fetching syntrax response based on non processor data
    * @param SobjectType  : Product jon
    * @return       :Syntrax Response
************************************************************************/
 public static Object callSyntraxSystem(String ProudctLineItemData){
        System.debug('ProudctLineItemData:'+ProudctLineItemData);
     	//US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
       // Object SyntraxResponse = ICS_WR_Warranty_Create_Agent_Controller.callSNtraxSystem(ProudctLineItemData);
        Object SyntraxResponse = ICS_WR_Warranty_Create_Agent_Ctrl_LEX.callSNtraxSystem_Portal(ProudctLineItemData);
        System.debug('SyntraxResponse---->:'+SyntraxResponse);
        return SyntraxResponse;
    }    
    
/***********************************************************************
    * @author      : Popcorn Apps
    * @date        : 25/05/2018
    * @description : Fetching syntrax response based on non processor data
    * @param        SobjectType  : Product jon
    * @return       :processSSDResponseDate , return type - DateTime
    * TChauhan- Updated below method to return expiry date from SSD sntrax & iBase in GMT format always
************************************************************************/    
 public static DateTime processSSDResponseDate(ICS_WR_ConsumingSNtrax_SSD.SSDResult SSDresponse){
        DateTime SSDWarrantyExpire = NULL;
        if(SSDresponse!=null) {
            List<ICS_WR_MM_Stocking__c > mmstockinglst;
            if(SSDresponse.FERT!= null || SSDresponse.FERT!=''){
                String SSD_MMID = SSDresponse.FERT.deleteWhitespace();
                if (!String.isBlank(SSDresponse.ShippingDate)) {
                    List<String> inputDateList = SSDresponse.WarrantyExpire.split('/');
                    Integer day = integer.valueOf(inputDateList[1]);
                    Integer month = integer.valueOf(inputDateList[0]);
                    Integer year = integer.valueOf(inputDateList[2]);
                    SSDWarrantyExpire =  DateTime.newInstance(year,month,day);  //this will return date in GMT format
                    System.debug('***SSDWarrantyExpire date from SSD SNtrax :'+SSD_MMID + SSDWarrantyExpire);
                }
               //Ibase call logic to get expiry date
                List<ICS_WR_MMID_BU_Hierarchy__c> mmBuHierarchyRecord = [SELECT id,Name,ICS_WR_Operation_Business_Unit_Code__c FROM ICS_WR_MMID_BU_Hierarchy__c WHERE Name=:SSD_MMID limit 1];
                if(mmBuHierarchyRecord!=null && mmBuHierarchyRecord.size()>0){
                    List<ICS_WR_Operation_Business_Unit__mdt> operationUnit = [SELECT id,DeveloperName,Label FROM ICS_WR_Operation_Business_Unit__mdt WHERE DeveloperName=:mmBuHierarchyRecord[0].ICS_WR_Operation_Business_Unit_Code__c];
                        //if it is matching then call ibase
                        if(operationUnit!=null && operationUnit.size()>0){
                            //US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
                            //List<ICS_WR_ConsumingIbaseData.WarrantyInfoData> iBaseResponse = ICS_WR_Warranty_Util_Agent.ibaseCallMethod(inputVal);
                            List<ICS_WR_ConsumingIbaseData.WarrantyInfoData> iBaseResponse = ICS_WR_Warranty_Util_Agent_LEX.ibaseCallMethod(inputVal);
                            System.debug('===iBaseResponse ==='+iBaseResponse);
                            if(iBaseResponse!=null && iBaseResponse.size()>0 && iBaseResponse[0].WarrantyEnddate!=null ){
                                SSDWarrantyExpire = DateTime.newInstance((iBaseResponse[0].WarrantyEnddate).year(),(iBaseResponse[0].WarrantyEnddate).month(),(iBaseResponse[0].WarrantyEnddate).day());
                                System.debug('***SSDWarrantyExpire date from iBase :'+SSDWarrantyExpire);
                            }
                        }
                }    
            }
        }
        return SSDWarrantyExpire;
    }    
/***********************************************************************
    * @author      : Popcorn Apps
    * @date        : 25/05/2018
    * @description : Fetching syntrax response based on non processor data
    * @param SobjectType  : Product jon
    * @return       :doFraudCheckNonProcessor
************************************************************************/
public static Object ValidateFraudCheckNonProcessor(String Syntxdata,String validateJson,String MMId ,String StockingId,String strRMAType,String strContactId,Boolean blnFraudCheck,string shipCountryCode,string shipGeoCode){
   System.debug('Syntxdata:'+Syntxdata);
   //Start--US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
   //Object fraudNonProcesorRes = ICS_WR_Warranty_Create_Agent_Controller.doFraudCheckNonProcessor(Syntxdata,validateJson,MMId,StockingId,strRMAType,strContactId,blnFraudCheck,shipCountryCode,shipGeoCode);
	Object fraudNonProcesorRes = ICS_WR_Warranty_Create_Agent_Ctrl_LEX.doFraudCheckNonProcessor_Portal(Syntxdata,validateJson,MMId,StockingId,strRMAType,strContactId,blnFraudCheck,shipCountryCode,shipGeoCode);
    //End--US789395--Popcornapps--5/10/2020
    return fraudNonProcesorRes;
  } 
/***********************************************************************
    * @author      : Popcorn Apps
    * @date        : 22/05/2018
    * @description : Validating syntran and product line items and generating warranty expriry dates for non processors prodcut types
    * @param SobjectType  : Product jon
    * @return       :Non processor warranty response
************************************************************************/    
   public static Map<String,Set<String>> doWarrantyCheckNonProcessorValidation(String strSNTRAXResponses,String validateProductData,String strMMId ,String strStcokingId,String strStaticContact,String DepotId,Boolean blnFraudCheck){
    //Start--US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
   //Map<String,Set<String>>  nonProcessorResponse = ICS_WR_Warranty_Create_Agent_Controller.doWarrantyCheckNonProcessor(strSNTRAXResponses,validateProductData,strMMId,strStcokingId,strStaticContact,DepotId,blnFraudCheck);    
   Map<String,Set<String>>  nonProcessorResponse  =ICS_WR_Warranty_Create_Agent_Ctrl_LEX.doWarrantyCheckNonProcessor_Portal(strSNTRAXResponses,validateProductData,strMMId,strStcokingId,strStaticContact,DepotId,blnFraudCheck);
       //End--US789395--Popcornapps
    System.debug('nonProcessorResponseValidation---->:'+nonProcessorResponse);
    return nonProcessorResponse;
  }
 
/***********************************************************************
    * @author      : Popcorn Apps
    * @date        : 04/09/2018
    * @description : Fetching Catts Tca response
    * @param SobjectType  : Product jon
    * @return       :TCA Response
************************************************************************/
 public static Object callCattsTCASystem(String ProudctData){
        System.debug('ProudctData:'+ProudctData);
     	//US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
        //Object cattsTcaResponse = ICS_WR_Warranty_Create_Agent_Controller.calPMFTSystem(ProudctData);
     	Object cattsTcaResponse = ICS_WR_Warranty_Create_Agent_Ctrl_LEX.calPMFTSystem_Portal(ProudctData);
        System.debug('CattsTcaResponse11:'+cattsTcaResponse);
        return cattsTcaResponse;
    } 
/***********************************************************************
    * @author      : Popcorn Apps
    * @date        : 04/09/2018
    * @description : Fraudcheck validation
    * @param SobjectType  : Product jon
    * @return       :Fraud Check Response
************************************************************************/
 public static Object ValidateFraudCheckProcessor(String jsondata,String validateJson,String MMId ,String StockingId,String strRMAType,String strContactId,Boolean blnFraudCheck,string shipCountryCode,string shipGeoCode){
   System.debug('jsondata:'+jsondata);
  //Start--US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
   // Object fraudCheckvalidateResponse = ICS_WR_Warranty_Create_Agent_Controller.doFraudCheckProcessor(jsondata,validateJson,MMId,StockingId,strRMAType,strContactId,blnFraudCheck,shipCountryCode,shipGeoCode);
   Object fraudCheckvalidateResponse = ICS_WR_Warranty_Create_Agent_Ctrl_LEX.doFraudCheckProcessor_Portal(jsondata,validateJson,MMId,StockingId,strRMAType,strContactId,blnFraudCheck,shipCountryCode,shipGeoCode);
   //End--US789395--Popcornapps--5/10/2020
   return fraudCheckvalidateResponse;
  }  
  
/***********************************************************************
    * @author      : Popcorn Apps
    * @date        : 04/09/2018
    * @description : Validating processor data
    * @param SobjectType  : Product jon
    * @return       :Validated product response
************************************************************************/
 /*Generic static method for validating TCA response and product data*/    
   public static Map<String,Set<String>> doWarrantyCheckProccesorValidation(String tcaResponseJson,String producValidJson,String strMMID,String strStockingId,String strContactId,String strDepotId,Boolean blnFraudCheck){
   //Start--US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
   //Map<String,Set<String>> processorValidatedRes = ICS_WR_Warranty_Create_Agent_Controller.doWarrantyCheckProcessor(tcaResponseJson,producValidJson,strMMID,strStockingId,strContactId,strDepotId,blnFraudCheck);
   Map<String,Set<String>> processorValidatedRes = ICS_WR_Warranty_Create_Agent_Ctrl_LEX.doWarrantyCheckProcessor_Portal(tcaResponseJson,producValidJson,strMMID,strStockingId,strContactId,strDepotId,blnFraudCheck);
   //End--US789395--Popcornapps
   System.debug('processorValidatedRes--->:'+processorValidatedRes);
   return processorValidatedRes;
   }
/***********************************************************************
    * @author Tanvi
    * @date 04/07/2018
    * @description This method is used to search products based on product type, fpo/atpo/stockingid/serial number
    * @param productType, input1, input2, warrantyType, mode, portaltype
    * @return List of product wrapper
************************************************************************/
public static List<ProductWrapper> getSearchedProducts (String productType, String warrantyType, String depotId, String mode, String portalType){
    
      //Here we pass the RMA type value in transaction type custom setting and get the corresponding service type
        String strServicesType;
        String strTransactionType;
        String strServiceTypeException;
        List<String> lstServiceTypeException;
        lststocking = new List<String>();
        setstocking = new Set<String>();
        mapLocked = new Map<String,String>();
        prdWrapperList = new list<ProductWrapper>();
        //prdWrapperList.clear();
        ICS_WR_Warranty_Transaction_Types__c transactionSettings ;
        List<String> lstServiceType= new List<String>();
        allHardStopMessages = new Set<String>(); // Set to hold uniques hardstop codes    
         
         /**Agent Side Variables**/
         //Replacing spaces and *s with % to the search string and quering with new string
        //String searchText  = inputVal.trim();
        //inputVal  = searchText;
        //String inputString  = inputVal.trim();
       
        //Below snippet is to fetch 'transaction type' & ServiceTypeException condition for hardstop
       if(!String.isEmpty(warrantyType)){
           if(warrantyType == 'AWR'){
               strTransactionType = 'Advanced Warranty Return';
           }else if(warrantyType == 'SWR'){
               strTransactionType = 'Standard Warranty Return';
           }else if(warrantyType == 'SRR'){
               strTransactionType = 'Self Recycling Return';
           }else if(warrantyType == 'FUL'){
               strTransactionType = 'Fulfillment';
           }
            transactionSettings = ICS_WR_Warranty_Transaction_Types__c.getInstance(strTransactionType);
            if(transactionSettings != null){
                strServicesType = transactionSettings.ICS_WR_Service_Type__c;
                strServiceTypeException= transactionSettings.ICS_WR_Exception_Service_Type__c;
            }
            if(strServiceTypeException!=null){
                lstServiceTypeException = strServiceTypeException.split(';');
            }
            if(strServicesType!=null)
                lstServiceType = strServicesType.split(';');
            System.debug('*** list of ServiceTypeException===='+lstServiceTypeException);
       }
    try{
    
            lstglobalProductwrapper = new List<ProductWrapper>();   //This is the final wrapper to be returned back
            System.debug('inputVal-->'+inputVal);
            System.debug('inputFPO-->'+inputFPO);
            lstMMStock = new List<ICS_WR_MM_Stocking__c>();
            String strProcessorType = Label.ICS_WR_Processor_Product_Type;
            List<String> lstProcessorType  = strProcessorType.split(';');
            String strNonProcessorType = Label.ICS_WR_Non_Processor_Product_Type;
            List<String> lstNonProcessorType  = strNonProcessorType.split(';');
               
            
            /* Description : AGENT SIDE : If Product type is processor & FPO is entered*/  
            /*if(productType==PRODUCT_TYPE_PROCESSOR && portalType== Label.ICS_WR_Agent && String.isBlank(inputFPO)){
                lstMMStock=[SELECT Id,ICS_WR_Stocking__c,ICS_WR_Stocking__r.ICS_WR_Category_ID__c,ICS_WR_Stocking__r.Name,MMID__c,MMID__r.Name,MMID__r.ICS_WR_Product__c,MMID__r.ICS_WR_Product__r.Name,
                                        MMID__r.ICS_WR_Product__r.VPH_Nav__c,MMID__r.ICS_WR_Product__r.ICS_WR_Returnable_Over_Web__c,MMID__r.ICS_WR_Product__r.Support_Life_Cycle_Status__c,MMID__r.ICS_WR_Product__r.EPM_ID__c,
                                        ICS_WR_Stocking__r.ICS_WR_Description__c FROM ICS_WR_MM_Stocking__c where ICS_WR_Stocking__c IN
                                        (SELECT id from ICS_WR_Stocking__c where (ICS_WR_Category_ID__c IN :lstProcessorType) AND ((Name  LIKE :searchText) OR (ICS_WR_AA_Number__c  LIKE :searchText) OR (ICS_WR_PBA_Number__c LIKE :searchText) 
                                        OR (ICS_WR_TA_Number__c LIKE :searchText))) AND MMID__r.ICS_WR_Product__r.IsActive=true And MMID__r.ICS_WR_Product__r.VPH__c=true AND ICS_WR_Stocking__r.ICS_WR_Active__c=true LIMIT 500];     
                //If we not found any record then we have to search the product record based on EPM long Name/Product Name
                if(lstMMStock.size()==0){
                    searchText = inputVal.replaceAll(' ', '%');
                    searchText = searchText.replaceAll('\\*', '%');
                    searchText = '%'+searchText+'%';
                    System.debug('===searchText==='+searchText);
                    lstMMStock=[SELECT Id,ICS_WR_Stocking__c,ICS_WR_Stocking__r.ICS_WR_Category_ID__c,ICS_WR_Stocking__r.Name,MMID__c,MMID__r.Name,MMID__r.ICS_WR_Product__c,MMID__r.ICS_WR_Product__r.Name,
                                            MMID__r.ICS_WR_Product__r.VPH_Nav__c,MMID__r.ICS_WR_Product__r.ICS_WR_Returnable_Over_Web__c,MMID__r.ICS_WR_Product__r.Support_Life_Cycle_Status__c,MMID__r.ICS_WR_Product__r.EPM_ID__c,
                                            ICS_WR_Stocking__r.ICS_WR_Description__c FROM ICS_WR_MM_Stocking__c 
                                            WHERE MMID__r.ICS_WR_Product__r.Name LIKE :searchText AND (ICS_WR_Stocking__r.ICS_WR_Category_ID__c IN :lstProcessorType) AND MMID__r.ICS_WR_Product__r.IsActive=true AND
                                            MMID__r.ICS_WR_Product__r.VPH__c=true  AND ICS_WR_Stocking__r.ICS_WR_Active__c=true LIMIT 500];
                    
                }
            }*/
            /* Description : AGENT SIDE If Product type is Non-Processor then it will search the product record baded on strocking id,aa number,pba number,ta number*/
            /*else if(productType==PRODUCT_TYPE_NON_PROCESSOR && portalType == Label.ICS_WR_Agent){
                 lstMMStock=[SELECT Id,ICS_WR_Stocking__c,ICS_WR_Stocking__r.ICS_WR_Category_ID__c,ICS_WR_Stocking__r.Name,MMID__c,MMID__r.Name,MMID__r.ICS_WR_Product__c,MMID__r.ICS_WR_Product__r.Name,MMID__r.ICS_WR_Product__r.VPH_Nav__c,MMID__r.ICS_WR_Product__r.Support_Life_Cycle_Status__c,MMID__r.ICS_WR_Product__r.EPM_ID__c,MMID__r.ICS_WR_Product__r.ICS_WR_Returnable_Over_Web__c,ICS_WR_Stocking__r.ICS_WR_Description__c FROM ICS_WR_MM_Stocking__c where ICS_WR_Stocking__c in 
                            (SELECT id from ICS_WR_Stocking__c where (ICS_WR_Category_ID__c=:lstNonProcessorType) AND 
                             ((ICS_WR_AA_Number__c  LIKE :searchText)OR(ICS_WR_PBA_Number__c LIKE :searchText)OR(Name  LIKE :searchText)OR(ICS_WR_TA_Number__c LIKE :searchText))) AND MMID__r.ICS_WR_Product__r.IsActive=true AND MMID__r.ICS_WR_Product__r.VPH__c=true AND ICS_WR_Stocking__r.ICS_WR_Active__c=true LIMIT 500];
                //If we not found any record then we have to search the product record based on EPM long Name/Product Name
                if(lstMMStock.size()==0){
                    searchText = inputVal.replaceAll(' ', '%');
                    searchText = searchText.replaceAll('\\*', '%');
                    searchText = '%'+searchText+'%';
                    System.debug('===searchText==='+searchText);
                    lstMMStock=[SELECT Id,ICS_WR_Stocking__c,ICS_WR_Stocking__r.ICS_WR_Category_ID__c,ICS_WR_Stocking__r.Name,MMID__c,MMID__r.Name,MMID__r.ICS_WR_Product__c,MMID__r.ICS_WR_Product__r.Name,
                                            MMID__r.ICS_WR_Product__r.VPH_Nav__c,MMID__r.ICS_WR_Product__r.Support_Life_Cycle_Status__c,MMID__r.ICS_WR_Product__r.EPM_ID__c,MMID__r.ICS_WR_Product__r.ICS_WR_Returnable_Over_Web__c,
                                            ICS_WR_Stocking__r.ICS_WR_Description__c FROM ICS_WR_MM_Stocking__c 
                                            WHERE MMID__r.ICS_WR_Product__r.Name LIKE :searchText AND (ICS_WR_Stocking__r.ICS_WR_Category_ID__c=:lstNonProcessorType)   AND MMID__r.ICS_WR_Product__r.IsActive=true And
                                            MMID__r.ICS_WR_Product__r.VPH__c=true AND ICS_WR_Stocking__r.ICS_WR_Active__c=true LIMIT 500];
                }
            }*/
             //This Conditon is checking weather we get the product record in salesforce or not    
            /*if(lstMMStock!=null && lstMMStock.size()>0){
                //flag=false;
                for(ICS_WR_MM_Stocking__c mmStk:lstMMStock)
                {
                    Boolean blnSupportType = false;
                    Boolean blnServiceTypeException = false;
                    lststocking.add(mmStk.ICS_WR_Stocking__r.Name);
                    prdWrapperList.add(new ProductWrapper(mmStk,productType,'','','',blnSupportType,false,'',blnServiceTypeException,false,'',''));
                    System.debug('product type'+productType);
                    System.debug('prdWrapperList='+prdWrapperList);
                }
            } **/
            // if we won't get the product record in salesforce system then we call the external system
            //else {
            //flag=true;
            mapQryParameter=new Map<String,String>();
            Map<String,List<String>> mapStockingIdATPO = new Map<String,List<String>>();
            mapStockingIdFPO = new Map<String,String>();
            
            if(productType==PRODUCT_TYPE_PROCESSOR){
                Set<String> lstMMId = new Set<String>();
                Set<String> lstStockingId = new Set<String>();
                //US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
                //TCAResponse = new ICS_WR_ProcessorInfo_Util.MMIDListResult();
                TCAResponse = new ICS_WR_ProcessorInfo_Util_LEX.MMIDListResult();
                System.debug('TCAResponse=instance==>'+TCAResponse.Error);
               
               //Case 1: Here we pass the customer input as ATPO and calling the TCA system
                if(portalType == Label.ICS_WR_Agent || ((portalType == 'Support' || portalType == Label.ICS_WR_Customer) && !String.IsBlank(inputFPO))){
                    //Based on given input fpo number length with combination of 4/5 characters paasing inputFPO number to mapQryParameter
                    Integer inputStringLength = inputVal.length();
                    if((inputStringLength ==4 || inputStringLength ==5) && inputFPO!= null && inputFPO.length() >= 8 && inputFPO.length() <= 11 ) {
                        System.debug('*** Inside Case1==='+inputFPO + inputVal+ portalType);
                        mapQryParameter.put('fpo',inputFPO.toUpperCase().trim());
                        mapQryParameter.put('atpo',inputVal.toUpperCase().trim());
                        //US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
                        //TCAResponse = ICS_WR_ProcessorInfo_Util.get_MMIDList(mapQryParameter);
                        TCAResponse = ICS_WR_ProcessorInfo_Util_LEX.get_MMIDList(mapQryParameter);
                        System.debug('TCAResponse='+TCAResponse);
                        //System.debug('ICS_WR_ProcessorInfo_Util.isError='+ICS_WR_ProcessorInfo_Util.isError);
                        System.debug('ICS_WR_ProcessorInfo_Util_LEX.isError='+ICS_WR_ProcessorInfo_Util_LEX.isError);
                        System.debug('after calling 4/5 TCA inputVal = ' + inputVal);
                        if(portalType == 'Support' || portalType == Label.ICS_WR_Customer){
                            FPOBufferCX = '';
                        }
                    }
                //Case 2: AGENT ONLY :Call TCAwith FPO only if the input string length is between 8 and 11
                 /*   else if (inputStringLength >= 8 && inputStringLength <= 11 && (portalType != Label.ICS_WR_Customer || portalType != 'Support')) {
                    System.debug('*** Inside Case2===' +portalType + inputFPO + inputVal);
                        mapQryParameter.put('fpo',inputVal.toUpperCase().trim());
                        TCAResponse = ICS_WR_ProcessorInfo_Util.get_MMIDList(mapQryParameter);
                        System.debug('TCAResponse='+TCAResponse);
                        System.debug('TCAResponse.isError='+TCAResponse);
                    }*/
                    
                  //Case 3: Call TCA with ATPO only if the input string length is between than 11 and 14
                    else if (inputStringLength >=11 && inputStringLength <= 14 ) {
                    System.debug('*** Inside Case3===' +portalType + inputFPO + inputVal);
                        mapQryParameter=new Map<String,String>();
                        //Perform the product search with ATPO number
                         if(portalType == Label.ICS_WR_Customer ||  portalType == 'Support'){
                          mapQryParameter.put('fpo',inputFPO);
                         }else{
                          mapQryParameter.put('fpo','');
                         }
                        mapQryParameter.put('atpo',inputVal.toUpperCase().trim());
                        inputATPOVal=inputVal;
                        inputVal = '';
                        if(portalType == Label.ICS_WR_Customer ||  portalType == 'Support'){
                            FPOBufferCX = inputFPO;
                            inputFPO = '';
                        }
                        //Start--US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
                        //TCAResponse = ICS_WR_ProcessorInfo_Util.get_MMIDList(mapQryParameter);
                        TCAResponse = ICS_WR_ProcessorInfo_Util_LEX.get_MMIDList(mapQryParameter);
                        System.debug('***TCAResponse='+TCAResponse);
                        //System.debug('***ICS_WR_ProcessorInfo_Util.isError='+ICS_WR_ProcessorInfo_Util.isError);
                        System.debug('***ICS_WR_ProcessorInfo_Util_LEX.isError='+ICS_WR_ProcessorInfo_Util_LEX.isError);
                        System.debug('***after calling Case3 inputFPO + inputVal +FPOBufferCX + inputATPOVal == ' + inputFPO + inputVal +FPOBufferCX +inputATPOVal);
                    }
                    else {
                        if(portalType == Label.ICS_WR_Customer ||  portalType == 'Support'){
                         FPOBufferCX = inputFPO;
                         inputFPO = '';                             
                        }
                        //ICS_WR_ProcessorInfo_Util.isError = false;
                        ICS_WR_ProcessorInfo_Util_LEX.isError = false;
                        //End--US789395--Popcornapps--5/10/2020
                        TCAResponse = null;
                        System.debug('value in pro');
                    }
                     if(TCAResponse!=null && TCAResponse.Error == 'false'){
                        System.debug('value in pro1');
                        if(TCAResponse!=null && TCAResponse.MaterialMasterList !=null){
                             //Here we are checking if the BoxTrayIndicator is not null and it's try we are making boolean as true to display the message.
                            if(!String.isEmpty(TCAResponse.BoxTrayIndicator) && TCAResponse.BoxTrayIndicator == 'Tray'){
                                blnTryMessage = true;
                            }
                              System.debug('BoxTrayIndicator===>'+TCAResponse.BoxTrayIndicator);
                              System.debug('blnTryMessage===>'+blnTryMessage);
                           //US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
                           //for(ICS_WR_ProcessorInfo_Util.MaterialMasterList mmId:TCAResponse.MaterialMasterList){
                            for(ICS_WR_ProcessorInfo_Util_LEX.MaterialMasterList mmId:TCAResponse.MaterialMasterList){
                               System.debug('======FOR LOOP mmId'+mmId);
                                lstMMId.add(mmId.Material_Master_Num);
                                lstStockingId.add(mmId.Level_4_Prod);
                               
                               System.debug('***mapStockingIdATPO Before====>'+mapStockingIdATPO);
                               System.debug('*** mapStockingIdFPO Before====>'+mapStockingIdFPO);
                               System.debug('***mmId.ATPO===>'+mmId.ATPO);
                            
                               //Adding Stocking number and ATPO numbers in to map to get ATPO in prdWrapperList
                               if(!String.isBlank(mmId.ATPO)){
                                    if(mapStockingIdATPO.containsKey(mmId.Level_4_Prod)){
                                       mapStockingIdATPO.get(mmId.Level_4_Prod).add(mmId.ATPO);
                                     }else{
                                       mapStockingIdATPO.put(mmId.Level_4_Prod, new List<String>{mmId.ATPO});
                                     }
                                }
                                //Here Preparing the map for Retrieve FPO when completing a search for ATPO.
                                if(!String.isBlank(mmId.FPO) && !String.isEmpty(inputATPOVal)){
                                  mapStockingIdFPO.put(mmId.Level_4_Prod,mmId.FPO);  
                                }
                            }
                            System.debug('*** mapStockingIdATPO After===>'+mapStockingIdATPO);
                            System.debug('*** mapStockingIdFPO After====>'+mapStockingIdFPO);
                        }
                    }  
                }
                else if(portalType == Label.ICS_WR_Customer ||  portalType == 'Support'){
                    System.debug('==from portal====');
                    System.debug('***inputVal='+inputVal);
                    System.debug('***inputATPOVal='+inputATPOVal);
                    FPOBufferCX = '';
                    mapQryParameter.put('fpo',inputVal.toUpperCase().trim());
                    mapQryParameter.put('atpo',inputATPOVal.toUpperCase().trim());
                    //Start--US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
                    //TCAResponse = ICS_WR_ProcessorInfo_Util.get_MMIDList(mapQryParameter);
                    TCAResponse = ICS_WR_ProcessorInfo_Util_LEX.get_MMIDList(mapQryParameter);
                    if(TCAResponse != null && TCAResponse.Error == 'false'){
                      if(TCAResponse.MaterialMasterList !=null){
                              System.debug('value in pro1');
                           //for(ICS_WR_ProcessorInfo_Util.MaterialMasterList mmId:TCAResponse.MaterialMasterList){
                           for(ICS_WR_ProcessorInfo_Util_LEX.MaterialMasterList mmId:TCAResponse.MaterialMasterList){
                           //End--US789395--Popcornapps
                               lstMMId.add(mmId.Material_Master_Num);
                                lstStockingId.add(mmId.Level_4_Prod); 
                            }
                        } 
                    }
                }
                if(lstMMId!=null && lstMMId.size()>0 && lstStockingId!=null && lstStockingId.size()>0){
                    addMMToProductWrapper(lstMMId, lstStockingId, lstProcessorType,mapStockingIdATPO, productType, portalType);
                    System.debug('lstMMId---Size--->'+lstMMId.size());
                    System.debug('lstStockingId--->'+lstStockingId.size());
                }
                System.debug('***prdWrapperList after Processor search==='+prdWrapperList.size() + prdWrapperList);
            }
            //Calling SNtrax for Boards, MiniPC, Other non-processors
            else if(productType==PRODUCT_TYPE_NON_PROCESSOR){
                mapQryParameter=new Map<String,String>();
                mapQryParameter.put('serialNo',inputVal);
                response =ICS_WR_ConsumingSNtraxDATA.get_SNtrax_data(mapQryParameter);
                processSNTraxResponse(response, productType);
            
            //Calling SNtrax for SSDs (Memory) 
            //Added logic to call normal SNtrax in create mode - US109060--Tchauhan---06292018
            }else if(productType=='SSD'){
                mapQryParameter=new Map<String,String>();
                if(mode=='check'){
                    mapQryParameter.put('sno',inputVal);
                    SSDresponse =ICS_WR_ConsumingSNtrax_SSD.get_SNtrax_Validate_SSD(mapQryParameter);
                    System.debug('Mode check');
                    processSSDResponse(SSDresponse, productType);
                    
                }else if(mode=='create'){
                    mapQryParameter.put('serialNo',inputVal);
                    response =ICS_WR_ConsumingSNtraxDATA.get_SNtrax_data(mapQryParameter);
                    System.debug('Mode Create');
                    processSNTraxResponse(response, productType);
                }
               
            }
            System.debug('***prdWrapperList after Non-processor search==='+prdWrapperList.size() + prdWrapperList); 
       
            //Description: Below snippet is to handle error scenarios
            System.debug('Prod Size'+prdWrapperList.size());
            if(prdWrapperList.size()==0 || prdWrapperList==null)
            {    
               if(productType==PRODUCT_TYPE_PROCESSOR){
                   //Added if condition for customers, executes if ATPO search don't have any results and do search with FPO again
                   if((portalType == Label.ICS_WR_Customer || portalType=='Support')&& !String.IsBlank(FPOBufferCX) && mode=='check' && !blnTryMessage){
                        inputATPOVal = '';
                        inputVal = FPOBufferCX;
                        inputFPO = '';
                        List<ProductWrapper>  finalproductWrapper = getSearchedProducts ( productType, warrantyType, depotId, mode, portalType);
                        return finalproductWrapper;
                   }
                    else if(TCAResponse != null && TCAResponse.Error == 'true'){
                       //Label.ICS_WR_No_Result_Found_as_the_PMFT_System_is_down;
                       allHardStopMessages.add(HDSTP_1001);
                   }
                    //blnTryMessage equal to true then display the try message other wise else condition message.
                    else if(blnTryMessage == true){
                       //Label.ICS_WR_Tray_Processor_Message; 
                       allHardStopMessages.add(HDSTP_1004);
                    }
                    else {
                        //Label.ICS_WR_No_Result_Found;
                        allHardStopMessages.add(HDSTP_1002);
                    }
                 
                }
                //US109060--Tchauhan---06292018---Corrected error scenarios
                else if(productType==PRODUCT_TYPE_NON_PROCESSOR && ICS_WR_ConsumingSNtraxDATA.isError){
                        //Label.ICS_WR_No_Result_Found_as_the_Sntrax_System_is_down;
                        allHardStopMessages.add(HDSTP_1001);
                }
                else if(mode=='create' && productType=='SSD' && ICS_WR_ConsumingSNtraxDATA.isError){
                        allHardStopMessages.add(HDSTP_1001);
                }
                else if(mode=='check' && productType=='SSD' && ICS_WR_ConsumingSNtrax_SSD.isError){
                        //Label.ICS_WR_No_Result_Found_as_the_Sntrax_System_is_down;
                        allHardStopMessages.add(HDSTP_1001);
                }
                else if(blnsyntraxError){
                        //Label.ICS_WR_No_Results_found_in_Sntrax_System;
                        allHardStopMessages.add(HDSTP_1002);
                }
                else {
                        //Label.ICS_WR_No_Result_Found;
                        allHardStopMessages.add(HDSTP_1002);
                    }
            }else{
                List<ICS_WR_Depot_Stock__c> lstDepotStock;
                System.debug('depotId='+depotId);
                if(!String.isEmpty(depotId)){
                    System.debug('LINE 641');
                    lstDepotStock = [SELECT Id, ICS_WR_Locked__c, ICS_WR_Stocking__c, ICS_WR_Stocking__r.Name, ICS_WR_Service_Type__c, ICS_WR_Depot__c FROM ICS_WR_Depot_Stock__c WHERE ICS_WR_Stocking__r.Name IN:lststocking AND ICS_WR_Depot__c =:depotId];
                    for(ICS_WR_Depot_Stock__c dep :lstDepotStock){
                        System.debug('LSTDEPOTDEBUG '+ dep.ICS_WR_Locked__c);
                    }
                    System.debug('LSTDEPOTSIZE '+lstDepotStock.size());
                    System.debug('LSTSTOCKING '+lststocking);
                    System.debug('DEPOTIDHAI '+depotId);
                }
                else {
                    List<ICS_WR_Depot_Stock__c> depotForAnonymousUser = [Select id,ICS_WR_Depot__c FROM ICS_WR_Depot_Stock__c WHERE ICS_WR_Stocking__r.Name = :lststocking[0] LIMIT 1]; 
                    if (depotForAnonymousUser != null && depotForAnonymousUser.size() > 0) {
                        System.debug('LINE 647');
                        lstDepotStock = [SELECT Id, ICS_WR_Locked__c, ICS_WR_Stocking__c, ICS_WR_Stocking__r.Name, ICS_WR_Service_Type__c, ICS_WR_Depot__c FROM ICS_WR_Depot_Stock__c WHERE ICS_WR_Stocking__r.Name IN:lststocking AND ICS_WR_Depot__c =:depotForAnonymousUser[0].ICS_WR_Depot__c];
                    }
                }
                for(ICS_WR_Depot_Stock__c depot : lstDepotStock){
                    System.debug('Depot ID IS -- '+ depot.Id);
                }
                if(lstDepotStock!=null && lstDepotStock.size()==0 && productType!='SSD'){
                    prdWrapperList.clear();
                    //Label.ICS_WR_No_Result_Found;
                    allHardStopMessages.add(HDSTP_1002);
                }
                System.debug(lstDepotStock);
                List<ProductWrapper> lstTempProduct = new List<ProductWrapper>();
                Set<String> setProduct = new Set<String>();
                System.debug('before for loop - prdWrapperList = ' + prdWrapperList);
                System.debug('before for loop - lstDepotStock = ' + lstDepotStock);
                for(ProductWrapper objProduct:prdWrapperList){ 
                    for(ICS_WR_Depot_Stock__c objDepotStock:lstDepotStock){
                        if(objProduct.mmRecord.ICS_WR_Stocking__r.Name==objDepotStock.ICS_WR_Stocking__r.Name){
                            //Here we are determining the service type from depot stock object
                            Boolean blnSupportType = false;
                            Boolean blnServiceTypeException = false;
                            
                            //Here we are matching specific RMA type related service type == stocking record related service type
                            if(transactionSettings!=null && lstServiceType!=null && lstServiceType.size()>0) {
                                for(String strServiceType:lstServiceType){
                                    if(strServiceType==objDepotStock.ICS_WR_Service_Type__c)
                                        blnSupportType = true;
                                }
                            }
                            //Here we are matching specific RMA type related service type exception == stocking record related service type
                            if(transactionSettings!=null && lstServiceTypeException!=null && lstServiceTypeException.size()>0) {
                                for(String serviceTypeException:lstServiceTypeException){
                                    if(serviceTypeException==objDepotStock.ICS_WR_Service_Type__c)
                                        blnServiceTypeException = true;
                                } 
                            }
                            objProduct.blnServiceTypeException = blnServiceTypeException;
                            objProduct.blnSupportType = blnSupportType;
                            objProduct.strServiceType = objDepotStock.ICS_WR_Service_Type__c;
                           // objProduct.isLocked = objDepotStock.ICS_WR_Locked__c;
                           // System.debug('Check Boolean'+ objDepotStock.ICS_WR_Locked__c);
                           // System.debug(objDepotStock);
                            //Setting maplocked map to check for hardstop scenario from handler
                            if(objDepotStock.ICS_WR_Locked__c){
                                mapLocked.put(String.valueOf(objProduct.mmRecord.MMID__r.ICS_WR_Product__c+'_'+objProduct.mmRecord.ICS_WR_Stocking__r.Name),'true');
                            }else{
                                mapLocked.put(String.valueOf(objProduct.mmRecord.MMID__r.ICS_WR_Product__c+'_'+objProduct.mmRecord.ICS_WR_Stocking__r.Name),'false');
                            }
                            if(inputVal != null && inputVal.toUpperCase()==Label.ICS_WR_ARSLABEL){
                                if(strTransactionType==Label.ICS_WR_Fulfillment || strTransactionType==Label.ICS_WR_Fulfillment_Next_Business_Day || strTransactionType==Label.ICS_WR_Receive_Only || strTransactionType==Label.ICS_WR_Refund_Only){
                                    objProduct.blnSupportType = true;
                                }  
                            }
                            //Below snippet removes the duplicate products (same name & ids) but belonging to unique MMIDs
                            if(!(portalType == Label.ICS_WR_Customer && portalType == 'Support' && objDepotStock.ICS_WR_Locked__c)){
                                if (!setProduct.contains(objProduct.mmRecord.MMID__r.ICS_WR_Product__c+'_'+objProduct.mmRecord.ICS_WR_Stocking__r.Name) && blnATPORender == false){
                                    setProduct.add(objProduct.mmRecord.MMID__r.ICS_WR_Product__c+'_'+objProduct.mmRecord.ICS_WR_Stocking__r.Name);
                                    lstTempProduct.add(objProduct);
                                }else if(blnATPORender == true){
                                    lstTempProduct.add(objProduct);
                                }
                            }
                        }
                    }
                    //Setting mapLocked for hardstop scenario
                    if(!mapLocked.containskey(objProduct.mmRecord.MMID__r.ICS_WR_Product__c+'_'+objProduct.mmRecord.ICS_WR_Stocking__r.Name)){
                        mapLocked.put(String.valueOf(objProduct.mmRecord.MMID__r.ICS_WR_Product__c+'_'+objProduct.mmRecord.ICS_WR_Stocking__r.Name),'false');
                    }
                }
                if(lstTempProduct!=null && lstTempProduct.size()>0){
                    prdWrapperList.clear();
                    prdWrapperList.addAll(lstTempProduct);
                    prdWrapperList.sort();
                }
                lstglobalProductwrapper.addAll(prdWrapperList);
            }
            //inputVal = inputString;
            //Converting Set of hardStopMessage to String
            for(String hardstops : allHardStopMessages){
                errorMessages += hardstops + ' ';
            }
            if(errorMessages.length() >0){
                errorMessages = errorMessages.substring(0, errorMessages.length()-1);
            }
        }
        Catch(Exception e)
        {
            String strInvocationID ='ICS_WR_Product_Search_Controller'+UserInfo.getUserId() + '_' + system.now().formatGmt('yyyyMMddkkmmssSS')
                + '_' + String.valueOf((Math.random() * 10).round()).leftpad(3,'0');
            Core_Log_Entry.logEntryWithException(strInvocationID,System.Label.ICS_WR_logging_Scope,'ICS_Support_Warranty_Util__searchProduct','Error',e.getMessage(),'',e);
        }
        
        return lstglobalProductwrapper; 
}

    public static List<String> trimList(List<String> inputList) {
        List<String> outputList = new List<String>();
        if (inputList != null && inputList.size() > 0) {
            for (String str : inputList) {
                outputList.add(str.trim());
            }
        }
        return outputList;
    }
    public static Set<String> trimSet(Set<String> inputList) {
        Set<String> outputList = new Set<String>();
        if (inputList != null && inputList.size() > 0) {
            for (String str : inputList) {
                outputList.add(str.trim());
            }
        }
        return outputList;
    }
    
/***********************************************************************
    * @author Intel
    * @date 04/09/2018
    * @description This method is used to prepare prdWrapperList with the searched results
    * @param list if mmids, stockingids, processorType, map of Stockingid-atpo, productType
    * @return void
************************************************************************/
    public static void addMMToProductWrapper(Set<String> lstMMId, Set<String> lstStockingId, List<String> lstProcessorType, Map<String,List<String>> mapStockingIdATPO, String productType, String portalType) {
        if(lstMMId!=null && lstMMId.size()>0 && lstStockingId!=null && lstStockingId.size()>0){
            lstMMId = trimSet(lstMMId);
            lstStockingId = trimSet(lstStockingId);
            
            //Here we get are getting the MMId and stocking Id form PMFT response and based on that we are searching the product in salesforce system    
            List<ICS_WR_MM_Stocking__c > mmstockinglst =  [SELECT id,ICS_WR_Stocking__c,ICS_WR_Stocking__r.Name,MMID__r.Name,MMID__r.ICS_WR_Product__c,MMID__r.ICS_WR_Product__r.Name,MMID__r.ICS_WR_Product__r.EPM_ID__c,
                                                           MMID__r.ICS_WR_Product__r.VPH_Nav__c,MMID__r.ICS_WR_Product__r.ICS_WR_Returnable_Over_Web__c,ICS_WR_Stocking__r.ICS_WR_Description__c,ICS_WR_Stocking__r.ICS_WR_Category_ID__c,
                                                           MMID__r.ICS_WR_Product__r.Support_Life_Cycle_Status__c FROM ICS_WR_MM_Stocking__c 
                                                           WHERE MMID__r.Name IN:lstMMId AND ICS_WR_Stocking__r.Name IN:lstStockingId AND (ICS_WR_Stocking__r.ICS_WR_Category_ID__c IN:lstProcessorType) AND MMID__r.ICS_WR_Product__r.IsActive=true And MMID__r.ICS_WR_Product__r.VPH__c=true AND ICS_WR_Stocking__r.ICS_WR_Active__c=true LIMIT 500];
            
            if(mmstockinglst == null || mmstockinglst.size() == 0) {
                mmstockinglst =  [SELECT id,ICS_WR_Stocking__c,ICS_WR_Stocking__r.Name,MMID__r.Name,MMID__r.ICS_WR_Product__c,MMID__r.ICS_WR_Product__r.Name,MMID__r.ICS_WR_Product__r.EPM_ID__c,MMID__r.ICS_WR_Product__r.VPH_Nav__c,
                                                MMID__r.ICS_WR_Product__r.ICS_WR_Returnable_Over_Web__c,ICS_WR_Stocking__r.ICS_WR_Description__c,ICS_WR_Stocking__r.ICS_WR_Category_ID__c,MMID__r.ICS_WR_Product__r.Support_Life_Cycle_Status__c 
                                                FROM ICS_WR_MM_Stocking__c 
                                                WHERE ICS_WR_Stocking__r.Name IN:lstStockingId AND (ICS_WR_Stocking__r.ICS_WR_Category_ID__c IN :lstProcessorType) AND MMID__r.ICS_WR_Product__r.IsActive=true And MMID__r.ICS_WR_Product__r.VPH__c=true AND ICS_WR_Stocking__r.ICS_WR_Active__c=true LIMIT 500];
            }
            
            if(mmstockinglst.size()>0)
            {
                for(ICS_WR_MM_Stocking__c mmStk:mmstockinglst){
                    Boolean blnSupportType = false;
                    Boolean blnServiceTypeException=false;
                    lststocking.add(mmStk.ICS_WR_Stocking__r.Name);
                    if(TCAResponse!=null){
                       //Here Retrieve FPO when completing a search for ATPO
                       if(!String.isEmpty(inputATPOVal) && !mapStockingIdFPO.isEmpty() && mapStockingIdFPO.ContainsKey(mmStk.ICS_WR_Stocking__r.Name) &&!String.isEmpty(mapStockingIdFPO.get(mmStk.ICS_WR_Stocking__r.Name))){
                            inputVal = mapStockingIdFPO.get(mmStk.ICS_WR_Stocking__r.Name);
                       }
                       //This condition executed when agent search full FPO/ATPO number
                       if(String.isEmpty(inputFPO)){
                          prdWrapperList.add(New ProductWrapper(mmStk,productType,inputVal,inputATPOVal,blnSupportType,'','',blnServiceTypeException,'',false));  
                          blnATPORender = false;
                       }  
                       //This condition executed when ever agent search 4/5 char and fpo number(If unit trace data not found)
                       else if(portalType != Label.ICS_WR_Agent && !String.isEmpty(inputFPO) && mapStockingIdATPO.isEmpty()){
                           prdWrapperList.add(New ProductWrapper(mmStk,productType,inputFPO,inputATPOVal,blnSupportType,'','',blnServiceTypeException,'',false));  
                           blnATPORender = false;
                       }
                       //Agent only - This condition executed when ever agent search 4/5 char and fpo number(If unit trace data not found)
                       /*else if(portalType == Label.ICS_WR_Agent && !String.isEmpty(inputFPO) && mapStockingIdATPO.isEmpty()){
                           System.debug('====4/5 search unit report is not found');
                           prdWrapperList.add(New ProductWrapper(mmStk,productType,inputFPO,inputATPOVal,'',blnSupportType,false,'',blnServiceTypeException,TCAResponse.ContainsProtectionPlan=='true','',''));  
                           blnATPORender = false;
                           errorMessages = Label.ICS_WR_4_5_Char_Result_Not_Found_Message; 
                       
                       }**/
                       else if(mapStockingIdATPO != null && mapStockingIdATPO.ContainsKey(mmStk.ICS_WR_Stocking__r.Name) && mapStockingIdATPO.get(mmStk.ICS_WR_Stocking__r.Name)!= null && !mapStockingIdATPO.get(mmStk.ICS_WR_Stocking__r.Name).isEmpty())
                       {
                          for(String getMultipleATPOs:mapStockingIdATPO.get(mmStk.ICS_WR_Stocking__r.Name)){
                            prdWrapperList.add(New ProductWrapper(mmStk,productType,inputFPO,getMultipleATPOs,blnSupportType,'','',blnServiceTypeException,'',false)); 
                           }
                          blnATPORender = true;
                       }
                       }
                    
                    if(!String.isEmpty(inputATPOVal))
                        inputVal=inputATPOVal;
                    
                }
            }
            /*System.debug('Out side ContainsProtectionPlan==>'+TCAResponse.ContainsProtectionPlan);
            if(portalType == Label.ICS_WR_Agent && TCAResponse != null && TCAResponse.ContainsProtectionPlan=='true' && prdWrapperList != null && !prdWrapperList.isEmpty()){
              System.debug('In side ContainsProtectionPlan==>'+TCAResponse.ContainsProtectionPlan);
               errorMessages = Label.ICS_WR_PAC_code_is_associated_to_that_search_result;
            }*/
            
        }
    }
/***********************************************************************
    * @author Intel
    * @date 04/11/2018
    * @description This method is used to process SNtrax response
    * @param sntraxResponse
    * @return void
************************************************************************/
  public static void processSNTraxResponse(ICS_WR_ConsumingSNtraxDATA.SerialNoResult sntraxResponse, String productType) {    
        String strNonProcessorType = Label.ICS_WR_Non_Processor_Product_Type;
        List<String> lstNonProcessorType  = strNonProcessorType.split(';');
        List<String> lstPartNumber = new List<String>();
        Set<String> setPartNumber = new Set<String>();
        if(sntraxResponse!=null)
        {
            if(sntraxResponse.ProcessCode=='1'){
                blnsyntraxError=true;
             }
            else if(sntraxResponse.ProcessCode=='0'){
                lstPartNumber.addAll(sntraxResponse.PartNumberList);
                setPartNumber.addAll(sntraxResponse.PartNumberList);
            } 
        }
        if(!String.isEmpty(inputPartNumVal)){
            lstPartNumber.add(inputPartNumVal);
            if(setPartNumber!=null && setPartNumber.size()>0)
                setPartNumber.add(inputPartNumVal);
        }
        if(lstPartNumber!=null && lstPartNumber.size()>0){
            lstPartNumber = trimList(lstPartNumber);
            List<ICS_WR_MM_Stocking__c > mmstockinglst;
            //Here we get are getting the stocking Id form Syntrax response and based on that we are searching the product in salesforce system   
            mmstockinglst =   [SELECT Id,ICS_WR_Stocking__c,ICS_WR_Stocking__r.ICS_WR_Category_ID__c,ICS_WR_Stocking__r.Name,MMID__c,MMID__r.Name,MMID__r.ICS_WR_Product__c,MMID__r.ICS_WR_Product__r.Name,MMID__r.ICS_WR_Product__r.EPM_ID__c,MMID__r.ICS_WR_Product__r.VPH_Nav__c,MMID__r.ICS_WR_Product__r.Support_Life_Cycle_Status__c,MMID__r.ICS_WR_Product__r.ICS_WR_Returnable_Over_Web__c,ICS_WR_Stocking__r.ICS_WR_Description__c FROM ICS_WR_MM_Stocking__c 
                                                WHERE ICS_WR_Stocking__r.Name IN:lstPartNumber AND (ICS_WR_Stocking__r.ICS_WR_Category_ID__c=:lstNonProcessorType)         
                                                AND MMID__r.ICS_WR_Product__r.IsActive=true And MMID__r.ICS_WR_Product__r.VPH__c=true AND ICS_WR_Stocking__r.ICS_WR_Active__c=true LIMIT 500]; 
            System.debug('mmstockinglstsize = ' + mmstockinglst.size()); 
            
            if(mmstockinglst!=null && mmstockinglst.size()>0)
            {
                for(ICS_WR_MM_Stocking__c mmStk:mmstockinglst){
                    Boolean blnSupportType = false;
                    Boolean blnServiceTypeException=false;
                    lststocking.add(mmStk.ICS_WR_Stocking__r.Name);
                    System.debug('MM NAME '+mmStk.ICS_WR_Stocking__r.Name);
                    prdWrapperList.add(New ProductWrapper(mmStk,productType,'',inputVal,blnSupportType,'','',blnServiceTypeException,'',false));  
                }
            }
            System.debug('LSTTOCK SIZE '+lststocking);
        }
    }
    
    public static void processSSDResponse(ICS_WR_ConsumingSNtrax_SSD.SSDResult SSDresponse, String productType){
        if(SSDresponse!=null) {
            List<ICS_WR_MM_Stocking__c > mmstockinglst;
            if(SSDresponse.FERT!= null || SSDresponse.FERT!=''){
                String SSD_MMID = SSDresponse.FERT.deleteWhitespace();
                System.debug('***SSD response'+SSD_MMID);
                String SSDWarrantyExpire = SSDresponse.WarrantyExpire;
               //Ibase call logic to get expiry date
                List<ICS_WR_MMID_BU_Hierarchy__c> mmBuHierarchyRecord = [SELECT id,Name,ICS_WR_Operation_Business_Unit_Code__c FROM ICS_WR_MMID_BU_Hierarchy__c WHERE Name=:SSD_MMID limit 1];
                System.debug('***mmBuHierarchyRecord==>'+mmBuHierarchyRecord);
                if(mmBuHierarchyRecord!=null && mmBuHierarchyRecord.size()>0){
                    List<ICS_WR_Operation_Business_Unit__mdt> operationUnit = [SELECT id,DeveloperName,Label FROM ICS_WR_Operation_Business_Unit__mdt WHERE DeveloperName=:mmBuHierarchyRecord[0].ICS_WR_Operation_Business_Unit_Code__c];
                        //if it is matching then call ibase
                        if(operationUnit!=null && operationUnit.size()>0){
                            //US789395--Popcornapps--5/10/2020--Replacing classic controllers with lightning controllers as part of migration
                            //List<ICS_WR_ConsumingIbaseData.WarrantyInfoData> iBaseResponse = ICS_WR_Warranty_Util_Agent.ibaseCallMethod(inputVal);
                            List<ICS_WR_ConsumingIbaseData.WarrantyInfoData> iBaseResponse = ICS_WR_Warranty_Util_Agent_LEX.ibaseCallMethod(inputVal);
                            System.debug('===iBaseResponse ==='+iBaseResponse);
                            if(iBaseResponse!=null && iBaseResponse.size()>0 && iBaseResponse[0].WarrantyEnddate!=null ){
                                SSDWarrantyExpire = DateTime.newInstance((iBaseResponse[0].WarrantyEnddate).year(),(iBaseResponse[0].WarrantyEnddate).month(),(iBaseResponse[0].WarrantyEnddate).day()).format('MM/dd/YYYY');
                                System.debug('ssdExpiryDateInValues:'+SSDWarrantyExpire);
                            }
                        }
                }
                mmstockinglst =  [SELECT id,ICS_WR_Stocking__c,ICS_WR_Stocking__r.Name,MMID__r.Name,MMID__r.ICS_WR_Product__c,MMID__r.ICS_WR_Product__r.Name,MMID__r.ICS_WR_Product__r.Support_Life_Cycle_Status__c,MMID__r.ICS_WR_Product__r.EPM_ID__c,MMID__r.ICS_WR_Product__r.VPH_Nav__c,MMID__r.ICS_WR_Product__r.ICS_WR_Returnable_Over_Web__c,ICS_WR_Stocking__r.ICS_WR_Description__c,ICS_WR_Stocking__r.ICS_WR_Category_ID__c FROM ICS_WR_MM_Stocking__c 
                                  WHERE MMID__r.Name =:SSD_MMID AND MMID__r.ICS_WR_Product__r.IsActive=true And MMID__r.ICS_WR_Product__r.VPH__c=true AND ICS_WR_Stocking__r.ICS_WR_Active__c=true LIMIT 1];
                System.debug('mmstockinglst size'+mmstockinglst +'--'+mmstockinglst.size());
                if(mmstockinglst.size()>0)
                {
                    for(ICS_WR_MM_Stocking__c mmStk:mmstockinglst){
                        Boolean blnSupportType = false;
                        Boolean blnServiceTypeException=false;
                        lststocking.add(mmStk.ICS_WR_Stocking__r.Name);
                        prdWrapperList.add(New ProductWrapper(mmStk,productType,inputVal,inputATPOVal,blnSupportType,'','',blnServiceTypeException,SSDWarrantyExpire,false));  
                    }
                }
            }
        }
    }
    
//format the date according to userlocale and send in to Date.parse()
    public static DateTime getGMTFormattedDate(String inputDate) {
        System.debug('***in getGMTFormattedDate');
        System.debug('***inputDate: '+inputDate);
        DateTime dateInGMT=null;
        // Parse string to GMT dateTime format 
        if(!String.isBlank(inputDate)){
            if(inputDate.containsAny('/')){
            List<String> inputDateList = inputDate.split('/');
            Integer day = integer.valueOf(inputDateList[1]);
            Integer month = integer.valueOf(inputDateList[0]);
            Integer year = integer.valueOf(inputDateList[2]);
            dateInGMT = DateTime.newInstance(year,month,day); 
            }
        }
        
        System.debug('***returning finalString'+dateInGMT);
        return dateInGMT;
    }
    
    
 //This Wrapper class is for to send both product type and product details 
   public class ProductWrapper implements Comparable
    {
        public ICS_WR_MM_Stocking__c mmRecord{set;get;}  
        public String productType{set;get;}
        public String fpoNumber{get;set;}
        public String atpoNumber{get;set;}
        public Boolean blnSupportType{get;set;}
        public String strSubComponent{get;set;}
        public String strServiceType{get;set;}
        public boolean blnServiceTypeException{get;set;}
        public String SSDExpiryDate{get;set;}
        public boolean isLocked {get;set;}
        //public String pacNumber{get;set;}
        //public Boolean blnSubcomponentAvailable{get;set;}
        //public boolean blnPTPEligiblity{get;set;}
        
        public ProductWrapper(ICS_WR_MM_Stocking__c mmRecord,String productType, String fpoNumber,String atpoNumber,Boolean blnSupportType,String strSubComponent,String strServiceType,Boolean blnServiceTypeException,string SSDExpiryDate,boolean isLocked)
        {
            this.mmRecord=mmRecord;
            this.productType=productType;
            this.fpoNumber=fpoNumber;
            this.atpoNumber = atpoNumber;
            this.blnSupportType = blnSupportType;
            this.strSubComponent = strSubComponent;
            this.strServiceType = strServiceType;
            this.blnServiceTypeException = blnServiceTypeException;
            this.SSDExpiryDate = SSDExpiryDate;
            this.isLocked = isLocked;
            //this.pacNumber = pacNumber;
            //this.blnSubcomponentAvailable = blnSubcomponentAvailable;
            //this.blnPTPEligiblity = blnPTPEligiblity;
           
        }
        //This method is used for sorting Product based on the product name
        //Here we are using standard sorting by using comparable interface
        public Integer compareTo(Object compareTo) {
            ProductWrapper compareToEmp = (ProductWrapper)compareTo;
            if (mmRecord.MMID__r.ICS_WR_Product__r.Name == compareToEmp.mmRecord.MMID__r.ICS_WR_Product__r.Name  && blnSupportType==compareToEmp.blnSupportType) return 0;
            if (mmRecord.MMID__r.ICS_WR_Product__r.Name > compareToEmp.mmRecord.MMID__r.ICS_WR_Product__r.Name  && blnSupportType==compareToEmp.blnSupportType) return 1;
            return -1; 
            
        }
    }  

    
 }