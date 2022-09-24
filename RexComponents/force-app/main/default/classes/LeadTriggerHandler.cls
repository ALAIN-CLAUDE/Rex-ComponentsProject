/**
 * Created by EvgeniyMalahovskiy on 7/3/2022.
 */

public with sharing class LeadTriggerHandler extends SObjectDomain {
    private static final String LEAD_API_NAME = SObjectType.Lead.getName();

    public override void onBeforeInsert() {
        RexCompanyService.handleSetVisibilityByUsrProfile(Trigger.new);
        RexCompanyService.handleSetRelatedRexCompanyCheckboxesOnInsert(Trigger.new);
    }

    public override void onAfterInsert() {
        RexCompanyService.handleRexCompanyCreationOnInsert(Trigger.new, LEAD_API_NAME);
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        RexCompanyService.handleSetVisibilityByUsrProfile(RexCompanyService.getRecordsWithChangedOwner(Trigger.new, existingRecords));
        RexCompanyService.handleRexCompanyChanges(Trigger.new, existingRecords, LEAD_API_NAME);
    }

    public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
        LeadService.convertLeadOnQualifiedStatus(Trigger.new, (Map<Id, Lead>) existingRecords);
    }
}