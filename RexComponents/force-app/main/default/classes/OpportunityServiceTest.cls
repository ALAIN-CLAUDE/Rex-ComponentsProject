/**
 * Created by EvgeniyMalahovskiy on 8/12/2022.
 */

@IsTest
private class OpportunityServiceTest {
    @IsTest
    private static void setOppContactRoleOnOppCreationTest() {
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

        Trigger_Settings__c opportunitySettings = new Trigger_Settings__c(
                Name = 'OpportunityTrigger',
                Is_Active__c = true
        );
        insert opportunitySettings;

        Account account = new Account(
            Name = 'Test Account'
        );
        insert account;

        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Role',
            AccountId = account.Id
        );
        insert contact;

        Opportunity opportunity = new Opportunity(
            Name = 'Test Role',
            AccountId = account.Id,
            StageName = 'ClosedWon',
            CloseDate = Date.today()
        );

        System.assertEquals(0, [SELECT Id FROM OpportunityContactRole].size(), 'Expected 0 opp contact role records');

        Test.startTest();
        insert opportunity;
        Test.stopTest();

        System.assertEquals(1, [SELECT Id FROM OpportunityContactRole].size(), 'Expected 1 opp contact role records');
    }
}