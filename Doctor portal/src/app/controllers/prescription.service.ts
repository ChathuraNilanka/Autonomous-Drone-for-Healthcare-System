import { AngularFirestore } from '@angular/fire/firestore';
import { Injectable } from '@angular/core';
import { Prescription } from '../models/prescription.model';

// this service is using to to manage prescription related logistics operetions
@Injectable()
export class PrescriptionService{

constructor(
    private afs: AngularFirestore
){}

addPrescription(prescription: Prescription){
    return this.afs.collection('prescription').add( prescription ).then(res => {
        console.log(res);
    }).catch(err=>{
        console.log(err);
    })
}

// use to get doctors prescriptions of a one patient
getPrescriptions( patientId: string){
  return this.afs.collection('prescription',  ref => ref.where('patientId', '==', patientId)).get();
}

// use to get doctors all prescriptions
getDocMyPrescriptions( DocId: string){
    return this.afs.collection('prescription',  ref => ref.where('docId', '==', DocId)).get();
}


}