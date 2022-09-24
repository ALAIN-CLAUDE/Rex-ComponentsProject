/**
 * Created by EvgeniyMalahovskiy on 8/23/2022.
 */

public with sharing class ConvertLeadController {

    @AuraEnabled
    public static ConvertLeadWrapper setDataLoad(String recordId) {
        Lead lead = [SELECT Id, Company, Name,LastName, FirstName, IsConverted, MiddleName FROM Lead WHERE Id = :recordId];

        ConvertLeadWrapper leadWrapper = new ConvertLeadWrapper();

        if (lead.IsConverted) {
            leadWrapper.isConverted = true;
        } else {
            leadWrapper.currentUserId = UserInfo.getUserId();
            leadWrapper.ownerId = UserInfo.getUserId();
            leadWrapper.recordId = lead.Id;
            leadWrapper.companyName = lead.Company;
            leadWrapper.accountName = lead.Company;
            leadWrapper.middleNamePAccount = lead.MiddleName;
            leadWrapper.middleNameContact = lead.MiddleName;
            leadWrapper.leadName = lead.Name;
            leadWrapper.companyNotEmpty = String.isNotBlank(lead.Company);

            if (leadWrapper.accountName == null) {
                leadWrapper.opportunityName = lead.Name + '-';
                leadWrapper.lastNameContact = lead.LastName;
                leadWrapper.firstNameContact = lead.FirstName;
                leadWrapper.fullNameContact = lead.Name;
                leadWrapper.firstNamePAccount = lead.FirstName;
                leadWrapper.lastNamePAccount = lead.LastName;
                leadWrapper.accountName = lead.Name;
                leadWrapper.accountRecordTypeValue = 'Person Account';
            } else {
                leadWrapper.firstNamePAccount = lead.FirstName;
                leadWrapper.lastNamePAccount = lead.LastName;
                leadWrapper.lastNameContact = lead.LastName;
                leadWrapper.firstNameContact = lead.FirstName;
                leadWrapper.fullNameContact = lead.Name;
                leadWrapper.opportunityName = lead.Company + '-';
                leadWrapper.accountRecordTypeValue = 'Business Account';
            }

            for (String recordTypeOpp : Schema.SObjectType.Opportunity.getRecordTypeInfosByName().keySet()) {
                leadWrapper.oppRecordTypeOptions.add(recordTypeOpp);
            }
        }

        return leadWrapper;
    }

    @AuraEnabled
    public static ConvertedWrapper handleConvertLead(String convertLeadWrapperJSON) {
        ConvertedWrapper convertedLead = new ConvertedWrapper();
        ConvertLeadWrapper leadWrapper = new ConvertLeadWrapper();

        leadWrapper = (ConvertLeadWrapper) JSON.deserialize(convertLeadWrapperJSON, ConvertLeadWrapper.class);

        Lead leadForUpdate = new Lead();
        if (leadWrapper.accountRecordTypeValue == 'Person Account' && !leadWrapper.isChooseExistingAccount) {
            leadForUpdate.Id = leadWrapper.recordId;
            leadForUpdate.Company = null;
        } else if (leadWrapper.accountRecordTypeValue != 'Person Account') {
            leadForUpdate.Id = leadWrapper.recordId;
            leadForUpdate.Company = leadWrapper.accountName;
        }

        if (leadForUpdate.Id != null) {
            update leadForUpdate;
        }

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadWrapper.recordId);

        if (leadWrapper.isChooseExistingAccount && leadWrapper.existingAccountId != null) {
            lc.setAccountId(leadWrapper.existingAccountId);
        }

        if (leadWrapper.isChooseExistingContact && leadWrapper.existingContactId != null) {
            lc.setContactId(leadWrapper.existingContactId);
        }

        if (leadWrapper.isChooseExistingOpp && leadWrapper.existingOppId != null) {
            lc.setOpportunityId(leadWrapper.existingOppId);
        } else {
            lc.setOpportunityName(leadWrapper.opportunityName);
        }

        lc.setConvertedStatus('Qualified');
        lc.setOwnerId(leadWrapper.ownerId);
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true;
        Database.LeadConvertResult lcr = Database.convertLead(lc, dml);

        if (lcr.isSuccess()) {
            if (!leadWrapper.isChooseExistingAccount) {
                Account accountForUpdate = [ SELECT Id, Phone, RecordTypeId, Name, RecordType.Name  FROM Account WHERE Id = :lcr.getAccountId()];

                if (leadWrapper.accountRecordTypeValue == 'Person Account') {

                } else {
                    accountForUpdate.Name = leadWrapper.accountName;

                    update accountForUpdate;
                }
            }

            if (!leadWrapper.isChooseExistingContact && leadWrapper.accountRecordTypeValue != 'Person Account') {
                Contact contactForUpdate = [SELECT Id, LastName, Salutation, Suffix, FirstName, MiddleName FROM Contact WHERE Id = :lcr.getContactId()];
                contactForUpdate.Salutation = leadWrapper.salutationContact;
                contactForUpdate.FirstName = leadWrapper.firstNameContact;
                contactForUpdate.MiddleName = leadWrapper.middleNameContact;

                if (String.isBlank(leadWrapper.lastNameContact)) {
                    contactForUpdate.LastName = leadWrapper.leadName;
                } else {
                    contactForUpdate.LastName = leadWrapper.lastNameContact;
                }

                contactForUpdate.Suffix = leadWrapper.suffixContact;

                update contactForUpdate;
            } else if (leadWrapper.accountRecordTypeValue == 'Person Account' && !leadWrapper.isChooseExistingAccount) {
                Contact contactForUpdate = [SELECT Id, LastName, Salutation, Suffix, FirstName, MiddleName FROM Contact WHERE Id = :lcr.getContactId()];
                contactForUpdate.Salutation = leadWrapper.salutationPAccount;
                contactForUpdate.FirstName = leadWrapper.firstNamePAccount;
                contactForUpdate.MiddleName = leadWrapper.middleNamePAccount;

                if (leadWrapper.lastNamePAccount!= null) {
                    contactForUpdate.LastName = leadWrapper.lastNamePAccount;
                } else {
                    contactForUpdate.LastName = leadWrapper.accountName;
                }

                contactForUpdate.Suffix = leadWrapper.suffixPAccount;

                update contactForUpdate;
            }

            if (!leadWrapper.isChooseExistingOpp) {
                Opportunity opportunityForUpdate = [SELECT Id, Name, RecordTypeId, StageName, AccountId, Account.Name, RecordType.Name, CloseDate, Amount FROM Opportunity WHERE Id = :lcr.getOpportunityId()];
                opportunityForUpdate.Name = leadWrapper.opportunityName;

                update opportunityForUpdate;
            }


            if(lcr.getAccountId() != null) {
                convertedLead.convertedAccount = [ SELECT Id, Phone, PersonContactId, RecordTypeId, Name, RecordType.Name, Industry, Owner.Name, PersonTitle, PersonEmail, PersonMobilePhone FROM Account WHERE Id = :lcr.getAccountId()];
            }

            if(lcr.getOpportunityId() != null) {
                convertedLead.convertedOpportunity = [ SELECT Id, Name, AccountId, Account.Name, CloseDate, Amount, Owner.Name FROM Opportunity WHERE Id = :lcr.getOpportunityId()];
            }

            if(lcr.getContactId() != null) {
                convertedLead.convertedContact = [ SELECT Id, Name, Email, Phone,  AccountId, Account.Name, Title, MobilePhone FROM Contact WHERE Id = :lcr.getContactId()];
            }

            convertedLead.isPersonAccount = leadWrapper.accountRecordTypeValue == 'Person Account';
            convertedLead.accountOwner = convertedLead.convertedAccount.Owner.Name;
            convertedLead.oppOwner = convertedLead.convertedOpportunity.Owner.Name;
            convertedLead.contactAccountName = convertedLead.convertedContact.Account.Name;
            convertedLead.oppAccountName = convertedLead.convertedOpportunity.Account.Name;
        }

        return convertedLead;
    }

    public class ConvertLeadWrapper {
        @AuraEnabled
        public Boolean isConverted;
        @AuraEnabled
        public String currentUserId;
        @AuraEnabled
        public String companyName;
        @AuraEnabled
        public String leadName;
        @AuraEnabled
        public Boolean companyNotEmpty;
        @AuraEnabled
        public String recordId;
        @AuraEnabled
        public String accountName;
        @AuraEnabled
        public String accountRecordTypeValue;
        @AuraEnabled
        public String salutationPAccount;
        @AuraEnabled
        public String firstNamePAccount;
        @AuraEnabled
        public String middleNamePAccount;
        @AuraEnabled
        public String lastNamePAccount;
        @AuraEnabled
        public String suffixPAccount;
        @AuraEnabled
        public Boolean isChooseExistingAccount;
        @AuraEnabled
        public String existingAccountId;
        @AuraEnabled
        public String existingContactId;
        @AuraEnabled
        public String existingOppId;
        @AuraEnabled
        public String salutationContact;
        @AuraEnabled
        public String firstNameContact;
        @AuraEnabled
        public String middleNameContact;
        @AuraEnabled
        public String lastNameContact;
        @AuraEnabled
        public String fullNameContact;
        @AuraEnabled
        public String suffixContact;
        @AuraEnabled
        public Boolean isChooseExistingContact;
        @AuraEnabled
        public Boolean isChooseExistingOpp;
        @AuraEnabled
        public String opportunityName;
        @AuraEnabled
        public String opportunityRecordType;
        @AuraEnabled
        public List<String> oppRecordTypeOptions = new List<String>();
        @AuraEnabled
        public String ownerId;

    }

    public class ConvertedWrapper {
        @AuraEnabled
        public Boolean isPersonAccount;
        @AuraEnabled
        public Account convertedAccount;
        @AuraEnabled
        public String accountOwner;
        @AuraEnabled
        public Contact convertedContact;
        @AuraEnabled
        public String contactAccountName;
        @AuraEnabled
        public Opportunity convertedOpportunity;
        @AuraEnabled
        public String oppAccountName;
        @AuraEnabled
        public String oppOwner;
    }
}