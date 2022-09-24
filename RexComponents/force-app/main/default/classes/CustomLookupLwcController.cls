/**
 * Created by EvgeniyMalahovskiy on 8/24/2022.
 */

public with sharing class CustomLookupLwcController {
// Method to fetch lookup search result
    @AuraEnabled(cacheable=true)
    public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName, String accountRecordType) {
        System.debug(accountRecordType);
        List < sObject > returnList = new List < sObject > ();
        String sWildCardText = '%' + searchKey + '%';
        String sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText order by createdDate DESC LIMIT 5';

        if (accountRecordType != null && accountRecordType == 'Person Account') {
            sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText AND IsPersonAccount = true order by createdDate DESC LIMIT 5';
        } else if (accountRecordType != null && accountRecordType != 'Person Account' && sObjectApiName != 'Opportunity') {
            sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText AND IsPersonAccount = false order by createdDate DESC LIMIT 5';
        } else if (sObjectApiName == 'Opportunity') {
            sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText AND AccountId = :accountRecordType order by createdDate DESC LIMIT 5';
        }

        for (sObject obj: database.query(sQuery)) {
            returnList.add(obj);
        }
        return returnList;
    }

    // Method to fetch lookup default value
    @AuraEnabled
    public static sObject fetchDefaultRecord(string recordId , string sObjectApiName) {
        string sRecId = recordId;
        string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Id = : sRecId LIMIT 1';
        for (sObject obj: database.query(sQuery)) {
            return obj;
        }
        return null;
    }
}