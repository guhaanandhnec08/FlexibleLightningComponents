({
    init : function(cmp, event, helper) {
        helper.setColumns(cmp);
    },
    setColumns : function(cmp, event, helper){
        var action = cmp.get('c.listAllFields2');
        action.setParams({
            objName: cmp.get("v.objectName"),
            columnsName: cmp.get("v.columnsName"),
            rowCount: cmp.get("v.rowCount"),
            incrementCount: cmp.get("v.incrementCount"),
            viewMore: cmp.get("v.enableViewMore")
        });
        action.setCallback(this,$A.getCallback(
            function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    cmp.set('v.columnList',response.getReturnValue().fieldDetails);
                }else if(state === 'ERROR'){
                    var error = response.getError();
                    console.error(error);
                }
            }
        ));
        $A.enqueueAction(action);
    }
})