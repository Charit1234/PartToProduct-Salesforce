global with sharing class PartToProductScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new PartToProductBatch(), 200);
    }
}