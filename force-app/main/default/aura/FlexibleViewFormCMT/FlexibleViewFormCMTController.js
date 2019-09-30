({
    init : function(cmp, event, helper) {
        helper.setColumns(cmp);
    },
    setColumns : function(cmp, event, helper){
        var action = cmp.get('c.listAllFields');
        console.log('>>>>typeString: ',cmp.get("v.typeString"));
        action.setParams({tableName: cmp.get("v.typeOfForm"), typeString: cmp.get("v.typeString")});
        action.setCallback(this,$A.getCallback(
            function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    cmp.set('v.columnList',response.getReturnValue().fieldDetails);
                    cmp.set('v.objectName',response.getReturnValue().objectType);
                    cmp.set('v.columnsName',response.getReturnValue().columnName);
                    cmp.set('v.rowCount',response.getReturnValue().rowCount);
                    cmp.set('v.incrementCount',response.getReturnValue().rowCount);
                    cmp.set('v.enableViewMore',response.getReturnValue().viewMoreOption);
                    helper.getDynamicData(cmp, event, helper);
                }else if(state === 'ERROR'){
                    var error = response.getError();
                    console.error(error);
                }
            }
        ));
        $A.enqueueAction(action);
    }
})