@isTest
public class BatchCreateLeadsTest {
        Static testMethod void testing1()
   {
       
       
    lead a = new lead();
     a.firstname = 'John';
     a.lastname = 'Web';
     a.status = 'Open';
     a.Email = 'tere@mail.com';
   
     insert a;
       
      
       

       

  test.startTest();
     BatchCreateLeads batchTest = new BatchCreateLeads();
    
    Id batchId = Database.executeBatch(batchTest);
  test.stopTest();
  
    
}


}