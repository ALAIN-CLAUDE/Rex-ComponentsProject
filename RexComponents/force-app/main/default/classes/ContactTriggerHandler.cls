/**
 * Created by EvgeniyMalahovskiy on 7/3/2022.
 */

public with sharing class ContactTriggerHandler extends SObjectDomain {
    private static final String CONTACT_API_NAME = SObjectType.Contact.getName();

    public override void onBeforeInsert() {
        RexCompanyService.handleSetVisibilityByUsrProfile(Trigger.new);
        RexCompanyService.handleSetRelatedRexCompanyCheckboxesOnInsert(Trigger.new);
    }

    public override void onAfterInsert() {
        RexCompanyService.handleRexCompanyCreationOnInsert(Trigger.new, CONTACT_API_NAME);
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        RexCompanyService.handleSetVisibilityByUsrProfile(RexCompanyService.getRecordsWithChangedOwner(Trigger.new, existingRecords));
        RexCompanyService.handleRexCompanyChanges(Trigger.new, existingRecords, CONTACT_API_NAME);
    }
}