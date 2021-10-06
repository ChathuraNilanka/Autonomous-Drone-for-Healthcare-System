import { AngularFirestore } from '@angular/fire/firestore';
import { Injectable } from '@angular/core';
import { Doctor } from '../models/doctor.model';

import { CookieService, CookieOptions } from 'angular2-cookie/core';
import { AngularFireAuth } from '@angular/fire/auth';
import { MedicineItem } from '../models/medicine.model';

// this service is use to manage doctors prescription and patient related functions
@Injectable()
export class DoctorSevice {

    constructor(private afs: AngularFirestore,
        private cookieService: CookieService,
        private firebaseAuth: AngularFireAuth) {

    }

    updatedoctor(docObj: Doctor) {

        this.firebaseAuth.auth.currentUser.updateEmail(docObj.email).then(res => {
            this.afs.collection('doctor').doc(docObj.id).update(
                {
                    mobileNumber: docObj.mobileNumber,
                    email: docObj.email,
                    bio: docObj.bio,
                }
            ).then(res => {
                this.cookieService.putObject('doc', docObj);
            }).catch(err => {
                console.log(err);
                return false;
            })
        }).catch(err => {
            console.log(err);
        });

    }

    // use to get doctors time table 
    getTimeTable(docID: string) {
        return this.afs.collection('doctor/' + docID + '/timeTable').valueChanges();
    }

    // use to get the medicines from doctors quick list
    getMedicine(docID: string) {
        return this.afs.collection('doctor/' + docID + '/medicine').valueChanges();
    }

    // use to add medicines to doctors quick list
    addMedicine(docId, medicine: MedicineItem) {
        return this.afs.collection('doctor/' + docId + '/medicine').add(medicine);

    }

}