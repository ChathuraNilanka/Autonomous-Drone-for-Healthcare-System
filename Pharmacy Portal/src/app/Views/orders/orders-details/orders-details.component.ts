import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { OrderService } from 'src/app/controllers/orders.service';
import { Order } from 'src/app/models/order.model';
import { getDistance } from 'geolib';
import { ETAService } from 'src/app/controllers/ETA.service';
import { Delivery } from 'src/app/models/delivery.model';
import { WeatherService } from '../../../controllers/weather.service';


@Component({
  selector: 'app-orders-details',
  templateUrl: './orders-details.component.html',
  styleUrls: ['./orders-details.component.scss']
})
export class OrdersDetailsComponent implements OnInit {

  prescription: any = {};
  order: Order = {};
  orderid: string;
  lat: string;
  lng: string;
  s_lat: number = 6.93577;
  s_lng: number = 79.984703;
  prescription_id: string = "pid";
  distence: number;
  delivery: Delivery = {};
  ETA: number;
  status = "new";
  

  constructor(private router: Router,
    private route: ActivatedRoute,
    private oderService: OrderService,
    private _ETAService: ETAService,
    private weatherService: WeatherService) {
      
    this.delivery.propoler_size = 1;
    this.delivery.center = 1;

    this.getWeather();
  }

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      this.orderid = params.id;
      this.prescription_id = params.pid;
      this.oderService.getOrder(this.orderid).then((res: any) => {
        this.order = res.data();
        this.order.id = this.orderid;
        this.status = this.order.orderStatus;
        this.lat = this.order.location.latitude;
        this.lng = this.order.location.longitude;
        return { lat: this.lat, lng: this.lng }
      }).then((res) => {
        if (res) {
          console.log(res);
          this.distence = getDistance(
            { latitude: res.lat, longitude: res.lng },
            { latitude: this.s_lat, longitude: this.s_lng }
          )
        }
        return this.distence
      }).then((res) => {
        console.log(res);
      })
    });

  }

  acceptOrder() {
    this.oderService.acceptOrder(this.order);
    this.order.orderStatus = 'accepted';
    this.status  = 'accepted';
  }

  deployDrone() {
    this.oderService.deployOrder(this.orderid);
    this.order.orderStatus = 'onTheWay';
    this.router.navigate(["orders/", this.orderid, this.order.referecnceId, "monitor",this.order.location.latitude,this.order.location.longitude,this.delivery.alttitude])
  }

  monitorDrone() {
    this.router.navigate(["orders/", this.orderid, this.order.referecnceId, "monitor",this.order.location.latitude,this.order.location.longitude,this.delivery.alttitude])
  }

  // formating ETA obj
  calculateETA() {
    this.delivery.lat = this.order.location.latitude;
    this.delivery.long = this.order.location.longitude;
    this.delivery.distance = this.distence;

    var MIN_time = this.distence / this.delivery.max_speed
    this.delivery.ETA = MIN_time*2.5;
    console.log(this.delivery);
    this._ETAService.getETA(this.delivery).subscribe((res:any) => {
      var ETASqr = res.ETA*res.ETA;
      this.ETA = Math.sqrt(ETASqr);
    });
  }

  // get ETA from ETA service
  EnableETAButton(){
    if(this.delivery.max_speed && this.delivery.alttitude && this.delivery.weight&& this.delivery.wind_speed && this.delivery.humadity){
      return false;
    }
    else{
      return true;
    }
  }

  // get weather details from weather service
  getWeather(){
    this.weatherService.getWeatherDetails(6.93577,79.984703).subscribe((res: any)=>{
      this.delivery.humadity = res.main.humidity;
      this.delivery.wind_speed = res.wind.speed;
      console.log(res);
    });
  }

}
