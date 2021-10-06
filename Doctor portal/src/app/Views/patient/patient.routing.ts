import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ProfileComponent } from './profile/profile.component';
import { SearchComponent } from './search/search.component';

const routes: Routes = [
  {
    path: 'search',
    component: SearchComponent,
    data: {
      title: 'patients'
    }
  }, {
    path: 'profile/:pid',
    component: ProfileComponent,
    data: {
      title: 'Patients profile'
    }
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PetientsRoutingModule { }