/* eslint-disable no-console */
// Import LightningElement and api classes from lwc module
import { LightningElement, api, wire, track } from 'lwc';
// import getPicklistValues method from lightning/uiObjectInfoApi
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
// import getObjectInfo method from lightning/uiObjectInfoApi
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
// Import lead object APi from schema
import LEAD_OBJECT from '@salesforce/schema/Lead';
// import Lead status field from schema
import PICKLIST_FIELD from '@salesforce/schema/Lead.Status';
// import record ui service to use crud services
import { getRecord } from 'lightning/uiRecordApi';
// import show toast
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import update record api
import { updateRecord } from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";

import updateReason from '@salesforce/apex/LeadCustomPathController.updateReason';


const FIELDS = [
    'Lead.Id',
    'Lead.Status'
];


export default class LeadCustomPath extends NavigationMixin(LightningElement) {

    @track selectedValue;
    @api recordId;
    @track showSpinner = false;

    @wire(getObjectInfo, { objectApiName: LEAD_OBJECT })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: PICKLIST_FIELD })
    picklistFieldValues;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    record;

    @track
    currentValue;

    get unQualifiedOptions() {
        return [
            { label: 'Not Interested', value: 'Not Interested' },
            { label: 'Not Accredited', value: 'Not Accredited' },
            { label: 'No Budget', value: 'No Budget' }
        ];
    }

    showQualified = false;

    selectedReason;

    updateReason = false;


    get picklistValues() {
        let itemsList = [];
        if (this.record.data) {
            if (!this.selectedValue && this.record.data.fields.Status.value) {
                this.selectedValue = this.record.data.fields.Status.value + '';
            }
            if (this.picklistFieldValues && this.picklistFieldValues.data && this.picklistFieldValues.data.values) {
                console.log('got picklist field data');
                let selectedUpTo = 0;
                let stopSelect = false;
                for (let item in this.picklistFieldValues.data.values) {

                    if (Object.prototype.hasOwnProperty.call(this.picklistFieldValues.data.values, item)) {
                        let classList;

                        if (this.picklistFieldValues.data.values[item].value === this.selectedValue) {
                            classList = 'slds-path__item slds-is-current slds-is-active';
                            stopSelect = true;
                        } else {
                            classList = 'slds-path__item slds-is-incomplete';
                        }

                        if (!stopSelect) {
                            selectedUpTo++;
                        }

                        console.log(classList);

                        itemsList.push({
                            pItem: this.picklistFieldValues.data.values[item],
                            classList: classList
                        })
                    }
                }

                if (selectedUpTo > 0) {
                    console.log('Up Yauhen', selectedUpTo)
                    for (let item = 0; item < selectedUpTo; item++) {
                        itemsList[item].classList = 'slds-path__item slds-is-complete';
                    }
                }
                console.log('im here = ' + this.selectedValue);
                return itemsList;
            }
        }
        return null;
    }

    handleSelect(event) {
        console.log('in the function', event.currentTarget.dataset.value);
        this.selectedValue = event.currentTarget.dataset.value;
    }

    handleMarkAsSelected() {
        this.showSpinner = true;
        const fields = {};
        fields.Id = this.recordId;
        fields.Status = this.selectedValue;

        if (this.selectedValue == 'Qualified') {
            this.navigateToComponent();
        } else if (this.selectedValue == 'Unqualified' && !this.updateReason ) {
            this.showSpinner = false;
            this.updateReason = true;
            this.template.querySelector('c-modal-window').showModalWindow();
        } else {
            this.updateReason = false;
            const recordInput = { fields };

            updateRecord(recordInput)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Status Updated!',
                            variant: 'success'
                        })
                    );
                    console.log('success!');
                })
                .catch(
                    error => {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error updating status!',
                                message: error.body.message,
                                variant: 'error'
                            })
                        );
                        console.log('failure => ' + error.body.message);
                    }
                );
            this.showSpinner = false;
        }


    }

    navigateToComponent() {
        let paramData = {Name:this.Name, City:this.City};//JSON.parse({Name:this.Name, City:this.City});
        let ev = new CustomEvent('childmethod'
        );
        this.dispatchEvent(ev);

        this.showSpinner = false;
    }

    handleCloseModal() {
        this.selectedReason = null;
        this.template.querySelector('c-modal-window').closeModalWindow();
    }

    handleSubmit() {
        this.showSpinner = true;

        try {
            updateReason({'recordId':this.recordId, 'reason' : this.selectedReason})
                .then(result => {
                    this.handleMarkAsSelected();
                    this.handleCloseModal();
                })
                .catch(error => {
                    this.error = error.message;

                    console.log(this.error);
                });
        } catch (e) {
            console.log('ddddddddddddddddddddddddddd',e)
        }

        this.showSpinner = false;
    }

    handleChangeReason(event) {
        this.selectedReason = event.detail.value;
    }

    get disable() {
        let isDisable = true;

        if (this.selectedReason != null && this.selectedReason != undefined) {
            isDisable = false;
        }

        return isDisable;
    }
}