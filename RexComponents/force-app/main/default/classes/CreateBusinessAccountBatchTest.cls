@isTest
public class CreateBusinessAccountBatchTest {
	
    @testSetup static void setup() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Id busRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        Account acc = new Account ();
        acc.FirstName = 'Sonal';
        acc.LastName = 'singh';
        acc.PersonEmail = 'test@CLoudTrnasform.com';
        acc.Website = 'www.CLoudTrnasform.com';
        acc.PersonMailingCity='Delhi';
        acc.PersonMailingStreet= 'Ardee City';
        acc.PersonMailingState = 'Delhi';
        acc.Phone  = '12345678';
        acc.RecordTypeId = devRecordTypeId;
        insert acc;
        
        Account acc2 = new Account ();
        acc2.FirstName = 'Sonal';
        acc2.LastName = 'singh';
        acc2.PersonEmail = 'test@CLoudTrnasform.com';
        acc2.Website = 'www.CLoudTrnasform.com';
        acc2.PersonMailingCity='Delhi';
        acc2.PersonMailingStreet= 'Ardee City';
        acc2.PersonMailingState = 'Delhi';
        acc2.Phone  = '12345678';
        acc2.RecordTypeId = devRecordTypeId;
        insert acc2;
        
        Account acc3 = new Account ();
        acc3.FirstName = 'Sonal';
        acc3.LastName = 'singh';
        acc3.PersonEmail = 'test@CLoudTrnasform.com';
        acc3.Website = 'www.CLoudTrnasform.com';
        acc3.PersonMailingCity='Delhi';
        acc3.PersonMailingStreet= 'Ardee City';
        acc3.PersonMailingState = 'Delhi';
        acc3.Phone  = '12345678';
        acc3.RecordTypeId = devRecordTypeId;
        insert acc3;
        
        Account accB = new Account ();
        accB.Name = 'Sonal Test';
        accB.Website = 'www.CLoudTrnasform.com';
        accB.Phone  = '12345678';
        accB.DomainAndPhone__c = 'test';
        accB.RecordTypeId = busRecordTypeId;
        insert accB;
        
        Account accB2 = new Account ();
        accB2.Name = 'Sonal singh';
        accB2.Website = 'www.CLoudTrnasform.com';
        accB2.DomainAndPhone__c = 'test';
        accB2.Phone  = '12345678';
        accB2.RecordTypeId = busRecordTypeId;
        insert accB2;
        
        Account accB3 = new Account ();
        accB3.Name = 'Sonal';
        accB3.Website = 'www.CLoudTrnasform.com';
        accB3.Phone  = '12345678';
        accB3.DomainAndPhone__c = 'test';
        accB3.RecordTypeId = busRecordTypeId;
        insert accB3;
             
    }
    
    @istest
    public static void testBatch(){
        
        List<Account> acct = [SELECT Id FROM Account];
        
        Test.startTest();
		 	UpdateFormulaFieldBatch updateFormulaField = new UpdateFormulaFieldBatch();
        	Database.executeBatch(updateFormulaField);
        
           CreateBusinessAccountBatch cba = new CreateBusinessAccountBatch('');
           Database.executeBatch(cba);
        Test.stoptest();
    }
    
    
    @istest
    public static void testBatchForBusinessAccount(){
        List<Account> lstAcc = [SELECT Id FROM Account WHERE RecordType.Name = 'Business Account' AND DomainAndPhone__c != null];
        System.assert(lstAcc.size() != 0);
        Test.startTest();
        CreateBusinessAccountBatch cbaMerge = new CreateBusinessAccountBatch('Merge');
        Database.executeBatch(cbaMerge);
        Test.stoptest();
    }
    
    @istest
    public static void testBatchForUpdateName(){
        Test.startTest();
    	CreateBusinessAccountBatch cbaUpdate = new CreateBusinessAccountBatch('UpdateName');
        Database.executeBatch(cbaUpdate);
        Test.stoptest();
    }
}