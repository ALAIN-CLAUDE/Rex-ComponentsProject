/**
 * Created by EvgeniyMalahovskiy on 8/18/2022.
 */

public without sharing class DefineExistingContactsFromLeadBatch implements Database.Batchable<sObject>{

    public void execute(Database.BatchableContext param1, List<Lead> leads) {
        Set<String> leadNames = new Set<String>();

        for (Lead lead : leads) {
            leadNames.add(lead.Name);
        }

        List<Contact> contacts = [SELECT Id, Name, Email FROM Contact WHERE Name IN :leadNames];

        Map<String, List<Contact>> contactsByName = new Map<String, List<Contact>>();

        for (Contact contact : contacts) {
            if (!contactsByName.containsKey(contact.Name)) {
                contactsByName.put(contact.Name, new List<Contact>());
            }
            contactsByName.get(contact.Name).add(contact);
        }

        List<Lead> leadsForUpdate = new List<Lead>();

        for (Lead lead : leads) {
            if (contactsByName.containsKey(lead.Name)) {
                for (Contact contact : contactsByName.get(lead.Name)) {
                    if (contact.Email == lead.Email) {
                        leadsForUpdate.add(new Lead(
                            Id = lead.Id,
                            Already_Contact__c = true,
                            Duplicate_Contact__c = contact.Id
                        ));

                        break;
                    }
                }
            }
        }

        update leadsForUpdate;
    }

    public void finish(Database.BatchableContext param1) {
    }

    public Database.QueryLocator start(Database.BatchableContext param1) {
        String query  = 'SELECT Id, Already_Contact__c, Duplicate_Contact__c, Name, Email FROM Lead WHERE IsConverted = false';
        return Database.getQueryLocator(query);
    }
}