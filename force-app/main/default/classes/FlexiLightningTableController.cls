public class FlexiLightningTableController {

    @AuraEnabled
    public static resultWrapper listAllFields2(String objName, String columnsName, Integer rowCount, Integer incrementCount, Boolean viewMore){
        String objectName = objName;
        String columnNames = columnsName;
        List<fieldDataWrapper> wrapperList =  new List<fieldDataWrapper>();
        List<fieldDataWrapper> fieldWrapperList =  new List<fieldDataWrapper>();
        SObjectType sObjectName = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = sObjectName.getDescribe().fields.getMap();
        List<Schema.SObjectField> mFieldList = new List<Schema.SObjectField>();
        for(String s:ColumnNames.split('\\,')){
            mFieldList.add(mfields.get(s));
        }
        system.debug('mFieldList '+mFieldList);

        For(Schema.SObjectField field : mFieldList){
            fieldDataWrapper wrapper = new fieldDataWrapper();
            wrapper.label = field.getDescribe().getLabel();
            wrapper.fieldName = field.getDescribe().getName();
            wrapper.type = String.valueOf(field.getDescribe().getType());
            wrapperList.add(wrapper);
        }
        system.debug('wrapperList '+wrapperList);
        resultWrapper result = new resultWrapper(objectName, columnNames, wrapperList,
                rowCount,viewMore);
        system.debug('result '+result);
        return result;
    }

    @AuraEnabled
    public static resultWrapper listAllFields(String tableName, String typeString){
        DynamicTableMetaData__mdt tableDetails = [SELECT MasterLabel,Object_Name__c,Field_Names__c,
                                                  Row_Count__c,Enable_View_More__c
                                                  FROM DynamicTableMetaData__mdt	
                                                  WHERE MasterLabel =:tableName AND Type__c=:typeString];
        system.debug('tableDetails '+tableDetails);
        String objectName = tableDetails.Object_Name__c;
        String columnNames = tableDetails.Field_Names__c;
        List<fieldDataWrapper> wrapperList =  new List<fieldDataWrapper>(); 
        List<fieldDataWrapper> fieldWrapperList =  new List<fieldDataWrapper>();
        SObjectType sObjectName = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = sObjectName.getDescribe().fields.getMap();
        List<Schema.SObjectField> mFieldList = new List<Schema.SObjectField>();
        for(String s:ColumnNames.split('\\,')){
            mFieldList.add(mfields.get(s));			    
        }
        system.debug('mFieldList '+mFieldList);
        
        For(Schema.SObjectField field : mFieldList){
            fieldDataWrapper wrapper = new fieldDataWrapper();
            wrapper.label = field.getDescribe().getLabel();
            wrapper.fieldName = field.getDescribe().getName();
            wrapper.type = String.valueOf(field.getDescribe().getType());            
            wrapperList.add(wrapper);
        }
        system.debug('wrapperList '+wrapperList);
        resultWrapper result = new resultWrapper(objectName, columnNames, wrapperList, 
                                                 tableDetails.Row_Count__c,tableDetails.Enable_View_More__c);
        system.debug('result '+result);
        return result;
    }
    
    public class resultWrapper{
        @AuraEnabled	public string objectType {get; set;}
        @AuraEnabled	public string columnName {get; set;}
        @AuraEnabled	public List<fieldDataWrapper> fieldDetails {get; set;}
        @AuraEnabled	public Decimal rowCount {get;set;}
        @AuraEnabled	public Boolean viewMoreOption {get;set;}
        public resultWrapper(String obj, String columns, List<fieldDataWrapper> fields, Decimal noRows, Boolean enableViewMore){
            objectType = obj;
            columnName = columns;
            fieldDetails = fields;
            rowCount = noRows;
            viewMoreOption = enableViewMore;
        }
    }
    
    public class fieldDataWrapper{
        @AuraEnabled	public String label { get; set; }
        @AuraEnabled	public String fieldName { get; set; }
        @AuraEnabled	public String type { get; set; }
    }
    
    @AuraEnabled
    public static List<SObject> getData(String ObjectName, String ColumnNames){
        system.debug('ObjectName is '+ObjectName+'****** Columns are '+ColumnNames);
        String query='SELECT '+ColumnNames+' FROM '+ObjectName+' ORDER BY Name ASC NULLS LAST';
        List<sObject> sobjList = Database.query(query);
        return sobjList;        
    }
}