/**
 * Created by EvgeniyMalahovskiy on 8/25/2022.
 */

public with sharing class DuplicateResolveBatchPerson implements Database.Batchable<sObject>{
    public void execute(Database.BatchableContext param1, List<Contact> contacts) {
        List<Contact> contactsForDelete = new List<Contact>();
        List<Contact> contactsForUpdate = new List<Contact>();

        Map<Id, Contact> contactMap = new Map<Id, Contact>(contacts);
        List<Contact> contactsWithRelatedObjects = [
                SELECT Id,
                (SELECT Id FROM ActivityHistories WHERE CreatedDate = THIS_YEAR),
                (SELECT Id FROM OpportunityContactRoles)
                FROM Contact
                WHERE Id IN :contactMap.keySet()
        ];
        List<Contact> contactsForCheckAccount = new List<Contact>();

        for (Contact contact : contactsWithRelatedObjects) {
            if (contact.ActivityHistories.isEmpty() && contact.OpportunityContactRoles.isEmpty()) {
                contactsForDelete.add(contact);
            } else {
                contactsForUpdate.add(contact);
            }
        }

        if (!contactsForDelete.isEmpty()) {
            delete contactsForDelete;
        }

        if (!contactsForUpdate.isEmpty()) {
            updateContacts(contactsForUpdate);
        }
    }

    private static void updateContacts(List<Contact> contactsForUpdate) {
        Map<Id, Contact> contactsForUpdateMappedById = new Map<Id, Contact>(contactsForUpdate);
        List<Lead> leadsForDelete = [SELECT Id, Website, Title, LeadSource,Company, Phone, Duplicate_Contact__c FROM Lead WHERE Duplicate_Contact__c IN :contactsForUpdateMappedById.keySet()];

        for (Lead lead : leadsForDelete) {
            contactsForUpdateMappedById.get(lead.Duplicate_Contact__c).Title = lead.Title;
            contactsForUpdateMappedById.get(lead.Duplicate_Contact__c).LeadSource = lead.LeadSource;
            contactsForUpdateMappedById.get(lead.Duplicate_Contact__c).Phone = lead.Phone;
        }

        update contactsForUpdateMappedById.values();
        delete leadsForDelete;
    }

    public void finish(Database.BatchableContext param1) {
    }

    public Database.QueryLocator start(Database.BatchableContext param1) {
        String query  = 'SELECT Id FROM Contact WHERE itsDuplicate__c = true AND IsPersonAccount = true';
        return Database.getQueryLocator(query);
    }
}