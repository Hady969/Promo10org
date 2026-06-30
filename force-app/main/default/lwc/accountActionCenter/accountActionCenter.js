import { LightningElement, api, track, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllAccounts from '@salesforce/apex/AccountController.getAllAccounts';
import { NavigationMixin } from 'lightning/navigation';

const COLUMNS = [
    { 
        label: 'Name', 
        fieldName: 'accountUrl', 
        type: 'url', 
        typeAttributes: { 
            label: { fieldName: 'Name' }, 
            target: '_blank' 
        } 
    },
    { label: 'Rating', fieldName: 'Rating', type: 'text' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Description', fieldName: 'Description', type: 'text' }
];

export default class AccountFilter extends NavigationMixin(LightningElement) {
    @track displayedAccounts = [];
    @track selectedAccount = null;
    @api recordId;
    
    newDescription = '';
    columns = COLUMNS;
    buttonLabel = 'All';

    get isUpdateDisabled() {
        return !this.newDescription || this.newDescription.trim() === '';
    }

    @wire(getAllAccounts, { buttonLabel: '$buttonLabel' })
    async wiredAccounts({ error, data }) {
        if (data) {
            try {
                this.selectedAccount = null;

                const processedAccounts = await Promise.all(
                    data.map(async (acc) => {
                        const url = await this[NavigationMixin.GenerateUrl]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: acc.Id,
                                actionName: 'view',
                            },
                        });
                        return { ...acc, accountUrl: url };
                    })
                );

                switch (this.buttonLabel) {
                    case 'Hot':
                        this.displayedAccounts = processedAccounts.filter(acc => acc.Rating && acc.Rating.toLowerCase() === 'hot');
                        break;
                    case 'No Phone':
                        this.displayedAccounts = processedAccounts.filter(acc => !acc.Phone || acc.Phone.trim() === '');
                        break;
                    case 'Last 10 Accounts':
                        this.displayedAccounts = processedAccounts.slice(-10);
                        break;
                    default:
                        this.displayedAccounts = processedAccounts;
                }
            } catch (err) {
                this.showToast('Error', 'An error occurred while fetching records.', 'error');
            }
        } else if (error) {
            this.showToast('Error', 'An error occurred while fetching records.', 'error');
        }
    }

    handleAccountAction(event) {
        this.buttonLabel = event.target.label;
    }

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        if (selectedRows.length > 0) {
            this.selectedAccount = selectedRows[0];
            this.newDescription = this.selectedAccount.Description || '';
        } else {
            this.selectedAccount = null;
        }
    }

    handleDescriptionChange(event) {
        this.newDescription = event.target.value;
        debugger;
    }

    async handleUpdateDescription() {
        const fields = {};
        fields['Id'] = this.selectedAccount.Id;
        fields['Description'] = this.newDescription;

        const recordInput = { fields };

        try {
            await updateRecord(recordInput);
            this.showToast('Success', 'Account description updated successfully.', 'success');
            
            this.selectedAccount = { ...this.selectedAccount, Description: this.newDescription };
            this.displayedAccounts = this.displayedAccounts.map(acc => {
                if (acc.Id === this.selectedAccount.Id) {
                    return { ...acc, Description: this.newDescription };
                }
                return acc;
            });
        } catch (error) {
            this.showToast('Error Updating Record', error.body.message, 'error');
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
