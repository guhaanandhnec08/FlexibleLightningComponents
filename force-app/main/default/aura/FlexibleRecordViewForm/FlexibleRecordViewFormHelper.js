({
    getDynamicData :function(cmp, event, helper){
        var rowCount = cmp.get("v.rowCount");
        var action = cmp.get('c.getData');
        action.setParams({ObjectName: cmp.get("v.objectName"),ColumnNames: cmp.get("v.columnsName")});
        action.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            if(state === 'SUCCESS' ){
                cmp.set('v.dataList',response.getReturnValue());
                cmp.set('v.processedDataList',response.getReturnValue().slice(0,rowCount));
            }else if(state === 'ERROR'){
                var error = response.getError();
                console.error(error);
            }
        }));
        $A.enqueueAction(action);
    }
})