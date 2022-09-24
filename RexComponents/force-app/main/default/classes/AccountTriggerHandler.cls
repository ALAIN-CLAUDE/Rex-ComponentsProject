/**
 * Created by EvgeniyMalahovskiy on 7/3/2022.
 */

public with sharing class AccountTriggerHandler extends SObjectDomain{
    private static final String ACCOUNT_API_NAME = SObjectType.Account.getName();

    public override void onBeforeInsert() {
        AccountService.setRexValuesFromPC(Trigger.new, null);
        RexCompanyService.handleSetVisibilityByUsrProfile(Trigger.new);
        RexCompanyService.handleSetRelatedRexCompanyCheckboxesOnInsert(Trigger.new);
    }

    public override void onAfterInsert() {
        RexCompanyService.handleRexCompanyCreationOnInsert(Trigger.new, ACCOUNT_API_NAME);
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        AccountService.setRexValuesFromPC(Trigger.new, (Map<Id, Account>) existingRecords);
        RexCompanyService.handleSetVisibilityByUsrProfile(RexCompanyService.getRecordsWithChangedOwner(Trigger.new, existingRecords));
        RexCompanyService.handleRexCompanyChanges(Trigger.new, existingRecords, ACCOUNT_API_NAME);
    }
}