/**
@Author -->Accenture Team(Orion)
@name   --> ICS_ThinCaseController
@CreateDate --> 14/02/2020
@Description  --> To Fetch the wrapper of thin Case,Product,Chat related Deatils 
@US-->US542953-Agents to log issue information on thin case
*/

// decorated with "without sharing" keyword as a part of Critical update:
// Use with sharing for @AuraEnabled Apex Controllers with Implicit Sharing
public without sharing class ICS_ThinCaseController {
    
    
    /* Wrapper class to consolidate details required to display & Create Thin Case*/
    public class ThinWrapper{
        @AuraEnabled public String thinCaseId;
        @AuraEnabled Public Id prdId;
        @AuraEnabled public Id chatButtonId;
        @AuraEnabled public String chatKey;
        @AuraEnabled public Boolean thinFunctionalityAvailable = false;  
    }
     @auraEnabled public  string prdHrcId;
     @auraEnabled public  List<Product_Hierarchy__c> productHierarchy;
     @auraEnabled public  List<ICS_Case_Environment_Detail__c> Case_Env_Details;
     @auraEnabled public  List<ICS_Environment_Detail_Question__c> env_Questions;
     @auraEnabled public  List<ICS_Environment_Detail_Answer__c> env_Answers;
     @auraEnabled public  Boolean showEnvironment;
     @auraEnabled public  String hiddenEnvDetails;
     @auraEnabled public Map<String, String> mapOldQuestionAnswer;
     @auraEnabled public  case caseRec = new case();
    
     @AuraEnabled
     public static ICS_ThinCaseController getEnvironmemt(string prdHrcId,string caseRecId){
         try{  ICS_ThinCaseController cw=new ICS_ThinCaseController();
        cw.prdHrcId=prdHrcId;
        cw.caseRec.Id=caseRecId;
        cw.getEnvironmentDetails(prdHrcId);
        return cw;
            }catch(Exception e){
                system.debug('exception e ==> '+e);
                return null;
            }
    }
    
   
     public  void getEnvironmentDetails(string prdHrcId){
         try{  system.debug('prdHrcId=========>'+prdHrcId);
        mapOldQuestionAnswer=new Map<String,String>();
        caseRec.Product_Hierarchy__c=prdHrcId;
        
        productHierarchy =[ select id,Path__c,Product__c from Product_Hierarchy__c where  Id =:caseRec.Product_Hierarchy__c and Hierarchy_ID__c = '95'];
         system.debug('Path__c ==> '+productHierarchy[0].Path__c);
         system.debug('Product__c==> '+productHierarchy[0].Product__c);
        
         String getpaths='';
        for(Product_Hierarchy__c getPath:productHierarchy){
            getpaths=getPath.Path__c;
        }
          system.debug('prod hier');
        if((productHierarchy!=null)&& (productHierarchy.size() > 0)){
            showEnvironment=true;
            ICS_Environment_Language__c getLanguages = ICS_Environment_Language__c.getInstance(UserInfo.getLanguage());
            if(caseRec.Id!=null){
                Case_Env_Details = [SELECT ID,Question__c,Answer__c FROM ICS_Case_Environment_Detail__c WHERE Case__c =:caseRec.Id];
                string allDetailEnv='';
                for(ICS_Case_Environment_Detail__c caseExEnvDetail : Case_Env_Details ){
					string envans = (caseExEnvDetail.Answer__c!=null?caseExEnvDetail.Answer__c:'');
                    string eachDetailEnv = '{"QuestionId":"'+caseExEnvDetail.Question__c+'","Answer":"'+envans+'"}';
                    allDetailEnv +=eachDetailEnv+',';
                    mapOldQuestionAnswer.put(caseExEnvDetail.Question__c, caseExEnvDetail.Answer__c);                    
                }
                allDetailEnv = allDetailEnv.removeEnd(',');
                hiddenEnvDetails = '['+allDetailEnv+']';
            }
            String[] getspiltPath = getpaths.split('\\|');
            list<string> getNodeid = new list<string>();
            for(Integer i=getspiltPath.size()-1;i>=0;i--){
                productHierarchy =[ select id,Product__r.id from Product_Hierarchy__c where  Node_ID__c =:getspiltPath[i] and Hierarchy_ID__c = '95'];
                 system.debug('productHierarchy ==> '+productHierarchy.size());
                //system.debug('productHierarchy ==> '+productHierarchy[0]);
                if(productHierarchy.size()>0){
                    env_Questions = [SELECT ID,Question__c,Required_for_Agent_at_Case_Creation__c,Field_Type__c FROM ICS_Environment_Detail_Question__c WHERE Product__c =:productHierarchy[0].Product__r.id AND Language__c =:getLanguages.code__c AND Active_To_Agent__c=TRUE AND Effective_Date__c <= :datetime.now() AND (End_Date__c >= :datetime.now() or End_Date__c = null)];
                    if(env_Questions.size()>0){
                        i=0;
                    }
                }
            }
            env_Answers = [SELECT ID,Environment_Detail_Question__c,Answer__c FROM ICS_Environment_Detail_Answer__c WHERE Effective_Date__c <= :datetime.now() AND (End_Date__c >= :datetime.now() or End_Date__c = null) AND Environment_Detail_Question__c=:env_Questions];
        }
            }catch(Exception e){
            system.debug('exception e ==> '+e);
                
        }
    }
    
    
    
     /**
    *  Description -Fetch the ProductId,Chat Key,Button Id,Thin Case Id at the intailization of the component
    *  @name -->getPrdThinData(String chatId)
    *  @param -->String chatId  ---> Chat Transcript Id
    *  @return -->ThinWrapper obj which includes all details to create & display the thin case
    *  @US-->US542953-Agents to log issue information on thin case
    **/
    
    @AuraEnabled
    public static ThinWrapper getPrdThinData(String chatId){
        ThinWrapper wrapperObj = new ThinWrapper();
        
        List<LiveChatTranscript> chaltList = [SELECT Id,ThinCase__c,LiveChatButtonId,LiveChatButton.DeveloperName,ChatKey FROM LiveChatTranscript where Id =:chatId];
        
        if(chaltList != null && !chaltList.isEmpty()){ 
            
            wrapperObj.thinCaseId=chaltList[0].ThinCase__c;
            wrapperObj.chatButtonId=chaltList[0].LiveChatButtonId;
            wrapperObj.chatKey=chaltList[0].ChatKey;
            
            String buttonName = chaltList[0].LiveChatButton.DeveloperName;
            
            // ICS_Thin_Case_Skill_Product_map__c obj = ICS_Thin_Case_Skill_Product_map__c.getValues(buttonName);
            // sai edit
            List<LiveChatButtonSkill> liveChatButtonSkillObj = [SELECT Skill.DeveloperName, Button.Developername, ButtonId, Id
                                                                FROM LiveChatButtonSkill
                                                                WHERE Skill.DeveloperName=: Label.ICS_QuickSkill
                                                                AND ButtonId =: chaltList[0].LiveChatButtonId];
            
            
            
            if(liveChatButtonSkillObj != null && !liveChatButtonSkillObj.isEmpty()){
                wrapperObj.thinFunctionalityAvailable=true;
            }
                // sai edit
              /*  if(obj != null){
                    wrapperObj.thinFunctionalityAvailable=true;
                String prdName = obj.Product__c;                
                Id prdId = [select Id , Name from Product2 where Name=:prdName limit 1].Id;                
                if(prdId != null){
                    wrapperObj.prdId = prdId;
                }
            }*/
            
        }
        System.debug('wrapperObj'+wrapperObj);
        return wrapperObj;
    }
    
    
    /**
    *  Description -After Thin Case Creation , update the Chat Transcript Object with the thin case details 
    *  @name -->updateChatTranscript(String chatTranscriptId, String thinCaseId)
    *  @param -->String chatTranscriptId, String thinCaseId  ---> Chat Transcript Id & thin Case Id
    *  @return -->None
    *  @US-->US542953-Agents to log issue information on thin case
    **/
    
    @auraEnabled
    public static void updateChatTranscript(String chatTranscriptId, String thinCaseId){
        List<LiveChatTranscript> chaltList = [SELECT Id,ThinCase__c,LiveChatButtonId,ChatKey FROM LiveChatTranscript where Id =:chatTranscriptId];
        
        if(chaltList != null && !chaltList.isEmpty()){ 
            for(LiveChatTranscript lct : chaltList){
                if(String.isNotBlank(thinCaseId)){
                    lct.ThinCase__c = thinCaseId;
                }
            }
            update chaltList;
        }
        
    }
    
}