

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';

@Injectable()
export class WeatherService{
   
    uri = environment.weatherUri;
    appid = environment.weatherapp;

    constructor( private httpClient: HttpClient){

    }

    // use to get weather details from the openWeather
    getWeatherDetails(lat, long){
        console.log(this.uri+"?lat="+lat+"&lon="+long+"&appid="+this.appid)
        return this.httpClient.get(this.uri+"?lat="+lat+"&lon="+long+"&appid="+this.appid);
    }


}