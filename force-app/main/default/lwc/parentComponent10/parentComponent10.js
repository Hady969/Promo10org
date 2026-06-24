import { LightningElement, api } from 'lwc';
export default class parentComponent10 extends LightningElement {
    showinggreeting ;
    handlegreeting(event){
        this.showinggreeting = event.detail;
    }
}