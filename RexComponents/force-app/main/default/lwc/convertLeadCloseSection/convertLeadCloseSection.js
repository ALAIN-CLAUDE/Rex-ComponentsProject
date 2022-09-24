/**
 * Created by EvgeniyMalahovskiy on 8/23/2022.
 */

import {api, LightningElement} from 'lwc';

export default class ConvertLeadCloseSection extends LightningElement {
    @api
    currentObject;
    @api
    valueForInput;
    @api
    valueForInputName;
    @api
    disableRadioButton = false
    @api
    createNewAccountToggle = false;
    @api
    chooseExistingToggle = false;

    handleToggleAccount() {
        this.createNewAccountToggle = !this.createNewAccountToggle;
        this.chooseExistingToggle = !this.chooseExistingToggle;
        this.handleClick();
    }

    handleClick() {
        let paramData = {
            currentObject : this.currentObject,
            createNewToggle : this.createNewAccountToggle,
            chooseExistingToggle : this.chooseExistingToggle
        };
        let ev = new CustomEvent('callclosesection',
            {detail : paramData}
        );
        this.dispatchEvent(ev);
    }
}