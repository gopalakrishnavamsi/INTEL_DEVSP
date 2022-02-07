/********************************************************************************************
* Name        : ICS_AVM_AvaamoContentWrapperCls_Test 
* Author      : Nikhil Patil - Popcornapps
* Date created: 07 - July - 2021
* Description : Rest API to initiate agent live chat 
*                
* Date              Created By                    User-Story   
* 07/07/2021        Popcornapps                   
* ******************************************************************************************/
@isTest
public class ICS_AVM_AvaamoContentWrapperCls_Test {
    @isTest
    static void onWorkAcceptedCntr1()
    {
        String str = '{"access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiISzRndyJ9.","token_type":"Bearer","expires_in":"3599","ext_expires_in":"3599"}';
        ICS_AVM_AvaamoContentWrapperCls wrCont = new ICS_AVM_AvaamoContentWrapperCls();
        wrCont = ICS_AVM_AvaamoContentWrapperCls.parse(str);
    }
}