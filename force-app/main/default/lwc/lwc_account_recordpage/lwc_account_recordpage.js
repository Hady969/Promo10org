import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import RECORD_TYPE_ID_FIELD from '@salesforce/schema/Account.RecordTypeId';

export default class MyComponent extends LightningElement {

    @api recordId; 
    
    recordTypeId;
    @track ratingOptions = [];

    @wire(getRecord, { recordId: '$recordId', fields: [RECORD_TYPE_ID_FIELD] })
    wiredAccount({ error, data }) {
        if (data) {

            this.recordTypeId = data.fields.RecordTypeId.value;


        } else if (error) {
            console.error('Error fetching record:', error);
        }
    }

    @wire(getPicklistValuesByRecordType, { objectApiName: ACCOUNT_OBJECT, recordTypeId: '$recordTypeId' })
    wiredPicklistValues({ error, data }) {
        if (data) {
           
            if (data.picklistFieldValues && data.picklistFieldValues.Rating) {
                const rawValues = data.picklistFieldValues.Rating.values;
                this.processPicklistValues(rawValues);
            }
        } else if (error) {
            console.error('Error fetching picklist values:', error);
        }
    }

    
    processPicklistValues(valuesArray) {
      
        this.ratingOptions = valuesArray.map(picklistOption => {
            return {
                label: picklistOption.label,
                value: picklistOption.value
            };
        });

        console.log('Filtered Rating Picklist Values:', JSON.stringify(this.ratingOptions));
        
        this.myCustomFunction(this.ratingOptions);
    }

    myCustomFunction(dataArray) {
        console.log('Array received in custom function. Length:', dataArray.length);
    }
}
