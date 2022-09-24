/**
 * Created by EvgeniyMalahovskiy on 8/11/2022.
 */

public with sharing class LeadService {
    public static void convertLeadOnQualifiedStatus(List<Lead> leads, Map<Id, Lead> oldLeads) {
        Set<Id> leadIdsForConvert = new Set<Id>();

        for (Lead lead : leads) {
            if (lead.Status != oldLeads.get(lead.Id).Status && lead.Status == 'Qualified' && !lead.IsConverted) {
                leadIdsForConvert.add(lead.Id);
            }
        }

        if (!leadIdsForConvert.isEmpty()) {
            customLeadConvert(leadIdsForConvert);
        }
    }

    private static void customLeadConvert(Set<Id> leadIdsForConvert) {
        LeadStatus convertLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];

        List<Database.LeadConvert> massLeadConverts = new List<Database.LeadConvert>();
        for(Id currentLead : leadIdsForConvert){
            Database.LeadConvert leadConvert = new Database.LeadConvert();
            leadConvert.setLeadId (currentLead);
            leadConvert.setConvertedStatus(convertLeadStatus.MasterLabel);
            massLeadConverts.add(leadConvert);
        }

        if (!massLeadConverts.isEmpty()) {
            List<Database.LeadConvertResult> lcr = Database.convertLead(massLeadConverts);
        }
    }
}