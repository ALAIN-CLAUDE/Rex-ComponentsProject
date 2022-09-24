@isTest
private class BatchApexTestExampleTest {
    static testMethod void testme(){
       Account a = new Account();
     a.Name = 'John Smith';
     a.AccountSource = 'Web';
     a.Type = 'Personal';
     insert a;
        Test.startTest();
        BatchApexTestExample ba= new BatchApexTestExample();
        Id jobid= Database.executeBatch(ba,5);
        Test.stopTest();
        account accs = [select name from account where id=:a.Id];
        system.assertEquals('John Smith', accs.name);
    }
}