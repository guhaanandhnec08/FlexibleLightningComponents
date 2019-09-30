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
                    helper.getDynamicData(cmp, event, helper);
                }else if(state === 'ERROR'){
                    var error = response.getError();
                    console.error(error);
                }
            }
        ));
        $A.enqueueAction(action);
    },
    loadMoreData : function(cmp, event, helper){
        var allData = cmp.get("v.dataList");
        var rowCount = cmp.get("v.rowCount");
        var increment = cmp.get("v.incrementCount");
        if(rowCount <= allData.length){
            rowCount = rowCount+increment;
        }
        if(rowCount >= allData.length){
            $A.util.addClass(cmp.find("viewMore"), "slds-hide");
        }
        cmp.set("v.rowCount",rowCount);
        cmp.set('v.processedDataList',allData.slice(0,rowCount));
    }
})