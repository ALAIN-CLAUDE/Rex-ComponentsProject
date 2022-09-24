@isTest
public class BatchReassignContactToMasTest2 {
       Static testMethod void testing1()
   {
       
         Account b = new Account();
     b.Name = 'John Smith';
     b.AccountSource = 'Web';
     b.Type = 'Personal';
     b.ItADuplicateRecord__c = false;

     insert b;
       
       Account c = new Account();
     c.Name = 'John Smith';
     c.AccountSource = 'Web';
     c.Type = 'Personal';
     c.ItADuplicateRecord__c = false;
   
     insert c;
       
     Account a = new Account();
     a.Name = 'John Smith';
     a.AccountSource = 'Web';
     a.Type = 'Personal';
     a.ItADuplicateRecord__c = true;
   
     insert a;
       
       contact cc = new contact();
       cc.LastName = 'Tester';
       cc.AccountId= a.id;
       insert cc;
       
       
       
       Task t = new task();
       t.WhatId = a.id;
       t.Status= 'Completed';
       t.ActivityDate = system.today();
       insert t;
       

	test.startTest();
     BatchReassignContactToMaster2 batchTest = new BatchReassignContactToMaster2();
    
    Id batchId = Database.executeBatch(batchTest);
	test.stopTest();
  
    
}

}