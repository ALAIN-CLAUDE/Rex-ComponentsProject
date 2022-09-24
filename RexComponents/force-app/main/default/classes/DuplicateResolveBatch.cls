/**
 * Created by EvgeniyMalahovskiy on 8/25/2022.
 */

public with sharing class DuplicateResolveBatch implements Database.Batchable<sObject>{

    public void execute(Database.BatchableContext param1, List<Contact> contacts) {
        List<Contact> contactsForDelete = new List<Contact>();
        List<Contact> contactsForUpdate = new List<Contact>();

        Map<Id, Contact> contactMap = new Map<Id, Contact>(contacts);
        List<Contact> contactsWithRelatedObjects = [
                SELECT Id, AccountId,
                    (SELECT Id FROM ActivityHistories WHERE CreatedDate = THIS_YEAR),
                    (SELECT Id FROM OpportunityContactRoles)
                FROM Contact
                WHERE Id IN :contactMap.keySet()
        ];
        List<Contact> contactsForCheckAccount = new List<Contact>();
        Set<String> accountIds = new Set<String>();

        for (Contact contact : contactsWithRelatedObjects) {
            if (contact.ActivityHistories.isEmpty() && contact.OpportunityContactRoles.isEmpty()) {
                contactsForCheckAccount.add(contact);
                accountIds.add(contact.AccountId);
            } else {
                contactsForUpdate.add(contact);
            }
        }

        if (!accountIds.isEmpty() && !contactsForCheckAccount.isEmpty()) {
            Map<Id, Account> accountMap = new Map<Id, Account>([
                SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accountIds
            ]);

            for (Contact contact : contactsForCheckAccount) {
                if (contact.AccountId != null && accountMap.get(contact.AccountId).Contacts.size() == 1) {
                    contactsForDelete.add(contact);
                } else {
                    contactsForUpdate.add(contact);
                }
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
        List<Contact> contactForUpdateFromLead = new List<Contact>();
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
        String query  = 'SELECT Id FROM Contact WHERE itsDuplicate__c = true AND IsPersonAccount = false';
        return Database.getQueryLocator(query);
    }
}