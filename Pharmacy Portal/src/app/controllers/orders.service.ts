import { AngularFirestore } from '@angular/fire/firestore';
import { Injectable } from '@angular/core';
import * as firebase from 'firebase';
import { Order } from '../models/order.model';

// use to handle Order related logic
@Injectable()
export class OrderService {
  orders: Order = {}

  // initialize afs as angularfirestore obj
  constructor(
    private afs: AngularFirestore
  ) { }

  // return All the orders from the patients as observerble
  getOrders() {
    return this.afs.collection('order').get();
  }


  // return All the orders from the patients as promiss
  async getOrder(oid: string){
    return await this.afs.collection('order').doc(oid).get().toPromise();
  }

  // accept order by seting a price to the order
  acceptOrder(order: Order){
    this.afs.collection('order').doc(order.id).update({"orderStatus" : 'accepted',"amount": order.amount});
  }

  // use to change order ststus as deploy
  deployOrder(oid) {
    this.afs.collection('order').doc(oid).update({"orderStatus" : 'onTheWay'});
  }

  // use to update Delivery locetion of a delivery
  updateLiveLocetion(oid,lat, long){
    var _location =  new firebase.firestore.GeoPoint(lat, long);
    this.afs.collection('order').doc(oid).update({"liveTrack": _location});
  }

}