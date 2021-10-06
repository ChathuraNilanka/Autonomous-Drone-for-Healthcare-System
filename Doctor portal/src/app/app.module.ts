import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { environment } from '../environments/environment';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { MDBBootstrapModule } from 'angular-bootstrap-md';

import { AngularFireModule } from '@angular/fire';
import { AngularFirestoreModule } from '@angular/fire/firestore';
import { AngularFireStorageModule } from '@angular/fire/storage';
import { AngularFireAuthModule } from '@angular/fire/auth';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

import { AccountService } from './controllers/accout.service';
import { PatientService } from './controllers/patient.service';
import { OCRService } from './controllers/ocr.service';
import { DoctorSevice } from './controllers/doctor.service';
import { PrescriptionService } from './controllers/prescription.service';
import { ImgService } from './controllers/image.service';
import { BusyIndicatorService } from './Views/core/busy-indicator/busy-indicator.service';


import { AuthGuard } from './guards/auth.guard';

import { LoginComponent } from './Views/login/login.component';
import { HomeComponent } from './Views/home/home.component';


import { CookieService } from 'angular2-cookie/services/cookies.service';
import { from } from 'rxjs';
import { DocProfileComponent } from './Views/doc-profile/doc-profile.component';

import { ShowHidePasswordModule } from 'ngx-show-hide-password';
import { NO_ERRORS_SCHEMA } from '@angular/compiler';
import { DocPrescriptionsComponent } from './Views/doc-prescriptions/doc-prescriptions.component';

import { TableModule } from 'primeng/table';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    DocProfileComponent,
    HomeComponent,
    DocPrescriptionsComponent
  ],
  imports: [
    BrowserModule,
    TableModule,
    BrowserAnimationsModule,
    FormsModule,
    ShowHidePasswordModule,
    HttpClientModule,
    AppRoutingModule,
    MDBBootstrapModule.forRoot(),
    AngularFireModule.initializeApp(environment.firebaseConfig),
    AngularFirestoreModule.enablePersistence(),
    AngularFireAuthModule,
    AngularFireStorageModule,
  ],
  providers: [AccountService,
    PatientService,
    AuthGuard,
    ImgService,
    CookieService,
    OCRService,
    DoctorSevice,
    PrescriptionService,
    BusyIndicatorService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
