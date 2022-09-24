/**
 * Created by EvgeniyMalahovskiy on 7/3/2022.
 */

trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    private static List<Trigger_Settings__c> triggerSettings = [
            SELECT is_Active__c
            FROM Trigger_Settings__c
            WHERE Name = 'OpportunityTrigger'
            AND Is_Active__c = true
            LIMIT 1
    ];

    if (!triggerSettings.isEmpty()) {
        SObjectDomain.triggerHandler(OpportunityTriggerHandler.class);
    }
}