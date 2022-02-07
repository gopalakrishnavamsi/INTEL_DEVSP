({
    doInit: function(component, event, helper) {
        console.log('inside do init ==> ');
        
    },
    
    onWorkAccepted : function(component, event, helper) {
        console.log('inside onWorkAccepted ==> ');
        component.set("v.isWorkAccepted", false);
        let workItemId = event.getParam('workItemId');
        let workId = event.getParam('workId');
        let content = "";
        let action = component.get("c.onWorkAcceptedCntr");
        action.setParams({ content : content ,
                          recordId : workItemId });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let isWorkAccepted = component.get("v.isWorkAccepted");
                console.log('inside onWorkAccepted isWorkAccepted ==> '+isWorkAccepted);
                component.set("v.isWorkAccepted", true);
               // helper.onWorkAcceptedHelper( component, workItemId , msg );
                if(component.get("v.onAgentSendMessages").length > 0 ){
                    let onAgentSendMessage = component.get("v.onAgentSendMessages");
                    for (var i=0; i< onAgentSendMessage.length; i++)
                    { 
                        var msg = onAgentSendMessage[i];
                        helper.onAgentSendHelper( component, workItemId , msg );
                    } 
                    component.set("v.onAgentSendMessages", "");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("From server: INCOMPLETE");
            }
                else if (state === "ERROR") {
                    let errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: "+errors[0].message);
                        }
                    }else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    }, 
    
    onAgentSend: function(component, event, helper) {
        console.log('inside onAgentSend ==> ');
        let recordId = event.getParam("recordId");
        let content = event.getParam("content");
        let name = event.getParam("name");
        let type = event.getParam("type");
        let timestamp = event.getParam("timestamp");
        // helper.onAgentSendHelper(recordId,content);
        if(component.get("v.isWorkAccepted")){
            console.log('inside if  ==> ');
            helper.onAgentSendHelper(component,recordId,content);
        }else{
            console.log('inside else  ==> ');
            let onAgentSendMessage = component.get("v.onAgentSendMessages");
            onAgentSendMessage.push(content);
            console.log('onAgentSendMessages ==> ',onAgentSendMessage);
            component.set("v.onAgentSendMessages", onAgentSendMessage);
        }
    },
    
    onChatEnded: function(component, event, helper) {
        console.log('inside onChatEnded ==> ');
        var conversation = component.find("conversationKit");
        var recordId = event.getParam("recordId");
        let content = "";//"The live agent has ended the chat. If you still need help you can choose one of the following ways to get help for your issue:";
        let action = component.get("c.onChatEndedCntr");
        action.setParams({  content : content ,
                          recordId : recordId });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server: SUCCESS");
                //refreshFocusedTab(component, event, helper);
            }
            else if (state === "INCOMPLETE") {
                console.log("From server: INCOMPLETE");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: "+errors[0].message);
                        }
                    }else {
                        console.log("Unknown error");
                    }
                }
            /*     var workspaceAPI = component.find("workspace");
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                workspaceAPI.refreshTab({
                    tabId: focusedTabId,
                    includeAllSubtabs: true
                });
            })
            .catch(function(error) {
                console.log(error);
            });*/
        });
            $A.enqueueAction(action);
        },
    
   
    refreshFocusedTab : function(component, event, helper) {
        system.debug('inside refreshFocusedTab');
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.refreshTab({
                tabId: focusedTabId,
                includeAllSubtabs: true
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    
    onWorkClosed : function(component, event, helper) {
        var workItemId = event.getParam('workItemId');
        var workId = event.getParam('workId');
    }, 
    
    onNewMessage: function(cmp, event, helper) {
        let recordId = event.getParam('recordId');
        let content = event.getParam('content');
        let name = event.getParam('name');
        let type = event.getParam('type');
        let timestamp = event.getParam('timestamp');
    },
    
})