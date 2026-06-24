import {LightningElement,api} from 'lwc';
export default  class childComponent10 extends LightningElement {

   selectedContact = {
     name: 'John Doe',
     email: 'John.Doe@emial.com',
     phone: '123-456-7890'
   };
    
      connectedCallback() {
         const event = new CustomEvent('myevent', {
            detail: this.selectedContact});

      this.dispatchEvent(event);

}
}