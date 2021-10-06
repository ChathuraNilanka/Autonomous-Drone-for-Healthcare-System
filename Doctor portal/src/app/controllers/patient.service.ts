import { AngularFirestore } from '@angular/fire/firestore';
import { Injectable } from '@angular/core';
import { Patient, Doctor_Patient } from "../models/patients.model";
import * as firebase from 'firebase';
import { Patient_doctor } from '../models/doctor.model';

// this service is using to to manage patient related logistics operetions
@Injectable()
export class PatientService {

  doctorPatient: Doctor_Patient = {};
  patientDoctor: Patient_doctor = {}
  constructor(
    private afs: AngularFirestore
  ) { }

  // get patients of a doctor
  getPatients(docID) {
    const patientList: Patient[] = [];
    return this.afs.collection('doctor/' + docID + '/patients').valueChanges();
  }

  // send medical record access req to patiens
  sendRequest(nic: string, docID: string) {

    return this.checkExistence(nic, docID).then( res => 
      {
        if(res){
          return firebase.firestore().collection('patients').where('nic', '==', nic).get().then(snap => {
            if (snap.docs.length > 0) {
              // formating patient obj
              this.doctorPatient.pid = snap.docs[0].id;
              this.doctorPatient.name = snap.docs[0].data().displayName;
              this.doctorPatient.mobileNumber = snap.docs[0].data().mobileNumber;
              this.doctorPatient.email = snap.docs[0].data().email;
              this.doctorPatient.nic = nic;
              this.doctorPatient.status = "pending";
      
              // add patient to the patient list of the doctor
              this.addToPatientsDocLList(this.doctorPatient.pid, docID);
      
              try {
                this.afs.collection('doctor/' + docID + '/patients').add(this.doctorPatient);
              } catch (err) {
                console.log(err);
                return false;
              }
              return true;
            } else {
              return false;
            }
          })
        }else 
          return new Promise(()=>{
            return false;
          })
      });
  }

  addToPatientsDocLList(pID, docID) {
    this.afs.collection('doctor').doc(docID).get().toPromise().then(res => {

      // formating patient obj
      this.patientDoctor.docID = docID;
      this.patientDoctor.mbbs = res.data().mbbs || null;
      this.patientDoctor.name = res.data().name || null;
      this.patientDoctor.nic = res.data().nic || null;
      this.patientDoctor.specialty = res.data().specialty || null;
      this.patientDoctor.status = "pending";
      try {
        this.afs.collection('patients/' + pID + '/doctors').add(this.patientDoctor);
      } catch (err) {
        console.log(err);
        return false;
      }
    })

  }

  // check existens of a patient 
  checkExistence(nic: string, docID: string) {
    return firebase.firestore().collection('doctor/' + docID + '/patients').where('nic', '==', nic).get().then(snap => {
      if (snap.docs.length > 0) {
        return false;
      } else {
        return true;
      }
    })
  }

  // get details of one patient
  getPatient(pid: string){
    return this.afs.collection('patients').doc(pid).valueChanges();
  }

}