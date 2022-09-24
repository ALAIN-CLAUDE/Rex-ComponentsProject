@isTest
private class FindDuplicatesAccountsTest {
    Static testMethod void testing1()
   {
     Account a = new Account();
     a.Name = 'John Smith';
     a.AccountSource = 'Web';
     a.Type = 'Personal';

     insert a;

	test.startTest();
     FindDuplicatesAccounts batchTest = new FindDuplicatesAccounts();
    // Database.executeBatch(batchTest);
    Id batchId = Database.executeBatch(batchTest);
	test.stopTest();
  
    
}
}