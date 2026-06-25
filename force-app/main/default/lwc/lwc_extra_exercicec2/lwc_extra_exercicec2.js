import { LightningElement } from 'lwc';

export default class lwc_extra_exercicec2 extends LightningElement {
    isSelected = false;


    get buttonLabel() {
        return this.isSelected ? 'Selected' : 'Unselected';
    }
    
    child_selection() {

        this.isSelected = !this.isSelected;


        const event = new CustomEvent('myevent_2', {
            detail: this.isSelected
        });
        this.dispatchEvent(event);
    }
}
