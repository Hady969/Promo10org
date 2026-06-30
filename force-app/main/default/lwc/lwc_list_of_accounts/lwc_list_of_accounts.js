import getAllAccounts from '@salesforce/apex/AccountController.getAllAccounts';
import { LightningElement, wire, track} from 'lwc';


export default class wire_ex extends LightningElement {
    selectedRating='';
    get ratingOptions(){
         return [
            { label: 'All Ratings', value: 'All' },
            { label: 'Hot', value: 'Hot' },
            { label: 'Warm', value: 'Warm' },
            { label: 'Cold', value: 'Cold' }
        ];
    }
    @wire(getAllAccounts)
         accounts;

    get displayedAccounts() {
       
       if (this.accounts && this.accounts.data){
            if (this.selectedRating === 'All'){
                return this.accounts.data;
            }

            
            return this.accounts.data.filter(acc => acc.Rating === this.selectedRating);
        }
        return[];
    }

     displayAccount(event) {
        this.selectedRating = event.target.value;
    }

}