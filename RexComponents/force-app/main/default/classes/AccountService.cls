/**
 * Created by EvgeniyMalahovskiy on 7/3/2022.
 */

public with sharing class AccountService {

    public static void setRexValuesFromPC(List<Account> accounts, Map<Id, Account> oldRecords) {
        for (Account account : accounts) {
            if (oldRecords == null && account.Rex_Companies__pc != null) {
                account.Rex_Companies__c = account.Rex_Companies__pc;
            } else if (oldRecords != null && account.Rex_Companies__pc != oldRecords.get(account.Id).Rex_Companies__pc) {
                account.Rex_Companies__c = account.Rex_Companies__pc;
            }
        }
    }
}