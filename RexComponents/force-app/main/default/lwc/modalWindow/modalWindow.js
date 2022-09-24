/**
 * Created by EvgeniyMalahovskiy on 8/31/2022.
 */

import {api, LightningElement} from 'lwc';
const KEYUP = 'keyup';
const SLDS_MODAL_FOOTER = 'slds-modal__footer';
const HIDE_MODAL_WINDOW = 'hidemodalwindow';
const SHOW_MODAL_WINDOW = 'showmodalwindow';


export default class ModalWindow extends LightningElement {

    @api modalHeader = '';
    @api subHeader = '';
    @api showModal = false;
    @api showSpinner = false;
    @api spinnerSize;
    @api isOverflowContent = "false";
    @api dontShowCloseIcon = false;

    slotFooterClass = '';

    //render modal window
    renderedCallback() {
        if (this.isOverflowContent === "true") {
            let modalContent = this.template.querySelector('.slds-modal__content');
            if (modalContent) {
                modalContent.classList.add('overflowContent');
            }
        }
    }

    //use for close modal
    @api
    closeModalWindow() {
        window.removeEventListener( KEYUP, function() {}, false);
        this.showModal = false;
        this.dispatchEvent(new CustomEvent(HIDE_MODAL_WINDOW));
        //Sends event to window too so that parent component can listen and reset the value
        window.dispatchEvent(new CustomEvent(HIDE_MODAL_WINDOW));
    }

    //use for show modal
    @api
    showModalWindow() {
        let self = this;
        this.showModal = true;

        window.addEventListener(KEYUP, function(event) {
            if (event.keyCode === 27) {
                window.removeEventListener(KEYUP, function() {}, false);
                self.showModal = false;
            }
        }, false);

        this.dispatchEvent(new CustomEvent(SHOW_MODAL_WINDOW));
    }

    //assign footer element
    handleFooterSlotChange(event) {
        this.slotFooterClass = this.showModal && event.target.assignedElements().length !== 0
            ? SLDS_MODAL_FOOTER
            : '';
    }
}