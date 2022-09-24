/**
 * Created by EvgeniyMalahovskiy on 8/1/2022.
 */

public with sharing class FixAccountFieldsBatch implements Database.Batchable<sObject>{

    public void execute(Database.BatchableContext param1, List<Account> accounts) {
        Map<String, List<Account>> accountMap = new Map<String, List<Account>>();

        for (Account account : accounts) {
            if (!accountMap.containsKey(account.Name)) {
                accountMap.put(account.Name, new List<Account>());
            }
            accountMap.get(account.Name).add(account);
        }

        if (!accountMap.isEmpty()) {
            List<Account_field_map__c> accountFieldMaps = [
                    SELECT Id,Name, Type__c, DomainAndPhone_c__c, DomainName_c__c, Background_c__c, Investor_Tier_c__c, FirstName__c, LastName__c,New_Name__c
                    FROM Account_field_map__c
                    WHERE Name IN :accountMap.keySet()
            ];

            List<Account> accountsForUpdate = new List<Account>();

            for (Account_field_map__c accountFieldMap : accountFieldMaps) {
                if (accountMap.containsKey(accountFieldMap.Name)) {
                    for (Account accountForFix : accountMap.get(accountFieldMap.Name)) {
                        Account copyOfAccount = new Account();
                        copyOfAccount.Id = accountForFix.Id;
                        if (accountForFix.RecordType.DeveloperName == 'Business_Account') {
                            copyOfAccount.Name = accountFieldMap.New_Name__c;
                        } else {
                            copyOfAccount.FirstName = accountFieldMap.FirstName__c;
                            copyOfAccount.LastName = accountFieldMap.LastName__c;
                        }
                        if (String.isBlank(accountForFix.Type)) copyOfAccount.Type = accountFieldMap.Type__c;
                        if (String.isBlank(accountForFix.DomainAndPhone__c)) copyOfAccount.DomainAndPhone__c = accountFieldMap.DomainAndPhone_c__c;
                        if (String.isBlank(accountForFix.DomainName__c)) copyOfAccount.DomainName__c = accountFieldMap.DomainName_c__c;
                        if (String.isBlank(accountForFix.Background__c)) copyOfAccount.Background__c = accountFieldMap.Background_c__c;
                        if (String.isBlank(accountForFix.Investor_Tier__c)) copyOfAccount.Investor_Tier__c = accountFieldMap.Investor_Tier_c__c;

                        copyOfAccount.Field_Fixed__c = true;
                        accountsForUpdate.add(copyOfAccount);
                    }
                }
            }

            Map<Id, Account> accountsByIds = new Map<Id, Account>();
            accountsByIds.putAll(accountsForUpdate);
            update accountsByIds.values();

        }

    }

    public void finish(Database.BatchableContext param1) {
    }

    public Database.QueryLocator start(Database.BatchableContext param1) {
        String filterCondition = 'a0%';
        String query  = 'SELECT ID, Name, Type, DomainAndPhone__c, ' +
                'Background__c, DomainName__c, Investor_Tier__c, Field_Fixed__c, FirstName, LastName, RecordType.DeveloperName ' +
                'FROM Account WHERE (Account_Name_Lenght__c = 15 OR Person_Account_Name_length__c = 15) AND Name LIKE :filterCondition AND Field_Fixed__c = false';
        return Database.getQueryLocator(query);
    }
}