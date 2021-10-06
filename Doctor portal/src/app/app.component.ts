import { Component, ElementRef, Renderer2, HostListener } from '@angular/core';
import { AccountService } from './controllers/accout.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})

export class AppComponent {
  title = 'DoctorPortal';
  navbarOpt: boolean = false;
  state = false;

  constructor(private btn: ElementRef, 
              private renderer: Renderer2, 
              private accountService: AccountService,
              private router: Router){
    this.accountService.isLoggedIn().subscribe(status => {
      this.navbarOpt = status;
    })

  }

  signOut(){
    this.accountService.signOut();
  }

  navtoLogin(){
    this.router.navigate(['account']);
  }
}

