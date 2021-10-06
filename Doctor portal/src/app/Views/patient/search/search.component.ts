import { Component, OnInit, ViewChild } from '@angular/core';
import { ViewEncapsulation } from '@angular/core';
import { PatientService } from '../../../controllers/patient.service';
import { Patient } from '../../../models/patients.model';
import { LazyLoadEvent } from 'primeng';
import { CookieService, CookieOptions } from 'angular2-cookie/core';
import { Doctor } from 'src/app/models/doctor.model';
import { Router } from '@angular/router';
import { ModalContainerComponent } from 'angular-bootstrap-md';
import { MessageService } from 'primeng/api';

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.scss'],
  encapsulation: ViewEncapsulation.None,
  providers: [MessageService]
})
export class SearchComponent implements OnInit {

  @ViewChild('basicModal', { static: true }) basicModal: ModalContainerComponent; //add patient model

  patients: Patient[] = [];
  nic: string = "";
  cols: any[];
  loading: boolean;
  docId: string;
  doctorObj: Doctor = null;
  addErr: boolean;
  emptyErr: boolean;

  constructor(private patientService: PatientService,
    private cookiService: CookieService,
    private router: Router,
    private messageService: MessageService) {
    this.cols = [
      { field: 'name', header: 'Name' },
      { field: 'mobileNumber', header: 'Tel:' },
      { field: 'email', header: 'Email' },
      { field: 'nic', header: 'NIC' },
    ];
  }

  ngOnInit(): void {

    this.doctorObj = this.cookiService.getObject('doc');
    if (!this.doctorObj) {
      this.router.navigate(['/account/']);
    } else {
      this.patientService.getPatients(this.doctorObj.id).subscribe(data => {
        this.patients = [];
        data.forEach(x => {
          var patient: Patient = x;
          this.patients = [...this.patients, patient];
        });
      });
    }
    this.loading = true;
  }

  addPatient() {
    this.addErr = false;
    this.emptyErr = false;
    if (this.nic) {
      this.patientService.sendRequest(this.nic, this.doctorObj.id).then(
        res => {
          console.log(res);
          if (res == false) {
            this.addErr = true;
          } else{
            this.messageService.add({ severity: 'success', summary: 'Request Sent', detail: 'Your request has been sent to the patient' });
            this.basicModal.hide();
          }
        }
      )
    } else {
      this.emptyErr = true;
    }
  }

  // use to nav to petints profile
  navProfile(event) {
    if( event.data['status'] == 'accepted'){
      this.router.navigate(['user/profile', event.data['pid']]);
    }else{
      
      this.messageService.add({ severity: 'error', summary: 'Request Did not Accepted', detail: 'Ask your patient to Accept the Request' });
            
    }
  }

  loadLazy(event: LazyLoadEvent) {
    this.loading = true;
    setTimeout(() => {
      if (this.patients) {
        this.patients = this.patients.slice(event.first, (event.first + event.rows));
        this.loading = false;
      }
    }, 1000);
  }


}
