@isTest
public class PartToProductBatchTest {

    @testSetup
    static void setup() {
        Product2 prod = new Product2(Name = 'TestProduct', ProductCode = 'P001', IsActive = true);
        insert prod;

        SQX_Part__c p1 = new SQX_Part__c(Name='TestProduct', Part_Number__c='P001', Active__c=true);
        SQX_Part__c p2 = new SQX_Part__c(Name='NewProduct', Part_Number__c='P002', Active__c=true);
        insert new List<SQX_Part__c>{p1, p2};
    }

    static testmethod void testBatchAsAdmin() {
        Test.startTest();
        Database.executeBatch(new PartToProductBatch(), 200);
        Test.stopTest();

        List<SQX_Part__c> parts = [SELECT Id, Product2__c FROM SQX_Part__c];
        System.assertNotEquals(null, parts[0].Product2__c);
        System.assertNotEquals(null, parts[1].Product2__c);
    }

    static testmethod void testScheduler() {
        Test.startTest();
        String jobId = System.schedule('Test Job', '0 0 6 * * ?', new PartToProductScheduler());
        Test.stopTest();
        System.assertNotEquals(null, jobId);
    }
}