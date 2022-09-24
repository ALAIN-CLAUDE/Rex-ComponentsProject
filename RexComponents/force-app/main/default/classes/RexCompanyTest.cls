/**
 * Created by EvgeniyMalahovskiy on 7/3/2022.
 */

@IsTest
private class RexCompanyTest {
    @TestSetup
    private static void setup() {
        Rex_Company__c company = new Rex_Company__c(
            Name = 'PayUp'
        );

        insert company;

        Rex_Company__c company2 = new Rex_Company__c(
                Name = 'GetDone'
        );

        insert company2;

        Trigger_Settings__c accountSettings = new Trigger_Settings__c(
                Name = 'AccountTrigger',
                Is_Active__c = true
        );
        insert accountSettings;

        Trigger_Settings__c contactSettings = new Trigger_Settings__c(
                Name = 'ContactTrigger',
                Is_Active__c = true
        );
        insert contactSettings;

        Trigger_Settings__c leadSettings = new Trigger_Settings__c(
                Name = 'LeadTrigger',
                Is_Active__c = true
        );
        insert leadSettings;

        Trigger_Settings__c opportunitySettings = new Trigger_Settings__c(
                Name = 'OpportunityTrigger',
                Is_Active__c = true
        );
        insert opportunitySettings;
    }

    @IsTest
    private static void testHandleRexCompanyCreationOnInsert_Account() {
        Account account = new Account(
                Name = 'Test',
                Rex_Companies__c = 'PayUp;GetDone'
        );
        Test.startTest();
        insert account;
        Test.stopTest();

        System.assertEquals(2, [SELECT Id FROM Associated_Rex_Company__c].size(), 'Expected 2 junction records');
    }

    @IsTest
    private static void testHandleRexCompanyChangesOnUpdate_Account() {
        Account account = new Account(
                Name = 'Test',
                Rex_Companies__c = 'PayUp'
        );

        insert account;

        System.assertEquals(1, [SELECT Id FROM Associated_Rex_Company__c].size(), 'Expected 1 junction records');

        account.Rex_Companies__c = 'PayUp;GetDone';
        Test.startTest();
        update account;
        Test.stopTest();

        System.assertEquals(2, [SELECT Id FROM Associated_Rex_Company__c].size(), 'Expected 2 junction records');
    }

    @IsTest
    private static void testHandleRexCompanyChangesOnUpdateRemove_Account() {
        Account account = new Account(
                Name = 'Test',
                Rex_Companies__c = 'PayUp;GetDone'
        );

        insert account;

        System.assertEquals(2, [SELECT Id FROM Associated_Rex_Company__c].size(), 'Expected 1 junction records');

        account.Rex_Companies__c = 'PayUp';
        Test.startTest();
        update account;
        Test.stopTest();

        System.assertEquals(1, [SELECT Id FROM Associated_Rex_Company__c].size(), 'Expected 2 junction records');
    }

    @IsTest
    private static void testHandleRexCompanyCreationOnInsert_Contact() {
        Account account = new Account(
                Name = 'Test'
        );

        insert account;

        Contact contact = new Contact(
                LastName = 'test',
                AccountId = account.Id,
                Rex_Companies__c = 'PayUp;GetDone'
        );
        Test.startTest();
        insert contact;
        Test.stopTest();

        System.assertEquals(2, [SELECT Id FROM Associated_Rex_Company__c].size(), 'Expected 2 junction records');
    }

    @IsTest
    private static void testHandleRexCompanyUpdate_Contact() {
        Account account = new Account(
                Name = 'Test'
        );

        insert account;

        Contact contact = new Contact(
                LastName = 'test',
                AccountId = account.Id,
                Rex_Companies__c = 'PayUp;GetDone'
        );

        insert contact;

        contact.Rex_Companies__c = 'PayUp';
        Test.startTest();
        update contact;
        Test.stopTest();

        System.assertEquals(1, [SELECT Id FROM Associated_Rex_Company__c].size(), 'Expected 1 junction records');
    }


    @IsTest
    private static void testHandleRexCompanyCreationOnInsert_Lead() {
        Lead lead = new Lead(
                LastName = 'Test',
                Rex_Companies__c = 'PayUp;GetDone',
                Company = 'Test'
        );
        Test.startTest();
        insert lead;
        Test.stopTest();

        System.assertEquals(2, [SELECT Id FROM Associated_Rex_Company__c].size(), 'Expected 2 junction records');
    }

    @IsTest
    private static void testHandleRexCompanyUpdate_Lead() {
        Lead lead = new Lead(
                LastName = 'Test',
                Rex_Companies__c = 'PayUp;GetDone',
                Company = 'Test'
        );

        insert lead;

        lead.Rex_Companies__c = 'PayUp';

        Test.startTest();
        update lead;
        Test.stopTest();

        System.assertEquals(1, [SELECT Id FROM Associated_Rex_Company__c].size(), 'Expected 1 junction records');
    }

    @IsTest
    private static void testHandleRexCompanyCreationOnInsert_Opportunity() {
        Opportunity opportunity = new Opportunity(
                Name = 'Test', CloseDate = Date.today(),
                StageName = 'Prospect',
                Opportunity_Lead__c = 'Peter Rex',
                Rex_Companies__c = 'PayUp;GetDone'
        );
        Test.startTest();
        insert opportunity;
        Test.stopTest();

        System.assertEquals(2, [SELECT Id FROM Associated_Rex_Company__c].size(), 'Expected 2 junction records');
    }

    @IsTest
    private static void testHandleRexCompanyUpdate_Opportunity() {
        Opportunity opportunity = new Opportunity(
                Name = 'Test', CloseDate = Date.today(),
                StageName = 'Prospect',
                Opportunity_Lead__c = 'Peter Rex',
                Rex_Companies__c = 'PayUp;GetDone'
        );

        insert opportunity;
        opportunity.Rex_Companies__c = 'PayUp';
        Test.startTest();
        update opportunity;
        Test.stopTest();

        System.assertEquals(1, [SELECT Id FROM Associated_Rex_Company__c].size(), 'Expected 1 junction records');
    }
}