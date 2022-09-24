/**
 * Created by EvgeniyMalahovskiy on 8/19/2022.
 */

@IsTest
private class LeadSeviceTest {
    @IsTest
    static void testConvertLeadOnQualifiedStatus() {
        Trigger_Settings__c leadTrigger = new Trigger_Settings__c(
                Name = 'LeadTrigger',
                Is_Active__c = true
        );
        insert leadTrigger;
        Lead lead = new Lead(
            LastName = 'Test',
            Email = 'mail@mail.com'
        );
        insert lead;

        System.assertEquals(0, [SELECT Id FROM Opportunity].size(), 'Expected none Opportunities');
        Test.startTest();
        lead.Status = 'Qualified';
        update lead;
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Opportunity].size(), 'Expected 1 Opportunities After convert');
    }
}