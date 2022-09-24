/**
 * Created by EvgeniyMalahovskiy on 8/28/2022.
 */

@IsTest
private class CustomLookupLwcControllerTest {
    private static Id PERSON_ACCOUNT_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static Id BUSINESS_ACCOUNT_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();

    @IsTest
    static void fetchLookupDataTest() {
        Account personAccount = new Account(
            LastName = 'PersonTest',
            RecordTypeId = PERSON_ACCOUNT_ID
        );

        insert personAccount;

        Account businessAccount = new Account(
                Name = 'BusinessTest',
                RecordTypeId = BUSINESS_ACCOUNT_ID
        );

        insert businessAccount;

        Opportunity opportunity = new Opportunity(
            Name = 'TestOpp',
            StageName = 'New',
            CloseDate = Date.today()
        );

        insert opportunity;

        Test.startTest();
        CustomLookupLwcController.fetchLookupData('Pe', 'Account', 'Person Account');
        CustomLookupLwcController.fetchLookupData('Busin', 'Account', 'Business Account');
        CustomLookupLwcController.fetchLookupData('Test', 'Opportunity', businessAccount.Id);
        Test.stopTest();
    }

    @IsTest
    static void fetchDefaultRecordTest() {
        Account personAccount = new Account(
                LastName = 'PersonTest',
                RecordTypeId = PERSON_ACCOUNT_ID
        );

        insert personAccount;


        Test.startTest();
        CustomLookupLwcController.fetchDefaultRecord(personAccount.Id, 'Account');
        Test.stopTest();
    }
}