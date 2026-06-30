import { LightningElement } from 'lwc';

export default class lwc_extra_exercice_parent extends LightningElement {
   
    Selectionstring1;
    Selectionstring2;


    handleselection(event) {
        var Selection = event.detail;
        this.Selectionstring1 = this.Selection ? 'Selected' : 'Unselected';
    }


    handleselection2(event) {
        var Selection = event.detail;
        this.Selectionstring2 = this.Selection ? 'Selected' : 'Unselected';
    }
}
