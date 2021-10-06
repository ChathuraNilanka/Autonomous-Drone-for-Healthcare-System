import { Component, OnInit, ChangeDetectorRef, ViewChild } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { PatientService } from 'src/app/controllers/patient.service';
import { Patient } from 'src/app/models/patients.model';
import * as moment from 'moment';
import { OCRService } from 'src/app/controllers/ocr.service';
import { PrescriptionService } from 'src/app/controllers/prescription.service';
import { Prescription } from '../../../models/prescription.model';
import { CookieService } from 'angular2-cookie/core';
import { Doctor } from 'src/app/models/doctor.model';
import { ModalContainerComponent } from 'angular-bootstrap-md';
import { ImgService } from '../../../controllers/image.service';
import { DoctorSevice } from 'src/app/controllers/doctor.service';
import { MedicineItem } from 'src/app/models/medicine.model';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.scss']
})
export class ProfileComponent implements OnInit {

  @ViewChild('prescriptionModal', { static: true }) prescriptionModal: ModalContainerComponent; //prescription model

  cols: any[];
  uplo: File;

  pid: string;
  patient: Patient = {};
  DOB: string = "";
  age: number;
  uploadedFile: any;
  uploErr: boolean;
  prescriptionTxt: string = '';
  prescriptions: Prescription[] = [];
  today = new Date();
  expDate: any;
  repeat = false;
  imgRef: string = "";
  emptyErr = false;
  medicine: unknown[];
  _medicineItem: MedicineItem = {};

  constructor(private route: ActivatedRoute,
    private petientService: PatientService,
    private ocrService: OCRService,
    private prescriptionService: PrescriptionService,
    private doctorService: DoctorSevice,
    private cookiService: CookieService,
    private imgService: ImgService) {
    this.patient.proPic = "";
    this.route.params.subscribe(params => {
      this.pid = params.pid;
    });

    this.petientService.getPatient(this.pid).subscribe((res) => {
      this.patient = res;
      this.age = this.ageCal(this.patient.birthday);
      console.log(this.patient);
    });

    this.getPrescriptions(this.pid);

    console.log(this.prescriptions);
  }

  ngOnInit(): void {
    this.cols = [
      { field: 'docName', header: 'Doctor Name' },
      { field: 'createdAt', header: 'Date' },
      { field: 'prescription', header: 'Prescription' }
    ];

    this.getMedicine();

  }


  // age calculation from dob
  ageCal(dob) {
    let db = dob.toDate();
    return moment().diff(db, 'years');
  }

  // add prescriptions to patients acc
  addPrescription() {
    this.emptyErr = false;
    if(this.prescriptionTxt){
    var prescrition: Prescription = {};
    var docObj: Doctor = this.cookiService.getObject('doc') || null;
    
    // formatting prescription obj
    prescrition.docId = docObj.id;
    prescrition.docName = docObj.name;
    prescrition.patientId = this.patient.id;
    prescrition.patientName = this.patient.name;
    prescrition.expDate = this.expDate;
    prescrition.createdAt = new Date;
    prescrition.repeat = this.repeat;
    prescrition.status = "new";
    prescrition.prescription = this.prescriptionTxt;

    this.prescriptionService.addPrescription(prescrition).then(res=>{
      this.prescriptionTxt = "";
      this.repeat = false;
      this.expDate = null;
    });

    this.prescriptions = [];

    // calling get prescriptions to ubdate the prescription table

    this.getPrescriptions(this.patient.id);
    this.prescriptionModal.hide();
    } else {
      this.emptyErr = true;
    }
  }

  // get prescriptions to make prescription table
  getPrescriptions(pid) {
    this.prescriptionService.getPrescriptions(pid).subscribe(res => {
      res.forEach(item => {
        var prescrition: Prescription = {};

        prescrition = item.data();
        prescrition.id = item.id;
        this.prescriptions.push(prescrition);
      })
    });
  }

  // get pro pic
  getProfilePicURL() {
    this.imgRef = <string>this.imgService.getImg();
    console.log("this" + this.imgRef.toString());
  }

  prescriptionModalClose(){
    this.prescriptionTxt = "";
    this.repeat = false;
    this.expDate = null;
    this.prescriptionModal.hide();
  }

  // get medicine to quick selector
  getMedicine(){
    var _doc: Doctor =  this.cookiService.getObject('doc');
    console.log(_doc.id);
    this.doctorService.getMedicine(_doc.id).subscribe( res => {
      this.medicine = res;
    })
  }

  // use to add medicine from quick selector to prescription
  printSelect(){
    console.log(this._medicineItem);
    this.prescriptionTxt =  this.prescriptionTxt + this._medicineItem.name + "\t" 
                            + this._medicineItem.mesureValue + this._medicineItem.mesure + "\t" 
                            +this._medicineItem.duretionValue +" "+ this._medicineItem.duretion +"\n"
  }


}

