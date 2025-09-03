@istest
public class TestOpportunityChangeTrigger {
	@istest
    public static void testCreateAndUpdateOpportunity(){
        Test.enableChangeDataCapture();
        Opportunity op1 = new Opportunity();
        op1.Name = 'Sell 100 Widgets';
        op1.StageName = 'Prospecting';
        op1.CloseDate = Date.today().addMonths(3);
        INSERT op1;
        
        Test.getEventBus().deliver();
        
        Opportunity[] oppRecords = [SELECT Id, StageName FROM Opportunity];
		Opportunity opp = oppRecords[0];
		opp.StageName = 'Closed Won';
		update opp;

		Test.getEventBus().deliver();
		Task[] taskList = [SELECT Id, Subject FROM Task];
		System.assertEquals(1, taskList.size(), 'The change trigger did not create the expected task.');        
    }
}