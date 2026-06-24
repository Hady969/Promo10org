import { LightningElement, track } from 'lwc';

export default class Lwc_listofemp extends LightningElement {
    @track empsobjs = [];

    username = '';
    email = '';
    age = '';

    handleInputChange(event) {
        const field = event.target.name;
        
        if (field === 'employee_name') {
            this.username = event.target.value;
        } else if (field === 'user-email') {
            this.email = event.target.value;
        } else if (field === 'user-age') {
            this.age = event.target.value;
        }
    }

    handleFormSubmit(event) {
        event.preventDefault();

        const newEmployee = {
            id: Date.now().toString(),
            username: this.username,
            email: this.email,
            age: this.age
        };

        this.empsobjs = [...this.empsobjs, newEmployee];

        this.username = '';
        this.email = '';
        this.age = '';

        this.template.querySelector('form').reset();
    }
       handleDelete(event) {
        const targetId = event.target.dataset.id;

        this.empsobjs = this.empsobjs.filter(emp => emp.id !== targetId);
    }
}
