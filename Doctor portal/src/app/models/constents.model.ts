import { environment } from 'src/environments/environment';

export class AuthenticationKeys {
    static AccessDetailsToken = 'AccessDetailsToken';
    static AccessControlSettings = 'accessControlSettings';
    static CookieExpirationInDays = 14;
}

export class Constants {
    static UserDetailCookieName = 'User';
}

export class ORC{
    static API_Key = 'ee6515c23188957';
    static URI_img = environment.OCR;
}