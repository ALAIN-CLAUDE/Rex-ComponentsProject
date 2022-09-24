/**
 * Created by EvgeniyMalahovskiy on 7/3/2022.
 */

public with sharing class OpportunityTriggerHandler extends SObjectDomain{
    private static final String OPPORTUNITY_API_NAME = SObjectType.Opportunity.getName();

    public override void onBeforeInsert() {
        RexCompanyService.handleSetVisibilityByUsrProfile(Trigger.new);
        RexCompanyService.handleSetRelatedRexCompanyCheckboxesOnInsert(Trigger.new);
    }

    public override void onAfterInsert() {
        OpportunityService.setOppContactRoleOnOppCreation(Trigger.new);
        RexCompanyService.handleRexCompanyCreationOnInsert(Trigger.new, OPPORTUNITY_API_NAME);
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        RexCompanyService.handleSetVisibilityByUsrProfile(RexCompanyService.getRecordsWithChangedOwner(Trigger.new, existingRecords));
        RexCompanyService.handleRexCompanyChanges(Trigger.new, existingRecords, OPPORTUNITY_API_NAME);
    }
}