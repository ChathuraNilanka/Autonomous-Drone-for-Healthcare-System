import { Injectable } from '@angular/core';

import { Message } from 'primeng/primeng';

// use to manage alerts, comfime msg and warnings
@Injectable()
export class MessageService {

    public msgs: Message[] = [];

    showSuccess(msg: string) {
        this.msgs = [];
        this.msgs.push({ severity: 'success', summary: 'Success!', detail: msg });
    }

    showInfo(msg: string) {
        this.msgs = [];
        this.msgs.push({ severity: 'info', summary: 'Information!', detail: msg });
    }

    showWarn(msg: string) {
        this.msgs = [];
        this.msgs.push({ severity: 'warn', summary: 'Warning!', detail: msg });
    }

    showError(msg: string) {
        this.msgs = [];
        this.msgs.push({ severity: 'error', summary: 'Error!', detail: msg });
    }

    clear() {
        this.msgs = [];
    }
}
