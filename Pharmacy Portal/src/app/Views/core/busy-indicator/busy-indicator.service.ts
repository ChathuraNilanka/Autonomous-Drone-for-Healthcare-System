import { Injectable } from '@angular/core';
import { Subject } from 'rxjs/internal/Subject';
import { BusyOperation } from './busy-indicator.model';

@Injectable()
export class BusyIndicatorService {
  busyChange: Subject<boolean> = new Subject<boolean>();

  startOperation(): BusyOperation {
    const operation = new BusyOperation();


    // if (!operation.isCompleted) {
    //  this.busyChange.next(true);
    // }

    // Do not indicate busy status unless the operation has been running for some time.
    // (This will make busy indicator invisible for quick operations)
    setTimeout(
      () => {
        if (!operation.isCompleted) {
          this.busyChange.next(true);
        }
      },
      150,
      operation
    );

    return operation;
  }

  endOperation(operation: BusyOperation) {
    operation.isCompleted = true;
    this.busyChange.next(false);
  }
}
