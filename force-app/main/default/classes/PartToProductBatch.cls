public with sharing class PartToProductBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, Part_Number__c, Active__c, Product2__c
            FROM SQX_Part__c
            WHERE Active__c = true
        ]);
    }

    public void execute(Database.BatchableContext bc, List<SQX_Part__c> scope) {
        if (hasAccess()) {
            PartToProductService.syncPartsWithProducts(scope);
        }
    }

    public void finish(Database.BatchableContext bc) {}

    private Boolean hasAccess() {
        return (UserInfo.getProfileId() == [
            SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1
        ].Id)
        || FeatureManagement.checkPermission('CQ_Product_Admin');
    }
}