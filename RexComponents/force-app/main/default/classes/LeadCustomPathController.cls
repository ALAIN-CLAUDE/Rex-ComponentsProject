/**
 * Created by EvgeniyMalahovskiy on 8/31/2022.
 */

public with sharing class LeadCustomPathController {
    private static final Set<String> STATUS_VALUES = new Set<String>{
        'Open',
        'Activating',
        'Catalyzing',
        'Unqualified',
        'Qualified'
    };

    @AuraEnabled
    public static void initData(String recordId) {
        Lead currentLead = [SELECT Id, RecordTypeId, Status FROM Lead WHERE Id = :recordId];
        List<LeadStatusWrapper> leadStatusWrappers = new List<LeadStatusWrapper>();

        for (String status : STATUS_VALUES) {
            LeadStatusWrapper wrapper = new LeadStatusWrapper();

            if (currentLead.Status == status) {
                wrapper.className = 'slds-is-active slds-path__item';
            }
        }
    }

    @AuraEnabled
    public static void updateReason(String recordId, String reason) {
        Lead lead = new Lead();
        lead.Id = recordId;
        Lead.Status = 'Unqualified';
        lead.Unqualified_Reason__c = reason;

        update lead;
    }

    public class LeadStatusWrapper {
        @AuraEnabled
        public String className;
        @AuraEnabled
        public String statusValue;
    }
}