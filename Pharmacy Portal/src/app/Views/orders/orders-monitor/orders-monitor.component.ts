import { Component, OnInit } from '@angular/core';
import { DroneService } from 'src/app/controllers/drone.service';
import { interval, Observable, Subscription } from 'rxjs';
import { SetLocetion, Trip } from 'src/app/models/trip.model';
import { ActivatedRoute, Router } from '@angular/router';
import { THIS_EXPR } from '@angular/compiler/src/output/output_ast';
import { OrderService } from 'src/app/controllers/orders.service';

@Component({
  selector: 'app-orders-monitor',
  templateUrl: './orders-monitor.component.html',
  styleUrls: ['./orders-monitor.component.scss']
})
export class OrdersMonitorComponent implements OnInit {

  s_lat: number = 6.93577;
  s_lng: number = 79.984703;
  trip: Trip = {};
  _locetion: SetLocetion = {};
  disableDeploy = true;
  speed: number= 0;
  orderId: number;
  getInfor_sub: Subscription;
  subsribe: boolean;

  constructor(private droneService: DroneService,
              private route: ActivatedRoute,
              private oderService: OrderService) {

                this.route.params.subscribe( (params) => {
                  this.orderId = params.id;
                  this._locetion.lat = params.lat;
                  this._locetion.lon = params.lon;
                  this._locetion.alt = params.alt;
                })

                this.disableDeploy = true;

  }

  ngOnInit(): void {
    this.getInfor_sub = this.getInfoInterval();
  }

  setLocetion() {

    var deliveryObj = {
      "lat": this._locetion.lat,
      "lon": this._locetion.lon,
      "alt": this._locetion.alt
    }
    this.droneService.setLocetion(deliveryObj).subscribe((res) => {
      this.disableDeploy = false;
      console.log(res);
    });
  }

  getInfo() {
    this.droneService.getInfo().subscribe((res) => {
      console.log(res);
    })
  }

  Deploy() {
    this.droneService.tackoff().subscribe(res => {
      console.log(res);
    })
  }

  // use to get drone details in every 3000 milisec and ubdate the db
  getInfoInterval() {
    return interval(3000).subscribe(x => this.droneService.getInfo().subscribe((res) => {
      this.trip = res;
      this.updateLocetion(this.trip.lat, this.trip.lon);
      this.s_lat = this.trip.lat;
      this.s_lng - this.trip.lon;
      if(this.trip.isArrived){
        this.droneService.setIsArrived();
      }
      console.log(res);
      this.speed = this.calculateSpeed(this.trip.velocity);
      this.subsribe = true;
    }))
  }

  Release(){
    this.droneService.release().subscribe((res)=>{
      console.log(res);
    });
  }

  // use to calculate th drone velocity using the drone api obj
  calculateSpeed(velocity){
    var st = velocity[0];
    var nd = velocity[1];
    var rd = velocity[2];

    st = Math.abs(st);
    nd = Math.abs(nd);
    rd = Math.abs(rd);

    return (st+nd+rd)/3;
  }

  updateLocetion(lat, long){
    this.oderService.updateLiveLocetion(this.orderId, lat, long);
  }

  unsub_getInfo(){
    this.getInfor_sub.unsubscribe();
    this.subsribe = false;
  }

  setSubObj(){
    this.getInfor_sub = this.getInfoInterval();
  }


}
