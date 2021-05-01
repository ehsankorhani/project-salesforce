import { LightningElement } from 'lwc';

export default class JsSubscriber extends LightningElement {

    valueInp = '';

    connectedCallback() {
        window.addEventListener('message', this.handleMessage, false);
    }

    handleMessage = (e) => {
        //console.log('event', e.detail.value);
        //this.valueInp = e.detail.value;
    }

    disconnectedCallback() {
        window.removeEventListener('message', this.handleMessage, false);
    }

}