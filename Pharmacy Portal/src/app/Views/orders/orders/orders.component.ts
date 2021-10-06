import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { analytics } from 'firebase';
import { OrderService } from 'src/app/controllers/orders.service';
import { Order } from 'src/app/models/order.model';

@Component({
  selector: 'app-orders',
  templateUrl: './orders.component.html',
  styleUrls: ['./orders.component.scss']
})
export class OrdersComponent implements OnInit {

  orders: Order[] = [];
  cols: { field: string; header: string; }[];

  constructor( private orderService: OrderService,
               private router: Router,) {

    //order table colume structure 
    this.cols = [
      { field: 'patientName', header: 'Patient Name' },
      { field: 'contactNum', header: 'Contact Number' },
      { field: 'orderStatus', header: 'Order Status' },
      { field: 'createdAt', header: 'Date' }
    ];
  }

  ngOnInit(): void {
    this.getOrders();
  }

  getOrders(){
    this.orderService.getOrders().subscribe( res => {
      res.forEach( item => {
        var order: Order={};
        var _item : any = item
  
        order = _item.data();
        order.id = _item.id;
        this.orders.push(order);
      })
    });
  }
  
  //navigate to the order detail page 
  nav_details(rowData:Order){
    console.log(rowData);
    this.router.navigate(["orders/",rowData.id, rowData.referecnceId ])
  }
}
