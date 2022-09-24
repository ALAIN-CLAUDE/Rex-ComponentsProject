/**
 * Created by EvgeniyMalahovskiy on 8/25/2022.
 */

import {LightningElement, track, api} from 'lwc';
import {NavigationMixin} from "lightning/navigation";

export default class ConvertLeadSuccessScreen extends NavigationMixin(LightningElement) {
    @api
    convertWrap;

    goToAccount(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.convertWrap.convertedAccount.Id,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

    goToOpp(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.convertWrap.convertedOpportunity.Id,
                objectApiName: 'Opportunity',
                actionName: 'view'
            }
        });
    }

    goToContact(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.convertWrap.convertedContact.Id,
                objectApiName: 'Contact',
                actionName: 'view'
            }
        });
    }
}