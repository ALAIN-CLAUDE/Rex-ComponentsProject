/**
 * Created by EvgeniyMalahovskiy on 8/28/2022.
 */

@IsTest
private class ConvertLeadControllerTest {
    @IsTest
    static void setDataLoadWithCompanyNameTest() {
        Lead lead = new Lead(
            LastName = 'Test',
            Company = 'Test'
        );

        insert lead;

        ConvertLeadController.ConvertLeadWrapper leadWrapper = new ConvertLeadController.ConvertLeadWrapper();

        Test.startTest();
        leadWrapper = ConvertLeadController.setDataLoad(lead.Id);
        Test.stopTest();
    }

    @IsTest
    static void setDataLoadWithoutCompanyNameTest() {
        Lead lead = new Lead(
                LastName = 'Test'
        );

        insert lead;

        ConvertLeadController.ConvertLeadWrapper leadWrapper = new ConvertLeadController.ConvertLeadWrapper();

        Test.startTest();
        leadWrapper = ConvertLeadController.setDataLoad(lead.Id);
        Test.stopTest();
    }

    @IsTest
    static void handleConvertLeadTest() {
        Lead lead = new Lead(
                LastName = 'Test'
        );

        insert lead;

        ConvertLeadController.ConvertLeadWrapper leadWrapper = new ConvertLeadController.ConvertLeadWrapper();
        leadWrapper.recordId = lead.Id;
        leadWrapper.isChooseExistingContact = false;
        leadWrapper.isChooseExistingAccount = false;
        leadWrapper.isChooseExistingOpp = false;
        leadWrapper.opportunityName = 'Test';
        leadWrapper.accountRecordTypeValue = 'Person Account';
        leadWrapper.salutationContact = 'Twest';
        leadWrapper.firstNameContact = 'Twest';
        leadWrapper.middleNameContact = 'Twest';
        leadWrapper.lastNameContact = 'Test';
        leadWrapper.salutationPAccount = 'Test';
        leadWrapper.firstNamePAccount = 'Test';
        leadWrapper.middleNamePAccount = 'Test';
        leadWrapper.lastNamePAccount = 'Test';

        Test.startTest();
        ConvertLeadController.handleConvertLead(JSON.serialize(leadWrapper));
        Test.stopTest();
    }

    @IsTest
    static void handleConvertLeadBusinessTest() {
        Lead lead = new Lead(
                LastName = 'Test',
                Company = 'Test'
        );

        insert lead;

        ConvertLeadController.ConvertLeadWrapper leadWrapper = new ConvertLeadController.ConvertLeadWrapper();
        leadWrapper.recordId = lead.Id;
        leadWrapper.isChooseExistingContact = false;
        leadWrapper.isChooseExistingAccount = false;
        leadWrapper.isChooseExistingOpp = false;
        leadWrapper.opportunityName = 'Test';
        leadWrapper.accountRecordTypeValue = 'Business Account';
        leadWrapper.salutationContact = 'Twest';
        leadWrapper.firstNameContact = 'Twest';
        leadWrapper.middleNameContact = 'Twest';
        leadWrapper.lastNameContact = 'Test';
        leadWrapper.salutationPAccount = 'Test';
        leadWrapper.firstNamePAccount = 'Test';
        leadWrapper.middleNamePAccount = 'Test';
        leadWrapper.lastNamePAccount = 'Test';
        leadWrapper.accountName = 'Test';

        Test.startTest();
        ConvertLeadController.handleConvertLead(JSON.serialize(leadWrapper));
        Test.stopTest();
    }
}