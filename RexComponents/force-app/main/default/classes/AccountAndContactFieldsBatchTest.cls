@isTest
public class AccountAndContactFieldsBatchTest {
    private static Id PERSON_ACCOUNT_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();



    @testSetup static void setup() {
        
        Account acc = new Account ();
        acc.FirstName = 'Sonal';
        acc.LastName = 'singh';
        acc.PersonEmail = 'test@CLoudTrnasform.com';
        acc.Website = 'www.CLoudTrnasform.com';
        acc.PersonMailingCity='Delhi';
        acc.PersonMailingStreet= 'Ardee City';
        acc.PersonMailingState = 'Delhi';
        acc.Phone  = '12345678';
        acc.RecordTypeId = PERSON_ACCOUNT_ID;
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Minimum_Investment__c= 1200;
        opp.Type = 'Investor';
        opp.Background__c= 'test';
        opp.Investor_Tier__c = 'A';
        opp.Accredited_Investor__c = true;
        opp.Qualified_Purchaser__c = true;
        opp.InvestRes_Investor__c = true;
        opp.LinkedIn__c= 'www.linkedin.com';
        opp.Location__c= 'test';
        opp.StageName = 'Prospect'; 
        opp.CloseDate = System.today()+10;
        opp.Name = 'Test';
        Opp.Opportunity_Lead__c = 'Peter Rex';
        insert opp;
        
        Contact con = new Contact();
        con.FirstName=  'Tesst';
        con.LastName = 'Test';
        insert Con;
        
        OpportunityContactRole oppContactRole = new OpportunityContactRole();
        oppContactRole.OpportunityID = opp.id;
        oppContactRole.ContactId = con.Id;
        insert oppContactRole;
        
    }
    
    
    @istest
    public static void testBatch(){
        
        List<Opportunity> opp = [SELECT Id FROM Opportunity];
        
        Test.startTest();
		 	
           AccountAndContactFieldsBatch cba = new AccountAndContactFieldsBatch();
           Database.executeBatch(cba);
        Test.stoptest();
    }
}