/**
 * Created by EvgeniyMalahovskiy on 8/24/2022.
 */

public with sharing class MapOppWithContactBatch implements Database.Batchable<sObject>{
    public void execute(Database.BatchableContext param1, List<Opportunity> opportunities) {
        Map<Id, Opportunity> selectedOpp = new Map<Id, Opportunity>(opportunities);
        List<Opportunity> opportunitiesWithOppRoles = [
                SELECT Id, Opportunity_Email__c, Name,
                    (SELECT Id, ContactId FROM OpportunityContactRoles)
                FROM Opportunity WHERE Id IN :selectedOpp.keySet()
        ];

        Set<String> oppNames = new Set<String>();

        for (Opportunity opportunity : opportunitiesWithOppRoles) {
            oppNames.add(opportunity.Name);
        }

        List<Contact> contacts = [SELECT Id, Name, Email FROM Contact WHERE Name IN :oppNames AND itsDuplicate__c = true];

        Map<String, List<Contact>> contactsByName = new Map<String, List<Contact>>();

        for (Contact contact : contacts) {
            if (!contactsByName.containsKey(contact.Name)) {
                contactsByName.put(contact.Name, new List<Contact>());
            }
            contactsByName.get(contact.Name).add(contact);
        }
        List<OpportunityContactRole> opportunityContactRolesForInsert = new List<OpportunityContactRole>();

        for (Opportunity opportunity : opportunitiesWithOppRoles) {
            if (contactsByName.containsKey(opportunity.Name)) {
                for (Contact contact : contactsByName.get(opportunity.Name)) {
                    if (contact.Email == opportunity.Opportunity_Email__c) {
                        Boolean doInsert = true;
                        for (OpportunityContactRole contactRole : opportunity.OpportunityContactRoles) {
                            if (contactRole.ContactId == contact.Id) {
                                doInsert = false;
                            }
                        }

                        if (doInsert) {
                            opportunityContactRolesForInsert.add(new OpportunityContactRole(
                                    OpportunityId = opportunity.Id,
                                    ContactId = contact.Id
                            ));
                        }
                    }
                }
            }
        }

        insert opportunityContactRolesForInsert;
    }

    public void finish(Database.BatchableContext param1) {
    }

    public Database.QueryLocator start(Database.BatchableContext param1) {
        String query  = 'SELECT Id, Opportunity_Email__c, Name FROM Opportunity';
        return Database.getQueryLocator(query);
    }
}