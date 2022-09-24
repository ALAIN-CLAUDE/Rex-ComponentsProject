/**
 * Created by EvgeniyMalahovskiy on 7/3/2022.
 */

trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    private static List<Trigger_Settings__c> triggerSettings = [
            SELECT is_Active__c
            FROM Trigger_Settings__c
            WHERE Name = 'AccountTrigger'
                AND Is_Active__c = true
            LIMIT 1
    ];

    if (!triggerSettings.isEmpty()) {
        SObjectDomain.triggerHandler(AccountTriggerHandler.class);
    }
    if(trigger.isAfter){
        if(trigger.isInsert){
            OnInsertAccountCreateRexCompany.onInsert(trigger.newMap);
        }
    }
}