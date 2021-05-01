import { LightningElement } from 'lwc';
import messageChannel from '@salesforce/messageChannel/Sample__c';
import { subscribe, MessageContext, createMessageContext } from 'lightning/messageService';

export default class LmsSubscriberWebComponent extends LightningElement {

    messageText = '';
    context = createMessageContext();

    connectedCallback() {
        this.handleSubscribe();
    }

    handleSubscribe() {
        if (this.subscription) {
            return;
        }
        this.subscription = subscribe(this.context, messageChannel, (message) => {
            console.log(message.messageText);
            this.messageText = message.messageText;
        });
    }

}