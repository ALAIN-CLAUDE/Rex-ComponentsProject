/**
 * Created by EvgeniyMalahovskiy on 7/3/2022.
 */

public with sharing class RexCompanyService {
    private static final Map<String, String> OBJECT_TYPES_TO_LOOKUP_NAME = new Map<String, String>{
        'Account' => 'Account__c',
        'Contact' => 'Contact__c',
        'Opportunity' => 'Opportunity__c',
        'Lead' => 'Lead__c'
    };
    private static final Map<String, String> PROFILE_NAME_TO_RELATED_COMPANY = new Map<String, String>{
        'CapOps Admin' => 'CapOps',
        'GetDone' => 'GetDone',
        'IDcore' => 'IDcore',
        'InsurePro' => 'InsurePro',
        'JobCall' => 'JobCall',
        'OwnProp' => 'OwnProp',
        'PayUp' => 'PayUp',
        'PrimePro' => 'PrimePro',
        'PropData' => 'PropData',
        'ShopSupply' => 'ShopSupply',
        'SmartFuse' => 'SmartFuse'
    };

    public static List<SObject> getRecordsWithChangedOwner(List<SObject> records, Map<Id, SObject> oldRecords) {
        List<SObject> suitableRecords = new List<SObject>();

        for (SObject record : records) {
            SObject oldRecord = oldRecords.get(record.Id);
            if ((String) record.get('OwnerId') != (String) oldRecord.get('OwnerId')) {
                suitableRecords.add(record);
            }
        }

        return suitableRecords;
    }

    public static void handleSetVisibilityByUsrProfile(List<SObject> objectsFromTrigger) {
        Set<Id> userIds = getOwnerIds(objectsFromTrigger);
        Map<Id, User> ownerByIds = new Map<Id, User>([
            SELECT Id, Profile.Name FROM User WHERE Id IN :userIds
        ]);

        if (ownerByIds.isEmpty()) return;

        setVisibilityByUsrProfile(objectsFromTrigger, ownerByIds);
    }

    private static void setVisibilityByUsrProfile(List<SObject> objectsFromTrigger, Map<Id, User> ownerByIds) {
        for (SObject objectFromTrigger : objectsFromTrigger) {
            if (ownerByIds.containsKey((Id) objectFromTrigger.get('OwnerId'))) {
                User ownerOfRecord = ownerByIds.get((Id) objectFromTrigger.get('OwnerId'));

                if (PROFILE_NAME_TO_RELATED_COMPANY.containsKey(ownerOfRecord.Profile.Name)) {
                    objectFromTrigger.put('Rex_Companies__c', PROFILE_NAME_TO_RELATED_COMPANY.get(ownerOfRecord.Profile.Name));
                }
            }
        }
    }

    private static Set<Id> getOwnerIds(List<SObject> objectsFromTrigger) {
        Set<Id> userIds = new Set<Id>();

        for (SObject objectFromTrigger : objectsFromTrigger) {
            userIds.add((Id) objectFromTrigger.get('OwnerId'));
        }

        return userIds;
    }

    public static void handleSetRelatedRexCompanyCheckboxesOnInsert(List<SObject> objectsFromTrigger) {
        for (SObject objectFromTrigger : objectsFromTrigger) {
            if (objectFromTrigger.get('Rex_Companies__c') != null) {
                String rexCompanies = (String) objectFromTrigger.get('Rex_Companies__c');
                for (String companyName : rexCompanies.split(';')) {
                    objectFromTrigger.put('Related_' + companyName + '__c', true);
                }
            }
        }
    }

    public static void handleRexCompanyCreationOnInsert(List<SObject> objectsFroTrigger, String objectType) {
        Map<String, List<SObject>> objectsByRexCompanyName = new Map<String, List<SObject>>();

        for (SObject objectFromTrigger : objectsFroTrigger) {
            if (objectFromTrigger.get('Rex_Companies__c') != null) {
                String rexCompanies = (String) objectFromTrigger.get('Rex_Companies__c');
                for (String companyName : rexCompanies.split(';')) {
                    if (!objectsByRexCompanyName.containsKey(companyName)) {
                        objectsByRexCompanyName.put(companyName, new List<SObject>());
                    }
                    objectsByRexCompanyName.get(companyName).add(objectFromTrigger);
                }
            }
        }

        if (!objectsByRexCompanyName.isEmpty()) {
            RexCompanyService.createAssociatedRexCompanies(objectsByRexCompanyName, objectType);
        }
    }

    public static void handleRexCompanyChanges(List<SObject> objectsFromTrigger, Map<Id, SObject> oldRecords, String objectType) {
        Map<String, List<SObject>> objectsByRexCompanyNameForInsert = new Map<String, List<SObject>>();
        Set<String> companyNamesForRemove = new Set<String>();
        Set<Id> objectIdsFromTrigger = new Set<Id>();

        for (SObject objectFromTrigger : objectsFromTrigger) {
            String newRexCompanyValues = (String) objectFromTrigger.get('Rex_Companies__c');
            SObject oldRecord = oldRecords.get((Id) objectFromTrigger.get('Id'));
            String oldRexCompanyValues = (String) oldRecord.get('Rex_Companies__c');
            if (newRexCompanyValues != oldRexCompanyValues) {
                if (newRexCompanyValues != null) {
                    Set<String> valuesForCreation = setRexCompanyValuesForCreation(
                            objectFromTrigger,
                            newRexCompanyValues,
                            oldRexCompanyValues
                    );

                    for (String companyName : valuesForCreation) {
                        if (!objectsByRexCompanyNameForInsert.containsKey(companyName)) {
                            objectsByRexCompanyNameForInsert.put(companyName, new List<SObject>());
                        }
                        objectsByRexCompanyNameForInsert.get(companyName).add(objectFromTrigger);
                    }
                }

                if (oldRexCompanyValues != null) {
                    Set<String> valuesForRemove = setRexCompanyValuesForRemove(
                            objectFromTrigger,
                            newRexCompanyValues,
                            oldRexCompanyValues
                    );

                    companyNamesForRemove.addAll(valuesForRemove);
                    objectIdsFromTrigger.add((Id) objectFromTrigger.get('Id'));
                }
            }
        }

        if (!objectsByRexCompanyNameForInsert.isEmpty()) {
            RexCompanyService.createAssociatedRexCompanies(objectsByRexCompanyNameForInsert, objectType);
        }

        if (!companyNamesForRemove.isEmpty() && !objectIdsFromTrigger.isEmpty()) {
            RexCompanyService.removeAssociatedRexCompanies(companyNamesForRemove, objectIdsFromTrigger);
        }
    }

    private static void createAssociatedRexCompanies(Map<String, List<SObject>> objectsByRexCompanyName, String objectType) {
        Set<Id> objectsFromTriggerIds = new Set<Id>();

        for (String companyName : objectsByRexCompanyName.keySet()) {
            for (SObject objectFromTrigger : objectsByRexCompanyName.get(companyName)) {
                objectsFromTriggerIds.add((Id) objectFromTrigger.get('Id'));
            }
        }
        Map<String, Rex_Company__c> companiesByName = getMappedByNameRexCompanies(
                objectsByRexCompanyName.keySet(),
                objectsFromTriggerIds
        );
        if (companiesByName.isEmpty()) return;

        List<Associated_Rex_Company__c> associatedRexCompaniesForInsert = new List<Associated_Rex_Company__c>();
        for (String companyName : objectsByRexCompanyName.keySet()) {
            if (companiesByName.containsKey(companyName) && companiesByName.get(companyName).Associated_Rex_Companies__r.isEmpty()) {
                Id rexCompanyId = companiesByName.get(companyName).Id;
                for (SObject objectFromTrigger : objectsByRexCompanyName.get(companyName)) {
                    Associated_Rex_Company__c associatedRexCompany = new Associated_Rex_Company__c();
                    associatedRexCompany.Rex_Company__c = rexCompanyId;
                    associatedRexCompany.put(OBJECT_TYPES_TO_LOOKUP_NAME.get(objectType), objectFromTrigger.get('Id'));
                    associatedRexCompaniesForInsert.add(associatedRexCompany);
                }
            }
        }

        if (!associatedRexCompaniesForInsert.isEmpty()) {
            insert associatedRexCompaniesForInsert;
        }
    }

    private static void removeAssociatedRexCompanies(Set<String> companyNamesForRemove, Set<Id> objectIdsFromTrigger) {
        delete getExistedAssociatedRexCompanies(companyNamesForRemove, objectIdsFromTrigger);
    }

    private static Set<String> setRexCompanyValuesForCreation(
            SObject objectFromTrigger,
            String newRexCompanyValues,
            String oldRexCompanyValues
    ) {
        Set<String> valuesForCreation = new Set<String>();

        if (oldRexCompanyValues == null) {
            valuesForCreation.addAll(newRexCompanyValues.split(';'));

            for (String newRexCompanyValue : newRexCompanyValues.split(';')) {
                objectFromTrigger.put('Related_' + newRexCompanyValue + '__c', true);
            }
        } else {
            Set<String> oldValues = new Set<String>(oldRexCompanyValues.split(';'));

            for (String newRexCompanyValue : newRexCompanyValues.split(';')) {
                if (!oldValues.contains(newRexCompanyValue)) {
                    valuesForCreation.add(newRexCompanyValue);
                    objectFromTrigger.put('Related_' + newRexCompanyValue + '__c', true);
                }
            }
        }

        return valuesForCreation;
    }

    private static Set<String> setRexCompanyValuesForRemove(
            SObject objectFromTrigger,
            String newRexCompanyValues,
            String oldRexCompanyValues
    ) {
        Set<String> valuesForRemove = new Set<String>();

        if (newRexCompanyValues == null) {
            valuesForRemove.addAll(oldRexCompanyValues.split(';'));

            for (String oldRexCompanyValue : oldRexCompanyValues.split(';')) {
                objectFromTrigger.put('Related_' + oldRexCompanyValue + '__c', false);
            }
        } else {
            Set<String> newValues = new Set<String>(newRexCompanyValues.split(';'));

            for (String oldRexCompanyValue : oldRexCompanyValues.split(';')) {
                if (!newValues.contains(oldRexCompanyValue)) {
                    valuesForRemove.add(oldRexCompanyValue);
                    objectFromTrigger.put('Related_' + oldRexCompanyValue + '__c', false);
                }
            }
        }

        return valuesForRemove;
    }

    private static Map<String, Rex_Company__c> getMappedByNameRexCompanies(Set<String> companyNames, Set<Id> objectsFromTriggerIds) {
        Map<String, Rex_Company__c> companiesByName = new Map<String, Rex_Company__c>();

        for (Rex_Company__c company : [SELECT Id, Name,
                (SELECT Id
                FROM Associated_Rex_Companies__r
                WHERE Lead__c IN :objectsFromTriggerIds
                    OR Account__c IN :objectsFromTriggerIds
                    OR Contact__c IN :objectsFromTriggerIds
                    OR Opportunity__c IN :objectsFromTriggerIds
                )
            FROM Rex_Company__c WHERE Name IN :companyNames]) {
            companiesByName.put(company.Name, company);
        }

        return companiesByName;
    }

    private static List<Associated_Rex_Company__c> getExistedAssociatedRexCompanies(Set<String> companyNamesForRemove, Set<Id> objectIdsFromTrigger) {
        return [
                SELECT Id
                FROM Associated_Rex_Company__c
                WHERE Rex_Company__r.Name IN :companyNamesForRemove
                    AND (
                        Account__c IN :objectIdsFromTrigger
                        OR Contact__c IN :objectIdsFromTrigger
                        OR Lead__c IN :objectIdsFromTrigger
                        OR Opportunity__c IN :objectIdsFromTrigger
                    )
        ];
    }

}