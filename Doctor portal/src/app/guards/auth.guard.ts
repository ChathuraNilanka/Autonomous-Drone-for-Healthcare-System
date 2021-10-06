import { Injectable } from '@angular/core';
import { Router, CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { AngularFireAuth } from '@angular/fire/auth';
import { CookieService, CookieOptions } from 'angular2-cookie/core';
import { map } from 'rxjs/operators';
import { Doctor } from '../models/doctor.model';

// use to gard the routes fron un Auth access
@Injectable()
export class AuthGuard implements CanActivate {

  docObj: Doctor = null;

  constructor(private router: Router,
    private afAuth: AngularFireAuth,
    private cookiService: CookieService) { }

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    this.docObj = this.cookiService.getObject('doc');
    if (typeof (this.docObj) === undefined) {
      console.log(this.docObj);
      this.router.navigate(['/account/']);
      return false;
    }

    return this.afAuth.authState.pipe(
      map(user => {
        if (typeof (this.docObj) === undefined) {
          this.router.navigate(['/account/']);
          return false;
        } else {
          if (user !== null) {
            if (typeof (this.docObj) === undefined) {
              console.log(this.docObj);
              this.router.navigate(['/account/']);
              return false;
            }
            return true;
          } else {
            this.router.navigate(['/account/']);
            return false;
          }
        }
      },
        error => {
          this.router.navigate(['/account/']);
          return false;
        }));
  }

}
