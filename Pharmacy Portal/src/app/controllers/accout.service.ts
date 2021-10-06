import { Injectable } from '@angular/core';
import { AngularFireAuth } from '@angular/fire/auth';
import * as firebase from 'firebase/app';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

import { CookieService } from 'angular2-cookie/core';
import { Router } from '@angular/router';
import { Doctor } from '../models/doctor.model';


// this service maintain methods to handle login proccers.
@Injectable()
export class AccountService {

    user: Observable<firebase.User>;
    private userDetails: firebase.User = null;
    doctorCollection: Observable<any[]>;

    constructor(
        private firebaseAuth: AngularFireAuth,
        private cookieService: CookieService,
        private router: Router,
    ) {

        this.user = firebaseAuth.authState;
        this.user.subscribe(user => {
            if (user) {
                this.userDetails = user;
            } else {
                this.userDetails = null;
            }
        });
    }

    // Validate users Auth
    isLoggedIn(): Observable<boolean> {
        return this.firebaseAuth.authState.pipe(
            map(user => {
                if (user !== null) {
                    return true;
                }
                return false;
            },
                error => {
                    return false;
                }));
    }

    // firbase auth sign in
    signIn(email, password) {
        return this.firebaseAuth.auth.signInWithEmailAndPassword(email, password);
    }

    // firebase Auth sign out
    async signOut() {
        try {
            this.cookieService.removeAll();
            return await this.firebaseAuth.auth.signOut();
        } catch (err) {
            throw err;
        }
    }

    // set user cookie to Easy use
    setDoctorCookie(uid) {
        var doc: Doctor;
        firebase.firestore().collection('doctor').where('uid', '==', uid).get().then((res) => {
            doc = res.docs[0].data();
            doc.id = res.docs[0].id;
            console.log(doc);
            this.cookieService.putObject('doc', doc);
        })
    }

    // nav to login after sign out
    navtoLogin() {
        this.router.navigate(['account']);
    }
}
