/**
 * Created by EvgeniyMalahovskiy on 8/23/2022.
 */

import {api, LightningElement, track} from 'lwc';
import {NavigationMixin} from "lightning/navigation";

import setDataLoad from '@salesforce/apex/ConvertLeadController.setDataLoad';
import handleConvertLead from '@salesforce/apex/ConvertLeadController.handleConvertLead';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class ConvertLead extends NavigationMixin(LightningElement) {
    @track
    data;
    @api
    recordId;

    @track
    convertWrap;

    isLoading = true;

    openAccount = true;
    createNewAccountToggle = true;
    chooseExistingToggle = false;

    openContact = false;
    createNewContactToggle = true;
    chooseExistingContactToggle = false;

    openOpportunity = false;
    createNewOpportunityToggle = true;
    chooseExistingOpportunityToggle = false;

    salutationPicklistValue = '';

    oppRecordTypeValue = 'Admin View';

    currentConvertedValue = 'Qualified';

    convertedAccountId;
    hasAccount;

    convertedContactId;
    hasContact;

    convertedOppId;
    hasOpp;

    hasContactTop = false;
    hasContactBottom = false;

    totalBoxes = 0;
    confirmClass = '';

    convertedSuccess = false;

    disableExistingOpp = true;

    selectedRecordLookupNameAccount;
    selectedRecordLookupNameContact;
    selectedRecordLookupNameOpp;

    get accountRecordTypeOptions() {
        return [
            { label: 'Person Account', value: 'Person Account' },
            { label: 'Business Account', value: 'Business Account' }
        ];
    }

    get accountSalutationOptions() {
        return [
            { label: '--None--', value: '' },
            { label: 'Mr.', value: 'Mr.' },
            { label: 'Ms.', value: 'Ms.' }
        ];
    }

    get oppRecordTypeValues() {
        return [
            { label: 'Admin View', value: 'Admin View' },
            { label: 'CapOps Connector', value: 'CapOps Connector' },
            { label: 'CapOps Sales Process', value: 'CapOps Sales Process' },
            { label: 'InsurePro Sales Process', value: 'InsurePro Sales Process' }
        ];
    }

    get ConvertedStatusValues() {
        return [
            { label: 'Qualified', value: 'Qualified' }
        ];
    }

    connectedCallback() {
        this.setDataLoad();
    }

    setDataLoad() {
        setDataLoad({'recordId':this.recordId})
            .then(result => {
                this.data = result;
                this.isLoading = false;
            })
            .catch(error => {
                this.error = error.message;

                console.log(this.error);
            });
    }

    handleCloseSectionClick(event) {
        let currentObjectOpen = event.detail.currentObject;

        if (currentObjectOpen === 'Account') {
            this.createNewAccountToggle = event.detail.createNewToggle;
            this.chooseExistingToggle = event.detail.chooseExistingToggle;
            if (this.chooseExistingToggle) {
                this.disableExistingOpp = false;
            } else {
                this.createNewOpportunityToggle = true;
                this.chooseExistingOpportunityToggle = false;
                this.disableExistingOpp = true;
            }
            this.openAccount = true;
        } else if (currentObjectOpen === 'Contact') {
            this.createNewContactToggle = event.detail.createNewToggle;
            this.chooseExistingContactToggle = event.detail.chooseExistingToggle;
            this.openContact = true;
        } else if (currentObjectOpen === 'Opportunity') {
            this.createNewOpportunityToggle = event.detail.createNewToggle;
            this.chooseExistingOpportunityToggle = event.detail.chooseExistingToggle;
            this.openOpportunity = true;
        }
    }

    handleToggleAccount() {
        this.createNewAccountToggle = !this.createNewAccountToggle;
        this.chooseExistingToggle = !this.chooseExistingToggle;

        if (this.chooseExistingToggle) {
            this.disableExistingOpp = false;
        } else {
            this.data.existingAccountId = null;
            this.data.isChooseExistingOpp = null;
            this.createNewOpportunityToggle = true;
            this.chooseExistingOpportunityToggle = false;
            this.disableExistingOpp = true;
            let itemAccount = this.template.querySelector(".accountLookup");

            if (itemAccount != null && itemAccount != undefined) {
                itemAccount.handleRemove();
            }
            let itemOpp = this.template.querySelector(".oppLookup");
            if (itemOpp != null && itemOpp != undefined) {
                itemOpp.handleRemove();
            }
        }
        let itemDD = this.template.querySelector(".accountLookup");
        this.resetAccountValidation();
        itemDD.removeSetErrorExistingLookup();
    }

    handleToggleContact() {
        this.createNewContactToggle = !this.createNewContactToggle;
        this.chooseExistingContactToggle = !this.chooseExistingContactToggle;

        if (!this.chooseExistingContactToggle) {
            this.data.existingContactId = null;
            let itemContact = this.template.querySelector(".contactLookup");

            if (itemContact != null && itemContact != undefined) {
                itemContact.handleRemove();
            }
        }
        this.resetContactValidation();
        let itemDD = this.template.querySelector(".contactLookup");
        itemDD.removeSetErrorExistingLookupContact();
    }

    handleToggleOpportunity() {
        this.createNewOpportunityToggle = !this.createNewOpportunityToggle;
        this.chooseExistingOpportunityToggle = !this.chooseExistingOpportunityToggle;

        if (!this.chooseExistingOpportunityToggle) {
            this.data.existingOppId = null;
            let itemOpp = this.template.querySelector(".oppLookup");

            if (itemOpp != null && itemOpp != undefined) {
                itemOpp.handleRemove();
            }
        }
        this.resetOppValidation();
        let itemDD = this.template.querySelector(".oppLookup");
        itemDD.removeSetErrorExistingLookupContact();
    }

    handleCloseAccountSection() {
        this.openAccount = false;
    }

    handleCloseContactSection() {
        this.openContact = false;
    }

    handleCloseOpportunitySection() {
        this.openOpportunity = false;
    }

    handleChangeAccountRecordType(event) {
        try {
            this.data.accountRecordTypeValue = event.detail.value;

            if (event.detail.value == 'Person Account') {
                this.data.companyNotEmpty = false
            } else {
                this.data.companyNotEmpty = true
            }
        } catch (e) {
            console.log(e)
        }
    }

    handleChangeAccountSalutation(event) {
        try {
            this.salutationPicklistValue = event.detail.value;
            this.data.salutationPAccount = event.detail.value;
        } catch (e) {
            console.log(e)
        }
    }

    handleChangeContactSalutation(event) {
        try {
            this.salutationPicklistValue = event.detail.value;
            this.data.salutationContact = event.detail.value;
        } catch (e) {
            console.log(e)
        }
    }
    handleChangeOppType(event) {
        try {
            this.oppRecordTypeValue = event.detail.value;
            this.data.opportunityRecordType = event.detail.value;
        } catch (e) {
            console.log(e)
        }
    }

    resetAccountValidation() {
        let accountName = this.template.querySelector(".accountName");
        if (accountName !== undefined && accountName !== null) {
            accountName.setCustomValidity('');
            accountName.reportValidity();
        }

        let lastNameAccount = this.template.querySelector(".lastNameAccount");
        if (lastNameAccount !== undefined && lastNameAccount !== null) {
            lastNameAccount.setCustomValidity('');
            lastNameAccount.reportValidity();
        }
    }

    resetContactValidation() {
        let lastNameContact = this.template.querySelector(".lastNameContact");

        if (lastNameContact !== undefined && lastNameContact !== null) {
            lastNameContact.setCustomValidity('');
            lastNameContact.reportValidity();
        }
    }

    resetOppValidation() {
        let oppName = this.template.querySelector(".oppName");

        if (oppName !== undefined && oppName !== null) {
            oppName.setCustomValidity('');
            oppName.reportValidity();
        }
    }

    handleCheckAccountName() {
        let accountName = this.template.querySelector(".accountName");
        if (accountName !== undefined && accountName !== null) {
            let fieldValue = accountName.value;

            if (!fieldValue) {
                accountName.setCustomValidity('Please, fill this field');
            } else {
                accountName.setCustomValidity('');
            }

            accountName.reportValidity();
        }

        let lastNameAccount = this.template.querySelector(".lastNameAccount");
        if (lastNameAccount !== undefined && lastNameAccount !== null) {
            let fieldValueLast = lastNameAccount.value;

            if (!fieldValueLast) {
                lastNameAccount.setCustomValidity('Please, fill this field');
            } else {
                lastNameAccount.setCustomValidity('');
            }

            lastNameAccount.reportValidity();
        }
    }

    handleCheckContactName() {
        let lastNameContact = this.template.querySelector(".lastNameContact");

        if (lastNameContact !== undefined && lastNameContact !== null) {
            let fieldValueContact = lastNameContact.value;

            if (!fieldValueContact) {
                lastNameContact.setCustomValidity('Please, fill this field');
            } else {
                lastNameContact.setCustomValidity('');
            }

            lastNameContact.reportValidity();

        }
    }

    handleCheckOppName() {
        let oppName = this.template.querySelector(".oppName");

        if (oppName !== undefined && oppName !== null) {
            let fieldValueOppName = oppName.value;

            if (!fieldValueOppName) {
                oppName.setCustomValidity('Please, fill this field');
            } else {
                oppName.setCustomValidity('');
            }

            oppName.reportValidity();
        }
    }

    onFieldChange(event) {
        if (event.target.name === 'accountName') {
            this.data.accountName = event.target.value;
            this.handleCheckAccountName();
        }

        if (event.target.name === 'firstNameAccount') {
            this.data.firstNamePAccount = event.target.value;
        }

        if (event.target.name === 'middleNameAccount') {
            this.data.middleNamePAccount = event.target.value;
        }

        if (event.target.name === 'lastNameAccount') {
            this.data.lastNamePAccount = event.target.value;
            this.handleCheckAccountName();
        }

        if (event.target.name === 'suffixAccount') {
            this.data.suffixPAccount = event.target.value;
        }

        if (event.target.name === 'contactName') {
            this.data.contactName = event.target.value;
        }

        if (event.target.name === 'firstNameContact') {
            this.data.firstNameContact = event.target.value;
        }

        if (event.target.name === 'middleNameContact') {
            this.data.middleNameContact = event.target.value;
        }

        if (event.target.name === 'lastNameContact') {
            this.data.lastNameContact = event.target.value;
            this.handleCheckContactName();
        }

        if (event.target.name === 'suffixContact') {
            this.data.suffixContact = event.target.value;
        }

        if (event.target.name === 'firstNameOpportunity') {
            this.data.opportunityName = event.target.value;
            this.handleCheckOppName();
        }

        console.log(this.data);
    }

    lookupRecord(event){
        try {
            if (event.detail.selectedRecord !== null) {
                this.selectedRecordLookupNameAccount = event.detail.selectedRecord.Name;
                this.data.existingAccountId = event.detail.selectedRecord.Id;
            } else {
                this.data.existingAccountId = null;
                this.selectedRecordLookupNameAccount = null;
            }
        } catch (e) {
            this.data.existingAccountId = null;
            this.selectedRecordLookupNameAccount = null;
        }
    }

    lookupRecordContact(event){
        try {
            if (event.detail.selectedRecord !== null) {
                this.selectedRecordLookupNameContact = event.detail.selectedRecord.Name;
                this.data.existingContactId = event.detail.selectedRecord.Id;
            } else {
                this.selectedRecordLookupNameContact = null;
                this.data.existingContactId = null;
            }
        } catch (e) {
            this.selectedRecordLookupNameContact = null;
            this.data.existingContactId = null;
        }
    }

    lookupRecordOpp(event){
        try {
            if (event.detail.selectedRecord !== null) {
                this.selectedRecordLookupNameOpp = event.detail.selectedRecord.Name;
                this.data.existingOppId = event.detail.selectedRecord.Id;
            } else {
                this.selectedRecordLookupNameOpp = null;
                this.data.existingOppId = null;
            }
        } catch (e) {
            this.selectedRecordLookupNameOpp = null;
            this.data.existingOppId = null;
        }
    }

    handleSearchUser(event){
        try {
            if (event.detail.selectedRecord !== null) {
                this.data.ownerId = event.detail.selectedRecord.Id;
            } else {
                this.data.ownerId = null;
            }
        } catch (e) {
            this.data.ownerId = null;
        }
    }

    handleDoValidation() {
        let isPass = true;

        if (!this.data.isChooseExistingAccount) {
            let accountName = this.template.querySelector(".accountName");
            if (accountName !== undefined && accountName !== null) {
                let fieldValue = accountName.value;

                if (!fieldValue) {
                    accountName.setCustomValidity('Please, fill this field');
                    isPass = false;
                } else {
                    accountName.setCustomValidity('');
                }

                accountName.reportValidity();
            }

            let lastNameAccount = this.template.querySelector(".lastNameAccount");
            if (lastNameAccount !== undefined && lastNameAccount !== null) {
                let fieldValueLast = lastNameAccount.value;

                if (!fieldValueLast) {
                    lastNameAccount.setCustomValidity('Please, fill this field');
                    isPass = false;
                } else {
                    lastNameAccount.setCustomValidity('');
                }

                lastNameAccount.reportValidity();
            }
        }

        if (!this.data.isChooseExistingContact) {
            let lastNameContact = this.template.querySelector(".lastNameContact");

            if (lastNameContact !== undefined && lastNameContact !== null) {
                let fieldValueContact = lastNameContact.value;

                if (!fieldValueContact) {
                    lastNameContact.setCustomValidity('Please, fill this field');
                    isPass = false;
                } else {
                    lastNameContact.setCustomValidity('');
                }

                lastNameContact.reportValidity();
            }
        }

        if (!this.data.isChooseExistingOpp) {
            console.log('here')
            let oppName = this.template.querySelector(".oppName");

            if (oppName !== undefined && oppName !== null) {
                let fieldValueOppName = oppName.value;

                if (!fieldValueOppName) {
                    oppName.setCustomValidity('Please, fill this field');
                    isPass = false;
                } else {
                    oppName.setCustomValidity('');
                }

                oppName.reportValidity();
            }
        }

        if (this.data.ownerId == null || this.data.ownerId == undefined) {
            this.template.querySelectorAll('c-custom-search-lookup').forEach(element => {
                element.handleSetError();
            });
            isPass = false;
        }

        if (this.data.isChooseExistingAccount && (this.data.existingAccountId == null || this.data.existingAccountId == undefined)) {
            isPass = false;
            let itemDD = this.template.querySelector(".accountLookup");
            itemDD.handleSetErrorExistingLookup();
        }

        if (this.data.isChooseExistingContact && (this.data.existingContactId == null || this.data.existingContactId == undefined)) {
            isPass = false;
            let itemDD = this.template.querySelector(".contactLookup");
            itemDD.handleSetErrorExistingLookup();
        }

        if (this.data.isChooseExistingOpp && (this.data.existingOppId == null || this.data.existingOppId == undefined)) {
            isPass = false;
            let itemDD = this.template.querySelector(".oppLookup");
            itemDD.handleSetErrorExistingLookup();
        }

        return isPass;
    }

    handleConvertLead() {
        this.data.isChooseExistingAccount = this.chooseExistingToggle;
        this.data.isChooseExistingContact = this.chooseExistingContactToggle;
        this.data.isChooseExistingOpp = this.chooseExistingOpportunityToggle;

        if (this.handleDoValidation()) {
            this.isLoading = true;

            let newWrap = JSON.stringify(this.data);
            console.log(this.data);

            handleConvertLead({"convertLeadWrapperJSON":newWrap})

                .then(result => {
                    console.log(result);
                    this.convertWrap = result;
                    console.log(this.convertWrap);
                    if(this.convertWrap.convertedAccount) {
                        this.convertedAccountId = this.convertWrap.convertedAccount.Id;
                        this.hasAccount = true;
                        this.totalBoxes++;
                    }
                    if(this.convertWrap.convertedOpportunity) {
                        this.convertedOppId = this.convertWrap.convertedOpportunity.Id;
                        this.hasOpp = true;
                        this.totalBoxes++
                    }
                    if(this.convertWrap.convertedContact) {
                        if(this.totalBoxes < 2) {
                            this.hasContactTop = true;
                        } else {
                            this.hasContactBottom = true;
                        }
                        this.convertedContactId = this.convertWrap.convertedContact.Id;
                        this.hasContact = true;
                        this.totalBoxes++;
                    }
                    if(this.totalBoxes === 3) {
                        this.confirmClass = 'slds-p-around_medium slds-size_12-of-12 slds-medium-size_6-of-12 slds-large-size_4-of-12';
                    } else if(this.totalBoxes === 2) {
                        this.confirmClass = 'slds-p-vertical_medium slds-p-horizontal_large slds-size_12-of-12 slds-medium-size_6-of-12';
                    } else {
                        this.confirmClass = 'slds-p-vertical_medium slds-p-horizontal_xx-large slds-size_12-of-12';
                    }
                    this.isLoading = false;
                    this.convertedSuccess = true;

                    console.log('Yauhen ' + this.hasAccount);

                })
                .catch(error => {
                    this.error = error.message;
                    console.log(this.error);
                });
        }
    }

    handleClose() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Lead',
                actionName: 'view'
            }
        });
    }

    get valueForAccountCloseSection() {
        let value = 'Search for matching';

        if (this.selectedRecordLookupNameAccount != null && this.selectedRecordLookupNameAccount != undefined) {
            value = this.selectedRecordLookupNameAccount;
        }

        return value;
    }

    get valueForContactCloseSection() {
        let value = 'Search for matching';

        if (this.selectedRecordLookupNameContact != null && this.selectedRecordLookupNameContact != undefined) {
            value = this.selectedRecordLookupNameContact;
        }

        return value;
    }

    get valueForOppCloseSection() {
        let value = 'Search for matching';

        if (this.selectedRecordLookupNameOpp != null && this.selectedRecordLookupNameOpp != undefined) {
            value = this.selectedRecordLookupNameOpp;
        }

        return value;
    }
}