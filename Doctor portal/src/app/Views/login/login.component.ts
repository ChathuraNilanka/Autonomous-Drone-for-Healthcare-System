import { Component, OnInit } from '@angular/core';
import { AccountService } from '../../controllers/accout.service';
import { LogInModel } from 'src/app/models/account.model';
import { Router } from '@angular/router';
import { CookieService } from 'ngx-cookie-service';
import { BusyIndicatorService } from '../core/busy-indicator/busy-indicator.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

  loginModel: LogInModel = {};
  loginErr: boolean = false;

  constructor(private accountService: AccountService,
    private router: Router,
    private cookie: CookieService,
    private busyIndicatorService: BusyIndicatorService) { }

  ngOnInit(): void {
  }

  signIn() {
    this.loginErr = false;
    const operetion = this.busyIndicatorService.startOperation();
    this.accountService.signIn(this.loginModel.username, this.loginModel.password)
      .then(user => {
          this.accountService.setDoctorCookie(user.user.uid);
          this.busyIndicatorService.endOperation(operetion);
          this.router.navigate(['home']);
      }
      ).catch( err => {
        this.loginErr = true;
        console.log("naa broh!!");
      });
  }

  signOut() {
    this.cookie.deleteAll();
    this.accountService.signOut();
  }

}
