import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AppComponent } from './app.component';
import { HomeComponent } from './Views/home/home.component';
import { AuthGuard } from './guards/auth.guard';
import { LoginComponent } from './Views/login/login.component';
import { P404Component } from './Views/error/404.component';
import { P500Component } from './Views/error/500.component';
import { from } from 'rxjs';
import { OrdersComponent } from './Views/orders/orders/orders.component';
import { OrdersMonitorComponent } from './Views/orders/orders-monitor/orders-monitor.component';
import { OrdersDetailsComponent } from './Views/orders/orders-details/orders-details.component';

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
    path: 'orders',
    component: OrdersComponent
  },
  {
    path: 'orders/:id/:pid',
    component: OrdersDetailsComponent,
  },
  {
    path: 'orders/:id/:pid/monitor/:lat/:lon/:alt',
    component: OrdersMonitorComponent
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
