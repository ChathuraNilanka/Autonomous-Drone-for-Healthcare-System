
import { from, Observable } from 'rxjs';
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
import { Delivery } from '../models/delivery.model';
import { environment } from 'src/environments/environment';

@Injectable()
export class ETAService{

    uri = environment.ETAUri

    constructor( private httpClient: HttpClient){

    }

    // get predicted ETA Value
    getETA( _delivery: Delivery){
        return this.httpClient.get(this.uri +'?lat='+ _delivery.lat +'&long='+ _delivery.long +'&distance='+ _delivery.distance +'&humadity='+ _delivery.humadity +'&wind_speed='+ _delivery.wind_speed +'&propoler_size='+ _delivery.propoler_size +'&altitude='+ _delivery.alttitude +'&weight='+ _delivery.weight +'&ETA='+ _delivery.ETA +'&max_speed='+ _delivery.max_speed +'&center=1');
    }


}