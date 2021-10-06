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
import { BusyIndicatorService } from './Views/core/busy-indicator/busy-indicator.service';



import { AuthGuard } from './guards/auth.guard';

import { LoginComponent } from './Views/login/login.component';
import { HomeComponent } from './Views/home/home.component';


import { CookieService } from 'angular2-cookie/services/cookies.service';

import { ShowHidePasswordModule } from 'ngx-show-hide-password';

import { TableModule } from 'primeng/table';
import { OrdersComponent } from './Views/orders/orders/orders.component';
import { OrderService } from './controllers/orders.service';
import { AgmCoreModule } from '@agm/core';
import { OrdersDetailsComponent } from './Views/orders/orders-details/orders-details.component';
import { OrdersMonitorComponent } from './Views/orders/orders-monitor/orders-monitor.component';
import { ETAService } from './controllers/ETA.service';
import { DroneService } from './controllers/drone.service';
import { WeatherService } from './controllers/weather.service';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    HomeComponent,
    OrdersComponent,
    OrdersDetailsComponent,
    OrdersMonitorComponent
  ],
  imports: [
    BrowserModule,
    TableModule,
    BrowserAnimationsModule,
    FormsModule,
    AgmCoreModule.forRoot({
      apiKey: 'AIzaSyBAMBxfRBZO3BZu1GMUEEEDkQnTH7DAAgs'
    }),
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
    AuthGuard,
    CookieService,
    BusyIndicatorService,
    OrderService,
    ETAService,
    DroneService,
    WeatherService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
