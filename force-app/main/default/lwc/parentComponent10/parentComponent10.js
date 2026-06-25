import { LightningElement } from 'lwc';

export default class ParentComponent10 extends LightningElement {
    showinggreeting_name;
    showinggreeting_email;

    handlegreeting(event) {
        // Access the specific name field inside the object
        this.showinggreeting_name = event.detail.name; 
        this.showinggreeting_email = event.detail.email;
    }
}
