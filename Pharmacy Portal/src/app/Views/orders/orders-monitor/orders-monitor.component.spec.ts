import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { OrdersMonitorComponent } from './orders-monitor.component';

describe('OrdersMonitorComponent', () => {
  let component: OrdersMonitorComponent;
  let fixture: ComponentFixture<OrdersMonitorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ OrdersMonitorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(OrdersMonitorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
