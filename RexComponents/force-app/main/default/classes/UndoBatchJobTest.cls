@isTest
public class UndoBatchJobTest {
		  Static testMethod void testing1()
   {
     Account a = new Account();
     a.Name = 'John Smith';
     a.AccountSource = 'Web';
     a.Type = 'Personal';

     insert a;

	test.startTest();
     UndoBatchJob batchTest = new UndoBatchJob();
    Id batchId = Database.executeBatch(batchTest);
	test.stopTest();
  
    
}
}