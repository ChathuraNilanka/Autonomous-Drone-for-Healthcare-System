import { Component, OnInit, ViewChild } from '@angular/core';
import { Doctor } from 'src/app/models/doctor.model';
import { CookieService, CookieOptions } from 'angular2-cookie/core';
import { AccountService } from '../../controllers/accout.service';
import { ModalContainerComponent } from 'angular-bootstrap-md';
import { DoctorSevice } from 'src/app/controllers/doctor.service';
import { MedicineItem } from 'src/app/models/medicine.model';

@Component({
  selector: 'app-doc-profile',
  templateUrl: './doc-profile.component.html',
  styleUrls: ['./doc-profile.component.scss']
})



export class DocProfileComponent implements OnInit {

  @ViewChild('passwordModal', { static: true }) passwordModal: ModalContainerComponent;
  @ViewChild('editModal', { static: true }) editModal: ModalContainerComponent;  
  @ViewChild('addMedModel', { static: true }) addMedModel: ModalContainerComponent;

  

  cols: any[];
  docObj: Doctor;
  editObj: Doctor;
  cpass: string = null;
  npass: string = null;
  matchError =  false;
  rpass: string = null;
  timeTable: any;
  medItem: MedicineItem = {};

  constructor( private cookiService: CookieService,
               private accountService: AccountService,
               private docService: DoctorSevice ) { }

  ngOnInit(): void {
    this.docObj = this.cookiService.getObject('doc') || null;
    this.editObj = this.cookiService.getObject('doc') || null;

    this.cols = [
      { field: 'date', header: 'Date' },
      { field: 'venue', header: 'Venue' },
      { field: 'time', header: 'Time' }
    ];

    this.docService.getTimeTable(this.docObj.id).subscribe( res => {
      this.timeTable = res;
    });
  }

  changepassword(){
    if( this.cpass && this.rpass == this.npass){
      this.matchError = false;
      this.passwordModal.hide();
      this.accountService.UpdatePassword(this.docObj.email, this.cpass, this.npass);
    }
    else{
      this.matchError= true;
      console.log("error")
    }
    
  }

  updateInfo(){
    this.docService.updatedoctor(this.editObj);
    this.docObj = this.editObj;
    this.editModal.hide();
  }

  addMedicine(){
    this.docService.addMedicine(this.docObj.id, this.medItem);
    this.addMedModel.hide();
  }
}
