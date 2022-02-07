({
    onAgentSendHelper: function(component, recordId, content) {
        console.log('inside helper onAgentSend ==> ');
        // let recordId = event.getParam("recordId");
        //let content = event.getParam("content");
        console.log('inside helper onAgentSend recordId==> '+recordId);
        console.log('inside helper onAgentSend content ==> '+content);
        
        
        let action = component.get("c.onAgentSendCntr");
        action.setParams({ content : content ,
                          recordId : recordId });
        console.log('inside onAgentSend content ==> '+content);
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server onAgentSend: SUCCESS");
                
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
        });
        $A.enqueueAction(action);
    },
    
  /*  onWorkAcceptedHelper : function(component, recordId, content) {
        console.log('inside onWorkAcceptedHelper ==> ');
      //  let content = "";
        let action = component.get("c.onWorkAcceptedCntr1");
        action.setParams({ content : content ,
                          recordId : recordId });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                 console.log('inside onWorkAcceptedHelper success ==> ');
                
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
    }*/
    
})