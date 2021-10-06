import { ORC } from '../models/constents.model';
import { from, Observable } from 'rxjs';
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';

// this service was used to manage character recognition using OCR API
@Injectable()
export class OCRService{

    api_key = ORC.API_Key;
    uri = ORC.URI_img;
    
    constructor( private httpClient: HttpClient){

    }

    getText(uploadfile): Observable<any>{

        const formData = new FormData();
        formData.append('file', uploadfile);
        const headers = new HttpHeaders({
              'apikey':  this.api_key,
              'Content-Type': 'multipart/form-data'
            });
        console.log(uploadfile);
        return this.httpClient.post( this.uri, formData, { headers: headers});
    }

    test(){

    }


}