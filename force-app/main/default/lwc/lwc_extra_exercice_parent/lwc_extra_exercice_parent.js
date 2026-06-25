import { LightningElement } from 'lwc';

export default class lwc_extra_exercice_parent extends LightningElement {
    Selection1;
    Selection2;
    Selectionstring1;
    Selectionstring2;


    handleselection(event) {
        this.Selection1 = event.detail;
        this.Selectionstring1 = this.Selection1 ? 'Selected' : 'Unselected';
    }


    handleselection2(event) {
        this.Selection2 = event.detail;
        this.Selectionstring2 = this.Selection2 ? 'Selected' : 'Unselected';
    }
}
