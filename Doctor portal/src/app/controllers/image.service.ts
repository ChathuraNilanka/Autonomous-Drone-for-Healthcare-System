
import { Injectable } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/storage'

// this service use to get profile pics of docs and patients
@Injectable()
export class ImgService {
    imgSrc: any;


    constructor(private st: AngularFireStorage
    ) {

    }

    // use to get the users pofile pics
    getImg() {
        const ref = this.st.ref("/p_pro_pics/user_4.png");
        this.imgSrc = ref.getDownloadURL().subscribe(res =>
            console.log(res)
        );
        return this.imgSrc;
    }



}