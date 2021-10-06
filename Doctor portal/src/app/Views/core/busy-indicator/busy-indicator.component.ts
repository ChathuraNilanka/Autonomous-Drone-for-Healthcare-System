import { Component, OnInit } from '@angular/core';
import { Subscription } from 'rxjs/internal/Subscription';
import { BusyIndicatorService } from './busy-indicator.service';

@Component({
  selector: 'busy-indicator',
  templateUrl: './busy-indicator.component.html',
  styleUrls: ['./busy-indicator.component.scss']
})
export class BusyIndicatorComponent implements OnInit {
  subscription: Subscription;
  busyCount = 0;

  constructor(private busyIndicatorService: BusyIndicatorService) {}

  ngOnInit() {
    this.subscribeToBusyChanges();
  }

  subscribeToBusyChanges() {
    this.subscription = this.busyIndicatorService.busyChange.subscribe(isBusy => {
      if (isBusy) {
        this.busyCount++;
      } else if (this.busyCount > 0) {
        this.busyCount--;
      }
    });
  }

  ngOnDestroy() {
    this.subscription.unsubscribe();
  }
}
