/**
 * Created by EvgeniyMalahovskiy on 7/29/2022.
 */

public with sharing class SetVisibleStatusForRexDataBatch implements Database.Batchable<sObject>{
    private static final Map<String, String> PROFILE_NAME_TO_RELATED_COMPANY = new Map<String, String>{
            'CapOps Admin' => 'Related_CapOps__c',
            'GetDone' => 'Related_GetDone__c',
            'IDcore' => 'Related_IDcore__c',
            'InsurePro' => 'Related_InsurePro__c',
            'JobCall' => 'Related_JobCall__c',
            'OwnProp' => 'Related_OwnProp__c',
            'PayUp' => 'Related_PayUp__c',
            'PrimePro' => 'Related_PrimePro__c',
            'ShopSupply' => 'Related_ShopSupply__c',
            'SmartFuse' => 'Related_SmartFuse__c'
    };

    public void execute(Database.BatchableContext param1, List<Account> records) {
        List<Account> recordsForUpdate = new List<Account>();

        for (Account record : records) {
            if (PROFILE_NAME_TO_RELATED_COMPANY.containsKey(record.Owner.Profile.Name)) {
                record.put(PROFILE_NAME_TO_RELATED_COMPANY.get(record.Owner.Profile.Name), true);

                recordsForUpdate.add(record);
            }
        }

        update recordsForUpdate;
    }

    public void finish(Database.BatchableContext param1) {
    }

    public Database.QueryLocator start(Database.BatchableContext param1) {
        Set<String> profileNames = PROFILE_NAME_TO_RELATED_COMPANY.keySet();
        String query  = 'SELECT Id, Owner.Profile.Name FROM Lead WHERE Owner.Profile.Name IN :profileNames';
        return Database.getQueryLocator(query);
    }
}