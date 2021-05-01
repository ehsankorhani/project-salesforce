import { LightningElement } from 'lwc';
import messageChannel from '@salesforce/messageChannel/Sample__c';
import {publish, MessageContext, createMessageContext} from 'lightning/messageService'

export default class LmsPublisherWebComponent extends LightningElement {
    context = createMessageContext();

    handleButtonClick() {
        let message = {messageText: 'This is a test'};       
        publish(this.context, messageChannel, message);
    }
}