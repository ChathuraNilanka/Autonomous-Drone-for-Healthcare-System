import { Component, OnInit } from '@angular/core';
import { Prescription } from 'src/app/models/prescription.model';
import { PrescriptionService } from 'src/app/controllers/prescription.service';
import { Doctor } from 'src/app/models/doctor.model';
import { CookieService, CookieOptions } from 'angular2-cookie/core';

@Component({
  selector: 'app-doc-prescriptions',
  templateUrl: './doc-prescriptions.component.html',
  styleUrls: ['./doc-prescriptions.component.scss']
})
export class DocPrescriptionsComponent implements OnInit {

  prescriptions: Prescription[] = [];
  docObj: Doctor;
  cols: { field: string; header: string; }[];

  constructor( private prescriptionService: PrescriptionService,
               private cookiService: CookieService ) { }

  ngOnInit(): void {
    this.cols = [
      { field: 'Patient Name', header: 'Doctor Name' },
      { field: 'createdAt', header: 'Date' },
      { field: 'prescription', header: 'Prescription' }
    ];
    
    
    this.docObj = this.cookiService.getObject('doc') || null;

    this.getPrescriptions(this.docObj.id);

    console.log(this.prescriptions);
  }

  getPrescriptions(DocId: string){
    this.prescriptionService.getDocMyPrescriptions(DocId).subscribe( res => {
      res.forEach( item => {
        var prescrition: Prescription={};
  
        prescrition = item.data();
        prescrition.id = item.id;
        this.prescriptions.push(prescrition);
      })
    });
  }

}
