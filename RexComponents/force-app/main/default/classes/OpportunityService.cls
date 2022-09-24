/**
 * Created by EvgeniyMalahovskiy on 8/12/2022.
 */

public with sharing class OpportunityService {

    public static void setOppContactRoleOnOppCreation(List<Opportunity> opportunities) {
        List<OpportunityContactRole> contactRoles = new List<OpportunityContactRole>();
        Map<String, Opportunity> opportunitiesByName = getOppsMapByName(opportunities);

        for (Contact contact : getContactsByOppName(opportunitiesByName.keySet())) {
            if (opportunitiesByName.containsKey(contact.Name)) {
                contactRoles.add(new OpportunityContactRole(
                    ContactId = contact.Id,
                    OpportunityId = opportunitiesByName.get(contact.Name).Id
                ));
            }
        }

        if (!contactRoles.isEmpty()) {
            insert contactRoles;
        }
    }

    private static List<Contact> getContactsByOppName(Set<String> oppNames) {
        return [SELECT Id, Name FROM Contact WHERE Name IN :oppNames];
    }

    private static Map<String, Opportunity> getOppsMapByName(List<Opportunity> opportunities) {
        Map<String, Opportunity> opportunitiesByName = new Map<String, Opportunity>();

        for (Opportunity opportunity : opportunities) {
            opportunitiesByName.put(opportunity.Name, opportunity);
        }

        return opportunitiesByName;
    }
}