import { LightningElement, track } from 'lwc';

export default class LifecycleDemo extends LightningElement {
    counter = 0;
    isMessageVisible = false;

    constructor() {
        
        super();
        console.log('--- Lifecycle: constructor() executed ---');
     
    }

    connectedCallback() {
        console.log('--- Lifecycle: connectedCallback() executed ---');
        
    }

    renderedCallback() {
        console.log('--- Lifecycle: renderedCallback() executed ---');

    }

    handleIncrement() {
        this.counter += 1;
    }

    handleToggleMessage() {
        this.isMessageVisible = !this.isMessageVisible;
    }
}
