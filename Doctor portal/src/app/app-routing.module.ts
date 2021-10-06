import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AppComponent } from './app.component';
import { ProfileComponent } from './Views/patient/profile/profile.component';
import { HomeComponent } from './Views/home/home.component';
import { AuthGuard } from './guards/auth.guard';
import { LoginComponent } from './Views/login/login.component';
import { P404Component } from './Views/error/404.component';
import { P500Component } from './Views/error/500.component';
import { DocProfileComponent } from './Views/doc-profile/doc-profile.component';
import { DocPrescriptionsComponent } from './Views/doc-prescriptions/doc-prescriptions.component';
import { from } from 'rxjs';

const routes: Routes = [
  {
    path: '',
    component: HomeComponent
  },
  {
    path: 'home',
    component: HomeComponent
  },
  {
    path: '404',
    component: P404Component,
    data: {
      title: 'Page 404'
    }
  },
  {
    path: '500',
    component: P500Component,
    data: {
      title: 'Page 500'
    }
  },
  {
    path: 'account',
    component: LoginComponent
  },
  {
    path: 'profile',
    canActivate: [AuthGuard],
    component: DocProfileComponent
  },
  {
    path: 'myPrescription',
    canActivate: [AuthGuard],
    component: DocPrescriptionsComponent
  },
  {
    path: 'user',
    canActivate: [AuthGuard],
    loadChildren: () => import('./Views/patient/patient.module').then(m => m.PatientModule)
  },
  {
    path: '**',
    redirectTo: '/404'
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
