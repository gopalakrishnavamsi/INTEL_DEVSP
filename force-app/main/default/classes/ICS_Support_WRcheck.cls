/************************************************************************************************
 * Name             : ICS_Support_WRcheck
 * Description      : RestAPI class for fecthing Warranty Check Information.
 * Developer        : Omni CX Orion
 * Version History  : V1.0 - April 2018 - Created 
 * User Storty      : US101496
 * @Author          : Satish M 
 ************************************************************************************************/
@RestResource(urlMapping='/support/v1.0/warranty/warrantyinfo/*')
global with sharing class ICS_Support_WRcheck 
{
    @HttpPost
    global static ICS_Support_WRcheck_Handler.ResponseWrapper getWarrantyInfo(String ProductType,String FPONumber,String ATPONumber,String SerialNumber,String ProductId,String MMId,String StockingId)
    {
        RestRequest req = RestContext.request;
        String FPOStockingNumber;
        String ATPOSerialNumber;
       if(ProductType == 'Processor'){    
         FPOStockingNumber = FPONumber;
         ATPOSerialNumber = ATPONumber;
       }else{
         FPOStockingNumber = StockingId;
         ATPOSerialNumber = SerialNumber;             
       }
       
        return ICS_Support_WRcheck_Handler.getWarrantyCheckData(req,ProductType,FPOStockingNumber,ATPOSerialNumber,ProductId,MMId,StockingId);
    }
}

/*
Login User:https://expensetracker--Dev02.cs20.my.salesforce.com/services/apexrest/support/v1.0/warranty/warrantyinfo/

Annonymous User:https://dev02-intelcustomersupport.cs20.force.com/onlinecasemgmt/services/apexrest/support/v1.0/warranty/warrantyinfo/
Valid input json:
    {
  "ProductType": "Processor",
  "FPOStockingNumber": "X4508519",
  "ATPOSerialNumber": "3E447120A0868",
  "ProductId": "01tm0000002YxGvAAK",
  "MMId": "928634",
  "StockingId": "BX80646I74770"
}
*/