/**
 * Created by EvgeniyMalahovskiy on 8/18/2022.
 */

@IsTest
private class DefineExistingContactsFromLeadBatchTest {
    @IsTest
    static void testBatchJob() {
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Duplicate',
            Email = 'mail@mail.com'
        );

        insert testContact;

        Lead lead = new Lead(
            FirstName = 'Test',
            LastName = 'Duplicate',
            Email = 'mail@mail.com'
        );
        insert lead;

        Test.startTest();
        Database.executeBatch(new DefineExistingContactsFromLeadBatch(), 200);
        Test.stopTest();
    }
}