import { LightningElement } from 'lwc';

export default class ChildComponent10 extends LightningElement {
    selectedContact = {
        name: 'John Doe',
        email: 'john.doe@email.com',
        phone: '123-456-7890'
    };
    
    // Fires on button click
    handleClick() {
        const event = new CustomEvent('myevent', {
            detail: this.selectedContact
        });
        this.dispatchEvent(event);
    }
}
