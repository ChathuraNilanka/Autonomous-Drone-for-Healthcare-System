import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProfileComponent } from './profile/profile.component';
import { SearchComponent } from './search/search.component';
import { PetientsRoutingModule } from './patient.routing';
import { MDBBootstrapModule } from 'angular-bootstrap-md';
import { TableModule } from 'primeng/table';
import { CalendarModule } from 'primeng/calendar';
import { FormsModule } from '@angular/forms';
import { FileUploadModule } from 'primeng/fileupload';
import { ToastModule } from 'primeng/toast';


@NgModule({
  declarations: [ProfileComponent, SearchComponent],
  imports: [
    CommonModule,
    ToastModule,
    CalendarModule,
    PetientsRoutingModule,
    MDBBootstrapModule,
    TableModule,
    FileUploadModule,
    FormsModule
  ]
})
export class PatientModule { }
