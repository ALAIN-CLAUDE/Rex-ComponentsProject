public without sharing class UserTriggerHandler extends SObjectDomain {

    public override void onAfterInsert() {
        UserService.addUserToPublicGroup(Trigger.newMap.keySet());
    }

    public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
        Set<Id> userIds = UserService.getUserIdsWithChangedProfile(Trigger.new, (Map<Id, User>) existingRecords);
        if (!userIds.isEmpty()) {
            UserService.addUserToPublicGroup(Trigger.newMap.keySet());
        }
    }
}