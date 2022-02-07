/********************************************************************************************
* Name        : ICS_AVM_ChatButtonsUtil
* Test class  : ICS_AVM_ChatButtonsUtil_Test
* Author      : Priyabhavana - Popcornapps
* Date created: 31 - March - 2020
* Description : Return chat button id when provided epm id,language and deploymentId
*                
* Date              Created By                    User-Story   
* 31/03/2020        Popcornapps                   US951685
* ******************************************************************************************/
public with sharing class ICS_AVM_ChatButtonsUtil {
 
    Map<String, ChatandDeploymentIdWrapper> epmIdAndLanguageToChatandDepIdMap;
    String defaultButtonId;
    String defaultDeploymentId;
    // 06/04/2020 -US951685 (TA2259813)- Adding deploymentid as param 
    public ChatandDeploymentIdWrapper processEPMIdAndLanguage(String epmId,String language){
        ChatandDeploymentIdWrapper chatandDeploymentIdWrap = new ChatandDeploymentIdWrapper();
        Map<String, ICS_AVM_ChatButtonToEPMAndLanguageMap__c> chatButtonToEPMAndLangCustomMap = ICS_AVM_ChatButtonToEPMAndLanguageMap__c.getAll();
        
        if(chatButtonToEPMAndLangCustomMap != null && !chatButtonToEPMAndLangCustomMap.isEmpty()){
           epmIdAndLanguageToChatandDepIdMap = prepareEPMIdAndLangToChatButtonIdMap(chatButtonToEPMAndLangCustomMap); 
        }
        
        if(epmIdAndLanguageToChatandDepIdMap != null && !epmIdAndLanguageToChatandDepIdMap.isEmpty()){
           chatandDeploymentIdWrap = getChatButtonId(epmId,language);
        }
        return chatandDeploymentIdWrap;
    }
    
        
    /*───────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
    * @method   prepareEPMIdAndLangToChatButtonIdMap
    * @author   Priyabhavana
    * @param    chatButtonToEPMAndLangCustomMap - custom settings map
    * @return   epmIdAndLanguageToChatButtonIdMap 
    * ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    Map<String,ChatandDeploymentIdWrapper> prepareEPMIdAndLangToChatButtonIdMap(Map<String,ICS_AVM_ChatButtonToEPMAndLanguageMap__c> chatButtonToEPMAndLangCustomMap){
        epmIdAndLanguageToChatandDepIdMap = new Map<String,ChatandDeploymentIdWrapper>();
        for(String chatButtonName: chatButtonToEPMAndLangCustomMap.keySet()){
           ChatandDeploymentIdWrapper chatandDeploymentIdWrap = new ChatandDeploymentIdWrapper();
            if(chatButtonToEPMAndLangCustomMap.get(chatButtonName).Is_Default__c == true){
               defaultButtonId = chatButtonToEPMAndLangCustomMap.get(chatButtonName).Chat_Button_Id__c;
               defaultDeploymentId = chatButtonToEPMAndLangCustomMap.get(chatButtonName).Deployment_Id__c; 
            }
           chatandDeploymentIdWrap.chatButtonId = chatButtonToEPMAndLangCustomMap.get(chatButtonName).Chat_Button_Id__c;
           chatandDeploymentIdWrap.deploymentId = chatButtonToEPMAndLangCustomMap.get(chatButtonName).Deployment_Id__c;
           epmIdAndLanguageToChatandDepIdMap.put(chatButtonToEPMAndLangCustomMap.get(chatButtonName).EPM_Id__c+chatButtonToEPMAndLangCustomMap.get(chatButtonName).Language__c,chatandDeploymentIdWrap);
        }    
        return epmIdAndLanguageToChatandDepIdMap;
    }
    
    /*───────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
    * @method   getChatButtonId
    * @author   Priyabhavana
    * @param    epmIdAndLanguageToChatButtonIdMap,epmId,language,deploymentId
    * @return   buttonId 
    * ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    ChatandDeploymentIdWrapper getChatButtonId(String epmId,String language){
       ChatandDeploymentIdWrapper chatandDepIdWrap = new ChatandDeploymentIdWrapper();
        if(String.isNotBlank(epmId) && String.isNotBlank(language) && epmIdAndLanguageToChatandDepIdMap.containsKey(epmId+language)){
            chatandDepIdWrap.chatButtonId = epmIdAndLanguageToChatandDepIdMap.get(epmId+language).chatButtonId;
            chatandDepIdWrap.deploymentId = epmIdAndLanguageToChatandDepIdMap.get(epmId+language).deploymentId;
        }else{
            chatandDepIdWrap.chatButtonId = defaultButtonId;
            chatandDepIdWrap.deploymentId = defaultDeploymentId;
        }
        return chatandDepIdWrap;
    }

    public class ChatandDeploymentIdWrapper{
        public String chatButtonId;
        public String deploymentId;
    }
    
}