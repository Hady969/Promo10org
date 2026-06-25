import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import { LightningElement, wire } from 'lwc';

export default class wire_ex extends LightningElement {
    numberOfAccounts = 1;
    @wire(getAccounts, { numberOfAccounts: '$numberOfAccounts' })
         accounts;
    handleNumberOfAccountsChange(event) {
       
        this.numberOfAccounts = event.target.value;
    }

}