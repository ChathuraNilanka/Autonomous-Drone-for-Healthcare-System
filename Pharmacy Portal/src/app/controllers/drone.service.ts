
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
import { Delivery } from '../models/delivery.model';
import { AngularFirestore } from '@angular/fire/firestore';
import { environment } from 'src/environments/environment';

//handle drone related methods
@Injectable()
export class DroneService{
   
    uri = environment.droneUri;

    constructor( private httpClient: HttpClient,
        private afs: AngularFirestore){
            

    }

    // set delivery locetion of a delivery
    setLocetion( _delivery: Delivery){
        
        const headers = new HttpHeaders({
            'Content-Type': 'application/json'
          });

        const body=JSON.stringify(_delivery);

        return this.httpClient.post( this.uri + "setlocation", body, {'headers':headers});
    }

    // deploy the drone
    tackoff(){
        return this.httpClient.get(this.uri + "takeoff")
    }

    // get drone monitor details
    getInfo(){
        return this.httpClient.get(this.uri + "getinfo")
    }

    // package realse method
    release() {
        return this.httpClient.get(this.uri + "releasePackage")
      }

    // notify patient about the arrivel of the delivery
    setIsArrived(){
        this.afs.collection('isArrived').doc('drone1').update({"isArrived": true});
    }

}