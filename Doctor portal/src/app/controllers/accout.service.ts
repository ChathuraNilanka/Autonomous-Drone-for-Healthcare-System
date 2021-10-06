import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { AngularFireAuth } from '@angular/fire/auth';
import * as firebase from 'firebase/app';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

import { CookieService } from 'angular2-cookie/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Doctor } from '../models/doctor.model';

// this service is responsible for all the doctor acc related functions
@Injectable()
export class AccountService {

    user: Observable<firebase.User>;
    private userDetails: firebase.User = null;
    doctorCollection: Observable<any[]>;

    constructor(
        private firebaseAuth: AngularFireAuth,
        private route: ActivatedRoute,
        private afs: AngularFirestore,
        private cookieService: CookieService,
        private router: Router,
    ) {
        // firebase auth to cheack auth status
        this.user = firebaseAuth.authState;
        this.user.subscribe(user => {
            if (user) {
                this.userDetails = user;
            } else {
                this.userDetails = null;
            }
        });
    }

    //method to chack login status 
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

    // sign in using firebaseAuth
    signIn(email, password) {
        return this.firebaseAuth.auth.signInWithEmailAndPassword(email, password);
    }

    // firebaseAuth signOut
    async signOut() {
        try {
            this.cookieService.removeAll();
            return await this.firebaseAuth.auth.signOut();
        } catch (err) {
            throw err;
        }
    }

    setDoctorCookie(uid) {
        var doc: Doctor;
        firebase.firestore().collection('doctor').where('uid', '==', uid).get().then((res) => {
            doc = res.docs[0].data();
            doc.id = res.docs[0].id;
            console.log(doc);
            this.cookieService.putObject('doc', doc);
        })
    }

    UpdatePassword(email, cpass, npass) {
        this.signIn(email, cpass).then(res => {
            this.firebaseAuth.auth.currentUser.updatePassword(npass).then(res => {
                this.signOut();
                this.navtoLogin();
            });

        })

    }

    // this use to nav to Auth page in case Auth status are false
    navtoLogin() {
        this.router.navigate(['account']);
    }
}
