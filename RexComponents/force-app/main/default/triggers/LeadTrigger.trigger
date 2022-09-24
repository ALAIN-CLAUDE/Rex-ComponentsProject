/**
 * Created by EvgeniyMalahovskiy on 7/3/2022.
 */

trigger LeadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    private static List<Trigger_Settings__c> triggerSettings = [
            SELECT is_Active__c
            FROM Trigger_Settings__c
            WHERE Name = 'LeadTrigger'
            AND Is_Active__c = true
            LIMIT 1
    ];

    if (!triggerSettings.isEmpty()) {
        SObjectDomain.triggerHandler(LeadTriggerHandler.class);
    }
}