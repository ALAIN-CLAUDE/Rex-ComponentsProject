trigger UserTrigger on User (before insert, before update, before delete, after insert, after update, after delete) {
    private static List<Trigger_Settings__c> triggerSettings = [
            SELECT is_Active__c
            FROM Trigger_Settings__c
            WHERE Name = 'UserTrigger'
            AND Is_Active__c = true
            LIMIT 1
    ];

    if (!triggerSettings.isEmpty()) {
        SObjectDomain.triggerHandler(UserTriggerHandler.class);
    }
}