@isTest
public class BatchMapNewNameTest {
		    
    		      Static testMethod void testing1()
   {
       
       
     Opportunity_main_upload__c a = new Opportunity_main_upload__c();
     a.name='test';
       a.Name__c = 'John Smith';
    // a.AccountId__c = '000001';
   
     insert a;
       
       Account_field_map__c cc = new Account_field_map__c();
       cc.firstName__c = 'Tester';
       cc.lastName__c ='ruba';
        cc.Id__c = '000001';
       insert cc;
       
       
       

  test.startTest();
     BatchMapNewName batchTest = new BatchMapNewName();
    
    Id batchId = Database.executeBatch(batchTest);
  test.stopTest();
  
    
}

}