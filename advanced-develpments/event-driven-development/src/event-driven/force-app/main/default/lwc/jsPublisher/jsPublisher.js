import { LightningElement } from 'lwc';

export default class JsPublisher extends LightningElement {
    item = '';

    changeHandler(event) {
        this.item = event.target.value;
    }

    publishEvent() {
        console.log('published message:', this.item);

        const event = new CustomEvent('message', {
            detail: {
                value: this.item
            },
            bubbles: true
        });

        this.dispatchEvent(event);
    }
}