/************************************************************************************************
 * API Name          : WarrantyProductSearch
 * Description       : Get list of products 
 * HTTP Verb         : Get
 * URI               : /services/apexrest/support/v1.0/warranty/products/search?type=[producttype]
                     &input1=[FPOStockingid]&input2=[ATPOSerial]&mode=[check/create]&returntype=[AWR/SRR/SWR/FUL]
 * Developer         : Omni CX Orion
 * Version History   : V1.0 - Feb 2018 - Created 
 ************************************************************************************************/


@RestResource(urlMapping='/support/v1.0/warranty/products/search')
global with sharing class ICS_Support_WRProductSearch {
    @HttpGet
    global static ICS_Support_WRProductSearch_Handler.ResponseWrapper getWarrantyProducts() {
        RestRequest req = RestContext.request;
        ICS_Support_WRProductSearch_Handler handler = new ICS_Support_WRProductSearch_Handler();
        return handler.getWarrantyProducts(req);
    }   
}


/***********Test Data - Use below URI in Workbench********
/support/v1.0/warranty/products/search?type=[producttype]&input1=[FPONumber]&input2=[ATPONumber]&mode=[check/create]&returntype=[AWR/SRR/SWR/FUL]
/services/apexrest/support/v1.0/warranty/products/search?type=Processor&input1=X450B519&input2=3E447120A0868&oauth=005m0000002UF39
/services/apexrest/support/v1.0/warranty/products/search?type=Processor&input1=X450B519&input2=3E447120A0868returntype=AWR&oauth=005m0000002UF39
/services/apexrest/support/v1.0/warranty/products/search?type=Boards&input1=H60945-201&input2=G6SY548003MK&oauth=005m0000002UF39
/services/apexrest/support/v1.0/warranty/products/search?type=Memory&input1=H60945-201&input2=G6SY548003MK&oauth=005m0000002UF39

*/